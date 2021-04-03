/*
The Employee table holds all employees. Every employee has an Id, a salary, 
and there is also a column for the department Id.

+----+-------+--------+--------------+
| Id | Name  | Salary | DepartmentId |
+----+-------+--------+--------------+
| 1  | Joe   | 70000  | 1            |
| 2  | Jim   | 90000  | 1            |
| 3  | Henry | 80000  | 2            |
| 4  | Sam   | 60000  | 2            |
| 5  | Max   | 90000  | 1            |
+----+-------+--------+--------------+
The Department table holds all departments of the company.

+----+----------+
| Id | Name     |
+----+----------+
| 1  | IT       |
| 2  | Sales    |
+----+----------+
Write a SQL query to find employees who have the highest salary in each of the departments. 
For the above tables, your SQL query should return the following rows (order of rows does not matter).

+------------+----------+--------+
| Department | Employee | Salary |
+------------+----------+--------+
| IT         | Max      | 90000  |
| IT         | Jim      | 90000  |
| Sales      | Henry    | 80000  |
+------------+----------+--------+
*/
SELECT Department, Employee, Salary
FROM (SELECT 
          d.Name AS Department,
          e.Name AS Employee,
          e.Salary,
          RANK() OVER (
                PARTITION BY d.Name
                ORDER BY e.Salary DESC) AS r
      FROM Employee e
      JOIN Department d ON e.DepartmentId = d.Id) tmp
WHERE r = 1

/*-------------------------------------------------------------------*/
select b.Name Department, a.Name Employee, a.Salary
from (
    select DepartmentId, Name, Salary, rank() over(partition by DepartmentId order by salary desc) rnk
    from Employee) a
join Department b
on a.DepartmentId=b.Id
where a.rnk=1

/*-------------------------------------------------------------------*/
select Department, Employee, Salary
from(
    select b.Name as Department, a.Name as Employee, a.Salary, max(a.Salary) over (partition by a.DepartmentId) as MaxSalary
    from Employee as a
    join Department as b on a.DepartmentId = b.Id
) as t
where t.Salary = t.MaxSalary

