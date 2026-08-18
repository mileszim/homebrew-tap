class Meebis < Formula
  desc "A fast, disposable, in-memory Redis-compatible server for ephemeral dev work"
  homepage "https://github.com/mileszim/meebis"
  version "0.13.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mileszim/meebis/releases/download/v0.13.0/meebis-aarch64-apple-darwin.tar.xz"
      sha256 "30c840c3308904a6181e925763e3336a44c55aee110d9c54cdcb0b520ffd8a62"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mileszim/meebis/releases/download/v0.13.0/meebis-x86_64-apple-darwin.tar.xz"
      sha256 "79a7bc83ea96fdb9e6e7bfd48a02f241bea002f8339d2a2d2c5bf8a88f0f6dee"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mileszim/meebis/releases/download/v0.13.0/meebis-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "984b1b8a73025e8cdb2002d1cd731fdeb13cc179e54b7fd0ae5d788c1e699c8a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mileszim/meebis/releases/download/v0.13.0/meebis-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "556197e8bdad24b2c84bdb60ce0bfd8fdb04d00e9aa1937064b25bb4b1f8326c"
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
