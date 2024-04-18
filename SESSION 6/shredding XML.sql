---XQuery Value method
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

---XQuery Modify method
set @x.modify('replace value of (/Shopping/ShoppingTrip[1]/Item[3]/@Cost)[1]
                  with "6.0"')
select @x
set @x.modify('insert <Item Cost="5">New Food</Item>
			   into (/Shopping/ShoppingTrip)[2]')
select @x


---XQuery Query and FLWOR 1
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
select @x.query('for $ValueRetrieved in /Shopping/ShoppingTrip/Item
                 return $ValueRetrieved')
select @x.query('for $ValueRetrieved in /Shopping/ShoppingTrip/Item
                 return string($ValueRetrieved)')
select @x.query('for $ValueRetrieved in /Shopping/ShoppingTrip[1]/Item
                 return concat(string($ValueRetrieved),";")')

---XQuery Query and FLWOR 2
select @x.query('for $ValueRetrieved in /Shopping/ShoppingTrip[1]/Item
                 let $CostVariable := $ValueRetrieved/@Cost
                 where $CostVariable >= 4
                 order by $CostVariable
                 return concat(string($ValueRetrieved),";")')


---nodes using Variable (shredding a variable)
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
select tbl.col.value('.', 'varchar(50)') as Item
     , tbl.col.value('@Cost','varchar(50)') as Cost
into tblTemp
from @x.nodes('/Shopping/ShoppingTrip/Item') as tbl(col)

select * from tblTemp

drop table tblTemp
--for let where order by return


---notes using table (shredding a table)
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
  <Item>Furniture</Item>  
</ShoppingTrip>  
</Shopping>'  

drop table #tblXML
create table #tblXML(pkXML INT PRIMARY KEY, xmlCol XML)

insert into #tblXML(pkXML, xmlCol) VALUES (1, @x1)
insert into #tblXML(pkXML, xmlCol) VALUES (2, @x2)

select * from #tblXML
select tbl.col.value('@Cost','varchar(50)')
from #tblXML CROSS APPLY
xmlCol.nodes('/Shopping/ShoppingTrip/Item') as tbl(col)


