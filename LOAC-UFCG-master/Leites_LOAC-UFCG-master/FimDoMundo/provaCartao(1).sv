parameter  senha1 = 1;
parameter  senha2 = 3;
parameter  senha3 = 7;

logic cartaoQuebrado, validaSenha, stateCartao, cartao, stateConfirmaSenha, inserirSenha, confirmaSenha, resetOperacao;
logic [2:0] valorSenha1;
logic [2:0] valorSenha2;
logic [2:0] valorSenha3;
logic [1:0] indiceSenha;
logic [1:0] qtdErros;

always_comb begin
    cartao <= SWI[1];
    confirmaSenha <= SWI[7];
    resetOperacao <= SWI[0];
    LED[7] <= second; // MUST BE THE CLOCK
end

always_ff @ (posedge second) begin
    if(resetOperacao) begin
        cartaoQuebrado <= 0;
        validaSenha <= 0;
        valorSenha1 <= 0;
        valorSenha2 <= 0;
        valorSenha3 <= 0;
        inserirSenha <= 0;
        indiceSenha <= 0;
        LED[0] <= 0;
        LED[1] <= 0;
    end
    else begin
        if (validaSenha) begin
            if ( valorSenha1 == senha1 && valorSenha2 == senha2 && valorSenha3 == senha3 ) begin
                LED[0] <= 1;
                LED[1] <= 0;
            end else if(qtdErros == 3) begin
                LED[0] <= 0;
                LED[1] <= 1;
                cartaoQuebrado <= 1;
            end
            else begin
                cartaoQuebrado <= 0;
                validaSenha <= 0;
                valorSenha1 <= 0;
                valorSenha2 <= 0;
                valorSenha3 <= 0;
                indiceSenha <= 0;
            end
        end
        if(confirmaSenha && inserirSenha) begin
            stateConfirmaSenha <= 1;
        end
        else if(confirmaSenha == 0) begin
            if(stateConfirmaSenha && inserirSenha && indiceSenha < 3) begin
                stateConfirmaSenha <= 0;
                indiceSenha <= indiceSenha + 1;
                if(indiceSenha == 0) begin
                    valorSenha1 <= SWI[6:4];
                end
                if(indiceSenha == 1) begin
                    valorSenha1 <= SWI[6:4];
                end
                if(indiceSenha == 2) begin
                    valorSenha3 <= SWI[6:4];
                    validaSenha <= 1;
                    qtdErros <= qtdErros +1;
                end
            end
        end
    end
end

always_comb case (indiceSenha)
        8'd1: SEG <= 8'b00000110;
        8'd2: SEG <= 8'b01011011;
        8'd3: SEG <= 8'b01001111;
        8'd4: SEG <= 8'b01100110;
        8'd5: SEG <= 8'b01101101;
        8'd6: SEG <= 8'b01111101;
        8'd7: SEG <= 8'b00000111;
        8'd8: SEG <= 8'b01111111;
        8'd9: SEG <= 8'b01101111;
        8'd10: SEG <= 8'b01110111;
        8'd11: SEG <= 8'b01111100;
        8'd12: SEG <= 8'b00111001;
        8'd13: SEG <= 8'b01011110;
        8'd14: SEG <= 8'b01111001;
        8'd15: SEG <= 8'b01110001;
        default SEG <= 8'b00000000;
endcase
