= jdbc-openedge

* http://jruby-extras.rubyforge.org/activerecord-jdbc-adapter/

== DESCRIPTION:

This is an OpenEdge / Progress JDBC driver gem for JRuby.  This will only
work if you have the SQL-92 engine running on your OpenEdge database.

Use

Add `openedge.jar` and `pool.jar` (from your OpenEdge installation) to your
Java classpath.  Then,

    require 'jdbc/openedge'

to make the driver accessible to JDBC and ActiveRecord
code running in JRuby.

