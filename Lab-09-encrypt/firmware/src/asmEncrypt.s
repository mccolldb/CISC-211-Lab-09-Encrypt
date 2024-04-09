/*** asmEncrypt.s   ***/

#include <xc.h>

// Declare the following to be in data memory 
.data  

/* create a string */
.global nameStr
.type nameStr,%gnu_unique_object
    
/*** STUDENTS: Change the next line to your name!  **/
nameStr: .asciz "David McColl"  
 
/* initialize a global variable that C can access to print the nameStr */
.global nameStrPtr
.type nameStrPtr,%gnu_unique_object
nameStrPtr: .word nameStr   /* Assign the mem loc of nameStr to nameStrPtr */

// Define the globals so that the C code can access them
// (in this lab we return the pointer, so strictly speaking,
// doesnot really need to be defined as global)
.global cipherText
.type cipherText,%gnu_unique_object

.align
// space allocated for cipherText: 200 bytes, prefilled with 0x2A */
cipherText: .space 200,0x2A  
 
.global cipherTextPtr
.type cipherTextPtr,%gnu_unique_object
cipherTextPtr: .word cipherText

// Tell the assembler that what follows is in instruction memory    
.text
.align

// Tell the assembler to allow both 16b and 32b extended Thumb instructions
.syntax unified

    
/********************************************************************
function name: asmEncrypt
function description:
     pointerToCipherText = asmEncrypt ( ptrToInputText , key )
     
where:
     input:
     ptrToInputText: location of first character in null-terminated
                     input string. Per calling convention, passed in via r0.
     key:            shift value (K). Range 0-25. Passed in via r1.
     
     output:
     pointerToCipherText: mem location (address) of first character of
                          encrypted text. Returned in r0
     
     function description: asmEncrypt reads each character of an input
                           string, uses a shifted alphabet to encrypt it,
                           and stores the new character value in memory
                           location beginning at "cipherText". After copying
                           a character to cipherText, a pointer is incremented 
                           so that the next letter is stored in the bext byte.
                           Only encrypt characters in the range [a-zA-Z].
                           Any other characters should just be copied as-is
                           without modifications
                           Stop processing the input string when a NULL (0)
                           byte is reached. Make sure to add the NULL at the
                           end of the cipherText string.
     
     notes:
        The return value will always be the mem location defined by
        the label "cipherText".
     
     
********************************************************************/    
.global asmEncrypt
.type asmEncrypt,%function
asmEncrypt:   
    // pointerToCipherText = asmEncrypt ( ptrToInputText , key )
    //         R0                              R0          R1
    // save the callers registers, as required by the ARM calling convention
    push {r4-r11,LR}
    
    /* YOUR asmEncrypt CODE BELOW THIS LINE! VVVVVVVVVVVVVVVVVVVVV  */
    // SUB R1,R1,'A'      // calc offset from 'A' to key char.
    LDR R3,=cipherText    // initialize pointer to cyphertext char
1:
    LDRB R2,[R0],1  // read plaintext char --> R2
    CMP R2,'A'
    BLT not_capital
    CMP R2,'Z'
    BGT not_capital
    ADD  R2,R2,R1   // is a capital letter -- encrypt it!
    CMP R2,'Z'      // check capital for wrap
    SUBGT R2,R2,26
    B rdy2write
not_capital:
    CMP R2,'a'
    BLT not_lower
    CMP R2,'z'
    BGT not_lower
    ADD  R2,R2,R1  // is a lower letter -- encrypt it!
    CMP R2,'z'     // check for lower wrap
    SUBGT R2,R2,26
not_lower:
rdy2write:
    STRB R2,[R3],1  // write cyphertetxt char
    CMP R2,0        // check for NUL terminator
    BNE 1b
    LDR R0,=cipherText /* return addr(encrypted string) */

    /* YOUR asmEncrypt CODE ABOVE THIS LINE! ^^^^^^^^^^^^^^^^^^^^^  */

    // restore the caller's registers, as required by the ARM calling convention
    pop {r4-r11,LR}
    mov pc, lr	 /* asmEncrypt return to caller */
/**********************************************************************/   
.end  /* The assembler will not process anything after this directive!!! */
           




