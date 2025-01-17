module shift_right_tb #(parameter N = 4) ();

	logic[N-1:0] a;
	logic[N-1:0] shift_right_result;

	shift_right #(N) dut(a, shift_right_result);
	
	initial begin
	a = 4'b0111;
	#10ns;
	a = 4'b1110;
	#10ns;
	a = 4'b1001;
	#10ns;
	a = 4'b1000;
	#10ns;
	a = 4'b1111;
	#10ns;
	a = 4'b0000;
	#10ns;
	a = 4'b0101;
	#10ns;
	end

endmodule