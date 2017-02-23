with Ada.Text_IO;
with Ada.Integer_Text_IO;
with Ada.Streams.Stream_IO;
with Home_Pictures.PNG_Surfaces;
with Home_Pictures.PNG_Surfaces.Puts;
with System; use System;
with Ada.Streams;

procedure Main is

   procedure Test2 is
      use Ada.Streams.Stream_IO;
      use Home_Pictures.PNG_Surfaces;
      F : File_Type;
      S : PNG_Surface;
   begin
      Ada.Text_IO.New_Line;
      Open (F, In_File, "lena512.png");
      Read (Stream (F), S);
      Close (F);
      Puts.Put_Lines (S);
   end;

begin

   --Ada.Text_IO.Put_Line ("Stream_Element'Size " & Ada.Streams.Stream_Element'Size'Img);
   Test2;
end;
