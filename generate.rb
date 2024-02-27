require 'yaml'

data=YAML.parse(ARGF.read).to_ruby
puts data

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

data['Weeks'].each do |week|
  File.open(week['liturgical_week_short']+"descriptions.txt", "wt+") do |f|
    data['Books'].each do |book|
      book['parts'].each do |part|
        puts "Filename: #{book['short_title']}_#{week['liturgical_week_short']}_#{book['short_publisher']}_#{short_part(part)}"
        puts part.snake_case
        puts "\"#{week[part.snake_case]['title']}\" - #{author(book, week)}"
      end
    end
  end
end
