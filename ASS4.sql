USE AdventureWorksDW2019

/* Ex1: From the tables dbo.DimProduct, dbo.DimPromotion, and dbo.FactInternetSales, 
retrieve ProductKey and EnglishProductName for the rows that satisfy the condition DiscountPct >= 20%
*/
-- My code here 

SELECT 
    FIS.ProductKey,
    DP.EnglishProductName,
    DPr.DiscountPct
FROM dbo.FactInternetSales AS FIS
LEFT JOIN dbo.DimProduct AS DP ON FIS.ProductKey = DP.ProductKey
LEFT JOIN dbo.DimPromotion AS DPr ON FIS.PromotionKey = DPr.PromotionKey
WHERE DPr.DiscountPct >= 0.2


/* Ex2: From the tables DimProduct, DimProductSubcategory, and DimProductCategory, 
retrieve ProductKey, EnglishProductName, EnglishProductSubCategoryName, and EnglishProductCategoryName 
for products where EnglishProductCategoryName is 'Clothing'
*/
-- My code here

SELECT
    DP.ProductKey,
    DP.EnglishProductName,
    DPS.EnglishProductSubcategoryName,
    DPC.EnglishProductCategoryName
FROM dbo.DimProduct AS DP
LEFT JOIN dbo.DimProductSubcategory AS DPS
    ON DP.ProductSubcategoryKey = DPS.ProductSubcategoryKey
LEFT JOIN dbo.DimProductCategory AS DPC
    ON DPS.ProductCategoryKey = DPC.ProductCategoryKey
WHERE DPC.EnglishProductCategoryName = 'Clothing'


/* Ex3: From the tables FactInternetSales and DimProduct, 
retrieve ProductKey, EnglishProductName, and ListPrice for products that have never been sold.
Use two methods: the IN operator and a JOIN
*/
-- My code here

-- Option 1
SELECT 
    ProductKey,
    EnglishProductName,
    ListPrice
FROM 
    DimProduct
WHERE 
    ProductKey NOT IN (
        SELECT DISTINCT ProductKey
        FROM FactInternetSales
    )

-- Option 2
SELECT 
    p.ProductKey,
    p.EnglishProductName,
    p.ListPrice
FROM 
    DimProduct p
LEFT JOIN 
    FactInternetSales f ON p.ProductKey = f.ProductKey
WHERE 
    f.ProductKey IS NULL 
ORDER BY p.ProductKey ASC


/* Ex4: From the DimDepartmentGroup table, 
retrieve DepartmentGroupKey, DepartmentGroupName, and ParentDepartmentGroupKey, 
then perform a self-join to retrieve the ParentDepartmentGroupName
*/
-- My code here

SELECT 
    child.DepartmentGroupKey,
    child.DepartmentGroupName,
    child.ParentDepartmentGroupKey,
    parent.DepartmentGroupKey AS Parent_key,
    parent.DepartmentGroupName AS Parent_Name,
    parent.ParentDepartmentGroupKey AS Parent_Groupkey
FROM dbo.DimDepartmentGroup AS child
LEFT JOIN dbo.DimDepartmentGroup AS parent
    ON parent.DepartmentGroupKey = child.ParentDepartmentGroupKey


/* Ex5: From the tables FactFinance, DimOrganization, and DimScenario, 
retrieve OrganizationKey, OrganizationName, and ParentOrganizationKey, 
then perform a self-join to get the ParentOrganizationName and Amount 
for records where ScenarioName is 'Actual'
*/
-- My code here
SELECT
    FF.Amount,
    DO_child.OrganizationKey,
    DO_child.OrganizationName,
    DO_child.ParentOrganizationKey,
    DO_parent.OrganizationKey AS Parent_Key,
    DO_parent.OrganizationName AS Parent_Name,
    DS.ScenarioName
FROM dbo.FactFinance AS FF
LEFT JOIN dbo.DimScenario AS DS 
    ON FF.ScenarioKey = DS.ScenarioKey
LEFT JOIN dbo.DimOrganization AS DO_child 
    ON FF.OrganizationKey = DO_child.OrganizationKey
LEFT JOIN dbo.DimOrganization AS DO_parent
    ON DO_parent.OrganizationKey = DO_child.ParentOrganizationKey
WHERE DS.ScenarioName = 'Actual'