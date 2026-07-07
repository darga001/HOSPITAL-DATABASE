INSERT INTO departments (department_name, phone_number)
VALUES 
    ('Cardiology', '555-555-1001'),
    ('Dermatology', '555-555-1002'),
    ('Endocrinology', '555-555-1003'),
    ('Urology & Reproductive Medicine', '555-555-1004'),
    ('Reproductive', '555-555-1005'),
    ('Hematology', '555-555-1006'),
    ('Immunology', '555-555-1007'),
    ('Psychiatry', '555-555-1008'),
    ('Medical Genetics', '555-555-1009'),
    ('Neuroskeletal', '555-555-1010'),
    ('Orthopedics', '555-555-1011'),
    ('Rheumatology', '555-555-1012'),
    ('Neurology', '555-555-1013'),
    ('Oncology','555-555-1014'),
    ('Ophthalmology', '555-555-1015'),
    ('Pulmonology', '555-555-1016'),
    ('Gastroenterology', '555-555-1017'),
    ('Emergency Room', '555-555-1018'),
    ('Intensive Care','555-555-1019'),
    ('Pediatrics', '555-555-1020'),
    ('Obstetrics & Maternity' , '555-555-1021');
-- Split combined department into proper naming
UPDATE departments
SET department_name = 'Urology'
WHERE department_name = 'Urology & Reproductive Medicine';

-- Standardize naming
UPDATE departments
SET department_name = 'Reproductive Medicine'
WHERE department_name = 'Reproductive';

UPDATE departments
SET department_name = 'Intensive Care Unit'
WHERE department_name = 'Intensive Care';
-- department test population
INSERT INTO departments (department_name, phone_number)
VALUES
    ('Billing', '555-555-1022'),
    ('Pharmacy', '555-555-1023'),
    ('Operations', '555-555-1024'),
    ('Imaging', '555-555-1025'),
    ('Laboratory Services', '555-555-1026');


-- further logic issues found that needed to be corrected
ALTER TABLE departments
ADD COLUMN IF NOT EXISTS wing_id INT,
ADD COLUMN IF NOT EXISTS floor_number INT,
ADD COLUMN IF NOT EXISTS total_beds INT,
ADD COLUMN IF NOT EXISTS nurse_station_phone VARCHAR(20);

ALTER TABLE departments
ADD CONSTRAINT fk_departments_wing
FOREIGN KEY (wing_id) REFERENCES hospital_wings(wing_id);


-- add too hospital_wings
insert into hospital_wings (wing_name, wing_code, wing_status_active)
values 
    ('Grayson Wing', 'GW',TRUE),
    ('Allen Research', 'AR', TRUE),
    ('Grayson Clinical Wing', 'GCW', TRUE),
    ('Viltrum Operation Center', 'VOC', TRUE),
    ('Coalition Sciences Wing', 'CSW', TRUE),
    ('Global Services Wing', 'GW', TRUE),
    ('Steadman Psychiatric Wing', 'SPW', TRUE);
-- nurse station phones
update departments 
SET
    nurse_station_phone = CASE
        when department_name = 'Cardiology'  then '555-555-2001'
        when department_name = 'Dermatology' then '555-555-2002'
        when department_name = 'Endocrinology' then '555-555-2003'
        when department_name = 'Urology' then '555-555-2004'
        when department_name = 'Reproductive Medicine' then '555-555-2005'
        when department_name = 'Hematology' then '555-555-2006'
        when department_name = 'Immunology' then '555-555-2007'
        when department_name = 'Psychiatry' then '555-555-2008'
        when department_name = 'Medical Genetics' then '555-555-2009'
        when department_name = 'Neuroskeletal' then '555-555-2010'
        when department_name = 'Orthopedics' then '555-555-2011'
        when department_name = 'Rheumatology' then '555-555-2012'
        when department_name = 'Neurology' then '555-555-2013'
        when department_name = 'Oncology' then '555-555-2014'
        when department_name = 'Ophthalmology' then '555-555-2015'
        when department_name = 'Pulmonology' then '555-555-2016'
        when department_name = 'Emergency Room' THEN '555-555-2018'
        when department_name = 'Intensive Care Unit' then '555-555-2019'
        when department_name = 'Gastroenterology' then '555-555-2017'
        when department_name = 'Pediatrics' then '555-555-2020'
        when department_name = 'Obstetrics & Maternity' then '555-555-2021'
        when department_name = 'Billing' then 'n/a'
        when department_name = 'Pharmacy' then '555-555-2023'
        when department_name = 'Operations' then '555-555-2024'
        when department_name = 'Imaging' then '555-555-2025'
        when department_name = 'Laboratory Services' then '555-555-2026'
END;

-- Update total_beds
UPDATE departments
SET total_beds = CASE
    WHEN department_name = 'Cardiology' THEN 35
    WHEN department_name = 'Dermatology' THEN 15
    WHEN department_name = 'Endocrinology' THEN 20
    WHEN department_name = 'Urology' THEN 20
    WHEN department_name = 'Reproductive Medicine' THEN 35
    WHEN department_name = 'Hematology' THEN 10
    WHEN department_name = 'Immunology' THEN 15
    WHEN department_name = 'Psychiatry' THEN 30
    WHEN department_name = 'Medical Genetics' THEN 10
    WHEN department_name = 'Neuroskeletal' THEN 18
    WHEN department_name = 'Orthopedics' THEN 18
    WHEN department_name = 'Rheumatology' THEN 40
    WHEN department_name = 'Neurology' THEN 30
    WHEN department_name = 'Oncology' THEN 30
    WHEN department_name = 'Ophthalmology' THEN 10
    WHEN department_name = 'Pulmonology' THEN 20
    WHEN department_name = 'Emergency Room' THEN 120
    WHEN department_name = 'Intensive Care Unit' THEN 30
    WHEN department_name = 'Gastroenterology' THEN 40
    WHEN department_name = 'Pediatrics' THEN 35
    WHEN department_name = 'Obstetrics & Maternity' THEN 35
    WHEN department_name = 'Billing' THEN 0
    WHEN department_name = 'Pharmacy' THEN 0
    WHEN department_name = 'Operations' THEN 0
    WHEN department_name = 'Imaging' THEN 6
    WHEN department_name = 'Laboratory Services' THEN 2
    ELSE total_beds
END;

-- Change floor_number to VARCHAR(5)

ALTER TABLE departments
ALTER COLUMN floor_number TYPE VARCHAR(5)
USING floor_number::VARCHAR;

-- Update floor_number
UPDATE departments
SET floor_number = CASE
    -- Grayson Clinical Wing
    WHEN department_name = 'Cardiology' THEN '1A'
    WHEN department_name = 'Dermatology' THEN '1B'
    WHEN department_name = 'Neurology' THEN '2A'
    WHEN department_name = 'Pulmonology' THEN '2B'
    WHEN department_name = 'Rheumatology' THEN '3A'
    WHEN department_name = 'Ophthalmology' THEN '3B'

    -- Viltrum Operations Center
    WHEN department_name = 'Operations' THEN '1'
    WHEN department_name = 'Billing' THEN '2'

    -- Coalition Sciences Wing
    WHEN department_name = 'Pediatrics' THEN '1'
    WHEN department_name = 'Obstetrics & Maternity' THEN '2'
    WHEN department_name = 'Reproductive Medicine' THEN '3'

    -- Global Services Wing
    WHEN department_name = 'Imaging' THEN '1'
    WHEN department_name = 'Laboratory Services' THEN '2A'
    WHEN department_name = 'Pharmacy' THEN '2B'
    WHEN department_name = 'Neuroskeletal' THEN '3'
    WHEN department_name = 'Orthopedics' THEN '3'

    -- Psychiatry Wing
    WHEN department_name = 'Psychiatry' THEN '1'

    -- Allen Research Wing
    WHEN department_name = 'Gastroenterology' THEN '1'
    WHEN department_name = 'Endocrinology' THEN '2A'
    WHEN department_name = 'Urology' THEN '2B'
    WHEN department_name = 'Oncology' THEN '3A'
    WHEN department_name = 'Hematology' THEN '3B'
    WHEN department_name = 'Medical Genetics' THEN '4A'
    WHEN department_name = 'Immunology' THEN '4B'

    -- Grayson Wing
    WHEN department_name = 'Emergency Room' THEN '1'
    WHEN department_name = 'Intensive Care Unit' THEN '2'

    ELSE floor_number
END;
-- Update wing_id
UPDATE departments
SET wing_id = CASE
    -- Grayson Clinical Wing
    WHEN department_name = 'Cardiology' THEN 3
    WHEN department_name = 'Dermatology' THEN 3
    WHEN department_name = 'Neurology' THEN 3
    WHEN department_name = 'Pulmonology' THEN 3
    WHEN department_name = 'Rheumatology' THEN 3
    WHEN department_name = 'Ophthalmology' THEN 3

    -- Viltrum Operations Center
    WHEN department_name = 'Operations' THEN 4
    WHEN department_name = 'Billing' THEN 4

    -- Coalition Sciences Wing
    WHEN department_name = 'Pediatrics' THEN 5
    WHEN department_name = 'Obstetrics & Maternity' THEN 5
    WHEN department_name = 'Reproductive Medicine' THEN 5

    -- Global Services Wing
    WHEN department_name = 'Imaging' THEN 6
    WHEN department_name = 'Laboratory Services' THEN 6
    WHEN department_name = 'Pharmacy' THEN 6
    WHEN department_name = 'Neuroskeletal' THEN 6
    WHEN department_name = 'Orthopedics' THEN 6

    -- Psychiatry Wing
    WHEN department_name = 'Psychiatry' THEN 7

    -- Allen Research Wing
    WHEN department_name = 'Gastroenterology' THEN 2
    WHEN department_name = 'Endocrinology' THEN 2
    WHEN department_name = 'Urology' THEN 2
    WHEN department_name = 'Oncology' THEN 2
    WHEN department_name = 'Hematology' THEN 2
    WHEN department_name = 'Medical Genetics' THEN 2
    WHEN department_name = 'Immunology' THEN 2

    -- Grayson Wing
    WHEN department_name = 'Emergency Room' THEN 1
    WHEN department_name = 'Intensive Care Unit' THEN 1

    ELSE wing_id
END;

--Add offices column
ALTER TABLE departments
ADD COLUMN IF NOT EXISTS offices INT;
-- Update offices
UPDATE departments
SET offices = CASE
    WHEN department_name = 'Cardiology' THEN 12
    WHEN department_name = 'Dermatology' THEN 6
    WHEN department_name = 'Endocrinology' THEN 8
    WHEN department_name = 'Hematology' THEN 6
    WHEN department_name = 'Immunology' THEN 7
    WHEN department_name = 'Psychiatry' THEN 8
    WHEN department_name = 'Medical Genetics' THEN 6
    WHEN department_name = 'Neuroskeletal' THEN 6
    WHEN department_name = 'Orthopedics' THEN 8
    WHEN department_name = 'Rheumatology' THEN 7
    WHEN department_name = 'Neurology' THEN 10
    WHEN department_name = 'Oncology' THEN 12
    WHEN department_name = 'Pulmonology' THEN 8
    WHEN department_name = 'Ophthalmology' THEN 6
    WHEN department_name = 'Gastroenterology' THEN 10
    WHEN department_name = 'Emergency Room' THEN 12
    WHEN department_name = 'Pediatrics' THEN 10
    WHEN department_name = 'Obstetrics & Maternity' THEN 10
    WHEN department_name = 'Urology' THEN 8
    WHEN department_name = 'Reproductive Medicine' THEN 8
    WHEN department_name = 'Intensive Care Unit' THEN 12
    WHEN department_name = 'Billing' THEN 8
    WHEN department_name = 'Pharmacy' THEN 5
    WHEN department_name = 'Operations' THEN 10
    WHEN department_name = 'Imaging' THEN 8
    WHEN department_name = 'Laboratory Services' THEN 6
    ELSE offices
END;

-- beds creation based ob beds inside departments number.

INSERT INTO beds (department_id, occupied, bed_type)
SELECT
    d.department_id,
    CASE
        WHEN d.department_name = 'Emergency Room' THEN TRUE
        WHEN gs <= CEIL(d.total_beds * 0.70) THEN TRUE
        ELSE FALSE
    END AS occupied,
    CASE
        WHEN d.department_name = 'Emergency Room' THEN 'Emergency Bed'
        WHEN d.department_name = 'Intensive Care Unit' THEN 'ICU Bed'
        WHEN d.department_name = 'Pediatrics' THEN 'Pediatric Bed'
        WHEN d.department_name = 'Obstetrics & Maternity' THEN 'Maternity Bed'
        WHEN d.department_name = 'Reproductive Medicine' THEN 'Reproductive Care Bed'
        WHEN d.department_name = 'Psychiatry' THEN 'Psychiatric Bed'
        WHEN d.department_name = 'Oncology' THEN 'Oncology Bed'
        WHEN d.department_name = 'Hematology' THEN 'Hematology Bed'
        WHEN d.department_name = 'Cardiology' THEN 'Cardiac Bed'
        WHEN d.department_name = 'Neurology' THEN 'Neurology Bed'
        WHEN d.department_name = 'Pulmonology' THEN 'Pulmonary Bed'
        WHEN d.department_name = 'Orthopedics' THEN 'Orthopedic Bed'
        WHEN d.department_name = 'Neuroskeletal' THEN 'Neuroskeletal Bed'
        WHEN d.department_name = 'Gastroenterology' THEN 'Gastro Bed'
        WHEN d.department_name = 'Endocrinology' THEN 'Endocrine Bed'
        WHEN d.department_name = 'Urology' THEN 'Urology Bed'
        WHEN d.department_name = 'Immunology' THEN 'Immunology Bed'
        WHEN d.department_name = 'Medical Genetics' THEN 'Genetics Bed'
        WHEN d.department_name = 'Rheumatology' THEN 'Rheumatology Bed'
        WHEN d.department_name = 'Dermatology' THEN 'Dermatology Bed'
        WHEN d.department_name = 'Ophthalmology' THEN 'Observation Bed'
        WHEN d.department_name = 'Imaging' THEN 'Observation Bed'
        WHEN d.department_name = 'Laboratory Services' THEN 'Observation Bed'
        ELSE 'Standard Bed'
    END AS bed_type
FROM departments d
CROSS JOIN LATERAL generate_series(1, d.total_beds) AS gs
WHERE d.total_beds > 0;
--624 beds






-- Patient Population key logical query for occpied beds.
SELECT COUNT(*) AS occupied_beds
FROM beds
JOIN departments
    ON beds.department_id = departments.department_id
WHERE departments.department_name = 'Cardiology'
  AND beds.occupied = TRUE;

--hospital_db=# select count(*) as occupied_beds
--hospital_db-# from beds
--hospital_db-# where occupied = TRUE;
-- occupied_beds
---------------
 --          478
--(1 row)
-- 478 active patients in the hospital right now.

-- surgery rooms population

INSERT INTO surgery_rooms (room_name, room_number, wing_id, available_for_use)
VALUES
-- GRAYSON WING ER and ICU
('OR-1','1', 1, TRUE),
('OR-2','2', 1, FALSE),
('OR-3','3', 1, FALSE),
('OR-4','4', 1, FALSE),
('EMERGENCY-OR','5', 1, FALSE),
('TRAUMA-SUITE','6', 1, FALSE),

-- GRAYSON CLINICAL WING
('OR-5','1', 3, FALSE),
('OR-6','2', 3, FALSE),             
('CARDIO-SUITE','3', 3, FALSE),
('NEURO-SUITE','4', 3, TRUE),       
('VASCULAR-SUITE','5', 3, FALSE),
('EYE-SUITE','6', 3, TRUE),

-- ALLEN RESEARCH
('OR-7','1', 2, FALSE),
('OR-8','2', 2, TRUE),
('OR-9','3', 2, TRUE),             
('MINIMALLY-INVASIVE-SUITE','4', 2, FALSE),
('HYBRID-OR','5', 2, FALSE),
('THORACIC-SUITE','6', 2, FALSE),
('ONCO-SUITE','7', 2, FALSE),

-- COALITION SCIENCES
('PEDS-OR-1','1', 5, FALSE),
('PEDS-OR-2','2', 5, TRUE),
('OR-10','3', 5, FALSE),
('OBYGN-SUITE','4', 5, FALSE), 

-- GLOBAL SERVICES
('ORTHO-OR-1','1', 6, FALSE),
('ORTHO-OR-2','2', 6, FALSE);


-- Load diseases from CSV
\copy diseases 
(disease_name, category, body_system, is_chronic, 
is_autoimmune, is_infectious, infection_type,
is_tumor, is_operable, is_contagious, is_genetic,
is_degenerative, is_treatable, is_curable) 
FROM 'C:/Users/diego/OneDrive/Desktop/hospital_db/diseases_enriched_filled.csv' 
WITH (FORMAT csv, HEADER true);

--  



