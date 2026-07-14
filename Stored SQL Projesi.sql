-- =======================================================
-- Create a procedure to list product names, suppliers, 
-- and categories in the Products table
-- =======================================================

create procedure urun_bilgi_getir
as
select ProductName,SupplierID,CategoryID FROM Products

execute urun_bilgi_getir

--====================================================
-- Modify the created procedure to accept a parameter
--====================================================
alter procedure urun_bilgi_getir
@isim varchar(50)='Tofu'
as
select ProductName, SupplierID, CategoryID
from Products
where ProductName=@isim

execute urun_bilgi_getir

--============================================================
-- Procedure to list products belonging to a specific category
--============================================================

create procedure kategoriye_gore_urun_getir
@kategori INT
as
select ProductID, ProductName, UnitPrice, UnitsInStock
from Products
where CategoryID=@kategori

execute kategoriye_gore_urun_getir 6

-- =======================================================
-- Create a procedure to see which products a specific 
-- order contains and the product quantity
-- =======================================================

create procedure siparis_detayý
@siparisdetay INT
as
select P.ProductName, OD.UnitPrice, OD.Quantity, 
OD.Discount From [order Details] OD
Inner Join Products P
On P.ProductID=OD.ProductID
where OD.OrderID=@siparisdetay

exec siparis_detayý 10277

--=======================================================
-- Procedure to list the top-selling products
--=======================================================

create procedure en_cok_satan_urun
@topurun INT
as
Select top (@topurun) P.ProductName,
SUM(OD.Quantity) as toplamsatis
from [Order Details] OD
inner join Products P
On P.ProductID=OD.ProductID
Group By P.ProductName
Order By toplamsatis DESC

exec en_cok_satan_urun 3

--=======================================================
-- Procedure to list out-of-stock products
--=======================================================

create procedure stokta_kalmayan_urun
AS
SELECT ProductID, ProductName, UnitsInStock
FROM Products where UnitsInStock = 0

exec stokta_kalmayan_urun

--=======================================================
-- To find the customer who placed the most orders
--=======================================================
create procedure cok_siparis_musteri1
as
select top 1 CustomerID, Count(OrderID) as SiparisSayisi
from Orders
Group by CustomerID
ORDER BY SiparisSayisi DESC;

exec cok_siparis_musteri1

--===============================================================
-- Procedure to get the latest order information of a customer
--===============================================================

create procedure son_siparis_bilgi
@musteri NCHAR(5)
as
select top 1 OrderID, OrderDate, RequiredDate, ShippedDate
from Orders where CustomerID=@musteri
Order by orderDate DESC

exec son_siparis_bilgi 'RATTC'

create procedure tum_siparis_bilgi
@musteri NCHAR(5)
as
select OrderID, OrderDate, RequiredDate, ShippedDate
from Orders where CustomerID=@musteri
Order by orderDate DESC

exec tum_siparis_bilgi 'RATTC'

alter procedure tum_siparis_bilgi
@musteri NCHAR(5)
as
select OrderID, OrderDate, RequiredDate, ShippedDate, Freight
from Orders where CustomerID=@musteri
Order by orderDate DESC

--===============================================================
-- Procedure to get the number of products grouped by categories
--===============================================================

create procedure kategorilenmis_urun
as
select C.CategoryName, count(P.ProductID)
from Categories C
inner join Products P
on C.categoryID=P.categoryID 
Group by C.CategoryName

exec kategorilenmis_urun

--========================================================
-- Procedure to calculate the average order delivery time
--========================================================

create procedure ortalama_teslimat_suresi
as
SELECT AVG(DATEDIFF(DAY, OrderDate, ShippedDate)) as OrtalamaTeslimatSuresi
from Orders where ShippedDate is Not Null

exec ortalama_teslimat_suresi
