    library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.STD_LOGIC_ARITH.ALL;
    use IEEE.STD_LOGIC_UNSIGNED.ALL;
    entity write is
        Port ( sclk : out std_logic;
        clk: in std_logic;
        sdata : in std_logic;
        addra : out std_logic_vector (14 downto 0);
        dina : out std_logic_vector (15 downto 0);
        wea : out std_logic_vector (0 downto 0);
        cs: out std_logic;
        done_ADC : out std_logic);
    end write;
    architecture Behavioral of write is
        component sclk_1 is
        Port ( clk : in std_logic;
        sclk: out std_logic;
        cs: out std_logic);
        end component sclk_1;
        signal signal_dina : std_logic_vector (15 downto 0) :=
        "0100101011101100";
        --signal signal_dina : std_logic_vector (15 downto 0) :=
        --"0000000000000000";
        signal signal_addra : std_logic_vector (14 downto 0) :=
        "000000000000001";
        signal signal_sclk : std_logic := '0';
        signal signal_cs : std_logic := '1'; --idle
        signal count : integer range 0 to 1000000000 := 15;
        signal sdata_signal : std_logic;
        signal check: std_logic := '0';
        --signal count2 : integer range 0 to 1000000000 := 0;
        --signal sdata: std_logic := '0';
        begin
        uu0: component sclk_1
        port map (clk => clk, sclk => signal_sclk , cs => signal_cs );
        process (signal_sclk, signal_addra, signal_cs)
            begin
            if rising_edge (signal_sclk) then
                if (signal_addra < "11111010000001") then
                
                         done_ADC <= '0';
                    if (signal_cs = '0') then --cs=0 - ADC sends data
                        wea <= "0";
                        --Datayý okuma (16 bit doldurma)
                    if (count = 0) then
                    if (check='0') then
                    signal_addra <= signal_addra + "000000000000001";
                    check <= '1';
                end if;
                
                else
                    signal_dina(count-1) <= sdata_signal;
                    count <= count - 1;
                end if;
                
                elsif (signal_cs = '1') then --idle state/RAMe yazma
                    wea <= "1";
                    count <= 15;
                    check <= '0';
                end if;
                else --address dolduysa
                    wea <= "0";
                    done_ADC <= '1';
                end if;
            end if;
        end process;
        dina <= signal_dina;
        addra <= signal_addra;
        sclk <= signal_sclk;
        cs <= signal_cs;
        sdata_signal <= sdata;
    end Behavioral;
    --end of write module