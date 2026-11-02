class Clickflash < Formula
  desc "Black window that flashes white on every click, for click-to-photon latency"
  homepage "https://github.com/porkloin/clickflash"
  url "https://github.com/porkloin/clickflash/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"
  license "GPL-3.0-or-later"
  head "https://github.com/porkloin/clickflash.git", branch: "main"

  depends_on "rust" => :build
  depends_on :linux

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "usage: clickflash", shell_output("#{bin}/clickflash --help")
  end
end
