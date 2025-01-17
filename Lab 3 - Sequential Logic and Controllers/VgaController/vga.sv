module vga(
	input logic clk,
	input reg [2:0] i_actual, j_actual,
	input reg [1:0] tablero_jugador[5][5],
	input reg [1:0] tablero_pc[5][5],
	input [2:0] player_ships_input_internal,  // Additional input for ship placement length
	input logic colocation_ships_State,            // Additional input for confirming ship placement
	input logic decision_State,
	input logic player_turn_State,
	output logic vgaclk,
	output logic hsync, vsync,
	output logic sync_b, blank_b,
	output logic [7:0] r, g, b
);

	// Coordenadas del píxel en la pantalla
	logic [9:0] x, y;
	
	// Instancia de un PLL (Phase-Locked Loop) que genera una señal de reloj vgaclk a partir de la señal de reloj de entrada clk
	pll vgapll(
		.inclk0(clk),
		.c0(vgaclk)
	);
	
	// Controlador VGA que genera señales de sincronización hsync, vsync, sync_b y blank_b, así como coordenadas x e y para la pantalla VGA
	vgaController vgaCont(
		.vgaclk(vgaclk),
		.hsync(hsync),
		.vsync(vsync),
		.sync_b(sync_b),
		.blank_b(blank_b),
		.x(x),
		.y(y)
	);
	
	// Generador de video que toma las coordenadas x e y y genera señales de color r, g y b para cada píxel en la pantalla VGA
	videoGen vgavideoGen(
		.x(x),
		.y(y),
		.i_actual(i_actual),
		.j_actual(j_actual),
		.tablero_jugador(tablero_jugador),
		.tablero_pc(tablero_pc),
		.player_ships_input_internal(player_ships_input_internal),  // Connected new input for handling ship placement length
		.colocation_ships_State(colocation_ships_State), 
		.decision_State(decision_State),
		.player_turn_State(player_turn_State),
		.r(r),
		.g(g),
		.b(b)
	);

endmodule
