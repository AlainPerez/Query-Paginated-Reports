WITH CTE_SalesPersons AS (SELECT 
    SalesPersonID,
    SalesOrderID,
    OrderDate,
    TotalDue,
	AVG(TotalDue) OVER (PARTITION BY SalesPersonID) AS AvgSalesPerPerson,
    RANK() OVER (PARTITION BY SalesPersonID ORDER BY TotalDue DESC) AS SalesRankByAmount
FROM 
    Sales.SalesOrderHeader
WHERE 
    SalesPersonID IS NOT NULL)
SELECT * 
FROM CTE_SalesPersons
WHERE SalesRankByAmount in (1,2,3)