# builder-stack

[English](README.md) | **简体中文**

面向中小型项目的 Claude Code 技能包。它从 [pstack](https://github.com/cursor/plugins/tree/main/pstack)（Lauren Tan）的 Claude Code 移植版 [pstack-claude](https://github.com/michael-denyer/pstack-claude) 裁剪而来，只保留"先验证、再交付"的核心流程。

## 为什么要做 builder-stack

pstack 面向的是长周期、跨多种 agent 运行环境的工程项目：67 个技能、23 个 playbook，还要适配十来种 agent 运行环境。大多数中小项目只用得到其中一小部分，剩下的内容依然会占用上下文和注意力。builder-stack 保留了"先验证、再交付"的核心，并补上了小团队日常需要的几道护栏。

| | pstack-claude | builder-stack |
| --- | --- | --- |
| 规模 | 67 个技能、23 个 playbook | 45 个技能、3 个 playbook（Investigation、Bug fix、Feature），外加收尾用的 Opening a PR |
| 运行环境 | 十来种 agent 运行环境 | 只支持 Claude Code，不用再读其他平台的适配说明 |
| 计划 | 在 playbook 内部做计划，做完直接动手 | 写出计划，等你批准后才改代码 |
| 项目初始化 | 只配置模型表和钩子（`setup-pstack`） | `init` 还会生成受管理的 AGENTS.md 区块和 CLAUDE.md 导入，写入前先给你看 diff |
| AGENTS.md 规则 | 不生成 | 条件式的"When…"规则，加上默认留空（`TODO`）的 Commands 和 Patterns 表格，不预设任何语言或框架 |
| TDD | 只用于有便宜测试路径的 bug 修复 | Feature 中的行为变更也适用 |
| 文档 | 没有更新文档这一步 | Bug fix 和 Feature 都会在同一次改动里更新文档和 feature map |
| Known issues | 不查 | Bug fix 第一步先查 known-issues 文档，发现了不打算修的问题就记一条 |
| 小任务 | 由会话钩子路由 | 只改一个文件、检查方式明显的改动直接做，不走 playbook |

### 适合什么场景

- 你用 Claude Code，个人开发或者小团队。
- 项目规模中小，模块不多，而不是一堆微服务。
- 你希望 agent 改代码之前，先让你批准计划。
- 你希望每个仓库都从同一种 AGENTS.md 结构起步，随着项目推进再逐步补齐。

### 什么时候该用 pstack

- 你还会用 Cursor、Codex 等其他运行环境。
- 任务跨好几天、涉及很多个连续的 PR，或者需要盯 CI、自动发布、性能爬坡。这些 playbook 在这里都删掉了。
- 你希望 agent 默认无人值守运行。builder-stack 也能做到，但只有在你明确写"autonomous"时才会这样。

## 安装

```text
/plugin marketplace add yongtao-wang/builder-stack
/plugin install builder@builder-stack
```

装完后重启 Claude Code，或者新开一个会话。如果仓库是私有的，Claude Code 需要能访问你的 GitHub（比如本机已登录 `gh`，或者配置了 git 凭据）。

更新到新版本：运行 `/plugin marketplace update builder-stack`；如果插件没有自动更新，运行 `/plugin` 手动更新。卸载：运行 `/plugin uninstall builder@builder-stack`。

装好后，在项目根目录运行一次：

```text
/builder:init
```

init 会依次完成以下几件事，每一步写文件前都会先征求你的同意：

1. 配置模型和 SessionStart 钩子（调用 `setup-builder`）。
2. 询问是否生成 verify 技能和 feature map（调用 `create-verification-skill`）。
3. 查找项目里的架构文档和 known-issues 文档。找不到时，问你是创建一个空模板，还是不加相关规则。
4. 在 `AGENTS.md` 末尾追加一段用 `<!-- builder:start -->` 和 `<!-- builder:end -->` 包起来的内容，并让 `CLAUDE.md` 导入 `@AGENTS.md`。写入前会先给你看 diff。

追加的内容包括：Commands 表格、Patterns 表格、条件式规则，以及一个空的 Do not touch 段落。Commands 和 Patterns 默认都是 `TODO`，因为 init 不会预设项目用什么语言或框架；agent 在命令第一次跑通时会自己补上。重复运行 init 只会替换标记之间的内容，你在别处写的东西不会被改动。

## 日常用法

```text
/builder:builder-mode 登录后偶尔跳回首页。先复现，再修复并验证。
/builder:builder-mode 新增导出 CSV 功能。不要改现有 API。
/builder:builder-mode 搞清楚缓存为什么在登出后还在。先不要改代码。
```

builder-mode 会根据请求选一个 playbook，把它的步骤原样抄进任务列表，并要求拿到证据之后才能报告完成。

**先计划，再动手。** Bug fix 和 Feature 两个 playbook 都会先做只读调研，然后写出计划，等你批准后才开始改代码。计划包括：目标、可验证的完成条件、要改的文件、先写哪个失败的测试、验证方式、要更新的文档、风险点。如果想跳过审批，在提示里写"autonomous"或"no plan approval"即可。你也可以先按 Shift+Tab 进入 Claude Code 的 plan mode，再调用 builder-mode。

模式是"粘住"的：之后说"继续"会沿用同一个 playbook，换任务时说"new task"。

好的提示应写清三件事：目标、完成条件、哪些东西不能改。

## 包含什么

**核心**

| 技能 | 作用 |
| --- | --- |
| `init` | 在项目里一次性完成 builder 的配置，包括生成 AGENTS.md 区块 |
| `builder-mode` | 总入口和路由，包含 Investigation、Bug fix、Feature 三个 playbook，以及收尾用的 Opening a PR |
| `create-verification-skill` | 为项目生成 `.claude/skills/verify/` 和 feature map |
| `correct` | 找出 agent 反复犯的错误，用架构、类型、lint 或测试把它堵住 |
| `tdd` | 先写失败的测试，再修复 |
| `how` | 讲清楚一个子系统怎么运作、改动应该放在哪里 |

**被核心技能直接引用的技能**

| 技能 | 被谁引用 |
| --- | --- |
| `why` | Bug fix、Investigation |
| `architect` | builder-mode、Bug fix、Feature |
| `arena` | Feature（实现方案有多种合理形状时必须使用），architect |
| `interrogate` | builder-mode、Feature |
| `in-your-own-words` | interrogate |
| `swarm` | builder-mode |
| `figure-it-out` | builder-mode（没有合适的 playbook 时） |
| `show-me-your-work` | builder-mode（长任务或无人值守任务） |
| `unslop`、`technical-writing`、`deslop`、`no-comments` | builder-mode、Opening a PR |
| `benchmark-checklist` | builder-mode（报告性能数字之前） |
| `maintain-verification-skill` | create-verification-skill、init |
| `setup-builder` | builder-mode 的模型配置、init |
| 24 个 `principle-*` 原则 | builder-mode 的原则索引 |
| 子 agent `builder-agent`、`comment-sicko` | builder-mode、no-comments |

## 控制成本

`arena`、`architect` 和 `interrogate` 会同时启动多个模型。默认配置是 opus、fable、sonnet、haiku 各跑一份。如果是中小项目，建议在 `/builder:setup-builder` 里把这几个角色缩减到一到两个模型，或者在提示里直接写"不要用 arena"。

小任务（只改一个文件、检查方式很明显的改动，或者一行代码的修改）不需要进入 builder-mode。

## 许可

MIT。所有上游版权声明都合并在 [LICENSE](LICENSE) 里，来源说明见 [NOTICE.md](NOTICE.md)。
