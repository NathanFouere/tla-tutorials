---- MODULE MC ----
EXTENDS mac, TLC

\* INVARIANT definition @modelCorrectnessInvariants:0
inv_178275954954364000 ==
IsValid = TRUE
----
\* INVARIANT definition @modelCorrectnessInvariants:1
inv_178275954954365000 ==
NotNegative = TRUE
----
\* INVARIANT definition @modelCorrectnessInvariants:2
inv_178275954954366000 ==
NotIncoherent = TRUE
----
\* INVARIANT definition @modelCorrectnessInvariants:3
inv_178275954954367000 ==
NotOutnombered = TRUE
----
\* INVARIANT definition @modelCorrectnessInvariants:4
inv_178275954954368000 ==
~IsEnded = TRUE
----
=============================================================================
\* Modification History
\* Created Mon Jun 29 20:59:09 CEST 2026 by nathanf
