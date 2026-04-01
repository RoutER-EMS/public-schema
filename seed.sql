-- routER – Seed data for local development / demo.
-- Run AFTER init.sql.
-- UUIDs must be valid hex (0-9, a-f) per PostgreSQL uuid type.

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
    {"key":"A9EF3KJLS2D4JFL324KA23DF","user_type":"manager","email":"manager@testagency.com","is_used":false,"created_at":"2026-03-23T12:00:00Z"}
  ]'::jsonb,
  NULL
);

-- ============================================================
-- Users
-- ============================================================

INSERT INTO users (user_id, name, email, user_type, generated_key, contract_id) VALUES
  ('a0000000-0000-0000-0000-000000000001', 'Admin User', 'router.ems.gt@gmail.com', 'admin', NULL, NULL);

-- ============================================================
-- Hospitals (Atlanta metro area)
-- ============================================================

INSERT INTO public."Hospitals" (
    hospital_id, 
    name, 
    latitudinal, 
    longitudinal, 
    geofence_radius_meters, 
    er_wall_time_minutes, 
    phone_number, 
    address
) VALUES
(1, 'Arthur M. Blank Children''s Hospital', 33.793571, -84.31965, 200, 38, '404-785-6422', '1405 CLIFTON ROAD NE, DRUID HILLS, GA 30322'),
(2, 'Atlanta VA Medical Center', 33.801861, -84.311425, 200, 50, '(404) 321-6111', '1670 CLAIRMONT ROAD, DECATUR, GA 30033'),
(3, 'Children''s Healthcare of Atlanta at Scottish Rite', 33.906082, -84.353952, 200, 27, '404-785-2275', '1001 JOHNSON FERRY RD, ATLANTA, GA 30342'),
(4, 'Eastside Medical Center - South Campus', 33.877569, -84.021074, 200, 26, '(770) 979-0200', '1700 MEDICAL WAY, SNELLVILLE, GA 30078'),
(5, 'Emory Decatur Hospital', 33.791089, -84.28291, 200, 59, '404-501-3900/1758', '2701 N DECATUR ROAD, DECATUR, GA 30033'),
(6, 'Emory Hillandale Hospital', 33.70522, -84.147983, 200, 54, '404-501-2341', '2801 DEKALB MEDICAL PARKWAY, LITHONIA, GA 30058'),
(7, 'Emory Johns Creek Hospital', 34.066675, -84.176628, 200, 43, '678-474-7101/7100', '6325 HOSPITAL PARKWAY, JOHNS CREEK, GA 30097'),
(8, 'Emory Saint Joseph''s Hospital', 33.908758, -84.348984, 200, 41, '678-843-7164/7166', '5665 PEACHTREE DUNWOODY RD NE, SANDY SPRINGS, GA 30342'),
(9, 'Emory University Hospital', 33.792023, -84.322263, 200, 79, '404-727-9292/7109', '1364 CLIFTON ROAD NE, DRUID HILLS, GA 30322'),
(10, 'Emory University Hospital Midtown', 33.769175, -84.386732, 200, 46, '404-686-1050/1051', '550 PEACHTREE ST NE, ATLANTA, GA 30308'),
(11, 'Grady Memorial Hospital', 33.751989, -84.381792, 200, 55, '404-616-4677', '80 JESSE HILL, JR DRIVE SE, ATLANTA, GA 30303'),
(12, 'Hughes Spalding Children''s Hospital', 33.831792, -84.330333, 200, 33, '404-785-9662/9650', '1711 TULLIE CIRCLE NE, ATLANTA, GA 30329'),
(13, 'Northside Hospital Atlanta', 33.908912, -84.353925, 200, 36, '404-851-6504/404-780-7722', '1000 JOHNSON FERRY ROAD NE, ATLANTA, GA 30342'),
(14, 'Northside Hospital Duluth', 33.999722, -84.163425, 200, 25, '678-312-6741/6757', '3620 HOWELL FERRY ROAD, DULUTH, GA 30096'),
(15, 'Northside Hospital Gwinnett', 33.963677, -84.017563, 200, 40, '678-312-3338', '1000 MEDICAL CENTER BOULEVARD, LAWRENCEVILLE, GA 30045'),
(16, 'Piedmont Atlanta', 33.808815, -84.394415, 200, 47, '404-605-2211/3952', '1968 PEACHTREE ROAD NW, ATLANTA, GA 30309'),
(17, 'Piedmont Eastside Medical Center', 33.877569, -84.021074, 200, 31, '770-736-2440', '1700 MEDICAL WAY, SNELLVILLE, GA 30078'),
(18, 'Piedmont Newton', 33.60134, -83.84843, 200, 42, '770-385-4414', '5126 HOSPITAL DRIVE, COVINGTON, GA 30014'),
(19, 'Piedmont Rockdale', 33.680724, -84.001575, 200, 49, '770-918-3030', '1412 MILSTEAD AVENUE NE, CONYERS, GA 30012'),
(20, 'Southern Regional Medical Center', 33.57902, -84.389951, 200, 56, '770-991-8198/8198', '11 UPPER RIVERDALE ROAD SW, RIVERDALE, GA 30274'),
(21, 'Wellstar Cobb Hospital', 33.857542, -84.605025, 200, 50, '470-732-3051/3043', '3950 AUSTELL ROAD, AUSTELL, GA 30106'),
(22, 'Wellstar Douglas Hospital', 33.739118, -84.731524, 200, 38, '470-644-6422', '8954 HOSPITAL DRIVE, DOUGLASVILLE, GA 30134'),
(23, 'WellStar Kennestone Regional Medical Center', 33.967953, -84.551352, 200, 31, '770-793-5698', '677 CHURCH STREET, MARIETTA, GA 30060'),
(24, 'Wellstar North Fulton Hospital', 34.063321, -84.319972, 200, 48, '770-410-4419', '3000 HOSPITAL BOULEVARD, ROSWELL, GA 30076');

-- ============================================================
-- Hospital specialties (sample)
-- ============================================================

INSERT INTO hospital_specialties (hospital_id, specialty_key, specialty_level, diversion_status) VALUES
-- 1. Arthur M. Blank Children's Hospital
(1, 'trauma', 'T-I', 'open'),
(1, 'neonatal', 'Neo-IV', 'open'),

-- 3. Children's Healthcare of Atlanta at Scottish Rite
(3, 'trauma', 'T-II', 'open'),
(3, 'neonatal', 'Neo-IV', 'open'),

-- 5. Emory Decatur Hospital
(5, 'stroke', 'PSC', 'open'),

-- 6. Emory Hillandale Hospital
(6, 'stroke', 'PSC', 'open'),

-- 7. Emory Johns Creek Hospital
(7, 'stemi', 'C-II', 'open'),
(7, 'stroke', 'PSC', 'open'),

-- 8. Emory Saint Joseph's Hospital
(8, 'stemi', 'C-I', 'open'),
(8, 'stroke', 'PSC', 'open'),

-- 9. Emory University Hospital
(9, 'stemi', 'C-I', 'open'),
(9, 'stroke', 'CSC', 'open'),

-- 10. Emory University Hospital Midtown
(10, 'stemi', 'C-I', 'open'),
(10, 'stroke', 'PSC', 'open'),
(10, 'neonatal', 'Neo-III', 'open'),

-- 11. Grady Memorial Hospital
(11, 'stemi', 'C-I', 'open'),
(11, 'trauma', 'T-I', 'open'),
(11, 'burn', 'T-BC', 'open'),
(11, 'stroke', 'CSC', 'open'),
(11, 'obgyn', 'M-IV', 'open'),

-- 13. Northside Hospital Atlanta
(13, 'stemi', 'C-II', 'open'),
(13, 'stroke', 'PSC', 'open'),
(13, 'obgyn', 'M-IV', 'open'),

-- 14. Northside Hospital Duluth
(14, 'stemi', 'C-III', 'open'),
(14, 'stroke', 'PSC', 'open'),

-- 15. Northside Hospital Gwinnett
(15, 'stemi', 'C-I', 'open'),
(15, 'trauma', 'T-II', 'open'),
(15, 'stroke', 'PSC', 'open'),

-- 16. Piedmont Atlanta
(16, 'stroke', 'CSC', 'open'),
(16, 'obgyn', 'M-IV', 'open'),

-- 17. Piedmont Eastside Medical Center
(17, 'stroke', 'PSC', 'open'),

-- 18. Piedmont Newton
(18, 'stroke', 'ASRC', 'open'),

-- 19. Piedmont Rockdale
(19, 'stroke', 'ASRC', 'open'),

-- 20. Southern Regional Medical Center
(20, 'stroke', 'PSC', 'open'),

-- 21. Wellstar Cobb Hospital
(21, 'stemi', 'C-II', 'open'),
(21, 'trauma', 'T-III', 'open'),
(21, 'stroke', 'PSC', 'open'),
(21, 'obgyn', 'M-III', 'open'),

-- 22. Wellstar Douglas Hospital
(22, 'stemi', 'C-II', 'open'),
(22, 'stroke', 'PSC', 'open'),
(22, 'obgyn', 'M-II', 'open'),

-- 23. WellStar Kennestone Regional Medical Center
(23, 'stemi', 'C-I', 'open'),
(23, 'trauma', 'T-I', 'open'),
(23, 'stroke', 'CSC', 'open'),

-- 24. Wellstar North Fulton Hospital
(24, 'stemi', 'C-II', 'open'),
(24, 'trauma', 'T-II', 'open'),
(24, 'stroke', 'CSC', 'open'),
(24, 'obgyn', 'M-II', 'open');