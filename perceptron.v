module perceptron(
    input [7:0] x,
    output reg predict
);

// ----- PASTE YOUR VALUES -----
parameter signed W0 = 80;
parameter signed W1 = 80;
parameter signed W2 = 64;
parameter signed W3 = 64;
parameter signed W4 = 64;
parameter signed W5 = 112;
parameter signed W6 = 80;
parameter signed W7 = 96;
parameter signed BIAS = -240;
// -----------------------------

integer sum;

always @(*) begin
    sum = BIAS;
    if(x[0]) sum = sum + W0;
    if(x[1]) sum = sum + W1;
    if(x[2]) sum = sum + W2;
    if(x[3]) sum = sum + W3;
    if(x[4]) sum = sum + W4;
    if(x[5]) sum = sum + W5;
    if(x[6]) sum = sum + W6;
    if(x[7]) sum = sum + W7;

    if(sum >= 0)
        predict = 1;
    else
        predict = 0;
end
endmodule
