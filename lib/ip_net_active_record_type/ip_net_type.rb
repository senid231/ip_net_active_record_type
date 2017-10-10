require 'active_record/type/value'
require_relative 'ip_net'

module IpNetActiveRecordType
  class IpNetType < ActiveRecord::Type::Value

    def cast_value(value)
      case value
        when IpNetActiveRecordType::IpNet
          value
        when IPAddr
          IpNetActiveRecordType::IpNet.from_ipaddr(value)
        else
          IpNetActiveRecordType::IpNet.new(value)
      end
    end

    def type_cast_for_database(value)
      value.to_s
    end

  end
end