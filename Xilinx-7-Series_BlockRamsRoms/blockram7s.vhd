library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


-- This entity translates into a contiguous RAM block, composed of distributed ram or an
-- array of blockrams, depending on the metrics given by NUM_ADDR_BITS and NUM_DATA_BITS.
-- The following table shows a few tested configurations for the Artix xc7a35.
-- To test other devices (e.g. xc7a15) and other metrics (e.g. 72 data bits), simply change
-- NUM_ADDR_BITS and NUM_DATA_BITS in blockram7s_package and/or the target device in 
-- project settings and run synthesis again. Tested with Vivado 2016.1

--   Device = xc7a35
--
--   First column = number of address bits (NUM_ADDR_BITS)
--   |
--   |       BR = synthesizes to blockram /  #  = synthesizes to distributed ram
--   v
--  15  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR ...  BR
--  14  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR ...  BR
--  13  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR ...  BR
--  12  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR ...  BR
--  11  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR ...  BR
--  10  #   BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR ...  BR
--   9  #   #   BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR ...  BR
--   8  #   #   #   #   BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR  BR ...  BR
--   7  #   #   #   #   #   #   #   #   BR  BR  BR  BR  BR  BR  BR  BR  BR  BR ...  BR
--   6  #   #   #   #   #   #   #   #   #   #   #   #   #   #   #   #   BR  BR ...  BR
--   5  #   #   #   #   #   #   #   #   #   #   #   #   #   #   #   #   BR  BR ...  BR
--   4  #   #   #   #   #   #   #   #   #   #   #   #   #   #   #   #   BR  BR ...  BR
--   3  #   #   #   #   #   #   #   #   #   #   #   #   #   #   #   #   BR  BR ...  BR
--   2  #   #   #   #   #   #   #   #   #   #   #   #   #   #   #   #   BR  BR ...  BR
--   1  #   #   #   #   #   #   #   #   #   #   #   #   #   #   #   #   BR  BR ...  BR
--      1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  16  17  18 ...  36
--      ^--------------Number of data bits (NUM_DATA_BITS) --------------------------^


entity blockram7s is

  generic (
    NUM_ADDR_BITS : integer range 1 to 32 := 10;  -- default : 1024 addresses & 32 bit data words =>
    NUM_DATA_BITS : integer range 1 to 72 := 32   -- fits in single RAMB36E1 as 1K x 32
  );  
  port (
    clk   :  in STD_LOGIC;
    we    :  in STD_LOGIC;
    addr  :  in STD_LOGIC_VECTOR (NUM_ADDR_BITS-1 downto 0);
    din   :  in STD_LOGIC_VECTOR (NUM_DATA_BITS-1 downto 0);
    dout  : out STD_LOGIC_VECTOR (NUM_DATA_BITS-1 downto 0)
  );

end blockram7s;


architecture rtl of blockram7s is

  -- define the RAM area
  
  type mem_arr is array(0 to 2**NUM_ADDR_BITS-1) of std_logic_vector (NUM_DATA_BITS-1 downto 0);
  signal memory : mem_arr := (
    -- insert initialization data here, e.g. :
    -- X"00000001", X"12345678", ...,
    -- and fill the rest with
    others => X"00000000"
  );

  attribute ram_style : string;
  attribute ram_style of memory : signal is "block";
  -- this attribute for signal 'memory' tells Vivado to use block ram instead of distributed ram
  -- but that only works for certain ram metrics (see table above or synthesize with corresponding configuration)
  -- BTW: There seems to be no difference between using 'ram_style' and 'rom_style'. Empty (i.e. non-initialized
  -- or initialized to all '0') rams that are instantiated as roms (we <= '0' and/or din <= (others => '0'))
  -- will be optimized away during synthesis, even when using rom_style as attribute!

  
begin
  
    memrw : process (clk)
    begin
      if rising_edge (clk) then
        dout <= memory (to_integer(unsigned(addr))); 
        if (we='1') then
            memory(to_integer (unsigned(addr))) <= din;
        end if;
      end if;
    end process;
  
  
  end rtl;
