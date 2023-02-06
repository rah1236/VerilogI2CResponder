module shiftReg8b(
  input shift_in,
  input clock,
  output shift_out,
  output [7:0] byte_out
);

reg regbyte[7:0];

assign shift_out = regbyte[7];
assign byte_out = regbyte;

always @(posedge clock) begin
    regbyte[7] <= regbyte[6];
    regbyte[6] <= regbyte[5];
    regbyte[5] <= regbyte[4];
    regbyte[4] <= regbyte[3];
    regbyte[3] <= regbyte[2];
    regbyte[2] <= regbyte[1];
    regbyte[1] <= regbyte[0];
    regbyte[0] <= shift_in;
end

endmodule

