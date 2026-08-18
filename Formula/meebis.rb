class Meebis < Formula
  desc "A fast, disposable, in-memory Redis-compatible server for ephemeral dev work"
  homepage "https://github.com/mileszim/meebis"
  version "0.12.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mileszim/meebis/releases/download/v0.12.0/meebis-aarch64-apple-darwin.tar.xz"
      sha256 "b65e205847492cf52b6607d020ca2e89f651657081f61a2a6a9c456aacaf8972"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mileszim/meebis/releases/download/v0.12.0/meebis-x86_64-apple-darwin.tar.xz"
      sha256 "a95cf0c43819a643e26fbcfaaab805c6b42054b2866fa0b98835d0aa05a944c8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mileszim/meebis/releases/download/v0.12.0/meebis-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "98d5df0527aa6da0ed2d17719afbdb6ec601bf154bf896f50fa07093ea2f987a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mileszim/meebis/releases/download/v0.12.0/meebis-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "677454f82985a0e41b39bd7493f58195a19a2a9e93d113f5d613685156538239"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "meebis"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "meebis"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "meebis"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "meebis"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
