require 'test/unit'
require 'pathname'
class TestFunctional < Test::Unit::TestCase
  @@dir = Pathname(__FILE__).expand_path.dirname

  def strip_time(str)
    str.sub(/Generated on.+$/, '')
  end

  def cmp(file)
    content = lambda{|dir| strip_time(File.read(@@dir+dir+file))}
    assert_equal(content["expected_coverage"], content["actual_coverage"])
  end

  def run_rcov(opts, opts_tail="")
    rcov = @@dir+"../bin/rcov"
    ruby_opts = "-I../lib:../ext/rcovrt"
    Dir.chdir(@@dir) do
      `cd #{@@dir}; ruby #{ruby_opts} #{rcov} #{opts} -o actual_coverage sample_04.rb #{opts_tail}`
      yield
    end
  end

  def test_annotation
    run_rcov("-a") do
      cmp "sample_04_rb.rb"
      cmp "sample_03_rb.rb"
    end
  end

  def test_html
    run_rcov("") do
      cmp "sample_04_rb.html"
      cmp "sample_03_rb.html"
    end
  end

  def test_text_gcc
    run_rcov("--gcc --include-file=sample --exclude=rcov",
             "> actual_coverage/gcc-text.out") do
      cmp "gcc-text.out"
    end
  end

end