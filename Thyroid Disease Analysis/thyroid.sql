
-- Renames table appropriately
-- thyroidDF.csv -> DBeaver -> public.newtable -> thyroiddata
ALTER TABLE thyroiddf RENAME TO thyroiddata;



-- Confirms there are no duplicates
-- Both queries = 9172, as expected
SELECT COUNT(DISTINCT patient_id) FROM thyroiddata;

SELECT COUNT(*) FROM thyroiddata;



-- Removes unnecessary columns
ALTER TABLE thyroiddata
DROP COLUMN query_on_thyroxine,
DROP COLUMN lithium,
DROP COLUMN psych,
DROP COLUMN referral_source,
DROP COLUMN tsh_measured,
DROP COLUMN t3_measured,
DROP COLUMN tt4_measured,
DROP COLUMN t4u_measured,
DROP COLUMN fti_measured,
DROP COLUMN tbg_measured;



-- Removes incorrect entries by age
-- Only considers patients with realistic ages (<= 130)
DELETE FROM thyroiddata WHERE age>130;



-- Removes normal patients
-- Normal patients are marked by '-' in the target column
-- There were 6671 normal patients (2401 patients remain in table)
DELETE FROM thyroiddata WHERE target='-';

	  
	  
-- Renames contents of sex column and replaces NULL values
UPDATE thyroiddata SET sex='Female' WHERE sex='F';

UPDATE thyroiddata SET sex='Male' WHERE sex='M';

UPDATE thyroiddata SET sex='Other' WHERE sex='';



-- Converts boolean T/F columns into 1/0
-- Allows easier type casting for later
UPDATE thyroiddata 
SET on_thyroxine = CASE
	WHEN on_thyroxine = 't' THEN 1
	ELSE 0
END
WHERE on_thyroxine IS NOT NULL;

UPDATE thyroiddata 
SET on_antithyroid_meds = CASE
	WHEN on_antithyroid_meds = 't' THEN 1
	ELSE 0
END
WHERE on_antithyroid_meds IS NOT NULL;

UPDATE thyroiddata 
SET thyroid_surgery = CASE
	WHEN thyroid_surgery = 't' THEN 1
	ELSE 0
END
WHERE thyroid_surgery IS NOT NULL;

UPDATE thyroiddata 
SET i131_treatment = CASE
	WHEN i131_treatment = 't' THEN 1
	ELSE 0
END
WHERE i131_treatment IS NOT NULL;



-- Classifies patients by age categories and displays relevant info
/*
   Child (1-12)
   Teenager (13-17)
   Adult (18-39)
   Middle Age (40-59)
   Elder (60+)
*/

CREATE TABLE agestats AS (
	SELECT thyroiddata.patient_id, thyroiddata.age,
		   subtable.age_category, sex, tsh, t3, tt4, t4u, fti, tbg,
		   on_thyroxine, on_antithyroid_meds, thyroid_surgery, i131_treatment
	FROM thyroiddata JOIN (
		SELECT patient_id, age,
		CASE
			WHEN age<13 THEN 'Child'
			WHEN age BETWEEN 13 AND 17 THEN 'Teenager'
			WHEN age BETWEEN 18 AND 39 THEN 'Adult'
			WHEN age BETWEEN 40 AND 59 THEN 'Middle Age'
			ELSE 'Elder'
		END AS age_category
		FROM thyroiddata
	) AS subtable
	ON thyroiddata.patient_id = subtable.patient_id
)
ORDER BY age ASC;

SELECT * FROM agestats;



-- Displays number of patients in each age category and their average hormone stats
-- Contains outliers that impact averages
SELECT age_category, sex, COUNT(*) AS num_patients,
	   AVG(tsh) AS avg_tsh, AVG(t3) AS avg_t3, AVG(fti) AS avg_fti
FROM agestats
GROUP BY age_category, sex
ORDER BY CASE age_category
	WHEN 'Child' THEN 1
	WHEN 'Teenager' THEN 2
	WHEN 'Adult' THEN 3
	WHEN 'Middle Age' THEN 4
	ELSE 5
END, CASE sex 
	WHEN 'Male' THEN 1
	WHEN 'Female' THEN 2
	ELSE 3
END;



-- Finds average hormone stats without outliers
-- Excludes patients that are more than 2 standard deviations from average

CREATE TABLE averagestats AS (
	WITH avgstd AS (
		SELECT AVG(tsh) AS avg_tsh, STDDEV(tsh) AS std_tsh,
			   AVG(t3) AS avg_t3, STDDEV(t3) AS std_t3,
			   AVG(fti) AS avg_fti, STDDEV(fti) AS std_fti
		FROM agestats
	)
	SELECT agestats.age_category, agestats.sex, count(*) AS num_patients,
		   AVG(CAST(tsh AS DECIMAL(5,2))) AS avg_tsh,
		   AVG(CAST(t3 AS DECIMAL(5,2))) AS avg_t3,
		   AVG(CAST(fti AS DECIMAL(5,2))) AS avg_fti,
		   SUM(CAST(on_thyroxine AS INT)) AS hypothyroid_med,
		   SUM(CAST(on_antithyroid_meds AS INT)) AS hyperthyroid_med,
		   SUM(CAST(thyroid_surgery AS INT)) AS surgery,
		   SUM(CAST(i131_treatment AS INT)) AS radiation
	FROM agestats
	CROSS JOIN avgstd
	WHERE tsh < (avg_tsh + std_tsh*2) AND tsh > (avg_tsh - std_tsh*2) AND
		  t3 < (avg_t3 + std_t3*2) AND t3 > (avg_t3 - std_t3*2) AND
		  fti < (avg_fti + std_fti*2) AND fti > (avg_fti - std_fti*2)
	GROUP BY agestats.age_category, agestats.sex
	ORDER BY CASE age_category
		WHEN 'Child' THEN 1
		WHEN 'Teenager' THEN 2
		WHEN 'Adult' THEN 3
		WHEN 'Middle Age' THEN 4
		ELSE 5
	END, CASE sex 
		WHEN 'Male' THEN 1
		WHEN 'Female' THEN 2
		ELSE 3
	END
);

SELECT * FROM averagestats;



-- Finds new total number of patients after removing outliers
-- Original 2401 - 1556 from following query = 845 removed
SELECT SUM(num_patients) FROM averagestats;



-- Finds new total of patients underdoing treatment
SELECT SUM(hypothyroid_med) FROM averagestats; -- 240 patients
SELECT SUM(hyperthyroid_med) FROM averagestats; -- 28 patients
SELECT SUM(surgery) FROM averagestats; -- 23 patients
SELECT SUM(radiation) FROM averagestats; -- 28 patients
