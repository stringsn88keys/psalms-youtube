require 'yaml'


data=YAML.parse(ARGF.read).to_ruby

def short_part(part)
  case part
  when /Psalm/
    'Psalm'
  when /Gospel/
    'Gospel'
  else
    part
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

def alternate_part(book, part, liturgy)
  liturgy.dig(part.snake_case, 'alt', book['short_title']) ||
    liturgy[part.snake_case]
end

def author(book, part, liturgy)
  book['author'] ||
  alternate_part(book, part, liturgy)['author']
end

def title(book, part, liturgy)
  case part
  when /Psalm/
    if liturgy[part.snake_case]['alt'][book['short_title']]&.[]('response')
      liturgy[part.snake_case]['alt'][book['short_title']]['response']
    else
      liturgy[part.snake_case]['title']
    end
  when /Gospel/
    liturgy[part.snake_case]['alt'][book['short_title']]['response']
  else
    alternate_part(book, part, liturgy)['title']
  end
end

def sub_description(book, part, liturgy)
  lines = []
  if liturgy['liturgy_name'] =~ / of /
    lines << "#{book['title']} #{part} for the #{liturgy['liturgy_name']}"
  else
    lines << "#{book['title']} #{part} for #{liturgy['liturgy_name']}"
  end

  if part =~ /Gospel/
    lines << "#{liturgy['gospel_acclamation']['verse']}"
  end
  lines.join("\n")
end

def extra
  [
  "Get the Psalm Recording links on Tuesdays by becoming a patron on Patreon patreon.com/ThomasPowell88Keys",
  "Yamaha #clavinova CLP-585 CFX Grand"
  ].join("\n")
end

def base_filename(book, part, liturgy)
  "#{book['short_title']}_#{liturgy['liturgy_short_name']}_#{book['short_publisher']}_#{short_part(part)}"
end

def parts(book, liturgy)
  liturgy['alternate_parts']&.[](book['short_title']) || book['parts']
end

data['Liturgies'].each do |liturgy|
  File.open(liturgy['liturgy_short_name']+"descriptions.txt", "wt+") do |f|
    f.puts "=== #{liturgy['liturgy_name']} ==="
    data['Books'].each do |book|
      parts(book, liturgy).each do |part|
        f.puts "Filename: "+ base_filename(book, part, liturgy)
        f.puts "\"#{title(book, part, liturgy)}\" - #{author(book, part, liturgy)}"
        f.puts sub_description(book, part, liturgy)
        f.puts extra
        f.puts "##{liturgy['liturgy_short_name']}"
        f.puts liturgy['other_tags'].map { |tag| "##{tag}" }.join ' '

        f.puts
      end
    end
  end
end
