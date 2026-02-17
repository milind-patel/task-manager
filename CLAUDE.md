# Task Manager — Claude Code Instructions

Full-stack task management app: **Rails 8 API** (`task-manager-api/`, port 3000) + **React 19 + TypeScript** frontend (`task-manager-ui/`, port 5173).

---

## Setup

### Prerequisites

| Tool | Required version |
|------|-----------------|
| Ruby | 3.2+ |
| Node.js | 20.19+ or 22.12+ |
| npm | bundled with Node |

### Backend

```bash
cd task-manager-api
bundle install
rails db:migrate
rails db:seed          # optional — loads sample data
rails server -p 3000
```

### Frontend

```bash
cd task-manager-ui
npm install
npm run dev            # http://localhost:5173
```

### Common fixes

| Problem | Fix |
|---------|-----|
| Port 3000 in use | `lsof -ti:3000 \| xargs kill -9` |
| Port 5173 in use | `lsof -ti:5173 \| xargs kill -9` |
| Migration conflicts | `rails db:drop db:create db:migrate db:seed` |
| Node version warning | Upgrade to Node 20.19+ or 22.12+ |

---

## Development commands

```bash
# Backend linting
cd task-manager-api && rubocop

# Frontend linting
cd task-manager-ui && npm run lint

# Backend tests
cd task-manager-api && rails test

# Frontend tests
cd task-manager-ui && npm run test

# Production build (output: task-manager-ui/dist/)
cd task-manager-ui && npm run build
```

---

## Architecture rules

### Backend (Rails API)

- **API-only mode.** No views, no assets pipeline, no session cookies.
- **Namespace all routes** under `/api/v1/`. New resources must follow the same pattern.
- **Thin controllers.** Controllers handle HTTP concerns only (params, status codes, render). Business logic belongs in models or service objects.
- **Strong parameters required** on every controller action that accepts user input. Never use `permit!` or pass raw params to ActiveRecord.
- **Models own validations.** Validate presence, format, and enum values at the model layer; never rely on the database alone.
- **Use migrations** for every schema change — no manual `ALTER TABLE`, no editing existing migration files after they have been committed.
- **Enum fields** (`priority`, `status`) must be defined with explicit string values in the model and validated with `inclusion`.
- **Associations**: Task `belongs_to :category, optional: true`. Deleting a category sets `category_id` to `null` — do not cascade delete tasks.
- **API versioning**: bump to `v2` namespace for breaking changes; never modify the `v1` contract once in production.
- **JSON responses only.** Always render JSON. Use `render json:` with explicit `status:` codes.

#### Directory layout

```
task-manager-api/app/
├── controllers/api/v1/     # TasksController, CategoriesController
├── models/                 # task.rb, category.rb
└── config/
    ├── routes.rb
    └── initializers/cors.rb
```

### Frontend (React + TypeScript)

- **Strict TypeScript.** All props, state, and API payloads must be typed. Interfaces live in `src/types/index.ts`. No `any`.
- **API calls only through the service layer** (`src/services/api.ts`). Components must never call `fetch`/`axios` directly.
- **State management via React Hooks** (`useState`, `useEffect`). Do not introduce a global state library (Redux, Zustand, etc.) without explicit approval.
- **Small, focused components.** Each component has a single responsibility. Extract reusable logic into custom hooks under `src/hooks/`.
- **Prop types via interfaces** — never use inline object literals as prop types.
- **No inline event handlers** in JSX for anything beyond trivial cases. Define handler functions inside the component body.
- **Error boundaries**: surface API errors as user-visible messages, not silent failures or raw `console.error` calls.
- **Do not dangerously set inner HTML.** Use React's JSX escaping at all times.

#### Directory layout

```
task-manager-ui/src/
├── components/     # TaskList, TaskCard, TaskForm, Filters
├── services/       # api.ts — all HTTP calls
├── types/          # index.ts — shared interfaces
├── App.tsx
└── main.tsx
```

### API contract

| Method | Path | Purpose |
|--------|------|---------|
| GET | /api/v1/tasks | List tasks (filterable by `status`, `priority`, `category_id`) |
| GET | /api/v1/tasks/:id | Single task |
| POST | /api/v1/tasks | Create task |
| PATCH | /api/v1/tasks/:id | Update task |
| DELETE | /api/v1/tasks/:id | Delete task |
| GET | /api/v1/categories | List categories |
| POST | /api/v1/categories | Create category |
| DELETE | /api/v1/categories/:id | Delete category |

Always return the appropriate HTTP status: `200`, `201`, `204`, `422`, `404`. Never swallow errors with a `200` envelope.

---

## Security rules

### Backend

1. **Strong parameters — no exceptions.** Every controller action that writes to the database must go through an explicit `params.require(...).permit(...)` allowlist. `permit!` is banned.
2. **No raw SQL.** Use ActiveRecord query methods or parameterized `where("col = ?", value)`. String interpolation inside SQL (`where("col = '#{val}'"`) is forbidden — it opens SQL injection.
3. **CORS is locked to known origins.** The allowlist in `config/initializers/cors.rb` currently allows only `http://localhost:5173` and `http://127.0.0.1:5173`. For production, replace these with the exact production domain — never use `"*"`.
4. **No secrets in source code.** API keys, credentials, and connection strings must live in `config/credentials.yml.enc` or environment variables. Never commit `.env` files.
5. **Validate all enum inputs.** `priority` and `status` are enums — always validate `inclusion` before persisting.
6. **HTTP status codes carry meaning.** Return `422 Unprocessable Entity` for validation failures with a JSON body containing `errors`. Do not return `200` on failure.
7. **Rate limiting and authentication are out of scope for development** but must be added before any production deployment. Flag these gaps if asked to deploy.

### Frontend

1. **Never use `dangerouslySetInnerHTML`.** React's JSX escaping is the only acceptable rendering path for user-supplied content.
2. **Do not store sensitive data in `localStorage` or `sessionStorage`.** There is no auth in the current scope; if auth is added, tokens must be in `HttpOnly` cookies.
3. **Validate user input client-side before sending.** Empty titles, invalid date formats, and out-of-range values should be caught in the form layer and never reach the API.
4. **Do not expose internal error stack traces to the UI.** Catch errors in the service layer, log to the console in development only, and surface a generic message to the user.
5. **Content Security Policy**: when configuring the production web server (Nginx, etc.), set a strict CSP header that disallows inline scripts and restricts `connect-src` to the API origin.
6. **Dependency hygiene.** Run `npm audit` before merging. Do not add dependencies without reviewing their transitive footprint.

### Git / secrets hygiene

- `.gitignore` already excludes `*.env`, `*.sqlite3`, and Rails credentials. Verify this before committing.
- Never force-push to `main`.
- Feature branches: `feature/<name>`, bug fixes: `fix/<name>`.
