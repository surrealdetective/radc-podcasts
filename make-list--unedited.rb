class MP3
  attr_reader :file_location

  def initialize(file_location, args={})
    @file_location = file_location.to_s
  end

  def ==(other)
    self.to_s === other.to_s
  end

  def to_s
    "@#{_folder_name_location}, #:#{_mp3_file_num}"
  end

  def mark_as_edited!
    @edited = true
  end

  def edited?
    edited
  end
  
  private

  def _mp3_file_num
    /[.]\/meetings\/.*\/[0123456789]{3}/.match(file_location).to_s[-4..-1]
  end

  def _folder_name_location
    /[.]\/meetings\/[^\/]*\//.match(file_location).to_s
  end

  def edited
    @edited ||= false
  end
end

MP3FileFinder = Struct.new(:folder_location) do
  def run
    Dir[folder_location].map {|file| MP3.new(file) }
  end
end

MP3UneditedStatusSelector = Struct.new(:raw_files, :edited_files) do
  def run
    raw_files.select do |raw_mp3| 
      if !edited_files.include?(raw_mp3)
        true # as in yes, this is unedited
      else
        raw_mp3.mark_as_edited!
        false
      end
   end 
  end
end

class PlainLineLogic
  def write(f, content, options={})
    write_pre_content(f, options)
    f.write(content)
    write_post_content(f, options)
  end

  def write_pre_content(f, options); nil; end
  def write_post_content(f, options); f.write("\n") end
end

class ChecklistLineLogic < PlainLineLogic
  def write_pre_content(f, options)
    f.write(options[:needs_check] ? '[x] ' : '[ ] ')
  end
end

class ListWriter
  attr_reader :files, :list_location, :writer_logic

  def initialize(args={})
    @files         = Array(args[:files])
    @list_location = args[:list_location].to_s
    @writer_logic  = args.fetch(:writer_logic, PlainLineLogic.new)
  end

  def run!
    File.open(list_location, 'w') do |f|
      files.each do |mp3|
        writer_logic.write(f, mp3.file_location, {needs_check: mp3.edited?})
      end
    end    
  end
end

edited_mp3_files   = MP3FileFinder.new('./meetings/*/edited/*').run 
raw_mp3_files      = MP3FileFinder.new('./meetings/*/raw/*').run
unedited_mp3_files = MP3UneditedStatusSelector.new(
  raw_mp3_files, 
  edited_mp3_files
).run
ListWriter.new(
  files: unedited_mp3_files, 
  list_location: 'list--unedited.md', 
  writer_logic: PlainLineLogic.new
).run!
ListWriter.new(
  files: raw_mp3_files, 
  list_location: 'list--all.md', 
  writer_logic: ChecklistLineLogic.new
).run!