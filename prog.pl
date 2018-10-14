:- use_module(library(pce)).
:- use_module(library(random)).

% :- (dynamic contar/4).
ganha(pedra, tesoura).
ganha(papel, pedra).
ganha(tesoura, papel).

empate(pedra, pedra).
empate(tesoura, tesoura).
empate(papel, papel).


/*
transicao(pedra, pedra).
transicao(pedra, papel).
transicao(pedra, tesoura).
transicao(papel, papel).
transicao(papel, pedra).
transicao(papel, tesoura).
transicao(tesoura, tesoura).
transicao(tesoura, papel).
transicao(tesoura, pedra).


% pensei em algo do tipo para contar as ocorrencias mas não ta dando muito certo
contar(0,_,_,_).
contar(X,Y,_,_):- Y is X+1.*/

resultado(X, Result, Oponente) :-
    random_member(Y, [pedra, papel, tesoura]),
    (   
        ganha(X, Y),
        send(Result, selection, 'Você ganhou!!'),
        send(Oponente, selection, 'O oponente jogou '),
        send(Oponente, append, Y)
    ;   ganha(Y, X),
        send(Result, selection, 'Você perdeu :/'),
        send(Oponente, selection, 'O oponente jogou '),
        send(Oponente, append, Y)
    ;   empate(X, Y),
        send(Result, selection, 'Você empatou'),
        send(Oponente, selection, 'O oponente jogou '),
        send(Oponente, append, Y)
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

    %writeln(Y).

   /* asserta(ultimo(X)),
    findall(Z, ultimo(Z), [H1,H2|T]),
    transicao(H2,H1),
    asserta(contar(_,_,H1,H2)).*/
