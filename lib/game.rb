class Game
  attr_accessor :board, :player_1, :player_2, :timer

  COMBINATIONS = [
  [0, 1, 2],
  [3, 4, 5],
  [6, 7, 8],
  [0, 3, 6],
  [1, 4, 7],
  [2, 5, 8],
  [0, 4, 8],
  [6, 4, 2]
  ]

  def initialize(player_1 = Player::Human.new("X"), player_2 = Player::Human.new("O"), board = Board.new)
    @player_1 = player_1
    @player_2 = player_2
    @board = board
    @timer = 1.5
  end

  def current_player
    board.turn_count.even?  ? player_1 : player_2
  end

  def won?
    COMBINATIONS.find do |combo|
      board.cells[combo[0]] == board.cells[combo[1]] && board.cells[combo[1]] == board.cells[combo[2]] && board.cells[combo[0]] != " "
    end
  end

  def draw?
    board.full? && !won?
  end

  def over?
    won? || draw?
  end

  def winner
    board.cells[won?[0]] if won?
  end

  def turn
    puts "#{current_player.token}'s turn."
    input = current_player.move(board, timer).to_i
    if board.valid_move?(input.to_s)
      board.update(input, current_player)
      system('clear')
      board.display
    elsif input.between?(1, 9) == false
      puts "Invalid move!"
      turn
    else
      puts "Position is taken already!"
      turn
    end
  end
  
  def play
    board.reset!
    system('clear')
    board.display
    until over?
      turn
    end
    if draw?
      puts "WINNER: NONE"
    elsif won?
      puts "WINNER: #{winner}"
    end
  end
end
