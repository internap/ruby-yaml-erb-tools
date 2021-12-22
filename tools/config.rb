#!/usr/bin/env ruby
require 'erb'
require 'json'
require 'yaml'
require 'optparse'
require 'ostruct'

class ERBContext
  def initialize(hash)
    raise ArgumentError, 'hash must be a Hash object' unless hash.is_a?(::Hash)
    hash.each do |key, value|
      instance_variable_set :"@#{key}", value
    end
  end

  def render(template)
    template.result binding
  end

  class << self
    def render(hash, template, safe_level = nil, trim_mode = nil, eoutvar = '_erbout')
      tmpl = ::ERB.new(template, safe_level, trim_mode, eoutvar)
      context = new(hash)
      context.render tmpl
    end
  end
end

def file_or_stdin(args, stdin = ::STDIN)
  if args.empty? || args.first == '-'
    yield stdin
  else
    File.open args.first, 'r' do |f|
      yield f
    end
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
    STDERR.puts '%s: cannot render more than 1 file at a time!' % $0
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

  file_or_stdin args do |input|
    puts ERBContext.render(options.yaml || {}, input.read, nil, '-')
  end
end

main if __FILE__ == $0
