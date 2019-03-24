require 'sqlite3'
require 'pry'
#require 'pry-nav'
require_relative '../lib/student'

DB = {:conn => SQLite3::Database.new("db/students.db")}