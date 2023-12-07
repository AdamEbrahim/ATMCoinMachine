nop
nop
nop
nop
init:
j main
#j startBeamBreak

# startBeamBreak:
# #Memory 1: beambroken1
# #Memory 2: beambroken5
# #Memory 3: beambroken10
# #Memory 4: beambroken25
# lw $14, 1($0) # $14 = beambroken1
# lw $15, 2($0) # $15 = beambroken5
# lw $16, 3($0) # $16 = beambroken10
# lw $17, 4($0) # $17 = beambroken25
# bne $14, $0, oneCent # if beambroken1 is not 0, go to oneCent
# bne $15, $0, fiveCent # if beambroken5 is not 0, go to fiveCent
# bne $16, $0, tenCent # if beambroken10 is not 0, go to tenCent
# bne $17, $0, twentyFiveCent # if beambroken25 is not 0, go to twentyFiveCent

# oneCent: #add 1 to accountBalance (memory 15)
# lw $22, 15($0) # $22 = accountBalance
# addi $22, $22, 1 # $22 = accountBalance + 1
# j startBeamBreak

# fiveCent: #add 5 to accountBalance (memory 15)
# lw $22, 15($0) # $22 = accountBalance   
# addi $22, $22, 5 # $22 = accountBalance + 5
# j startBeamBreak

# tenCent: #add 10 to accountBalance (memory 15) 
# lw $22, 15($0) # $22 = accountBalance
# addi $22, $22, 10 # $22 = accountBalance + 10
# j startBeamBreak

# twentyFiveCent: #add 25 to accountBalance (memory 15)
# lw $22, 15($0) # $22 = accountBalance
# addi $22, $22, 25 # $22 = accountBalance + 25
# j startBeamBreak


collect4DigitNumber: #a0 = memory address to store 4 digit number at
addi $29, $29, -8
sw $2, 0($29)
sw $17, 1($29)
sw $21, 2($29)
sw $10, 3($29)
sw $11, 4($29)
sw $12, 5($29)
sw $14, 6($29)
sw $22, 7($29)

addi $21, $21, 21 # $21 = 21 (current memory address of seven segment storing at)
addi $17, $17, 17 # $17 = 17 (used for final memory address of seven segment storing at)

_waitKeyLoop:
lw $2, 0($0) # $2 = keypad data
bne $13, $2, _recordNum # if GOT A NUMBER, branch
j _waitKeyLoop # else, keep checking for key

_recordNum:
sw $1, 22($0) # acknowledge that key has been read: store 1 into memory 1
sw $2, 0($21) # set first key pressed
sub $21, $21, $1 # subtract 1 from seven segment memory address storing at
sw $0, 22($0) # turn off acknowledge key: store 0 into memory 1
bne $21, $17, _waitKeyLoop # if memory address is not 21, go back to checking for key

_appendTogether: # if 4 digits have been collected
lw $10, 18($0) # $10 = get 4th most significant digit
lw $11, 19($0) # $11 = get 3rd most significant digit
lw $12, 20($0) # $12 = get 2nd most significant digit
lw $14, 21($0) # $14 = get most significant digit

addi $17, $17, 10 # 17 = 10
addi $21, $21, 100 # 21 = 100
addi $22, $22, 1000 # 22 = 1000

mul $17, $11, $17 # $17 = 3rd most significant digit * 10
mul $21, $12, $21 # $21 = 2nd most significant digit * 100
mul $22, $14, $22 # $22 = most significant digit * 1000

add $10, $10, $17 # $10 = add 2nd digit * 10        FINAL RESULT STORED IN $10
add $10, $10, $21 # $29 = add 3rd digit * 100
add $10, $10, $22 # $29 = add 4th digit * 1000

addi $28, $10, 0 # return final result as $v0 ($28)

lw $2, 0($29)
lw $17, 1($29)
lw $21, 2($29)
lw $10, 3($29)
lw $11, 4($29)
lw $12, 5($29)
lw $14, 6($29)
lw $22, 7($29)
addi $29, $29, 8
jr $31


waitForPin:
addi $29, $29, -1
sw $31, 0($29)

sw $1, 17($0) # turn LED 15 on to indicate waiting for pin
jal collect4DigitNumber
sw $0, 17($0) # turn LED 15 off to indicate done

lw $31, 0($29)
addi $29, $29, 1
jr $31 #return four digit value as $v0 ($28)


displayBalance: #argument is the pin whose balance we want to display
addi $29, $29, -8
sw $2, 0($29)
sw $3, 1($29)
sw $4, 2($29)
sw $5, 3($29)
sw $6, 4($29)
sw $7, 5($29)
sw $8, 6($29)
sw $9, 7($29)

lw $2, 0($26) # $2 = current balance at memory address of the pin passed in

_splitIntoDigits:
addi $3, $0, 0 # $3 = iterator = 0
addi $4, $0, 4 # $4 = max count of iterator
addi $5, $0, 18 # $5 = current seven segment memory address storing at
addi $6, $0, 10 # 10 for dividing

_splitDigitsLoop:
div $7, $2, $6 
mul $8, $7, $6
sub $9, $2, $8 # the digit
lw $9, 0($5)
add $2, $7, $0

addi $3, $3, 1
addi $5, $5, 1
bne $3, $4, _splitDigitsLoop

lw $2, 0($29)
lw $3, 1($29)
lw $4, 2($29)
lw $5, 3($29)
lw $6, 4($29)
lw $7, 5($29)
lw $8, 6($29)
lw $9, 7($29)
addi $29, $29, 8
jr $31


depositOrWithdraw: #TODO, returns 0 if deposit 1 if withdraw
addi $11, $0, 25
sw $11, 0($26)
addi $28, $0, 0
jr $31


deposit: #TODO
_waitKeyLoop2:
lw $12, 0($0) # $2 = keypad data
bne $13, $12, _test2 # if GOT A NUMBER, branch
j _waitKeyLoop2 # else, keep checking for key
_test2:
jal displayBalance
jr $31


withdraw: #TODO
jr $31



main:
addi $29, $29, 4096 # initialize stack pointer to be 4096 (top of RAM)
addi $1, $1, 1 # $1 = 1 (general purpose 1)
addi $13, $13, 13 # $13 = 13 (general purpose no key pressed)
# $26 = a0, $27= a1, $28 = v0

jal waitForPin # start waiting for a pin

addi $2, $28, 0 # $2 will hold the pin for future use since we may again modify $v0
addi $26, $28, 0 # $26 (a0) for display balance is the pin that was returned through $28 ($v0)
jal displayBalance # display current balance for pin

#MAKE THIS A LOOP
_loopDepositWithdraw:
add $26, $2, 0
jal depositOrWithdraw # ask user if want to deposit or withdraw and then collect value to deposit or withdraw

bne $28, $0, _withdrawing # $v0 = 0 if deposit 1 if withdraw
_depositing:
jal deposit
j _finishDepositWithdraw

_withdrawing:
jal withdraw

_finishDepositWithdraw:
#j _loopDepositWithdraw

finish:
nop
nop
nop
j finish