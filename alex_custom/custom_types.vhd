library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

package custom_types is
    function to_ssdca(input : integer)          return std_logic_vector;
    function to_ssdca(input : std_logic_vector) return std_logic_vector;
    function to_ssdcc(input : integer)          return std_logic_vector;
    function to_ssdcc(input : std_logic_vector) return std_logic_vector;
end package custom_types;

package body custom_types is
    function to_ssdca(input: integer) return std_logic_vector is
    begin
        case input is
            when 0      => return "0000001";
            when 1      => return "1001111";
            when 2      => return "0010010";
            when 3      => return "0000110";
            when 4      => return "1001100";
            when 5      => return "0100100";
            when 6      => return "0100000";
            when 7      => return "0001111";
            when 8      => return "0000000";
            when 9      => return "0001100";
            when 10     => return "0001000";
            when 11     => return "1100000";
            when 12     => return "0110001";
            when 13     => return "1000010";
            when 14     => return "0110000";
            when 15     => return "0111000";
            when others => return "1111111";
        end case;
    end function to_ssdca;

    function to_ssdca(input: std_logic_vector) return std_logic_vector is
    begin
        case input is
            when "0000" => return "0000001";
            when "0001" => return "1001111";
            when "0010" => return "0010010";
            when "0011" => return "0000110";
            when "0100" => return "1001100";
            when "0101" => return "0100100";
            when "0110" => return "0100000";
            when "0111" => return "0001111";
            when "1000" => return "0000000";
            when "1001" => return "0001100";
            when "1010" => return "0001000";
            when "1011" => return "1100000";
            when "1100" => return "0110001";
            when "1101" => return "1000010";
            when "1110" => return "0110000";
            when "1111" => return "0111000";
            when others => return "1111111";
        end case;
    end function to_ssdca;

    function to_ssdcc(input: integer) return std_logic_vector is
    begin
        case input is
            when 0      => return "1111110";
            when 1      => return "0110000";
            when 2      => return "1101101";
            when 3      => return "1111001";
            when 4      => return "0110011";
            when 5      => return "1011011";
            when 6      => return "1011111";
            when 7      => return "1110000";
            when 8      => return "1111111";
            when 9      => return "1110011";
            when 10     => return "1110111";
            when 11     => return "0011111";
            when 12     => return "1001110";
            when 13     => return "0111101";
            when 14     => return "1001111";
            when 15     => return "1000111";
            when others => return "0000000";
        end case;
    end function to_ssdcc;

    function to_ssdcc(input: std_logic_vector) return std_logic_vector is
    begin
        case input is
            when "0000" => return "1111110";
            when "0001" => return "0110000";
            when "0010" => return "1101101";
            when "0011" => return "1111001";
            when "0100" => return "0110011";
            when "0101" => return "1011011";
            when "0110" => return "1011111";
            when "0111" => return "1110000";
            when "1000" => return "1111111";
            when "1001" => return "1110011";
            when "1010" => return "1110111";
            when "1011" => return "0011111";
            when "1100" => return "1001110";
            when "1101" => return "0111101";
            when "1110" => return "1001111";
            when "1111" => return "1000111";
            when others => return "0000000";
        end case;
    end function to_ssdcc;
end package body;
