-------------------------------------------------------
Convex Hulls, Seveso Andrea 781856, Ahmed Moksud 765060
-------------------------------------------------------

Implementazione in Common Lisp del calcolo delle chiglie convesse utilizzando il "Graham Scan".
Come risultato finale abbiamo scelto di ritornare una lista in ordine
antiorario, anche se non si é ben capito se la lista da ritornare
dev'essere in senso orario o antiorario.
Inoltre abbiamo deciso che se la lista da ritornare (cioé la Convex Hull
calcolata tramite il nostro programma) contiene meno di 3 punti, non si
tratta di un poligono, e quindi restituiamo false.
Queste sono gli unici 2 punti di perplessità, e qui abbiamo spiegato il
perché delle nostre scelte.

-------------------------------------------------------

Fonti e documentazione:

* Introduzione agli algoritmi e strutture dati
Thomas H. Cormen, Charles E. Leiserson, Ronald L. Rivest, Clifford Stein
Capitolo 33 - Geometria computazionale

* Lee Mac Programming
http://www.lee-mac.com/

-------------------------------------------------------

La libreria contiene 14 predicati, ampiamente commentati nel codice stesso. 
Per comodità li elencherò a seguire, spiegando il loro funzionamento:

* (make-point x y): Definisce un punto creando una lista nel formato: '(x y).

* (x point): Restituisce l'ordinata del punto dato per argomento.

* (y point): Restituisce l'ascissa del punto dato per argomento.

* (is-a-pointp point): Restituisce t se l'argomento è un punto, nil altrimenti.

* (all-points-listp pointlist): Il predicato ritorna t se tutti i membri della lista sono punti, nil altrimenti.

* (area2 a b c): Dati tre punti restituisce il doppio dell'area del triangolo che descrivono.
Risultato > 0 se senso antiorario, < 0 senso orario, = 0 punti collineari.

* (left a b c): Il predicato ritorna t se i tre punti sono validi e rappresentano una svolta
a sinistra (ovvero in senso antiorario), nil in tutti gli altri casi.

* (left-on a b c): Il predicato ritorna t se i tre punti sono validi e rappresentano una svolta
a sinistra (ovvero in senso antiorario) oppure se i tre punti sono collineari, nil in tutti gli altri casi.

* (collinear a b c): Il predicato restituisce t se a,b,c sono collineari.
Restituisce nil se non sono collineari oppure non sono dei punti.

* (angle2d a b): La funzione ritorna l'angolo (in radianti) tra due punti, nil se i punti non sono validi.

* (distanceSqrd a b): La funzione ritorna il quadrato della distanza tra due punti.

* (removeSameAngle listaPunti p): Precondizione: i punti di lat sono ordinati per angolo polare da p.
Se piu' punti hanno stesso angolo polare da p, il primo in ordine e' il piu' vicino a p, mentre l'ultimo in ordine 
e' il piu' distante.Rimuove i punti che hanno lo stesso angolo polare da p e distanza non massima.

* (ch p): Scansione di Graham. L'algoritmo richiede in input una lista di punti e restituisce 
la chiglia convessa come lista di punti. Ampiamente commentata nel codice.

* (read-points filename): Funzione che legge una lista di punti da un file.