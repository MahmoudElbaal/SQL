--1> Create a stored procedure without parameters to show the number of students per department name.[use ITI DB].
use ITI

create proc p1
as
SELECT Dept_Name, COUNT(st_id) as [Number of Students]
FROM Department d INNER JOIN Student s
ON d.Dept_Id = s.Dept_Id
group by Dept_Name

p1

--=========================================================================================================
--2> Create a stored procedure that will check for the number of employees in the project p1 if they are more than 3 print message to 
--   the user “'The number of employees in the project p1 is 3 or more'” if they are less display a message to the user 
--   “'The following employees work for the project p1'” in addition to the first name and last name of each one. [SD DB].
use SD

create proc p2
as
begin
  declare @empcount int
     
	  SELECT @empcount = COUNT(e.EmpNo)
      FROM HR.Employee e JOIN Works_on w
      ON e.EmpNo = w.EmpNo JOIN Company.Project p 
      ON w.ProjectNo = p.ProjectNo
      where p.ProjectNo = 'p1' 
      
	  if @empcount >= 3
	   begin
	    select 'The number of employees in the project p1 is 3 or more' as [message]
	   end
     else if @empcount < 3
	   begin

	    select 'The following employees work for the project p1' as [message]

		SELECT EmpFname+' '+EmpLname as [Full Name], p.ProjectNo
         FROM HR.Employee e JOIN Works_on w
         ON e.EmpNo = w.EmpNo JOIN Company.Project p 
         ON w.ProjectNo = p.ProjectNo
         where p.ProjectNo = 'p1' 

	   end	    
end

exec p2;


--=========================================================================================================
--3> Create a stored procedure that will be used in case there is an old employee has left the project and a new one become 
--   instead of him. The procedure should take 3 parameters (old Emp. number, new Emp. number and the project number) 
--   and it will be used to update works_on table. [SD DB]
use SD

create proc new_pro @old_emp int, @new_emp int , @pname varchar(10)
as
begin
  begin try
     begin
	   update Works_on 
       set EmpNo = @new_emp	
       where EmpNo = @old_emp and ProjectNo = @pname
	 end
  end try
   begin catch
    select 'error happened'
   end catch
end

new_pro 2581, 3 , 40

--=========================================================================================================
--4> add column budget in project table and insert any draft values in it then then Create an Audit table with the following structure ProjectNo 	UserName 	ModifiedDate 	Budget_Old 	Budget_New p2 	Dbo 2008-01-31	95000 	200000 This table will be used to audit the update trials on the Budget column (Project table, Company DB)Example:If a user updated the budget column then the project number, user name that made that update, the date of the modification and the value of the old and the new budget will be inserted into the Audit table Note: This process will take place only if the user updated the budget column
create table Audit (ProjectNo varchar(5),Username varchar(50),ModifiedDate	date, Budget_Old int , Budget_New int )

insert into Audit 
values ('p2','Dbo','2008-01-31',95000,200000)
select * from Audit

create trigger t1
on company.project
instead of update
as 
begin
    if UPDATE (budget)
	  begin
	    declare @old int , @new int ,@projectno varchar(5)
		select @old = budget from deleted
		select @new = budget from inserted
		select @projectno = projectno from deleted
		insert into audit
		values (@projectno,SUSER_NAME(),GETDATE(),@old,@new)

		update Company.Project set Budget = @new where ProjectNo = @projectno
	  end
end

update Company.Project
set Budget = 100000 where ProjectNo = 'p2'

select * from Audit

--=========================================================================================================
--5> Create a trigger to prevent anyone from inserting a new record in the Department table [ITI DB] “Print a message for user to tell him that he can’t insert a new record in that table”
use ITI

create trigger t2
on department
instead of insert
as
   select 'You can not insert any data in this table'

insert into Department values (1,'a','aa','cairo',2,'2025/1/1')

--=========================================================================================================
--6> Create a trigger that prevents the insertion Process for Employee table in March [Company DB].
use Company_SD

create trigger t3
on employee
instead of insert
as
    begin 
        if MONTH(getdate()) = 3
		   begin
             select 'You can not insert any data in this table in March'
		     rollback transaction
		   end
        else 
		   begin
		     insert into Employee
			 select * from inserted
		   end
    end 

--=========================================================================================================
--7> Create a trigger on student table after insert to add Row in Student Audit table (Server User Name , Date, Note) where note will be “[username] Insert New Row with Key=[Key Value] in table [table name]”
use ITI

create table Student_Audit (Server_User_Name varchar(50) ,Date date, Note varchar(100))

create trigger t4
on student
after insert
as
Begin    
	 declare @username varchar(50),@note varchar(100), @st_id int
	 select @username = SUSER_NAME() , @st_id = st_id from inserted
	 select @note = @username+ 'Insert New Row with Key ='+ cast(@st_id as varchar) + ' in table student '
	
	insert into Student_Audit 
	values (@username , GETDATE(), @note)
end


insert into Student (St_Id )
values (18)

select * from Student_Audit

--=========================================================================================================
--8> Create a trigger on student table instead of delete to add Row in Student Audit table (Server User Name, Date, Note) where note will be“ try to delete Row with Key=[Key Value]”

create trigger t5
on student
instead of delete 
as
 Begin    
	 declare @username varchar(50),@note varchar(100), @st_id int
	 select @username = SUSER_NAME() , @st_id = st_id from deleted
	 select @note = 'try to delete Row with Key ='+ cast(@st_id as varchar)
	
	insert into Student_Audit 
	values (@username , GETDATE(), @note)
end

delete from Student where St_Id = 12

select * from Student_Audit

-- [*] Create a sequence object that allow values from 1 to 10 without cycling in a specific column and test it.
create sequence sq as int 
start with 1 increment by 1 
minvalue 1 maxvalue 10
no cycle

select next value for sq ---- from 1 to 10  when reached 10 --- error

-- [*] Create full, differential Backup for SD DB.

backup database SD
to disk='E:\SD.bak'

backup database SD 
to disk='E:\SD.bak'
with differential

--=========================================================================================================
-- [part2] Transform all functions in lab7 to be stored procedures
--1 
create proc getmonthname @date date
as begin
       declare @monthname varchar(20)
	   set @monthname = Datename (MONTH,@date)
	   return @monthname
   end

--=========================================================================================================
--2 
create proc betweennumbers @x int , @y int
as begin
       declare @num int = @x
	   while @num <= @y
	   begin
	   insert into @result(value)
	   values (@num)

	   set @num = @num + 1
	   end
   end

--=========================================================================================================
--3 
create proc getdepandsname @sid int
as begin
		select dept_name , st_fname+' '+st_lname as [Full Name]
		from Department d join Student s on d.Dept_Id = s.Dept_Id
		where St_Id = @sid
end

--=========================================================================================================
--4 
create proc getmessage @sid int
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

--=========================================================================================================
--5 

create proc newdatafun @manageid int
as begin
  select Dept_Name , Ins_Name , Manager_hiredate
  from Department d join Instructor i 
  on d.Dept_Manager = i.Ins_Id
  where Dept_Manager = @manageid
end

--=========================================================================================================
--6
create proc getstuds @format varchar(100)
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
	end






--=========================================================================================================
--=========================================================================================================
--=========================================================================================================