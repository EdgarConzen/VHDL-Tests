library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.blockram7s_package.all;


-- This entity shows the instantiation of a blockram7s component as RAM resp. as ROM.
-- A non-initialized blockram7s instantiated as ROM will be optimized away from Vivado. 
--
-- NUM_ADDR_BITS and NUM_DATA_BITS determine the ram's metric and are defined in
-- blockram7s_package for shared use by components and testbench


entity use_blockram7s is

  port ( 
    clk   :  in STD_LOGIC;
    we    :  in STD_LOGIC;
    addr  :  in STD_LOGIC_VECTOR (NUM_ADDR_BITS-1 downto 0);
    din   :  in STD_LOGIC_VECTOR (NUM_DATA_BITS-1 downto 0);
    dout  : out STD_LOGIC_VECTOR (NUM_DATA_BITS-1 downto 0)
  );

end entity use_blockram7s;


architecture rtl of use_blockram7s is

begin

  bram7s : component blockram7s
  generic map (
    NUM_ADDR_BITS => NUM_ADDR_BITS,
    NUM_DATA_BITS => NUM_DATA_BITS
  )
  port map (
    clk   => clk,
    we    => we,    -- for rom : we => '0'
    addr  => addr,
    din   => din,   -- for rom : din => (others => '0'),
    dout  => dout
  );


end architecture rtl;
