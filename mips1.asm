.data 

titulo: .asciiz ">>>>>>>>>>>>>>> El dia siguiente <<<<<<<<<<<<<<<<<<<<\n"
subtitulo: .asciiz "*** Ingrese una fecha ***\n"
dia: .asciiz "dia(dd) :\n"
mes: .asciiz "mes(mm): \n"
anio: .asciiz "anio(aaaa) :\n"
nextday: .asciiz "El dia siguiente al ingresado es :\n"
barra: .asciiz "/"

meses: .word 1 3 5 7 8 10 12

.eqv TAM 7
.eqv DIATREINTA 30
.eqv DIAOCHO 28
.eqv DIAUNO 31


.text
	
###MAIN###
	li $v0, 4
	la $a0, titulo
	syscall
	
	li $v0, 4
	la $a0, subtitulo
	syscall
	
### pedir elementos ###
#dia
	li $v0, 4
	la $a0, dia
	syscall
	li $v0, 5
	syscall
	move $s1, $v0
#mes
	li $v0, 4
	la $a0, mes
	syscall
	li $v0, 5
	syscall
	move $s2, $v0		
#anio
	li $v0, 4
	la $a0, anio
	syscall
	li $v0, 5
	syscall
	move $s3, $v0

## Procesamiento ###
	li $t3, 0  ##iterador
	li $s4, TAM
	la $s5, meses
	li $s6, 28
	li $s7, 30
	li $s0, 31
	
## Compara si el anio es bisiesto ##
  	rem $t0, $s3, 4     # $s1 = year % 4
  	rem $t1, $s3, 100   # $s2 = year % 100
  	rem $t2, $s3, 400   # $s3 = year % 400
  	bne $t0, $zero, false  # no es divisible por 4?
  	beq $s1, $zero, false  # es divisible por 100?
  
  	true:
  # si es bisieto hay que comparar si el mes es febrero y si el dia es 29
  	bne $s2, 2, loop 	
	li $t6, 29
#comparar si el dia es 28
	slt $t1, $s1, $t6
	beq $t1, $zero, elsebisiesto
#si el dia es menor a 29 se aumenta en 1
	addi $s1, $s1, 1
	j mostrar
#si el dia es 29 se cambia el dia por 1 y se aumenta el mes en 1	
	elsebisiesto:
	li $s1, 1
	addi $s2, $s2, 1
	j mostrar
  	
  	
  	false:
  	beq $t2, $zero, true  # es divisible por 400?
  	j notbisiesto


	notbisiesto:
### Comparar caso 1 - si es el mes es Febrero ####
	bne $s2, 2, loop 	
	
#comparar si el dia es 28
	slt $t1, $s1, $s6
	beq $t1, $zero, elseocho
#si el dia es menor a 28 se aumenta en 1
	addi $s1, $s1, 1
	j mostrar
#si el dia es 28 se cambia el dia por 1 y se aumenta el mes en 1	
	elseocho:
	li $s1, 1
	addi $s2, $s2, 1
	j mostrar
	
	loop:
	
	bge $t3, $s4, exitloop
	
	sll $t0, $t3, 2
	add $t0, $t0, $s5
	lw $t5, 0($t0)
	
	beq $t5,$s2,elseuno
	
	
	addi $t3,$t3,1
	j loop
### Comparar caso 2 - si el mes tiene 30 dias
	exitloop:
	
	slt $t1, $s1, $s7
	beq $t1, $zero, elsetreinta
#menor a 30
	
	addi $s1, $s1, 1
	j mostrar
	
#si es 30
	elsetreinta:
	li $s1, 1
	addi $s2, $s2, 1
	j mostrar
	
	
##comparar caso 3 - si el mes tiene 31 dias	
	elseuno:
	li $t2, 12
##comparar si el mes es diciembre
	beq $s2, $t2, diciembre
	
#Si no es diciembre
#Compara si el dia es 31
	slt $t1, $s1, $s0
	beq $t1, $zero, else
#menor a 31
	addi $s1, $s1, 1
	j mostrar 
#el dia es 31
	else:
	li $s1, 1
	addi $s2, $s2, 1
	
	j mostrar

#Si es diciembre
	diciembre: 
#compara si es 31 de diciembre
	slt $t1, $s1, $s0
	beq $t1, $zero, elsefinal
#menor a 31
	addi $s1, $s1, 1
	j mostrar 
#el dia es 31 de diciembre
	elsefinal:
	li $s1, 1
	li $s2, 1
	addi $s3, $s3, 1
	
	j mostrar
	
### imprimir resultados ###	
	mostrar:
	li $v0, 4
	la $a0, nextday
	syscall

	li $v0, 1
	la $a0, ($s1)
	syscall
	
	li $v0, 4
	la $a0, barra
	syscall
	
	li $v0, 1
	la $a0, ($s2)
	syscall
	
	li $v0, 4
	la $a0, barra
	syscall
	
	li $v0, 1
	la $a0, ($s3)
	syscall

	
	
	li $v0, 10
	syscall

## Makima barkf barkf
	
