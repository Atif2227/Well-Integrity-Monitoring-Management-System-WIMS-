-- 1. Well Master Table
CREATE TABLE wells (
    well_id INT IDENTITY(1,1) PRIMARY KEY,
    well_name VARCHAR(50) NOT NULL,
    field_name VARCHAR(50),
    location_type VARCHAR(20),   -- Onshore / Offshore
    well_type VARCHAR(20),       -- Producer / Injector
    completion_date VARCHAR(30),
    current_status VARCHAR(20)   -- Active / Suspended / Abandoned
);

-------------------------------------------------

-- 2. Sensor & Monitoring Data
CREATE TABLE sensorreadings (
    reading_id INT IDENTITY(1,1) PRIMARY KEY,
    well_id INT NOT NULL,
    reading_datetime VARCHAR(30),
    annular_pressure FLOAT,
    tubing_pressure FLOAT,
    temperature FLOAT,
    flow_rate FLOAT,
    CONSTRAINT fk_sensor_well
        FOREIGN KEY (well_id) REFERENCES wells(well_id)
);
-------------------------------------------------


-- 3. Integrity Inspection Records
CREATE TABLE Inspections (
    inspection_id INT IDENTITY(1,1) PRIMARY KEY,
    well_id INT NOT NULL,
    inspection_date VARCHAR(30),
    inspection_type VARCHAR(50),
    inspection_result VARCHAR(10),  -- Pass / Fail
    inspector_name VARCHAR(50),
    comments VARCHAR(255),
    CONSTRAINT fk_inspection_well
        FOREIGN KEY (well_id) REFERENCES wells(well_id)
);
-------------------------------------------------

-- 4. Integrity Failures & Incidents
CREATE TABLE IntegrityEvents (
    event_id INT IDENTITY(1,1) PRIMARY KEY,
    well_id INT NOT NULL,
    event_date VARCHAR(30),
    failure_type VARCHAR(50),
    severity_level VARCHAR(10),   -- Low / Medium / High
    root_cause VARCHAR(100),
    event_status VARCHAR(20),     -- Open / Closed
    CONSTRAINT fk_event_well
        FOREIGN KEY (well_id) REFERENCES wells(well_id)
);
------------------------------------------------

-- 5. Maintenance & Workover Logs
CREATE TABLE Maintenance (
    maintenance_id INT IDENTITY(1,1) PRIMARY KEY,
    well_id INT NOT NULL,
    maintenance_date VARCHAR(30),
    maintenance_type VARCHAR(50),
    description VARCHAR(255),
    cost_estimate DECIMAL(12,2),
    CONSTRAINT fk_maintenance_well
        FOREIGN KEY (well_id) REFERENCES wells(well_id)
);
------------------------------------
Sevrver Name: BRW03WFTATHASD