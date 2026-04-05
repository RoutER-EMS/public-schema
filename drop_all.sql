-- routER – tear down all application tables and enum types in public schema.
-- Run against the same database as init.sql (e.g. router or routerDB).
-- PostGIS / uuid-ossp extensions are left in place (init.sql uses IF NOT EXISTS).
--
-- Typical reset:
--   psql ... -v ON_ERROR_STOP=1 -f drop_all.sql
--   psql ... -v ON_ERROR_STOP=1 -f init.sql
--   psql ... -v ON_ERROR_STOP=1 -f seed.sql

BEGIN;

-- Dependency order: children before parents (contracts ↔ users is resolved by dropping contracts before users).

DROP TABLE IF EXISTS route_suggestions CASCADE;
DROP TABLE IF EXISTS ambulance_telemetry CASCADE;
DROP TABLE IF EXISTS routes CASCADE;
DROP TABLE IF EXISTS shifts CASCADE;
DROP TABLE IF EXISTS ambulances CASCADE;
DROP TABLE IF EXISTS hospital_specialties CASCADE;
DROP TABLE IF EXISTS contracts CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS hospitals CASCADE;

-- Must run after tables that use these types.
DROP TYPE IF EXISTS hospital_specialty_type CASCADE;
DROP TYPE IF EXISTS agency_vote CASCADE;
DROP TYPE IF EXISTS diversion_status CASCADE;
DROP TYPE IF EXISTS user_type CASCADE;

COMMIT;
