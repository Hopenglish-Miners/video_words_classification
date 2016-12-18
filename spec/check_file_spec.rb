require 'minitest/autorun'
require 'json'
require_relative '../lib/helper.rb'

describe 'Check we have necesary file' do
  it 'should check if we have vocabulary.json' do
    json = File.read(VIDEOS_FILE)
    obj = JSON.parse(json)
    obj.size > 0
  end

  it 'should check if we have videoData_vs_WordList.json' do
    json = File.read(VOCABULARY_FILE)
    obj = JSON.parse(json)
    obj.size > 0
  end
end

describe 'Check behavior' do
  before do
    @classificator = VideoPreProcessor.new
  end

  it 'should check if video sample has correct format' do
    sample = @classificator.videos.sample
    sample["postId"].wont_be_empty
    sample["wordList"].wont_be_empty
  end

  it 'should check that vocaubulary1 array have size 6' do
    vocabulary = @classificator.vocabulary1
    vocabulary.size == 6
  end

  # This vocabulary has 6 categories
  # cat: [A1,A2,B1,B2,C1,C2]
  it 'should check that vocabulary2 array has also size 6' do
    #vocabulary = @classificator.vocabulary
  end

  it 'should return each video with correct format' do
    sample = @classificator.compare_videos_with_dictionary.sample
    (1..6).each do |i|
      sample["l#{i}"].wont_be_nil
    end
  end
end
