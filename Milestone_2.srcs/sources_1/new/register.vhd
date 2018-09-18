----------------------------------------------------------------------------------
-- Author: Suhao Zhang 65353853  John He 44056699
-- 
-- Create Date: 22/03/2018 
-- Revision History: 15/05/2018 
-- Module Name:  register - Behavioral
-- Project Name: ENEL 373 Project
-- Description: This architiecture is for storing the 16 bit and 8 bit value on 
-- register
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

entity my_register is
    Port ( data_in : in STD_LOGIC_VECTOR (15 downto 0);
           duty_in : in STD_LOGIC_VECTOR (7 downto 0);
           clk, reset :in STD_LOGIC;
           duty_out : out STD_LOGIC_VECTOR (7 downto 0);
           data_out : out STD_LOGIC_VECTOR (15 downto 0));
end my_register;

architecture Behavioral of my_register is
signal data_register : std_logic_vector (15 downto 0):= X"8000";
signal duty_register : std_logic_vector (7 downto 0);
begin
------------------------------------------------------------------------------------------------
-- register_16: This process stores 16 bit period value into register
------------------------------------------------------------------------------------------------
  register_16: process(clk, reset)
    begin
     if(reset = '1') then
     -- automatically upate 16 bit value as X8000
        data_register <= X"8000";
     elsif(clk'Event and clk = '1') then
     -- output the 16 bit period value 
             data_register <= data_in;
     end if;
   end process register_16;
------------------------------------------------------------------------------------------------
-- register_8: This process stores 8 bit duty cycle value into register 
------------------------------------------------------------------------------------------------   
   register_8: process(clk, reset)
       begin
        if(reset = '1') then
        -- automatically upate 8 bit value as X00
           duty_register <= X"00";
        elsif(clk'Event and clk = '1') then
        -- output the 8 bit duty cycle value
           duty_register <= duty_in;
        end if;
    end process register_8;
data_out <= data_register;
duty_out <= duty_register;
end Behavioral;
