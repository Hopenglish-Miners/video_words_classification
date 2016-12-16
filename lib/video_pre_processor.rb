class VideoPreProcessor
  def initialize
    @videos = load_videos
  end
  
  def videos
    if @videos != nil
      @videos
    else
      load_videos
    end
  end

  private
  def load_videos
    json = File.read(VIDEOS_FILE)
    array = JSON.parse(json)
    array
  end
end
