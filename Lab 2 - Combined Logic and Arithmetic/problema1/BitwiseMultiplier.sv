module BitwiseMultiplier #(parameter n = 4)(
    input logic [n-1:0] A,
    input logic [n-1:0] B,
    output logic [(n*2)-1:0] M
);

    wire C [n-2:0];
    logic [n-1:0] ta [n-2:0];
    logic [n-1:0] tb [n-2:0];
    logic [n-1:0] ts [n-2:0];

    genvar i;
    genvar j;

    generate
        for (i = 0; i < n-1; i++) begin : fa
            for (j = 0; j < n; j++) begin : t
                if (i == 0) begin
                    if (j == n-1) begin
                        assign ta[i][j] = 1'b0;
                    end else begin
                        assign ta[i][j] = A[i] & B[j+1];
                    end
                end else begin
                    if (j == n-1) begin
                        assign ta[i][j] = C[i-1];
                    end else begin
                        assign ta[i][j] = ts[i-1][j+1];
                    end
                end
                assign tb[i][j] = A[i+1] & B[j];
            end

            sum #(n) fa(
                .a(ta[i]),
                .b(tb[i]),
                .cin(1'b0),
                .s(ts[i]),
                .cout(C[i])
            );

            if (i == 0) begin
                assign M[i] = A[i] & B[i];
            end else begin
                assign M[i] = ts[i-1][0];
            end
        end
    endgenerate

    assign M[(n*2)-1:(n*2)-5] = {C[n-2], ts[n-2]};

endmodule