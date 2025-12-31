
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

DELETE FROM task
WHERE project_id = 2;


SELECT * FROM task

DROP TABLE project

SELECT 
    p.project_id,
    p.project_name,
    t.task_id,
    t.task_name
FROM project p
LEFT JOIN task t 
    ON p.project_id = t.project_id
ORDER BY p.project_id;


