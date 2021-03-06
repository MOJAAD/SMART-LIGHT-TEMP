/*******************************************************
Author  :  Mohammad Javad Adel 9621010042
*******************************************************/
#include <mega32.h>
#include <stdlib.h>
#include <stdio.h>
#include <glcd.h>
#include <delay.h>
#include <font5x7.h>

char recive[7],flag=0;
int i=0;
flash char shift[4]= { 0xFE , 0xFD , 0xFB , 0xF7} ;
eeprom char  center[16][8][2];

int keypad(void);
void firstmain(void);
void showpattern(void);
void editpattern(void);
void showtemp(void);
void aboutme(void);
void tablepattern(void);
void savepattern(int x);
//void defaultpattern(void);
void showled(int d);
void clearround(int w);
void save2pattern(int j,int x);
void patternapply(int d);
void writeapply(int d,int w);

interrupt [EXT_INT0] void ext_int0_isr(void)
{
  #asm("cli")

//    glcd_clear();
//    glcd_rectround(5,5,118,54, 5);
//    glcd_outtextxy(28,10, recive);
//    delay_ms(125);
//    glcd_clear();
     #asm("sei")

}

interrupt [EXT_INT1] void ext_int1_isr(void)
{
 #asm("cli")

// glcd_clear();
// glcd_outtextxy(28,30, recive);
// delay_ms(125);
// glcd_clear();

 #asm("sei")

}

interrupt [EXT_INT2] void ext_int2_isr(void)
{
// Place your code here

}

#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)
#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<DOR)
#define TX_BUFFER_SIZE 8
char tx_buffer[TX_BUFFER_SIZE];
#if TX_BUFFER_SIZE <= 256
unsigned char tx_wr_index=0,tx_rd_index=0;
#else
unsigned int tx_wr_index=0,tx_rd_index=0;
#endif
#if TX_BUFFER_SIZE < 256
unsigned char tx_counter=0;
#else
unsigned int tx_counter=0;
#endif

interrupt [USART_TXC] void usart_tx_isr(void)
{
if (tx_counter)
   {
   --tx_counter;
   UDR=tx_buffer[tx_rd_index++];
#if TX_BUFFER_SIZE != 256
   if (tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
#endif
   }
}

#ifndef _DEBUG_TERMINAL_IO_
// Write a character to the USART Transmitter buffer
#define _ALTERNATE_PUTCHAR_
#pragma used+
void putchar(char c)
{
while (tx_counter == TX_BUFFER_SIZE);
#asm("cli")
if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
   {
   tx_buffer[tx_wr_index++]=c;
#if TX_BUFFER_SIZE != 256
   if (tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
#endif
   ++tx_counter;
   }
else
   UDR=c;
#asm("sei")
}
#pragma used-
#endif

#define RX_BUFFER_SIZE 8
char rx_buffer[RX_BUFFER_SIZE];
#if RX_BUFFER_SIZE <= 256
unsigned char rx_wr_index=0,rx_rd_index=0;
#else
unsigned int rx_wr_index=0,rx_rd_index=0;
#endif
#if RX_BUFFER_SIZE < 256
unsigned char rx_counter=0;
#else
unsigned int rx_counter=0;
#endif
bit rx_buffer_overflow;
interrupt [USART_RXC] void usart_rx_isr(void)
{
char test;
char status,data;
#asm("cli")

status=UCSRA;
data=UDR;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
   rx_buffer[rx_wr_index++]=data;
#if RX_BUFFER_SIZE == 256
   // special case for receiver buffer size=256
   if (++rx_counter == 0) rx_buffer_overflow=1;
#else
   if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
   if (++rx_counter == RX_BUFFER_SIZE)
      {
      rx_counter=0;
      rx_buffer_overflow=1;
      }
}
#endif
 //zZ36.25 CXx
test=getchar();
switch(i){
 case 0:
    if(test=='z'){flag=1;break;}
 case 1:
    if(test=='Z' && flag==1){break;}
    else{flag=0;break;}
 case 2:
    if(flag==1){
    if(test >='1' && test <='6'){recive[0]=test;break;}
    }
    else{flag=0;break;}
 case 3:
    if(flag==1){
    if(test >='0' && test <='9'){recive[1]=test;break;}
    }
    else{flag=0;break;}
 case 4:
    if(flag==1){
    recive[2]='.';
    break;
    }
    else{flag=0;break;}
 case 5:
    if(flag==1){
    if(test >='0' && test <='9'){recive[3]=test;break;}
    }
    else{flag=0;break;}
 case 6:
    if(flag==1){
    if(test >='0' && test <='9'){recive[4]=test;break;}
    }
    else{flag=0;break;}
 case 7:
    if(test==' ' && flag==1){recive[5]=test;break;}
    else{flag=0;break;}
 case 8:
    if(test=='C' && flag==1){recive[6]=test;break;}
    else{flag=0;break;}
 case 9:
    if(test=='X' && flag==1){break;}
    else{flag=0;break;}
 case 10:
    if(test=='x' && flag==1){break;}
    else{flag=0;break;}
}
i++;
if(i>=10){i=0;}
   #asm("sei")
}
#ifndef _DEBUG_TERMINAL_IO_
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
char data;
while (rx_counter==0);
data=rx_buffer[rx_rd_index++];
#if RX_BUFFER_SIZE != 256
if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
#endif
#asm("cli")
--rx_counter;
#asm("sei")
return data;
}
#pragma used-
#endif

void main(void)
{
int j;
GLCDINIT_t glcd_init_data;

//defaultpattern();

DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (1<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (1<<PORTA3) | (1<<PORTA2) | (1<<PORTA1) | (1<<PORTA0);
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
PORTB=(1<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (1<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
PORTD=(1<<PORTD7) | (1<<PORTD6) | (1<<PORTD5) | (1<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0x00;
OCR0=0x00;
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;
ASSR=0<<AS2;
TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2=0x00;
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);

// External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Falling Edge
// INT1: On
// INT1 Mode: Falling Edge
// INT2: On
// INT2 Mode: Falling Edge
GICR|=(0<<INT1) | (0<<INT0) | (0<<INT2);
MCUCR=(1<<ISC11) | (0<<ISC10) | (1<<ISC01) | (0<<ISC00);
MCUCSR=(0<<ISC2);
GIFR=(1<<INTF1) | (1<<INTF0) | (1<<INTF2);

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 9600
UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
UCSRB=(1<<RXCIE) | (1<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
UBRRH=0x00;
UBRRL=0x33;

ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
SFIOR=(0<<ACME);
ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

// Graphic Display Controller initialization
// The KS0108 connections are specified in the
// Project|Configure|C Compiler|Libraries|Graphic Display menu:
// DB0 - PORTC Bit 0
// DB1 - PORTC Bit 1
// DB2 - PORTC Bit 2
// DB3 - PORTC Bit 3
// DB4 - PORTC Bit 4
// DB5 - PORTC Bit 5
// DB6 - PORTC Bit 6
// DB7 - PORTC Bit 7
// E - PORTB Bit 4
// RD /WR - PORTB Bit 3
// RS - PORTB Bit 1
// /RST - PORTB Bit 0
// CS1 - PORTB Bit 5
// CS2 - PORTB Bit 6
glcd_init_data.font=font5x7;
glcd_init_data.readxmem=NULL;
glcd_init_data.writexmem=NULL;
glcd_init(&glcd_init_data);

glcd_clear();
glcd_rectround(2,2,124,60, 5);
glcd_outtextxy(5,15, " IN THE NAME OF GOD");
glcd_outtextxy(5,25,"      WELCOME!");
for(j=0;j<10;j++) {
   delay_ms(10);
   glcd_bar(10+10*j, 40, 20+10*j, 50);
}
glcd_clear();
#asm("sei")
while (1)
      {
            firstmain();
            //glcd_clear();
      }
}

void firstmain(void){
int j=0;
  glcd_rectround(22,1,85,16, 2);
  glcd_outtextxy(24,5,"ENTER NUMBER:");
  glcd_rectround(2,20,124,55, 2);
  glcd_outtextxy(5,25,"1. Show  Pattern");
  glcd_outtextxy(5,35,"2. Edit  Pattern");
  glcd_outtextxy(5,45,"3. Show  Temprature");
  glcd_outtextxy(5,55,"4. About ME!");
  j=keypad();
  switch(j){
    case 0:
        showpattern();
        break;
    case 1:
        glcd_clear();
        editpattern();
        break;
    case 2:
        glcd_clear();
        showtemp();
        break;
    case 3:
        glcd_clear();
        aboutme();
  }
}

int keypad(void){
int i=0,column=0;
while(1){
            for  (i=0;i<4;i++){
            PORTA = shift[i] ;
            delay_us(10);
            if(PINA.4==0){column=0;while(PINA.4==0){}return i*4 + column;}
            if(PINA.5==0){column=1;while(PINA.5==0){}return i*4 + column;}
            if(PINA.6==0){column=2;while(PINA.6==0){}return i*4 + column;}
            if(PINA.7==0){column=3;while(PINA.7==0){}return i*4 + column;}
            }
        if(PINB.2==0){while(PINB.2==0);return 16;}
        if(PINB.7==0){while(PINB.7==0);return 17;}
        }
}

void showtemp(void){
glcd_rectround(1,1,126,62, 5);
glcd_outtextxy(30,10,"TEMPRATURE:");
glcd_outtextxy(43,20,recive);
glcd_circle(62,45,15);
glcd_outtextxy(57,42,"BK");
while(PINB.7==0);
while(PINB.7==1);
glcd_clear();
}

void aboutme(void){
glcd_rectround(1,1,126,62, 5);
glcd_outtextxy(5,8,"SMART   LIGHT   AND");
glcd_outtextxy(5,21,"TEMPRATURE  PROJECT");
glcd_outtextxy(5,33,"MOHAAMAD JAVAD  ADEL");
glcd_outtextxy(45,47,"9621010042");
glcd_circle(30,50,10);
glcd_outtextxy(25,47,"BK");
while(PINB.7==0);
while(PINB.7==1);
glcd_clear();
}

void showpattern(void){
int d=0;
char buffer[20];
tablepattern();
glcd_rectround(68,0,60,64,2);
glcd_outtextxy(70,5,"Pattern");
glcd_circle(84,25,10);
glcd_outtextxy(78,22,"<<");
glcd_circle(110,25,10);
glcd_outtextxy(106,22,">>");
glcd_circle(84,50,10);
glcd_outtextxy(78,48,"OK");
glcd_circle(110,50,10);
glcd_outtextxy(105,48,"BK");
while(1){
 switch(d){
  case 0:
    glcd_outtextxy(117,5,"1");
    showled(d);
    break;
  case 1:
    glcd_outtextxy(117,5,"2");
    showled(d);
    break;
  case 2:
    glcd_outtextxy(117,5,"3");
    showled(d);
    break;
  case 3:
    glcd_outtextxy(117,5,"4");
    showled(d);
    break;
  case 4:
    glcd_outtextxy(117,5,"5");
    showled(d);
    break;
  case 5:
    glcd_outtextxy(117,5,"6");
    showled(d);
    break;
  case 6:
    glcd_outtextxy(117,5,"7");
    showled(d);
    break;
  case 7:
    glcd_outtextxy(117,5,"8");
    showled(d);
    break;
 }
 if(PINB.7==0){while(PINB.7==0);break;}
 if(PIND.6==0){while(PIND.6==0);d++;if(d>7){d=0;}}
 if(PIND.4==0){while(PIND.4==0);d--;if(d<0){d=7;}}
 if(PINB.2==0){
    while(PINB.2==0);
    glcd_clear();
    glcd_rectround(5,20,118,18,5);
    sprintf(buffer,"Pattern %d Applied !",d+1);
    glcd_outtextxy(7,25,buffer);
    patternapply(d);
    delay_ms(125);
    break;
    }
}
glcd_clear();
}

void tablepattern(void){
int j=0,k=0,x=0,w=0;
glcd_clear();
for(j=0;j<16;j++){
    for(k=0;k<16;k++){
        glcd_rectround(1+w,1+x,3,3, 0);
        x=x+4;
    }
    w=w+4;
    x=0;
}
}

//void defaultpattern(void){
// int j,k;
// for(j=0;j<16;j++){
//    for(k=0;k<8;k++){
//      center[j][k][0]=0b01010101;
//      center[j][k][1]=0b10101010;
//  }
// }
//for(j=0;j<16;j++){
//    center[j][2][0]=0b11110000;
//    center[j][2][1]=0b00001111;
//}
//}

void showled(int d){
int j,shifter;
char k,binary;
for(j=0;j<16;j++){
    for(k=0;k<2;k++){
        for(shifter=0;shifter<8;shifter++){
            binary = 0b00000001 << shifter ;
            if( (center[j][d][k] & binary) == binary ){
                glcd_setpixel( (4*(shifter%4)) + (16*(j%4)) + 2 , (k*8) + (4*(shifter/4)) + (16*(j/4)) + 2 );
            }
            else{
                glcd_clrpixel( (4*(shifter%4)) + (16*(j%4)) + 2 , (k*8) + (4*(shifter/4)) + (16*(j/4)) + 2 );
            }
        }
    }
}
}

void editpattern(void){
int d=0;
tablepattern();
glcd_rectround(68,0,60,64,2);
glcd_outtextxy(70,5,"Pattern");
glcd_circle(84,25,10);
glcd_outtextxy(78,22,"<<");
glcd_circle(110,25,10);
glcd_outtextxy(106,22,">>");
glcd_circle(84,50,10);
glcd_outtextxy(78,48,"ED");
glcd_circle(110,50,10);
glcd_outtextxy(105,48,"BK");
while(1){
 switch(d){
  case 0:
    glcd_outtextxy(117,5,"1");
    showled(d);
    break;
  case 1:
    glcd_outtextxy(117,5,"2");
    showled(d);
    break;
  case 2:
    glcd_outtextxy(117,5,"3");
    showled(d);
    break;
  case 3:
    glcd_outtextxy(117,5,"4");
    showled(d);
    break;
  case 4:
    glcd_outtextxy(117,5,"5");
    showled(d);
    break;
  case 5:
    glcd_outtextxy(117,5,"6");
    showled(d);
    break;
  case 6:
    glcd_outtextxy(117,5,"7");
    showled(d);
    break;
  case 7:
    glcd_outtextxy(117,5,"8");
    showled(d);
    break;
    }
 if(PINB.7==0){while(PINB.7==0);break;}
 if(PINB.2==0){while(PINB.2==0);savepattern(d);}
 if(PIND.6==0){while(PIND.6==0);d++;if(d>7){d=0;}}
 if(PIND.4==0){while(PIND.4==0);d--;if(d<0){d=7;}}
}
glcd_clear();
}

void savepattern(int x){
int j=0;
glcd_outtextxy(70,15,"         ");
glcd_outtextxy(70,20,"         ");
glcd_outtextxy(70,25,"         ");
glcd_outtextxy(70,30,"         ");
glcd_outtextxy(74,20,"PRESS ED");
glcd_outtextxy(77,30,"TO EDIT");
while(1){
    glcd_rectround(16*(j%4),16*(j/4),17,17, 0);
    if(PIND.7==0){while(PIND.7==0);clearround(j);if(j>11){j=(j%4);}else{j=j+4;}}
    if(PIND.5==0){while(PIND.5==0);clearround(j);if(j<4){j=12+(j%4);}else{j=j-4;}}
    if(PIND.6==0){while(PIND.6==0);clearround(j);if((j+1)%4==0){j=(j/4)*4;}else{j=j+1;}}
    if(PIND.4==0){while(PIND.4==0);clearround(j);if(j%4==0){j=j+3;}else{j=j-1;}}
    if(PINB.7==0){while(PINB.7==0);clearround(j);break;}
    if(PINB.2==0){while(PINB.2==0);save2pattern(j,x);}
}
glcd_outtextxy(70,15,"         ");
glcd_outtextxy(70,20,"         ");
glcd_outtextxy(70,25,"         ");
glcd_outtextxy(70,30,"         ");
glcd_circle(84,25,10);
glcd_outtextxy(78,22,"<<");
glcd_circle(110,25,10);
glcd_outtextxy(106,22,">>");
}

void clearround(int w){
int k=0;
    for(k=0;k<16;k++){
        glcd_clrpixel( ((w%4)*16)+k , (w/4)*16 );
    }
    for(k=0;k<16;k++){
        glcd_clrpixel( ((w%4)*16)+16 , ((w/4)*16) + k );
    }
    for(k=16;k>0;k--){
        if ( w<12 ) { glcd_clrpixel( ((w%4)*16)+k , (w/4)*16 + 16 ); }
        else { glcd_clrpixel( ((w%4)*16)+k , (w/4)*16 + 15 ); k=k-3; }
    }
    for(k=16;k>0;k--){
        glcd_clrpixel( (w%4)*16 , ((w/4)*16) + k );
    }
}

void save2pattern(int j,int x){
int shifter=0,k=0;
char binary,buffer_center[2];
glcd_outtextxy(70,15,"         ");
glcd_outtextxy(70,20,"         ");
glcd_outtextxy(70,25,"         ");
glcd_outtextxy(70,30,"         ");
glcd_outtextxy(74,19,"USE KEYS");
glcd_outtextxy(77,29,"TO EDIT");
glcd_outtextxy(78,48,"SV");
buffer_center[0]=center[j][x][0];
buffer_center[1]=center[j][x][1];
while(1){
    shifter=keypad();
    if( shifter<8 ){
        binary = 0b00000001 << shifter ;
        k=0;
        if( (buffer_center[k] & binary) == binary ){
            glcd_clrpixel( (j%4)*16 + 2 + (shifter%4)*4 , (j/4)*16 + 2 + (shifter/4)*4 );
            buffer_center[k]=buffer_center[k] ^ binary ;
        }
        else{
            glcd_setpixel( (j%4)*16 + 2 + (shifter%4)*4 , (j/4)*16 + 2 + (shifter/4)*4 );
            buffer_center[k]=buffer_center[k] ^ binary ;
        }
    }
    else if(shifter == 16){
        center[j][x][0]=buffer_center[0];
        center[j][x][1]=buffer_center[1];
        glcd_outtextxy(70,15,"         ");
        glcd_outtextxy(70,20,"         ");
        glcd_outtextxy(70,25,"         ");
        glcd_outtextxy(70,30,"         ");
        glcd_outtextxy(82,20,"BLOCK");
        glcd_outtextxy(78,30,"SAVED !");
        writeapply(x,j);
        delay_ms(100);
        break; }
    else if(shifter == 17){ break; }
    else {
        binary = 0b00000001 << (shifter-8) ;
        k=1;
        if( (buffer_center[k] & binary) == binary ){
            glcd_clrpixel( (j%4)*16 + 2 + (shifter%4)*4 , (j/4)*16 + 2 + (shifter/4)*4 );
            buffer_center[k]=buffer_center[k] ^ binary ;
        }
        else{
            glcd_setpixel( (j%4)*16 + 2 + (shifter%4)*4 , (j/4)*16 + 2 + (shifter/4)*4 );
            buffer_center[k]=buffer_center[k] ^ binary ;
        }
    }
}
glcd_outtextxy(70,15,"         ");
glcd_outtextxy(70,20,"         ");
glcd_outtextxy(70,25,"         ");
glcd_outtextxy(70,30,"         ");
glcd_outtextxy(74,19,"PRESS ED");
glcd_outtextxy(77,29,"TO EDIT");
glcd_outtextxy(78,48,"ED");
}

void patternapply(int d){
    char temp,select=0b10001111;
    temp = d << 4 ;
    temp = select ^ temp ;
//    putchar('X');
//    delay_us(50);
    putchar(temp);
//    delay_us(50);
//    putchar('Z') ;
}

void writeapply(int d,int w){
char temp,write=0b00000000;
temp = d << 4 ;
write = write ^ temp ;
temp = w << 0 ;
write = write ^ temp ;
//putchar('X');
//delay_us(100);
putchar(write);
delay_us(100);
putchar(center[w][d][0]);
delay_us(100);
putchar(center[w][d][1]);
//delay_us(100);
//putchar('Z') ;
}

//void defaultpattern(void){
//int block=0,pattern=0,row=0;
//int num =0b11011101;
//for(block=0;block<16;block++){
//    for(pattern=0;pattern<8;pattern++){
//        for(row=0;row<2;row++){
//            center[block][pattern][row]= num;
//            num++;
//        }
//    }
//num=0b11011101;
//}
//}



