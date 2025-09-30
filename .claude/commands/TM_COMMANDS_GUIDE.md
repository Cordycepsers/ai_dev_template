# Task Master Commands Guide for Claude Code

This guide provides Claude Code with comprehensive information about Task Master commands and their usage within the development workflow.

## Core Commands

### `tm list`
Lists all tasks with their current status, priorities, and basic information.

**Usage:**
```bash
tm list
tm list --status=pending
tm list --priority=high
```

**When to use:**
- Getting an overview of project tasks
- Checking task statuses before planning work
- Identifying available tasks for execution

### `tm next`
Shows the next recommended task(s) to work on based on dependencies and priorities.

**Usage:**
```bash
tm next
tm next --count=3
```

**When to use:**
- Starting a new work session
- After completing a task
- When unsure what to work on next

### `tm get <task-id>`
Retrieves detailed information about a specific task, including subtasks, dependencies, and acceptance criteria.

**Usage:**
```bash
tm get 1
tm get 2.3
tm get --id=5 --include-subtasks
```

**When to use:**
- Before implementing a task
- Understanding task requirements
- Checking acceptance criteria

### `tm set-status <task-id> <status>`
Updates the status of a task or subtask.

**Usage:**
```bash
tm set-status 1 in-progress
tm set-status 2.3 review
tm set-status 5 done
```

**Valid statuses:**
- `pending` - Task is ready to be worked on
- `in-progress` - Task is currently being implemented
- `review` - Task implementation is complete, awaiting verification
- `done` - Task is completed and verified
- `blocked` - Task cannot proceed due to dependencies or issues

**When to use:**
- Starting work on a task (set to `in-progress`)
- Completing implementation (set to `review`)
- After verification passes (set to `done`)

### `tm update <task-id>`
Updates task details, adds notes, or modifies task properties.

**Usage:**
```bash
tm update 1 --notes="Implemented user authentication with JWT"
tm update 2.3 --priority=high
tm update 5 --add-subtask="Write unit tests"
```

**When to use:**
- Adding implementation notes
- Updating task priorities
- Adding new subtasks discovered during implementation

### `tm parse-prd <prd-file>`
Parses a Product Requirements Document and generates tasks automatically.

**Usage:**
```bash
tm parse-prd .taskmaster/docs/prd.txt
tm parse-prd docs/requirements.md --research-mode
```

**When to use:**
- Starting a new project
- Adding new features from updated requirements
- Converting high-level requirements into actionable tasks

### `tm expand <task-id>`
Breaks down a complex task into smaller, more manageable subtasks.

**Usage:**
```bash
tm expand 1
tm expand 3 --detail-level=high
```

**When to use:**
- When a task seems too complex to implement directly
- Breaking down epic-level tasks
- Creating more granular work items

## Workflow Integration

### For Task Orchestrator Agent
```bash
# Get project overview
tm list

# Identify next priorities
tm next --count=5

# Get detailed task information
tm get <task-id>

# Update task priorities
tm update <task-id> --priority=high
```

### For Task Executor Agent
```bash
# Get task details before implementation
tm get <task-id>

# Mark task as in progress
tm set-status <task-id> in-progress

# Add implementation notes
tm update <task-id> --notes="Implementation approach: ..."

# Mark for review after implementation
tm set-status <task-id> review
```

### For Task Checker Agent
```bash
# Get task details for verification
tm get <task-id>

# Mark as done after successful verification
tm set-status <task-id> done

# Or return to pending if issues found
tm set-status <task-id> pending --notes="Issues found: ..."
```

## Best Practices

### Status Management
1. **Always update status** when starting work on a task
2. **Use 'review' status** instead of 'done' after implementation
3. **Add notes** when changing status to provide context
4. **Check dependencies** before marking tasks as done

### Task Discovery
1. **Use `tm next`** to maintain workflow momentum
2. **Check `tm list`** regularly for project overview
3. **Use `tm get`** to understand requirements fully before implementing
4. **Expand complex tasks** into subtasks for better tracking

### Communication
1. **Add implementation notes** using `tm update`
2. **Document decisions** and approaches in task updates
3. **Report blockers** by updating task status and adding notes
4. **Provide verification details** when checking tasks

## Error Handling

### Common Issues
- **Task not found**: Verify task ID exists with `tm list`
- **Invalid status**: Use only valid status values
- **Dependency conflicts**: Check task dependencies before status changes
- **Permission errors**: Ensure proper file permissions for task files

### Troubleshooting
```bash
# Check if Task Master is properly installed
tm help

# Verify task file integrity
tm status

# Reset task status if needed
tm set-status <task-id> pending
```

## Integration with MCP

Task Master integrates with Model Context Protocol (MCP) for seamless AI assistant integration:

- **MCP Server**: Provides structured access to task data
- **Real-time Updates**: Changes are immediately available to all agents
- **Structured Data**: Tasks are stored in JSON format for easy parsing
- **Event Notifications**: Status changes trigger workflow events

## Advanced Usage

### Batch Operations
```bash
# Update multiple tasks
tm list --status=review | xargs -I {} tm set-status {} done

# Get details for multiple tasks
for id in 1 2 3; do tm get $id; done
```

### Filtering and Querying
```bash
# Find high-priority pending tasks
tm list --status=pending --priority=high

# Get tasks by dependency
tm list --depends-on=1

# Find tasks by keyword
tm list --search="authentication"
```

### Reporting
```bash
# Generate progress report
tm status --format=json

# Export task data
tm list --format=csv > tasks.csv

# Get completion statistics
tm status --stats
```

This guide ensures Claude Code agents can effectively use Task Master for coordinated development workflow management.

