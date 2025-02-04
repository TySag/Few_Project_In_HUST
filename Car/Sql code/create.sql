use car;
/*user*/
create table Users(
  Uid char(10) primary key,
  Pass char(20) not null,
  Name char(10) null, 
  Mail char(20) not null,
  Phone char(15) null, Address char(30) null,
  Blacklabel bool default 1
);

create table CarsInfo(
  Name char(10) primary key,
  Brand char(10) null,
  /*Life int default 7300,*/
  Popular int not null,
  Totalnum int not null,
  Availnum int not null
);

create table Cars(
  Cid char(10) primary key,
  Name char(10) not null,
  Price int not null,
  Deposit int not null,
  Speed int not null,
  Days int not null default 0,
  State char(10) not null,
  foreign key(Name) references CarsInfo(Name)
  ON DELETE CASCADE
  ON UPDATE CASCADE
);

create table Staffs(
  Sid char(10) primary key,
  Pass char(20) not null,
  Name char(10), 
  Pos char(10)
);
  
create table Orders(
  Oid char(10) primary key,
  Cid char(10) not null,
  Uid char(10) not null,
  Days int default 1,
  Date Datetime not null default now(),
  Checked bool not null default 0,
  foreign key(Cid) references Cars(Cid)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  foreign key(Uid) references Users(Uid)
  ON DELETE CASCADE
  ON UPDATE CASCADE
);
  
create table Records(
  Rid char(10) primary key,
  Cid char(10) not null,
  Uid char(10) not null,
  Sid char(10) not null,
  Days int not null,
  Cost int not null,
  Date Datetime not null default now(),
  foreign key(Cid) references Cars(Cid)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  foreign key(Uid) references Users(Uid)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  foreign key(Sid) references Staffs(Sid)
  ON DELETE CASCADE
  ON UPDATE CASCADE
);
  
create table Fixlist(
  Fid char(10) primary key,
  Rid char(10) not null,
  Fix char(40),
  Cost int,
  foreign key(Rid) references Records(Rid)
  ON DELETE CASCADE
  ON UPDATE CASCADE
);

create table Accident(
  Aid char(10),
  Rid char(10) not null,
  Acc char(40),
  foreign key(Rid) references Records(Rid)
  ON DELETE CASCADE
  ON UPDATE CASCADE
);  

/*
insert delete Carsc -> CarsInfo
*/
delimiter |
create trigger addcar
after insert on cars
for each row 
begin
   update carsinfo 
   set Totalnum = Totalnum + 1,
   Availnum = Availnum + 1 
   where carsinfo.Name = new.Name;
end
|

delimiter |
create trigger movecar
after delete on cars
for each row 
begin
   update carsinfo 
   set Totalnum = Totalnum - 1,
   Availnum = Availnum - 1 
   where carsinfo.Name = old.Name;
end
|

delimiter |
create trigger addOrder
after insert on Orders
for each row 
begin
   update cars
   set cars.State = 'select'
   where cars.cid = new.cid;
   update carsinfo, cars
   set CarsInfo.Availnum = CarsInfo.Availnum - 1
   where cars.cid = new.cid and carsinfo.Name = cars.Name;
end
|

delimiter |
create trigger UpOrder
after update on Orders
for each row 
begin
   if new.Checked = true then
   update cars
   set cars.State = 'use'
   where cars.cid = old.cid;
   end if;
end
|

delimiter |
create trigger moveOrder
after delete on Orders
for each row 
begin
   update cars
   set cars.State = 'wait'
   where cars.cid = old.cid;
   update carsinfo, cars
   set CarsInfo.Availnum = CarsInfo.Availnum + 1
   where cars.cid = old.cid and carsinfo.Name = cars.Name;
end
|

delimiter |
create trigger addRecord
after insert on Records
for each row 
begin
   update cars
   set cars.State = 'wait',
   cars.Days = cars.Days + new.Days
   where cars.cid = new.cid;
   update carsinfo, cars
   set CarsInfo.Availnum = Availnum + 1,
   CarsInfo.Popular = CarsInfo.Popular + new.days
   where cars.cid = new.cid and carsinfo.Name = cars.Name;
end
|





/*drop trigger movecar;
drop trigger addOrder;
drop trigger addcar;drop trigger addOrder;
drop table Fixlist;
drop table accident;
drop table records;
drop table orders;
drop table cars;
drop table staffs;
drop table carsinfo;
drop table users;
*/