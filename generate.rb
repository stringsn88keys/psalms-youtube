require 'yaml'


data=YAML.parse(ARGF.read).to_ruby

def short_part(part)
  case part
  when /Psalm/
    'Psalm'
  when /Gospel/
    'Gospel'
  end
end

module StringHelpers
  refine String do
    def snake_case
      self.downcase.gsub(/ /, '_')
    end
  end
end

using StringHelpers

def author(book, part, week)
  book['author'] || week[part.snake_case]['alt'][book['short_title']]['author']
end

def title(book, part, week)
  case part
  when /Psalm/
    if week[part.snake_case]['alt'][book['short_title']]&.[]('response')
      week[part.snake_case]['alt'][book['short_title']]['response']
    else
      week[part.snake_case]['title']
    end
  when /Gospel/
    week[part.snake_case]['alt'][book['short_title']]['response']
  end
end

def sub_description(book, part, week)
  lines = []
  if week['liturgical_week'] =~ / of /
    lines << "#{book['title']} #{part} for the #{week['liturgical_week']}"
  else
    lines << "#{book['title']} #{part} for #{week['liturgical_week']}"
  end

  if part =~ /Gospel/
    lines << "#{week['gospel_acclamation']['verse']}"
  end
  lines.join("\n")
end

def extra
  [
  "Get the Psalm Recording links on Tuesdays by becoming a patron on Patreon patreon.com/ThomasPowell88Keys",
  "Yamaha #clavinova CLP-585 CFX Grand"
  ].join("\n")
end

def base_filename(book, part, week)
  "#{book['short_title']}_#{week['liturgical_week_short']}_#{book['short_publisher']}_#{short_part(part)}"
end

data['Weeks'].each do |week|
  File.open(week['liturgical_week_short']+"descriptions.txt", "wt+") do |f|
    f.puts "=== #{week['liturgical_week']} ==="
    data['Books'].each do |book|
      book['parts'].each do |part|
        f.puts "Filename: "+ base_filename(book, part, week)
        f.puts "\"#{title(book, part, week)}\" - #{author(book, part, week)}"
        f.puts sub_description(book, part, week)
        f.puts extra
        f.puts "##{week['liturgical_week_short']}"
        f.puts week['other_tags'].map { |tag| "##{tag}" }.join ' '

        f.puts
      end
    end
  end
end
