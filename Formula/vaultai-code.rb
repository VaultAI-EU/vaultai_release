class VaultaiCode < Formula
  desc "AI coding agent for your terminal, connected to your VaultAI instance"
  homepage "https://github.com/VaultAI-EU/vaultai_release"
  version "0.9.10"
  license :cannot_represent

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/VaultAI-EU/vaultai_release/releases/download/vaultai-code-v0.9.10/vaultai-code-darwin-arm64.zip"
      sha256 "c7f085b1f617185d92af6c9f6620e21c10b45454cc3b71a6b58e243d869524f2"
    else
      url "https://github.com/VaultAI-EU/vaultai_release/releases/download/vaultai-code-v0.9.10/vaultai-code-darwin-x64.zip"
      sha256 "PLACEHOLDER_DARWIN_X64"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/VaultAI-EU/vaultai_release/releases/download/vaultai-code-v0.9.10/vaultai-code-linux-arm64.tar.gz"
      sha256 "3447d4020b6aab79b44c8d5d8874cb687730ccf718f2943d237701ceeee92ddc"
    else
      url "https://github.com/VaultAI-EU/vaultai_release/releases/download/vaultai-code-v0.9.10/vaultai-code-linux-x64.tar.gz"
      sha256 "26f5d0338f799add50dcb4f4d3bbcb92aaa2654d176b1923f31d9681d5b4be34"
    end
  end

  def install
    bin.install "vaultai-code"
    bin.install_symlink "vaultai-code" => "vaultai"
  end

  test do
    assert_match "vaultai-code", shell_output("#{bin}/vaultai-code --version")
  end
end
