#!/bin/bash

# AI Development Template Setup Script
# This script sets up your development environment for AI-assisted development

set -e  # Exit on any error

echo "🚀 Setting up AI Development Template..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on macOS or Linux
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
    print_status "Detected macOS"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
    print_status "Detected Linux"
else
    print_error "Unsupported operating system: $OSTYPE"
    exit 1
fi

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check for required tools
print_status "Checking for required tools..."

# Check for Python
if command_exists python3; then
    PYTHON_VERSION=$(python3 --version | cut -d' ' -f2)
    print_success "Python $PYTHON_VERSION found"
else
    print_error "Python 3 is required but not installed"
    exit 1
fi

# Check for Node.js
if command_exists node; then
    NODE_VERSION=$(node --version)
    print_success "Node.js $NODE_VERSION found"
else
    print_warning "Node.js not found. Installing via package manager..."
    if [[ "$OS" == "macos" ]]; then
        if command_exists brew; then
            brew install node
        else
            print_error "Homebrew not found. Please install Node.js manually"
            exit 1
        fi
    else
        curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
        sudo apt-get install -y nodejs
    fi
fi

# Check for Docker
if command_exists docker; then
    print_success "Docker found"
else
    print_warning "Docker not found. Please install Docker manually"
    print_status "Visit: https://docs.docker.com/get-docker/"
fi

# Check for Git
if command_exists git; then
    print_success "Git found"
else
    print_error "Git is required but not installed"
    exit 1
fi

# Setup environment file
print_status "Setting up environment configuration..."
if [ ! -f .env ]; then
    cp config/.env.template .env
    print_success "Created .env file from template"
    print_warning "Please edit .env file and add your API keys"
else
    print_warning ".env file already exists, skipping..."
fi

# Install Taskmaster AI
print_status "Installing Taskmaster AI..."
if command_exists npm; then
    npm install -g task-master-ai
    print_success "Taskmaster AI installed globally"
else
    print_error "npm not found. Cannot install Taskmaster AI"
fi

# Setup Python environment
print_status "Setting up Python environment..."

# Check for conda
if command_exists conda; then
    print_status "Conda found, creating environment..."
    
    # Read environment name from .env if it exists
    if [ -f .env ]; then
        ENV_NAME=$(grep CONDA_ENV_NAME .env | cut -d'=' -f2 | tr -d '"' | tr -d "'")
        if [ -z "$ENV_NAME" ]; then
            ENV_NAME="ai-dev-env"
        fi
    else
        ENV_NAME="ai-dev-env"
    fi
    
    # Create conda environment if it doesn't exist
    if ! conda env list | grep -q "^$ENV_NAME "; then
        conda create -n $ENV_NAME python=3.11 -y
        print_success "Created conda environment: $ENV_NAME"
    else
        print_warning "Conda environment $ENV_NAME already exists"
    fi
    
    # Activate environment and install packages
    eval "$(conda shell.bash hook)"
    conda activate $ENV_NAME
    
    # Install common packages
    if [ -f requirements.txt ]; then
        pip install -r requirements.txt
        print_success "Installed Python packages from requirements.txt"
    else
        # Install basic packages
        pip install black flake8 pytest pytest-cov jupyter ipython requests
        print_success "Installed basic Python packages"
    fi
    
else
    print_warning "Conda not found, using system Python with venv..."
    
    # Create virtual environment
    if [ ! -d "venv" ]; then
        python3 -m venv venv
        print_success "Created Python virtual environment"
    fi
    
    # Activate and install packages
    source venv/bin/activate
    pip install --upgrade pip
    
    if [ -f requirements.txt ]; then
        pip install -r requirements.txt
    else
        pip install black flake8 pytest pytest-cov jupyter ipython requests
    fi
    print_success "Installed Python packages"
fi

# Initialize Taskmaster
print_status "Initializing Taskmaster..."
# Always ensure the full directory structure exists, as .taskmaster exists
# in the repo but its subdirectories may not.
# Note: tasks/ subdirectories (todo, in-progress, done) will be created by taskmaster
mkdir -p .taskmaster/{docs,templates}
if [ ! -d ".taskmaster" ]; then
    print_success "Created Taskmaster directory structure"
fi

# Copy PRD template if it doesn't exist
if [ ! -f ".taskmaster/docs/prd.txt" ]; then
    if [ -f ".taskmaster/templates/prd-template.txt" ]; then
        cp .taskmaster/templates/prd-template.txt .taskmaster/docs/prd.txt
        print_success "Created PRD from template"
        print_warning "Please edit .taskmaster/docs/prd.txt with your project details"
    fi
fi

# Setup Docker if available
if command_exists docker; then
    print_status "Setting up Docker configuration..."
    
    # Create basic Dockerfile if it doesn't exist
    if [ ! -f "Dockerfile" ]; then
        cat > Dockerfile << 'EOF'
# Multi-stage build for Python application
FROM python:3.11-slim as base

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Create app directory
WORKDIR /app

# Copy requirements first for better caching
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy application code
COPY . .

# Create non-root user
RUN useradd --create-home --shell /bin/bash app \
    && chown -R app:app /app
USER app

# Expose port
EXPOSE 8000

# Default command
CMD ["python", "app.py"]
EOF
        print_success "Created basic Dockerfile"
    fi
    
    # Create docker-compose.yml if it doesn't exist
    if [ ! -f "docker-compose.yml" ]; then
        cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  app:
    build: .
    ports:
      - "8000:8000"
    environment:
      - NODE_ENV=development
      - PYTHON_ENV=development
    volumes:
      - .:/app
      - /app/node_modules
    env_file:
      - .env
    depends_on:
      - db

  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: devdb
      POSTGRES_USER: devuser
      POSTGRES_PASSWORD: devpass
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

volumes:
  postgres_data:
EOF
        print_success "Created docker-compose.yml"
    fi
fi

# Setup VS Code configuration
print_status "Setting up VS Code configuration..."
if [ ! -f ".vscode/tasks.json" ]; then
    mkdir -p .vscode
    cat > .vscode/tasks.json << 'EOF'
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "Taskmaster: Parse PRD",
            "type": "shell",
            "command": "task-master",
            "args": ["parse-prd", ".taskmaster/docs/prd.txt"],
            "group": "build",
            "presentation": {
                "echo": true,
                "reveal": "always",
                "focus": false,
                "panel": "shared"
            }
        },
        {
            "label": "Taskmaster: Next Task",
            "type": "shell",
            "command": "task-master",
            "args": ["next"],
            "group": "build"
        },
        {
            "label": "Taskmaster: List Tasks",
            "type": "shell",
            "command": "task-master",
            "args": ["list"],
            "group": "build"
        },
        {
            "label": "Python: Run Tests",
            "type": "shell",
            "command": "python",
            "args": ["-m", "pytest"],
            "group": "test"
        },
        {
            "label": "Docker: Build",
            "type": "shell",
            "command": "docker",
            "args": ["build", "-t", "${workspaceFolderBasename}", "."],
            "group": "build"
        },
        {
            "label": "Docker: Run",
            "type": "shell",
            "command": "docker",
            "args": ["run", "-p", "8000:8000", "${workspaceFolderBasename}"],
            "group": "build"
        }
    ]
}
EOF
    print_success "Created VS Code tasks configuration"
fi

# Create basic requirements.txt if it doesn't exist
if [ ! -f "requirements.txt" ]; then
    cat > requirements.txt << 'EOF'
# Core development tools
black==23.12.1
flake8==7.0.0
pytest==7.4.4
pytest-cov==4.1.0

# Common libraries
requests==2.31.0
python-dotenv==1.0.0

# AI/ML libraries (uncomment as needed)
# openai==1.6.1
# anthropic==0.8.1
# google-generativeai==0.3.2

# Web development (uncomment as needed)
# fastapi==0.108.0
# uvicorn==0.25.0
# flask==3.0.0

# Data science (uncomment as needed)
# pandas==2.1.4
# numpy==1.26.2
# matplotlib==3.8.2
# jupyter==1.0.0
EOF
    print_success "Created requirements.txt"
fi

# Final setup steps
print_status "Finalizing setup..."

# Create basic .gitignore additions
if ! grep -q "# AI Development Template" .gitignore 2>/dev/null; then
    cat >> .gitignore << 'EOF'

# AI Development Template
.env
.env.local
usage-data/
.ai-cache/
.taskmaster/tasks/
EOF
    print_success "Updated .gitignore"
fi

# Create usage tracking directory
mkdir -p usage-data
echo '{"monthly_usage": 0, "last_reset": "'$(date -u +%Y-%m-%d)'"}' > usage-data/monthly-usage.json
print_success "Created usage tracking"

print_success "🎉 Setup complete!"
echo ""
print_status "Next steps:"
echo "1. Edit .env file and add your API keys"
echo "2. Edit .taskmaster/docs/prd.txt with your project details"
echo "3. Run: task-master parse-prd .taskmaster/docs/prd.txt"
echo "4. Run: task-master next"
echo "5. Start coding with AI assistance!"
echo ""
print_status "For ADHD-friendly development:"
echo "- Use 'Ctrl+Shift+P' in VS Code and search for 'Tasks: Run Task'"
echo "- Set up Pomodoro timer (25min work, 5min break)"
echo "- Keep tasks small and focused"
echo "- Celebrate small wins! 🎉"

