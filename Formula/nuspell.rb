class Nuspell < Formula
  desc "Spellchecker"
  homepage "https://nuspell.github.io"
  url "https://github.com/nuspell/nuspell/archive/v4.2.0.tar.gz"
  sha256 "01804d490bec517748ee49fa2f1249f4c99380c26335e32082cdaa02b5b2b4dc"

  depends_on "cmake" => :build
  depends_on "pandoc" => :build
  depends_on "gnu-tar" => :test
  depends_on "grep" => :test
  uses_from_macos "binutils" => :test
  uses_from_macos "icu4c"

  resource "test_dictionary" do
    url "http.us.debian.org/debian/pool/main/s/scowl/hunspell-en-us_2019.10.06-1_all.deb"
    sha256 "b15bb8a8a891fa4efb3705e9579f300bf6ab1929a335b2090e053d1b02fbb3e8"
  end

  resource "test_wordlist" do
    url "http.us.debian.org/debian/pool/main/s/scowl/wamerican-small_2019.10.06-1_all.deb"
    sha256 "0dae43bfdc5fc3cf9560509f927a7cc959616d86d121c032616c37cdf58d5b99"
  end

  def install
    if MacOS.version >= :mojave && MacOS::CLT.installed?
      ENV["SDKROOT"] = ENV["HOMEBREW_SDKROOT"] = MacOS::CLT.sdk_path(MacOS.version)
    end
    mkdir "build" do
      system "cmake", "..", "-DCMAKE_BUILD_TYPE=Release", "-DBUILD_TESTING=OFF", *std_cmake_args
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
    testpath.install resource("test_dictionary")
    system "ar", "x", "hunspell-en-us_2019.10.06-1_all.deb"
    system "tar", "xf", "data.tar.xz"
    testpath.install resource("test_wordlist")
    system "ar", "x", "wamerican-small_2019.10.06-1_all.deb"
    system "tar", "xf", "data.tar.xz"
    assert(pipe_output("#{bin}/nuspell -d usr/share/hunspell/en_US usr/share/dict/american-english-small | grep '^*'").size > 45000)
  end
end
