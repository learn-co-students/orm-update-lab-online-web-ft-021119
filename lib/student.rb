require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade, :id
  @@all = []

  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
    @@all << self
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def save
    if self.id != nil
      self.update
    else
      insert_sql = <<-SQL
        INSERT INTO students (name, grade)
        VALUES (?, ?)
      SQL
      DB[:conn].execute(insert_sql, self.name, self.grade)
      id_sql = <<-SQL
          SELECT id FROM students WHERE name = (?) AND grade = (?)
      SQL
      self.id = DB[:conn].execute(id_sql, self.name, self.grade).flatten.first
    end
  end

  def self.create(name, grade)
    self.new(name, grade).save
  end

  def self.new_from_db(row)
    student = self.new(row[1],row[2],row[0])
  end

  def self.find_by_name(name)
    sql = <<-SQL
        SELECT * FROM students WHERE name = (?)
    SQL
    row = DB[:conn].execute(sql, name)
    row.flatten! if row.size == 1
    student = new_from_db(row)
  end

  def update
    update_sql = <<-SQL
      UPDATE students SET name = (?), grade = (?) WHERE id = (?)
    SQL
    DB[:conn].execute(update_sql, self.name, self.grade, self.id)
  end

end
