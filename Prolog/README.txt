

%%%%%%%%%%%%%%%%%%%%%%%%%%%%  READ ME PROLOG %%%%%%%%%%%%%%%%%%%%%%%%%%%%

	

   %%%% 807141 Gianmaria Balducci  
   %%%% 807500 Roberto Lotterio


-----------------------INFORMAZIONI PROGETTO-----------------------


Abbiamo seguito le seguenti regole:

il monomio e il polinomio rappresentanti il numero 0 sono rispettivamente:
-m(0,0,[])
-poly([])





si accettano in input anche monomi e polinomi già parsati, si suppongono tuttavia già ordinati e compressi nella forma:
- Monomio = m(Coef Totaldegree VarPowers)    VarPowers  es. [(v 1 x), (v 2 y)]
    es. 'm(1, 2, [v(1, x), v(1, y)])

- Polinomio = poly[(Monomi)]
    es. poly([m(1, 2, [v(1, x) v(1, y)]), m(2, 3, [v(2, a) ,v(1, b)])])





---------------------------- DESCRIZIONE FUNZIONI PRINCIPALI CHE NON ACCETTANO IN INPUT POLINOMI -------------------------------------

Le seguenti funzioni accettano in input tutti i casi, esclusi: - polynomi già parsati, quindi poly[(Monomi)]
                                                               - le strutture polynomial , quindi i casi "x+x+x" con cui restituiscono un messaggio di errore "Input non valido"



 - as_monomial(Expression, Monomial) (dato un Monomial input ritorna un monomio parsato con la VarPowers ordinata e compressa  m(Coef TD VarPowers)
    es. as_monomial (2*x*r*t,M)  M= m(2, 3, [v(1, R), v(1, t), v(1, x)])
        as_monomial m(2, 3, [v(1, r), v(1, t), v(1, x)]),M) M= m(2, 3, [v(1, r), v(1, t), v(1, x)])
        as_monomial (sin(30)*x,M) M= (-0.9880316, 1 ,[v(1, x)])
        as_monomial (x+x+x,M)  False



---------------------------- DESCRIZIONE FUNZIONI PRINCIPALI CHE ACCETTANO IN INPUT POLINOMI -------------------------------------

I seguenti casi accettano in input tutti i casi (espressione polinomio,polinomio parsato, espressione monomio, monomio parsato, espressioni nulle, monomi e polinomi zeri) tutti gli output sono da considerarsi ordinati e compressi

 - as_polynomial(Expression,Poly) dato un qualsiasi input (espressione polinomio,polinomio parsato, espressione monomio, monomio parsato, espressioni nulle, monomi e polinomi zeri) ritorna un polinomio parsato ordinato e compresso

	es: as_polynomial(3*x*y^2+4*y^2*z,P).
	    P = poly([m(3, 3, [v(1, x), v(2, y)]), m(4, 3, [v(2, y), v(1, z)])]).
    

 - coefficients(Poly,Coefficients) dato un qualsiasi input (espressione polinomio,polinomio parsato, espressione monomio, monomio parsato, espressioni nulle, monomi e polinomi zeri) ritorna la lista dei coefficienti di un polinomio mantenendo l'ordine con cui appaiono nel polinomio parsato e non cancellando le ripetizioni

	es: coefficients(3*x+4*y+z^3,C).
	    C = [3, 4, 1].

  

 - variables(Poly,Variables) dato un qualsiasi input (espressione polinomio,polinomio parsato, espressione monomio, monomio parsato, espressioni nulle, monomi e polinomi zeri) ritorna la lista delle variabili di un polinomio ordinate e senza ripetizioni

	es:  variables(2*x^4+x^4+z*y,V).
	     V = [x, y, z].

   

 - monomials(Poly,Monomials) dato un qualsiasi input (espressione polinomio,polinomio parsato, espressione monomio, monomio parsato, espressioni nulle, monomi e polinomi zeri) ritorna la lista di tutti i monomi del polinomio

	es: monomials(2*x^5*y^2+4*z,M).
	    M = [m(4, 1, [v(1, z)]), m(2, 7, [v(5, x), v(2, y)])].

	
    
 - maxdegree(Poly,Degree) dato un qualsiasi input (espressione polinomio,polinomio parsato, espressione monomio, monomio parsato, espressioni nulle, monomi e polinomi zeri) ritorna il total degree piu alto tra i monomi del polinomio

	es: maxdegree(x*y^2+3*z^4+w^5,Degree).
	    Degree = 5.
   

 - mindegree(Poly,Degree) dato un qualsiasi input (espressione polinomio,polinomio parsato, espressione monomio, monomio parsato, espressioni nulle, monomi e polinomi zeri) ritorna il total degree piu piccolo tra i monomi del polinomio

	es: mindegree(x*y^2+3*z^4+w^5,Degree).
	    Degree = 3.

    

 - polyplus(Poly1,Poly2,Result) dati due qualsiasi input (espressione polinomio,polinomio parsato, espressione monomio, monomio parsato, espressioni nulle, monomi e polinomi zeri) ritorna la somma dei polinomi sotto forma di polinomio parsato

   	es: polyplus(x*y^3,y,Res).
	    Res = poly([m(1, 1, [v(1, y)]), m(1, 4, [v(1, x), v(3, y)])]).

 - polyminus(Poly1,Poly2,Result) dati due qualsiasi input (espressione polinomio,polinomio parsato, espressione monomio, monomio parsato, espressioni nulle, monomi e polinomi zeri) ritorna la differenza dei polinomi sotto forma di polinomio parsato

	 es: polyminus(x*y^3+y,y,Res).
	     Res = poly([m(1, 4, [v(1, x), v(3, y)])]).
    
 - polytimes(Poly1,Poly2,Result) dati due qualsiasi input (espressione polinomio,polinomio parsato, espressione monomio, monomio parsato, espressioni nulle, monomi e polinomi zeri) ritorna il prodotto dei polinomi sotto forma di polinomio parsato

	 es:polytimes(3*x*y^3+y,y,Res).
	    Res = poly([m(1, 2, [v(2, y)]), m(3, 5, [v(1, x), v(4, y)])]).

   

 - polyval(Polynomial, VariablesValue, Value) dato un qualsiasi input (espressione polinomio,polinomio parsato, espressione monomio, monomio parsato, espressioni nulle, monomi e polinomi zeri) e una lista di valori,  ritorna il risultato dell'espressione sostituendo i valori della lista VariablesValue alle variabili del polinomio, associando ogni valore alla lista di variabili ordinata e senza ripetizioni (associa quindi i valori che si passano in input al risultato di variables del polinomio) (N.B. se ci sono piu variabili che valori la funzione dar� errore, se ci saranno piu valori che variabili, verranno ignorate quelle in eccesso)

    	es: polyval(3*x+y^3+2*z,[3,2,4],Value).
	    Value = 25.


 - pprint_polynomial(Polynomial). dato un qualsiasi input (espressione polinomio,polinomio parsato, espressione monomio, monomio parsato, espressioni nulle, monomi e 	polinomi zeri) stampa il polinomio nella forma tradizionale e ritorna nil (se i coefficienti di una moltiplicazione sono 1 o -1 verranno omessi, nel caso del 	-1 verrà stampato solo un -)

	es:  pprint_polynomial(poly([m(1, 2, [v(2, y)]), m(3, 5, [v(1, x), v(4, y)])])).
	     y^2 + 3 * x * y^4
    




---------------------------- DESCRIZIONE FUNZIONI SECONDARIE CON INPUT SPECIFICI -------------------------------------




-compress(Var,VarCompressa). Questo predicato prende in ingresso una lista di variabli di un Monomio e restitusce una lista di variabili
	compressata: se as_monomial riceve in ingresso un monomio "3*x*x" questo predicato si assicura di mandare in output un monomio nella 
	forma parsata del tipo 3*x^2, modificando la lista delle sue variabili.

	es:  compress([v(1, a),v(1, a)],VarCompressata).
	     VarCompressata = [v(2, a)].



-totdegree(Var,Degree). Questo predicato prende in ingresso una lista di variabili [v(Esp,X)...] dal quale ne ricava il grado totale del monomio
		        sommando tutti gli esponenti della lista, serve per unificare il Total degree di un monomio.
	es: totdegree([v(2, a),v(1, x),v(4,z)],Degree).
	    Degree = 7.

-ordina(CompareSymbol,Monomio1,Monomio2). Questo predicato è usato dal predsort per ordinare i monomi di un polinomio confrontandoli.

	es:ordina(<,m(_,Td,_),m(_,Td2,_)):-
		Td<Td2,
		!.


-trovamin(Var, ListaVar) .Questo predicato viene richiamato da ordina (predicato del predsort), in caso di totaldegree pari questo predicato
	                  ordina i monomi lessicograficamente crescente, usando la funzione compare.
	


-estraicoef(Monomio,Coef). Estrae il coefficiente di un monomio mettendolo in una lista. Viene richiamato da coefficients.
	es: estraicoef(m(2,3,[v(a,3)]),C).
	    C = [2].


-estraisimbolo(ListaVar,Symbol). Estrae i simboli della ListaVar [v(E,Symbol)...] viene richiamato da variables.

	es: estraisimbolo([v(2, z),v(1, u),v(4,y),v(2, r),v(4,y)],S).
	    S = [z, u, y, r, y].


-estraivar(m(Coef,Td,Var),Var). Estrae la lista di variabili del monomio in input.
	
	es:estraivar(m(1,3,[v(2, z),v(1, u)]),Var)
	   Var=[v(2, z),v(1, u)]


-compress_poly(ListaMonomi,MonomiCompressati). Questo predicato prende un ingresso una lista di monomi e confronta 
	                                        le corrispettive liste di variabili se sono uguali allora somma i coefficienti.
	                                       si assicura che: 3*x+x diventi 4*x.
	
	es:compress_poly([m(3, 1, [v(1, x)]),m(1, 1, [v(1, x)])],P).
            P = [m(4, 1, [v(1, x)]).

	                                     

-scomponi_lista(Var). Predicato di appoggio a pprint_polynomial stampa in output in forma di espressione il simbolo e il suo esponente 
	             a seconda dei casi.
	 
	es:scomponi_lista([v(2, x)]).
	    x^2


-pprint_polynomial2(Poly). Predicato di appoggio a pprint_polynomial stampa in output in forma di espressione il polinomio e gli operatori a seconda dei casi.




-dividipolinomio(Poly,PolyResult). Predicato di appoggio a monomials che usando il predicato compress ordina le liste dei monomi di monomials



-estraimonomi(poly[Monomi],Monomi).Toglie la scritta poly al risultato per servirloa monomials.


-max([L],Max). trova il massimo di una lista e lo serve a maxdegree.

-min([L],Min). trova il minimo di una lista e lo serve a mindegree.


-estraitd(Poly,ListaTD). estrai tutti i totaldegree di una lista di monomi e li mette in una lista risultante.


	es: estraitd([m(3, 4, [v(1, x)]),m(1, 2, [v(1, x)]),m(1,3,[v(2, z),v(1, u)])],ListaTD).
	    ListaTD = [4, 2, 3].



-deletezero(Poly,ListaRes). elimina dalla lista dei monomi i "monomi zero" della forma m(0,0[]), serve ad as_polynomial.
	
	es: deletezero([m(3, 4, [v(1, x)]),m(0, 0, []),m(1,3,[v(2, z),v(1, u)])],ListaRes).
            ListaRes = [m(3, 4, [v(1, x)]), m(1, 3, [v(2, z), v(1, u)])].

-deletezero1(Monomio,M). se riceve un monomio che ha coefficiente zero lo rende nella forma m(0,0[]).



-cambiacoeff(Poly,Polynegato). predicato di appoggio a polyminus, moltiplica i coefficienti per -1.




-polymoltiplicazione(Poly1,Poly2,Result). predicato di appoggio di polytimes moltiplica i coefficienti dei polinomi ne somma il total-degree,
                                          ordina e compressa il polinomio risultante.



-compress-times(Poly,PolyCompresso). predicato di appoggio di polytimes che comprime le VarPowers di ogni monomio del polinomio risultante (che prende in ingresso) 	                             dalla moltiplicazione.



-polyval2(Poly,VarValue,ListaPairlis,Result). predicato d'appoggio di polyval, prende in input la lista dei monomi, escluso il primo monomio,una lista coppia	                                      (valore,var) e la lista di valori che  gli passa polyval; ritorna il risultato dell'espressione escluso il risutato del 	                                      primo monomio, con cui si sommerà poi in polyval.


-pairlis(Var,VarValue,Coppia) predicato di appoggio a polyval che riceve una lista di variabili,una lista di valori, e restituisce una lista di accoppiamenti 	                      valore,variabile che fornisce al predicato confronta.


-confronta(Var,ListaPair,Result) predicato d'appoggio di polyval e polyval2, prende in input la VarPowers e la lista di pairlis, confronta ogni variabile con la lista 	                        di pairlis, quando trova una corrispondenza eleva il valore associato alla variabile con l'esponente della variabile
    es. confronta([v(2, x)],[(x,3)],Result) 
	Result= 9




