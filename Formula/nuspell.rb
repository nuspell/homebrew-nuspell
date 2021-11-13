class Nuspell < Formula
  desc "Spellchecker"
  homepage "https://nuspell.github.io"
  url "https://github.com/nuspell/nuspell/archive/v5.0.1.tar.gz"
  sha256 "a48d9b0297f9c87d8e3231b2662786c5380634cd2b2e0005c55709caefdaa032"

  depends_on "icu4c"
  depends_on "cmake" => :build
  depends_on "pandoc" => :build

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
