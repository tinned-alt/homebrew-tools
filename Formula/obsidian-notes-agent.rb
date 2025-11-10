class ObsidianNotesAgent < Formula
  include Language::Python::Virtualenv

  desc "AI-powered agent for managing Obsidian notes with Claude"
  homepage "https://github.com/tinned-alt/notes-agent"
  url "https://github.com/tinned-alt/notes-agent/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "0019dfc4b32d63c1392aa264aed2253c1e0c2fb09216f8e2cc269bbfb8bb49b5"
  license "MIT"

  depends_on "python@3.12"

  def install
    # Create isolated virtualenv
    virtualenv_create(libexec, "python3.12")
    
    # Install the package and all its dependencies
    system libexec/"bin/pip", "install", "--verbose", buildpath
    
    # Link the command
    bin.install_symlink libexec/"bin/notes"
  end

  def post_install
    config_dir = Pathname.new(Dir.home) / ".config" / "obsidian-notes-agent"
    config_dir.mkpath
    config_dir.chmod 0700
  end

  def caveats
    <<~EOS
      ╭──────────────────────────────────────────────────────────╮
      │  Obsidian Notes Agent installed successfully!            │
      ╰──────────────────────────────────────────────────────────╯

      🔧 First-time setup:
         notes config

      📖 Usage:
         notes chat              Interactive chat
         notes ingest <url>      Import content
         notes info              View configuration
    EOS
  end

  test do
    assert_match "Obsidian Notes Agent", shell_output("#{bin}/notes --help")
  end
end
