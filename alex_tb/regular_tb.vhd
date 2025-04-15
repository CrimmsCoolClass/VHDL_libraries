library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

package regular_tb is
    procedure assert_eq(message : string; actual, expected : std_logic);
    procedure assert_eq(message : string; actual, expected : std_logic_vector);
    procedure assert_eq(message : string; actual, expected : integer);
    procedure write_UART(in_byte : in std_logic_vector(7 downto 0); signal serial_out : out std_logic; constant BIT_PERIOD : in time);
end package;

package body regular_tb is
    procedure assert_eq(message : string; actual, expected : std_logic) is
    begin
        if actual = expected then
            report "Pass test: " & message;
        else
            report "!!Fail test: " & message & LF & "expected: " & to_string(expected) & ", " & "actual: " & to_string(actual)
            severity error;
        end if;
    end procedure;
    
    procedure assert_eq(message : string; actual, expected : std_logic_vector) is
    begin
        if actual = expected then
            report "Pass test: " & message;
        else
            report "!!Fail test: " & message & LF & "expected: " & to_string(expected) & ", " & "actual: " & to_string(actual)
            severity error;
        end if;
    end procedure;
    
    procedure assert_eq(message : string; actual, expected : integer) is
    begin
        if actual = expected then
            report "Pass test: " & message;
        else
            report "!!Fail test: " & message & LF & "expected: " & to_string(expected) & ", " & "actual: " & to_string(actual)
            severity error;
        end if;
    end procedure;
    
    procedure write_UART(in_byte : in std_logic_vector(7 downto 0); signal serial_out : out std_logic; constant BIT_PERIOD : in time) is
    begin
        serial_out <= '0';
        wait for BIT_PERIOD;

        for i in in_byte'range loop
            serial_out <= in_byte(i);
            wait for BIT_PERIOD;
        end loop;
        serial_out <= '1';
        wait for BIT_PERIOD;
    end procedure;
end package body;
