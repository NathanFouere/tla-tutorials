---- MODULE MC ----
EXTENDS mac, TLC

\* INVARIANT definition @modelCorrectnessInvariants:0
inv_178275943571834000 ==
IsValid = TRUE
----
\* INVARIANT definition @modelCorrectnessInvariants:1
inv_178275943571835000 ==
NotNegative = TRUE
----
\* INVARIANT definition @modelCorrectnessInvariants:2
inv_178275943571836000 ==
NotIncoherent = TRUE
----
\* INVARIANT definition @modelCorrectnessInvariants:3
inv_178275943571837000 ==
NotOutnombered = TRUE
----
\* PROPERTY definition @modelCorrectnessProperties:0
prop_178275943571838000 ==
<>IsEnded
----
=============================================================================
\* Modification History
\* Created Mon Jun 29 20:57:15 CEST 2026 by nathanf
