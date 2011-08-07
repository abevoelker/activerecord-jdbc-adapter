module Jdbc
  module OpenEdge
    VERSION = "10.2.1" # Corresponds to OpenEdge 10.2B
  end
end
if RUBY_PLATFORM =~ /java/
  require "openedge.jar"
  require "pool.jar"
else
  warn "jdbc-openedge is only for use with JRuby"
end
