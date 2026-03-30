-- routER – MVP schema
-- Requires PostgreSQL 14+ with PostGIS and uuid-ossp extensions.

CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================
-- ENUMS
-- ============================================================

CREATE TYPE user_type AS ENUM ('admin', 'manager', 'driver', 'hospital');

CREATE TYPE diversion_status AS ENUM ('open', 'divert', 'closed');

CREATE TYPE movement_status AS ENUM ('En route', 'At hospital', 'Patient dropped off');

CREATE TYPE agency_vote AS ENUM ('agree', 'disagree', 'pending');

-- burn is present in the mobile app's SPECIALTIES list but was absent from the
-- original schema draft. Added here so the backend matches the frontend enum.
CREATE TYPE hospital_specialty_type AS ENUM (
  'trauma', 'burn', 'stemi', 'stroke', 'pediatric', 'obgyn', 'neonatal'
);

-- Specialty level codes are stored as TEXT in hospital_specialties.specialty_level.
-- Valid values by specialty (enforced in application code):
--   trauma    → T-I, T-II, T-III, T-IV
--   stemi     → C-I, C-II, C-III
--   stroke    → CSC, TCSC, PPSC, PSC, ASRC, RTSC
--   pediatric → P-I, P-II, P-III
--   obgyn     → M-I, M-II, M-III, M-IV
--   neonatal  → Neo-I, Neo-II, Neo-III, Neo-IV
--   burn      → (no designated levels; column is NULL)

-- ============================================================
-- TABLES
-- ============================================================

CREATE TABLE contracts (
  contract_id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  agency_name          VARCHAR(255),
  price_per_ambulance  NUMERIC,
  start_date           TIMESTAMP,
  end_date             TIMESTAMP,
  max_users            INTEGER,
  current_num_users    INTEGER DEFAULT 0,
  generated_keys       JSONB DEFAULT '[]'::jsonb,
  main_contact_user_id UUID,            -- FK added after users table
  created_at           TIMESTAMP DEFAULT now()
);

CREATE TABLE users (
  user_id      UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  cognito_sub  VARCHAR(255) UNIQUE,     -- links to Cognito identity
  name         VARCHAR(255),
  email        VARCHAR(255) UNIQUE,
  user_type    user_type,
  generated_key VARCHAR(50),
  contract_id  UUID REFERENCES contracts(contract_id),
  hospital_id  UUID,                    -- FK added after hospitals table
  created_at   TIMESTAMP DEFAULT now()
);

ALTER TABLE contracts
  ADD CONSTRAINT fk_contracts_main_contact
  FOREIGN KEY (main_contact_user_id) REFERENCES users(user_id);

CREATE TABLE hospitals (
  hospital_id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  hospital_name        VARCHAR(255) NOT NULL,
  location             GEOGRAPHY(Point, 4326),
  er_wall_time_minutes INTEGER DEFAULT 0,
  phone_number         VARCHAR(30),
  address              TEXT,
  en_route_num         INTEGER DEFAULT 0,
  at_hospital_num      INTEGER DEFAULT 0
);

ALTER TABLE users
  ADD CONSTRAINT fk_users_hospital
  FOREIGN KEY (hospital_id) REFERENCES hospitals(hospital_id);

CREATE TABLE hospital_specialties (
  hospital_id      UUID NOT NULL REFERENCES hospitals(hospital_id) ON DELETE CASCADE,
  specialty_key    hospital_specialty_type NOT NULL,
  specialty_level  TEXT,
  diversion_status diversion_status DEFAULT 'open',
  update_time      TIMESTAMP,
  num_approved     INTEGER DEFAULT 0,
  num_disagree     INTEGER DEFAULT 0,
  responders       UUID[] DEFAULT '{}',
  PRIMARY KEY (hospital_id, specialty_key)
);

CREATE TABLE hospital_load_balance (
  user_id         UUID PRIMARY KEY REFERENCES users(user_id),
  hospital_id     UUID REFERENCES hospitals(hospital_id),
  movement_status movement_status,
  arrival_time    TIMESTAMP
);

CREATE TABLE ambulances (
  ambulance_id     UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  contract_id      UUID REFERENCES contracts(contract_id),
  vehicle_number   VARCHAR(50),
  status           TEXT DEFAULT 'available',
  current_location GEOGRAPHY(Point, 4326),
  last_update      TIMESTAMP DEFAULT now(),
  created_at       TIMESTAMP DEFAULT now()
);

CREATE TABLE shifts (
  shift_id   UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id    UUID REFERENCES users(user_id),
  start_time TIMESTAMP,
  end_time   TIMESTAMP
);

CREATE TABLE routes (
  route_id                UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  shift_id                UUID REFERENCES shifts(shift_id),
  ambulance_id            UUID REFERENCES ambulances(ambulance_id),
  hospital_specialty      hospital_specialty_type,
  navigation_history      JSONB DEFAULT '[]'::jsonb,
  start_location          GEOGRAPHY(Point, 4326),
  arrival_hospital_id     UUID REFERENCES hospitals(hospital_id),
  start_travel_time       TIMESTAMP,
  end_travel_time         TIMESTAMP,
  dropped_off_patient_time TIMESTAMP,
  decision_time_seconds   INTEGER,
  created_at              TIMESTAMP DEFAULT now()
);

CREATE TABLE route_suggestions (
  suggestion_id              BIGSERIAL PRIMARY KEY,
  route_id                   UUID REFERENCES routes(route_id) ON DELETE CASCADE,
  hospital_id                UUID REFERENCES hospitals(hospital_id),
  suggestion_rank            INTEGER,
  estimated_travel_minutes   INTEGER,
  hospital_wall_time_minutes INTEGER,
  total_score                NUMERIC,
  created_at                 TIMESTAMP DEFAULT now()
);

CREATE TABLE ambulance_telemetry (
  telemetry_id BIGSERIAL PRIMARY KEY,
  ambulance_id UUID REFERENCES ambulances(ambulance_id),
  location     GEOGRAPHY(Point, 4326),
  recorded_at  TIMESTAMP DEFAULT now()
);

-- ============================================================
-- INDEXES
-- ============================================================

CREATE INDEX idx_users_email         ON users (email);
CREATE INDEX idx_users_cognito_sub   ON users (cognito_sub);
CREATE INDEX idx_users_contract      ON users (contract_id);

CREATE INDEX idx_hospitals_location  ON hospitals USING GIST (location);

CREATE INDEX idx_hospital_spec_hosp  ON hospital_specialties (hospital_id);

CREATE INDEX idx_load_hospital       ON hospital_load_balance (hospital_id);

CREATE INDEX idx_shifts_user         ON shifts (user_id);

CREATE INDEX idx_routes_shift        ON routes (shift_id);

CREATE INDEX idx_suggestions_route   ON route_suggestions (route_id);

CREATE INDEX idx_ambulances_contract ON ambulances (contract_id);

CREATE INDEX idx_telemetry_ambulance ON ambulance_telemetry (ambulance_id);
CREATE INDEX idx_telemetry_time      ON ambulance_telemetry (recorded_at DESC);
