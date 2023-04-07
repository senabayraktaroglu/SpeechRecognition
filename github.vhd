    library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    
    entity github is
            Port (
            I_clk : in STD_LOGIC;
            --I_txSig: in STD_LOGIC;
            O_txRdy : out STD_LOGIC;
            O_tx : out STD_LOGIC;
            framestart : out std_logic;
            s_trdy: out std_logic;
            sclk: out std_logic;
            sdata: in std_logic;
            cs: out std_logic;
            sampling: out std_logic);
            
    end github;
    
    architecture Behavioral of github is
        component uart_simple is
        Port (
            I_clk : in STD_LOGIC;
            I_clk_baud_count : in STD_LOGIC_VECTOR (15 downto 0);
            I_reset : in STD_LOGIC;        
            doutb: in std_logic_vector (15 downto 0);
            addrb: out std_logic_vector (14 downto 0);        
            --I_txData : in STD_LOGIC_VECTOR (7 downto 0);
            I_txSig : in STD_LOGIC;
            O_txRdy : out STD_LOGIC;
            O_tx : out STD_LOGIC);
        end component uart_simple;
      
        component blk_mem_gen_0 is
            Port (
                clka : IN STD_LOGIC;
                wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
                addra : IN STD_LOGIC_VECTOR(14 DOWNTO 0);
                dina : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
                clkb : IN STD_LOGIC;
                enb : IN STD_LOGIC;
                addrb : IN STD_LOGIC_VECTOR(14 DOWNTO 0);
                doutb : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) );
        end component blk_mem_gen_0;
        
        component blk_mem_gen_1 is
            Port (
                clka : IN STD_LOGIC;
                wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
                addra : IN STD_LOGIC_VECTOR(14 DOWNTO 0);
                dina : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
                clkb : IN STD_LOGIC;
                enb : IN STD_LOGIC;
                addrb : IN STD_LOGIC_VECTOR(14 DOWNTO 0);
                doutb : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) );
        end component blk_mem_gen_1;
        
         component blk_mem_gen_2 is
            Port (
                clka : IN STD_LOGIC;
                wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
                addra : IN STD_LOGIC_VECTOR(14 DOWNTO 0);
                dina : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
                clkb : IN STD_LOGIC;
                enb : IN STD_LOGIC;
                addrb : IN STD_LOGIC_VECTOR(14 DOWNTO 0);
                doutb : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) );
        end component blk_mem_gen_2;
        
        
        component write is
            Port(
                sclk : out std_logic;
                clk: in std_logic;
                sdata : in std_logic;
                addra : out std_logic_vector (14 downto 0);
                dina : out std_logic_vector (15 downto 0);
                wea : out std_logic_vector (0 downto 0);
                cs: out std_logic;
                done_ADC : out std_logic);
                
        end component write;
                
        component window is
        Port( wea : out std_logic_vector (0 downto 0);
              addrb : out std_logic_vector(14 downto 0);
              dinb : in std_logic_vector (15 downto 0);
              hamming_index : out integer range 0 to 511;
              hamming_value : in std_logic_vector (15 downto 0);
              addrout : out std_logic_vector(14 downto 0);
              dout : out std_logic_vector(15 downto 0);
              clk : in std_logic;
              done : in std_logic;
              done_hamming :  out std_logic );
        end component window;
        
        
        component hamming_rom is
        --  Port ( );
        port(
        clk: in std_logic;
        address: in integer range 0 to 511;
        data: out std_logic_vector(15 downto 0));
        end component hamming_rom;
        
        component xfft_0 is
        PORT (
          aclk : IN STD_LOGIC;
          aresetn : IN STD_LOGIC;
          s_axis_config_tdata : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
          s_axis_config_tvalid : IN STD_LOGIC;
          s_axis_config_tready : OUT STD_LOGIC;
          s_axis_data_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
          s_axis_data_tvalid : IN STD_LOGIC;
          s_axis_data_tready : OUT STD_LOGIC;
          s_axis_data_tlast : IN STD_LOGIC;
          m_axis_data_tdata : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
          m_axis_data_tvalid : OUT STD_LOGIC;
          m_axis_data_tlast : OUT STD_LOGIC;
          event_frame_started : OUT STD_LOGIC;
          event_tlast_unexpected : OUT STD_LOGIC;
          event_tlast_missing : OUT STD_LOGIC;
          event_data_in_channel_halt : OUT STD_LOGIC
        );
        end component xfft_0;
        
        component fft_controller is
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
          addra: out std_logic_vector(14 downto 0);
          dina: out std_logic_vector(15 downto 0);
          done_fft: out std_logic;
          wea: out std_logic_vector(0 downto 0);
          address: out std_logic_vector(14 downto 0); 
          data: in std_logic_vector(15 downto 0);
          done_hamming: in std_logic );
        end component fft_controller;

        
        
        
        --signal I_clk_x: STD_LOGIC;
        signal I_clk_baud_count_x : STD_LOGIC_VECTOR (15 downto 0) :=
        "0010100010110000";
        signal I_reset_x : STD_LOGIC :='0';
        signal addrb_a: std_logic_vector (14 downto 0);
        signal doutb_a: std_logic_vector (15 downto 0);
        --signal I_txSig : STD_LOGIC;
        signal done_ADC : STD_LOGIC;
        --signal O_txRdy_x : STD_LOGIC;
        --signal O_tx_x : STD_LOGIC;
        signal wea_a: std_logic_vector(0 downto 0);
        signal addra_a: std_logic_vector(14 downto 0);
        signal dina_a: std_logic_vector(15 downto 0);
        
        
        signal addrb_h: std_logic_vector (14 downto 0);
        signal doutb_h: std_logic_vector (15 downto 0);
        signal done_hamming : STD_LOGIC;
        signal wea_h: std_logic_vector(0 downto 0);
        signal addra_h: std_logic_vector(14 downto 0);
        signal dina_h: std_logic_vector(15 downto 0);

        signal addrb_f: std_logic_vector (14 downto 0);
        signal doutb_f: std_logic_vector (15 downto 0);
        signal done_fft : STD_LOGIC;
        signal wea_f: std_logic_vector(0 downto 0);
        signal addra_f: std_logic_vector(14 downto 0);
        signal dina_f: std_logic_vector(15 downto 0);        
        
        signal hamming_index : integer range 0 to 511;
        signal hamming_value :  std_logic_vector (15 downto 0);
        
        signal hiclik: std_logic_vector(14 downto 0);
        
        
        --inputs of FFT
        signal aresetn_signal : std_logic := '1';
        signal s_axis_config_tdata_signal : std_logic_vector(7 downto 0) := "00000001";
        signal s_axis_config_tvalid_signal :std_logic := '1';
        signal s_axis_data_tdata_signal: std_logic_vector(31 downto 0);
        signal s_axis_data_tvalid_signal:std_logic:='1';
        signal s_axis_data_tlast_signal: std_logic;
        
        --outputs of FFT
        signal s_axis_config_tready_signal:std_logic;
        signal s_axis_data_tready_signal:std_logic;
        signal  m_axis_data_tdata_signal : std_logic_vector(63 downto 0);
        signal m_axis_data_tvalid_signal : std_logic;
        signal m_axis_data_tlast_signal : std_logic;
        signal event_frame_started_signal: std_logic :='0';
        signal event_tlast_unexpected_signal : std_logic;
        signal event_tlast_missing_signal:std_logic;
        signal event_data_in_channel_halt_signal:std_logic;

        
        
        begin
        sampling<=not(done_ADC);
        
        u0: component uart_simple
        Port map (I_clk => I_clk,
        I_clk_baud_count => I_clk_baud_count_x,
        I_reset => I_reset_x,
        --I_txData => I_txData_x,
        addrb => addrb_h,
        doutb => doutb_h,
        I_txSig => done_fft,
        O_txRdy => O_txRdy,
        O_tx => O_tx);
        
        u1: component blk_mem_gen_0
        Port map (clka => I_clk,
        wea => wea_a,
        addra => addra_a,
        dina => dina_a,
        clkb => I_clk,
        enb => done_ADC,
        addrb => addrb_a,
        doutb => doutb_a);
        
        u2: component write
        Port map (sclk => sclk,
        clk => I_clk,
        sdata => sdata,
        addra => addra_a,
        dina => dina_a,
        wea => wea_a,
        cs => cs,
        done_ADC => done_ADC);
        
        u3: component blk_mem_gen_1
        Port map (clka => I_clk,
        wea => wea_h,
        addra => addra_h,
        dina => dina_h,
        clkb => I_clk,
        enb => done_hamming,
        addrb => addrb_h,
        doutb => doutb_h);
        
        u4: component window 
        Port map (wea => wea_h,
              addrb => addrb_a,
              dinb => doutb_a,
              hamming_index => hamming_index,
              hamming_value  => hamming_value,
              addrout => addra_h,
              dout => dina_h,
              clk => I_clk,
              done => done_ADC,
              done_hamming => done_hamming);
              
        u5: component hamming_rom
        Port map(
            clk => I_clk,
            address => hamming_index,
            data => hamming_value
        );
        
       u6: component blk_mem_gen_2
        Port map (clka => I_clk,
        wea => wea_f,
        addra => addra_f,
        dina => dina_f,
        clkb => I_clk,
        enb => done_fft,
        addrb => addrb_f,
        doutb => doutb_f);
    
    u7: component xfft_0
        Port map ( aclk => I_clk,
                   aresetn => aresetn_signal,
                   s_axis_config_tdata => s_axis_config_tdata_signal,
                   s_axis_config_tvalid => s_axis_config_tvalid_signal,
                   s_axis_config_tready => s_axis_config_tready_signal,
                   s_axis_data_tdata => s_axis_data_tdata_signal,
                   s_axis_data_tvalid =>  s_axis_data_tvalid_signal,
                   s_axis_data_tready => s_axis_data_tready_signal,
                   s_axis_data_tlast => s_axis_data_tlast_signal,
                   m_axis_data_tdata => m_axis_data_tdata_signal,
                   m_axis_data_tvalid => m_axis_data_tvalid_signal,
                   m_axis_data_tlast => m_axis_data_tlast_signal,
                   event_frame_started => event_frame_started_signal,
                   event_tlast_unexpected => event_tlast_unexpected_signal,
                   event_tlast_missing =>  event_tlast_missing_signal,
                   event_data_in_channel_halt => event_data_in_channel_halt_signal);
                    
        u8: component fft_controller
        Port map ( aclk => I_clk,
                   aresetn => aresetn_signal,
                   s_axis_config_tdata => s_axis_config_tdata_signal,
                   s_axis_config_tvalid => s_axis_config_tvalid_signal,
                   s_axis_config_tready => s_axis_config_tready_signal,
                   s_axis_data_tdata => s_axis_data_tdata_signal,
                   s_axis_data_tvalid =>  s_axis_data_tvalid_signal,
                   s_axis_data_tready => s_axis_data_tready_signal,
                   s_axis_data_tlast => s_axis_data_tlast_signal,
                   m_axis_data_tdata => m_axis_data_tdata_signal,
                   m_axis_data_tvalid => m_axis_data_tvalid_signal,
                   m_axis_data_tlast => m_axis_data_tlast_signal,
                   event_frame_started => event_frame_started_signal,
                   event_tlast_unexpected => event_tlast_unexpected_signal,
                   event_tlast_missing =>  event_tlast_missing_signal,
                   event_data_in_channel_halt => event_data_in_channel_halt_signal,
                   framestart => framestart,
                   s_trdy => s_trdy,
                   addra => addra_f,
                   dina => dina_f,
                   done_fft => done_fft,
                   wea => wea_f,
                   --address => addrb_h,
                   address=>hiclik,
                   data => doutb_h,
                   done_hamming => done_hamming);
         
    end Behavioral;