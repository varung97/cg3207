library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity HazardUnit is
port(
    RA1E : in std_logic_vector(3 downto 0);
    RA2E : in std_logic_vector(3 downto 0);
    RA3E : in std_logic_vector(3 downto 0);
    WA4M : in std_logic_vector(3 downto 0);
    WA4W : in std_logic_vector(3 downto 0);
    RegWriteM : in std_logic;
    RegWriteW : in std_logic;
    ALUResultM : in std_logic_vector(31 downto 0);
    ResultW : in std_logic_vector(31 downto 0);
    ToForwardD1E : out std_logic;
    ToForwardD2E : out std_logic;
    ToForwardD3E : out std_logic;
    ForwardD1E : out std_logic_vector(31 downto 0);
    ForwardD2E : out std_logic_vector(31 downto 0);
    ForwardD3E : out std_logic_vector(31 downto 0)
);
end HazardUnit;

architecture Hazard_arch of HazardUnit is
    signal Match1EM : std_logic;
    signal Match1EW : std_logic;

    signal Match2EM : std_logic;
    signal Match2EW : std_logic;

    signal Match3EM : std_logic;
    signal Match3EW : std_logic;
begin
    Match1EM <= '1' when (RA1E = WA4M and RegWriteM = '1') else '0';
    Match1EW <= '1' when (RA1E = WA4W and RegWriteW = '1') else '0';

    Match2EM <= '1' when (RA2E = WA4M and RegWriteM = '1') else '0';
    Match2EW <= '1' when (RA2E = WA4W and RegWriteW = '1') else '0';

    Match3EM <= '1' when (RA3E = WA4M and RegWriteM = '1') else '0';
    Match3EW <= '1' when (RA3E = WA4W and RegWriteW = '1') else '0';

    ToForwardD1E <= Match1EM or Match1EW;
    ForwardD1E <= ALUResultM when Match1EM = '1' else ResultW;

    ToForwardD2E <= Match2EM or Match2EW;
    ForwardD2E <= ALUResultM when Match2EM = '1' else ResultW;

    ToForwardD3E <= Match3EM or Match3EW;
    ForwardD3E <= ALUResultM when Match3EM = '1' else ResultW;
end Hazard_arch;
