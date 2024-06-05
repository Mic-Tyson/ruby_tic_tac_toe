# TODO
# 1. Add Input formating checking instead of just bounds checking
# 2. Add CPU

class Board
  attr_reader :SQUARES, :moves_made, :grid

  @@SQUARES = 3

  @@WIN_STATES = [
    [[0, 0], [0, 1], [0, 2]], # Rows
    [[1, 0], [1, 1], [1, 2]],
    [[2, 0], [2, 1], [2, 2]],
    [[0, 0], [1, 0], [2, 0]], # Columns
    [[0, 1], [1, 1], [2, 1]],
    [[0, 2], [1, 2], [2, 2]],
    [[0, 0], [1, 1], [2, 2]], # Diagonals
    [[0, 2], [1, 1], [2, 0]]
  ]

  @@PLAYER_MOVES = {
    1 => :player1,
    2 => :player2
  }

  def initialize
    @grid = Array.new(@@SQUARES) { Array.new(@@SQUARES) }
    @moves_made = 0
  end

  def reset
    @grid = Array.new(@@SQUARES) { Array.new(@@SQUARES) }
    @moves_made = 0
  end

  def add_move(j, i, ch)
    raise 'Invalid coordinates' if !i.between?(0, @@SQUARES - 1) || !j.between?(0, @@SQUARES - 1)
    raise 'Square taken' if grid[i][j]

    grid[i][j] = ch
    @moves_made += 1
    check_for_winner
  end

  private

  def check_for_winner
    @@WIN_STATES.each do |win_state|
      potential_win = win_state.map { |square| grid[square[0]][square[1]] }
      return @@PLAYER_MOVES[potential_win[0]] if potential_win.uniq.size == 1 && !potential_win[0].nil?
    end
    false
  end
end

class Game
  def initialize
    @board = Board.new
    @player1 = Player.new('Player 1', 'X')
    @player2 = Player.new('Player 2', 'O')
  end

  def query_input
    curr_player = @board.moves_made.even? ? 1 : 2
    puts "Make your move '(x,y)' Player #{curr_player}"
    loop do
      move = gets.chomp
      begin
        return @board.add_move(move[1].to_i, move[4].to_i, curr_player)
      rescue RuntimeError => e
        puts "Error: #{e.message} \n Please enter valid coordinates eg (1, 2)"
      end
    end
  end

  def display
    puts '   0 1 2'
    @board.grid.each_with_index do |row, i|
      print "#{i}  "
      row.each do |square|
        symbol = square == 1 ? @player1.symbol : square == 2 ? @player2.symbol : '-'
        print "#{symbol}|"
      end
      puts "\n   -----"
    end
  end

  def play
    display
    while @board.moves_made < 9
      winner = query_input
      display
      puts 'Player 1 wins' if winner == :player1
      puts 'Player 2 wins' if winner == :player2
      @board.reset if winner
    end
    puts 'Draw!'
    @board.reset
  end
end

class Player
  attr_reader :symbol

  def initialize(name, symbol)
    @name = name
    @symbol = symbol
    @score = 0
  end
end