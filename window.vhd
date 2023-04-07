library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMeric_std.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity window is
Port( wea : out std_logic_vector (0 downto 0);
      addrb : out std_logic_vector(14 downto 0);
      dinb : in std_logic_vector (15 downto 0);
      hamming_index : out integer range 0 to 511;
      hamming_value : in std_logic_vector (15 downto 0);
      addrout : out std_logic_vector(14 downto 0);
      dout : out std_logic_vector(15 downto 0);
      clk : in std_logic;
      done : in std_logic;
      done_hamming : out std_logic);
end window;

architecture Behavioral of window is

signal addrb_signal : std_logic_vector (14 downto 0) := "000000000000001";
signal addrout_signal : std_logic_vector(14 downto 0) := "000000000000000";
signal addr_count : std_logic_vector(14 downto 0) := "000000000000000";
signal hamming_index_signal : integer range 0 to 511 := 0;

signal j : integer range 0 to 16385 := 257;
signal i : integer range 0 to 513 := 0;
signal index : integer range 0 to 16385 := 0;

signal count63 : std_logic_vector(14 downto 0):= "000000000000000";
signal count512 : integer range 0 to 513 := 0;

signal out16 : std_logic_vector(15 downto 0);
signal out32 : std_logic_vector(31 downto 0);
signal first_frame_done : std_logic:= '0';
signal count: integer range 0 to 5000 := 0;
signal frame: integer range 0 to 4 := 1; --frame number
signal done_hamming_sig: std_logic := '0';

signal bufferr : std_logic_vector(23 downto 0);


begin

process (clk)
begin
if (rising_edge (clk)) then
    if (done='1') then
     
        if (count63 <"000000001000000") then
                wea <= "1"; 
            if (count512 < 512) then
                addrb_signal <= addrb_signal +  "000000000000001";
                addrout_signal<=addrout_signal +  "000000000000001";
                count512 <= count512 +1;
                
                hamming_index_signal<=hamming_index_signal+1;
                out32 <= hamming_value*dinb;
                out16<=out32(31 downto 16);
                
           else
                count63 <= count63 + "000000000000001";
                count512 <= 0;
                hamming_index_signal <= 0;
                bufferr <= ("100000000" * count63 ) - "00000011111111";
                addrb_signal<=bufferr(14 downto 0); 
           end if;
           
        else
        
         wea <= "0";  
         done_hamming_sig <= '1'; 
        end if; --count63
        
    end if; --done
end if; -- rising edge
end process;

addrb <= addrb_signal;
hamming_index <= hamming_index_signal;
addrout <= addrout_signal;
dout <= out16;
done_hamming <= done_hamming_sig;

end Behavioral;