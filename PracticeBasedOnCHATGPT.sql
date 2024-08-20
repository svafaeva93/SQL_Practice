--Window Functions 
--1. Calcualte the Running Total of the UnitPrice for each product within its Category across all orders

Select  ProductId, CategoryID, ProductName, UnitPrice,  
SUM(UnitPrice) over (partition by CategoryID order by ProductID) As RunningTotal
from Products
order by CategoryID, 
ProductID 

--2. Rank customers based on total amount spent in descending order 

;With CustomerSpending as (
	Select 
		c.CustomerID, Sum(od.UnitPrice * od.Quantity) as TotalSpent
	from Customers c 
	join Orders o on o. CustomerID = c.CustomerID 
	join [Order Details] od on od.OrderID = o.OrderID
	group by c.CustomerID ) 
Select 
	CustomerID, 
	TotalSpent, 
	DENSE_RANK() over (order by TotalSpent desc) SpendingRank 
From CustomerSpending
 
--3. Find the top 3 most expensive orders by Freight cost per ShipCountry 
;With RankedOrders as (
	select 
		OrderId, 
		ShipCountry, 
		Freight,
		dense_rank() over (partition by ShipCountry order by Freight desc) FreightRank
	from orders ) 
Select 
	OrderID, 
	ShipCountry, 
	Freight, 
	FreightRank 
From RankedOrders
Where FreightRank <=3 
Order by ShipCountry, FreightRank 

--4. Identify the average Ordervalue for each employee and then compare each orders value to this average 

;With CTE as (
	select 
		o.OrderID, o.EmployeeID, Sum(UnitPrice * Quantity) as OrderValue 
		from Orders o 
		join [Order Details] od on o.OrderID = od.OrderID
		group by o.OrderID, o.EmployeeID
),
EmployeeAvgOrderValue As (
	Select  
		EmployeeID, 
		Avg(OrderValue) over (partition by employeeid) as AvgOrderValue 
	from CTE)
Select 
	c.OrderID, 
	c.EmployeeID, 
	c.OrderValue, 
	eav.AvgOrderValue,
	(c.OrderValue - eav.AvgOrderValue) as DifferencefromAvg 
From 
	CTE c 
Join EmployeeAvgOrderValue eav on c.EmployeeID = eav.EmployeeID
Order by c.EmployeeID;

--5. Determine the cumulative sum of Quantity for each Order by Product 







