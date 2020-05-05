require_relative 'hangman_methods'
require 'json'

class Hangman
  include HangmanMethods

  attr_accessor :game_over, :current_game

  def initialize(name = "Player")
    @game_over = false

    @current_game = {
                    player: name,
                    remaining_guesses: "default",
                    correct_guesses: [],
                    incorrect_guesses: [],
                    word: []
    }

    game_start
  end

  def game_start
    puts "Welcome to Hangman!"

    good_input = false

    until good_input
      puts "Please write \'1\' for new game or \'2\' to load a game."
      input = gets.chomp
        case input
        when "1"
          new_game
          good_input = true
        when "2"
          load_game
          good_input = true
        else
          puts "I don't understand"
        end
    end
  end

  def new_game
    current_game[:remaining_guesses] = select_difficulty
    current_game[:word] = generate_word

    play
  end

  def load_game
    save = File.read("saves/saved_game.json")
    @current_game = JSON.parse(save, symbolize_names: true)

    play
  end

  def play
    until game_over
    display_game
    input = get_input
    change_state(input)
    game_over?
    end
  end
end

Hangman.new
