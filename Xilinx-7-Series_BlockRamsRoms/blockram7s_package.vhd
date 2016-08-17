library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


package blockram7s_package is

  -- NUM_ADDR_BITS and NUM_DATA_BITS determine the ram's size and metric and 
  -- are defined here for shared use by between components and testbench
  
  constant NUM_ADDR_BITS : integer := 15; -- Number of address bits
  constant NUM_DATA_BITS : integer := 32; -- Number of data bits
  --> 128KiB 
  

  -- declaration
  component blockram7s is
  
    generic (
      NUM_ADDR_BITS : integer range 1 to 32;  -- 4G address space and
      NUM_DATA_BITS : integer range 1 to 72   -- 64 bit data width plus parity should be enough
    );  
    port (
      clk   :  in STD_LOGIC;
      we    :  in STD_LOGIC;
      addr  :  in STD_LOGIC_VECTOR (NUM_ADDR_BITS-1 downto 0);
      din   :  in STD_LOGIC_VECTOR (NUM_DATA_BITS-1 downto 0);
      dout  : out STD_LOGIC_VECTOR (NUM_DATA_BITS-1 downto 0)
    );
  
  end component blockram7s;


end blockram7s_package;
