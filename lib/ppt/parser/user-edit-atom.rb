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
    class UserEditAtom < Struct.new(:record_header,
                                    :last_slide_id_ref,
                                    :version,
                                    :minor_version,
                                    :major_version,
                                    :last_edit_offset,
                                    :persist_directory_offset,
                                    :doc_persist_id_ref,
                                    :persist_id_seed,
                                    :last_view,
                                    :unused,
                                    :encrypt_session_persist_id_ref)
      class << self
        def parse(data)
          reader = BinaryReader.new(data)

          record_header_raw              = reader.read(:raw, 8)
          record_header                  = RecordHeader.parse(record_header_raw)
          last_slide_id_ref              = reader.read(:unsigned_integer, 4)
          version                        = reader.read(:unsigned_integer, 2)
          minor_version                  = reader.read(:unsigned_integer, 1)
          major_version                  = reader.read(:unsigned_integer, 1)
          last_edit_offset               = reader.read(:unsigned_integer, 4)
          persist_directory_offset       = reader.read(:unsigned_integer, 4)
          doc_persist_id_ref             = reader.read(:unsigned_integer, 4)
          persist_id_seed                = reader.read(:unsigned_integer, 4)
          last_view                      = reader.read(:unsigned_integer, 2)
          _unused                        = reader.read(:raw, 2)
          encrypt_session_persist_id_ref = reader.read(:unsigned_integer, 4)

          new(record_header,
              last_slide_id_ref,
              version,
              minor_version,
              major_version,
              last_edit_offset,
              persist_directory_offset,
              doc_persist_id_ref,
              persist_id_seed,
              last_view,
              encrypt_session_persist_id_ref)
        end
      end
    end
  end
end
