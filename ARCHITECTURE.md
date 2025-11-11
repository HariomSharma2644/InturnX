# InturnX Vercel Deployment Architecture

## 🏗️ System Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                         USER'S BROWSER                              │
│                    https://your-app.vercel.app                      │
└────────────────────────────┬────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      VERCEL EDGE NETWORK                            │
│                    (Global CDN & Routing)                           │
└────────────┬────────────────────────────────────┬───────────────────┘
             │                                    │
             ▼                                    ▼
┌────────────────────────┐          ┌────────────────────────────────┐
│   STATIC FRONTEND      │          │   SERVERLESS FUNCTIONS         │
│   (React + Vite)       │          │   (Node.js + Python)           │
├────────────────────────┤          ├────────────────────────────────┤
│                        │          │                                │
│ • Built from /client   │          │ Backend API (Node.js):         │
│ • Served from /dist    │          │ • /api/* → server/api/index.js │
│ • Static HTML/CSS/JS   │          │ • Express routes               │
│ • React Router         │          │ • Authentication               │
│ • Vite optimized       │          │ • Database operations          │
│                        │          │                                │
│                        │          │ AI Service (Python):           │
│                        │          │ • /api/ai/* → api/ai/index.py  │
│                        │          │ • FastAPI endpoints            │
│                        │          │ • ML/AI operations             │
│                        │          │                                │
└────────────────────────┘          └────────────┬───────────────────┘
                                                 │
                                                 ▼
                              ┌──────────────────────────────────────┐
                              │      EXTERNAL SERVICES               │
                              ├──────────────────────────────────────┤
                              │                                      │
                              │ • MongoDB Atlas (Database)           │
                              │ • Google OAuth                       │
                              │ • GitHub OAuth                       │
                              │ • LinkedIn OAuth                     │
                              │ • OpenAI API (optional)              │
                              │                                      │
                              └──────────────────────────────────────┘
```

## 📁 File Structure

```
inturnx/
│
├── client/                          # Frontend (React + Vite)
│   ├── src/                         # React source code
│   ├── dist/                        # Build output (deployed)
│   ├── package.json
│   └── vite.config.js
│
├── server/                          # Backend (Express)
│   ├── api/
│   │   └── index.js                 # ⭐ Vercel serverless entry
│   ├── routes/                      # API routes
│   ├── controllers/                 # Business logic
│   ├── models/                      # Database models
│   ├── middleware/                  # Express middleware
│   ├── config/                      # Configuration
│   ├── server.js                    # Original server (for local dev)
│   └── package.json
│
├── api/                             # Vercel serverless functions
│   └── ai/
│       └── index.py                 # ⭐ Python AI service
│
├── ai_service/                      # AI service source code
│   ├── main.py                      # FastAPI app
│   ├── recommend.py                 # Course recommendations
│   ├── resume_analyzer.py           # Resume analysis
│   ├── code_eval.py                 # Code evaluation
│   ├── chat_mentor.py               # AI mentor chat
│   └── requirements.txt
│
├── vercel.json                      # ⭐ Vercel configuration
├── .vercelignore                    # Files to exclude
├── requirements.txt                 # Python dependencies
├── package.json                     # Root package.json
│
├── .env.example                     # Environment variables template
├── deploy-to-vercel.sh              # Deployment script
├── setup-env-vercel.sh              # Env setup script
│
└── Documentation/
    ├── DEPLOY_CHECKLIST.md          # Step-by-step checklist
    ├── VERCEL_DEPLOYMENT_GUIDE.md   # Quick start guide
    ├── DEPLOYMENT.md                # Comprehensive guide
    ├── DEPLOYMENT_SUMMARY.md        # Setup summary
    └── ARCHITECTURE.md              # This file
```

## 🔄 Request Flow

### Frontend Request (Static Files)
```
User → Vercel Edge → /client/dist/index.html → Browser
```

### API Request (Backend)
```
User → Vercel Edge → /api/* → server/api/index.js → MongoDB Atlas
                                      ↓
                              Express Routes
                                      ↓
                              Controllers
                                      ↓
                              Database/Services
```

### AI Service Request
```
User → Vercel Edge → /api/ai/* → api/ai/index.py → AI Models
                                         ↓
                                  FastAPI Routes
                                         ↓
                                  AI Processing
```

### OAuth Flow
```
User → Click "Login with Google"
     → /api/auth/google
     → Redirect to Google
     → User authorizes
     → Google redirects to /api/auth/google/callback
     → Create session
     → Redirect to app
```

## 🔐 Environment Variables Flow

```
Local Development:
.env file → process.env → Application

Vercel Production:
Vercel Dashboard → Environment Variables → Serverless Functions
                                                    ↓
                                            process.env
                                                    ↓
                                              Application
```

## 💾 Data Flow

### User Registration
```
Frontend Form → POST /api/auth/register → Validate Data
                                               ↓
                                        Hash Password
                                               ↓
                                        Save to MongoDB
                                               ↓
                                        Generate JWT
                                               ↓
                                        Return Token
```

### Course Recommendation
```
User Profile → POST /api/ai/recommend → Python AI Service
                                              ↓
                                        Analyze Skills
                                              ↓
                                        ML Model Processing
                                              ↓
                                        Return Recommendations
```

## 🚀 Deployment Flow

### Build Process
```
1. Vercel receives deployment trigger (git push or manual)
2. Vercel reads vercel.json configuration
3. Install dependencies:
   - npm install (root)
   - npm install --prefix client
   - npm install --prefix server
   - pip install -r requirements.txt
4. Build frontend:
   - cd client && npm run build
   - Output: client/dist/
5. Prepare serverless functions:
   - server/api/index.js → Node.js function
   - api/ai/index.py → Python function
6. Deploy to Vercel Edge Network
7. Assign URL: https://your-app-xyz.vercel.app
```

### Continuous Deployment (GitHub Integration)
```
Developer → git push → GitHub → Webhook → Vercel
                                              ↓
                                        Build & Deploy
                                              ↓
                                        Run Tests (optional)
                                              ↓
                                        Deploy to Production
                                              ↓
                                        Notify (Slack, Email, etc.)
```

## 🔧 Serverless Function Lifecycle

```
Request Arrives → Cold Start (if needed) → Initialize Function
                                                   ↓
                                          Load Dependencies
                                                   ↓
                                          Connect to Database
                                                   ↓
                                          Execute Handler
                                                   ↓
                                          Return Response
                                                   ↓
                                          Keep Warm (15 min)
                                                   ↓
                                          Shutdown (if idle)
```

## 📊 Scaling

### Automatic Scaling
```
Low Traffic:    1-2 function instances
Medium Traffic: 5-10 function instances
High Traffic:   50+ function instances (auto-scales)
```

### Geographic Distribution
```
User in US → Vercel Edge (US) → Serverless Function (US)
User in EU → Vercel Edge (EU) → Serverless Function (EU)
User in Asia → Vercel Edge (Asia) → Serverless Function (Asia)
```

## ⚡ Performance Optimizations

### Frontend
- Static file caching (CDN)
- Gzip compression
- Code splitting (Vite)
- Lazy loading
- Image optimization

### Backend
- Database connection pooling
- Response caching
- Efficient queries
- Serverless function warm-up

### Database
- MongoDB Atlas auto-scaling
- Indexed queries
- Connection reuse

## 🔒 Security Layers

```
1. Vercel Edge Network
   - DDoS protection
   - SSL/TLS encryption
   - Rate limiting

2. Application Layer
   - JWT authentication
   - Password hashing (bcrypt)
   - Input validation
   - CORS configuration

3. Database Layer
   - MongoDB Atlas encryption
   - IP whitelisting
   - User authentication
   - Role-based access

4. OAuth Layer
   - Secure token exchange
   - State verification
   - HTTPS only
```

## 📈 Monitoring & Logging

```
Vercel Dashboard:
- Deployment logs
- Function logs
- Analytics
- Performance metrics

MongoDB Atlas:
- Query performance
- Connection metrics
- Storage usage
- Alerts

Application:
- Error tracking (optional: Sentry)
- User analytics (optional: Google Analytics)
- Custom logging
```

## 🌐 URLs & Endpoints

### Production URLs
```
Frontend:     https://your-app.vercel.app
Backend API:  https://your-app.vercel.app/api/*
AI Service:   https://your-app.vercel.app/api/ai/*
Health Check: https://your-app.vercel.app/api/health
```

### API Endpoints
```
Authentication:
- POST /api/auth/register
- POST /api/auth/login
- GET  /api/auth/google
- GET  /api/auth/github
- GET  /api/auth/linkedin

Courses:
- GET  /api/courses
- GET  /api/courses/:id
- POST /api/courses (admin)

AI Services:
- POST /api/ai/recommend
- POST /api/ai/analyze-resume
- POST /api/ai/evaluate-code
- POST /api/ai/chat-mentor

Users:
- GET  /api/users/profile
- PUT  /api/users/profile
- GET  /api/users/progress
```

---

This architecture provides:
✅ Global CDN distribution
✅ Automatic scaling
✅ High availability
✅ Low latency
✅ Cost-effective (pay per use)
✅ Easy deployment
✅ Built-in SSL/HTTPS
✅ Continuous deployment

