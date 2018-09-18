----------------------------------------------------------------------------------
-- Author: Suhao Zhang 65353853  John He 44056699
-- 
-- Create Date: 22/03/2018 
-- Revision History: 15/05/2018 
-- Module Name: clock_divider - Behavioral
-- Project Name: ENEL 373 Project
-- Description: The clock divider provide three different clock rate output signals
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity my_divider is
    Port ( Clk_in : in  STD_LOGIC;
           Clk_out2k : out  STD_LOGIC;
           Clk_out1k : out  STD_LOGIC;
           Clk_out5k : out  STD_LOGIC;
           LED_ON :out STD_LOGIC;
           Clk_out5 : out  STD_LOGIC);
	
end my_divider;

architecture Behavioral of my_divider is

constant limit_2k : std_logic_vector(15 downto 0) := X"61A8"; -- 2k HZ frequency (max frequency / desired frequency / 2)
constant limit_1k : std_logic_vector(15 downto 0) := X"C350"; -- 1k HZ frequency
constant limit_5k : std_logic_vector(15 downto 0) := X"2710"; -- 5k HZ frequency
constant limit_Led : std_logic_vector(23 downto 0) := X"989680"; -- 5 HZ frequency for LED

signal clk_ctr_2k : std_logic_vector(15 downto 0);
signal clk_ctr_1k : std_logic_vector(15 downto 0);
signal clk_ctr_5k : std_logic_vector(15 downto 0);
signal clk_ctr_Led : std_logic_vector(23 downto 0);

signal temp_clk_2k : std_logic;
signal temp_clk_1k : std_logic;
signal temp_clk_5k : std_logic;
signal temp_clk_Led : std_logic;
begin
------------------------------------------------------------------------------------------------
-- clock_LED: This process divides clock frequency down to 5 HZ for LED output signal 
------------------------------------------------------------------------------------------------
 clock_LED: process (Clk_in)   
 begin
    if Clk_in = '1' and Clk_in'Event then
    -- process clock divider            
       if clk_ctr_Led = limit_Led then
          temp_clk_Led <= not temp_clk_Led;          -- toggle      
          clk_ctr_Led <= X"000000";                    
       else                                
          clk_ctr_Led <= clk_ctr_Led + X"000001";    --  counter = counter + 1
       end if;
    end if;
 end process clock_LED;
------------------------------------------------------------------------------------------------
-- clock_2k: This process divides clock frquency down to 2k HZ  
------------------------------------------------------------------------------------------------
 clock_2k: process (Clk_in)
  begin
     if Clk_in = '1' and Clk_in'Event then
     -- process clock divider
        if clk_ctr_2k = limit_2k then
           temp_clk_2k <= not temp_clk_2k;        -- toggle         
           clk_ctr_2k <= X"0000";                    
        else                                
           clk_ctr_2k <= clk_ctr_2k + X"0001";    --  counter = counter + 1
        end if;
     end if;
  end process clock_2k;
------------------------------------------------------------------------------------------------
-- clock_1k: This process divided clock frquency down to 1k HZ  
------------------------------------------------------------------------------------------------
  clock_1k: process (Clk_in)
 begin
    if Clk_in = '1' and Clk_in'Event then
    -- process clock divider
       if clk_ctr_1k = limit_1k then
          temp_clk_1k <= not temp_clk_1k;        -- toggle        
          clk_ctr_1k <= X"0000";                    
       else                                
          clk_ctr_1k <= clk_ctr_1k + X"0001";    --  counter = counter + 1
       end if;
    end if;
 end process clock_1k;
------------------------------------------------------------------------------------------------
-- clock_5k: This process divided clock frquency down to 5k HZ  
------------------------------------------------------------------------------------------------
  clock_5k: process (Clk_in)
 begin
    if Clk_in = '1' and Clk_in'Event then
    -- process clock divider
       if clk_ctr_5k = limit_5k then
          temp_clk_5k <= not temp_clk_5k;        -- toggle        
          clk_ctr_5k <= X"0000";                    
       else                                
          clk_ctr_5k <= clk_ctr_5k + X"0001";    --  counter = counter + 1
       end if;
    end if;
 end process clock_5k;

 Clk_out2k <= temp_clk_2k;  -- output 2k HZ clock signal
 Clk_out1k <= temp_clk_1k;  -- output 1k HZ clock signal
 Clk_out5k <= temp_clk_5k;	-- output 5k HZ clock signal
 Clk_out5 <= temp_clk_Led;  -- output 5 HZ clock signal for LED
 LED_ON <= temp_clk_Led;    -- output 5 HZ clock signal to JA pin 2 for observe 
end Behavioral;