-- routER – Seed data for local development / demo.
-- Run AFTER init.sql.

-- ============================================================
-- Contracts
-- ============================================================

INSERT INTO contracts (contract_id, agency_name, price_per_ambulance, start_date, end_date, max_users, current_num_users, generated_keys, main_contact_user_id)
VALUES (
  'c0000000-0000-0000-0000-000000000001',
  'Atlanta EMS Agency',
  150,
  '2025-01-01',
  '2025-12-31',
  12,
  3,
  '[
    {"key":"DEMO-KEY-2025","user_type":"driver","is_used":false,"created_at":"2026-03-23T12:00:00Z"},
    {"key":"MGR-KEY-001","user_type":"manager","is_used":true,"created_at":"2026-03-23T12:05:00Z"},
    {"key":"HOSP-KEY-001","user_type":"hospital","is_used":true,"created_at":"2026-03-23T12:10:00Z"}
  ]'::jsonb,
  NULL  -- will be updated after users are inserted
);

-- ============================================================
-- Users
-- ============================================================

INSERT INTO users (user_id, name, email, user_type, generated_key, contract_id) VALUES
  ('u0000000-0000-0000-0000-000000000001', 'Admin User',   'admin@emsdemo.com',   'admin',    NULL,           NULL),
  ('u0000000-0000-0000-0000-000000000002', 'EMS Manager',  'manager@emsdemo.com', 'manager',  'MGR-KEY-001',  'c0000000-0000-0000-0000-000000000001'),
  ('u0000000-0000-0000-0000-000000000003', 'EMS Driver',   'driver@emsdemo.com',  'driver',   NULL,           'c0000000-0000-0000-0000-000000000001'),
  ('u0000000-0000-0000-0000-000000000004', 'Grady Staff',  'grady@hospital.com',  'hospital', 'HOSP-KEY-001', NULL);

UPDATE contracts
SET main_contact_user_id = 'u0000000-0000-0000-0000-000000000002'
WHERE contract_id = 'c0000000-0000-0000-0000-000000000001';

-- ============================================================
-- Hospitals (Atlanta metro area)
-- ============================================================

INSERT INTO hospitals (hospital_id, hospital_name, location, er_wall_time_minutes, phone_number, address) VALUES
  ('h0000000-0000-0000-0000-000000000001', 'Grady Memorial Hospital',       ST_MakePoint(-84.3923, 33.7555)::geography, 22, '(404) 616-1000', '80 Jesse Hill Jr Dr SE, Atlanta, GA 30303'),
  ('h0000000-0000-0000-0000-000000000002', 'Emory University Hospital',     ST_MakePoint(-84.3234, 33.7915)::geography, 35, '(404) 712-2000', '1364 Clifton Rd NE, Atlanta, GA 30322'),
  ('h0000000-0000-0000-0000-000000000003', 'Northside Hospital Atlanta',    ST_MakePoint(-84.3526, 33.9334)::geography, 18, '(404) 851-8000', '1000 Johnson Ferry Rd, Atlanta, GA 30342'),
  ('h0000000-0000-0000-0000-000000000004', 'Piedmont Atlanta Hospital',     ST_MakePoint(-84.3812, 33.8121)::geography, 28, '(404) 605-5000', '1968 Peachtree Rd NW, Atlanta, GA 30309'),
  ('h0000000-0000-0000-0000-000000000005', 'WellStar Atlanta Medical Ctr',  ST_MakePoint(-84.3875, 33.7489)::geography, 45, '(470) 245-9998', '303 Parkway Dr NE, Atlanta, GA 30312');

-- Link hospital user
UPDATE users SET hospital_id = 'h0000000-0000-0000-0000-000000000001'
WHERE user_id = 'u0000000-0000-0000-0000-000000000004';

-- ============================================================
-- Hospital specialties (sample)
-- ============================================================

INSERT INTO hospital_specialties (hospital_id, specialty_key, specialty_level, diversion_status) VALUES
  -- Grady: level-1 trauma center, full specialty suite
  ('h0000000-0000-0000-0000-000000000001', 'trauma',    'T-I',  'open'),
  ('h0000000-0000-0000-0000-000000000001', 'burn',       NULL,   'open'),
  ('h0000000-0000-0000-0000-000000000001', 'stemi',     'C-I',  'open'),
  ('h0000000-0000-0000-0000-000000000001', 'stroke',    'CSC',  'open'),
  ('h0000000-0000-0000-0000-000000000001', 'pediatric', 'P-I',  'open'),
  ('h0000000-0000-0000-0000-000000000001', 'obgyn',     'M-II', 'open'),
  ('h0000000-0000-0000-0000-000000000001', 'neonatal',  'Neo-II','open'),

  -- Emory
  ('h0000000-0000-0000-0000-000000000002', 'trauma',    'T-II', 'open'),
  ('h0000000-0000-0000-0000-000000000002', 'stemi',     'C-I',  'divert'),
  ('h0000000-0000-0000-0000-000000000002', 'stroke',    'CSC',  'open'),
  ('h0000000-0000-0000-0000-000000000002', 'pediatric', 'P-II', 'open'),

  -- Northside
  ('h0000000-0000-0000-0000-000000000003', 'obgyn',     'M-I',  'open'),
  ('h0000000-0000-0000-0000-000000000003', 'neonatal',  'Neo-I','open'),
  ('h0000000-0000-0000-0000-000000000003', 'pediatric', 'P-I',  'open'),

  -- Piedmont
  ('h0000000-0000-0000-0000-000000000004', 'trauma',    'T-III','open'),
  ('h0000000-0000-0000-0000-000000000004', 'stemi',     'C-II', 'open'),
  ('h0000000-0000-0000-0000-000000000004', 'stroke',    'PSC',  'closed'),

  -- WellStar
  ('h0000000-0000-0000-0000-000000000005', 'trauma',    'T-II', 'divert'),
  ('h0000000-0000-0000-0000-000000000005', 'burn',       NULL,   'open'),
  ('h0000000-0000-0000-0000-000000000005', 'stemi',     'C-II', 'open');

-- ============================================================
-- Ambulances
-- ============================================================

INSERT INTO ambulances (ambulance_id, contract_id, vehicle_number, status) VALUES
  ('a0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000001', 'ATL-101', 'available'),
  ('a0000000-0000-0000-0000-000000000002', 'c0000000-0000-0000-0000-000000000001', 'ATL-102', 'available');
