-- Initialize database and load schema
\c reading_rewards;

-- Load schema
\i schema.sql

-- Insert sample data
INSERT INTO books (title, author, genre, difficulty_level, page_count, word_count, points_reward, publication_year) VALUES
('The Great Adventure', 'John Smith', 'fiction', 'intermediate', 250, 45000, 50, 2020),
('Mystery in the Mountains', 'Sarah Johnson', 'mystery', 'advanced', 320, 60000, 75, 2021),
('Space Explorers', 'Mike Chen', 'science_fiction', 'beginner', 180, 30000, 40, 2019),
('The Magic Forest', 'Emma Wilson', 'fantasy', 'beginner', 200, 35000, 45, 2022),
('History of Ancient Rome', 'Dr. Robert Brown', 'history', 'intermediate', 400, 80000, 80, 2020),
('Poetry Collection', 'Various Authors', 'poetry', 'advanced', 150, 20000, 30, 2021);

-- Insert sample achievements
INSERT INTO achievements (name, description, criteria, points_value) VALUES
('First Reader', 'Complete your first book', 'Complete 1 book', 10),
('Book Lover', 'Complete 5 books', 'Complete 5 books', 50),
('Reading Champion', 'Complete 10 books', 'Complete 10 books', 100),
('Quick Learner', 'Complete a book in 7 days', 'Complete book in 7 days', 25),
('Reading Streak', 'Read for 7 consecutive days', '7 day streak', 35);

COMMIT;
