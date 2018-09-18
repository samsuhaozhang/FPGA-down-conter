----------------------------------------------------------------------------------
-- Author: Suhao Zhang 65353853  John He 44056699
-- 
-- Create Date: 22/03/2018 
-- Revision History: 15/05/2018 
-- Module Name: FSM - Behavioral
-- Project Name: ENEL 373 Project
-- Description: This architiecture is for schedulaing the different states process 
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

entity FSM is
    Port ( debounce_in : in STD_LOGIC_VECTOR(1 downto 0);
           button_in : in STD_LOGIC_VECTOR(1 downto 0);
           data_in : in STD_LOGIC_VECTOR(15 downto 0);
           duty_in : in STD_LOGIC_VECTOR(7 downto 0);
           clock,reset : in STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR(15 downto 0);
           duty_out : out STD_LOGIC_VECTOR(7 downto 0);
           frequencey_state_out, pwm_state_out  : out STD_LOGIC_VECTOR(1 downto 0));
end FSM;

architecture Behavioral of FSM is
type frequency_state_type is (A, B, C);
signal frequency_current_state, frequency_next_state : frequency_state_type;

type pwm_state_type is (high, toggle, low);
signal pwm_current_state, pwm_next_state : pwm_state_type;

begin
------------------------------------------------------------------------------------------------
-- clock_process: This initilized start state 
------------------------------------------------------------------------------------------------
    clock_process :process(clock, reset)
          begin
          if(reset = '1') then
          -- after reset initial the start state
            frequency_current_state <= A;
            pwm_current_state <= toggle;
          elsif(clock'event and clock = '1')then
          -- keep looping updated states
            frequency_current_state <= frequency_next_state;
            pwm_current_state <= pwm_next_state;
          end if;
    end process clock_process;
------------------------------------------------------------------------------------------------
-- switch: This store the 16 bit and 8 bit value to register whenever the buttons are pushed 
------------------------------------------------------------------------------------------------
    switch :process(debounce_in(0))
    begin
        if(clock'event and clock = '1')then
            if(button_in(0)='1')then
                data_out <= data_in;
            end if;
            if(button_in(1) = '1')then
                duty_out <= duty_in;
            end if;
        end if;
    end process switch;
------------------------------------------------------------------------------------------------
-- frequency: This process assigns a state to each different clock rate 
------------------------------------------------------------------------------------------------   
    frequency:process(debounce_in(0), frequency_current_state)
           begin
           case frequency_current_state is
           when A => -- defined state A
                if(debounce_in(0) = '1') then
                    frequencey_state_out <= "01";
                    frequency_next_state <= B;
                else
                    frequencey_state_out <= "00";
                    frequency_next_state <= A;
                end if;
           when B => -- defined state B
                if(debounce_in(0) = '1')then
                    frequencey_state_out <= "11";
                    frequency_next_state <= C;
                else
                    frequencey_state_out <= "01";
                    frequency_next_state <= B;
                end if;
           when C => -- defined state C
                if(debounce_in(0) = '1')then
                   frequencey_state_out <= "00";
                   frequency_next_state <= A;
                else
                   frequencey_state_out <= "11";
                   frequency_next_state <= C;
                end if;
           end case;
       end process frequency;
------------------------------------------------------------------------------------------------
-- pwm_mode: This process assigns a state to each different PWM mode 
------------------------------------------------------------------------------------------------      
       pwm_mode :process(debounce_in(1), pwm_current_state)
            begin
            case pwm_current_state is
            when toggle => -- defined toggle mode state
                 if(debounce_in(1) = '1')then
                    pwm_state_out <= "11";
                    pwm_next_state <= low;
                 else
                    pwm_state_out <= "00";
                    pwm_next_state <= toggle;
                 end if;
            when high => -- defined assert high mode state
                 if(debounce_in(1) = '1')then
                     pwm_state_out <= "00";
                     pwm_next_state <= toggle;
                 else
                     pwm_state_out <= "10";
                     pwm_next_state <= high;
                 end if;
            when low => -- defined assert low mode state
                 if(debounce_in(1) = '1')then
                     pwm_state_out <= "10";
                     pwm_next_state <= high;
                 else
                     pwm_state_out <= "11";
                     pwm_next_state <= low;
                 end if;
             end case;
        end process pwm_mode;

end Behavioral;
