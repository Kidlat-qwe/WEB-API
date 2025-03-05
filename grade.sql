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
    school_year_id SERIAL,
    school_year character varying(10),
    is_active boolean
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

-- Class-Student Table
CREATE TABLE class_student (
    class_id INTEGER REFERENCES class(class_id) ON DELETE CASCADE,
    student_id INTEGER REFERENCES users(user_id) ON DELETE CASCADE,
    PRIMARY KEY (class_id, student_id)
);

-- Class-Subject Table
CREATE TABLE class_subject (
    class_id INTEGER REFERENCES class(class_id) ON DELETE CASCADE,
    subject_id INTEGER REFERENCES subject(subject_id) ON DELETE CASCADE,
    teacher_id INTEGER REFERENCES users(user_id) ON DELETE CASCADE,
    PRIMARY KEY (class_id, subject_id, teacher_id)
);

-- Student Grade Table
CREATE TABLE student_grade (
    student_id INTEGER REFERENCES users(user_id) ON DELETE CASCADE,
    class_id INTEGER REFERENCES class(class_id) ON DELETE CASCADE,
    subject_id INTEGER REFERENCES subject(subject_id) ON DELETE CASCADE,
    teacher_id INTEGER REFERENCES users(user_id) ON DELETE CASCADE,
    quarter INTEGER CHECK (quarter BETWEEN 1 AND 4),
    grade NUMERIC(5,2) CHECK (grade BETWEEN 0 AND 100),
    PRIMARY KEY (student_id, class_id, subject_id, quarter)
);

-- Insert Users
INSERT INTO users (email, user_type, fname, mname, lname, gender, teacher_status, firebase_uid) VALUES
('admin@school.com', 'Admin', 'Admin', NULL, 'User', 'M', FALSE, 'admin123'),
('john.doe@school.com', 'Teacher', 'John', 'A.', 'Doe', 'M', TRUE, 'teacher123'),
('jane.doe@school.com', 'Teacher', 'Jane', 'B.', 'Doe', 'F', TRUE, 'teacher456'),
('alice.j@school.com', 'Student', 'Alice', 'M.', 'Johnson', 'F', FALSE, 'student123'),
('bob.s@school.com', 'Student', 'Bob', 'L.', 'Smith', 'M', FALSE, 'student456');

-- Insert School Years
INSERT INTO school_year (school_year_id, school_year, is_active) VALUES
(1, '2023-2024', true),
(2, '2024-2025', false);

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

-- Insert Class-Student Relationships
INSERT INTO class_student (class_id, student_id) VALUES
(1, 4),  -- Alice in Grade 5-A
(2, 5);  -- Bob in Grade 6-B

-- Insert Class-Subject Relationships
INSERT INTO class_subject (class_id, subject_id, teacher_id) VALUES
(1, 1, 2),  -- Grade 5-A, Mathematics, John Doe
(1, 2, 2),  -- Grade 5-A, Science, John Doe
(2, 1, 2),  -- Grade 6-B, Mathematics, John Doe
(2, 2, 3);  -- Grade 6-B, Science, Jane Doe

-- Insert Student Grades
INSERT INTO student_grade (student_id, class_id, subject_id, teacher_id, quarter, grade) VALUES
(4, 1, 1, 2, 1, 85.50),  -- Alice, Grade 5-A, Mathematics, Q1
(4, 1, 2, 2, 1, 88.75),  -- Alice, Grade 5-A, Science, Q1
(5, 2, 1, 2, 1, 90.00),  -- Bob, Grade 6-B, Mathematics, Q1
(5, 2, 2, 3, 1, 92.25);  -- Bob, Grade 6-B, Science, Q1
