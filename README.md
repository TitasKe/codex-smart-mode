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
/smart --why "fix auth bug in production"
/smart doctor
/smart config init
/smart models
/smart release-check
csmart "fix the failing tests"
csmart "explain what this script does"
csmart exec "summarize this repo"
csmart resume --last "continue and verify the change"
csmart review --uncommitted "focus on regressions"
csmart --dry-run "design a new billing architecture"
```

Bare `codex-smart`, `csmart`, or `/smart` prints status and examples instead of trying to start an empty Codex session.

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

Explain a route without launching Codex:

```bash
csmart --why "fix auth bug in production"
```

## Maintenance

```bash
csmart doctor          # check install health
csmart status          # print status and examples
csmart models          # list Codex models from `codex debug models`
csmart release-check   # syntax, secrets, git author, and release checks
csmart uninstall       # remove installed binaries and the managed /smart function
```

The installer also installs a standalone uninstaller:

```bash
codex-smart-uninstall
```

## Config

Create a user config:

```bash
csmart config init
```

User config path:

```bash
csmart config path
```

Project-level overrides can be placed in `.codex-smart.env` at the workspace root. Project config overrides user config, and environment variables override both.

Supported config keys:

```bash
NANO_MODEL=gpt-5.4-mini
LIGHT_MODEL=gpt-5.4-mini
STANDARD_MODEL=gpt-5.5
DEEP_MODEL=gpt-5.5
ARCHITECT_MODEL=gpt-5.5
PLAN_SANDBOX=read-only
IMPL_SANDBOX=workspace-write
PLAN_APPROVAL=never
IMPL_APPROVAL=on-request
EXTRA_PLAN_RE=
EXTRA_IMPL_RE=
EXTRA_DEEP_RE=
EXTRA_ARCHITECT_RE=
EXTRA_SEARCH_RE=
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
uninstall.sh   # removes installed files and the managed /smart function
README.md      # this file
```
