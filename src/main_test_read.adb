with Ada.Streams;
with Ada.Text_IO;

with Home_Pictures.PNG;
with Home_Pictures.PNG.Decode1;
with Home_Pictures.PNG.Generic_Decode2;
with Home_Pictures.PNG.Reader1;

procedure Main_Test_Read is


   procedure Test1 is
      use Home_Pictures.PNG;
      use Home_Pictures.PNG.Reader1;
      use Ada.Streams;
      use Ada.Text_IO;
      Reader_Context : PNG_Reader_Context;
      Buffer : Stream_Element_Array (1 .. 1000);
      Last : Stream_Element_Offset;
   begin
      Initialize (Reader_Context, "lena3x10.png");

      declare
         Pixel_Byte_Depth : constant PNG_Pixel_Byte_Depth := Find_Pixel_Byte_Depth (Reader_Context.Header.Data_IHDR.Color_Kind, Reader_Context.Header.Data_IHDR.Bit_Depth);
         package D is new Home_Pictures.PNG.Generic_Decode2 (Pixel_Byte_Depth, Reader_Context.Header.Data_IHDR.Width, Reader_Context.Header.Data_IHDR.Height);
         Decoder_Context : D.Decode_Context;
         Pixmap : D.Row_Array;
         K : Character;
      begin
         loop
            Read (Reader_Context, Buffer, Last);
            exit when Reader_Context.Kind = PNG_Chunk_Kind_IDAT;
         end loop;

         D.Initialize (Decoder_Context, Buffer (Buffer'First .. Last));

         for I in Pixmap'First .. Pixmap'Last loop
            Get_Immediate (K);
            D.Decode_Row (Decoder_Context, Pixmap);
            for R in D.Row_Index loop
               for C in D.Column_Index loop
                  for P of Pixmap (R) (C) loop
                     Put (" ");
                     Home_Pictures.PNG.Decode1.Put_Base (P, 2, 16);
                  end loop;
                  Put ("|");
               end loop;
               New_Line;
            end loop;
            New_Line (3);
         end loop;
      end;
   end;

begin

   Test1;

end;
