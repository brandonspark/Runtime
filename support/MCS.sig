signature MCS =
sig
  type 'a seq
  val mcs: real seq -> int * int * real
end
