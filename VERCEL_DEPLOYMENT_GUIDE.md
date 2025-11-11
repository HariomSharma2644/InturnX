# 🚀 Quick Vercel Deployment Guide for InturnX

## ⚡ Quick Start (3 Steps)

### Step 1: Prepare Your Environment
```bash
# Make sure you have all dependencies
npm run install:all
```

### Step 2: Deploy to Vercel
```bash
# Run the deployment script
./deploy-to-vercel.sh

# Or manually:
npx vercel login
npx vercel --prod
```

### Step 3: Set Up Environment Variables
```bash
# Run the environment setup script
./setup-env-vercel.sh

# Or manually in Vercel Dashboard:
# Go to Project Settings → Environment Variables
```

## 📋 What's Been Configured

### ✅ Files Created
- `vercel.json` - Vercel deployment configuration
- `.vercelignore` - Files to exclude from deployment
- `server/api/index.js` - Serverless function entry point
- `api/ai/index.py` - Python AI service wrapper
- `.env.example` - Environment variables template
- `DEPLOYMENT.md` - Detailed deployment guide
- `deploy-to-vercel.sh` - Automated deployment script
- `setup-env-vercel.sh` - Environment variables setup script

### ✅ Package Updates
- Added Vercel CLI to devDependencies
- Added deployment scripts to package.json
- Added concurrently for running multiple services

## 🔑 Required Environment Variables

You MUST set these in Vercel Dashboard before your app will work:

### Essential (Required)
```
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/inturnx
JWT_SECRET=your-random-secret-here
SESSION_SECRET=your-random-secret-here
CLIENT_URL=https://your-app.vercel.app
```

### OAuth (Optional but recommended)
```
GOOGLE_CLIENT_ID=your-google-client-id
GOOGLE_CLIENT_SECRET=your-google-client-secret
GOOGLE_CALLBACK_URL=https://your-app.vercel.app/api/auth/google/callback

GITHUB_CLIENT_ID=your-github-client-id
GITHUB_CLIENT_SECRET=your-github-client-secret
GITHUB_CALLBACK_URL=https://your-app.vercel.app/api/auth/github/callback

LINKEDIN_CLIENT_ID=your-linkedin-client-id
LINKEDIN_CLIENT_SECRET=your-linkedin-client-secret
LINKEDIN_CALLBACK_URL=https://your-app.vercel.app/api/auth/linkedin/callback
```

### AI Services (Optional)
```
OPENAI_API_KEY=your-openai-api-key
```

## 🎯 Deployment Options

### Option A: GitHub Integration (Easiest - Recommended)
1. Push your code to GitHub
2. Go to [vercel.com/new](https://vercel.com/new)
3. Import your repository
4. Vercel auto-detects configuration
5. Add environment variables
6. Deploy!

**Benefits:**
- Automatic deployments on git push
- Preview deployments for PRs
- Easy rollbacks

### Option B: Vercel CLI (Fastest)
```bash
# Login
npx vercel login

# Deploy preview
npx vercel

# Deploy production
npx vercel --prod
```

### Option C: Use Our Script (Guided)
```bash
./deploy-to-vercel.sh
```

## 📊 Project Structure for Vercel

```
inturnx/
├── client/              # React frontend (Vite)
│   ├── dist/           # Build output (auto-generated)
│   └── package.json
├── server/             # Express backend
│   ├── api/
│   │   └── index.js   # Vercel serverless entry point
│   └── package.json
├── api/                # Vercel serverless functions
│   └── ai/
│       └── index.py   # Python AI service
├── vercel.json        # Vercel configuration
└── package.json       # Root package.json
```

## ⚠️ Important Considerations

### 1. Socket.IO Limitations
Vercel's serverless functions don't support persistent WebSocket connections well.

**Solutions:**
- Deploy backend separately on Railway/Render for Socket.IO
- Use Vercel Edge Functions with WebSocket support
- Implement polling as fallback

### 2. File Uploads
Vercel functions are stateless - files don't persist.

**Solutions:**
- Use AWS S3, Cloudinary, or similar
- Update multer config to use cloud storage

### 3. Python AI Service
Heavy ML models may exceed Vercel's limits.

**Solutions:**
- Deploy AI service separately on Railway/Render
- Use lighter models
- Implement caching

### 4. MongoDB Atlas
You MUST use MongoDB Atlas (cloud) - local MongoDB won't work.

**Setup:**
1. Create free cluster at [mongodb.com/atlas](https://www.mongodb.com/atlas)
2. Whitelist IP: 0.0.0.0/0 (allow all - required for Vercel)
3. Get connection string
4. Add to Vercel environment variables

## 🔍 Testing Your Deployment

### 1. Check Health Endpoints
```bash
# Backend health
curl https://your-app.vercel.app/api/health

# AI service health (if deployed)
curl https://your-app.vercel.app/api/ai/health
```

### 2. Check Logs
- Go to Vercel Dashboard
- Select your project
- Click "Deployments"
- Click on latest deployment
- View "Function Logs"

### 3. Test Features
- [ ] Homepage loads
- [ ] User registration/login works
- [ ] OAuth login works
- [ ] API endpoints respond
- [ ] Database operations work

## 🐛 Troubleshooting

### Build Fails
```bash
# Check build logs in Vercel Dashboard
# Common issues:
# - Missing dependencies
# - Environment variables not set
# - Build script errors
```

### Database Connection Fails
```bash
# Verify:
# 1. MongoDB Atlas IP whitelist includes 0.0.0.0/0
# 2. Connection string is correct
# 3. Database user has permissions
# 4. MONGODB_URI is set in Vercel
```

### OAuth Not Working
```bash
# Verify:
# 1. Callback URLs match exactly
# 2. OAuth apps are published/approved
# 3. Environment variables are set
# 4. CLIENT_URL is correct
```

### Functions Timeout
```bash
# Vercel limits:
# - Hobby: 10s execution time
# - Pro: 60s execution time
# 
# Solutions:
# - Optimize slow operations
# - Use background jobs
# - Deploy heavy operations separately
```

## 📚 Additional Resources

- [Full Deployment Guide](./DEPLOYMENT.md)
- [Vercel Documentation](https://vercel.com/docs)
- [MongoDB Atlas Setup](https://docs.atlas.mongodb.com/)
- [Environment Variables Template](./.env.example)

## 🆘 Need Help?

1. Check [DEPLOYMENT.md](./DEPLOYMENT.md) for detailed instructions
2. View Vercel function logs for errors
3. Check MongoDB Atlas monitoring
4. Review OAuth app configurations

## ✅ Deployment Checklist

- [ ] Code pushed to GitHub
- [ ] MongoDB Atlas cluster created
- [ ] MongoDB IP whitelist configured (0.0.0.0/0)
- [ ] Vercel project created
- [ ] Environment variables set in Vercel
- [ ] OAuth apps configured (if using)
- [ ] OAuth callback URLs updated
- [ ] Deployment successful
- [ ] Health endpoints responding
- [ ] Features tested and working

---

**Ready to deploy?** Run `./deploy-to-vercel.sh` to get started! 🚀

