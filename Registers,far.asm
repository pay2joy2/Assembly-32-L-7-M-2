DATA_SEG    SEGMENT
    MSG1    DB  'Registers,Far, 32*L+7*M^2',13,10,'$'
    MSG2    DB  13,10,'Enter the 1st number: $'
    MSG3    DB  13,10,'Enter the 2nd number: $'
    MSG4    DB  13,10,'Result is $'
    MULFAC DB  10
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
            
            
        STACK_INIT:
            PUSH    BP                   ;Initializing stack pointer
            MOV     BP,SP                ;Getting stack pointer
            PUSH    0                    ;Pushing space reserved for variable
                    
    
        GET_1ST_NUM:
            MOV     AH, 01                ;Prepating command
            INT     21H                   ;Interruption
            CMP     AL,13                 ;Comparing to "Enter"
            JZ      SECOND_STACK_INIT     ;If equal, than jump
            
        
        CONVERT_1ST_NUM:
            
            SUB     AL,48                 ;Subbtracting 48
            MOV     DL,AL                 ;Saving in DL
            
            POP     AX                    ;Poping num to AX
            MUL     MULFAC                ;MUL by 10
            PUSH    AX                    ;Pushing AX back
            
            ADD     [BP-2],DL             ;Adding DL to pushed num              
            JMP     GET_1ST_NUM           ;jump to get another num
          
            
        SECOND_STACK_INIT:
            
            PUSH    0                     ;Reserving space for second num
            
        SECOND_MSG:
            MOV     AH, 09                ;Preparing command
            MOV     DX, OFFSET MSG3       ;Preparing the message   
            INT     21H                   ;Initiating interruption  
            
        GET_2ND_NUM:
            
            MOV     AH, 01                ;Preparing command
            INT     21H                   ;Interruption
            CMP     AL,13                 ;Comparing to "Enter"
            JZ      CALL_FUNC             ;If equal, than jump
            
        CONVERT_2ND_NUM:
            
            SUB     AL,48                 ;Subtracting 48
            MOV     DL,AL                 ;Saving in DL
            
            POP     AX                    ;Poping num to AX
            MUL     MULFAC                ;MUL by 10
            PUSH    AX                    ;Pushing AX back
            
            
            ADD     [BP-4],DL             ;Adding DL to pushed num                        
            JMP     GET_2ND_NUM           ;jump to get another num     
            
        CALL_FUNC:
            MOV     CX,[BP-4]             ;Moving from stack to registers
            MOV     BX,[BP-2]             ;Moving from stack to registers
            CALL FAR ptr NUMS             ;Calling function
            
            
        DISPLAYING:
            MOV     AX,CX                 ;Moving result to AX
            MOV     BX,10                 ;Moving to divide by 10
            MOV     CX,0                  ;Clearing CX to use as counter
          
        BREAKING_NUM:
            MOV     DX,0                  ;Clearing DX
            DIV     BX                    ;Div AX by 10
            PUSH    DX                    ;Pushing remains to stack           
            INC     CX                    ;Incrementing counter
            CMP     AX,0                  ;Checking if AX is 0
            JZ      JOIN_N_DISPLAY        ;If equal than display num
            JMP     BREAKING_NUM          ;If not, repeat breaking

        JOIN_N_DISPLAY:
            POP     DX                    ;Poping num from stack
            ADD     DL,48                 ;Adding 48 to convert to char
            MOV     AH,02                 ;Preparing the command
            INT     21H                   ;Initiating interruption
            DEC     CX                    ;Decreasing counter
            CMP     CX,0                  ;Comparing if counter is zero
            JZ      EXIT_PROGRAM          ;If equal, jump to exit programm function
            JMP     JOIN_N_DISPLAY        ;If not, continue to display nums
            
        EXIT_PROGRAM:
            MOV     AH, 4CH               ;Preparing command
            MOV     AL, 0                 ;Clearing AL
            INT     21H                   ;Initiating interruption

CODE_SEG    ENDS

FUNC_SEG SEGMENT
        ASSUME CS: FUNC_SEG, DS:DATA_SEG
        
        NUMS proc FAR
            MOV     AX, 32                 ;Preparing mul by 32
            MUL     BX                     ;Mul AX by BX
            MOV     BX, AX                 ;Store result in BX
            
            
            MOV     AX, CX                 ;Storing CX in AX to power
            MUL     CX                     ;Mul AX by CX (power 2)
            MOV     CX, AX                 ;Store result in CX
            MOV     AX, 7                  ;Preparing mul by 7
            MUL     CX                     ;Mul by 7
            MOV     CX, AX                 ;Store result in CX
            
            ADD     CX,BX                  ;Adding CX and BX
                
            MOV     AH, 09                 ;Preparing command 
            MOV     DX, OFFSET MSG4        ;Preparing message
            INT     21H                    ;Initiating interruption
            
            retf                           ;returning from function
            
      NUMS endp      
            
FUNC_SEG ENDS 
       
    END START
