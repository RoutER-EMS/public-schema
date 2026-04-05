-- routER – one-off migration for existing databases (run once).
-- Apply after deploying API changes that expect this schema.
-- Safe to re-run only where noted with IF EXISTS / IF NOT EXISTS patterns.

BEGIN;

-- 1) Shifts → ambulance
ALTER TABLE shifts ADD COLUMN IF NOT EXISTS ambulance_id UUID REFERENCES ambulances(ambulance_id);

-- 2) Routes → navigation target
ALTER TABLE routes ADD COLUMN IF NOT EXISTS navigating_to_hospital_id UUID REFERENCES hospitals(hospital_id);

CREATE INDEX IF NOT EXISTS idx_routes_navigating_hospital ON routes (navigating_to_hospital_id);
CREATE INDEX IF NOT EXISTS idx_shifts_ambulance ON shifts (ambulance_id);

-- 3) route_suggestions: keep rows when route deleted (analytics / orphan inference)
ALTER TABLE route_suggestions DROP CONSTRAINT IF EXISTS route_suggestions_route_id_fkey;
ALTER TABLE route_suggestions ALTER COLUMN route_id DROP NOT NULL;
ALTER TABLE route_suggestions
  ADD CONSTRAINT route_suggestions_route_id_fkey
  FOREIGN KEY (route_id) REFERENCES routes(route_id) ON DELETE SET NULL;

-- 4) Remove hospital_load_balance
DROP TABLE IF EXISTS hospital_load_balance;

-- 5) Hospitals: counts are computed from routes in the API
ALTER TABLE hospitals DROP COLUMN IF EXISTS en_route_num;
ALTER TABLE hospitals DROP COLUMN IF EXISTS at_hospital_num;

-- 6) movement_status enum only served hospital_load_balance
DROP TYPE IF EXISTS movement_status;

COMMIT;
