/*
Linguaggi di programmazione - Progetto Prolog - Luglio 2015


Autori:
Ahmed Moksud - Matricola: 765060
Seveso Andrea - Matricola: 781856
*/


/*
Nome progetto: Convex Hulls (Chiglie convesse)
Obiettivo: Creazione di un programma Prolog che dato in input una lista
di punti, restituisca una lista contenente la Convex Hull creata
tramite uno dei tanti algoritmi di calcolo di una Convex Hull.

Svolgimento: Ho implementato tutti i predicati richiesti dal prof, che
erano molto semplici, grazie anche all'aiuto del libro.
L'unico predicato difficile é il CH che calcola la Convex Hull vera e
propria.
Come algoritmo di calcolo della Convex Hull ho deciso di usare il Graham
Scan, un'algoritmo di computazione della Convex Hull di un insieme
finito di punti in un piano, ed ha complessità O(n log n).
Come risultato finale abbiamo scelto di ritornare una lista in ordine
antiorario, anche se non si é ben capito se la lista da ritornare
dev'essere in senso orario o antiorario.
Inoltre abbiamo deciso che se la lista da ritornare (cioé la Convex Hull
calcolata tramite il nostro programma) contiene meno di 3 punti, non si
tratta di un poligono, e quindi restituiamo false.
Queste sono gli unici 2 punti di perplessità, e qui abbiamo spiegato il
perché delle nostre scelte.
*/


/*
Uso il predicato read_points/2 per leggere un file che contiene i punti,
il file contenente i punti é costituito da un numero pari d'interi, due
per riga, separati da un carattere di tabulazione.
Il primo argomento del predicato é il nome del file, mentre il secondo
argomento é il nome di una variabile (lista), che conterrà una lista con
dentro tutti i punti letti dal file in input.
Dentro al predicato read_points/2 controllo che il Filename, cioé il
nome del file dato in input non sia una variabile, in caso positivo,
fermo il programma e restituisco false, successivamente controllo che il
nome del file inserito come primo argomento esiste nel percorso
specificato, infine uso il predicato di default per leggere i file in
csv, il predicato csv_read_file/2, che ha come primo argomento il nome
del file da leggere, come secondo argomento il nome della lista che
conterrà i miei punti, come terzo argomento indico il separatore usato
nel nostro file di input (carattere di tabulazione) perché noi non
abbiamo come separatore il separatore di default (punto e virgola),
indico l'arità e il nome del funtore cosi da poter asserire i vari
punti tramite il predicato maplist/2, ovviamente prima di asserire i
punti richiamo il predicato delete_duplicate/2 che elimina i punti
duplicati.
*/
read_points(Filename, Points) :- nonvar(Filename), !, exists_file(Filename), !,
	csv_read_file(Filename, Rows, [separator(0'\t), arity(2), functor(pt)]),
	delete_duplicate(Rows, Points), maplist(assert, Points).


/*
Questo predicato prende come argomenti 2 liste, prende la lista
passata come primo argomento e restituisce come secondo argomento
la stessa lista rimuovendo gli elementi duplicati.
*/
delete_duplicate(L1,L2) :- delete_duplicate(L1,[],L2).
delete_duplicate([],ACC,ACC).
delete_duplicate([H|L1],ACC,L2) :-
member(H,ACC),!,
delete_duplicate(L1,ACC,L2).
delete_duplicate([H|L1],ACC,L2) :-
append(ACC,[H],ACC1),
delete_duplicate(L1,ACC1,L2).


/*
Uso il predicato get_coordinate/3 per estrarre le coordinate di un
punto.
*/
get_coordinate(P, X, Y) :- nonvar(P), !, arg(1, P, X), arg(2, P, Y).


/*
Uso il predicato get_min_point/2 per ottenere il punto con la
coordinata Y minore, nel caso ci siano piu punti con la coordinata Y
minore di tutti, tra questi punti, scelgo quello con la coordinata X
minore.
*/
get_min_point([X], X) :- !.

get_min_point([A, B | T], Min) :-
	get_coordinate(A, X1, Y1),
	get_coordinate(B, X2, Y2),
	(
	    Y1 < Y2 -> get_min_point([A | T], Min) ;
	    Y2 < Y1 -> get_min_point([B | T], Min) ;
	    X1 < X2 -> get_min_point([A | T], Min) ;
	    get_min_point([B | T], Min)
	).


/*
Questa funzione viene usata per calcolare l'area di un triangolo date le
coordinate dei vertici, i primi 3 argomenti sono i 3 punti che sono i
vertici del triangolo di cui dobbiamo calcolare l'area, per calcolare
l'area usiamo una formula trovata nel file PDF che descriveva il
progetto, il quarto argomento é il risultato, cioé l'area.
Da notare che se il valore dell'area é positivo, allora l'angolo abc é
un angolo a sinistra, nel caso in cui il valore dell'area risulti
negativo, allora l'angolo abc é un angono a destra, mentre nel caso
l'area risulti 0, sappiamo con certezza che i 3 punti sono collineari.
Per il calcolo dell'area evitiamo l'inutile divisione per 2, perché non
é di nostro interesse poiché il risultato area*2 ci basta per
raggiungere il nostro obiettivo, cioé capire se stiamo facendo una
svolta a sinistra o a destra.
*/
area2(A, B, C, Area) :-
	nonvar(A), !, nonvar(B), !, nonvar(C),	!,
	get_coordinate(A, X1, Y1),
	get_coordinate(B, X2, Y2),
	get_coordinate(C, X3, Y3),
	Area is (((X2 - X1) * (Y3 - Y1)) - ((Y2 - Y1) * (X3 - X1))).


/*
Dati 3 punti, questo predicato ci dice se il terzo punto sta alla
sinistra della linea immaginaria tracciata tra il primo e il secondo
punto. Leggendo il libro di Joseph O'Rourke capiamo che dati 3 punti in
un ordine (a,b,c), il punto 'c' si trova a sinistra della linea
immaginaria tra 'a' e 'b' se l'area (a,b,c) é maggiore di 0. Quindi
possiamo far uso del predicato area/4 per capire se il terzo punto é
alla sinistra o no.
*/
left(A, B, C) :- nonvar(A), !, nonvar(B), !, nonvar(C), !,
	area2(A, B, C, Area),
	Area > 0 -> true ; false.


/*
Dati 3 punti, questo predicato ci dice se il terzo punto sta alla
sinistra o sopra la linea immaginaria tracciata tra il primo e il
secondo punto. Leggendo il libro di Joseph O'Rourke capiamo che dati 3
punti in un ordine (a,b,c), il punto 'c' si trova a sinistra o
sopra la linea immaginaria tra 'a' e 'b' se l'area (a,b,c) é maggiore o
uguale a 0. Quindi possiamo far uso del predicato area/4 per capire se
il terzo punto é alla sinistra o sopra la linea immaginaria tra 'a' e
'b' o no.
*/
left_on(A, B, C) :- nonvar(A), !, nonvar(B), !, nonvar(C), !,
	area2(A, B, C, Area),
	Area >= 0 -> true ; false.



/*
Dati 3 punti, questo predicato ci dice se i 3 punti sono allineati o no.
Leggendo dal libro di Joseph O'Rourke capiamo che dati 3 punti in un
ordine (a,b,c), i 3 punti sono allineati se la loro area (a,b,c) é
uguale a 0. Quindi possiamo fare uso del predicato area2/4 per capire se
i 3 punti sono allineati o no.
*/
collinear(A, B, C) :- nonvar(A), !, nonvar(B), !, nonvar(C), !,
	area2(A, B, C, Area),
	Area = 0 -> true ; false.



/*
Questo predicato ci serve per calcolare l'angolo tra 2 punti, il primo e
il secondo argomento sono due punti, mentre il terzo argomento é il
risultato che ottengo usando la funziona atan/2 che mi restituisce
l'angolo in radianti tra due punti. In realtà sarebbe l'angolo che c'é
se tracciassimo le due rette dei due punti, e poi misurassimo l'angolo
che formano le due rette quando si incontrano.
*/
angle2d(B, A, Result) :- nonvar(A), !, nonvar(B), !,
	get_coordinate(A, X1, Y1),
	get_coordinate(B, X2, Y2),
	Result is atan2((Y1-Y2),(X1-X2)).


/*
Questo é il predicato vero e proprio che calcolerà la chiglia convessa
chiamando i vari predicati che ci servono, il primo argomento é una
lista di punti, mentre il secondo argomento é una lista che conterrà la
Convex Hull della lista passata come primo argomento.

L'algoritmo funziona cosi:

1: Eliminiamo dalla lista da elaborare il punto minimo, lo aggiungeremo
dopo come primo elemento, tanto sappiamo che il punto minimo (quello con
coordinata Y minore, fa parte della Convex Hull. Quindi otteniamo una
lista che contiene tutti gli elementi passati come argomento, tranne il
primo elemento (punto).

2: Creiamo delle coppie (punto minimo, punto2), (punto minimo, punto3),
ecc... cosi da poter ordinare tutti i punti (tranne il primo) secondo
l'angolo polare che formano col punto minimo.

3: Uso il predicato keysort/2 che serve per ordinare una lista di coppie
(chiave - valore).

4: Controllo che ci siano coppie chiave-valore per tutti i punti.

5: Faccio il push, cioé aggiungo nello stack il punto minimo e il primo
punto della mia lista.

6: Chiamo il predicato convex_hull che calcola la
mia Convex Hull.

7: Aggiungo di nuovo il punto minimo nello stack, cosi "chiudo" la mia
Convex Hull.

8: Dopo aver ottenuto la mia Convex Hull, con i punti in senso orario,
uso il predicato reverse per invertire la lista ed avere una lista con i
punti in senso antiorario. Avrei potuto fare direttamente in senso
antiorario, ma siccome dal testo non era sicuro se fare in senso orario
o antiorario, avevo pensato in senso orario, dopo il mio collega mi ha
avvertito che forse la lista dev'essere in senso antiorario, quindi
invece che modificare direttamente l'algoritmo, ho preferito aggiungere
semplicemente un predicato reverse/2 che mi ritorna la lista con
l'ordine invertito, quindi con i punti in ordine antiorario.

9: Siccome prima di inziiare l'algoritmo non ho fatto controlli di
questo tipo, controllo se il risultato da me ottenuto é un poligono
tramite il predicato is_polygon/1 che mi restituisce true se si tratta
di un poligono (lista contenente almeno 3 punti distinti), false se non
si tratta di un poligono.
*/
ch(Points, Result) :-
	calculate_ch(Points, X),
	reverse(X, Result),
	is_polygon(Result).

calculate_ch(Points, Result) :-
	nonvar(Points), !, get_min_point(Points, MinPoint),
	delete(Points, MinPoint, PointsM),
	create_pairs(MinPoint, PointsM, Pairs),
	keysort(Pairs, SortedPairs),
	pairs_keys_values(SortedPairs, _, [A | B]),
	push(MinPoint, [], S),
	push(A, S, S1),
	convex_hull(B, S1, Res),
	push(MinPoint, Res, Result).

/*
Serve a verificare che la Convex Hull sia un poligono, cioé che abbia
almeno 3 punti.
*/
is_polygon(Result) :-
	length(Result, X),
	X > 3 -> true ; false.



create_pairs(_, [], []) :- !.

create_pairs(S, [H | T], Pairs) :- nonvar(S), !,
	angle2d(S, H, R),
	create_pairs(S, T, NewPairs),
	Pairs = [R-H | NewPairs].

/*
L'algoritmo di Convex Hull funziona cosi:

1: Controllo che i primi 2 elementi della lista non siano variabili.

2: Rimuovo un elemento dalla testa dello stack, chiamamolo punto A, poi
leggo il punto nella testa dello stack, senza eliminarlo, chiamiamolo
punto B, ed entro in un ciclo if-else.

Se il punto H (primo elemento della lista in ingresso) si trova a
sinistra (lo verifico tramite il predicato left/3), faccio la push del
punto A e del punto H e richiamo il predicato convex_hull per ricorsione
sul resto della lista.

Se il punto H (primo elemento della lista in
ingresso) e i punti A e B sono collineari, allora faccio la push del
punto H (primo elemento della lista in ingresso) e richiamo il predicato
convex_hull per ricorsione sul resto della lista.

Se il punto H (primo elemento della lista in ingresso) non si trova alla
sinistra, lo salto e per ricorsione richiamo il predicato convex_hull
sul resto della lista.
*/
convex_hull([], S, S) :- !.

convex_hull([H | T], S, CH) :- nonvar(H), !, nonvar(T), !,
	pop(Middle, S, S1),
	peek(Tail, S1),
	( left_on(Tail, Middle, H) ->
		( left(Tail, Middle, H) ->
			push(Middle, S1, S2),
			push(H, S2, S3),
			convex_hull(T, S3, CH) ;
		collinear(Tail, Middle, H) ->
			push(H, S1, S4),
			convex_hull(T, S4, CH) ) ;
		convex_hull([H | T], S1, CH) ).


/*
Questo predicato rimuove un elemento dalla testa dello stack.
*/
pop(A, [A | B], B).


/*
Questo predicato legge l'elemento in cima allo stack, senza eliminarlo.
*/
peek(A, [A | _]).


/*
Questo predicato aggiunge un elemento in testa allo stack.
*/
push(A, B, [A | B]).
