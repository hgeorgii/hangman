module HangmanMethods
  def select_difficulty
    puts "Select difficulty:"
    puts "\'easy\'-----7 guesses"
    puts "\'medium\'---6 guesses"
    puts "\'hard\'-----5 guesses"

    input = gets.chomp.downcase
    message = "You selected #{input}."

    case input
    when "easy"
      puts message
      puts
      7
    when "medium"
      puts message
      puts
      6
    when "hard"
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
    word = ""

    word = File.readlines("dictionary.txt").sample.gsub(/\s+/, "") until word.size > 4 && word.size < 13

    word.downcase.split("")
  end

  def display_game
    puts "################################################################"
    puts
    puts "You have #{current_game[:remaining_guesses]} guesses left"
    puts
    p word_to_display
    puts
    puts "Wrong guesses: #{current_game[:incorrect_guesses]}"
    puts
    puts "################################################################"
    puts
  end

  def word_to_display
    word_to_display = []

    current_game[:word].each { |char| word_to_display << "_" }

    current_game[:correct_guesses].each do |guess|
      current_game[:word].each_with_index do |correct_char, index|
        if guess == correct_char
          word_to_display[index] = guess
        end
      end
    end

    word_to_display
  end

  def get_input
    input = ""

    until input.size == 1 && input.match(/[a-z]/)
      puts "Please input a single unselected character from \'a\' to \'z\' or input \'save\' to save the game:"
      puts

      input = gets.chomp.downcase

      if input == "save"
        input = ""
        save_game
        puts "Game saved."
        puts
      elsif all_guesses.include?(input)
        input = ""
        puts "You already chose that one. Try again."
        puts
      else
        puts "You chose \"#{input}\""
        puts
      end
    end

    input
  end

  def all_guesses
    current_game[:correct_guesses] + current_game[:incorrect_guesses]
  end

  def change_state(input)
    if current_game[:word].include?(input)
      current_game[:correct_guesses] << input
      puts "#{input} was correct."
      puts
    else
      current_game[:incorrect_guesses] << input
      current_game[:remaining_guesses] -= 1
      puts "#{input} was incorrect."
      puts
    end
  end

  def save_game
    File.open("saves/saved_game.json", "w") { |f| f.puts current_game.to_json }
  end

  def game_over?
    if current_game[:remaining_guesses] == 0
      puts "You lose!"
      puts
      puts "The word was #{current_game[:word]}"
      puts
      @game_over = true
    elsif word_to_display.include?("_") == false
      puts "You win!"
      puts
      puts "The word was #{current_game[:word]}."
      puts
      @game_over = true
    else
      @game_over = false
    end
  end
end
