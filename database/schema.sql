-- Reading Rewards Platform Database Schema

-- Create ENUM types
CREATE TYPE user_role AS ENUM ('admin', 'school_admin', 'teacher', 'student');
CREATE TYPE book_genre AS ENUM ('fiction', 'non_fiction', 'mystery', 'fantasy', 'science_fiction', 'romance', 'biography', 'history', 'poetry', 'educational');
CREATE TYPE difficulty_level AS ENUM ('beginner', 'intermediate', 'advanced', 'expert');
CREATE TYPE enrollment_status AS ENUM ('pending', 'active', 'suspended', 'cancelled');

-- Users table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    role user_role NOT NULL DEFAULT 'student',
    profile_picture_url TEXT,
    bio TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP,
    is_active BOOLEAN DEFAULT true
);

-- Schools table
CREATE TABLE schools (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    registration_number VARCHAR(100) UNIQUE NOT NULL,
    country VARCHAR(100),
    state VARCHAR(100),
    city VARCHAR(100),
    address TEXT,
    phone_number VARCHAR(20),
    email VARCHAR(255) UNIQUE NOT NULL,
    school_admin_id INTEGER NOT NULL,
    logo_url TEXT,
    website VARCHAR(255),
    enrollment_status enrollment_status DEFAULT 'pending',
    total_students INTEGER DEFAULT 0,
    subscription_tier VARCHAR(50) DEFAULT 'free',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (school_admin_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Classes table
CREATE TABLE classes (
    id SERIAL PRIMARY KEY,
    school_id INTEGER NOT NULL,
    teacher_id INTEGER NOT NULL,
    name VARCHAR(100) NOT NULL,
    grade_level VARCHAR(50),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (school_id) REFERENCES schools(id) ON DELETE CASCADE,
    FOREIGN KEY (teacher_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Students table
CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL UNIQUE,
    school_id INTEGER NOT NULL,
    class_id INTEGER,
    student_id_number VARCHAR(100),
    date_of_birth DATE,
    parent_name VARCHAR(255),
    parent_email VARCHAR(255),
    parent_phone VARCHAR(20),
    total_points INTEGER DEFAULT 0,
    total_books_read INTEGER DEFAULT 0,
    reading_streak INTEGER DEFAULT 0,
    last_read_date TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (school_id) REFERENCES schools(id) ON DELETE CASCADE,
    FOREIGN KEY (class_id) REFERENCES classes(id) ON DELETE SET NULL
);

-- Teachers table
CREATE TABLE teachers (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL UNIQUE,
    school_id INTEGER NOT NULL,
    subject_specialty VARCHAR(100),
    years_of_experience INTEGER,
    qualification VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (school_id) REFERENCES schools(id) ON DELETE CASCADE
);

-- Books table
CREATE TABLE books (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    isbn VARCHAR(20) UNIQUE,
    description TEXT,
    cover_image_url TEXT,
    file_url TEXT NOT NULL,
    genre book_genre NOT NULL,
    difficulty_level difficulty_level NOT NULL,
    recommended_age_min INTEGER,
    recommended_age_max INTEGER,
    page_count INTEGER,
    word_count INTEGER,
    estimated_reading_time_minutes INTEGER,
    points_reward INTEGER NOT NULL DEFAULT 10,
    language VARCHAR(50) DEFAULT 'English',
    publication_year INTEGER,
    is_published BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Student Reading Progress table
CREATE TABLE reading_progress (
    id SERIAL PRIMARY KEY,
    student_id INTEGER NOT NULL,
    book_id INTEGER NOT NULL,
    pages_read INTEGER DEFAULT 0,
    percentage_complete DECIMAL(5,2) DEFAULT 0,
    is_completed BOOLEAN DEFAULT false,
    points_earned INTEGER DEFAULT 0,
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    last_read_at TIMESTAMP,
    reading_time_minutes INTEGER DEFAULT 0,
    comprehension_score DECIMAL(5,2),
    quiz_passed BOOLEAN,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE,
    UNIQUE(student_id, book_id)
);

-- Achievements/Badges table
CREATE TABLE achievements (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    badge_icon_url TEXT,
    criteria VARCHAR(255) NOT NULL,
    points_value INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Student Achievements (junction table)
CREATE TABLE student_achievements (
    id SERIAL PRIMARY KEY,
    student_id INTEGER NOT NULL,
    achievement_id INTEGER NOT NULL,
    earned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (achievement_id) REFERENCES achievements(id) ON DELETE CASCADE,
    UNIQUE(student_id, achievement_id)
);

-- Leaderboard table (cached for performance)
CREATE TABLE leaderboard (
    id SERIAL PRIMARY KEY,
    student_id INTEGER NOT NULL,
    school_id INTEGER NOT NULL,
    class_id INTEGER,
    total_points INTEGER DEFAULT 0,
    total_books_read INTEGER DEFAULT 0,
    ranking INTEGER,
    class_ranking INTEGER,
    school_ranking INTEGER,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (school_id) REFERENCES schools(id) ON DELETE CASCADE,
    FOREIGN KEY (class_id) REFERENCES classes(id) ON DELETE SET NULL
);

-- Reading Sessions table
CREATE TABLE reading_sessions (
    id SERIAL PRIMARY KEY,
    student_id INTEGER NOT NULL,
    book_id INTEGER NOT NULL,
    session_start TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    session_end TIMESTAMP,
    pages_read_in_session INTEGER,
    reading_time_minutes INTEGER,
    notes TEXT,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE
);

-- Create indexes for performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_schools_admin ON schools(school_admin_id);
CREATE INDEX idx_students_school ON students(school_id);
CREATE INDEX idx_students_class ON students(class_id);
CREATE INDEX idx_students_user ON students(user_id);
CREATE INDEX idx_reading_progress_student ON reading_progress(student_id);
CREATE INDEX idx_reading_progress_book ON reading_progress(book_id);
CREATE INDEX idx_reading_progress_completed ON reading_progress(is_completed);
CREATE INDEX idx_books_genre ON books(genre);
CREATE INDEX idx_books_difficulty ON books(difficulty_level);
CREATE INDEX idx_leaderboard_school ON leaderboard(school_id);
CREATE INDEX idx_leaderboard_class ON leaderboard(class_id);
CREATE INDEX idx_reading_sessions_student ON reading_sessions(student_id);

-- Create triggers for updated_at timestamps
CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_users_timestamp BEFORE UPDATE ON users
FOR EACH ROW EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER update_schools_timestamp BEFORE UPDATE ON schools
FOR EACH ROW EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER update_students_timestamp BEFORE UPDATE ON students
FOR EACH ROW EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER update_books_timestamp BEFORE UPDATE ON books
FOR EACH ROW EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER update_reading_progress_timestamp BEFORE UPDATE ON reading_progress
FOR EACH ROW EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER update_leaderboard_timestamp BEFORE UPDATE ON leaderboard
FOR EACH ROW EXECUTE FUNCTION update_timestamp();
