#!/usr/bin/env bash
# 采集 GitHub 仓库的门面事实,供 github-repo-optimize 体检使用。全部调用只读。
# 用法: collect-repo-facts.sh [OWNER/REPO];省略时取当前目录的 git origin。
set -euo pipefail

if [[ $# -gt 1 ]]; then
  echo "用法: $0 [OWNER/REPO]" >&2
  exit 2
fi

repo="${1:-}"
if [[ -z "$repo" ]]; then
  origin="$(git remote get-url origin 2>/dev/null || true)"
  if [[ -z "$origin" ]]; then
    echo "错误: 未提供 OWNER/REPO,且当前目录没有 git origin" >&2
    exit 2
  fi
  repo="$(printf '%s' "$origin" | sed -E 's#^.*github\.com[/:]##; s#\.git$##')"
fi

if ! command -v gh >/dev/null 2>&1; then
  echo "错误: 需要 gh CLI(https://cli.github.com)" >&2
  exit 2
fi
if ! gh auth status >/dev/null 2>&1; then
  echo "错误: gh 未登录,先运行 gh auth login" >&2
  exit 2
fi

echo "# 仓库事实:$repo"
echo

echo "## 基本面"
gh repo view "$repo" --json nameWithOwner,description,homepageUrl,repositoryTopics,licenseInfo,stargazerCount,forkCount,primaryLanguage,createdAt,pushedAt,isArchived,isPrivate --jq '.'
echo

echo "## 根目录文件"
gh api "repos/$repo/contents" --jq '.[].name' 2>/dev/null | sort || echo "(读取失败)"
echo

echo "## .github 目录"
if dotgithub="$(gh api "repos/$repo/contents/.github" --jq '.[].name' 2>/dev/null)"; then
  printf '%s\n' "$dotgithub"
  # gh api 对 404 会把错误 JSON 打到 stdout 且退出码非 0,必须用状态判断,不能只看输出非空。
  if templates="$(gh api "repos/$repo/contents/.github/ISSUE_TEMPLATE" --jq '.[].name' 2>/dev/null)" && [[ -n "$templates" ]]; then
    echo "ISSUE_TEMPLATE: 有($(printf '%s\n' "$templates" | wc -l | tr -d ' ') 个模板)"
  else
    echo "ISSUE_TEMPLATE: 无"
  fi
  if workflows="$(gh api "repos/$repo/contents/.github/workflows" --jq '.[].name' 2>/dev/null)" && [[ -n "$workflows" ]]; then
    echo "workflows: $(printf '%s' "$workflows" | tr '\n' ' ')"
  else
    echo "workflows: 无"
  fi
else
  echo "(无 .github 目录)"
fi
echo

echo "## Releases(最近 5 个)"
if releases="$(gh api "repos/$repo/releases?per_page=5" \
  --jq '.[] | "\(.tag_name)  \(.published_at // "draft")"' 2>/dev/null)" && [[ -n "$releases" ]]; then
  printf '%s\n' "$releases"
else
  echo "(无 release)"
fi
echo

echo "## README"
readme="$(gh api "repos/$repo/readme" -H 'Accept: application/vnd.github.raw+json' 2>/dev/null)" || readme=""
if [[ -z "$readme" ]]; then
  echo "(无 README 或读取失败)"
else
  lines="$(printf '%s\n' "$readme" | wc -l | tr -d ' ')"
  images="$(printf '%s\n' "$readme" | grep -c '!\[' || true)"
  fences="$(printf '%s\n' "$readme" | grep -c '^```' || true)"
  badges="$(printf '%s\n' "$readme" | grep -cE 'img\.shields\.io|badge' || true)"
  echo "总行数:$lines · 图片引用:$images · 代码块栅栏行:$fences · shields/badge 引用:$badges"
  echo
  echo "### README 全文(超过 400 行时截断)"
  if (( lines <= 400 )); then
    printf '%s\n' "$readme"
  else
    printf '%s\n' "$readme" | head -400
    echo
    echo "(已截断:全文共 $lines 行;其余部分读本地 checkout 或 gh api repos/$repo/readme)"
  fi
fi
