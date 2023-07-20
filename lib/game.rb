# frozen_string_literal: true

require 'bundler'
Bundler.require

require_relative 'player'
require_relative 'board'
require_relative 'colors'

# The Game class that controls the flow of the Tic Tac Toe game
class Game
  attr_accessor :player1, :player2, :turn

  # Initializes the game, players and the game board
  def initialize
    welcome # Welcome message for the players
    (@player1 = Player.new(1, 'X')).ask_name  # Create and ask for Player 1's name
    (@player2 = Player.new(2, 'O')).ask_name  # Create and ask for Player 2's name
    puts "\n#{BRIGHT_RED}#{BOLD}#{RAPID_BLINK}Let's Fight !#{RESET}"
    @games = 0
    @current_player = @player1 # The game starts with Player 1's turn
    @board = Board.new # Initialize a new game board
  end

  # Resets the game board for a new game
  def reset_board
    @board.reset
  end

  # Prints a welcome message for the game
  def welcome
    puts <<-ACCUEIL

    #{BRIGHT_BLUE_BG}#{BLACK}#{BOLD}-----------------------------------------------------#{RESET}
    #{BRIGHT_BLUE_BG}#{BLACK}#{BOLD}|           Bienvenue sur 'LE MORPION' !            |#{RESET}
    #{BRIGHT_BLUE_BG}#{BLACK}#{BOLD}|    Le but du jeu est d'aligner 3 de tes signes    |#{RESET}
    #{BRIGHT_BLUE_BG}#{BLACK}#{BOLD}|     à l'horizontale, verticale ou en diagonale    |#{RESET}
    #{BRIGHT_BLUE_BG}#{BLACK}#{BOLD}-----------------------------------------------------#{RESET}
    ACCUEIL
  end

  # Checks if the game is finished by checking for winning combinations
  def finished?
    winning_combinations = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
    player_marks = { 'X' => @player1, 'O' => @player2 }

    # Loop over each combination to see if all elements are the same
    # If they are, that means the current player won, so we return true
    winning_combinations.each do |combination|
      player_marks.each do |mark, player|
        if combination.all? { |i| @board.cells[i] == mark }
          @winning_player = player
          return true
        end
      end
    end

    # If all cells are filled and we have not returned yet, the game is a tie, return true
    return true if @board.cells.none? { |cell| cell.match?(/[1-9]/) }

    false # The game is not finished yet
  end

  # Asks whose turn is next
  def ask_whos_next
    puts "\nC'est le tour de #{BOLD}#{BRIGHT_CYAN}#{@current_player.name}#{RESET}"
  end

  # Shows the current state of the game board
  def show_board
    @board.show
  end

  # Asks the current player for the cell they want to mark
  def ask_which_cell
    puts "\n#{BOLD}#{BRIGHT_MAGENTA}Choisis la case que tu veux cocher (entre 1 et 9)#{RESET}"
    print "#{BRIGHT_YELLOW}> #{RESET}"
    loop do
      input = gets.chomp.to_i
      if input.between?(1, 9)
        return input unless @board.cells[input - 1].match?(/[XO]/)

        puts "#{BRIGHT_RED}#{BOLD}La case est déjà prise ! Choisis en une autre#{RESET}"

      else
        puts "#{BRIGHT_RED}#{BOLD}Entre un chiffre entre 1 et 9.#{RESET}"
      end
      print "#{BRIGHT_YELLOW}> #{RESET}"
    end
  end

  # Updates the chosen cell with the current player's sign
  def make_current_player_draw_in_cell(number)
    @current_player.draw_in_cell(@board, number)
  end

  # Switches the turn to the other player
  def switch_player
    @current_player = @current_player == @player1 ? @player2 : @player1
  end

  # Shows the number of games played so far
  def show_games_played
    @games += 1
    puts "\n#{BRIGHT_YELLOW}#{@games}#{RESET} partie(s) joué(e)s"
  end

  # Shows the current number of wins for each player
  def show_winning_count
    p1 = @player1
    p2 = @player2
    p1_color = p1.wins > p2.wins ? BRIGHT_GREEN : BRIGHT_RED
    p2_color = p2.wins > p1.wins ? BRIGHT_GREEN : BRIGHT_RED

    puts "\n#{p1.name} #{p1_color}#{p1.wins}#{RESET} - #{p2_color}#{p2.wins}#{RESET} #{p2.name}"
  end

  # Ends the game, declaring the winner or if it's a tie
  def end
    puts "\n#{BRIGHT_BLUE}#{BOLD}La partie est finie#{RESET}"
    if @winning_player == @player1
      puts "\n#{BOLD}#{BRIGHT_GREEN}#{RAPID_BLINK}#{@player1.name} a gagné#{RESET}"
      @player1.wins += 1
    elsif @winning_player == @player2
      puts "\n#{BOLD}#{BRIGHT_GREEN}#{RAPID_BLINK}#{@player2.name} a gagné#{RESET}"
      @player2.wins += 1
    else
      puts "\n#{BRIGHT_WHITE_BG}#{BLACK}#{SLOW_BLINK}MATCH NUL"
    end
  end

  # Asks if the players want to retry
  def retry?
    loop do
      puts "\n#{BRIGHT_MAGENTA}Veux-tu prendre ta revanche ? O/N#{RESET}"
      print "#{BRIGHT_YELLOW}> #{RESET}"
      input = gets.chomp.downcase
      case input
      when 'o', 'oui'
        return true
      when 'n', 'non'
        return false
      else
        puts "Réponds avec 'o', 'oui', 'n', ou 'non'."
      end
    end
  end
end
