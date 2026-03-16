#!/bin/bash
# VaultAI Code — Installation Script
# Usage: curl -fsSL https://raw.githubusercontent.com/VaultAI-EU/vaultai_release/main/install.sh | bash

set -e

REPO="VaultAI-EU/vaultai_release"
BINARY_NAME="vaultai-code"
INSTALL_DIR="${VAULTAI_INSTALL_DIR:-${HOME}/.vaultai/bin}"

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

print_banner() {
    echo -e "${BLUE}${BOLD}"
    cat << 'EOF'
 █   █ █▀▀█ █  █ █    ▀█▀   █▀▀█ ▀█▀
 █   █ █▄▄█ █  █ █     █    █▄▄█  █
  █▄█  █  █ █▄▄█ █▄▄▄ ▄█▄   █  █ ▄█▄
               CODE
EOF
    echo -e "${NC}"
    echo -e "${DIM}AI coding agent for your VaultAI instance${NC}"
    echo ""
}

detect_platform() {
    local os arch

    os=$(uname -s | tr '[:upper:]' '[:lower:]')
    arch=$(uname -m)

    case "$arch" in
        x86_64|amd64) arch="x64" ;;
        aarch64|arm64) arch="arm64" ;;
        *) echo -e "${RED}Unsupported architecture: $arch${NC}"; exit 1 ;;
    esac

    case "$os" in
        darwin)
            PLATFORM="vaultai-code-darwin-$arch"
            ARCHIVE_EXT="zip"
            ;;
        linux)
            local libc=""
            if ldd --version 2>&1 | grep -qi musl; then
                libc="-musl"
            fi
            PLATFORM="vaultai-code-linux-$arch$libc"
            ARCHIVE_EXT="tar.gz"
            ;;
        mingw*|msys*|cygwin*)
            PLATFORM="vaultai-code-windows-x64"
            BINARY_NAME="vaultai-code.exe"
            ARCHIVE_EXT="zip"
            ;;
        *)
            echo -e "${RED}Unsupported OS: $os${NC}"
            exit 1
            ;;
    esac

    echo -e "  Platform: ${GREEN}$PLATFORM${NC}"
}

get_latest_release() {
    echo -e "  Fetching latest release..."
    LATEST_RELEASE=$(curl -sL "https://api.github.com/repos/$REPO/releases/latest" 2>/dev/null | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')

    if [ -z "$LATEST_RELEASE" ]; then
        echo -e "${RED}No release found. Please check https://github.com/$REPO/releases${NC}"
        exit 1
    fi

    echo -e "  Version:  ${GREEN}$LATEST_RELEASE${NC}"
}

download_binary() {
    local tmp_dir
    tmp_dir=$(mktemp -d)

    local download_url="https://github.com/$REPO/releases/download/$LATEST_RELEASE/$PLATFORM.$ARCHIVE_EXT"
    echo -e "  Downloading..."

    if ! curl -fSL "$download_url" -o "$tmp_dir/archive.$ARCHIVE_EXT" 2>/dev/null; then
        echo -e "${RED}Download failed: $download_url${NC}"
        echo -e "${YELLOW}This platform may not have a pre-built binary yet.${NC}"
        rm -rf "$tmp_dir"
        exit 1
    fi

    mkdir -p "$INSTALL_DIR"

    if [ "$ARCHIVE_EXT" = "tar.gz" ]; then
        tar -xzf "$tmp_dir/archive.tar.gz" -C "$tmp_dir"
    else
        unzip -q "$tmp_dir/archive.zip" -d "$tmp_dir"
    fi

    # Install main binary as vaultai-code
    mv "$tmp_dir/vaultai-code"* "$INSTALL_DIR/$BINARY_NAME"
    chmod +x "$INSTALL_DIR/$BINARY_NAME"

    # Create `vaultai` symlink (short command)
    local short="vaultai"
    if [ "$BINARY_NAME" = "vaultai-code.exe" ]; then
        short="vaultai.exe"
    fi
    ln -sf "$BINARY_NAME" "$INSTALL_DIR/$short"

    rm -rf "$tmp_dir"
}

setup_path() {
    local shell_rc=""
    local shell_name
    shell_name=$(basename "$SHELL")

    case "$shell_name" in
        bash) shell_rc="$HOME/.bashrc" ;;
        zsh) shell_rc="$HOME/.zshrc" ;;
        fish) shell_rc="$HOME/.config/fish/config.fish" ;;
        *) shell_rc="$HOME/.profile" ;;
    esac

    if [[ ":$PATH:" == *":$INSTALL_DIR:"* ]]; then
        return
    fi

    echo ""
    if [ "$shell_name" = "fish" ]; then
        local path_line="fish_add_path $INSTALL_DIR"
    else
        local path_line="export PATH=\"\$PATH:$INSTALL_DIR\""
    fi

    read -p "  Add to PATH automatically? ($shell_rc) [Y/n] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
        if [ "$shell_name" = "fish" ]; then
            fish -c "fish_add_path $INSTALL_DIR" 2>/dev/null || true
        else
            echo "$path_line" >> "$shell_rc"
        fi
        echo -e "  ${GREEN}PATH updated.${NC} Restart your terminal or run: ${BOLD}source $shell_rc${NC}"
    else
        echo -e "  Add this to your shell config:"
        echo -e "    ${BOLD}$path_line${NC}"
    fi
}

main() {
    print_banner
    detect_platform
    get_latest_release
    download_binary

    echo ""
    echo -e "${GREEN}${BOLD}  Installation complete!${NC}"
    echo ""
    echo -e "  Installed to: ${BLUE}$INSTALL_DIR/$BINARY_NAME${NC}"

    local version
    version=$("$INSTALL_DIR/$BINARY_NAME" --version 2>/dev/null || echo "")
    if [ -n "$version" ]; then
        echo -e "  Version:     ${GREEN}$version${NC}"
    fi

    setup_path

    echo ""
    echo -e "  ${BOLD}Quick Start:${NC}"
    echo ""
    echo -e "    ${GREEN}vaultai${NC}                              Launch the TUI"
    echo -e "    ${GREEN}vaultai auth login${NC} ${DIM}<url>${NC}             Connect to your instance"
    echo -e "    ${GREEN}vaultai -p${NC} ${DIM}\"fix the bug\"${NC}            One-shot mode"
    echo ""
}

main "$@"
