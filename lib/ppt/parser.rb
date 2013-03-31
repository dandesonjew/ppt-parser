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

# [MS-PPT]: PowerPoint (.ppt) Binary File Format
# http://msdn.microsoft.com/ja-jp/library/office/cc313106%28v=office.14%29.aspx

require "ole/storage"

require "ppt/parser/current-user-atom"
require "ppt/parser/user-edit-atom"

module PPT
  class Parser
    class Error < StandardError
    end

    class << self
      def parse(path)
        Ole::Storage.open(path, "rb") do |storage|
          new(storage).parse
        end
      end
    end

    attr_reader :current_user_atom
    attr_reader :user_edit_atom
    def initialize(storage)
      @storage = storage
    end

    def parse
      parse_current_user_stream
      parse_power_point_document_stream
    end

    private
    def parse_current_user_stream
      current_user_stream = @storage.root["Current User"]
      data = current_user_stream.read
      @current_user_atom = CurrentUserAtom.parse(data)
    end

    def parse_power_point_document_stream
      power_point_document_stream = @storage.root["PowerPoint Document"]
      data = power_point_document_stream.read
      user_edit_data = data[@current_user_atom.current_edit_offset..-1]
      @user_edit_atom = UserEditAtom.parse(user_edit_data)
    end
  end
end
