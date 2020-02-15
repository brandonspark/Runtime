signature MAX_RECTANGLE =
sig
  type 'a seq

  (* Return the coordinates and sum of the interior rectangle that has
   * maximum sum. In the picture below, if the sum of the rectangle is R,
   * the result would be ((i1, j1), (i2, j2), R).
   * Indices i1 and j1 are inclusive, and indices i2 and j2 are exclusive.
   *
   *             j1  j2
   *             |   |
   *         +---+---+----+
   *         |   |   |    |
   *    i1 --+---+---+    |
   *         |   |   |    |
   *    i2 --+---+---+    |
   *         |            |
   *         +------------+
   *
   * The input is a sequence of rows, and each row must be the same length.
   *)

  val maxRectangle: real seq seq -> (int * int) * (int * int) * real
end
