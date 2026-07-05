Die Hard Water Jugs

    Difficulty: Medium
    Example solution: https://en.wikipedia.org/wiki/Die_Hard_with_a_Vengeance#Water_jug_riddle
    Type: Puzzle

You have an m-gallon jug and an n-gallon jug with no markings, and a water source. Measure exactly k gallons using filling, emptying, and pouring between jugs. 
Determine when this is possible and provide a minimal-step procedure.

    Explore next: Use Bézout’s identity and graph search over jug states.

---- MODULE dhwj ----
EXTENDS TLC, Integers, Sequences
(*--algorithm dhwj
    variables
        k = 4;
        m = 3;
        n = 17;
        mJugFill = 0;
        nJugFill = 0;
        spaceLeft = 0;
        switch = 0;
    define
       Coherent ==
        /\ mJugFill <= m
        /\ nJugFill <= n
       
       Finished == mJugFill = k \/ nJugFill = k \/ nJugFill + mJugFill = k
        
       IsFull(jug, capacity) == jug = capacity
    end define;

    
    macro FillIn(jug1, jug1Cap, jug2, jug2Cap) begin
        if jug2 + jug1 > jug2Cap then
            spaceLeft := jug2Cap - jug2;
            jug1 := jug1 - spaceLeft;
            jug2 := jug2Cap;
        else
            jug2 := jug1 + jug2;
            jug1 := 0;
        end if;
    end macro;
    
    macro THROW(jug) begin
        jug := 0;
    end macro;
    
    
    macro FILL(jug, jubCapacity) begin
        jug := jubCapacity;
    end macro;
    
    process Solver = "solver"
    begin
        FILL:
            either
                FILL(nJugFill, n);
            or
                FillIn(nJugFill, n, mJugFill, m);
            or 
                THROW(nJugFill);
            or
                FILL(mJugFill, m);
            or
                FillIn(mJugFill, m, nJugFill, n);
            or
                THROW(mJugFill);
            end either;
            goto FILL;
    end process;
end algorithm;
*)
\* BEGIN TRANSLATION (chksum(pcal) = "65664350" /\ chksum(tla) = "d4c3001a")
VARIABLES k, m, n, mJugFill, nJugFill, spaceLeft, switch, pc

(* define statement *)
Coherent ==
 /\ mJugFill <= m
 /\ nJugFill <= n

Finished == mJugFill = k \/ nJugFill = k \/ nJugFill + mJugFill = k

IsFull(jug, capacity) == jug = capacity


vars == << k, m, n, mJugFill, nJugFill, spaceLeft, switch, pc >>

ProcSet == {"solver"}

Init == (* Global variables *)
        /\ k = 4
        /\ m = 3
        /\ n = 17
        /\ mJugFill = 0
        /\ nJugFill = 0
        /\ spaceLeft = 0
        /\ switch = 0
        /\ pc = [self \in ProcSet |-> "FILL"]

FILL == /\ pc["solver"] = "FILL"
        /\ \/ /\ nJugFill' = n
              /\ UNCHANGED <<mJugFill, spaceLeft>>
           \/ /\ IF mJugFill + nJugFill > m
                    THEN /\ spaceLeft' = m - mJugFill
                         /\ nJugFill' = nJugFill - spaceLeft'
                         /\ mJugFill' = m
                    ELSE /\ mJugFill' = nJugFill + mJugFill
                         /\ nJugFill' = 0
                         /\ UNCHANGED spaceLeft
           \/ /\ nJugFill' = 0
              /\ UNCHANGED <<mJugFill, spaceLeft>>
           \/ /\ mJugFill' = m
              /\ UNCHANGED <<nJugFill, spaceLeft>>
           \/ /\ IF nJugFill + mJugFill > n
                    THEN /\ spaceLeft' = n - nJugFill
                         /\ mJugFill' = mJugFill - spaceLeft'
                         /\ nJugFill' = n
                    ELSE /\ nJugFill' = mJugFill + nJugFill
                         /\ mJugFill' = 0
                         /\ UNCHANGED spaceLeft
           \/ /\ mJugFill' = 0
              /\ UNCHANGED <<nJugFill, spaceLeft>>
        /\ pc' = [pc EXCEPT !["solver"] = "FILL"]
        /\ UNCHANGED << k, m, n, switch >>

Solver == FILL

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == /\ \A self \in ProcSet: pc[self] = "Done"
               /\ UNCHANGED vars

Next == Solver
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(\A self \in ProcSet: pc[self] = "Done")

\* END TRANSLATION 
====
