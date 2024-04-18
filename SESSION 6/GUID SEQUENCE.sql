---Problems with IDENTITY
begin tran
insert into tblEmployee2
values ('New Name')
select * from tblEmployee2
rollback tran

truncate table tblEmployee2


---GUIDs
declare @newvalue as uniqueidentifier --GUID
SET @newvalue = NEWID()
SELECT @newvalue as TheNewID
GO
declare @randomnumbergenerator int = DATEPART(MILLISECOND,SYSDATETIME())+1000*(DATEPART(SECOND,SYSDATETIME())
                                     +60*(DATEPART(MINUTE,SYSDATETIME())+60*DATEPART(HOUR,SYSDATETIME())))
SELECT RAND(@randomnumbergenerator) as RandomNumber;

begin tran
Create table tblEmployee4
(UniqueID uniqueidentifier CONSTRAINT df_tblEmployee4_UniqueID DEFAULT NEWID(),
EmployeeNumber int CONSTRAINT uq_tblEmployee4_EmployeeNumber UNIQUE)

Insert into tblEmployee4(EmployeeNumber)
VALUES (1), (2), (3)
select * from tblEmployee4
rollback tran
go
declare @newvalue as uniqueidentifier
SET @newvalue = NEWSEQUENTIALID()
SELECT @newvalue as TheNewID
GO
begin tran
Create table tblEmployee4
(UniqueID uniqueidentifier CONSTRAINT df_tblEmployee4_UniqueID DEFAULT NEWSEQUENTIALID(),
EmployeeNumber int CONSTRAINT uq_tblEmployee4_EmployeeNumber UNIQUE)

 
rollback tran


---Defining SEQUENCES
BEGIN TRAN
CREATE SEQUENCE newSeq AS BIGINT
START WITH 1
INCREMENT BY 1
MINVALUE 1
--MAXVALUE 999999
--CYCLE
CACHE 50
CREATE SEQUENCE secondSeq AS INT
SELECT * FROM sys.sequences
ROLLBACK TRAN



---NEXT VALUE FOR sequence
BEGIN TRAN
CREATE SEQUENCE newSeq AS BIGINT
START WITH 1
INCREMENT BY 1
MINVALUE 1
CACHE 50
select NEXT VALUE FOR newSeq as NextValue;
--select *, NEXT VALUE FOR newSeq OVER (ORDER BY DateOfTransaction) as NextNumber from tblTransaction
rollback tran

CREATE SEQUENCE newSeq AS BIGINT
START WITH 1
INCREMENT BY 1
MINVALUE 1
--MAXVALUE 999999
--CYCLE
CACHE 50

alter table tblTransaction
ADD NextNumber int CONSTRAINT DF_Transaction DEFAULT NEXT VALUE FOR newSeq

alter table tblTransaction
drop DF_Transaction
alter table tblTransaction
drop column NextNumber

alter table tblTransaction
add NextNumber int
alter table tblTransaction
add CONSTRAINT DF_Transaction DEFAULT NEXT VALUE FOR newSeq for NextNumber

begin tran
select * from tblTransaction
INSERT INTO tblTransaction(Amount, DateOfTransaction, EmployeeNumber)
VALUES (1,'2017-01-01',123)
select * from tblTransaction WHERE EmployeeNumber = 123;
update tblTransaction
set NextNumber = NEXT VALUE FOR newSeq
where NextNumber is null
select * from tblTransaction --WHERE EmployeeNumber = 123
ROLLBACK TRAN

--SET IDENTITY_INSERT tablename ON
--DBCC CHECKIDENT(tablename,RESEED)

alter sequence newSeq
restart with 1

alter table tblTransaction
drop DF_Transaction
alter table tblTransaction
drop column NextNumber
DROP SEQUENCE newSeq
