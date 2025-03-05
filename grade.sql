CREATE DATABASE school_db;
\c school_db;

-- Users Table
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    user_type VARCHAR(20) NOT NULL,
    flag BOOLEAN DEFAULT TRUE
);

-- School Year Table
CREATE TABLE school_year (
    school_year_id SERIAL PRIMARY KEY,
    school_year VARCHAR(10) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE
);

-- Student Table
CREATE TABLE student (
    student_id SERIAL PRIMARY KEY,
    fname VARCHAR(50) NOT NULL,
    mname VARCHAR(50),
    lname VARCHAR(50) NOT NULL,
    gender VARCHAR(1),
    age INTEGER,
    user_id INTEGER REFERENCES users(user_id) ON DELETE SET NULL
);

-- Teacher Table
CREATE TABLE teacher (
    teacher_id SERIAL PRIMARY KEY,
    fname VARCHAR(50) NOT NULL,
    mname VARCHAR(50),
    lname VARCHAR(50) NOT NULL,
    gender VARCHAR(1),
    status BOOLEAN DEFAULT TRUE,
    user_id INTEGER REFERENCES users(user_id) ON DELETE SET NULL
);

-- Subject Table
CREATE TABLE subject (
    subject_id SERIAL PRIMARY KEY,
    subject_name VARCHAR(50) NOT NULL
);

-- Class Table
CREATE TABLE class (
    class_id SERIAL PRIMARY KEY,
    grade_level VARCHAR(20) NOT NULL,
    section VARCHAR(1) NOT NULL,
    class_description VARCHAR(50),
    school_year VARCHAR(10) NOT NULL
);

-- Student Grade Table
CREATE TABLE student_grade (
    student_id INTEGER REFERENCES student(student_id) ON DELETE CASCADE,
    class_id INTEGER REFERENCES class(class_id) ON DELETE CASCADE,
    subject_id INTEGER REFERENCES subject(subject_id) ON DELETE CASCADE,
    teacher_id INTEGER REFERENCES teacher(teacher_id) ON DELETE CASCADE,
    quarter INTEGER CHECK (quarter BETWEEN 1 AND 4),
    grade NUMERIC(5,2),
    PRIMARY KEY (student_id, class_id, subject_id, quarter)
);

-- Class-Student Table
CREATE TABLE class_student (
    class_id INTEGER REFERENCES class(class_id) ON DELETE CASCADE,
    student_id INTEGER REFERENCES student(student_id) ON DELETE CASCADE,
    PRIMARY KEY (class_id, student_id)
);

-- Class-Subject Table
CREATE TABLE class_subject (
    class_id INTEGER REFERENCES class(class_id) ON DELETE CASCADE,
    subject_id INTEGER REFERENCES subject(subject_id) ON DELETE CASCADE,
    teacher_id INTEGER REFERENCES teacher(teacher_id) ON DELETE CASCADE,
    PRIMARY KEY (class_id, subject_id, teacher_id)
);

-- Insert Users
INSERT INTO users (username, password, user_type, flag) VALUES
('admin', 'Admin@123', 'Admin', TRUE),
('teacher1', 'Teach@456', 'Teacher', TRUE),
('student1', 'Stud@789', 'Student', TRUE);

-- Insert School Years
INSERT INTO school_year (school_year, is_active) VALUES
('2023-2024', TRUE),
('2024-2025', FALSE);

-- Insert Students
INSERT INTO student (fname, mname, lname, gender, age, user_id) VALUES
('Alice', 'M.', 'Johnson', 'F', 10, 3),
('Bob', 'L.', 'Smith', 'M', 11, NULL);

-- Insert Teachers
INSERT INTO teacher (fname, mname, lname, gender, status, user_id) VALUES
('John', 'A.', 'Doe', 'M', TRUE, 2),
('Jane', 'B.', 'Doe', 'F', TRUE, NULL);

-- Insert Subjects
INSERT INTO subject (subject_name) VALUES
('Mathematics'),
('Science'),
('English'),
('Social Studies'),
('Computer Science');

-- Insert Classes
INSERT INTO class (grade_level, section, class_description, school_year) VALUES
('5', 'A', 'Regular Class', '2023-2024'),
('6', 'B', 'Advanced Class', '2023-2024');

-- Insert Student Grades
INSERT INTO student_grade (student_id, class_id, subject_id, teacher_id, quarter, grade) VALUES
(1, 1, 1, 1, 1, 85.50),
(2, 2, 2, 1, 1, 90.00);

-- Insert Class-Student Relationships
INSERT INTO class_student (class_id, student_id) VALUES
(1, 1),
(2, 2);

-- Insert Class-Subject Relationships
INSERT INTO class_subject (class_id, subject_id, teacher_id) VALUES
(1, 1, 1),
(2, 2, 1);
