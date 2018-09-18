----------------------------------------------------------------------------------
-- Author: Suhao Zhang 65353853  John He 44056699
-- 
-- Create Date: 22/03/2018 
-- Revision History: 15/05/2018 
-- Module Name: down counter - Behavioral
-- Project Name: ENEL 373 Project
-- Description: This architiecture is for counting down the 16 bit value from 
-- register
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sixteen_bit_counter is
    Port ( clk, reset : in STD_LOGIC;
           number : in STD_LOGIC_VECTOR (15 downto 0);
           LED_OUT : out STD_LOGIC;
           number_out : out STD_LOGIC_VECTOR (15 downto 0);
           q_count : out STD_LOGIC);
           
end sixteen_bit_counter;

architecture Behavioral of sixteen_bit_counter is
signal count : std_logic_vector (15 downto 0):= X"8000";
signal flag : std_logic;                       -- The flag for LED
begin
------------------------------------------------------------------------------------------------
-- This counting down the 16 bit input value 
------------------------------------------------------------------------------------------------
process(reset, clk)is
begin
  if reset = '1' then
  -- count number returns back to max input value whenever reset is on
   count <= number;
  elsif(clk'event and clk ='1')then
    if(count="0000")then
    -- eachtime count reaches zero, it will retutn back to max input vlaue and raise flag
       flag <= '1';
      count <= number;
    else
    -- if count not reached zero value then keep down count and dont raise flag
     flag <= '0';
     count <= count - 1;
     
    end if;
  end if;
  end process;
  -- output the counting signal and LED for debuging
  LED_OUT <= flag;
  q_count <= flag;
  -- show the stored 16 bit value on 16 switch LEDs
  number_out <= number;

end Behavioral;
