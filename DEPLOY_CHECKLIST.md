# ✅ InturnX Vercel Deployment Checklist

## Pre-Deployment Setup

### 1. MongoDB Atlas Setup
- [ ] Create account at [mongodb.com/atlas](https://www.mongodb.com/atlas)
- [ ] Create a new cluster (free tier is fine)
- [ ] Create database user with username and password
- [ ] Go to Network Access → Add IP Address → Allow Access from Anywhere (0.0.0.0/0)
- [ ] Get connection string (Connect → Connect your application)
- [ ] Replace `<password>` in connection string with your database password
- [ ] Save connection string for later

### 2. Generate Secrets
Run these commands and save the output:
```bash
# Generate JWT_SECRET
openssl rand -base64 32

# Generate SESSION_SECRET  
openssl rand -base64 32
```

### 3. OAuth Apps Setup (Optional but Recommended)

#### Google OAuth
- [ ] Go to [Google Cloud Console](https://console.cloud.google.com/)
- [ ] Create new project or select existing
- [ ] Enable Google+ API
- [ ] Create OAuth 2.0 credentials
- [ ] Add authorized redirect URI: `https://your-app.vercel.app/api/auth/google/callback`
- [ ] Save Client ID and Client Secret

#### GitHub OAuth
- [ ] Go to [GitHub Settings → Developer Settings → OAuth Apps](https://github.com/settings/developers)
- [ ] Click "New OAuth App"
- [ ] Homepage URL: `https://your-app.vercel.app`
- [ ] Authorization callback URL: `https://your-app.vercel.app/api/auth/github/callback`
- [ ] Save Client ID and Client Secret

#### LinkedIn OAuth
- [ ] Go to [LinkedIn Developers](https://www.linkedin.com/developers/apps)
- [ ] Create new app
- [ ] Add redirect URL: `https://your-app.vercel.app/api/auth/linkedin/callback`
- [ ] Save Client ID and Client Secret

## Deployment

### 4. Deploy to Vercel

Choose ONE method:

#### Method A: Automated Script (Easiest)
```bash
./deploy-to-vercel.sh
```

#### Method B: Manual CLI
```bash
npx vercel login
npx vercel --prod
```

#### Method C: GitHub Integration (Best for CI/CD)
- [ ] Push code to GitHub
- [ ] Go to [vercel.com/new](https://vercel.com/new)
- [ ] Import your repository
- [ ] Click Deploy

### 5. Configure Environment Variables

After deployment, you'll get a URL like: `https://your-app-xyz.vercel.app`

#### Method A: Use the Script
```bash
./setup-env-vercel.sh
```

#### Method B: Vercel Dashboard
- [ ] Go to [vercel.com](https://vercel.com)
- [ ] Select your project
- [ ] Go to Settings → Environment Variables
- [ ] Add each variable below

#### Required Variables (Add these for ALL environments)

```
MONGODB_URI = [your MongoDB connection string from step 1]
JWT_SECRET = [generated secret from step 2]
SESSION_SECRET = [generated secret from step 2]
CLIENT_URL = https://your-app-xyz.vercel.app
NODE_ENV = production
```

#### OAuth Variables (Add if you set up OAuth in step 3)

**Google:**
```
GOOGLE_CLIENT_ID = [from Google Cloud Console]
GOOGLE_CLIENT_SECRET = [from Google Cloud Console]
GOOGLE_CALLBACK_URL = https://your-app-xyz.vercel.app/api/auth/google/callback
```

**GitHub:**
```
GITHUB_CLIENT_ID = [from GitHub OAuth Apps]
GITHUB_CLIENT_SECRET = [from GitHub OAuth Apps]
GITHUB_CALLBACK_URL = https://your-app-xyz.vercel.app/api/auth/github/callback
```

**LinkedIn:**
```
LINKEDIN_CLIENT_ID = [from LinkedIn Developers]
LINKEDIN_CLIENT_SECRET = [from LinkedIn Developers]
LINKEDIN_CALLBACK_URL = https://your-app-xyz.vercel.app/api/auth/linkedin/callback
```

### 6. Update OAuth Callback URLs

Now that you have your Vercel URL, update the OAuth apps:

- [ ] **Google Cloud Console:** Update authorized redirect URI with actual Vercel URL
- [ ] **GitHub OAuth App:** Update authorization callback URL with actual Vercel URL
- [ ] **LinkedIn App:** Update redirect URL with actual Vercel URL

### 7. Redeploy (Important!)

After adding environment variables, redeploy:

```bash
npx vercel --prod
```

Or in Vercel Dashboard:
- [ ] Go to Deployments
- [ ] Click "..." on latest deployment
- [ ] Click "Redeploy"

## Post-Deployment Testing

### 8. Test Your Deployment

- [ ] Visit your Vercel URL: `https://your-app-xyz.vercel.app`
- [ ] Homepage loads correctly
- [ ] Test health endpoint: `https://your-app-xyz.vercel.app/api/health`
- [ ] Try user registration
- [ ] Try user login
- [ ] Test Google OAuth login (if configured)
- [ ] Test GitHub OAuth login (if configured)
- [ ] Test LinkedIn OAuth login (if configured)
- [ ] Browse courses
- [ ] Test any other critical features

### 9. Check Logs

If something doesn't work:
- [ ] Go to Vercel Dashboard → Deployments → [Latest] → Function Logs
- [ ] Look for error messages
- [ ] Check MongoDB Atlas → Metrics for connection attempts

### 10. Monitor

- [ ] Enable Vercel Analytics (Project Settings → Analytics)
- [ ] Set up MongoDB Atlas alerts
- [ ] Bookmark your deployment URL

## Troubleshooting

### If deployment fails:
1. Check build logs in Vercel Dashboard
2. Verify package.json has all dependencies
3. Check vercel.json syntax

### If app loads but features don't work:
1. Verify ALL environment variables are set
2. Check function logs for errors
3. Verify MongoDB connection string is correct
4. Check MongoDB Atlas IP whitelist

### If OAuth doesn't work:
1. Verify callback URLs match EXACTLY
2. Check OAuth app is published/approved
3. Verify environment variables are correct
4. Check CLIENT_URL is set correctly

## Success! 🎉

If all checkboxes are checked and tests pass, you're done!

Your InturnX app is now live at: `https://your-app-xyz.vercel.app`

## Next Steps

- [ ] Set up custom domain (optional)
- [ ] Configure Vercel Analytics
- [ ] Set up error monitoring (Sentry, etc.)
- [ ] Configure CI/CD with GitHub
- [ ] Set up staging environment

---

**Need help?** Check:
- VERCEL_DEPLOYMENT_GUIDE.md - Quick start guide
- DEPLOYMENT.md - Comprehensive guide
- DEPLOYMENT_SUMMARY.md - What was configured

**Still stuck?** Check Vercel function logs and MongoDB Atlas metrics.

