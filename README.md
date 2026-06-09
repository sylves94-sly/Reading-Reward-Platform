# 📚 Reading Rewards Platform

An advanced educational reading platform where schools enroll students to read storybooks and earn points for completing books.

## ✨ Features

- 📚 School enrollment and management
- 👨‍🎓 Student accounts with reading profiles
- 📖 Digital book library with categories and difficulty levels
- 🎮 Gamification with points and rewards system
- 📊 Teacher dashboards for progress tracking
- 🏆 Leaderboards and achievements
- 📈 Analytics and reporting
- 🔐 Secure JWT authentication

## 🛠 Tech Stack

- **Frontend**: Next.js 14, React 18, TypeScript, Tailwind CSS
- **Backend**: Node.js, Express, TypeScript
- **Database**: PostgreSQL
- **Authentication**: JWT + Bcrypt
- **Containerization**: Docker & Docker Compose

## 📁 Project Structure

```
reading-rewards-platform/
├── frontend/              # Next.js React application
│   ├── pages/
│   ├── components/
│   ├── styles/
│   └── package.json
├── backend/               # Express API server
│   ├── src/
│   │   ├── routes/
│   │   ├── middleware/
│   │   ├── config/
│   │   └── index.ts
│   └── package.json
├── database/              # PostgreSQL schema
│   ├── schema.sql
│   └── init.sql
├── docker-compose.yml     # Docker orchestration
├── .env.example           # Environment template
└── README.md
```

## 🚀 Quick Start

### Option 1: Docker (Recommended)
```bash
docker-compose up
```

### Option 2: Manual Setup
See documentation for detailed setup instructions.

## 📖 API Documentation

Base URL: `http://localhost:5000/api`

Core endpoints for:
- Authentication
- Books management
- Reading progress tracking
- Leaderboards
- School management

## 🔐 User Roles

- **admin** - Platform administrator
- **school_admin** - School administrator
- **teacher** - Teacher/educator
- **student** - Student user

## 🎮 Gamification System

- Students earn points for completing books
- Reading streaks reward consistent engagement
- Leaderboards drive friendly competition
- Badges/achievements for milestones

## 📄 License

MIT License
