DROP TABLE IF EXISTS artists; 

-- Table Definition
CREATE TABLE artists (
    id SERIAL PRIMARY KEY,
    name text,
    genre text
);

TRUNCATE TABLE artists RESTART IDENTITY;

INSERT INTO artists ("name", "genre") VALUES
('Pixies', 'Rock'),
('ABBA', 'Pop'),
('Taylor Swift', 'Pop'),
('Nina Simone', 'Pop');

