/*2019.9 Ads team
-- Tables:
--
-- web_requests
-- date| user_id | browser [chrome, firefox, ie] | request_count >0
--
-- api_requests
-- date | user_id | device_type [iphone, ipad, android-phone] | request_count
--
-- Goal: Get the per-day count since the beginning of the year of users who visited at least one page on an iphone and the web on the same day.
--
-- Or, asked differently: How many users each day (since the beginning of the year) were using both the iPhone and the web to visit Pinterest on the same day?
*/

SELECT w.date, COUNT(distinct w.user_id)
FROM web_requests w 
LEFT JOIN api_requests a 
ON w.date = a.date AND w.user_id = a.user_id
WHERE w.browser IS NOT NULL AND a.devie_type = ‘iphone’ AND w.date >= ‘….’
GROUP BY w.date

/*-----------------------------------------------------------------------*/

SELECT a.date, COUNT(a.user_id) as user_cnt
FROM
(
SELECT date, user_id 
FROM web_requests
WHERE data >= ‘….’  AND browser IS NOT NULL 
GROUP BY 1,2
) a
JOIN 
(
SELECT date, user_id
FROM api_requests
WHERE device_type = ‘iphone’ AND data >= ‘….’ 
) b
ON a.user_id = b.user_id AND a.date = b.date
GROUP BY 1

/*-------------------------------------------------------------------------------------------------------*/
/*
Table 1: ad_events
Userid | Advertiserid | Slot | Revenue | date | service (browser/iphone/android)

Table 2: user_dimension
Userid | Country | Age | Gender

Question: write a query to calculate the average US users on a given date that viewed the same Ads on both web and mobile device

Expected Output: Advertiserid | date | total_users
*/
SELECT a.Advertiserid, a.date, AVG(a.user_id) AS US_users
FROM ad_events a
JOIN user_dimension u
ON a.user_id = u.user_id
WHERE u.Country = 'US' 
  AND a.service = 'browser' AND (a.service = 'iphone' OR a.service = 'android')
GROUP BY a.date;

/*-------------------------------------------------------------------------------------------------------*/
/*
Tb1: pin_impressions
user_id, |pin_id | dt | action

Tb2: promoted_pins
Dt | advertiser_id |pin_id |cost

Tb3: user_dimension
User_id | country | gender | spam_indicator (0,1)
Q1: Calculate the percentage of impressions that are from ads (ad load), by country, by day, for non-spam users in 2020.
*/

  SELECT
     u.country,
     pi.dt,
     CONCAT(ROUND(SUM(CASE WHEN advertiser_id IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*) *100) ,4), '%') AS ad_load
  FROM pin_inpressions pi
  LEFT JOIN promoted_pins pp ON pi.pin_id = pp.pin_id AND pi.dt = pp.dt
  JOIN user_dimension u ON u.user_id = pi.user_id
  WHERE pi.dt BETWEEN '2020-01-01' AND '2020-12-31' AND u.spam_indicator = 0
  GROUP BY u.country, pi.dt
  ORDER BY 1,2;

/* Q2: From your first query, find countries with higher ad load today than yesterday. */
WITH ad_load AS
(
  SELECT
     u.country,
     pi.dt,
     CONCAT(ROUND(SUM(CASE WHEN advertiser_id IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*) *100) ,4), '%') AS ad_load
  FROM pin_inpressions pi
  LEFT JOIN promoted_pins pp ON pi.pin_id = pp.pin_id AND pi.dt = pp.dt
  JOIN user_dimension u ON u.user_id = pi.user_id
  WHERE pi.dt BETWEEN '2020-01-01' AND '2020-12-31' AND u.spam_indicator = 0
  GROUP BY u.country, pi.dt
  ORDER BY 1,2
)

SELE
  t.country,
  t.ad_load,
  y.ad_load
FROM ad_load t, ad_load y
WHERE t.country = y.country AND t.ad_load > y.ad_load AND t.dt = CURRENT_DATE AND y.dt = CURRENT_DATE - 1 /*?*/

/*-------------------------------------------------------------------------------------------------------*/
/*2019 1-3
Table 1= ad_events
Userid | Advertiserid |Slot - slot of the impression | Revenue |date
Table 2 = user_dimension
Userid | Country | Age | Gender | pam_indicator (0 or 1)
Question - Write a query to calculate the Average revenue generated per user for US users in first 10 slots for each advertiser on a given date
Expected Output: Advertiserid, revenue_per_user (Revenue generated per user in US in the first 10 slots )

Advertising slot就是指“广告时段” */

SELECT 
   advertiserid,
   SUM(revenue)/COUNT(DISTINCT user_id) AS revenue_per_user
FROM (SELECT
         a.user_id,
         a.advertiserid,
         a.revenue,
         RANK() OVER(PARTITION BY advertiserid ORDER BY a.slot DESC) as slot_rank
      FROM ad_events a
      JOIN user_dimension u ON a.user_id = u.user_id
      WHERE u.country = 'US' AND a.data = '...'
) t 
WHERE slot_rank <=10
GROUP BY advertiserid;

/*-------------------------------------------------------------------------------------------------------*/
/*SQL 2:
Table 1: user_insertion
Userid | insertion_id | dt
Table 2: ad_insertion
insertion_id | promoted_pin_id | action_type (view, click, hide) | action_timestamp  |dt
Question - Write a query to calculate the the number of repeated ads for each user on given day# #
Expected Output : Userid, Number_of_repeated_ads (number of ad pins that were repeated)
*/
/*?????????*/
SELECT
  u.user_id,
  COUNT(a.promoted_pin_id) AS number_of_repeated ads
FROM user_insertion u
JOIN ad_insertion a 
ON u.insertion_id = a.insertion_id AND u.dt = a.dt
WHERE u.dt = '....'
GROUP BY u.userid, a.promoted_pin_id  