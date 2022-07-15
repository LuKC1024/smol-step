#lang racket
(provide (rename-out [my-module-begin #%module-begin])
         (rename-out [my-top-interaction #%top-interaction]))

(require "../../s-exp-of-state.rkt")
(require "../../pict-of-state.rkt")
(require "../../parse.rkt")
(require "../../runtime.rkt")

(define (my-pict-of-state state)
  (define hide-closure? #t)
  (define hide-env-label? #t)
  (define hide-fun-addr? #t)
  (define defvar-lambda-as-deffun? #t)
  (define set!-lambda-as-def? #t)
  (define set!-other-as-def? #t)
  ((pict-of-state hide-closure? hide-env-label?)
   ((s-exp-of-state hide-fun-addr? defvar-lambda-as-deffun? set!-lambda-as-def? set!-other-as-def?) state)))

(define (run tracing? e)
  (define check void)
  (eval tracing? check my-pict-of-state (parse e)))

(define-syntax (my-module-begin stx)
  (syntax-case stx ()
    [(_ #:no-trace form ...)
     #'(#%module-begin (run #f '(form ...)))]
    [(_ form ...)
     #'(#%module-begin (run #t '(form ...)))]))

(define-syntax (my-top-interaction stx)
  (syntax-case stx ()
    [(_ . form)
     #'(#%top-interaction . (displayln "Please run programs in the editor window."))]))