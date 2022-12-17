:- include('KB.pl').

% Successor states
current_loc(X, Y, s0) :-
	agent_loc(X, Y).
current_loc(X, Y, result(up, S)):-
     current_loc(X1, Y, S),
	 X1 \= 0,
     X is X1 - 1.
current_loc(X, Y, result(down, S)):-
     current_loc(X1, Y, S),
	 grid(N, _),
     X is X1 + 1,
	 X \= N.
current_loc(X, Y, result(left, S)):-
     current_loc(X, Y1, S),
	 Y1 \= 0,
     Y is Y1 - 1.
current_loc(X, Y, result(right, S)):-
     current_loc(X, Y1, S),
     grid(_, M),
	 Y is Y1 + 1,
	 Y \= M.
current_loc(X, Y, result(AC, S)):- 
     (AC = drop; AC = retrieve),
     current_loc(X, Y, S).


remaining_passengers(_, P, s0):-
	ships_loc(LOCS),
	length(LOCS, P),
	!.
remaining_passengers(LOCS, A, result(retrieve, S)):-
	current_loc(X, Y, S),
	member([X, Y], LOCS),
	delete(LOCS, [X, Y], LOCS1),
	remaining_passengers(LOCS1, A1, S),
	A is A1 - 1.
remaining_passengers(LOCS, A, result(AC, S)):-
	(AC = drop; AC = up; AC = down; AC = left; AC = right),
	remaining_passengers(LOCS, A, S).


passengers_onboard(0, s0).
passengers_onboard(A, result(retrieve, S)):-
	ships_loc(LOCS),
	current_loc(X, Y, S),
	member([X, Y], LOCS),
	capacity(C),
	passengers_onboard(A1, S),
	A is A1 + 1,
	C >= A.
passengers_onboard(A, result(drop, S)):-
	station(X, Y),
	current_loc(X, Y, S),
	passengers_onboard(A1, S),
	A is A1 - 1,
	A >= 0.
passengers_onboard(A, result(AC, S)):-
	(AC = up; AC = down; AC = left; AC = right),
	passengers_onboard(A, S).


% GOAL
goal(S):-
     passengers_onboard(0, S),
	 ships_loc(LOCS),
	 remaining_passengers(LOCS, 0, S),
     station(SX, SY),
     current_loc(SX, SY, S).

% Helper Functions
ids(X,L):-
     (call_with_depth_limit(goal(X),L,R),number(R));
     (call_with_depth_limit(goal(X),L,R), R=depth_limit_exceeded, L1 is
     L+1, ids(X,L1)).
