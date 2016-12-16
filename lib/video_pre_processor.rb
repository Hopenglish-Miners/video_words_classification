require 'csv'
require 'json'
class VideoPreProcessor
  def initialize
    @videos = load_videos
    @vocabulary = parse_vocabulary
  end

  def videos
    if @videos != nil
      @videos
    else
      load_videos
    end
  end

  def vocabulary
    if @vocabulary != nil
      @vocabulary
    else
      parse_vocabulary
    end
  end

  def compare_videos_with_dictionary
    array = []

    @videos.each do |video|
      total_found = 0
      total_process = 0
      result = {}
      result["postId"] = video["postId"]
      result["l1"] = 0
      result["l2"] = 0
      result["l3"] = 0
      result["l4"] = 0
      result["l5"] = 0
      result["l6"] = 0
      video["wordList"].each do |word|
        @vocabulary.each_with_index do |level, index|
          if level.include? word
            total_found = total_found + 1
            result["l#{index + 1}"] = result["l#{index + 1}"] + 1
          end
          total_process = total_process + 1
        end
      end
      result["total_process"] = total_process
      result["total_found"] = total_found
      result["total_missed"] = total_process - total_found
      array << result
    end
    array
  end

  def run_pre_processor
    result = compare_videos_with_dictionary
    create_csv result
  end

  private
  def load_videos
    json = File.read(VIDEOS_FILE)
    array = JSON.parse(json)
    array
  end

  # Conver vocublary in a array of array of words
  # THe index +1 represent the level
  def parse_vocabulary
    json = File.read(VOCABULARY_FILE)
    object = JSON.parse(json)
    result = []
    (1..6).each do |i|
      result.push(object["LEVEL#{i}"]["words"])
    end
    result
  end

  def create_csv(pp_result)
    CSV.open("videos_compare_with_dictionary.csv", "wb") do |csv|
      csv << ["postId", "l1", "l2", "l3","l4","l5","l6","processed","found","missed"]
      pp_result.each { |result|
        csv << result.values
      }
    end
  end
end
