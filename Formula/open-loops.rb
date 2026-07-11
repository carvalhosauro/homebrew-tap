class OpenLoops < Formula
  desc "Recupere o contexto de trabalhos pausados: o que começou, onde parou, qual o próximo passo"
  homepage "https://github.com/carvalhosauro/open-loops"
  version "1.6.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/carvalhosauro/open-loops/releases/download/v1.6.1/open-loops-aarch64-apple-darwin.tar.xz"
      sha256 "83e4f5600543b3e5c5c247fb961dae6509813e4e2baad91be546f0035fd9b71e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/carvalhosauro/open-loops/releases/download/v1.6.1/open-loops-x86_64-apple-darwin.tar.xz"
      sha256 "77d4e6a18faa46c9c887b46f666124c730ee724ca820589f36e5e35bc820ebee"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/carvalhosauro/open-loops/releases/download/v1.6.1/open-loops-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "bd74e1a59efbcb7beb33008c78aaa2493c51c04b8387b89a38e0e68e48fd3d87"
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
