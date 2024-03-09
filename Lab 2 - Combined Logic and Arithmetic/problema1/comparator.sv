module comparator #(parameter N = 4)
						(input logic [N-1:0] a, b, 
						output logic a_mayor_b, a_menor_a);
						
	// Comparison
	assign a_mayor_b = (a > b);
	assign a_menor_b = (a < b);


endmodule