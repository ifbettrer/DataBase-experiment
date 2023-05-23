use XKXT

--���� ��ѧ����
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

--ѧ����ѡ������
--1.ʱ���ͻ
--2.ѧ�ֳ�ͻ
--3.���޿γ�ͻ
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
	  RAISERROR ('δѡ�����޿Σ�', 16, 1);
      ROLLBACK TRANSACTION;
    end
	if not exists(select Score from SC where SID = (select SID from inserted) and CID = (select PRECOURSE from C, inserted where C.ID = inserted.CID))  --�����Ƿ�ֹ���޿κ����ſ�ͬһѧ����
    begin
	  RAISERROR ('δѡ�����޿Σ�', 16, 1);
      ROLLBACK TRANSACTION;
    end
  end
end
go

DECLARE @da DATETIME = GETDATE();
insert into SC (SID,CID, DATE) values (1, 1, @da)

--ѧ�� �˿�����
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
  
  -- ������ļ�¼�Ƿ�ʱ�����Ҫ��
  IF EXISTS(SELECT DATE FROM deleted WHERE DATE < @twoWeekAgo)
  BEGIN
    -- �������ļ�¼ʱ����������ǰ����ʧ�ܲ����ش�����Ϣ
    RAISERROR ('����ɾ�������������Ͽγ�', 16, 1);
    ROLLBACK TRANSACTION;
  END
end
go

delete from SC where SID = 2 and CID = 2