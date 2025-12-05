% ----------------------------
% SIMPLE PROLOG TREASURE GAME
% ----------------------------

:- dynamic location/1.
:- dynamic inventory/1.

% Starting location
location(start).

% Room connections
path(start, east, forest).
path(start, south, cave).

path(forest, west, start).
path(forest, east, lake).

path(lake, west, forest).

path(cave, north, start).
path(cave, south, dungeon).

path(dungeon, north, cave).

% Items in rooms
item(forest, key).
item(dungeon, treasure).

% Traps
trap(lake).

% Show instructions
instructions :-
    nl,
    write('--- TREASURE HUNT ---'), nl,
    write('Commands:'), nl,
    write('  go(Direction).  % north, south, east, west'), nl,
    write('  take(Item).'), nl,
    write('  look.'), nl,
    write('  inventory.'), nl,
    write('  start.'), nl,
    nl,
    write('Find the treasure and avoid traps!'), nl, nl.

% Start game
start :-
    retractall(inventory(_)),
    retractall(location(_)),
    asserta(location(start)),
    nl,
    write('Game started! You are at the starting point.'), nl,
    instructions, !.

% Movement
go(Direction) :-
    location(Here),
    path(Here, Direction, There),
    ( trap(There) ->
        write('Oh no! You stepped into a trap at the lake! Game Over.'), nl, !
    ;
        retract(location(Here)),
        asserta(location(There)),
        describe(There), !
    ).
go(_) :-
    write('You cannot go that way.'), nl.

% Describe room
describe(Room) :-
    nl,
    write('You are now in the '), write(Room), nl,
    ( item(Room, Item) ->
        write('You see a '), write(Item), write(' here.'), nl
    ; true ),
    nl.

% Take an item
take(Item) :-
    location(Room),
    item(Room, Item),
    \+ inventory(Item),
    asserta(inventory(Item)),
    write('You picked up the '), write(Item), nl,
    ( Item = treasure ->
        nl, write('🎉 You found the TREASURE! YOU WIN! 🎉'), nl
    ; true ), !.

take(_) :-
    write('No such item here.'), nl.

% Show inventory
inventory :-
    write('You are carrying:'), nl,
    ( inventory(Item) ->
        write(' - '), write(Item), nl
    ; write('Nothing.'), nl ).

% Look around
look :-
    location(Room),
    describe(Room).

