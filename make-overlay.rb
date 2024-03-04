require 'rmagick'

# WIP - just laying out the basic structure of creating the image
class Overlay
  attr_reader :title, :composer
  def initialize(title:,composer:)
    @title = title
    @composer = composer
  end

  def render
    canvas = Magick::ImageList.new
    canvas.new_image(3840, 2160, Magick::HatchFill.new('white','lightcyan2'))
    text = Magick::Draw.new
    text.annotate(canvas, 0, 0, 0, 0, @title) do |txt|
      txt.font = 'Helvetica'
      txt.pointsize = 24
      txt.fill = 'black'
      txt.gravity = Magick::CenterGravity
    end
    text.annotate(canvas, 0, 0, 0, 30, @composer) do |txt|
      txt.font = 'Helvetica'
      txt.pointsize = 18
      txt.fill = 'black'
      txt.gravity = Magick::CenterGravity
    end
    canvas.write('overlay.png')
  end
end

overlay = Overlay.new(title: 'Symphony No. 9', composer: 'Ludwig van Beethoven')
overlay.render