/*
Table: Logs

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| log_id        | int     |
+---------------+---------+
id is the primary key for this table.
Each row of this table contains the ID in a log Table.

Since some IDs have been removed from Logs. Write an SQL query to find the start and end number of continuous ranges in table Logs.

Order the result table by start_id.

The query result format is in the following example:

Logs table:
+------------+
| log_id     |
+------------+
| 1          |
| 2          |
| 3          |
| 7          |
| 8          |
| 10         |
+------------+

Result table:
+------------+--------------+
| start_id   | end_id       |
+------------+--------------+
| 1          | 3            |
| 7          | 8            |
| 10         | 10           |
+------------+--------------+
The result table should contain all ranges in table Logs.
From 1 to 3 is contained in the table.
From 4 to 6 is missing in the table
From 7 to 8 is contained in the table.
Number 9 is missing in the table.
Number 10 is contained in the table.
*/

WITH temp1 AS
(SELECT log_id,
        log_id-ROW_NUMBER() OVER(ORDER BY log_id) AS diff
FROM Logs)

SELECT MIN(log_id) AS start_id, MAX(log_id) AS end_id
FROM temp1
GROUP BY diff
ORDER BY start_id


/*
SELECT log_id,
        log_id-ROW_NUMBER() OVER(ORDER BY log_id) AS diff
FROM Logs

{"headers": ["log_id", "difference"], "values": [[1, 0], [2, 0], [3, 0], [7, 3], [8, 3], [10, 4]]}

*/


SELECT min(log_id) as start_id, 
       max(log_id) as end_id
FROM (SELECT log_id, 
             RANK() OVER(ORDER BY log_id) as num
      FROM Logs) a
GROUP BY log_id - num
      
/*      
{"headers": ["log_id", "num"], "values": [[1, 1], [2, 2], [3, 3], [7, 4], [8, 5], [10, 6]]}
*/