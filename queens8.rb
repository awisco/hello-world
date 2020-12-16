#queens8.rb
# version 3
# Adam Wisco and Hugo Bocker


# This version has been programmed so that sample output can be printed by the user
# Main resource used for confirmation of syntax, etc: https://www.tutorialspoint.com/ruby/index.htm

$solutions_array = Array.new
$solutions_boards = Array.new

# The main object that we'll be working with to find the solution
class Board
    @squares # to represent the actual chess board
    @range  # an easy range for iterating 0-7

    #creates the initial board
    def initialize
        @squares = Array.new(8) { Array.new(8, 0)}
         @range = (0..7)
    end # end of initialize

    # prints a readable version of the board
    def print_board
        @squares.each do | i |
            print " "
            puts "-" * 33
            i.each do | val |
                print " | "
                print val
            end
            puts " |"
        end
        print " "
        puts "-" * 33
        puts "\n"
    end # end of print_board


    # sets the "attackable" columns, rows and diagonals to closed from given coords
    def set_closed(x, y)
        # sets columns and rows to closed
        coords = Array.[](x, y)

        @range.each do | i |
            @squares[x][i] = 1
            @squares[i][y] = 1
        end

        # sets values to the right diagonals closed
        y_val_down = y
        y_val_up = y
        (x..7).each do | x_val |

            if y_val_down < 8 then
                @squares[x_val][y_val_down] = 1
                y_val_down += 1
            end

            if y_val_up > -1 then
                @squares[x_val][y_val_up] = 1
                y_val_up -= 1
            end
        end

        #sets values to left diagonals closed
        y_val_down = y
        y_val_up = y

        x.downto(0) do | x_val |

            if y_val_down < 8 then
                @squares[x_val][y_val_down] = 1
                y_val_down += 1
            end

            if y_val_up > -1 then
                @squares[x_val][y_val_up] = 1
                y_val_up -= 1
            end
        end

        @squares[x][y] = "Q"
    end # end of set_closed


    # sets the solution for the board to true
    def set_solution
        @solutions = true
    end


    # returns solutions
    def get_solution
        @solutions
    end


    # returns an array of the available spots in the given row
    def check_open(y)
        result = Array.new
        (0..7).each do | i |
            if @squares[i][y] == 0
                result.push(i)
            end
        end
        return result
    end # end of check_open

end # end of board definition




# function to find the actual correct answer recursively for a given board
# assumes that we are working from left to right
def find_answer(row , board, queens)
    open = board.check_open(row)

    if open.empty?
        #if there are no solutions here, so this doesn't work
        return []

    elsif row == 7 and queens.size() < 7
        #if we're at the last row, but don't have enough queens
        return []

    elsif row == 7 and queens.size() == 7 and open.size < 1
        # we're at the last row with no solution
        return []

    elsif row == 7 and queens.size() == 7 and open.size() == 1
        # we're at the last row, and we have a final solution

        # Creates a new board for us to use recursively
        new_board1 = Board.new
        queens.each do | coords |
            new_board1.set_closed(coords[0], coords[1])
        end
        new_board1.set_closed(open[0], row)
        new_board1.set_solution

        #creates the final array of coordinates the queens are at
        final = queens.push([open[0], row])

        $solutions_array.push(final)
        $solutions_boards.push(new_board1)

        return final

    else # we're not at last row, and we still have a solution to try from open

        open.each do | spot |
            new_board = Board.new

            queens.each do | coords |
                new_board.set_closed(coords[0], coords[1])
            end
            new_board.set_closed(spot, row)

            new_queens = Array.new
            new_queens.concat(queens)
            new_queens.push([spot, row])

            new_row = row + 1

            find_answer(new_row, new_board, new_queens)
        end
    end
end


# MAIN #


# coordinates are in [row, column] format, because I accidentally did it that way
# the whole time, sorry!!!!

board = Board.new
answer = find_answer(0, board, [])

p "Hello, pick a number from 1 to 92 to see a solution to the 8-queens problem, "
p " or 'all' to see all 92 distinct solutions!"

number = gets

if number.chomp == "all"
    $solutions_boards.each do | this |
        this.print_board
    end

else
    $solutions_boards[number.chomp.to_i-1].print_board
    p "Queen coordinates are: "
    p $solutions_array[number.chomp.to_i - 1]
    puts "\n"

    count = 1
    while count < 92
        p "Would you like to see another solution? 'n' for no and a number between 1 "
        p "and 92 for yes. "
        more  = gets

        if more.chomp == "n"
            p "Bye!"
            break
        else
            if more.to_i <= 0 || more.to_i > 92
                p "That's not a valid choice, please try again silly"
            else
                puts "\n"
                p "Board number: " + more.chomp
                $solutions_boards[more.to_i-1].print_board
                p "Queen coordinates are: "
                p $solutions_array[more.chomp.to_i - 1]
                puts "\n"
                count += 1
            end
        end
    end
end
