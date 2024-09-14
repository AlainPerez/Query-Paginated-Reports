USE [AdventureWorks2022]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_employee_manager]    Script Date: 9/13/2024 11:08:13 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[udf_employee_manager] 
(
	-- Add the parameters for the function here
)
RETURNS @Table_Var TABLE 
(
	-- Add the column definitions for the TABLE variable here
	EmployeeID  int, 
	EmployeeJobTitle nvarchar(50),
	ManagerID int,
	ManagerJobTitle nvarchar(50)
)
AS
BEGIN
	INSERT INTO @Table_Var 
		   SELECT 
				emp.BusinessEntityID AS EmployeeID,
				emp.JobTitle AS EmployeeJobTitle,
				mgr.BusinessEntityID AS ManagerID,
				mgr.JobTitle AS ManagerJobTitle 
		    FROM 
				HumanResources.Employee AS emp
			LEFT JOIN 
				HumanResources.Employee AS mgr 
			ON 
				emp.ManagerID = mgr.BusinessEntityID
			ORDER BY 
				emp.BusinessEntityID;

	RETURN 
END
GO
