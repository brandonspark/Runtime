signature IMAGE =
sig
  type 'a seq

  type channel = Word8.word
  type pixel = {red: channel, green: channel, blue: channel}

  (* sequence of rows, each row must be the same length *)
  type image = pixel seq seq

  val width: image -> int
  val height: image -> int

  type box = {topleft: int * int, botright: int * int}

  val subimage: box -> image -> image

  (* `replace box image subimage` copies subimage into the image at the
   * specified box *)
  val replace: box -> image -> image -> image

  (* read the given .ppm file *)
  val read: string -> image

  (* output this image to the given .ppm file *)
  val write: string -> image -> unit
end
