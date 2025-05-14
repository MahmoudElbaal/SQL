use ITI

--=========================================================================================================
--1> Create a scalar function that takes date and returns Month name of that date

create function getmonthname(@date date)
returns varchar(20)
as begin
       declare @monthname varchar(20)
	   set @monthname = Datename (MONTH,@date)
	   return @monthname
   end

select dbo.getmonthname(getdate()) as [Month name]

--=========================================================================================================
--2> Create a multi-statements table-valued function that takes 2 integers and returns the values between them.

create function betweennumbers (@x int , @y int)
returns @result table (value int)
as begin
       declare @num int = @x
	   while @num <= @y
	   begin
	   insert into @result(value)
	   values (@num)

	   set @num = @num + 1
	   end
    return
   end

select value as [between numbers] from betweennumbers (10,20)

--=========================================================================================================
--3> Create inline function that takes Student No and returns Department Name with Student full name.

create function getdepandsname (@sid int)
returns table 
as
        return
		(
		select dept_name , st_fname+' '+st_lname as [Full Name]
		from Department d join Student s on d.Dept_Id = s.Dept_Id
		where St_Id = @sid
		)

select * from getdepandsname(6)

--=========================================================================================================
--4> Create a scalar function that takes Student ID and returns a message to user 
---- a.If first name and Last name are null then display 'First name & last name are null'
---- b.If First name is null then display 'first name is null'
---- c.If Last name is null then display 'last name is null'
---- d.Else display 'First name & last name are not null'

create function getmessage (@sid int)
returns varchar(100)
as begin
     declare @message varchar(100)
     select @message = 
	     case
		     when St_Fname is null and St_Lname is null then 'First name & last name are null'
			 when St_Fname is null then 'first name is null'
			 when St_Lname is null then 'last name is null'
		     else 'First name & last name are not null'
		 end
		 from Student
		 where St_Id = @sid
     return @message
   end

select dbo.getmessage(14) as [Null or not Null]

--=========================================================================================================
--5> Create inline function that takes integer which represents manager ID and displays department name, Manager Name and hiring date.

create function newdatafun (@manageid int)
returns table
as 
  return 
  (
  select Dept_Name , Ins_Name , Manager_hiredate
  from Department d join Instructor i 
  on d.Dept_Manager = i.Ins_Id
  where Dept_Manager = @manageid
  )

select * from newdatafun (1)

--=========================================================================================================
--6> Create multi-statements table-valued function that takes a string
-- If string='first name' returns student first name
-- If string='last name' returns student last name 
-- If string='full name' returns Full Name from student table 
-- Note: Use “ISNULL” function
create function getstuds(@format varchar(100))
returns @t table
            (
			 sname varchar(20)
			)
as
	begin
		if @format='firs tname'
			insert into @t
			select isnull(st_fname,' ') from Student
		else if @format='last name'
			insert into @t
			select isnull(st_lname,' ') from Student
		else if @format='full name'
			insert into @t
			select isnull(concat(st_fname,' ',st_lname),' ') from Student
		return 
	end

select * from dbo.getstuds('last name')

--=========================================================================================================
--7> Write a query that returns the Student No and Student first name without the last char.

select St_Id , left (st_fname , len(st_fname) - 1 )
from student 
where len(st_fname) > 0

--=========================================================================================================
--8> Write query to delete all grades for the students Located in SD Department 

delete from Stud_Course 
where St_Id in (select St_Id from Student s join Department d on s.Dept_Id = d.Dept_Id where Dept_Name = 'SD')

--=========================================================================================================
Bonus [2]
-- Create a batch that inserts 3000 rows in the student table(ITI database). 
-- The values of the st_id column should be unique and between 3000 and 6000. 
-- All values of the columns st_fname, st_lname, should be set to 'Jane', ' Smith' respectively.

WITH Numbers AS (
    SELECT 0 AS n
    UNION ALL
    SELECT n + 1 FROM Numbers WHERE n < 2999
)
INSERT INTO Student (st_id, st_fname, st_lname)
SELECT 3000 + n, 'Jane', 'Smith'
FROM Numbers
OPTION (MAXRECURSION 3000);



--=========================================================================================================
--=========================================================================================================
--=========================================================================================================