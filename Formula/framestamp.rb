class Framestamp < Formula
  desc "Game-like test pattern stamped with frame numbers, to verify streamed pictures in motion"
  homepage "https://github.com/porkloin/framestamp"
  url "https://github.com/porkloin/framestamp/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"
  license "GPL-3.0-or-later"
  head "https://github.com/porkloin/framestamp.git", branch: "main"

  depends_on "rust" => :build
  depends_on :linux

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "usage: framestamp", shell_output("#{bin}/framestamp --help")
  end
end
