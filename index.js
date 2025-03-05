import express from 'express';
import cors from 'cors';
import pkg from 'pg';

const { Pool } = pkg;
const app = express();

app.use(cors());
app.use(express.json());

const pool = new Pool({
    user: "postgres",
    host: "localhost",
    database: "Grade",
    password: "2025",
    port: 5432
});

// Simple test route
app.get('/', (req, res) => {
    res.json({ message: 'Server is running' });
});

// Teachers route
app.get('/api/teachers', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM teacher');
        res.json(result.rows);
    } catch (error) {
        console.error('Error:', error);
        res.status(500).json({ error: error.message });
    }
});

// Classes route
app.get('/api/classes', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM class');
        res.json(result.rows);
    } catch (error) {
        console.error('Error:', error);
        res.status(500).json({ error: error.message });
    }
});

// Subjects route
app.get('/api/subjects', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM subject');
        res.json(result.rows);
    } catch (error) {
        console.error('Error:', error);
        res.status(500).json({ error: error.message });
    }
});

const PORT = 5174;

app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
    
    // Test database connection
    pool.query('SELECT NOW()', (err, res) => {
        if (err) {
            console.error('Database connection error:', err);
        } else {
            console.log('Database connected successfully');
            pool.query('SELECT * FROM teacher').then(result => {
                console.log('Teachers in database:', result.rows);
            }).catch(err => {
                console.error('Error fetching teachers:', err);
            });
        }
    });
});
