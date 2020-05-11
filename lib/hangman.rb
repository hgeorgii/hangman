require_relative 'hangman_methods'
require_relative 'hangman/game'
require 'json'

class Hangman
  include HangmanMethods

  attr_accessor :current_game

  def initialize
    @current_game = game_start

    play(@current_game)
  end

  def game_start
    puts 'Welcome to Hangman!'
    new_or_load
  end

  def new_or_load
    puts "Please write \'1\' for new game or \'2\' to load a game."
    input = gets.chomp

    case input
    when '1'
      new_game
    when '2'
      load_game
    else
      puts "I don't understand"
      new_or_load
    end
  end

  def new_game
    remaining_guesses = select_difficulty
    secret_word = generate_word

    Game.new(secret_word, remaining_guesses)
  end

  def load_game
    save = File.read('saves/saved_game.json')
    attributes = JSON.parse(save, symbolize_names: true)

    Game.new(
      attributes[:word],
      attributes[:remaining_guesses],
      attributes[:correct_guesses],
      attributes[:incorrect_guesses]
    )
  end

  def play(current_game)
    if game_over?(current_game)
      if current_game.remaining_guesses.zero?
        puts 'You lose!'
        puts
        puts "The word was #{current_game.word}"
      elsif word_to_display(current_game.word, current_game.correct_guesses).include?('_') == false
        puts 'You win!'
        puts
        puts "The word was #{current_game.word}."
      end
    else
      display_game
      input = get_input
      change_state(input)
      play(current_game)
    end
  end
end
