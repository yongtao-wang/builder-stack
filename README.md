# builder-stack

面向中小型项目的 Claude Code 技能包。它从 [pstack](https://github.com/cursor/plugins/tree/main/pstack)（Lauren Tan）的 Claude Code 移植版 [pstack-claude](https://github.com/michael-denyer/pstack-claude) 裁剪而来，只保留"先验证、再交付"的核心流程。

A lean, verification-first Claude Code skill pack for small and medium projects, trimmed from pstack.

## 安装

```text
/plugin marketplace add yongtao-wang/builder-stack
/plugin install builder@builder-stack
```

装好后先运行一次 `/builder:setup-builder`。它会做三件事：按角色分配模型、决定是否开启 SessionStart 钩子、为项目生成 verify 技能。

## 日常用法

```text
/builder:builder-mode 登录后偶尔跳回首页。先复现，再修复并验证。
/builder:builder-mode 新增导出 CSV 功能。不要改现有 API。
/builder:builder-mode 搞清楚缓存为什么在登出后还在。先不要改代码。
```

builder-mode 会根据请求选一个 playbook，把它的步骤原样抄进任务列表，并要求拿到证据之后才能报告完成。模式是"粘住"的：之后说"继续"会沿用同一个 playbook，换任务时说"new task"。

好的提示应写清三件事：目标、完成条件、哪些东西不能改。

## 包含什么

**核心**

| 技能 | 作用 |
| --- | --- |
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
| `maintain-verification-skill` | create-verification-skill |
| `setup-builder` | builder-mode 的模型配置 |
| 24 个 `principle-*` 原则 | builder-mode 的原则索引 |
| 子 agent `builder-agent`、`comment-sicko` | builder-mode、no-comments |

## 控制成本

`arena`、`architect` 和 `interrogate` 会同时启动多个模型。默认配置是 opus、fable、sonnet、haiku 各跑一份。如果是中小项目，建议在 `/builder:setup-builder` 里把这几个角色缩减到一到两个模型，或者在提示里直接写"不要用 arena"。

小任务（只改一个文件、检查方式很明显的改动，或者一行代码的修改）不需要进入 builder-mode。

## 许可

MIT。上游版权和许可文件都已保留，详见 [NOTICE.md](NOTICE.md)。
