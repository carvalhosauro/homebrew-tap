class OpenLoops < Formula
  desc "Recupere o contexto de trabalhos pausados: o que começou, onde parou, qual o próximo passo"
  homepage "https://github.com/carvalhosauro/open-loops"
  version "1.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/carvalhosauro/open-loops/releases/download/v1.5.0/open-loops-aarch64-apple-darwin.tar.xz"
      sha256 "7d6537a94245bf0bf9e47cb0fd078a2a8ed59bb552e76a5ed974a71fbaf4a0e1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/carvalhosauro/open-loops/releases/download/v1.5.0/open-loops-x86_64-apple-darwin.tar.xz"
      sha256 "86dff3638bcbbcf150b4981f3c241bcf7967d9a8f067a7019a7905f81191f258"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/carvalhosauro/open-loops/releases/download/v1.5.0/open-loops-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "85433c87268837e52da5be57f4b54930e5bb87bb5613caf03b57ee241214fea4"
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
