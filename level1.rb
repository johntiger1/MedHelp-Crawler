require 'open-uri'
require 'open_uri_redirections'

File.open("other-toplevel.txt").each do |line|
  line.chomp!
  baseurl = line.split[0]
  max_num = line.split[1].to_i
  for id in 1..max_num
    puts "Crawling #{baseurl} page #{id}"
    `sleep 2`

    # begin end block is only for the rescue (exception handling) operation
    begin
      url = "#{baseurl}?page=#{id}"
      content = open(url, :allow_redirections => :safe).read
      filename = baseurl.gsub(/\//, "_")
      puts ("i am getting here")

      # ensure that crawled directory is already there!
      out = File.open("crawled/#{filename}.#{id}", 'w')
      out << content
    rescue => error
      puts "Error opening #{baseurl}: #{error}"
    end
  end
end
