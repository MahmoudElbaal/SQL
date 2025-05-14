use ITI
--1> Create a view that displays student full name, course name if the student has a grade more than 50. 
create view sgrade 
as
select St_Fname+' '+St_Lname as [Full Name], Crs_Name , Grade
from Student s join Stud_Course sc
on s.St_Id = sc.St_Id join Course c 
on sc.Crs_Id = c.Crs_Id
where Grade > 50

select * from sgrade

--=========================================================================================================
--2> Create an Encrypted view that displays manager names and the topics they teach. 
create view emanager 
with encryption
as
select Ins_Name as [manager name] , Top_Name as topic
from Department d join Instructor i 
on d.Dept_Manager = i.Ins_Id join Ins_Course ic 
on i.ins_id = ic.ins_id join Course c
on ic.crs_id = c.crs_id join Topic t
on c.top_id = t.top_id

select * from emanager

--=========================================================================================================
--3> Create a view that will display Instructor Name, Department Name for the ‘SD’ or ‘Java’ Department.
create view iname_dname
as
select Ins_Name, Dept_Name 
from Instructor i join Department d
on i.Dept_Id = d.Dept_Id
where Dept_Name in ('SD' , 'java')

select * from iname_dname

--=========================================================================================================
--4> Create a view “V1” that displays student data for student who lives in Alex or Cairo. 
-- Note: Prevent the users to run the following query 
-- Update V1 set st_address=’tanta’
-- Where st_address=’alex’;

create view V1 
as
select * from Student where St_Address in ('alex','cairo')
with check option

select * from V1
update v1 set St_Address='tanta' where St_Address= 'alex'  --- error

--=========================================================================================================
--5> Create a view that will display the project name and the number of employees work on it. “Use SD database”.
use SD
create view pname_numofemp 
as
select ProjectName , count(EmpNo) as [Number of Employees] 
from Company.Project p join Works_on w 
on p.ProjectNo = w.ProjectNo
group by ProjectName

select * from pname_numofemp

--=========================================================================================================
--6> Create index on column (Hiredate) that allow u to cluster the data in table Department. What will happen?
use ITI
select * from Department
create clustered index i2
on Department(manager_hiredate)
-- error can't create more than one clustered idex because the table has a PK which automatically its the clustered idex. --

--=========================================================================================================
--7> Create index that allow u to enter unique ages in student table. What will happen? 
select * from Student
create unique index i3 
on student(st_age)
-- error because age has duplicates values [null] --

--=========================================================================================================
--8> Using Merge statement between the following two tables [User ID, Transaction Amount]
create table lastt  (lid int,lval int)
create table dailyt (did int,dval int)

insert into dailyt values (1,1000),(2,2000),(3,1000)
insert into lastt  values (1,4000),(4,2000),(2,10000)

select * from dailyt
select * from lastt

merge into lastt as T
using dailyt     as S
on T.lid = S.did
when matched then
   update
     set t.lval = s.dval
when not matched then
   insert
    values(s.did,s.dval)
	output $action;

select * from dailyt
select * from lastt

--=========================================================================================================
--9> Create a cursor for Employee table that increases Employee salary by 10% if Salary <3000 and increases it by 20% if Salary >=3000. Use company DB
use Company_SD

declare c1 cursor 
for select Salary from Employee
for update
declare @sal int
open c1 
fetch c1 into @sal
while @@FETCH_STATUS=0
    begin
	if @sal < 3000
	update Employee
	   set Salary=@sal*1.10
	   where current of c1
    else if @sal >= 3000
	update Employee
	   set Salary=@sal*1.20
	   where current of c1
	   fetch c1 into @sal
	end
close c1
deallocate c1

select Salary from Employee


--=========================================================================================================
--10> Display Department name with its manager name using cursor. Use ITI DB.
use ITI
create table deptmanagers (Department_name varchar(10) , Manager_name varchar(10))

declare c5 cursor
for select distinct Dept_Name,Ins_Name from Department d join Instructor i on  d.Dept_Manager = i.Ins_Id
for read only
declare @depname varchar(10) , @manname varchar(10)
open c5
fetch next from c5 into @depname , @manname
while @@FETCH_STATUS=0
      begin
	     insert into deptmanagers values (@depname,@manname)

		 fetch next from c5 into @depname , @manname
	  end
select * from deptmanagers
close c5
deallocate c5

--=========================================================================================================
--11> Try to display all students first name in one cell separated by comma. Using Cursor 
declare c8 cursor
for select distinct St_Fname from Student where St_Fname is not null
for read only 
declare @name varchar(10) , @allnames varchar(300)=' '
open c8
fetch c8 into @name
while @@FETCH_STATUS=0
   begin
     set @allnames=CONCAT(@allnames,',',@name)
	 fetch c8 into @name
   end
select @allnames as [All Names]
close c8
deallocate c8

--=========================================================================================================
       ------------------------------------              -------------------------------------------
       ------------------------------------  [ Part 2 ]  -------------------------------------------
       ------------------------------------              -------------------------------------------
--=========================================================================================================

--1> Create view named “v_clerk” that will display employee#,project#, the date of hiring of all the jobs of the type 'Clerk'.
use SD
create view v_clerk 
as
select EmpFname+' '+EmpLname as [Full Name], p.ProjectNo ,ProjectName, Job,Enter_Date
from HR.Employee e join Works_on w 
on e.EmpNo = w.EmpNo join Company.Project p 
on w.ProjectNo = p.ProjectNo
where Job = 'clerk'

select * from v_clerk

--=========================================================================================================
--2> Create view named  “v_without_budget” that will display all the projects data without budget.
create view v_without_budget
as
select ProjectNo,ProjectName from Company.Project

select * from v_without_budget

--=========================================================================================================
--3> Create view named  “v_count “ that will display the project name and the # of jobs in it.
create view v_count
as
select ProjectName , COUNT(job) as [Number of Jobs] from Company.Project p join Works_on w on p.ProjectNo = w.ProjectNo
group by ProjectName

select * from v_count

--=========================================================================================================
--4> create view named ” v_project_p2” that will display the emp#  for the project# ‘p2’ use the previously created view  “v_clerk”.
create view v_project_p2
as
select * from v_clerk where ProjectNo = 'p2'

select * from v_project_p2

--=========================================================================================================
--5> modifey the view named  “v_without_budget”  to display all DATA in project p1 and p2.
alter view v_without_budget
as 
select * from Company.Project where ProjectNo in ('p1','p2')

select * from v_without_budget

--=========================================================================================================
--6> Delete the views  “v_ clerk” and “v_count”.
drop view v_clerk 
drop view v_count

--=========================================================================================================
--7> Create view that will display the emp# and emp lastname who works on dept# is ‘d2’.
create view V
as
select EmpFname,EmpLname ,e.DeptNo 
from HR.Employee e join Company.Department d 
on e.DeptNo = d.DeptNo 
where e.DeptNo = 'd2'

select * from V

--=========================================================================================================
--8> Display the employee  lastname that contains letter “J” Use the previous view created in Q#7.
select EmpLname from V where EmpLname like '%j%'

--=========================================================================================================
--9> Create view named “v_dept” that will display the department# and department name.
create view v_dept
as
select DeptNo,DeptName from Company.Department

--=========================================================================================================
--10> using the previous view try enter new department data where dept# is ’d4’ and dept name is ‘Development’.
select * from  v_dept
insert into v_dept 
values ('d4','Development')

--=========================================================================================================
--11> Create view name “v_2006_check” that will display employee#, the project #where he works and the date of joining the project which must be from the first of January and the last of December 2006.
create view v_2006_check
as
select EmpFname+' '+EmpLname as [Full Name], ProjectName , Enter_Date
from HR.Employee e join Works_on w 
on e.EmpNo = w.EmpNo join Company.Project p 
on w.ProjectNo = p.ProjectNo 
where Enter_Date between '2006/1/1' and '2006/12/31'

select * from v_2006_check



--=========================================================================================================
--=========================================================================================================
--=========================================================================================================
