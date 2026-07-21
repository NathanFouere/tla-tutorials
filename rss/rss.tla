cf . https://muratbuffalo.blogspot.com/2016/11/modeling-replicated-storage-system-in.html

---- MODULE rss ----
EXTENDS TLC, Integers, Sequences

(*--algorithm tb
variables
    bucket = 0;
begin
    Start:
        bucket := bucket + 1;
end algorithm;
*)
====
