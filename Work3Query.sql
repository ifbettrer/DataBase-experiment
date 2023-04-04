use XSCJ

select * from C
select * from SC

--1
go
if exists(select name from sysobjects where name = 'tri_Delete_C' and xtype = 'TR')
  begin
	drop trigger tri_Delete_C
  end
else
  print('不存在该触发器，可以新建')
go 
create trigger tri_Delete_C on C
after delete --在删除操作之后对SC表进行操作
as
  delete from SC
  where cno in(
	select cno from deleted
  )
go

delete from C
where C.Cno = 'C5'

--F:\SQL Server\MSSQL15.ZZY\MSSQL\Backup\   备份数据库文件路径

--insert into C values('C5','计算机网络','孙志鹏')
--insert into SC values('S1','C5', 88)

--2
go
if exists(select name from sysobjects where name = 'tri_Insert_S' and xtype = 'TR')
  begin
	drop trigger tri_Insert_S
  end
else
  print('不存在该触发器，可以新建')
go
create trigger tri_Insert_S on S
after insert, update
as
if exists(
	select * from inserted
	where Sage not between 18 and 25
  )
  begin
	print('插入的Sage值要在18到25之间')
	rollback transaction
  end
go
insert into S values('S8','小明','男',17,'信息安全')

--3
go
if exists(select name from sysobjects where name = 'tri_Update_SC' and xtype = 'TR')
	begin
	drop trigger tri_Update_SC
	end
else
	print('不存在该触发器，可以新建')
go
create trigger tri_Update_SC on SC
after update
as
if update(score)
  begin
	print('不能随便修改学生成绩！')
	rollback transaction
  end
go
update SC set score = 90
where Sno = 'S1'

--4
exec sp_help tri_Delete_C
exec sp_helptext tri_Delete_C
exec sp_helptrigger C

--5 禁用tri_Update_SC触发器
alter table SC disable trigger tri_Update_SC
--update SC set score = 80
--where Sno = 'S2'
update SC set score = 72
where Sno = 'S2'
select * from SC where Sno = 'S2'

--6
use XSCJ
go
if exists(select name from sysobjects where name = 'tri_Insert_SC' and xtype = 'TR')
  begin
	drop trigger tri_Insert_SC
  end
go
create trigger tri_Insert_SC on SC
instead of insert
as
if exists(select * from inserted where Score not between 0 and 100)
  begin
	print('分数必须在0到100之间')
  end
else
	insert into SC select * from inserted
go
insert into SC values('S6', 'C4', 107)
select * from SC
insert into SC values('S6', 'C4', 87)
select * from SC
/*delete from SC
where Sno = 'S6' and Cno = 'C4'*/

--7
use XSCJ
go
if exists(select name from sysobjects where name = 'tri_Update_S' and xtype = 'TR')
  begin
	drop trigger tri_Update_S
  end
go
--declare @OldSno varchar(20), @NewSno varchar(20)
--select @OldSno = Sno from deleted
--这里变量的声明和赋值必须在触发器里面，不然没法赋值
go
create trigger tri_Update_S on S
after update
as
  if update(Sno)
	begin
		declare @OldSno varchar(20), @NewSno varchar(20)
		select @OldSno = Sno from deleted
		select @NewSno = Sno from inserted
		update SC set Sno = @NewSno where Sno = @OldSno
	end
go
update S set Sno = 'S0'
where Sno = 'S1'
/*update S set Sno = 'S1'
where Sno = 'S0'*/

select * from S 
select * from SC 
select * from C
--8
use XSCJ
go
if exists(select name from sysobjects where name = 'tri_Delete_C' and xtype = 'TR')
  begin
	drop trigger tri_Delete_C
  end
go
create trigger tri_Delete_C on C
after delete
as
  begin
    declare @deleCno varchar(20)
	select @deleCno = Cno from deleted
	if exists(select * from SC where Cno = @deleCno)
	  begin
		print('不能删除已被选择的课程信息！')
		rollback transaction
	  end
end
go
--insert into C values('C7','计算机组成原理','罗贝贝')
delete from C
where Cno = 'C1'
--where Cno = 'C7'