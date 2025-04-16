library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

package regular_tb is
    procedure assert_eq(message : string; actual, expected : std_logic);
    procedure assert_eq(message : string; actual, expected : std_logic_vector);
    procedure assert_eq(message : string; actual, expected : integer);


    
    type slv_vector is array (natural range<>) of std_logic_vector;
    subtype byte is std_logic_vector(7 downto 0);
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
    
end package body;
