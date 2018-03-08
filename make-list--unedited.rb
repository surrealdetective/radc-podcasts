MP3 = Struct.new(:string) do
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
    /[.]\/meetings\/.*\/[0123456789]{3}/.match(string).to_s[-4..-1]
  end

  def _folder_name_location
    /[.]\/meetings\/[^\/]*\//.match(string).to_s
  end

  def edited
    @edited
  end
end

MP3FileFinder = Struct.new(:folder_location) do
  def run
    Dir[folder_location].map {|file| MP3.new(file) }
  end
end

edited_mp3_files = MP3FileFinder.new('./meetings/*/edited/*').run 
raw_mp3_files    = MP3FileFinder.new('./meetings/*/raw/*').run

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

unedited = MP3UneditedStatusSelector.new(raw_mp3_files, edited_mp3_files).run

# Write list--unedited.md
File.open('list--unedited.md', 'w') do |f|
  unedited.each do |mp3|
    f.write(mp3.string)
    f.write("\n")
  end
end

# Write list--all.md
File.open('list--all.md', 'w') do |f|
  raw_mp3_files.each do |mp3|
    mp3.edited? ? f.write("[x] ") : f.write("[ ] ")
    f.write(mp3.string)
    f.write("\n")
  end
end