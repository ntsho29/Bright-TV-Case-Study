-- Databricks notebook source

--------------------------------------------------
-- Checking all the columns in the table viewrship
--------------------------------------------------
SELECT *
FROM `tv_data`.`dataset_tv_casestudy`.`viewership` limit 10;

--------------------------------------------------
-- Checking if there is any row where in the column userid0 is empty
--------------------------------------------------
SELECT *
FROM `tv_data`.`dataset_tv_casestudy`.`viewership`
WHERE UserID0 IS NULL 
    OR userid4 IS NULL;
------------------------------------------------------
SELECT *
FROM `tv_data`.`dataset_tv_casestudy`.`viewership`
WHERE userid0 <> userid4;

----------------------------------------------------------
-- Checking for duplicates
----------------------------------------------------------
SELECT COUNT(*),
       UserID0, RecordDate2
FROM `tv_data`.`dataset_tv_casestudy`.`viewership`
GROUP BY UserID0, RecordDate2
HAVING COUNT(*)>1;

SELECT
    UserID0,
    RecordDate2,
    COUNT(*) AS duplicate_count
FROM workspace.default.viewership
GROUP BY
    UserID0,
    RecordDate2
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;
----------------------------------------
SELECT UserID0,
       TO_DATE(RecordDate2) AS watch_date,
       date_format(RecordDate2, 'HH:mm:ss') AS watch_time,
       date_format(Duration 2, 'HH:mm:ss') AS duration,
        Channel2
FROM workspace.default.viewership
WHERE userid0=810044;



WITH ranked_records AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY
                UserID0,
                TO_DATE(RecordDate2),
                date_format(RecordDate2, 'HH:mm:ss'),
                date_format(Duration 2, 'HH:mm:ss'),
                Channel2
            ORDER BY RecordDate2
        ) AS row_num
    FROM workspace.default.viewership
)

SELECT * EXCEPT (row_num)
FROM ranked_records
WHERE row_num = 1;

WITH cte1 AS (
SELECT DISTINCT *
FROM workspace.default.viewership
)
SELECT COUNT(*) AS duplicate_cnt,
       UserID0,
       TO_DATE(RecordDate2) AS watch_date,
       date_format(RecordDate2, 'HH:mm:ss') AS watch_time,
       date_format(Duration 2, 'HH:mm:ss') AS duration,
        Channel2
FROM cte1
--WHERE userid0=810044
GROUP BY ALL
HAVING COUNT(*) > 1
ORDER BY duplicate_cnt DESC
;

SELECT DISTINCT *
FROM workspace.default.viewership

