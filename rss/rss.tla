cf . https://muratbuffalo.blogspot.com/2016/11/modeling-replicated-storage-system-in.html

-------------------------- MODULE rss --------------------------
(* Replicated storage protocol with clientside routing *)
EXTENDS Integers, Sequences, FiniteSets, TLC
CONSTANTS N, C, STOP, ReadQ, WriteQ, FAILNUM
ASSUME N = 5 /\ C = 1 /\ STOP < 10 /\ 1 <= ReadQ /\ ReadQ <= 3
       /\ 1 <= WriteQ /\ WriteQ <= 3 /\ 0 <= FAILNUM /\ FAILNUM <= 2
Nodes   == 1..N
Clients == N+1 .. N+C        \* should give different ID space to Client

(*--algorithm voldemort
{
    variable FailNum = FAILNUM,
             up = [n \in Nodes |-> TRUE],                    \* Initially all nodes are up
             db = [n \in Nodes |-> {[ver |-> 0, val |-> 0]}];
             \* All nodes have database, wherein [ver=0, val=0] stored for the item

    define
    {
        \* TODO  (grande case cyan) : opérateurs utilitaires
        \*   -- probablement SetMax, SetofVers, ReturnDBs ... à toi de les trouver
        \*   (indice : il te faut extraire les "ver" d'un ensemble de records,
        \*    récupérer les db d'un ensemble de nœuds, et en prendre le max)

        UpNodes    == { \* TODO (case cyan) }
        ReturnReadQ  == \* TODO (case cyan)
        ReturnWriteQ == CHOOSE i \in SUBSET(UpNodes) : Cardinality(i) = WriteQ
        \* CHOOSE deterministically returns lowest ID nodes that satisfy the requirement
    }

    fair process (c \in Clients)
    variable cntr = 0, hver = 0, Q = {};
    {
    CL: while (cntr <= STOP)
        {
            cntr := cntr + 1;
            \* get the highest version number from read Quorum
            hver := \* TODO  (case cyan, une ligne)

            \* write val=cntr to writeQuorum with higher version number
            \* TODO  (grande case cyan)
        }
    }

    fair process (n \in Nodes)
    {
    NODE: while (TRUE)
        {
            if (FailNum > 0 /\ up[self] = TRUE)         \* Storage node can fail
            {
                \* TODO  (case cyan)
            }
            else if (up[self] = FALSE)                  \* Or recover
            {
                \* TODO  (case cyan)
            }
        }
    }
}
*)
=====================================================================
