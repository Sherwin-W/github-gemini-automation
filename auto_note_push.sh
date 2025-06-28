#!/bin/bash
set -e

# Set branch name based on date and time
BRANCH="notes-$(date +%Y-%m-%d-%H%M%S)"

# Check for changes
if [ -n "$(git status --porcelain)" ]; then
  git checkout -b "$BRANCH"
  git add .
  git commit -m "Note update: $(date)"
  git push -u origin "$BRANCH"
  # Create a pull request with GitHub CLI
  gh pr create --fill --title "Note update $(date)" --body "Automated note update"
else
  echo "No changes to commit."
fi

