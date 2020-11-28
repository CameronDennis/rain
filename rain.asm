;Cameron Dennis ECE109
;Program draws a cloud, rain begins to fall from the cloud
;Pressing letters b, g, y, r, w(actually space), changes the drops to the corresponding color
;Pressing enter will clear the screen
;Pressing q will halt the program


        .ORIG x3000
;Drawing the cloud
        LEA R1, COLOR
        LD R0, BLU
        STR R0, R1, #0
        LD R0, WHT              ;Loads White into R0
        LD R1, CORIG            ;Loads first pixel address of Cloud into R1
        AND R2, R2, #0          ;Resets R2 for XCounter
        LD R3, YINC             ;2cp YINC for YCounter in R3
        NOT R3, R3
        ADD R3, R3, #1
        LD R4, CXOFF            ;2cp CXOFF
        NOT R4, R4
        ADD R4, R4, #1
        LD R5, CYOFF            ;2cp CYOFF
        NOT R5, R5
        ADD R5, R5, #1
START   STR R0, R1, #0          ;Stores white ID in pixel
        ADD R6, R2, R4
        BRz INCY                ;Checks if we should increment Y-Pixel Down
        ADD R1, R1, #1          ;Increments X-Pixel
        ADD R2, R2, #1          ;Increments XCounter
        BRnzp START

INCY    ADD R1, R4, R1
        LD R6, YINC
        ADD R1, R1, R6          ;Increments Y-Pixel Down
        AND R2, R2, #0          ;Resets XCounter
        ADD R3, R3, R6          ;Increments YCounter
        ADD R6, R3, R5
        BRz RANDN               ;Checks if the cloud is done printing
        BRnzp START

        AND R3, R3, #0
;Loads original random numbers into storage
RANDN   AND R3, R3, #0
        LEA R1, DROPL
        STR R3, R1, #0
RANDN1  LEA R1, RAND            ;Loads address of storage location origin into R1
        LD R0, RAND0            ;Loads random number 0 into R0
        STR R0, R1, #0
        ADD R1, R1, #1
        LD R0, RAND1
        STR R0, R1, #0
        ADD R1, R1, #1
        LD R0, RAND2
        STR R0, R1, #0
        ADD R1, R1, #1
        LD R0, RAND3
        STR R0, R1, #0
        ADD R1, R1, #1
        LD R0, RAND4
        STR R0, R1, #0
        ADD R1, R1, #1
        LD R0, RAND5
        STR R0, R1, #0
        ADD R1, R1, #1
        LD R0, RAND6
        STR R0, R1, #0
        ADD R1, R1, #1
        LD R0, RAND7
        STR R0, R1, #0
        ADD R1, R1, #1
        LD R0, RAND8
        STR R0, R1, #0
        ADD R1, R1, #1
        LD R0, RAND9
        STR R0, R1, #0
        ADD R1, R1, #1

        ;ADD R3, R3, #0
        ;BRp RESET2
        ;LEA R1, DROPL
        ;AND R0, R0, #0
        ;STR R0, R1, #0


;Draws Drops
DROP    LEA R1, RAND            ;Loads address of storage location origin into R1
        LD R2, DROPN            ;Loads drop number into R2
        ADD R1, R1, R2          ;Increments R1 to storage location of drop address
        LDR R3, R1, #0          ;Loads drop address to R3
        LD R4, YINC
        ADD R3, R3, R4          ;Decrements drop address location by 1 pixel
        AND R5, R5, #0
        LD R6, OOBC
        ADD R5, R3, R6          ;Checks if drop address is out of bounds
        BRzp CLEAR
        STR R3, R1, #0          ;Stores new drop location
        BRnzp POLLB

POLLE   LD R0, COLOR              ;Sets color of drop pixel
        STR R0, R3, #0          ;Colors pixel
        LD R5, DROPL
        ADD R5, R5, #1          ;Increments Drop Length
        LD R6, NN
        ADD R6, R6, R5          ;Checks if drop is too long
        BRz RTOP1

DEC     ADD R5, R5, #-1         ;Decrements Drop Length
        LD R4, TC
        ADD R4, R3, R4
        BRn NRESET
        ADD R5, R5, #0
        BRz RESETO

NRESET  ADD R2, R2, #1          ;Increments Drop Number
        LEA R1, DROPN
        LD R4, NT
        ADD R4, R2, R4          ;Checks if drop number is over the amount of drops
        BRnp SKIP
        ADD R5, R5, #1
        ADD R5, R5, #-8
        ADD R5, R5, #-1
        BRz WUT
        ADD R5, R5, #2
        ADD R5, R5, #7
WUT2    AND R2, R2, #0

SKIP    STR R2, R1, #0          ;Stores drop number
        LEA R1, DROPL
        STR R5, R1, #0          ;Stores drop length
        BRnzp DROP

NRTOP   ADD R5, R5, #-1         ;Decrements Drop Length
        LEA R0, DROPL
        STR R5, R0, #0
        BRz RESETO              ;Jumps to reset drop address to original
        BRnzp DROP

RTOP1   LD R5, DROPL
        AND R2, R2, #0
RTOPL   ADD R2, R4, R2          ;Loop sets R5 to be an incrementation upwards
        ADD R5, R5, #-1         ;for the Black pixel to be set
        BRp RTOPL
        NOT R2, R2
        ADD R2, R2, #1
        ADD R3, R3, R2
        LD R0, BLK
        STR R0, R3, #0          ;Clears pixel

        LEA R1, DROPL           ;Resets registers to original values
        LD R5, DROPL
        ADD R5, R5, #1
        STR R5, R1, #0
        LD R5, DROPL
        LD R2, DROPN
        LEA R1, RANDN
        ADD R1, R2, R1
        LDR R3, R1, #0

        ;LD R6, OOBC
        ;ADD R4, R3, R6          ;Checks if drop address is out of bounds
        ;BRn OOF
        ;ADD R5, R5, #-1
        ;LEA R1, DROPL
        ;STR R5, R1, #0

OOF     LD R0, COLOR              ;
        BRnzp DEC

RESETO  ST R3, RTHREE              ;Reset drop storage to original address
        ADD R3, R2, #1
        ADD R3, R3, #-8
        ADD R3, R3, #-2
        BRnp NRESET
        ADD R3, R3, #1
        BRnzp RANDN1

RESET2  LD R3, RTHREE
        BRnzp NRESET            ;Jump back to looping

WUT     ADD R5, R5, #1
        ADD R5, R5, #7
        BRnzp WUT2

CLEAR   LD R0, BLK              ;Loads Black into R0
        LD R1, CANORIG          ;Loads first pixel address of canvas into R1
        AND R2, R2, #0          ;Resets R2 for XCounter
        LD R3, YINC             ;2cp YINC for YCounter in R3
        NOT R3, R3
        ADD R3, R3, #1
        LD R4, CANXOFF          ;2cp CANXOFF
        NOT R4, R4
        ADD R4, R4, #1
        LD R5, CANYOFF          ;2cp CANYOFF
        NOT R5, R5
        ADD R5, R5, #1
CLEAR1  STR R0, R1, #0          ;Stores black ID in pixel
        ADD R6, R2, R4
        BRz INCY1               ;Checks if we should increment Y-Pixel Down
        ADD R1, R1, #1          ;Increments X-Pixel
        ADD R2, R2, #1          ;Increments XCounter
        BRnzp CLEAR1

INCY1   ADD R1, R4, R1
        LD R6, YINC
        ADD R1, R1, R6          ;Increments Y-Pixel Down
        AND R2, R2, #0          ;Resets XCounter
        ADD R3, R3, R6          ;Increments YCounter
        ADD R6, R3, R5
        BRz RANDN               ;Checks if the cloud is done printing
        BRnzp CLEAR1

POLLB   LEA R0, RSTORA          ;Stores Values for after polling
        STR R1, R0, #0
        STR R2, R0, #1
        STR R3, R0, #2
        STR R4, R0, #3
        STR R5, R0, #4
        STR R6, R0, #5
        LD R0, CYOFF
TIME    ADD R0, R0, #-1
        BRnp TIME
        LDI R0, KBSRPtr         ;Checks for value in keyboard register
        BRzp POLLH
        LDI R0, KBDRPtr         ;Loads value from keyboard register in R0
;Setting colors
        LD R1, REDC
        ADD R1, R1, R0          ;Checks for r to change to RED
        BRnp GG
        LEA R0, COLOR
        LD R1, RED
        STR R1, R0, #0          ;Stores RED in COLOR
        BRnzp POLLH
GG      LD R1, GRNC
        ADD R1, R1, R0          ;Checks for g to change to GRN
        BRnp BB
        LEA R0, COLOR
        LD R1, GRN
        STR R1, R0, #0          ;Stores GRN in COLOR
        BRnzp POLLH
BB      LD R1, BLUC
        ADD R1, R1, R0          ;Checks for b to change to BLU
        BRnp YY
        LEA R0, COLOR
        LD R1, BLU
        STR R1, R0, #0          ;Stores BLU in COLOR
        BRnzp POLLH
YY      LD R1, YELC
        ADD R1, R1, R0          ;Checks for y to change to YEL
        BRnp WW
        LEA R0, COLOR
        LD R1, YEL
        STR R1, R0, #0          ;Stores YEL in COLOR
        BRnzp POLLH
WW      LD R1, WHTC
        ADD R1, R1, R0          ;Checks for space to change to WHT
        BRnp RLC
        LEA R0, COLOR
        LD R1, WHT
        STR R1, R0, #0          ;Stores WHT in COLOR
        BRnzp POLLH
;Check for additional
RLC     LD R1, CLRC
        ADD R1, R1, R0          ;Checks for enter to clear the screen
        BRz CLEAR               ;Jumps to clear
        LD R1, QUIC
        ADD R1, R1, R0          ;Checks for q to quit
        BRz TEST
POLLH   LEA R0, RSTORA          ;Stores Values for after polling
        LDR R1, R0, #0
        LDR R2, R0, #1
        LDR R3, R0, #2
        LDR R4, R0, #3
        LDR R5, R0, #4
        LDR R6, R0, #5
        BRnzp POLLE

TEST    HALT
;Value Assignment
  ;Colors
WHT     .FILL x7FFF
BLK     .FILL x0000
RED     .FILL x7C00
GRN     .FILL x03E0
BLU     .FILL x001F
YEL     .FILL x7FED
COLOR   .BLKW 1
;Numbers for checks
OOBC    .FILL x0200             ;Out of bounds check
NN      .FILL xFFF7
NT      .FILL xFFF6
TC      .FILL x0FD7
REDC    .FILL xFF8E
GRNC    .FILL xFF99
BLUC    .FILL xFF9E
YELC    .FILL xFF87
WHTC    .FILL xFFE0
CLRC    .FILL xFFF6
QUIC    .FILL xFF8F

  ;Important Display Addresses
DROPL   .BLKW 1
DORIG   .FILL xC000             ;First Display Pixel
CORIG   .FILL xC020             ;Cloud Start
CREDG   .FILL xC080             ;Cloud Edge
CXOFF   .FILL x0040             ;Cloud X Offset
CYOFF   .FILL x1400             ;Cloud Y Offset
CANXOFF .FILL x0040
CANYOFF .FILL x2980
CANORIG .FILL xD4A0
YINC    .FILL x0080
FININC  .FILL x2400             ;Offset for removal of bottom pixels
   ;Random Adresses

RAND    .BLKW 10
RAND0   .FILL xD420
RAND1   .FILL xD425
RAND2   .FILL xD42A
RAND3   .FILL xD427
RAND4   .FILL xD42A
RAND5   .FILL xD438
RAND6   .FILL xD43E
RAND7   .FILL xD430
RAND8   .FILL xD432
RAND9   .FILL xD450

;Register Storage
RSTORA  .BLKW 7

DROPN   .BLKW 1
RTHREE  .BLKW 1

;Keyboard Registers
KBSRPtr .FILL xFE00
KBDRPtr .FILL xFE02
