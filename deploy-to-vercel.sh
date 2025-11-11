#!/bin/bash

# InturnX Vercel Deployment Script
# This script helps you deploy InturnX to Vercel

echo "🚀 InturnX Vercel Deployment Script"
echo "===================================="
echo ""

# Check if Vercel CLI is available
if ! command -v vercel &> /dev/null && ! npx vercel --version &> /dev/null; then
    echo "❌ Vercel CLI not found. Installing..."
    npm install -g vercel || npm install vercel --save-dev
fi

echo "✅ Vercel CLI is available"
echo ""

# Check if user is logged in
echo "📝 Checking Vercel authentication..."
if ! npx vercel whoami &> /dev/null; then
    echo "🔐 Please log in to Vercel:"
    npx vercel login
else
    echo "✅ Already logged in to Vercel"
fi
echo ""

# Ask deployment type
echo "Select deployment type:"
echo "1) Preview deployment (for testing)"
echo "2) Production deployment"
read -p "Enter choice (1 or 2): " deploy_type

echo ""
echo "📦 Starting deployment..."
echo ""

if [ "$deploy_type" = "2" ]; then
    echo "🚀 Deploying to PRODUCTION..."
    npx vercel --prod
else
    echo "🔍 Creating PREVIEW deployment..."
    npx vercel
fi

echo ""
echo "✅ Deployment complete!"
echo ""
echo "📋 Next steps:"
echo "1. Set up environment variables in Vercel Dashboard"
echo "2. Configure OAuth callback URLs"
echo "3. Set up MongoDB Atlas"
echo ""
echo "📖 See DEPLOYMENT.md for detailed instructions"

