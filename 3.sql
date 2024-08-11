/* 
Transaction
Bir havale i�lemi yapmak i�in gerekli t�m i�lemleri yapt�n�z ve X hesab�ndan Y hesab�na 10
TL para g�ndereceksiniz. Bu i�lemin programsal olarak yap�labilmesi i�in sizin hesab�n�zdaki
bakiyenin UPDATE ile g�ncellenerek azalt�lmas�, g�nderilen hesab�n bakiyeside g�ncellenerek
al�nan miktar kadar artt�r�lmas� gereklidir. Ancak teknolojide her �ey do�ru gitmeyebilir.
Bu i�lemler s�ras�nda herhangi bir hata olursa sizin hesab�n�zdan 10 TL d���lecek, ancak
kar�� taraf�n hesab� g�ncellenerek bakiye art�m� ger�ekle�meyebilir.

Veritaban� mimarisinde bu t�r i� s�reci (transaction) gerekti�inde uyulmas� gereken 
prensiplere ACID (Atomicity,Consistency,Isolation,Durability) denir.
* Atomic: Veritaban�nda ger�ekle�tirilen t�m i�lemlerin (insert, update, delete gibi) 
ba�ar�yla ger�ekle�tirilmesini (commit veya roll back edilmesini) garanti etmektedir.
* Consistent: Veritaban� tutarl�l���n� garanti almaktad�r. Bir transaction�da commit 
veya roll back i�lemi ger�ekle�ti�inde veritaban� tutarl���n� korumak �nemlidir. 
Bu nedenle transaction i�lemleri ba�ar�l�ysa t�m de�i�iklikler veri taban�na uygulan�r. 
E�er transaction ortas�nda hata ger�ekle�irse, t�m de�i�iklikler otomatik olarak geri 
al�n�r.
* Isolation: Her transaction i�lemi bireyseldir. Transaction tamamlan�ncaya kadar, bir 
transaction di�er transaction�lar�n sonucuna eri�emez. Bir transaction oturumu 
ba�lad���nda veriyi de�i�tirecek Insert, Update gibi ifadeler, sadece ge�erli oturumda
g�r�n�r.
* Durable: Bir transaction ba�ar� ile tamamland���nda (commit ger�ekle�ti�inde), 
elektrik kesintisi veya program ��kmesi durumunda de�i�iklikler veritaban�nda kal�c� 
olmal�d�r.


Yap�:

BEGIN TRAN[SACTION] [ transaction_ismi | @transaction_degiskeni]

Transaction'� tamamlamak: COMMIT TRAN
Transaction'�n tamamland���n� ve ger�ekle�tirilen transaction i�lemlerinin kal�c� olarak 
veritaban�na yans�t�lmas� i�in kullan�l�r.
Transaction taraf�ndan etkilenen t�m de�i�iklikler, i�lemlerin tamam� ger�ekle�mese bile,
bu i�lemden sonra kal�c� hale gelir
COMMIT TRAN[SACTION] [transaction_ismi | @transaction_degiskeni ]

Transaction � geri almak: rollback tran
rollback transaction'�n ger�ekle�tirdi�i t�m i�lemleri geri almak i�in kullan�l�r.
Yani yap�lan t�m i�lemler transaction'�n ba�lang�c�ndaki haline d�nd�r�l�r.
ROLLBACK TRAN[SACTION] [transaction_ismi | kayit_noktasi_ismi  | @transaction_degiskeni
| @kayit_noktasi_degiskeni]

Sabiteleme noktalar�: save tran
Sabitleme noktalar� olu�turulmas�, transaction i�ersinde ba�a d�nmek yerine belirlenen bir
i�lem noktas�na d�nmek i�in kullan�l�r.

Yap�:
SAVE TRAN[SACTION] [kayit_noktasi_ismi | @kayit_noktasi_degiskeni ]

*/

-- Bir banka veritaban�nda kullan�c� hesaplar�n� tutan ve farkl� iki banka hesab� aras�nda 
-- havale i�lemi yapan transaction

create database BankDB
use BankDB

create table Accounts(
	AccountID char(10) primary key not null,
	FirstName varchar(50),
	LastName varchar(50),
	Branch int,
	Balance money
)


insert into Accounts
values ('0000065127','Tahsin','Canpolat',489,10000),
	   ('0000064219','Ali','Veli',489,500),
	   ('0000068233','Hasan','Demir',252,5844)


create proc sp_MoneyTransfer(
		@PurchaserID char(10),
		@SenderID char(10),
		@Amount money,
		@retVal int out
)
as
begin
	declare @inControl money
	select @inControl = Balance from Accounts where AccountID = @SenderID
	if @inControl >= @Amount
	begin
		begin transaction
			update Accounts set Balance = Balance - @Amount where AccountID = @SenderID
		if @@ERROR<>0
		begin
			rollback
		end
			update Accounts set Balance = Balance + @Amount where AccountID = @PurchaserID
		if @@ERROR<>0
		begin
			rollback
		end
		commit
	end
	else
	begin
		set @retVal = -1
		return @retval
	end
end

declare @rval int
exec sp_MoneyTransfer '0000064219','0000065127',0,@rval output

if @rval = -1
begin
	print 'Bakiyeniz yetersiz'
end
else
begin
	select * from Accounts
end

select * from Accounts
