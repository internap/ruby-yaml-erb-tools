# ruby-yaml-erb-tools

Tool set for parsing YAML and ERB files using ruby 

## config.rb

`Usage: config.rb --yaml config.yaml example.txt.erb`

will output the parsed template using the yaml file

## print_key.rb

`Usage: print_key.rb --yaml config.yaml parent.child`

will output the parsed value at the given path

# Usage in dockerfiles

You might need to build a container using templates... try multi stage build.

See `test/Dockerfile` for an example
