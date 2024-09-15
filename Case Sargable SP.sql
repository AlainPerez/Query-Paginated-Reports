SELECT 
	ISNULL(p.Title,'') + p.FirstName AS FirstName,
	p.MiddleName,
    p.LastName
FROM 
    HumanResources.Employee AS e
JOIN 
    Person.Person AS p ON e.BusinessEntityID = p.BusinessEntityID
WHERE 
    EXISTS (
        SELECT 1
        FROM Sales.SalesOrderHeader AS soh
        WHERE soh.SalesPersonID = e.BusinessEntityID
        GROUP BY soh.SalesPersonID
        HAVING COUNT(soh.SalesOrderID) > 5
    );
