with Ada.Streams;
with Ada.Text_IO;
with Home_Pictures.PNG;
with Home_Pictures.PNG.Dev1;
with Ada.Streams.Stream_IO;
with ztest;
--with Home_Pictures.PNG.Decode1;

procedure Main_Dev is
   use Ada.Text_IO;
   use Home_Pictures.PNG;
   use Home_Pictures.PNG.Dev1;
   Context : Dev_Context;

begin

   Initialize (Context, "lena3x10.png");
   Devtool_Put_Info (Context);

   declare
      use Ada.Streams;
      use Ada.Streams.Stream_IO;
      use ztest;
      Buffer : Stream_Element_Array (1 .. 1000);
      Last : Stream_Element_Offset;
      Buffer_Out : Stream_Element_Array (1 .. 1000);
      Kind : PNG_Chunk_Kind;
      K : Character;
      Z : Z_Native_Stream;
      Status : Z_Status;
   begin
      Initialize_Inflate (Z, 15);
      loop
         Get_Immediate (K);
         Read_Whole_Chunk_Arbitrary (Stream (Context.File), Kind, Buffer, Last);
         Put_Line ("Kind " & Kind'Img);
         case Kind is
         when PNG_Chunk_Kind_IDAT =>
            Set_Next_Input (Z, Buffer (Buffer'First .. Last));
            Set_Next_Output (Z, Buffer_Out);
            Status := Inflate (Z, Z_Flush_None);
            Put_Line ("Status " & Status'Img);
         when PNG_Chunk_Kind_IEND =>
            exit;
         when others =>
            null;
         end case;
      end loop;
   end;


--     Put_Line ("Zip stream:");
--     Home_Pictures.PNG.Decode1.Put_Base_Array (Buffer (Buffer'First .. Last), 3, 16, 10);
--     New_Line (2);
--
--     declare
--        Pixmap : PNG_Pixmap
--          (1 .. Context.Width,
--           1 .. Context.Height,
--           1 .. Context.Channel_Count,
--           1 .. Context.Sample_Depth);
--     begin
--
--        Decode (Context, Pixmap);
--
--        null;
--     end;

end Main_Dev;
