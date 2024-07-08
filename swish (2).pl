%-------------------------------
% Tic-Tac-Toe Game in Prolog
%-------------------------------

% Main predicate to start the game.
% It displays the instructions and then starts the game.
start :-
    show_instructions,
    initialize_game.

% Display the game instructions to the players.
% This includes the welcome message, how to play, and the initial board layout.
show_instructions :-
    nl, write('Welcome to Tic-Tac-Toe!'), nl,
    write('Players X and O, alternate turns to make your moves.'), nl,
    write('Enter your move as a number (1-9) followed by a period.'), nl,
    write('The board is arranged as follows:'), nl,
    display_board([1,2,3,4,5,6,7,8,9]), nl.

% Start the game with an empty board and the first player (X).
initialize_game :-
    EmptyBoard = ['-','-','-','-','-','-','-','-','-'],
    game_loop(EmptyBoard, x).

% Display the current state of the board in a 3x3 format.
display_board([A,B,C,D,E,F,G,H,I]) :-
    format(' ~w | ~w | ~w ~n---+---+---~n ~w | ~w | ~w ~n---+---+---~n ~w | ~w | ~w ~n', [A,B,C,D,E,F,G,H,I]), nl.

% Main game loop, alternating turns between players.
% Checks for a win or a tie after each move.
game_loop(Board, Player) :-
    display_board(Board),
    (check_game_over(Board, Winner) ->
        (Winner == tie -> write('The game is a tie!'), nl;
         format('Player ~w wins!', [Winner]), nl);
    get_next_move(Board, Player, NewBoard),
    switch_turn(Player, NextPlayer),
    game_loop(NewBoard, NextPlayer)).

% Get the next move from the current player, validate it, and update the board.
get_next_move(Board, Player, NewBoard) :-
    format('Player ~w, enter your move: ', [Player]),
    read(Move),
    (is_valid_move(Board, Move) ->
        execute_move(Board, Move, Player, NewBoard);
    show_invalid_move_message, get_next_move(Board, Player, NewBoard)).

% Switch to the other player's turn.
switch_turn(x, o).
switch_turn(o, x).

% Validate the move by checking if the position is within the valid range and is empty.
is_valid_move(Board, Move) :-
    integer(Move), Move >= 1, Move =< 9,
    nth1(Move, Board, '-').

% Execute the move by placing the player's symbol at the specified position.
execute_move(Board, Move, Player, NewBoard) :-
    nth1(Move, Board, '-', Rest),
    nth1(Move, NewBoard, Player, Rest).

% Display a message indicating the move is invalid.
show_invalid_move_message :-
    write('Invalid move. Please try again.'), nl.

% Check if the game is over with a win or a tie.
check_game_over(Board, Winner) :-
    (check_win(Board, x) -> Winner = x;
     check_win(Board, o) -> Winner = o;
     is_board_full(Board) -> Winner = tie;
     fail).

% Check if the board is full with no empty cells left.
is_board_full(Board) :-
    \+ member('-', Board).

% Check if there is a win condition for any player (row, column, or diagonal).
check_win(Board, Player) :- check_row_win(Board, Player);
                            check_column_win(Board, Player);
                            check_diagonal_win(Board, Player).

% Check if there is a row win for the player.
check_row_win(Board, Player) :- Board = [Player,Player,Player,_,_,_,_,_,_];
                                Board = [_,_,_,Player,Player,Player,_,_,_];
                                Board = [_,_,_,_,_,_,Player,Player,Player].

% Check if there is a column win for the player.
check_column_win(Board, Player) :- Board = [Player,_,_,Player,_,_,Player,_,_];
                                   Board = [_,Player,_,_,Player,_,_,Player,_];
                                   Board = [_,_,Player,_,_,Player,_,_,Player].

% Check if there is a diagonal win for the player.
check_diagonal_win(Board, Player) :- Board = [Player,_,_,_,Player,_,_,_,Player];
                                     Board = [_,_,Player,_,Player,_,Player,_,_].

