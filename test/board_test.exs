defmodule BoardTest do
  use ExUnit.Case
  doctest Board

  defp all_dead?(board) do
    assert (board.cells |> Enum.map(fn x -> x==0 end) |> Enum.all?())
  end

  test "can create an empty board" do
    board = Board.empty_board(3,4)

    assert board.width == 3
    assert board.height == 4
    assert length(board.cells) == 3*4
    assert all_dead?(board)
  end

  test "creating board with a single live cell works" do
    board = Board.new_board([{2,3}], 5, 6)

    assert board.width == 5
    assert board.height == 6
    assert length(board.cells) == 5*6
    assert Enum.at(board.cells, 5*3 + 2) == 1

    other_cells = List.delete_at(board.cells, 5*3 + 2)
    assert (other_cells |> Enum.map(fn x -> x==0 end) |> Enum.all?())
  end

  test "creating board with multiple live cell works" do
    board = Board.new_board([{1,1}, {1,2}, {0,0}], 3, 5)

    assert length(board.cells) == 3*5

    assert Enum.at(board.cells, 3*1 + 1) == 1
    assert Enum.at(board.cells, 3*2 + 1) == 1
    assert Enum.at(board.cells, 0) == 1
  end

  test "getting cell at (x,y) coordinate returns correct cell" do
    board = Board.new_board([{1,2}], 7, 3)
    cell = Board.get_cell(board, 1, 2)

    assert cell == 1
  end

end
