---
name: github-repo-optimize
slug: github-repo-optimize
displayName: GitHub Repo Optimize
version: 1.0.0
summary: GitHub 仓库体检与门面优化，让仓库更容易被开发者发现和 star
description: GitHub 仓库体检与门面优化：topics 标签、README、description、social preview、LICENSE/CI 等信任信号。用于新建仓库打样，或给存量仓库做审计提分，让仓库更容易被开发者发现和 star。Use whenever the user mentions 仓库优化/体检/包装, star 上不去, more stars, README 改写, topics/标签, social preview, making a repo attractive or credible, or is about to open-source a repo — even if they don't say "optimize".
---

# GitHub Repo Optimize

优化 GitHub 仓库的"门面"——开发者从搜索结果点进来后 30 秒内看到的一切——让仓库更易被发现、更可信、更容易被 star。

两种模式:

- **体检(audit)**:存量仓库。先出报告,用户勾选后再动手。
- **打样(scaffold)**:新仓库/空仓库。按固定顺序把门面一次配齐。

## 硬性原则

1. **只做真实的吸引力**。README 里的每个声明(功能、数字、benchmark)必须能追溯到仓库代码或用户原话;查不到就标"待确认",不编造。
2. **不碰虚假指标**:不买 star、不互 star、不堆砌无关热词、不放指向不存在 workflow 的徽章。这些短期有效,长期毁信誉,且会招来社区反感。
3. **先看后说**:所有"缺少 X"的结论必须来自实际检查(脚本输出 + 打开文件),不凭印象。
4. **先报告后执行**:体检模式下,`gh repo edit` 和文件改动都要在用户勾选后进行;`git push` 永远单独确认。
5. **gh CLI 是前提**:先 `gh auth status`,未登录就停下报错,不降级到网页抓取。

## 流程

### 0. 定目标与模式

- 仓库:参数给了 `owner/repo` 就用它;否则取当前目录的 git origin;两者都没有 → 问用户。
- 模式:用户说"新仓库/刚建/起步/开源准备" → 打样(§Scaffold);说"体检/优化/star 上不去"或仓库已有内容 → 体检(§Audit)。

### 1. 采集事实(只读)

跑 `scripts/collect-repo-facts.sh [owner/repo]`,一次拿到 description、topics、README 原文、LICENSE、release、根目录结构。

判断仓库是否在本地 checkout:当前目录的 origin 就是目标仓库 → 就地读;否则在常用代码目录(如 `~/code`)下找与仓库同名的目录;都找不到 → 按纯远端处理,报告里注明"未核对本地文件"。在本地 checkout 时额外读:

- README 源文件(脚本的远端版本可能落后于本地未推送的改动)
- 清单文件(`package.json` / `pyproject.toml` / `Cargo.toml` / `Makefile`)——用于校验 README 里的命令是否真实存在

### 2. 体检

读 [references/audit-checklist.md](references/audit-checklist.md),逐项检查,输出报告(格式见下)。检查 topics 时同时读 [references/topics.md](references/topics.md)。

报告开头先核对用户的前提:采集到的事实与用户说法矛盾时(比如仓库今天刚建,用户却说"star 一直上不去"),先点破前提,再给建议——前提错了,后面全是无用功。

```markdown
# 体检报告:mahingbun-dev/dsh-plugin-dev-kit(2026-09-28)

**现状** ⭐ 0 · 描述 ✓ · topics 10/20 · LICENSE ✓(MIT) · CI ✗ · 最近推送今天

| 维度 | 评分 | 一句话诊断 |
|---|---|---|
| 第一印象 | 3/5 | 首屏无 demo 图,三段口号后才出现可运行的东西 |
| 快速上手 | 2/5 | 安装命令可复制,但示例输出未展示 |
| 可信度 | 2/5 | 无 release、无 CI 徽章 |
| 内容结构 | 3/5 | 缺同类工具对比 |
| 可发现性 | 3/5 | topics 缺问题域词,全堆在品类词 |
| 门面细节 | 2/5 | 无 social preview、homepage 未填 |

## 建议清单(按优先级,勾选后我来执行)
- **P0** 首屏加一张运行效果图或 GIF(GitHub 渲染 `<img>` 或直接 `![]()`)
- **P1** topics 补 `developer-tools` `llm` 等竞品在用的问题域词
- **P1** 打 tag 发第一个 release
- **P2** 补 social preview 图(1280×640)
```

评分用扣分制,保证可复现:每维度从 5 分起,P0 每缺一项扣 2、P1 每缺一项扣 1、P2 每缺一项扣 0.5,不适用项不扣,下限 0。报告末尾必须以"勾选后我来执行"收尾,把选择权交给用户。

### 3. 执行(只做用户勾选的项)

```bash
# topics 全量重写(推荐,一步到位)
gh api -X PUT repos/OWNER/REPO/topics --input - <<'EOF'
{"names":["cli","rust","mcp-server"]}
EOF

# topics 增删(增量时用)
gh repo edit OWNER/REPO --add-topic a --remove-topic b

# description / homepage
gh repo edit OWNER/REPO --description "..." --homepage "https://..."
```

- **README 重写**:仓库在本地就改文件;不在本地就把完整新 README 放进一个 fenced block 交给用户,不擅自 clone。改动完成后给出一行 diff 摘要,commit 前确认,push 前再确认。
- **social preview 图**:GitHub **没有 API**(2026-09 验证)。生成 1200×630 图片后,明确告诉用户:Settings → General → Social preview → Edit,手动上传。
- **LICENSE**:问用户选哪种,并给一行取舍(MIT 最宽松;Apache-2.0 带专利授权条款,企业场景更稳)。不默默替用户选。

## Scaffold(新仓库打样)

按顺序做,前两步 5 分钟内见效,先于一切代码完善:

1. **description + topics + homepage**(`gh repo edit`)——最便宜的曝光,创建当天就配齐。
2. **LICENSE**——先问用户选哪种。
3. **README**(骨架如下,填入真实内容,禁止占位文案):

```markdown
# <项目名>
<一句话:做什么 + 给谁用 + 核心差异。禁形容词,用具体名词。>

![demo](docs/demo.gif)

<徽章 ≤5 个:CI · 最新版本 · license,每个指向真实目标>

## 安装
<唯一推荐方式,可复制,注明前置要求>

## 30 秒上手
<最小可运行示例 + 预期输出>

## 为什么是它
<与最相近的 1-2 个替代品对比,表格或要点>

## 文档
<完整文档 / 示例目录 / FAQ 链接>

## License
```

4. **demo 图/GIF**——哪怕只是截图。有界面的项目,这张图对转化的影响超过所有文字。
5. **social preview 图**(1280×640,GitHub 官方推荐尺寸,首屏信息浓缩成一张图)→ 手动上传(见上)。
6. **第一个 tag + release**、CI 绿。
7. 收尾提醒用户手动做:pin 仓库到个人/组织主页;是否对外 announce(发到哪、怎么措辞由用户决定,不代发)。

## README 语言

面向公开 star 的仓库默认**英文为主**(受众最大化),用户的中文素材翻译过去;中文版放 `README.zh-CN.md` 并在两个 README 顶部互链。受众明确只在中文圈(用户说了算)才中文为主。

## 反面清单(报告里出现即指出)

- topics 凑满 20 个全是 `awesome` `tutorial` 一类大词,或塞了和仓库无关的热词。
- 徽章墙(>5 个)或假徽章(badge 指向不存在的 workflow)。
- README 全是口号和 emoji,滚动 3 屏还看不到一条可复制命令。
- description 与 README 首句说法矛盾(改过一端忘了另一端)。
