USE AdventureWorksDW2019


/* Ex1: Based on the FactInternetSales table, calculate the total quantity of products (OrderQuantity) 
sold to each customer (CustomerKey). Display the results in descending order of total quantity.
*/
-- My code here  

SELECT  
    CustomerKey, 
    SUM(OrderQuantity) AS TotalOrderQuantity 
FROM  
    FactInternetSales 
GROUP BY  
    CustomerKey 
ORDER BY  
    TotalOrderQuantity DESC


/* Ex2: Based on the FactInternetSales and DimProduct tables, 
calculate the total number of products sold (TotalOrderQuantity) for each product (EnglishProductName). 
Display the results in descending order of TotalOrderQuantity.
*/
-- My code here  

SELECT  
    DP.EnglishProductName, 
    SUM(FIS.OrderQuantity) AS TotalOrderQuantity 
FROM  
    dbo.FactInternetSales AS FIS 
LEFT JOIN  
    dbo.DimProduct AS DP ON FIS.ProductKey = DP.ProductKey 
GROUP BY  
    DP.EnglishProductName 
ORDER BY  
    TotalOrderQuantity DESC


/* Ex3: Based on the FactInternetSales and DimCustomer tables, 
create a FullName field by concatenating FirstName, MiddleName, and LastName with spaces. 
Then, count the number of orders (OrderCount) each customer placed in the year 2014. 
Only include customers who placed at least 2 orders.
*/
-- My code here  

SELECT  
    CONCAT(DC.FirstName, ' ', DC.MiddleName, ' ', DC.LastName) AS FullName, 
    COUNT(DISTINCT FIS.SalesOrderNumber) AS OrderCount 
FROM  
    dbo.FactInternetSales AS FIS
LEFT JOIN  
    dbo.DimCustomer AS DC ON DC.CustomerKey = FIS.CustomerKey
LEFT JOIN  
    dbo.DimDate AS DD ON FIS.OrderDateKey = DD.DateKey
WHERE  
    DD.CalendarYear = 2014
GROUP BY  
    DC.FirstName, DC.MiddleName, DC.LastName
HAVING  
    COUNT(DISTINCT FIS.SalesOrderNumber) >= 2
ORDER BY  
    OrderCount DESC


/* Ex4: From the tables DimProduct, DimProductSubCategory, DimProductCategory, and FactInternetSales,
Write a query to retrieve EnglishProductCategoryName and TotalAmount (calculated using SalesAmount) 
for the top 2 product categories with the highest revenue in the year 2014.
*/
-- My code here  

SELECT TOP 2  
    DPC.EnglishProductCategoryName, 
    SUM(FIS.SalesAmount) AS TotalAmount 
FROM  
    dbo.FactInternetSales AS FIS 
LEFT JOIN  
    dbo.DimDate AS DD ON FIS.OrderDateKey = DD.DateKey AND DD.CalendarYear = 2014 
LEFT JOIN  
    dbo.DimProduct AS DP ON FIS.ProductKey = DP.ProductKey 
LEFT JOIN  
    dbo.DimProductSubCategory AS DPSC ON DP.ProductSubCategoryKey = DPSC.ProductSubCategoryKey 
LEFT JOIN  
    dbo.DimProductCategory AS DPC ON DPSC.ProductCategoryKey = DPC.ProductCategoryKey 
WHERE  
    DD.DateKey IS NOT NULL 
GROUP BY  
    DPC.EnglishProductCategoryName 
ORDER BY  
    TotalAmount DESC 


/* Ex5: From the tables FactInternetSales and FactResellerSales, 
combine data from both Internet and Reseller sales channels 
to retrieve all SaleOrderNumbers and the revenue of each SaleOrderNumber.
*/
-- My code here  

SELECT  
    SalesOrderNumber, 
    SUM(SalesAmount) AS TotalRevenue 
FROM ( 
    SELECT  
        SalesOrderNumber, 
        SalesAmount 
    FROM dbo.FactInternetSales
    UNION ALL 
    SELECT  
        SalesOrderNumber, 
        SalesAmount 
    FROM dbo.FactResellerSales 
) AS CombinedSales 
GROUP BY  
    SalesOrderNumber 
ORDER BY  
    TotalRevenue DESC


/* Ex6: Based on the tables DimDepartmentGroup and FactFinance, 
retrieve the TotalAmount (based on Amount) grouped by DepartmentGroupName and ParentDepartmentGroupName.
*/
-- My code here  

SELECT  
    DDG.DepartmentGroupName, 
    PDDG.DepartmentGroupName AS ParentDepartmentGroupName, 
    SUM(FF.Amount) AS TotalAmount 
FROM  
    dbo.FactFinance AS FF 
LEFT JOIN  
    dbo.DimDepartmentGroup AS DDG ON FF.DepartmentGroupKey = DDG.DepartmentGroupKey 
LEFT JOIN  
    dbo.DimDepartmentGroup AS PDDG ON DDG.ParentDepartmentGroupKey = PDDG.DepartmentGroupKey 
GROUP BY  
    DDG.DepartmentGroupName, 
    PDDG.DepartmentGroupName 
ORDER BY  
    TotalAmount DESC