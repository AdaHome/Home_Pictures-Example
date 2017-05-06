with Ada.Integer_Text_IO;
with Interfaces; use Interfaces;
with Ada.Text_IO;
with Ada.Streams.Stream_IO;
with Ada.Streams;

with GNAT.CRC32;

with Home_Pictures.PNG;
with Home_Pictures.PNG.Decode1;

procedure Main_Dev is

   procedure Put_Base (Value : Natural; Width : Natural; Base : Positive) is
      Hex : constant array (Natural range 0 .. 15) of Character := "0123456789ABCDEF";
      B : Natural := Value;
      Buffer : String (1 .. Width) := (others => ' ');
   begin
      for E of reverse Buffer loop
         E := Hex (B mod Base);
         B := B / Base;
         exit when B = 0;
      end loop;
      Ada.Text_IO.Put (Buffer);
      null;
   end;

   procedure Put (Item : Ada.Streams.Stream_Element_Array) is
   begin
      for E of Item loop
         Ada.Integer_Text_IO.Put (Integer (E), 6, 16);
      end loop;
   end Put;

   procedure Put (Item : Ada.Streams.Stream_Element_Array; Width : Home_Pictures.PNG.PNG_Width; Height : Home_Pictures.PNG.PNG_Height; Pixel_Byte_Depth : Home_Pictures.PNG.PNG_Pixel_Byte_Depth) is
      I : Ada.Streams.Stream_Element_Offset := Item'First;
   begin
      for K in 1 .. Height loop
         for J in 1 .. Width loop
            for L in 1 .. Pixel_Byte_Depth loop
               Put_Base (Integer (Item (I)), 4, 10);
               I := Ada.Streams.Stream_Element_Offset'Succ (I);
            end loop;
            Ada.Text_IO.Put ("|");
         end loop;
         Ada.Text_IO.New_Line;
      end loop;
   end Put;

   procedure Test is
      use Ada.Streams;
      use Ada.Streams.Stream_IO;
      use Home_Pictures.PNG;
      Checksum : GNAT.CRC32.CRC32;
      F : File_Type;
      Header : PNG_Complete_Fixed_Header;
      Length : Unsigned_32;
      Kind : PNG_Chunk_Kind;
      Buffer : Stream_Element_Array (1 .. 1000);
      Last : Stream_Element_Offset := 0;
   begin
      Ada.Text_IO.New_Line;
      Open (F, In_File, "lena3x10.png");
      Read_Signature (Stream (F));
      loop
         Read_Chunk_Begin (Stream (F), Length, Kind, Checksum);
         Ada.Text_IO.Put_Line (Length'Img & "|" & Kind'Img);
         case Kind is
         when PNG_Chunk_Kind_IDAT =>
            Last := Buffer'First + Stream_Element_Count (Length) - 1;
            Read_Chunk_End_Arbitrary (Stream (F), Buffer (Buffer'First .. Last), Checksum);
         when others =>
            Read_Chunk_End_Header (Stream (F), Header, Length, Kind, Checksum);
         end case;
         exit when Kind = PNG_Chunk_Kind_IEND;
      end loop;
      Close (F);

      Ada.Text_IO.New_Line;
      Put (Buffer (Buffer'First .. Last));
      Ada.Text_IO.New_Line (2);

      declare
         use Home_Pictures.PNG.Decode1;
         Pixel_Byte_Depth : constant Unsigned_32 := Find_Pixel_Byte_Depth (Header.Data_IHDR.Color_Kind, Header.Data_IHDR.Bit_Depth);
         Complete_Size_Byte : constant Unsigned_32 := Header.Data_IHDR.Width * Header.Data_IHDR.Height * Pixel_Byte_Depth;
         Pixmap : Stream_Element_Array (1 .. Stream_Element_Offset (Complete_Size_Byte));
      begin
         Ada.Text_IO.Put_Line ("Complete_Size_Byte " & Complete_Size_Byte'Img);
         Decode1.Inflate_All (Buffer (Buffer'First .. Last), Header.Data_IHDR.Width, Header.Data_IHDR.Height, Pixel_Byte_Depth, Pixmap);

         Ada.Text_IO.New_Line;
         Put (Pixmap, Header.Data_IHDR.Width, Header.Data_IHDR.Height, Pixel_Byte_Depth);
         Ada.Text_IO.New_Line (2);
      end;

   end;

begin

   Test;

end;
