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

module PPT
  class Parser
    class BinaryReader
      def initialize(data)
        @data = data
        @offset = 0
      end

      def read(type, n_bytes)
        if type == :raw
          data = @data[@offset, n_bytes]
        else
          data = @data[@offset..-1].unpack(unpack_format(type, n_bytes))[0]
        end
        @offset += n_bytes
        data
      end

      private
      def unpack_format(type, n_bytes)
        case type
        when :unsigned_integer
          case n_bytes
          when 1
            "C"
          when 2
            "v"
          when 4
            "V"
          else
            raise "unsupported unsigned integer bytes: #{n_bytes}"
          end
        else
          raise "unknown: #{type}"
        end
      end
    end
  end
end
