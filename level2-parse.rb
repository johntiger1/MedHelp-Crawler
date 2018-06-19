require 'nokogiri'

def get_author_info(noko)
  authors, are_profs, reply_to = [], [], []
  idx = 0
  for author in noko.xpath('//div[starts-with(@class, "user_info")]')
    if author.xpath('.//div/span//a/text()').size > 0 and idx == 0
      authors << author.xpath('.//div/span//a/text()').text.gsub(/ Comment.*/, "")
      idx += 1
      are_profs << author.xpath('.//div/span//img').size
      reply_to << "NA"
    end
    if author.xpath('.//div/span//a/text()').size > 0 and idx == 1
      idx += 1
      next
    end
    if author.xpath('.//div[@class="question_by"]/span//a/text()').size > 0 and idx > 1
      authors << author.xpath('.//div[@class="question_by"]/span//a/text()')[0]
      idx += 1
      are_profs << author.xpath('.//div[@class="question_by"]/span//img').size
    end
    reply_person = "NA"
    reply_len = author.xpath('.//div[@class="post_question_forum_to"]//a/text()').size
    if reply_len > 0
      reply_person = author.xpath('.//div[@class="post_question_forum_to"]//a/text()')[0].text
    end
    reply_to << reply_person.strip
  end
  [authors, are_profs, reply_to]
end

def get_dates(noko)
  post_dates = noko.xpath('//div[starts-with(@class, "user_info")]//div/text()')
  dates = []
  for date in post_dates
    date = date.text.strip
    dates << date if date.match(/[a-zA-Z]+ [0-9][0-9], [12][0-9][0-9][0-9]/)
  end
  dates
end

def get_posts(noko)
  puts "get_posts"
  posts = []
  for content in noko.xpath('//div[starts-with(@class, "post_message")]//div/text()') #noko.xpath('//div[@class="posts_wrapper"]')
    #content = content.xpath('.//div[@class="post_message"]')
    puts "content1: #{content}"
    #content = content.to_a.join(" ")#.gsub(/[\r\n]/, " ")
    #content = content.gsub(/[\r\n]/, " ")
    puts "content2: #{content}"
    #posts << content.gsub(/[\t ]+/, " ")
    puts "content3: #{content}"
    if !(content == "" || content == "\n")
      posts << content
    end
  end
  posts
end

def process(noko, output, post_id, file)
  dates = get_dates(noko)
  #authors, are_profs, reply_to = get_author_info(noko)
  posts = get_posts(noko)
  order = 1
  title = noko.xpath('//div[@class="ss_header"]/div[@class="desc"]/@title').text
  #for user_id, is_pro, content, rep_author, date in authors.zip(are_profs, posts, reply_to, dates)
  for content in posts
    #output << "#{post_id}\t#{order}\t#{user_id}\t#{file.gsub(/_/, '/')}\t"
    #output << "#{is_pro}\t#{content}\t#{rep_author}\t#{title}\t#{date}\n"
    if !(content =~ /^\s*$/)
      output << "#{content}\n"
      puts "text: #{content}"
    end
    order += 1
  end
end

def main()
  output = File.open("output-women.txt", 'w')
  post_id = 0
  Dir.foreach("posts/women/") do |file|
    file.chomp!
    next if file == "." or file == ".."
    content = File.open("posts/women/#{file}").read
    noko = Nokogiri::HTML(content)
    process(noko, output, post_id, file)
    post_id += 1
  end
end

main()
