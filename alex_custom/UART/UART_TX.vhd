library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library UART;
use UART.UART_pkg.all;

entity UART_TX is
    generic(
        UART_FREQ        : integer;
        UART_BAUD        : integer;
        UART_BITS        : integer;
        UART_CLK_PER_BIT : integer := UART_FREQ / UART_BAUD
    );
    
    port(
        clk          : in  std_logic;
        uart_inputs  : in  UART_TX_IN;
        uart_outputs : out UART_TX_OUT
    );
end entity;

architecture rtl of UART_TX is
    signal tx_state    : UART_TX_SM := TX_Idle;
    signal clock_count : integer range 0 to UART_CLK_PER_BIT - 1 := 0; 
    signal bit_index   : integer range 0 to UART_BITS - 1 := 0;
begin
    statemachine:process(clk)
    begin
        if rising_edge(clk) then
            uart_outputs.TX_DONE <= '0';
            case tx_state is
                when TX_Idle =>
                    uart_outputs.TX_ACTIVATE <= '0';
                    uart_outputs.TX_SERIAL   <= '1';
                    clock_count            <= 0;
                    bit_index              <= 0;

                    if uart_inputs.TX_STARTBIT = '1' then
                        tx_state <= TX_Start;
                    else
                        tx_state <= TX_Idle;
                    end if;

                when TX_Start =>
                    uart_outputs.TX_ACTIVATE <= '1';
                    uart_outputs.TX_SERIAL   <= '0';
                    if clock_count < UART_CLK_PER_BIT - 1 then
                        clock_count <= clock_count + 1;
                        tx_state    <= TX_Start;
                    else
                        clock_count <= 0;
                        tx_state    <= TX_Data;
                    end if;

                when TX_Data =>
                    uart_outputs.TX_SERIAL <= uart_inputs.TX_BYTE(bit_index);
                    if clock_count < UART_CLK_PER_BIT - 1 then
                        clock_count <= clock_count + 1;
                        tx_state <= TX_Data;
                    else
                        clock_count <= 0;

                        if bit_index < UART_BITS - 1 then
                            bit_index <= bit_index + 1;
                            tx_state <= TX_Data;
                        else
                            bit_index <= 0;
                            tx_state  <= TX_Stop;
                        end if;
                    end if;

                when TX_Stop =>
                    uart_outputs.TX_SERIAL <= '1';

                    if clock_count < UART_CLK_PER_BIT - 1 then
                        clock_count <= clock_count + 1;
                        tx_state    <= TX_Stop;
                    else
                        uart_outputs.TX_DONE <= '1';
                        clock_count <= 0;
                        tx_state    <= TX_Cleanup;
                    end if;

                when TX_Cleanup =>
                    uart_outputs.TX_ACTIVATE <= '0';
                    tx_state <= TX_Idle;

                when others =>
                    tx_state <= TX_Idle;
            end case;
        end if;
    end process;

end architecture;
