/* 
Pivot table

Pivot,table sorgu sonucu gelen tablo üzerindeki verileri belirli
bir satýrdaki veriler merkezinde kolonlara ayýrarak yatay olarak þekillendiren
verisel karþýlýk olarakta bu kolonlaþtýrýlan satýralara denk gelen deðerleri
basan bir raporlama fonksiyonudur.

*/
use Northwind

-- þehire göre satýþ adetleri
select ShipCity, COUNT(OrderID) [Satýþ adedi] from Orders
group by ShipCity

select * from (
select 
ShipCity, COUNT(OrderID) [Satýþ adedi] 
from Orders
group by ShipCity
) as SourceTable
PIVOT
(
	sum([Satýþ adedi])
	for ShipCity in ([Aachen],[Albuquerque],[Reims],[Münster])
) as PivotTable

select o.ShipCountry,e.FirstName + ' ' + e.LastName as [FullName],count(*) as [Satýþ adedi]
from Orders o join Employees e 
on o.EmployeeID = e.EmployeeID
group by o.ShipCountry,e.FirstName + ' ' + e.LastName

select * from (
select o.ShipCountry,e.FirstName + ' ' + e.LastName as Personel ,count(*) as [Satýþ adedi]
from Orders o join Employees e 
on o.EmployeeID = e.EmployeeID
group by o.ShipCountry,e.FirstName + ' ' + e.LastName) as UlkeSatisAdedi
PIVOT
(
	sum([Satýþ adedi])
	for ShipCountry in ([Argentina],[Austria],[Belgium],[Brazil],[Canada],[Denmark],[Finland],[France],[Germany])
) as PivotUlkeSatisAdedi

/* 
Temp Table
Geçici tablolar, ara sonuçlarý depolamaya ve iþlemeye olanak tanýyan kullanýþlý
bir özelliktir. Bu tablolarda select sorgularý aracýlýðýyla veriler sorgulanabilir ve update,
insert ve delete (dml) komutlarý ile de verilerde deðiþiklikler yapýlabilir. Bu açýdan ayný
kalýcý tablolar gibi davranýrlar
- Yerel geçici tablolar (local temporary tables) => #
- Global geçici tablolar (global temporary table) => ##

Not: bu oluþan tablolar databases seviyesinde oluþur.
Databases>System Databases>tempdb>Temporary Tables
*/

create table #LocalTempTable
(
	ProductCode int,
	ProductName varchar(50),
	PerUnit varchar(50)
)

insert into #LocalTempTable
values ('Iphone','10box')

select * from #LocalTempTable

drop table #LocalTempTable
-- tablomuzu temp table a aktarma
select ProductID,ProductName,QuantityPerUnit
into #LocalTempTable
from Products

-- Global Temp Table

create table ##GlobalTempTable
(
	ProductCode int,
	ProductName varchar(50),
	PerUnit varchar(50)
)

insert into ##GlobalTempTable
values (1001,'Iphone','10box')

select * from ##GlobalTempTable

drop table ##GlobalTempTable
-- tablomuzu temp table a aktarma
select ProductID,ProductName,QuantityPerUnit
into ##GlobalTempTable
from Products

/* 
	CTE (Common table expression)
	Geçici olarak var olan ve genelde yinelemeli(recursive) ve büyük
	sorgu ifadelerinde kullaným için olan bir sorgunun sonuç kümesi
	olarak düþünebiliriz.
	Viewler,Temp Table'lar ve Tablo tipi deðiþkenler gibi kullanýcýnýn
	okunabilirlik deneyimini arttýrma,soyutlaþtýrma, kolay yazýlabilirliði
	ve en zor sorgularýn bile basit bloklara dönüþmesinde yardýmcý olur.
*/

with cteOrderDatePrice as(
	select 
	year(o.OrderDate) as [Year],
	od.UnitPrice,
	od.Quantity
	from Orders o left join [Order Details] od
	on od.OrderID = o.OrderID
)
select [Year],sum(UnitPrice*Quantity) as TotalPrice
from cteOrderDatePrice group by [Year]

-- recursive (tekrar eden)

declare @StartDate date = '2021-04-22',
@EndDate date = '2021-05-22';

with cte as(
	select DATE = @StartDate, day = 1
	union all
	select DATE = DATEADD(DAY,1,DATE),DAY + 1	
	from cte
	where DATE< @EndDate
)
select Date , Day from cte
where @StartDate is not null
and @EndDate is not null
option (maxrecursion 0)









