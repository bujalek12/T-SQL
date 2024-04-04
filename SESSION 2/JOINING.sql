Create Table tblTransaction (
Amount smallmoney NOT NULL,
DateOfTransaction smalldatetime NULL,
EmployeeNumber int NOT NULL)

select tblEmployee.EmployeeNumber, EmployeeFirstName, EmployeeLastName, sum(Amount) as SumOfAmount
from tblEmployee left join tblTransaction
on tblEmployee.EmployeeNumber = tblTransaction.EmployeeNumber
GROUP BY tblEmployee.EmployeeNumber, EmployeeFirstName, EmployeeLastName
ORDER BY EmployeeNumber


select Department as NumberOfDepartments
into tblDepartment2
from
(select Department, count(*) as NumberPerDepartment
from tblEmployee
GROUP BY Department) as newTable

select distinct Department, convert(varchar(20), N'') as DepartmentHead
into tblDepartment
from tblEmployee

drop table tblDepartment

select * from tblDepartment

select * from tblDepartment2

alter table tblDepartment
alter column DepartmentHead varchar(30) null

select tblDepartment.Department, sum(Amount) as SumOfAmount
from tblDepartment
left join tblEmployee
on tblDepartment.Department = tblEmployee.Department
left join tblTransaction
on tblEmployee.EmployeeNumber = tblTransaction.EmployeeNumber
group by tblDepartment.Department



select DepartmentHead, sum(Amount) as SumOfAmount
from tblDepartment
left join tblEmployee
on tblDepartment.Department = tblEmployee.Department
left join tblTransaction
on tblEmployee.EmployeeNumber = tblTransaction.EmployeeNumber
group by DepartmentHead
order by DepartmentHead

insert into tblDepartment(Department,DepartmentHead)
values ('Accounts', 'James')

select D.DepartmentHead, Sum(T.Amount) as SumOfAmount
from tblDepartment as D
left join tblEmployee as E
on D.Department = E.Department
left join tblTransaction T
on E.EmployeeNumber = T.EmployeeNumber
group by D.DepartmentHead
order by D.DepartmentHead


