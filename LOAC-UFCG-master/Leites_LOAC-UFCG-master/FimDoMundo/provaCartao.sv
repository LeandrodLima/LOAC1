logic clock, RESET, cartao, dinheiro, destroi_on;
logic [25:0] contador;
logic [2:0] codigo, destroi;
logic [4:0] state;

always_ff @posedge CLOCK_50) begin
    contador <= contador + 1;
end

always_comb begin
    clock <= contador[25];
    RESET <= SWI[0];
    cartao <= SWI[1];
    codigo <= SWI[6:4];
end

parameter SEM_CARTAO = 0, COM_CARTAO = 1, DIG2 = 2, DIG3 = 3, SAI_DINHEIRO = 4, DESTROI_CARTAO = 5;

always_ff @(posedge clock or posedge RESET) begin
    if(RESET) begin
        state <= SEM_CARTAO;
        destroi <= 0;
        dinheiro <= 0;
        destroi_on <= 0;
    end
    else unique case(state)
        SEM_CARTAO: begin
            if(cartao) state <= COM_CARTAO;
        end
        COM_CARTAO: begin
            if(codigo[1] || codigo[2]) destroi <= destroi + 1;
            else if(codigo[0]) state <= DIG2;

            if(destroi > 2) state <= DESTROI_CARTAO;
        end
        DIG2: begin
            if(~codigo[0] || codigo[2]) destroi <= destroi + 1;
            else if(codigo[1]) state <= DIG3;

            if(destroi > 2) state <= DESTROI_CARTAO;
        end
        DIG3: begin
            if(~codigo[0] || ~codigo[1]) destroi <= destroi + 1;
            else if(codigo[2]) state <= SAI_DINHEIRO;
            if(destroi > 2) state <= DESTROI_CARTAO;
        end
        SAI_DINHEIRO: begin 
            dinheiro <= 1;
        end
        DESTROI_CARTAO: begin
            destroi_on <= 1;
        end
    endcase
end

always_comb begin
    LED[0] <= dinheiro;
    LED[1] <= destroi_on;
    LED[7] <= clock;

    unique case (state)
        0: SEG <= 8'b00111111;
        1: SEG <= 8'b00000110;
        2: SEG <= 8'b01011011;
        3: SEG <= 8'b01001111;
        4: SEG <= 8'b01100110;
        5: SEG <= 8'b01101101;
        6: SEG <= 8'b01111101;
        7: SEG <= 8'b00000111;
        8: SEG <= 8'b01111111;
        9: SEG <= 8'b01101111;
        10: SEG <= 8'b10000110;
    endcase
end