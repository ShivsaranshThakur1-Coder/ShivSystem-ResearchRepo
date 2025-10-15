#!/bin/bash
set -e

echo "Rebuilding research_index.yaml..."
cd ~/ShivSystem/ResearchRepo

echo "---" > _meta/research_index.yaml
for dir in $(find . -maxdepth 1 -type d -regex './[A-Za-z0-9_-]*' ! -name '.*' ! -name '_meta' | sort); do
  dirname=$(basename "$dir")
  echo "$dirname:" >> _meta/research_index.yaml
  find "$dir" -maxdepth 1 -type f \( -name "*.md" -o -name "*.txt" -o -name "*.pdf" -o -name "*.yaml" \) \
    -exec basename {} \; | awk '{print "  - "$1}' >> _meta/research_index.yaml
done

timestamp=$(date "+%Y-%m-%d %H:%M:%S")
echo "last_verified: \"$timestamp\"" >> _meta/research_index.yaml

git add _meta/research_index.yaml
git commit --no-verify -m "Auto-refresh research_index.yaml"
git push

echo "✅ research_index.yaml rebuilt and pushed."
