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
  print('�����ڸô������������½�')
go 
create trigger tri_Delete_C on C
after delete --��ɾ������֮���SC����в���
as
  delete from SC
  where cno in(
	select cno from deleted
  )
go

delete from C
where C.Cno = 'C5'

--F:\SQL Server\MSSQL15.ZZY\MSSQL\Backup\   �������ݿ��ļ�·��

--insert into C values('C5','���������','��־��')
--insert into SC values('S1','C5', 88)

--2
go
if exists(select name from sysobjects where name = 'tri_Insert_S' and xtype = 'TR')
  begin
	drop trigger tri_Insert_S
  end
else
  print('�����ڸô������������½�')
go
create trigger tri_Insert_S on S
after insert, update
as
if exists(
	select * from inserted
	where Sage not between 18 and 25
  )
  begin
	print('�����SageֵҪ��18��25֮��')
	rollback transaction
  end
go
insert into S values('S8','С��','��',17,'��Ϣ��ȫ')

--3
go
if exists(select name from sysobjects where name = 'tri_Update_SC' and xtype = 'TR')
	begin
	drop trigger tri_Update_SC
	end
else
	print('�����ڸô������������½�')
go
create trigger tri_Update_SC on SC
after update
as
if update(score)
  begin
	print('��������޸�ѧ���ɼ���')
	rollback transaction
  end
go
update SC set score = 90
where Sno = 'S1'

--4
exec sp_help tri_Delete_C
exec sp_helptext tri_Delete_C
exec sp_helptrigger C

--5 ����tri_Update_SC������
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
	print('����������0��100֮��')
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
--��������������͸�ֵ�����ڴ��������棬��Ȼû����ֵ
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
		print('����ɾ���ѱ�ѡ��Ŀγ���Ϣ��')
		rollback transaction
	  end
end
go
--insert into C values('C7','��������ԭ��','�ޱ���')
delete from C
where Cno = 'C1'
--where Cno = 'C7'