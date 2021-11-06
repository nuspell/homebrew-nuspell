class Nuspell < Formula
  desc "Spellchecker"
  homepage "https://nuspell.github.io"
  url "https://github.com/nuspell/nuspell/archive/v5.0.0.tar.gz"
  sha256 "855d4771d225dcce1e48d098be6a2d69629c635b79b53f9e095a35adc68f0ea1"

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
