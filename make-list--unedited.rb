MP3 = Struct.new(:file_location) do
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

ListWriter = Struct.new(:files, :list_location, :writer_logic) do
  def run!
    File.open(list_location, 'w') do |f|
      files.each do |mp3|
        writer_logic.write(f, mp3.file_location, mp3.edited?)
      end
    end
  end
end

class PlainLineLogic
  def write(f, content, status=nil)
    write_pre_content(f, status)    
    f.write(content)
    f.write("\n")
  end

  def write_pre_content(f, status); nil; end
end

class ChecklistLineLogic < PlainLineLogic
  def write_pre_content(f, status)
    f.write(status ? '[x] ' : '[ ] ')
  end
end

edited_mp3_files   = MP3FileFinder.new('./meetings/*/edited/*').run 
raw_mp3_files      = MP3FileFinder.new('./meetings/*/raw/*').run
unedited_mp3_files = MP3UneditedStatusSelector.new(raw_mp3_files, edited_mp3_files).run
ListWriter.new(unedited_mp3_files, 'list--unedited.md', PlainLineLogic.new).run!
ListWriter.new(raw_mp3_files, 'list--all.md', ChecklistLineLogic.new).run!