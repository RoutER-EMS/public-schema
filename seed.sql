-- routER – Seed data for local development / demo.
-- Run AFTER init.sql.
-- UUIDs must be valid hex (0-9, a-f) per PostgreSQL uuid type.

BEGIN;

-- ============================================================
-- Contracts
-- ============================================================

INSERT INTO contracts (contract_id, agency_name, price_per_ambulance, start_date, end_date, max_users, current_num_users, generated_keys, main_contact_user_id)
VALUES (
  'c0000000-0000-0000-0000-000000000001',
  'Test Agency',
  150,
  '2025-01-01',
  '2025-12-31',
  12,
  0,
  '[
    {"key":"A9EF3KJLS2D4JFL324KA23DF","user_type":"manager","email":"vhesu3@gatech.edu","is_used":false,"created_at":"2026-03-23T12:00:00Z"}
  ]'::jsonb,
  NULL
)
ON CONFLICT (contract_id) DO UPDATE
SET
  agency_name = EXCLUDED.agency_name,
  price_per_ambulance = EXCLUDED.price_per_ambulance,
  start_date = EXCLUDED.start_date,
  end_date = EXCLUDED.end_date,
  max_users = EXCLUDED.max_users,
  current_num_users = EXCLUDED.current_num_users,
  generated_keys = EXCLUDED.generated_keys,
  main_contact_user_id = EXCLUDED.main_contact_user_id;

-- ============================================================
-- Users
-- ============================================================

INSERT INTO users (user_id, name, email, user_type, generated_key, contract_id) VALUES
  ('e4c8b4d8-6091-7002-c57d-830c6014a3ed', 'Admin User', 'router.ems.gt@gmail.com', 'admin', NULL, NULL)
ON CONFLICT (email) DO UPDATE
SET
  name = EXCLUDED.name,
  user_type = EXCLUDED.user_type,
  generated_key = EXCLUDED.generated_key,
  contract_id = EXCLUDED.contract_id;

-- ============================================================
-- Hospitals (Atlanta metro area)
-- ============================================================

-- Hospitals seeded from the provided dataset.
-- Note: we keep `hospital_id` as UUIDs (per init.sql) but use stable IDs that visually map to 1..24.
INSERT INTO hospitals (
  hospital_id,
  hospital_name,
  location,
  geofence_radius_meters,
  er_wall_time_minutes,
  phone_number,
  address
) VALUES
  ('b0000000-0000-0000-0000-000000000001', 'Arthur M. Blank Children''s Hospital',              ST_MakePoint(-84.31965, 33.793571)::geography, 200, 38, '404-785-6422', '1405 CLIFTON ROAD NE, DRUID HILLS, GA 30322'),
  ('b0000000-0000-0000-0000-000000000002', 'Atlanta VA Medical Center',                         ST_MakePoint(-84.311425, 33.801861)::geography, 200, 50, '(404) 321-6111', '1670 CLAIRMONT ROAD, DECATUR, GA 30033'),
  ('b0000000-0000-0000-0000-000000000003', 'Children''s Healthcare of Atlanta at Scottish Rite',ST_MakePoint(-84.353952, 33.906082)::geography, 200, 27, '404-785-2275', '1001 JOHNSON FERRY RD, ATLANTA, GA 30342'),
  ('b0000000-0000-0000-0000-000000000004', 'Eastside Medical Center - South Campus',            ST_MakePoint(-84.021074, 33.877569)::geography, 200, 26, '(770) 979-0200', '1700 MEDICAL WAY, SNELLVILLE, GA 30078'),
  ('b0000000-0000-0000-0000-000000000005', 'Emory Decatur Hospital',                            ST_MakePoint(-84.28291, 33.791089)::geography, 200, 59, '404-501-3900/1758', '2701 N DECATUR ROAD, DECATUR, GA 30033'),
  ('b0000000-0000-0000-0000-000000000006', 'Emory Hillandale Hospital',                         ST_MakePoint(-84.147983, 33.70522)::geography, 200, 54, '404-501-2341', '2801 DEKALB MEDICAL PARKWAY, LITHONIA, GA 30058'),
  ('b0000000-0000-0000-0000-000000000007', 'Emory Johns Creek Hospital',                        ST_MakePoint(-84.176628, 34.066675)::geography, 200, 43, '678-474-7101/7100', '6325 HOSPITAL PARKWAY, JOHNS CREEK, GA 30097'),
  ('b0000000-0000-0000-0000-000000000008', 'Emory Saint Joseph''s Hospital',                    ST_MakePoint(-84.348984, 33.908758)::geography, 200, 41, '678-843-7164/7166', '5665 PEACHTREE DUNWOODY RD NE, SANDY SPRINGS, GA 30342'),
  ('b0000000-0000-0000-0000-000000000009', 'Emory University Hospital',                         ST_MakePoint(-84.322263, 33.792023)::geography, 200, 79, '404-727-9292/7109', '1364 CLIFTON ROAD NE, DRUID HILLS, GA 30322'),
  ('b0000000-0000-0000-0000-000000000010', 'Emory University Hospital Midtown',                 ST_MakePoint(-84.386732, 33.769175)::geography, 200, 46, '404-686-1050/1051', '550 PEACHTREE ST NE, ATLANTA, GA 30308'),
  ('b0000000-0000-0000-0000-000000000011', 'Grady Memorial Hospital',                           ST_MakePoint(-84.381792, 33.751989)::geography, 200, 55, '404-616-4677', '80 JESSE HILL, JR DRIVE SE, ATLANTA, GA 30303'),
  ('b0000000-0000-0000-0000-000000000012', 'Hughes Spalding Children''s Hospital',              ST_MakePoint(-84.330333, 33.831792)::geography, 200, 33, '404-785-9662/9650', '1711 TULLIE CIRCLE NE, ATLANTA, GA 30329'),
  ('b0000000-0000-0000-0000-000000000013', 'Northside Hospital Atlanta',                        ST_MakePoint(-84.353925, 33.908912)::geography, 200, 36, '404-851-6504/404-780-7722', '1000 JOHNSON FERRY ROAD NE, ATLANTA, GA 30342'),
  ('b0000000-0000-0000-0000-000000000014', 'Northside Hospital Duluth',                         ST_MakePoint(-84.163425, 33.999722)::geography, 200, 25, '678-312-6741/6757', '3620 HOWELL FERRY ROAD, DULUTH, GA 30096'),
  ('b0000000-0000-0000-0000-000000000015', 'Northside Hospital Gwinnett',                       ST_MakePoint(-84.017563, 33.963677)::geography, 200, 40, '678-312-3338', '1000 MEDICAL CENTER BOULEVARD, LAWRENCEVILLE, GA 30045'),
  ('b0000000-0000-0000-0000-000000000016', 'Piedmont Atlanta',                                  ST_MakePoint(-84.394415, 33.808815)::geography, 200, 47, '404-605-2211/3952', '1968 PEACHTREE ROAD NW, ATLANTA, GA 30309'),
  ('b0000000-0000-0000-0000-000000000017', 'Piedmont Eastside Medical Center',                  ST_MakePoint(-84.021074, 33.877569)::geography, 200, 31, '770-736-2440', '1700 MEDICAL WAY, SNELLVILLE, GA 30078'),
  ('b0000000-0000-0000-0000-000000000018', 'Piedmont Newton',                                   ST_MakePoint(-83.84843, 33.60134)::geography, 200, 42, '770-385-4414', '5126 HOSPITAL DRIVE, COVINGTON, GA 30014'),
  ('b0000000-0000-0000-0000-000000000019', 'Piedmont Rockdale',                                 ST_MakePoint(-84.001575, 33.680724)::geography, 200, 49, '770-918-3030', '1412 MILSTEAD AVENUE NE, CONYERS, GA 30012'),
  ('b0000000-0000-0000-0000-000000000020', 'Southern Regional Medical Center',                   ST_MakePoint(-84.389951, 33.57902)::geography, 200, 56, '770-991-8198/8198', '11 UPPER RIVERDALE ROAD SW, RIVERDALE, GA 30274'),
  ('b0000000-0000-0000-0000-000000000021', 'Wellstar Cobb Hospital',                             ST_MakePoint(-84.605025, 33.857542)::geography, 200, 50, '470-732-3051/3043', '3950 AUSTELL ROAD, AUSTELL, GA 30106'),
  ('b0000000-0000-0000-0000-000000000022', 'Wellstar Douglas Hospital',                          ST_MakePoint(-84.731524, 33.739118)::geography, 200, 38, '470-644-6422', '8954 HOSPITAL DRIVE, DOUGLASVILLE, GA 30134'),
  ('b0000000-0000-0000-0000-000000000023', 'WellStar Kennestone Regional Medical Center',        ST_MakePoint(-84.551352, 33.967953)::geography, 200, 31, '770-793-5698', '677 CHURCH STREET, MARIETTA, GA 30060'),
  ('b0000000-0000-0000-0000-000000000024', 'Wellstar North Fulton Hospital',                     ST_MakePoint(-84.319972, 34.063321)::geography, 200, 48, '770-410-4419', '3000 HOSPITAL BOULEVARD, ROSWELL, GA 30076')
ON CONFLICT (hospital_id) DO UPDATE
SET
  hospital_name = EXCLUDED.hospital_name,
  location = EXCLUDED.location,
  geofence_radius_meters = EXCLUDED.geofence_radius_meters,
  er_wall_time_minutes = EXCLUDED.er_wall_time_minutes,
  phone_number = EXCLUDED.phone_number,
  address = EXCLUDED.address;

-- ============================================================
-- Hospital specialties (sample)
-- ============================================================

INSERT INTO hospital_specialties (hospital_id, specialty_key, specialty_level, diversion_status) VALUES
  -- 1. Arthur M. Blank Children's Hospital
  ('b0000000-0000-0000-0000-000000000001', 'trauma', 'T-I', 'open'),
  ('b0000000-0000-0000-0000-000000000001', 'neonatal', 'Neo-IV', 'open'),

  -- 3. Children's Healthcare of Atlanta at Scottish Rite
  ('b0000000-0000-0000-0000-000000000003', 'trauma', 'T-II', 'open'),
  ('b0000000-0000-0000-0000-000000000003', 'neonatal', 'Neo-IV', 'open'),

  -- 5. Emory Decatur Hospital
  ('b0000000-0000-0000-0000-000000000005', 'stroke', 'PSC', 'open'),

  -- 6. Emory Hillandale Hospital
  ('b0000000-0000-0000-0000-000000000006', 'stroke', 'PSC', 'open'),

  -- 7. Emory Johns Creek Hospital
  ('b0000000-0000-0000-0000-000000000007', 'stemi', 'C-II', 'open'),
  ('b0000000-0000-0000-0000-000000000007', 'stroke', 'PSC', 'open'),

  -- 8. Emory Saint Joseph's Hospital
  ('b0000000-0000-0000-0000-000000000008', 'stemi', 'C-I', 'open'),
  ('b0000000-0000-0000-0000-000000000008', 'stroke', 'PSC', 'open'),

  -- 9. Emory University Hospital
  ('b0000000-0000-0000-0000-000000000009', 'stemi', 'C-I', 'open'),
  ('b0000000-0000-0000-0000-000000000009', 'stroke', 'CSC', 'open'),

  -- 10. Emory University Hospital Midtown
  ('b0000000-0000-0000-0000-000000000010', 'stemi', 'C-I', 'open'),
  ('b0000000-0000-0000-0000-000000000010', 'stroke', 'PSC', 'open'),
  ('b0000000-0000-0000-0000-000000000010', 'neonatal', 'Neo-III', 'open'),

  -- 11. Grady Memorial Hospital
  ('b0000000-0000-0000-0000-000000000011', 'stemi', 'C-I', 'open'),
  ('b0000000-0000-0000-0000-000000000011', 'trauma', 'T-I', 'open'),
  ('b0000000-0000-0000-0000-000000000011', 'burn', 'T-BC', 'open'),
  ('b0000000-0000-0000-0000-000000000011', 'stroke', 'CSC', 'open'),
  ('b0000000-0000-0000-0000-000000000011', 'obgyn', 'M-IV', 'open'),

  -- 13. Northside Hospital Atlanta
  ('b0000000-0000-0000-0000-000000000013', 'stemi', 'C-II', 'open'),
  ('b0000000-0000-0000-0000-000000000013', 'stroke', 'PSC', 'open'),
  ('b0000000-0000-0000-0000-000000000013', 'obgyn', 'M-IV', 'open'),

  -- 14. Northside Hospital Duluth
  ('b0000000-0000-0000-0000-000000000014', 'stemi', 'C-III', 'open'),
  ('b0000000-0000-0000-0000-000000000014', 'stroke', 'PSC', 'open'),

  -- 15. Northside Hospital Gwinnett
  ('b0000000-0000-0000-0000-000000000015', 'stemi', 'C-I', 'open'),
  ('b0000000-0000-0000-0000-000000000015', 'trauma', 'T-II', 'open'),
  ('b0000000-0000-0000-0000-000000000015', 'stroke', 'PSC', 'open'),

  -- 16. Piedmont Atlanta
  ('b0000000-0000-0000-0000-000000000016', 'stroke', 'CSC', 'open'),
  ('b0000000-0000-0000-0000-000000000016', 'obgyn', 'M-IV', 'open'),

  -- 17. Piedmont Eastside Medical Center
  ('b0000000-0000-0000-0000-000000000017', 'stroke', 'PSC', 'open'),

  -- 18. Piedmont Newton
  ('b0000000-0000-0000-0000-000000000018', 'stroke', 'ASRC', 'open'),

  -- 19. Piedmont Rockdale
  ('b0000000-0000-0000-0000-000000000019', 'stroke', 'ASRC', 'open'),

  -- 20. Southern Regional Medical Center
  ('b0000000-0000-0000-0000-000000000020', 'stroke', 'PSC', 'open'),

  -- 21. Wellstar Cobb Hospital
  ('b0000000-0000-0000-0000-000000000021', 'stemi', 'C-II', 'open'),
  ('b0000000-0000-0000-0000-000000000021', 'trauma', 'T-III', 'open'),
  ('b0000000-0000-0000-0000-000000000021', 'stroke', 'PSC', 'open'),
  ('b0000000-0000-0000-0000-000000000021', 'obgyn', 'M-III', 'open'),

  -- 22. Wellstar Douglas Hospital
  ('b0000000-0000-0000-0000-000000000022', 'stemi', 'C-II', 'open'),
  ('b0000000-0000-0000-0000-000000000022', 'stroke', 'PSC', 'open'),
  ('b0000000-0000-0000-0000-000000000022', 'obgyn', 'M-II', 'open'),

  -- 23. WellStar Kennestone Regional Medical Center
  ('b0000000-0000-0000-0000-000000000023', 'stemi', 'C-I', 'open'),
  ('b0000000-0000-0000-0000-000000000023', 'trauma', 'T-I', 'open'),
  ('b0000000-0000-0000-0000-000000000023', 'stroke', 'CSC', 'open'),

  -- 24. Wellstar North Fulton Hospital
  ('b0000000-0000-0000-0000-000000000024', 'stemi', 'C-II', 'open'),
  ('b0000000-0000-0000-0000-000000000024', 'trauma', 'T-II', 'open'),
  ('b0000000-0000-0000-0000-000000000024', 'stroke', 'CSC', 'open'),
  ('b0000000-0000-0000-0000-000000000024', 'obgyn', 'M-II', 'open')
ON CONFLICT (hospital_id, specialty_key) DO UPDATE
SET
  specialty_level = EXCLUDED.specialty_level,
  diversion_status = EXCLUDED.diversion_status;

COMMIT;