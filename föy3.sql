CREATE DATABASE [F�Y3]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'F�Y3', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.PRODONUR\MSSQL\DATA\F�Y3.mdf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'F�Y3_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.PRODONUR\MSSQL\DATA\F�Y3_log.ldf' , SIZE = 8192KB , FILEGROWTH = 65536KB )

=========================================================================================================================



CREATE TABLE Birimler (
    birim_id INT NOT NULL,
    birim_adi CHAR(25) NOT NULL,
    PRIMARY KEY (birim_id)
);

CREATE TABLE Calisanlar (
    calisan_id INT NOT NULL,
    ad CHAR(25),
	soyad CHAR(25),
	maas int,
	katimaTarihi datetime,
	calisan_birim_id INT NOT NULL,
	PRIMARY KEY (calisan_id),
	FOREIGN KEY (calisan_birim_id) REFERENCES Birimler(birim_id),
);

CREATE TABLE Ikramiye (
    ikramiye_calisan_id INT NOT NULL,
    ikramiye_ucret int,
	ikramiye_tarih datetime,
	FOREIGN KEY (ikramiye_calisan_id) REFERENCES Calisanlar(calisan_id),
);

CREATE TABLE Unvan (
	unvan_calisan_id int not null,
	unvan_calisan char(25),
	unvan_tarih datetime
	FOREIGN KEY (unvan_calisan_id) REFERENCES Calisanlar(calisan_id),
);
==========================================================================================
Begin transaction;
insert into Birimler values('1','Yaz�l�m');
insert into Birimler values('2','Donan�m');
insert into Birimler values('3','G�venlik');
insert into Calisanlar values('1','�smail','��eri','100000','2014-02-20 00:00:00.000','1');
insert into Calisanlar values('2','Hami','Sat�lm��','80000','2014-06-11 00:00:00.000','1');
insert into Calisanlar values('3','Durmu�','�ahin','300000','2014-02-20 00:00:00.000','2');
insert into Calisanlar values('4','Ka�an','Yazar','500000','2014-02-20 00:00:00.000','3');
insert into Calisanlar values('5','Meryem','Soysald�','500000','2014-06-11 00:00:00.000','3');
insert into Calisanlar values('6','Duygu','Ak�ehir','200000','2014-06-11 00:00:00.000','2');
insert into Calisanlar values('7','K�bra','Seyhan','75000','2014-01-20 00:00:00.000','1');
insert into Calisanlar values('8','G�lcan','Y�ld�z','90000','2014-04-11 00:00:00.000','3');
insert into Ikramiye values ('1','5000','2016-02-20 00:00:00.000');
insert into Ikramiye values ('2','3000','2016-06-11 00:00:00.000');
insert into Ikramiye values ('3','4000','2016-02-20 00:00:00.000');
insert into Ikramiye values ('1','4500','2016-02-20 00:00:00.000');
insert into Ikramiye values ('2','3500','2016-06-11 00:00:00.000');
insert into Unvan values ('1','Y�netici','2016-02-20 00:00:00.000');
insert into Unvan values ('2','Personel','2016-06-11 00:00:00.000');
insert into Unvan values ('8','Personel','2016-06-11 00:00:00.000');
insert into Unvan values ('5','M�d�r','2016-06-11 00:00:00.000');
insert into Unvan values ('4','Y�netici Yard�mc�s�','2016-06-11 00:00:00.000');
insert into Unvan values ('7','Personel','2016-06-11 00:00:00.000');
insert into Unvan values ('6','Tak�m Lideri','2016-06-11 00:00:00.000');
insert into Unvan values ('3','Tak�m Lideri','2016-06-11 00:00:00.000');
commit transaction;
============================================================================================
SELECT c.ad, c.soyad, c.maas, b.birim_adi, b.birim_id
FROM Calisanlar c
join Birimler b on b.birim_id = c.calisan_birim_id
WHERE calisan_birim_id = 1 OR calisan_birim_id= 2;
===========================================================================================
SELECT ad, soyad, maas
FROM Calisanlar order by 3 desc;

SELECT ad, soyad, maas
FROM Calisanlar order by maas desc;
=========================================================================================
SELECT c.calisan_birim_id, b.birim_adi, COUNT(*) AS �al��anSay�s�
FROM Calisanlar c 
join Birimler b on b.birim_id=c.calisan_birim_id
GROUP BY c.calisan_birim_id, b.birim_adi;
=========================================================================================
select COUNT(unvan_calisan) as Ayn��nvanaSahipBirdenFazla�al��anSay�s�, unvan_calisan
from unvan
GROUP BY unvan_calisan
HAVING COUNT(unvan_calisan) > 1;
========================================================================================
select ad, soyad, maas from Calisanlar where maas between '50000' and '100000' order by 3 desc;
========================================================================================
select  c.ad, c.soyad, b.birim_adi, u.unvan_calisan, i.ikramiye_ucret
from Ikramiye i
join Calisanlar c on i.ikramiye_calisan_id=c.calisan_id
join Birimler b on b.birim_id=c.calisan_birim_id
join Unvan u on u.unvan_calisan_id=c.calisan_id;
=========================================================================================
select c.ad, c.soyad, u.unvan_calisan
from Unvan u 
join  Calisanlar c on c.calisan_id=u.unvan_calisan_id
where unvan_calisan ='Y�netici' or unvan_calisan='M�d�r'
======================================================================================
SELECT b.birim_adi, c.ad, c.soyad, c.maas
FROM (SELECT calisan_birim_id, MAX(maas) AS max_maas FROM Calisanlar GROUP BY calisan_birim_id) as	max_maas_table
JOIN Calisanlar c ON max_maas_table.calisan_birim_id = c.calisan_birim_id AND max_maas_table.max_maas = c.maas
JOIN Birimler b ON c.calisan_birim_id = b.birim_id;
=======================================================================================