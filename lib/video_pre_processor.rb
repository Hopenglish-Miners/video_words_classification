require 'csv'
require 'json'
class VideoPreProcessor
  def initialize
    @videos = load_videos
    @vocabulary1 = parse_vocabulary1
    @vocabulary2 = parse_vocabulary2
  end

  def videos
    if @videos != nil
      @videos
    else
      load_videos
    end
  end

  def vocabulary1
    if @vocabulary1 != nil
      @vocabulary1
    else
      parse_vocabulary1
    end
  end


  def vocabulary2
    if @vocabulary2 != nil
      @vocabulary2
    else
      parse_vocabulary2
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
        @vocabulary1.each_with_index do |level, index|
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

  def compare_videos_with_dictionary2
    array = []
    index_to_level = ["a1","a2","b1","b2","c1","c2"]
    @videos.each do |video|
      total_found = 0
      total_process = 0
      result = {}
      result["postId"] = video["postId"]
      result["a1"] = 0
      result["a2"] = 0
      result["b1"] = 0
      result["b2"] = 0
      result["c1"] = 0
      result["c2"] = 0
      video["wordList"].each do |word|
        @vocabulary2.each_with_index do |level, index|
          if level.include? word
            total_found = total_found + 1
            result[index_to_level[index]] = result[index_to_level[index]] + 1
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

  def run_pre_processor2
    result = compare_videos_with_dictionary2
    create_csv2 result
  end

  private
  def load_videos
    json = File.read(VIDEOS_FILE)
    array = JSON.parse(json)
    array
  end

  # Conver vocublary in a array of array of words
  # THe index +1 represent the level
  def parse_vocabulary1
    json = File.read(VOCABULARY_FILE)
    object = JSON.parse(json)
    result = []
    (1..6).each do |i|
      result.push(object["LEVEL#{i}"]["words"])
    end
    result
  end

  def parse_vocabulary2
    mapping = {}
    CSV.foreach(VOCABULARY2_FILE) do |row|
      if mapping[row[1]]
        mapping[row[1]].push(row[0])
      else
        value = []
        value.push(row[0])
        mapping[row[1]] = value
      end
    end
    # just return the values
    mapping.values
  end

  def create_csv(pp_result)
    CSV.open("videos_compare_with_dictionary.csv", "wb") do |csv|
      csv << ["postId", "l1", "l2", "l3","l4","l5","l6","processed","found","missed"]
      pp_result.each { |result|
        csv << result.values
      }
    end
  end
  def create_csv2(pp_result)
    CSV.open("videos_compare_with_dictionary2.csv", "wb") do |csv|
      csv << ["postId", "a1", "a2", "b1","b2","c1","c2","processed","found","missed"]
      pp_result.each { |result|
        csv << result.values
      }
    end
  end
end
