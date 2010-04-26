#!/usr/bin/ruby1.8 -w

require 'digest/md5'

class Hasher
	# Constructor
	# method = "SHA1" or "MD5"
	# filepath = Full filepath
  def initialize(root)
    @root = root
    @file_count = 0
    @checksums = Hash.new(true)
  end

  def begin
    puts @root
    recurse_on_folder(@root)
    puts 'done'
    puts @file_count
    puts @checksums.count
    puts 'dups: ' + (@file_count - @checksums.count).to_s
  end

  def recurse_on_folder(dir)
    dirs = []
    Dir.foreach(dir) do |entry|
      fullpath = dir + '/' + entry
      if (entry[0] == 46 || entry == '..' )
      elsif File.file?(fullpath)
        @file_count += 1
        if @file_count%100 == 0
          puts @file_count
        end
        digest = Digest::MD5.hexdigest(File.open(fullpath, 'rb') {|f| f.sysread(1024)})
        if @checksums[digest]
          @checksums[digest] = false
        else
#          puts 'delete: ' + fullpath
          File.delete(fullpath)
        end
      elsif File::directory?(fullpath)
        dirs << fullpath
      end
    end
    dirs.each do |fullpath|
      recurse_on_folder(fullpath)
    end
  end

end

#Program starts
hasher = Hasher.new(ARGV[0])
hasher.begin


