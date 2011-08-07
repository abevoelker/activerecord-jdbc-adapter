class ActiveRecord::Base
  class << self
    def openedge_connection( config )
      config[:host] ||= "localhost"
      config[:port] ||= -1
      config[:port] = -1 if config[:service_name]
      config[:database] ||= "sports2000"
      config[:url] ||= "jdbc:datadirect:openedge://#{config[:host]}:#{config[:port]};\
                        databaseName=#{config[:database]};"
      config[:url] << "servicename=#{config[:service_name]};" if config[:service_name]
      config[:url] << "defaultSchema=#{config[:default_schema]};" if config[:default_schema]
      config[:url] << "statementCacheSize=#{config[:stmt_cache_size]};" if config[:stmt_cache_size]
      config[:driver] ||= "com.ddtek.jdbc.openedge.OpenEdgeDriver"
      jdbc_connection(config)
    end
  end
end
