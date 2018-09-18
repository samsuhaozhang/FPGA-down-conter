----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.04.2018 16:09:59
-- Design Name: 
-- Module Name: my_8bit_register - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity my_8bit_register is
    Port ( clk, reset : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (7 downto 0);
           enable : in STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR (7 downto 0));
end my_8bit_register;

architecture Behavioral of my_8bit_register is
signal data_register : std_logic_vector (7 downto 0):= X"FF";
begin
  process(clk, enable, reset)
   begin
     if(reset = '1') then
        data_register <= X"00";
     elsif(clk'Event and clk = '1') then
          if(enable = '1') then
             data_register <= data_in;
          end if;
     end if;
  end process;
  data_out <= data_register;

end Behavioral;
