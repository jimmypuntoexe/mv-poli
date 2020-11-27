README LISP

807500 LOTTERIO ROBERTO

807141 BALDUCCI GIANMARIA


------------------------- INFORMAZIONI PROGETTO -------------------------------------


Abbiamo seguito le seguenti regole:

il monomio e il polinomio rappresentanti il numero 0 sono rispettivamente:
-(M 0 0 NIL)
-(POLY NIL)

polynomial  = (+ Monomial Monomial ...)
monomial    = number
              (* [coefficient] var-expt)
var-expt    = variable
              (expt variable exponent)
variable    = symbol
exponent    = non-negative integer




Tutte le funzioni del progetto accettano in input la maggior parte dei casi, in particolare abbiamo gestito i seguenti input (Se il coef è 1 si puo omettere):
'3
'x
'(3)
'(x)
'(expt x 3)
'(* coef lista_variabili) --> Struttura Monomial 
'(* (sin 30) x)) --> gestiamo anche i coefficienti che si riescono a calcolare
'(+ 4 (* (expt t 3)) x (expt y 2) Monomial )  --> Struttura Polynomial


si accettano in input anche monomi e polinomi già parsati, si suppongono tuttavia già ordinati e compressi nella forma:
- Monomio = '(M coef Totaldegree Vp-List)    Vp-List -> es. ((V 1 X) (V 2 Y))
    es. '(M 1 2 ((V 1 X) (V 1 Y)))

- Polinomio = '(POLY (Monomi))
    es. '(POLY ((M 1 2 ((V 1 X) (V 1 Y))) (M 2 3 ((V 2 A) (V 1 B)))))



nei casi in cui l'input risulta sbagliato o non viene accettato, viene stampato un errore "Input errato"





---------------------------- DESCRIZIONE FUNZIONI PRINCIPALI CHE NON ACCETTANO IN INPUT POLINOMI -------------------------------------

Le seguenti funzioni accettano in input tutti i casi, esclusi: - polynomi già parsati, quindi '(POLY (Monomi))
                                                               - le strutture polynomial , quindi i casi '(+ ..) con cui restituiscono un messaggio di errore "Input non valido"

 - varpowers -> dato un Monomial input ritorna la Vp-list -> ((V esponente variabili)(...)(...))
    es. (varpowers '(* 2 x r t)) -> ((V 1 R) (V 1 T) (V 1 X))
        (varpowers '(M 2 3 ((V 1 R) (V 1 T) (V 1 X)))) -> ((V 1 R) (V 1 T) (V 1 X))

 - vars-of -> dato un Monomial input ritorna la lista delle variabili di un monomio ordinate e senza ripetizioni
    es. (vars-of '(* 2 x r x t)) -> (R T X)
        (vars-of '(M 2 3 ((V 1 R) (V 1 T) (V 1 X)))) -> (R T X)

 - monomial-degree -> dato un Monomial input ritorna il Total Degree di un monomio
    es. (monomial-degree '(* 2 x r t)) -> 3
        (monomial-degree '(M 2 3 ((V 1 R) (V 1 T) (V 1 X)))) -> 3

 - monomial-coefficient -> dato un Monomial input ritorna il coefficiente di un monomio
    es. (monomial-coefficient '(* 2 x r t)) -> 2
        (monomial-coefficient '(M 2 3 ((V 1 R) (V 1 T) (V 1 X)))) -> 2

 - as-monomial -> dato un Monomial input ritorna un monomio parsato con la Vp-list ordinata e compressa-> (M coef TD Vp-List)
    es. (as-monomial '(* 2 x r t)) -> (M 2 3 ((V 1 R) (V 1 T) (V 1 X)))
        (as-monomial '(M 2 3 ((V 1 R) (V 1 T) (V 1 X)))) -> (M 2 3 ((V 1 R) (V 1 T) (V 1 X)))
        (as-monomial '(* (sin 30) x)) -> (M -0.9880316 1 ((V 1 X)))
        (as-monomial '(+ x x x)) -> Error: Input Errato



---------------------------- DESCRIZIONE FUNZIONI PRINCIPALI CHE ACCETTANO IN INPUT POLINOMI -------------------------------------

I seguenti casi accettano in input tutti i casi descritti in <INFORMAZIONI PROGETTO>, tutti gli output sono da considerarsi ordinati e compressi

 - as-polynomial -> dato un qualsiasi input ritorna un polinomio parsato ordinato e compresso
    es. (as-polynomial '(+ 5 x (* 2 x r t))) -> (POLY ((M 5 0 NIL) (M 1 1 ((V 1 X))) (M 2 3 ((V 1 R) (V 1 T) (V 1 X)))))
        (as-polynomial '(* 2 x r t)) -> (POLY ((M 2 3 ((V 1 R) (V 1 T) (V 1 X)))))
        (as-polynomial '(POLY ((M 2 3 ((V 1 R) (V 1 T) (V 1 X)))))) -> (POLY ((M 2 3 ((V 1 R) (V 1 T) (V 1 X)))))

 - coefficients -> dato un qualsiasi input ritorna la lista dei coefficienti di un polinomio mantenendo l'ordine con cui appaiono nel polinomio parsato e non cancellando le ripetizioni
    es. (coefficients '(POLY NIL)) -> (0)
        (coefficients '(+ -4 x (expt t 3) (* 2 x r t) (* 2 y))) -> (-4 1 2 2 1)
        (coefficients '(POLY ((M -4 0 NIL) (M 1 1 ((V 1 X))) (M 2 1 ((V 1 Y))) (M 2 3 ((V 1 R) (V 1 T) (V 1 X))) (M 1 3 ((V 3 T)))))) -> (-4 1 2 2 1)

 - variables -> dato un qualsiasi input ritorna la lista delle variabili di un polinomio ordinate e senza ripetizioni
    es. (variables '(+ -4 x (expt t 3) (* 2 x r t) (* 2 y))) -> (R T X Y)
        (variables '(POLY ((M -4 0 NIL) (M 1 1 ((V 1 X))) (M 2 1 ((V 1 Y))) (M 2 3 ((V 1 R) (V 1 T) (V 1 X))) (M 1 3 ((V 3 T)))))) -> (R T X Y)

 - monomials -> dato un qualsiasi input ritorna la lista di tutti i monomi del polinomio
    es. (monomials '(+ -4 (expt t 3) (* 2 x r t))) -> ((M -4 0 NIL) (M 2 3 ((V 1 R) (V 1 T) (V 1 X))) (M 1 3 ((V 3 T))))
        (monomials '(POLY ((M -4 0 NIL) (M 2 3 ((V 1 R) (V 1 T) (V 1 X))) (M 1 3 ((V 3 T)))))) -> ((M -4 0 NIL) (M 2 3 ((V 1 R) (V 1 T) (V 1 X))) (M 1 3 ((V 3 T))))
 
 - maxdegree -> dato un qualsiasi input ritorna il total degree piu alto tra i monomi del polinomio
    es. (maxdegree '(+ -4 (expt t 3) (* 2 x r t))) -> 3
        (maxdegree '(POLY ((M -4 0 NIL) (M 2 3 ((V 1 R) (V 1 T) (V 1 X))) (M 1 3 ((V 3 T)))))) -> 3

 - mindegree -> dato un qualsiasi input ritorna il total degree piu piccolo tra i monomi del polinomio
    es. (mindegree '(+ -4 (expt t 3) (* 2 x r t))) -> 0
        (mindegree '(POLY ((M -4 0 NIL) (M 2 3 ((V 1 R) (V 1 T) (V 1 X))) (M 1 3 ((V 3 T)))))) -> 0

 - polyplus -> dati due qualsiasi input ritorna la somma dei polinomi sotto forma di polinomio parsato
    es. (polyplus '(+ -4 (expt t 3)) '(+ 5 (* 2 x))) -> (POLY ((M 1 0 NIL) (M 2 1 ((V 1 X))) (M 1 3 ((V 3 T)))))
        (polyplus '(POLY ((M -4 0 NIL) (M 1 3 ((V 3 T))))) '(POLY ((M 5 0 NIL) (M 2 1 ((V 1 X)))))) -> (POLY ((M 1 0 NIL) (M 2 1 ((V 1 X))) (M 1 3 ((V 3 T)))))

 - polyminus -> dati due qualsiasi input ritorna la differenza dei polinomi sotto forma di polinomio parsato
    es. (polyminus '(+ -4 (expt t 3)) '(+ 5 (* 2 x))) -> (POLY ((M -9 0 NIL) (M -2 1 ((V 1 X))) (M 1 3 ((V 3 T)))))
        (polyminus '(POLY ((M -4 0 NIL) (M 1 3 ((V 3 T))))) '(POLY ((M 5 0 NIL) (M 2 1 ((V 1 X)))))) -> (POLY ((M -9 0 NIL) (M -2 1 ((V 1 X))) (M 1 3 ((V 3 T)))))

 - polytimes -> dati due qualsiasi input ritorna il prodotto dei polinomi sotto forma di polinomio parsato
    es. (polytimes '(+ -4 (expt t 3)) '(+ 5 (* 2 x))) -> (POLY ((M -20 0 NIL) (M -8 1 ((V 1 X))) (M 5 3 ((V 3 T))) (M 2 4 ((V 3 T) (V 1 X)))))
        (polytimes '(POLY ((M -4 0 NIL) (M 1 3 ((V 3 T))))) '(POLY ((M 5 0 NIL) (M 2 1 ((V 1 X)))))) -> (POLY ((M -20 0 NIL) (M -8 1 ((V 1 X))) (M 5 3 ((V 3 T))) (M 2 4 ((V 3 T) (V 1 X)))))

 - polyval -> dato un qualsiasi input e una lista di valori,  ritorna il risultato dell'espressione sostituendo i valori della lista valori alle variabili del polinomio, associando ogni valore alla lista di variabili ordinata e senza ripetizioni (associa quindi i valori che si passano in input al risultato di variables del polinomio) (N.B. se ci sono piu variabili che valori la funzione darà errore, se ci saranno piu valori che variabili, verranno ignorate quelle in eccesso)
    es. (polyval '(+ -4 (expt t 3)) '(1 2)) -> -3
        (polyval '(POLY ((M -4 0 NIL) (M 1 3 ((V 3 T))))) '(1 2)) -> -3

 - pprint-polynomial -> dato un qualsiasi input stampa il polinomio nella forma tradizionale e ritorna nil (se i coefficienti di una moltiplicazione sono 1 o -1 verranno omessi, nel caso del -1 verrà stampato solo un -), se l'esponenete è 1 non viene stampato, inoltre si omette il simbolo *
    es. (pprint-polynomial '(+ -4 (expt t 3) 5 (* 2 x))) -> 1 + 2 X + T^3 
        (pprint-polynomial '(POLY ((M -4 0 NIL) (M 1 3 ((V 3 T)))))) -> -4 + T^3 




---------------------------- DESCRIZIONE FUNZIONI SECONDARIE CON INPUT SPECIFICI -------------------------------------
 
 - as-monomial2 -> funzione d'appoggio di as-monomial, riceve l'input da as-monomial nel caso in cui l'input di as-monomial inizi con * e ci sia una lista dopo, ritona il monomio parsato, compresso e ordinato

 - parse -> prende in input l'espressione da parsare (senza il *), ritorna in output la VP-List fatta
    es. (parse'(y (expt x 2))) -> ((V 1 Y) (V 2 X))

 - parse2 -> funzione d'appoggio di parse, prende in input una variabile alla volta del monomio e ritorna in output il singolo VP
    es. (parse2 '(expt x 2)) -> ((V 2 X))
        (parse2'(expt x 0)) -> NIL

 - total-degree -> prende in input la VP-List e somma tutti gli esponenti delle variabili del monomio
    es. (total-degree '((V 1 Y) (V 2 X))) -> 3

 - vars-of2 -> funzione d'appoggio di vars-of, prende in input la VP-List e ritorna la lista di varibili

 - coefficients2 -> funzione d'appoggio di coefficients, riceve in input un polinomio gia parsato e ritorna la lista di coefficienti ordinati per come si trovano nel polinomio parsato

 - variables2 -> funzione d'appoggio di variables, riceve in input un polinomio gia parsato e ritorna la lista di variabili non ordinata e con i duplicati

 - variables3 -> funzione d'appoggio di variables2, riceve in input la VP-List e ritorna la lista di variabili non ordinata e con i duplicati

 - as-polynomial2 -> funzione d'appoggio di as-polynomial, prende in input l'espressione escluso l'operatore +, richiama as-monomial per ogni elemento della lista, ritorna la lista di monomi,che poi si andrà a unire con la lista (POLY) in as-polynomial

 - ordina-monomio -> prende in input la VP-List del monomio, la ordina secondo un ordine lessicografico e la restituisce
    es. (ordina-monomio '((V 1 X)(V 1 A))) -> ((V 1 A) (V 1 X))

 - compress-mono -> prende in input la VP-List del monomio, ritorna la lista ordinata e compressa

 - compress2 -> funzione d'appoggio di compress-mono, prende in input la VP-List ordinata del monomio, ritorna la lista compressa e ordinata

 - compress-poly -> prende in input un polinomio già parsato, ritorna il polinomio compresso, ordinato e senza monomi con coefficiente 0

 - compress-poly2 -> funzione d'appoggio di compress-poly, prende in input la lista dei monomi del polinomio e restituisce il polinomio compresso

 - riconosci -> prende in input tutti i casi definiti in <INFORMAZIONI PROGETTO> e restituisce un poinomio parsato, compresso e ordinato

 - deletezero -> prende in input un polinomio parsato, ritorna il polinomio eliminando i monomi con coefficiente 0

 - deletezero2 -> funzione d'appoggio di deletezero, prende in input la lista dei monomi del polinomio, ritorna la lista dei monomi eliminando i monomi con coefficiente 0

 - cambia-coefficiente -> funzione d'appoggio di polyminus, prende in input la lista dei monomi del polinomio, ritorna la lista dei monomi con i coefficienti moltiplicati per -1

 - polymoltiplicazione -> funzione 'appoggio di polytimes, prende in input le liste dei monomi dei due polinomi che gli passa polytimes, le moltiplica e ritorna un unica lista a polytimes, che poi compresserà e ordinerà

 - compress-times -> funzione d'appoggio di polytimes, prende in input il risultato di polymoltiplicazione, comprime le VP-List di tutti i monomi e ritorna il risultato a polytimes

 - polyval2 -> funzione d'appoggio di polyval, prende in input la lista dei monomi, escluso il primo monomio, e la lista di valori che gli passa polyval; ritorna il risultato dell'espressione escluso il risutato del primo monomio, con cui si sommerà poi in polyval 

 - pairlis1 -> funzione d'appoggio di polyval, prende in input la lista variables del polinomio passato a polyval, e restituisce una lista con le variabili associate al valore
    es. (pairlis1 '(A B C) '(1 2 3)) -> ((A 1) (B 2) (C 3))

 - confronta -> funzione d'appoggio di polyval e polyval2, prende in input la VP-List e la lista di pairlis1, confronta ogni variabile con la lista di pairlis1, quando trova una corrispondenza eleva il valore associato alla variabile con l'esponente della variabile
    es. (confronta '((V 2 X)) '((X 3))) -> 9

 - ordina-poly -> prende in input un polynomio parsato, ritorna il polinomio parsato e ordinato, non compresso

 - ordina-poly2 -> funzione d'appoggio di ordina-poly, prende in input la lista dei monomi del polinomio e compressa le VP-List di ogni monomio

 - ordina-poly3 -> funzione d'appoggio di ordina-poly, prende in input la lista dei monomi ordinata in base alla sortpoly, compressata da ordina-poly2, in output ritorna la lista dei monomi ordinata secondo il total degree

 - sortpoly -> funzione d'appoggio di ordina-poly, definisce l'ordinamento dei monomi in base lessico grafico delle VP-List, ritorna la lista ordinata, che poi passerà a ordina-poly3 per essere ordinata in base al total degree

 - scomponi-lista -> funzione d'appoggio di pprint-polynomial, prende in input una VP-List e stampa nello standard output una rappresentazione tradizionale della VP-List, se l'esponenete è 1 non viene stampato, inoltre si omette il simbolo *
    es. (scomponi-lista '((V 1 X)(V 2 Y))) -> X Y^2

 - pprint-polynomial2 -> funzione d'appoggio per pprint-polynomial, serve principalmente per la ricorsione, visto che il primo monomio viene trattato diversamente da pprint-polynomial, pprint-polynomial2 invece gestisce i monomi dal secondo in poi, ritorna in fine NIL