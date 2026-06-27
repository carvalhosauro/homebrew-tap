class OpenLoops < Formula
  desc "Recupere o contexto de trabalhos pausados: o que começou, onde parou, qual o próximo passo"
  homepage "https://github.com/carvalhosauro/open-loops"
  version "1.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/carvalhosauro/open-loops/releases/download/v1.3.0/open-loops-aarch64-apple-darwin.tar.xz"
      sha256 "7ba326c686daec3db54fe3c6d153a5390ece7592ea2c85c861b15ca689215e66"
    end
    if Hardware::CPU.intel?
      url "https://github.com/carvalhosauro/open-loops/releases/download/v1.3.0/open-loops-x86_64-apple-darwin.tar.xz"
      sha256 "dfd279abc82e7aff31e53764ae7e27a1b6205270fee1c3378619b021d5ce372f"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/carvalhosauro/open-loops/releases/download/v1.3.0/open-loops-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "0f4c3dde43a8f4afa880e8a3df7c9e570f7d918b25532c0c829ac166cfeb402d"
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "loops" if OS.mac? && Hardware::CPU.arm?
    bin.install "loops" if OS.mac? && Hardware::CPU.intel?
    bin.install "loops" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
