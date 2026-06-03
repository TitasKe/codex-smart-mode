# codex-smart-mode

A Codex CLI smart launcher inspired by `claude-smart-mode`.

It classifies the task before Codex starts, then launches Codex with the selected model, reasoning effort, sandbox, approval policy, and optional web search.

## Install

```bash
git clone https://github.com/TitasKe/codex-smart-mode.git
cd codex-smart-mode
chmod +x install.sh codex-smart
./install.sh
```

The installer adds:

```bash
codex-smart
csmart
/smart
```

`csmart` is the short command. `/smart` is a zsh function installed through `~/.zshenv`, so it works in normal Terminal sessions and one-shot zsh commands. This does not replace the existing Claude `smart` alias.

## Usage

```bash
/smart "fix the failing tests"
/smart "explain what this script does"
csmart "fix the failing tests"
csmart "explain what this script does"
csmart exec "summarize this repo"
csmart resume --last "continue and verify the change"
csmart review --uncommitted "focus on regressions"
csmart --dry-run "design a new billing architecture"
```

## Routing

Complexity controls model and reasoning effort:

| Tier | Model | Effort | When |
| --- | --- | --- | --- |
| nano | `gpt-5.4-mini` | low | Typos, trivial lookups, one-liners |
| light | `gpt-5.4-mini` | medium | Small single-file work |
| standard | `gpt-5.5` | high | Normal implementation work |
| deep | `gpt-5.5` | xhigh | Hard bugs, auth, security, deploys, automation |
| architect | `gpt-5.5` | xhigh | Architecture, large refactors, new subsystems |

Nature controls Codex permissions:

| Nature | Sandbox | Approval | When |
| --- | --- | --- | --- |
| plan | read-only | never | Explain, review, analyze, plan, design, audit |
| impl | workspace-write | on-request | Implement, fix, build, test, run, deploy |

`architect` always forces `plan`.

Every run starts with a line like:

```text
[smart] tier=standard nature=impl model=gpt-5.5 effort=high sandbox=workspace-write approval=on-request search=off
```

## Overrides

```bash
csmart --tier deep "debug this flaky Playwright flow"
csmart --nature plan "review this migration"
csmart --model gpt-5.4 --effort medium "small change"
csmart --sandbox read-only --approval never "inspect only"
csmart --search on "use latest OpenAI docs"
```

Model defaults can be changed with environment variables:

```bash
export CODEX_SMART_NANO_MODEL=gpt-5.4-mini
export CODEX_SMART_LIGHT_MODEL=gpt-5.4-mini
export CODEX_SMART_STANDARD_MODEL=gpt-5.5
export CODEX_SMART_DEEP_MODEL=gpt-5.5
export CODEX_SMART_ARCHITECT_MODEL=gpt-5.5
```

## Difference from Claude smart mode

Claude Code supports slash commands and prompt hooks that can toggle behavior inside an already-running session.

Codex CLI routing is configured when a session starts or resumes through command flags such as `--model`, `--sandbox`, `--ask-for-approval`, `--search`, and `-c model_reasoning_effort=...`. This project therefore implements smart mode as a launcher:

```bash
/smart "your task"
csmart "your task"
```

That is the reliable Codex equivalent of Claude's `/smart task` from Terminal. For an existing Codex session, use:

```bash
/smart resume --last "your task"
```

Inside an already-open Codex chat, custom `/smart` slash handling depends on Codex's built-in slash-command support. The Terminal `/smart` function is the supported path here.

## Files

```text
codex-smart    # launcher
install.sh     # installs codex-smart and csmart into ~/.local/bin
README.md      # this file
```
