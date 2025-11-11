# InturnX Vercel Deployment Guide

## 📋 Prerequisites

1. **Vercel Account**: Sign up at [vercel.com](https://vercel.com)
2. **MongoDB Atlas**: Set up a cloud MongoDB database at [mongodb.com/atlas](https://www.mongodb.com/atlas)
3. **OAuth Credentials**: Set up OAuth apps for Google, GitHub, and LinkedIn
4. **GitHub Repository**: Push your code to GitHub

## 🚀 Deployment Steps

### Option 1: Deploy via Vercel Dashboard (Recommended)

1. **Push to GitHub**:
   ```bash
   git add .
   git commit -m "Prepare for Vercel deployment"
   git push origin main
   ```

2. **Import to Vercel**:
   - Go to [vercel.com/new](https://vercel.com/new)
   - Click "Import Project"
   - Select your GitHub repository
   - Vercel will auto-detect the configuration

3. **Configure Environment Variables**:
   - In Vercel Dashboard, go to Project Settings → Environment Variables
   - Add all variables from `.env.example`
   - See "Environment Variables" section below

4. **Deploy**:
   - Click "Deploy"
   - Wait for the build to complete
   - Your app will be live at `https://your-app.vercel.app`

### Option 2: Deploy via Vercel CLI

1. **Login to Vercel**:
   ```bash
   npx vercel login
   ```

2. **Deploy**:
   ```bash
   # For preview deployment
   npx vercel
   
   # For production deployment
   npx vercel --prod
   ```

3. **Set Environment Variables**:
   ```bash
   npx vercel env add MONGODB_URI
   npx vercel env add JWT_SECRET
   # ... add all other variables
   ```

## 🔐 Environment Variables

### Required Variables

Add these in Vercel Dashboard → Project Settings → Environment Variables:

#### Database
- `MONGODB_URI`: Your MongoDB Atlas connection string
  - Example: `mongodb+srv://username:password@cluster.mongodb.net/inturnx?retryWrites=true&w=majority`

#### Authentication
- `JWT_SECRET`: Random string for JWT signing (generate with `openssl rand -base64 32`)
- `SESSION_SECRET`: Random string for sessions (generate with `openssl rand -base64 32`)

#### URLs
- `CLIENT_URL`: Your Vercel frontend URL (e.g., `https://your-app.vercel.app`)

#### OAuth - Google
- `GOOGLE_CLIENT_ID`: From Google Cloud Console
- `GOOGLE_CLIENT_SECRET`: From Google Cloud Console
- `GOOGLE_CALLBACK_URL`: `https://your-app.vercel.app/api/auth/google/callback`

#### OAuth - GitHub
- `GITHUB_CLIENT_ID`: From GitHub OAuth Apps
- `GITHUB_CLIENT_SECRET`: From GitHub OAuth Apps
- `GITHUB_CALLBACK_URL`: `https://your-app.vercel.app/api/auth/github/callback`

#### OAuth - LinkedIn
- `LINKEDIN_CLIENT_ID`: From LinkedIn Developers
- `LINKEDIN_CLIENT_SECRET`: From LinkedIn Developers
- `LINKEDIN_CALLBACK_URL`: `https://your-app.vercel.app/api/auth/linkedin/callback`

#### AI Services (Optional)
- `OPENAI_API_KEY`: If using OpenAI services

### Setting Up OAuth Apps

#### Google OAuth
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing
3. Enable Google+ API
4. Create OAuth 2.0 credentials
5. Add authorized redirect URI: `https://your-app.vercel.app/api/auth/google/callback`

#### GitHub OAuth
1. Go to [GitHub Settings → Developer Settings → OAuth Apps](https://github.com/settings/developers)
2. Click "New OAuth App"
3. Set Homepage URL: `https://your-app.vercel.app`
4. Set Authorization callback URL: `https://your-app.vercel.app/api/auth/github/callback`

#### LinkedIn OAuth
1. Go to [LinkedIn Developers](https://www.linkedin.com/developers/apps)
2. Create a new app
3. Add redirect URL: `https://your-app.vercel.app/api/auth/linkedin/callback`

## 📦 MongoDB Atlas Setup

1. **Create Cluster**:
   - Go to [MongoDB Atlas](https://www.mongodb.com/atlas)
   - Create a free cluster
   - Choose a cloud provider and region

2. **Configure Network Access**:
   - Go to Network Access
   - Click "Add IP Address"
   - Select "Allow Access from Anywhere" (0.0.0.0/0) for Vercel

3. **Create Database User**:
   - Go to Database Access
   - Add a new database user
   - Save username and password

4. **Get Connection String**:
   - Click "Connect" on your cluster
   - Choose "Connect your application"
   - Copy the connection string
   - Replace `<password>` with your database user password

## ⚠️ Important Notes

### Socket.IO Limitations
Vercel's serverless functions have limitations with WebSocket connections (Socket.IO). For real-time features:
- Consider deploying the backend separately on Railway, Render, or Heroku
- Or use Vercel's Edge Functions with WebSocket support
- Or implement polling as a fallback

### File Uploads
Vercel's serverless functions are stateless. For file uploads:
- Use cloud storage (AWS S3, Cloudinary, etc.)
- Update the multer configuration to use cloud storage
- See `server/middleware/upload.js` for implementation

### Python AI Service
The AI service can be deployed:
1. **On Vercel** (as serverless functions) - Limited by execution time and memory
2. **Separately** on Railway, Render, or AWS Lambda - Recommended for heavy ML models

## 🔍 Troubleshooting

### Build Fails
- Check build logs in Vercel Dashboard
- Ensure all dependencies are in `package.json`
- Verify Node.js version compatibility

### Database Connection Issues
- Verify MongoDB Atlas IP whitelist includes 0.0.0.0/0
- Check connection string format
- Ensure database user has correct permissions

### OAuth Not Working
- Verify callback URLs match exactly
- Check that OAuth apps are approved/published
- Ensure environment variables are set correctly

### API Routes Not Working
- Check that routes start with `/api/`
- Verify `vercel.json` routing configuration
- Check function logs in Vercel Dashboard

## 📊 Monitoring

- **Vercel Analytics**: Enable in Project Settings
- **Function Logs**: View in Vercel Dashboard → Deployments → Function Logs
- **MongoDB Monitoring**: Use MongoDB Atlas monitoring tools

## 🔄 Continuous Deployment

Once connected to GitHub, Vercel automatically:
- Deploys on every push to main branch (production)
- Creates preview deployments for pull requests
- Runs build checks before deployment

## 📚 Additional Resources

- [Vercel Documentation](https://vercel.com/docs)
- [MongoDB Atlas Documentation](https://docs.atlas.mongodb.com/)
- [Next.js + Express on Vercel](https://vercel.com/guides/using-express-with-vercel)

