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

  def touch_session_vim
    session_path = File.join(tmpdir, 'Session.vim')
    FileUtils.touch(session_path)
  end

  def v(args: nil, env: { 'EDITOR' => nil }, pre: nil)
    Dir.chdir tmpdir do
      capture_subprocess_io do
        system(env, "#{pre}#{v_path} --dry-run #{args}")
      end
    end
  end

  describe 'handling EDITOR environment' do
    describe 'when it is defined' do
      it 'is used' do
        stdout, _ = v(env: { 'EDITOR' => 'foo' })
        assert_equal "foo .\n", stdout
      end
    end

    describe 'when it is not defined' do
      it 'defaults to `vim`' do
        stdout, _ = v
        assert_equal "vim .\n", stdout
      end
    end
  end

  describe 'with no arguments' do
    describe 'when Session.vim exists in the current directory' do
      before do
        touch_session_vim
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

  describe 'with stdin' do
    describe '<' do
      let(:path_to_readme) { File.expand_path('README.md', __dir__) }

      it do
        stdout, _ = v(args: "< #{path_to_readme}")
        assert_equal "vim -\n", stdout
      end
    end

    describe '|' do
      it do
        stdout, _ = v(pre: 'echo testy | ')
        assert_equal "vim -\n", stdout
      end
    end

    describe 'extra arguments' do
      it 'are ignored' do
        stdout, _ = v(args: 'path/to/file', pre: 'echo testy | ')
        assert_equal "vim -\n", stdout
      end
    end

    describe 'when Session.vim exists in the current directory' do
      before do
        touch_session_vim
      end

      it 'is ignored' do
        stdout, _ = v(pre: 'echo testy | ')
        assert_equal "vim -\n", stdout
      end
    end
  end

  describe 'other arguments' do
    it 'are forwarded' do
      stdout, _ = v(args: '-foo -bar')
      assert_equal "vim -foo -bar\n", stdout
    end
  end
end
