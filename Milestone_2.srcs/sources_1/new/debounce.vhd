----------------------------------------------------------------------------------
-- Author: Suhao Zhang 65353853  John He 44056699
-- 
-- Create Date: 22/03/2018 
-- Revision History: 15/05/2018 
-- Module Name: debounce - Behavioral
-- Project Name: ENEL 373 Project
-- Description: This architiecture is for debouncing 4 push-buttons  
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

entity debounce is
    Port ( button_in : in STD_LOGIC_VECTOR(1 downto 0);
           clk : in STD_LOGIC;
           debounce_out : out STD_LOGIC_VECTOR(1 downto 0));
end debounce;

architecture Behavioral of debounce is
signal button1_delay1, button1_delay2, button1_delay3: std_logic;
signal button2_delay1, button2_delay2, button2_delay3: std_logic;
begin 
------------------------------------------------------------------------------------------------
-- Frequency_button: This process debounces the buttons to give clean signals for controlling different clock rates 
------------------------------------------------------------------------------------------------    
    frequency_button :process(clk)
    begin
        if(clk'event and clk = '1')then
        -- process debouncing by using 3 flip-flop
            button1_delay1 <= button_in(0);
            button1_delay2 <= button1_delay1;
            button1_delay3 <= button1_delay2;
        end if;
    end process frequency_button;
------------------------------------------------------------------------------------------------
-- pwm_button: This process debounces the button to give clean signals for controlling different PWM mode 
------------------------------------------------------------------------------------------------    
    pwm_button :process(clk)
    begin
        if(clk'event and clk = '1')then
        -- process debouncing by using 3 flip-flop
            button2_delay1 <= button_in(1);
            button2_delay2 <= button2_delay1;
            button2_delay3 <= button2_delay2;
        end if;
    end process pwm_button;
------------------------------------------------------------------------------------------------
-- output all the debounced signals
------------------------------------------------------------------------------------------------ 
debounce_out(0) <= button1_delay1 and button1_delay2 and not(button1_delay3);
debounce_out(1) <= button2_delay1 and button2_delay2 and not(button2_delay3);
end Behavioral;
