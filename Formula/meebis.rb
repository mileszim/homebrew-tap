class Meebis < Formula
  desc "A fast, disposable, in-memory Redis-compatible server for ephemeral dev work"
  homepage "https://github.com/mileszim/meebis"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mileszim/meebis/releases/download/v0.5.0/meebis-aarch64-apple-darwin.tar.xz"
      sha256 "efcfdbdb9b535d128bc27ace55a71e77678d29c5bb13f8b3557f4cded0ba7c3b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mileszim/meebis/releases/download/v0.5.0/meebis-x86_64-apple-darwin.tar.xz"
      sha256 "b7ba930712f98e7ffe9901e0605640b6591fe3af10f0af2147e1f77c37a7bc23"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mileszim/meebis/releases/download/v0.5.0/meebis-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2abdb974b56b3bdeed12f0766f9474ff8ed5572c51ac601a99d0bfbd330a5c85"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mileszim/meebis/releases/download/v0.5.0/meebis-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "86311cc2cf2cad636d99983fa2d2327a0e999969c55addc59d0730e78c4b6c5f"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "meebis" if OS.mac? && Hardware::CPU.arm?
    bin.install "meebis" if OS.mac? && Hardware::CPU.intel?
    bin.install "meebis" if OS.linux? && Hardware::CPU.arm?
    bin.install "meebis" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
