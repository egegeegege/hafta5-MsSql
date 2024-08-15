/* 
Pivot table

Pivot,table sorgu sonucu gelen tablo �zerindeki verileri belirli
bir sat�rdaki veriler merkezinde kolonlara ay�rarak yatay olarak �ekillendiren
verisel kar��l�k olarakta bu kolonla�t�r�lan sat�ralara denk gelen de�erleri
basan bir raporlama fonksiyonudur.

*/
use Northwind

-- �ehire g�re sat�� adetleri
select ShipCity, COUNT(OrderID) [Sat�� adedi] from Orders
group by ShipCity

select * from (
select 
ShipCity, COUNT(OrderID) [Sat�� adedi] 
from Orders
group by ShipCity
) as SourceTable
PIVOT
(
	sum([Sat�� adedi])
	for ShipCity in ([Aachen],[Albuquerque],[Reims],[M�nster])
) as PivotTable

select o.ShipCountry,e.FirstName + ' ' + e.LastName as [FullName],count(*) as [Sat�� adedi]
from Orders o join Employees e 
on o.EmployeeID = e.EmployeeID
group by o.ShipCountry,e.FirstName + ' ' + e.LastName

select * from (
select o.ShipCountry,e.FirstName + ' ' + e.LastName as Personel ,count(*) as [Sat�� adedi]
from Orders o join Employees e 
on o.EmployeeID = e.EmployeeID
group by o.ShipCountry,e.FirstName + ' ' + e.LastName) as UlkeSatisAdedi
PIVOT
(
	sum([Sat�� adedi])
	for ShipCountry in ([Argentina],[Austria],[Belgium],[Brazil],[Canada],[Denmark],[Finland],[France],[Germany])
) as PivotUlkeSatisAdedi

/* 
Temp Table
Ge�ici tablolar, ara sonu�lar� depolamaya ve i�lemeye olanak tan�yan kullan��l�
bir �zelliktir. Bu tablolarda select sorgular� arac�l���yla veriler sorgulanabilir ve update,
insert ve delete (dml) komutlar� ile de verilerde de�i�iklikler yap�labilir. Bu a��dan ayn�
kal�c� tablolar gibi davran�rlar
- Yerel ge�ici tablolar (local temporary tables) => #
- Global ge�ici tablolar (global temporary table) => ##

Not: bu olu�an tablolar databases seviyesinde olu�ur.
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
	Ge�ici olarak var olan ve genelde yinelemeli(recursive) ve b�y�k
	sorgu ifadelerinde kullan�m i�in olan bir sorgunun sonu� k�mesi
	olarak d���nebiliriz.
	Viewler,Temp Table'lar ve Tablo tipi de�i�kenler gibi kullan�c�n�n
	okunabilirlik deneyimini artt�rma,soyutla�t�rma, kolay yaz�labilirli�i
	ve en zor sorgular�n bile basit bloklara d�n��mesinde yard�mc� olur.
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









