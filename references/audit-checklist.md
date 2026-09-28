# 体检清单

逐项检查并记录。每维度按完成度给 0-5 分。

优先级含义:

- **P0**:损害信任或让人看不懂,必须修。
- **P1**:对 star 转化影响大,优先安排。
- **P2**:打磨项,有余力再做。

## 1. 第一印象(首屏 30 秒)

| 项 | 怎么判定 | 优先级 | 修法 |
|---|---|---|---|
| 一句话价值主张 | 遮住标题只读标题下第一段,3 秒内能否答出"这是什么、给我什么好处" | P0 | `做什么 + 给谁 + 核心差异`;把 "blazing fast" 换成数字或事实 |
| 演示素材 | 首屏有无 GIF / 截图 / asciinema | P1 | CLI 和有界面的项目几乎必备;放 `docs/` 下并用相对路径引用 |
| 徽章克制且真实 | 徽章 ≤5 个,每个指向真实目标(CI workflow、registry、LICENSE) | P1 | 只留 CI、最新版本、license 三类;删纯装饰徽章 |
| README 语言 | 公开仓库是否英文为主,中文版是否互链 | P1 | 英文为主,`README.zh-CN.md` 互链;受众只在中文圈除外 |
| 仓库名与描述一致 | 名字、description、README 首句三者说的是同一个项目 | P0 | 改过一端就同步另一端 |

## 2. 快速上手

| 项 | 怎么判定 | 优先级 | 修法 |
|---|---|---|---|
| 安装命令可复制 | 有 fenced code block,单一推荐路径,注明前置要求(语言版本、系统依赖) | P0 | 多渠道安装时给一个主推,其余折叠到文档 |
| 示例带预期输出 | 最小示例是否展示了"运行后应该看到什么" | P0 | 补一段真实的预期输出;跑不出来就说明示例已过期 |
| 命令在仓库内可验证 | README 里的 install/run 命令与 `package.json` scripts / `pyproject.toml` / `Makefile` 一致 | P0 | 逐条对;对不上要么改 README 要么改脚本名 |
| 常见失败有兜底 | 缺系统依赖、版本不匹配等高频问题有无 FAQ / troubleshooting | P2 | 从 issue 区找 2-3 个高频问题写进 README |

## 3. 可信度

| 项 | 怎么判定 | 优先级 | 修法 |
|---|---|---|---|
| LICENSE 文件 | 根目录或 GitHub About 区有无 license(无则显示 "no license",很多开发者直接关页) | P0 | 问用户选 MIT / Apache-2.0,给一行取舍 |
| CI 且绿 | 有 `.github/workflows`,README 徽章是 passing | P1 | 没有就建最小 CI(安装 + 测试);红了先修再放徽章 |
| 有测试 | 仓库里能找到测试目录或测试脚本 | P1 | README 的"可信度"很大程度来自可见的测试 |
| Release / CHANGELOG | 有 tag 或 release;版本可预期 | P1 | 打第一个 tag;后续用 changelog 或 GitHub Releases 记录 |
| 最近活跃 | pushedAt 距今 < 6 个月;archived 仓库先确认再决定是否还做优化 | P1 | archived 的仓库不优化门面,先问用户意图 |
| 链接无死链 | README、description、homepage 里的链接都能打开 | P2 | 逐个点;死链比没链接更伤 |

## 4. 内容结构

| 项 | 怎么判定 | 优先级 | 修法 |
|---|---|---|---|
| Why → What → How | 先问题,再方案,再上手;不是一上来就 API 列表 | P1 | 把动机段提到安装段之前 |
| 特性列表具体 | 每条 = 能力 + 证据,而非形容词堆叠 | P1 | 每条特性后跟一个事实(数字、对比、示例链接) |
| 与替代品对比 | 有无和最相近 1-2 个工具的对比表 | P2 | 开发者会搜 "x vs y";对比要公平,写清各自适用场景 |
| examples/ 目录 | 有示例目录且 README 链接到它 | P2 | 哪怕 2-3 个最小示例 |
| 坦诚边界 | 有 limitations / not-yet 支持的说明 | P2 | 坦诚反而降低退货率,提高 star 保留率 |

## 5. 可发现性

| 项 | 怎么判定 | 优先级 | 修法 |
|---|---|---|---|
| topics 数量与配比 | 10-15 个,品类/技术栈/问题域/独有词四类都有(策略见 topics.md) | P0 | 免费流量入口,最常见的缺口 |
| description 含核心词 | 一句话内含开发者会搜的关键词,不堆砌 | P1 | GitHub 搜索索引 name + description + topics + README |
| homepage 已填 | About 区有项目主页或文档链接 | P1 | 没有独立站点就指向 docs 目录或最新 release |
| README 小节用开发者会搜的词 | 小节标题里出现问题域关键词 | P2 | GitHub 搜索索引 README 正文 |
| 已 pin 到主页 | REST API 查不到;需要时用 GraphQL 查 `user.pinnedItems`,否则直接列为手动提醒项 | P2 | 手动操作,报告里提醒用户 |
| issue labels 有贡献者入口 | 有 `good first issue` 等 label | P2 | 贡献者漏斗;对 star 是间接信号 |

## 6. 门面细节

| 项 | 怎么判定 | 优先级 | 修法 |
|---|---|---|---|
| social preview 图 | **无 API 可判定是否已上传**,标"待用户确认",别浪费往返去试 | P1 | 1280×640(GitHub 官方推荐),把首屏信息浓缩成一张图;**手动上传**(Settings → General → Social preview) |
| 无死链的徽章/图片 | README 里的图片都能加载(移动端网络下也尽量小) | P2 | GIF 控制在 10MB 内,否则压缩或换截图 |
| About 区整洁 | description、topics、homepage 齐而不乱 | P2 | 一处一个事实,不重复 |
