module JdbcSpec
  module Derby
    module Column
      def type_cast(value)
        return nil if value.nil? || value =~ /^\s*null\s*$/i
        case type
        when :string    then value
        when :integer   then defined?(value.to_i) ? value.to_i : (value ? 1 : 0)
        when :primary_key then defined?(value.to_i) ? value.to_i : (value ? 1 : 0) 
        when :float     then value.to_f
        when :datetime  then cast_to_date_or_time(value)
        when :timestamp then cast_to_time(value)
        when :binary    then value.scan(/[0-9A-Fa-f]{2}/).collect {|v| v.to_i(16)}.pack("C*")
        when :time      then cast_to_time(value)
        else value
        end
      end
      def cast_to_date_or_time(value)
        return value if value.is_a? Date
        return nil if value.blank?
        guess_date_or_time (value.is_a? Time) ? value : cast_to_time(value)
      end

      def cast_to_time(value)
        return value if value.is_a? Time
        time_array = ParseDate.parsedate value
        time_array[0] ||= 2000; time_array[1] ||= 1; time_array[2] ||= 1;
        Time.send(Base.default_timezone, *time_array) rescue nil
      end

      def guess_date_or_time(value)
        (value.hour == 0 and value.min == 0 and value.sec == 0) ?
        Date.new(value.year, value.month, value.day) : value
      end
    end

    def modify_types(tp)
      tp[:primary_key] = "int generated by default as identity NOT NULL PRIMARY KEY"
      tp[:integer][:limit] = nil
      tp
    end

    def add_limit_offset!(sql, options) # :nodoc:
      @limit = options[:limit]
      @offset = options[:offset]
    end
    
    def select_all(sql, name = nil)
      @limit ||= -1
      @offset ||= 0
      select(sql, name)[@offset..(@offset+@limit)]
    ensure
      @limit = @offset = nil
    end
    
    def select_one(sql, name = nil)
      @offset ||= 0
      select(sql, name)[@offset]
    ensure
      @limit = @offset = nil
    end

    def execute(sql, name = nil)
      log_no_bench(sql, name) do
        if sql =~ /^select/i
          @limit ||= -1
          @offset ||= 0
          @connection.execute_query(sql)[@offset..(@offset+@limit)]
        else
          @connection.execute_update(sql)
        end
      end
    ensure
      @limit = @offset = nil
    end

    def remove_index(table_name, options) #:nodoc:
      execute "DROP INDEX #{index_name(table_name, options)}"
    end

    def rename_table(name, new_name)
      execute "RENAME TABLE #{name} TO #{new_name}"
    end

    # Support for removing columns added via derby bug issue:
    # https://issues.apache.org/jira/browse/DERBY-1489
    #
    # This feature has not made it into a formal release and is not in Java 6.  We will
    # need to conditionally support this somehow (supposed to arrive for 10.3.0.0)
    #
    # def remove_column(table_name, column_name)
    #  execute "ALTER TABLE #{table_name} DROP COLUMN #{column_name} RESTRICT"
    # end
    
    # Notes about changing in Derby:
    #    http://db.apache.org/derby/docs/10.2/ref/rrefsqlj81859.html#rrefsqlj81859__rrefsqlj37860)
    # Derby cannot: Change the column type or decrease the precision of an existing type, but
    #   can increase the types precision only if it is a VARCHAR.
    #
    def change_column(table_name, column_name, type, options = {}) #:nodoc:
      execute "ALTER TABLE #{table_name} ALTER COLUMN #{column_name} SET DATA TYPE #{type_to_sql(type, options[:limit])}"
    end

    def change_column_default(table_name, column_name, default) #:nodoc:
      execute "ALTER TABLE #{table_name} ALTER COLUMN #{column_name} SET DEFAULT #{quote(default)}"
    end

    # Support for renaming columns:
    # https://issues.apache.org/jira/browse/DERBY-1490
    #
    # This feature is expect to arrive in version 10.3.0.0:
    # http://wiki.apache.org/db-derby/DerbyTenThreeRelease)
    #
    #def rename_column(table_name, column_name, new_column_name) #:nodoc:
    #  execute "ALTER TABLE #{table_name} ALTER RENAME COLUMN #{column_name} TO #{new_column_name}"
    #end
    
    def primary_keys(table_name)
      @connection.primary_keys table_name.to_s.upcase
    end
    
    # For migrations, exclude the primary key index as recommended
    # by the HSQLDB docs.  This is not a great test for primary key
    # index.
    def indexes(table_name)
      @connection.indexes(table_name)
    end
    
    def quote(value, column = nil) # :nodoc:
      return value.to_s if column && column.type == :primary_key

      case value
      when String                
        if column && column.type == :binary
          "CAST(x'#{quote_string(value).unpack("C*").collect {|v| v.to_s(16)}.join}' AS BLOB)"
        else
          vi = value.to_i
          if vi.to_s == value
            value
          else
            "'#{quote_string(value)}'"
          end
        end
      else super
      end
    end

# For DDL it appears you can quote "" column names, but in queries (like insert it errors out?)
#    def quote_column_name(name) #:nodoc:
#        %Q{"#{name}"}
#    end
    
    def quoted_true
      '1'
    end

    def quoted_false
      '0'
    end
  end
end