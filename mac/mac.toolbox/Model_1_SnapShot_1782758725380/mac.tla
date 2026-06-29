---- MODULE mac ----
EXTENDS TLC, Integers

(*--algorithm mac
    variables
        NB_MISSIONARIES_START = 3,
        NB_CANNIBALS_START = 3,
        NB_CANNIBALS_END = 0,
        NB_MISSIONARIES_END = 0;
        BoatStartPos = TRUE;
    define
        NotNegative == 
            /\ NB_MISSIONARIES_START >= 0 
            /\ NB_MISSIONARIES_END >= 0 
            /\ NB_CANNIBALS_START >= 0 
            /\ NB_CANNIBALS_END >= 0 
        NotIncoherent == 
            /\ NB_MISSIONARIES_START + NB_MISSIONARIES_END  = 3
            /\ NB_CANNIBALS_START + NB_CANNIBALS_END  = 3
        NotOutnombered == 
            /\ (NB_MISSIONARIES_START = 0 \/ NB_MISSIONARIES_START >= NB_CANNIBALS_START)
            /\ (NB_MISSIONARIES_END = 0 \/ NB_MISSIONARIES_END >= NB_CANNIBALS_END)
        IsEnded == 
            /\ NB_MISSIONARIES_END = 3
            /\ NB_CANNIBALS_END = 3
        IsValid == 
            /\ NotNegative
            /\ NotIncoherent
            /\ NotOutnombered
        Min(a, b) == IF a < b THEN a ELSE b
    end define;
begin
    CROSS:
        if BoatStartPos then
            with x \in 0..Min(2, NB_MISSIONARIES_START), y \in 0..Min(2, NB_CANNIBALS_START) do
                when x + y >= 1 /\ x + y <= 2;
                    NB_MISSIONARIES_START := NB_MISSIONARIES_START - x;
                    NB_MISSIONARIES_END := NB_MISSIONARIES_END + x;
                    NB_CANNIBALS_START := NB_CANNIBALS_START - y;
                    NB_CANNIBALS_END := NB_CANNIBALS_END + y;
            end with;
            BoatStartPos := FALSE;
        else
            with x \in 0..Min(2, NB_MISSIONARIES_END), y \in 0..Min(2, NB_CANNIBALS_END) do
                when x + y >= 1 /\ x + y <= 2;
                    NB_MISSIONARIES_END := NB_MISSIONARIES_END - x;
                    NB_MISSIONARIES_START := NB_MISSIONARIES_START + x;
                    NB_CANNIBALS_END := NB_CANNIBALS_END - y;
                    NB_CANNIBALS_START := NB_CANNIBALS_START + y;
            end with;
            BoatStartPos := TRUE;
        end if;
        goto CROSS;
end algorithm;
*)
\* BEGIN TRANSLATION (chksum(pcal) = "7ba4783a" /\ chksum(tla) = "e9da2379")
VARIABLES NB_MISSIONARIES_START, NB_CANNIBALS_START, NB_CANNIBALS_END, 
          NB_MISSIONARIES_END, BoatStartPos, pc

(* define statement *)
NotNegative ==
    /\ NB_MISSIONARIES_START >= 0
    /\ NB_MISSIONARIES_END >= 0
    /\ NB_CANNIBALS_START >= 0
    /\ NB_CANNIBALS_END >= 0
NotIncoherent ==
    /\ NB_MISSIONARIES_START + NB_MISSIONARIES_END  = 3
    /\ NB_CANNIBALS_START + NB_CANNIBALS_END  = 3
NotOutnombered ==
    /\ (NB_MISSIONARIES_START = 0 \/ NB_MISSIONARIES_START >= NB_CANNIBALS_START)
    /\ (NB_MISSIONARIES_END = 0 \/ NB_MISSIONARIES_END >= NB_CANNIBALS_END)
IsEnded ==
    /\ NB_MISSIONARIES_END = 3
    /\ NB_CANNIBALS_END = 3
IsValid ==
    /\ NotNegative
    /\ NotIncoherent
    /\ NotOutnombered
Min(a, b) == IF a < b THEN a ELSE b


vars == << NB_MISSIONARIES_START, NB_CANNIBALS_START, NB_CANNIBALS_END, 
           NB_MISSIONARIES_END, BoatStartPos, pc >>

Init == (* Global variables *)
        /\ NB_MISSIONARIES_START = 3
        /\ NB_CANNIBALS_START = 3
        /\ NB_CANNIBALS_END = 0
        /\ NB_MISSIONARIES_END = 0
        /\ BoatStartPos = TRUE
        /\ pc = "CROSS"

CROSS == /\ pc = "CROSS"
         /\ IF BoatStartPos
               THEN /\ \E x \in 0..Min(2, NB_MISSIONARIES_START):
                         \E y \in 0..Min(2, NB_CANNIBALS_START):
                           /\ x + y >= 1 /\ x + y <= 2
                           /\ NB_MISSIONARIES_START' = NB_MISSIONARIES_START - x
                           /\ NB_MISSIONARIES_END' = NB_MISSIONARIES_END + x
                           /\ NB_CANNIBALS_START' = NB_CANNIBALS_START - y
                           /\ NB_CANNIBALS_END' = NB_CANNIBALS_END + y
                    /\ BoatStartPos' = FALSE
               ELSE /\ \E x \in 0..Min(2, NB_MISSIONARIES_END):
                         \E y \in 0..Min(2, NB_CANNIBALS_END):
                           /\ x + y >= 1 /\ x + y <= 2
                           /\ NB_MISSIONARIES_END' = NB_MISSIONARIES_END - x
                           /\ NB_MISSIONARIES_START' = NB_MISSIONARIES_START + x
                           /\ NB_CANNIBALS_END' = NB_CANNIBALS_END - y
                           /\ NB_CANNIBALS_START' = NB_CANNIBALS_START + y
                    /\ BoatStartPos' = TRUE
         /\ pc' = "CROSS"

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == CROSS
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 
====
