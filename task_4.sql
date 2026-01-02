
--USE DATABASE
use kesavan_db
GO
--Project Table
CREATE TABLE project
(
	project_id INT IDENTITY(1,1) PRIMARY KEY,
	project_name VARCHAR(150) UNIQUE NOT NULL,
	starts_date DATE NOT NULL,
	end_date DATE NOT NULL,
	budget MONEY ,
	statuss VARCHAR(50) DEFAULT 'Not Started',

	--Constraints for end date field
	    CONSTRAINT CHECK_end_date_After_starts_date 
        CHECK (end_date >= starts_date),
)
GO

--Inserting values:
INSERT INTO project (project_name, starts_date, end_date, budget, statuss)
VALUES 
    ('Website Redesign', '2025-01-01', '2025-06-30', 15000.00, 'In Progress'),
    ('Mobile App Development', '2025-02-15', '2025-07-15', 25000.00, 'Not Started'),
    ('Market Research', '2025-03-01', '2025-05-31', 10000.00, 'Completed'),
    ('Annual Report Preparation', '2025-04-01', '2025-12-31', 12000.00, 'In Progress')
GO

--task table creation
CREATE TABLE task(
	task_id INT IDENTITY(1,1) PRIMARY KEY,
	task_name VARCHAR(150) NOT NULL,
	descriptions VARCHAR(255) NOT NULL,
	starts_date DATE NOT NULL,
	due_date DATE NOT NULL,
		--Constraints for end date field
	    CONSTRAINT CHECK_due_date_After_starts_date 
          CHECK (due_date >= starts_date),
	prioritys VARCHAR(150) 
		CONSTRAINT CK_Task_Priority CHECK (prioritys IN ('Low', 'Medium', 'High')),
	statuss VARCHAR(70) DEFAULT 'Pending',
	project_id INT FOREIGN KEY REFERENCES project(project_id)
);
GO

--inserting task values
INSERT INTO task (task_name, descriptions, starts_date, due_date, prioritys, statuss, project_id)
VALUES 
    ('Initial Design', 'Design phase for the new website', '2025-01-02', '2025-02-28', 'High', 'Completed', 1),
    ('UI Development', 'Development of user interface components', '2025-03-01', '2025-05-15', 'Medium', 'In Progress', 1),
    ('Quality Assurance', 'Testing and quality assurance', '2025-05-16', '2025-06-15', 'High', 'Pending', 1),
    ('API Development', 'Developing APIs for the mobile app', '2025-02-16', '2025-04-30', 'Medium', 'Completed', 2),
    ('Beta Testing', 'Conducting beta testing for the mobile app', '2025-05-01', '2025-06-30', 'High', 'In Progress', 2),
    ('Survey Analysis', 'Analyzing market research surveys', '2025-03-02', '2025-04-15', 'Low', 'Completed', 3),
    ('Report Drafting', 'Drafting the final report based on research', '2025-04-16', '2025-05-30', 'Medium', 'Pending', 3),
    ('Financial Statements', 'Preparing financial statements for the annual report', '2025-04-02', '2025-07-15', 'High', 'In Progress', 4),
    ('Final Review', 'Final review and submission of the annual report', '2025-07-16', '2025-12-15', 'High', 'Pending', 4),
    ('Client Feedback Incorporation', 'Incorporating feedback from the client into the project', '2025-02-01', '2025-03-15', 'Medium', 'In Progress', 1),
    ('Launch Preparation', 'Preparing for the official launch of the mobile app', '2025-06-01', '2025-07-01', 'High', 'Pending', 2);
    
    

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

-- Query 2: Retrieve all projects and any associated tasks, including projects with no tasks

SELECT * FROM task
/*
DELETE FROM task
WHERE project_id = 2;
*/

SELECT 
    p.project_id,
    p.project_name,
    t.task_id,
    t.task_name,
    t.prioritys,
    t.statuss,
    t.due_date
FROM project p
LEFT JOIN task t 
    ON p.project_id = t.project_id
ORDER BY p.project_id, t.task_id;


-- Query 3: Retrieve all tasks and any associated projects, including tasks with no associated project


--Display the result of the both table 
SELECT * FROM task, project
/*  
--insert a value to check this 
INSERT INTO task (
    task_name, 
    descriptions, 
    starts_date, 
    due_date, 
    prioritys, 
    statuss, 
    project_id
)
VALUES (
    'Orphan Task', 
    'This task has no associated project', 
    '2025-02-01', 
    '2025-02-10', 
    'High', 
    'Pending', 
    NULL
);
*/
-- Query

SELECT 
    t.task_id,
    t.task_name,
    t.prioritys,
    t.statuss,
    t.due_date,
    p.project_id,
    p.project_name
FROM task t
LEFT JOIN project p 
    ON t.project_id = p.project_id
ORDER BY t.task_id;

-- Query 4: Add New Column as parent_project_id as nullable in project Table, Enter valid Record for prvent_project_id 

--first add nullable column
ALTER TABLE project
ADD parent_project_id INT NULL;

--Display project table
SELECT * FROM project

---- Insert a record parent_project_id
INSERT INTO project (
    project_name, 
    starts_date, 
    end_date, 
    budget, 
    statuss,
    parent_project_id
)
vALUES (
    'Mobile Apps Development', 
    '2025-02-01', 
    '2025-06-30', 
    50000, 
    'Completed',
    1
);
/*
DELETE FROM project
WHERE project_name = 'Mobile Apps Development'
*/
-- Query
SELECT
    p.project_name AS Parent_Project,
    c.project_name AS Child_Project
FROM
    project c
JOIN
    project p
ON
    c.parent_project_id= p.project_id;


-- Query 5: Returns the current date and time 
SELECT 
    GETDATE() AS CurrentDateTime_GETDATE,
    SYSDATETIME() AS CurrentDateTime_SYSDATETIME;

-- Query 6: Extracts a specific part of a date of Any record in Project Start and End Date.
SELECT 
    project_name,
    YEAR(starts_date) AS Start_Year,
    MONTH(starts_date) AS Start_Month,
    DAY(starts_date) AS Start_Day,
    YEAR(end_date) AS End_Year,
    MONTH(end_date) AS End_Month,
    DAY(end_date) AS End_Day
FROM 
    project;



-- Query 7: Returns the difference between two dates of Any record in Project Start and End Date.
SELECT 
    project_name,
    DATEDIFF(DAY, starts_date, end_date) AS In_Days
FROM 
    project;

-- Query 8: Formats a date to 'yyyy-MM-dd' of Any record in Project Start Date.

SELECT 
    project_name,
    FORMAT(starts_date, 'yyyy-MM-dd') AS Formatted_Start_Date
FROM 
    project;


-- Query 9: Retrieve Tasks for Each Project Using CROSS APPLY.

SELECT 
    p.project_name,
    t.task_id,
    t.task_name,
    t.statuss
FROM 
    project p
CROSS APPLY (
    SELECT 
        task_id,
        task_name,
        statuss
    FROM 
        task
    WHERE 
        task.project_id = p.project_id
) t;
