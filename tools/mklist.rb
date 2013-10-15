# Create mgem repository list

require 'yaml'

mgem_dir = File.join(ENV['HOME'], '.mgem')
mgem_list = Dir.glob(File.join(mgem_dir, 'mgem-list/*.gem'))

repositories = mgem_list.map do |mgem|
  YAML.load(File.read(mgem))['repository']
end

repositories.each do |repo|
    puts "milk add #{repo} -p git"
end



