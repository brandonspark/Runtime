functor Kadane (Seq : SEQUENCE) :> MCS where type 'a seq = 'a Seq.t =
struct

  type 'a seq = 'a Seq.t

  fun mcs s =
    let
      val n = Seq.length s

      fun loop bestSoFar (bestEndingHere as (start, stop, sum)) =
        if stop >= n then bestSoFar else
        let
          val x = Seq.nth s stop
          val bestEndingHere' =
            if x > sum + x
            then (stop, stop+1, x)
            else (start, stop+1, sum+x)
          val bestSoFar' =
            if #3 bestEndingHere' > #3 bestSoFar
            then bestEndingHere'
            else bestSoFar
        in
          loop bestSoFar' bestEndingHere'
        end
    in
      loop (0, 0, 0.0) (0, 0, 0.0)
    end

end
