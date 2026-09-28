# Topics 标签策略

topics 是大仓库之外最便宜的曝光入口:GitHub 把它纳入仓库搜索,并按 topic 聚合成可浏览的页面。它也是最常被忽视的一项。

## 硬约束

- 每仓库最多 **20** 个;每个 ≤50 字符。
- 只允许小写字母、数字、连字符,且以字母或数字开头(不能有空格、下划线、大写)。

## 四类配比(合计 10-15 个为宜,不必凑满 20)

1. **品类(它是什么)**:`cli` `mcp-server` `vscode-extension` `browser-extension` `library` `framework`…
2. **技术栈**:`typescript` `rust` `python` `go` `nodejs`…
3. **问题域(解决什么)**:`code-review` `terminal` `llm` `context-management` `documentation`…
4. **独有词**:项目名、独有概念,1-2 个,方便老用户回搜。

多数仓库的通病是 1、2 类齐而 3 类缺——而开发者搜索时用的恰恰是问题域词。

## 选词流程

```bash
# 1. 找 3-5 个同类高星仓库(gh search repos 的 --json 没有 topics 字段,必须走 REST API)
gh api 'search/repositories?q=<最像的 2-3 个关键词>&sort=stars&per_page=10' \
  --jq '.items[] | {full_name, stars: .stargazers_count, topics}'
```

2. 取它们 topics 的并集,按四类归位;删掉只有 1 个仓库在用的自造词(没人顺着它搜)。
3. 补齐竞品没用、但你的问题域该有的词——这是免费的超越机会。
4. 每个入选词问一句:开发者遇到这个问题时,会在搜索框里打这个词吗?不会就不放。
5. 搜不到直接同类仓库的冷门品类:改搜相邻品类(用户会拿什么词找到这类项目,就搜什么),从结果里借问题域词。

## 禁止

- 与仓库无关的热词(堆砌降低转化,也招社区反感)。
- `awesome` `tutorial` `notes` 一类不含品类信息的泛词(除非仓库确实是那种东西)。
- 为凑数放同义重复:`cli` 和 `cli-tool` 二选一。

## 落地

```bash
# 全量重写(推荐,一步到位)
gh api -X PUT repos/OWNER/REPO/topics --input - <<'EOF'
{"names":["cli","rust","mcp-server"]}
EOF

# 增量增删
gh repo edit OWNER/REPO --add-topic a --remove-topic b
```

改完用 `gh repo view OWNER/REPO --json repositoryTopics` 复核。
