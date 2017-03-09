with ztest;
with Ada.Streams;
with Interfaces.C;
with Ada.Text_IO;
with Ada.Integer_Text_IO;

procedure Main_ZTest is

   use Ada.Text_IO;
   use Ada.Integer_Text_IO;
   use Ada.Streams;
   use ztest;
   use type Interfaces.C.unsigned;

   Z : Z_Stream;
   Data_Compressed : Stream_Element_Array := (16#18#, 16#57#, 16#63#, 16#0#, 16#82#, 16#FF#, 16#F5#, 16#F5#, 16#F5#, 16#FF#, 16#F#, 16#1F#, 16#3E#, 16#FC#, 16#9F#, 16#11#, 16#C4#, 16#1#, 16#89#, 16#1C#, 16#3E#, 16#7C#, 16#98#, 16#1#, 16#0#, 16#88#, 16#17#, 16#A#, 16#D#);
   Data_Uncompressed : Stream_Element_Array (1 .. 1000);
   R : Interfaces.C.int;
begin

   Initialize (Z, 15);

   Z.Next_In := Data_Compressed'Address;
   Z.Avail_In := Data_Compressed'Length;

   Z.Next_Out := Data_Uncompressed'Address;
   Z.Avail_Out := Data_Uncompressed'Length;

   R := Inflate (Z, Z_NO_FLUSH);
   Put_Line (R'Img);
   Put_Line (Z.Avail_Out'Img);

   for E of Data_Uncompressed (1 .. Stream_Element_Offset (Data_Uncompressed'Length - Z.Avail_Out)) loop
      Put (Integer (E), 8, 16);
   end loop;
   New_Line;

end Main_ZTest;
