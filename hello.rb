require 'sinatra'
# require 'sinatra/reloader'


class Cipher

  def caesar_cipher(inputStr, key)
      
    if !inputStr.nil?

      key = key % 26 if key > 26                                          # loops the key if it's larger than 26
      
      @key = key

      inputArr = inputStr.split('')

      outputArr = inputArr.map do |letter|

      newLetterOrd = letter.ord + @key
          
          if letter.ord >= 97 && letter.ord <= 122                        # if lower case letter

              newLetterOrd = newLetterOrd - 26 if newLetterOrd > 122      # loop from z - a if necessary

          elsif letter.ord >= 65 && letter.ord <= 90                      # if upper case letter

              newLetterOrd = newLetterOrd - 26 if newLetterOrd > 90       # loop from Z - A if necessary

          else                                                            # if not letter

              newLetterOrd = letter.ord                                   # do not add key

          end

          newLetterOrd.chr

      end

      outputStr = outputArr.join('')

    else

      outputStr = ''

    end # if !inputStr.nil?

      
    end # def caesar_cipher

    def simple_method(input)
      input.upcase
    end


  end # class Cipher

  
  
  
  
  # ----------------------------------------------------------------------------------------------------------
  # ----------------------------------------------------------------------------------------------------------
  # ----------------------------------------------------------------------------------------------------------
  # ----------------------------------------------------------------------------------------------------------
  # ----------------------------------------------------------------------------------------------------------
  # ----------------------------------------------------------------------------------------------------------
  # ----------------------------------------------------------------------------------------------------------
  # ----------------------------------------------------------------------------------------------------------
  # ----------------------------------------------------------------------------------------------------------
  
  
  class Hangman

    attr_accessor :hangman_output_message
    
    def initialize
      @completed = false
      @good_guess = false
      usable_words = []
      @letters = []
      @wrong = 0
      @temp_game_word = ""
      @cnt = 0
      @hangman_output = ""
      @hangman_output_message = hangman_output_message
      
      dictionary = File.open("5desk.txt").readlines.each do |line|
        if line.length > 6 && line.length < 13
          usable_words[@cnt] = line.chomp.downcase
          @cnt += 1
        end
      end
      @game_word = usable_words[rand(usable_words.length)]
      # @game_word = "cat" #temp
    end

    def play(letter)
      # puts "letter: #{letter}"
      # puts "@completed: #{@completed}"
      # puts "@game.word: #{@game_word}"
      # letter |= "A"
      if @completed == false && !letter.nil?
        @good_guess = false
        while @good_guess == false
          # @hangman_output = "Guess a letter."
          if letter.length == 1
            @good_guess = true 
          end
          letter.downcase!
        end # while @good_guess == false
        
        @letters.push(letter)
        @temp_game_word = @game_word.gsub(/[^#{@letters}]/,"_")
        
        if @game_word.include? letter
          # puts "here"
          @hangman_output = "#{@temp_game_word} (cheat: #{@game_word})"
          @hangman_output_message = "good job"
        else
          @hangman_output = "#{@temp_game_word} (cheat: #{@game_word})"
          @hangman_output_message = "try again"
          @wrong += 1
        end # if @game_word.include? letter
        
        unless @temp_game_word.include? "_"
          @completed = true
          @hangman_output = "#{@temp_game_word} (cheat: #{@game_word})"
          @hangman_output_message = "you win"
        end # unless @temp_game_word.include? "_"
        
        if @wrong > 5
          @hangman_output = "#{@temp_game_word} (cheat: #{@game_word})"
          @hangman_output_message = "You lose"
        end # if @wrong > 5
        
        return @hangman_output
      end # if @completed == false
    end # def play


    def simple_method(input)
      input.upcase
    end
    
  end #class Hangman
  
  
  
  
# ----------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------


# cipher = Cipher.new
hangman = Hangman.new

do_counter = 0

# puts "hangman.play('a'): #{hangman.play("a")}"
# puts "hangman.play('a').nil?: #{hangman.play("a").nil?}"

get '/' do
  
  encrypted_word = "nothing yet"
  if do_counter == 0
    hangman_output = "guess a letter above"
    hangman_output_message = "then hit 'submit'"
    # encrypted_word = "enter a word to encrypt, above, then hit 'encrypt'"
  else
    this_letter = params["hangman_letter"]
    hangman_output = hangman.play(this_letter)
    hangman_output_message = hangman.hangman_output_message
    # encrypted_word = cipher.caesar_cipher(params["word"],params["key"].to_i)
  end
  do_counter += 1
  




  erb :index, :locals => {:hangman_output_message => hangman_output_message, :hangman_output => hangman_output}

end