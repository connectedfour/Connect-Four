class Board
  attr_reader :columns, :current_row, :current_column
  def initialize
    @columns = Array.new(7) { Column.new }
  end

  def get_value_at(column_num, row)
    @columns[column_num].get_value_at(row)
  end

  def insert(column_num, token)
    return if @columns[column_num - 1].number_of_pieces == 6
    @current_row = @columns[column_num - 1].insert(token) - 1
    @current_column = column_num - 1
  end

  def column_values
    column_values = []
    0.upto(5) { |row| column_values << @columns[@current_column].get_value_at(row) }
    column_values
  end

  def row_values
    row_values = []
    0.upto(6) { |column_num| row_values << @columns[column_num].get_value_at(@current_row) }
    row_values
  end

  def positive_diagonal_values
    diagonal_values = []
    row_num = 0
    column_num = 0
    row_num = @current_row - @current_column if @current_row > @current_column
    column_num = @current_column - @current_row if @current_column > @current_row
    while column_num < 7 && row_num < 6
      diagonal_values << @columns[column_num].get_value_at(row_num)
      column_num += 1
      row_num += 1
    end
    diagonal_values
  end

  def negative_diagonal_values
    diagonal_values = []
    sum = @current_row + @current_column
    if sum <= 6
      column_num = sum
      row_num = 0
    else
      column_num = 6
      row_num = sum - 6
    end
    while row_num < 6
      diagonal_values << @columns[column_num].get_value_at(row_num)
      column_num -= 1
      row_num += 1
    end
    diagonal_values
  end

  def connect_four?(values)
    o_win = ["O", "O", "O", "O"]
    x_win = ["X", "X", "X", "X"]
    values.each_cons(4).any? { |four| four == o_win || four == x_win }
  end

  def win?
    connect_four?(column_values) || connect_four?(row_values) || connect_four?(positive_diagonal_values) || connect_four?(negative_diagonal_values)
  end

  def full?
    row_values.all? { |value| value != "." } && @current_row == 5
  end

  def to_s
    5.downto(0) do |row_num|
      row_values = []
      0.upto(6) { |column_num| row_values << @columns[column_num].get_value_at(row_num) }
      puts row_values.join(' | ')
    end
    puts "-" * 25 + "\n1 | 2 | 3 | 4 | 5 | 6 | 7"
    return
  end

  def to_twitter
    board_str = ""
    5.downto(0) do |row_num|
      row_values = []
      0.upto(6) { |column_num| row_values << @columns[column_num].get_value_at(row_num) }
      board_str += "|" + row_values.join
    end
    board_str += "|"
    return board_str
  end

  def self.from_string(s)
    puts "in method self.from_string"
    board = Board.new
    p s.gsub("|", "")
    c4_array = s.gsub("|", "").split(//).each_slice(7).to_a.reverse
    c4_array.each do |row|
      row.each_with_index { |token, index| board.insert(index + 1, token) if token == 'X' || token == 'O' }
    end
    puts "leaving method ..."
    board
  end
end
