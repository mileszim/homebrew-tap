class Meebis < Formula
  desc "A fast, disposable, in-memory Redis-compatible server for ephemeral dev work"
  homepage "https://github.com/mileszim/meebis"
  version "0.14.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mileszim/meebis/releases/download/v0.14.0/meebis-aarch64-apple-darwin.tar.xz"
      sha256 "26723f23f3699c5fb8fc57b04d8082197e49c99e72d9301923ec9d92550ade7c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mileszim/meebis/releases/download/v0.14.0/meebis-x86_64-apple-darwin.tar.xz"
      sha256 "53be129dc987cfef03b81b40e8d21a3b0e8d75ac0b2da0f76bf21134c7b9851b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mileszim/meebis/releases/download/v0.14.0/meebis-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ae3c3110635294b1dc4fde938b81a7622fc0782f3d5825e360d29ec746924ece"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mileszim/meebis/releases/download/v0.14.0/meebis-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ec841814c736994b5346aedf24b70cadb792610ae993d1173e64b37d670bfbaa"
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
