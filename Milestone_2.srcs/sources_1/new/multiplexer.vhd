----------------------------------------------------------------------------------
-- Author: Suhao Zhang 65353853  John He 44056699
-- 
-- Create Date: 22/03/2018 
-- Revision History: 15/05/2018 
-- Module Name: multiplexer - Behavioral
-- Project Name: ENEL 373 Project
-- Description: This architiecture is for multiplexes three clock rates input and 
-- output one multiplexed clock rate  
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

entity multiplexer is
    Port ( state : in STD_LOGIC_VECTOR(1 downto 0);
           Frequency_in : in STD_LOGIC_VECTOR (2 downto 0);
           Frequency_out : out STD_LOGIC);
end multiplexer;

architecture Behavioral of multiplexer is
signal F_out : std_logic;
begin
------------------------------------------------------------------------------------------------
-- This process assigns different frequency output signal to each different state
------------------------------------------------------------------------------------------------
  process(state)
    begin
        if(state = "11") then
        -- process 5k Hz
          F_out <= Frequency_in(2); 
        elsif(state = "01") then
        -- process 2k Hz
          F_out <= Frequency_in(0);  
        elsif(state = "00") then
        -- process 1k Hz
          F_out <= Frequency_in(1);
        end if;
   end process;
Frequency_out <= F_out;
end Behavioral;
