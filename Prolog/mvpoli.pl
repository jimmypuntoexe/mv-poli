%%%% 807500 Lotterio Roberto
%%%% 807141 Balducci Gianmaria


%----------------as monomial--------------------------
is_monomial(m(_C,TD,VPs)):-
	    integer(TD),
	    TD>=0,
	    is_list(VPs).

as_monomial(_X^0,m(1,0,[])):- !.
as_monomial(-_X^0,m(-1,0,[])):- !.


%----------Coefficiente Fratto------------

as_monomial(C, m(X, 0, [])):-
	catch(X is C,_,fail),
	!.

as_monomial(Fattore*_X^0,Result):-
	as_monomial(Fattore,Result),
	!.
as_monomial(_X^0*Fattore,Result):-
	as_monomial(Fattore,Result),
	!.



%caso senza coef.
as_monomial(Nocoef,m(1,TD,VarPowers)):-
	parse(Nocoef,VarPowers),
	totdegree(VarPowers,TD),
	!.

%caso senza coef. negativo
as_monomial(-Nocoef,m(-1,TD,VarPowers)):-
	parse(Nocoef,VarPowers),
	totdegree(VarPowers,TD),
	!.


%Siamo sicuri di questo caso??
as_monomial(Expr,m(_C,TD,VarPowers)):-
	parse(Expr,VarPowers),
	totdegree(VarPowers,TD),
	!.



%num negativo
as_monomial(-Numerosolo,m(-Numerosolo,TD,VPs)):-
	number(Numerosolo),
	totdegree(VPs,TD),
	!.

%caso  solo coef
as_monomial(Numerosolo,m(Numerosolo,TD,VPs)):-
	number(Numerosolo),
	totdegree(VPs,TD),
	!.

as_monomial(PrimiFattori*UltimoFattore,m(0,0,[])):-
	as_monomial(PrimiFattori,m(AltroFattore,_,_)),
	as_monomial(UltimoFattore,m(AltroFattore,_,_)),
	AltroFattore=0,
	!.



%divisione monomio
as_monomial(PrimiFattori*UltimoFattore,Monomio):-
	as_monomial(PrimiFattori,m(AltroFattore,TD1,VarP)),
	as_monomial(UltimoFattore,m(AltroFattore,TD2,VPs)),
	append(VarP,VPs,VarPowers),
	TotalD is TD1+TD2,
	sort(2,@=<,VarPowers,ResultVar),
	compress(ResultVar,VarCompleta),
	deletezero1(m(AltroFattore,TotalD,VarCompleta),Monomio),
	!.


as_monomial(-(PrimiFattori*UltimoFattore),Monomio):-
	as_monomial(PrimiFattori,m(AltroFattore,TD1,VarP)),
	as_monomial(UltimoFattore,m(AltroFattore,TD2,VPs)),
	append(VarP,VPs,VarPowers),
	TotalD is TD1+TD2,
	sort(2,@=<,VarPowers,ResultVar),
	compress(ResultVar,VarCompleta),
	FattoreFinal is AltroFattore*(-1),
	deletezero1(m(FattoreFinal,TotalD,VarCompleta),Monomio),
%	is_monomial(Monomio),
	!.


estraimonomio([],[]).
estraimonomio([M],M).
estraimonomio([M|Ms],(M,Ms)).


%--------------------Compress---------------------------

compress_poly2([m(C,TD,VPs),m(Coef,TD,VPs)],[]):-
	Coefficiente is C+Coef,
	Coefficiente=0,
	!.


compress_poly2([m(C,TD,VPs)],[m(C,TD,VPs)]):- !.

compress_poly2([m(C,TD,VPs),m(Coef,TD,VPs)],[m(Coefficiente,TD,VPs)]):-
	Coefficiente is C+Coef,
	!.

compress_poly2([m(C,TD,VarPowers),m(Coef,TD,VarPowers)|Zs],Rs):-
	Coefficiente is C+Coef,
	compress_poly([m(Coefficiente,TD,VarPowers)|Zs],Rs),
	!.



%---------------Compress---------------------------------

compress([],[]):-
	!.

compress([X],[X]):-
	!.

compress([v(E,X),v(E2,X)|Vs],Zs):-
	Esp is E+E2,
	compress([v(Esp,X)|Vs],Zs),
	!.

compress([v(E,X),v(E2,Y)|Vs],[v(E,X)|Res]):-
	compress([v(E2,Y)|Vs],Res),
	!.

%---------------parsing----------------------------------

is_varpower(v(Power,VarSymbol)):-
	integer(Power),
	Power>=0,
	atom(VarSymbol).


parse(X,[v(1,X)]):-
	is_varpower(v(1,X)),
	!.

parse(X^E,[v(E,X)]):-
        is_varpower(v(E,X)),
	!.


%----------------total degree--------------------------

totdegree([],0):-
	!.
totdegree([v(E,_)|Vs],R):-
	totdegree(Vs,T),
	R is T+E,
	!.



%----------------as polinomial--------------------------

is_polynomial(poly(Monomials)):-
	is_list(Monomials),
	foreach(member(M,Monomials),is_monomial(M)).


as_polynomial(0,poly([])):-
	!.

as_polynomial(Expression,poly(M2)):-
	as_monomial(Expression,M),
	is_monomial(M),
	deletezero([M],M2),
	!.


as_polynomial(PrimoFatt+Secondo,poly(PoliDefinitivo)):-
	as_monomial(Secondo,M),
	is_monomial(M),
	as_polynomial(PrimoFatt,poly(Monomials)),
	append([M],Monomials,Result),
	predsort(ordina,Result,PoliOrdinato),
	compress_poly(PoliOrdinato,PoliCompress),
	deletezero(PoliCompress,PoliDefinitivo),
	!.



as_polynomial(PrimoFatt-Secondo,poly(PoliDefinitivo)):-
	as_monomial(-Secondo,M),
	is_monomial(M),
	as_polynomial(PrimoFatt,poly(Monomials)),
	append([M],Monomials,Result),
	predsort(ordina,Result,PoliOrdinato),
	compress_poly(PoliOrdinato,PoliCompress),
	deletezero(PoliCompress,PoliDefinitivo),
	!.


%------------------------predsort---------------------------
ordina(<,m(_,Td,_),m(_,Td2,_)):-
	Td<Td2,
	!.
ordina(<,m(_,Td,V),m(_,Td,V2)):-
	trovamin(V,V2),
	!.
ordina(>,m(_,_,_),m(_,_,_)):-
	!.
ordina(>,m(_,Td,V),m(_,Td,V2)):-
	trovamin(V2,V),
	!.

trovamin([],[]):- !.
trovamin([],[_]):-!.

trovamin([v(_E,X)],[v(_E2,Y)]):-
	compare(<,X,Y),
	!.
trovamin([v(_E,X)|_Xs],[v(_E2,Y)]):-
	compare(<,X,Y),
	!.
trovamin([v(_E,X)],[v(_E2,Y)|_Ys]):-
	compare(<,X,Y),
	!.

trovamin([v(E,X)|_Xs],[v(E2,X)|_Ys]):-
	E<E2,
	!.
trovamin([v(E,X)|Xs],[v(E,X)|Ys]):-
	trovamin(Xs,Ys),
	!.


trovamin([v(_E,X)|_Xs],[v(_E2,Y)|_Ys]):-
	compare(<,X,Y),
	!.




% -----------------------------Coefficients--------------------

estraicoef(m(Coe,_Tot,_Var),[Coe]).


coefficients(m(0,0,[]),[]):- !.
coefficients(m(C,Td,X),[C]):-
	is_monomial(m(C,Td,X)),
	!.

coefficients(poly([]),[0]):- !.
coefficients(poly([X]),Coefficients):-
	is_polynomial(poly([X])),
	estraicoef(X,Coefficients),
	!.

coefficients(poly([M|Monomials]),Coefficienti):-
	predsort(ordina,[M|Monomials],[Mon|Monomi]),
	compress_poly([Mon|Monomi],[Monomio|Monomissimi]),
	is_monomial(Monomio),
	estraicoef(Monomio,Coef),
	coefficients(poly(Monomissimi),Cs),
	append(Coef,Cs,Coefficienti),
	!.

coefficients(Expression,Coefficienti):-
	as_polynomial(Expression,X),
	coefficients(X,Coefficienti),
	!.

%---------------------VARIABLES--------------------

estraisimbolo([],[]):- !.
estraisimbolo([v(_E,X)],[X]):- !.
estraisimbolo([v(_E,X)|Vs],[X|Zs]):-
	estraisimbolo(Vs,Zs),
	!.


estraivar(m(_Coe,_TD,Var),Var):- !.


variables(poly([]),[]):- !.
variables(m(0,0,[]),[]):- !.

variables(m(C,Td,X),Simboli):-
	is_monomial(m(C,Td,X)),
	estraisimbolo(X,Simboli),
	!.

variables(poly([M|Monomials]),VarOrdinata):-
	is_monomial(M),
	estraivar(M,Var),
	estraisimbolo(Var,Simboli),
	variables(poly(Monomials),Vs),
	append(Simboli,Vs,Variabili),
	list_to_set(Variabili,ListaVar),
	sort(ListaVar, VarOrdinata),
	!.

variables(Expression,VarOrdinata):-
	as_polynomial(Expression,X),
	variables(X,Variabili),
	sort(Variabili, VarOrdinata),
	!.



%---------------------compress_poly-------------------------

compress_poly([m(C,TD,VPs),m(Coef,TD,VPs)],[]):-
	Coefficiente is C+Coef,
	Coefficiente=0,
	!.


compress_poly([m(C,TD,VPs)],[m(C,TD,VPs)]):- !.

compress_poly([m(C,TD,VPs),m(Coef,TD,VPs)],[m(Coefficiente,TD,VPs)]):-
	Coefficiente is C+Coef,
	!.

compress_poly([m(C,TD,VarPowers),m(Coef,TD,VarPowers)|Zs],Rs):-
	Coefficiente is C+Coef,
	compress_poly([m(Coefficiente,TD,VarPowers)|Zs],Rs),
	!.


compress_poly([m(C,TotalD,VPs),m(Coef,TD,VarP)|Vs],[m(C,TotalD,VPs)|Res]):-
	compress_poly([m(Coef,TD,VarP)|Vs],Res),
	!.




%---------------------pprint_polynomial----------------------
scomponi_lista([]):-
	!.
scomponi_lista([v(0,_)]):-
	print(1),
	!.
scomponi_lista([v(1,X)]):-
	print(X),
	!.
scomponi_lista([v(E,X)]):-
	print(X^E),
	!.

scomponi_lista([v(0,_)|Xs]):-
	scomponi_lista(Xs),
	!.

scomponi_lista([v(1,X)|Xs]):-
	print(X),
	write(' '),
	print(*),
	write(' '),
	scomponi_lista(Xs),
	!.

scomponi_lista([v(E,X)|Xs]):-
	print(X^E),
	write(' '),
	print(*),
	write(' '),
	scomponi_lista(Xs),
	!.

pprint_polynomial(m(0,0,[])).
pprint_polynomial(poly([])).

pprint_polynomial(m(C,0,[])):-
	print(C),
	!.

pprint_polynomial(poly([m(C,0,[])])):-
	print(C),
	!.



pprint_polynomial(m(1,Td,Xs)):-
	is_monomial(m(1,Td,Xs)),
	scomponi_lista(Xs),
	!.
pprint_polynomial(m(-1,Td,Xs)):-
	is_monomial(m(-1,Td,Xs)),
	print(-),
	scomponi_lista(Xs),
	!.

pprint_polynomial(m(C,Td,Xs)):-
	is_monomial(m(C,Td,Xs)),
	print(C),
	write(' '),
	print(*),
	write(' '),
	scomponi_lista(Xs),
	!.

pprint_polynomial(poly([m(1,Td,[X|Xs])|Polinomials])):-
	is_polynomial(poly([m(1,Td,[X|Xs])|Polinomials])),
	scomponi_lista([X|Xs]),
	pprint_polynomial2(poly(Polinomials)),
	!.

pprint_polynomial(poly([m(-1,Td,[X|Xs])|Polinomials])):-
	is_polynomial(poly([m(-1,Td,[X|Xs])|Polinomials])),
	print(-),
	scomponi_lista([X|Xs]),
	pprint_polynomial2(poly(Polinomials)),
	!.

pprint_polynomial(poly([m(C,Td,[X|Xs])|Polinomials])):-
	is_polynomial(poly([m(C,Td,[X|Xs])|Polinomials])),
	print(C),
	write(' '),
	print(*),
	write(' '),
	scomponi_lista([X|Xs]),
	pprint_polynomial2(poly(Polinomials)),
	!.

pprint_polynomial(poly([m(C,Td,[])|Polinomials])):-
	is_polynomial(poly([m(C,Td,[])|Polinomials])),
	C<0,
	X is C*(-1),
	print(-),
	print(X),
	pprint_polynomial2(poly(Polinomials)),
	!.

pprint_polynomial(poly([m(C,Td,[])|Polinomials])):-
	is_polynomial(poly([m(C,Td,[])|Polinomials])),
	print(C),
	pprint_polynomial2(poly(Polinomials)),
	!.


pprint_polynomial2(poly([])):- !.


pprint_polynomial2(poly([m(1,_,[X|Xs])|Polinomials])):-
	write(' '),
	print(+),
	write(' '),
	scomponi_lista([X|Xs]),
	pprint_polynomial2(poly(Polinomials)),
	!.

pprint_polynomial2(poly([m(-1,_,[X|Xs])|Polinomials])):-
	write(' '),
	print(-),
	write(' '),
	scomponi_lista([X|Xs]),
	pprint_polynomial2(poly(Polinomials)),
	!.

pprint_polynomial2(poly([m(C,_,[])|Polinomials])):-
	C<0,
	X is C*(-1),
	write(' '),
	print(-),
	write(' '),
	print(X),
	pprint_polynomial2(poly(Polinomials)),
	!.

pprint_polynomial2(poly([m(C,_,[])|Polinomials])):-
	write(' '),
	print(+),
	write(' '),
	print(C),
	pprint_polynomial2(poly(Polinomials)),
	!.


pprint_polynomial2(poly([m(C,_,[X|Xs])|Polinomials])):-
	C<0,
	Z is C*(-1),
	write(' '),
	print(-),
	write(' '),
	print(Z),
	write(' '),
	print(*),
	write(' '),
	scomponi_lista([X|Xs]),
	pprint_polynomial2(poly(Polinomials)),
	!.


pprint_polynomial2(poly([m(C,_,[X|Xs])|Polinomials])):-
	write(' '),
	print(+),
	write(' '),
	print(C),
	write(' '),
	print(*),
	write(' '),
	scomponi_lista([X|Xs]),
	pprint_polynomial2(poly(Polinomials)),
	!.


%-------------------------------monomials-----------------------
monomials(m(0,0,[]),[]):- !.
monomials(poly([]),[]):- !.

monomials(m(C,Td,Xs),[m(C,Td,Xs)]):-
	is_monomial(m(C,Td,Xs)),
	!.

monomials(poly(Monomi),MonomiOrdinati):-
	is_polynomial(poly(Monomi)),
	estraimonomi(poly(Monomi),Monomials),
	compress_poly(Monomials,MonomiDefinitivi),
	dividipolinomio(MonomiDefinitivi,MtuttoOk),
	predsort(ordina,MtuttoOk,MonomiOrdinati),
	!.



monomials(Poly,MS):-
	as_polynomial(Poly,Monomials),
	is_polynomial(Monomials),
	estraimonomi(Monomials,MS),
	!.


dividipolinomio([m(C,TD,Var)],[m(C,TD,ResultVar)]):-
	compress(Var,VarOrd),
	sort(2,@=<,VarOrd,ResultVar),
	!.



dividipolinomio([M|Monomi],Result):-
	dividipolinomio(Monomi,Zs),
	dividipolinomio([M],Monomials),
	append(Monomials,Zs,Result),
	!.




estraimonomi(poly([]),[]):- !.
estraimonomi(poly([M|Ms]),[M|Ms]):- !.
estraimonomi(poly([M]),[M]):- !.




%--------------------MaxDegree-MinDegree------------------------

max([],0):- !.
max([X],X):-!.
max([X|Xs],K):-max(Xs,K), K>=X,!.
max([X|Xs],X):-max(Xs,K), X>=K, !.

maxdegree(m(C,Td,Xs),Td):-
	is_monomial(m(C,Td,Xs)),
	!.
maxdegree(poly(Monomi),Degree):-
	is_polynomial(poly(Monomi)),
	estraimonomi(poly(Monomi),ListaM),
	estraitd(ListaM,ListaTd),
	max(ListaTd,Degree),
	!.

maxdegree(Espressione,Degree):-
	as_polynomial(Espressione,Monomi),
	maxdegree(Monomi,Degree),
	!.



estraitd([],[]):- !.
estraitd([m(_C,TD,_Var)],[TD]):- !.

estraitd([m(_Coef,TD,_Variables),m(C,TotalD,Var)|Ms],[TD,TotalD|Ts]):-
	estraitd([m(C,TotalD,Var)|Ms],[TotalD|Ts]),
	!.


min([],0):- !.
min([X],X):-!.
min([X|Xs],K):-min(Xs,K), K=<X,!.
min([X|Xs],X):-min(Xs,K), X=<K, !.

mindegree(m(C,Td,Xs),Td):-
	is_monomial(m(C,Td,Xs)),
	!.

mindegree(poly(Monomi),Degree):-
	is_polynomial(poly(Monomi)),
	estraimonomi(poly(Monomi),ListaM),
	estraitd(ListaM,ListaTd),
	min(ListaTd,Degree),
	!.

mindegree(Espressione,Degree):-
	as_polynomial(Espressione,Monomi),
	mindegree(Monomi,Degree),
	!.



%-------------------Deletezero---------------------------
deletezero([],[]):- !.
deletezero([m(0,0,[])],[]):- !.
deletezero([m(0,_TD,[_X|_Xs])],[]):- !.
deletezero([m(C,TD,V),[]],[m(C,TD,V)]).


deletezero([m(0,_TD,_Var)|Xs],Zs):-
	deletezero(Xs,Zs),
	!.

deletezero([m(C,TD,Var)],[m(C,TD,Var)]):-
	C\=0,
	!.
deletezero([m(C,TD,Var)|Xs],[m(C,TD,Var)|Zs]):-
	C\=0,
	deletezero(Xs,Zs),
	!.



deletezero1(m(0,_Td,_Xs),m(0,0,[])):- !.
deletezero1(m(C,Td,Xs),m(C,Td,Xs)):- !.



%--------------------polyplus---------------------------
polyplus(0,0,poly([])):- !.

polyplus(0,m(0,0,[]),poly([])).
polyplus(m(0,0,[]),0,poly([])).


polyplus(poly(P),0,poly(P)).


polyplus(0,poly(P),poly(P)).



polyplus(0,m(C,Td,Xs),poly([m(C,Td,Var)])):-
	compress(Xs,Var),
	is_monomial(m(C,Td,Var)),
	!.
polyplus(m(C,Td,Xs),0,poly([m(C,Td,Xs)])):-
	is_monomial(m(C,Td,Xs)),
	!.
polyplus(P,0,Poly):-
	as_polynomial(P,Poly),
	!.
polyplus(0,P,Poly):-
	as_polynomial(P,Poly),
	!.


polyplus(poly([]),m(0,0,[]),poly([])):- !.
polyplus(m(0,0,[]),poly([]),poly([])):- !.
polyplus(m(0,0,[]),m(0,0,[]),poly([])):- !.
polyplus(poly([]),poly([]),poly([])):- !.


polyplus(poly([]),m(C,Td,Xs),poly([m(C,Td,Xs)])):-
	is_monomial(m(C,Td,Xs)),
	!.
polyplus(m(C,Td,Xs),poly([]),poly([m(C,Td,Xs)])):-
	is_monomial(m(C,Td,Xs)),
	!.

polyplus(Espr,m(C,TD,Var),Res):-
	as_polynomial(Espr,Poly),
	polyplus(Poly,m(C,TD,Var),Res).

polyplus(m(C,TD,Var),Espr,Res):-
	as_polynomial(Espr,Poly),
	polyplus(m(C,TD,Var),Poly,Res).


polyplus(poly(P),m(0,0,[]),poly(P)):-
	is_polynomial(poly(P)),
	!.
polyplus(m(0,0,[]),poly(P),poly(P)):-
	is_polynomial(poly(P)),
	!.


polyplus(poly(P),m(C,Td,Xs),Result):-
	polyplus(poly(P),poly([m(C,Td,Xs)]),Result),
	!.
polyplus(m(C,Td,Xs),poly(P),Result):-
	polyplus(poly([m(C,Td,Xs)]),poly(P),Result),
	!.

polyplus(m(C,Td,Xs),m(C1,Td1,Ys),Res):-
	polyplus(poly([m(C,Td,Xs)]),poly([m(C1,Td1,Ys)]),Res),
	!.


polyplus(Primo,Secondo,poly(Result)):-
	as_polynomial(Primo,poly(P)),
	as_polynomial(Secondo,poly(S)),
        polyplus(poly(P),poly(S),poly(Result)),
	!.

polyplus(poly(Primo),poly(Secondo),poly(Result)):-
	is_polynomial(poly(Primo)),
	is_polynomial(poly(Secondo)),
	append(Primo,Secondo,PolyApp),
	predsort(ordina,PolyApp,PoliOrdinato),
	compress_poly(PoliOrdinato,PoliComp),
	deletezero(PoliComp,Result),
	!.

%---------------------polyminus-------------------------
polyminus(0,0,poly([])):- !.

polyminus(poly([]),m(0,0,[]),poly([])):- !.
polyminus(m(0,0,[]),poly([]),poly([])):- !.
polyminus(m(0,0,[]),m(0,0,[]),poly([])):- !.
polyminus(poly([]),poly([]),poly([])):- !.

polyminus(poly([]),m(C,Td,Xs),poly([m(C1,Td,Xs)])):-
	is_monomial(m(C,Td,Xs)),
	C1 is C*(-1),
	!.
polyminus(m(C,Td,Xs),poly([]),poly([m(C,Td,Xs)])):-
	is_monomial(m(C,Td,Xs)),
	!.

polyminus(poly(P),0,poly(P)).
polyminus(0,poly(P),poly(Poly)):-
	cambiacoeff(P,Poly).

polyminus(Espr,m(C,TD,Var),Res):-
	as_polynomial(Espr,Poly),
	polyminus(Poly,poly([m(C,TD,Var)]),Res).

polyminus(m(C,TD,Var),Espr,Res):-
	as_polynomial(Espr,Poly),
	polyminus(poly([m(C,TD,Var)]),Poly,Res).


polyminus(poly(P),m(0,0,[]),poly(P)):- !.
polyminus(m(0,0,[]),poly(P),Result):-
	polyminus(poly([m(0,0,[])]),poly(P),Result),
	!.

polyminus(poly(P),m(C,Td,Xs),Result):-
	polyminus(poly(P),poly([m(C,Td,Xs)]),Result),
	!.
polyminus(m(C,Td,Xs),poly(P),Result):-
	polyminus(poly([m(C,Td,Xs)]),poly(P),Result),
	!.
polyminus(m(C,Td,Xs),m(C1,Td1,Ys),Res):-
	polyminus(poly([m(C,Td,Xs)]),poly([m(C1,Td1,Ys)]),Res),
	!.


polyminus(Primo,Secondo,Result):-
	as_polynomial(Primo,poly(P)),
	as_polynomial(Secondo,poly(S)),
	cambiacoeff(S,S1),
	polyplus(poly(P),poly(S1),Result),
	!.

polyminus(poly(Primo),poly(Secondo),Result):-
	is_polynomial(poly(Primo)),
	is_polynomial(poly(Secondo)),
	cambiacoeff(Secondo,S),
	polyplus(poly(Primo),poly(S),Result),
	!.


cambiacoeff([],[]):-!.
cambiacoeff([m(C,Td,Vs)],[m(Coef,Td,Vs)]):-
	Coef is C*(-1),
	!.
cambiacoeff([m(C,Td,Vs)|Xs],[m(Coef,Td,Vs)|Zs]):-
	Coef is C*(-1),
	cambiacoeff(Xs,Zs),
	!.

%------------------polytimes---------------------

polytimes(0,_P,poly([])):- !.
polytimes(_P,0,poly([])):- !.


polytimes(1,Poly,Result):-
	as_polynomial(Poly,Result),
	is_polynomial(Result),
	!.
polytimes(Poly,1,Result):-
	as_polynomial(Poly,Result),
	is_polynomial(Result),
	!.

polytimes(poly([m(1,0,[])]),poly(P),poly(P)):-
	is_polynomial(poly(P)),
	!.
polytimes(poly(P),poly([m(1,0,[])]),poly(P)):-
	is_polynomial(poly(P)),
	!.


polytimes(poly([]),poly([]),poly([])):- !.
polytimes(poly([]),poly(P),poly([])):-
	is_polynomial(poly(P)),
	!.
polytimes(poly(P),poly([]),poly([])):-
	is_polynomial(poly(P)),
	!.

polytimes(poly(P),1,poly(P)).
polytimes(1,poly(P),poly(P)).

polytimes(poly(_P),0,poly([])).
polytimes(0,poly([_P]),poly([])).


polytimes(m(0,0,[]),_Express,poly([])):- !.

polytimes(_Express,m(0,0,[]),poly([])):- !.


polytimes(poly(_P),m(0,0,[]),poly([])).
polytimes(m(0,0,[]),poly(_P),poly([])).




polytimes(m(C,TD,Var),m(Coef,TotD,VarPowers),Result):-
	polytimes(poly([m(C,TD,Var)]),poly([m(Coef,TotD,VarPowers)]),Result),
	!.



polytimes(m(C,TD,Var),poly(Secondo),Result):-
	polytimes(poly([m(C,TD,Var)]),poly(Secondo),Result),
	!.



polytimes(poly(Primo),m(C,TD,Var),Result):-
	polytimes(poly(Primo),poly([m(C,TD,Var)]),Result),
	!.


polytimes(Espr,m(C,TD,Var),Prodotto):-
	as_polynomial(Espr,Poly),
	polytimes(Poly,poly([m(C,TD,Var)]),Prodotto).

polytimes(m(C,TD,Var),Espr,Prodotto):-
	as_polynomial(Espr,Poly),
	polytimes(poly([m(C,TD,Var)]),Poly,Prodotto).

polytimes(Primo,Secondo,Result):-
	as_polynomial(Primo,poly(P)),
	as_polynomial(Secondo,poly(S)),
	polytimes(poly(P),poly(S),Result),
	!.


polytimes(poly(Primo),poly(Secondo),poly(PolyCompress)):-
	is_polynomial(poly(Primo)),
	is_polynomial(poly(Secondo)),
	polymoltiplicazione(Primo,Secondo,Result),
	deletezero(Result,Polygiusto),
	compress_poly(Polygiusto,PolyCompress),
	!.


polymoltiplicazione([m(0,_TD,[_X])],[_M],[]):- !.

polymoltiplicazione([_M],[m(0,_TD,[_X])],[]):- !.

polymoltiplicazione([m(C,Td,Xs)],[m(C2,Td2,Ys)],Monomio):-
	C3 is C*C2,
	Td3 is Td+Td2,
	append(Xs,Ys,Variabili),
	compress(Variabili,Var),
	predsort(ordina,[m(C3,Td3,Var)],PoliOrdinato),
	compress_times(PoliOrdinato,Monomio),
	!.



polymoltiplicazione([m(C,Td,Xs)],[m(C2,Td2,Ys)|Ms],Monomi):-
	C3 is C*C2,
	Td3 is Td+Td2,
	append(Xs,Ys,Variabili),
	compress(Variabili,Var),
	polymoltiplicazione([m(C,Td,Xs)],Ms,Parziale),
	predsort(ordina,[m(C3,Td3,Var)|Parziale],PoliOrdinato),
	compress_times(PoliOrdinato,Monomi),
	!.


polymoltiplicazione([m(C2,Td2,Ys)|Ms],[m(C,Td,Xs)],Monomi):-
	C3 is C*C2,
	Td3 is Td+Td2,
	append(Xs,Ys,Variabili),
	compress(Variabili,Var),
	polymoltiplicazione(Ms,[m(C,Td,Xs)],Parziale),
	predsort(ordina,[m(C3,Td3,Var)|Parziale],PoliOrdinato),
	compress_times(PoliOrdinato,Monomi),
	!.





polymoltiplicazione([m(C,Td,Xs)|Mons],[m(C2,Td2,Ys)|Ms],Monomi):-
	C3 is C*C2,
	Td3 is Td+Td2,
	append(Xs,Ys,Variabili),
	compress(Variabili,Var),
	polymoltiplicazione([m(C,Td,Xs)],Ms,Parziale),
	polymoltiplicazione(Mons,[m(C2,Td2,Ys)|Ms],Parziale2),
	append([m(C3,Td3,Var)|Parziale],Parziale2,PolyMoltiplicato),
	predsort(ordina,PolyMoltiplicato,PoliOrdinato),
	compress_times(PoliOrdinato,Monomi),
	!.


compress_times([],[]):- !.


compress_times([m(C,TD,Var)],[m(C,TD,VarPowers)]):-
	       sort(2,@=<,Var,ResultVar),
	       compress(ResultVar,VarPowers),
	       !.


compress_times([m(C,TD,Var)|Ms],[m(C,TD,VarPowers)|Monomi]):-
	sort(2,@=<,Var,ResultVar),
	compress(ResultVar,VarPowers),
	compress_times(Ms,Monomi),
	!.

%------------------------polyval----------------------------
polyval(poly([]),[],0):- !.
polyval(poly([]),[_],0):- !.
polyval(m(0,0,[]),[_],0):- !.

polyval(m(C,Td,Var),[Valori|Vs],Result):-
	polyval(poly([m(C,Td,Var)]),[Valori|Vs],Result),
	!.


polyval(Exp,Vs,Result):-
	as_polynomial(Exp,poly(P)),
	polyval(poly(P),Vs,Result),
	!.


polyval(poly([m(C,Td,Vs)|Xs]),[VarValues|Vs2],Result):-
	variables(poly([m(C,Td,Vs)|Xs]),ListaVar),
	pairlis(ListaVar,[VarValues|Vs2],Result1),
	confronta(Vs,Result1,Result2),
	Result3 is Result2*C,
	polyval2(poly(Xs),[VarValues|Vs2],Result1,Result4),
	Result is Result3+Result4,
	!.

%caso per quando c'è solo il coeff
polyval2(poly([]),_,_,0).
polyval2(poly([]),[_X|_Xs],[_Y|_Ys],0).


polyval2(poly([m(0,_Td,[])|Xs]),[VarValues|Vs2],ListaPairlis,Result):-
	polyval2(poly(Xs),[VarValues|Vs2],ListaPairlis,Result),
	!.


polyval2(poly([m(C,_Td,Vs)|Xs]),[VarValues|Vs2],ListaPairlis,Result):-
	confronta(Vs,ListaPairlis,Result2),
	Result3 is Result2*C,
	polyval2(poly(Xs),[VarValues|Vs2],ListaPairlis,Result4),
	Result is Result3+Result4,
	!.




pairlis([],[_Y|_Ys],[]).
pairlis([X],[Y],[(X,Y)]):- !.
pairlis([X],[Y|_Ys],[(X,Y)]):- !.
pairlis([X|Xs],[Y|Ys],[(X,Y)|Zs]):-
	pairlis(Xs,Ys,Zs),
	!.


%caso in cui c'e solo il coeff
confronta([],[],1).
confronta([],[_V|_Vs],1).


confronta([v(E,X)],[(X,N)],Y):-
	Y is N^E,
	!.
confronta([v(E,X)],[(X,N)|_Xs],Y):-
	Y is N^E,
	!.

confronta([v(E,X)|_Xs],[(X,N)],Y):-
	Y is N^E,
	!.

confronta([v(_E,_X)|Xs],[(Y,N)],Result):-
	confronta(Xs,[(Y,N)],Result),
	!.

confronta([v(_E,_X)],[(_Y,_N)],1):-
	!.

confronta([v(E,X)],[(_Y,_N)|Xs],Result):-
	confronta([v(E,X)],Xs,Result),
	!.


confronta([v(E,X)|Xs],[(X,N)|Ys],Result):-
	Y is N^E,
	confronta(Xs,Ys,Z),
	Result is Y*Z,
	!.

confronta([v(E,X)|Xs],[(Y,N)|Ys],Result):-
	confronta([v(E,X)|Xs],Ys,Z),
	confronta(Xs,[(Y,N)],K),
	Result is Z*K,
	!.





