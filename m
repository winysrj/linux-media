Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:52089 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751250AbdCYMC5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 25 Mar 2017 08:02:57 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/8] [media] staging: sir: remove unselectable Tekram and Actisys
Date: Sat, 25 Mar 2017 12:02:20 +0000
Message-Id: <f62b874137db2f91f86cc0e988a4104449dfdbb1.1490443026.git.sean@mess.org>
In-Reply-To: <cover.1490443026.git.sean@mess.org>
References: <cover.1490443026.git.sean@mess.org>
In-Reply-To: <cover.1490443026.git.sean@mess.org>
References: <cover.1490443026.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Support for these sir ports is not compiled in by default, it has to
be enabled by manually defining LIRC_TEKRAM, LIRC_SIR_ACTISYS_ACT200L
or LIRC_SIR_ACTISYS_ACT220L somewhere. This cannot be done from Kconfig
at all so remove them from the driver.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/staging/media/lirc/lirc_sir.c | 334 +---------------------------------
 1 file changed, 3 insertions(+), 331 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_sir.c b/drivers/staging/media/lirc/lirc_sir.c
index 9905990..ec5a3c7 100644
--- a/drivers/staging/media/lirc/lirc_sir.c
+++ b/drivers/staging/media/lirc/lirc_sir.c
@@ -1,5 +1,5 @@
 /*
- * LIRC SIR driver, (C) 2000 Milan Pikula <www@fornax.sk>
+ * IR SIR driver, (C) 2000 Milan Pikula <www@fornax.sk>
  *
  * sir_ir - Device driver for use with SIR (serial infra red)
  * mode of IrDA on many notebooks.
@@ -61,62 +61,18 @@
 #include <media/rc-core.h>
 
 /* SECTION: Definitions */
-
-/*** Tekram dongle ***/
-#ifdef LIRC_SIR_TEKRAM
-/* stolen from kernel source */
-/* definitions for Tekram dongle */
-#define TEKRAM_115200 0x00
-#define TEKRAM_57600  0x01
-#define TEKRAM_38400  0x02
-#define TEKRAM_19200  0x03
-#define TEKRAM_9600   0x04
-#define TEKRAM_2400   0x08
-
-#define TEKRAM_PW 0x10 /* Pulse select bit */
-
-/* 10bit * 1s/115200bit in milliseconds = 87ms*/
-#define TIME_CONST (10000000ul/115200ul)
-
-#endif
-
-#ifdef LIRC_SIR_ACTISYS_ACT200L
-static void init_act200(void);
-#elif defined(LIRC_SIR_ACTISYS_ACT220L)
-static void init_act220(void);
-#endif
-
 #define PULSE '['
 
-#ifndef LIRC_SIR_TEKRAM
 /* 9bit * 1s/115200bit in milli seconds = 78.125ms*/
 #define TIME_CONST (9000000ul/115200ul)
-#endif
-
 
 /* timeout for sequences in jiffies (=5/100s), must be longer than TIME_CONST */
 #define SIR_TIMEOUT	(HZ*5/100)
 
-#ifndef LIRC_ON_SA1100
-#ifndef LIRC_IRQ
-#define LIRC_IRQ 4
-#endif
-#ifndef LIRC_PORT
-/* for external dongles, default to com1 */
-#if defined(LIRC_SIR_ACTISYS_ACT200L)         || \
-	    defined(LIRC_SIR_ACTISYS_ACT220L) || \
-	    defined(LIRC_SIR_TEKRAM)
-#define LIRC_PORT 0x3f8
-#else
 /* onboard sir ports are typically com3 */
-#define LIRC_PORT 0x3e8
-#endif
-#endif
-
-static int io = LIRC_PORT;
-static int irq = LIRC_IRQ;
+static int io = 0x3e8;
+static int irq = 4;
 static int threshold = 3;
-#endif
 
 static DEFINE_SPINLOCK(timer_lock);
 static struct timer_list timerlist;
@@ -392,71 +348,6 @@ static int init_hardware(void)
 
 	spin_lock_irqsave(&hardware_lock, flags);
 	/* reset UART */
-#if defined(LIRC_SIR_TEKRAM)
-	/* disable FIFO */
-	soutp(UART_FCR,
-	      UART_FCR_CLEAR_RCVR|
-	      UART_FCR_CLEAR_XMIT|
-	      UART_FCR_TRIGGER_1);
-
-	/* Set DLAB 0. */
-	soutp(UART_LCR, sinp(UART_LCR) & (~UART_LCR_DLAB));
-
-	/* First of all, disable all interrupts */
-	soutp(UART_IER, sinp(UART_IER) &
-	      (~(UART_IER_MSI|UART_IER_RLSI|UART_IER_THRI|UART_IER_RDI)));
-
-	/* Set DLAB 1. */
-	soutp(UART_LCR, sinp(UART_LCR) | UART_LCR_DLAB);
-
-	/* Set divisor to 12 => 9600 Baud */
-	soutp(UART_DLM, 0);
-	soutp(UART_DLL, 12);
-
-	/* Set DLAB 0. */
-	soutp(UART_LCR, sinp(UART_LCR) & (~UART_LCR_DLAB));
-
-	/* power supply */
-	soutp(UART_MCR, UART_MCR_RTS|UART_MCR_DTR|UART_MCR_OUT2);
-	safe_udelay(50*1000);
-
-	/* -DTR low -> reset PIC */
-	soutp(UART_MCR, UART_MCR_RTS|UART_MCR_OUT2);
-	udelay(1*1000);
-
-	soutp(UART_MCR, UART_MCR_RTS|UART_MCR_DTR|UART_MCR_OUT2);
-	udelay(100);
-
-
-	/* -RTS low -> send control byte */
-	soutp(UART_MCR, UART_MCR_DTR|UART_MCR_OUT2);
-	udelay(7);
-	soutp(UART_TX, TEKRAM_115200|TEKRAM_PW);
-
-	/* one byte takes ~1042 usec to transmit at 9600,8N1 */
-	udelay(1500);
-
-	/* back to normal operation */
-	soutp(UART_MCR, UART_MCR_RTS|UART_MCR_DTR|UART_MCR_OUT2);
-	udelay(50);
-
-	udelay(1500);
-
-	/* read previous control byte */
-	pr_info("0x%02x\n", sinp(UART_RX));
-
-	/* Set DLAB 1. */
-	soutp(UART_LCR, sinp(UART_LCR) | UART_LCR_DLAB);
-
-	/* Set divisor to 1 => 115200 Baud */
-	soutp(UART_DLM, 0);
-	soutp(UART_DLL, 1);
-
-	/* Set DLAB 0, 8 Bit */
-	soutp(UART_LCR, UART_LCR_WLEN8);
-	/* enable interrupts */
-	soutp(UART_IER, sinp(UART_IER)|UART_IER_RDI);
-#else
 	outb(0, io + UART_MCR);
 	outb(0, io + UART_IER);
 	/* init UART */
@@ -472,12 +363,6 @@ static int init_hardware(void)
 	outb(UART_IER_RDI, io + UART_IER);
 	/* turn on UART */
 	outb(UART_MCR_DTR|UART_MCR_RTS|UART_MCR_OUT2, io + UART_MCR);
-#ifdef LIRC_SIR_ACTISYS_ACT200L
-	init_act200();
-#elif defined(LIRC_SIR_ACTISYS_ACT220L)
-	init_act220();
-#endif
-#endif
 	spin_unlock_irqrestore(&hardware_lock, flags);
 	return 0;
 }
@@ -526,208 +411,6 @@ static void drop_port(void)
 	release_region(io, 8);
 }
 
-#ifdef LIRC_SIR_ACTISYS_ACT200L
-/* Crystal/Cirrus CS8130 IR transceiver, used in Actisys Act200L dongle */
-/* some code borrowed from Linux IRDA driver */
-
-/* Register 0: Control register #1 */
-#define ACT200L_REG0    0x00
-#define ACT200L_TXEN    0x01 /* Enable transmitter */
-#define ACT200L_RXEN    0x02 /* Enable receiver */
-#define ACT200L_ECHO    0x08 /* Echo control chars */
-
-/* Register 1: Control register #2 */
-#define ACT200L_REG1    0x10
-#define ACT200L_LODB    0x01 /* Load new baud rate count value */
-#define ACT200L_WIDE    0x04 /* Expand the maximum allowable pulse */
-
-/* Register 3: Transmit mode register #2 */
-#define ACT200L_REG3    0x30
-#define ACT200L_B0      0x01 /* DataBits, 0=6, 1=7, 2=8, 3=9(8P)  */
-#define ACT200L_B1      0x02 /* DataBits, 0=6, 1=7, 2=8, 3=9(8P)  */
-#define ACT200L_CHSY    0x04 /* StartBit Synced 0=bittime, 1=startbit */
-
-/* Register 4: Output Power register */
-#define ACT200L_REG4    0x40
-#define ACT200L_OP0     0x01 /* Enable LED1C output */
-#define ACT200L_OP1     0x02 /* Enable LED2C output */
-#define ACT200L_BLKR    0x04
-
-/* Register 5: Receive Mode register */
-#define ACT200L_REG5    0x50
-#define ACT200L_RWIDL   0x01 /* fixed 1.6us pulse mode */
-    /*.. other various IRDA bit modes, and TV remote modes..*/
-
-/* Register 6: Receive Sensitivity register #1 */
-#define ACT200L_REG6    0x60
-#define ACT200L_RS0     0x01 /* receive threshold bit 0 */
-#define ACT200L_RS1     0x02 /* receive threshold bit 1 */
-
-/* Register 7: Receive Sensitivity register #2 */
-#define ACT200L_REG7    0x70
-#define ACT200L_ENPOS   0x04 /* Ignore the falling edge */
-
-/* Register 8,9: Baud Rate Divider register #1,#2 */
-#define ACT200L_REG8    0x80
-#define ACT200L_REG9    0x90
-
-#define ACT200L_2400    0x5f
-#define ACT200L_9600    0x17
-#define ACT200L_19200   0x0b
-#define ACT200L_38400   0x05
-#define ACT200L_57600   0x03
-#define ACT200L_115200  0x01
-
-/* Register 13: Control register #3 */
-#define ACT200L_REG13   0xd0
-#define ACT200L_SHDW    0x01 /* Enable access to shadow registers */
-
-/* Register 15: Status register */
-#define ACT200L_REG15   0xf0
-
-/* Register 21: Control register #4 */
-#define ACT200L_REG21   0x50
-#define ACT200L_EXCK    0x02 /* Disable clock output driver */
-#define ACT200L_OSCL    0x04 /* oscillator in low power, medium accuracy mode */
-
-static void init_act200(void)
-{
-	int i;
-	__u8 control[] = {
-		ACT200L_REG15,
-		ACT200L_REG13 | ACT200L_SHDW,
-		ACT200L_REG21 | ACT200L_EXCK | ACT200L_OSCL,
-		ACT200L_REG13,
-		ACT200L_REG7  | ACT200L_ENPOS,
-		ACT200L_REG6  | ACT200L_RS0  | ACT200L_RS1,
-		ACT200L_REG5  | ACT200L_RWIDL,
-		ACT200L_REG4  | ACT200L_OP0  | ACT200L_OP1 | ACT200L_BLKR,
-		ACT200L_REG3  | ACT200L_B0,
-		ACT200L_REG0  | ACT200L_TXEN | ACT200L_RXEN,
-		ACT200L_REG8 |  (ACT200L_115200       & 0x0f),
-		ACT200L_REG9 | ((ACT200L_115200 >> 4) & 0x0f),
-		ACT200L_REG1 | ACT200L_LODB | ACT200L_WIDE
-	};
-
-	/* Set DLAB 1. */
-	soutp(UART_LCR, UART_LCR_DLAB | UART_LCR_WLEN8);
-
-	/* Set divisor to 12 => 9600 Baud */
-	soutp(UART_DLM, 0);
-	soutp(UART_DLL, 12);
-
-	/* Set DLAB 0. */
-	soutp(UART_LCR, UART_LCR_WLEN8);
-	/* Set divisor to 12 => 9600 Baud */
-
-	/* power supply */
-	soutp(UART_MCR, UART_MCR_RTS|UART_MCR_DTR|UART_MCR_OUT2);
-	for (i = 0; i < 50; i++)
-		safe_udelay(1000);
-
-		/* Reset the dongle : set RTS low for 25 ms */
-	soutp(UART_MCR, UART_MCR_DTR|UART_MCR_OUT2);
-	for (i = 0; i < 25; i++)
-		udelay(1000);
-
-	soutp(UART_MCR, UART_MCR_RTS|UART_MCR_DTR|UART_MCR_OUT2);
-	udelay(100);
-
-	/* Clear DTR and set RTS to enter command mode */
-	soutp(UART_MCR, UART_MCR_RTS|UART_MCR_OUT2);
-	udelay(7);
-
-	/* send out the control register settings for 115K 7N1 SIR operation */
-	for (i = 0; i < sizeof(control); i++) {
-		soutp(UART_TX, control[i]);
-		/* one byte takes ~1042 usec to transmit at 9600,8N1 */
-		udelay(1500);
-	}
-
-	/* back to normal operation */
-	soutp(UART_MCR, UART_MCR_RTS|UART_MCR_DTR|UART_MCR_OUT2);
-	udelay(50);
-
-	udelay(1500);
-	soutp(UART_LCR, sinp(UART_LCR) | UART_LCR_DLAB);
-
-	/* Set DLAB 1. */
-	soutp(UART_LCR, UART_LCR_DLAB | UART_LCR_WLEN7);
-
-	/* Set divisor to 1 => 115200 Baud */
-	soutp(UART_DLM, 0);
-	soutp(UART_DLL, 1);
-
-	/* Set DLAB 0. */
-	soutp(UART_LCR, sinp(UART_LCR) & (~UART_LCR_DLAB));
-
-	/* Set DLAB 0, 7 Bit */
-	soutp(UART_LCR, UART_LCR_WLEN7);
-
-	/* enable interrupts */
-	soutp(UART_IER, sinp(UART_IER)|UART_IER_RDI);
-}
-#endif
-
-#ifdef LIRC_SIR_ACTISYS_ACT220L
-/*
- * Derived from linux IrDA driver (net/irda/actisys.c)
- * Drop me a mail for any kind of comment: maxx@spaceboyz.net
- */
-
-void init_act220(void)
-{
-	int i;
-
-	/* DLAB 1 */
-	soutp(UART_LCR, UART_LCR_DLAB|UART_LCR_WLEN7);
-
-	/* 9600 baud */
-	soutp(UART_DLM, 0);
-	soutp(UART_DLL, 12);
-
-	/* DLAB 0 */
-	soutp(UART_LCR, UART_LCR_WLEN7);
-
-	/* reset the dongle, set DTR low for 10us */
-	soutp(UART_MCR, UART_MCR_RTS|UART_MCR_OUT2);
-	udelay(10);
-
-	/* back to normal (still 9600) */
-	soutp(UART_MCR, UART_MCR_DTR|UART_MCR_RTS|UART_MCR_OUT2);
-
-	/*
-	 * send RTS pulses until we reach 115200
-	 * i hope this is really the same for act220l/act220l+
-	 */
-	for (i = 0; i < 3; i++) {
-		udelay(10);
-		/* set RTS low for 10 us */
-		soutp(UART_MCR, UART_MCR_DTR|UART_MCR_OUT2);
-		udelay(10);
-		/* set RTS high for 10 us */
-		soutp(UART_MCR, UART_MCR_RTS|UART_MCR_DTR|UART_MCR_OUT2);
-	}
-
-	/* back to normal operation */
-	udelay(1500); /* better safe than sorry ;) */
-
-	/* Set DLAB 1. */
-	soutp(UART_LCR, UART_LCR_DLAB | UART_LCR_WLEN7);
-
-	/* Set divisor to 1 => 115200 Baud */
-	soutp(UART_DLM, 0);
-	soutp(UART_DLL, 1);
-
-	/* Set DLAB 0, 7 Bit */
-	/* The dongle doesn't seem to have any problems with operation at 7N1 */
-	soutp(UART_LCR, UART_LCR_WLEN7);
-
-	/* enable interrupts */
-	soutp(UART_IER, UART_IER_RDI);
-}
-#endif
-
 static int init_sir_ir(void)
 {
 	int retval;
@@ -809,19 +492,8 @@ static void __exit sir_ir_exit(void)
 module_init(sir_ir_init);
 module_exit(sir_ir_exit);
 
-#ifdef LIRC_SIR_TEKRAM
-MODULE_DESCRIPTION("Infrared receiver driver for Tekram Irmate 210");
-MODULE_AUTHOR("Christoph Bartelmus");
-#elif defined(LIRC_SIR_ACTISYS_ACT200L)
-MODULE_DESCRIPTION("LIRC driver for Actisys Act200L");
-MODULE_AUTHOR("Karl Bongers");
-#elif defined(LIRC_SIR_ACTISYS_ACT220L)
-MODULE_DESCRIPTION("LIRC driver for Actisys Act220L(+)");
-MODULE_AUTHOR("Jan Roemisch");
-#else
 MODULE_DESCRIPTION("Infrared receiver driver for SIR type serial ports");
 MODULE_AUTHOR("Milan Pikula");
-#endif
 MODULE_LICENSE("GPL");
 
 module_param(io, int, 0444);
-- 
2.9.3
