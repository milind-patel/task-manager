# Task Manager Application

A full-stack task management application built with Ruby on Rails API backend and React + TypeScript frontend.

## Tech Stack

| Layer      | Technology              |
|------------|-------------------------|
| Backend    | Ruby on Rails 8 (API mode) |
| Frontend   | React 18 + TypeScript   |
| Database   | SQLite3                 |
| Build Tool | Vite                    |

## Features

- Create, read, update, and delete tasks
- Priority levels (high, medium, low)
- Status tracking (todo, in_progress, done)
- Due dates with overdue highlighting
- Categories for organizing tasks
- Filter tasks by status, priority, and category

## Prerequisites

- Ruby 3.2+ (recommended: use RVM or rbenv)
- Node.js 20.19+ or 22.12+
- npm or yarn

## Project Structure

```
2026/
├── task-manager-api/          # Rails API backend
│   ├── app/
│   │   ├── controllers/api/v1/
│   │   │   ├── tasks_controller.rb
│   │   │   └── categories_controller.rb
│   │   └── models/
│   │       ├── task.rb
│   │       └── category.rb
│   ├── db/
│   │   └── migrate/
│   └── config/
│       ├── routes.rb
│       └── initializers/cors.rb
│
├── task-manager-ui/           # React + TypeScript frontend
│   ├── src/
│   │   ├── components/
│   │   │   ├── TaskList.tsx
│   │   │   ├── TaskCard.tsx
│   │   │   ├── TaskForm.tsx
│   │   │   └── Filters.tsx
│   │   ├── types/index.ts
│   │   ├── services/api.ts
│   │   ├── App.tsx
│   │   └── App.css
│   └── package.json
│
└── README.md
```

## Setup Instructions

### Backend Setup

1. Navigate to the API directory:
   ```bash
   cd task-manager-api
   ```

2. Install Ruby dependencies:
   ```bash
   bundle install
   ```

3. Set up the database:
   ```bash
   rails db:migrate
   rails db:seed  # Optional: adds sample data
   ```

4. Start the Rails server:
   ```bash
   rails server -p 3000
   ```

   The API will be available at `http://localhost:3000`

### Frontend Setup

1. Navigate to the UI directory:
   ```bash
   cd task-manager-ui
   ```

2. Install Node dependencies:
   ```bash
   npm install
   ```

3. Start the development server:
   ```bash
   npm run dev
   ```

   The app will be available at `http://localhost:5173`

## API Documentation

### Tasks

| Method | Endpoint           | Description        | Request Body |
|--------|--------------------|--------------------|--------------|
| GET    | /api/v1/tasks      | List all tasks     | - |
| GET    | /api/v1/tasks/:id  | Get single task    | - |
| POST   | /api/v1/tasks      | Create task        | `{ task: { title, description, priority, status, due_date, category_id } }` |
| PATCH  | /api/v1/tasks/:id  | Update task        | `{ task: { ... } }` |
| DELETE | /api/v1/tasks/:id  | Delete task        | - |

**Query Parameters for GET /api/v1/tasks:**
- `status` - Filter by status (todo, in_progress, done)
- `priority` - Filter by priority (high, medium, low)
- `category_id` - Filter by category ID

### Categories

| Method | Endpoint               | Description          | Request Body |
|--------|------------------------|----------------------|--------------|
| GET    | /api/v1/categories     | List all categories  | - |
| POST   | /api/v1/categories     | Create category      | `{ category: { name } }` |
| DELETE | /api/v1/categories/:id | Delete category      | - |

### Example API Requests

**Create a task:**
```bash
curl -X POST http://localhost:3000/api/v1/tasks \
  -H "Content-Type: application/json" \
  -d '{"task": {"title": "My new task", "priority": "high", "status": "todo"}}'
```

**Get all tasks:**
```bash
curl http://localhost:3000/api/v1/tasks
```

**Filter tasks by status:**
```bash
curl "http://localhost:3000/api/v1/tasks?status=todo"
```

**Update a task:**
```bash
curl -X PATCH http://localhost:3000/api/v1/tasks/1 \
  -H "Content-Type: application/json" \
  -d '{"task": {"status": "done"}}'
```

## Database Schema

### Tasks Table
| Column      | Type     | Constraints                           |
|-------------|----------|---------------------------------------|
| id          | integer  | primary key                           |
| title       | string   | not null                              |
| description | text     | nullable                              |
| priority    | string   | default: 'medium' (high/medium/low)   |
| status      | string   | default: 'todo' (todo/in_progress/done) |
| due_date    | date     | nullable                              |
| category_id | integer  | foreign key, nullable                 |
| created_at  | datetime | auto                                  |
| updated_at  | datetime | auto                                  |

### Categories Table
| Column     | Type     | Constraints      |
|------------|----------|------------------|
| id         | integer  | primary key      |
| name       | string   | not null, unique |
| created_at | datetime | auto             |
| updated_at | datetime | auto             |

## Development

### Running Tests

**Backend:**
```bash
cd task-manager-api
rails test
```

**Frontend:**
```bash
cd task-manager-ui
npm run test
```

### Building for Production

**Frontend:**
```bash
cd task-manager-ui
npm run build
```

The built files will be in the `dist/` directory.

## Troubleshooting

### CORS Issues
If you encounter CORS errors, ensure the Rails server is running and the CORS configuration in `config/initializers/cors.rb` includes your frontend URL.

### Database Issues
Reset the database if you encounter migration issues:
```bash
cd task-manager-api
rails db:drop db:create db:migrate db:seed
```

### Node Version Warning
The project uses Vite 7 which requires Node.js 20.19+ or 22.12+. Update your Node.js version if you see version warnings.
