require 'active_model/type/value'
require_relative 'ip_net'

module IpNetActiveRecordType
  class IpNetType < ActiveModel::Type::Value

    def cast_value(value)
      case value
        when IpNetActiveRecordType::IpNet
          value
        when IPAddr
          safe_typecast { IpNetActiveRecordType::IpNet.from_ipaddr(value) }
        else
          safe_typecast { IpNetActiveRecordType::IpNet.new(value) }
      end
    end

    def serialize(value)
      value.to_s
    end

    private

    def safe_typecast
      yield
    rescue ArgumentError
      nil
    end

  end
end
