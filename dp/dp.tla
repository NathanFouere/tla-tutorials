Dining Philosophers

    Difficulty: Medium
    Example solution: https://en.wikipedia.org/wiki/Dining_philosophers_problem
    Type: Concurrency problem

Five philosophers sit around a table with a fork between each pair. Each alternates thinking and eating; to eat, a philosopher needs both adjacent forks. Devise a protocol that avoids deadlock and starvation while allowing concurrent progress.

    Explore next: Compare resource hierarchies, arbitrators, and Chandy–Misra solutions.

---- MODULE dp ----
EXTENDS TLC, Integers
CONSTANT NULL, THINKING, EATING, USED, UNUSED, IDLE

(*--algorithm dp
   
    variables
        Nb = 5;
        Philosophers = 0..(Nb-1);
        StatePhil = [p \in Philosophers |-> [state |-> THINKING, usedFork |-> NULL]];
        Forks = 0..(Nb-1);
        StateForks = [p \in Forks |-> UNUSED];

    define
        TypeOK ==
            /\ \A p \in Philosophers :
                /\ StatePhil[p].state \in {THINKING, EATING, IDLE}
                /\ StatePhil[p].usedFork \in Forks \union {NULL}
              
     \* ajouter liveness "a un moment, tout le monde va manger et tout le monde va penser"
     
    end define;
    
        process Phil \in Philosophers
        begin
            P:
                if StatePhil[self].state = EATING then
                    \* repose la fourchette et passe a l etat thinking
                    PASS_TO_THINKING:
                        StatePhil[self].state := THINKING;
                    UNSET_FORK:
                        StateForks[StatePhil[self].usedFork] := UNUSED;
                        StatePhil[self].usedFor := NULL;
                elsif StateForks[self] = UNUSED then
                    \* prend fourchette gauche et passe a l etat manger
                    PASS_TO_EATING_LEFT:
                        StatePhil[self].state := EATING;
                    PASS_TO_USED_LEFT:
                        StatePhil[self].usedFork := self;
                        StateForks[self] := USED;
                elsif StateForks[(self + 1) % Nb] = UNUSED then \* mod Nb permet de pas depasser
                    \* prend fourchette droite et passe a l etat manger
                    PASS_TO_EATING_RIGHT:
                        StatePhil[(self + 1) % Nb].state := EATING;
                    PASS_TO_USED_RIGHT:
                        StatePhil[(self + 1) % Nb].usedFork := self;
                        StateForks[(self + 1) % Nb] := USED;
                else
                    \* passe a letat idle
                    StatePhil[self] := IDLE;
                end if;
        
        end process;
end algorithm;
*)
\* BEGIN TRANSLATION (chksum(pcal) = "49bbc5f8" /\ chksum(tla) = "694c93d")
VARIABLES Nb, Philosophers, StatePhil, Forks, StateForks, pc

(* define statement *)
TypeOK ==
    /\ \A p \in Philosophers :
        /\ StatePhil[p].state \in {THINKING, EATING, IDLE}
        /\ StatePhil[p].usedFork \in Forks \union {NULL}


vars == << Nb, Philosophers, StatePhil, Forks, StateForks, pc >>

ProcSet == (Philosophers)

Init == (* Global variables *)
        /\ Nb = 5
        /\ Philosophers = 0..(Nb-1)
        /\ StatePhil = [p \in Philosophers |-> [state |-> THINKING, usedFork |-> NULL]]
        /\ Forks = 0..(Nb-1)
        /\ StateForks = [p \in Forks |-> UNUSED]
        /\ pc = [self \in ProcSet |-> "P"]

P(self) == /\ pc[self] = "P"
           /\ IF StatePhil[self].state = EATING
                 THEN /\ pc' = [pc EXCEPT ![self] = "PASS_TO_THINKING"]
                      /\ UNCHANGED StatePhil
                 ELSE /\ IF StateForks[self] = UNUSED
                            THEN /\ pc' = [pc EXCEPT ![self] = "PASS_TO_EATING_LEFT"]
                                 /\ UNCHANGED StatePhil
                            ELSE /\ IF StateForks[(self + 1) % Nb] = UNUSED
                                       THEN /\ pc' = [pc EXCEPT ![self] = "PASS_TO_EATING_RIGHT"]
                                            /\ UNCHANGED StatePhil
                                       ELSE /\ StatePhil' = [StatePhil EXCEPT ![self] = IDLE]
                                            /\ pc' = [pc EXCEPT ![self] = "Done"]
           /\ UNCHANGED << Nb, Philosophers, Forks, StateForks >>

PASS_TO_THINKING(self) == /\ pc[self] = "PASS_TO_THINKING"
                          /\ StatePhil' = [StatePhil EXCEPT ![self].state = THINKING]
                          /\ pc' = [pc EXCEPT ![self] = "UNSET_FORK"]
                          /\ UNCHANGED << Nb, Philosophers, Forks, StateForks >>

UNSET_FORK(self) == /\ pc[self] = "UNSET_FORK"
                    /\ StateForks' = [StateForks EXCEPT ![StatePhil[self].usedFork] = UNUSED]
                    /\ StatePhil' = [StatePhil EXCEPT ![self].usedFor = NULL]
                    /\ pc' = [pc EXCEPT ![self] = "Done"]
                    /\ UNCHANGED << Nb, Philosophers, Forks >>

PASS_TO_EATING_LEFT(self) == /\ pc[self] = "PASS_TO_EATING_LEFT"
                             /\ StatePhil' = [StatePhil EXCEPT ![self].state = EATING]
                             /\ pc' = [pc EXCEPT ![self] = "PASS_TO_USED_LEFT"]
                             /\ UNCHANGED << Nb, Philosophers, Forks, 
                                             StateForks >>

PASS_TO_USED_LEFT(self) == /\ pc[self] = "PASS_TO_USED_LEFT"
                           /\ StatePhil' = [StatePhil EXCEPT ![self].usedFork = self]
                           /\ StateForks' = [StateForks EXCEPT ![self] = USED]
                           /\ pc' = [pc EXCEPT ![self] = "Done"]
                           /\ UNCHANGED << Nb, Philosophers, Forks >>

PASS_TO_EATING_RIGHT(self) == /\ pc[self] = "PASS_TO_EATING_RIGHT"
                              /\ StatePhil' = [StatePhil EXCEPT ![(self + 1) % Nb].state = EATING]
                              /\ pc' = [pc EXCEPT ![self] = "PASS_TO_USED_RIGHT"]
                              /\ UNCHANGED << Nb, Philosophers, Forks, 
                                              StateForks >>

PASS_TO_USED_RIGHT(self) == /\ pc[self] = "PASS_TO_USED_RIGHT"
                            /\ StatePhil' = [StatePhil EXCEPT ![(self + 1) % Nb].usedFork = self]
                            /\ StateForks' = [StateForks EXCEPT ![(self + 1) % Nb] = USED]
                            /\ pc' = [pc EXCEPT ![self] = "Done"]
                            /\ UNCHANGED << Nb, Philosophers, Forks >>

Phil(self) == P(self) \/ PASS_TO_THINKING(self) \/ UNSET_FORK(self)
                 \/ PASS_TO_EATING_LEFT(self) \/ PASS_TO_USED_LEFT(self)
                 \/ PASS_TO_EATING_RIGHT(self) \/ PASS_TO_USED_RIGHT(self)

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == /\ \A self \in ProcSet: pc[self] = "Done"
               /\ UNCHANGED vars

Next == (\E self \in Philosophers: Phil(self))
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(\A self \in ProcSet: pc[self] = "Done")

\* END TRANSLATION 
====
