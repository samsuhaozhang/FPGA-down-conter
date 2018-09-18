----------------------------------------------------------------------------------
-- Author: Suhao Zhang 65353853  John He 44056699
-- 
-- Create Date: 22/05/2018 
-- Revision History: 25/05/2018 
-- Module Name: FSM Testbench - Behavioral
-- Project Name: ENEL 373 Project
-- Description: The testbech is used to test the Finite state machine 
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

entity tb_FSM is
end tb_FSM;

architecture tb of tb_FSM is

component FSM
    port (debounce_in          : in std_logic_vector (1 downto 0);
          button_in            : in std_logic_vector (1 downto 0);
          data_in              : in std_logic_vector (15 downto 0);
          duty_in              : in std_logic_vector (7 downto 0);
          clock                : in std_logic;
          reset                : in std_logic;
          data_out             : out std_logic_vector (15 downto 0);
          duty_out             : out std_logic_vector (7 downto 0);
          frequencey_state_out : out std_logic_vector (1 downto 0);
          pwm_state_out        : out std_logic_vector (1 downto 0));
end component;
--input
signal debounce_in          : std_logic_vector (1 downto 0);
signal button_in            : std_logic_vector (1 downto 0);
signal data_in              : std_logic_vector (15 downto 0);
signal duty_in              : std_logic_vector (7 downto 0);
signal clock                : std_logic;
signal reset                : std_logic;
--output
signal data_out             : std_logic_vector (15 downto 0);
signal duty_out             : std_logic_vector (7 downto 0);
signal frequencey_state_out : std_logic_vector (1 downto 0);
signal pwm_state_out        : std_logic_vector (1 downto 0);
-- initialization
constant TbPeriod : time := 50 ns; -- time period
signal TbClock : std_logic := '0';
signal TbSimEnded : std_logic := '0';

begin
uut : FSM
port map (debounce_in          => debounce_in,
          button_in            => button_in,
          data_in              => data_in,
          duty_in              => duty_in,
          clock                => clock,
          reset                => reset,
          data_out             => data_out,
          duty_out             => duty_out,
          frequencey_state_out => frequencey_state_out,
          pwm_state_out        => pwm_state_out);

    clock_process : process
    begin
        
        reset <= '1';
        wait for 100 ns;
        reset <= '0';
        wait for 100 ns;
        clock <= '0';
        wait for TbPeriod / 2;
        clock <= '1';
        wait for TbPeriod / 2;
    end process;
    
    state_process : process
    begin
        wait for 100 ns;
        debounce_in(0) <= '1';
        wait for 100 ns;
        debounce_in(0) <= '0';
        wait for 100 ns;
        debounce_in(1) <= '1';
        wait for 100 ns;
        debounce_in(1) <= '0';
        wait for 100 ns;
        button_in(0) <= '1';
        wait for 100 ns;
        button_in(0) <= '0';
        wait for 100 ns;
        --input different value
        data_in <= X"8000";
        wait for 100 ns;
        wait for 100 ns;
        button_in(0) <= '1';
        wait for 100 ns;
        button_in(0) <= '0';
        wait for 100 ns;
        button_in(1) <= '1';
        wait for 100 ns;
        button_in(1) <= '0';       
        wait;
    end process;

end tb;
