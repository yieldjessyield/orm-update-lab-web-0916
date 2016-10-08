require_relative "../config/environment.rb"
require 'pry'

class Student

  attr_accessor :name, :grade, :id

  def initialize(id=nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        album TEXT
        )
        SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
        DROP TABLE IF EXISTS students
        SQL

    DB[:conn].execute(sql)
  end

  def save
    if self.id
      self.update
    else
      sql = <<-SQL
          INSERT INTO students (name, grade)
          VALUES (?,?)
        SQL
      DB[:conn].execute(sql, self.name, self.grade)
      #binding.pry
      @id = DB[:conn].execute("SELECT LAST_INSERT_ROWid() FROM students")[0][0]
      end
  end

  def update
    sql = <<-SQL
        UPDATE students SET name = ?, grade = ? WHERE id = ?
      SQL

    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

  def self.create(name, grade)
      student = self.new(name, grade)
      student.save
  end

  def self.new_from_db(row)
    id = row[0]
    name = row[1]
    grade = row[2]

    student = self.new(id, name, grade)
    student
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE students.name = ?"
    student_row = DB[:conn].execute(sql, name)[0]
    new_from_db(student_row)
  end

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]


end

#Pry.start
