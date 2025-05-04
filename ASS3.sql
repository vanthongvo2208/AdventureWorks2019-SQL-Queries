USE  AdventureWorksDW2019

/* Ex1: From the tables dbo.FactInternetSales and dbo.DimSalesTerritory, 
retrieve SalesOrderNumber, SalesOrderLineNumber, ProductKey, and SalesTerritoryCountry 
for records where SalesAmount is greater than 1000
*/
-- My code here

SELECT 
    FIS.SalesOrderNumber,
    FIS.SalesOrderLineNumber,
    FIS.ProductKey,
    DST.SalesTerritoryCountry,
    FIS.SalesAmount
FROM 
    dbo.FactInternetSales AS FIS
LEFT JOIN 
    dbo.DimSalesTerritory AS DST ON 
    FIS.SalesTerritoryKey = DST.SalesTerritoryKey
WHERE 
    FIS.SalesAmount > 1000;


/* Ex2: From the tables dbo.DimProduct and dbo.DimProductSubcategory, 
retrieve ProductKey, EnglishProductName, and Color for products 
where EnglishProductSubCategoryName contains the word 'Bikes' 
and the integer part of ListPrice is 3399
*/
-- My code here

SELECT
    DP.ProductKey, 
    DP.EnglishProductName,
    DP.Color,
    DP.ListPrice,
    DPS.EnglishProductSubcategoryName
FROM 
    dbo.DimProduct AS DP 
LEFT JOIN 
    dbo.DimProductSubcategory AS DPS ON
    DP.ProductSubCategoryKey = DPS.ProductSubcategoryKey
WHERE
    DPS.EnglishProductSubcategoryName LIKE '%Bikes%'
    AND FLOOR(DP.ListPrice) = 3399


/* Ex3: From the tables dbo.DimPromotion and dbo.FactInternetSales, 
retrieve ProductKey, SalesOrderNumber, and SalesAmount 
for records where DiscountPct is greater than or equal to 20%
*/
-- My code here

SELECT
    FIS.ProductKey, 
    FIS.SalesOrderNumber, 
    FIS.SalesAmount,
    DPr.DiscountPct
FROM 
    dbo.FactInternetSales AS FIS
LEFT JOIN
    dbo.DimPromotion AS DPr ON
    FIS.PromotionKey = DPr.PromotionKey
WHERE
    DPr.DiscountPct >= 0.2


/* Ex4: From the tables dbo.DimCustomer and dbo.DimGeography, 
retrieve Phone, FullName (a combination of FirstName, MiddleName, and LastName separated by spaces), 
and City for customers with YearlyIncome > 150000 
and CommuteDistance less than 5 Miles
*/
-- My code here

SELECT 
    DC.Phone,
    CONCAT(DC.FirstName, ' ', DC.MiddleName, ' ', DC.LastName) AS FullName,
    DG.City,
    DC.YearlyIncome,
    DC.CommuteDistance
FROM
    dbo.DimCustomer AS DC 
LEFT JOIN
    dbo.DimGeography AS DG ON
    DC.GeographyKey = DG.GeographyKey
WHERE
    DC.YearlyIncome > 150000
    AND DC.CommuteDistance IN ('0-1 Miles', '1-2 Miles', '2-5 Miles')


-- LogicalExpression

/* Ex5: From the table dbo.DimCustomer, retrieve CustomerKey and perform the following tasks:
a. Create a new column named YearlyIncomeRange with the following logic:
- If YearlyIncome is between 0 and 50000, set value to "Low Income"
- If YearlyIncome is between 50001 and 90000, set value to "Middle Income"
- If YearlyIncome is 90001 or higher, set value to "High Income"
b. Create a new column named AgeRange using the following logic:
- If the customer's age as of 12/31/2019 is up to 39, set value to "Young Adults"
- If the customer's age is between 40 and 59, set value to "Middle-Aged Adults"
- If the customer's age is over 60, set value to "Old Adults"
*/
-- My code here

SELECT
    CustomerKey,
    YearlyIncome,
    BirthDate,
    /* a. */
    CASE WHEN YearlyIncome  BETWEEN 0 AND 50000 THEN 'Low Income'
        WHEN YearlyIncome  BETWEEN 50001 AND 90000 THEN 'Middle Income'
        WHEN YearlyIncome  >= 90001 THEN 'High Income'
        ELSE 'Unknown'
    END AS YearlyInComeRange,

    /* b. */
    CASE WHEN DATEDIFF(YEAR, BirthDate, '2019-12-31') <= 39 THEN 'Young Adults'
        WHEN DATEDIFF(YEAR, BirthDate, '2019-12-31') BETWEEN 40 AND 59 THEN 'Middle-Aged Adults'
        WHEN DATEDIFF(YEAR, BirthDate, '2019-12-31') >= 60 THEN 'Old Adults'
        ELSE 'Other'
    END AS AgeRange


FROM 
    dbo.DimCustomer
WHERE
    BirthDate IS NOT NULL


-- UNION concept

/* Ex6: From the tables FactInternetSales, FactResellerSales, and DimProduct, 
find all SalesOrderNumber where the EnglishProductName contains the word 'Road' 
and the product color is Yellow
*/
-- My code here

SELECT 
    FIS.SalesOrderNumber,
    DP.EnglishProductName
FROM
    dbo.FactInternetSales AS FIS
LEFT JOIN
    dbo.DimProduct AS DP ON
    FIS.ProductKey = DP.ProductKey
WHERE 
    DP.EnglishProductName LIKE '%Road%'
    AND DP.Color = 'Yellow'

UNION ALL

SELECT 
    FRS.SalesOrderNumber,
    DP.EnglishProductName
FROM
    dbo.FactResellerSales AS FRS
LEFT JOIN
    dbo.DimProduct AS DP ON
    FRS.ProductKey = DP.ProductKey
WHERE 
    DP.EnglishProductName LIKE '%Road%'
    AND DP.Color = 'Yellow'