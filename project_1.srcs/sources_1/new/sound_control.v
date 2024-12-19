`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/19 22:25:00
// Design Name: 
// Module Name: sound_control
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sound_control(
input clk,
input reset,
//input [3:0]sec_1s_2,
//input [3:0]sec_10s_2,
input [3:0]min_1s,
//input [3:0]min_10s,
output reg soundcontol

    );
    
//assign 
 //assign soundcontol=(min_1s==4'b0001)?1:0;
    
    
   always@(posedge clk ) begin 
   //if (reset) begin 
   //soundcontol<=1'b0; 
   //end 
    if(min_1s==4'b0001/*&&min_10s==4'b0000&&sec_10s_2==4'b0000&&sec_1s_2<4'b0010*/)
   soundcontol<=1'b1;
   else soundcontol<=1'b0; 
      end 
      
     
endmodule
