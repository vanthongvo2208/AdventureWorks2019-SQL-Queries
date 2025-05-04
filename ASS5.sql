USE AdventureWorksDW2019


/* Ex1: From the DimEmployee table, calculate the average BaseRate for each Title in the company
*/
-- My code here  

SELECT 
    Title,
    AVG(BaseRate) AverageBaseRate
FROM dbo.DimEmployee
GROUP BY Title


/* Ex2: From the FactInternetSales table, create a column named TotalOrderQuantity by calculating 
the total OrderQuantity for each ProductKey and each OrderDate
*/
-- My code here  

SELECT
    ProductKey,
    OrderDate,
    SUM(OrderQuantity) AS TotalOrderQuantity  
FROM dbo.FactInternetSales
GROUP BY ProductKey, OrderDate


/* Ex3: From the tables DimProduct, FactInternetSales, DimProductCategory, and other related tables if necessary,
Retrieve product category information including: CategoryKey and EnglishCategoryName for rows that meet the condition 
OrderDate in the year 2012, and calculate the following for each category:
- TotalRevenue using the SalesAmount column
- TotalCost using the TotalProductCost column
- TotalProfit calculated as (TotalRevenue - TotalCost)
Only display records where TotalRevenue > 5000
*/
-- My code here  

SELECT
    DPC.ProductCategoryKey,
    DPC.EnglishProductCategoryName,
    SUM(FIS.SalesAmount) AS TotalRevenue,
    SUM(FIS.TotalProductCost) AS TotalCost,
    SUM(FIS.SalesAmount) - SUM(FIS.TotalProductCost) AS TotalProfit

FROM dbo.FactInternetSales AS FIS 
LEFT JOIN dbo.DimProduct AS DP ON
    FIS.ProductKey = DP.ProductKey
LEFT JOIN dbo.DimProductSubcategory AS DPS On
    DP.ProductSubcategoryKey = DPS.ProductSubcategoryKey
LEFT JOIN dbo.DimProductCategory AS DPC ON
    DPS.ProductCategoryKey = DPC.ProductCategoryKey
WHERE LEFT(CAST(FIS.OrderDateKey AS VARCHAR), 4) = '2012'
GROUP BY 
    DPC.ProductCategoryKey,
    DPC.EnglishProductCategoryName
HAVING SUM(FIS.SalesAmount) > 5000


/* Ex4: From the tables FactInternetSales and DimProduct,
- Create a column named Color_group from the Color column. If Color is 'Black' or 'Silver', assign 'Basic' to Color_group;
otherwise, keep the original Color value.
- Then calculate the TotalRevenue using the SalesAmount column for each Color_group
*/
-- My code here  

SELECT
    CASE 
        WHEN DP.Color IN ('Black', 'Silver') THEN 'Basic'
        ELSE DP.Color
    END AS Color_group,
    SUM(FIS.SalesAmount) AS TotalRevenue

FROM dbo.FactInternetSales AS FIS 
LEFT JOIN dbo.DimProduct AS DP ON
    FIS.ProductKey = DP.ProductKey
GROUP BY
    CASE 
        WHEN DP.Color IN ('Black', 'Silver') THEN 'Basic'
        ELSE DP.Color
    END        


/* Ex5 (Advanced): From the tables FactInternetSales, FactResellerSales, and other related tables if needed,
Use the SalesAmount column to calculate monthly revenue for the two sales channels: Internet and Reseller
The output should include the following columns: Year, Month, InternSales, Reseller_Sales
Hint: Calculate monthly revenue separately for each table (FactInternetSales and FactResellerSales) using CTE
Note: When using more than one CTE, the syntax is written as follows:

WITH Name_CTE_1 AS (
    SELECT statement
),
Name_CTE_2 AS (
    SELECT statement
)

SELECT statement
*/
-- My code here  

;WITH InternSales_CTE AS ( 
SELECT  
    DD.CalendarYear AS Year, 
    DD.MonthNumberOfYear AS Month, 
    SUM(FIS.SalesAmount) AS InternSales 
FROM dbo.FactInternetSales AS FIS 
JOIN dbo.DimDate AS DD ON FIS.OrderDateKey = DD.DateKey 
GROUP BY DD.CalendarYear, DD.MonthNumberOfYear 
), 
ResellerSales_CTE AS ( 
SELECT  
    DD.CalendarYear AS Year, 
    DD.MonthNumberOfYear AS Month, 
    SUM(FRS.SalesAmount) AS Reseller_Sales 
FROM dbo.FactResellerSales AS FRS 
JOIN dbo.DimDate AS DD ON FRS.OrderDateKey = DD.DateKey 
GROUP BY DD.CalendarYear, DD.MonthNumberOfYear 
) 

SELECT  
    COALESCE(I.Year, R.Year) AS Year, 
    COALESCE(I.Month, R.Month) AS Month, 
    I.InternSales, 
    R.Reseller_Sales 
FROM InternSales_CTE I 
FULL OUTER JOIN ResellerSales_CTE R  
ON I.Year = R.Year AND I.Month = R.Month 
ORDER BY Year, Month 

 
