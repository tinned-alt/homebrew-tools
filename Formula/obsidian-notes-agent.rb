class ObsidianNotesAgent < Formula
  include Language::Python::Virtualenv

  desc "AI-powered agent for managing Obsidian notes with Claude"
  homepage "https://github.com/tinned-alt/notes-agent"
  url "https://github.com/tinned-alt/notes-agent/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "a60dc12e32cf3d73da57b5e569bca934b3ddadfdf08a78e6bdb316a0b1d17b66"
  license "MIT"

  depends_on "python@3.12"

  def install
    # Create venv
    venv = virtualenv_create(libexec, "python3.12")
    
    # Install using system pip (since venv uses --system-site-packages)
    system Formula["python@3.12"].opt_bin/"python3.12", "-m", "pip", "install", 
           "--target=#{libexec}/lib/python3.12/site-packages",
           "--no-deps", buildpath
    
    # Now install dependencies
    system Formula["python@3.12"].opt_bin/"python3.12", "-m", "pip", "install",
           "--target=#{libexec}/lib/python3.12/site-packages",
           "-r", buildpath/"requirements.txt"
    
    # Create wrapper script
    (bin/"notes").write_env_script(libexec/"bin/notes", PYTHONPATH: "#{libexec}/lib/python3.12/site-packages:$PYTHONPATH")
  end

  def post_install
    config_dir = Pathname.new(Dir.home) / ".config" / "obsidian-notes-agent"
    config_dir.mkpath
    config_dir.chmod 0700
  end

  def caveats
    <<~EOS
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
