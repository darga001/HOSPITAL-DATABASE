-- Table edits for propper integrity

-- while making the tables i realized there were a couple of things that needed to be added to ensure logic and data integrity

ALTER TABLE hospital_wings
    ALTER COLUMN wing_status_active SET DEFAULT TRUE,
    ADD CONSTRAINT floor_check CHECK (floor_number >= 0),
    DROP CONSTRAINT hospital_wings_department_id_fkey,
    ADD CONSTRAINT hospital_wings_department_id_fkey
        FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
        ON DELETE RESTRICT;

ALTER TABLE diseases
    ALTER COLUMN is_chronic SET DEFAULT FALSE,
    ALTER COLUMN is_autoimmune SET DEFAULT FALSE,
    ALTER COLUMN is_infectious SET DEFAULT FALSE,
    ALTER COLUMN is_tumor SET DEFAULT FALSE,
    ALTER COLUMN is_operable SET DEFAULT FALSE,
    ALTER COLUMN is_contagious SET DEFAULT FALSE,
    ALTER COLUMN is_genetic SET DEFAULT FALSE,
    ALTER COLUMN is_degenerative SET DEFAULT FALSE,
    ALTER COLUMN is_treatable SET DEFAULT TRUE,
    ALTER COLUMN is_curable SET DEFAULT TRUE;

ALTER TABLE doctors
    ALTER COLUMN employment_status_active SET DEFAULT TRUE,
    ALTER COLUMN vacation_status SET DEFAULT FALSE,
    DROP CONSTRAINT doctors_department_id_fkey,
    ADD CONSTRAINT doctors_department_id_fkey
        FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
        ON DELETE RESTRICT,
    DROP CONSTRAINT doctors_wing_id_fkey,
    ADD CONSTRAINT doctors_wing_id_fkey
        FOREIGN KEY (wing_id)
        REFERENCES hospital_wings(wing_id)
        ON DELETE RESTRICT;

ALTER TABLE patients
    ALTER COLUMN registration_date SET DEFAULT CURRENT_DATE,
    ALTER COLUMN is_born_in_hospital SET DEFAULT FALSE;

ALTER TABLE beds
    ALTER COLUMN occupied SET DEFAULT FALSE,
    ADD CONSTRAINT bed_check_room CHECK (room_number ~ '^[1-9][0-9]*$'),
    DROP CONSTRAINT beds_wing_id_fkey,
    ADD CONSTRAINT beds_wing_id_fkey
        FOREIGN KEY (wing_id)
        REFERENCES hospital_wings(wing_id)
        ON DELETE RESTRICT;

ALTER TABLE admissions
    ALTER COLUMN trauma_case SET DEFAULT FALSE,
    ALTER COLUMN pregnancy SET DEFAULT FALSE,
    ADD CONSTRAINT discharge_after_admission_check
        CHECK (discharge_date IS NULL OR discharge_date >= admission_date),
    DROP CONSTRAINT admissions_patient_id_fkey,
    ADD CONSTRAINT admissions_patient_id_fkey
        FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id)
        ON DELETE RESTRICT,
    DROP CONSTRAINT admissions_admitting_doctor_id_fkey,
    ADD CONSTRAINT admissions_admitting_doctor_id_fkey
        FOREIGN KEY (admitting_doctor_id)
        REFERENCES doctors(doctor_id)
        ON DELETE RESTRICT,
    DROP CONSTRAINT admissions_wing_id_fkey,
    ADD CONSTRAINT admissions_wing_id_fkey
        FOREIGN KEY (wing_id)
        REFERENCES hospital_wings(wing_id)
        ON DELETE RESTRICT,
    DROP CONSTRAINT admissions_bed_id_fkey,
    ADD CONSTRAINT admissions_bed_id_fkey
        FOREIGN KEY (bed_id)
        REFERENCES beds(bed_id)
        ON DELETE RESTRICT;

ALTER TABLE billing_items
    ADD CONSTRAINT billing_items_quantity_check CHECK (quantity > 0),
    ADD CONSTRAINT billing_items_unit_cost_check CHECK (unit_cost >= 0);

ALTER TABLE pharmaceuticals
    ADD CONSTRAINT pharmaceuticals_unit_cost_check CHECK (unit_cost >= 0),
    ADD CONSTRAINT pharmaceuticals_stock_quantity_check CHECK (stock_quantity IS NULL OR stock_quantity >= 0);

ALTER TABLE pharma_use_event
    ADD CONSTRAINT pharma_use_event_dates_check
        CHECK (end_date IS NULL OR end_date >= start_date),
    DROP CONSTRAINT pharma_use_event_pharma_id_fkey,
    ADD CONSTRAINT pharma_use_event_pharma_id_fkey
        FOREIGN KEY (pharma_id)
        REFERENCES pharmaceuticals(pharma_id)
        ON DELETE RESTRICT,
    DROP CONSTRAINT pharma_use_event_patient_id_fkey,
    ADD CONSTRAINT pharma_use_event_patient_id_fkey
        FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id)
        ON DELETE RESTRICT,
    DROP CONSTRAINT pharma_use_event_admission_id_fkey,
    ADD CONSTRAINT pharma_use_event_admission_id_fkey
        FOREIGN KEY (admission_id)
        REFERENCES admissions(admission_id)
        ON DELETE SET NULL,
    DROP CONSTRAINT pharma_use_event_prescribing_doctor_id_fkey,
    ADD CONSTRAINT pharma_use_event_prescribing_doctor_id_fkey
        FOREIGN KEY (prescribing_doctor_id)
        REFERENCES doctors(doctor_id)
        ON DELETE RESTRICT,
    DROP CONSTRAINT pharma_use_event_administrating_nurse_id_fkey,
    ADD CONSTRAINT pharma_use_event_administrating_nurse_id_fkey
        FOREIGN KEY (administrating_nurse_id)
        REFERENCES nurses(nurse_id)
        ON DELETE SET NULL,
    DROP CONSTRAINT pharma_use_event_wing_id_fkey,
    ADD CONSTRAINT pharma_use_event_wing_id_fkey
        FOREIGN KEY (wing_id)
        REFERENCES hospital_wings(wing_id)
        ON DELETE SET NULL;

ALTER TABLE surgery_rooms
    ALTER COLUMN available_for_use SET DEFAULT TRUE,
    DROP CONSTRAINT surgery_rooms_wing_id_fkey,
    ADD CONSTRAINT surgery_rooms_wing_id_fkey
        FOREIGN KEY (wing_id)
        REFERENCES hospital_wings(wing_id)
        ON DELETE RESTRICT;

ALTER TABLE surgeries
    ADD CONSTRAINT surgeries_time_check
        CHECK (actual_end >= actual_start),
    DROP CONSTRAINT surgeries_patient_id_fkey,
    ADD CONSTRAINT surgeries_patient_id_fkey
        FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id)
        ON DELETE RESTRICT,
    DROP CONSTRAINT surgeries_doctor_id_fkey,
    ADD CONSTRAINT surgeries_doctor_id_fkey
        FOREIGN KEY (doctor_id)
        REFERENCES doctors(doctor_id)
        ON DELETE RESTRICT,
    DROP CONSTRAINT surgeries_admission_id_fkey,
    ADD CONSTRAINT surgeries_admission_id_fkey
        FOREIGN KEY (admission_id)
        REFERENCES admissions(admission_id)
        ON DELETE SET NULL,
    DROP CONSTRAINT surgeries_item_id_fkey,
    ADD CONSTRAINT surgeries_item_id_fkey
        FOREIGN KEY (item_id)
        REFERENCES billing_items(item_id)
        ON DELETE SET NULL,
    DROP CONSTRAINT surgeries_pharma_id_fkey,
    ADD CONSTRAINT surgeries_pharma_id_fkey
        FOREIGN KEY (pharma_id)
        REFERENCES pharmaceuticals(pharma_id)
        ON DELETE SET NULL,
    DROP CONSTRAINT surgeries_surgery_room_id_fkey,
    ADD CONSTRAINT surgeries_surgery_room_id_fkey
        FOREIGN KEY (surgery_room_id)
        REFERENCES surgery_rooms(surgery_room_id)
        ON DELETE SET NULL;

ALTER TABLE diagnostics
    ADD CONSTRAINT diagnostics_standard_cost_check CHECK (standard_cost >= 0),
    DROP CONSTRAINT diagnostics_department_id_fkey,
    ADD CONSTRAINT diagnostics_department_id_fkey
        FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
        ON DELETE RESTRICT;

ALTER TABLE test_records
    ALTER COLUMN result_ready SET DEFAULT FALSE,
    ADD CONSTRAINT test_records_cost_check CHECK (cost IS NULL OR cost >= 0),
    DROP CONSTRAINT test_records_test_id_fkey,
    ADD CONSTRAINT test_records_test_id_fkey
        FOREIGN KEY (test_id)
        REFERENCES diagnostics(test_id)
        ON DELETE RESTRICT,
    DROP CONSTRAINT test_records_doctor_id_fkey,
    ADD CONSTRAINT test_records_doctor_id_fkey
        FOREIGN KEY (doctor_id)
        REFERENCES doctors(doctor_id)
        ON DELETE RESTRICT,
    DROP CONSTRAINT test_records_patient_id_fkey,
    ADD CONSTRAINT test_records_patient_id_fkey
        FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id)
        ON DELETE RESTRICT,
    DROP CONSTRAINT test_records_admission_id_fkey,
    ADD CONSTRAINT test_records_admission_id_fkey
        FOREIGN KEY (admission_id)
        REFERENCES admissions(admission_id)
        ON DELETE SET NULL;

ALTER TABLE patient_diagnosis
    ADD CONSTRAINT patient_diagnosis_date_check CHECK (diagnosis_date <= CURRENT_DATE),
    DROP CONSTRAINT patient_diagnosis_disease_id_fkey,
    ADD CONSTRAINT patient_diagnosis_disease_id_fkey
        FOREIGN KEY (disease_id)
        REFERENCES diseases(disease_id)
        ON DELETE SET NULL,
    DROP CONSTRAINT patient_diagnosis_patient_id_fkey,
    ADD CONSTRAINT patient_diagnosis_patient_id_fkey
        FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id)
        ON DELETE RESTRICT,
    DROP CONSTRAINT patient_diagnosis_doctor_id_fkey,
    ADD CONSTRAINT patient_diagnosis_doctor_id_fkey
        FOREIGN KEY (doctor_id)
        REFERENCES doctors(doctor_id)
        ON DELETE RESTRICT,
    DROP CONSTRAINT patient_diagnosis_admission_id_fkey,
    ADD CONSTRAINT patient_diagnosis_admission_id_fkey
        FOREIGN KEY (admission_id)
        REFERENCES admissions(admission_id)
        ON DELETE SET NULL,
    DROP CONSTRAINT patient_diagnosis_test_record_id_fkey,
    ADD CONSTRAINT patient_diagnosis_test_record_id_fkey
        FOREIGN KEY (test_record_id)
        REFERENCES test_records(test_record_id)
        ON DELETE SET NULL;

ALTER TABLE outcomes
    ALTER COLUMN discharged SET DEFAULT FALSE,
    ALTER COLUMN death SET DEFAULT FALSE,
    ALTER COLUMN complications SET DEFAULT FALSE,
    ALTER COLUMN follow_up_required SET DEFAULT FALSE,
    ADD CONSTRAINT outcomes_followup_check
        CHECK (follow_up_required = TRUE OR follow_up_date IS NULL),
    DROP CONSTRAINT outcomes_patient_diagnosis_id_fkey,
    ADD CONSTRAINT outcomes_patient_diagnosis_id_fkey
        FOREIGN KEY (patient_diagnosis_id)
        REFERENCES patient_diagnosis(patient_diagnosis_id)
        ON DELETE SET NULL,
    DROP CONSTRAINT outcomes_admission_id_fkey,
    ADD CONSTRAINT outcomes_admission_id_fkey
        FOREIGN KEY (admission_id)
        REFERENCES admissions(admission_id)
        ON DELETE RESTRICT;

ALTER TABLE billing
    ALTER COLUMN billing_date SET DEFAULT CURRENT_DATE,
    ADD CONSTRAINT billing_total_amount_check CHECK (total_amount >= 0),
    DROP CONSTRAINT billing_admission_id_fkey,
    ADD CONSTRAINT billing_admission_id_fkey
        FOREIGN KEY (admission_id)
        REFERENCES admissions(admission_id)
        ON DELETE RESTRICT,
    DROP CONSTRAINT billing_patient_id_fkey,
    ADD CONSTRAINT billing_patient_id_fkey
        FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id)
        ON DELETE RESTRICT;
        
-- further edits because of issues on the initial 18 table set up. 
352069