/*2019.9 Ads team
-- Tables:
--
-- web_requests
-- date
-- user_id
-- browser [chrome, firefox, ie]
-- request_count >0
--
-- api_requests
-- date
-- user_id
-- device_type [iphone, ipad, android-phone]
-- request_count
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