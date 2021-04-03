/*
Table: Logs

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| num         | varchar |
+-------------+---------+
id is the primary key for this table.
 

Write an SQL query to find all numbers that appear at least three times consecutively.

Return the result table in any order.

The query result format is in the following example:

 

Logs table:
+----+-----+
| Id | Num |
+----+-----+
| 1  | 1   |
| 2  | 1   |
| 3  | 1   |
| 4  | 2   |
| 5  | 1   |
| 6  | 2   |
| 7  | 2   |
+----+-----+

Result table:
+-----------------+
| ConsecutiveNums |
+-----------------+
| 1               |
+-----------------+
1 is the only number that appears consecutively for at least three times.
*/

SELECT distinct num ConsecutiveNums
FROM
(SELECT id, num,
        LAG(num) over (order by id) as pre,
        lead(num) over (order by id) as nxt
 FROM logs) next_prev
WHERE num=pre and pre =nxt

/*
Logs table:
+----+-----+-----+-----+
| Id | Num | pre | nxt |
+----+-----+-----+-----+
| 1  | 1   | NULL|  1  |
| 2  | 1   |  1  |  1  |
| 3  | 1   |  1  |  2  |
| 4  | 2   |  1  |  1  |
| 5  | 1   |  2  |  2  |
| 6  | 2   |  1  |  2  |
| 7  | 2   |  2  | NULL|
+----+-----+-----+-----+
*/

/*
LAG()
Returns the value of the Nth row before the current row in a partition. It returns NULL if no preceding row exists.
https://www.mysqltutorial.org/mysql-window-functions/mysql-lag-function/

LEAD() 
Returns the value of the Nth row after the current row in a partition. It returns NULL if no subsequent row exists.
https://www.mysqltutorial.org/mysql-window-functions/mysql-lead-function/