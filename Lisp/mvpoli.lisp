;;;; 807500 Lotterio Roberto
;;;; 807141 Balducci Gianmaria

;------------------------------LISP-------------------------------
(defun is-monomial (m)
  (and (listp m)
       (eq 'm (first m))
       (let ((mtd (third m))
             (vps (fourth m))
             )
         (and (integerp mtd)
              (>= mtd 0)
              (listp vps)
              (every #'is-varpower vps)))))


(defun is-varpower(vp)
  (and (listp vp)
       (eq 'v (first vp))
       (let ((p (second vp))
             (v (third vp))
             )
         (and (integerp p)
              (>= p 0)
              (symbolp v)))))


(defun is-polynomial (p)
  (and (listp p)
       (eql 'poly (first p))
       (let ((ms (second p)))
         (and (listp ms)
              (every #'is-monomial ms)))))

;----------------------AS-MONOMIAL------------------------------------------
(defun as-monomial (Mono)
  (cond ((null Mono) nil)
        ((numberp Mono) 
         (list 'm Mono 0 ()))
        ((symbolp Mono) 
         (list 'm 1 1 (compress-mono (parse Mono))))
        ((eql 'm (first Mono)) Mono)
        ((eql 'expt (car mono)) 
         (list 'm 1 (third mono) (compress-mono (parse Mono))))
        ((and (eql '* (car Mono)) 
              (null (rest mono)))  
         (list 'm 1 0 nil))
        ((eql '+ (first Mono)) (Error "Input errato" Mono))
        ((and (= (length Mono) 1)
              (symbolp (first Mono)))             
         (list 'm 1 1 (compress-mono (parse Mono))))
        ((and (numberp (eval (car Mono)))
              (null (cdr Mono)))
         (list 'm (car Mono) 0 ()))
        ((and (eql '* (car Mono)) 
              (listp  Mono)) (as-monomial2 (cdr Mono)))
        ((symbolp (first Mono)) 
         (list 'm 1 1 (compress-mono (parse Mono))))
        ((eql 'expt (first (first Mono))) 
         (list 'm 1 (third (first Mono)) (compress-mono (parse Mono))))
        (t (Error "Input errato"))))


(defun as-monomial2 (Espr)
  (cond ((eq (car Espr) 0) (list 'm 0 0 ()))
        ((null (car Espr)) (list 'm 0 0 ()))
        ((and (numberp (car Espr)) 
              (null (cdr Espr))) 
         (list 'm (car Espr) 0 ()))
        ((symbolp (car Espr)) 
         (list 'm 
               1 
               (total-degree (parse Espr)) 
               (compress-mono (parse Espr))))
        ((numberp (car Espr)) 
         (list 'm 
               (eval (car Espr)) 
               (total-degree (parse (cdr Espr))) 
               (compress-mono (parse (cdr Espr)))))
        ((numberp (second (car Espr))) 
         (list 'm 
               (eval (car Espr)) 
               (total-degree (parse (cdr Espr))) 
               (compress-mono (parse (cdr Espr)))))
        ((eql 'expt (first (first Espr))) 
         (list 'm 
               1 
               (total-degree (parse Espr)) 
               (compress-mono (parse Espr))))
        ((numberp (eval (car Espr))) 
         (list 'm 
               (eval (car Espr)) 
               (total-degree (parse (cdr Espr))) 
               (compress-mono (parse (cdr Espr)))))))



(defun parse (mono)
  (cond ((null mono) nil)
        ((symbolp mono) 
         (list (list 'v 1 mono)))
        ((and (eql 'expt (first mono))
              (eq (third mono) 0)) nil)   
        ((eql 'expt (first mono)) 
         (list (list 'v (third mono) (second mono))))
        ((and (eql 'expt (first mono)) 
              (eq (third mono) 0)) nil)
        (t (append (parse2 (car mono))
                   (parse (cdr mono))))))

(defun parse2 (mono)
  (cond ((null mono) nil)
        ((symbolp mono) 
         (list (list 'v 1 mono)))
        ((and (eql 'expt (first mono)) 
              (eq (third mono) 0)) nil)
        ((eql 'expt (first mono)) 
         (list (list 'v (third mono) (second mono))))
        ((symbolp (first mono)) 
         (list (list 'v 1 (first mono))))
        ((eq (third mono) 0) nil)))


(defun total-degree (var)
  (cond ((null var) 0)
        (t (+ (second (first var)) 
              (total-degree (rest var))))))


(defun ordina-monomio (var)
  (cond ((null var) nil)
        (t (sort  var #'string< :key #'third))))
  
(defun compress-mono (var)
  (compress2 (ordina-monomio (copy-list var))))


;-----------------VARPOWERS----------------------------------------------
(defun varpowers (mono)
  (cond ((is-monomial (as-monomial mono))
         (cond ((null mono) nil)
               ((eql 'm (first mono)) (fourth mono))
               (t (fourth (as-monomial mono)))))
        (t (Error "Input errato" mono))))

;----------------VARS-OF-------------------------------------------------
(defun vars-of (mono)
  (cond ((is-monomial (as-monomial mono))
         (cond ((null mono) nil)
               ((eql 'm (first mono)) (vars-of2 (fourth mono)))
               (t (vars-of2 (fourth (as-monomial mono))))))
        (t (Error "Input errato" mono))))

(defun vars-of2 (mono)
  (cond ((null mono) nil)
        ((eql 'v  (first (first mono))) 
         (append (list (third (first mono))) 
                 (vars-of2 (rest mono))))))

;------------------------MONOMIAL DEGREE-----------------------------------
(defun monomial-degree (mono)
  (cond ((is-monomial (as-monomial mono))
         (cond ((null mono) nil)
               ((eql 'm (first mono)) (third mono))
               (t (third (as-monomial mono)))))
        (t (Error "Input errato"))))

;----------------------MONOMIAL COEFFICIENTS-------------------------------
(defun monomial-coefficient (mono)
  (cond ((is-monomial (as-monomial mono))
         (cond ((null mono) nil)
               ((eql 'm (first mono)) (second mono))
               (t (second (as-monomial mono)))))
        (t (Error "Input errato"))))


;----------------------COEFFICIENTS----------------------------------------
(defun coefficients (poly)
  (cond ((is-polynomial (riconosci poly))
         (cond ((null poly) (list 0))
               ((null (second (riconosci poly))) (list 0))
               (t (coefficients2 (second (riconosci poly))))))
        (t (Error "Input errato"))))

(defun coefficients2 (poly)
  (cond ((null poly) nil)
        ((eql 'm (first (first poly))) 
         (append (list (second (first poly))) 
                 (coefficients2 (rest poly))))
        (t (append (list (second (first (first poly)))) 
                   (coefficients2 (rest (first poly)))))))

;---------------------VARIABLES---------------------------------------------
(defun variables (poly)
  (cond ((is-polynomial (riconosci poly))
         (remove-duplicates 
          (sort 
           (cond ((null poly) nil)
                 (t (variables2 (second (riconosci poly)))))
           #'string<)))
        (t (Error "Input errato"))))

(defun variables2 (poly)
  (cond ((null poly) nil)
        (t (append (variables3 (fourth (first poly))) 
                   (variables2 (rest poly))))))

(defun variables3 (var)
  (cond ((null var) nil)
        (t (append (list (third (first var))) 
                   (variables3 (rest var))))))

;--------------------MONOMIALS--------------------------------------------
(defun monomials (poly)
  (cond ((is-polynomial (riconosci poly))
         (cond ((null poly) nil)
               (t (second (riconosci poly)))))
        (t (Error "Input errato"))))

;------------------MAX DEGREE---------------------------------------------
(defun maxdegree (poly)
  (cond ((is-polynomial (riconosci poly))
         (cond ((null poly) nil)
               (t (third (first (last (second (riconosci poly))))))))
        (t (Error "Input errato"))))

;----------------MIN DEGREE-----------------------------------------------
(defun mindegree (poly)
  (cond ((is-polynomial (riconosci poly))
         (cond ((null poly) nil)
               (t (third (first (second (riconosci poly)))))))
        (t (Error "Input errato"))))



;---------------------AS-POLYNOMIAL---------------------------------------
     
(defun as-polynomial (poly)
  (compress-poly 
   (ordina-poly 
    (cond ((null poly) 
           (list 'poly ()))
          ((eq poly 0) 
           (list 'poly ()))
          ((or (numberp poly) 
               (symbolp poly)) 
           (list 'poly (list (as-monomial poly))))
          ((eql 'poly (first poly)) 
           poly)
          ((eq (first poly) 0) 
           (list 'poly ()))
          ((eql '+ (first poly)) 
           (list 'poly (as-polynomial2 (rest poly))))
          ((eql '* (first poly)) 
           (list 'poly (list (as-monomial poly))))
          ((or (numberp (first poly)) 
               (symbolp (first poly))) 
           (list 'poly (list (as-monomial poly))))
          ((and (eql 'm (first (first poly))) 
                (eq (second (first poly)) 0)) 
           (list 'poly ()))
          ((eql 'm (first (first poly))) 
           (append (list 'poly) 
                   (list poly)))
          ((eql 'expt (first (first poly))) 
           (list 'poly (list (as-monomial poly))))))))

(defun as-polynomial2 (poly)
  (cond ((null poly) nil)
        (t (append (list (as-monomial (first poly))) 
                   (as-polynomial2 (rest poly))))))



(defun compress2 (var)
  (cond ((null var) nil)
        ((eql (third (first var)) (third (second var))) 
         (compress-mono 
          (append 
           (list 
            (list 'v (+ (second (first var)) 
                        (second (second var)))
                  (third (first var)))) 
           (rest (rest var)))))
        (t (append 
            (list 
             (list 'v (second (first var)) (third (first var))))   
            (compress-mono (rest var))))))
  
  
  

(defun compress-poly (poly)
  (ordina-poly 
   (deletezero 
    (cond ((null poly) nil)
          (t (deletezero 
              (list 'poly 
                    (compress-poly2 (second poly)))))))))


  
(defun compress-poly2 (poly)
  (cond ((null poly) nil)
        ((and (equal (fourth (first poly)) 
                     (fourth (second poly))) 
              (not (null (cdr poly)))) 
         (compress-poly2 
          (append (list (list 'm 
                              (+ (second (first poly)) 
                                 (second (second poly))) 
                              (third (first poly)) 
                              (fourth (first poly)))) 
                  (cdr (cdr poly)))))
        (t (append (list (first poly)) 
                   (compress-poly2 (rest poly))))))


(defun riconosci (exp)
  (cond ((null exp) nil)
        ((or (numberp exp) 
             (symbolp exp)) (as-polynomial exp))
        ((eql 'poly (first exp)) exp)
        ((or (numberp (first exp)) 
             (symbolp (first exp))) (as-polynomial exp))
        ((eql 'expt (first exp)) (as-polynomial exp))
        ((or (eql '* (first exp)) 
             (eql '+ (first exp))) (as-polynomial exp)) 
        ((eql 'm (first (first exp))) (as-polynomial exp))))

(defun deletezero (poly)
  (list 'poly (cond ((null poly) nil)
                    (t (deletezero2 (second poly))))))

(defun deletezero2 (poly)
  (cond ((null poly) nil)
        ((eq (second (first poly)) 0) 
         (deletezero2 (rest poly)))
        ((not (eq (second (first poly)) 0)) 
         (append (list (first poly)) 
                 (deletezero2 (rest poly))))))

(defun ordina-poly (poly)
  (list 'poly 
        (ordina-poly3 
         (sort 
          (ordina-poly2 (second poly)) 
          #'sortpoly :key #'fourth))))

(defun ordina-poly2 (poly)
  (cond ((null poly) nil)
        (t (append (list 
                    (copy-list 
                     (list 'm 
                           (second (first poly)) 
                           (third (first poly)) 
                           (compress-mono (fourth (first poly)))))) 
                   (ordina-poly2 (rest poly))))))
 
(defun ordina-poly3 (poly)
  (sort poly #'< :key #'third))

(defun sortpoly (var1 var2)
  (cond ((null var2) nil)
        ((null var1) t)
        ((eql (third (first var1)) (third (first var2))) 
         (cond ((> (second (first var1)) 
                   (second (first var2))) nil)
               ((< (second (first var1)) 
                   (second (first var2))) t)
               ((= (second (first var1)) 
                   (second (first var2))) 
                (sortpoly (rest var1) (rest var2)))))
        ((string< (third (first var1)) (third (first var2))) t)
        ((string< (third (first var2)) (third (first var1))) nil)))


;---------------------POLYPLUS----------------------------------------
(defun polyplus (poly1 poly2)
  (cond ((and (is-polynomial (riconosci poly1))
              (is-polynomial (riconosci poly2)))
         (cond ((or (null poly1) 
                    (null (second (riconosci poly1)))) 
                (riconosci poly2))
               ((or (null poly2) 
                    (null (second (riconosci poly2)))) 
                (riconosci poly1))
               (t (compress-poly 
                   (ordina-poly 
                    (list 'poly 
                          (append (second 
                                   (compress-poly (riconosci poly1))) 
                                  (second 
                                   (compress-poly 
                                    (riconosci poly2))))))))))
        (t (Error "Input errato"))))

;------------------POLYMINUS-----------------------------------------
(defun polyminus (poly1 poly2)
  (cond ((and (is-polynomial (riconosci poly1))
              (is-polynomial (riconosci poly2)))
         (compress-poly 
          (ordina-poly 
           (list 'poly 
                 (append (second 
                          (compress-poly (riconosci poly1))) 
                         (cambia-coefficiente 
                          (second 
                           (compress-poly 
                            (riconosci poly2)))))))))
        (t (Error "Input errato"))))



(defun cambia-coefficiente (poly)
  (cond ((null poly) nil)
        (t (append (list (list 'm 
                               (* (second (first poly)) 
                                  -1) 
                               (third (first poly)) 
                               (fourth (first poly)))) 
                   (cambia-coefficiente (rest poly))))))

;-------------------POLYTIMES-----------------------------------------
(defun polytimes (poly1 poly2)
  (cond ((and (is-polynomial (riconosci poly1))
              (is-polynomial (riconosci poly2)))
         (compress-poly 
          (ordina-poly
           (cond ((or (null (riconosci poly1)) 
                      (null (riconosci poly2))) (list 'poly ()))
                 (t 
                  (list 'poly 
                        (compress-times 
                         (polymoltiplicazione (second 
                                               (riconosci poly1)) 
                                              (second 
                                               (riconosci poly2))))))))))
        (t (Error "Input errato"))))



(defun polymoltiplicazione (poly1 poly2)
  (cond ((or (null poly1)
             (null poly2)) nil)
        (t (append 
            (append 
             (list (list 'm 
                         (* (second (first poly1)) 
                            (second (first poly2))) 
                         (+ (third (first poly1)) 
                            (third (first poly2))) 
                         (append (fourth (first poly1)) 
                                 (fourth (first poly2))))) 
             (polymoltiplicazione (list (first poly1)) (rest poly2))) 
            (polymoltiplicazione (rest poly1) poly2)))))

(defun compress-times (monomi)
  (cond ((null monomi) nil)
        (t (append (list 
                    (list 'm 
                          (second (first monomi)) 
                          (third (first monomi)) 
                          (compress-mono (fourth (first monomi)))))
                   (compress-times (rest monomi))))))


;-------------------------POLYVAL------------------------------------
(defun polyval (poly var)
  (cond ((is-polynomial (riconosci poly))
         (cond ((or (null poly) (null (second (riconosci poly)))) 0)
               (t (+ (* (second (first (second (riconosci poly)))) 
                        (confronta (fourth 
                                    (first (second (riconosci poly)))) 
                                   (pairlis1 
                                    (variables (riconosci poly)) var)))
                     (polyval2 (rest 
                                (second (riconosci poly))) 
                               (pairlis1 
                                (variables (riconosci poly)) var))))))
        (t (Error "Input errato"))))


(defun polyval2 (poly var)
  (cond ((null poly) 0)
        (t (+ (* (second(first poly))
                 (confronta (fourth (first poly)) var))
              (polyval2 (rest poly) var)))))

(defun pairlis1 (variabili valori)
  (cond ((null variabili) nil)
        (t (append (list (list (first variabili) (first valori))) 
                   (pairlis1 (rest variabili) (rest valori))))))

(defun confronta (vps listapairlis)
  (cond ((and (null vps) (null listapairlis)) 1)
        ((null vps) 1)
        ((eql (third (first vps)) (first (first listapairlis))) 
         (* (expt (second (first listapairlis))(second (first vps)))
            (confronta (rest vps) (rest listapairlis))))
        ((not (eql (third (first vps)) (first (first listapairlis))))
         (* (confronta vps (rest listapairlis))
            (confronta (rest vps) (list (first listapairlis)))))))
                                                                                                              


;-----------------PPRINT-POLYNOMIAL---------------------------------
(defun pprint-polynomial (poly)
  (cond ((is-polynomial (riconosci poly))
         (cond ((null poly) nil)
               ((null (fourth (first (second (riconosci poly))))) 
                (princ (second (first (second (riconosci poly)))))
                (princ " ")
                (pprint-polynomial2 
                 (rest (second (riconosci poly)))))
               ((eq (second (first (second (riconosci poly)))) -1)
                (princ "- ")
                (scomponi-lista 
                 (fourth (first (second (riconosci poly)))))
                (pprint-polynomial2 
                 (rest (second (riconosci poly)))))
               ((eq (second (first (second (riconosci poly)))) 1) 
                (scomponi-lista 
                 (fourth (first (second (riconosci poly)))))
                (pprint-polynomial2 
                 (rest (second (riconosci poly)))))
               (t (princ 
                   (second (first (second (riconosci poly))))) 
                  (princ " ") 
                  (scomponi-lista 
                   (fourth (first (second (riconosci poly))))) 
                  (pprint-polynomial2 
                   (rest (second (riconosci poly)))))))
        (t (Error "Input errato"))))
         

(defun pprint-polynomial2 (poly)
  (cond ((null poly) nil)
        ((null  (fourth (first poly))) 
         (princ " + ") 
         (princ (second (first poly)))  
         (pprint-polynomial2 (rest poly)))
        ((eq (second (first poly)) 1)
         (princ "+ ")
         (scomponi-lista (fourth (first poly))) 
         (pprint-polynomial2 (rest poly)))
        ((eq (second (first poly)) -1) 
         (princ "- ") 
         (scomponi-lista (fourth (first poly))) 
         (pprint-polynomial2 (rest poly)))
        ((< (second (first poly)) 0) 
         (princ "- ") 
         (princ (* (second (first poly)) 
                   (- 1))) 
         (princ " ") 
         (scomponi-lista (fourth (first poly))) 
         (pprint-polynomial2 (rest poly)))
        (t (princ "+ ")
           (princ (second (first poly))) 
           (princ " ")  
           (scomponi-lista (fourth (first poly))) 
           (pprint-polynomial2 (rest poly)))))
 

(defun scomponi-lista (var)
  (cond ((null var) nil)
        ((eq (second (first var)) 0)  
         (princ 1) 
         (princ " ") 
         (scomponi-lista (rest var)))
        ((eq (second (first var)) 1)  
         (princ (third (first var))) 
         (princ " ") 
         (scomponi-lista (rest var)))
        (t (princ (third (first var))) 
           (princ '^)  
           (princ (second (first var))) 
           (princ " ") 
           (scomponi-lista (rest var)))))
