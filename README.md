# VaultAI Code

AI coding agent for your terminal, connected to your self-hosted VaultAI instance.

## Install

**One command:**

```bash
curl -fsSL https://raw.githubusercontent.com/VaultAI-EU/vaultai_release/main/install.sh | bash
```

This downloads the right binary for your platform and adds it to your PATH. No runtime dependencies needed.

**Manual download:** grab the binary for your platform from [Releases](https://github.com/VaultAI-EU/vaultai_release/releases).

**Homebrew (macOS):**

```bash
brew install VaultAI-EU/tap/vaultai-code
```

## Quick Start

```bash
# Launch interactive TUI
vaultai

# Connect to your VaultAI instance
vaultai auth login https://your-instance.vaultai.eu

# One-shot mode
vaultai -p "explain this function"

# Pipe mode
cat error.log | vaultai -p "what went wrong?"
```

## Usage

```
vaultai [options] [prompt...]

Options:
  -m, --model <model>          Model to use
  --mode <mode>                Starting mode (plan, default, trust)
  -p, --print                  One-shot mode: print response and exit
  --server <url>               VaultAI server URL
  --max-turns <n>              Max conversation turns (default: 50)
  --system-prompt <prompt>     Override system prompt
  --dangerously-skip-permissions  Skip all permission checks

Subcommands:
  auth login [url]             Login to a VaultAI instance
  auth logout                  Clear saved credentials
  auth status                  Show current auth status
```

## Supported Platforms

| Platform | Architecture | Status |
|----------|-------------|--------|
| macOS | Apple Silicon (arm64) | Supported |
| macOS | Intel (x64) | Supported |
| Linux | x64 (glibc) | Supported |
| Linux | x64 (musl) | Supported |
| Linux | arm64 (glibc) | Supported |
| Linux | arm64 (musl) | Supported |
| Windows | x64 | Supported |

## Update

VaultAI Code checks for updates automatically on startup. You can also run:

```bash
vaultai update
```

## License

Proprietary. See [vaultai.eu](https://vaultai.eu) for details.
