/*
 * Copyright (c) 2023 by Liyuxuan, all rights reserved.
 */

`include "GlobalDefine.v"

module Buzzer 
(
    input               clk,
    input               rstn,
    input[7:0]          addrIn,
    input[7:0]          addrOut,
    input[3:0]          sizeDecode,
    input[31:0]         dataIn,
    output reg[31:0]    dataOut,
    output              BUZ,
    output              AUD
);

`define NOTE 0      // 已弃用
`define TIME 1      // 已弃用
`define OUTP 2
`define LOOP 3
`define GAPT 4
`define LENT 5
`define STAT 6

`define LEN_BUZZ 16 
`define LEN_MIDI 48

`define MIDI_NOTE 31:24
`define MIDI_VELO 23:16
`define MIDI_TIME 15:0

reg [31:0] mem [`LEN_BUZZ+`LEN_MIDI-1:0];

reg [15:0] msCounter;

reg [15:0] notePos;
reg [15:0] noteTimeRemain;

reg [7:0] nowNote;
reg [7:0] nowVelocity;


// reg [15:0] notePos;

// reg [15:0] tmCounter;

always@(posedge clk or negedge rstn) 
begin
    if(~rstn)
    begin
        mem[`NOTE] <= 0;
        mem[`TIME] <= 0;
        mem[`OUTP] <= 0;
        mem[`LOOP] <= 0;
        mem[`GAPT] <= 0;
        // mem[`LENT] <= 4;
        mem[`LENT] <= 0;
        mem[`STAT] <= 0;
        msCounter <= 0;
        notePos <= 0;
        noteTimeRemain <= 0;
        // mem[`LEN_BUZZ+0] <= 32'h01_00_00FF;
        // mem[`LEN_BUZZ+1] <= 32'h02_00_00FF;
        // mem[`LEN_BUZZ+2] <= 32'h03_00_00FF;
        // mem[`LEN_BUZZ+3] <= 32'h04_00_00FF;
    end
    else
    begin
        if(sizeDecode[0]) mem[addrIn[5:0]][7:0]   <= dataIn[7:0];
        if(sizeDecode[1]) mem[addrIn[5:0]][15:8]  <= dataIn[15:8];
        if(sizeDecode[2]) mem[addrIn[5:0]][23:16] <= dataIn[23:16];
        if(sizeDecode[3]) mem[addrIn[5:0]][31:24] <= dataIn[31:24];

        dataOut <= mem[addrOut[5:0]];

        if(noteTimeRemain != 0)
        begin
            msCounter <= msCounter + 1;
            if(msCounter == 50000)
            begin
                msCounter <= 0;
                noteTimeRemain <= noteTimeRemain - 1;
            end
        end
        else
        begin
            noteTimeRemain <= mem[`LEN_BUZZ + notePos][`MIDI_TIME];
            nowNote <= mem[`LEN_BUZZ + notePos][`MIDI_NOTE];
            nowVelocity <= mem[`LEN_BUZZ + notePos][`MIDI_VELO];
            notePos <= notePos + 1;
            if(notePos == mem[`LENT] - 1)
                notePos <= 0;
        end

        // if(mem[`LOOP] & mem[`STAT])
        // begin
        //     if(notePos != 128)
        //     begin
        //         if(tmCounter != 0)
        //         begin
        //             msCounter <= msCounter + 1;
        //             if(msCounter == 50000)   //计时
        //             begin
        //                 msCounter <= 0;
        //                 tmCounter <= tmCounter - 1;
        //             end
        //         end
        //         else
        //         begin
        //             notePos <= notePos + 1;  
        //             tmCounter <= memMIDI[notePos][31:16];
        //         end
                    
        //     end
        //     else
        //         begin
        //             mem[`LOOP] <= mem[`LOOP] - 1;
        //             notePos <= 0;
        //             mem[`STAT] <= 0;
        //             tmCounter <= mem[`GAPT];
        //         end
        // end
        // else if (~mem[`STAT])
        // begin
        //     if(tmCounter != 0)
        //         begin
        //             msCounter <= msCounter + 1;
        //             if(msCounter == 50000)   //计时
        //             begin
        //                 msCounter <= 0;
        //                 tmCounter <= tmCounter - 1;
        //             end
        //         end
        // end

    end
end

`define nC3 262
`define nD3 294
`define nE3 330
`define nF3 349
`define nG3 392
`define nA3 440
`define nB3 494

`define nC4 523
`define nD4 587
`define nE4 659
`define nF4 698
`define nG4 784
`define nA4 880
`define nB4 988

`define NUM(X) (`CLK_FRE/X)/2

wire [31:0] clkNum =
    (nowNote == 4'd0)   ? 0 :
    (nowNote == 4'd1)   ? `NUM(`nC3) :
    (nowNote == 4'd2)   ? `NUM(`nD3) :
    (nowNote == 4'd3)   ? `NUM(`nE3) :
    (nowNote == 4'd4)   ? `NUM(`nF3) :
    (nowNote == 4'd5)   ? `NUM(`nG3) :
    (nowNote == 4'd6)   ? `NUM(`nA3) :
    (nowNote == 4'd7)   ? `NUM(`nB3) : 
    (nowNote == 4'd8)   ? `NUM(`nC4) :
    (nowNote == 4'd9)   ? `NUM(`nD4) :
    (nowNote == 4'd10)  ? `NUM(`nE4) :
    (nowNote == 4'd11)  ? `NUM(`nF4) :
    (nowNote == 4'd12)  ? `NUM(`nG4) :
    (nowNote == 4'd13)  ? `NUM(`nA4) :
    (nowNote == 4'd14)  ? `NUM(`nB4) : 0;

reg [31:0] counter;
always @(posedge clk) if(counter>=clkNum) counter<=0; else counter <= counter+1;

reg speaker;
always @(posedge clk) if(counter>=clkNum && noteTimeRemain != 0) speaker <= ~speaker;

assign BUZ = (mem[`OUTP][0]) ? speaker : 1'bz;
assign AUD = (mem[`OUTP][1]) ? speaker : 1'bz;

endmodule