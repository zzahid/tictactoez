class Game
  attr_accessor :board, :player_1, :player_2, :timer

  def initialize(player_1 = Player::Human.new("X"), player_2 = Player::Human.new("O"), board = Board.new)
    @player_1 = player_1
    @player_2 = player_2
    @board = board
    @timer = 1.5
    @dim = 3
  end

  def current_player
    board.turn_count.even?  ? player_1 : player_2
  end

  def won?
    rows = board.cells.each_slice(@dim).to_a
    cols = []
    columns = []
    left_diag = []
    right_diag = []

    (0...@dim).each do |i|
      left_diag << rows[i][i]
      right_diag << rows[i][@dim-(i+1)]
      (0...rows.size).each do |j|
        cols << rows[j][i]
      end
      # rows check
      columns = cols.each_slice(@dim).to_a
      unless rows[i].all?(" ")
        if rows[i].all? { |x| x == rows[i][0] }
          return rows[i][0]
        end
      end
      # columns check
      unless columns[i].all?(" ")
        if columns[i].all? { |x| x == columns[i][0] }
          return columns[i][0]
        end
      end
    end
    # left diagonal check
    unless left_diag.all?(" ")
      if left_diag.all? { |x| x == left_diag[0] }
        return left_diag[0]
      end
    end
    # right diagonal check
    unless right_diag.all?(" ")
      if right_diag.all? { |x| x == right_diag[0] }
        return right_diag[0]
      end
    end
  end


  def draw?
    board.full? && !won?
  end

  def over?
    won? || draw?
  end

  def winner
    won?[0] if won?
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
