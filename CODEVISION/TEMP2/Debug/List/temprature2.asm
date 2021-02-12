
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : float, width, precision
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _tx_wr_index=R5
	.DEF _tx_rd_index=R4
	.DEF _tx_counter=R7

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart_tx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_font5x7:
	.DB  0x5,0x7,0x20,0x60,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x5F,0x0,0x0,0x0,0x7
	.DB  0x0,0x7,0x0,0x14,0x7F,0x14,0x7F,0x14
	.DB  0x24,0x2A,0x7F,0x2A,0x12,0x23,0x13,0x8
	.DB  0x64,0x62,0x36,0x49,0x55,0x22,0x50,0x0
	.DB  0x5,0x3,0x0,0x0,0x0,0x1C,0x22,0x41
	.DB  0x0,0x0,0x41,0x22,0x1C,0x0,0x8,0x2A
	.DB  0x1C,0x2A,0x8,0x8,0x8,0x3E,0x8,0x8
	.DB  0x0,0x50,0x30,0x0,0x0,0x8,0x8,0x8
	.DB  0x8,0x8,0x0,0x30,0x30,0x0,0x0,0x20
	.DB  0x10,0x8,0x4,0x2,0x3E,0x51,0x49,0x45
	.DB  0x3E,0x0,0x42,0x7F,0x40,0x0,0x42,0x61
	.DB  0x51,0x49,0x46,0x21,0x41,0x45,0x4B,0x31
	.DB  0x18,0x14,0x12,0x7F,0x10,0x27,0x45,0x45
	.DB  0x45,0x39,0x3C,0x4A,0x49,0x49,0x30,0x1
	.DB  0x71,0x9,0x5,0x3,0x36,0x49,0x49,0x49
	.DB  0x36,0x6,0x49,0x49,0x29,0x1E,0x0,0x36
	.DB  0x36,0x0,0x0,0x0,0x56,0x36,0x0,0x0
	.DB  0x0,0x8,0x14,0x22,0x41,0x14,0x14,0x14
	.DB  0x14,0x14,0x41,0x22,0x14,0x8,0x0,0x2
	.DB  0x1,0x51,0x9,0x6,0x32,0x49,0x79,0x41
	.DB  0x3E,0x7E,0x11,0x11,0x11,0x7E,0x7F,0x49
	.DB  0x49,0x49,0x36,0x3E,0x41,0x41,0x41,0x22
	.DB  0x7F,0x41,0x41,0x22,0x1C,0x7F,0x49,0x49
	.DB  0x49,0x41,0x7F,0x9,0x9,0x1,0x1,0x3E
	.DB  0x41,0x41,0x51,0x32,0x7F,0x8,0x8,0x8
	.DB  0x7F,0x0,0x41,0x7F,0x41,0x0,0x20,0x40
	.DB  0x41,0x3F,0x1,0x7F,0x8,0x14,0x22,0x41
	.DB  0x7F,0x40,0x40,0x40,0x40,0x7F,0x2,0x4
	.DB  0x2,0x7F,0x7F,0x4,0x8,0x10,0x7F,0x3E
	.DB  0x41,0x41,0x41,0x3E,0x7F,0x9,0x9,0x9
	.DB  0x6,0x3E,0x41,0x51,0x21,0x5E,0x7F,0x9
	.DB  0x19,0x29,0x46,0x46,0x49,0x49,0x49,0x31
	.DB  0x1,0x1,0x7F,0x1,0x1,0x3F,0x40,0x40
	.DB  0x40,0x3F,0x1F,0x20,0x40,0x20,0x1F,0x7F
	.DB  0x20,0x18,0x20,0x7F,0x63,0x14,0x8,0x14
	.DB  0x63,0x3,0x4,0x78,0x4,0x3,0x61,0x51
	.DB  0x49,0x45,0x43,0x0,0x0,0x7F,0x41,0x41
	.DB  0x2,0x4,0x8,0x10,0x20,0x41,0x41,0x7F
	.DB  0x0,0x0,0x4,0x2,0x1,0x2,0x4,0x40
	.DB  0x40,0x40,0x40,0x40,0x0,0x1,0x2,0x4
	.DB  0x0,0x20,0x54,0x54,0x54,0x78,0x7F,0x48
	.DB  0x44,0x44,0x38,0x38,0x44,0x44,0x44,0x20
	.DB  0x38,0x44,0x44,0x48,0x7F,0x38,0x54,0x54
	.DB  0x54,0x18,0x8,0x7E,0x9,0x1,0x2,0x8
	.DB  0x14,0x54,0x54,0x3C,0x7F,0x8,0x4,0x4
	.DB  0x78,0x0,0x44,0x7D,0x40,0x0,0x20,0x40
	.DB  0x44,0x3D,0x0,0x0,0x7F,0x10,0x28,0x44
	.DB  0x0,0x41,0x7F,0x40,0x0,0x7C,0x4,0x18
	.DB  0x4,0x78,0x7C,0x8,0x4,0x4,0x78,0x38
	.DB  0x44,0x44,0x44,0x38,0x7C,0x14,0x14,0x14
	.DB  0x8,0x8,0x14,0x14,0x18,0x7C,0x7C,0x8
	.DB  0x4,0x4,0x8,0x48,0x54,0x54,0x54,0x20
	.DB  0x4,0x3F,0x44,0x40,0x20,0x3C,0x40,0x40
	.DB  0x20,0x7C,0x1C,0x20,0x40,0x20,0x1C,0x3C
	.DB  0x40,0x30,0x40,0x3C,0x44,0x28,0x10,0x28
	.DB  0x44,0xC,0x50,0x50,0x50,0x3C,0x44,0x64
	.DB  0x54,0x4C,0x44,0x0,0x8,0x36,0x41,0x0
	.DB  0x0,0x0,0x7F,0x0,0x0,0x0,0x41,0x36
	.DB  0x8,0x0,0x2,0x1,0x2,0x4,0x2,0x7F
	.DB  0x41,0x41,0x41,0x7F
__glcd_mask:
	.DB  0x0,0x1,0x3,0x7,0xF,0x1F,0x3F,0x7F
	.DB  0xFF

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0

_0x0:
	.DB  0x57,0x45,0x4C,0x43,0x4F,0x4D,0x45,0x21
	.DB  0x0,0x54,0x45,0x4D,0x50,0x52,0x41,0x54
	.DB  0x55,0x52,0x45,0x20,0x20,0x4E,0x4F,0x57
	.DB  0x3A,0x0,0x50,0x4C,0x4F,0x54,0x0,0x49
	.DB  0x4E,0x46,0x4F,0x0,0x2D,0x2D,0x3E,0x25
	.DB  0x2D,0x35,0x2E,0x32,0x66,0x3C,0x2D,0x2D
	.DB  0x0,0x7A,0x5A,0x25,0x30,0x35,0x2E,0x32
	.DB  0x66,0x20,0x43,0x58,0x78,0x0,0x42,0x4B
	.DB  0x0,0x41,0x56,0x45,0x52,0x41,0x47,0x45
	.DB  0x20,0x54,0x45,0x4D,0x50,0x52,0x41,0x54
	.DB  0x55,0x52,0x45,0x3A,0x0,0x4D,0x41,0x58
	.DB  0x20,0x54,0x45,0x4D,0x50,0x52,0x41,0x54
	.DB  0x55,0x52,0x45,0x3A,0x0,0x4D,0x49,0x4E
	.DB  0x20,0x54,0x45,0x4D,0x50,0x52,0x41,0x54
	.DB  0x55,0x52,0x45,0x3A,0x0,0x25,0x2D,0x35
	.DB  0x2E,0x32,0x66,0x0
_0x2060000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x2080060:
	.DB  0x1
_0x2080000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x09
	.DW  _0x10
	.DW  _0x0*2

	.DW  0x11
	.DW  _0x10+9
	.DW  _0x0*2+9

	.DW  0x05
	.DW  _0x10+26
	.DW  _0x0*2+26

	.DW  0x05
	.DW  _0x10+31
	.DW  _0x0*2+31

	.DW  0x03
	.DW  _0x37
	.DW  _0x0*2+62

	.DW  0x11
	.DW  _0x37+3
	.DW  _0x0*2+9

	.DW  0x05
	.DW  _0x37+20
	.DW  _0x0*2+26

	.DW  0x05
	.DW  _0x37+25
	.DW  _0x0*2+31

	.DW  0x14
	.DW  _0x3E
	.DW  _0x0*2+65

	.DW  0x10
	.DW  _0x3E+20
	.DW  _0x0*2+85

	.DW  0x10
	.DW  _0x3E+36
	.DW  _0x0*2+101

	.DW  0x03
	.DW  _0x3E+52
	.DW  _0x0*2+62

	.DW  0x11
	.DW  _0x3E+55
	.DW  _0x0*2+9

	.DW  0x05
	.DW  _0x3E+72
	.DW  _0x0*2+26

	.DW  0x05
	.DW  _0x3E+77
	.DW  _0x0*2+31

	.DW  0x01
	.DW  __seed_G104
	.DW  _0x2080060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*******************************************************
;Date    : 2/8/2021
;Author  :  Mohmmad Javad Adel
;*******************************************************/
;#include <mega16.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <glcd.h>
;#include <font5x7.h>
;#include <stdio.h>
;#include <stdlib.h>
;
;eeprom int counter=0;
;eeprom char temprature[128];
;
;void plot(void);
;void mean(void);
;
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;#define TX_BUFFER_SIZE 8
;char tx_buffer[TX_BUFFER_SIZE];
;#if TX_BUFFER_SIZE <= 256
;unsigned char tx_wr_index=0,tx_rd_index=0;
;#else
;unsigned int tx_wr_index=0,tx_rd_index=0;
;#endif
;#if TX_BUFFER_SIZE < 256
;unsigned char tx_counter=0;
;#else
;unsigned int tx_counter=0;
;#endif
;
;interrupt [USART_TXC] void usart_tx_isr(void)
; 0000 0025 {

	.CSEG
_usart_tx_isr:
; .FSTART _usart_tx_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0026 if (tx_counter)
	TST  R7
	BREQ _0x3
; 0000 0027    {
; 0000 0028    --tx_counter;
	DEC  R7
; 0000 0029    UDR=tx_buffer[tx_rd_index++];
	MOV  R30,R4
	INC  R4
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R30,Z
	OUT  0xC,R30
; 0000 002A #if TX_BUFFER_SIZE != 256
; 0000 002B    if (tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
	LDI  R30,LOW(8)
	CP   R30,R4
	BRNE _0x4
	CLR  R4
; 0000 002C #endif
; 0000 002D    }
_0x4:
; 0000 002E }
_0x3:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)
; 0000 0034 {
_putchar:
; .FSTART _putchar
; 0000 0035 while (tx_counter == TX_BUFFER_SIZE);
	ST   -Y,R26
;	c -> Y+0
_0x5:
	LDI  R30,LOW(8)
	CP   R30,R7
	BREQ _0x5
; 0000 0036 #asm("cli")
	cli
; 0000 0037 if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
	TST  R7
	BRNE _0x9
	SBIC 0xB,5
	RJMP _0x8
_0x9:
; 0000 0038    {
; 0000 0039    tx_buffer[tx_wr_index++]=c;
	MOV  R30,R5
	INC  R5
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R26,Y
	STD  Z+0,R26
; 0000 003A #if TX_BUFFER_SIZE != 256
; 0000 003B    if (tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
	LDI  R30,LOW(8)
	CP   R30,R5
	BRNE _0xB
	CLR  R5
; 0000 003C #endif
; 0000 003D    ++tx_counter;
_0xB:
	INC  R7
; 0000 003E    }
; 0000 003F else
	RJMP _0xC
_0x8:
; 0000 0040    UDR=c;
	LD   R30,Y
	OUT  0xC,R30
; 0000 0041 #asm("sei")
_0xC:
	sei
; 0000 0042 }
	JMP  _0x2120011
; .FEND
;#pragma used-
;#endif
;
;#define ADC_VREF_TYPE ((0<<REFS1) | (0<<REFS0) | (0<<ADLAR))
;unsigned int read_adc(unsigned char adc_input)
; 0000 0048 {
_read_adc:
; .FSTART _read_adc
; 0000 0049 ADMUX=adc_input | ADC_VREF_TYPE;
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	OUT  0x7,R30
; 0000 004A // Delay needed for the stabilization of the ADC input voltage
; 0000 004B delay_us(10);
	__DELAY_USB 27
; 0000 004C // Start the AD conversion
; 0000 004D ADCSRA|=(1<<ADSC);
	SBI  0x6,6
; 0000 004E // Wait for the AD conversion to complete
; 0000 004F while ((ADCSRA & (1<<ADIF))==0);
_0xD:
	SBIS 0x6,4
	RJMP _0xD
; 0000 0050 ADCSRA|=(1<<ADIF);
	SBI  0x6,4
; 0000 0051 return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	JMP  _0x2120011
; 0000 0052 }
; .FEND
;
;void main(void)
; 0000 0055 {
_main:
; .FSTART _main
; 0000 0056 int i=0;
; 0000 0057 float temp=0.0;
; 0000 0058 char send[10],buffer[16];
; 0000 0059 
; 0000 005A GLCDINIT_t glcd_init_data;
; 0000 005B DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	SBIW R28,36
	LDI  R30,LOW(0)
	STD  Y+32,R30
	STD  Y+33,R30
	STD  Y+34,R30
	STD  Y+35,R30
;	i -> R16,R17
;	temp -> Y+32
;	send -> Y+22
;	buffer -> Y+6
;	glcd_init_data -> Y+0
	__GETWRN 16,17,0
	OUT  0x1A,R30
; 0000 005C PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 005D DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x17,R30
; 0000 005E PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0000 005F DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 0060 PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 0061 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0000 0062 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (1<<PORTD4) | (1<<PORTD3) | (1<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(28)
	OUT  0x12,R30
; 0000 0063 TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 0064 TCNT0=0x00;
	OUT  0x32,R30
; 0000 0065 OCR0=0x00;
	OUT  0x3C,R30
; 0000 0066 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 0067 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 0068 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0069 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 006A ICR1H=0x00;
	OUT  0x27,R30
; 0000 006B ICR1L=0x00;
	OUT  0x26,R30
; 0000 006C OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 006D OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 006E OCR1BH=0x00;
	OUT  0x29,R30
; 0000 006F OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0070 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 0071 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 0072 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0073 OCR2=0x00;
	OUT  0x23,R30
; 0000 0074 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 0075 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 0076 MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 0077 // USART initialization
; 0000 0078 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0079 // USART Receiver: Off
; 0000 007A // USART Transmitter: On
; 0000 007B // USART Mode: Asynchronous
; 0000 007C // USART Baud Rate: 9600
; 0000 007D UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
	OUT  0xB,R30
; 0000 007E UCSRB=(0<<RXCIE) | (1<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(72)
	OUT  0xA,R30
; 0000 007F UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 0080 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0081 UBRRL=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 0082 
; 0000 0083 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0084 // ADC initialization
; 0000 0085 // ADC Clock frequency: 125.000 kHz
; 0000 0086 // ADC Voltage Reference: AREF pin
; 0000 0087 // ADC Auto Trigger Source: ADC Stopped
; 0000 0088 ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(0)
	OUT  0x7,R30
; 0000 0089 ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (0<<ADPS0);
	LDI  R30,LOW(134)
	OUT  0x6,R30
; 0000 008A SFIOR=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 008B 
; 0000 008C SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 008D TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 008E // Graphic Display Controller initialization
; 0000 008F // The KS0108 connections are specified in the
; 0000 0090 // Project|Configure|C Compiler|Libraries|Graphic Display menu:
; 0000 0091 // DB0 - PORTB Bit 0
; 0000 0092 // DB1 - PORTB Bit 1
; 0000 0093 // DB2 - PORTB Bit 2
; 0000 0094 // DB3 - PORTB Bit 3
; 0000 0095 // DB4 - PORTB Bit 4
; 0000 0096 // DB5 - PORTB Bit 5
; 0000 0097 // DB6 - PORTB Bit 6
; 0000 0098 // DB7 - PORTB Bit 7
; 0000 0099 // E - PORTC Bit 0
; 0000 009A // RD /WR - PORTC Bit 1
; 0000 009B // RS - PORTC Bit 2
; 0000 009C // /RST - PORTC Bit 3
; 0000 009D // CS1 - PORTC Bit 4
; 0000 009E // CS2 - PORTC Bit 5
; 0000 009F glcd_init_data.font=font5x7;
	LDI  R30,LOW(_font5x7*2)
	LDI  R31,HIGH(_font5x7*2)
	ST   Y,R30
	STD  Y+1,R31
; 0000 00A0 glcd_init_data.readxmem=NULL;
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+2+1,R30
; 0000 00A1 glcd_init_data.writexmem=NULL;
	STD  Y+4,R30
	STD  Y+4+1,R30
; 0000 00A2 glcd_init(&glcd_init_data);
	MOVW R26,R28
	RCALL _glcd_init
; 0000 00A3 #asm("sei")
	sei
; 0000 00A4 glcd_clear();
	CALL _glcd_clear
; 0000 00A5 glcd_outtextxy(40,20,"WELCOME!");
	LDI  R30,LOW(40)
	ST   -Y,R30
	LDI  R30,LOW(20)
	ST   -Y,R30
	__POINTW2MN _0x10,0
	CALL _glcd_outtextxy
; 0000 00A6 for(i=0;i<10;i++) {
	__GETWRN 16,17,0
_0x12:
	__CPWRN 16,17,10
	BRGE _0x13
; 0000 00A7    delay_ms(10);
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _delay_ms
; 0000 00A8    glcd_bar(10+10*i, 40, 20+10*i, 50);
	LDI  R26,LOW(10)
	MULS R16,R26
	MOVW R30,R0
	MOVW R26,R30
	SUBI R30,-LOW(10)
	ST   -Y,R30
	LDI  R30,LOW(40)
	ST   -Y,R30
	MOVW R30,R26
	SUBI R30,-LOW(20)
	ST   -Y,R30
	LDI  R26,LOW(50)
	CALL _glcd_bar
; 0000 00A9 }
	__ADDWRN 16,17,1
	RJMP _0x12
_0x13:
; 0000 00AA glcd_clear();
	CALL SUBOPT_0x0
; 0000 00AB glcd_rectround(2,2,124,60, 5);
; 0000 00AC glcd_outtextxy(15,5,"TEMPRATURE  NOW:");
	__POINTW2MN _0x10,9
	CALL SUBOPT_0x1
; 0000 00AD glcd_circle(32,43,15);
; 0000 00AE glcd_outtextxy(21,40,"PLOT");
	__POINTW2MN _0x10,26
	CALL SUBOPT_0x2
; 0000 00AF glcd_circle(95,43,15);
; 0000 00B0 glcd_outtextxy(83,40,"INFO");
	__POINTW2MN _0x10,31
	CALL _glcd_outtextxy
; 0000 00B1 delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 00B2 while (1)
_0x14:
; 0000 00B3       {
; 0000 00B4         temp = read_adc(0);
	LDI  R26,LOW(0)
	RCALL _read_adc
	CLR  R22
	CLR  R23
	CALL __CDF1
	__PUTD1S 32
; 0000 00B5         temprature[counter]=(temp-4)/4;
	CALL SUBOPT_0x3
	SUBI R30,LOW(-_temprature)
	SBCI R31,HIGH(-_temprature)
	PUSH R31
	PUSH R30
	__GETD1S 32
	CALL SUBOPT_0x4
	POP  R26
	POP  R27
	CALL __CFD1U
	CALL __EEPROMWRB
; 0000 00B6         counter++;
	CALL SUBOPT_0x3
	ADIW R30,1
	CALL __EEPROMWRW
; 0000 00B7         if(counter>128){counter=0;}
	CALL SUBOPT_0x3
	CPI  R30,LOW(0x81)
	LDI  R26,HIGH(0x81)
	CPC  R31,R26
	BRLT _0x17
	LDI  R26,LOW(_counter)
	LDI  R27,HIGH(_counter)
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EEPROMWRW
; 0000 00B8         sprintf(buffer,"-->%-5.2f<--",(temp-4)/4);
_0x17:
	MOVW R30,R28
	ADIW R30,6
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,36
	CALL SUBOPT_0x5
	CALL SUBOPT_0x6
; 0000 00B9         glcd_outtextxy(33,15,buffer);
	LDI  R30,LOW(33)
	ST   -Y,R30
	LDI  R30,LOW(15)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,8
	CALL _glcd_outtextxy
; 0000 00BA         if(PIND.2==0){ while(PIND.2==0); plot(); }
	SBIC 0x10,2
	RJMP _0x18
_0x19:
	SBIS 0x10,2
	RJMP _0x19
	RCALL _plot
; 0000 00BB         if(PIND.4==0){ while(PIND.4==0); mean(); }
_0x18:
	SBIC 0x10,4
	RJMP _0x1C
_0x1D:
	SBIS 0x10,4
	RJMP _0x1D
	RCALL _mean
; 0000 00BC         sprintf(send,"zZ%05.2f CXx",(temp-4)/4);
_0x1C:
	MOVW R30,R28
	ADIW R30,22
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,49
	CALL SUBOPT_0x5
	CALL SUBOPT_0x6
; 0000 00BD         for(i=0;i<10;i++)
	__GETWRN 16,17,0
_0x21:
	__CPWRN 16,17,10
	BRGE _0x22
; 0000 00BE         {
; 0000 00BF                 putchar(send[i]);
	MOVW R26,R28
	ADIW R26,22
	ADD  R26,R16
	ADC  R27,R17
	LD   R26,X
	RCALL _putchar
; 0000 00C0         }
	__ADDWRN 16,17,1
	RJMP _0x21
_0x22:
; 0000 00C1         if(PIND.2==0){ while(PIND.2==0); plot(); }
	SBIC 0x10,2
	RJMP _0x23
_0x24:
	SBIS 0x10,2
	RJMP _0x24
	RCALL _plot
; 0000 00C2         if(PIND.4==0){ while(PIND.4==0); mean(); }
_0x23:
	SBIC 0x10,4
	RJMP _0x27
_0x28:
	SBIS 0x10,4
	RJMP _0x28
	RCALL _mean
; 0000 00C3         delay_ms(125);
_0x27:
	LDI  R26,LOW(125)
	LDI  R27,0
	CALL _delay_ms
; 0000 00C4         if(PIND.2==0){ while(PIND.2==0); plot(); }
	SBIC 0x10,2
	RJMP _0x2B
_0x2C:
	SBIS 0x10,2
	RJMP _0x2C
	RCALL _plot
; 0000 00C5         if(PIND.4==0){ while(PIND.4==0); mean(); }
_0x2B:
	SBIC 0x10,4
	RJMP _0x2F
_0x30:
	SBIS 0x10,4
	RJMP _0x30
	RCALL _mean
; 0000 00C6       }
_0x2F:
	RJMP _0x14
; 0000 00C7 }
_0x33:
	RJMP _0x33
; .FEND

	.DSEG
_0x10:
	.BYTE 0x24
;
;
;void plot(void){
; 0000 00CA void plot(void){

	.CSEG
_plot:
; .FSTART _plot
; 0000 00CB int i=0;
; 0000 00CC glcd_clear();
	CALL SUBOPT_0x7
;	i -> R16,R17
; 0000 00CD glcd_rectround(0,0,128,64, 0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R30,LOW(128)
	ST   -Y,R30
	LDI  R30,LOW(64)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _glcd_rectround
; 0000 00CE for(i = 1; i<counter;i++){
	__GETWRN 16,17,1
_0x35:
	CALL SUBOPT_0x3
	CP   R16,R30
	CPC  R17,R31
	BRGE _0x36
; 0000 00CF     glcd_line(i-1,64-temprature[i-1],i,64-temprature[i]);
	MOV  R30,R16
	SUBI R30,LOW(1)
	ST   -Y,R30
	MOVW R30,R16
	SBIW R30,1
	SUBI R30,LOW(-_temprature)
	SBCI R31,HIGH(-_temprature)
	MOVW R26,R30
	CALL __EEPROMRDB
	LDI  R26,LOW(64)
	SUB  R26,R30
	ST   -Y,R26
	ST   -Y,R16
	CALL SUBOPT_0x8
	LDI  R26,LOW(64)
	SUB  R26,R30
	CALL _glcd_line
; 0000 00D0 }
	__ADDWRN 16,17,1
	RJMP _0x35
_0x36:
; 0000 00D1 glcd_circle(10,15,10);
	LDI  R30,LOW(10)
	ST   -Y,R30
	LDI  R30,LOW(15)
	ST   -Y,R30
	LDI  R26,LOW(10)
	CALL _glcd_circle
; 0000 00D2 glcd_outtextxy(5,13,"BK");
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R30,LOW(13)
	ST   -Y,R30
	__POINTW2MN _0x37,0
	CALL _glcd_outtextxy
; 0000 00D3 while(PIND.3==1);
_0x38:
	SBIC 0x10,3
	RJMP _0x38
; 0000 00D4 while(PIND.3==0);
_0x3B:
	SBIS 0x10,3
	RJMP _0x3B
; 0000 00D5 glcd_clear();
	CALL SUBOPT_0x0
; 0000 00D6 glcd_rectround(2,2,124,60, 5);
; 0000 00D7 glcd_outtextxy(15,5,"TEMPRATURE  NOW:");
	__POINTW2MN _0x37,3
	CALL SUBOPT_0x1
; 0000 00D8 glcd_circle(32,43,15);
; 0000 00D9 glcd_outtextxy(21,40,"PLOT");
	__POINTW2MN _0x37,20
	CALL SUBOPT_0x2
; 0000 00DA glcd_circle(95,43,15);
; 0000 00DB glcd_outtextxy(83,40,"INFO");
	__POINTW2MN _0x37,25
	CALL _glcd_outtextxy
; 0000 00DC }
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND

	.DSEG
_0x37:
	.BYTE 0x1E
;
;void mean(void){
; 0000 00DE void mean(void){

	.CSEG
_mean:
; .FSTART _mean
; 0000 00DF int i=0;
; 0000 00E0 float show=0;
; 0000 00E1 char buffer[20];
; 0000 00E2 glcd_clear();
	SBIW R28,24
	LDI  R30,LOW(0)
	STD  Y+20,R30
	STD  Y+21,R30
	STD  Y+22,R30
	STD  Y+23,R30
	CALL SUBOPT_0x7
;	i -> R16,R17
;	show -> Y+22
;	buffer -> Y+2
; 0000 00E3 glcd_outtextxy(10,5,"AVERAGE TEMPRATURE:");
	LDI  R30,LOW(10)
	ST   -Y,R30
	LDI  R30,LOW(5)
	ST   -Y,R30
	__POINTW2MN _0x3E,0
	CALL _glcd_outtextxy
; 0000 00E4 glcd_outtextxy(10,25,"MAX TEMPRATURE:");
	LDI  R30,LOW(10)
	ST   -Y,R30
	LDI  R30,LOW(25)
	ST   -Y,R30
	__POINTW2MN _0x3E,20
	CALL _glcd_outtextxy
; 0000 00E5 glcd_outtextxy(10,45,"MIN TEMPRATURE:");
	LDI  R30,LOW(10)
	ST   -Y,R30
	LDI  R30,LOW(45)
	ST   -Y,R30
	__POINTW2MN _0x3E,36
	CALL _glcd_outtextxy
; 0000 00E6 for(i=0;i<counter;i++){
	__GETWRN 16,17,0
_0x40:
	CALL SUBOPT_0x3
	CP   R16,R30
	CPC  R17,R31
	BRGE _0x41
; 0000 00E7 show = show + temprature[i];
	CALL SUBOPT_0x8
	LDI  R31,0
	CALL SUBOPT_0x9
	CALL __ADDF12
	CALL SUBOPT_0xA
; 0000 00E8 }
	__ADDWRN 16,17,1
	RJMP _0x40
_0x41:
; 0000 00E9 show = show / counter ;
	CALL SUBOPT_0x3
	CALL SUBOPT_0x9
	CALL __DIVF21
	CALL SUBOPT_0xA
; 0000 00EA sprintf(buffer,"%-5.2f",show);
	CALL SUBOPT_0xB
; 0000 00EB glcd_outtextxy(20,15,buffer);
	LDI  R30,LOW(20)
	ST   -Y,R30
	LDI  R30,LOW(15)
	CALL SUBOPT_0xC
; 0000 00EC show = temprature[0];
; 0000 00ED for(i=1;i<counter;i++){
_0x43:
	CALL SUBOPT_0x3
	CP   R16,R30
	CPC  R17,R31
	BRGE _0x44
; 0000 00EE if(show <= temprature[i]){ show = temprature[i]; }
	CALL SUBOPT_0x8
	CALL SUBOPT_0xD
	BREQ PC+3
	BRCS PC+2
	RJMP _0x45
	CALL SUBOPT_0x8
	CALL SUBOPT_0xE
; 0000 00EF }
_0x45:
	__ADDWRN 16,17,1
	RJMP _0x43
_0x44:
; 0000 00F0 sprintf(buffer,"%-5.2f",show);
	CALL SUBOPT_0xB
; 0000 00F1 glcd_outtextxy(20,35,buffer);
	LDI  R30,LOW(20)
	ST   -Y,R30
	LDI  R30,LOW(35)
	CALL SUBOPT_0xC
; 0000 00F2 show = temprature[0];
; 0000 00F3 for(i=1;i<counter;i++){
_0x47:
	CALL SUBOPT_0x3
	CP   R16,R30
	CPC  R17,R31
	BRGE _0x48
; 0000 00F4 if(show >= temprature[i]){ show = temprature[i]; }
	CALL SUBOPT_0x8
	CALL SUBOPT_0xD
	BRLO _0x49
	CALL SUBOPT_0x8
	CALL SUBOPT_0xE
; 0000 00F5 }
_0x49:
	__ADDWRN 16,17,1
	RJMP _0x47
_0x48:
; 0000 00F6 sprintf(buffer,"%-5.2f",show);
	CALL SUBOPT_0xB
; 0000 00F7 glcd_outtextxy(20,55,buffer);
	LDI  R30,LOW(20)
	ST   -Y,R30
	LDI  R30,LOW(55)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,4
	CALL _glcd_outtextxy
; 0000 00F8 glcd_circle(110,50,10);
	LDI  R30,LOW(110)
	ST   -Y,R30
	LDI  R30,LOW(50)
	ST   -Y,R30
	LDI  R26,LOW(10)
	CALL _glcd_circle
; 0000 00F9 glcd_outtextxy(105,48,"BK");
	LDI  R30,LOW(105)
	ST   -Y,R30
	LDI  R30,LOW(48)
	ST   -Y,R30
	__POINTW2MN _0x3E,52
	CALL _glcd_outtextxy
; 0000 00FA while(PIND.3==1);
_0x4A:
	SBIC 0x10,3
	RJMP _0x4A
; 0000 00FB while(PIND.3==0);
_0x4D:
	SBIS 0x10,3
	RJMP _0x4D
; 0000 00FC glcd_clear();
	CALL SUBOPT_0x0
; 0000 00FD glcd_rectround(2,2,124,60, 5);
; 0000 00FE glcd_outtextxy(15,5,"TEMPRATURE  NOW:");
	__POINTW2MN _0x3E,55
	CALL SUBOPT_0x1
; 0000 00FF glcd_circle(32,43,15);
; 0000 0100 glcd_outtextxy(21,40,"PLOT");
	__POINTW2MN _0x3E,72
	CALL SUBOPT_0x2
; 0000 0101 glcd_circle(95,43,15);
; 0000 0102 glcd_outtextxy(83,40,"INFO");
	__POINTW2MN _0x3E,77
	CALL _glcd_outtextxy
; 0000 0103 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,26
	RET
; .FEND

	.DSEG
_0x3E:
	.BYTE 0x52
;
;
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_ks0108_enable_G100:
; .FSTART _ks0108_enable_G100
	nop
	SBI  0x15,0
	nop
	RET
; .FEND
_ks0108_disable_G100:
; .FSTART _ks0108_disable_G100
	CBI  0x15,0
	CBI  0x15,4
	CBI  0x15,5
	RET
; .FEND
_ks0108_rdbus_G100:
; .FSTART _ks0108_rdbus_G100
	ST   -Y,R17
	RCALL _ks0108_enable_G100
	IN   R17,22
	CBI  0x15,0
	MOV  R30,R17
	LD   R17,Y+
	RET
; .FEND
_ks0108_busy_G100:
; .FSTART _ks0108_busy_G100
	ST   -Y,R26
	ST   -Y,R17
	LDI  R30,LOW(0)
	OUT  0x17,R30
	SBI  0x15,1
	CBI  0x15,2
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	MOV  R17,R30
	SBRS R17,0
	RJMP _0x2000003
	SBI  0x15,4
	RJMP _0x2000004
_0x2000003:
	CBI  0x15,4
_0x2000004:
	SBRS R17,1
	RJMP _0x2000005
	SBI  0x15,5
	RJMP _0x2000006
_0x2000005:
	CBI  0x15,5
_0x2000006:
_0x2000007:
	RCALL _ks0108_rdbus_G100
	ANDI R30,LOW(0x80)
	BRNE _0x2000007
	LDD  R17,Y+0
	RJMP _0x212000C
; .FEND
_ks0108_wrcmd_G100:
; .FSTART _ks0108_wrcmd_G100
	ST   -Y,R26
	LDD  R26,Y+1
	RCALL _ks0108_busy_G100
	CALL SUBOPT_0xF
	RJMP _0x212000C
; .FEND
_ks0108_setloc_G100:
; .FSTART _ks0108_setloc_G100
	__GETB1MN _ks0108_coord_G100,1
	ST   -Y,R30
	LDS  R30,_ks0108_coord_G100
	ANDI R30,LOW(0x3F)
	ORI  R30,0x40
	MOV  R26,R30
	RCALL _ks0108_wrcmd_G100
	__GETB1MN _ks0108_coord_G100,1
	ST   -Y,R30
	__GETB1MN _ks0108_coord_G100,2
	ORI  R30,LOW(0xB8)
	MOV  R26,R30
	RCALL _ks0108_wrcmd_G100
	RET
; .FEND
_ks0108_gotoxp_G100:
; .FSTART _ks0108_gotoxp_G100
	ST   -Y,R26
	LDD  R30,Y+1
	STS  _ks0108_coord_G100,R30
	SWAP R30
	ANDI R30,0xF
	LSR  R30
	LSR  R30
	__PUTB1MN _ks0108_coord_G100,1
	LD   R30,Y
	__PUTB1MN _ks0108_coord_G100,2
	RCALL _ks0108_setloc_G100
	RJMP _0x212000C
; .FEND
_ks0108_nextx_G100:
; .FSTART _ks0108_nextx_G100
	LDS  R26,_ks0108_coord_G100
	SUBI R26,-LOW(1)
	STS  _ks0108_coord_G100,R26
	CPI  R26,LOW(0x80)
	BRLO _0x200000A
	LDI  R30,LOW(0)
	STS  _ks0108_coord_G100,R30
_0x200000A:
	LDS  R30,_ks0108_coord_G100
	ANDI R30,LOW(0x3F)
	BRNE _0x200000B
	LDS  R30,_ks0108_coord_G100
	ST   -Y,R30
	__GETB2MN _ks0108_coord_G100,2
	RCALL _ks0108_gotoxp_G100
_0x200000B:
	RET
; .FEND
_ks0108_wrdata_G100:
; .FSTART _ks0108_wrdata_G100
	ST   -Y,R26
	__GETB2MN _ks0108_coord_G100,1
	RCALL _ks0108_busy_G100
	SBI  0x15,2
	CALL SUBOPT_0xF
_0x2120011:
	ADIW R28,1
	RET
; .FEND
_ks0108_rddata_G100:
; .FSTART _ks0108_rddata_G100
	__GETB2MN _ks0108_coord_G100,1
	RCALL _ks0108_busy_G100
	LDI  R30,LOW(0)
	OUT  0x17,R30
	SBI  0x15,1
	SBI  0x15,2
	RCALL _ks0108_rdbus_G100
	RET
; .FEND
_ks0108_rdbyte_G100:
; .FSTART _ks0108_rdbyte_G100
	ST   -Y,R26
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R30,Y+1
	CALL SUBOPT_0x10
	RCALL _ks0108_rddata_G100
	RCALL _ks0108_setloc_G100
	RCALL _ks0108_rddata_G100
	RJMP _0x212000C
; .FEND
_glcd_init:
; .FSTART _glcd_init
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	SBI  0x14,0
	SBI  0x14,1
	SBI  0x14,2
	SBI  0x14,3
	SBI  0x15,3
	SBI  0x14,4
	SBI  0x14,5
	RCALL _ks0108_disable_G100
	CBI  0x15,3
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
	SBI  0x15,3
	LDI  R17,LOW(0)
_0x200000C:
	CPI  R17,2
	BRSH _0x200000E
	ST   -Y,R17
	LDI  R26,LOW(63)
	RCALL _ks0108_wrcmd_G100
	ST   -Y,R17
	INC  R17
	LDI  R26,LOW(192)
	RCALL _ks0108_wrcmd_G100
	RJMP _0x200000C
_0x200000E:
	LDI  R30,LOW(1)
	STS  _glcd_state,R30
	LDI  R30,LOW(0)
	__PUTB1MN _glcd_state,1
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	SBIW R30,0
	BREQ _0x200000F
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL __GETW1P
	__PUTW1MN _glcd_state,4
	ADIW R26,2
	CALL __GETW1P
	__PUTW1MN _glcd_state,25
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,4
	CALL __GETW1P
	RJMP _0x20000AC
_0x200000F:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	__PUTW1MN _glcd_state,4
	__PUTW1MN _glcd_state,25
_0x20000AC:
	__PUTW1MN _glcd_state,27
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,6
	__PUTB1MN _glcd_state,7
	__PUTB1MN _glcd_state,8
	LDI  R30,LOW(255)
	__PUTB1MN _glcd_state,9
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,16
	__POINTW1MN _glcd_state,17
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDI  R26,LOW(8)
	LDI  R27,0
	CALL _memset
	RCALL _glcd_clear
	LDI  R30,LOW(1)
	LDD  R17,Y+0
	RJMP _0x212000D
; .FEND
_glcd_clear:
; .FSTART _glcd_clear
	CALL __SAVELOCR4
	LDI  R16,0
	LDI  R19,0
	__GETB1MN _glcd_state,1
	CPI  R30,0
	BREQ _0x2000015
	LDI  R16,LOW(255)
_0x2000015:
_0x2000016:
	CPI  R19,8
	BRSH _0x2000018
	LDI  R30,LOW(0)
	ST   -Y,R30
	MOV  R26,R19
	SUBI R19,-1
	RCALL _ks0108_gotoxp_G100
	LDI  R17,LOW(0)
_0x2000019:
	MOV  R26,R17
	SUBI R17,-1
	CPI  R26,LOW(0x80)
	BRSH _0x200001B
	MOV  R26,R16
	CALL SUBOPT_0x11
	RJMP _0x2000019
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _ks0108_gotoxp_G100
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _glcd_moveto
	CALL __LOADLOCR4
	ADIW R28,4
	RET
; .FEND
_glcd_putpixel:
; .FSTART _glcd_putpixel
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+4
	CPI  R26,LOW(0x80)
	BRSH _0x200001D
	LDD  R26,Y+3
	CPI  R26,LOW(0x40)
	BRLO _0x200001C
_0x200001D:
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x212000E
_0x200001C:
	LDD  R30,Y+4
	ST   -Y,R30
	LDD  R26,Y+4
	RCALL _ks0108_rdbyte_G100
	MOV  R17,R30
	RCALL _ks0108_setloc_G100
	LDD  R30,Y+3
	ANDI R30,LOW(0x7)
	LDI  R26,LOW(1)
	CALL __LSLB12
	MOV  R16,R30
	LDD  R30,Y+2
	CPI  R30,0
	BREQ _0x200001F
	OR   R17,R16
	RJMP _0x2000020
_0x200001F:
	MOV  R30,R16
	COM  R30
	AND  R17,R30
_0x2000020:
	MOV  R26,R17
	RCALL _ks0108_wrdata_G100
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x212000E
; .FEND
_glcd_getpixel:
; .FSTART _glcd_getpixel
	ST   -Y,R26
	LDD  R26,Y+1
	CPI  R26,LOW(0x80)
	BRSH _0x2000022
	LD   R26,Y
	CPI  R26,LOW(0x40)
	BRLO _0x2000021
_0x2000022:
	LDI  R30,LOW(0)
	RJMP _0x212000C
_0x2000021:
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R26,Y+1
	RCALL _ks0108_rdbyte_G100
	MOV  R1,R30
	LD   R30,Y
	ANDI R30,LOW(0x7)
	LDI  R26,LOW(1)
	CALL __LSLB12
	AND  R30,R1
	BREQ _0x2000024
	LDI  R30,LOW(1)
	RJMP _0x2000025
_0x2000024:
	LDI  R30,LOW(0)
_0x2000025:
	RJMP _0x212000C
; .FEND
_ks0108_wrmasked_G100:
; .FSTART _ks0108_wrmasked_G100
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+5
	ST   -Y,R30
	LDD  R26,Y+5
	RCALL _ks0108_rdbyte_G100
	MOV  R17,R30
	RCALL _ks0108_setloc_G100
	LDD  R30,Y+1
	CPI  R30,LOW(0x7)
	BREQ _0x200002B
	CPI  R30,LOW(0x8)
	BRNE _0x200002C
_0x200002B:
	LDD  R30,Y+3
	ST   -Y,R30
	LDD  R26,Y+2
	CALL _glcd_mappixcolor1bit
	STD  Y+3,R30
	RJMP _0x200002D
_0x200002C:
	CPI  R30,LOW(0x3)
	BRNE _0x200002F
	LDD  R30,Y+3
	COM  R30
	STD  Y+3,R30
	RJMP _0x2000030
_0x200002F:
	CPI  R30,0
	BRNE _0x2000031
_0x2000030:
_0x200002D:
	LDD  R30,Y+2
	COM  R30
	AND  R17,R30
	RJMP _0x2000032
_0x2000031:
	CPI  R30,LOW(0x2)
	BRNE _0x2000033
_0x2000032:
	LDD  R30,Y+2
	LDD  R26,Y+3
	AND  R30,R26
	OR   R17,R30
	RJMP _0x2000029
_0x2000033:
	CPI  R30,LOW(0x1)
	BRNE _0x2000034
	LDD  R30,Y+2
	LDD  R26,Y+3
	AND  R30,R26
	EOR  R17,R30
	RJMP _0x2000029
_0x2000034:
	CPI  R30,LOW(0x4)
	BRNE _0x2000029
	LDD  R30,Y+2
	COM  R30
	LDD  R26,Y+3
	OR   R30,R26
	AND  R17,R30
_0x2000029:
	MOV  R26,R17
	CALL SUBOPT_0x11
	LDD  R17,Y+0
	ADIW R28,6
	RET
; .FEND
_glcd_block:
; .FSTART _glcd_block
	ST   -Y,R26
	SBIW R28,3
	CALL __SAVELOCR6
	LDD  R26,Y+16
	CPI  R26,LOW(0x80)
	BRSH _0x2000037
	LDD  R26,Y+15
	CPI  R26,LOW(0x40)
	BRSH _0x2000037
	LDD  R26,Y+14
	CPI  R26,LOW(0x0)
	BREQ _0x2000037
	LDD  R26,Y+13
	CPI  R26,LOW(0x0)
	BRNE _0x2000036
_0x2000037:
	RJMP _0x2120010
_0x2000036:
	LDD  R30,Y+14
	STD  Y+8,R30
	LDD  R26,Y+16
	CLR  R27
	LDD  R30,Y+14
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	CPI  R26,LOW(0x81)
	LDI  R30,HIGH(0x81)
	CPC  R27,R30
	BRLO _0x2000039
	LDD  R26,Y+16
	LDI  R30,LOW(128)
	SUB  R30,R26
	STD  Y+14,R30
_0x2000039:
	LDD  R18,Y+13
	LDD  R26,Y+15
	CLR  R27
	LDD  R30,Y+13
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	CPI  R26,LOW(0x41)
	LDI  R30,HIGH(0x41)
	CPC  R27,R30
	BRLO _0x200003A
	LDD  R26,Y+15
	LDI  R30,LOW(64)
	SUB  R30,R26
	STD  Y+13,R30
_0x200003A:
	LDD  R26,Y+9
	CPI  R26,LOW(0x6)
	BREQ PC+2
	RJMP _0x200003B
	LDD  R30,Y+12
	CPI  R30,LOW(0x1)
	BRNE _0x200003F
	RJMP _0x2120010
_0x200003F:
	CPI  R30,LOW(0x3)
	BRNE _0x2000042
	__GETW1MN _glcd_state,27
	SBIW R30,0
	BRNE _0x2000041
	RJMP _0x2120010
_0x2000041:
_0x2000042:
	LDD  R16,Y+8
	LDD  R30,Y+13
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R19,R30
	MOV  R30,R18
	ANDI R30,LOW(0x7)
	BRNE _0x2000044
	LDD  R26,Y+13
	CP   R18,R26
	BREQ _0x2000043
_0x2000044:
	MOV  R26,R16
	CLR  R27
	MOV  R30,R19
	LDI  R31,0
	CALL __MULW12U
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CALL SUBOPT_0x12
	LSR  R18
	LSR  R18
	LSR  R18
	MOV  R21,R19
_0x2000046:
	PUSH R21
	SUBI R21,-1
	MOV  R30,R18
	POP  R26
	CP   R30,R26
	BRLO _0x2000048
	MOV  R17,R16
_0x2000049:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x200004B
	CALL SUBOPT_0x13
	RJMP _0x2000049
_0x200004B:
	RJMP _0x2000046
_0x2000048:
_0x2000043:
	LDD  R26,Y+14
	CP   R16,R26
	BREQ _0x200004C
	LDD  R30,Y+14
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R31,0
	CALL SUBOPT_0x12
	LDD  R30,Y+13
	ANDI R30,LOW(0x7)
	BREQ _0x200004D
	SUBI R19,-LOW(1)
_0x200004D:
	LDI  R18,LOW(0)
_0x200004E:
	PUSH R18
	SUBI R18,-1
	MOV  R30,R19
	POP  R26
	CP   R26,R30
	BRSH _0x2000050
	LDD  R17,Y+14
_0x2000051:
	PUSH R17
	SUBI R17,-1
	MOV  R30,R16
	POP  R26
	CP   R26,R30
	BRSH _0x2000053
	CALL SUBOPT_0x13
	RJMP _0x2000051
_0x2000053:
	LDD  R30,Y+14
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R31,0
	CALL SUBOPT_0x12
	RJMP _0x200004E
_0x2000050:
_0x200004C:
_0x200003B:
	LDD  R30,Y+15
	ANDI R30,LOW(0x7)
	MOV  R19,R30
_0x2000054:
	LDD  R30,Y+13
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000056
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(0)
	LDD  R16,Y+16
	CPI  R19,0
	BREQ PC+2
	RJMP _0x2000057
	LDD  R26,Y+13
	CPI  R26,LOW(0x8)
	BRSH PC+2
	RJMP _0x2000058
	LDD  R30,Y+9
	CPI  R30,0
	BREQ _0x200005D
	CPI  R30,LOW(0x3)
	BRNE _0x200005E
_0x200005D:
	RJMP _0x200005F
_0x200005E:
	CPI  R30,LOW(0x7)
	BRNE _0x2000060
_0x200005F:
	RJMP _0x2000061
_0x2000060:
	CPI  R30,LOW(0x8)
	BRNE _0x2000062
_0x2000061:
	RJMP _0x2000063
_0x2000062:
	CPI  R30,LOW(0x6)
	BRNE _0x2000064
_0x2000063:
	RJMP _0x2000065
_0x2000064:
	CPI  R30,LOW(0x9)
	BRNE _0x2000066
_0x2000065:
	RJMP _0x2000067
_0x2000066:
	CPI  R30,LOW(0xA)
	BRNE _0x200005B
_0x2000067:
	ST   -Y,R16
	LDD  R30,Y+16
	CALL SUBOPT_0x10
_0x200005B:
_0x2000069:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x200006B
	LDD  R26,Y+9
	CPI  R26,LOW(0x6)
	BRNE _0x200006C
	RCALL _ks0108_rddata_G100
	RCALL _ks0108_setloc_G100
	CALL SUBOPT_0x14
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ks0108_rddata_G100
	MOV  R26,R30
	CALL _glcd_writemem
	RCALL _ks0108_nextx_G100
	RJMP _0x200006D
_0x200006C:
	LDD  R30,Y+9
	CPI  R30,LOW(0x9)
	BRNE _0x2000071
	LDI  R21,LOW(0)
	RJMP _0x2000072
_0x2000071:
	CPI  R30,LOW(0xA)
	BRNE _0x2000070
	LDI  R21,LOW(255)
	RJMP _0x2000072
_0x2000070:
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
	MOV  R21,R30
	LDD  R30,Y+9
	CPI  R30,LOW(0x7)
	BREQ _0x2000079
	CPI  R30,LOW(0x8)
	BRNE _0x200007A
_0x2000079:
_0x2000072:
	CALL SUBOPT_0x16
	MOV  R21,R30
	RJMP _0x200007B
_0x200007A:
	CPI  R30,LOW(0x3)
	BRNE _0x200007D
	COM  R21
	RJMP _0x200007E
_0x200007D:
	CPI  R30,0
	BRNE _0x2000080
_0x200007E:
_0x200007B:
	MOV  R26,R21
	CALL SUBOPT_0x11
	RJMP _0x2000077
_0x2000080:
	CALL SUBOPT_0x17
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDD  R26,Y+13
	RCALL _ks0108_wrmasked_G100
_0x2000077:
_0x200006D:
	RJMP _0x2000069
_0x200006B:
	LDD  R30,Y+15
	SUBI R30,-LOW(8)
	STD  Y+15,R30
	LDD  R30,Y+13
	SUBI R30,LOW(8)
	STD  Y+13,R30
	RJMP _0x2000081
_0x2000058:
	LDD  R21,Y+13
	LDI  R18,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+13,R30
	RJMP _0x2000082
_0x2000057:
	MOV  R30,R19
	LDD  R26,Y+13
	ADD  R26,R30
	CPI  R26,LOW(0x9)
	BRSH _0x2000083
	LDD  R18,Y+13
	LDI  R30,LOW(0)
	STD  Y+13,R30
	RJMP _0x2000084
_0x2000083:
	LDI  R30,LOW(8)
	SUB  R30,R19
	MOV  R18,R30
_0x2000084:
	ST   -Y,R19
	MOV  R26,R18
	CALL _glcd_getmask
	MOV  R20,R30
	LDD  R30,Y+9
	CPI  R30,LOW(0x6)
	BRNE _0x2000088
_0x2000089:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x200008B
	CALL SUBOPT_0x18
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSRB12
	CALL SUBOPT_0x19
	MOV  R30,R19
	MOV  R26,R20
	CALL __LSRB12
	COM  R30
	AND  R30,R1
	OR   R21,R30
	CALL SUBOPT_0x14
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R21
	CALL _glcd_writemem
	RJMP _0x2000089
_0x200008B:
	RJMP _0x2000087
_0x2000088:
	CPI  R30,LOW(0x9)
	BRNE _0x200008C
	LDI  R21,LOW(0)
	RJMP _0x200008D
_0x200008C:
	CPI  R30,LOW(0xA)
	BRNE _0x2000093
	LDI  R21,LOW(255)
_0x200008D:
	CALL SUBOPT_0x16
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSLB12
	MOV  R21,R30
_0x2000090:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x2000092
	CALL SUBOPT_0x17
	ST   -Y,R20
	LDI  R26,LOW(0)
	RCALL _ks0108_wrmasked_G100
	RJMP _0x2000090
_0x2000092:
	RJMP _0x2000087
_0x2000093:
_0x2000094:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x2000096
	CALL SUBOPT_0x1A
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSLB12
	ST   -Y,R30
	ST   -Y,R20
	LDD  R26,Y+13
	RCALL _ks0108_wrmasked_G100
	RJMP _0x2000094
_0x2000096:
_0x2000087:
	LDD  R30,Y+13
	CPI  R30,0
	BRNE _0x2000097
	RJMP _0x2000056
_0x2000097:
	LDD  R26,Y+13
	CPI  R26,LOW(0x8)
	BRSH _0x2000098
	LDD  R30,Y+13
	SUB  R30,R18
	MOV  R21,R30
	LDI  R30,LOW(0)
	RJMP _0x20000AD
_0x2000098:
	MOV  R21,R19
	LDD  R30,Y+13
	SUBI R30,LOW(8)
_0x20000AD:
	STD  Y+13,R30
	LDI  R17,LOW(0)
	LDD  R30,Y+15
	SUBI R30,-LOW(8)
	STD  Y+15,R30
	LDI  R30,LOW(8)
	SUB  R30,R19
	MOV  R18,R30
	LDD  R16,Y+16
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x2000082:
	MOV  R30,R21
	LDI  R31,0
	SUBI R30,LOW(-__glcd_mask*2)
	SBCI R31,HIGH(-__glcd_mask*2)
	LPM  R20,Z
	LDD  R30,Y+9
	CPI  R30,LOW(0x6)
	BRNE _0x200009D
_0x200009E:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x20000A0
	CALL SUBOPT_0x18
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSLB12
	CALL SUBOPT_0x19
	MOV  R30,R18
	MOV  R26,R20
	CALL __LSLB12
	COM  R30
	AND  R30,R1
	OR   R21,R30
	CALL SUBOPT_0x14
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R21
	CALL _glcd_writemem
	RJMP _0x200009E
_0x20000A0:
	RJMP _0x200009C
_0x200009D:
	CPI  R30,LOW(0x9)
	BRNE _0x20000A1
	LDI  R21,LOW(0)
	RJMP _0x20000A2
_0x20000A1:
	CPI  R30,LOW(0xA)
	BRNE _0x20000A8
	LDI  R21,LOW(255)
_0x20000A2:
	CALL SUBOPT_0x16
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSRB12
	MOV  R21,R30
_0x20000A5:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x20000A7
	CALL SUBOPT_0x17
	ST   -Y,R20
	LDI  R26,LOW(0)
	RCALL _ks0108_wrmasked_G100
	RJMP _0x20000A5
_0x20000A7:
	RJMP _0x200009C
_0x20000A8:
_0x20000A9:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x20000AB
	CALL SUBOPT_0x1A
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSRB12
	ST   -Y,R30
	ST   -Y,R20
	LDD  R26,Y+13
	RCALL _ks0108_wrmasked_G100
	RJMP _0x20000A9
_0x20000AB:
_0x200009C:
_0x2000081:
	LDD  R30,Y+8
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x2000054
_0x2000056:
_0x2120010:
	CALL __LOADLOCR6
	ADIW R28,17
	RET
; .FEND

	.CSEG
_glcd_clipx:
; .FSTART _glcd_clipx
	CALL SUBOPT_0x1B
	BRLT _0x2020003
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x212000C
_0x2020003:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x80)
	LDI  R30,HIGH(0x80)
	CPC  R27,R30
	BRLT _0x2020004
	LDI  R30,LOW(127)
	LDI  R31,HIGH(127)
	RJMP _0x212000C
_0x2020004:
	LD   R30,Y
	LDD  R31,Y+1
	RJMP _0x212000C
; .FEND
_glcd_clipy:
; .FSTART _glcd_clipy
	CALL SUBOPT_0x1B
	BRLT _0x2020005
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x212000C
_0x2020005:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x40)
	LDI  R30,HIGH(0x40)
	CPC  R27,R30
	BRLT _0x2020006
	LDI  R30,LOW(63)
	LDI  R31,HIGH(63)
	RJMP _0x212000C
_0x2020006:
	LD   R30,Y
	LDD  R31,Y+1
	RJMP _0x212000C
; .FEND
_glcd_setpixel:
; .FSTART _glcd_setpixel
	ST   -Y,R26
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R30,Y+1
	ST   -Y,R30
	LDS  R26,_glcd_state
	RCALL _glcd_putpixel
	RJMP _0x212000C
; .FEND
_glcd_getcharw_G101:
; .FSTART _glcd_getcharw_G101
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,3
	CALL SUBOPT_0x1C
	MOVW R16,R30
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x202000B
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x212000F
_0x202000B:
	CALL SUBOPT_0x1D
	STD  Y+7,R0
	CALL SUBOPT_0x1D
	STD  Y+6,R0
	CALL SUBOPT_0x1D
	STD  Y+8,R0
	LDD  R30,Y+11
	LDD  R26,Y+8
	CP   R30,R26
	BRSH _0x202000C
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x212000F
_0x202000C:
	MOVW R30,R16
	__ADDWRN 16,17,1
	LPM  R21,Z
	LDD  R26,Y+8
	CLR  R27
	CLR  R30
	ADD  R26,R21
	ADC  R27,R30
	LDD  R30,Y+11
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	BRLO _0x202000D
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x212000F
_0x202000D:
	LDD  R30,Y+6
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R20,R30
	LDD  R30,Y+6
	ANDI R30,LOW(0x7)
	BREQ _0x202000E
	SUBI R20,-LOW(1)
_0x202000E:
	LDD  R30,Y+7
	CPI  R30,0
	BREQ _0x202000F
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
	LDD  R26,Y+8
	LDD  R30,Y+11
	SUB  R30,R26
	LDI  R31,0
	MOVW R26,R30
	LDD  R30,Y+7
	LDI  R31,0
	CALL __MULW12U
	MOVW R26,R30
	MOV  R30,R20
	LDI  R31,0
	CALL __MULW12U
	ADD  R30,R16
	ADC  R31,R17
	RJMP _0x212000F
_0x202000F:
	MOVW R18,R16
	MOV  R30,R21
	LDI  R31,0
	__ADDWRR 16,17,30,31
_0x2020010:
	LDD  R26,Y+8
	SUBI R26,-LOW(1)
	STD  Y+8,R26
	SUBI R26,LOW(1)
	LDD  R30,Y+11
	CP   R26,R30
	BRSH _0x2020012
	MOVW R30,R18
	__ADDWRN 18,19,1
	LPM  R26,Z
	LDI  R27,0
	MOV  R30,R20
	LDI  R31,0
	CALL __MULW12U
	__ADDWRR 16,17,30,31
	RJMP _0x2020010
_0x2020012:
	MOVW R30,R18
	LPM  R30,Z
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
	MOVW R30,R16
_0x212000F:
	CALL __LOADLOCR6
	ADIW R28,12
	RET
; .FEND
_glcd_new_line_G101:
; .FSTART _glcd_new_line_G101
	LDI  R30,LOW(0)
	__PUTB1MN _glcd_state,2
	__GETB2MN _glcd_state,3
	CLR  R27
	CALL SUBOPT_0x1E
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	__GETB1MN _glcd_state,7
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RCALL _glcd_clipy
	__PUTB1MN _glcd_state,3
	RET
; .FEND
_glcd_putchar:
; .FSTART _glcd_putchar
	ST   -Y,R26
	SBIW R28,1
	CALL SUBOPT_0x1C
	SBIW R30,0
	BRNE PC+2
	RJMP _0x202001F
	LDD  R26,Y+7
	CPI  R26,LOW(0xA)
	BRNE _0x2020020
	RJMP _0x2020021
_0x2020020:
	LDD  R30,Y+7
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,7
	RCALL _glcd_getcharw_G101
	MOVW R20,R30
	SBIW R30,0
	BRNE _0x2020022
	CALL __LOADLOCR6
	RJMP _0x2120009
_0x2020022:
	__GETB1MN _glcd_state,6
	LDD  R26,Y+6
	ADD  R30,R26
	MOV  R19,R30
	__GETB2MN _glcd_state,2
	CLR  R27
	CALL SUBOPT_0x1F
	__CPWRN 16,17,129
	BRLO _0x2020023
	MOV  R16,R19
	CLR  R17
	RCALL _glcd_new_line_G101
_0x2020023:
	__GETB1MN _glcd_state,2
	ST   -Y,R30
	__GETB1MN _glcd_state,3
	ST   -Y,R30
	LDD  R30,Y+8
	ST   -Y,R30
	CALL SUBOPT_0x1E
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R21
	ST   -Y,R20
	LDI  R26,LOW(7)
	RCALL _glcd_block
	__GETB1MN _glcd_state,2
	LDD  R26,Y+6
	ADD  R30,R26
	ST   -Y,R30
	__GETB1MN _glcd_state,3
	ST   -Y,R30
	__GETB1MN _glcd_state,6
	ST   -Y,R30
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x20
	__GETB1MN _glcd_state,2
	ST   -Y,R30
	__GETB2MN _glcd_state,3
	CALL SUBOPT_0x1E
	ADD  R30,R26
	ST   -Y,R30
	ST   -Y,R19
	__GETB1MN _glcd_state,7
	CALL SUBOPT_0x20
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x2020024
_0x2020021:
	RCALL _glcd_new_line_G101
	CALL __LOADLOCR6
	RJMP _0x2120009
_0x2020024:
_0x202001F:
	__PUTBMRN _glcd_state,2,16
	CALL __LOADLOCR6
	RJMP _0x2120009
; .FEND
_glcd_outtextxy:
; .FSTART _glcd_outtextxy
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+4
	ST   -Y,R30
	LDD  R26,Y+4
	RCALL _glcd_moveto
_0x2020025:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2020027
	MOV  R26,R17
	RCALL _glcd_putchar
	RJMP _0x2020025
_0x2020027:
	LDD  R17,Y+0
_0x212000E:
	ADIW R28,5
	RET
; .FEND
_glcd_putpixelm_G101:
; .FSTART _glcd_putpixelm_G101
	ST   -Y,R26
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R30,Y+2
	ST   -Y,R30
	__GETB1MN _glcd_state,9
	LDD  R26,Y+2
	AND  R30,R26
	BREQ _0x202003E
	LDS  R30,_glcd_state
	RJMP _0x202003F
_0x202003E:
	__GETB1MN _glcd_state,1
_0x202003F:
	MOV  R26,R30
	RCALL _glcd_putpixel
	LD   R30,Y
	LSL  R30
	ST   Y,R30
	CPI  R30,0
	BRNE _0x2020041
	LDI  R30,LOW(1)
	ST   Y,R30
_0x2020041:
	LD   R30,Y
_0x212000D:
	ADIW R28,3
	RET
; .FEND
_glcd_moveto:
; .FSTART _glcd_moveto
	ST   -Y,R26
	LDD  R26,Y+1
	CLR  R27
	RCALL _glcd_clipx
	__PUTB1MN _glcd_state,2
	LD   R26,Y
	CLR  R27
	RCALL _glcd_clipy
	__PUTB1MN _glcd_state,3
_0x212000C:
	ADIW R28,2
	RET
; .FEND
_glcd_line:
; .FSTART _glcd_line
	ST   -Y,R26
	SBIW R28,11
	CALL __SAVELOCR6
	LDD  R26,Y+20
	CLR  R27
	RCALL _glcd_clipx
	STD  Y+20,R30
	LDD  R26,Y+18
	CLR  R27
	RCALL _glcd_clipx
	STD  Y+18,R30
	LDD  R26,Y+19
	CLR  R27
	RCALL _glcd_clipy
	STD  Y+19,R30
	LDD  R26,Y+17
	CLR  R27
	RCALL _glcd_clipy
	STD  Y+17,R30
	LDD  R30,Y+18
	__PUTB1MN _glcd_state,2
	LDD  R30,Y+17
	__PUTB1MN _glcd_state,3
	LDI  R30,LOW(1)
	STD  Y+8,R30
	LDD  R30,Y+17
	LDD  R26,Y+19
	CP   R30,R26
	BRNE _0x2020042
	LDD  R17,Y+20
	LDD  R26,Y+18
	CP   R17,R26
	BRNE _0x2020043
	ST   -Y,R17
	LDD  R30,Y+20
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _glcd_putpixelm_G101
	RJMP _0x212000B
_0x2020043:
	LDD  R26,Y+18
	CP   R17,R26
	BRSH _0x2020044
	LDD  R30,Y+18
	SUB  R30,R17
	MOV  R16,R30
	__GETWRN 20,21,1
	RJMP _0x2020045
_0x2020044:
	LDD  R26,Y+18
	MOV  R30,R17
	SUB  R30,R26
	MOV  R16,R30
	__GETWRN 20,21,-1
_0x2020045:
_0x2020047:
	LDD  R19,Y+19
	LDI  R30,LOW(0)
	STD  Y+6,R30
_0x2020049:
	CALL SUBOPT_0x21
	BRSH _0x202004B
	ST   -Y,R17
	ST   -Y,R19
	INC  R19
	LDD  R26,Y+10
	RCALL _glcd_putpixelm_G101
	STD  Y+7,R30
	RJMP _0x2020049
_0x202004B:
	LDD  R30,Y+7
	STD  Y+8,R30
	ADD  R17,R20
	MOV  R30,R16
	SUBI R16,1
	CPI  R30,0
	BRNE _0x2020047
	RJMP _0x202004C
_0x2020042:
	LDD  R30,Y+18
	LDD  R26,Y+20
	CP   R30,R26
	BRNE _0x202004D
	LDD  R19,Y+19
	LDD  R26,Y+17
	CP   R19,R26
	BRSH _0x202004E
	LDD  R30,Y+17
	SUB  R30,R19
	MOV  R18,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x202011B
_0x202004E:
	LDD  R26,Y+17
	MOV  R30,R19
	SUB  R30,R26
	MOV  R18,R30
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
_0x202011B:
	STD  Y+13,R30
	STD  Y+13+1,R31
_0x2020051:
	LDD  R17,Y+20
	LDI  R30,LOW(0)
	STD  Y+6,R30
_0x2020053:
	CALL SUBOPT_0x21
	BRSH _0x2020055
	ST   -Y,R17
	INC  R17
	CALL SUBOPT_0x22
	STD  Y+7,R30
	RJMP _0x2020053
_0x2020055:
	LDD  R30,Y+7
	STD  Y+8,R30
	LDD  R30,Y+13
	ADD  R19,R30
	MOV  R30,R18
	SUBI R18,1
	CPI  R30,0
	BRNE _0x2020051
	RJMP _0x2020056
_0x202004D:
	LDI  R30,LOW(0)
	STD  Y+6,R30
_0x2020057:
	CALL SUBOPT_0x21
	BRLO PC+2
	RJMP _0x2020059
	LDD  R17,Y+20
	LDD  R19,Y+19
	LDI  R30,LOW(1)
	MOV  R18,R30
	MOV  R16,R30
	LDD  R26,Y+18
	CLR  R27
	LDD  R30,Y+20
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	MOVW R20,R26
	TST  R21
	BRPL _0x202005A
	LDI  R16,LOW(255)
	MOVW R30,R20
	CALL __ANEGW1
	MOVW R20,R30
_0x202005A:
	MOVW R30,R20
	LSL  R30
	ROL  R31
	STD  Y+15,R30
	STD  Y+15+1,R31
	LDD  R26,Y+17
	CLR  R27
	LDD  R30,Y+19
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	STD  Y+13,R26
	STD  Y+13+1,R27
	LDD  R26,Y+14
	TST  R26
	BRPL _0x202005B
	LDI  R18,LOW(255)
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	CALL __ANEGW1
	STD  Y+13,R30
	STD  Y+13+1,R31
_0x202005B:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	LSL  R30
	ROL  R31
	STD  Y+11,R30
	STD  Y+11+1,R31
	ST   -Y,R17
	ST   -Y,R19
	LDI  R26,LOW(1)
	RCALL _glcd_putpixelm_G101
	STD  Y+8,R30
	LDI  R30,LOW(0)
	STD  Y+9,R30
	STD  Y+9+1,R30
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	CP   R20,R26
	CPC  R21,R27
	BRLT _0x202005C
_0x202005E:
	ADD  R17,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CALL SUBOPT_0x23
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	CP   R20,R26
	CPC  R21,R27
	BRGE _0x2020060
	ADD  R19,R18
	LDD  R26,Y+15
	LDD  R27,Y+15+1
	CALL SUBOPT_0x24
_0x2020060:
	ST   -Y,R17
	CALL SUBOPT_0x22
	STD  Y+8,R30
	LDD  R30,Y+18
	CP   R30,R17
	BRNE _0x202005E
	RJMP _0x2020061
_0x202005C:
_0x2020063:
	ADD  R19,R18
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	CALL SUBOPT_0x23
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x2020065
	ADD  R17,R16
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	CALL SUBOPT_0x24
_0x2020065:
	ST   -Y,R17
	CALL SUBOPT_0x22
	STD  Y+8,R30
	LDD  R30,Y+17
	CP   R30,R19
	BRNE _0x2020063
_0x2020061:
	LDD  R30,Y+19
	SUBI R30,-LOW(1)
	STD  Y+19,R30
	LDD  R30,Y+17
	SUBI R30,-LOW(1)
	STD  Y+17,R30
	RJMP _0x2020057
_0x2020059:
_0x2020056:
_0x202004C:
_0x212000B:
	CALL __LOADLOCR6
	ADIW R28,21
	RET
; .FEND
_glcd_corners_G101:
; .FSTART _glcd_corners_G101
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR6
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R17,Z+3
	LDD  R16,Z+1
	LDD  R19,Z+2
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X
	CP   R16,R17
	BRSH _0x2020066
	MOV  R21,R16
	MOV  R16,R17
	MOV  R17,R21
_0x2020066:
	CP   R18,R19
	BRSH _0x2020067
	MOV  R21,R18
	MOV  R18,R19
	MOV  R19,R21
_0x2020067:
	MOV  R30,R17
	__PUTB1SNS 6,3
	MOV  R30,R19
	__PUTB1SNS 6,2
	MOV  R30,R16
	__PUTB1SNS 6,1
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ST   X,R18
	CALL __LOADLOCR6
	RJMP _0x2120009
; .FEND
_glcd_rectround:
; .FSTART _glcd_rectround
	ST   -Y,R26
	SBIW R28,2
	CALL __SAVELOCR6
	LDD  R30,Y+10
	CPI  R30,0
	BREQ _0x2020069
	LDD  R30,Y+9
	CPI  R30,0
	BRNE _0x202006A
_0x2020069:
	RJMP _0x2020068
_0x202006A:
	LDD  R30,Y+8
	LDD  R26,Y+12
	ADD  R30,R26
	MOV  R17,R30
	LDD  R30,Y+8
	LDD  R26,Y+11
	ADD  R30,R26
	MOV  R18,R30
	__GETB1MN _glcd_state,8
	SUBI R30,LOW(1)
	STD  Y+7,R30
	LDD  R30,Y+10
	LDD  R26,Y+12
	ADD  R26,R30
	SUBI R26,LOW(1)
	MOV  R19,R26
	LDD  R26,Y+8
	MOV  R30,R19
	SUB  R30,R26
	MOV  R16,R30
	LDD  R26,Y+7
	SUB  R19,R26
	LDD  R30,Y+9
	LDD  R26,Y+11
	ADD  R26,R30
	SUBI R26,LOW(1)
	MOV  R20,R26
	LDD  R26,Y+8
	MOV  R30,R20
	SUB  R30,R26
	MOV  R21,R30
	LDD  R26,Y+7
	SUB  R20,R26
	__GETB1MN _glcd_state,9
	STD  Y+6,R30
	LDI  R30,LOW(255)
	__PUTB1MN _glcd_state,9
	ST   -Y,R17
	LDD  R30,Y+12
	ST   -Y,R30
	MOV  R30,R16
	SUBI R30,LOW(1)
	ST   -Y,R30
	LDD  R26,Y+14
	RCALL _glcd_line
	ST   -Y,R16
	ST   -Y,R18
	LDD  R30,Y+10
	ST   -Y,R30
	LDI  R26,LOW(129)
	RCALL _glcd_quadrant_G101
	ST   -Y,R19
	ST   -Y,R18
	ST   -Y,R19
	MOV  R26,R21
	SUBI R26,LOW(1)
	RCALL _glcd_line
	ST   -Y,R16
	ST   -Y,R21
	LDD  R30,Y+10
	ST   -Y,R30
	LDI  R26,LOW(136)
	RCALL _glcd_quadrant_G101
	ST   -Y,R16
	ST   -Y,R20
	ST   -Y,R17
	MOV  R26,R20
	RCALL _glcd_line
	ST   -Y,R17
	ST   -Y,R21
	LDD  R30,Y+10
	ST   -Y,R30
	LDI  R26,LOW(132)
	RCALL _glcd_quadrant_G101
	LDD  R30,Y+12
	ST   -Y,R30
	ST   -Y,R21
	LDD  R30,Y+14
	ST   -Y,R30
	MOV  R26,R18
	RCALL _glcd_line
	ST   -Y,R17
	ST   -Y,R18
	LDD  R30,Y+10
	ST   -Y,R30
	LDI  R26,LOW(130)
	RCALL _glcd_quadrant_G101
	LDD  R30,Y+6
	__PUTB1MN _glcd_state,9
	RJMP _0x202006B
_0x2020068:
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R26,Y+12
	RCALL _glcd_setpixel
_0x202006B:
	CALL __LOADLOCR6
	ADIW R28,13
	RET
; .FEND
_glcd_plot8_G101:
; .FSTART _glcd_plot8_G101
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,3
	CALL __SAVELOCR6
	LDD  R30,Y+13
	STD  Y+8,R30
	__GETB1MN _glcd_state,8
	STD  Y+7,R30
	LDS  R30,_glcd_state
	STD  Y+6,R30
	LDD  R26,Y+18
	CLR  R27
	LDD  R30,Y+15
	CALL SUBOPT_0x1F
	LDD  R26,Y+17
	CLR  R27
	LDD  R30,Y+16
	CALL SUBOPT_0x25
	LDD  R30,Y+16
	CALL SUBOPT_0x26
	BREQ _0x2020073
	LDD  R30,Y+8
	ANDI R30,LOW(0x80)
	BRNE _0x2020075
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	CALL SUBOPT_0x27
	BRLT _0x2020077
	CALL SUBOPT_0x28
	BRGE _0x2020078
_0x2020077:
	RJMP _0x2020076
_0x2020078:
_0x2020073:
	TST  R19
	BRMI _0x2020079
	CALL SUBOPT_0x29
_0x2020079:
	LDD  R26,Y+7
	CPI  R26,LOW(0x2)
	BRLO _0x202007B
	__CPWRN 18,19,2
	BRGE _0x202007C
_0x202007B:
	RJMP _0x202007A
_0x202007C:
	CALL SUBOPT_0x2A
	BRNE _0x202007D
	ST   -Y,R16
	MOV  R26,R18
	SUBI R26,LOW(1)
	RCALL _glcd_setpixel
_0x202007D:
_0x202007A:
_0x2020076:
_0x2020075:
	LDD  R30,Y+8
	ANDI R30,LOW(0x88)
	CPI  R30,LOW(0x88)
	BREQ _0x202007F
	LDD  R30,Y+8
	ANDI R30,LOW(0x80)
	BRNE _0x2020081
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	SUBI R26,LOW(-270)
	SBCI R27,HIGH(-270)
	CALL SUBOPT_0x2B
	BRLT _0x2020083
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	SUBI R26,LOW(-270)
	SBCI R27,HIGH(-270)
	CALL SUBOPT_0x2C
	BRGE _0x2020084
_0x2020083:
	RJMP _0x2020082
_0x2020084:
_0x202007F:
	CALL SUBOPT_0x2D
	BRLO _0x2020085
	CALL SUBOPT_0x2E
	BRNE _0x2020086
	ST   -Y,R16
	MOV  R26,R20
	SUBI R26,-LOW(1)
	RCALL _glcd_setpixel
_0x2020086:
_0x2020085:
_0x2020082:
_0x2020081:
	LDD  R26,Y+18
	CLR  R27
	LDD  R30,Y+15
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	MOVW R16,R26
	TST  R17
	BRPL PC+2
	RJMP _0x2020087
	LDD  R30,Y+8
	ANDI R30,LOW(0x82)
	CPI  R30,LOW(0x82)
	BREQ _0x2020089
	LDD  R30,Y+8
	ANDI R30,LOW(0x80)
	BRNE _0x202008B
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	SUBI R26,LOW(-90)
	SBCI R27,HIGH(-90)
	CALL SUBOPT_0x2B
	BRLT _0x202008D
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	SUBI R26,LOW(-90)
	SBCI R27,HIGH(-90)
	CALL SUBOPT_0x2C
	BRGE _0x202008E
_0x202008D:
	RJMP _0x202008C
_0x202008E:
_0x2020089:
	TST  R19
	BRMI _0x202008F
	CALL SUBOPT_0x29
_0x202008F:
	LDD  R26,Y+7
	CPI  R26,LOW(0x2)
	BRLO _0x2020091
	__CPWRN 18,19,2
	BRGE _0x2020092
_0x2020091:
	RJMP _0x2020090
_0x2020092:
	CALL SUBOPT_0x2A
	BRNE _0x2020093
	ST   -Y,R16
	MOV  R26,R18
	SUBI R26,LOW(1)
	RCALL _glcd_setpixel
_0x2020093:
_0x2020090:
_0x202008C:
_0x202008B:
	LDD  R30,Y+8
	ANDI R30,LOW(0x84)
	CPI  R30,LOW(0x84)
	BREQ _0x2020095
	LDD  R30,Y+8
	ANDI R30,LOW(0x80)
	BRNE _0x2020097
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDI  R30,LOW(270)
	LDI  R31,HIGH(270)
	CALL SUBOPT_0x27
	BRLT _0x2020099
	CALL SUBOPT_0x28
	BRGE _0x202009A
_0x2020099:
	RJMP _0x2020098
_0x202009A:
_0x2020095:
	CALL SUBOPT_0x2D
	BRLO _0x202009B
	CALL SUBOPT_0x2E
	BRNE _0x202009C
	ST   -Y,R16
	MOV  R26,R20
	SUBI R26,-LOW(1)
	RCALL _glcd_setpixel
_0x202009C:
_0x202009B:
_0x2020098:
_0x2020097:
_0x2020087:
	LDD  R26,Y+18
	CLR  R27
	LDD  R30,Y+16
	CALL SUBOPT_0x1F
	LDD  R26,Y+17
	CLR  R27
	LDD  R30,Y+15
	CALL SUBOPT_0x25
	LDD  R30,Y+15
	CALL SUBOPT_0x26
	BREQ _0x202009E
	LDD  R30,Y+8
	ANDI R30,LOW(0x80)
	BRNE _0x20200A0
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	CP   R26,R30
	CPC  R27,R31
	BRLT _0x20200A2
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x20200A3
_0x20200A2:
	RJMP _0x20200A1
_0x20200A3:
_0x202009E:
	TST  R19
	BRMI _0x20200A4
	CALL SUBOPT_0x29
	LDD  R26,Y+7
	CPI  R26,LOW(0x2)
	BRLO _0x20200A5
	MOV  R30,R16
	SUBI R30,-LOW(2)
	CALL SUBOPT_0x2F
	BRNE _0x20200A6
	MOV  R30,R16
	SUBI R30,-LOW(1)
	ST   -Y,R30
	MOV  R26,R18
	RCALL _glcd_setpixel
_0x20200A6:
_0x20200A5:
_0x20200A4:
_0x20200A1:
_0x20200A0:
	LDD  R30,Y+8
	ANDI R30,LOW(0x88)
	CPI  R30,LOW(0x88)
	BREQ _0x20200A8
	LDD  R30,Y+8
	ANDI R30,LOW(0x80)
	BRNE _0x20200AA
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDI  R30,LOW(360)
	LDI  R31,HIGH(360)
	CALL SUBOPT_0x27
	BRLT _0x20200AC
	CALL SUBOPT_0x28
	BRGE _0x20200AD
_0x20200AC:
	RJMP _0x20200AB
_0x20200AD:
_0x20200A8:
	CALL SUBOPT_0x2D
	BRLO _0x20200AE
	MOV  R30,R16
	SUBI R30,-LOW(2)
	CALL SUBOPT_0x30
	BRNE _0x20200AF
	MOV  R30,R16
	SUBI R30,-LOW(1)
	ST   -Y,R30
	MOV  R26,R20
	RCALL _glcd_setpixel
_0x20200AF:
_0x20200AE:
_0x20200AB:
_0x20200AA:
	LDD  R26,Y+18
	CLR  R27
	LDD  R30,Y+16
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	MOVW R16,R26
	TST  R17
	BRPL PC+2
	RJMP _0x20200B0
	LDD  R30,Y+8
	ANDI R30,LOW(0x82)
	CPI  R30,LOW(0x82)
	BREQ _0x20200B2
	LDD  R30,Y+8
	ANDI R30,LOW(0x80)
	BRNE _0x20200B4
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDI  R30,LOW(180)
	LDI  R31,HIGH(180)
	CALL SUBOPT_0x27
	BRLT _0x20200B6
	CALL SUBOPT_0x28
	BRGE _0x20200B7
_0x20200B6:
	RJMP _0x20200B5
_0x20200B7:
_0x20200B2:
	TST  R19
	BRMI _0x20200B8
	CALL SUBOPT_0x29
	LDD  R26,Y+7
	CPI  R26,LOW(0x2)
	BRLO _0x20200BA
	__CPWRN 16,17,2
	BRGE _0x20200BB
_0x20200BA:
	RJMP _0x20200B9
_0x20200BB:
	MOV  R30,R16
	SUBI R30,LOW(2)
	CALL SUBOPT_0x2F
	BRNE _0x20200BC
	MOV  R30,R16
	SUBI R30,LOW(1)
	ST   -Y,R30
	MOV  R26,R18
	RCALL _glcd_setpixel
_0x20200BC:
_0x20200B9:
_0x20200B8:
_0x20200B5:
_0x20200B4:
	LDD  R30,Y+8
	ANDI R30,LOW(0x84)
	CPI  R30,LOW(0x84)
	BREQ _0x20200BE
	LDD  R30,Y+8
	ANDI R30,LOW(0x80)
	BRNE _0x20200C0
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	SUBI R26,LOW(-180)
	SBCI R27,HIGH(-180)
	CALL SUBOPT_0x2B
	BRLT _0x20200C2
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	SUBI R26,LOW(-180)
	SBCI R27,HIGH(-180)
	CALL SUBOPT_0x2C
	BRGE _0x20200C3
_0x20200C2:
	RJMP _0x20200C1
_0x20200C3:
_0x20200BE:
	CALL SUBOPT_0x2D
	BRLO _0x20200C5
	__CPWRN 16,17,2
	BRGE _0x20200C6
_0x20200C5:
	RJMP _0x20200C4
_0x20200C6:
	MOV  R30,R16
	SUBI R30,LOW(2)
	CALL SUBOPT_0x30
	BRNE _0x20200C7
	MOV  R30,R16
	SUBI R30,LOW(1)
	ST   -Y,R30
	MOV  R26,R20
	RCALL _glcd_setpixel
_0x20200C7:
_0x20200C4:
_0x20200C1:
_0x20200C0:
_0x20200B0:
	CALL __LOADLOCR6
	ADIW R28,19
	RET
; .FEND
_glcd_line2_G101:
; .FSTART _glcd_line2_G101
	ST   -Y,R26
	CALL __SAVELOCR4
	LDD  R26,Y+7
	CLR  R27
	LDD  R30,Y+5
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	RCALL _glcd_clipx
	MOV  R17,R30
	LDD  R26,Y+7
	CLR  R27
	LDD  R30,Y+5
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RCALL _glcd_clipx
	MOV  R16,R30
	LDD  R26,Y+6
	CLR  R27
	LDD  R30,Y+4
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	RCALL _glcd_clipy
	MOV  R19,R30
	LDD  R26,Y+6
	CLR  R27
	LDD  R30,Y+4
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RCALL _glcd_clipy
	MOV  R18,R30
	ST   -Y,R17
	ST   -Y,R19
	ST   -Y,R16
	MOV  R26,R19
	RCALL _glcd_line
	ST   -Y,R17
	ST   -Y,R18
	ST   -Y,R16
	MOV  R26,R18
	RCALL _glcd_line
	RJMP _0x2120008
; .FEND
_glcd_quadrant_G101:
; .FSTART _glcd_quadrant_G101
	ST   -Y,R26
	CALL __SAVELOCR6
	LDD  R26,Y+9
	CPI  R26,LOW(0x80)
	BRSH _0x20200C9
	LDD  R26,Y+8
	CPI  R26,LOW(0x40)
	BRLO _0x20200C8
_0x20200C9:
	RJMP _0x212000A
_0x20200C8:
	__GETBRMN 21,_glcd_state,8
_0x20200CB:
	MOV  R30,R21
	SUBI R21,1
	CPI  R30,0
	BRNE PC+2
	RJMP _0x20200CD
	LDD  R30,Y+7
	CPI  R30,0
	BRNE _0x20200CE
	RJMP _0x212000A
_0x20200CE:
	LDD  R30,Y+7
	SUBI R30,LOW(1)
	STD  Y+7,R30
	SUBI R30,-LOW(1)
	MOV  R16,R30
	LDI  R31,0
	LDI  R26,LOW(5)
	LDI  R27,HIGH(5)
	SUB  R26,R30
	SBC  R27,R31
	MOVW R30,R26
	CALL __LSLW2
	CALL __ASRW2
	MOVW R18,R30
	LDI  R17,LOW(0)
_0x20200D0:
	LDD  R26,Y+6
	CPI  R26,LOW(0x40)
	BRNE _0x20200D2
	CALL SUBOPT_0x31
	ST   -Y,R17
	MOV  R26,R16
	RCALL _glcd_line2_G101
	CALL SUBOPT_0x31
	ST   -Y,R16
	MOV  R26,R17
	RCALL _glcd_line2_G101
	RJMP _0x20200D3
_0x20200D2:
	CALL SUBOPT_0x31
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+10
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _glcd_plot8_G101
_0x20200D3:
	SUBI R17,-1
	TST  R19
	BRPL _0x20200D4
	MOV  R30,R17
	LDI  R31,0
	RJMP _0x202011C
_0x20200D4:
	SUBI R16,1
	MOV  R26,R17
	CLR  R27
	MOV  R30,R16
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	MOVW R30,R26
_0x202011C:
	LSL  R30
	ROL  R31
	ADIW R30,1
	__ADDWRR 18,19,30,31
	CP   R16,R17
	BRSH _0x20200D0
	RJMP _0x20200CB
_0x20200CD:
_0x212000A:
	CALL __LOADLOCR6
	ADIW R28,10
	RET
; .FEND
_glcd_circle:
; .FSTART _glcd_circle
	ST   -Y,R26
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R30,Y+2
	ST   -Y,R30
	LDI  R26,LOW(143)
	RCALL _glcd_quadrant_G101
	JMP  _0x2120002
; .FEND
_glcd_barrel:
; .FSTART _glcd_barrel
	ST   -Y,R26
	CALL __SAVELOCR4
	LDD  R26,Y+7
	CPI  R26,LOW(0x80)
	BRSH _0x20200ED
	LDD  R26,Y+6
	CPI  R26,LOW(0x40)
	BRLO _0x20200EC
_0x20200ED:
	RJMP _0x2120008
_0x20200EC:
	LDD  R30,Y+5
	CPI  R30,0
	BREQ _0x20200F0
	LDD  R30,Y+4
	CPI  R30,0
	BRNE _0x20200F1
_0x20200F0:
	RJMP _0x20200EF
_0x20200F1:
	LDD  R19,Y+6
	MOV  R30,R19
	LDD  R26,Y+4
	ADD  R30,R26
	STD  Y+4,R30
	LDD  R30,Y+7
	LDD  R26,Y+5
	ADD  R30,R26
	STD  Y+5,R30
_0x20200F2:
	LDD  R30,Y+4
	CP   R19,R30
	BRSH _0x20200F4
	SUB  R30,R19
	MOV  R18,R30
	CPI  R18,9
	BRLO _0x20200F5
	LDI  R18,LOW(8)
_0x20200F5:
	LDD  R17,Y+7
_0x20200F6:
	LDD  R30,Y+5
	CP   R17,R30
	BRSH _0x20200F8
	SUB  R30,R17
	MOV  R16,R30
	CPI  R16,9
	BRLO _0x20200F9
	LDI  R16,LOW(8)
_0x20200F9:
	ST   -Y,R17
	ST   -Y,R19
	ST   -Y,R16
	ST   -Y,R18
	LDI  R30,LOW(0)
	ST   -Y,R30
	__POINTW1MN _glcd_state,17
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(8)
	RCALL _glcd_block
	ADD  R17,R16
	RJMP _0x20200F6
_0x20200F8:
	ADD  R19,R18
	RJMP _0x20200F2
_0x20200F4:
_0x20200EF:
_0x2120008:
	CALL __LOADLOCR4
_0x2120009:
	ADIW R28,8
	RET
; .FEND
_glcd_bar:
; .FSTART _glcd_bar
	ST   -Y,R26
	MOVW R26,R28
	RCALL _glcd_corners_G101
	LDD  R30,Y+3
	ST   -Y,R30
	LDD  R30,Y+3
	ST   -Y,R30
	LDD  R26,Y+5
	LDD  R30,Y+3
	SUB  R30,R26
	SUBI R30,-LOW(1)
	ST   -Y,R30
	LDD  R26,Y+5
	LDD  R30,Y+3
	SUB  R30,R26
	SUBI R30,-LOW(1)
	MOV  R26,R30
	RCALL _glcd_barrel
	JMP  _0x2120001
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G103:
; .FSTART _put_buff_G103
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2060010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2060012
	__CPWRN 16,17,2
	BRLO _0x2060013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2060012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0x32
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2060013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2060014
	CALL SUBOPT_0x32
_0x2060014:
	RJMP _0x2060015
_0x2060010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2060015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x2120003
; .FEND
__ftoe_G103:
; .FSTART __ftoe_G103
	CALL SUBOPT_0x33
	LDI  R30,LOW(128)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	CALL __SAVELOCR4
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x2060019
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x2060000,0
	CALL _strcpyf
	RJMP _0x2120007
_0x2060019:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x2060018
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x2060000,1
	CALL _strcpyf
	RJMP _0x2120007
_0x2060018:
	LDD  R26,Y+11
	CPI  R26,LOW(0x7)
	BRLO _0x206001B
	LDI  R30,LOW(6)
	STD  Y+11,R30
_0x206001B:
	LDD  R17,Y+11
_0x206001C:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x206001E
	CALL SUBOPT_0x34
	RJMP _0x206001C
_0x206001E:
	__GETD1S 12
	CALL __CPD10
	BRNE _0x206001F
	LDI  R19,LOW(0)
	CALL SUBOPT_0x34
	RJMP _0x2060020
_0x206001F:
	LDD  R19,Y+11
	CALL SUBOPT_0x35
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2060021
	CALL SUBOPT_0x34
_0x2060022:
	CALL SUBOPT_0x35
	BRLO _0x2060024
	CALL SUBOPT_0x36
	CALL SUBOPT_0x37
	RJMP _0x2060022
_0x2060024:
	RJMP _0x2060025
_0x2060021:
_0x2060026:
	CALL SUBOPT_0x35
	BRSH _0x2060028
	CALL SUBOPT_0x36
	CALL SUBOPT_0x38
	CALL SUBOPT_0x39
	SUBI R19,LOW(1)
	RJMP _0x2060026
_0x2060028:
	CALL SUBOPT_0x34
_0x2060025:
	__GETD1S 12
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x39
	CALL SUBOPT_0x35
	BRLO _0x2060029
	CALL SUBOPT_0x36
	CALL SUBOPT_0x37
_0x2060029:
_0x2060020:
	LDI  R17,LOW(0)
_0x206002A:
	LDD  R30,Y+11
	CP   R30,R17
	BRLO _0x206002C
	__GETD2S 4
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x3A
	MOVW R26,R30
	MOVW R24,R22
	CALL _floor
	__PUTD1S 4
	CALL SUBOPT_0x36
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3D
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	__GETD2S 4
	CALL __MULF12
	CALL SUBOPT_0x36
	CALL SUBOPT_0x3E
	CALL SUBOPT_0x39
	MOV  R30,R17
	SUBI R17,-1
	CPI  R30,0
	BRNE _0x206002A
	CALL SUBOPT_0x3C
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x206002A
_0x206002C:
	CALL SUBOPT_0x3F
	SBIW R30,1
	LDD  R26,Y+10
	STD  Z+0,R26
	CPI  R19,0
	BRGE _0x206002E
	NEG  R19
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(45)
	RJMP _0x2060113
_0x206002E:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(43)
_0x2060113:
	ST   X,R30
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x3F
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __DIVB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	CALL SUBOPT_0x3F
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __MODB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x2120007:
	CALL __LOADLOCR4
	ADIW R28,16
	RET
; .FEND
__print_G103:
; .FSTART __print_G103
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,63
	SBIW R28,17
	CALL __SAVELOCR6
	LDI  R17,0
	__GETW1SX 88
	STD  Y+8,R30
	STD  Y+8+1,R31
	__GETW1SX 86
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2060030:
	MOVW R26,R28
	SUBI R26,LOW(-(92))
	SBCI R27,HIGH(-(92))
	CALL SUBOPT_0x32
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2060032
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x2060036
	CPI  R18,37
	BRNE _0x2060037
	LDI  R17,LOW(1)
	RJMP _0x2060038
_0x2060037:
	CALL SUBOPT_0x40
_0x2060038:
	RJMP _0x2060035
_0x2060036:
	CPI  R30,LOW(0x1)
	BRNE _0x2060039
	CPI  R18,37
	BRNE _0x206003A
	CALL SUBOPT_0x40
	RJMP _0x2060114
_0x206003A:
	LDI  R17,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+21,R30
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x206003B
	LDI  R16,LOW(1)
	RJMP _0x2060035
_0x206003B:
	CPI  R18,43
	BRNE _0x206003C
	LDI  R30,LOW(43)
	STD  Y+21,R30
	RJMP _0x2060035
_0x206003C:
	CPI  R18,32
	BRNE _0x206003D
	LDI  R30,LOW(32)
	STD  Y+21,R30
	RJMP _0x2060035
_0x206003D:
	RJMP _0x206003E
_0x2060039:
	CPI  R30,LOW(0x2)
	BRNE _0x206003F
_0x206003E:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2060040
	ORI  R16,LOW(128)
	RJMP _0x2060035
_0x2060040:
	RJMP _0x2060041
_0x206003F:
	CPI  R30,LOW(0x3)
	BRNE _0x2060042
_0x2060041:
	CPI  R18,48
	BRLO _0x2060044
	CPI  R18,58
	BRLO _0x2060045
_0x2060044:
	RJMP _0x2060043
_0x2060045:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x2060035
_0x2060043:
	LDI  R20,LOW(0)
	CPI  R18,46
	BRNE _0x2060046
	LDI  R17,LOW(4)
	RJMP _0x2060035
_0x2060046:
	RJMP _0x2060047
_0x2060042:
	CPI  R30,LOW(0x4)
	BRNE _0x2060049
	CPI  R18,48
	BRLO _0x206004B
	CPI  R18,58
	BRLO _0x206004C
_0x206004B:
	RJMP _0x206004A
_0x206004C:
	ORI  R16,LOW(32)
	LDI  R26,LOW(10)
	MUL  R20,R26
	MOV  R20,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x2060035
_0x206004A:
_0x2060047:
	CPI  R18,108
	BRNE _0x206004D
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0x2060035
_0x206004D:
	RJMP _0x206004E
_0x2060049:
	CPI  R30,LOW(0x5)
	BREQ PC+2
	RJMP _0x2060035
_0x206004E:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2060053
	CALL SUBOPT_0x41
	CALL SUBOPT_0x42
	CALL SUBOPT_0x41
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x43
	RJMP _0x2060054
_0x2060053:
	CPI  R30,LOW(0x45)
	BREQ _0x2060057
	CPI  R30,LOW(0x65)
	BRNE _0x2060058
_0x2060057:
	RJMP _0x2060059
_0x2060058:
	CPI  R30,LOW(0x66)
	BREQ PC+2
	RJMP _0x206005A
_0x2060059:
	MOVW R30,R28
	ADIW R30,22
	STD  Y+14,R30
	STD  Y+14+1,R31
	CALL SUBOPT_0x44
	CALL __GETD1P
	CALL SUBOPT_0x45
	CALL SUBOPT_0x46
	LDD  R26,Y+13
	TST  R26
	BRMI _0x206005B
	LDD  R26,Y+21
	CPI  R26,LOW(0x2B)
	BREQ _0x206005D
	CPI  R26,LOW(0x20)
	BREQ _0x206005F
	RJMP _0x2060060
_0x206005B:
	CALL SUBOPT_0x47
	CALL __ANEGF1
	CALL SUBOPT_0x45
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x206005D:
	SBRS R16,7
	RJMP _0x2060061
	LDD  R30,Y+21
	ST   -Y,R30
	CALL SUBOPT_0x43
	RJMP _0x2060062
_0x2060061:
_0x206005F:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ADIW R30,1
	STD  Y+14,R30
	STD  Y+14+1,R31
	SBIW R30,1
	LDD  R26,Y+21
	STD  Z+0,R26
_0x2060062:
_0x2060060:
	SBRS R16,5
	LDI  R20,LOW(6)
	CPI  R18,102
	BRNE _0x2060064
	CALL SUBOPT_0x47
	CALL __PUTPARD1
	ST   -Y,R20
	LDD  R26,Y+19
	LDD  R27,Y+19+1
	CALL _ftoa
	RJMP _0x2060065
_0x2060064:
	CALL SUBOPT_0x47
	CALL __PUTPARD1
	ST   -Y,R20
	ST   -Y,R18
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	RCALL __ftoe_G103
_0x2060065:
	MOVW R30,R28
	ADIW R30,22
	CALL SUBOPT_0x48
	RJMP _0x2060066
_0x206005A:
	CPI  R30,LOW(0x73)
	BRNE _0x2060068
	CALL SUBOPT_0x46
	CALL SUBOPT_0x49
	CALL SUBOPT_0x48
	RJMP _0x2060069
_0x2060068:
	CPI  R30,LOW(0x70)
	BRNE _0x206006B
	CALL SUBOPT_0x46
	CALL SUBOPT_0x49
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2060069:
	ANDI R16,LOW(127)
	CPI  R20,0
	BREQ _0x206006D
	CP   R20,R17
	BRLO _0x206006E
_0x206006D:
	RJMP _0x206006C
_0x206006E:
	MOV  R17,R20
_0x206006C:
_0x2060066:
	LDI  R20,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+20,R30
	LDI  R19,LOW(0)
	RJMP _0x206006F
_0x206006B:
	CPI  R30,LOW(0x64)
	BREQ _0x2060072
	CPI  R30,LOW(0x69)
	BRNE _0x2060073
_0x2060072:
	ORI  R16,LOW(4)
	RJMP _0x2060074
_0x2060073:
	CPI  R30,LOW(0x75)
	BRNE _0x2060075
_0x2060074:
	LDI  R30,LOW(10)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x2060076
	__GETD1N 0x3B9ACA00
	CALL SUBOPT_0x4A
	LDI  R17,LOW(10)
	RJMP _0x2060077
_0x2060076:
	__GETD1N 0x2710
	CALL SUBOPT_0x4A
	LDI  R17,LOW(5)
	RJMP _0x2060077
_0x2060075:
	CPI  R30,LOW(0x58)
	BRNE _0x2060079
	ORI  R16,LOW(8)
	RJMP _0x206007A
_0x2060079:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x20600B8
_0x206007A:
	LDI  R30,LOW(16)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x206007C
	__GETD1N 0x10000000
	CALL SUBOPT_0x4A
	LDI  R17,LOW(8)
	RJMP _0x2060077
_0x206007C:
	__GETD1N 0x1000
	CALL SUBOPT_0x4A
	LDI  R17,LOW(4)
_0x2060077:
	CPI  R20,0
	BREQ _0x206007D
	ANDI R16,LOW(127)
	RJMP _0x206007E
_0x206007D:
	LDI  R20,LOW(1)
_0x206007E:
	SBRS R16,1
	RJMP _0x206007F
	CALL SUBOPT_0x46
	CALL SUBOPT_0x44
	ADIW R26,4
	CALL __GETD1P
	RJMP _0x2060115
_0x206007F:
	SBRS R16,2
	RJMP _0x2060081
	CALL SUBOPT_0x46
	CALL SUBOPT_0x49
	CALL __CWD1
	RJMP _0x2060115
_0x2060081:
	CALL SUBOPT_0x46
	CALL SUBOPT_0x49
	CLR  R22
	CLR  R23
_0x2060115:
	__PUTD1S 10
	SBRS R16,2
	RJMP _0x2060083
	LDD  R26,Y+13
	TST  R26
	BRPL _0x2060084
	CALL SUBOPT_0x47
	CALL __ANEGD1
	CALL SUBOPT_0x45
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x2060084:
	LDD  R30,Y+21
	CPI  R30,0
	BREQ _0x2060085
	SUBI R17,-LOW(1)
	SUBI R20,-LOW(1)
	RJMP _0x2060086
_0x2060085:
	ANDI R16,LOW(251)
_0x2060086:
_0x2060083:
	MOV  R19,R20
_0x206006F:
	SBRC R16,0
	RJMP _0x2060087
_0x2060088:
	CP   R17,R21
	BRSH _0x206008B
	CP   R19,R21
	BRLO _0x206008C
_0x206008B:
	RJMP _0x206008A
_0x206008C:
	SBRS R16,7
	RJMP _0x206008D
	SBRS R16,2
	RJMP _0x206008E
	ANDI R16,LOW(251)
	LDD  R18,Y+21
	SUBI R17,LOW(1)
	RJMP _0x206008F
_0x206008E:
	LDI  R18,LOW(48)
_0x206008F:
	RJMP _0x2060090
_0x206008D:
	LDI  R18,LOW(32)
_0x2060090:
	CALL SUBOPT_0x40
	SUBI R21,LOW(1)
	RJMP _0x2060088
_0x206008A:
_0x2060087:
_0x2060091:
	CP   R17,R20
	BRSH _0x2060093
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2060094
	CALL SUBOPT_0x4B
	BREQ _0x2060095
	SUBI R21,LOW(1)
_0x2060095:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x2060094:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL SUBOPT_0x43
	CPI  R21,0
	BREQ _0x2060096
	SUBI R21,LOW(1)
_0x2060096:
	SUBI R20,LOW(1)
	RJMP _0x2060091
_0x2060093:
	MOV  R19,R17
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x2060097
_0x2060098:
	CPI  R19,0
	BREQ _0x206009A
	SBRS R16,3
	RJMP _0x206009B
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	LPM  R18,Z+
	STD  Y+14,R30
	STD  Y+14+1,R31
	RJMP _0x206009C
_0x206009B:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LD   R18,X+
	STD  Y+14,R26
	STD  Y+14+1,R27
_0x206009C:
	CALL SUBOPT_0x40
	CPI  R21,0
	BREQ _0x206009D
	SUBI R21,LOW(1)
_0x206009D:
	SUBI R19,LOW(1)
	RJMP _0x2060098
_0x206009A:
	RJMP _0x206009E
_0x2060097:
_0x20600A0:
	CALL SUBOPT_0x4C
	CALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x20600A2
	SBRS R16,3
	RJMP _0x20600A3
	SUBI R18,-LOW(55)
	RJMP _0x20600A4
_0x20600A3:
	SUBI R18,-LOW(87)
_0x20600A4:
	RJMP _0x20600A5
_0x20600A2:
	SUBI R18,-LOW(48)
_0x20600A5:
	SBRC R16,4
	RJMP _0x20600A7
	CPI  R18,49
	BRSH _0x20600A9
	__GETD2S 16
	__CPD2N 0x1
	BRNE _0x20600A8
_0x20600A9:
	RJMP _0x20600AB
_0x20600A8:
	CP   R20,R19
	BRSH _0x2060116
	CP   R21,R19
	BRLO _0x20600AE
	SBRS R16,0
	RJMP _0x20600AF
_0x20600AE:
	RJMP _0x20600AD
_0x20600AF:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x20600B0
_0x2060116:
	LDI  R18,LOW(48)
_0x20600AB:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x20600B1
	CALL SUBOPT_0x4B
	BREQ _0x20600B2
	SUBI R21,LOW(1)
_0x20600B2:
_0x20600B1:
_0x20600B0:
_0x20600A7:
	CALL SUBOPT_0x40
	CPI  R21,0
	BREQ _0x20600B3
	SUBI R21,LOW(1)
_0x20600B3:
_0x20600AD:
	SUBI R19,LOW(1)
	CALL SUBOPT_0x4C
	CALL __MODD21U
	CALL SUBOPT_0x45
	LDD  R30,Y+20
	__GETD2S 16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	CALL SUBOPT_0x4A
	__GETD1S 16
	CALL __CPD10
	BREQ _0x20600A1
	RJMP _0x20600A0
_0x20600A1:
_0x206009E:
	SBRS R16,0
	RJMP _0x20600B4
_0x20600B5:
	CPI  R21,0
	BREQ _0x20600B7
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x43
	RJMP _0x20600B5
_0x20600B7:
_0x20600B4:
_0x20600B8:
_0x2060054:
_0x2060114:
	LDI  R17,LOW(0)
_0x2060035:
	RJMP _0x2060030
_0x2060032:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,31
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x4D
	SBIW R30,0
	BRNE _0x20600B9
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2120006
_0x20600B9:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x4D
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G103)
	LDI  R31,HIGH(_put_buff_G103)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G103
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2120006:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG
_ftoa:
; .FSTART _ftoa
	CALL SUBOPT_0x33
	LDI  R30,LOW(0)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x208000D
	CALL SUBOPT_0x4E
	__POINTW2FN _0x2080000,0
	CALL _strcpyf
	RJMP _0x2120005
_0x208000D:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x208000C
	CALL SUBOPT_0x4E
	__POINTW2FN _0x2080000,1
	CALL _strcpyf
	RJMP _0x2120005
_0x208000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x208000F
	__GETD1S 9
	CALL __ANEGF1
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x50
	LDI  R30,LOW(45)
	ST   X,R30
_0x208000F:
	LDD  R26,Y+8
	CPI  R26,LOW(0x7)
	BRLO _0x2080010
	LDI  R30,LOW(6)
	STD  Y+8,R30
_0x2080010:
	LDD  R17,Y+8
_0x2080011:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2080013
	CALL SUBOPT_0x51
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x52
	RJMP _0x2080011
_0x2080013:
	CALL SUBOPT_0x53
	CALL __ADDF12
	CALL SUBOPT_0x4F
	LDI  R17,LOW(0)
	__GETD1N 0x3F800000
	CALL SUBOPT_0x52
_0x2080014:
	CALL SUBOPT_0x53
	CALL __CMPF12
	BRLO _0x2080016
	CALL SUBOPT_0x51
	CALL SUBOPT_0x38
	CALL SUBOPT_0x52
	SUBI R17,-LOW(1)
	CPI  R17,39
	BRLO _0x2080017
	CALL SUBOPT_0x4E
	__POINTW2FN _0x2080000,5
	CALL _strcpyf
	RJMP _0x2120005
_0x2080017:
	RJMP _0x2080014
_0x2080016:
	CPI  R17,0
	BRNE _0x2080018
	CALL SUBOPT_0x50
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x2080019
_0x2080018:
_0x208001A:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x208001C
	CALL SUBOPT_0x51
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x3A
	MOVW R26,R30
	MOVW R24,R22
	CALL _floor
	CALL SUBOPT_0x52
	CALL SUBOPT_0x53
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x50
	CALL SUBOPT_0x3D
	LDI  R31,0
	CALL SUBOPT_0x51
	CALL __CWD1
	CALL __CDF1
	CALL __MULF12
	CALL SUBOPT_0x54
	CALL SUBOPT_0x3E
	CALL SUBOPT_0x4F
	RJMP _0x208001A
_0x208001C:
_0x2080019:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x2120004
	CALL SUBOPT_0x50
	LDI  R30,LOW(46)
	ST   X,R30
_0x208001E:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x2080020
	CALL SUBOPT_0x54
	CALL SUBOPT_0x38
	CALL SUBOPT_0x4F
	__GETD1S 9
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x50
	CALL SUBOPT_0x3D
	LDI  R31,0
	CALL SUBOPT_0x54
	CALL __CWD1
	CALL __CDF1
	CALL SUBOPT_0x3E
	CALL SUBOPT_0x4F
	RJMP _0x208001E
_0x2080020:
_0x2120004:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x2120005:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,13
	RET
; .FEND

	.DSEG

	.CSEG

	.CSEG
_memset:
; .FSTART _memset
	ST   -Y,R27
	ST   -Y,R26
    ldd  r27,y+1
    ld   r26,y
    adiw r26,0
    breq memset1
    ldd  r31,y+4
    ldd  r30,y+3
    ldd  r22,y+2
memset0:
    st   z+,r22
    sbiw r26,1
    brne memset0
memset1:
    ldd  r30,y+3
    ldd  r31,y+4
_0x2120003:
	ADIW R28,5
	RET
; .FEND
_strcpyf:
; .FSTART _strcpyf
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpyf0:
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strcpyf0
    movw r30,r24
    ret
; .FEND
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.CSEG
_glcd_getmask:
; .FSTART _glcd_getmask
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__glcd_mask*2)
	SBCI R31,HIGH(-__glcd_mask*2)
	LPM  R26,Z
	LDD  R30,Y+1
	CALL __LSLB12
	ADIW R28,2
	RET
; .FEND
_glcd_mappixcolor1bit:
; .FSTART _glcd_mappixcolor1bit
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+1
	CPI  R30,LOW(0x7)
	BREQ _0x20C0007
	CPI  R30,LOW(0xA)
	BRNE _0x20C0008
_0x20C0007:
	LDS  R17,_glcd_state
	RJMP _0x20C0009
_0x20C0008:
	CPI  R30,LOW(0x9)
	BRNE _0x20C000B
	__GETBRMN 17,_glcd_state,1
	RJMP _0x20C0009
_0x20C000B:
	CPI  R30,LOW(0x8)
	BRNE _0x20C0005
	__GETBRMN 17,_glcd_state,16
_0x20C0009:
	__GETB1MN _glcd_state,1
	CPI  R30,0
	BREQ _0x20C000E
	CPI  R17,0
	BREQ _0x20C000F
	LDI  R30,LOW(255)
	LDD  R17,Y+0
	RJMP _0x2120002
_0x20C000F:
	LDD  R30,Y+2
	COM  R30
	LDD  R17,Y+0
	RJMP _0x2120002
_0x20C000E:
	CPI  R17,0
	BRNE _0x20C0011
	LDI  R30,LOW(0)
	LDD  R17,Y+0
	RJMP _0x2120002
_0x20C0011:
_0x20C0005:
	LDD  R30,Y+2
	LDD  R17,Y+0
	RJMP _0x2120002
; .FEND
_glcd_readmem:
; .FSTART _glcd_readmem
	ST   -Y,R27
	ST   -Y,R26
	LDD  R30,Y+2
	CPI  R30,LOW(0x1)
	BRNE _0x20C0015
	LD   R30,Y
	LDD  R31,Y+1
	LPM  R30,Z
	RJMP _0x2120002
_0x20C0015:
	CPI  R30,LOW(0x2)
	BRNE _0x20C0016
	LD   R26,Y
	LDD  R27,Y+1
	CALL __EEPROMRDB
	RJMP _0x2120002
_0x20C0016:
	CPI  R30,LOW(0x3)
	BRNE _0x20C0018
	LD   R26,Y
	LDD  R27,Y+1
	__CALL1MN _glcd_state,25
	RJMP _0x2120002
_0x20C0018:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
_0x2120002:
	ADIW R28,3
	RET
; .FEND
_glcd_writemem:
; .FSTART _glcd_writemem
	ST   -Y,R26
	LDD  R30,Y+3
	CPI  R30,0
	BRNE _0x20C001C
	LD   R30,Y
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ST   X,R30
	RJMP _0x20C001B
_0x20C001C:
	CPI  R30,LOW(0x2)
	BRNE _0x20C001D
	LD   R30,Y
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL __EEPROMWRB
	RJMP _0x20C001B
_0x20C001D:
	CPI  R30,LOW(0x3)
	BRNE _0x20C001B
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+2
	__CALL1MN _glcd_state,27
_0x20C001B:
	JMP  _0x2120001
; .FEND

	.CSEG
_ftrunc:
; .FSTART _ftrunc
	CALL __PUTPARD2
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
; .FEND
_floor:
; .FSTART _floor
	CALL __PUTPARD2
	CALL __GETD2S0
	CALL _ftrunc
	CALL __PUTD1S0
    brne __floor1
__floor0:
	CALL __GETD1S0
	RJMP _0x2120001
__floor1:
    brtc __floor0
	CALL __GETD1S0
	__GETD2N 0x3F800000
	CALL __SUBF12
_0x2120001:
	ADIW R28,4
	RET
; .FEND

	.CSEG

	.DSEG
_glcd_state:
	.BYTE 0x1D

	.ESEG
_counter:
	.DB  0x0,0x0
_temprature:
	.BYTE 0x80

	.DSEG
_tx_buffer:
	.BYTE 0x8
_ks0108_coord_G100:
	.BYTE 0x3
__seed_G104:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x0:
	CALL _glcd_clear
	LDI  R30,LOW(2)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R30,LOW(124)
	ST   -Y,R30
	LDI  R30,LOW(60)
	ST   -Y,R30
	LDI  R26,LOW(5)
	CALL _glcd_rectround
	LDI  R30,LOW(15)
	ST   -Y,R30
	LDI  R30,LOW(5)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x1:
	CALL _glcd_outtextxy
	LDI  R30,LOW(32)
	ST   -Y,R30
	LDI  R30,LOW(43)
	ST   -Y,R30
	LDI  R26,LOW(15)
	CALL _glcd_circle
	LDI  R30,LOW(21)
	ST   -Y,R30
	LDI  R30,LOW(40)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x2:
	CALL _glcd_outtextxy
	LDI  R30,LOW(95)
	ST   -Y,R30
	LDI  R30,LOW(43)
	ST   -Y,R30
	LDI  R26,LOW(15)
	CALL _glcd_circle
	LDI  R30,LOW(83)
	ST   -Y,R30
	LDI  R30,LOW(40)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(_counter)
	LDI  R27,HIGH(_counter)
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x4:
	__GETD2N 0x40800000
	CALL __SUBF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x40800000
	CALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	ST   -Y,R31
	ST   -Y,R30
	__GETD1S 36
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x6:
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	ST   -Y,R17
	ST   -Y,R16
	__GETWRN 16,17,0
	JMP  _glcd_clear

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x8:
	LDI  R26,LOW(_temprature)
	LDI  R27,HIGH(_temprature)
	ADD  R26,R16
	ADC  R27,R17
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	__GETD2S 22
	CALL __CWD1
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xA:
	__PUTD1S 22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0xB:
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,117
	ST   -Y,R31
	ST   -Y,R30
	__GETD1S 26
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xC:
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,4
	CALL _glcd_outtextxy
	LDI  R26,LOW(_temprature)
	LDI  R27,HIGH(_temprature)
	CALL __EEPROMRDB
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	RCALL SUBOPT_0xA
	__GETWRN 16,17,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xD:
	__GETD2S 22
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xE:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xF:
	CBI  0x15,1
	LDI  R30,LOW(255)
	OUT  0x17,R30
	LD   R30,Y
	OUT  0x18,R30
	CALL _ks0108_enable_G100
	JMP  _ks0108_disable_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R26,R30
	JMP  _ks0108_gotoxp_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	CALL _ks0108_wrdata_G100
	JMP  _ks0108_nextx_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x13:
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _glcd_writemem

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x14:
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x15:
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	JMP  _glcd_readmem

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	ST   -Y,R21
	LDD  R26,Y+10
	JMP  _glcd_mappixcolor1bit

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x17:
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+16
	ST   -Y,R30
	ST   -Y,R21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	ST   -Y,R16
	INC  R16
	LDD  R26,Y+16
	CALL _ks0108_rdbyte_G100
	AND  R30,R20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x19:
	MOV  R21,R30
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CLR  R24
	CLR  R25
	CALL _glcd_readmem
	MOV  R1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1A:
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+16
	ST   -Y,R30
	LDD  R30,Y+14
	ST   -Y,R30
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ADIW R30,1
	STD  Y+9,R30
	STD  Y+9+1,R31
	SBIW R30,1
	RJMP SUBOPT_0x15

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	ST   -Y,R27
	ST   -Y,R26
	LD   R26,Y
	LDD  R27,Y+1
	CALL __CPW02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	CALL __SAVELOCR6
	__GETW1MN _glcd_state,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	MOVW R30,R16
	__ADDWRN 16,17,1
	LPM  R0,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1E:
	__GETW1MN _glcd_state,4
	ADIW R30,1
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x20:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(9)
	JMP  _glcd_block

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x21:
	LDD  R26,Y+6
	SUBI R26,-LOW(1)
	STD  Y+6,R26
	SUBI R26,LOW(1)
	__GETB1MN _glcd_state,8
	CP   R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	ST   -Y,R19
	LDD  R26,Y+10
	JMP  _glcd_putpixelm_G101

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+9,R30
	STD  Y+9+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+9,R30
	STD  Y+9+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x25:
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	MOVW R18,R26
	LDD  R26,Y+17
	CLR  R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x26:
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R20,R30
	LDD  R30,Y+8
	ANDI R30,LOW(0x81)
	CPI  R30,LOW(0x81)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x27:
	SUB  R30,R26
	SBC  R31,R27
	MOVW R0,R30
	MOVW R26,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x28:
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	CP   R30,R0
	CPC  R31,R1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x29:
	ST   -Y,R16
	MOV  R26,R18
	JMP  _glcd_setpixel

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2A:
	ST   -Y,R16
	MOV  R26,R18
	SUBI R26,LOW(2)
	CALL _glcd_getpixel
	MOV  R26,R30
	LDD  R30,Y+6
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2B:
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2C:
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2D:
	ST   -Y,R16
	MOV  R26,R20
	CALL _glcd_setpixel
	LDD  R26,Y+7
	CPI  R26,LOW(0x2)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2E:
	ST   -Y,R16
	MOV  R26,R20
	SUBI R26,-LOW(2)
	CALL _glcd_getpixel
	MOV  R26,R30
	LDD  R30,Y+6
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2F:
	ST   -Y,R30
	MOV  R26,R18
	CALL _glcd_getpixel
	MOV  R26,R30
	LDD  R30,Y+6
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x30:
	ST   -Y,R30
	MOV  R26,R20
	CALL _glcd_getpixel
	MOV  R26,R30
	LDD  R30,Y+6
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x31:
	LDD  R30,Y+9
	ST   -Y,R30
	LDD  R30,Y+9
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x32:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x33:
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x34:
	__GETD2S 4
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x35:
	__GETD1S 4
	__GETD2S 12
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x36:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x37:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	__PUTD1S 12
	SUBI R19,-LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x38:
	__GETD1N 0x41200000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x39:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3A:
	__GETD2N 0x3F000000
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3B:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3C:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3D:
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3E:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3F:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x40:
	ST   -Y,R18
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x41:
	__GETW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x42:
	SBIW R30,4
	__PUTW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x43:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x44:
	__GETW2SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x45:
	__PUTD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x46:
	RCALL SUBOPT_0x41
	RJMP SUBOPT_0x42

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x47:
	__GETD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x48:
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL _strlen
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x49:
	RCALL SUBOPT_0x44
	ADIW R26,4
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4A:
	__PUTD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x4B:
	ANDI R16,LOW(251)
	LDD  R30,Y+21
	ST   -Y,R30
	__GETW2SX 87
	__GETW1SX 89
	ICALL
	CPI  R21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4C:
	__GETD1S 16
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4D:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4E:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4F:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x50:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x51:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x52:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x53:
	__GETD1S 2
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x54:
	__GETD2S 9
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSRB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSRB12R
__LSRB12L:
	LSR  R30
	DEC  R0
	BRNE __LSRB12L
__LSRB12R:
	RET

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__ASRW2:
	ASR  R31
	ROR  R30
	ASR  R31
	ROR  R30
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__DIVB21U:
	CLR  R0
	LDI  R25,8
__DIVB21U1:
	LSL  R26
	ROL  R0
	SUB  R0,R30
	BRCC __DIVB21U2
	ADD  R0,R30
	RJMP __DIVB21U3
__DIVB21U2:
	SBR  R26,1
__DIVB21U3:
	DEC  R25
	BRNE __DIVB21U1
	MOV  R30,R26
	MOV  R26,R0
	RET

__DIVB21:
	RCALL __CHKSIGNB
	RCALL __DIVB21U
	BRTC __DIVB211
	NEG  R30
__DIVB211:
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODB21:
	CLT
	SBRS R26,7
	RJMP __MODB211
	NEG  R26
	SET
__MODB211:
	SBRC R30,7
	NEG  R30
	RCALL __DIVB21U
	MOV  R30,R26
	BRTC __MODB212
	NEG  R30
__MODB212:
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__CHKSIGNB:
	CLT
	SBRS R30,7
	RJMP __CHKSB1
	NEG  R30
	SET
__CHKSB1:
	SBRS R26,7
	RJMP __CHKSB2
	NEG  R26
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSB2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
