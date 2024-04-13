module videoGen(
    input logic [9:0] x, y, 
    //input reg[6:0] player_board [4:0][4:0], 
    //input reg[6:0] pc_board [4:0][4:0], 
    input reg[2:0] i_actual, j_actual, 
    //input is_defeat, is_victory,
    output logic [7:0] r, g, b
);



    // Declare signals
    reg inrect_main, inrect_secondary;
    reg [9:0] colIndex, rowIndex, col_px, row_px;
    reg [7:0] numberFrameX, numberFrameY, segmentWidth;
    reg [7:0] size, frame, numberSizeX, numberSizeY;

    // Constants
    parameter VGA_WIDTH = 640;
    parameter VGA_HEIGHT = 480;
    parameter BOARD_SIZE = 5;

    // Initialize parameters
    initial begin
        size = 58;
        frame = 2;
        numberSizeX = 30;
        numberSizeY = 47;
        numberFrameX = 13;
        numberFrameY = 6;
        segmentWidth = 2;
    end

    // Calculate column and row indices
    always @* begin
        colIndex = x / (size + frame);          
        rowIndex = y / (size + frame);
    end

    // Calculate column and row pixels
    always @* begin
        col_px = colIndex * (size + frame);
        row_px = rowIndex * (size + frame);
    end

    // Check if inside a rectangle
    always @* begin
        inrect_main = (colIndex < BOARD_SIZE && rowIndex < BOARD_SIZE) && 
                      (x >= col_px + frame && x < col_px + size && 
                       y >= row_px + frame && y < row_px + size);
        inrect_secondary = ((colIndex >= BOARD_SIZE) && (colIndex < (2 * BOARD_SIZE)) && 
                            (rowIndex >= 0) && (rowIndex < BOARD_SIZE)) && 
                           (x >= col_px + frame && x < col_px + size && 
                            y >= row_px + frame && y < row_px + size);
    end

		// Set color based on rectangles
		always @* begin
			 {r, g, b} = inrect_main ? (colIndex == j_actual && rowIndex == i_actual) ? {8'hFF, 8'hFF, 8'hFF} : {8'hFF, 8'h00, 8'h00} :
										  inrect_secondary ? {8'h00, 8'h00, 8'hFF} :
										  {8'h00, 8'h00, 8'h00};
		end


endmodule
