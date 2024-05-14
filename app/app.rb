require 'sinatra'
p 'Starting to initilize..'
starttime=Time.now
rawlist=File.read('./wordlist')
endtime=Time.now
p 'Wordlist loaded in ' + (endtime-starttime).to_s + 'seconds'
p 'Parsing json..'
starttime=Time.now
wordlist=JSON.parse(rawlist)
endtime=Time.now
p 'Wordlist parsed in ' + (endtime-starttime).to_s + 'seconds'
#words = wordlist.keys # Just the words, definitions stay in the main object. Ruby does fun things with pointers to objects so this should just speed processing in the future
#p words.length
set :bind, '0.0.0.0'
# set :port, 443

get '/' do
  "42\n #{wordlist.keys.length}"
end

get '/randword' do 
 requested_length = params['length']
 word_subset=[]
 words = wordlist.keys
 if requested_length.to_i >= 2 && requested_length.to_i <16 # Dictionary only has from 2 up to 15 letters.
   logger.info requested_length
   words.each {|w| if w.length == requested_length.to_i; word_subset.push(w); end }
else
  word_subset = wordlist.keys
 end # if requested_length
 logger.info word_subset.to_json

  selected_word = word_subset[rand(word_subset.length)]
  logger.info  selected_word
  out =  { 'word' => selected_word, 
           'definition' => wordlist[selected_word]['definition'], 
           'part_of_speech' => wordlist[selected_word]['speech_part']
          }
  out.to_json
end 



put '/' do
  "42\n"
end
