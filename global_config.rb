require 'sequel'

$LOAD_PATH << "."

DB = Sequel.sqlite('blah.db')