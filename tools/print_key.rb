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
  options.yamls = []

  parser = OptionParser.new do |opts|
    opts.banner = 'Usage: %s [options] file.erb' % $0
    opts.on '-y', '--yaml=YAML-FILE(S)', Array, 'YAML file(s) to populate local variables for the template. separated by comma' do |configs|
      configs.each do |config|
        if File.directory?(config)
          Dir.foreach(config) do |yaml|
            next if yaml == '.' or yaml == '..'
            File.open File.join(config, yaml), 'r' do |f|
              options.yamls.push(YAML::load(f))
            end
          end
        else
          File.open config, 'r' do |f|
            options.yamls.push(YAML::load(f))
          end
        end
      end
    end
  end

  if (args = parser.parse(ARGV)).length > 1
    STDERR.puts '%s: cannot render more than 1 key at a time!' % $0
    exit 1
  end

  options.yamls.each_with_index do |y, i|
    if !y.nil? && y.inspect != 'false'
      if options.yaml.nil?
        options.yaml = y
      else
        options.yaml = options.yaml.merge y
      end
    end
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
