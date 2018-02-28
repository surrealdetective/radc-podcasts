MP3 = Struct.new(:string) do
  def ==(other)
    self.to_s === other.to_s
  end

  def to_s
    "#{_folder_name_location} #{_mp3_file_num}"
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

# Create list of files
edited   = Dir['./meetings/*/edited/*'].map {|file| MP3.new(file) }
raw      = Dir['./meetings/*/raw/*'].map {|file| MP3.new(file) }
unedited = raw.select do |raw_mp3| 
            if !edited.include?(raw_mp3)
              true # as in yes, this is unedited
            else
              raw_mp3.mark_as_edited!
              false
            end
           end 

# Write list--unedited.md
File.open('list--unedited.md', 'w') do |f|
  unedited.each do |mp3|
    f.write(mp3.string)
    f.write("\n")
  end
end

# Write list--all.md
File.open('list--all.md', 'w') do |f|
  raw.each do |mp3|
    mp3.edited? ? f.write("[x] ") : f.write("[ ] ")
    f.write(mp3.string)
    f.write("\n")
  end
end