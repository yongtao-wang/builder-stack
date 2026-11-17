# builder-stack

[English](README.md) | **简体中文**

面向中小型项目的 Claude Code 技能包。它从 [pstack](https://github.com/cursor/plugins/tree/main/pstack)（Lauren Tan）的 Claude Code 移植版 [pstack-claude](https://github.com/michael-denyer/pstack-claude) 裁剪而来，只保留"先验证、再交付"的核心流程。

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

MIT。上游版权和许可文件都已保留，详见 [NOTICE.md](NOTICE.md)。
