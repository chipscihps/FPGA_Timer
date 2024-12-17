`timescale 1ns / 1ps

module gamestarting(
    input clk, reset,
    input enter, space,
    output reg gamestart=0
);

always @(posedge clk) begin
    if(reset) begin
        gamestart <= 0;
    end else if(enter == 1||space == 1) begin
        gamestart <= 1;
    end 
end
    
endmodule
