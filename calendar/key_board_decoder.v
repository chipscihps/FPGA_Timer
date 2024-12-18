`timescale 1ns / 1ps

module key_board_decoder(
    input [8:0] scancode,
    input Released,
    input reset,
    output reg enter,space
);


reg [2:0] sit;

always@(posedge Released)begin 
    case(scancode)

    'd13:sit = 3'd5;
    'h20:sit = 3'd6;
    default: sit = 3'd0;
    endcase 
    

        
    if(sit == 3'd5)
        enter <= 1;
    else
        enter <= 0;
        
    if(sit == 3'd6)
        space <= 1;
    else 
        space <= 0;
end 

endmodule
