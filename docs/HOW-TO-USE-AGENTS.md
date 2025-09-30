# 🤖 How to Use AGENTS.md

> **The complete guide to leveraging AGENTS.md for effective AI-assisted development**

AGENTS.md is your secret weapon for keeping AI coding assistants focused, informed, and productive. This guide shows you exactly how to create and use AGENTS.md files to transform your AI development experience.

## 🎯 What is AGENTS.md?

AGENTS.md is a special Markdown file that provides context and instructions to AI coding assistants. Think of it as a **"README for AI agents"** - it tells them everything they need to know about your project, coding standards, and workflows.

### **Why You Need It**
- **Prevents hallucinations** by providing accurate project context
- **Maintains consistency** across different AI interactions
- **Reduces repetitive explanations** of project structure and rules
- **Improves code quality** by enforcing standards automatically
- **Saves time** by eliminating back-and-forth clarifications

## 🚀 Quick Start: Creating Your First AGENTS.md

### **Step 1: Add AGENTS.md to Your Repository**
```bash
# Create AGENTS.md at the root of your repository
touch AGENTS.md

# Most coding agents can scaffold one for you
# Just ask: "Please create an AGENTS.md file for this project"
```

### **Step 2: Cover What Matters**
Add sections that help an agent work effectively with your project. Popular choices:

#### **Essential Sections:**
- **Project Overview** - What the project does and its goals
- **Build and Test Commands** - How to run, build, and test the code
- **Code Style Guidelines** - Formatting, naming conventions, patterns
- **Testing Instructions** - How to write and run tests
- **Security Considerations** - Security requirements and gotchas

#### **Example Structure:**
```markdown
# Project: My Awesome App

## Overview
This is a React + Node.js web application that...

## Build Commands
```bash
npm install
npm run build
npm test
```

## Code Style
- Use TypeScript for all new code
- Follow Prettier formatting (auto-format on save)
- Use descriptive variable names
- Write JSDoc comments for all functions

## Testing
- Write unit tests for all business logic
- Use Jest and React Testing Library
- Aim for 80%+ code coverage
- Run tests before committing

## Security
- Never commit API keys or secrets
- Validate all user inputs
- Use HTTPS in production
```

### **Step 3: Add Extra Instructions**
Include anything you'd tell a new teammate:

- **Commit Message Guidelines** - How to write good commit messages
- **Pull Request Process** - Review requirements and standards
- **Deployment Steps** - How to deploy to different environments
- **Large Datasets** - How to handle data files and databases
- **Architecture Decisions** - Why certain technologies were chosen
- **Common Gotchas** - Known issues and how to avoid them

## 🏗️ Advanced Usage

### **Large Monorepo? Use Nested AGENTS.md Files**

For complex projects with multiple subprojects, place AGENTS.md files in each package:

```
my-monorepo/
├── AGENTS.md                    # Main project instructions
├── frontend/
│   ├── AGENTS.md               # Frontend-specific instructions
│   └── src/
├── backend/
│   ├── AGENTS.md               # Backend-specific instructions
│   └── api/
└── shared/
    ├── AGENTS.md               # Shared library instructions
    └── utils/
```

**How it works:**
- Agents automatically read the **nearest** AGENTS.md file in the directory tree
- The **closest** file takes precedence
- Each subproject can have tailored instructions
- Example: OpenAI's main repo has **88 AGENTS.md files**

### **Inheritance and Overrides**
```
project/
├── AGENTS.md                    # Global rules: "Use TypeScript"
└── legacy/
    └── AGENTS.md               # Override: "This folder uses JavaScript"
```

## 📋 Template Sections

### **Complete AGENTS.md Template**
```markdown
# [Project Name]

## Project Overview
[Brief description of what this project does and its main goals]

## Technology Stack
- **Frontend:** [React, Vue, etc.]
- **Backend:** [Node.js, Python, etc.]
- **Database:** [PostgreSQL, MongoDB, etc.]
- **Deployment:** [AWS, Vercel, etc.]

## Development Setup
```bash
# Installation
npm install

# Development server
npm run dev

# Build for production
npm run build

# Run tests
npm test

# Linting and formatting
npm run lint
npm run format
```

## Code Style Guidelines
- **Language:** [TypeScript/JavaScript/Python/etc.]
- **Formatting:** [Prettier, Black, etc.]
- **Linting:** [ESLint, Flake8, etc.]
- **Naming:** [camelCase, snake_case, etc.]
- **Comments:** [JSDoc, docstrings, etc.]

## Testing Requirements
- **Framework:** [Jest, pytest, etc.]
- **Coverage:** [Minimum percentage]
- **Types:** [Unit, integration, e2e]
- **Location:** [test/ folder, __tests__, etc.]

## Security Guidelines
- Never commit secrets or API keys
- Validate all user inputs
- Use environment variables for configuration
- Follow OWASP security practices

## Git Workflow
- **Branches:** [main, develop, feature/*, etc.]
- **Commits:** [Conventional commits, descriptive messages]
- **PRs:** [Review requirements, CI checks]

## Deployment
- **Staging:** [How to deploy to staging]
- **Production:** [How to deploy to production]
- **Environment Variables:** [Required env vars]

## Common Commands
```bash
# Start development
npm run dev

# Run all tests
npm test

# Build and deploy
npm run build && npm run deploy
```

## Architecture Notes
[Important architectural decisions, patterns used, etc.]

## Troubleshooting
[Common issues and their solutions]

## Additional Notes
[Any other important information for developers]
```

## 🔧 Best Practices

### **Writing Effective Instructions**

#### **✅ Do:**
- **Be specific:** "Use camelCase for variables" not "use good naming"
- **Include examples:** Show code snippets of what you want
- **List commands:** Provide exact commands to run
- **Explain why:** Help agents understand the reasoning
- **Keep it current:** Update as the project evolves

#### **❌ Don't:**
- **Be vague:** "Write good code" doesn't help
- **Assume knowledge:** Explain project-specific concepts
- **Forget edge cases:** Mention special situations
- **Make it too long:** Keep it focused and scannable

### **Testing Integration**
```markdown
## Testing Commands
```bash
# Run unit tests
npm test

# Run integration tests
npm run test:integration

# Run all tests with coverage
npm run test:coverage

# Fix linting issues
npm run lint:fix
```

**Note:** The agent will automatically run these commands and fix failures before finishing tasks.
```

### **Security Considerations**
```markdown
## Security Requirements
- All API endpoints must validate input
- Use parameterized queries for database access
- Never log sensitive information
- Implement rate limiting on public endpoints
- Use HTTPS in all environments
```

## 📊 FAQ

### **Are there required fields?**
**No.** AGENTS.md is just standard Markdown. Use any headings you like; the agent simply parses the text you provide.

### **What if instructions conflict?**
The **closest AGENTS.md** to the edited file wins; explicit user chat prompts override everything.

### **Will the agent run testing commands found in AGENTS.md automatically?**
**Yes**—if you list them. The agent will attempt to execute relevant programmatic checks and fix failures before finishing the task.

### **Can I update it later?**
**Absolutely.** Treat AGENTS.md as living documentation. Update it as your project evolves.

### **How do I know if my AGENTS.md is working?**
- AI assistants give more relevant suggestions
- Less back-and-forth clarification needed
- Code follows your standards consistently
- Fewer configuration-related errors

### **Should I commit AGENTS.md to version control?**
**Yes!** AGENTS.md should be versioned with your code so all team members and AI assistants have the same context.

## 🎯 Real-World Examples

### **Example 1: React Frontend**
```markdown
# Frontend Application

## Overview
React 18 + TypeScript + Vite application with Material-UI components.

## Development
```bash
npm run dev    # Start dev server on :3000
npm run build  # Build for production
npm test       # Run Jest tests
```

## Code Style
- Use functional components with hooks
- TypeScript for all new files
- Material-UI components only
- CSS-in-JS with emotion
- Prettier formatting (auto-format on save)

## Testing
- Jest + React Testing Library
- Test files: `*.test.tsx`
- Mock external APIs
- 80%+ coverage required
```

### **Example 2: Python API**
```markdown
# Backend API

## Overview
FastAPI application with PostgreSQL database and Redis caching.

## Development
```bash
pip install -r requirements.txt
uvicorn main:app --reload
pytest
```

## Code Style
- Python 3.11+
- Black formatting
- Type hints required
- Docstrings for all functions
- Follow PEP 8

## Database
- Use Alembic for migrations
- SQLAlchemy ORM
- Never write raw SQL
- Always use transactions
```

## 🚀 Getting Started

1. **Create your AGENTS.md** using the template above
2. **Start with basics** - project overview, build commands, code style
3. **Add specifics** as you encounter common issues
4. **Test with AI** - see if assistants follow your guidelines
5. **Iterate and improve** based on real usage

Remember: AGENTS.md is your **AI pair programming contract**. The better you define it, the more effective your AI assistants become! 🤖✨

