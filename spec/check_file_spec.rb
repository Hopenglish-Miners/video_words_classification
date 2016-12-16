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
    @classificator = VideoPreProcesor.new
  end

  it 'shoul check if video is loaded' do
    sample = @classificator.videos.sample
    sample["postId"].wont_be_empty
    sample["wordList"].wont_be_empty
  end
end
