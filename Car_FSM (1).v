`timescale 1ns / 1ps

module Car_FSM(

input clk,
input reset,
input left,
input right,
output reg [2:0] l,
output reg [2:0] r
    );

//clock divisions for 1 MHz / 2^27 = 2-4 Hz        
    reg [26:0] clk_div;
    always@(posedge clk, negedge reset)
    begin
    if(reset==1)
    clk_div=0;
    else
    clk_div=clk_div+1;
    end

//present and next states    
reg [2:0] ps, ns;

//states of the fsm
parameter s0 = 3'b000,s1 = 3'b001,s2 = 3'b010,s3 = 3'b011,s4 = 3'b100,s5 = 3'b101,s6 = 3'b110;

always @(posedge clk_div[26], negedge reset)
    begin
    if (reset ==1)
    ps=s0;
    else
    ps <= ns;
    end

//following the flow model of the fsm    
always @(ps, left, right)
    begin
    case (ps)
        s0 : begin
            if (left==0 && right==1)      ns = s1;
            else if (left==1 && right==0) ns = s4;
            else                          ns = s0;
            end
        s1 : begin
            if (left==0 && right==1)      ns = s2;
            else                          ns = s0;
            end
        s2 : begin
            if (left==0 && right==1)      ns = s3;
            else                          ns = s0;
            end  
        s3 :ns = s0;
        s4 :begin
            if (left==1 && right==0)      ns = s5;
            else                          ns = s0;
            end
        s5 : begin
            if (left==1 && right==0)      ns = s6;
            else                          ns = s0;
            end  
        s6 :ns = s0;
    endcase 
    end

//output of the lights at the present state of the fsm    
always @(ps)
    case (ps)
    s0 :begin
        l = 3'b000;
        r = 3'b000;
        end
    s1 : begin
        l = 3'b000;
        r = 3'b100;
        end
    s2 : begin
        l = 3'b000;
        r = 3'b110;
        end
    s3 : begin
        l = 3'b000;
        r = 3'b111;
        end
    s4 : begin
        l = 3'b001;
        r = 3'b000;
        end
    s5 : begin
        l = 3'b011;
        r = 3'b000;
        end
    s6 : begin
        l = 3'b111;
        r = 3'b000; 
        end    
    endcase    
        
endmodule
