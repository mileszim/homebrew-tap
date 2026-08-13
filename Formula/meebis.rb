class Meebis < Formula
  desc "A fast, disposable, in-memory Redis-compatible server for ephemeral dev work"
  homepage "https://github.com/mileszim/meebis"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mileszim/meebis/releases/download/v0.6.0/meebis-aarch64-apple-darwin.tar.xz"
      sha256 "be1bbecfa9736bc830169ef848f9cf479a89354c226350f28af4ead8fa188c78"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mileszim/meebis/releases/download/v0.6.0/meebis-x86_64-apple-darwin.tar.xz"
      sha256 "097a915de8ddf4887001fef05cbec4f544bac4c7eaab0f963eef53f0bc97e13c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mileszim/meebis/releases/download/v0.6.0/meebis-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3f3247187b73937ce84d19308a29a262e4edc4e3af15ea43213a7f29285f40e5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mileszim/meebis/releases/download/v0.6.0/meebis-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a29458689cfb0d1dc3ca71ee4b91c6e3e7f4291ad129c28977aaaf231b33e652"
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
