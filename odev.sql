-- �dev => �smini belirtti�imiz kategori alt�nda ka� adet �r�n oldu�unu veren 
-- procedure � yaz�n.

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

-- �dev => �al��anlar�n ya�lar�n� hesaplayan procedure � yaz�n
create proc sp_EmployeeCalcAge
as
begin
	select year(getdate()) - year(BirthDate) as '�al��anlar�n Ya��' from Employees
end

exec sp_EmployeeCalcAge

-- �dev => �r�ne g�re verilen sipari�lerin Quantitylerini gruplay�n. Group by

select p.ProductName,sum(od.Quantity) as 'Sipari� Miktar�' from Products p join
[Order Details] od on p.ProductID = od.ProductID
group by p.ProductName
order by 2