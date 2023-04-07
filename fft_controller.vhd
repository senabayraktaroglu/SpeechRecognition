library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMeric_std.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fft_controller is
Port (aclk : IN STD_LOGIC;
      aresetn : out STD_LOGIC;
      s_axis_config_tdata : out STD_LOGIC_VECTOR(7 DOWNTO 0);
      s_axis_config_tvalid : out STD_LOGIC;
      s_axis_config_tready : in STD_LOGIC;
      s_axis_data_tdata : out STD_LOGIC_VECTOR(31 DOWNTO 0);
      s_axis_data_tvalid : out STD_LOGIC;
      s_axis_data_tready : in STD_LOGIC;
      s_axis_data_tlast : out STD_LOGIC;
      m_axis_data_tdata : in STD_LOGIC_VECTOR(63 DOWNTO 0);
      m_axis_data_tvalid : in STD_LOGIC;
      m_axis_data_tlast : in STD_LOGIC;
      event_frame_started : in STD_LOGIC;
      event_tlast_unexpected : in STD_LOGIC;
      event_tlast_missing : in STD_LOGIC;
      event_data_in_channel_halt : in STD_LOGIC;
      framestart: out std_logic;
      s_trdy : out std_logic;
      addra: out std_logic_vector(14 downto 0); --RAM-A
      dina: out std_logic_vector(15 downto 0); --RAM-A
      done_fft: out std_logic; --UART&RAM
      wea: out std_logic_vector(0 downto 0); --RAM
      address: out std_logic_vector(14 downto 0); --SINUS ROM
      data: in std_logic_vector(15 downto 0);
      done_hamming: in std_logic ); --SINUS-ROM
end fft_controller;

architecture Behavioral of fft_controller is
--inputs of this module

--inputs of FFT / outputs of this module
signal aresetn_signal : std_logic := '1';
signal s_axis_config_tdata_signal : std_logic_vector(7 downto 0) := "00000001";
signal s_axis_config_tvalid_signal :std_logic := '1';
signal s_axis_data_tdata_signal: std_logic_vector(31 downto 0);
signal s_axis_data_tvalid_signal:std_logic:='1';
signal s_axis_data_tlast_signal: std_logic;
signal framestart_signal : std_logic:='0';
signal s_trdy_signal : std_logic := '0';
signal count: integer range 0 to 5000 := 0;

signal check : std_logic:='0';
signal check1 : std_logic:='0';

signal addra_signal : std_logic_vector(14 downto 0) := "000000000000001";
signal rom_address: std_logic_vector(14 downto 0) := "000000000000001";

signal imag_signal: std_logic_vector(25 downto 0);
signal real_signal: std_logic_vector(25 downto 0);
signal i2: std_logic_vector(51 downto 0);
signal r2: std_logic_vector(51 downto 0);
signal i16: std_logic_vector(51 downto 0);
signal r16: std_logic_vector(15 downto 0);




begin


process (aclk) 
begin
    if (rising_edge (aclk)) then
    
        --------------------------
--        if ( m_axis_data_tlast = '1') then
--            s_trdy_signal <= '1';
--        end if;
        
--        if (event_frame_started = '1') then
--            framestart_signal <= '1';
--        end if;
        ---------------------------

                     
        if (check='0' and done_hamming='1') then --FFT Step
               --load frame
           if (s_axis_data_tready='1') then
              done_fft <= '0';
              s_axis_data_tdata(31 downto 16)<="0000000000000000";
              s_axis_data_tdata(15 downto 0)<= data;
              
              if (rom_address< "111111000000000") then
                rom_address<=rom_address + "000000000000001";
              end if;
               
           --unload frame
           elsif ( m_axis_data_tvalid = '1') then
                real_signal <= not (m_axis_data_tdata(25 downto 0)) + "00000000000000000000000001" ;
                imag_signal <= not (m_axis_data_tdata(57 downto 32)) + "00000000000000000000000001" ;
                if (addra_signal < "111111000000000") then
                    addra_signal <= addra_signal + "000000000000001";
                    wea<="1";
                    dina <= real_signal(25 downto 10);
                else
                    check<='1';
                    done_fft <= '1';
                    framestart_signal <= '1';
                end if;
         
           end if;  

       end if; --check     
    end if; --rising_edge clk
end process;    

aresetn <= aresetn_signal;
s_axis_config_tdata <= s_axis_config_tdata_signal;
s_axis_config_tvalid <= s_axis_config_tvalid_signal;
--s_axis_data_tdata <= s_axis_data_tdata_signal;
s_axis_data_tvalid <= s_axis_data_tvalid_signal;
s_axis_data_tlast <= s_axis_data_tlast_signal;
framestart <= framestart_signal;
s_trdy <= s_trdy_signal;
addra<=addra_signal;
address <= rom_address;

end Behavioral;