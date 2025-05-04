/* Ex1: From the AdventureworksDW2019 database, table DimEmployee,
Retrieve EmployeeKey, FirstName, LastName, BaseRate, VacationHours, SickLeaveHours
Then, additionally retrieve the following columns:
a. Column FullName derived from: FirstName + '  ' + LastName
b. Column VacationLeavePay derived from: BaseRate * VacationHours
c. Column SickLeavePay derived from: BaseRate * SickLeaveHours
d. Column TotalLeavePay derived from: VacationLeavePay + SickLeavePay
*/
-- My code here  

USE AdventureWorksDW2019 

SELECT 
    EmployeeKey, 
    FirstName, 
    LastName, 
    BaseRate, 
    VacationHours, 
    SickLeaveHours, 

    /* a. */ 
    FirstName + ' ' + LastName AS FullName, 

    /* b. */ 
    BaseRate * VacationHours AS VacationLeavePay, 

    /* c. */  
    BaseRate * SickLeaveHours AS SickLeavePay,  

    /* d. */ 
    BaseRate * (VacationHours + SickLeaveHours) AS TotalLeavePay  

FROM dbo.DimEmployee 


/* Ex2: From the AdventureworksDW2019 database, table FactInternetSales,
Retrieve SalesOrderNumber, ProductKey, OrderDate
Then, additionally retrieve the following columns:
a. Column TotalRevenue derived from: OrderQuantity * UnitPrice
b. Column TotalCost derived from: ProductStandardCost + DiscountAmount
c. Column Profit derived from: TotalRevenue - TotalCost
d. Column Profit Margin derived from: (TotalRevenue - TotalCost)/TotalRevenue * 100
*/
-- My code here  

SELECT  
    SalesOrderNumber, 
    ProductKey, 
    OrderDate, 

    /* a. */       
    OrderQuantity * UnitPrice AS TotalRevenue, 

    /* b. */ 
    ProductStandardCost + DiscountAmount AS TotalCost, 

    /* c. */ 
    (OrderQuantity * UnitPrice) - (ProductStandardCost + DiscountAmount) AS Profit, 

    /* d. */ 
    ((OrderQuantity * UnitPrice) - (ProductStandardCost + DiscountAmount) / (OrderQuantity * UnitPrice)) * 100 AS ProfitMargin 

FROM dbo.FactInternetSales 


/* Ex3: From the AdventureworksDW2019 database, table FactProductInventory,
Retrieve the following columns:
MovementDate,
ProductKey,
And:
a. Column NoProductEOD derived from: UnitsBalance + UnitsIn - UnitsOut
b. Column TotalCost derived from: NoProductEOD * UnitCost
*/
-- My code here  

SELECT 
    MovementDate, 
    ProductKey, 

    /* a. */ 
    UnitsBalance + UnitsIn - UnitsOut AS NoProductEOD, 

    /* b. */ 
    (UnitsBalance + UnitsIn - UnitsOut) * UnitCost AS TotalCost  

FROM dbo.FactProductInventory 


/* Ex4: From the AdventureworksDW2019 database, table DimGeography, retrieve EnglishCountryRegionName, 
City, and StateProvinceName. Remove duplicate rows and sort the result set in ascending order of 
EnglishCountryRegionName. For rows with the same country name, further sort them in descending order of City.
*/
-- My code here  

SELECT DISTINCT 
    EnglishCountryRegionName, 
    City, 
    StateProvinceName 
FROM dbo.DimGeography 
ORDER BY EnglishCountryRegionName ASC, City DESC 


/* Ex5: From the AdventureworksDW2019 database, table DimProduct,
Retrieve EnglishProductName of the top 10% products with the highest ListPrice
*/
-- My code here  

SELECT 
TOP 10 PERCENT 
    EnglishProductName, 
    ListPrice 
FROM dbo.DimProduct 
ORDER BY ListPrice DESC