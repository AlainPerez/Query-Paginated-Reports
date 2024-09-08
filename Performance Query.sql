WITH CTE_Performance AS (
 SELECT TOP 7
 SUM(qs.total_worker_time)/(1000000) AS [CPU Time Seconds],    
 SUM(qs.execution_count) AS [Times Run],    
 qs.query_hash AS [Hash],
 MIN(creation_time) AS [Creation time],
 MIN(qt.text) AS [Query],
 MIN(USER_NAME(r.user_id)) AS [UserName]
FROM sys.dm_exec_query_stats qs CROSS apply
 sys.dm_exec_sql_text(qs.sql_handle) AS qt   
 LEFT JOIN sys.dm_exec_requests AS r ON qs.query_hash = 
r.query_hash
GROUP BY qs.query_hash
ORDER BY [CPU Time Seconds] DESC
) SELECT *, ROW_NUMBER() OVER(ORDER BY([CPU Time Seconds]) DESC) rnum
  FROM CTE_Performance 