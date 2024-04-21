class Nuspell < Formula
  desc "Spellchecker"
  homepage "https://nuspell.github.io"
  url "https://github.com/nuspell/nuspell/archive/refs/tags/v5.1.4.tar.gz"
  sha256 "bdf344c5adbcc6797940f8f8cb75cb59f5a3794eb21b9547751a11782a792ef7"

  depends_on "icu4c"
  depends_on "cmake" => :build

  def install
    mkdir "build" do
      icu4c_prefix = Formula["icu4c"].opt_prefix
      system "cmake", "..", "-DICU_ROOT=#{icu4c_prefix}", *std_cmake_args
      system "cmake", "--build", ".", "--target", "install"
    end
  end

  def caveats; <<~EOS
    Dictionary files (*.aff and *.dic) should be placed in
    ~/Library/Spelling/ or /Library/Spelling/.  Homebrew itself
    provides no dictionaries for Nuspell, but you can download
    compatible Hunspell dictionaries from other sources, such as
    https://wiki.documentfoundation.org/Language_support_of_LibreOffice .
  EOS
  end

  test do
    system "#{bin}/nuspell", "--help"
  end
end
