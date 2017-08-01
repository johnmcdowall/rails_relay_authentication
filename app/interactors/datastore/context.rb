module Datastore
  class Context < BaseContext
    def params
      record.slice(*whitelist)
    end

    def self.common_attributes
      super + %i(id uuid schema whitelist record datastore record_builder)
    end
  end
end  
