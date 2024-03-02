# Psalms Youtube

A collection of utility scripts to format YouTube videos and descriptions for
my [Weekly Psalm Recordings playlist](https://www.youtube.com/playlist?list=PLIT1yvoUgVytDLj7ecBa-9UffHJISzXN9)

## TODO list items

* [Extract a frame with a single timestamp](https://ottverse.com/extract-frames-using-ffmpeg-a-comprehensive-guide/#:~:text=Extracting%20the%20First%20Frame%20of%20a%20Video%20using%20FFmpeg,-Moving%20on%20to&text=This%20command%20is%20handy%20in,a%20preview%20of%20the%20video.&text=The%20%2Dframes%3Av%201%20argument,v%201%20before%20%2Di%20input.) - sample in ffmpeg-example.sh:
```sh
ffmpeg -ss 00:01:00 -i input.mp4 -frames:v 1 output.png
```
* Render using ffmpeg with a standardized audio volume reduction.. see [Audio Volume Manipulation](https://trac.ffmpeg.org/wiki/AudioVolume)
* Create title images with imagemagick [ImageMagick text with transparent background](https://stackoverflow.com/questions/39919143/imagemagick-text-with-transparent-background)
* Upload a YouTube video [Upload a Video - YouTube Data API](https://developers.google.com/youtube/v3/guides/uploading_a_video)
