; From chapter 1
(define +1 (x) (+ x 1))
(define <= (x y) (or (< x y) (= x y)))
; Section 3.1,3
(define fac (n) (*/ (indx n)))
(fac 4)
24
(define avg (v) (/ (+/ v) (shape v)))
(avg '(2 4 6))
4
(define neg (v) (- 0 v))
(neg '(3 -5 -8))
'(-3 5 8)
(define min (v1 v2) (neg (max (neg v1) (neg v2))))
(min 4 8)
4
(min '(2 4 6 8) '(5 3 7 4))
'(2 3 6 4)
(define min/ (v) (neg (max/ (neg v))))
(min/ '(5 3 7 4))
3
(define mod (m n) (- m (* n (/ m n))))
(mod '(2 5 8 11) '(1 2 3 4))
'(0 1 2 3)
(mod 10 '(2 5 8 11))
'(0 0 2 10)
(define even? (n) (= (mod n 2) 0))
(even? '(1 2 3 4 5))
'(0 1 0 1 0)
(define even-sum (v) (+/ (compress (even? v) v)))
(even-sum '(1 2 3 4 5))
6
(define not= (x y) (if (= x y) 0 1))
(not= 3 5)
1
(not= '(1 3 5) '(1 4 8))
0
(define not (x) (- 1 x))
(define <> (x y) (not (= x y)))
(<> '(1 3 5) '(1 4 8))
'(0 1 1)
(define reverse (a)
        (begin
         (set size ([] (shape a) 1))
                 ([] a (+1 (- size (indx size))))))
(set m (restruct '(4 4) '(1 1 0 0 0)))
   '(1   1   0   0)
   '(0   1   1   0)
   '(0   0   1   1)
   '(0   0   0   1)
(reverse m)
   '(0   0   0   1)
   '(0   0   1   1)
   '(0   1   1   0)
   '(1   1   0   0)
(define reverse (a)
           ([] a (+1 (- (set size ([] (shape a) 1)) (indx size)))))
(reverse m)
   '(0   0   0   1)
   '(0   0   1   1)
   '(0   1   1   0)
   '(1   1   0   0)
(define signum (x) (+ (* (< x 0) -1)(> x 0)))
(define abs (x) (* x (signum x)))
(define find (x v) ([] (compress (= x v) (indx (shape v))) 1))
(find 3 '(1 4 7 3 9 2))
4
(define find-closest (x v)
      (begin
           (set absdiffs (abs (- v x)))
           (find (min/ absdiffs) absdiffs)))
(find-closest 10 '(8 11 4 13 7))
2
(define sqr (x) (* x x))
(define variance (v) (/ (+/ (sqr (- v (avg v)))) (shape v)))
(variance '(5 10 15 20))
31
(define binom (n)
     (begin (set l '(1))
              (print l)
              (while (< (shape l) n)
                    (begin
                          (set l (+ (cat 0 l)(cat l 0)))
                          (print l)))))
(define prime (n)
        (and/ (<> 0 (mod n (+1 (indx (- n 2)))))))
(define dropend (v) ([] v (indx (- (shape v) 1))))
(define +\ (v)
         (if (= (shape v) 0) v
               (cat (+\ (dropend v)) (+/ v))))
(+\ '(1 3 5 7))
'(1   4   9   16)
;; (define assign (v i x)
;;       (cat ([] v (indx (- i 1)))
;;            (cat x ([] v (+ i (indx (- (shape v) i)))))))
;; (assign '(1 2 3 4 5) 3 6)
;; '(1 2 6 4 5)
;; (define drop1 (v) ([] v (+1 (indx (- (shape v) 1)))))
;; (define vecassign (v i x)
;;       (if (= (shape i) 0) v
;;              (vecassign (assign v ([] i 1)([] x 1))
;;                        (drop1 i) (drop1 x))))
;; (vecassign '(10 20 30 40 50) '(3 5 1) '(7 9 11))
;; '(11 20 7 40 9)
;; (define fillzeros (v)
;;        (vecassign (restruct (+/ (+ v 1)) 0)
;;                     (+\ (+ v 1))
;;                     (restruct (shape v) 1)))
;; (fillzeros '(2 0 3 1))
'(0 0 1 1 0 0 0 1 0 1)
(define mod-outer-prod (v1 v2)
         (mod (trans (restruct (cat (shape v2)(shape v1)) v1))
             (restruct (cat (shape v1) (shape v2)) v2)))
(mod-outer-prod (indx 4) (indx 7))
'(0 1 1 1 1 1 1)
'(0 0 2 2 2 2 2)
'(0 1 0 3 3 3 3)
'(0 0 1 0 4 4 4)
(define primes<= (n)
    (compress (= 2 (+/ (= 0 (mod-outer-prod (set s (indx n)) s))))
              s))
(primes<= 7)
'(2 3 5 7)
; Section 3.3??
(define dup-cols (v n)
    (trans (restruct (cat n (shape v)) v)))
(define dup-rows (v n)
    ([] (restruct (cat 1 (shape v)) v) (restruct n 1)))
(define freqvec (scores lo hi)
     (begin
          (set width (+ (- hi lo) 1))
          (+/ (trans (=
                (dup-cols scores width)
                (dup-rows (+ (indx width) (- lo 1)) (shape scores)))))))
(define cumfreqvec (freqs) (+\ freqs))
(define range (scores) (cat (min/ scores) (max/ scores)))
(define mode (freqs lo) (+ (find (max/ freqs) freqs) (- lo 1)))
(define median (cumfreqs lo)
           (+ (- lo 1) (find-closest (max/ cumfreqs) (* 2 cumfreqs))))
(define addelt (e i v)
    (cat ([] v (indx (- i 1)))
         (cat e ([] v (+ (indx (- (+1 (shape v)) i)) (- i 1))))))
(define addrow (v i m)
    ([] (restruct (+ '(1 0) (shape m)) (cat v m))
          (addelt 1 i (+1 (indx ([] (shape m) 1))))))
(define addcol (v i m)
    (trans (addrow v i (trans m))))
(define histo (freqs lo hi)
    (begin
         (set width (+1 (- hi lo)))
         (set length (max/ freqs))
         (set hist
             (<=   (restruct (cat width length) (indx length))
                 (dup-cols freqs length)))
         (addcol (- (indx width) (- 1 lo)) 1 hist)))
(define graph (freqs lo)
   (begin
       (set length (max/ freqs))
       (set lines (restruct (cat (+ length 1) length)
                                  (cat (restruct length 0) 1)))
       (set thegraph (reverse (trans ([] lines (+ freqs 1)))))
       (addrow (- (indx (shape freqs)) (- 1 lo)) (+ length 1) thegraph)))
(set SCORES '(-2 1 -1 0 0 2 1 1))
;; (set FREQS (freqvec SCORES -2 2))
;; '(1 1 2 3 1)
;; (set CUMFREQS (cumfreqvec FREQS))
;; '(1 2 4 7 8)
;; (range SCORES)
;; '(-2 2)
;; (mode FREQS -2)
;; 1
;; (median CUMFREQS -2)
;; 0
;; (histo FREQS -2 2)
;; '(-2 1 0 0)
;; '(-1 1 0 0)
;; '(0 1 1 0)
;; '(1 1 1 1)
;; '(2 1 0 0)
;; (graph FREQS -2)
;; '(0 0 0 1 0)
;; '(0 0 1 0 0)
;; '(1 1 0 0 1)
;; '(-2 -1 0 1 2)
;; (graph CUMFREQS -2)
;; '(0 0 0 0 1)
;; '(0 0 0 1 0)
;; '(0 0 0 0 0)
;; '(0 0 0 0 0)
;; '(0 0 1 0 0)
;; '(0 0 0 0 0)
;; '(0 1 0 0 0)
;; '(1 0 0 0 0)
;; '(-2 -1 0 1 2)
quit
