use SD
create table Department
(
DeptNo varchar(3) primary key,
DeptName varchar(20),
Location loc
)

sp_addtype loc ,'nchar(2)';
sp_bindrule r1,'loc';
sp_bindefault def1,'loc';

create rule r1 as @value in('NY','DS','KW');
create default def1 as 'NY';

--=========================================================================================================
create table Employee
(
EmpNo int primary key,
EmpFname varchar(20) not null,
EmpLname varchar(20) not null,
DeptNo varchar(3) ,
Salary int unique,
foreign key (DeptNo) references Department(DeptNo)
)

create rule r2 as @x<6000;
sp_bindrule r2 , 'Employee.Salary';

CREATE TABLE Project (
    ProjectNo VARCHAR(10) PRIMARY KEY,
    ProjectName VARCHAR(100) NOT NULL,
    Budget INT NULL
);

CREATE TABLE Works_on (
    EmpNo INT,
    ProjectNo VARCHAR(10),
    Job VARCHAR(50),
    Enter_Date DATE,
    CONSTRAINT PK_Works_on PRIMARY KEY (EmpNo, ProjectNo)
);

--=========================================================================================================
insert into Department values
('d1', 'Research', 'NY'),
('d2', 'Accounting', 'DS'),
('d3', 'Marketing', 'KW')

insert into Employee values
(25348, 'mathew', 'smith', 'd3', 2500),
(10102, 'ann', 'jones', 'd3', 3000),
(18316, 'john', 'barrimore', 'd1', 2400),
(29346, 'james', 'james', 'd2', 2800),
(9031,  'lisa', 'bertoni', 'd2', 4000),
(2581,  'elisa', 'hansel', 'd2', 3600),
(28559, 'sybl', 'moser', 'd1', 2900);


INSERT INTO Project (ProjectNo, ProjectName, Budget) VALUES
('p1', 'Apollo', 120000),
('p2', 'Gemini', 95000),
('p3', 'Mercury', 185600);

INSERT INTO Works_on (EmpNo, ProjectNo, Job, Enter_Date) VALUES
(10102, 'p1', 'Analyst', '2006-10-01'),
(10102, 'p3', 'Manager', '2012-01-01'),
(25348, 'p2', 'Clerk', '2007-02-15'),
(18316, 'p2', NULL, '2007-06-01'),
(29346, 'p2', NULL, '2006-12-15'),
(2581,  'p3', 'Analyst', '2007-10-15'),
(9031,  'p1', 'Manager', '2007-04-15'),
(28559, 'p1', NULL, '2007-08-01'),
(28559, 'p2', 'Clerk', '2012-02-01'),
(9031,  'p3', 'Clerk', '2006-11-15'),
(29346, 'p1', 'Clerk', '2007-01-04');

--=========================================================================================================
select * from Employee
select * from Department
select * from Project
select * from works_on

select * from Employee e join works_on w
on e.EmpNo = w.EmpNo join project p 
on w.projectNo = p.projectNo

--=========================================================================================================
--1> 
insert into works_on (empno)
values (11111)

--2>
update works_on 
set empno = 11111 where empno = 10102

--3>
update Employee
set EmpNo = 22222 where EmpNo = 10102

--4>
delete Employee where EmpNo = 10102

--=========================================================================================================
--1>
alter table employee add TelephoneNumber int

--2>
alter table employee drop column TelephoneNumber

--=========================================================================================================
--2>
create schema Company
alter schema Company Transfer dbo.Department

create schema HR
alter schema HR Transfer dbo.Employee
--3>

SELECT 
    tc.CONSTRAINT_NAME,
    tc.CONSTRAINT_TYPE,
    kcu.COLUMN_NAME
FROM 
    INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS tc
JOIN 
    INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS kcu
    ON tc.CONSTRAINT_NAME = kcu.CONSTRAINT_NAME
WHERE 
    tc.TABLE_NAME = 'Employee';

--4>
create Synonym emp for HR.Employee

Select * from Employee
Select * from HR.Employee
Select * from Emp
Select * from HR.Emp

--5>
select * from company.project
select * from HR.Employee
select * from Company.Department
select * from works_on

update Company.Project
set Budget = Budget*1.10
from Company.Project cp join Works_on w
on cp.ProjectNo = w.ProjectNo
where w.Job ='manager'and w.EmpNo=10102 

--6>
update Company.Department
set DeptName = 'sales'
from Company.Department d join HR.Employee e
on d.DeptNo = e.DeptNo
where EmpFname = 'james'

--7>
update Works_on
set Enter_Date = '12.12.2007'
from works_on w join HR.employee e
on w.empno = e.empno join company.department d
on e.deptno = d.deptno
where w.ProjectNo = 'p1' and d.DeptNo = 'sales'


--8>
delete W
from works_on W join HR.Employee E on W.EmpNo = E.EmpNo 
join Company.Department D on E.DeptNo = D.DeptNo
where D.Location = 'KW'




--=========================================================================================================
--=========================================================================================================
--=========================================================================================================
