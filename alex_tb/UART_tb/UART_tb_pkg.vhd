library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.regular_tb.all;

library UART;
use UART.UART_pkg.all;

package UART_tb is
    procedure write_UART(in_byte : in byte; signal serial_out : out std_logic; constant BIT_PERIOD : in time);
    procedure check_TX(ref_data : byte; signal Tx_output : in UART_TX_OUT; constant BIT_PERIOD : in time; constant CLK_PERIOD : in time); 
    procedure assert_eq(message : string; actual, expected : UART_RX_OUT);
    procedure assert_eq(message : string; actual, expected : UART_TX_OUT);

    type UART_Stimuli_data  is array (natural range<>) of byte;
end package;

package body UART_tb is
    procedure write_UART(in_byte : in byte; signal serial_out : out std_logic; constant BIT_PERIOD : in time) is
    begin
        serial_out <= '0';
        wait for BIT_PERIOD;

        for i in in_byte'reverse_range loop
            serial_out <= in_byte(i);
            wait for BIT_PERIOD;
        end loop;
        serial_out <= '1';
        wait for BIT_PERIOD;
    end procedure;
--======================================================================================================================================================--
    procedure check_TX(ref_data : byte; signal Tx_output : in UART_TX_OUT; constant BIT_PERIOD : in time; constant CLK_PERIOD : in time) is
        variable temp_byte : byte := (others => '0');
    begin
        wait until Tx_output.TX_ACTIVATE = '1';
        wait for BIT_PERIOD;
        wait for CLK_PERIOD / 4; --necessary otherwise behavior is inconsistent on edges 
        for i in temp_byte'reverse_range loop
            temp_byte(i) := Tx_output.TX_SERIAL;
            report "Current TX Reading: " & to_string(temp_byte);
            wait for BIT_PERIOD;
        end loop;
        wait until Tx_output.TX_DONE = '1';
        report "End of UART Transmit";
        if ref_data = temp_byte then
            report "Transmit Match!" & LF & CR & "Expected: " & to_hex_string(ref_data) & LF & CR & "Actual: " & to_hex_string(temp_byte) & LF & CR;
        else
            report "Transmit mismatch!" & LF & CR & "Expected: " & to_hex_string(ref_data) & LF & CR & "Actual: " & to_hex_string(temp_byte) & LF & CR
            severity error;
        end if;


    end procedure;
--======================================================================================================================================================--
    procedure assert_eq(message : string; actual, expected : UART_RX_OUT) is
    begin
        if actual = expected then
            report "Pass test: " & message;
        else
            report "!!Fail test: " & message & LF & "expected: " & to_string(expected.RX_BYTE) & ", " & "actual: " & to_string(actual.RX_BYTE)
            severity error;
        end if;
    end procedure;
--======================================================================================================================================================--
    procedure assert_eq(message : string; actual, expected : UART_TX_OUT) is
    begin
        if actual = expected then
            report "Pass test: " & message;
        else
            report "!!Fail test: " & message & LF & "expected: " & to_string(expected.TX_SERIAL) & ", " & "actual: " & to_string(actual.TX_SERIAL)
            severity error;
        end if;
    end procedure;


end package body;
