Cabbage, Goat, and Wolf

    Difficulty: Easy
    Example solution: https://muratbuffalo.blogspot.com/2023/10/cabbage-goat-and-wolf-puzzle-in-tla.html
    Type: Puzzle

A farmer with a wolf, a goat, and a cabbage must cross a river by boat. The boat can carry only the farmer and a single item. If left unattended together, the wolf would eat the goat, or the goat would eat the cabbage. How can they cross the river without anything being eaten?

---- MODULE cgw ----
EXTENDS Integers, Sequences, TLC, FiniteSets
(*--algorithm cgw
    
    variables
        FARMER = "FARMER";
        WOLF = "WOLF";
        GOAT = "GOAT";
        CABBAGE = "CABBAGE";
        LeftSide = {FARMER, WOLF, GOAT, CABBAGE};
        RightSide = {};
        BoatStartPos = TRUE;
        
    define
        GoatNotAloneWithWolf ==
            /\ (FARMER \notin LeftSide => ~({WOLF, GOAT} \subseteq LeftSide))
            /\ (FARMER \notin RightSide => ~({WOLF, GOAT} \subseteq RightSide))
        GoatNotAloneWithCabbage ==
            /\ (FARMER \notin LeftSide => ~({CABBAGE, GOAT} \subseteq LeftSide))
            /\ (FARMER \notin RightSide => ~({CABBAGE, GOAT} \subseteq RightSide))
        
        Coherent(A) == (A \in LeftSide /\ A \notin RightSide) \/ (A \in RightSide /\ A \notin LeftSide)
            
        NotIncoherent == 
            /\ Coherent(FARMER)
            /\ Coherent(WOLF)
            /\ Coherent(GOAT)
            /\ Coherent(CABBAGE)
 
        AllCrossed ==
            /\ (Cardinality(LeftSide) = 0)
            /\ (Cardinality(RightSide) = 4)
            /\ (FARMER \in RightSide /\ WOLF \in RightSide /\ GOAT \in RightSide /\ CABBAGE \in RightSide)
                
        IsValid ==
            /\ GoatNotAloneWithWolf
            /\ GoatNotAloneWithCabbage
            /\ NotIncoherent
    end define;
    
    begin
        CROSS:
        
            if BoatStartPos then
                with item \in LeftSide do
                     if item = GOAT then
                         LeftSide := LeftSide \ {GOAT, FARMER};
                         RightSide := RightSide \union {GOAT, FARMER};
                     elsif item = WOLF then
                        when ~({GOAT, CABBAGE} \subseteq LeftSide);
                         LeftSide := LeftSide \ {WOLF, FARMER};
                         RightSide := RightSide \union {WOLF, FARMER};
                     elsif item = CABBAGE then
                        when ~({GOAT, WOLF} \subseteq LeftSide);
                         LeftSide := LeftSide \ {CABBAGE, FARMER};
                         RightSide := RightSide \union {CABBAGE, FARMER};
                     end if;
                end with;
                BoatStartPos := FALSE;
            else
                with item \in RightSide do
                     if item = GOAT then
                         RightSide := RightSide \ {GOAT, FARMER};
                         LeftSide := LeftSide \union {GOAT, FARMER};
                     elsif item = WOLF then
                        when ~({GOAT, CABBAGE} \subseteq RightSide);
                         RightSide := RightSide \ {WOLF, FARMER};
                         LeftSide := LeftSide \union {WOLF, FARMER};
                     elsif item = CABBAGE then
                        when ~({GOAT, WOLF} \subseteq RightSide);
                         RightSide := RightSide \ {CABBAGE, FARMER};
                         LeftSide := LeftSide \union {CABBAGE, FARMER};
                     end if;
                end with;
                BoatStartPos := TRUE;
        
            end if;
            
            goto CROSS;
end algorithm;
*)
\* BEGIN TRANSLATION (chksum(pcal) = "431adebc" /\ chksum(tla) = "a67b8cd3")
VARIABLES FARMER, WOLF, GOAT, CABBAGE, LeftSide, RightSide, BoatStartPos, pc

(* define statement *)
GoatNotAloneWithWolf ==
    /\ (FARMER \notin LeftSide => ~({WOLF, GOAT} \subseteq LeftSide))
    /\ (FARMER \notin RightSide => ~({WOLF, GOAT} \subseteq RightSide))
GoatNotAloneWithCabbage ==
    /\ (FARMER \notin LeftSide => ~({CABBAGE, GOAT} \subseteq LeftSide))
    /\ (FARMER \notin RightSide => ~({CABBAGE, GOAT} \subseteq RightSide))

Coherent(A) == (A \in LeftSide /\ A \notin RightSide) \/ (A \in RightSide /\ A \notin LeftSide)

NotIncoherent ==
    /\ Coherent(FARMER)
    /\ Coherent(WOLF)
    /\ Coherent(GOAT)
    /\ Coherent(CABBAGE)

AllCrossed ==
    /\ (Cardinality(LeftSide) = 0)
    /\ (Cardinality(RightSide) = 4)
    /\ (FARMER \in RightSide /\ WOLF \in RightSide /\ GOAT \in RightSide /\ CABBAGE \in RightSide)

IsValid ==
    /\ GoatNotAloneWithWolf
    /\ GoatNotAloneWithCabbage
    /\ NotIncoherent


vars == << FARMER, WOLF, GOAT, CABBAGE, LeftSide, RightSide, BoatStartPos, pc
        >>

Init == (* Global variables *)
        /\ FARMER = "FARMER"
        /\ WOLF = "WOLF"
        /\ GOAT = "GOAT"
        /\ CABBAGE = "CABBAGE"
        /\ LeftSide = {FARMER, WOLF, GOAT, CABBAGE}
        /\ RightSide = {}
        /\ BoatStartPos = TRUE
        /\ pc = "CROSS"

CROSS == /\ pc = "CROSS"
         /\ IF BoatStartPos
               THEN /\ \E item \in LeftSide:
                         IF item = GOAT
                            THEN /\ LeftSide' = LeftSide \ {GOAT, FARMER}
                                 /\ RightSide' = (RightSide \union {GOAT, FARMER})
                            ELSE /\ IF item = WOLF
                                       THEN /\ ~({GOAT, CABBAGE} \subseteq LeftSide)
                                            /\ LeftSide' = LeftSide \ {WOLF, FARMER}
                                            /\ RightSide' = (RightSide \union {WOLF, FARMER})
                                       ELSE /\ IF item = CABBAGE
                                                  THEN /\ ~({GOAT, WOLF} \subseteq LeftSide)
                                                       /\ LeftSide' = LeftSide \ {CABBAGE, FARMER}
                                                       /\ RightSide' = (RightSide \union {CABBAGE, FARMER})
                                                  ELSE /\ TRUE
                                                       /\ UNCHANGED << LeftSide, 
                                                                       RightSide >>
                    /\ BoatStartPos' = FALSE
               ELSE /\ \E item \in RightSide:
                         IF item = GOAT
                            THEN /\ RightSide' = RightSide \ {GOAT, FARMER}
                                 /\ LeftSide' = (LeftSide \union {GOAT, FARMER})
                            ELSE /\ IF item = WOLF
                                       THEN /\ ~({GOAT, CABBAGE} \subseteq RightSide)
                                            /\ RightSide' = RightSide \ {WOLF, FARMER}
                                            /\ LeftSide' = (LeftSide \union {WOLF, FARMER})
                                       ELSE /\ IF item = CABBAGE
                                                  THEN /\ ~({GOAT, WOLF} \subseteq RightSide)
                                                       /\ RightSide' = RightSide \ {CABBAGE, FARMER}
                                                       /\ LeftSide' = (LeftSide \union {CABBAGE, FARMER})
                                                  ELSE /\ TRUE
                                                       /\ UNCHANGED << LeftSide, 
                                                                       RightSide >>
                    /\ BoatStartPos' = TRUE
         /\ pc' = "CROSS"
         /\ UNCHANGED << FARMER, WOLF, GOAT, CABBAGE >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == CROSS
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 
====
