#!/usr/bin/env ruby

argv = ARGV.dup
dry_run = argv.reject! { |arg| arg == '--dry-run' }

args = if argv.empty?
  session_path = File.join(Dir.pwd, 'Session.vim')

  if File.exist?(session_path)
    ['-S', session_path]
  else
    ['.']
  end
elsif argv.last =~ /^([^:]+):(\d+)\b/
  [$1, "+#{$2}"]
else
  argv
end

cmd = args.unshift('mvim')

if dry_run
  puts cmd.join(' ')
else
  exec *cmd
end
