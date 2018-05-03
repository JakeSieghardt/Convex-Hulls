Linguaggi di programmazione - Progetto Prolog - Luglio 2015

Autori:
Ahmed Moksud - Matricola: 765060
Seveso Andrea - Matricola: 781856



Nome progetto: Convex Hulls (Chiglie convesse)
Obiettivo: Creazione di un programma Prolog che dato in input una lista
di punti, restituisca una lista contenente la Convex Hull creata
tramite uno dei tanti algoritmi di calcolo di una Convex Hull.



Predicati usati:

read_points/2 -> legge un file csv contenete punti, la struttura del file prevede che ci sia un punto per ogni riga e le coordinate sono separate da un carattere di tabulazione
area2/4 -> dati 3 punti calcola l'area moltiplicata per due

left/3 -> mi dice se l'angolo formato dai 3 punti é un angolo a sinistra

left_on/3 -> mi dice se l'angolo formato dai 3 punti é un angolo a sinistra o sulla linea immagiaria tracciata tra i primi due punti

collinear/3 -> mi dice se i 3 punti sono collineari
angle2d/3 -> calcola l'angolo in radianti tra i 2 punti

ch/2 -> calcola la Convex Hull di una lista di punti

delete_duplicate/2 -> rimuove gli elementi duplicati da una lista

get_coordinate/3 -> estrae le coordinate X e Y di un punto

get_min_point/2 -> restituisce il punto con coordinata Y minore, in caso di parità quello con coordinata X minore

pop/3 -> rimuove un elemento dalla testa dello stack

push/3 -> aggiunge un elemento in testa allo stack

peek/2 -> legge l'elento in cima allo stack senza eliminarlo

convex_hull/3 -> calcola la Convex Hull



Fonti usate per la realizzazione del progetto re-nfa.pl:
	- J. O’Rourke, Computational Geometry in C, Cambridge University Press, 1998.
	- T. H. Cormen, C. E. Leiserson, R. L. Rivest, C. Stein, Introduction to Algorithms, 2nd Edition, MIT Press, 2001
	- Sio web http://www.geeksforgeeks.org/convex-hull-set-2-graham-scan/
	- Wikipedia - Algoritmo Graham Scan
	- Sito web http://www.cse.unsw.edu.au/~billw/dictionaries/prolog/
	- Moodle Informatica di Linguaggi di programmazione
	- Youtube - Videolezioni del professor Braione