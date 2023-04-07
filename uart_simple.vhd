library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity uart_simple is
Port (
I_clk : in STD_LOGIC;
I_clk_baud_count : in STD_LOGIC_VECTOR (15 downto 0) :=
"0010100010110000";
I_reset : in STD_LOGIC;

--I_txData : in STD_LOGIC_VECTOR (7 downto 0);
doutb: in std_logic_vector (15 downto 0);
addrb: out std_logic_vector (14 downto 0);

I_txSig : in STD_LOGIC;
O_txRdy : out STD_LOGIC;
O_tx : out STD_LOGIC
-- Done: out std_logic
);
end uart_simple;
architecture Behavioral of uart_simple is
    --signal tx_data : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal tx_data : STD_LOGIC_VECTOR(7 downto 0);
    signal tx_state: integer := 0;
    signal tx_rdy : STD_LOGIC := '1';
    signal tx: STD_LOGIC;
    signal ram_addr: std_logic_vector(14 downto 0) := "000000000000001";
    signal datain: std_logic_vector(15 downto 0);
    -- signal done_signal: std_logic := '1';
    signal tx_clk_counter : integer := 0;
    signal tx_clk : STD_LOGIC := '0';
    constant OFFSET_START_BIT: integer := 7;
    constant OFFSET_DATA_BITS: integer := 15;
    constant OFFSET_STOP_BIT: integer := 7;
    signal check: std_logic:= '0';
    begin
    clk_gen: process (I_clk)
    begin
    if rising_edge(I_clk) then
    -- TX standard baud clock, no reset
    if tx_clk_counter = 0 then
    -- chop off LSB to get a clock
    tx_clk_counter <= to_integer(unsigned(I_clk_baud_count(15 downto
    1)));
    tx_clk <= not tx_clk;
    else
    tx_clk_counter <= tx_clk_counter - 1;
    end if;
    
    end if;
    end process;
    O_tx <= tx;
    O_txRdy <= tx_rdy;
    datain <= doutb;
    --datain <= "11001101";
    addrb <= ram_addr;
    --done <= done_signal;
    tx_proc: process (tx_clk, I_reset, I_txSig, tx_state)
    begin
        -- TX runs off the TX baud clock
        if rising_edge(tx_clk) then
        if I_reset = '1' then
        tx_state <= 0;
        tx_data <= X"00";
        tx_rdy <= '1';
        tx <= '1';
        else
        if (ram_addr < "111111000000001" and I_txSig = '1') then
        if tx_state = 0 and I_txSig = '1' then
        tx_state <= 1;
        --tx_data<=datain;
        if (check='0') then --MSByte
        tx_data <= datain(15 downto 8);
        elsif (check='1') then --LSByte
        tx_data<= datain(7 downto 0);
        end if;
        tx_rdy <= '0';
        tx <= '0'; -- start bit
        elsif tx_state < 9 and tx_rdy = '0' then
        tx <= tx_data(0);
        tx_data <= '0' & tx_data (7 downto 1);
        tx_state <= tx_state + 1;
        elsif tx_state = 9 and tx_rdy = '0' then
        tx <= '1'; -- stop bit
        tx_rdy <= '1';
        tx_state <= 0;
        if check='1' then
        ram_addr <= ram_addr + "000000000000001";
        end if;
        check <= not (check);
        end if;
        -- else --RAM is full
        --tx_rdy <= '1';
        --done_signal <= '0';
        end if;
        
        end if;
        end if;
    end process;
end Behavioral;