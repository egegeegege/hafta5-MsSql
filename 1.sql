-- instead of trigger
-- ana sorguyu engelleyen ve sadece triggerýn yapacaðý iþi yapabilen trigger.

create trigger tg_DeleteEmployee
on Employees
instead of delete
as
begin
	print ('Silme iþlemi gerçekleþtiremezsiniz')
end	

delete from Employees where EmployeeID = 10
select * from Employees