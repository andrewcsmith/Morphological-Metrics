$LOAD_PATH << File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name = 'morphological_metrics'
  s.required_ruby_version = '>= 1.9.3'
  s.summary = 'Implementation of Morphological Metrics put forward by Larry Polansky'
  s.version = '0.1'
  s.authors = 'Beau Sievers'
  s.files = [
    'lib/mm.rb',
    'lib/mm/dist_config.rb',
    'lib/mm/euclidean.rb',
    'lib/mm/helpers.rb',
    'lib/mm/metrics.rb'
  ]
end
