with Ada.Text_IO;
with Ada.Integer_Text_IO;
with Ada.Streams.Stream_IO;
with Ada.Streams;

with System;

with Home_Pictures.PNG;
with Home_Pictures.PNG.Puts;

procedure Main is

   procedure Put_Lines_PNG_Small_Chunk is
      use Home_Pictures.PNG;
      A : PNG_Small_Chunk_Vector;
   begin
      Read_Complete ("lena10.png", A);
      Puts.Put_Lines (A);
   end;

   procedure Test is
      use Ada.Streams.Stream_IO;
      use Home_Pictures.PNG;
      F : File_Type;
      S : PNG_Information;
   begin
      Ada.Text_IO.New_Line;
      Open (F, In_File, "lena10.png");
      Read (Stream (F), S);
      Close (F);
      Puts.Put_Lines (S);
   end;

begin
   Put_Lines_PNG_Small_Chunk;

   Test;
   --Home_Pictures.PNG.Puts.Put_Kind_Static_Expression;

   --Test;
end;
