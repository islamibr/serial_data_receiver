library ieee;
use ieee.std_logic_1164.all;

entity top is 
    port (
        din, clk: in std_logic;
        data: out std_logic_vector (6 downto 0);
        err: out std_logic;
        data_valid: inout std_logic
    );
end top;

architecture beh of top is
    signal QS: std_logic_vector(9 downto 0) := (others => '0');
    signal start_detected: std_logic := '0';
    signal reception_done: std_logic := '0';
    signal parity_xor: std_logic;
begin 
    process(clk)
    begin 
        if rising_edge(clk) then 
            if start_detected = '0' and din = '1' then -- Detecting start bit
                start_detected <= '1';
                QS(0) <= din;
            elsif start_detected = '1' and reception_done = '0' then -- Data reception
                for i in 9 downto 1 loop
                    QS(i) <= QS(i-1);
                end loop;
                QS(0) <= din;
                
                if QS(8) = '1' then -- Reception completed
                    reception_done <= '1';
                    
                    parity_xor <= QS(1) xor QS(2) xor QS(3) xor QS(4) xor QS(5) xor QS(6) xor QS(7);
                    
                end if;
						
					 
            
				elsif reception_done = '1'then 
						if (QS(0)='1' and (parity_xor= QS(1))) then
						
                        err <= '0';
                        data_valid <= '1';
						else 
							err <= '1';
                     data_valid <= '0';
                  end if;
								
				end if;
				
				if data_valid = '1' or data_valid = '0' then
						start_detected <= '0';
						reception_done <= '0';
						qs<= (others =>'0');
				end if;
				
				
				if start_detected = '0' and reception_done <= '0' then 
					err <= 'U';
					data_valid <= 'U';
				end if ;
		  end if;
    end process;
	
    data <= QS(8 downto 2) when data_valid = '1' ELSE -- Output the received data
	 "UUUUUUU";															
end beh;
