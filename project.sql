create database project;
CREATE TABLE Employee (
    EmpID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Gender ENUM('Male', 'Female', 'Other'),
    DOB DATE,
    DepartmentID INT,
    Salary DECIMAL(10,2),
    Contact VARCHAR(15) UNIQUE,
    Email VARCHAR(100) UNIQUE,
    HireDate DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (DepartmentID) REFERENCES Department(DeptID) ON DELETE SET NULL
);
CREATE TABLE Department (
    DeptID INT PRIMARY KEY AUTO_INCREMENT,
    DeptName VARCHAR(100) UNIQUE NOT NULL,
    Location VARCHAR(100)
);
CREATE TABLE Salary (
    SalaryID INT PRIMARY KEY AUTO_INCREMENT,
    EmpID INT,
    BasicSalary DECIMAL(10,2),
    Bonus DECIMAL(10,2),
    Deductions DECIMAL(10,2),
    NetSalary DECIMAL(10,2) GENERATED ALWAYS AS (BasicSalary + Bonus - Deductions) STORED,
    FOREIGN KEY (EmpID) REFERENCES Employee(EmpID) ON DELETE CASCADE
);
CREATE TABLE Attendance (
    AttendanceID INT PRIMARY KEY AUTO_INCREMENT,
    EmpID INT,
    Date DATE DEFAULT (CURRENT_DATE),
    Status ENUM('Present', 'Absent', 'Leave') NOT NULL,
    FOREIGN KEY (EmpID) REFERENCES Employee(EmpID) ON DELETE CASCADE
);
CREATE TABLE Performance (
    PerformanceID INT PRIMARY KEY AUTO_INCREMENT,
    EmpID INT,
    Year INT CHECK (Year >= 2000),
    Rating DECIMAL(3,2) CHECK (Rating BETWEEN 1 AND 5),
    FOREIGN KEY (EmpID) REFERENCES Employee(EmpID) ON DELETE CASCADE
);
-- Insert Departments
INSERT INTO Department (DeptName, Location) VALUES 
('HR', 'New York'),
('IT', 'San Francisco'),
('Finance', 'Chicago');

-- Insert Employees
INSERT INTO Employee (Name, Gender, DOB, DepartmentID, Salary, Contact, Email) VALUES 
('Alice Johnson', 'Female', '1990-05-14', 1, 60000.00, '1234567890', 'alice@example.com'),
('Bob Smith', 'Male', '1985-08-20', 2, 80000.00, '9876543210', 'bob@example.com');

-- Insert Salary Details
INSERT INTO Salary (EmpID, BasicSalary, Bonus, Deductions) VALUES 
(1, 60000.00, 5000.00, 2000.00),
(2, 80000.00, 7000.00, 3000.00);

-- Insert Attendance Records
INSERT INTO Attendance (EmpID, Date, Status) VALUES 
(1, '2024-02-01', 'Present'),
(2, '2024-02-01', 'Absent');

-- Insert Performance Ratings
INSERT INTO Performance (EmpID, Year, Rating) VALUES 
(1, 2023, 4.5),
(2, 2023, 3.8);

SELECT e.EmpID, e.Name, e.Gender, e.Salary, d.DeptName
FROM Employee e
JOIN Department d ON e.DepartmentID = d.DeptID;

SELECT Name, Salary FROM Employee WHERE Salary > 70000;

UPDATE Employee SET Salary = Salary + 5000 WHERE EmpID = 1;

DELETE FROM Employee WHERE EmpID = 2;

SELECT e.Name, a.Date, a.Status
FROM Attendance a
JOIN Employee e ON a.EmpID = e.EmpID;

SELECT e.Name, a.Date, a.Status
FROM Attendance a
JOIN Employee e ON a.EmpID = e.EmpID;

DELIMITER //
CREATE PROCEDURE GetEmployeesByDepartment(IN dept_name VARCHAR(100))
BEGIN
    SELECT e.EmpID, e.Name, e.Salary 
    FROM Employee e 
    JOIN Department d ON e.DepartmentID = d.DeptID
    WHERE d.DeptName = dept_name;
END //
DELIMITER ;
CALL GetEmployeesByDepartment('IT');

CREATE TABLE EmployeeLog (
    LogID INT PRIMARY KEY AUTO_INCREMENT,
    EmpID INT,
    Name VARCHAR(100),
    DeletedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE TRIGGER BeforeEmployeeDelete
BEFORE DELETE ON Employee
FOR EACH ROW
BEGIN
    INSERT INTO EmployeeLog (EmpID, Name) VALUES (OLD.EmpID, OLD.Name);
END //
DELIMITER ;




