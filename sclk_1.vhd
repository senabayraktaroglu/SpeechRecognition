library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity sclk_1 is
Port ( clk : in std_logic;
sclk : out std_logic;
cs : out std_logic);
end sclk_1;
--10Mhz
architecture behavioral of sclk_1 is

signal temp: STD_LOGIC :='0';
signal temp2: STD_LOGIC := '1';
signal count: integer range 0 to 49999999 := 0;
signal count2: integer range 0 to 49999999 := 0;
signal sclk_sig : STD_LOGIC;

begin
process (clk) begin
if rising_edge(clk) then
if (count = 4) then
temp <= not(temp);
count <= 0;
else
count <= count + 1;
end if;
end if;
end process;
process (temp)
begin
if falling_edge(temp) then
if(temp2 = '0') then
if (count2 = 16) then
temp2 <= '1';
count2 <= 0;
else
count2 <= count2 + 1;
end if;
elsif (temp2 = '1') then
if (count2 = 609) then
temp2 <= '0';
count2 <= 0;
else
count2 <= count2 +1;
end if;
end if;
end if;
end process;
cs <= temp2;
sclk <= temp;

end Behavioral;
