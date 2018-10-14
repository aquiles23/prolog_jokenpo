:- use_module(library(pce)).
:- use_module(library(random)).

:-dynamic markov/3.

markov(pedra, pedra, 0).
markov(pedra, tesoura, 0).
markov(pedra, papel, 0).

markov(tesoura, pedra, 0).
markov(tesoura, tesoura, 0).
markov(tesoura, papel, 0).

markov(papel, pedra, 0).
markov(papel, tesoura, 0).
markov(papel, papel, 0).

ganha(pedra, tesoura).
ganha(papel, pedra).
ganha(tesoura, papel).

empate(pedra, pedra).
empate(tesoura, tesoura).
empate(papel, papel).

sum(X, Y, R):-
    R is X+Y.

esquece(X):-
    esquece1(X), fail.
esquece(X).

esquece1(X):-
    retract(X).
esquece1(X).

adiciona(X, Y):-
    markov(X, Y, Z), esquece(markov(X, Y, Z)), sum(Z, 1, R), assert(markov(X, Y, R)).

proximaJogada(P):-
    my_maximum(X, Z), ganha(P, X).  
my_maximum(X, Z):-
    markov(X, _, Z), forall(markov(X, _, Y), (Y>Z->fail;true)).

resultado(X, Result, Oponente) :-
    random_member(Y, [pedra, papel, tesoura]),
    adiciona(X, Y),
    (   
        ganha(X, Y),
        send(Result, selection, 'Você ganhou!!'),
        send(Oponente, selection, 'O oponente jogou '),
        send(Oponente, append, Y),
        send(Oponente, append, '.')
    ;   ganha(Y, X),
        send(Result, selection, 'Você perdeu :/'),
        send(Oponente, selection, 'O oponente jogou '),
        send(Oponente, append, Y),
        send(Oponente, append, '.')
    ;   empate(X, Y),
        send(Result, selection, 'Você empatou'),
        send(Oponente, selection, 'O oponente jogou '),
        send(Oponente, append, Y),
        send(Oponente, append, '.')
    ).

jogo :-
    new(D, dialog('JOKENPO')),
    send(D, append, new(Jogada, menu('Escolha sua jogada'))),
    send(Jogada, append, pedra),
    send(Jogada, append, papel),
    send(Jogada, append, tesoura),
    new(Result, label),
    send(D, append, Result),
    new(Oponente, label),
    send(D, append, Oponente),
    send(D,
         append,
         button(jogar, message(@prolog, resultado, Jogada?selection, Result, Oponente))),
    send(D, append, button(cancelar, message(D, destroy))),
    send(D, open).
