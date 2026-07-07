-- First two tables departments and hospital_wings were created direclty on the command prompt to ensure databse was live. 
CREATE TABLE doctors(
    doctor_id SERIAL PRIMARY KEY,
    doctor_name VARCHAR(100) NOT NULL,
    doctor_last_name VARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender VARCHAR(20) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone_number VARCHAR(20) UNIQUE NOT NULL,
    license_number VARCHAR(50) UNIQUE NOT NULL,
    specialty VARCHAR(150) NOT NULL,
    sub_specialty VARCHAR(150),
    department_id INT REFERENCES departments(department_id),
    wing_id INT REFERENCES hospital_wings(wing_id),
    shift_type VARCHAR(100) NOT NULL,
    employment_status_active BOOLEAN NOT NULL,
    vacation_status BOOLEAN NOT NULL,
    salary INT NOT NULL
);

CREATE TABLE diseases(
    disease_id SERIAL PRIMARY KEY,
    disease_name VARCHAR(300) UNIQUE NOT NULL,
    category VARCHAR(100) NOT NULL,
    body_system VARCHAR(200) NOT NULL,
    is_chronic BOOLEAN,
    is_autoimmune BOOLEAN,
    is_infectious BOOLEAN,
    infection_type VARCHAR(200),
    is_tumor BOOLEAN,
    is_operable BOOLEAN,
    is_contagious BOOLEAN,
    is_genetic BOOLEAN,
    is_degenerative BOOLEAN,
    is_treatable BOOLEAN NOT NULL,
    is_curable BOOLEAN NOT NULL
);

CREATE TABLE patients(
    patient_id SERIAL PRIMARY KEY,
    patient_name VARCHAR(100) NOT NULL,
    patient_last_name VARCHAR(150) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender VARCHAR(20) NOT NULL,
    marital_status VARCHAR(80),
    nationality VARCHAR(100) NOT NULL,
    blood_type VARCHAR(60) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone_number VARCHAR(20) UNIQUE NOT NULL,
    city VARCHAR(100),
    zip CHAR(5),
    registration_date DATE NOT NULL,
    is_born_in_hospital BOOLEAN
);

CREATE TABLE nurses(
    nurse_id SERIAL PRIMARY KEY,
    nurse_name VARCHAR(100) NOT NULL,
    nurse_last_name VARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender VARCHAR(20),
    email VARCHAR(255) UNIQUE NOT NULL,
    phone_number VARCHAR(20) UNIQUE NOT NULL,
    nurse_type VARCHAR(100),
    specialty VARCHAR(200),
    department_id INT REFERENCES departments(department_id),
    wing_id INT REFERENCES hospital_wings(wing_id),
    shift_type VARCHAR(100) NOT NULL,
    employment_status_active BOOLEAN NOT NULL,
    vacation_status BOOLEAN NOT NULL,
    salary INT NOT NULL
);

CREATE TABLE beds(
    bed_id SERIAL PRIMARY KEY,
    wing_id INT REFERENCES hospital_wings(wing_id),
    occupied BOOLEAN NOT NULL,
    room_number VARCHAR(5) NOT NULL,
    bed_type VARCHAR(50)
);

CREATE TABLE admissions(
    admission_id SERIAL PRIMARY KEY,
    patient_id INT REFERENCES patients(patient_id) NOT NULL,
    admitting_doctor_id INT REFERENCES doctors(doctor_id) NOT NULL,
    wing_id INT REFERENCES hospital_wings(wing_id) NOT NULL,
    bed_id INT REFERENCES beds(bed_id) NOT NULL,
    admission_date DATE NOT NULL,
    discharge_date DATE,
    trauma_case BOOLEAN NOT NULL,
    pregnancy BOOLEAN NOT NULL,
    admission_notes VARCHAR(500)
);

CREATE TABLE billing_items(
    item_id SERIAL PRIMARY KEY,
    item_name VARCHAR(150) NOT NULL UNIQUE,
    item_category VARCHAR(100),
    quantity INT NOT NULL,
    unit_cost DECIMAL NOT NULL
);

CREATE TABLE pharmaceuticals(
    pharma_id SERIAL PRIMARY KEY,
    medication_name VARCHAR(200) UNIQUE NOT NULL,
    category VARCHAR(150) NOT NULL,
    dosage_form VARCHAR(150),
    manufacturer VARCHAR(150) NOT NULL,
    unit_cost DECIMAL NOT NULL,
    stock_quantity INT
);

CREATE TABLE pharma_use_event(
    pharma_use_event_id SERIAL PRIMARY KEY,
    pharma_id INT REFERENCES pharmaceuticals(pharma_id) NOT NULL,
    patient_id INT REFERENCES patients(patient_id) NOT NULL,
    admission_id INT REFERENCES admissions(admission_id),
    prescribing_doctor_id INT REFERENCES doctors(doctor_id) NOT NULL,
    administrating_nurse_id INT REFERENCES nurses(nurse_id),
    start_date DATE NOT NULL,
    end_date DATE,
    frequency VARCHAR(50),
    dosage VARCHAR(50),
    wing_id INT REFERENCES hospital_wings(wing_id)
);

CREATE TABLE surgery_rooms(
    surgery_room_id SERIAL PRIMARY KEY,
    room_name VARCHAR(50),
    room_number VARCHAR(4),
    wing_id INT REFERENCES hospital_wings(wing_id),
    available_for_use BOOLEAN
);

CREATE TABLE surgeries(
    surgery_id SERIAL PRIMARY KEY,
    patient_id INT REFERENCES patients(patient_id) NOT NULL,
    doctor_id INT REFERENCES doctors(doctor_id) NOT NULL,
    admission_id INT REFERENCES admissions(admission_id),
    item_id INT REFERENCES billing_items(item_id),
    pharma_id INT REFERENCES pharmaceuticals(pharma_id),
    surgery_room_id INT REFERENCES surgery_rooms(surgery_room_id),
    surgery_type VARCHAR(200),
    surgery_name VARCHAR(200) NOT NULL,
    scheduled_date DATE,
    actual_start TIMESTAMP NOT NULL,
    actual_end TIMESTAMP NOT NULL,
    outcome_status VARCHAR(200),
    surgery_notes VARCHAR(500)
);

CREATE TABLE diagnostics(
    test_id SERIAL PRIMARY KEY,
    test_name VARCHAR(100) NOT NULL,
    test_category VARCHAR(100) NOT NULL,
    department_id INT REFERENCES departments(department_id),
    standard_cost DECIMAL NOT NULL
);

CREATE TABLE test_records(
    test_record_id SERIAL PRIMARY KEY,
    test_id INT REFERENCES diagnostics(test_id) NOT NULL,
    doctor_id INT REFERENCES doctors(doctor_id) NOT NULL,
    patient_id INT REFERENCES patients(patient_id) NOT NULL,
    admission_id INT REFERENCES admissions(admission_id),
    test_date DATE NOT NULL,
    result_summary VARCHAR(150),
    result_ready BOOLEAN NOT NULL,
    abnormal_result BOOLEAN,
    cost DECIMAL
);

CREATE TABLE patient_diagnosis(
    patient_diagnosis_id SERIAL PRIMARY KEY,
    diagnosis VARCHAR(150),
    disease_id INT REFERENCES diseases(disease_id),
    patient_id INT REFERENCES patients(patient_id) NOT NULL,
    doctor_id INT REFERENCES doctors(doctor_id) NOT NULL,
    admission_id INT REFERENCES admissions(admission_id),
    diagnosis_date DATE NOT NULL,
    test_record_id INT REFERENCES test_records(test_record_id),
    notes VARCHAR(400)
);

CREATE TABLE outcomes(
    outcome_id SERIAL PRIMARY KEY,
    patient_diagnosis_id INT REFERENCES patient_diagnosis(patient_diagnosis_id),
    admission_id INT REFERENCES admissions(admission_id),
    discharged BOOLEAN,
    death BOOLEAN,
    complications BOOLEAN,
    follow_up_required BOOLEAN,
    follow_up_date DATE
);

CREATE TABLE billing(
    bill_id SERIAL PRIMARY KEY,
    admission_id INT REFERENCES admissions(admission_id) NOT NULL,
    patient_id INT REFERENCES patients(patient_id) NOT NULL,
    total_amount DECIMAL NOT NULL,
    billing_date DATE NOT NULL
);   

-- Table edits for propper integrity

-- while making the tables i realized there were a couple of things that needed to be added to ensure logic and data integrity

