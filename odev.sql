-- Ödev => Ýsmini belirttiðimiz kategori altýnda kaç adet ürün olduðunu veren 
-- procedure ü yazýn.

create proc sp_CategoryProductCount @categoryName varchar(max)
as
begin
	declare @categoryID int
	select @categoryID = CategoryID from Categories where  CategoryName = @categoryName
	declare @productCount int
	select @productCount = count(ProductID) from Products where CategoryID = @categoryID
	print (@productCount)
end

exec sp_CategoryProductCount 'Seafood'

-- Ödev => Çalýþanlarýn yaþlarýný hesaplayan procedure ü yazýn
create proc sp_EmployeeCalcAge
as
begin
	select year(getdate()) - year(BirthDate) as 'Çalýþanlarýn Yaþý' from Employees
end

exec sp_EmployeeCalcAge

-- Ödev => Ürüne göre verilen sipariþlerin Quantitylerini gruplayýn. Group by

select p.ProductName,sum(od.Quantity) as 'Sipariþ Miktarý' from Products p join
[Order Details] od on p.ProductID = od.ProductID
group by p.ProductName
order by 2