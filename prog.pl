:- use_module(library(pce)).
:- use_module(library(random)).

:-dynamic markov/3.
:-dynamic jogada_passada/1.
:-dynamic proximo_movimento/1.

proximo_movimento(papel).
jogada_passada(pedra).

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

adiciona_proximo(X):-
    esquece(proximo_movimento(Y)), assert(proximo_movimento(X)).

atualiza_jogada(X):-
    esquece(jogada_passada(Y)), assert(jogada_passada(X)). 

adiciona(X, Y):-
    markov(X, Y, Z), esquece(markov(X, Y, Z)), sum(Z, 1, R), assert(markov(X, Y, R)).

atualiza_prox_movimento:-
    my_maximum(X, Z), markov(X, Y, Z), ganha(P, Y), adiciona_proximo(P).

my_maximum(X, Z):-
    markov(X, _, Z), forall(markov(X, _, Y), (Y>Z->fail;true)).

decide_jogada(Y):-
    atualiza_prox_movimento, proximo_movimento(Y).

resultado(X, Result, Oponente) :-
    random_member(Y, [pedra, papel, tesoura]),
    % decide_jogada(Y),
    jogada_passada(Z),
    adiciona(Z, X),
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
    ),
    atualiza_jogada(X).

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
    send(D, append, button(cancel, message(D, destroy))),
    send(D, open).
