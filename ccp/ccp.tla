Coffee Can Puzzle (Black and White Beans)

    Difficulty: Medium
    Example solution: https://en.wikipedia.org/wiki/Coffee_can_problem
    Type: Puzzle

 A coffee can contains some black beans and white beans. The following process is to be repeated as long as possible:

Randomly select two beans from the can. If they are the same color, throw them out, but put another black bean in. 
    (Enough extra black beans are available to do this.) If they are different colors, place the white one back into the can and throw the black one away.

Execution of this process reduces the number of beans in the can by one. Repetition of this process must terminate with exactly one bean in the can, 
    for then two beans cannot be selected. The question is: what, if anything, can be said about the color of the final bean based on the number of white beans and the number of black beans initially in the can?


Explore next: Prove invariants and simulate outcomes for random initial counts. 

---- MODULE ccp ----
EXTENDS TLC, Integers

(*--algorithm ccp
    variables
        NbWhiteBean = 43;
        NbBlackBean = 90;
        
        
        NbInitialWhiteBean = NbWhiteBean;
 
    define
        BeansLeft == 
            /\ NbWhiteBean > 0
            /\ NbBlackBean > 0
            
        OneBeanLeft == 
            /\ NbWhiteBean + NbBlackBean = 1
            
        InvariantParite == NbWhiteBean % 2 = NbInitialWhiteBean % 2
        
        ConclusionPuzzle == 
            <>[](OneBeanLeft =>
                (NbInitialWhiteBean % 2 = 0 => NbWhiteBean = 0) /\ 
                (NbInitialWhiteBean % 2 = 1 => NbWhiteBean = 1))
    end define;
    
    begin
        PICK_BEAN:
            if NbWhiteBean + NbBlackBean > 1 then
                either 
                    when NbBlackBean >= 2;
                    \* Meme couleur noir
                    NbBlackBean := NbBlackBean - 1;
                    
                or 
                    when NbWhiteBean >= 2;
                    \* Meme couleur blanche
                    NbBlackBean := NbBlackBean + 1;
                    NbWhiteBean := NbWhiteBean - 2;
                    
                or 
                    when NbWhiteBean > 0 /\ NbBlackBean > 0;
                    \* Couleurs differentes
                    NbBlackBean := NbBlackBean - 1;
                
                end either;
            
                goto PICK_BEAN; 
            end if;

end algorithm;
*)
\* BEGIN TRANSLATION (chksum(pcal) = "2d25f1b1" /\ chksum(tla) = "140dfc21")
VARIABLES NbWhiteBean, NbBlackBean, NbInitialWhiteBean, pc

(* define statement *)
BeansLeft ==
    /\ NbWhiteBean > 0
    /\ NbBlackBean > 0

OneBeanLeft ==
    /\ NbWhiteBean + NbBlackBean = 1

InvariantParite == NbWhiteBean % 2 = NbInitialWhiteBean % 2

ConclusionPuzzle ==
    <>[](OneBeanLeft =>
        (NbInitialWhiteBean % 2 = 0 => NbWhiteBean = 0) /\
        (NbInitialWhiteBean % 2 = 1 => NbWhiteBean = 1))


vars == << NbWhiteBean, NbBlackBean, NbInitialWhiteBean, pc >>

Init == (* Global variables *)
        /\ NbWhiteBean = 43
        /\ NbBlackBean = 90
        /\ NbInitialWhiteBean = NbWhiteBean
        /\ pc = "PICK_BEAN"

PICK_BEAN == /\ pc = "PICK_BEAN"
             /\ IF NbWhiteBean + NbBlackBean > 1
                   THEN /\ \/ /\ NbBlackBean >= 2
                              /\ NbBlackBean' = NbBlackBean - 1
                              /\ UNCHANGED NbWhiteBean
                           \/ /\ NbWhiteBean >= 2
                              /\ NbBlackBean' = NbBlackBean + 1
                              /\ NbWhiteBean' = NbWhiteBean - 2
                           \/ /\ NbWhiteBean > 0 /\ NbBlackBean > 0
                              /\ NbBlackBean' = NbBlackBean - 1
                              /\ UNCHANGED NbWhiteBean
                        /\ pc' = "PICK_BEAN"
                   ELSE /\ pc' = "Done"
                        /\ UNCHANGED << NbWhiteBean, NbBlackBean >>
             /\ UNCHANGED NbInitialWhiteBean

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == PICK_BEAN
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 
====
