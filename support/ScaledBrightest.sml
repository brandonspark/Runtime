functor ScaledBrightest
  (structure Seq: SEQUENCE
   structure MaxRect: MAX_RECTANGLE where type 'a seq = 'a Seq.t
   structure Image: IMAGE where type 'a seq = 'a Seq.t) :>
sig
  (* processImage "path/to/input.ppm" "path/to/output.ppm" *)
  val processImage: string -> string -> unit
end =
struct

  (* https://stackoverflow.com/questions/596216/formula-to-determine-brightness-of-rgb-color *)
  fun luminance {red, green, blue} =
    let
      val r = Real.fromInt (Word8.toInt red) / 255.0
      val g = Real.fromInt (Word8.toInt green) / 255.0
      val b = Real.fromInt (Word8.toInt blue) / 255.0
      val y = 0.299*r + 0.587*g + 0.114*b
    in
      y
    end

  fun brightestBox scale image =
    let
      val height = Image.height image
      val width = Image.width image
      val lums = Seq.map (Seq.map luminance) image
      val totLum = Seq.reduce op+ 0.0 (Seq.map (Seq.reduce op+ 0.0) lums)
      val avgLum = totLum / Real.fromInt (width * height)
      fun adjust x = x - scale * avgLum
      val adjustedLums = Seq.map (Seq.map adjust) lums
      val ((i1,j1), (i2,j2), _) = MaxRect.maxRectangle adjustedLums
    in
      {topleft=(i1,j1), botright=(i2,j2)}
    end

  fun mark' scale image =
    let
      val box as {topleft=(i1,j1), botright=(i2,j2)} = brightestBox scale image

      val image' =
        if (i2 - i1) * (j2 - j1) <= 2500 then
          (* stop if brightest box is small enough *)
          image
        else
          mark' (scale * 1.5) image

      fun outputpx i j =
        if ((i = i1 orelse i = i2-1) andalso (j1 <= j) andalso (j < j2)) orelse
           ((j = j1 orelse j = j2-1) andalso (i1 <= i) andalso (i < i2))
        then {red=0w0, green=0w255, blue=0w0}
        else Seq.nth (Seq.nth image' i) j

      val result =
        Seq.tabulate
        (fn i => Seq.tabulate (fn j => outputpx i j) (Image.width image))
        (Image.height image)
    in
      result
    end

  fun mark image = mark' 1.0 image

  fun processImage infile outfile =
    let
      val _ = print ("reading " ^ infile ^ "...\n")
      val image = Image.read infile
      val _ = print ("width " ^ Int.toString (Image.width image) ^ "\n")
      val _ = print ("height " ^ Int.toString (Image.height image) ^ "\n")

      val _ = print ("finding brightest region (scaled)...\n")
      val result = mark image

      val _ = print ("writing to " ^ outfile ^ "...\n")
      val _ = Image.write outfile result
      val _ = print ("done\n")
    in
      ()
    end

end
