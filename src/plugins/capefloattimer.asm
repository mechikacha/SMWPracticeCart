sixteen_calculation:
        ; pause check
        LDA $13D4 ; pause flag
        BNE .return

        LDA $14A5
        CMP #$00
        BEQ .freefall

        ; in the air
        INC $18C6 ; counted up frames
        CMP #$10
        BNE +

        ; framerule management
        STZ $18C6 ; framecounter
        INC $18C5 ; counted up frame rules

        ; return
      + LDA $18C6
        STA $18C7
        LDA $18C7
        CMP #$0A
        BCC +
        ADC #$05
        STA $18C7
      + BRA .return

      .freefall:
      ; reset numbers we've got
        STZ $18C5
        STZ $18C6
        STZ $18C7
     .return
      + RTS