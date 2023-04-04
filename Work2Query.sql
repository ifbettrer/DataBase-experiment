--1.计算机系所有学生姓名
use XSCJ
go
IF EXISTS ( SELECT name FROM SYSOBJECTS WHERE name= 'sp_cxxs' and xtype='P')
 DROP PROCEDURE sp_cxxs
go
create procedure sp_cxxs
as
select Sname from S
where Sdept = '计算机'
go
exec sp_cxxs


--2.列出该生的所修课程名称和分数
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
exec sp_cxcj '李强'
go

--3.返回C语言课程最高分
go
IF EXISTS ( SELECT name FROM SYSOBJECTS WHERE name= 'sp_cxzgf' and xtype='P')
 DROP PROCEDURE sp_cxzgf
go
create procedure sp_cxzgf(@maxScore int output)
as
select @maxScore = MAX(Score) from SC, C
where SC.Cno = C.Cno
	and C.Cname = 'C语言'
go

declare @maxScore int
exec sp_cxzgf @maxScore output
print 'C语言最高分为：'+cast(@maxScore as varchar(10))
go

--4、返回该生的各科平均分
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
set @sname = '李强'
exec sp_cxscore @sname, @averScore output
print '学生'+@sname+'平均成绩为：'+cast(@averScore as varchar(10))
go
/*exec sp_cxscore '李强', @averScore output
print '学生李强平均成绩为:' + cast(@averScore as varchar(10))
go*/

--6、sp_cxxs存储过程定义信息
go
select text from syscomments
where id in(
	select id from sysobjects
	where name = 'sp_cxxs' and xtype = 'P'
)
go

--7、
--修改4中的存储过程
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
--运行
declare @Tname varchar(20), @TCavgScore float
set @Tname = '刘军'
exec sp_cxscore @Tname, @TCavgScore output
print @Tname+'老师所教授课程的平均分为：'+ cast(@TCavgScore as varchar(10))
go

--8、删除7给出的存储过程
go
IF EXISTS ( SELECT name FROM SYSOBJECTS WHERE name= 'sp_cxscore' and xtype='P')
 DROP PROCEDURE sp_cxscore
go