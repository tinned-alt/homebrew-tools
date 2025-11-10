class ObsidianNotesAgent < Formula
  include Language::Python::Virtualenv

  desc "AI-powered agent for managing Obsidian notes with Claude"
  homepage "https://github.com/tinned-alt/notes-agent"
  url "https://github.com/tinned-alt/notes-agent/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "a60dc12e32cf3d73da57b5e569bca934b3ddadfdf08a78e6bdb316a0b1d17b66"
  license "MIT"

  depends_on "python@3.12"

  def install
    # Use the standard virtualenv_install_with_resources but pass the source directly
    # This will create a proper venv with pip and install the package
    venv = virtualenv_create(libexec, "python3.12")
    
    # Bootstrap pip into the venv
    system libexec/"bin/python", "-m", "ensurepip"
    system libexec/"bin/pip", "install", "--upgrade", "pip", "setuptools", "wheel"
    
    # Install the package with all dependencies
    system libexec/"bin/pip", "install", buildpath
    
    # Link the notes command
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
         notes chat
         notes ingest <url>
         notes info
    EOS
  end

  test do
    assert_match "Obsidian Notes Agent", shell_output("#{bin}/notes --help")
  end
end
