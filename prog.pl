%TODO: jogar todos  os fatos em um arquivo separado.
:- dynamic contar/2.

ganha(pedra, tesoura).
ganha(papel, pedra).
ganha(tesoura, papel).

empate(pedra, pedra).
empate(tesoura, tesoura).
empate(papel, papel).

transicao(pedra, pedra, 1).
transicao(pedra, papel, 2).
transicao(pedra, tesoura, 3).
transicao(papel, papel, 4).
transicao(papel, pedra, 5).
transicao(papel, tesoura, 6).
transicao(tesoura, tesoura, 7).
transicao(tesoura, papel, 8).
transicao(tesoura, pedra, 9).

% pensei em algo do tipo para contar as ocorrencias mas não ta dando muito certo
contar(transicao(_, _, N), B) :-
    (   B is B+1
    ;   retract(contar(transicao(_, _, N),
                      B-1))
    ).

resultado(X, Y) :-
    (   ganha(X, Y),
        write('você ganhou')
    ;   ganha(Y, X),
        write('você perdeu')
    ;   empate(X, Y),
        write(empatou)
    ).


primeiro_jogo :-
    read(X),
    random_member(Y, [pedra, papel, tesoura]),
    writeln(Y),
    resultado(X, Y),
    asserta(ultimo(X)). 

