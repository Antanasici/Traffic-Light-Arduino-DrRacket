#lang racket
; Traffic Light project. 
; Run through the sequence of states for a triple traffic light and pedastrian crossing if the button is pressed.
; Sensor to check if the RED light on the 3rd traffic light ( X ) is HIGH ( on ), and if the movment is detected flash a white light ( Penalty for crossing on the red light ).
; 7-Segment display on the pedastrian crossing after the green light finishes. ( The Green should stay on, till the timer runs 9-1 and then switch to Red).
; Requests for racket library.
; States will be represented by an iteger.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Call for asip.
(require "AsipMain.rkt" "AsipButtons.rkt")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;Definitions 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define lights (list 22 23 24  25 26 27  28 29 30  32 31)) ; pin's that are used for LED's (Color coding: Red, Amber, Green | Red, Amber, Green | Red, Amber, Green |2x Green, Red 2x)
(define emergency-button-pin 33) ; Pedastrian crossing button pin.
(define segmentled (list 53 52 51 50 49 48 47)) ;pins that are used for 7 segment display.
(define oldTime 0) ;  Definition of time for an old time. (Keep value).
(define smallOldTime 0) ; Definition of time for an smalloldtime ( Keep value).
(define currentState 1) ; Definition of name to store the current state, and set the initial state to 1.
(define rled 36) ; Double wire pin for third road pin that used to check light state for sensor.
(define led 35) ; Sensor flash display led.
(define bpp 0) ; Stores the button click to memmory.
(define sp 1) ; Sleep value for delaying the transaction of number changing in 7-Segment display.
(define normsp 2) ; Defines a duration of red and green states. (secs).
(define ambersp 0.4) ; Defines a durationot og amber and amber + red. (secs).
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;Function for preparing the board to run the program.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define setup 
  (λ ()
    (open-asip)  
    (map (λ (x) (set-pin-mode  x  OUTPUT_MODE)) lights) 
    (map (λ (x) (set-pin-mode  x  OUTPUT_MODE)) segmentled) 
    (map (λ (x) (digital-write x LOW)) lights) 
    (set-pin-mode! emergency-button-pin INPUT_MODE) 
    (sleep 0.1)  
    (enableDistance 100) 
    (sleep 0.1) 
    ) 
  ) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Definitions of 7-Segment display numbers. (Lazy version... Someone wants to redo to lists?
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define n1
  (λ ()
    (digital-write 53 HIGH)
    (digital-write 47 HIGH)
    )
  )
(define n2
  (λ ()
    (digital-write 51 HIGH)
    (digital-write 53 HIGH)
    (digital-write 50 HIGH)
    (digital-write 49 HIGH)
    (digital-write 48 HIGH)
    )
  )
(define n3
  (λ ()
    (digital-write 51 HIGH)
    (digital-write 53 HIGH)
    (digital-write 50 HIGH)
    (digital-write 48 HIGH)
    (digital-write 47 HIGH)
    )
  )
(define n4
  (λ  ()
    (digital-write 52 HIGH)
    (digital-write 50 HIGH)
    (digital-write 53 HIGH)
    (digital-write 47 HIGH)
    )
  )
(define n5
  (λ ()
    (digital-write 51 HIGH)
    (digital-write 52 HIGH)
    (digital-write 50 HIGH)
    (digital-write 47 HIGH)
    (digital-write 48 HIGH)
    )
  )
(define n6
  (λ ()
    (digital-write 51 HIGH)
    (digital-write 52 HIGH)
    (digital-write 50 HIGH)
    (digital-write 47 HIGH)
    (digital-write 48 HIGH)
    (digital-write 49 HIGH)
    )
  )
(define n7
  (λ ()
    (digital-write 51 HIGH)
    (digital-write 53 HIGH)
    (digital-write 47 HIGH)
    )
  )
(define n8
  (λ ()
    (digital-write 53 HIGH)
    (digital-write 52 HIGH)
    (digital-write 51 HIGH)
    (digital-write 50 HIGH)
    (digital-write 49 HIGH)
    (digital-write 48 HIGH)
    (digital-write 47 HIGH)
    )
  )
(define n9
  (λ ()
    (digital-write 53 HIGH)
    (digital-write 52 HIGH)
    (digital-write 51 HIGH)
    (digital-write 50 HIGH)
    (digital-write 48 HIGH)
    (digital-write 47 HIGH)
    )
  )
(define clear-it
  (λ ()
    (digital-write 53 LOW) 
    (digital-write 52 LOW) 
    (digital-write 51 LOW) 
    (digital-write 50 LOW) 
    (digital-write 49 LOW) 
    (digital-write 48 LOW) 
    (digital-write 47 LOW) 
    )
  )
;Functions that calls function of number, sets the display of the number, and clears it before displaying a second one. 
(define run-the-clock
  (λ ()
    (clear-it) 
    (n9) 
    (sleep sp)
    (clear-it) 
    (n8) 
    (sleep sp) 
    (clear-it)
    (n7)
    (sleep sp)
    (clear-it)
    (n6)
    (sleep sp)
    (clear-it)
    (n5)
    (sleep sp)
    (clear-it)
    (n4)
    (sleep sp)
    (clear-it)
    (n3)
    (sleep sp)
    (clear-it)
    (n2)
    (sleep sp)
    (clear-it)
    (n1)
    (sleep sp)
   
    )
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; States 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; State Transition Table (FSM I suppose ? )
; for this case, trasaction ( key ) is mapped to value.Change of state is cuased by sequence in other function gotoNextState. ( value "b" )
; transaction at to pedastiran caused by function gotoNextState with value "e".
; Take note that the it goes in order, if function gotoNextState with "b" value is called in state 2 it changes to 2. But otherwise "e" changes to state 13. ( All red, pedastrian green)
;But in main function I finish all 12 sequence before checking if the button was pressed. That way, we finsh the sequence before chaning to pedastrian. This helps to fix insta transaction
;if pedastrian crossing button is clicked. ( For example Green on one -> Insta red on all ).
(define stateTable (hash 
                    1 (hash "b" 2 "e" 13 "a" 1 )
                    2 (hash "b" 3 "e" 13 "a" 1 )
                    3 (hash "b" 4 "e" 13 "a" 1 )
                    4 (hash "b" 5 "e" 13 "a" 1 )
                    5 (hash "b" 6 "e" 13 "a" 1 )
                    6 (hash "b" 7 "e" 13 "a" 1 )
                    7 (hash "b" 8 "e" 13 "a" 1 )
                    8 (hash "b" 9 "e" 13 "a" 1 ) 
                    9 (hash "b" 10 "e" 13 "a" 1 )
                    10 (hash "b" 11 "e" 13 "a" 1 )
                    11 (hash "b" 12 "e" 13 "a" 1 )
                    12 (hash "b" 1 "e" 13 "a" 1 )
                    13 (hash "b" 1 "e" 13 "a" 1 )
                    )
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; mapping and ordering of light ordering in particualar states 1-13.
; e.g. in state 1, all 3 trafficl lights are red including pedastrian.
; e.g. in state 2, 1st trafficl light changes red + amber, while all other are red.
; e.g. in state 13, all fraficl lights are red, while pedastrian is green.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 (define lightStates (hash
                     1 (list 1 0 0  1 0 0  1 0 0   0 1 ) ;  (1st - RED, 2nd - RED, 3rd - RED.) RED
                     2 (list 1 1 0  1 0 0  1 0 0    0 1) ;  (1st - RED + AMBER, 2nd - RED, 3rd - RED.) RED 
                     3 (list 0 0 1  1 0 0  1 0 0    0 1)  ; (1st - GREEN , 2nd - RED , 3rd - RED.)RED
                     4 (list 0 1 0  1 0 0  1 0 0    0 1)  ; (1st - AMBER, 2nd - RED , 3rd - RED.) RED 
                     5 (list 1 0 0  1 0 0  1 0 0    0 1)  ; (1st - RED, 2nd - RED  , 3rd - RED.) RED
                     6 (list 1 0 0  1 1 0  1 0 0    0 1)  ; (1st - RED, 2nd - RED + AMBER , 3rd - RED.)RED 
                     7 (list 1 0 0  0 0 1  1 0 0    0 1)  ; (1st - RED, 2nd - GREEN , 3rd - RED .)RED
                     8 (list 1 0 0  0 1 0  1 0 0    0 1)  ; (1st - RED, 2nd - AMBER , 3rd - RED.)RED 
                     9 (list 1 0 0  1 0 0  1 0 0    0 1)  ; (1st - RED , 2nd - RED , 3rd -RED .) RED              
                     10 (list 1 0 0  1 0 0  1 1 0   0 1)  ; (1st - RED, 2nd - RED , 3rd - AMBER.) RED 
                     11 (list 1 0 0  1 0 0  0 0 1   0 1 )  ; (1st - RED, 2nd - RED  , 3rd - GREEN .)RED
                     12 (list 1 0 0  1 0 0  0 1 0   0 1 ); (1st - RED, 2nd - RED , 3rd - AMBER.)RED 
                     13 (list 1 0 0  1 0 0  1 0 0  1 0  )  ; (1st - RED, 2nd - RED, 3rd - RED.)GREEN 
                     ))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Gets the value of state and even to check succsesor, priority.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define getNextState (lambda (state event) 
   (hash-ref (hash-ref stateTable state 0) event 0)
  ))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; SETTING TRAFFIC LIGHTS
; Takes the first item in the list of lights, to change there value. Aka on or off. 0/1 and so on
; and keeps doing to in recursive way to change all the lights acording to the sequence from the sequence table.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define setLights (lambda (lightPins vals)
                    (cond [(not (empty? lightPins))  
                           (cond [(equal? (first vals) 1) 
                                  (digital-write (first lightPins) HIGH) 
                                  ] 
                                 (else  
                                  (digital-write (first lightPins) LOW) 
                                  )
                                 )
                           (sleep 0.02)
                           (setLights (rest lightPins) (rest vals)) 
                           ]  
                          )
                    ) 
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; This is the sensor check function. ( Checks if the red light is on, and if there is a movment while it's on, flashes the white led ).
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define sensorcheckup
  (λ ()
(cond
                ((= (digital-read rled) 1)
                 (sleep 0.02)
                 (cond
                   ((and (> (getDistance) 0) (< (getDistance) 20)) 
                    (digital-write led HIGH)
                    (sleep 0.5)
                    (digital-write led LOW)
                    (sleep 0.5)
                    )
                   [else 0] 
                   )
                 )
                [else 0] 
                )
    )
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Conditional to check if the button was clicked and then set the memory value to 1. (Some sleeps to control the speed of upload on the ports.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define button-check
  (λ ()
    (cond
      ((= (digital-read 33) 1) 
       (sleep 0.2) 
       (set! bpp 1) 
       (sleep 0.2) 
       )
      [else 0] 
      )
    (sleep 0.2) 
    )
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Combine the functions to display lights according to state.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (outputCurrentState)
  (setLights lights (hash-ref lightStates currentState))
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; EXECUTION
; Change from the state that is displayed to the following one, which is determineted by ev. S
; Set lights based on new state.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define gotoNextState (lambda (ev)
  (let ([newState (getNextState currentState ev)]) 
    (cond [ (not (equal? newState 0))   
            (set! currentState newState) 
           (outputCurrentState)    
           ]) 
    )               
  ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Main function "run" that combines and runs other functions. To change states, set lights. Check if there is movment on X way, red light( Sensor ), Pedastrian button check
; 7-Segment display and a few more.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define run
  (λ ()
    (cond
      [ (> (- (current-milliseconds) oldTime) 1000) 
              (gotoNextState "b" )  
              (sleep 0.1)  
              (sensorcheckup) 
              (button-check) 
              (sleep 0.1) 
              (sleep ambersp) 
              (gotoNextState "b" )
              (sleep 0.1) 
              (sensorcheckup) 
              (button-check) 
              (sleep 0.1) 
              (sleep normsp) 
              (gotoNextState "b" ) 
              (sleep 0.1)  
              (sensorcheckup)
              (button-check) 
              (sleep 0.1) 
              (sleep ambersp) 
              (gotoNextState "b" )
              (sleep 0.1)  
              (sensorcheckup) 
              (button-check) 
              (sleep 0.1) 
              (sleep normsp)
              (gotoNextState "b" )
              (sleep 0.1)  
              (sensorcheckup) 
              (button-check)
              (sleep 0.1) 
              (sleep ambersp)
              (gotoNextState "b" )
              (sleep 0.1)  
              (sensorcheckup) 
              (button-check) 
              (sleep 0.1) 
              (sleep normsp)
              (gotoNextState "b" )
              (sleep 0.1)  
              (sensorcheckup) 
              (button-check) 
              (sleep 0.1) 
              (sleep ambersp)
              (gotoNextState "b" )
              (sleep 0.1)  
              (sensorcheckup) 
              (button-check) 
              (sleep 0.1) 
              (sleep normsp)
              (gotoNextState "b" )
              (sleep 0.1)  
              (sensorcheckup) 
              (button-check) 
              (sleep 0.1) 
              (sleep ambersp)
              (gotoNextState "b" )
              (sleep 0.1)  
              (sensorcheckup) 
              (button-check) 
              (sleep 0.1) 
              (sleep normsp)
              (gotoNextState "b" )
              (sleep 0.1)  
              (sensorcheckup) 
              (button-check) 
              (sleep 0.1) 
              (sleep ambersp)
              (gotoNextState "b" )
              (sleep 0.1)  
              (sensorcheckup) 
              (button-check) 
              (sleep 0.1) 
              (sleep normsp)   
              (set! oldTime (current-milliseconds)) 
            ]
          )
  (cond
    [ (> (- (current-milliseconds) smallOldTime) 500)
  
   ; Using diff aproach, not needed anymore.
   
              (set! smallOldTime (current-milliseconds))
            ]
            )
    ; Conditional in * group  to display  state for pedastrian crossing 
   (cond
     ((= bpp 1) 
       (gotoNextState "e")
       (sleep 0.2) 
       (set! bpp 0)
       (sleep 3) 
       (run-the-clock) 
       (clear-it) 
       (gotoNextState "b")) 
     [else 0]
   )
            (run) 
          )
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Start all the functions from here. Setup and then start the recursion of run.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setup)
(run)
