class OpenLoops < Formula
  desc "Recupere o contexto de trabalhos pausados: o que começou, onde parou, qual o próximo passo"
  homepage "https://github.com/carvalhosauro/open-loops"
  version "1.6.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/carvalhosauro/open-loops/releases/download/v1.6.2/open-loops-aarch64-apple-darwin.tar.xz"
      sha256 "281a33bce8be650e3ac7a3d42c773ad777c39e24b59648c594e4e99dd0621134"
    end
    if Hardware::CPU.intel?
      url "https://github.com/carvalhosauro/open-loops/releases/download/v1.6.2/open-loops-x86_64-apple-darwin.tar.xz"
      sha256 "c5b989d88e26c883b7b5970906711925e393f416aee1dae613357b62ed90d36b"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/carvalhosauro/open-loops/releases/download/v1.6.2/open-loops-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "52210c74b369272a051db1d33ef0a4372cc9070559ea5127ce6b644c5b542780"
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
