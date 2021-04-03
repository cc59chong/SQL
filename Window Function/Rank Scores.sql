/*
Write a SQL query to rank scores. If there is a tie between two scores, 
both should have the same ranking. Note that after a tie, 
the next ranking number should be the next consecutive integer value. 
In other words, there should be no "holes" between ranks.

+----+-------+
| Id | Score |
+----+-------+
| 1  | 3.50  |
| 2  | 3.65  |
| 3  | 4.00  |
| 4  | 3.85  |
| 5  | 4.00  |
| 6  | 3.65  |
+----+-------+
For example, given the above Scores table, your query should generate the following report 
(order by highest score):

+-------+---------+
| score | Rank    |
+-------+---------+
| 4.00  | 1       |
| 4.00  | 1       |
| 3.85  | 2       |
| 3.65  | 3       |
| 3.65  | 3       |
| 3.50  | 4       |
+-------+---------+
*/
SELECT Score,
       DENSE_RANK() OVER ( 
          ORDER BY Score DESC) AS 'Rank'
FROM Scores；

/*-----------------------------------------------------------------------------------*/
SELECT Score,
       RANK() OVER ( 
         ORDER BY Score DESC) AS 'Rank'
FROM Scores
/*
+-------+---------+
| score | Rank    |
+-------+---------+
| 4.00  | 1       |
| 4.00  | 1       |
| 3.85  | 3       |
| 3.65  | 4       |
| 3.65  | 4       |
| 3.50  | 6       |
+-------+---------+

*/

/*
DENSE_RANK() Assigns a rank to every row within its partition based on the ORDER BY clause. 
It assigns the same rank to the rows with equal values. 
If two or more rows have the same rank, then there will be no gaps in the sequence of ranked values.

RANK() Similar to the DENSE_RANK() function except that there are gaps in the sequence of ranked values 
when two or more rows have the same rank.
