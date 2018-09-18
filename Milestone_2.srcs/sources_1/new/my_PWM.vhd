----------------------------------------------------------------------------------
-- Author: Suhao Zhang 65353853  John He 44056699
-- 
-- Create Date: 22/03/2018 
-- Revision History: 15/05/2018 
-- Module Name: PWM generator - Behavioral
-- Project Name: ENEL 373 Project
-- Description:  This architiecture is for generating three mode PWM signals          
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity my_PWM is
    Port ( clk_in : in STD_LOGIC;
           enable : in STD_LOGIC_VECTOR(1 downto 0);
           duty_cycle : in STD_LOGIC_VECTOR (7 downto 0);
           period : in STD_LOGIC_VECTOR (15 downto 0);
           pwm_out : out STD_LOGIC);
end my_PWM;

architecture Behavioral of my_PWM is
signal count : std_logic_vector (15 downto 0) := period;
-- threshold: This is for calculating the threshold voltage and converting it to a interger
signal threshold : unsigned(23 downto 0):= unsigned((unsigned(period)*unsigned(duty_cycle))/255);
begin
------------------------------------------------------------------------------------------------
-- internal_count: This is internal counter for PWM generator 
------------------------------------------------------------------------------------------------
     internal_count: process(clk_in, period)
     begin
          if(clk_in'event and clk_in = '1')then
             if count = 0 then
                count <= period;
             else
                count <= count - 1;
             end if;
          end if;
     end process internal_count;
------------------------------------------------------------------------------------------------
-- pwm_output: This process assigns a particular PWM signal to a particular state 
------------------------------------------------------------------------------------------------    
     pwm_output: process(count, enable)
     begin
          if(enable = "00")then
          -- toggle mode  
             if(threshold >= unsigned(count))then
             -- if threshold voltage bigger equal then count value the PWM output on high otherwise low
                pwm_out <= '1';
             else
                pwm_out <= '0';
             end if;
          elsif(enable = "10")then
          -- assert high mode
               pwm_out <= '1';
          elsif(enable = "11")then
          -- assert low mode
               pwm_out <= '0';
          end if;
     end process pwm_output;

end Behavioral;
