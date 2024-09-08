WITH CTE_EmplHierarchy (BusinessEntityID, ManagerID, [Level]) AS (
    -- Anchor member: start with employees who do not have a manager (top-level managers)
    SELECT  BusinessEntityID, ManagerID, 0 AS [Level]
    FROM
        HumanResources.Employee
    WHERE
        ManagerID IS NULL

    UNION ALL

    -- Recursive member: join the CTE with the Employee table to find employees under each manager
    SELECT e.BusinessEntityID, e.ManagerID, eh.Level + 1 AS Level
    FROM
        HumanResources.Employee e INNER JOIN CTE_EmplHierarchy eh
    ON
        e.ManagerID = eh.BusinessEntityID
)
-- Final select to show the results
SELECT cte.BusinessEntityID, CONCAT(p.FirstName,' ',p.LastName) as Fullname, PhoneNumber, CONCAT(pp.FirstName,' ',pp.LastName) AS Manager, [Level]
FROM
    CTE_EmplHierarchy cte JOIN Person.Person p ON cte.BusinessEntityID=p.BusinessEntityID JOIN Person.PersonPhone pf ON p.BusinessEntityID = pf.BusinessEntityID JOIN Person.Person pp ON ManagerID=pp.BusinessEntityID
ORDER BY
    Level;