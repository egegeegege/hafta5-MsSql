/* 
Transaction
Bir havale iþlemi yapmak için gerekli tüm iþlemleri yaptýnýz ve X hesabýndan Y hesabýna 10
TL para göndereceksiniz. Bu iþlemin programsal olarak yapýlabilmesi için sizin hesabýnýzdaki
bakiyenin UPDATE ile güncellenerek azaltýlmasý, gönderilen hesabýn bakiyeside güncellenerek
alýnan miktar kadar arttýrýlmasý gereklidir. Ancak teknolojide her þey doðru gitmeyebilir.
Bu iþlemler sýrasýnda herhangi bir hata olursa sizin hesabýnýzdan 10 TL düþülecek, ancak
karþý tarafýn hesabý güncellenerek bakiye artýmý gerçekleþmeyebilir.

Veritabaný mimarisinde bu tür iþ süreci (transaction) gerektiðinde uyulmasý gereken 
prensiplere ACID (Atomicity,Consistency,Isolation,Durability) denir.
* Atomic: Veritabanýnda gerçekleþtirilen tüm iþlemlerin (insert, update, delete gibi) 
baþarýyla gerçekleþtirilmesini (commit veya roll back edilmesini) garanti etmektedir.
* Consistent: Veritabaný tutarlýlýðýný garanti almaktadýr. Bir transaction’da commit 
veya roll back iþlemi gerçekleþtiðinde veritabaný tutarlýðýný korumak önemlidir. 
Bu nedenle transaction iþlemleri baþarýlýysa tüm deðiþiklikler veri tabanýna uygulanýr. 
Eðer transaction ortasýnda hata gerçekleþirse, tüm deðiþiklikler otomatik olarak geri 
alýnýr.
* Isolation: Her transaction iþlemi bireyseldir. Transaction tamamlanýncaya kadar, bir 
transaction diðer transaction’larýn sonucuna eriþemez. Bir transaction oturumu 
baþladýðýnda veriyi deðiþtirecek Insert, Update gibi ifadeler, sadece geçerli oturumda
görünür.
* Durable: Bir transaction baþarý ile tamamlandýðýnda (commit gerçekleþtiðinde), 
elektrik kesintisi veya program çökmesi durumunda deðiþiklikler veritabanýnda kalýcý 
olmalýdýr.


Yapý:

BEGIN TRAN[SACTION] [ transaction_ismi | @transaction_degiskeni]

Transaction'ý tamamlamak: COMMIT TRAN
Transaction'ýn tamamlandýðýný ve gerçekleþtirilen transaction iþlemlerinin kalýcý olarak 
veritabanýna yansýtýlmasý için kullanýlýr.
Transaction tarafýndan etkilenen tüm deðiþiklikler, iþlemlerin tamamý gerçekleþmese bile,
bu iþlemden sonra kalýcý hale gelir
COMMIT TRAN[SACTION] [transaction_ismi | @transaction_degiskeni ]

Transaction ý geri almak: rollback tran
rollback transaction'ýn gerçekleþtirdiði tüm iþlemleri geri almak için kullanýlýr.
Yani yapýlan tüm iþlemler transaction'ýn baþlangýcýndaki haline döndürülür.
ROLLBACK TRAN[SACTION] [transaction_ismi | kayit_noktasi_ismi  | @transaction_degiskeni
| @kayit_noktasi_degiskeni]

Sabiteleme noktalarý: save tran
Sabitleme noktalarý oluþturulmasý, transaction içersinde baþa dönmek yerine belirlenen bir
iþlem noktasýna dönmek için kullanýlýr.

Yapý:
SAVE TRAN[SACTION] [kayit_noktasi_ismi | @kayit_noktasi_degiskeni ]

*/

-- Bir banka veritabanýnda kullanýcý hesaplarýný tutan ve farklý iki banka hesabý arasýnda 
-- havale iþlemi yapan transaction

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
