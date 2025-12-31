
--USE DATABASE
use kesavan_db
GO


-- Query 1:  Retrieve tasks along with their project details
SELECT 
    t.task_id,
    t.task_name,
    t.prioritys,
    p.project_id,
    p.project_name,
    p.starts_date,
    p.end_date,
    t.statuss
FROM 
    task t
INNER JOIN 
    project p
ON 
    t.project_id = p.project_id;