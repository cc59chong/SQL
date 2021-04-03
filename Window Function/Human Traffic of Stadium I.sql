/*
Table: Stadium

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| visit_date    | date    |
| people        | int     |
+---------------+---------+
visit_date is the primary key for this table.
Each row of this table contains the visit date and visit id to the stadium with the number of people during the visit.
No two rows will have the same visit_date, and as the id increases, the dates increase as well.
 

Write an SQL query to display the records with three or more rows with consecutive id's, 
and the number of people is greater than or equal to 100 for each.

Return the result table ordered by visit_date in ascending order.

The query result format is in the following example.

 

Stadium table:
+------+------------+-----------+
| id   | visit_date | people    |
+------+------------+-----------+
| 1    | 2017-01-01 | 10        |
| 2    | 2017-01-02 | 109       |
| 3    | 2017-01-03 | 150       |
| 4    | 2017-01-04 | 99        |
| 5    | 2017-01-05 | 145       |
| 6    | 2017-01-06 | 1455      |
| 7    | 2017-01-07 | 199       |
| 8    | 2017-01-09 | 188       |
+------+------------+-----------+

Result table:
+------+------------+-----------+
| id   | visit_date | people    |
+------+------------+-----------+
| 5    | 2017-01-05 | 145       |
| 6    | 2017-01-06 | 1455      |
| 7    | 2017-01-07 | 199       |
| 8    | 2017-01-09 | 188       |
+------+------------+-----------+
The four rows with ids 5, 6, 7, and 8 have consecutive ids and each of them has >= 100 people attended. 
Note that row 8 was included even though the visit_date was not the next day after row 7.
The rows with ids 2 and 3 are not included because we need at least three consecutive ids.
*/
/*----------------------------------------------------------------------------------------------------*/

/*ROW_NUMBER	Assigns a sequential integer to every row within its partition */
/*
SELECT id, id - ROW_NUMBER() over (ORDER BY id) AS diff
FROM Stadium
WHERE people >= 100


Stadium table:
+------+------------+-----------+------+
| id   | visit_date | people    | diff |
+------+------------+-----------+------+ 
| 2    | 2017-01-02 | 109       |   1  |
| 3    | 2017-01-03 | 150       |   1  |
| 5    | 2017-01-05 | 145       |   2  |
| 6    | 2017-01-06 | 1455      |   2  |
| 7    | 2017-01-07 | 199       |   2  |
| 8    | 2017-01-09 | 188       |   2  |
+------+------------+-----------+------+

SELECT id, COUNT(*) OVER (PARTITION BY DIFF) as cnt
FROM
     (SELECT id, id - ROW_NUMBER() over (ORDER BY id) AS diff
      FROM Stadium
      WHERE people >= 100) a
	  
+------+------+
|  id  |  cnt |
+------+------+
|  2   |  2   |
|  3   |  2   |
|  5   |  4   |
|  6   |  4   |
|  7   |  4   |
|  8   |  4   |
+------+------+
*/
SELECT *
FROM Stadium
WHERE id IN (SELECT id
             FROM (SELECT id, COUNT(*) OVER (PARTITION BY DIFF) as cnt
                   FROM (SELECT id, id - ROW_NUMBER() over (ORDER BY id) AS diff
                         FROM Stadium
                         WHERE people >= 100) a
                   ) b
             WHERE cnt >= 3);