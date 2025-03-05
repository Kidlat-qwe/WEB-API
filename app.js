const express = require('express');
const { Pool } = require('pg');
const cors = require('cors');

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

// Test database connection
pool.query('SELECT NOW()', (err, res) => {
    if (err) {
        console.error('Database connection error:', err);
    } else {
        console.log('Database connected successfully');
        // List all tables
        pool.query(`SELECT * FROM teacher`).then(result => {
            console.log('Teachers:', result.rows);
        });
    }
});

app.get('/api/teachers', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM teacher');
        res.json(result.rows);
    } catch (error) {
        console.error('Error:', error);
        res.status(500).json({ error: error.message });
    }
});

app.get('/api/subjects', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM subject');
        res.json(result.rows);
    } catch (error) {
        console.error('Error:', error);
        res.status(500).json({ error: error.message });
    }
});

app.get('/api/classes', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM class');
        res.json(result.rows);
    } catch (error) {
        console.error('Error:', error);
        res.status(500).json({ error: error.message });
    }
});

const PORT = 5174;

app.listen(PORT, () => {
    console.log(`Server running at http://localhost:${PORT}`);
});
