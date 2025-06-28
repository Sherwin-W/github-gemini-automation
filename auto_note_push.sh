#!/bin/bash
set -e

BRANCH="notes-$(date +%Y-%m-%d-%H%M%S)"

# 1. Check for changes (including untracked files)
if [ -n "$(git status --porcelain)" ]; then
  # 2. Create new branch, add, commit, push
  git checkout -b "$BRANCH"
  git add .
  git commit -m "Note update: $(date)"
  git push -u origin "$BRANCH"

  # 3. Open a PR and capture its URL
  PR_URL=$(gh pr create --fill --title "Note update $(date)" --body "Automated note update" --json url -q .url)
  echo "PR created: $PR_URL"

  # 4. Merge the PR (and delete branch after merge)
  gh pr merge "$PR_URL" --merge --delete-branch --admin
  echo "PR merged and branch deleted."

  # 5. Run Gemini CLI code review (all files)
  echo "Running Gemini code review..."
  gemini -a -p "You are an AI code reviewer. Review this repository for code quality, clarity, potential bugs, and best practices. List specific improvements and actionable feedback. Only provide code review, not code changes." > gemini_review.md

  # 6. Create a GitHub issue with Gemini review
  if [ -s gemini_review.md ]; then
    gh issue create --title "Gemini Automated Code Review $(date)" --body "$(cat gemini_review.md)"
    echo "Gemini review posted as GitHub issue."
  else
    echo "Gemini review was empty. No issue created."
  fi

else
  echo "No changes to commit."
fi

