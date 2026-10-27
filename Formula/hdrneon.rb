class Hdrneon < Formula
  desc "HDR test scene: neon tubes above reference patches, in SDR, HDR10 or scRGB"
  homepage "https://github.com/porkloin/hdrneon"
  url "https://github.com/porkloin/hdrneon/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"
  license "GPL-3.0-or-later"
  head "https://github.com/porkloin/hdrneon.git", branch: "main"

  depends_on "rust" => :build
  depends_on :linux

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "usage: hdrneon", shell_output("#{bin}/hdrneon --help")
  end
end
