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

resultado(X, Y) :-
    (   ganha(X, Y),
        write('você ganhou')
    ;   ganha(Y, X),
        write('você perdeu')
    ;   empate(X, Y),
        write(empatou)
    ).

jogo :-
    new(D, dialog('JOKENPO')),
    send(D, append, new(Jogada, menu('Escolha sua jogada'))),
    send(Jogada, append, pedra),
    send(Jogada, append, papel),
    send(Jogada, append, tesoura),
    random_member(Y, [pedra, papel, tesoura]),
    send(D,
         append,
         button(jogar,
                message(@prolog,
                        resultado,
                               create(string, '%s', @arg1?Jogada)?selection,
                               Y?selection))),
    send(D, open).

    %writeln(Y).

   /* asserta(ultimo(X)),
    findall(Z, ultimo(Z), [H1,H2|T]),
    transicao(H2,H1),
    asserta(contar(_,_,H1,H2)).*/
