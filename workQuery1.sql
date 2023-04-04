use XSCJ
create table hyuser
(
	hyid int identity(1,1)primary key,
	hyname varchar(50) unique,
	hypwd varchar(50)
)

insert into hyuser(hyname, hypwd) values('stu1', '11111')
insert into hyuser(hyname, hypwd) values('stu2', '22222')
insert into hyuser(hyname, hypwd) values('stu3', '33333')

declare @hyuser varchar(50), @hypwd varchar(50)
set @hyuser = 'stu1'
set @hypwd = '11111'

--�ж��û��Ƿ����
if exists(select * from hyuser where hyname = @hyuser)
	print'���û�����'
else
	print'���û�������'

if exists(select * from hyuser where hyname = @hyuser and hypwd = @hypwd)
	print'���û�������ȷ�� �ɹ���¼��'
else
	print @@ERROR

create table SC2
(
	Sno varchar(5),
	Cno varchar(5) primary key(Sno, Cno),
	Score int,
	class varchar(10)
)
--alter table SC2 add class varchar

--select COUNT(Sno) from SC2 
--group by Cno
update SC2 set  class= 
  case
    when Score < 60 then '������'
	when Score >= 60 and Score <80 then '����'
	when Score >= 80 and Score <90 then '����'
	else '����'
  end

select class �ȼ�, COUNT(Sno)
from SC2
where Cno = 'C3'
group by class

select * from SC2
where Cno = 'C3'