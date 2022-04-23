defmodule GameOfLifeTest do
  use ExUnit.Case
  doctest GameOfLife
  doctest Board

  defp count_alive(board) do
    # Check first if all values are valid
    assert (board.cells |> Enum.map(fn cell_value -> (cell_value == 0 or cell_value == 1) end) |> Enum.all?)
    board.cells |> Enum.sum()
  end

  defp all_dead?(board) do
    count_alive(board) == 0
  end

  test "when all cells are dead the next tick they are still dead" do
    board = Board.empty_board(7,5)
    next_tick = GameOfLife.tick(board)

    assert next_tick.width == 7
    assert next_tick.height == 5
    assert (next_tick.cells |> Enum.map(fn x -> x==0 end) |> Enum.all?())
  end

  test "live cell with 0 live neighbors dies in next tick" do
    board = Board.new_board([{1,1}], 2, 2)
    next_tick = GameOfLife.tick(board)

    assert all_dead?(next_tick)
  end

  test "live cell with 1 live neighbors dies"  do
    board = Board.new_board([{0,1}, {0,2}], 2, 3)
    next_tick = GameOfLife.tick(board)

    assert Board.get_cell(next_tick, 0,1) == 0
    assert Board.get_cell(next_tick, 0,2) == 0
  end

  test "live cell with 4 neighbors dies" do
    board = Board.new_board([
                    {2,0},
      {0,1}, {1,1},
             {1,2}, {2, 2}
    ], 3, 3)
    next_tick = GameOfLife.tick(board)

    assert Board.get_cell(next_tick, 1,1) == 0
  end

  test "live cell with 5 neighbors dies" do
    board = Board.new_board([
             {2,2}, {3,2},
      {1,3}, {2,3},
             {2,4}, {3, 4}
    ], 7, 9)
    next_tick = GameOfLife.tick(board)

    assert Board.get_cell(next_tick, 2,3) == 0
  end

  test "live cell with 2 neighbors lives" do
    board = Board.new_board([
      {1,1},
      {1,2},
      {1,3}
    ], 5,5)
    next_tick = GameOfLife.tick(board)

    assert Board.get_cell(next_tick, 1,2) == 1
  end

  test "live cell with 3 neighbors lives" do
    board = Board.new_board([
      {3,1},
      {3,2},{4,2},
      {3,3}
    ], 6,6)
    next_tick = GameOfLife.tick(board)

    assert Board.get_cell(next_tick, 3,2) == 1
  end

  test "dead cell with 3 live neighbors becomes alive" do
    board = Board.new_board([{1,1}, {2,1}, {3,1}], 5,5)
    next_tick = GameOfLife.tick(board)

    assert Board.get_cell(next_tick, 2,0) == 1
  end

  # Still lives

  test "block (2*2 square of live cells) is a still live" do
    board = Board.new_board(GameOfLifePatterns.block(1,1), 4, 4)
    next_tick = GameOfLife.tick(board)

    # IO.puts(Board.to_string(board))

    assert Board.get_cell(next_tick, 1,1) == 1
    assert Board.get_cell(next_tick, 1,2) == 1
    assert Board.get_cell(next_tick, 2,1) == 1
    assert Board.get_cell(next_tick, 2,2) == 1

    assert count_alive(board) == 4
    assert board == next_tick
  end


  test "beehive is a still live" do
    board = Board.new_board(GameOfLifePatterns.beehive(1,1), 6, 6)
    next_tick = GameOfLife.tick(board)

    assert board == next_tick
  end

  test "blinker (horizontal strip of 3 live cells) rotates 90 degrees" do
    board = Board.new_board(GameOfLifePatterns.blinker(1,1), 6, 5)
    next_tick = GameOfLife.tick(board)

    expected_live_cells = [{2,0}, {2,1}, {2,2}]
    expected = Board.new_board(expected_live_cells, 6, 5)

    assert next_tick == expected
  end

  test "blinker has period 2" do
    board_0 = Board.new_board(GameOfLifePatterns.blinker(1,1), 4, 7)
    board_1 = GameOfLife.tick(board_0)
    board_2 = GameOfLife.tick(board_1)

    assert board_0 == board_2
    assert board_0 != board_1
  end



end
