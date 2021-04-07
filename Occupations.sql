/*
https://www.hackerrank.com/challenges/occupations/problem
*/

select min(temp.Doctor), min(temp.Professor),min(temp.Singer),  min(temp.Actor)
from(
	select
		name,
		ROW_NUMBER() OVER(PARTITION By Doctor,Professor,Singer,Actor order by name asc) AS Rownum, 
		case when Doctor=1 then name else Null end as Doctor,
		case when Professor=1 then name else Null end as Professor,
		case when Singer=1 then name else Null end as Singer,
		case when Actor=1 then name else Null end as Actor
	from
		occupations 
	  pivot	(count(occupation) for occupation in(Doctor, Professor, Singer, Actor)) as p
) temp
group by temp.Rownum;

/*
====Steps 1====

select
	name, Doctor, Professor, Singer, Actor
from
	occupations 
  pivot	(count(occupation) for occupation in(Doctor, Professor, Singer, Actor)) as p

Out put:
Aamina 1 0 0 0 
Ashley 0 1 0 0 
Belvet 0 1 0 0 
Britney 0 1 0 0 
Christeen 0 0 1 0 
Eve 0 0 0 1 
Jane 0 0 1 0 
Jennifer 0 0 0 1 
Jenny 0 0 1 0 
Julia 1 0 0 0 
Ketty 0 0 0 1 
Kristeen 0 0 1 0 
Maria 0 1 0 0 
Meera 0 1 0 0 
Naomi 0 1 0 0 
Priya 1 0 0 0 
Priyanka 0 1 0 0 
Samantha 0 0 0 1

====Steps 2====
select
	name,
	ROW_NUMBER() OVER(PARTITION By Doctor,Professor,Singer,Actor order by name asc) AS Rownum, 
	case when Doctor=1 then name else Null end as Doctor,
	case when Professor=1 then name else Null end as Professor,
	case when Singer=1 then name else Null end as Singer,
	case when Actor=1 then name else Null end as Actor
from
	occupations 
  pivot	(count(occupation) for occupation in(Doctor, Professor, Singer, Actor)) as p


Out put:

Eve 		1 NULL NULL NULL Eve 
Jennifer 	2 NULL NULL NULL Jennifer 
Ketty 		3 NULL NULL NULL Ketty 
Samantha 	4 NULL NULL NULL Samantha 
Christeen 	1 NULL NULL Christeen NULL 
Jane 		2 NULL NULL Jane NULL 
Jenny 		3 NULL NULL Jenny NULL 
Kristeen 	4 NULL NULL Kristeen NULL 
Ashley 		1 NULL Ashley NULL NULL 
Belvet 		2 NULL Belvet NULL NULL 
Britney 	3 NULL Britney NULL NULL 
Maria 		4 NULL Maria NULL NULL 
Meera 		5 NULL Meera NULL NULL 
Naomi 		6 NULL Naomi NULL NULL 
Priyanka 	7 NULL Priyanka NULL NULL 
Aamina 		1 Aamina NULL NULL NULL 
Julia 		2 Julia NULL NULL NULL 
Priya 		3 Priya NULL NULL NULL 

====Steps 2====
// added rownum to make the result understandable.

select Rownum, min(Doctor), min(Professor),min(Singer),  min(Actor)
from(
	select
		name,
		ROW_NUMBER() OVER(PARTITION By Doctor,Professor,Singer,Actor order by name asc) AS Rownum, 
		case when Doctor=1 then name else Null end as Doctor,
		case when Professor=1 then name else Null end as Professor,
		case when Singer=1 then name else Null end as Singer,
		case when Actor=1 then name else Null end as Actor
	from
		occupations 
	  pivot	(count(occupation) for occupation in(Doctor, Professor, Singer, Actor)) as p

) temp

group by Rownum  ;


1 Aamina Ashley Christeen Eve 
2 Julia Belvet Jane Jennifer 
3 Priya Britney Jenny Ketty 
4 NULL Maria Kristeen Samantha 
5 NULL Meera NULL NULL 
6 NULL Naomi NULL NULL 
7 NULL Priyanka NULL NULL 