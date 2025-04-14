library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library UART;
use UART.UART_pkg.all;

entity UART_RX is
    generic(
        UART_FREQ        : integer;
        UART_BAUD        : integer;
        UART_BITS        : integer;
        UART_CLK_PER_BIT : integer := UART_FREQ / UART_BAUD
    );
    
    port(
        clk          : in  std_logic;
        uart_inputs  : in  UART_RX_IN;
        uart_outputs : out UART_RX_OUT
    );
end entity;

architecture rtl of UART_RX is
    signal rx_state    : UART_RX_SM := RX_Idle;
    signal temp_byte   : std_logic_vector(UART_BITS - 1 downto 0) := (others => '0');
    signal clock_count : integer range 0 to UART_CLK_PER_BIT - 1 := 0;
    signal bit_index   : integer range 0 to UART_BITS - 1 := 0;
begin
    statemachine:process(clk)
    begin
        if rising_edge(clk) then
            case rx_state is
                when RX_Idle =>
                    uart_outputs.RX_STOPBIT <= '0';
                    clock_count <= 0;
                    bit_index   <= 0;

                    if uart_inputs.RX_SERIAL = '0' then
                        rx_state <= RX_Start;
                    else
                        rx_state <= RX_Idle;
                    end if;

                when RX_Start =>
                    if clock_count = (UART_CLK_PER_BIT - 1) / 2 then
                        if uart_inputs.RX_SERIAL = '0' then
                            clock_count <= 0;
                            rx_state    <= RX_Data;
                        else
                            rx_state    <= RX_Start;
                        end if;
                    else
                        clock_count <= clock_count + 1;
                        rx_state    <= RX_Start;
                    end if;

                when RX_Data =>
                    if clock_count < UART_CLK_PER_BIT - 1 then
                        clock_count <= clock_count + 1;
                        rx_state    <= RX_Data;
                    else
                        clock_count <= 0;
                        temp_byte(bit_index) <= uart_inputs.RX_SERIAL;

                        if bit_index < UART_BITS - 1 then
                            bit_index <= bit_index + 1;
                            rx_state <= RX_Data;
                        else
                            bit_index <= 0;
                            rx_state  <= RX_Stop;
                        end if;
                    end if;

                when RX_Stop =>
                    if clock_count < UART_CLK_PER_BIT - 1 then
                        clock_count <= clock_count + 1;
                        rx_state    <= RX_Stop;
                    else
                        uart_outputs.RX_STOPBIT <= '1';
                        clock_count           <= 0;
                        rx_state <= RX_Cleanup;
                    end if;

                when RX_Cleanup =>
                    rx_state <= RX_Idle;
                    uart_outputs.RX_STOPBIT <= '0';

                when others =>
                    rx_state <= RX_Idle;
            end case;
        end if;
    end process;

    uart_outputs.RX_BYTE <= temp_byte;

end architecture;
