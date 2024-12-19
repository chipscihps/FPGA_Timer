`timescale 1ns / 1ps

module key_board_decoder(
    input [8:0] scancode,
    input Released,
    output reg enter,space
);


reg [2:0] eventing;

always@(posedge Released)begin 
    case(scancode)

    'd13:eventing = 3'b101;
    'h20:eventing = 3'b110;
    default: eventing = 3'd0;
    endcase 
    

        
    if(eventing == 3'b101)
        enter <= 1;
    else
        enter <= 0;
        
    if(eventing == 3'b110)
        space <= 1'b1;
    else 
        space <= 1'b0;
end 

endmodule
