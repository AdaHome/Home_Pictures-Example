with ztest;
with Ada.Streams;
with Interfaces.C;
with Ada.Text_IO;
with Ada.Integer_Text_IO;
with Home_Pictures.PNG;

procedure Main_ZTest is

   use Ada.Text_IO;
   use Ada.Integer_Text_IO;
   use Ada.Streams;
   use ztest;
   use Home_Pictures.PNG;
   use type Interfaces.C.unsigned;

   Z : Z_Native_Stream;
   Data_Compressed : Stream_Element_Array := (16#18#, 16#57#, 16#63#, 16#0#, 16#82#, 16#FF#, 16#F5#, 16#F5#, 16#F5#, 16#FF#, 16#F#, 16#1F#, 16#3E#, 16#FC#, 16#9F#, 16#9#, 16#C4#, 16#3#, 16#1#, 16#5B#, 16#5B#, 16#5B#, 16#6#, 16#38#, 16#87#, 16#81#, 16#81#, 16#81#, 16#1#, 16#0#, 16#DB#, 16#EA#, 16#7#, 16#7F#);
   Data_Uncompressed : Stream_Element_Array (1 .. 3 * 3 * 4);
   Data_Uncompressed2 : Stream_Element_Array (1 .. 1000);


   Status : Z_Status;

begin
   New_Line (2);
   Initialize_Inflate (Z, 15);
   Set_Next_Input (Z, Data_Compressed);
   Inflate_All (Z, 3, 3, 4, Data_Uncompressed);

   for E of Data_Uncompressed loop
      Put (Integer (E), 8, 16);
   end loop;

   New_Line (2);

   Initialize_Inflate (Z, 15);
   Set_Next_Input (Z, Data_Compressed);
   Set_Next_Output (Z, Data_Uncompressed2);
   Status := Inflate (Z, Z_Flush_None);
   Put_Line (Status'Img);
   Put_Line (Z.Output_Available'Img);
   Put_Line (Z.Output_Total'Img);
   for E of Data_Uncompressed2 (1 .. Stream_Element_Offset (Z.Output_Total)) loop
      Put (Integer (E), 8, 16);
   end loop;
   New_Line;


end Main_ZTest;
