---Scalar Functions 1
CREATE FUNCTION AmountPlusOne(@Amount smallmoney)
RETURNS smallmoney
AS
BEGIN

    RETURN @Amount + 1

END
GO


select DateOfTransaction, EmployeeNumber, Amount, dbo.AmountPlusOne(Amount) as AmountAndOne
from tblTransaction

DECLARE @myValue smallmoney
EXEC @myValue = dbo.AmountPlusOne @Amount = 345.67
select @myValue

---Scalar Functions 2

if object_ID(N'NumberOfTransactions',N'FN') IS NOT NULL
	DROP FUNCTION NumberOfTransactions
GO
CREATE FUNCTION NumberOfTransactions(@EmployeeNumber int)
RETURNS int
AS
BEGIN
	DECLARE @NumberOfTransactions INT
	SELECT @NumberOfTransactions = COUNT(*) FROM tblTransaction
	WHERE EmployeeNumber = @EmployeeNumber
	RETURN @NumberOfTransactions
END


---Inline Table Function
if object_ID(N'TransactionList',N'FN') IS NOT NULL
	DROP FUNCTION TransactionList
GO
CREATE FUNCTION TransactionList(@EmployeeNumber int)
RETURNS TABLE AS RETURN
(
    SELECT * FROM tblTransaction
	WHERE EmployeeNumber = @EmployeeNumber
)

SELECT * 
from dbo.TransactionList(123)

select *
from tblEmployee
where exists(select * from dbo.TransactionList(EmployeeNumber))

select distinct E.*
from tblEmployee as E
join tblTransaction as T
on E.EmployeeNumber = T.EmployeeNumber

select *
from tblEmployee as E
where exists(Select EmployeeNumber from tblTransaction as T where E.EmployeeNumber = T.EmployeeNumber)


---Apply
SELECT * 
from dbo.TransactionList(123)
GO

select *, (select count(*) from TransactionList(E.EmployeeNumber)) as NumTransactions
from tblEmployee as E

select *
from tblEmployee as E
outer apply TransactionList(E.EmployeeNumber) as T

select *
from tblEmployee as E
cross apply TransactionList(E.EmployeeNumber) as T

--123 left join TransList(123)
--124 left join TransList(124)

--outer apply all of tblEmployee, UDF 0+ rows
--cross apply UDF 1+ rows

--outer apply = LEFT JOIN
--cross apply = INNER JOIN

select *
from tblEmployee as E
where  (select count(*) from dbo.TransactionList(E.EmployeeNumber)) >3
