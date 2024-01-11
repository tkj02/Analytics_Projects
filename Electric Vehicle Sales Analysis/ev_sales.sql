-- What does the dataset look like?
SELECT * FROM ev_sales ORDER BY "Make" ASC;

-- Drops unnecessary column
ALTER TABLE ev_sales DROP COLUMN "Logo";

-- How many entries are there?
SELECT COUNT(*) FROM ev_sales;

-- What are the column names and their data types?
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'ev_sales';

-- Columns for May through Dec 2019 are of type 'character varying'
-- Want this to be numeric for later calculations
-- Replaces empty strings with '0' in May through Nov 2019
UPDATE ev_sales SET "May 2019" = '0' WHERE "May 2019" = ''; 
UPDATE ev_sales SET "juin-19" = '0' WHERE "juin-19" = ''; 
UPDATE ev_sales SET "juil-19" = '0' WHERE "juil-19" = ''; 
UPDATE ev_sales SET "Aug 2019" = '0' WHERE "Aug 2019" = ''; 
UPDATE ev_sales SET "sept-19" = '0' WHERE "sept-19" = ''; 
UPDATE ev_sales SET "oct-19" = '0' WHERE "oct-19" = ''; 
UPDATE ev_sales SET "nov-19" = '0' WHERE "nov-19" = '';
 
-- Attempts to view casting after trim on May 2019
-- This results in an error with a particular entry
UPDATE ev_sales SET "May 2019" = TRIM("May 2019");
SELECT CAST("May 2019" AS INT) FROM ev_sales;

-- Turns out there are hidden junk characters in several entries
-- It's more efficient to clean data for these months in Excel and import changes
-- Changes are saved in the table cleaned_ev_sales
SELECT * FROM cleaned_ev_sales;

-- Adds id columns to tables
ALTER TABLE ev_sales ADD COLUMN id SERIAL PRIMARY KEY;
ALTER TABLE cleaned_ev_sales ADD COLUMN id SERIAL PRIMARY KEY;

-- Removes columns with junk data from main table
ALTER TABLE ev_sales 
DROP COLUMN "May 2019",
DROP COLUMN "juin-19",
DROP COLUMN "juil-19",
DROP COLUMN "Aug 2019",
DROP COLUMN "sept-19",
DROP COLUMN "oct-19",
DROP COLUMN "nov-19",
DROP COLUMN "Dec 2019";

-- View of main table with cleaned data
-- Will use a similar join method for 2019 data calculations
-- Note: this view contains both table's id columns
SELECT * FROM ev_sales FULL OUTER JOIN cleaned_ev_sales
ON ev_sales.id = cleaned_ev_sales.id
ORDER BY "Make" ASC;

-- What are the unique Makes and Models?
SELECT DISTINCT("Make") FROM ev_sales ORDER BY "Make" ASC;
SELECT DISTINCT("Model") FROM ev_sales ORDER BY "Model" ASC;
 
-- What was each Make's quarterly and total sales in 2012?
WITH quarters AS (
	SELECT "Make", COALESCE(SUM("janv-12")+SUM("Feb 2012")+SUM("mars-12"), 0) AS q1_12,
			COALESCE(SUM("Apr 2012")+SUM("May 2012")+SUM("juin-12"), 0) AS q2_12,
			COALESCE(SUM("juil-12")+SUM("Aug 2012")+SUM("sept-12"), 0) AS q3_12,
			COALESCE(SUM("oct-12")+SUM("nov-12")+SUM("Dec 2012"), 0) AS q4_12
	FROM ev_sales
	GROUP BY "Make"
	ORDER BY "Make" ASC
)
SELECT "Make", SUM(q1_12) AS q1_12, SUM(q2_12) AS q2_12,
		SUM(q3_12) AS q3_12, SUM(q4_12) AS q4_12,
		SUM(q1_12)+SUM(q2_12)+SUM(q3_12)+SUM(q4_12) AS total_sales_12
FROM quarters
GROUP BY "Make"
ORDER BY total_sales_12 DESC;

-- What was each Make's quarterly and total sales in 2013?
WITH quarters AS (
	SELECT "Make", COALESCE(SUM("janv-13")+SUM("Feb 2013")+SUM("mars-13"), 0) AS q1_13,
			COALESCE(SUM("Apr 2013")+SUM("May 2013")+SUM("juin-13"), 0) AS q2_13,
			COALESCE(SUM("juil-13")+SUM("Aug 2013")+SUM("sept-13"), 0) AS q3_13,
			COALESCE(SUM("oct-13")+SUM("nov-13")+SUM("Dec 2013"), 0) AS q4_13
	FROM ev_sales
	GROUP BY "Make"
	ORDER BY "Make" ASC
)
SELECT "Make", SUM(q1_13) AS q1_13, SUM(q2_13) AS q2_13,
		SUM(q3_13) AS q3_13, SUM(q4_13) AS q4_13,
		SUM(q1_13)+SUM(q2_13)+SUM(q3_13)+SUM(q4_13) AS total_sales_13
FROM quarters
GROUP BY "Make"
ORDER BY total_sales_13 DESC;

-- What was each Make's quarterly and total sales in 2014?
WITH quarters AS (
	SELECT "Make", COALESCE(SUM("janv-14")+SUM("Feb 2014")+SUM("mars-14"), 0) AS q1_14,
			COALESCE(SUM("Apr 2014")+SUM("May 2014")+SUM("juin-14"), 0) AS q2_14,
			COALESCE(SUM("juil-14")+SUM("Aug 2014")+SUM("sept-14"), 0) AS q3_14,
			COALESCE(SUM("oct-14")+SUM("nov-14")+SUM("Dec 2014"), 0) AS q4_14
	FROM ev_sales
	GROUP BY "Make"
	ORDER BY "Make" ASC
)
SELECT "Make", SUM(q1_14) AS q1_14, SUM(q2_14) AS q2_14,
		SUM(q3_14) AS q3_14, SUM(q4_14) AS q4_14,
		SUM(q1_14)+SUM(q2_14)+SUM(q3_14)+SUM(q4_14) AS total_sales_14
FROM quarters
GROUP BY "Make"
ORDER BY total_sales_14 DESC;

-- What was each Make's quarterly and total sales in 2015?
WITH quarters AS (
	SELECT "Make", COALESCE(SUM("janv-15")+SUM("Feb 2015")+SUM("mars-15"), 0) AS q1_15,
			COALESCE(SUM("Apr 2015")+SUM("May 2015")+SUM("juin-15"), 0) AS q2_15,
			COALESCE(SUM("juil-15")+SUM("Aug 2015")+SUM("sept-15"), 0) AS q3_15,
			COALESCE(SUM("oct-15")+SUM("nov-15")+SUM("Dec 2015"), 0) AS q4_15
	FROM ev_sales
	GROUP BY "Make"
	ORDER BY "Make" ASC
)
SELECT "Make", SUM(q1_15) AS q1_15, SUM(q2_15) AS q2_15,
		SUM(q3_15) AS q3_15, SUM(q4_15) AS q4_15,
		SUM(q1_15)+SUM(q2_15)+SUM(q3_15)+SUM(q4_15) AS total_sales_15
FROM quarters
GROUP BY "Make"
ORDER BY total_sales_15 DESC;

-- What was each Make's quarterly and total sales in 2016?
WITH quarters AS (
	SELECT "Make", COALESCE(SUM("janv-16")+SUM("Feb 2016")+SUM("mars-16"), 0) AS q1_16,
			COALESCE(SUM("Apr 2016")+SUM("May 2016")+SUM("juin-16"), 0) AS q2_16,
			COALESCE(SUM("juil-16")+SUM("Aug 2016")+SUM("sept-16"), 0) AS q3_16,
			COALESCE(SUM("oct-16")+SUM("nov-16")+SUM("Dec 2016"), 0) AS q4_16
	FROM ev_sales
	GROUP BY "Make"
	ORDER BY "Make" ASC
)
SELECT "Make", SUM(q1_16) AS q1_16, SUM(q2_16) AS q2_16,
		SUM(q3_16) AS q3_16, SUM(q4_16) AS q4_16,
		SUM(q1_16)+SUM(q2_16)+SUM(q3_16)+SUM(q4_16) AS total_sales_16
FROM quarters
GROUP BY "Make"
ORDER BY total_sales_16 DESC;

-- What was each Make's quarterly and total sales in 2017?
WITH quarters AS (
	SELECT "Make", COALESCE(SUM("janv-17")+SUM("Feb 2017")+SUM("mars-17"), 0) AS q1_17,
			COALESCE(SUM("Apr 2017")+SUM("May 2017")+SUM("juin-17"), 0) AS q2_17,
			COALESCE(SUM("juil-17")+SUM("Aug 2017")+SUM("sept-17"), 0) AS q3_17,
			COALESCE(SUM("oct-17")+SUM("nov-17")+SUM("Dec 2017"), 0) AS q4_17
	FROM ev_sales
	GROUP BY "Make"
	ORDER BY "Make" ASC
)
SELECT "Make", SUM(q1_17) AS q1_17, SUM(q2_17) AS q2_17,
		SUM(q3_17) AS q3_17, SUM(q4_17) AS q4_17,
		SUM(q1_17)+SUM(q2_17)+SUM(q3_17)+SUM(q4_17) AS total_sales_17
FROM quarters
GROUP BY "Make"
ORDER BY total_sales_17 DESC;

-- What was each Make's quarterly and total sales in 2018?
WITH quarters AS (
	SELECT "Make", COALESCE(SUM("janv-18")+SUM("Feb 2018")+SUM("mars-18"), 0) AS q1_18,
			COALESCE(SUM("Apr 2018")+SUM("May 2018")+SUM("juin-18"), 0) AS q2_18,
			COALESCE(SUM("juil-18")+SUM("Aug 2018")+SUM("sept-18"), 0) AS q3_18,
			COALESCE(SUM("oct-18")+SUM("nov-18")+SUM("Dec 2018"), 0) AS q4_18
	FROM ev_sales
	GROUP BY "Make"
	ORDER BY "Make" ASC
)
SELECT "Make", SUM(q1_18) AS q1_18, SUM(q2_18) AS q2_18,
		SUM(q3_18) AS q3_18, SUM(q4_18) AS q4_18,
		SUM(q1_18)+SUM(q2_18)+SUM(q3_18)+SUM(q4_18) AS total_sales_18
FROM quarters
GROUP BY "Make"
ORDER BY total_sales_18 DESC;
 
-- What was each make's total sales in 2019?
WITH joined AS (
	SELECT "Make", COALESCE(SUM("janv-19")+SUM("Feb 2019")+SUM("mars-19"), 0) AS q1_19,
			COALESCE(SUM("Apr 2019")+SUM(ces."May 2019")+SUM(ces."juin-19"), 0) AS q2_19,
			COALESCE(SUM(ces."juil-19")+SUM(ces."Aug 2019")+SUM(ces."sept-19"), 0) AS q3_19,
			COALESCE(SUM(ces."oct-19")+SUM(ces."nov-19")+SUM(ces."Dec 2019"), 0) AS q4_19
	FROM ev_sales FULL OUTER JOIN cleaned_ev_sales as ces
	ON ev_sales.id = ces.id
	GROUP BY "Make"
	ORDER BY "Make" ASC
)
SELECT "Make", SUM(q1_19) AS q1_19, SUM(q2_19) AS q2_19,
		SUM(q3_19) AS q3_19, SUM(q4_19) AS q4_19,
		SUM(q1_19)+SUM(q2_19)+SUM(q3_19)+SUM(q4_19) AS total_sales_19
FROM joined
GROUP BY "Make"
ORDER BY total_sales_19 DESC;

-- How much did each Make have in sales across all years (2012-19)?
WITH
quarters_12 AS (
	SELECT "Make", COALESCE(SUM("janv-12")+SUM("Feb 2012")+SUM("mars-12"), 0) AS q1_12,
			COALESCE(SUM("Apr 2012")+SUM("May 2012")+SUM("juin-12"), 0) AS q2_12,
			COALESCE(SUM("juil-12")+SUM("Aug 2012")+SUM("sept-12"), 0) AS q3_12,
			COALESCE(SUM("oct-12")+SUM("nov-12")+SUM("Dec 2012"), 0) AS q4_12
	FROM ev_sales
	GROUP BY "Make"
	ORDER BY "Make" ASC
),
quarters_13 AS (
	SELECT "Make", COALESCE(SUM("janv-13")+SUM("Feb 2013")+SUM("mars-13"), 0) AS q1_13,
			COALESCE(SUM("Apr 2013")+SUM("May 2013")+SUM("juin-13"), 0) AS q2_13,
			COALESCE(SUM("juil-13")+SUM("Aug 2013")+SUM("sept-13"), 0) AS q3_13,
			COALESCE(SUM("oct-13")+SUM("nov-13")+SUM("Dec 2013"), 0) AS q4_13
	FROM ev_sales
	GROUP BY "Make"
	ORDER BY "Make" ASC
),
quarters_14 AS (
	SELECT "Make", COALESCE(SUM("janv-14")+SUM("Feb 2014")+SUM("mars-14"), 0) AS q1_14,
			COALESCE(SUM("Apr 2014")+SUM("May 2014")+SUM("juin-14"), 0) AS q2_14,
			COALESCE(SUM("juil-14")+SUM("Aug 2014")+SUM("sept-14"), 0) AS q3_14,
			COALESCE(SUM("oct-14")+SUM("nov-14")+SUM("Dec 2014"), 0) AS q4_14
	FROM ev_sales
	GROUP BY "Make"
	ORDER BY "Make" ASC
),
quarters_15 AS (
	SELECT "Make", COALESCE(SUM("janv-15")+SUM("Feb 2015")+SUM("mars-15"), 0) AS q1_15,
			COALESCE(SUM("Apr 2015")+SUM("May 2015")+SUM("juin-15"), 0) AS q2_15,
			COALESCE(SUM("juil-15")+SUM("Aug 2015")+SUM("sept-15"), 0) AS q3_15,
			COALESCE(SUM("oct-15")+SUM("nov-15")+SUM("Dec 2015"), 0) AS q4_15
	FROM ev_sales
	GROUP BY "Make"
	ORDER BY "Make" ASC
),
quarters_16 AS (
	SELECT "Make", COALESCE(SUM("janv-16")+SUM("Feb 2016")+SUM("mars-16"), 0) AS q1_16,
			COALESCE(SUM("Apr 2016")+SUM("May 2016")+SUM("juin-16"), 0) AS q2_16,
			COALESCE(SUM("juil-16")+SUM("Aug 2016")+SUM("sept-16"), 0) AS q3_16,
			COALESCE(SUM("oct-16")+SUM("nov-16")+SUM("Dec 2016"), 0) AS q4_16
	FROM ev_sales
	GROUP BY "Make"
	ORDER BY "Make" ASC
),
quarters_17 AS (
	SELECT "Make", COALESCE(SUM("janv-17")+SUM("Feb 2017")+SUM("mars-17"), 0) AS q1_17,
			COALESCE(SUM("Apr 2017")+SUM("May 2017")+SUM("juin-17"), 0) AS q2_17,
			COALESCE(SUM("juil-17")+SUM("Aug 2017")+SUM("sept-17"), 0) AS q3_17,
			COALESCE(SUM("oct-17")+SUM("nov-17")+SUM("Dec 2017"), 0) AS q4_17
	FROM ev_sales
	GROUP BY "Make"
	ORDER BY "Make" ASC
),
quarters_18 AS (
	SELECT "Make", COALESCE(SUM("janv-18")+SUM("Feb 2018")+SUM("mars-18"), 0) AS q1_18,
			COALESCE(SUM("Apr 2018")+SUM("May 2018")+SUM("juin-18"), 0) AS q2_18,
			COALESCE(SUM("juil-18")+SUM("Aug 2018")+SUM("sept-18"), 0) AS q3_18,
			COALESCE(SUM("oct-18")+SUM("nov-18")+SUM("Dec 2018"), 0) AS q4_18
	FROM ev_sales
	GROUP BY "Make"
	ORDER BY "Make" ASC
),
quarters_19 AS (
	SELECT "Make", COALESCE(SUM("janv-19")+SUM("Feb 2019")+SUM("mars-19"), 0) AS q1_19,
			COALESCE(SUM("Apr 2019")+SUM(ces."May 2019")+SUM(ces."juin-19"), 0) AS q2_19,
			COALESCE(SUM(ces."juil-19")+SUM(ces."Aug 2019")+SUM(ces."sept-19"), 0) AS q3_19,
			COALESCE(SUM(ces."oct-19")+SUM(ces."nov-19")+SUM(ces."Dec 2019"), 0) AS q4_19
	FROM ev_sales FULL OUTER JOIN cleaned_ev_sales as ces
	ON ev_sales.id = ces.id
	GROUP BY "Make"
	ORDER BY "Make" ASC
)
SELECT "Make", total_sales_12+total_sales_13+total_sales_14+total_sales_15+
	   total_sales_16+total_sales_17+total_sales_18+total_sales_19 AS total
FROM (
	SELECT quarters_12."Make",
		   SUM(q1_12)+SUM(q2_12)+SUM(q3_12)+SUM(q4_12) AS total_sales_12,
		   SUM(q1_13)+SUM(q2_13)+SUM(q3_13)+SUM(q4_13) AS total_sales_13,
		   SUM(q1_14)+SUM(q2_14)+SUM(q3_14)+SUM(q4_14) AS total_sales_14,
		   SUM(q1_15)+SUM(q2_15)+SUM(q3_15)+SUM(q4_15) AS total_sales_15,
		   SUM(q1_16)+SUM(q2_16)+SUM(q3_16)+SUM(q4_16) AS total_sales_16,
		   SUM(q1_17)+SUM(q2_17)+SUM(q3_17)+SUM(q4_17) AS total_sales_17,
		   SUM(q1_18)+SUM(q2_18)+SUM(q3_18)+SUM(q4_18) AS total_sales_18,
		   SUM(q1_19)+SUM(q2_19)+SUM(q3_19)+SUM(q4_19) AS total_sales_19
	FROM quarters_12 JOIN quarters_13 ON quarters_12."Make" = quarters_13."Make"
		 JOIN quarters_14 ON quarters_13."Make" = quarters_14."Make"
		 JOIN quarters_15 ON quarters_14."Make" = quarters_15."Make"
		 JOIN quarters_16 ON quarters_15."Make" = quarters_16."Make"
		 JOIN quarters_17 ON quarters_16."Make" = quarters_17."Make"
		 JOIN quarters_18 ON quarters_17."Make" = quarters_18."Make"
		 JOIN quarters_19 ON quarters_18."Make" = quarters_19."Make"
GROUP BY quarters_12."Make")
ORDER BY total DESC;

