class RecordNotFound < StandardError; end
class NoHTML5Compliant < Exception; end;

module CartoDB
  class InvalidUser < StandardError; end
  class InvalidTableName < StandardError; end
  class InvalidColumnName < StandardError; end
  class InvalidGeomType < StandardError; end
  class InvalidSRID < StandardError; end
  class InvalidGeoJSONFormat < StandardError; end
  class QueryNotAllowed < StandardError; end
  
  # importer errors
  class EmptyFile < StandardError 
    def detail
      ERROR_CODES[:empty_file]
    end  
  end

  class InvalidUrl < StandardError 
    def detail
      ERROR_CODES[:url_error]
    end  
  end

  class InvalidFile < StandardError 
    def detail
      ERROR_CODES[:file_error]
    end  
  end
  
  class TableCopyError < StandardError 
    def detail
      ERROR_CODES[:table_copy_error]
    end  
  end
  
  class QuotaExceeded < StandardError
    def detail
      ERROR_CODES[:quota_error].merge(:raw_error => self.message)      
    end  
  end


  # database errors
  class DbError < StandardError
    attr_accessor :message
    def initialize(msg)
      # Example of an error (newline included):
      # Pgerror: error:  relation "antantaric_species" does not exist
      # LINE 1: insert into antantaric_species (name_of_species,family) valu...

      # So we suppose everything we need is in the first line
      @message = msg.split("\n").first.gsub(/pgerror: error:/i,'').strip
    end
    def to_s; @message; end
  end

  class TableNotExists < DbError; end
  class ColumnNotExists < DbError; end
  class ErrorRunningQuery < DbError
    attr_accessor :db_message # the error message from the database
    attr_accessor :syntax_message # the query and a marker where the error is

    def initialize(message)
      super(message)
      @db_message = message.split("\n")[0]
      @syntax_message = message.split("\n")[1..-1].join("\n")
    end    
  end

  class InvalidType < DbError
    attr_accessor :db_message # the error message from the database
    attr_accessor :syntax_message # the query and a marker where the error is

    def initialize(message)
      @db_message = message.split("\n")[0]
      @syntax_message = message.split("\n")[1..-1].join("\n")
      CartoDB::Logger.info "InvalidType", message
    end
  end

  class InvalidQuery < StandardError
    attr_accessor :message
    def initialize
      @message = "Only SELECT statement is allowed"
    end
  end

  class EmptyAttributes < StandardError
    attr_accessor :error_message
    def initialize(message)
      @error_message = message
      CartoDB::Logger.info "EmptyAttributes", message      
    end
  end

  class InvalidAttributes < StandardError
    attr_accessor :error_message
    def initialize(message)
      @error_message = message
      CartoDB::Logger.info "InvalidAttributes", message      
    end
  end
end  
