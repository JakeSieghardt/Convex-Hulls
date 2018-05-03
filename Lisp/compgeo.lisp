;;;;Convex Hulls, Seveso Andrea 781856, Ahmed Moksud 765060

;;;Definisce un punto creando una lista nel formato: '(x y).
(defun make-point (x y) (
	when (and (integerp x)(integerp y))
		(list x y)))
	
(defun x (point) (car point)) ;Restituisce l'ordinata del punto dato per argomento.
(defun y (point) (cadr point)) ;Restituisce l'ascissa del punto dato per argomento.

;;;Restituisce t se l'argomento è un punto, nil altrimenti.
(defun is-a-pointp (point) (
	and (listp point) (integerp (x point)) (integerp (y point)) (null (caddr point))))

;;;Il predicato ritorna t se tutti i membri della lista sono punti, nil altrimenti.
(defun all-points-listp (pointlist) (
	cond 
		((null pointlist) t)
		((not(is-a-pointp (car pointlist))) nil)
		(t (all-points-listp (cdr pointlist)))))	

;;;Dati tre punti restituisce il doppio dell'area del triangolo che descrivono.
;;;Risultato > 0 se senso antiorario, < 0 senso orario, = 0 punti collineari.
(defun area2 (a b c) (
;;Se sono effettivamente punti effettua l'operazione, altrimenti restituisce nil.
	when (and (is-a-pointp a) (is-a-pointp b) (is-a-pointp c)) 	
	(- (* (- (x b) (x a)) (- (y c) (y a))) (* (- (y b) (y a)) (- (x c) (x a))))))	
	
;;;Il predicato ritorna t se i tre punti sono validi e rappresentano una svolta
;;;a sinistra (ovvero in senso antiorario), nil in tutti gli altri casi.
(defun left (a b c) (
	let ((ar (area2 a b c)))
		(when ar (
			if (> ar '0) t nil))))

;;;Il predicato ritorna t se i tre punti sono validi e rappresentano una svolta
;;;a sinistra (ovvero in senso antiorario) oppure se i tre punti sono collineari,
;;;nil in tutti gli altri casi.
(defun left-on (a b c) (
	let ((ar (area2 a b c)))
		(when ar (
			if (>= ar '0) t nil))))

;;;Il predicato restituisce t se a,b,c sono collineari.
;;;Restituisce nil se non sono collineari oppure non sono dei punti.
(defun collinear (a b c) (
	let ((ar (area2 a b c)))
		(when ar (
			when (zerop ar) t))))
	
;;;La funzione ritorna l'angolo (in radianti) tra due punti, nil se
;;;i punti non sono validi.
(defun angle2d (a b) (
	when(is-a-pointp b)  (
	atan (- (y b) (y a)) (- (x b) (x a)))))	

;;;La funzione ritorna il quadrato della distanza tra due punti.	
(defun distanceSqrd (a b) (
	+ (expt (- (x b) (x a)) 2) (expt (- (y b) (y a)) 2)))

;;;Precondizione: i punti di lat sono ordinati per angolo polare da p.
;;;Se piu' punti hanno stesso angolo polare da p, il primo in ordine 
;;;e' il piu' vicino a p, mentre l'ultimo in ordine e' il piu' distante.
;;;Rimuove i punti che hanno lo stesso angolo polare da p e distanza non massima.
(defun removeSameAngle (lat p) (
	if (null (cdr lat)) (list(car lat))
	(if (equal (angle2d p (car lat))(angle2d p (cadr lat)))
		(removeSameAngle (cdr lat) p) ;Se i due angoli sono uguali rimuove il primo.
		(cons (car lat) (removeSameAngle (cdr lat) p))))) ;Se i due angoli non sono uguali non rimuove.

;;;Scansione di Graham. L'algoritmo richiede in input una lista di punti e 
;;;restituisce la chiglia convessa come lista di punti.
(defun ch (p) ( 
	cond
		;;Controlli iniziali sull'input. 
		((not(listp p)) nil) ;Se l'input non e' una lista, ritorna nil
		(t 	(setf p (remove-duplicates p :test #'equal)) ;;Rimuove punti duplicati
		(cond 
			((not(all-points-listp p)) nil) ;Tutti gli elementi della lista devono essere punti
			((< (length p) '3) nil) ;Se p ha meno di 3 punti, la figura non e' un poligono, ritorna nil.
			
		;;L'input e' corretto. Trova l'elemento di p con ascissa minore (e ordinata minore).
		(t 	(setf p0 (car p)) ;Imposta p0 come car p
            (loop for p1 in (cdr p) ;Inizio del loop. 
               do (when  (or(< (y p1) (y p0)) ;Se p1 ha ascissa minore di p0
				(and (eq (y p1) (y p0)) (< (x p1) (x p0)))) ;Oppure la stessa ascissa e ordinata minore
				(setf p0 p1))) ;p1 diventa il nuovo p0 e riparte il loop.  
				
			;;Ordiniamo i punti di p per angolo polare a partire da p0.
			(setf p (sort p 
				(lambda (a b) ( ;A parità di angolo polare, si ordinano prima quelli piu' vicini.
					if (equal (setf c (angle2d p0 a)) (setf d (angle2d p0 b)))
						(< (distanceSqrd p0 a) (distanceSqrd p0 b))
						(< c d)))))
			
			;;Grazie al particolare sort sopra usato, possiamo utilizzare removeSameAngle.
			;;La funzione non ci restituisce per la sua natura il car (p0) della lista
			;;se il cadr ha lo stesso angolo polare, quindi passiamo il cdr di p e ci consiamo p0.
			(setf p (cons p0(removeSameAngle (cdr p) p0))) 
			;;La lista p ora e' pronta per la costruzione della ch. 
					
			;;Inizia a costruire la lista che contiene la chiglia convessa.
			(setf convex (list (caddr p) (cadr p) (car p))) 
			
				(loop for p2 in (cdddr p) do  ;Loop nella parte rimanente di p
					(setf convex (cons p2 convex)) ;Inserisci p2 in convex, ogni loop convex ha un elemento in piu'
					(loop while (and (caddr convex) (not (left-on (caddr convex) (cadr convex) p2))) ;quando la lista
					;;ha 3 o piu' elementi e l'angolo formato dagli ultimi tre punti indica una svolta a destra
						do (setf convex (cons p2 (cddr convex))))) ;;toglie i 2 elementi in cima e inserisce p2
						
			(setf convex (reverse (cons p0 convex)))
			;;Restituisce il valore finale
			convex)))))

;;;Funzione che legge una lista di punti da un file
(defun read-points (filename)
	(with-open-file (in filename) ;Apre lo stream 
		(loop for line = (read-line in nil nil) ;Loop finchè non si e' alla fine del file
		while line ;Linea non vuota, si va a creare la lista
		collect (read-from-string (concatenate 'string "(" line")")))))