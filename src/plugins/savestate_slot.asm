@include

!savestate_slot_number = 2

!slot_to_save = $700340
!slot_to_load = $700341

macro slot_count(slot, reset, addsub) ; add = 0, sub = 1
        lda <slot>
        if <addsub> = 0
            inc a
            cmp #3
        elseif <addsub> = 1
            dec a
            cmp #$FF
        endif
        beq <reset>
        sta <slot>
        rts
endmacro

savestate_slot:
        jsr copy_to_wram
        lda !util_byetudlr_hold
        and #%00010000 ; start
        bne savestate_slot_control
        rts

savestate_slot_control:
        lda !util_axlr_hold
        cmp #%00010000
        beq .save
        cmp #%00100000
        beq .load
        rts
    .save:
        lda !util_byetudlr_frame
        cmp #%00001000
        bne .save_check_down
        %slot_count(!slot_to_save, .reset_save, 0)
    .save_check_down:
        cmp #%00000100
        bne savestate_slot_finish
        %slot_count(!slot_to_save, .reset_save, 1)
    .reset_save:
        lda #$00
        sta !slot_to_save
        rts

    .load:
        lda !util_byetudlr_frame
        cmp #%00001000
        bne .load_check_down
        %slot_count(!slot_to_load, .reset_load, 0)
    .load_check_down:
        cmp #%00000100
        bne savestate_slot_finish
        %slot_count(!slot_to_load, .reset_load, 1)
    .reset_load:
        lda #$00
        sta !slot_to_load
        rts

savestate_slot_finish:
        rts

copy_to_wram:
        lda !slot_to_save
        sta $1923
        lda !slot_to_load
        sta $1924
        rts
