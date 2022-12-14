:- include('KB.pl').

% Initial State
on_board(0, s0).
aloc(0, 1, s0).
passengers_on_ship(2, 2, 1, s0).
passengers_on_ship(1, 2, 1, s0).

% result(up, result(retrieve, result(down, s0))).

in_grid(A, B):-
     grid(X, Y),
     X1 is X - 1,
     Y1 is Y - 1,
     between(0, X1, A),
     between(0, Y1, B).
   
% Successor states
aloc(A, B, result(up, S)):-
     % in_grid(A, B),
     aloc(A1, B, S),
     A is A1 - 1.

aloc(A, B, result(down, S)):-
     % in_grid(A, B),
     aloc(A1, B, S),
     A is A1 + 1.

aloc(A, B, result(left, S)):-
     % in_grid(A, B),
     aloc(A, B1, S),
     B is B1 - 1.

aloc(A, B, result(right, S)):-
     % in_grid(A, B),
     aloc(A, B1, S),
     B is B1 + 1.

aloc(A, B, result(AC, S)):- 
     % in_grid(A, B),
     AC \== up,
     AC \== down,
     AC \== left,
     AC \== right,
     aloc(A, B, S).

% result(retrieve, result(right, result(down, s0))).

passengers_on_ship(A, B, 0, result(retrieve, S)):-
     on_board(X, S),
     capacity(Y),
     Y > X,
     aloc(A, B, S),
     passengers_on_ship(A, B, 1, S).

passengers_on_ship(A, B, X, result(AC, S)):-
     AC \== retrieve,
     passengers_on_ship(A, B, X, S).

% on_board(1, resukt(retrieve, result(down, result(retrieve, result(right, result(down, s0)))))).
on_board(A, result(retrieve, S)):-
     capacity(X),
     aloc(SX, SY, S),
     passengers_on_ship(SX, SY, 1, S),
     on_board(A2, S),
     A is A2 + 1,
     X >= A.

on_board(0, result(drop, S)):-
     aloc(SX, SY, S),
     station(SX, SY),
     on_board(PC, S),
     PC \== 0.

on_board(A, result(AC, S)):-
     AC \== retrieve,
     AC \== drop,
     on_board(A, S).

% Goal State
goal(S):-
     on_board(0, S),
     station(SX, SY),
     aloc(SX, SY, S),
     passengers_on_ship(2, 2, 0, S),
     passengers_on_ship(1, 2, 0, S).

ids(X,L):-
     (call_with_depth_limit(goal(X),L,R),number(R));
     (call_with_depth_limit(goal(X),L,R), R=depth_limit_exceeded, L1 is
     L+1, ids(X,L1)).