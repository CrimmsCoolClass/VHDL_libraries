library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

package UART_pkg is

    type UART_RX_SM is (RX_Idle, RX_Start, RX_Data, RX_Stop, RX_Cleanup);
    type UART_TX_SM is (TX_Idle, TX_Start, TX_Data, TX_Stop, TX_Cleanup);

     type UART_RX_IN is record
        RX_SERIAL  : std_logic;
    end record;

    type UART_RX_OUT is record
        RX_STOPBIT : std_logic;
        RX_BYTE    : std_logic_vector(7 downto 0);
    end record;

    type UART_TX_IN is record 
        TX_STARTBIT : std_logic;
        TX_BYTE     : std_logic_vector(7 downto 0);
    end record;

    type UART_TX_OUT is record
        TX_ACTIVATE : std_logic;
        TX_SERIAL   : std_logic;
        TX_DONE     : std_logic;
    end record;

end package;
