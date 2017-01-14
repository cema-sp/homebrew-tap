class Eta < Formula
  desc "Modern Haskell on the JVM"
  homepage "http://eta-lang.org"
  head "https://github.com/typelead/eta", :using => :git

  depends_on "haskell-stack"
  depends_on :java

  def install
    unless build.head?
      odie "Only HEAD build is supported at time"
    end

    setup_args = ["setup"]
    setup_args.unshift("--verbose") if ARGV.verbose?
    system "stack", *setup_args

    build_dir = buildpath/"build"
    build_dir.mkpath
    ENV.prepend_path "PATH", build_dir

    system "stack", "install", "--local-bin-path=#{build_dir}"

    binaries = Dir["#{build_dir}/*"].select { |dir| /example$/ !~ dir }
    bin.install binaries
  end

  def post_install
    system "eta-build", "uninstall"
    system "eta-build", "install"
    system "epm", "update"
  end

  test do
    system "#{bin}/eta", "--version"
    system "#{bin}/epm", "--version"
  end
end
