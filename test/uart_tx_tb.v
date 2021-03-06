//==============================================================================
// Testbench name 	 : uart_tx_tb
// File name   : uart_tx.v
// Function	   : Test for the UART transmit module
// Engineer    : Dennis Pinto Rivero danielpintoriv@gmail.com
//
// Notes:
//==============================================================================


`timescale 1ns/1ps

module uart_tx_tb;

reg clk, rst_n;
reg start;
reg [7:0] data;
wire tx, busy;

localparam clock_frequency = 12000000;
localparam clk_pulse_width = 1000000000/clock_frequency;

uart_tx uart_tx(
	.rst_n(rst_n),
	.clk(clk),
	.start(start),
	.data(data),
	.tx(tx),
	.busy(busy)
);

// Dump variables
initial begin
    //$dumpfile("uart_tx.vcd");
    $dumpvars(0,uart_tx);
end

// Clock
always #(clk_pulse_width/2) clk = !clk;

// Reset
initial begin
	$monitor("Time %d", $time);
	clk = 0;
    rst_n = 0;
	repeat (5) @(negedge clk);
	rst_n = 1;
end

// testbench
initial begin
	start = 0;
	data = 8'h00;
	wait( rst_n );
	@(negedge clk);
	$monitor("[Time %d]: Started testbench", $time);

	data = 8'b10101010;
	start = 1;
	
	repeat (10) @(negedge clk);
	start = 0;

	wait ( !busy );
	repeat (100) @(negedge clk);
	$finish;
end

endmodule // uart_tx_tb
