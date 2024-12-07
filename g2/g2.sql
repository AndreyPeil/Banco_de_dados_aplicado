CREATE TABLE Patients (
    patient_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    date_of_birth DATE,
    gender VARCHAR(10),
    address VARCHAR(150),
    smoker BOOLEAN,
    contact_number VARCHAR(15),
    registration_date DATE
);

-- Tabela: Registros Médicos
CREATE TABLE Medical_Records (
    record_id SERIAL PRIMARY KEY,
    patient_id INT,
    diagnosis_code VARCHAR(10),
    treatment_id INT,
    doctor_id INT,
    visit_date DATE,
    severity INT, -- 1 = leve, 2 = grave
    outcome BOOLEAN, -- TRUE = sucesso, FALSE = falha
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

-- Tabela: Tratamentos
CREATE TABLE Treatments (
    treatment_id SERIAL PRIMARY KEY,
    treatment_type VARCHAR(100),
    cost FLOAT,
    active BOOLEAN
);

-- Tabela: Médicos
CREATE TABLE Doctors (
    doctor_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    specialty VARCHAR(50),
    years_of_experience INT,
    current_hospital VARCHAR(100)
);

-- Tabela: Diagnósticos
CREATE TABLE Diagnoses (
    diagnosis_code VARCHAR(10) PRIMARY KEY,
    diagnosis_name VARCHAR(100),
    risk_factor VARCHAR(100)
);

-- Inserção de Dados nas Tabelas
-- Populando Pacientes
INSERT INTO Patients (name, date_of_birth, gender, address, smoker, contact_number, registration_date)
SELECT 
    CONCAT('Paciente_', i)::TEXT AS name,
    TO_DATE('19' || LPAD((60 + i)::TEXT, 2, '0') || '-01-01', 'YYYY-MM-DD') AS date_of_birth,
    CASE WHEN i % 2 = 0 THEN 'Male' ELSE 'Female' END AS gender,
    CONCAT('Rua ', i, ', Bairro ', i)::TEXT AS address,
    CASE WHEN i % 3 = 0 THEN TRUE ELSE FALSE END AS smoker,
    CONCAT('(11) 9', LPAD(i::TEXT, 4, '0'), '-', LPAD(i::TEXT, 4, '0'))::TEXT AS contact_number,
    '2023-01-01'::DATE AS registration_date
FROM generate_series(1, 50) AS s(i);


-- Populando Diagnósticos
INSERT INTO Diagnoses (diagnosis_code, diagnosis_name, risk_factor)
VALUES 
('D01', 'Diabetes', 'Obesidade'),
('D02', 'Hipertensão', 'Fumante'),
('D03', 'Doença Cardíaca', 'Colesterol Elevado'),
('D04', 'Asma', 'Histórico Familiar'),
('D05', 'Câncer de Pulmão', 'Fumante');

-- Populando Tratamentos
INSERT INTO Treatments (treatment_type, cost, active)
SELECT 
    CONCAT('Tratamento_', i),
    i * 100.0,
    CASE WHEN i % 2 = 0 THEN TRUE ELSE FALSE END
FROM generate_series(1, 50) AS i;

-- Populando Médicos
INSERT INTO Doctors (name, specialty, years_of_experience, current_hospital)
SELECT 
    CONCAT('Médico_', i),
    CASE WHEN i % 3 = 0 THEN 'Cardiologia' 
         WHEN i % 3 = 1 THEN 'Pneumologia' 
         ELSE 'Clínico Geral' END,
    i % 30,
    CONCAT('Hospital_', i)
FROM generate_series(1, 50) AS i;

-- Populando Registros Médicos
INSERT INTO Medical_Records (patient_id, diagnosis_code, treatment_id, doctor_id, visit_date, severity, outcome)
SELECT 
    (i % 50) + 1,
    CASE WHEN i % 5 = 0 THEN 'D01'
         WHEN i % 5 = 1 THEN 'D02'
         WHEN i % 5 = 2 THEN 'D03'
         WHEN i % 5 = 3 THEN 'D04'
         ELSE 'D05' END,
    (i % 50) + 1,
    (i % 50) + 1,
    '2023-01-01'::DATE + (i % 365),
    (i % 2) + 1,
    CASE WHEN i % 4 = 0 THEN TRUE ELSE FALSE END
FROM generate_series(1, 50) AS i;



create table dim_patient(
	patient_sk serial primary key,
	patient_id int not null,
	active bool default true not null,
	smoker bool not null,
	gender varchar(10) not null,
	address varchar(150) not null,
	registration_date DATE,
	effective_date DATE NOT NULL,
    end_date DATE
);


create table dim_diagnoses(
	diagnose_sk serial primary key,
	diagnose_id int not null,
	diagnosis_name varchar(100) not null,
	risk_factor varchar(100) not null
);

create table dim_treatment (
	treatment_sk serial primary key,
	treatment_id int not null,
	active bool default true not null,
	treatment varchar(100) not null,
	cost float not null,
	treatment_type VARCHAR(100)
);


create table dim_date(
	date_sk serial primary key,
    full_date date UNIQUE,
    year int,
    month int,
    day int,
    day_of_week varchar(15)
);

CREATE TABLE dim_doctor (
    doctor_sk serial primary key,
    doctor_id int, 
    name varchar(100),
    specialty varchar(50),
    years_of_experience int,
    current_hospital varchar(100)
);

create table fact_health_records (
    fact_id serial primary key,
    patient_sk int not null, 
    diagnose_sk int not null, 
    treatment_sk int not null,
    doctor_sk int not null, 
    date_sk int not null, 
    total_cost float,
    severity int, 
    outcome boolean, 
    foreign key (patient_sk) references dim_patient(patient_sk),
    foreign key (diagnose_sk) references dim_diagnoses(diagnose_sk),
    foreign key (treatment_sk) references dim_treatment(treatment_sk),
    foreign key (doctor_sk) references dim_doctor(doctor_sk),
    foreign key (date_sk) references dim_date(date_sk)
);


-- dim pacientes
INSERT INTO dim_patient (patient_id, active, smoker, gender, address, birth_data,registration_date, effective_date)
SELECT 
    patient_id,
    TRUE AS active,  --true pra todos
    smoker,
    gender,
    address,
    date_of_birth,
    registration_date,
    registration_date 
FROM Patients;


-- dim_diagnoses
INSERT INTO dim_diagnoses (diagnose_id, diagnosis_name, risk_factor)
SELECT 
     diagnosis_code AS diagnose_id, 
    diagnosis_name, 
    risk_factor
FROM Diagnoses;


-- dim_treatment
INSERT INTO dim_treatment (treatment_id, active, treatment, cost, treatment_type)
SELECT 
    treatment_id,
    active,
    treatment_type AS treatment,
    cost,
    treatment_type
FROM Treatments;


-- dim_doctor
INSERT INTO dim_doctor (doctor_id, name, specialty, years_of_experience, current_hospital)
SELECT 
    doctor_id,
    name,
    specialty,
    years_of_experience,
    current_hospital
FROM Doctors;


-- dim_date
INSERT INTO dim_date (full_date, year, month, day, day_of_week)
SELECT 
    DISTINCT visit_date AS full_date,
    EXTRACT(YEAR FROM visit_date) AS year,
    EXTRACT(MONTH FROM visit_date) AS month,
    EXTRACT(DAY FROM visit_date) AS day,
    TO_CHAR(visit_date, 'Day') AS day_of_week
FROM Medical_Records;



-- fatos prrencher
INSERT INTO fact_health_records (patient_sk, diagnose_sk, treatment_sk, doctor_sk, date_sk, total_cost, severity, outcome)
SELECT 
    p.patient_sk,
    d.diagnose_sk,
    t.treatment_sk,
    doc.doctor_sk,
    dt.date_sk,
    t.cost AS total_cost,
    m.severity,
    m.outcome
FROM Medical_Records m
JOIN dim_patient p ON m.patient_id = p.patient_id
JOIN dim_diagnoses d ON m.diagnosis_code = (
    SELECT diagnosis_code FROM Diagnoses 
    WHERE Diagnoses.diagnosis_name = d.diagnosis_name LIMIT 1
)
JOIN dim_treatment t ON m.treatment_id = t.treatment_id
JOIN dim_doctor doc ON m.doctor_id = doc.doctor_id
JOIN dim_date dt ON m.visit_date = dt.full_date;



-- 1
SELECT 
    dp.address AS region,
    dd.year,
    SUM(fhr.total_cost) AS total_treatment_cost
FROM 
    fact_health_records fhr
JOIN dim_patient dp ON fhr.patient_sk = dp.patient_sk
JOIN dim_date dd ON fhr.date_sk = dd.date_sk
GROUP BY 
    dp.address, dd.year
ORDER BY 
    dp.address, dd.year;

-- 2
   SELECT 
    dd.diagnosis_name,
    COUNT(DISTINCT fhr.patient_sk) AS count_smokers
FROM 
    fact_health_records fhr
JOIN dim_patient dp ON fhr.patient_sk = dp.patient_sk
JOIN dim_diagnoses dd ON fhr.diagnose_sk = dd.diagnose_sk
WHERE 
    dp.smoker = TRUE
    AND fhr.severity = 2
GROUP BY 
    dd.diagnosis_name
ORDER BY 
    count_smokers DESC;
   
-- 3
SELECT 
    dd.name AS doctor_name,
    COUNT(CASE WHEN fhr.outcome = TRUE THEN 1 END) * 100.0 / COUNT(*) AS success_rate
FROM 
    fact_health_records fhr
JOIN dim_doctor dd ON fhr.doctor_sk = dd.doctor_sk
GROUP BY 
    dd.name  
ORDER BY 
    success_rate DESC, dd.name;
   
   
   
   
--busca exportar dados
   SELECT 
    dp.gender AS patient_gender,
    dp.smoker AS is_smoker,
    DATE_PART('year', AGE(dp.birth_data)) AS age,
    dt.treatment_type,
    dt.cost AS treatment_cost,
    ddx.diagnosis_name,
    ddx.risk_factor,
    fhr.severity,
    fhr.outcome
FROM 
    fact_health_records fhr
JOIN dim_patient dp ON fhr.patient_sk = dp.patient_sk
JOIN dim_treatment dt ON fhr.treatment_sk = dt.treatment_sk
JOIN dim_diagnoses ddx ON fhr.diagnose_sk = ddx.diagnose_sk
JOIN dim_date dd ON fhr.date_sk = dd.date_sk;
