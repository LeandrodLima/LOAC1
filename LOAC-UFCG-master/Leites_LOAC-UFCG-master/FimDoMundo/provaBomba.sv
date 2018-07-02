// Bomba
logic clock, RESET, sol, painel, rede;
logic [25:0] contador;
logic [3:0] state;

logic [2:0] desl;

always_ff @(posedge CLOCK_50) begin
    contador <= contador + 1;
end

always_comb begin
    clock <= contador[25];
    RESET <= SWI[0];
    sol <= SWI[1];
end

parameter SEM_SOL = 0, COM_SOL = 1, PAINEL_TSEG = 3, REDE_ON = 4;

always_ff @(posedge clock or posedge RESET) begin
    if(RESET) begin
        state <= SEM_SOL;
        painel <= 0;
        rede <= 0;
        desl <= 0;
    end
    else unique case(state)
        SEM_SOL: begin
            painel <= 0;
            desl <= desl + 1;

            if(sol && desl < 2) begin
                state <= COM_SOL;
            end
            else if(sol && (desl == 2 || desl == 3)) begin
                state <= PAINEL_TSEG;
            end
            else if(sol && desl >= 3) begin
                state <= REDE_ON;
                rede <= 1;
            end
        end
        COM_SOL: begin
            desl <= 0;
            if(sol) painel <= ~painel;
            else state <= SEM_SOL;
        end
        PAINEL_TSEG: begin
            painel <= 1;
            desl <= desl - 1;
            if(desl == 1) state <= COM_SOL;
        end
        REDE_ON: begin
            rede <= 1;
            if(sol) begin
                state <= COM_SOL;
                rede <= 0;
                painel <= 1;
            end
        end
    end case
end

always_comb begin
    LED[0] <= painel;
    LED[1] <= rede;
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