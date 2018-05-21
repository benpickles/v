#!/usr/bin/env ruby

EDITOR = ENV.fetch('EDITOR', 'vim')
VERSION = '1.1.0'

if ARGV.include?('--help')
  puts DATA.read
    .gsub('#{EDITOR}', EDITOR)
    .gsub('#{VERSION}', VERSION)
  exit
end

argv = ARGV.dup
dry_run = argv.reject! { |arg| arg == '--dry-run' }

args = if !$stdin.tty?
  argv.push('-')
elsif argv.empty?
  session_path = File.join(Dir.pwd, 'Session.vim')

  if File.exist?(session_path)
    ['-S']
  else
    ['.']
  end
elsif argv.last =~ /^([^:]+):(\d+)\b/
  [$1, "+#{$2}"]
else
  if argv.include?('--version')
    puts "v #{VERSION} wrapping #{EDITOR} - https://github.com/benpickles/v"
  end

  argv
end

cmd = args.unshift(EDITOR)

if dry_run
  puts cmd.join(' ')
else
  exec *cmd
end

__END__

  Usage: v [options] [path]

  Options:

    --dry-run  Output the command that would have been executed.
    --help     This information.
    --version  Version information for v and #{EDITOR}.

  Content received via stdin will automatically be read.

  Path:

  A path can include a trailing colon and line number onto which cursor will be
  placed, making it easy to copy/paste output from testing tools and the like.

  For example:

    $ v path/to/file:4

  If no path is passed but a file named `Session.vim` is present in the current
  directory then it will loaded as a Vim session.

  Otherwise the current directory will be opened.

  Version: #{VERSION}
  Wrapping: #{EDITOR}

