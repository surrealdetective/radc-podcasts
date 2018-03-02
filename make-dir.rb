require 'rubygems'
require 'rake'
require 'pry'
include Forwardable

class NewDirectoryMaker
  extend Forwardable

  attr_reader :meeting
  def_delegators :meeting, :meeting_name

  def initialize(num, description)
    @meeting = Meeting.new(num, description.downcase.split(" ").join('-'))
  end

  def make!
    make_new_directory!
    make_raw_and_edited_subdirectories!
    puts "see your new directories:"
    puts "./meetings/#{meeting_name}"
    puts "./meetings/#{meeting_name}/raw"
    puts "./meetings/#{meeting_name}/edited"
  end

  private
  def make_new_directory!
    Dir.mkdir "meetings/#{meeting_name}"
  end

  def make_raw_and_edited_subdirectories!
    Dir.mkdir "meetings/#{meeting_name}/raw"
    Dir.mkdir "meetings/#{meeting_name}/edited"
  end

  public 
  Meeting = Struct.new(:meeting_num, :description) do
    def meeting_name
      "#{next_meeting_num}-#{meeting_type}-#{description}"
    end

    protected 

    def next_meeting_num
      next_num = (last_folder[11..13].to_i + 1)
      case next_num.to_s.length
      when 1 then "00#{next_num}"
      when 2 then "0#{next_num}"
      when 3 then next_num
      end
    end

    def last_folder
      folders.last
    end

    def folders
      @folders ||= Dir['./meetings/*'].grep(/[.]\/meetings\/[0123456789]{3}-#{meeting_type}/)
    end

    # refactor: switch to having one place to add new meeting types
    # re-use here and in Asker
    def meeting_type
      @meeting_type ||= case meeting_num
        when 1 then 'gen'
        when 2 then 'masc'
      end
    end
  end

end

class Asker
  def intro
    puts "Hey there!"
    puts "I'm going to ask 2 questions to make the directories in the proper format"    
  end

  def q1
    puts "Is this a general or masculinity meeting?"
    puts "type 1 for general and 2 for masculinity"    
  end
end

asker = Asker.new
asker.intro
asker.q1
while ![1, 2].include?(meeting_type = gets.chomp.to_i)
  asker.q1
end

puts "cool! Now, last question: please describe in a 3-10 words what topics you covered in this meeting:"
description = gets.chomp

maker = NewDirectoryMaker.new(meeting_type, description)
maker.make!