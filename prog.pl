ganha(pedra,tesoura).
ganha(papel,pedra).
ganha(tesoura,papel).

empate(pedra,pedra).
empate(tesoura,tesoura).
empate(papel,papel).

resultado(X,Y) :- 
    ganha(X,Y),write('você ganhou');
    ganha(Y,X),write('você perdeu');
    empate(X,Y),write('empatou').


primeiro_jogo :- read(X),
    random_member(Y,[pedra,papel,tesoura]),write(Y),nl,
    resultado(X,Y).

