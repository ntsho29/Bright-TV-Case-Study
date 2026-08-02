-- Databricks notebook source
select *
FROM `tv_data`.`dataset_tv_casestudy`.`viewership` limit 10;

-- Inspecting our table - find out what is in the table columns 
SELECT *
FROM tv_data.dataset_tv_casestudy.viewership
LIMIT 10;

-- Applying the DATE FUNCTIONS, they allow us to extract days, months, years YYYY-MM-DD  (RecordDate2)
SELECT
    RecordDate2,
    TO_DATE(RecordDate2) AS watch_date -- TO-DATE function helps convert a timestamp into a date YYYY-MM-DD
    FROM tv_data.dataset_tv_casestudy.viewership;

-- extracting the dates using DATE Functions (year, months, day)
SELECT 
    UserID0,
    RecordDate2,
    TO_DATE(RecordDate2) AS watch_date, -- Convert a string into a date YYYY-MM=-DD
    DAYNAME(TO_DATE(RecordDate2))AS day_name, -- Extract the day name 
    MONTHNAME(TO_DATE(RecordDate2)) AS month_name, -- Extracts the month name
    YEAR(TO_DATE(RecordDate2)) AS event_year, -- Extracts the year value
    DAY(TO_DATE(RecordDate2)) AS event_day -- Extracts the day value 
FROM tv_data.dataset_tv_casestudy.viewership;

SELECT
 COUNT(DISTINCT UserID0) AS number_of_subs,
 RecordDate2,
 TO_DATE(RecordDate2) AS watch_date,
 DAYNAME(TO_DATE(RecordDate2)) AS Day_name,
 CASE
    WHEN DAYNAME(TO_DATE(RecordDate2)) IN ('Sat', 'Sun') THEN '02. Weekend'
    ELSE '01. Weekday'
END AS Day_classification,
 MONTHNAME(TO_DATE(RecordDate2)) AS Month_name,
 YEAR(TO_DATE(RecordDate2)) AS Event_year,
 DAY(TO_DATE(RecordDate2)) AS Event_dt
FROM `tv_data`.`dataset_tv_casestudy`.`viewership`
WHERE UserID0 IS NOT NULL
GROUP BY ALL
ORDER BY watch_date DESC;

-----------------------------
--------------Temporary table


CREATE OR REPLACE TEMPORARY TABLE viewership AS (
SELECT
 COUNT(DISTINCT UserID0) AS number_of_subs,
 RecordDate2,
 TO_DATE(RecordDate2) AS watch_date,
 DAYNAME(TO_DATE(RecordDate2)) AS Day_name,
 CASE
    WHEN DAYNAME(TO_DATE(RecordDate2)) IN ('Sat', 'Sun') THEN '02. Weekend'
    ELSE '01. Weekday'
END AS Day_classification,
 MONTHNAME(TO_DATE(RecordDate2)) AS Month_name,
 YEAR(TO_DATE(RecordDate2)) AS Event_year,
 DAY(TO_DATE(RecordDate2)) AS Event_dt
FROM `tv_data`.`dataset_tv_casestudy`.`viewership`
WHERE UserID0 IS NOT NULL
GROUP BY ALL
ORDER BY watch_date DESC);

-- How many people are watching Weekdays and Weekends
SELECT SUM (number_of_subs) AS subs,
        Day_classification
FROM tv_data.dataset_tv_casestudy.viewership
Group BY Day_classification;

-- Inspect the temporary table 
SELECT*
FROM  tv_data.dataset_tv_casestudy.viewership;


