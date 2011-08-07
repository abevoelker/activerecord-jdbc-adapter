# -*- encoding: utf-8 -*-
arjdbc_lib = File.expand_path("../../lib", __FILE__)
$:.push arjdbc_lib unless $:.include?(arjdbc_lib)
require 'arjdbc/version'
version = ArJdbc::Version::VERSION
Gem::Specification.new do |s|
  s.name        = "activerecord-jdbcopenedge-adapter"
  s.version     = version
  s.platform    = Gem::Platform::RUBY
  s.authors = ["Abe Voelker"]
  s.description = %q{Install this gem to use OpenEdge with JRuby on Rails.}
  s.email = %q{abe@abevoelker.com}
  s.files = [
    "Rakefile",
    "README.txt",
    "LICENSE.txt",
    "lib/active_record/connection_adapters/jdbcopenedge_adapter.rb"
  ]
  s.homepage = %q{http://jruby-extras.rubyforge.org/ActiveRecord-JDBC}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{jruby-extras}
  s.summary = %q{OpenEdge JDBC adapter for JRuby on Rails.}

  s.add_dependency 'activerecord-jdbc-adapter', "~>#{version}"
  s.add_dependency 'jdbc-openedge', '~> 10.2.0'
end

