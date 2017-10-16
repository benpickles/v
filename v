#!/usr/bin/env ruby

args = if ARGV.empty?
  session_path = File.join(Dir.pwd, 'Session.vim')

  if File.exist?(session_path)
    ['-S', session_path]
  else
    ['.']
  end
elsif ARGV.last =~ /^([^:]+):(\d+)\b/
  [$1, "+#{$2}"]
else
  ARGV.dup
end

cmd = args.unshift('mvim')
exec *cmd
