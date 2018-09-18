----------------------------------------------------------------------------------
-- Author: Suhao Zhang 65353853  John He 44056699
-- 
-- Create Date: 22/03/2018 
-- Revision History: 15/05/2018 
-- Module Name: top_level_wrapper - Behavioral
-- Project Name: ENEL 373 Project
-- Description: The top level wrapper for producing 16-bit down-counter
-- Additional Comments: This reqires the use of 7 components: clock divider, button debounce, 
-- finite state machine, register, multiplexer, counter and pwm generator.
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

entity top_level_wrapper is
    Port ( CLK100MHZ : in STD_LOGIC;
           SW : in STD_LOGIC_VECTOR (15 downto 0);
           BTNC : in STD_LOGIC;
           BTNL : in STD_LOGIC;
           BTNR : in STD_LOGIC;
           BTNU : in STD_LOGIC;
           LED : out STD_LOGIC_VECTOR (15 downto 0);
           JA : out STD_LOGIC_VECTOR (3 downto 1);
           LED17_G : out STD_LOGIC;
           LED16_G : out STD_LOGIC;
           LED17_R : out STD_LOGIC;
           LED16_B : out STD_LOGIC);
end top_level_wrapper;

architecture Behavioral of top_level_wrapper is
------------------------------------------------------------------------------------------------
-- Clock divider: Divides the 100MHZ frequency clock down to 1kHZ, 2kHZ and 5kHZ clocks and then outputed to FSM 
------------------------------------------------------------------------------------------------
component my_divider
    Port ( Clk_in : in  STD_LOGIC;
           Clk_out2k : out  STD_LOGIC;
           Clk_out1k : out  STD_LOGIC;
           Clk_out5k : out  STD_LOGIC;
           LED_ON :out STD_LOGIC;
           Clk_out5 : out  STD_LOGIC);
    end component;
------------------------------------------------------------------------------------------------
-- Debounce: Ihis process is used to debounce to ensure clean the input buttons signal.
------------------------------------------------------------------------------------------------
component debounce is
    Port ( button_in : in STD_LOGIC_VECTOR(1 downto 0);
           clk : in STD_LOGIC;
           debounce_out : out STD_LOGIC_VECTOR(1 downto 0));
    end component;
------------------------------------------------------------------------------------------------
-- FSM: This process used to control all the different clock ouputs. State changed depends on the 
--push buttons then output to muiltipxer and counter
------------------------------------------------------------------------------------------------      
component FSM is
    Port ( debounce_in : in STD_LOGIC_VECTOR(1 downto 0);
           button_in : in STD_LOGIC_VECTOR(1 downto 0);
           data_in : in STD_LOGIC_VECTOR(15 downto 0);
           duty_in : in STD_LOGIC_VECTOR(7 downto 0);
           clock,reset : in STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR(15 downto 0);
           duty_out : out STD_LOGIC_VECTOR(7 downto 0);
           frequencey_state_out, pwm_state_out: out STD_LOGIC_VECTOR(1 downto 0));
    end component;
------------------------------------------------------------------------------------------------
-- Multiplexer: This process selects particular inputs and registers depending on its state and 
--then outptuts the signal.
------------------------------------------------------------------------------------------------
component multiplexer
    Port ( state : in STD_LOGIC_VECTOR(1 downto 0);
           Frequency_in : in STD_LOGIC_VECTOR (2 downto 0);
           Frequency_out : out STD_LOGIC);
    end component;
------------------------------------------------------------------------------------------------
-- Regisiter: This is used to store 16 bit switch data and 8 bit data inputs
------------------------------------------------------------------------------------------------ 
component my_register
    Port ( data_in : in STD_LOGIC_VECTOR (15 downto 0);
           duty_in : in STD_LOGIC_VECTOR (7 downto 0);
           clk, reset :in STD_LOGIC;
           duty_out : out STD_LOGIC_VECTOR (7 downto 0);
           data_out : out STD_LOGIC_VECTOR (15 downto 0));
    end component;
------------------------------------------------------------------------------------------------
-- Down counter: counting down the input 16 bit value and output signals
------------------------------------------------------------------------------------------------    
component sixteen_bit_counter
    Port ( clk, reset : in STD_LOGIC;
           number : in STD_LOGIC_VECTOR (15 downto 0);
           LED_OUT : out STD_LOGIC;
           number_out : out STD_LOGIC_VECTOR (15 downto 0);
           q_count : out STD_LOGIC);
    end component;
------------------------------------------------------------------------------------------------
-- PWM: generating three different PWM signals with varying duty cycle and period 
------------------------------------------------------------------------------------------------
component my_PWM
    Port ( clk_in : in STD_LOGIC;
           enable : in STD_LOGIC_VECTOR(1 downto 0);
           duty_cycle : in STD_LOGIC_VECTOR (7 downto 0);
           period : in STD_LOGIC_VECTOR (15 downto 0);
           pwm_out : out STD_LOGIC);
    end component;
-- The wire connect in between clock divider and multiplexer   
signal divider_to_mul_0: std_logic; 
signal divider_to_mul_1: std_logic;
signal divider_to_mul_2: std_logic;
-- The wire connect in between button debounce and FSM 
signal debounce_to_FSM : std_logic_vector(1 downto 0);
-- The wire connect in between FSM and multiplexer 
signal state_to_mul : std_logic_vector(1 downto 0);
-- The wire connect in between FSM and PWM generater 
signal state_to_mode : std_logic_vector(1 downto 0);
-- The wire connect in between FSM and register 
signal state_to_counter : std_logic_vector(15 downto 0);
signal state_to_pwm : std_logic_vector(7 downto 0);
-- The wire connect in between multiplexer and counter 
signal butn_to_counter: std_logic;
-- The wire connected reset signals
signal re: std_logic;
-- The wire connect in between register and counter/PWM 
signal reg_to_counter: std_logic_vector(15 downto 0);
signal reg_to_pwm: std_logic_vector(7 downto 0);
begin
--Port maps for all components
u1: my_divider
    port map(Clk_in => CLK100MHZ, Clk_out5 => LED16_B, Clk_out2k => divider_to_mul_0,
             Clk_out1k => divider_to_mul_1, Clk_out5k => divider_to_mul_2, LED_ON => JA(2));

u2: debounce
    port map(button_in(0) => BTNR, button_in(1) => BTNU, clk => divider_to_mul_1, debounce_out => debounce_to_FSM);
    
u3: FSM
    port map(debounce_in => debounce_to_FSM, button_in(0) => BTNC, button_in(1) => BTNL, clock => divider_to_mul_1, reset => re, data_in => SW, duty_in => SW(7 downto 0), 
             frequencey_state_out => state_to_mul, pwm_state_out => state_to_mode, data_out => state_to_counter, duty_out => state_to_pwm);
    
u4: multiplexer
    port map(state => state_to_mul, Frequency_in(0) => divider_to_mul_0, Frequency_in(1) => divider_to_mul_1, Frequency_in(2) => divider_to_mul_2,
             Frequency_out => butn_to_counter);
        
u5: my_register
        port map(data_in => state_to_counter, duty_in => state_to_pwm, clk => CLK100MHZ, reset => re, data_out => reg_to_counter,
                 duty_out => reg_to_pwm);

u6: sixteen_bit_counter
    port map(clk => butn_to_counter, reset => re, number => reg_to_counter, q_count => JA(1),
             LED_OUT => LED17_R, number_out => LED);
             
u7: my_PWM
    port map(clk_in=> butn_to_counter, enable => state_to_mode, period => reg_to_counter, duty_cycle => reg_to_pwm, pwm_out => JA(3));
        
end Behavioral;
