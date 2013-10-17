# -*- coding: utf-8 -*-
#
# @file 
# @brief
# @author ongaeshi
# @date   2012/03/02

require 'milkode/common/ignore_setting.rb'
require 'milkode/common/util'
require 'test_helper'
require 'test/unit'

class TestIgnoreSetting < Test::Unit::TestCase
  include Milkode

  def test_regexp
    r = /test(\/|\Z)/

    assert_match r, "test"
    assert_match r, "test/"
    assert_no_match r, "testa"
    assert_match r, "test/foo"
    assert_no_match r, "testa/foo"
  end
  
  def test_glob_regexp
    r = /[^\/]*bak(\/|\Z)/

    assert_match r, "hoge.bak"
    assert_no_match r, "hoge.cpp"
    assert_match r, "a/hoge.bak/test"
    assert_no_match r, "hoge.baka/test"
  end
  
  def test_reader
    is = IgnoreSetting.new "/pkg", ["rdoc", "*.bak"]

    assert_equal "/pkg", is.path
    assert_equal ["rdoc", "*.bak"], is.ignores
  end

  def test_ignore?
    is = IgnoreSetting.new "/doc", ["foo", "bar"]

    assert_equal false, is.ignore?("/lib/hoge.rb")
    assert_equal false, is.ignore?("/doc")

    assert_equal true,  is.ignore?("/doc/foo")
    assert_equal false, is.ignore?("/doc/foo_a")
    assert_equal true,  is.ignore?("/doc/foo/a.txt")
    assert_equal true,  is.ignore?("/doc/bar")
    assert_equal false, is.ignore?("/doc/hoge.foo")
  end

  def test_slash_ignore?
    is = IgnoreSetting.new "/doc", ["/foo"]

    assert_equal true,  is.ignore?("/doc/foo")
    assert_equal false, is.ignore?("/doc/bar/foo")
  end

  def test_glob_ignore?
    is = IgnoreSetting.new "/doc", ["*.bak"]

    assert_equal false, is.ignore?("/hoge.bak")
    assert_equal true,  is.ignore?("/doc/hoge.bak")
    assert_equal true,  is.ignore?("/doc/test/a.bak")
    assert_equal false, is.ignore?("/doc/hoge.baka")
    assert_equal false, is.ignore?("/doc/hoge@bak")
  end

  def test_slash_glob_ignore?
    is = IgnoreSetting.new "/doc", ["/*.bak"]

    assert_equal true,  is.ignore?("/doc/hoge.bak")
    assert_equal false,  is.ignore?("/doc/test/a.bak")
  end

  def test_multipath_ignore?
    is = IgnoreSetting.new "/doc", ["test/data"]

    assert_equal true,  is.ignore?("/doc/test/data/a.txt")
    assert_equal false, is.ignore?("/doc/test/dataa/a.txt")
  end

  def test_parse_gitignore
    ignores = IgnoreSetting.parse_gitignore <<EOF
# comment
rdoc
# comment2
*~
/test/data
EOF
    assert_equal ignores, ["rdoc", "*~", "/test/data"]
  end

  def test_create_from_gitignore
    Dir.chdir(File.join(File.dirname(__FILE__))) do
      open("data/.gitignore") do |f|
        is = IgnoreSetting.create_from_gitignore("/doc", f.read)
        assert_equal "/doc", is.path
        assert_equal ["coverage", "rdoc", "doc", ".yardoc", ".bundle", "pkg"], is.ignores
      end
    end
  end

  def test_create_from_gitignore_sjis
    Dir.chdir(File.join(File.dirname(__FILE__))) do
      str = Milkode::Util::load_content($stdout, "data/.gitignore.sjis") # sjis -> utf-8
      is  = IgnoreSetting.create_from_gitignore("/doc", str)
      assert_equal "/doc", is.path
      assert_equal ["coverage", "rdoc", "doc", ".yardoc", ".bundle", "pkg"], is.ignores
    end
  end

  def test_last_slash
    is = IgnoreSetting.new "/doc", ["/lib/"]

    assert_equal true,  is.ignore?("/doc/lib")
    assert_equal true,  is.ignore?("/doc/lib/test")
  end

  def test_not_ignore
    is = IgnoreSetting.new "/", ["/*", "!/bin"]
    assert_equal true,   is.ignore?("/tmp")
    assert_equal false,  is.ignore?("/bin")

    is = IgnoreSetting.new "/", ["/*", "!/path/to/dir"]
    assert_equal false,  is.ignore?("/path") # 途中も除外してはいけない
    assert_equal false,  is.ignore?("/path/to")
    assert_equal true ,  is.ignore?("/path/to/a") # 除外対象
    assert_equal false,  is.ignore?("/path/to/dir")

    is = IgnoreSetting.new "/", ["/*", "!/path/to/*/dir"]
    assert_equal false,  is.ignore?("/path")
    assert_equal false,  is.ignore?("/path/to")
    assert_equal false,  is.ignore?("/path/to/lib")
    assert_equal true,  is.ignore?("/path/to/lib/a")
    assert_equal false,  is.ignore?("/path/to/bin")
    assert_equal true,  is.ignore?("/path/to/bin/a")
    assert_equal false,  is.ignore?("/path/to/lib/dir")
    
    is = IgnoreSetting.new "/", ["/*", "!path/to/dir"]
    assert_equal false,  is.ignore?("/path/to/dir")
    assert_equal false,  is.ignore?("hoge/path/to/dir")
  end
end
