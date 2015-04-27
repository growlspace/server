#lang racket

(require json
         net/url
         web-server/dispatch
         web-server/http
         web-server/http/request-structs
         web-server/http/bindings)

(define-values (api-dispatch api-url)
  (dispatch-rules
   [("login") #:method "post" login-user]
   [("feed") view-feed]
   [("item" (integer-arg)) view-item]
   [("item") #:method "post" create-item]
   [("user" (string-arg)) view-user] 
   [("user") #:method "post" create-user]
   [else dbug]))

(define (login-user req)
  (let ([raw-post-data (request-post-data/raw req)])
    (if (bytes? raw-post-data)
      (with-handlers ([exn:fail? (λ (e) (format "~s" e))])
        (let ([post-jsexpr (bytes->jsexpr raw-post-data)])
          (if (hash? post-jsexpr)
            (or (and (hash-has-key? post-jsexpr 'username)
                     (hash-has-key? post-jsexpr 'password)
                     (jsexpr->string "ok"))
                     ;`(username: ,(hash-ref post-jsexpr 'username)
                     ;  passwd: ,(hash-ref post-jsexpr 'password)))
                `(missing fields))
            `(invalid json format))))
      `(not bytes))))

;; login required
(define (view-feed req)
  `(view-feed))

;; login required
(define (view-item req id)
  `(view-item ,id))

;; login required
(define (create-item req)
  `(create-item))

;; login required
(define (view-user req username)
  `(view-user ,username))

(define (create-user req)
  `(create-user))

(define (not-found req)
  `(not-found))

(define (dbug req)
  `(,(bytes->string/utf-8 (request-method req))
    ,(cond ((bytes? (request-post-data/raw req))
            (bytes->string/utf-8 (request-post-data/raw req)))
           (else "No request body"))))

(define root-api-uri (string->url "https://api.growl.space/v1"))

(define (url->get u)
  (make-request #"GET" (combine-url/relative root-api-uri u) empty
                (delay empty) #f "1.2.3.4" 80 "4.3.2.1"))

(define (url->post u body)
  (make-request #"POST" (combine-url/relative root-api-uri u) empty
                (delay empty) (string->bytes/utf-8 body)
                "1.2.3.4" 80 "4.3.2.1"))

(define (test-proper-login u p)
  (api-dispatch 
   (url->post "/login" (jsexpr->string (hasheqv 'username u 'password p)))))