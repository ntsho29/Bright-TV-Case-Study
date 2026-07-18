-- Databricks notebook source

select *
FROM `tv_data`.`dataset_tv_casestudy`.`viewership` limit 10;


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
