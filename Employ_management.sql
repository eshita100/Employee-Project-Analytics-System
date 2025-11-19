create database SQLProject2;
use SQLProject2;
CREATE TABLE Departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    dept_id INT,
    salary DECIMAL(10,2),
    hire_date DATE,
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id)
);

CREATE TABLE Projects (
    project_id INT PRIMARY KEY, 
    project_name VARCHAR(100),
    dept_id INT,
    budget DECIMAL(10,2),
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id)
);

CREATE TABLE Employee_Projects (
    emp_id INT,
    project_id INT,
    hours_worked INT,
    FOREIGN KEY (emp_id) REFERENCES Employees(emp_id),
    FOREIGN KEY (project_id) REFERENCES Projects(project_id)
);

INSERT INTO Departments VALUES
(1, 'HR'),
(2, 'Engineering'),
(3, 'Marketing'),
(4, 'Finance');

INSERT INTO Employees VALUES
(101, 'Alice', 1, 60000, '2020-01-15'),
(102, 'Bob', 2, 80000, '2019-05-10'),
(103, 'Charlie', 2, 75000, '2021-03-20'),
(104, 'David', 3, 50000, '2022-11-05'),
(105, 'Eve', 4, 90000, '2018-07-18');

INSERT INTO Projects VALUES
(201, 'Recruitment System', 1, 20000),
(202, 'AI Platform', 2, 150000),
(203, 'Ad Campaign', 3, 50000),
(204, 'Accounting Revamp', 4, 80000);

INSERT INTO Employee_Projects VALUES
(101, 201, 120),
(102, 202, 200),
(103, 202, 180),
(104, 203, 90),
(105, 204, 220);


-- List all employees along with their department names.
select e.emp_name,d.dept_name from Employees e join Departments d on e.dept_id=d.dept_id;
-- Show the total number of employees in each department.
select count(emp_id) from departments d join Employees e on d.dept_id=e.dept_id group by dept_name;
-- Find the average salary for each department.
select avg(e.salary) from departments d join Employees e on d.dept_id=e.dept_id group by dept_name;
-- Display all departments having more than 1 employee.
select d.dept_name from departments d join Employees e on d.dept_id=e.dept_id group by d.dept_name having count(emp_id)>1; 
-- Show all projects and their associated department names.
select p.project_name,d.dept_name from Projects p join Departments d on  p.dept_id=d.dept_id; 



-- List employees who don’t belong to any project (use LEFT JOIN).
select * from  Employees where emp_name not in
(select distinct e.emp_name from Employees e  join 
 Employee_Projects W on e.emp_id=W.emp_id);
				-- OR
select e.emp_name from Employees e left join Employee_Projects EP on e.emp_id=EP.emp_id where EP.emp_id is null;
-- Show total project hours worked by each employee.
select sum(hours_worked) from Employees e  join Employee_Projects EP on e.emp_id=EP.emp_id group by e.emp_name;

-- Find employees working in departments where average salary > 70000.
select distinct e.emp_name,avg(e.salary) from Employees e join Departments d on e.dept_id=d.dept_id group by e.emp_name having avg(salary)>70000;
-- List all departments with total salary expense > 100000.
select distinct d.dept_name,sum(e.salary) from Employees e join Departments d on e.dept_id=d.dept_id group by d.dept_name having sum(salary)>100000;

-- Display employees who earn more than the average salary of their department.
select e.emp_name,d.dept_name,avg(e.salary) from Employees e join Departments d on e.dept_id=d.dept_id group by d.dept_name,e.emp_name;
-- List all projects with department name and average hours worked by employees.
SELECT p.project_name, d.dept_name, AVG(EP.hours_worked) AS avg_hours
FROM Projects p
JOIN Departments d ON p.dept_id = d.dept_id
LEFT JOIN Employee_Projects EP ON p.project_id = EP.project_id
GROUP BY p.project_name, d.dept_name;
-- Show the highest-paid employee in each department.
select e.emp_name,d.dept_name from Employees e join Departments d on e.dept_id=d.dept_id  where salary in
(select max(e.salary) from Employees group by dept_id);
-- Find all employees who joined before 2020 and work in Finance.
SELECT e.emp_name, e.hire_date, d.dept_name
FROM Employees e
JOIN Departments d ON e.dept_id = d.dept_id
WHERE e.hire_date < '2020-01-01'
  AND d.dept_name = 'Finance';

-- List all departments that have no projects assigned.
select d.dept_name from Departments d left join Projects p on d.dept_id=p.dept_id where p.dept_id is null; 
-- Display the total number of projects per department using GROUP BY.
select count(project_id) from Projects p left join Departments d on p.dept_id=d.dept_id group by d.dept_name;
 -- Find departments where the average project budget exceeds 60000.
select d.dept_name,avg(p.budget) from Departments d join Projects p on d.dept_id=p.dept_id group by d.dept_name having avg(budget) >60000;
-- List employees and the number of projects they are assigned to.
select e.emp_name,count(project_id) from Employees e join Employee_Projects ep on e.emp_id=ep.emp_id group by e.emp_name;
-- Find employees who have worked more than 150 total hours across projects.
select e.emp_name,sum(ep.hours_worked) from Employees e join Employee_Projects ep on e.emp_id=ep.emp_id group by e.emp_name having sum(ep.hours_worked)>150;
-- Show departments that have at least one project with budget < 50000.
select distinct d.dept_name from Departments d join Projects p on d.dept_id=p.dept_id where p.budget<50000;
-- Display all employees with their department name and total hours worked, even if they have no project.
SELECT 
e.emp_name,d.dept_name,COALESCE(SUM(ep.hours_worked), 0) AS total_hours
FROM Employees e
JOIN Departments d ON e.dept_id = d.dept_id
LEFT JOIN Employee_Projects ep ON e.emp_id = ep.emp_id
GROUP BY e.emp_name, d.dept_name;
