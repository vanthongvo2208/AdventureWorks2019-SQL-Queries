USE  AdventureWorksDW2019

/* Ex1: From the AdventureWorksDW2019 database, table FactInternetSales,
Retrieve all records where OrderDate is on or after '2011-01-01' 
and ShipDate is within the year 2011
*/
-- My code here

SELECT *
FROM dbo.FactInternetSales
Where OrderDate >= '2011-01-01' and YEAR(ShipDate) = 2011


/* Ex2: From the AdventureWorksDW2019 database, table DimProduct,
Retrieve ProductKey, ProductAlternateKey, and EnglishProductName of products.
Filter for products where:
- ProductAlternateKey starts with 'BK-', followed by any single character except 'T', 
  and ends with any two digits
- AND Color is either 'Black', 'Red', or 'White'
*/
-- My code here

SELECT 
    ProductKey,
    ProductAlternateKey,
    EnglishProductName,
    Color
FROM dbo.DimProduct
WHERE ProductAlternateKey LIKE 'BK-[^T]%[0-9][0-9]' 
    AND Color in ('Black', 'Red', 'White')


/* Ex3: From the AdventureWorksDW2019 database, table DimProduct,
Retrieve all products where the Color column is 'Red'
*/
-- My code here

SELECT *
FROM dbo.DimProduct
WHERE Color = 'red'


/* Ex4: From the AdventureWorksDW2019 database, table FactInternetSales (sales data),
Retrieve all records where the sold product's color is 'Red'
(Hint: Use the IN operator with a subquery. 
You may refer to: sqlservertutorial.net/sql-server-basics/sql-server-in/)
*/
-- My code here

SELECT *
FROM dbo.FactInternetSales
WHERE ProductKey IN (
    SELECT ProductKey
    FROM dbo.DimProduct
    WHERE Color = 'red')


/* Ex5: From the AdventureWorksDW2019 database, table DimEmployee,
Retrieve EmployeeKey, FirstName, LastName, and MiddleName of employees 
where MiddleName is not NULL and the Phone column has a length of exactly 12 characters
*/
-- My code here

SELECT
    EmployeeKey,
    FirstName,
    LastName,
    MiddleName,
    Phone
FROM dbo.DimEmployee
WHERE MiddleName IS NOT NULL AND LEN(Phone) = 12


/* Ex6: From the AdventureWorksDW2019 database, table DimEmployee,
Retrieve a list of EmployeeKey
Then, additionally retrieve the following columns:
a. FullName: combine FirstName, MiddleName, and LastName with spaces in between 
   (use both '+' operator and a function to compare the difference)
b. AgeHired: calculate the employee’s age at the time of being hired using HireDate and BirthDate
c. AgeNow: calculate the employee’s current age using BirthDate
d. UserName: extract the part after the "\" character from the LoginID column 
   (e.g., LoginID = adventure-works\jun0 → UserName = jun0)
*/
-- My code here

SELECT
    EmployeeKey,
    FirstName,
    LastName,
    MiddleName,
    HireDate,
    BirthDate,
    LoginID,
    /*a.*/
    /* Method 1 using the '+' operator: if any column value is NULL, the entire FullName column result will also be NULL */
    FirstName + ' ' + MiddleName + ' ' + LastName AS FullName,

    /* Method 2 using a function (e.g., CONCAT): if a column value is NULL,  
    it will be ignored and the other column values will still be concatenated 
    to produce a result in the FullName_Concat column */
    CONCAT(FirstName, ' ', MiddleName, ' ', LastName) AS FullName_Concat,

    /*b.*/
    DATEDIFF(YEAR, BirthDate, HireDate) AS AgeHired,

    /*c.*/
    DATEDIFF(YEAR, BirthDate, GETDATE()) AS AgeNow,

    /*d.*/
    SUBSTRING(LoginID, 17, LEN(LoginID)) AS UserName

FROM dbo.DimEmployee