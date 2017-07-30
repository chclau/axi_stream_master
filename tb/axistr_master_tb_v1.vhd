------------------------------------------------------------------
-- Name		   : axistr_master_tb_v1.vhd
-- Description : Testbench for axi stream master V1
-- Designed by : Claudio Avi Chami - FPGA Site
-- Date        : 26/03/2016
-- Version     : 01
------------------------------------------------------------------
library ieee;
   use ieee.std_logic_1164.all;
	use ieee.numeric_std.ALL;
   use ieee.math_real.all;
    
entity axistr_master_tb_v1 is
end entity;

architecture test of axistr_master_tb_v1 is

   constant PERIOD  : time   := 20 ns;
  
	signal endSim    : boolean := false;
   signal clk       : std_logic := '0';
   signal start     : std_logic := '0';
   signal tvalid    : std_logic;

   component AXIStream_Master_v1  is
		port (      
         -- config ports
         start          : in std_logic;                        -- Low to high on this input starts an axi_stream transaction

         -- axi stream ports
         m_axis_clk     : in  std_logic;
         m_axis_tvalid  : out std_logic;
         m_axis_tdata  : out std_logic_vector(31 downto 0);
         m_axis_tstrb  : out std_logic_vector(3 downto 0);
         m_axis_tlast  : out std_logic  
      );
   end component;
    
begin
  clk     <= not clk after PERIOD/2;

	-- Main simulation process
	main_pr : process 
	begin
      wait until (rising_edge(clk));
		wait until (rising_edge(clk));
		wait until (rising_edge(clk));
    
		start	<= '1';
		for i in 0 to 40 loop
  		wait until (rising_edge(clk));
		end loop;
		wait until (rising_edge(clk));
		
		endSim  <= true;
		wait until (rising_edge(clk));

	end process;	
		
	-- End the simulation
	process 
	begin
		if (endSim) then
			assert false 
				report "End of simulation." 
				severity failure; 
		end if;
		wait until (rising_edge(clk));
	end process;	

   DUT : AXIStream_Master_v1
      port map (
         start           => start        ,
                          
         m_axis_clk      => clk          ,
         m_axis_tvalid   => tvalid       ,
         m_axis_tdata    => open         ,
         m_axis_tstrb    => open         ,
         m_axis_tlast    => open         
      );

end test;
