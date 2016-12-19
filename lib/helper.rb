require_relative 'video_pre_processor.rb'

# CONSTANT
VIDEOS_FILE = 'data/videoData_vs_WordList.json'
VIDEOS2_FILE = 'data/video_tags.json'
VOCABULARY_FILE = 'data/vocabulary.json'
VOCABULARY2_FILE = 'data/WordList-level1-6.csv'

# test
test = VideoPreProcessor.new
#puts test.compare_videos_with_dictionary
test.run_pre_processor
test.run_pre_processor2
