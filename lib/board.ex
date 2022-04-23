
defmodule Board do
  # use constructor

  # constructor do
  #   field :width, :integer, constructor: &is_integer/1, enforce: true
  #   field :height, :integer, constructor: &is_integer/1, enforce: true
  #   field :cells, :list, constructor
  # end

  @enforce_keys [:width, :height, :cells]
  defstruct [:width, :height, :cells]

  def empty_board(width, height) do
    %Board{width: width, height: height, cells: List.duplicate(0, width*height)}
  end

  def new_board(live_cells, width, height) do
    live_indices = live_cells |> Enum.map(fn {x,y} -> idx(x,y,width, height) end)
    cells = 0 .. width*height - 1 |> Enum.map(fn i -> if i in live_indices do 1 else 0 end end)
    %Board{width: width, height: height, cells: cells}
  end

  defp idx(x,y,width,height) when 0 <= x and x < width and 0 <= y and y < height do
    y*width + x
  end

  def get_cell(board,x,y) when ((0 <= x and x < board.width) and (0 <= y and y < board.height)) do
    Enum.at(board.cells, idx(x,y,board.width, board.height))
  end
  def get_cell(board,x,y), do: 0

  ################################
  # For printing the board:      #
  ################################
  def to_string(board, emoji \\ false) do
    board.cells
      |> Enum.chunk_every(board.width)
      |> Enum.map(fn row ->
            row
              |> Enum.map(&cell_to_string(&1, emoji))
              |> Enum.join
          end)
      |> Enum.join("\n")
  end

  defp cell_to_string(cell_value, emoji) when emoji == false do
    case cell_value do
      0 -> "0"
      1 -> "1"
    end
  end

  defp cell_to_string(cell_value, emoji) when emoji == true do
    case cell_value do
      0 -> "⬛"
      1 -> "⬜"
    end
  end

end
