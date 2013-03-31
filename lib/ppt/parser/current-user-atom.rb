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
require "ppt/parser/record-header"

module PPT
  class Parser
    class CurrentUserAtom < Struct.new(:record_header,
                                       :size,
                                       :header_token,
                                       :current_edit_offset,
                                       :user_name_length,
                                       :doc_file_version,
                                       :major_version,
                                       :minor_version,
                                       :ansi_user_name,
                                       :release_version,
                                       :unicode_user_name)
      class << self
        def parse(data)
          reader = BinaryReader.new(data)

          record_header_raw   = reader.read(:raw, 8)
          record_header       = RecordHeader.parse(record_header_raw)
          size                = reader.read(:unsigned_integer, 4)
          header_token        = reader.read(:unsigned_integer, 4)
          current_edit_offset = reader.read(:unsigned_integer, 4)
          user_name_length    = reader.read(:unsigned_integer, 2)
          doc_file_version    = reader.read(:unsigned_integer, 2)
          major_version       = reader.read(:unsigned_integer, 1)
          minor_version       = reader.read(:unsigned_integer, 1)
          _unused             = reader.read(:raw, 2)
          ansi_user_name      = reader.read(:raw, user_name_length)
          release_version     = reader.read(:unsigned_integer, 4)
          unicode_user_name   = reader.read(:raw, user_name_length * 2)

          new(record_header,
              size,
              header_token,
              current_edit_offset,
              user_name_length,
              doc_file_version,
              major_version,
              minor_version,
              ansi_user_name,
              release_version,
              unicode_user_name)
        end
      end
    end
  end
end
