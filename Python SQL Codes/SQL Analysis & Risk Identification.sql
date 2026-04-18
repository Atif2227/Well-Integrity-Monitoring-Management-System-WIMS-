-- Step 5.1: Identify Abnormal Well Operating Conditions (Sensors)
-- Goal: Find wells operating outside safe pressure limits.

SELECT
    w.well_name,
    w.field_name,
    s.reading_datetime,
    s.annular_pressure,
    s.tubing_pressure
FROM well_sensor_readings s
JOIN wells w
    ON s.well_id = w.well_id
WHERE s.annular_pressure > 4000
   OR s.tubing_pressure > 3500
ORDER BY s.reading_datetime DESC;

-- What this shows:
-- Wells that may have integrity risk due to high pressure, which is a key WIMS use case.
--------------------------------------------------------------------------------------------
-- Step 5.2: Wells with Repeated Integrity Failures
-- Goal: Identify wells with multiple integrity events.
SELECT
    w.well_name,
    COUNT(e.event_id) AS failure_count
FROM well_integrity_events e
JOIN wells w
    ON e.well_id = w.well_id
GROUP BY w.well_name
HAVING COUNT(e.event_id) >= 2
ORDER BY failure_count DESC;

-- What this shows:
-- Problem wells that need investigation or intervention.
-----------------------------------------------------------------------

-- Step 5.3: Failed or Overdue Inspections
-- Goal: Find wells failing inspections or not inspected recently.

-- Failed inspections
SELECT
    w.well_name,
    i.inspection_date,
    i.inspection_type
FROM well_inspections i
JOIN wells w
    ON i.well_id = w.well_id
WHERE i.inspection_result = 'Fail';

-- Overdue inspections (no inspection in last 12 months)
SELECT
    w.well_name,
    MAX(i.inspection_date) AS last_inspection_date
FROM wells w
LEFT JOIN well_inspections i
    ON w.well_id = i.well_id
GROUP BY w.well_name
HAVING MAX(i.inspection_date) < DATEADD(YEAR, -1, GETDATE())
    OR MAX(i.inspection_date) IS NULL;

-- What this shows:
-- Compliance gaps — very important in well integrity management.
------------------------------------------------------------------------------

-- Step 5.4: Simple Well Risk Classification
-- Goal: Classify wells as High / Medium / Low risk.
SELECT
    w.well_name,
    CASE
        WHEN COUNT(e.event_id) >= 2 THEN 'High Risk'
        WHEN COUNT(e.event_id) = 1 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS risk_level
FROM wells w
LEFT JOIN well_integrity_events e
    ON w.well_id = e.well_id
GROUP BY w.well_name;

-- What this shows:
-- A business‑friendly risk view that feeds directly into dashboards