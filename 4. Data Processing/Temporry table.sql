-- Databricks notebook source
SELECT *
FROM user_profiles;

CREATE OR REPLACE TEMPORARY TABLE viewership AS (
SELECT
COALESCE(UserID0,userid4) AS userid,
TO_CHAR(RecordDate2, 'yyyyMM') AS month_id,
TO_DATE(RecordDate2) AS watch_date,
--TIME(RecordDate2) AS watch_time,
TO_CHAR(RecordDate2, 'DD') AS day_of_week,
DAYNAME(RecordDate2) AS day_name,

CASE
WHEN day_name IN ('Sat', 'Sun') THEN 'weekend'
ELSE 'weekday'
END AS day_classification,

MONTHNAME(RecordDate2) AS month_name,

CASE
WHEN Channel2 IN ('SawSee','Sawsee') THEN 'SawSee'
WHEN Channel2 IN ('SuperSport Live Events','Live on SuperSport', 'Supersport Live Events', 'DStv Events 1') THEN 'Live Events'
ELSE Channel2
END AS Tv_channel,

date_format(RecordDate2, 'HH:mm:ss') AS watch_time,
CASE
WHEN watch_time BETWEEN '00:00:00' AND '05:59:59' THEN '01. Midnight'
WHEN watch_time BETWEEN '06:00:00' AND '11:59:59' THEN '02. Morning'
WHEN watch_time BETWEEN '12:00:00' AND '16:59:59' THEN '03. Afternoon'
WHEN watch_time BETWEEN '17:00:00' AND '23:59:59' THEN '04. Evening'
END AS time_of_day,

DATE_FORMAT(Duration 2, 'HH:mm:ss') AS duration,
CASE
WHEN duration BETWEEN '00:05:00' AND '00:30:00' THEN '01. Low Usage: <30 min'
WHEN duration BETWEEN '00:30:01' AND '00:59:59' THEN '02. Med Usage: <60 min'
WHEN duration > '00:59:59' THEN '03. High Usage: >60 min'
ELSE '04. No Usage'
END AS screen_time_bucket,

HOUR(RecordDate2) AS hour_of_day

FROM tv_data.dataset_tv_casestudy.viewership);


SELECT *
FROM viewership;

SELECT Coalesce(A.userid,B.userid) AS sub_id,
month_id,
watch_date,
day_of_week,
day_name,
day_classification,
month_name,
Tv_channel,
time_of_day,
hour_of_day,
screen_time_bucket,
--user_flag,
duration,
Region,
age_groups,
email_flag,
sm_flag,
Race,
Gender
FROM viewership AS A
LEFT JOIN user_profiles AS B
ON A.userid=B.userid;