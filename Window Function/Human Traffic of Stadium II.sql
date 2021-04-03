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

/*-------------------------------------------------------------------------------------------------*/

/*
The LAG() function returns the value of the expression from the row that precedes the current row 
by offset number of rows within its partition or result set.
LEAD() function is very useful for calculating the difference between the current row 
and the subsequent row within the same result set.
*/
/*
SELECT ID, 
       visit_date, 
       people,
       LEAD(people, 1) OVER (ORDER BY id) nxt,
       LEAD(people, 2) OVER (ORDER BY id) nxt2,
       LAG(people, 1) OVER (ORDER BY id) pre,
       LAG(people, 2) OVER (ORDER BY id) pre2
FROM Stadium

{"headers": ["ID", "visit_date", "people", "nxt", "nxt2", "pre", "pre2"], 
"values": [   [1,  "2017-01-01",   10,      109,   150,    null,  null], 
              [2,  "2017-01-02",   109,     150,   99,     10,    null], 
              [3,  "2017-01-03",   150,     99,    145,    109,   10], 
              [4,  "2017-01-04",   99,      145,   1455,   150,   109], 
              [5,  "2017-01-05",   145,     1455,  199,    99,    150], 
              [6,  "2017-01-06",   1455,    199,   188,    145,   99], 
              [7,  "2017-01-07",   199,     188,   null,   1455,  145],
              [8,  "2017-01-09",   188,     null,  null,   199,   1455]]}
*/			  
SELECT ID
    , visit_date
    , people
FROM (
    SELECT ID
        , visit_date
        , people
        , LEAD(people, 1) OVER (ORDER BY id) nxt
        , LEAD(people, 2) OVER (ORDER BY id) nxt2
        , LAG(people, 1) OVER (ORDER BY id) pre
        , LAG(people, 2) OVER (ORDER BY id) pre2
    FROM Stadium
) cte 
WHERE (cte.people >= 100 AND cte.nxt >= 100 AND cte.nxt2 >= 100) 
    OR (cte.people >= 100 AND cte.nxt >= 100 AND cte.pre >= 100)  
    OR (cte.people >= 100 AND cte.pre >= 100 AND cte.pre2 >= 100) 	


/*------------------------------------------------------------------------------*/

with t1 as
(select id, 
        visit_date, 
        people,
        lead(people, 1) over (order by id) as p_nextid,
        lead(people, 2) over (order by id) as p_2nextid ,
        lag(people, 1) over (order by id) as p_previd,
        lag(people, 2) over (order by id) as p_2previd
from stadium
)

select id, 
       visit_date, 
       people
from t1
where (people >= 100 and p_nextid >= 100 and p_2nextid >= 100) 
   or (people >= 100 and p_previd >= 100 and p_2previd >= 100) 
   or (people >= 100 and p_previd >= 100 and p_nextid >= 100)	