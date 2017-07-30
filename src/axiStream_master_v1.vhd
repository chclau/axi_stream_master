------------------------------------------------------------------
-- Name		   : axiStream_master_v1.vhd
-- Description : Simple AXI Stream mater implementation for tutorial
-- Designed by : Claudio Avi Chami - FPGA Site
--               fpgasite.blogspot.com
-- Date        : 26/07/2016
-- Version     : 01
------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AXIStream_Master_v1 is
   port (      
      start          : in std_logic;                        -- Low to high on this input starts an axi_stream transaction

      -- axi stream ports
      m_axis_clk	   : in  std_logic;
		m_axis_tvalid	: out std_logic;
		m_axis_tdata	: out std_logic_vector(31 downto 0);
		m_axis_tstrb	: out std_logic_vector(3 downto 0);
		m_axis_tlast	: out std_logic  
	);
end AXIStream_Master_v1;

architecture rtl of AXIStream_Master_v1 is
	                             
	constant PACKET_LEN : natural :=  8;
	constant PACKET_W   : natural :=  4;
	                                                                                  
	-- Define the states of state machine                                             
	type    state is (IDLE, SEND_STREAM);          
	signal  sm_state : state := IDLE;                                                   

	-- AXI Stream internal signals
	signal tvalid	        : std_logic := '0';
	signal tlast	        : std_logic := '0';   
   signal data        	  : unsigned(31 downto 0) := (others => '0');
   signal packet_len_cnt : unsigned(PACKET_W-1 downto 0)  := (others => '0');

begin

	-- I/O Connections assignments
   m_axis_tstrb   <= (others => '1');     -- byte enables always high
   m_axis_tvalid  <= tvalid;
   m_axis_tlast   <= tlast;
   data(PACKET_W-1 downto 0)  <= packet_len_cnt; 
   m_axis_tdata   <= std_logic_vector(data);
   
	-- Control state machine implementation                                               
	sm_pr : process(m_axis_clk)                                                                        
	begin                                                                                       
      if (rising_edge (m_axis_clk)) then                                                       
         case (sm_state) is                                                              
            when IDLE =>
               tvalid            <= '0';
               tlast             <= '0';
               packet_len_cnt    <= (others => '0');      
          
               -- start sending 
               if (start = '1') then
                  sm_state <= SEND_STREAM;  
               end if;                                                                                                       

            when SEND_STREAM  =>   
               tvalid            <= '1';               
               packet_len_cnt    <= packet_len_cnt + 1;
               if (packet_len_cnt = PACKET_LEN-1 ) then
                  tlast           <= '1';
                  sm_state        <= IDLE;
               end if;            	                                                                                           
            when others =>                                                                   
               sm_state <= IDLE;                                                           
	                                                                                            
	     end case;                                                                             
	   end if;                                                                                 
	end process sm_pr;                                                                                
end rtl;
