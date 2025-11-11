#!/bin/bash

# InturnX Vercel Environment Variables Setup Script
# This script helps you set up environment variables in Vercel

echo "🔐 InturnX Vercel Environment Variables Setup"
echo "=============================================="
echo ""
echo "This script will help you add environment variables to your Vercel project."
echo "You'll need to have the values ready."
echo ""

# Check if Vercel CLI is available
if ! command -v vercel &> /dev/null && ! npx vercel --version &> /dev/null; then
    echo "❌ Vercel CLI not found. Please run deploy-to-vercel.sh first."
    exit 1
fi

echo "Select environment:"
echo "1) Production only"
echo "2) Preview only"
echo "3) Development only"
echo "4) All environments (production, preview, development)"
read -p "Enter choice (1-4): " env_choice

case $env_choice in
    1) ENV_FLAG="production" ;;
    2) ENV_FLAG="preview" ;;
    3) ENV_FLAG="development" ;;
    4) ENV_FLAG="production,preview,development" ;;
    *) echo "Invalid choice"; exit 1 ;;
esac

echo ""
echo "Adding environment variables for: $ENV_FLAG"
echo ""

# Function to add environment variable
add_env_var() {
    local var_name=$1
    local var_description=$2
    
    read -p "Enter $var_description ($var_name): " var_value
    
    if [ -n "$var_value" ]; then
        echo "$var_value" | npx vercel env add "$var_name" "$ENV_FLAG"
        echo "✅ Added $var_name"
    else
        echo "⏭️  Skipped $var_name"
    fi
    echo ""
}

echo "📝 Required Environment Variables"
echo "=================================="
echo ""

# Database
add_env_var "MONGODB_URI" "MongoDB connection string"

# JWT & Session
add_env_var "JWT_SECRET" "JWT secret (random string)"
add_env_var "SESSION_SECRET" "Session secret (random string)"

# URLs
add_env_var "CLIENT_URL" "Frontend URL (e.g., https://your-app.vercel.app)"

echo ""
echo "📝 OAuth Configuration (Optional - press Enter to skip)"
echo "========================================================"
echo ""

# Google OAuth
read -p "Configure Google OAuth? (y/n): " config_google
if [ "$config_google" = "y" ]; then
    add_env_var "GOOGLE_CLIENT_ID" "Google Client ID"
    add_env_var "GOOGLE_CLIENT_SECRET" "Google Client Secret"
    add_env_var "GOOGLE_CALLBACK_URL" "Google Callback URL"
fi

# GitHub OAuth
read -p "Configure GitHub OAuth? (y/n): " config_github
if [ "$config_github" = "y" ]; then
    add_env_var "GITHUB_CLIENT_ID" "GitHub Client ID"
    add_env_var "GITHUB_CLIENT_SECRET" "GitHub Client Secret"
    add_env_var "GITHUB_CALLBACK_URL" "GitHub Callback URL"
fi

# LinkedIn OAuth
read -p "Configure LinkedIn OAuth? (y/n): " config_linkedin
if [ "$config_linkedin" = "y" ]; then
    add_env_var "LINKEDIN_CLIENT_ID" "LinkedIn Client ID"
    add_env_var "LINKEDIN_CLIENT_SECRET" "LinkedIn Client Secret"
    add_env_var "LINKEDIN_CALLBACK_URL" "LinkedIn Callback URL"
fi

echo ""
echo "📝 AI Service Configuration (Optional)"
echo "======================================"
echo ""

read -p "Configure OpenAI? (y/n): " config_openai
if [ "$config_openai" = "y" ]; then
    add_env_var "OPENAI_API_KEY" "OpenAI API Key"
fi

echo ""
echo "✅ Environment variables setup complete!"
echo ""
echo "📋 To view your environment variables:"
echo "   npx vercel env ls"
echo ""
echo "📋 To remove an environment variable:"
echo "   npx vercel env rm <variable-name>"
echo ""

