#!/usr/bin/env ruby

if ARGV.size == 1 && ARGV.first =~ /(.+):(\d+)$/
  args = [$1, "+#{$2}"]
elsif ARGV.empty?
  args = ['.']
else
  args = ARGV
end

exec args.unshift('mvim').join(' ')
