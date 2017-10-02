----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/02/2017 09:25:30 PM
-- Design Name: 
-- Module Name: test_programcounter - Behavioral
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

entity test_programcounter is
--  Port ( );
end test_programcounter;


architecture test_programcounter_behavioral of test_programcounter is

    component programcounter
        port ( CLK   : in std_logic;
               RESET : in std_logic;
               WE_PC : in std_logic;
               PC_IN : in std_logic_vector (31 downto 0);
               PC    : out std_logic_vector (31 downto 0) := (others => '0'));
    end component;

    signal t_CLK   : std_logic;
    signal t_RESET : std_logic;
    signal t_WE_PC : std_logic;
    signal t_PC_IN : std_logic_vector (31 downto 0);
    signal t_PC    : std_logic_vector (31 downto 0) := (others => '0');

    constant ClkPeriod : time := 1 ns; 

begin

    test_programcounter_module : ProgramCounter
    port map (
        -- Inputs
        CLK   => t_CLK,
        RESET => t_RESET,
        WE_PC => t_WE_PC,
        PC_IN => t_PC_IN,
        -- Outputs
        PC    => t_PC
    );

    -- Clock generation
    clk_process: process begin
        t_CLK <= '1';
        wait for ClkPeriod / 2;  --for 0.5 ns signal is '1'.
        t_CLK <= '0';
        wait for ClkPeriod / 2;  --for next 0.5 ns signal is '0'.
    end process;

    stim_proc : process begin
        -- Set initial value for inputs
        t_RESET <= '0'; t_WE_PC <= '0'; t_PC_IN <= (others => '0');
        -- Inputs will be changed and checked between clock edges to avoid indeterminate behaviour at the edge
        -- Each test case will start at x.5 ns, where x is 0, 1, 2... This is to keep track of where the clock is
        -- since some of the tests will be using the clock
        wait for ClkPeriod / 2;
               
        -- Before time = ClkPeriod, some signals may be U or X. That is expected, as the processor is only reset
        -- at the first clock edge, and this is when the PC is set to 0. Before this, PC is indeterminate.
               
        -- RESET = 1 to set PC to 0
        t_RESET <= '1'; 
        wait for ClkPeriod;
        
        -- Test case 1: RESET = 1, WE_PC = 0
        -- PC_IN = x"00000000"
        assert (t_PC = x"00000000") report "Failed Program Counter Test Case 1" severity error;
       
        -- Test case 2: RESET = 0, WE_PC = 1
        -- PC_IN = x"00000004"
        t_RESET <= '0'; t_WE_PC <= '1'; t_PC_IN <= x"00000004";  
        wait for ClkPeriod * 9 / 10;
        assert (t_PC = x"00000004") report "Failed Program Counter Test Case 2" severity error;
   
        wait;
        
    end process;

end test_programcounter_behavioral;