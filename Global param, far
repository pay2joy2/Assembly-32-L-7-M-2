DATA_SEG    SEGMENT
    MSG1    DB  'Global Param,Far, 32*L+7*M^2',13,10,'$'
    MSG2    DB  13,10,'Enter the 1st number: $'
    MSG3    DB  13,10,'Enter the 2nd number: $'
    MSG4    DB  13,10,'Result is $'
    NUM1    DW  0
    NUM2    DW  0
    RESULT  DW  0
    MUL_FAC DB  10
    COUNTER DB  0
    ARR_NUM DW  50  DUP(0)
DATA_SEG    ENDS

CODE_SEG    SEGMENT
   ASSUME CS: CODE_SEG, DS:DATA_SEG
   
    START:  
            MOV     AX, DATA_SEG        ;init data seg        
            MOV     DS, AX

    INITIAL_MSG:
            
            MOV     AH, 09              ;Preparing command
            MOV     DX, OFFSET MSG1     ;Preparing the message 
            INT     21H                 ;Initiating interruption
            
    FIRST_MSG:
            MOV     AH, 09              ;Preparing command
            MOV     DX, OFFSET MSG2     ;Preparing the message 
            INT     21H                 ;Initiating interruption

    GET_1ST_NUM: 
            MOV     AH, 01                ;Prepating command
            INT     21H                   ;Interruption
            CMP     AL,13                 ;Comparing to "Enter"      
            JZ      SECOND_MSG            ;IF equal, than jump

    CONVERT_1ST_NUM:
            SUB     AL, 48                ;Subtracting 48
            MOV     BL,AL                 ;Saving in BL
            MOV     BH,0                  ;Clearing BH
            MOV     AX,NUM1               ;Getting NUM1
            MUL     MUL_FAC               ;MUL by 10
            ADD     BX,AX                 ;adding num1 and BL
            MOV     NUM1,BX               ;Moving back to NUM1
            JMP     GET_1ST_NUM           ;Repeating insertion

    SECOND_MSG:
            MOV     AH, 09                ;Preparing command
            MOV     DX, OFFSET MSG3       ;Preparing the message   
            INT     21H                   ;Initiating interruption  


    GET_2ND_NUM:
            
            MOV     AH, 01                ;Prepating command
            INT     21H                   ;Interruption
            CMP     AL,13                 ;Comparing to "Enter"
            JZ      ADD_NUMS              ;If equal, than jump
            

    CONVERT_2ND_NUM:
            SUB     AL, 48                ;Subtracting 48
            MOV     BL,AL                 ;Saving in BL
            MOV     BH,0                  ;Saving in BH
            MOV     AX,NUM2               ;Getting NUM2
            MUL     MUL_FAC               ;MUL by 19
            ADD     BX,AX                 ;Adding NUM1 and BL
            MOV     NUM2,BX               ;Moving back to NUM2
            JMP     GET_2ND_NUM           ;Repeating insertion
            
     ADD_NUMS:
            CALL FAR ptr NUMS             ;Calling function        
            
     DISPLAYING:
            MOV     AX,RESULT             ;Getting result
            MOV     BX,10                 ;Preparing division by 10
            MOV     DI, OFFSET ARR_NUM    ;Getting initial array status
            MOV     NUM1, DI              ;Saving initial array
          
          
     BREAKING_NUM:
            MOV     DX,0                  ;Clearing DX 
            DIV     BX                    ;Dividing by 10
            ADD     DX,48                 ;Adding 48 for char
            MOV     [DI],DX               ;Putting remainder DX in DI
            INC     DI                    ;Increasing DI index
            CMP     AX,0                  ;Comparing to 0
            JZ      JOIN_N_DISPLAY        ;If equal than display number
            JMP     BREAKING_NUM          ;If not, repeat breaking

    JOIN_N_DISPLAY:
            MOV     DX, [DI]              ;Getting first char
            MOV     AH,02                 ;Preparing command
            INT     21H                   ;Initiating interruption
            CMP     NUM1,DI               ;Comparing to initial array
            JZ      EXIT_PROGRAM          ;If equal than end programm
            DEC     DI                    ;Decrease index
            JMP     JOIN_N_DISPLAY        ;If not, repeat display

    EXIT_PROGRAM:
            MOV     AH, 4CH               ;Preparing command
            MOV     AL, 0                 ;Clearing AL
            INT     21H                   ;Initiating interruption

CODE_SEG    ENDS

FUNC_SEG SEGMENT
        ASSUME CS: FUNC_SEG, DS:DATA_SEG
        
        NUMS proc FAR
            MOV     AX, 32                  ;Preparing mul by 32
            MOV     BX, NUM1                ;Getting Num1 to BX
            MUL     BX                      ;MUL AX BY BX
            MOV     BX, AX                  ;Store result in BX
            
            
            MOV     AX, NUM2                ;Storing NUM2 in AX
            MOV     CX, NUM2                ;Storing NUM2 in CX
            MUL     CX                      ;Powering
            MOV     CX, AX                  ;Storing result in CX
            MOV     AX, 7                   ;Preparing mul by 7
            MUL     CX                      ;Mul by 7
            MOV     CX, AX                  ;Store result in CX
            
            ADD     CX,BX                   ;Adding CX and BX
            
            MOV     RESULT,CX

            MOV     AH, 09                  ;Preparing command 
            MOV     DX, OFFSET MSG4         ;Preparing message
            INT     21H                     ;Initiating interruption
            
            retf                            ;returning from function

      NUMS endp      
            
FUNC_SEG ENDS 
       
    END START
