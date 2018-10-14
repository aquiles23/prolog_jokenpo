:- use_module(library(pce)).
:- use_module(library(random)).

ganha(pedra, tesoura).
ganha(papel, pedra).
ganha(tesoura, papel).

empate(pedra, pedra).
empate(tesoura, tesoura).
empate(papel, papel).

resultado(X, Result, Oponente) :-
    random_member(Y, [pedra, papel, tesoura]),
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
    send(D, append, button(cancel, message(D, destroy))),
    send(D, open).
