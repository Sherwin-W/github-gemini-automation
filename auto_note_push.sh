#!/bin/bash
set -e

BRANCH="notes-$(date +%Y-%m-%d-%H%M%S)"

# Check for changes (including untracked)
if [ -n "$(git status --porcelain)" ]; then
  # Create and checkout new branch
  git checkout -b "$BRANCH"
  git add .
  git commit -m "Note update: $(date)"
  git push -u origin "$BRANCH"

  # Open PR using gh CLI (interactive, uses current branch context)
  gh pr create --fill --title "Note update $(date)" --body "Automated note update"

  # Wait a few seconds to allow PR to be registered by GitHub (avoids race condition)
  sleep 5

  # Auto-merge PR for this branch and delete it
  gh pr merge --merge --delete-branch --admin
  echo "PR merged and branch deleted."

  # Run Gemini CLI code review on all files in repo
  echo "Running Gemini code review..."
  gemini -a -p "You are an AI code reviewer. Review this repository for code quality, clarity, potential bugs, and best practices. List specific improvements and actionable feedback. Only provide code review, not code changes." > gemini_review.md

  # Create a GitHub issue with Gemini review
  if [ -s gemini_review.md ]; then
    gh issue create --title "Gemini Automated Code Review $(date)" --body "$(cat gemini_review.md)"
    echo "Gemini review posted as GitHub issue."
  else
    echo "Gemini review was empty. No issue created."
  fi

else
  echo "No changes to commit."
fi

