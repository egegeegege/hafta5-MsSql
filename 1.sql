-- instead of trigger
-- ana sorguyu engelleyen ve sadece trigger�n yapaca�� i�i yapabilen trigger.

create trigger tg_DeleteEmployee
on Employees
instead of delete
as
begin
	print ('Silme i�lemi ger�ekle�tiremezsiniz')
end	

delete from Employees where EmployeeID = 10
select * from Employees