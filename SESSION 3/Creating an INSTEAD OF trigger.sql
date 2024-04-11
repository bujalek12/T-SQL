CREATE TRiGGER tr_tblDepartment
	ON dbo.tblDepartment
	AFTER DELETE, INSERT, UPDATE
	AS
	BEGIN
	SET NOCOUNT ON
	END


SET NOCOUNT ON
select * from tblDepartment
SET NOCOUNT OFF

ALTER TRIGGER tr_tblDepartment
ON tblTransaction
AFTER DELETE, INSERT, UPDATE
AS
BEGIN
	--insert into tblTransaction2
	select *, 'Inserted' from Inserted
	--insert into tblTransaction2
	select *, 'Deleted' from Deleted
END
GO

BEGIN TRAN
insert into tblTransaction(Amount, DateOfTransaction, EmployeeNumber)
VALUES (123,'2015-07-10', 123)
--delete tblTransaction 
--where EmployeeNumber = 123 and DateOfTransaction = '2015-07-10'
ROLLBACK TRAN
GO
DISABLE TRIGGER TR_tblTransaction ON tblTransaction;
GO
ENABLE TRIGGER TR_tblTransaction ON tblTransaction;
GO
DROP TRIGGER TR_tblTransaction;
GO


CREATE TRiGGER tr_ViewBYDepartment
ON dbo.ViewBYDepartment
INSTEAD of DELETE
AS
BEGIN
  SELECT *, 'ViewBYDepartment' FROM deleted
END



alter TRIGGER tr_ViewByDepartment
ON dbo.ViewByDepartment
INSTEAD OF DELETE
AS
BEGIN
    declare @EmployeeNumber as int
	declare @DateOfTransaction as smalldatetime
	declare @Amount as smallmoney
	select @EmployeeNumber = EmployeeNumber, @DateOfTransaction = DateOfTransaction,  @Amount = TotalAmount
	from deleted
	--SELECT * FROM deleted
	delete tblTransaction
	from tblTransaction as T
	where T.EmployeeNumber = @EmployeeNumber
	and T.DateOfTransaction = @DateOfTransaction
	and T.Amount = @Amount
END

begin tran
--SELECT * FROM ViewByDepartment where TotalAmount = -2.77 and EmployeeNumber = 132
delete from ViewByDepartment
where TotalAmount = -2.77 and EmployeeNumber = 132
--SELECT * FROM ViewByDepartment where TotalAmount = -2.77 and EmployeeNumber = 132
rollback tran
