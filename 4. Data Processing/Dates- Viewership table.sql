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


-----------------------------------------------
--------Amendments to the table to convert minutes to seconds and Africa to Johannesurg time
------------------------------------------------
—-Viewership code
Base_viewership AS
(SELECT
COALESCE (UserID0, userid4) AS User_id,-- combining two userids into one
From_UTC_Timestamp(RecordDate2, &#39;Africa/Johannesburg&#39;) AS
RecordDate_SAST,--converting timestamp to SA time
Channel2,
`Duration 2`
FROM brighttv.data.viewership
),
Cleaned_viewership AS
( SELECT
User_id,
RecordDate_SAST,
TO_DATE(RecordDate_SAST) AS watch_date, -- Convert a string into a date YYYY-MM=-DD
DAYNAME(TO_DATE(RecordDate_SAST))AS day_name, -- Extract the day name
MONTHNAME(TO_DATE(RecordDate_SAST)) AS month_name, -- Extracts the month name
YEAR(TO_DATE(RecordDate_SAST)) AS event_year, -- Extracts the year value
DAY(TO_DATE(RecordDate_SAST)) AS event_day, -- Extracts the day value
HOUR(RecordDate_SAST) AS Hour_of_day,--extracts hour of day
CASE
WHEN DAYNAME(TO_DATE(RecordDate_SAST)) IN (&#39;Sat&#39;, &#39;Sun&#39;) THEN
&#39;02. Weekend&#39;
ELSE &#39;01. Weekday&#39;
END AS day_classification,
date_format(RecordDate_SAST, &#39;HH:mm:ss&#39;) AS Watch_time,--converting date format to time
CASE
WHEN watch_time BETWEEN &#39;00:00:00&#39; AND &#39;05:59:59&#39; THEN &#39;01. Midnight&#39;
WHEN watch_time BETWEEN &#39;06:00:00&#39; AND &#39;11:59:59&#39; THEN &#39;02. Morning&#39;

WHEN watch_time BETWEEN &#39;12:00:00&#39; AND &#39;16:59:59&#39; THEN &#39;03.
Afternoon&#39;
WHEN watch_time BETWEEN &#39;17:00:00&#39; AND &#39;23:59:59&#39; THEN &#39;04. Evening&#39;
END AS Time_of_day,

`Duration 2`,
DATE_FORMAT(`Duration 2`, &#39;HH:mm:ss&#39;) AS Duration,--converting duration into time format
(
HOUR(TO_TIMESTAMP(`Duration 2`, &#39;HH:mm:ss&#39;)) +
MINUTE(TO_TIMESTAMP(`Duration 2`, &#39;HH:mm:ss&#39;)) / 60.0 + --converting minutes to seconds
SECOND(TO_TIMESTAMP(`Duration 2`, &#39;HH:mm:ss&#39;)) / 3600.0--converting seconds to minutes
) AS Duration_hours,
(
HOUR(TO_TIMESTAMP(`Duration 2`, &#39;HH:mm:ss&#39;)) * 3600 + --
converting hours to seconds
MINUTE(TO_TIMESTAMP(`Duration 2`, &#39;HH:mm:ss&#39;)) * 60 + ---
converting minutes to seconds
SECOND(TO_TIMESTAMP(`Duration 2`, &#39;HH:mm:ss&#39;))
) AS Duration_seconds,
CASE
WHEN Duration_seconds BETWEEN 300 AND 1800 THEN &#39;01. Low Usage (&lt;30
min)&#39;
WHEN Duration_seconds BETWEEN 1801 AND 3599 THEN &#39;02. Medium Usage
(&lt;60 min)&#39;
WHEN Duration_seconds &gt;= 3600 THEN &#39;03. High Usage (&gt;60 min)&#39;
ELSE &#39;04. No Usage&#39;
END AS Screen_time_bucket,
CASE --cleaning channel
WHEN Channel2 IN (&#39;SawSee&#39;,&#39;Sawsee&#39;) THEN &#39;SawSee&#39;
WHEN Channel2 IN (&#39;SuperSport Live Events&#39;,&#39;Live on SuperSport&#39;,
&#39;Supersport Live Events&#39;, &#39;DStv Events 1&#39;) THEN &#39;Live Events&#39;
ELSE Channel2

END AS Tv_channel
FROM Base_viewership)
