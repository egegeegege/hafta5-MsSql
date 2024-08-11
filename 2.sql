-- Views 
-- Sanal tablolar oluþturmak için kullanýlýr.
create view vw_employee
as
select * from Employees

select * from vw_employee

create view vw_product
as
select * from Products

select * from vw_product

create view vw_productOrderCount
as
select p.ProductName,sum(od.Quantity) as 'Sipariþ Miktarý' from Products p join
[Order Details] od on p.ProductID = od.ProductID
group by p.ProductName

select * from vw_productOrderCount

create view vw_CategoryName
as
select CategoryName from Categories

select * from vw_CategoryName


create view vw_OrderUnitPrice
as
select * from [Order Details] where UnitPrice>100

select * from vw_OrderUnitPrice


create view vw_selectShipFrance
as
select * from Orders where ShipCountry in ('France')

select * from vw_selectShipFrance