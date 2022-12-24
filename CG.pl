:- include('KB.pl').

% Successor State
coast_guard(X, Y, 0, REMAINING_SHIPS, s0):-
	agent_loc(X, Y),
	ships_loc(REMAINING_SHIPS).

coast_guard(X, Y, OB, RS, result(AC, S)):-
	coast_guard(X1, Y1, OB1, RS1, S),
	(
		(X is X1 - 1, X >= 0, Y1 = Y, OB1 = OB, RS1 = RS, AC = up);
		(X is X1 + 1, grid(M, _), X < M , Y1 = Y, OB1 = OB, RS1 = RS, AC = down );
		(Y is Y1 - 1, Y >= 0, X1 = X, OB1 = OB, RS1 = RS, AC = left );
		(Y is Y1 + 1, grid(_, N), Y < N , X1 = X, OB1 = OB, RS1 = RS, AC = right);
		(member([X1, Y1], RS1), delete(RS1, [X1, Y1], RS), X = X1, Y = Y1, OB is OB1 + 1, capacity(C), C >= OB, AC = pickup);
		(station(X1, Y1), OB1 > 0, OB = 0, X = X1, Y = Y1, RS = RS1, AC = drop)
	).


% Goal State
goal(S):-
	coast_guard(X, Y, 0, [], S),
	station(X, Y).

ids(X,L):-
     (call_with_depth_limit(goal(X),L,R),number(R));
     (call_with_depth_limit(goal(X),L,R), R=depth_limit_exceeded, L1 is
     L+1, ids(X,L1)).
