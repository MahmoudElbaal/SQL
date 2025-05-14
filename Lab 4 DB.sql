use Company_SD

-- 1

select d.Dependent_name, e.Sex
from Dependent d inner join Employee e
 on d.ESSN = e.SSN
where e.Sex = 'F' and d.Sex = 'F'
UNION
select d.Dependent_name, e.Sex
from Dependent d inner join Employee e
 on d.ESSN = e.SSN
where e.Sex = 'M' and d.Sex = 'M'

--=========================================================================================================
-- 2

SELECT 	p.Pname ,sum(w.Hours) [total Hours Per Week]
FROM Project p LEFT JOIN Works_for w 
	ON p.Pnumber = w.Pno
Group by p.Pname

--=========================================================================================================
-- 3 

SELECT 	d.*	,e.SSN
FROM Departments d JOIN Employee e 
	ON d.Dnum = e.Dno
WHERE e.SSN = (	SELECT MIN(SSN) FROM Employee)

--=========================================================================================================
-- 4

select Dname , max(salary) as maxsalary , min(salary) as minsalary , avg(salary) as avgsalary 
from Departments d , Employee e	
where d.Dnum = e.Dno
group by Dname

--=========================================================================================================
-- 5

SELECT 	Fname + ' ' + Lname as fullname
FROM Employee e JOIN Departments d 
	ON e.SSN = d.MGRSSN
WHERE e.SSN NOT IN (Select ESSN FROM Dependent)

--=========================================================================================================
-- 6

SELECT 	d.Dname	,d.Dnum	,COUNT(e.SSN) AS #Employees	,AVG(Salary) AS avgSalary
FROM Departments d LEFT JOIN Employee e 
	ON d.Dnum = e.Dno
GROUP BY d.Dname, d.Dnum
HAVING AVG(e.Salary) < (SELECT AVG(Salary)FROM Employee)

--=========================================================================================================
-- 7 

SELECT Fname + ' ' + Lname as fullname ,p.Pname	,d.Dnum
FROM Employee e JOIN Works_for w 
	ON e.SSN = w.ESSn  
JOIN Project p 
	ON w.Pno = p.Pnumber 
JOIN Departments d 
	ON p.Dnum = d.Dnum

ORDER BY d.Dnum, Lname, Fname

--=========================================================================================================
-- 8

SELECT TOP 2  salary
FROM Employee
ORDER BY salary DESC;

--=========================================================================================================
-- 9

select Fname+' '+Lname as fullname ,  d.Dependent_name
from Employee e join Dependent d 
on e.SSN = d.ESSN
where d.Dependent_name like '%' + Fname+' '+Lname + '%' 

--=========================================================================================================
-- 10

SELECT SSN , Fname+' '+Lname as fullname
FROM Employee e
WHERE EXISTS (SELECT 1 FROM Dependent d WHERE d.ESSN = e.SSN)

--=========================================================================================================
-- 11

select * from Departments

INSERT INTO Departments (Dnum, Dname, MGRSSN, [MGRStart Date])
VALUES (100, 'DEPT IT', '112233', '2006-11-01');

--=========================================================================================================
-- 12

UPDATE Departments
	SET MGRSSN = 968574
	WHERE Dnum =100

UPDATE Departments
	SET MGRSSN = 102672
	WHERE Dnum = 20

UPDATE Employee
	SET Superssn = 102672
	WHERE SSN = 102660

--=========================================================================================================
-- 13 

SELECT Dependent_name
FROM Dependent
WHERE ESSN = 223344

UPDATE Dependent
	SET ESSN = 102672
	WHERE ESSN = 223344

SELECT *
FROM Departments
WHERE MGRSSN = 223344

UPDATE Departments
	SET MGRSSN = 102672
	WHERE MGRSSN = 223344

SELECT * 
FROM Employee
WHERE Superssn = 223344

UPDATE Employee
	SET Superssn = 102672
	WHERE Superssn = 223344

SELECT *
FROM Works_for
WHERE ESSn = 223344

UPDATE Works_for
	SET ESSn = 102672
	WHERE ESSn = 223344

DELETE FROM Employee
WHERE SSN = 223344

--=========================================================================================================
-- 14 

UPDATE Employee
	SET Salary = Salary * 1.30
	WHERE SSN IN (SELECT e.SSN FROM Employee e JOIN Works_for w 
			ON e.SSN = w.Essn
		JOIN Project p 
			ON w.Pno = p.Pnumber
		WHERE p.Pname = 'Al Rabwah')

-- OR

UPDATE Employee 
	SET Salary = Salary * 1.30
	FROM Employee e JOIN Works_for w 
		ON e.SSN= w.ESSn 
	JOIN Project p 
	ON p.Pnumber = w.Pno and p.Pname='Al Rabwah'


--=========================================================================================================
--=========================================================================================================
--=========================================================================================================