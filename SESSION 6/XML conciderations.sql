---Importing and exporting XML using the bcp utility
bcp [SESSION6].dbo.tblDepartment out mydata.out -N -T
create table dbo.tblDepartment2
([Department] varchar(19) null,
[DepartmentHead] varchar(19) null)
bcp [SESSION6].dbo.tblDepartment2 in mydata.out -N –T


---Bulk Insert and Openrowset
drop table #tblXML
go
create table #tblXML(XmlCol xml)
go
bulk insert #tblXML from 'C:\Users\DELL\Desktop\T-SQL\SESSION 6\xml\SampleDataBulkInsert.txt'
select * from #tblXML

drop table #tblXML
go
create table #tblXML(IntCol int, XmlCol xml)
go
insert into #tblXML(XmlCol)
select * from
openrowset(BULK 'C:\Users\DELL\Desktop\T-SQL\SESSION 6\xml\SampleDataOpenRowset.txt', SINGLE_BLOB) AS x
select * from #tblXML


---Schema
select E.EmployeeNumber, E.EmployeeFirstName, E.EmployeeLastName
	   , T.Amount, T.DateOfTransaction
from [dbo].[tblEmployee] as E
left join [dbo].[tblTransaction] as T
on E.EmployeeNumber = T.EmployeeNumber
where E.EmployeeNumber between 200 and 202
for xml raw, xmlschema --, xmldata


---XML Indexes
declare @x xml  
set @x='<Shopping ShopperName="Phillip Burton" >  
<ShoppingTrip ShoppingTripID="L1" >  
  <Item Cost="5">Bananas</Item>  
  <Item Cost="4">Apples</Item>  
  <Item Cost="3">Cherries</Item>  
</ShoppingTrip>  
<ShoppingTrip ShoppingTripID="L2" >  
  <Item>Emeralds</Item>  
  <Item>Diamonds</Item>  
  <Item>Furniture</Item>  
</ShoppingTrip>  
</Shopping>'  
select @x.value('(/Shopping/ShoppingTrip/Item/@Cost)[1]','varchar(50)')

declare @x1 xml, @x2 xml 
set @x1='<Shopping ShopperName="Phillip Burton" >  
<ShoppingTrip ShoppingTripID="L1" >  
  <Item Cost="5">Bananas</Item>  
  <Item Cost="4">Apples</Item>  
  <Item Cost="3">Cherries</Item>
</ShoppingTrip></Shopping>'
set @x2='<Shopping ShopperName="Phillip Burton" >
<ShoppingTrip ShoppingTripID="L2" >  
  <Item>Emeralds</Item>  
  <Item>Diamonds</Item>  
  <Item>Furniture
        <Color></Color></Item>  
</ShoppingTrip>  
</Shopping>'  

drop table #tblXML;
create table #tblXML(pkXML INT PRIMARY KEY, xmlCol XML)

insert into #tblXML(pkXML, xmlCol) VALUES (1, @x1)
insert into #tblXML(pkXML, xmlCol) VALUES (2, @x2)

create primary xml index pk_tblXML on #tblXML(xmlCol)
create xml index secpk_tblXML_Path on #tblXML(xmlCol)
       using xml index pk_tblXML FOR PATH
create xml index secpk_tblXML_Value on #tblXML(xmlCol)
       using xml index pk_tblXML FOR VALUE
create xml index secpk_tblXML_Property on #tblXML(xmlCol)
       using xml index pk_tblXML FOR PROPERTY
