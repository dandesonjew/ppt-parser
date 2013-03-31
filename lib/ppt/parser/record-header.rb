# Copyright (C) 2013  Kouhei Sutou <kou@clear-code.com>
#
# This library is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library.  If not, see
# <http://www.gnu.org/licenses/>.

require "ppt/parser/binary-reader"

module PPT
  class Parser
    class RecordHeader < Struct.new(:version,
                                    :instance,
                                    :type,
                                    :length)
      class << self
        def parse(data)
          reader = BinaryReader.new(data)

          version_and_instance_high = reader.read(:unsigned_integer, 1)
          instance_low              = reader.read(:unsigned_integer, 1)
          type                      = reader.read(:unsigned_integer, 2)
          length                    = reader.read(:unsigned_integer, 4)

          version = (version_and_instance_high & 0xF0) >> 8
          instance_high = version_and_instance_high & 0x0F
          instance = instance_high << 8 + instance_low

          new(version, instance, type, length)
        end
      end

      module Type
        USER_EDIT_ATOM    = 0x0FF5
        CURRENT_USER_ATOM = 0x0FF6
      end
    end
  end
end
