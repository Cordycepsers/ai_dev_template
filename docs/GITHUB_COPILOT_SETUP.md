# GitHub Copilot Setup and Troubleshooting Guide

This guide helps you set up and troubleshoot GitHub Copilot in VS Code with this AI development template.

## Prerequisites

1. **GitHub Copilot Subscription**: You need an active GitHub Copilot subscription
   - Individual: $10/month or $100/year
   - Business: $19/user/month
   - Free for verified students, teachers, and maintainers of popular open-source projects

2. **VS Code**: Version 1.70 or later recommended

## Installation Steps

### 1. Install GitHub Copilot Extensions

The template already recommends the correct extensions in `.vscode/extensions.json`:
- `github.copilot` - Core GitHub Copilot extension
- `github.copilot-chat` - Chat interface for Copilot

**To install:**
1. Open VS Code
2. Press `Ctrl+Shift+P` (Windows/Linux) or `Cmd+Shift+P` (macOS)
3. Type "Extensions: Show Recommended Extensions"
4. Click "Install" on both GitHub Copilot extensions

**Or manually:**
1. Open Extensions view (`Ctrl+Shift+X`)
2. Search for "GitHub Copilot"
3. Install both extensions

### 2. Sign in to GitHub

1. After installing the extension, you'll see a prompt to sign in
2. Click "Sign in to GitHub"
3. Authorize the extension in your browser
4. Return to VS Code

**If you missed the prompt:**
1. Press `Ctrl+Shift+P`
2. Type "GitHub Copilot: Sign In"
3. Follow the authentication flow

### 3. Verify Settings

The template includes optimized settings for GitHub Copilot in `.vscode/settings.json`:

```json
{
  "github.copilot.enable": {
    "*": true,
    "yaml": true,
    "plaintext": true,
    "markdown": true,
    "python": true,
    "javascript": true,
    "typescript": true,
    "json": true
  },
  "github.copilot.editor.enableAutoCompletions": true,
  "github.copilot.chat.localeOverride": "en"
}
```

## Common Issues and Solutions

### Issue 1: Copilot Not Showing Suggestions

**Symptoms:** No inline suggestions appear while typing

**Solutions:**
1. **Check if Copilot is enabled:**
   - Look for the Copilot icon in the status bar (bottom right)
   - Click it to toggle Copilot on/off
   - Ensure it shows "Copilot enabled"

2. **Check file language mode:**
   - Copilot might not be enabled for the current file type
   - Check the language mode in the status bar (bottom right)
   - Verify the file extension is supported

3. **Restart VS Code:**
   ```bash
   # Close VS Code and reopen it
   # Or use Command Palette
   # Ctrl+Shift+P > "Developer: Reload Window"
   ```

4. **Check network connection:**
   - Copilot requires an internet connection
   - Check if you can access github.com
   - Try disabling VPN or proxy temporarily

5. **Verify subscription:**
   ```bash
   # In VS Code, press Ctrl+Shift+P
   # Type: "GitHub Copilot: Check Status"
   ```

### Issue 2: "GitHub Copilot could not connect to server"

**Solutions:**
1. **Sign out and sign in again:**
   ```
   Ctrl+Shift+P > "GitHub Copilot: Sign Out"
   Ctrl+Shift+P > "GitHub Copilot: Sign In"
   ```

2. **Clear authentication token:**
   ```
   Ctrl+Shift+P > "GitHub: Sign Out"
   Ctrl+Shift+P > "GitHub: Sign In"
   ```

3. **Check firewall/proxy settings:**
   - Ensure VS Code can access `*.github.com` and `*.githubcopilot.com`
   - Add exceptions in your firewall if needed

### Issue 3: Suggestions are Poor Quality or Irrelevant

**Solutions:**
1. **Provide better context:**
   - Write clear comments describing what you want
   - Use descriptive variable and function names
   - Include type hints (Python) or JSDoc comments

2. **Wait for suggestions:**
   - Copilot takes a moment to analyze context
   - Pause briefly after typing

3. **Use Copilot Chat for complex tasks:**
   - Press `Ctrl+Shift+I` to open Copilot Chat
   - Describe what you want in natural language

### Issue 4: Settings Not Taking Effect

**Solutions:**
1. **Reload VS Code:**
   ```
   Ctrl+Shift+P > "Developer: Reload Window"
   ```

2. **Check for conflicting settings:**
   - Open Settings UI (`Ctrl+,`)
   - Search for "copilot"
   - Ensure no conflicting user settings override workspace settings

3. **Verify settings file syntax:**
   - Ensure `.vscode/settings.json` is valid JSON with comments
   - Look for syntax errors highlighted in the editor

### Issue 5: Extension Conflicts

**Known conflicting extensions:**
- `ms-vscode.vscode-copilot-legacy` (already excluded in template)
- Some AI completion extensions may conflict

**Solution:**
- Disable other AI completion extensions temporarily
- Check `.vscode/extensions.json` for unwanted recommendations

## Advanced Configuration

### Customize Suggestions per File Type

You can enable/disable Copilot for specific languages:

```json
{
  "github.copilot.enable": {
    "*": true,
    "markdown": false,  // Disable for markdown
    "plaintext": false  // Disable for plaintext
  }
}
```

### Keyboard Shortcuts

- `Tab` - Accept suggestion
- `Alt+]` - Next suggestion
- `Alt+[` - Previous suggestion
- `Ctrl+Shift+I` - Open Copilot Chat
- `Ctrl+Enter` - Open Copilot completions panel

### Using Copilot Chat Effectively

1. **Open Chat:** `Ctrl+Shift+I`
2. **Ask questions:**
   - "Explain this code"
   - "How do I implement X?"
   - "Find bugs in this function"
   - "Write tests for this code"
3. **Use slash commands:**
   - `/explain` - Explain selected code
   - `/fix` - Propose a fix for problems
   - `/tests` - Generate unit tests
   - `/help` - Show available commands

## Verification Steps

After setup, verify Copilot is working:

1. **Create a test file:**
   ```bash
   touch test-copilot.py
   ```

2. **Open it in VS Code and start typing:**
   ```python
   # Function to calculate fibonacci numbers
   def fibonacci(
   ```

3. **Expected behavior:**
   - You should see a gray suggestion appear
   - Press `Tab` to accept it
   - Copilot should complete the function

## Getting Help

If you're still having issues:

1. **Check Copilot logs:**
   ```
   Ctrl+Shift+P > "Developer: Open Extension Logs Folder"
   # Navigate to github.copilot folder
   ```

2. **GitHub Copilot Status:**
   ```
   Ctrl+Shift+P > "GitHub Copilot: Check Status"
   ```

3. **Community Support:**
   - [GitHub Copilot Discussions](https://github.com/orgs/community/discussions/categories/copilot)
   - [VS Code GitHub Copilot Issues](https://github.com/microsoft/vscode-copilot-release/issues)

4. **Official Documentation:**
   - [GitHub Copilot Documentation](https://docs.github.com/en/copilot)
   - [VS Code Copilot Extension](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot)

## Best Practices

1. **Write clear comments** before code blocks
2. **Use meaningful variable names**
3. **Break down complex tasks** into smaller functions
4. **Review all suggestions** before accepting
5. **Use Copilot Chat** for explanations and complex tasks
6. **Combine with other AI tools** in this template (Claude, OpenAI)

## Template-Specific Features

This AI development template is optimized for:
- Multi-AI workflow (Copilot + Claude + OpenAI)
- Task-driven development with Taskmaster
- ADHD-friendly settings
- Budget tracking for AI usage

See `README.md` for more details on the complete AI development workflow.
