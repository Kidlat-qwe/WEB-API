CREATE DATABASE school_db;
\c school_db;

-- Users Table
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    email character varying(25),
    user_type character varying(20),
    fname character varying(50),
    mname character varying(50),
    lname character varying(50),
    gender character varying(1),
    teacher_status boolean,
    firebase_uid character varying(128)
);

-- School Year Table
CREATE TABLE school_year (
    school_year_id SERIAL PRIMARY KEY,
    school_year VARCHAR(10) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE
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
    user_id INTEGER REFERENCES users(user_id) ON DELETE CASCADE,
    class_id INTEGER REFERENCES class(class_id) ON DELETE CASCADE,
    subject_id INTEGER REFERENCES subject(subject_id) ON DELETE CASCADE,
    teacher_id INTEGER REFERENCES users(user_id) ON DELETE CASCADE,
    quarter INTEGER CHECK (quarter BETWEEN 1 AND 4),
    grade NUMERIC(5,2) CHECK (grade BETWEEN 0 AND 100),
    PRIMARY KEY (user_id, class_id, subject_id, quarter)
);

-- Class-Student Table
CREATE TABLE class_student (
    class_id INTEGER REFERENCES class(class_id) ON DELETE CASCADE,
    user_id INTEGER REFERENCES users(user_id) ON DELETE CASCADE,
    PRIMARY KEY (class_id, user_id)
);

-- Class-Subject Table
CREATE TABLE class_subject (
    class_id INTEGER REFERENCES class(class_id) ON DELETE CASCADE,
    subject_id INTEGER REFERENCES subject(subject_id) ON DELETE CASCADE,
    teacher_id INTEGER REFERENCES users(user_id) ON DELETE CASCADE,
    PRIMARY KEY (class_id, subject_id, teacher_id)
);

-- Insert Users (Including both teachers and students)
INSERT INTO users (email, user_type, fname, mname, lname, gender, teacher_status, firebase_uid) VALUES
('admin@school.com', 'Admin', 'Admin', NULL, 'User', 'M', FALSE, 'admin123'),
('john.doe@school.com', 'Teacher', 'John', 'A.', 'Doe', 'M', TRUE, 'teacher123'),
('jane.doe@school.com', 'Teacher', 'Jane', 'B.', 'Doe', 'F', TRUE, 'teacher456'),
('alice.j@school.com', 'Student', 'Alice', 'M.', 'Johnson', 'F', FALSE, 'student123'),
('bob.s@school.com', 'Student', 'Bob', 'L.', 'Smith', 'M', FALSE, 'student456');

-- Insert School Years
INSERT INTO school_year (school_year, is_active) VALUES
('2023-2024', TRUE),
('2024-2025', FALSE);

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

-- Insert Student Grades (using user_id instead of student_id)
INSERT INTO student_grade (user_id, class_id, subject_id, teacher_id, quarter, grade) VALUES
(4, 1, 1, 2, 1, 85.50),  -- Alice, Class 5-A, Mathematics, John Doe, Q1
(4, 1, 2, 2, 1, 88.75),  -- Alice, Class 5-A, Science, John Doe, Q1
(5, 2, 1, 2, 1, 90.00),  -- Bob, Class 6-B, Mathematics, John Doe, Q1
(5, 2, 2, 2, 1, 92.25);  -- Bob, Class 6-B, Science, John Doe, Q1

-- Insert Class-Student Relationships
INSERT INTO class_student (class_id, user_id) VALUES
(1, 4),  -- Alice in class 1
(2, 5);  -- Bob in class 2

-- Insert Class-Subject Relationships
INSERT INTO class_subject (class_id, subject_id, teacher_id) VALUES
(1, 1, 2),  -- Class 1, Math, John Doe
(2, 2, 2);  -- Class 2, Science, John Doe
