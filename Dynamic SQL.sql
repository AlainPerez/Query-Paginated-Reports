CREATE PROCEDURE [dbo].[usp_Dynamic_Query]
       @orderDateFrom DATE = '2012-01-01',   -- Filter by start date (not need Dynamic)
       @orderDateTo DATE = '2013-12-31',       -- Filter by end date (not need Dynamic)
       @customerID INT = NULL,                       -- Optional filter by CustomerID (not need Dynamic)
       @includeDetails BIT = 1                           -- Condition to include SalesOrderDetail JOIN (Dynamic needed)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @sql NVARCHAR(MAX);

    -- Base SQL query
    SET @sql = N'SELECT SOH.SalesOrderID, SOH.OrderDate, SOH.CustomerID, SOH.TotalDue';
    -- Dynamically add columns from SalesOrderDetail if @includeDetails is set
    IF @includeDetails = 1
        SET @sql = @sql + N', SOD.ProductID, SOD.OrderQty, SOD.LineTotal';

    -- FROM clause
    SET @sql = @sql + N' FROM Sales.SalesOrderHeader SOH';

    -- Dynamically add JOIN with SalesOrderDetail if @includeDetails is set
    IF @includeDetails = 1
        SET @sql = @sql + N' INNER JOIN Sales.SalesOrderDetail SOD ON OH.SalesOrderID=SOD.SalesOrderID';

    -- WHERE clause -- Add customer ID condition
    SET @sql = @sql + N' WHERE (@customerID IS NULL OR SOH.CustomerID = @customerID) AND ((@orderDateFrom IS NULL AND @orderDateTo IS NULL) OR SOH.OrderDate BETWEEN @orderDateFrom AND @orderDateTo)'; 

    -- Execute the dynamic SQL
    EXEC sp_executesql @sql, 
                                                N'@orderDateFrom DATE, @orderDateTo DATE, @customerID INT', 
                                               @orderDateFrom, @orderDateTo, @customerID;
END;