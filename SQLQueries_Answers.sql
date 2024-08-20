--Introductory and Advanced SQL Practice 
-- 1. 
Select * from Shippers;

--2. 
Select CategoryName, Description from Categories;

--3. 
Select FirstName, LastName, HireDate, Country
from Employees
where title = 'Sales Representative'

--4. 
Select FirstName, LastName, HireDate
from Employees
where title = 'Sales Representative'
and country Like 'USA'

--5.
Select OrderID, OrderDate 
from Orders
Where EmployeeID = 5 

--6. 
Select SupplierID, ContactName, ContactTitle 
from Suppliers 
where ContactTitle<>'Marketing Manager'

--7. 
Select ProductID, 
ProductName 
from Products
where ProductName Like 'Queso%'

--8. 
Select OrderID, CustomerID, ShipCountry
From Orders
where ShipCountry = 'France' 
or ShipCountry = 'Belgium'

--9. 
Select OrderID, CustomerID, ShipCountry
From Orders
where ShipCountry IN ('Brazil', 'Mexico', 'Argentina', 'Venezuela')

--10. 
Select FirstName, LastName, Title, BirthDate
from Employees
Order by BirthDate 

--11. 
Select FirstName, LastName, Title, Convert(Varchar(30), BirthDate, 110) as DateOnlyBirthDate
from Employees
Order by BirthDate 

--12. 
Select FirstName, LastName, FirstName + ' ' + LastName As FullName
From Employees 

--13. 
Select 
OrderID, 
ProductID, 
UnitPrice, 
Quantity, 
(UnitPrice * Quantity) as TotalPrice 
from [dbo].[Order Details]

--14. 
Select count(customerid) as TotalCustomers
from Customers

--15. 
select min(OrderDate) 
from Orders

--16.
select distinct country 
from Customers
group by Country

--17. 
select ContactTitle, count(ContactTitle) as TotalContactTitle  
from Customers
group by ContactTitle
order by TotalContactTitle desc

--18. 
Select p.ProductID, p.ProductName, s.CompanyName as Supplier 
from Products p
inner join Suppliers s
on s.SupplierID = p.SupplierID
order by ProductID


--19. 
Select
o.OrderID, 
o.OrderDate, 
s.CompanyName as Shipper 
from Orders o 
join Shippers s 
on o.ShipVia = s.ShipperID
where OrderID < 10270

------------------------------Intermediate Problems 
--20. 

Select * from Categories
Select * from Products

Select c.CategoryName, count(p.categoryid) TotalProducts 
from Products p 
inner join Categories c 
on c.categoryid = p.CategoryID
group by CategoryName
order by TotalProducts desc

--21. 
select Country, City, count(CustomerID) as TotalCustomers
from Customers
group by Country, City
order by TotalCustomers desc 

--22. 
select ProductID, ProductName, UnitsInStock, ReorderLevel
from Products
where UnitsInStock <= ReorderLevel
order by ProductID 

--23.
select ProductID, ProductName, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued
from Products
where UnitsInStock + UnitsOnOrder <= ReorderLevel
and Discontinued = 0
order by ProductID 

--24. 
select CustomerID, CompanyName, Region
from Customers
order by 
case 
	when Region is Null then 1 
	else 0 
end, 
Region, CustomerID

--25. 
select * from orders

Select top 3 ShipCountry, Avg(Freight) as AverageFreight 
from Orders
group by ShipCountry 
order by AverageFreight desc 

--26.
Select top 3 ShipCountry, Avg(Freight) as AverageFreight 
from Orders
where year(OrderDate) = 1996
group by ShipCountry 
order by AverageFreight desc 

--27. 
--Difference between Date and DateTime. Better to use Date when using between, because DateTime may not include the starting or ending date. 


--28.

Select max(Orderdate) 
from Orders

Select top 3 
	ShipCountry,
	Avg(Freight) as AverageFreight 
from Orders 
where 
	OrderDate >= Dateadd(year, -1, (Select max(Orderdate) from Orders))
group by ShipCountry
order by AverageFreight Desc  

--29. 
 
Select o.EmployeeID, e.LastName, o.OrderID, p.ProductName, od.Quantity 
from Orders o
join Employees e 
on o.EmployeeID = e.EmployeeID
join [Order Details] od
on o.OrderID = od.OrderID 
join Products p 
on p.ProductID = od.ProductID
order by OrderID, p.ProductID

--30. 

select * from Customers
select * from Orders

select c.CustomerID, o.OrderId 
From Customers c 
left join Orders o 
on c.CustomerID = o.CustomerID
where o.OrderID is NULL 

--31. 

select Customers.CustomerID, Orders.CustomerID
from Customers 
left join Orders 
on Customers.CustomerID = Orders.CustomerID and Orders.EmployeeID = 4
where Orders.CustomerID is null 

-------------------------------------------Advanced Queries 
--32. 
;With orders_cte as (
Select c.CustomerID, c.CompanyName, o.OrderID, sum(od.Quantity * od.UnitPrice) as TotalOrderAmount  
from Customers c 
join Orders o on o.CustomerID = c.CustomerID 
join [Order Details] od on od.OrderID = o.OrderID 
Where OrderDate > '19980101'
And OrderDate < '19990101'
group by c.CustomerID, c.CompanyName, o.OrderID
) 
Select * 
from orders_cte
where TotalOrderAmount >= 10000 

--33. 

Select c.CustomerID, c.CompanyName, sum(od.Quantity * od.UnitPrice) as TotalOrderAmount  
from Customers c 
join Orders o on o.CustomerID = c.CustomerID 
join [Order Details] od on od.OrderID = o.OrderID 
Where OrderDate > '19980101'
And OrderDate < '19990101'
group by c.CustomerID, c.CompanyName
Having  sum(od.Quantity * od.UnitPrice) >= 15000
Order by TotalOrderAmount Desc;

--34. 
Select c.CustomerID, c.CompanyName, sum(od.Quantity * od.UnitPrice) as TotalsWithoutDiscount, sum(od.Quantity * od.UnitPrice * (1- od.Discount)) as TotalsWithDiscount  
from Customers c 
join Orders o on o.CustomerID = c.CustomerID 
join [Order Details] od on od.OrderID = o.OrderID 
Where OrderDate > '19980101'
And OrderDate < '19990101'
group by c.CustomerID, c.CompanyName
Having  sum(od.Quantity * od.UnitPrice) >= 15000
Order by TotalsWithDiscount Desc;

--35. 
Select EmployeeID, OrderID, EOMONTH(OrderDate) as OrderDate 
from Orders
order by EmployeeID, OrderID desc

--36. 
Select top 10
OrderID, count(*) as TotalOrderDetails
from [Order Details]
group by OrderID 
order by count(*) desc 

--37. 
SELECT top 2 percent 
	OrderID
FROM Orders 
order by NewID();

--38. Identify OrderID's where the same quantity (60 or more) was assigned for two different ProductID's aaccidentaly. 
Select OrderID
from [Order Details] 
Where Quantity >= 60 
group by OrderID, Quantity
Having Count(Distinct ProductID) > 1 
Order by OrderID

--39. 

Select OrderId, ProductID, UnitPrice, Quantity, Discount 
from [Order Details] 
where OrderID in (
		Select OrderID
		from [Order Details] 
		Where Quantity >= 60 
		group by OrderID, Quantity
		Having Count(Distinct ProductID) > 1 
) 
Order by OrderID;

;With Orders_cte as ( 
		Select OrderID
		from [Order Details] 
		Where Quantity >= 60 
		group by OrderID, Quantity
		Having Count(Distinct ProductID) > 1 ) 
Select OrderID, ProductID, UnitPrice, Quantity, Discount 
from [Order Details]
Where OrderID in (Select OrderID from Orders_cte) 

--40. 

Select od.OrderID, ProductID, UnitPrice, Quantity, Discount 
From [Order Details] od
Join (
Select 
	Distinct OrderID 
From [Order Details] 
Where Quantity >=60 
Group by OrderID, Quantity
Having Count(*) >1) PotentialProblemOrders 
on PotentialProblemOrders.OrderID=od.OrderID
Order by OrderID, ProductID
 








