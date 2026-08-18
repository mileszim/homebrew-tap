class Meebis < Formula
  desc "A fast, disposable, in-memory Redis-compatible server for ephemeral dev work"
  homepage "https://github.com/mileszim/meebis"
  version "0.10.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mileszim/meebis/releases/download/v0.10.0/meebis-aarch64-apple-darwin.tar.xz"
      sha256 "528fc340c4f28cf9ff2386df94e7e8eb2db99d1717daa57d499edb3a2645f2ad"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mileszim/meebis/releases/download/v0.10.0/meebis-x86_64-apple-darwin.tar.xz"
      sha256 "8e78838fdff6752b0ad5726bf8021d14afc38315bba9c9bbd065fbb45aac2edf"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mileszim/meebis/releases/download/v0.10.0/meebis-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0247d743284d338f69d2f8d44884c3a53fe3c88a4f5adc42ebdda68b55f07958"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mileszim/meebis/releases/download/v0.10.0/meebis-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ee177371cbf680930807da4945b2004552b3e803ae6f59bcea815d7bc0e3082e"
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
