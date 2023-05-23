use XKXT

--教务处 退学处理
go
if exists(select name from sysobjects where name = 'tri_delete_S' and xtype = 'TR')
  begin
	drop trigger tri_delete_S
  end
go
create trigger tri_delete_S on S
after delete
as
	delete from SC
	where SID in(
		select ID from deleted
	)
	delete from ADMINISTRATOR
	where ID =CAST(
		(select ID from deleted) as varchar
	)
go

delete from S where ID = 333

--学生，选课申请
--1.时间冲突
--2.学分冲突
--3.先修课冲突
go
if exists(select name from sysobjects where name = 'tri_insert_SC1' and xtype = 'TR')
  begin
	drop trigger tri_insert_SC1
  end
go
create trigger tri_insert_SC1 on SC
after insert
as
begin 
  DECLARE @invalid_pair_count INT = 0;
  SELECT @invalid_pair_count = COUNT(*)
  FROM inserted AS I
  JOIN C ON C.ID = I.CID
  WHERE C.PRECOURSE IS NOT NULL
    AND NOT EXISTS (
      SELECT 1 FROM SC
      WHERE SID = I.SID
        AND CID = C.PRECOURSE
    );
  if(@invalid_pair_count >0)
  begin
    if not exists(select * from C,SC where C.ID = SC.CID and SC.SID = (select SID from inserted) and C.ID = (select PRECOURSE from C, inserted where C.ID = inserted.CID))
    begin
	  RAISERROR ('未选择先修课！', 16, 1);
      ROLLBACK TRANSACTION;
    end
	if not exists(select Score from SC where SID = (select SID from inserted) and CID = (select PRECOURSE from C, inserted where C.ID = inserted.CID))  --这里是防止先修课和这门课同一学期修
    begin
	  RAISERROR ('未选择先修课！', 16, 1);
      ROLLBACK TRANSACTION;
    end
  end
end
go

DECLARE @da DATETIME = GETDATE();
insert into SC (SID,CID, DATE) values (1, 1, @da)

--学生 退课申请
go
if exists(select name from sysobjects where name = 'tri_delete_SC' and xtype = 'TR')
  begin
	drop trigger tri_delete_SC
  end
go
create trigger tri_delete_SC on SC
after delete
as
begin
  DECLARE @now DATETIME = GETDATE();
  DECLARE @twoWeekAgo DATETIME = DATEADD(WEEK, -2, @now);
  
  -- 检查插入的记录是否时间符合要求
  IF EXISTS(SELECT DATE FROM deleted WHERE DATE < @twoWeekAgo)
  BEGIN
    -- 如果插入的记录时间早于两周前，则失败并返回错误消息
    RAISERROR ('不能删除开课两周以上课程', 16, 1);
    ROLLBACK TRANSACTION;
  END
end
go

delete from SC where SID = 2 and CID = 2