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

class TestParser < Test::Unit::TestCase
  private
  def fixture_directory
    File.join(File.dirname(__FILE__), "fixture")
  end

  def fixture_path(*components)
    File.join(fixture_directory, *components)
  end

  def parse(path)
    path = fixture_path(path)
    Ole::Storage.open(path, "rb") do |storage|
      @parser = PPT::Parser.new(storage)
      @parser.parse
    end
  end

  class TestCurrentUserAtom < self
    def setup
      parse("empty.ppt")
      @current_user_atom = @parser.current_user_atom
    end

    def test_record_type
      assert_equal(PPT::Parser::RecordHeader::Type::CURRENT_USER_ATOM,
                   @current_user_atom.record_header.type)
    end
  end

  class TestUserEditAtom < self
    def setup
      parse("empty.ppt")
      @user_edit_atom = @parser.user_edit_atom
    end

    def test_record_type
      assert_equal(PPT::Parser::RecordHeader::Type::USER_EDIT_ATOM,
                   @user_edit_atom.record_header.type)
    end
  end
end
