module Battleship(
	input logic start, // 
	input logic move_up, move_down, move_left, move_right, clk, rst,
	input logic player_move,

	
	
	
	//del estado decision se ocupan los siguientes inputs
	
		
	input reg [2:0] player_ships_input, //cantidad de barcos del jugador que después pasarán a ser iguales
												//a la cantidad de barcos por el PC
												
	input logic confirm_amount_button,
	
	output logic [2:0] game_ships_amount,
	
	// Señal de reloj para el monitor VGA
	output logic vgaclk,
	
	// Señales de sincronización horizontal y vertical para el monitor VGA
	output logic hsync, vsync,
	
	// Señales de sincronización y en blanco para el monitor VGA
	output logic sync_b, blank_b,
	
	//Componentes de color para el monitor VGA
	output logic [7:0] r, g, b,
	
	// siete segmentos para mostrar el número de barcos colocados y la cantidad de barcos restantes.
	output logic[6:0] ships_placed_seg, 
	output logic[6:0] player_ships_input_seg
	);
	
	
	// Registro para dividir la frecuencia del reloj clk
	reg clk_ms; 
	
	// Coordenadas actuales del jugador en el tablero
	reg [2:0] i_actual, j_actual; 
	
	// Coordenadas siguientes del jugador en el tablero
	reg [2:0] i_next, j_next; 
	
	// Cantidad de barcos de la PC (Inicializado con 0 barcos)
	reg [2:0] pc_ships = 3'b000; 

	// Cantidad de barcos del jugador (Inicializado con 0 barcos)
	reg [2:0] player_ships = 3'b000;
	
	
	
	
	
	logic decision, colocation_ships, player_turn,  pc_turn, is_victory, is_defeat ;
	
	logic ships_decided;
							  
							  
	reg[2:0] ships_placed;
	
	logic [2:0] ship_size_limit = 3'b101;

	logic [2:0] player_ships_input_limit = 3'b101;
	
	reg [2:0] player_ships_input_internal; // Señal interna para realizar operaciones
	
	reg [2:0] random_number;

	always_comb begin
		 player_ships_input_internal = (player_ships_input > player_ships_input_limit) ? player_ships_input_limit : player_ships_input;
	end
	
	// Definición de los tableros como matrices 5x5 de dos bits
   reg [1:0] tablero_jugador[5][5];
   reg [1:0] tablero_pc[5][5];

	always_comb begin
		 amount_of_ships_internal = (amount_of_ships > amount_of_ships_limit) ? amount_of_ships_limit : amount_of_ships;
	end
	
	

// Divide la frecuencia del reloj clk para generar una señal de reloj para el monitor VGA
	vga_clock clkdiv (
		clk, clk_ms
	);
	
	
	// Instancia del módulo decisionstate
    decisionstate decision_mod (
        .player_amount_ships(player_ships_input_internal),   // Conecta con la entrada de barcos del jugador
        .decision(decision),                            // Asumimos siempre activo para este ejemplo
        .clk(clk_ms),                                  // Reloj del sistema
        .rst(rst),                                  // Reset del sistema
        .player_confirm_amount(confirm_amount_button),     // Botón de confirmación de cantidad de barcos
		  .ships_decided(ships_decided)
	 );
	
	
	FSMgame fsm(
	  .clk(clk),
	  .rst(rst),
	  //.time_expired(time_expired),
	  .player_ships(player_ships),
	  .pc_ships_setup(pc_ships),
	  .player_move(player_move),
	  .finished_placing(finished_placing),
	  .ships_decided(ships_decided),
	  .decision(decision),
	  .colocation_ships(colocation_ships),
	  .player_turn(player_turn),
	  .pc_turn(pc_turn),
	  .is_victory(is_victory),
	  .is_defeat(is_defeat)
	);
	
	
	// Instancia del módulo tablero
    tablero game_board (
        .clk(clk),
        .rst(rst),
		  .decision(1'b1),
        .tablero_jugador(tablero_jugador),
        .tablero_pc(tablero_pc)
    );
	
	// Controla el movimiento del jugador en el tablero
	controls movement_controls(
		.i_actual(i_actual), 
		.j_actual(j_actual), 
		.i_next(i_next), 
		.j_next(j_next),
		.move_up(move_up), 
		.move_down(move_down), 
		.move_left(move_left), 
		.move_right(move_right),
		.clk(clk_ms), .rst(rst)
	);
	

// Genera señales de video VGA para mostrar el tablero del juego en un monitor
	vga vga(
		clk, 3'b000, 3'b000,
		vgaclk, hsync, vsync, sync_b, blank_b, tablero_jugador,
		tablero_pc, r, g, b
	);
	
	// Decodifica las señales de barcos colocados y cantidad de barcos restantes para visualización en siete segmentos
	decoder amount_of_ships_deco(player_ships_input_internal, ships_placed_seg);
	
endmodule