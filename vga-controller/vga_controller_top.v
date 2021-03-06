/*=============================================================================
 * This document contains information proprietary to the CSULB student that 
   created the file - any reuse without adequate approval and documentation is 
   prohibited. 
 * Class:      CECS 360 - Integrated Circuit Design Software 
 * File Name:  vga_controller_top.v
 * Project:    VGA Controller
 * Designer:   Michael Rios - Copyright � 2017. All rights reserved. 
 * Email:      riosmichael28@ymail.com
 * Rev. Date:  November 13, 2017
 *
 * Description: This is the VGA's top level module. This module ties together 
                the vga_sync module and the graphic_generator module. This 
                module takes in the board clock and reset as input and outputs 
                the hsync, vsync, and rgb signals which will drive a vga 
                display. The pixel_x and pixel_y signals(the current pixel being
                scanned) will be fed to the graphic_generator module which will 
                be used to determine what to set the rgb value of that pixel to. 
 *         
 * In submitting this file for class work at CSULB, I am confirming that this 
   is my work and the work of no one else. 
 * 
 * In the event other code sources are utilized I will document which portion 
   of the code and who is the author. 
 *
 * In submitting this code I acknowledge that plagiarism in student project 
   work is subject to dismissal from the class. 
 *===========================================================================*/ 
 `timescale 1ns / 1ps

module vga_controller_top(clk, rst, btn_up, btn_down, hsync, vsync, rgb);

   input    clk, rst;
   input    btn_up, btn_down; 
   output   [11:0] rgb; 
   output   hsync, vsync; 
   
   wire     video_on, rst_s, hsync, vsync;
   wire     [9:0] pixel_x, pixel_y; 
   wire     db_btn_up, db_btn_down;
      
   aiso_rst    u0(.clk(clk), .reset(rst), .reset_s(rst_s));
   
   vga_sync    u1(.clk(clk), .rst(rst_s), .hsync(hsync),.vsync(vsync), 
                  .pixel_x(pixel_x), .pixel_y(pixel_y), 
                  .video_on(video_on));
                  
   debounce    u2(.clk(clk), .reset(rst), .sw(btn_up), .db(db_btn_up)), 
   
               u3(.clk(clk), .reset(rst), .sw(btn_down), .db(db_btn_down)); 
   
   graphic_generator u4(.clk(clk), .rst(rst), .btn({db_btn_down, db_btn_up}), 
                        .pixel_x(pixel_x), .pixel_y(pixel_y), 
                        .video_on(video_on), .rgb(rgb));               

endmodule
