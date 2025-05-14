-- 1
select COUNT(st_id) as [ num ]
from Student
where St_Age is not null

--=========================================================================================================
-- 2
select distinct Ins_Name from Instructor

--=========================================================================================================
-- 3
select St_Id as [Student ID], St_Fname+' '+St_Lname as [Student Full Name] , Dept_Name as [Department name]
from Student s join Department d 
on s.Dept_Id = d.Dept_Id

--=========================================================================================================
-- 4
select Ins_Name , Dept_Name
from Instructor i join Department d
on i.Dept_Id = d.Dept_Id

--=========================================================================================================
-- 5
select St_Fname+' '+St_Lname as [Student Full Name] , Crs_Name 
from Student s join Stud_Course sc
on s.St_Id = sc.St_Id join Course c
on sc.Crs_Id = c.Crs_Id

--=========================================================================================================
-- 6
select Top_Name , COUNT(*) as [Number Of Courses]
from Course c join Topic t
on c.Top_Id = t.Top_Id
group by Top_Name

--=========================================================================================================
-- 7
select MAX(salary) as [Max Salary] , MIN(salary) as [Min Salary]
from Instructor

--=========================================================================================================
-- 8
select Ins_Name , Salary 
from Instructor
where Salary < (select AVG(salary) from Instructor)

--=========================================================================================================
-- 9
select Dept_Name
from Instructor i join Department d
on i.Dept_Id = d.Dept_Id
where i.Salary = (select min(salary) from Instructor)

--=========================================================================================================
-- 10
select top(2) Salary from Instructor
order by Salary desc

--=========================================================================================================
-- 11
select Ins_Name , COALESCE(CAST(Salary AS VARCHAR), 'bonus') AS [Salary or Bonus]
from Instructor

--=========================================================================================================
-- 12
select AVG(salary) as [AVG Salary] from Instructor

--=========================================================================================================
-- 13
select St_Fname , i.* 
from Student s join Instructor i
on s.St_super = i.Ins_Id

--=========================================================================================================
-- 14
select d.dept_name , i.Salary
from (select Salary, Dept_Id , Dense_rank() over(partition by dept_id order by salary desc) as DR
      from Instructor ) as i JOIN Department d ON i.Dept_Id = d.Dept_Id
where DR<=2

--=========================================================================================================
-- 15
SELECT *
FROM (SELECT * ,ROW_NUMBER() OVER (PARTITION BY Dept_Id ORDER BY NEWID())AS RN
FROM Student) AS X
WHERE RN=1


--=========================================================================================================
--=========================================================================================================
--=========================================================================================================