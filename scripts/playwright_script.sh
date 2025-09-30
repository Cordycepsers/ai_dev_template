#!/bin/bash

# Playwright Node.js Development Template Setup Script
# This script sets up your development environment for Playwright with Node.js on macOS

set -e  # Exit on any error

echo "🚀 Setting up Playwright with Node.js Development Environment on macOS..."

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

# Check if running on macOS
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
    print_status "Detected macOS"
else
    print_error "This script is intended for macOS: $OSTYPE"
    exit 1
fi

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check for required tools
print_status "Checking for required tools..."

# Check for Node.js [[10]]
if command_exists node; then
    NODE_VERSION=$(node --version)
    NODE_MAJOR=$(echo "$NODE_VERSION" | cut -d'.' -f1 | sed 's/v//')
    if [[ $NODE_MAJOR -ge 18 ]]; then # Check for 18+ as Playwright docs suggest 10.17+ but Node LTS is recommended [[7]]
        print_success "Node.js $NODE_VERSION found (LTS recommended)"
    else
        print_warning "Node.js $NODE_VERSION found, but LTS version is recommended for Playwright [[4]]"
    fi
else
    print_error "Node.js is required but not installed [[8]]. Attempting to install via Homebrew..."
    if command_exists brew; then
        brew install node
        print_success "Node.js installed via Homebrew"
    else
        print_error "Homebrew not found. Please install Node.js manually from https://nodejs.org/ or install Homebrew first."
        exit 1
    fi
fi

# Check for npm (usually comes with Node.js)
if command_exists npm; then
    NPM_VERSION=$(npm --version)
    print_success "npm $NPM_VERSION found"
else
    print_error "npm is required but not installed. This is unexpected if Node.js was installed correctly."
    exit 1
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

# Create a new project directory if it doesn't exist, or use current one if empty
PROJECT_DIR=${1:-"playwright-project"}
if [ -d "$PROJECT_DIR" ] && [ "$(ls -A $PROJECT_DIR)" ]; then
    print_warning "Directory $PROJECT_DIR already exists and is not empty. Using current directory for setup."
    PROJECT_DIR="."
else
    if [ "$PROJECT_DIR" != "." ]; then
        mkdir -p "$PROJECT_DIR"
        cd "$PROJECT_DIR"
        print_success "Created and navigated to project directory: $PROJECT_DIR"
    else
        print_status "Using current directory for setup."
    fi
fi

# Initialize a new Node.js project if package.json doesn't exist
if [ ! -f "package.json" ]; then
    print_status "Initializing new Node.js project..."
    npm init -y
    print_success "Initialized new Node.js project (package.json created)"
else
    print_warning "package.json already exists, skipping npm init."
fi

# Install Playwright [[10]]
print_status "Installing Playwright Test for Node.js..."
npm install --save-dev @playwright/test
print_success "Playwright Test installed"

# Install Playwright Browsers [[10]]
print_status "Installing Playwright browser binaries (Chromium, Firefox, WebKit)..."
npx playwright install
print_success "Playwright browser binaries installed"

# Install Playwright Codegen (optional, often included with @playwright/test)
print_status "Installing Playwright CLI tools..."
# The core installation via npm install @playwright/test usually includes the CLI tools like 'codegen'.
# Verify if codegen command is available within the project context after installation.
if npx playwright --help >/dev/null 2>&1; then
    print_success "Playwright CLI tools available."
else
    # Fallback: explicitly install if needed (usually not necessary)
    print_warning "Playwright CLI tools might need explicit installation (this is unusual)."
    # npm install --save-dev playwright-core # This is usually not needed alongside @playwright/test
fi

# Create a basic test example directory if it doesn't exist
TEST_DIR="tests"
mkdir -p "$TEST_DIR"
print_status "Created test directory: $TEST_DIR"

# Create a basic Playwright config file if it doesn't exist
CONFIG_FILE="playwright.config.js"
if [ ! -f "$CONFIG_FILE" ]; then
    cat > "$CONFIG_FILE" << 'EOF'
// @ts-check
const { defineConfig, devices } = require('@playwright/test');

module.exports = defineConfig({
  testDir: './tests', // Adjust if your tests are in a different folder
  /* Run tests in files in parallel */
  fullyParallel: true,
  /* Fail the build on CI if you accidentally left test.only in the source code. */
  forbidOnly: !!process.env.CI,
  /* Retry on CI only */
  retries: process.env.CI ? 2 : 0,
  /* Opt out of parallel tests on CI. */
  workers: process.env.CI ? 1 : undefined,
  /* Reporter to use. See https://playwright.dev/docs/test-reporters */
  reporter: 'html',
  /* Shared settings for all the projects below. See https://playwright.dev/docs/api/class-testoptions. */
  use: {
    /* Base URL to use in actions like \`await page.goto('/')\`. */
    // baseURL: 'http://127.0.0.1:3000',

    /* Collect trace when retrying the failed test. See https://playwright.dev/docs/trace-viewer */
    trace: 'on-first-retry',
  },

  /* Configure projects for major browsers */
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },

    {
      name: 'firefox',
      use: { ...devices['Desktop Firefox'] },
    },

    {
      name: 'webkit',
      use: { ...devices['Desktop Safari'] },
    },

    /* Test against mobile viewports. */
    // {
    //   name: 'Mobile Chrome',
    //   use: { ...devices['Pixel 5'] },
    // },
    // {
    //   name: 'Mobile Safari',
    //   use: { ...devices['iPhone 12'] },
    // },

    /* Test against branded browsers. */
    // {
    //   name: 'Microsoft Edge',
    //   use: { ...devices['Desktop Edge'], channel: 'msedge' },
    // },
    // {
    //   name: 'Google Chrome',
    //   use: { ...devices['Desktop Chrome'], channel: 'chrome' },
    // },
  ],

  /* Run your local dev server before starting the tests */
  // webServer: {
  //   command: 'npm run start',
  //   url: 'http://127.0.0.1:3000',
  //   reuseExistingServer: !process.env.CI,
  // },
});
EOF
    print_success "Created basic Playwright configuration: $CONFIG_FILE"
else
    print_warning "$CONFIG_FILE already exists, skipping creation."
fi

# Create a basic example test file if it doesn't exist
EXAMPLE_TEST_FILE="$TEST_DIR/example.spec.js"
if [ ! -f "$EXAMPLE_TEST_FILE" ]; then
    cat > "$EXAMPLE_TEST_FILE" << 'EOF'
const { test, expect } = require('@playwright/test');

test('has title', async ({ page }) => {
  await page.goto('https://playwright.dev/');

  // Expect a title "to contain" a substring.
  await expect(page).toHaveTitle(/Playwright/);
});

test('get started link', async ({ page }) => {
  await page.goto('https://playwright.dev/');

  // Click the get started link.
  await page.getByRole('link', { name: 'Get started' }).click();

  // Expects page to have a heading with the name of Installation.
  await expect(page.getByRole('heading', { name: 'Installation' })).toBeVisible();
});
EOF
    print_success "Created example test file: $EXAMPLE_TEST_FILE"
else
    print_warning "$EXAMPLE_TEST_FILE already exists, skipping creation."
fi

# Add useful scripts to package.json
print_status "Adding useful scripts to package.json..."
# Use npm to add scripts, or manually edit package.json if npm run-script isn't sufficient for adding multiple at once
# We'll manually edit the JSON for simplicity here, ensuring valid JSON structure.
if [ -f "package.json" ]; then
    # Define the scripts section to add
    NEW_SCRIPTS='{
      "test": "npx playwright test",
      "test:debug": "PWDEBUG=1 npx playwright test",
      "test:ui": "npx playwright test --ui",
      "test:report": "npx playwright show-report",
      "codegen": "npx playwright codegen"
    }'

    # Read current package.json, modify scripts, and write back
    # This is a simple replacement using sed, which might be fragile for complex JSON.
    # A more robust method would require a JSON-aware tool like jq if available.
    if command_exists jq; then
        # Use jq if available for safe JSON manipulation
        jq --argjson newScripts "$NEW_SCRIPTS" '.scripts = (.scripts // {}) + $newScripts' package.json > package.json.tmp && mv package.json.tmp package.json
    else
        # Fallback: use sed to insert/replace the scripts section.
        # This assumes a specific format for package.json and might not work perfectly if scripts already exist in a different format.
        # A more robust script would check if scripts exist and merge them.
        if grep -q '"scripts"' package.json; then
            print_warning "Scripts section found in package.json, skipping automatic script addition. Please add scripts manually."
        else
            # Find the end of the "main" or "description" line and insert the scripts block before the closing brace
            sed -i.bak '/},/i\
  "scripts": '"$NEW_SCRIPTS"',
' package.json 2>/dev/null || sed -i '' '/},/i\
  "scripts": '"$NEW_SCRIPTS"',
' package.json # Try both sed syntaxes for macOS compatibility
            if [ $? -eq 0 ]; then
               print_success "Added scripts to package.json"
            else
               print_warning "Failed to automatically add scripts to package.json. Please add them manually."
            fi
        fi
    fi
    print_success "Added useful scripts to package.json (check the file to confirm)"
else
    print_error "package.json not found, cannot add scripts automatically."
fi

# Setup VS Code configuration (tasks and launch)
print_status "Setting up VS Code configuration (tasks, launch, settings)..."
VSCODE_DIR=".vscode"
mkdir -p "$VSCODE_DIR"

# tasks.json for VS Code
TASKS_FILE="$VSCODE_DIR/tasks.json"
cat > "$TASKS_FILE" << 'EOF'
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "Playwright: Install Browsers",
            "type": "shell",
            "command": "npx",
            "args": ["playwright", "install"],
            "group": "build",
            "presentation": {
                "echo": true,
                "reveal": "always",
                "focus": false,
                "panel": "shared"
            }
        },
        {
            "label": "Playwright: Run All Tests",
            "type": "shell",
            "command": "npm",
            "args": ["run", "test"],
            "group": "test",
            "presentation": {
                "echo": true,
                "reveal": "always",
                "focus": false,
                "panel": "shared"
            }
        },
        {
            "label": "Playwright: Run Tests in UI Mode",
            "type": "shell",
            "command": "npm",
            "args": ["run", "test:ui"],
            "group": "test"
        },
        {
            "label": "Playwright: Run Tests in Debug Mode",
            "type": "shell",
            "command": "npm",
            "args": ["run", "test:debug"],
            "group": "test"
        },
        {
            "label": "Playwright: Open Trace Viewer",
            "type": "shell",
            "command": "npx",
            "args": ["playwright", "show-trace"],
            "group": "test"
        },
        {
            "label": "Playwright: Open HTML Report",
            "type": "shell",
            "command": "npm",
            "args": ["run", "test:report"],
            "group": "test"
        }
    ]
}
EOF
print_success "Created VS Code tasks configuration: $TASKS_FILE"

# launch.json for VS Code debugging
LAUNCH_FILE="$VSCODE_DIR/launch.json"
cat > "$LAUNCH_FILE" << 'EOF'
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Playwright: Debug Current Test",
            "type": "node",
            "request": "launch",
            "program": "${workspaceFolder}/node_modules/.bin/playwright",
            "args": [
                "test",
                "${relativeFile}",
                "--project=chromium",
                "--headed", // Run in headed mode for debugging
                "--debug" // Stop on first error or failure
            ],
            "console": "integratedTerminal",
            "cwd": "${workspaceFolder}",
            "env": {
                "PWDEBUG": "1" // Enables debug mode features
            },
            "outputCapture": "std",
            "preLaunchTask": "Playwright: Install Browsers" // Optional: ensure browsers are installed
        },
         {
            "name": "Playwright: Debug Specific Test File",
            "type": "node",
            "request": "launch",
            "program": "${workspaceFolder}/node_modules/.bin/playwright",
            "args": [
                "test",
                "${input:testFile}", // Uses input variable defined below
                "--project=chromium",
                "--headed",
                "--debug"
            ],
            "console": "integratedTerminal",
            "cwd": "${workspaceFolder}",
            "env": {
                "PWDEBUG": "1"
            },
            "outputCapture": "std"
        }
    ],
    "inputs": [
        {
            "id": "testFile",
            "type": "promptString",
            "description": "Path to the test file (e.g., tests/example.spec.js)"
        }
    ]
}
EOF
print_success "Created VS Code launch configuration: $LAUNCH_FILE"

# settings.json for VS Code (optional, can include Playwright-specific settings)
SETTINGS_FILE="$VSCODE_DIR/settings.json"
cat > "$SETTINGS_FILE" << 'EOF'
{
    "editor.formatOnSave": true,
    "editor.defaultFormatter": "esbenp.prettier-vscode",
    "prettier.configPath": "./.prettierrc"
}
EOF
print_success "Created VS Code settings: $SETTINGS_FILE"

# Suggest installing VS Code extensions
print_status "Suggested VS Code Extensions:"
echo "1.  JavaScript (ES6) code snippets (esbenp.prettier-vscode) - for formatting"
echo "2.  Playwright Test for VSCode (ms-playwright.playwright) - for syntax highlighting and running tests directly in the editor [[5]]"
echo "    You can install these by opening VS Code, going to Extensions (Ctrl+Shift+X), and searching for the names above."

# Create a basic .gitignore if it doesn't exist
GITIGNORE_FILE=".gitignore"
if [ ! -f "$GITIGNORE_FILE" ]; then
    cat > "$GITIGNORE_FILE" << 'EOF'
# Logs
logs
*.log

# Runtime data
pids
*.pid
*.seed
*.pid.lock

# Directory for instrumented libs generated by jscoverage/JSCover
lib-cov

# Coverage directory used by tools like istanbul
coverage
*.lcov

# nyc test coverage
.nyc_output

# Grunt intermediate storage (https://gruntjs.com/creating-plugins#storing-task-files)
.grunt

# Bower dependency directory (https://bower.io/)
bower_components

# node-waf configuration
.lock-wscript

# Compiled binary addons (https://nodejs.org/api/addons.html)
build/Release

# Dependency directories
node_modules/

# Optional npm cache directory
.npm

# Optional eslint cache
.eslintcache

# Env
.env
.env.test

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Playwright specific
playwright-report/
test-results/
EOF
    print_success "Created basic .gitignore: $GITIGNORE_FILE"
else
    print_warning "$GITIGNORE_FILE already exists, skipping creation."
fi

#!/bin/bash

# Add section for CI/CD configuration
print_status "Setting up CI/CD configuration (GitHub Actions example)..."

# Create the GitHub Actions workflow directory structure
GITHUB_WORKFLOW_DIR=".github/workflows"
mkdir -p "$GITHUB_WORKFLOW_DIR"

# Create a basic GitHub Actions workflow file
GITHUB_WORKFLOW_FILE="$GITHUB_WORKFLOW_DIR/playwright.yml"
if [ ! -f "$GITHUB_WORKFLOW_FILE" ]; then
    cat > "$GITHUB_WORKFLOW_FILE" << 'EOF'
name: Playwright Tests
on:
  push:
    branches: [ main, develop ] # Trigger on pushes to main and develop branches
  pull_request:
    branches: [ main ]         # Trigger on pull requests to main

jobs:
  test:
    timeout-minutes: 60
    runs-on: ubuntu-latest # GitHub-hosted runner (Linux)
    steps:
    - uses: actions/checkout@v4 # Check out the repository code

    - uses: actions/setup-node@v4 # Set up Node.js
      with:
        node-version: '20' # Use a specific Node.js version

    - name: Install dependencies
      run: npm ci # Install dependencies from package-lock.json

    - name: Install Playwright Browsers
      run: npx playwright install --with-deps # Install required browsers and their dependencies

    - name: Run Playwright tests
      run: npx playwright test # Execute the tests

    - uses: actions/upload-artifact@v4 # Upload test results and traces if tests failed
      if: failure() # Only run this step if the test step failed
      with:
        name: playwright-report
        path: playwright-report/
        retention-days: 30
EOF
    print_success "Created GitHub Actions workflow: $GITHUB_WORKFLOW_FILE"
else
    print_warning "$GITHUB_WORKFLOW_FILE already exists, skipping creation."
fi

# Suggest other CI platforms configuration (optional, just inform the user)
print_status "CI/CD Configuration Added!"
echo ""
print_status "Next steps for CI/CD:"
echo "1.  The script created a GitHub Actions workflow file (.github/workflows/playwright.yml)."
echo "2.  If you use GitLab CI, create a '.gitlab-ci.yml' file in your project root with similar steps (setup Node, install deps, install Playwright, run tests)."
echo "3.  If you use Jenkins, configure a job that checks out your code, sets up Node.js, runs 'npm ci', 'npx playwright install --with-deps', and 'npx playwright test'."
echo "4.  Commit and push your project (including the new .github directory) to your GitHub repository to activate the workflow."
echo "5.  Push a change to a configured branch (e.g., main, develop) or create a pull request to trigger the CI pipeline."
echo ""
print_status "Note on Docker in CI:"
echo "While Docker isn't strictly required for the basic GitHub Actions runner (ubuntu-latest), you can configure your CI job to run inside a Docker container if needed for environment consistency. The runner handles installing system dependencies for browsers on Linux/macOS/Windows."
# ... (Rest of the original script output remains the same) ...
print_success "🎉 Playwright with Node.js Setup (including CI/CD example) complete on macOS!"
echo ""
print_status "Next steps:"
echo "1.  Ensure your Node.js version is compatible (LTS recommended)."
echo "2.  Review the generated files: package.json, playwright.config.js, tests/example.spec.js, .vscode/, .github/workflows/"
echo "3.  Run 'npm run test' or 'npx playwright test' locally to execute the example test."
echo "4.  Run 'npm run test:ui' to run tests in the Playwright UI mode locally."
echo "5.  Run 'npm run codegen' to start the Playwright Codegen tool for recording tests."
echo "6.  Open this project in VS Code and use the defined tasks and launch configurations."
echo "7.  Add your own test files to the 'tests' directory."
echo "8.  Commit and push your project to GitHub to activate the CI workflow."
echo ""
print_status "For more information:"
echo "- Playwright Documentation: https://playwright.dev/docs/intro"
echo "- GitHub Actions Documentation: https://docs.github.com/actions"
echo "- VS Code Extension: https://marketplace.visualstudio.com/items?itemName=ms-playwright.playwright"
