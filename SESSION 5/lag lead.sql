---FIRST_VALUE and LAST_VALUE
select A.EmployeeNumber, A.AttendanceMonth, 
A.NumberAttendance, 
first_value(NumberAttendance)
over(partition by E.EmployeeNumber order by A.AttendanceMonth) as FirstMonth,
last_value(NumberAttendance)
over(partition by E.EmployeeNumber order by A.AttendanceMonth
rows between unbounded preceding and unbounded following) as LastMonth
from tblEmployee as E join tblAttendance as A
on E.EmployeeNumber = A.EmployeeNumber


---LAG and LEAD
select A.EmployeeNumber, A.AttendanceMonth, 
A.NumberAttendance, 
lag(NumberAttendance, 1)  over(partition by E.EmployeeNumber 
                            order by A.AttendanceMonth) as MyLag,
lead(NumberAttendance, 1) over(partition by E.EmployeeNumber 
                            order by A.AttendanceMonth) as MyLead,
NumberAttendance - lag(NumberAttendance, 1)  over(partition by E.EmployeeNumber 
                            order by A.AttendanceMonth) as MyDiff
--first_value(NumberAttendance)  over(partition by E.EmployeeNumber 
--                                    order by A.AttendanceMonth
--							        rows between 1 preceding and current row) as MyFirstValue,
--last_value(NumberAttendance) over(partition by E.EmployeeNumber 
--                                  order by A.AttendanceMonth
--								  rows between current row and 1 following) as MyLastValue
from tblEmployee as E join tblAttendance as A
on E.EmployeeNumber = A.EmployeeNumber


---CUME_DIST and PERCENT_RANK
select A.EmployeeNumber, A.AttendanceMonth, 
A.NumberAttendance, 
CUME_DIST()    over(partition by E.EmployeeNumber 
               order by A.AttendanceMonth) as MyCume_Dist,
PERCENT_RANK() over(partition by E.EmployeeNumber 
                order by A.AttendanceMonth) as MyPercent_Rank,
cast(row_number() over(partition by E.EmployeeNumber order by A.AttendanceMonth) as decimal(9,5))
/ count(*) over(partition by E.EmployeeNumber) as CalcCume_Dist,
cast(row_number() over(partition by E.EmployeeNumber order by A.AttendanceMonth) - 1 as decimal(9,5))
/ (count(*) over(partition by E.EmployeeNumber) - 1) as CalcPercent_Rank
from tblEmployee as E join tblAttendance as A
on E.EmployeeNumber = A.EmployeeNumber


----PERCENTILE_CONT and PERCENTILE_DISC
select A.EmployeeNumber, A.AttendanceMonth, 
A.NumberAttendance, 
CUME_DIST()    over(partition by E.EmployeeNumber 
               order by A.NumberAttendance) as MyCume_Dist,
PERCENT_RANK() over(partition by E.EmployeeNumber 
                order by A.NumberAttendance) * 100 as MyPercent_Rank
from tblEmployee as E join tblAttendance as A
on E.EmployeeNumber = A.EmployeeNumber

SELECT DISTINCT EmployeeNumber,
PERCENTILE_CONT(0.4) WITHIN GROUP (ORDER BY NumberAttendance) OVER (PARTITION BY EmployeeNumber) as AverageCont,
PERCENTILE_DISC(0.4) WITHIN GROUP (ORDER BY NumberAttendance) OVER (PARTITION BY EmployeeNumber) as AverageDisc
from tblAttendance
