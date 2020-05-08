class Hangman
  class Game
    attr_accessor :word, :remaining_guesses, :correct_guesses, :incorrect_guesses

    def initialize(word, remaining_guesses = 7, correct_guesses = [], incorrect_guesses = [])
      @word = word
      @remaining_guesses = remaining_guesses
      @correct_guesses = correct_guesses
      @incorrect_guesses = incorrect_guesses
    end

    def remove_remaining_guess
      @remaining_guesses -= 1
    end
  end
end
