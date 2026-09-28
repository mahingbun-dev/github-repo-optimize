# github-repo-optimize

**一个 AI agent 技能:审计并打磨 GitHub 仓库的"门面"——topics 标签、README、description、信任信号——让项目更容易被发现、被信任、被 star。**

[English](README.md) | 中文

[![CI](https://github.com/mahingbun-dev/github-repo-optimize/actions/workflows/ci.yml/badge.svg)](https://github.com/mahingbun-dev/github-repo-optimize/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

多数仓库不是输在代码,而是输在开发者点进来的前 30 秒:描述说不清、About 区空着、徽章墙后面才出现第一条可复制命令、topics 只有三个泛词。这个技能给你的 AI 编码 agent(ZCode、Claude Code、Codex)一套能落地的清单,两种模式:

- **体检(audit)**——存量仓库。agent 只读采集事实,按六维度评分(第一印象/快速上手/可信度/内容结构/可发现性/门面细节),输出按 P0–P2 排序的建议清单;你不勾选,它不动手。
- **打样(scaffold)**——新仓库。按见效顺序配齐门面:先 description + topics,再 LICENSE、README 骨架、demo 图、social preview、第一个 release。

## 里面有什么

| 文件 | 作用 |
| --- | --- |
| `SKILL.md` | 工作流:模式选择、硬性原则(每个声明可追溯、push 必须单独确认)、报告格式、执行命令 |
| `references/audit-checklist.md` | 六维度清单,每项带判定方法、优先级和修法 |
| `references/topics.md` | topics 策略:四类配比、竞品调研流程、硬约束 |
| `scripts/collect-repo-facts.sh` | 一条命令经 `gh` 只读采集仓库事实(description、topics、README、release、CI) |

## 安装

```sh
git clone https://github.com/mahingbun-dev/github-repo-optimize
./github-repo-optimize/install.sh
```

默认装进 ZCode(`~/.agents/skills`)、Claude Code(`~/.claude/skills`)、Codex CLI(`~/.codex/skills`);用 `--tool=zcode|claude|codex` 只装一个。需要已安装并登录 [`gh` CLI](https://cli.github.com)。

## 60 秒上手

在工具里开一个**全新会话**,说:

```text
帮我看看 owner/repo 这个仓库,star 一直上不去,做个体检
```

agent 跑 `collect-repo-facts.sh`,按六维度评分,输出这样的报告:

| 维度 | 评分 | 一句话诊断 |
| --- | --- | --- |
| 第一印象 | 4/5 | 首句价值主张具体,但无 demo 图 |
| 可信度 | 2/5 | 无 release、无 CI 徽章 |
| 可发现性 | 2/5 | topics 缺问题域词 |

勾选你要的项,agent 才执行——`gh repo edit`、topics 重写、README 修改;`git push` 永远单独向你确认。

## 底线

- **你不点头,只读不动。** 体检不改任何东西;写操作逐项确认。
- **不做虚假吸引力。** 不买 star、不堆无关关键词、不放指向空处的徽章——报告发现这些反模式会直接点名。
- **每个声明可追溯。** README 里的话必须来自代码或你本人;查不到的数字标"待确认",不编造。

## License

[MIT](LICENSE)
