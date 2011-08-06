# -*- encoding: utf-8 -*-

$LOAD_PATH << File.expand_path('../lib', __FILE__)
require 'jdbc/openedge'
version = Jdbc::OpenEdge::VERSION
Gem::Specification.new do |s|
  s.name = %q{jdbc-openedge}
  s.version = version

  s.authors = ["Abe Voelker"]
  s.date = %q{2011-08-06}
  s.description = %q{Add openedge.jar and pool.jar from your OE install to your Java classpath,
                     install this gem and require 'openedge' within JRuby to load the driver.}
  s.email = %q{abe@abevoelker.com}

  s.files = [
    "Rakefile", "README.txt", "LICENSE.txt",
    *Dir["lib/**/*"].to_a
  ]

  s.homepage = %q{http://jruby-extras.rubyforge.org/ActiveRecord-JDBC}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{jruby-extras}
  s.summary = %q{OpenEdge JDBC driver for Java and OpenEdge/ActiveRecord-JDBC.}
end
