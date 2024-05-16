require 'sinatra'
require 'json'
require 'cgi'

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
set :bind, '0.0.0.0'
# set :port, 443

get '/' do # TODO: Cleanup to be an actual webpage with a template, maybe.
  "Howdy! <BR>I'm a dictionary service with #{wordlist.keys.length} words loaded<br>\   
  You can try the following commands:<br><Li> /randword?length=x will retrun a random word of that length </LI>\ 
  <LI> /randword?min_length=x&max_length=y will find a word between those lengths</LI>\ 
  <LI>/wordinfo?word=word will give you the info we have on that word.</LI>"
  end

get '/randword' do 
 requested_length = params['length']
 logger.info requested_length.nil?
 min_length = params['min_length']
 max_length = params['max_length']
 if min_length.to_i > max_length.to_i
   x=max_length
   max_length=min_length
   min_length=x
 end 
 if min_length.nil? #set sane defaults Dictionary only has between 2 and 15 letter words.
  min_length=2
 end 
 if max_length.nil?
  max_length=15
 end 
 word_subset=[]
 words = wordlist.keys
 if requested_length.to_i >= 2 && requested_length.to_i <16 # If an exact length is requested, we will oblige.
   logger.info requested_length
   words.each {|w| if w.length == requested_length.to_i; word_subset.push(w); end } # Pull out the exact length words
else
  # Moved to requiring min and max to be sane defaults, so we will use them, unless they are both at default - then we'll short circuit for efficency.
  unless min_length.to_i == 2 && max_length.to_i == 15
  words.each { |w| if (w.length >= min_length.to_i && w.length <= max_length.to_i); word_subset.push(w); end } # Pull words between min and max only.
  else 
   word_subset = wordlist.keys
  end  # unless min/max are default
 end # if requested_length
 logger.info word_subset.length #debug check that we don't still have an empty array

  selected_word = word_subset[rand(word_subset.length)]
  logger.info  selected_word # Log the selected word for audit purposes.
  logger.info wordlist[selected_word]
  out =  { 'word' => selected_word, 
           'definition' => wordlist[selected_word]['definition'], 
           'part_of_speech' => wordlist[selected_word]['speech_part']
          }
  out.to_json
end 

get '/wordinfo' do #A specific word was requested, so we will return all the information we have on it
  requested_word = params['word']
  human = params['human_readable']
  
  unless requested_word.nil? 
   wordinfo = wordlist[requested_word.upcase] unless wordlist[requested_word.upcase].nil?
   logger.info wordinfo.nil?
   if wordinfo.nil?
    # Word not found
    if human 
     ' <p> We are sorry, but the word you requested, ' + CGI.escape_html(requested_word) + ' is not in our dictionary</p> '
    else
      { 'error_message' => CGI.escape_html(requested_word) + 'was not found' }.to_json
    end # if human
  else # Word was found
    logger.info wordinfo  
    if human 
      CGI.escape_html(requested_word) + " <br><b>Definition:</b> #{wordinfo['definition']} <br>"

    else 
      out =  { 'word' => requested_word, 
            'definition' => wordinfo['definition'], 
            'part_of_speech' => wordinfo['speech_part']
            }
      out.to_json
    end # Human check 
  end #word not found check
  else  
    '{ "error_message": "You must request a word" }'
  end 
  
end



#put '/' do
#  "42\n"
#end
