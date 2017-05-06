with Ada.Assertions;
with Ada.Text_IO;
with Ada.Streams.Stream_IO;
with Ada.Streams;

--with Home_Pictures.PNG;
with ztest;


procedure Main_Test is
   use Ada.Assertions;

   procedure Test is
      use Ada.Streams;
      use Ada.Streams.Stream_IO;
      use ztest;
      F : File_Type;
   begin
      Ada.Text_IO.New_Line;
      Open (F, In_File, "lena10.png");
      --Read1 (Stream (F), S, D, L);
      Close (F);
   end Test;

begin
   Assert (False, "Test");

   Test;
end Main_Test;
