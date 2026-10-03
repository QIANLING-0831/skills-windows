<p align="center"><img src=".github/readme/banner.svg" alt="Skills for Windows — 面向 Windows 的技能工具集" width="100%"></p>

<h1 align="center">Skills for Windows · 面向 Windows 的技能工具集</h1>

<p align="center">将 Matt Pocock 技能集适配为 Windows 安装与日常使用流程。</p>

<p align="center"><img src="https://img.shields.io/badge/docs-%E4%B8%AD%E6%96%87-38bdf8?style=flat-square&amp;labelColor=172033" alt="docs: 中文"> <img src="https://img.shields.io/badge/maintainer-QIANLING-0831-38bdf8?style=flat-square&amp;labelColor=172033" alt="maintainer: QIANLING-0831"> </p>

<p align="center"><a href="#快速安装">快速安装</a> &nbsp; · &nbsp; <a href="#其他命令">其他命令</a> &nbsp; · &nbsp; <a href="#目录结构">目录结构</a> &nbsp; · &nbsp; <a href="#迁移说明">迁移说明</a></p>

---

## 项目概览

| 方向 | 内容 |
| --- | --- |
| **一键安装** | 复制到用户技能目录 |
| **更新方式** | 支持目录联接与多客户端目录 |
| **Windows 适配** | PowerShell 脚本、路径与钩子模板 |

Matt Pocock `skills-1.1.0` 的 Windows / Codex 版本，独立放在这个文件夹里。

## 快速安装

在 PowerShell 中运行：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1
```

默认会把所有技能复制到 `%USERPROFILE%\.codex\skills`，Codex 重启后会读取到这些技能。已有同名技能默认会被覆盖；想保留现有版本时加 `-NoOverwrite`。

## 其他命令

```powershell
# 查看技能列表
.\scripts\list-skills.ps1

# 用目录联接（junction）安装，方便后续直接跟着本文件夹更新
.\scripts\link-skills.ps1 -Mode Junction -Force

# 卸载已安装的本套技能
.\uninstall.ps1
```

`link-skills.ps1` 默认目标也是 `%USERPROFILE%\.codex\skills`，可以加 `-IncludeClaude`、`-IncludeAgents` 把技能同时装到其他 agent 的目录。

## 目录结构

```text
skills/
  engineering/      日常代码工作技能
  productivity/     非代码工作流技能
  misc/             备用技能
  personal/         个人设置相关技能
  in-progress/      草稿技能
scripts/
  link-skills.ps1   安装 / 联接脚本
  list-skills.ps1   列出所有技能
docs/               技能文档
install.ps1         一键安装到 Codex
uninstall.ps1       一键卸载
```

## 迁移说明

相对原版 `skills-1.1.0` 的改动：

- `scripts/link-skills.sh`、`scripts/list-skills.sh` 改为 PowerShell 版本。
- `diagnosing-bugs` 的 HITL 脚本改为 `hitl-loop.template.ps1`。
- `wizard` 改为 PowerShell 模板 `template.ps1`。
- `git-guardrails-claude-code` 改为 `.ps1 + .cmd` 钩子，不再需要 `chmod`。
- `obsidian-vault` 使用 Windows 路径，可通过 `OBSIDIAN_VAULT` 环境变量覆盖。
- `grep`、`find`、`mkdir -p` 等 Unix 命令替换为 PowerShell / `rg` 等价写法。
- 原版按 `~/.claude/skills` 做符号链接；本版默认复制到 Codex 技能目录，也可用 junction。

原始许可证和技能内容版权归 Matt Pocock 原仓库所有（MIT）。
