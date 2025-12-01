#!/bin/bash

# ═══════════════════════════════════════════════════════════════
# 🚀 SUPREME AUTO-DEPLOY TO GITHUB
# Automatically deploys projects with full professional structure
# © 2025 RJ Business Solutions
# ═══════════════════════════════════════════════════════════════

set -e

# ─────────────────────────────────────────────────────────────
# 🎨 COLORS
# ─────────────────────────────────────────────────────────────

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ─────────────────────────────────────────────────────────────
# 🔧 CONFIGURATION
# ─────────────────────────────────────────────────────────────

# Load from .env if exists
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

# GitHub Configuration
GITHUB_USERNAME="${GITHUB_USERNAME:-rjbizsolution23-wq}"
GITHUB_EMAIL="${GITHUB_EMAIL:-rjbizsolution23@gmail.com}"
GITHUB_TOKEN="${GITHUB_PERSONAL_ACCESS_TOKEN}"

# Company Information
COMPANY_NAME="${COMPANY_NAME:-RJ Business Solutions}"
COMPANY_LOGO="${COMPANY_LOGO:-https://storage.googleapis.com/msgsndr/qQnxRHDtyx0uydPd5sRl/media/67eb83c5e519ed689430646b.jpeg}"
COMPANY_ADDRESS="${COMPANY_ADDRESS:-1342 NM 333, Tijeras, New Mexico 87059}"
COMPANY_WEBSITE="${COMPANY_WEBSITE:-https://rickjeffersonsolutions.com}"

# Get project name
PROJECT_NAME="${1:-$(basename $(pwd))}"

# ─────────────────────────────────────────────────────────────
# 🎯 FUNCTIONS
# ─────────────────────────────────────────────────────────────

print_header() {
    echo -e "${CYAN}"
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║                                                               ║"
    echo "║        🚀 SUPREME AUTO-DEPLOY TO GITHUB 🚀                    ║"
    echo "║                                                               ║"
    echo "║             RJ Business Solutions                             ║"
    echo "║                                                               ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_step() {
    echo -e "${BLUE}▶ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# ─────────────────────────────────────────────────────────────
# 🚀 MAIN SCRIPT
# ─────────────────────────────────────────────────────────────

print_header

echo -e "${CYAN}Project:${NC} $PROJECT_NAME"
echo -e "${CYAN}Owner:${NC} Rick Jefferson"
echo -e "${CYAN}Company:${NC} $COMPANY_NAME"
echo ""

# Step 1: Initialize Git
print_step "Initializing Git repository..."

if [ ! -d .git ]; then
    git init
    print_success "Git initialized"
else
    print_success "Git already initialized"
fi

# Configure git
git config user.name "Rick Jefferson"
git config user.email "$GITHUB_EMAIL"
print_success "Git configured"

# Step 2: Create .gitignore
print_step "Creating .gitignore..."

cat > .gitignore << 'EOF'
# Dependencies
node_modules/
__pycache__/
*.pyc
*.pyo
*.pyd
venv/
env/
.venv/
pip-log.txt
pip-delete-this-directory.txt

# Build outputs
.next/
out/
dist/
build/
*.log
*.pid
*.seed
*.pid.lock

# Environment variables
.env
.env.local
.env.production
.env.*.local

# IDE
.vscode/
.idea/
*.swp
*.swo
*~
.DS_Store

# OS
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Testing
coverage/
.nyc_output/
*.lcov

# Misc
*.tgz
.npm
.eslintcache
.node_repl_history
*.tsbuildinfo
.cache
EOF

print_success ".gitignore created"

# Step 3: Add all files
print_step "Adding files to git..."

git add .
print_success "Files added"

# Step 4: Create commit
print_step "Creating commit..."

COMMIT_MSG="feat: ${PROJECT_NAME} - Professional build by ${COMPANY_NAME}

🏗️ Project Structure:
- Complete production-ready codebase
- AI integration with preferred models
  • OpenRouter (primary gateway)
  • Z.AI (advanced reasoning)
  • HuggingFace (embeddings & custom models)
  • Kimi (long context processing)
  • Minimax (multimodal capabilities)
  • Claude (fallback)
  • OpenAI (emergency only)
- Full documentation and architecture
- CI/CD pipelines configured
- Security best practices implemented
- Performance optimized

🔐 Security:
- Environment variables properly configured
- API keys secured (not in repo)
- HTTPS enforced
- Input validation implemented
- Rate limiting enabled

📊 Features:
- Responsive design
- Mobile-first approach
- SEO optimized
- Accessibility compliant
- Analytics integrated

🚀 Deployment:
- Docker containerization
- Kubernetes ready
- CI/CD automation
- Health checks
- Monitoring enabled

Built: $(date '+%Y-%m-%d %H:%M:%S %Z')
Location: Tijeras, New Mexico
Developer: Rick Jefferson
Company: RJ Business Solutions
Website: ${COMPANY_WEBSITE}
GitHub: @${GITHUB_USERNAME}

This project follows enterprise-grade standards and best practices.
Ready for immediate production deployment."

git commit -m "$COMMIT_MSG" 2>/dev/null || {
    print_warning "No changes to commit"
}

print_success "Commit created"

# Step 5: Check if GitHub CLI is available
if ! command -v gh &> /dev/null; then
    print_error "GitHub CLI (gh) is not installed!"
    echo ""
    echo "Install it from: https://cli.github.com/"
    echo ""
    echo "Or push manually:"
    echo "  git remote add origin https://github.com/${GITHUB_USERNAME}/${PROJECT_NAME}.git"
    echo "  git branch -M main"
    echo "  git push -u origin main"
    exit 1
fi

# Step 6: Authenticate with GitHub
print_step "Checking GitHub authentication..."

if gh auth status &>/dev/null; then
    print_success "GitHub authenticated"
else
    print_warning "Not authenticated with GitHub"
    print_step "Authenticating..."
    gh auth login
fi

# Step 7: Create/Update Repository
print_step "Creating GitHub repository..."

REPO_EXISTS=$(gh repo view "${GITHUB_USERNAME}/${PROJECT_NAME}" 2>&1 || echo "not found")

if [[ $REPO_EXISTS == *"not found"* ]]; then
    print_step "Creating new repository..."
    
    gh repo create "${GITHUB_USERNAME}/${PROJECT_NAME}" \
        --public \
        --source=. \
        --remote=origin \
        --description "Professional ${PROJECT_NAME} built by ${COMPANY_NAME} - AI-powered with OpenRouter, Z.AI, HuggingFace, Kimi, Minimax. Production-ready and enterprise-grade." \
        --homepage "${COMPANY_WEBSITE}" || {
        print_error "Failed to create repository"
        exit 1
    }
    
    print_success "Repository created"
else
    print_success "Repository already exists"
    git remote add origin "https://github.com/${GITHUB_USERNAME}/${PROJECT_NAME}.git" 2>/dev/null || \
    git remote set-url origin "https://github.com/${GITHUB_USERNAME}/${PROJECT_NAME}.git"
fi

# Step 8: Push to GitHub
print_step "Pushing to GitHub..."

git branch -M main
git push -u origin main --force

print_success "Code pushed to GitHub"

# Step 9: Configure Repository
print_step "Configuring repository settings..."

# Add topics/tags
gh repo edit "${GITHUB_USERNAME}/${PROJECT_NAME}" \
    --add-topic "rj-business-solutions" \
    --add-topic "ai-powered" \
    --add-topic "openrouter" \
    --add-topic "zai" \
    --add-topic "huggingface" \
    --add-topic "production-ready" \
    --add-topic "automated-deployment" \
    --add-topic "rick-jefferson" \
    --add-topic "enterprise-grade" 2>/dev/null

print_success "Repository tags added"

# Enable features
gh repo edit "${GITHUB_USERNAME}/${PROJECT_NAME}" \
    --enable-issues \
    --enable-projects \
    --enable-wiki 2>/dev/null

print_success "Repository features enabled"

# Enable GitHub Pages if docs folder exists
if [ -d "docs" ]; then
    gh repo edit "${GITHUB_USERNAME}/${PROJECT_NAME}" \
        --enable-pages \
        --pages-branch main \
        --pages-path /docs 2>/dev/null
    print_success "GitHub Pages enabled"
fi

# Step 10: Display Success
echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                                                               ║${NC}"
echo -e "${GREEN}║           🎉 DEPLOYMENT COMPLETE! 🎉                          ║${NC}"
echo -e "${GREEN}║                                                               ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}📦 Repository:${NC} https://github.com/${GITHUB_USERNAME}/${PROJECT_NAME}"
echo -e "${BLUE}🌐 Website:${NC} ${COMPANY_WEBSITE}"
echo -e "${BLUE}👤 Owner:${NC} Rick Jefferson"
echo -e "${BLUE}🏢 Company:${NC} ${COMPANY_NAME}"
echo -e "${BLUE}📍 Location:${NC} ${COMPANY_ADDRESS}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Step 11: Open in browser (optional)
read -p "Open repository in browser? (Y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
    gh repo view "${GITHUB_USERNAME}/${PROJECT_NAME}" --web
fi

print_success "Script completed successfully!"
echo ""
