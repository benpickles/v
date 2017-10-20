#!/usr/bin/env ruby

if ARGV.include?('--help')
  puts DATA.read
  exit
end

argv = ARGV.dup
dry_run = argv.reject! { |arg| arg == '--dry-run' }

args = if argv.empty?
  session_path = File.join(Dir.pwd, 'Session.vim')

  if File.exist?(session_path)
    ['-S']
  else
    ['.']
  end
elsif argv.last =~ /^([^:]+):(\d+)\b/
  [$1, "+#{$2}"]
else
  argv
end

editor = ENV.fetch('EDITOR', 'vim')
cmd = args.unshift(editor)

if dry_run
  puts cmd.join(' ')
else
  exec *cmd
end

__END__

  Usage: v [options] [path]

  Options:

    --dry-run  Output the command that would have been executed.
    --help     Output this information.

  Path:

  A path can include a trailing colon and line number onto which cursor will be
  placed, making it easy to copy/paste output from testing tools and the like.

  For example:

    $ v path/to/file:4

  If no path is passed but file named `Session.vim` is present in the current
  directory then it will loaded as a Vim session.

  Otherwise the current directory will be opened.

