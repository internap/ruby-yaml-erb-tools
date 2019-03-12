#!/usr/bin/env ruby
require 'yaml'
require 'optparse'
require 'ostruct'

def key_or_stdin(args, stdin = ::STDIN)
  if args.empty? || args.first == '-'
    yield stdin
  else
    yield args.first
  end
end

def main
  options = OpenStruct.new

  parser = OptionParser.new do |opts|
    opts.banner = 'Usage: %s [options] key' % $0
    opts.on '-y', '--yaml=YAML-FILE', 'YAML file to read the key from' do |yaml_file|
      File.open yaml_file, 'r' do |f|
        options.yaml = YAML::load(f)
      end
    end
  end

  if (args = parser.parse(ARGV)).length > 1
    STDERR.puts '%s: cannot render more than 1 key at a time!' % $0
    exit 1
  end

  key_or_stdin args do |input|
    content = options.yaml
    input.split(".").each do |part|
      content = content[part]
    end
    puts content
  end
end

main if __FILE__ == $0
