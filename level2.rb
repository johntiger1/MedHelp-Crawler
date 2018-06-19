require 'open-uri'

File.open("other-post-urls.txt").each do |line|
  line.chomp!
  puts line
  `sleep 2`
  begin
    content = open("http://www.medhelp.org#{line}").read
    out = File.open("posts/#{line.gsub(/\//, '_')}", 'w')
    out.write(content)
  rescue Exception => ex
    puts "Error opening #{line}: #{ex.message}"
  end
end
