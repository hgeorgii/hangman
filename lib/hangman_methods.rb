module HangmanMethods
  def select_difficulty
    puts 'Select difficulty:'
    puts 'easy   ----- 7 guesses'
    puts 'medium ----- 6 guesses'
    puts 'hard   ----- 5 guesses'

    input = gets.chomp.downcase
    message = "You selected #{input}."

    case input
    when 'easy'
      puts message
      puts
      7
    when 'medium'
      puts message
      puts
      6
    when 'hard'
      puts message
      puts
      5
    else
      puts "I don't understand, selected medium as default"
      puts
      6
    end
  end

  def generate_word
    word = ''

    word = File.readlines('dictionary.txt').sample.gsub(/\s+/, '') until word.size > 4 && word.size < 13

    word.downcase.split('')

    # TODO: Clean this up
    'test'.split('')
  end

  def display_game
    system('clear')

    puts '################################################################'
    puts
    puts "You have #{remaining_guesses} guesses left"
    puts
    p word_to_display(secret_word, correct_guesses)
    puts
    puts "Wrong guesses: #{incorrect_guesses}"
    puts
    puts '################################################################'
    puts
  end

  def word_to_display(word, correct_guesses)
    coded_word = word.map { '_' }

    correct_guesses.each do |guess|
      word.each_with_index do |correct_char, index|
        if guess == correct_char
          coded_word[index] = guess
        end
      end
    end

    coded_word
  end

  def get_input
    input = ''

    until input.size == 1 && input.match(/[a-z]/)
      puts "Please input a single unselected character from \'a\' to \'z\' or input \'save\' to save the game:"
      puts

      input = gets.chomp.downcase

      if input == 'save'
        input = ''
        save_game
        puts 'Game saved.'
        puts
      elsif all_guesses.include?(input)
        input = ''
        puts 'You already chose that one. Try again.'
        puts
      else
        puts "You chose \"#{input}\""
        puts
      end
    end

    input
  end

  def all_guesses
    correct_guesses + incorrect_guesses
  end

  def change_state(input)
    if secret_word.include?(input)
      correct_guesses << input
      puts "#{input} was correct."
      puts
    else
      incorrect_guesses << input
      remove_remaining_guess
      puts "#{input} was incorrect."
      puts
    end
  end

  def save_game
    game_attributes = {
      word: current_game.word,
      remaining_guesses: current_game.remaining_guesses,
      correct_guesses: current_game.correct_guesses,
      incorrect_guesses: current_game.incorrect_guesses
    }

    File.open('saves/saved_game.json', 'w') { |f| f.puts game_attributes.to_json }
  end

  def game_over?(game)
    if game.remaining_guesses.zero?
      true
    else
      word_to_display(game.word, game.correct_guesses).include?('_') == false
    end
  end

  private

  def correct_guesses
    current_game.correct_guesses
  end

  def remaining_guesses
    current_game.remaining_guesses
  end

  def incorrect_guesses
    current_game.incorrect_guesses
  end

  def secret_word
    current_game.word
  end

  def remove_remaining_guess
    current_game.remove_remaining_guess
  end
end
