`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Authored by David J. Marion aka FPGA Dude
// Created on 4/14/2022
//
// Description: Top module for VGA clock and calendar version 2.
//
//////////////////////////////////////////////////////////////////////////////////
module design_top(
    input clk_100MHz,           // 100MHz from Basys 3
    input reset,                // sw[15], sys reset
    input inc_hr,               // btnL, set hour
    input inc_min,              // btnR, set minute
    input inc_month,            // btnU, set month
    input inc_day,              // btnC, set day
    input inc_year,             // btnD, set year
    input inc_cent,             // sw[3], set century
    input set_am_pm,            // sw[0], set am/pm
    input ps2_clk,
    input ps2_data,
  //  input SW3,
    output blink,               // LED[1], 1Hz signal
    output hsync,               // to VGA Connector
    output vsync,               // to VGA Connector
    output [11:0] vga           // to DAC, to VGA Connector
    );

clk_wiz_0 clockmaking(.clk_in1(clk_100MHz),.clk_out1(clk_100), .clk_out2(clk_50), .reset(1'b0) );

    
    wire [9:0] w_x, w_y;
    wire video_on, p_tick, am_pm;
    reg [11:0] rgb_reg;
    wire [11:0] rgb_next;
    wire [11:0] rgb_next1;
    reg [11:0] rgb_reg1;
    wire [11:0] rgb;
    wire [11:0] rgb1;
    wire [8:0] scancode;
    wire Released;
    wire space;
    wire enter;
    
    wire [3:0] hr_10s, hr_1s, min_10s, min_1s, sec_10s, sec_1s;
    wire [3:0] m_10s, m_1s, d_10s, d_1s, c_10s, c_1s, y_10s, y_1s;
    
    wire [3:0] hr_10s_2, hr_1s_2, min_10s_2, min_1s_2, sec_10s_2, sec_1s_2;
    wire [3:0] m_10s_2, m_1s_2, d_10s_2, d_1s_2, c_10s_2, c_1s_2, y_10s_2, y_1s_2;
    
wire gamestart;
    
    
    vga_controller vgc(
        .clk_100MHz(clk_100),
        .reset(reset),
        .video_on(video_on),
        .hsync(hsync),
        .vsync(vsync),
        .p_tick(p_tick),
        .x(w_x),
        .y(w_y)
        );

    pixel_gen pg1(
        .clk(clk_100),
        .video_on(video_on),
        .x(w_x),
        .y(w_y),
        .sec_10s(sec_10s),
        .sec_1s(sec_1s),
        .min_10s(min_10s),
        .min_1s(min_1s),
        .hr_10s(hr_10s),
        .hr_1s(hr_1s),
        .am_pm(am_pm),
        .m_10s(m_10s),
        .m_1s(m_1s),
        .d_10s(d_10s),
        .d_1s(d_1s),
        .y_10s(y_10s),
        .y_1s(y_1s),
        .c_10s(c_10s),
        .c_1s(c_1s),
        .rgb(rgb_next)
        );
        
        
    pixel_gen_2 pg2(
        .clk(clk_100),
        .video_on(video_on),
        .x(w_x),
        .y(w_y),
        .sec_10s(sec_10s),
        .sec_1s(sec_1s),
        .min_10s(min_10s),
        .min_1s(min_1s),
        .hr_10s(hr_10s),
        .hr_1s(hr_1s),
        .am_pm(am_pm),
        .m_10s(m_10s),
        .m_1s(m_1s),
        .d_10s(d_10s),
        .d_1s(d_1s),
        .y_10s(y_10s),
        .y_1s(y_1s),
        .c_10s(c_10s),
        .c_1s(c_1s_2),
        .rgb(rgb_next1)
    );

    top_clk_cal clock_and_calendar(
        .clk_100MHz(clk_100),
        .reset(reset),
        .inc_hour(inc_hr),
        .inc_minute(inc_min),
        .inc_month(inc_month), 
        .inc_day(inc_day),
        .inc_year(inc_year),
        .inc_century(inc_cent),
        .sw_am_pm(set_am_pm),
        .am_pm(am_pm),
        .o_1Hz(blink),
        .hr_10s(hr_10s),
        .hr_1s(hr_1s),
        .min_10s(min_10s),
        .min_1s(min_1s),
        .sec_10s(sec_10s),
        .sec_1s(sec_1s),
        .m_10s(m_10s),
        .m_1s(m_1s),
        .d_10s(d_10s),
        .d_1s(d_1s),
        .y_10s(y_10s),
        .y_1s(y_1s),
        .c_10s(c_10s),
        .c_1s(c_1s)
        );

        
ps2_kbd_top ps2_kbd (
    .clk(clk_50), 
    .rst(reset), 
    .ps2clk(ps2_clk), 
    .ps2data(ps2_data), 
    .scancode(scancode), 
    .Released(Released), 
    .err_ind(err_ind)
);

key_board_decoder key_decoder(
    .scancode(scancode),
    .Released(Released),
    .enter(enter),
    .space(space),
    .reset(reset)
);
        
        
        
    
    // RGB buffer
    always @(posedge clk_100)begin 
        if(p_tick)
            rgb_reg <= rgb_next;
    end 
            
    assign rgb = rgb_reg;

    always @(posedge clk_100)begin 
        if(p_tick)
            rgb_reg1 <= rgb_next1;            
    end 
    assign rgb1 = rgb_reg1;

assign  vga=(!space)?rgb:rgb1;


endmodule
