class Meebis < Formula
  desc "A fast, disposable, in-memory Redis-compatible server for ephemeral dev work"
  homepage "https://github.com/mileszim/meebis"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mileszim/meebis/releases/download/v0.4.0/meebis-aarch64-apple-darwin.tar.xz"
      sha256 "0529c23d1f0415ee40aac582f0fd13d949baa85d27c697925615641c469bd44e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mileszim/meebis/releases/download/v0.4.0/meebis-x86_64-apple-darwin.tar.xz"
      sha256 "f254b6e0d9ef7cb8a2dc1d6fd08b190fa4deefa30d008aaed6e17215ed02d4e4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mileszim/meebis/releases/download/v0.4.0/meebis-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4f3fa03f613c208ee7435dacfff79b02c786dc3f355d5cbbb14d055c03464269"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mileszim/meebis/releases/download/v0.4.0/meebis-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b27f2d7cb385243be866147e3429fb38292843715792f9e85a5f09c54ebaf65d"
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
