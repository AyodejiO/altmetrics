require 'csv'
require 'json'
require 'optparse'

mode = ''
OptionParser.new do |opts|
  opts.banner = "Usage:  ruby combine.rb --format [format] [options]"
  
  opts.on("-f", "--format [format]", String, "data output format") do |opt|
    mode = opt
  end

end.parse!

journalsList = ARGV[0]
articlesList = ARGV[1]
authorsList = ARGV[2]

def validISSN issn
  if issn.length == 9 && issn.match(/^\d{4}-\d{3}[\dxX]$/)
    return issn
  else
    return issn.insert(4, '-')
  end
end

def formatEntry (entry, mode)
  if mode == "json"
    return entry
  else
    return entry.values.to_csv
  end
end

def formatOutput (array, mode)
  if mode == "json"
    puts JSON.pretty_generate(array)
    exit
  else
    if array.class == Hash
      array = [array.values.to_csv]
    end
    puts array.join
  end 
end

def combineData (mode, journalsList, articlesList, authorsList)
  # Checks the existence of these files 
  if !File.file?(articlesList) && !File.file?(articlesList) && !File.file?(authorsList)
    formatOutput({ error: "Error: One or more of the files does not exist" }, mode)
    exit
  end

  # check for the supported output modes 
  if mode.nil? || !["json", "csv"].include?(mode)
    formatOutput({ error:  "Error: Invalid output mode" }, mode)
    exit
  end

  journals = CSV.read(journalsList, headers: true)
  articles = CSV.parse(File.read(articlesList), headers: true)
  authors = JSON.parse(File.read(authorsList))

  outputArray = Array.new

  articles.each_with_index do |article, index|
    issn = validISSN(article["ISSN"])
    output = { doi: article['DOI'], title: article['Title'], author: '', journal: '', issn: issn }
    
    output[:journal] = (journals.select { |journal| validISSN(journal['ISSN']) == issn }).first['Title']

    output[:author] = authors.select { |author| author['articles'].include?(article['DOI']) }.first['name']

    outputArray << formatEntry(output, mode)
  end

  formatOutput(outputArray, mode)
end

combineData(mode, journalsList, articlesList, authorsList)
