--1.�����ϵ����ѧ������
use XSCJ
go
IF EXISTS ( SELECT name FROM SYSOBJECTS WHERE name= 'sp_cxxs' and xtype='P')
 DROP PROCEDURE sp_cxxs
go
create procedure sp_cxxs
as
select Sname from S
where Sdept = '�����'
go
exec sp_cxxs


--2.�г����������޿γ����ƺͷ���
go
IF EXISTS ( SELECT name FROM SYSOBJECTS WHERE name= 'sp_cxcj' and xtype='P')
 DROP PROCEDURE sp_cxcj
go
create procedure sp_cxcj(@sname varchar(20))
as
select Cname,Score from C, SC,S
where S.Sno = SC.Sno
	and SC.Cno = C.Cno
	and S.Sname = @sname
go
exec sp_cxcj '��ǿ'
go

--3.����C���Կγ���߷�
go
IF EXISTS ( SELECT name FROM SYSOBJECTS WHERE name= 'sp_cxzgf' and xtype='P')
 DROP PROCEDURE sp_cxzgf
go
create procedure sp_cxzgf(@maxScore int output)
as
select @maxScore = MAX(Score) from SC, C
where SC.Cno = C.Cno
	and C.Cname = 'C����'
go

declare @maxScore int
exec sp_cxzgf @maxScore output
print 'C������߷�Ϊ��'+cast(@maxScore as varchar(10))
go

--4�����ظ����ĸ���ƽ����
go
IF EXISTS ( SELECT name FROM SYSOBJECTS WHERE name= 'sp_cxscore' and xtype='P')
 DROP PROCEDURE sp_cxscore
go
create procedure sp_cxscore(
	@sname varchar(20),
	@averScore float output
)
as
select @averScore=AVG(Score) from S, SC
where S.Sno = SC.Sno
	and S.Sname = @sname
go
declare @averScore float
declare @sname varchar(20)
set @sname = '��ǿ'
exec sp_cxscore @sname, @averScore output
print 'ѧ��'+@sname+'ƽ���ɼ�Ϊ��'+cast(@averScore as varchar(10))
go
/*exec sp_cxscore '��ǿ', @averScore output
print 'ѧ����ǿƽ���ɼ�Ϊ:' + cast(@averScore as varchar(10))
go*/

--6��sp_cxxs�洢���̶�����Ϣ
go
select text from syscomments
where id in(
	select id from sysobjects
	where name = 'sp_cxxs' and xtype = 'P'
)
go

--7��
--�޸�4�еĴ洢����
go
alter procedure sp_cxscore
(
	@Tname varchar(20),
	@TCavgScore float output
)
as
select @TCavgScore = AVG(Score) from C, SC
where C.Cno = SC.Cno
	and C.Cteacher = @Tname
go
--����
declare @Tname varchar(20), @TCavgScore float
set @Tname = '����'
exec sp_cxscore @Tname, @TCavgScore output
print @Tname+'��ʦ�����ڿγ̵�ƽ����Ϊ��'+ cast(@TCavgScore as varchar(10))
go

--8��ɾ��7�����Ĵ洢����
go
IF EXISTS ( SELECT name FROM SYSOBJECTS WHERE name= 'sp_cxscore' and xtype='P')
 DROP PROCEDURE sp_cxscore
go