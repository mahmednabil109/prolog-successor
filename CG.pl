:- include('KB.pl').

% Successor State
coast_guard(X, Y, 0, REMAINING_SHIPS, s0):-
	agent_loc(X, Y),
	ships_loc(REMAINING_SHIPS).

coast_guard(X, Y, OB, RS, result(AC, S)):- 
	(coast_guard(X1, Y, OB, RS, S),  AC = up, X1 > 0, X is X1 - 1);
	(coast_guard(X, Y1, OB, RS, S),  AC = left, Y1 > 0, Y is Y1 - 1);
	(coast_guard(X1, Y, OB, RS, S),  AC = down, grid(N, _), X is X1 + 1, N > X);
	(coast_guard(X, Y1, OB, RS, S),  AC = right, grid(_, M), Y is Y1 + 1, M > Y);
	(coast_guard(X, Y, OB1, RS1, S), AC = pickup, member([X, Y], RS1), delete(RS1, [X, Y], RS), OB is OB1 + 1, capacity(C), C >= OB);
	(coast_guard(X, Y, OB1, RS, S), AC = drop, station(X, Y), OB = 0, OB1 > 0).

% Goal State
goal(S):-
	% station(X, Y),
	call_with_depth_limit(coast_guard(_, _, 0, [], S), 13, _).

ids(X,L):-
     (call_with_depth_limit(goal(X),L,R),number(R));
     (call_with_depth_limit(goal(X),L,R), R=depth_limit_exceeded, L1 is
     L+1, ids(X,L1)).
