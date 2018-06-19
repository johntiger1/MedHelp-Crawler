Dir.foreach("crawled/") do |file|
  file.chomp!
  next if file == ".." or file == "."
  content = File.open("crawled/#{file}").read
  for m in content.scan(/a href="\/posts\/[^"]*\/show\/[0-9]+"/)
    puts m
  end
end
