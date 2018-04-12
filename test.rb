require 'fileutils'
require 'minitest/autorun'
require 'minitest/spec'
require 'tmpdir'

describe '`v`' do
  let(:tmpdir) { Dir.mktmpdir }
  let(:v_path) { File.expand_path('v', __dir__) }

  after do
    FileUtils.rm_r(tmpdir)
  end

  def v(args: nil, env: { 'EDITOR' => nil })
    Dir.chdir tmpdir do
      capture_subprocess_io do
        system(env, "#{v_path} --dry-run #{args}")
      end
    end
  end

  describe 'when EDITOR is defined' do
    describe 'uses EDITOR' do
      it do
        stdout, _ = v(env: { 'EDITOR' => 'foo' })
        assert_equal "foo .\n", stdout
      end
    end

    describe 'when EDITOR is not defined' do
      it 'defaults to `vim`' do
        stdout, _ = v
        assert_equal "vim .\n", stdout
      end
    end
  end

  describe 'with no arguments' do
    describe 'when Session.vim exists in the current directory' do
      before do
        session_path = File.join(tmpdir, 'Session.vim')
        FileUtils.touch(session_path)
      end

      it do
        stdout, _ = v
        assert_equal "vim -S\n", stdout
      end
    end

    describe 'otherwise' do
      it do
        stdout, _ = v
        assert_equal "vim .\n", stdout
      end
    end
  end

  describe 'with a path:line' do
    describe 'when line is a number' do
      it do
        stdout, _ = v(args: 'path/to/file:123')
        assert_equal "vim path/to/file +123\n", stdout
      end
    end

    describe 'when line is not a number' do
      it do
        stdout, _ = v(args: 'path/to/file:foo')
        assert_equal "vim path/to/file:foo\n", stdout
      end
    end

    describe 'when line is blank' do
      it do
        stdout, _ = v(args: 'path/to/file:')
        assert_equal "vim path/to/file:\n", stdout
      end
    end
  end

  describe 'with --help' do
    it do
      stdout, _ = v(args: '--help')
      assert stdout.include?('Usage:')
    end
  end
end
