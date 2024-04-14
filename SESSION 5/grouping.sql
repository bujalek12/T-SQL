---Adding Totals
select E.Department, E.EmployeeNumber, A.AttendanceMonth as AttendanceMonth, sum(A.NumberAttendance) as NumberAttendance
from tblEmployee as E join tblAttendance as A
on E.EmployeeNumber = A.EmployeeNumber
group by E.Department, E.EmployeeNumber, A.AttendanceMonth
--order by Department, EmployeeNumber, AttendanceMonth
UNION
select E.Department, E.EmployeeNumber, null as AttendanceMonth, sum(A.NumberAttendance) as TotalAttendance
from tblEmployee as E join tblAttendance as A
on E.EmployeeNumber = A.EmployeeNumber
group by E.Department, E.EmployeeNumber
union
select E.Department, null, null as AttendanceMonth, sum(A.NumberAttendance) as TotalAttendance
from tblEmployee as E join tblAttendance as A
on E.EmployeeNumber = A.EmployeeNumber
group by E.Department
union
select null, null, null as AttendanceMonth, sum(A.NumberAttendance) as TotalAttendance
from tblEmployee as E join tblAttendance as A
on E.EmployeeNumber = A.EmployeeNumber
order by Department, EmployeeNumber, AttendanceMonth

--- ROLLUP, GROUPING and GROUPING_ID
select E.Department, E.EmployeeNumber, A.AttendanceMonth as AttendanceMonth, sum(A.NumberAttendance) as NumberAttendance,
GROUPING(E.EmployeeNumber) AS EmployeeNumberGroupedBy,
GROUPING_ID(E.Department, E.EmployeeNumber, A.AttendanceMonth) AS EmployeeNumberGroupedID
from tblEmployee as E join tblAttendance as A
on E.EmployeeNumber = A.EmployeeNumber
group by ROLLUP (E.Department, E.EmployeeNumber, A.AttendanceMonth)
order by Department, EmployeeNumber, AttendanceMonth
--- GROUPING SETS
select E.Department, E.EmployeeNumber, A.AttendanceMonth as AttendanceMonth, sum(A.NumberAttendance) as NumberAttendance,
GROUPING(E.EmployeeNumber) AS EmployeeNumberGroupedBy,
GROUPING_ID(E.Department, E.EmployeeNumber, A.AttendanceMonth) AS EmployeeNumberGroupedID
from tblEmployee as E join tblAttendance as A
on E.EmployeeNumber = A.EmployeeNumber
group by GROUPING SETS ((E.Department, E.EmployeeNumber, A.AttendanceMonth), (E.Department), ())
order by coalesce(Department, 'zzzzzzz'), coalesce(E.EmployeeNumber, 99999), coalesce(AttendanceMonth,'2100-01-01')

select E.Department, E.EmployeeNumber, A.AttendanceMonth as AttendanceMonth, sum(A.NumberAttendance) as NumberAttendance,
GROUPING(E.EmployeeNumber) AS EmployeeNumberGroupedBy,
GROUPING_ID(E.Department, E.EmployeeNumber, A.AttendanceMonth) AS EmployeeNumberGroupedID
from tblEmployee as E join tblAttendance as A
on E.EmployeeNumber = A.EmployeeNumber
group by GROUPING SETS ((E.Department, E.EmployeeNumber, A.AttendanceMonth), (E.Department), ())
order by CASE WHEN Department       IS NULL THEN 1 ELSE 0 END, Department, 
         CASE WHEN E.EmployeeNumber IS NULL THEN 1 ELSE 0 END, E.EmployeeNumber, 
         CASE WHEN AttendanceMonth  IS NULL THEN 1 ELSE 0 END, AttendanceMonth
