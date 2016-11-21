Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:39835 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753700AbcKUVzz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Nov 2016 16:55:55 -0500
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH v4 1/3] [media] lirc_serial: port to rc-core
Date: Mon, 21 Nov 2016 21:55:51 +0000
Message-Id: <1479765353-4098-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tested with a homebrew serial ir. Remove last remmants of the nslu2
which could not be enabled, and fix checkpatch warnings.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/staging/media/lirc/lirc_serial.c | 677 +++++++++++++------------------
 1 file changed, 274 insertions(+), 403 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_serial.c b/drivers/staging/media/lirc/lirc_serial.c
index b798b31..05a8a47 100644
--- a/drivers/staging/media/lirc/lirc_serial.c
+++ b/drivers/staging/media/lirc/lirc_serial.c
@@ -9,6 +9,7 @@
  * Copyright (C) 1998 Ben Pfaff <blp@gnu.org>
  * Copyright (C) 1999 Christoph Bartelmus <lirc@bartelmus.de>
  * Copyright (C) 2007 Andrei Tanas <andrei@tanas.ca> (suspend/resume support)
+ * Copyright (C) 2016 Sean Young <sean@mess.org> (port to rc-core)
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
  *  the Free Software Foundation; either version 2 of the License, or
@@ -18,18 +19,13 @@
  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- *
  */
 
 /*
  * Steve's changes to improve transmission fidelity:
  *   - for systems with the rdtsc instruction and the clock counter, a
  *     send_pule that times the pulses directly using the counter.
- *     This means that the LIRC_SERIAL_TRANSMITTER_LATENCY fudge is
+ *     This means that the IR_SERIAL_TRANSMITTER_LATENCY fudge is
  *     not needed. Measurement shows very stable waveform, even where
  *     PCI activity slows the access to the UART, which trips up other
  *     versions.
@@ -52,56 +48,34 @@
 
 #include <linux/module.h>
 #include <linux/errno.h>
-#include <linux/signal.h>
-#include <linux/sched.h>
-#include <linux/fs.h>
 #include <linux/interrupt.h>
-#include <linux/ioport.h>
 #include <linux/kernel.h>
 #include <linux/serial_reg.h>
-#include <linux/ktime.h>
-#include <linux/string.h>
 #include <linux/types.h>
-#include <linux/wait.h>
-#include <linux/mm.h>
 #include <linux/delay.h>
-#include <linux/poll.h>
 #include <linux/platform_device.h>
-#include <linux/gpio.h>
-#include <linux/io.h>
-#include <linux/irq.h>
-#include <linux/fcntl.h>
 #include <linux/spinlock.h>
+#include <media/rc-core.h>
 
-/* From Intel IXP42X Developer's Manual (#252480-005): */
-/* ftp://download.intel.com/design/network/manuals/25248005.pdf */
-#define UART_IE_IXP42X_UUE   0x40 /* IXP42X UART Unit enable */
-#define UART_IE_IXP42X_RTOIE 0x10 /* IXP42X Receiver Data Timeout int.enable */
-
-#include <media/lirc.h>
-#include <media/lirc_dev.h>
-
-#define LIRC_DRIVER_NAME "lirc_serial"
-
-struct lirc_serial {
+struct serial_ir_hw {
 	int signal_pin;
 	int signal_pin_change;
 	u8 on;
 	u8 off;
+	unsigned set_send_carrier:1;
+	unsigned set_duty_cycle:1;
 	long (*send_pulse)(unsigned long length);
 	void (*send_space)(long length);
-	int features;
 	spinlock_t lock;
 };
 
-#define LIRC_HOMEBREW		0
-#define LIRC_IRDEO		1
-#define LIRC_IRDEO_REMOTE	2
-#define LIRC_ANIMAX		3
-#define LIRC_IGOR		4
-#define LIRC_NSLU2		5
+#define IR_HOMEBREW	0
+#define IR_IRDEO	1
+#define IR_IRDEO_REMOTE	2
+#define IR_ANIMAX	3
+#define IR_IGOR		4
 
-/*** module parameters ***/
+/* module parameters */
 static int type;
 static int io;
 static int irq;
@@ -114,107 +88,89 @@ static bool txsense;	/* 0 = active high, 1 = active low */
 
 /* forward declarations */
 static long send_pulse_irdeo(unsigned long length);
-static long send_pulse_homebrew(unsigned long length);
 static void send_space_irdeo(long length);
+#ifdef CONFIG_IR_SERIAL_TRANSMITTER
+static long send_pulse_homebrew(unsigned long length);
 static void send_space_homebrew(long length);
+#endif
 
-static struct lirc_serial hardware[] = {
-	[LIRC_HOMEBREW] = {
-		.lock = __SPIN_LOCK_UNLOCKED(hardware[LIRC_HOMEBREW].lock),
-		.signal_pin        = UART_MSR_DCD,
+static struct serial_ir_hw hardware[] = {
+	[IR_HOMEBREW] = {
+		.lock = __SPIN_LOCK_UNLOCKED(hardware[IR_HOMEBREW].lock),
+		.signal_pin	   = UART_MSR_DCD,
 		.signal_pin_change = UART_MSR_DDCD,
 		.on  = (UART_MCR_RTS | UART_MCR_OUT2 | UART_MCR_DTR),
 		.off = (UART_MCR_RTS | UART_MCR_OUT2),
+#ifdef CONFIG_IR_SERIAL_TRANSMITTER
 		.send_pulse = send_pulse_homebrew,
 		.send_space = send_space_homebrew,
-#ifdef CONFIG_LIRC_SERIAL_TRANSMITTER
-		.features    = (LIRC_CAN_SET_SEND_DUTY_CYCLE |
-				LIRC_CAN_SET_SEND_CARRIER |
-				LIRC_CAN_SEND_PULSE | LIRC_CAN_REC_MODE2)
-#else
-		.features    = LIRC_CAN_REC_MODE2
+		.set_send_carrier = true,
+		.set_duty_cycle = true,
 #endif
 	},
 
-	[LIRC_IRDEO] = {
-		.lock = __SPIN_LOCK_UNLOCKED(hardware[LIRC_IRDEO].lock),
-		.signal_pin        = UART_MSR_DSR,
+	[IR_IRDEO] = {
+		.lock = __SPIN_LOCK_UNLOCKED(hardware[IR_IRDEO].lock),
+		.signal_pin	   = UART_MSR_DSR,
 		.signal_pin_change = UART_MSR_DDSR,
 		.on  = UART_MCR_OUT2,
 		.off = (UART_MCR_RTS | UART_MCR_DTR | UART_MCR_OUT2),
-		.send_pulse  = send_pulse_irdeo,
-		.send_space  = send_space_irdeo,
-		.features    = (LIRC_CAN_SET_SEND_DUTY_CYCLE |
-				LIRC_CAN_SEND_PULSE | LIRC_CAN_REC_MODE2)
+		.send_pulse = send_pulse_irdeo,
+		.send_space = send_space_irdeo,
+		.set_duty_cycle = true,
 	},
 
-	[LIRC_IRDEO_REMOTE] = {
-		.lock = __SPIN_LOCK_UNLOCKED(hardware[LIRC_IRDEO_REMOTE].lock),
-		.signal_pin        = UART_MSR_DSR,
+	[IR_IRDEO_REMOTE] = {
+		.lock = __SPIN_LOCK_UNLOCKED(hardware[IR_IRDEO_REMOTE].lock),
+		.signal_pin	   = UART_MSR_DSR,
 		.signal_pin_change = UART_MSR_DDSR,
 		.on  = (UART_MCR_RTS | UART_MCR_DTR | UART_MCR_OUT2),
 		.off = (UART_MCR_RTS | UART_MCR_DTR | UART_MCR_OUT2),
-		.send_pulse  = send_pulse_irdeo,
-		.send_space  = send_space_irdeo,
-		.features    = (LIRC_CAN_SET_SEND_DUTY_CYCLE |
-				LIRC_CAN_SEND_PULSE | LIRC_CAN_REC_MODE2)
+		.send_pulse = send_pulse_irdeo,
+		.send_space = send_space_irdeo,
+		.set_duty_cycle = true,
 	},
 
-	[LIRC_ANIMAX] = {
-		.lock = __SPIN_LOCK_UNLOCKED(hardware[LIRC_ANIMAX].lock),
-		.signal_pin        = UART_MSR_DCD,
+	[IR_ANIMAX] = {
+		.lock = __SPIN_LOCK_UNLOCKED(hardware[IR_ANIMAX].lock),
+		.signal_pin	   = UART_MSR_DCD,
 		.signal_pin_change = UART_MSR_DDCD,
 		.on  = 0,
 		.off = (UART_MCR_RTS | UART_MCR_DTR | UART_MCR_OUT2),
 		.send_pulse = NULL,
 		.send_space = NULL,
-		.features   = LIRC_CAN_REC_MODE2
 	},
 
-	[LIRC_IGOR] = {
-		.lock = __SPIN_LOCK_UNLOCKED(hardware[LIRC_IGOR].lock),
-		.signal_pin        = UART_MSR_DSR,
+	[IR_IGOR] = {
+		.lock = __SPIN_LOCK_UNLOCKED(hardware[IR_IGOR].lock),
+		.signal_pin	   = UART_MSR_DSR,
 		.signal_pin_change = UART_MSR_DDSR,
 		.on  = (UART_MCR_RTS | UART_MCR_OUT2 | UART_MCR_DTR),
 		.off = (UART_MCR_RTS | UART_MCR_OUT2),
+#ifdef CONFIG_IR_SERIAL_TRANSMITTER
 		.send_pulse = send_pulse_homebrew,
 		.send_space = send_space_homebrew,
-#ifdef CONFIG_LIRC_SERIAL_TRANSMITTER
-		.features    = (LIRC_CAN_SET_SEND_DUTY_CYCLE |
-				LIRC_CAN_SET_SEND_CARRIER |
-				LIRC_CAN_SEND_PULSE | LIRC_CAN_REC_MODE2)
-#else
-		.features    = LIRC_CAN_REC_MODE2
+		.set_send_carrier = true,
+		.set_duty_cycle = true,
 #endif
 	},
 };
 
 #define RS_ISR_PASS_LIMIT 256
 
-/*
- * A long pulse code from a remote might take up to 300 bytes.  The
- * daemon should read the bytes as soon as they are generated, so take
- * the number of keys you think you can push before the daemon runs
- * and multiply by 300.  The driver will warn you if you overrun this
- * buffer.  If you have a slow computer or non-busmastering IDE disks,
- * maybe you will need to increase this.
- */
-
-/* This MUST be a power of two!  It has to be larger than 1 as well. */
-
-#define RBUF_LEN 256
+struct serial_ir {
+	ktime_t lastkt;
+	struct rc_dev *rcdev;
+	struct platform_device *pdev;
 
-static ktime_t lastkt;
+	unsigned int freq;
+	unsigned int duty_cycle;
 
-static struct lirc_buffer rbuf;
-
-static unsigned int freq = 38000;
-static unsigned int duty_cycle = 50;
+	unsigned long period;
+	unsigned long pulse_width, space_width;
+};
 
-/* Initialized in init_timing_params() */
-static unsigned long period;
-static unsigned long pulse_width;
-static unsigned long space_width;
+static struct serial_ir serial_ir;
 
 #if defined(__i386__)
 /*
@@ -241,18 +197,18 @@ static unsigned long space_width;
  * changed from 400 to 450 as this works better on slower machines;
  * faster machines will use the rdtsc code anyway
  */
-#define LIRC_SERIAL_TRANSMITTER_LATENCY 450
+#define IR_SERIAL_TRANSMITTER_LATENCY 450
 
 #else
 
 /* does anybody have information on other platforms ? */
 /* 256 = 1<<8 */
-#define LIRC_SERIAL_TRANSMITTER_LATENCY 256
+#define IR_SERIAL_TRANSMITTER_LATENCY 256
 
-#endif  /* __i386__ */
+#endif	/* __i386__ */
 /*
  * FIXME: should we be using hrtimers instead of this
- * LIRC_SERIAL_TRANSMITTER_LATENCY nonsense?
+ * IR_SERIAL_TRANSMITTER_LATENCY nonsense?
  */
 
 /* fetch serial input packet (1 byte) from register offset */
@@ -324,8 +280,8 @@ static int init_timing_params(unsigned int new_duty_cycle,
 {
 	__u64 loops_per_sec, work;
 
-	duty_cycle = new_duty_cycle;
-	freq = new_freq;
+	serial_ir.duty_cycle = new_duty_cycle;
+	serial_ir.freq = new_freq;
 
 	loops_per_sec = __this_cpu_read(cpu.info.loops_per_jiffy);
 	loops_per_sec *= HZ;
@@ -338,12 +294,12 @@ static int init_timing_params(unsigned int new_duty_cycle,
 	 * Carrier period in clocks, approach good up to 32GHz clock,
 	 * gets carrier frequency within 8Hz
 	 */
-	period = loops_per_sec >> 3;
-	period /= (freq >> 3);
+	serial_ir.period = loops_per_sec >> 3;
+	serial_ir.pperiod /= (freq >> 3);
 
 	/* Derive pulse and space from the period */
-	pulse_width = period * duty_cycle / 100;
-	space_width = period - pulse_width;
+	serial_ir.ppulse_width = serial_ir.period * serial.ir.duty_cycle / 100;
+	serial_ir.pspace_width = serial_ir.period - serial_ir.pulse_width;
 	pr_debug("in init_timing_params, freq=%d, duty_cycle=%d, clk/jiffy=%ld, pulse=%ld, space=%ld, conv_us_to_clocks=%ld\n",
 		 freq, duty_cycle, __this_cpu_read(cpu_info.loops_per_jiffy),
 		 pulse_width, space_width, conv_us_to_clocks);
@@ -358,18 +314,19 @@ static int init_timing_params(unsigned int new_duty_cycle,
  * IE multiplied by 256.
  */
 	if (256 * 1000000L / new_freq * new_duty_cycle / 100 <=
-	    LIRC_SERIAL_TRANSMITTER_LATENCY)
+	    IR_SERIAL_TRANSMITTER_LATENCY)
 		return -EINVAL;
 	if (256 * 1000000L / new_freq * (100 - new_duty_cycle) / 100 <=
-	    LIRC_SERIAL_TRANSMITTER_LATENCY)
+	    IR_SERIAL_TRANSMITTER_LATENCY)
 		return -EINVAL;
-	duty_cycle = new_duty_cycle;
-	freq = new_freq;
-	period = 256 * 1000000L / freq;
-	pulse_width = period * duty_cycle / 100;
-	space_width = period - pulse_width;
+	serial_ir.duty_cycle = new_duty_cycle;
+	serial_ir.freq = new_freq;
+	serial_ir.period = 256 * 1000000L / serial_ir.freq;
+	serial_ir.pulse_width = serial_ir.period * serial_ir.duty_cycle / 100;
+	serial_ir.space_width = serial_ir.period - serial_ir.pulse_width;
 	pr_debug("in init_timing_params, freq=%d pulse=%ld, space=%ld\n",
-		 freq, pulse_width, space_width);
+				serial_ir.freq, serial_ir.pulse_width,
+				serial_ir.space_width);
 	return 0;
 }
 #endif /* USE_RDTSC */
@@ -386,7 +343,7 @@ static long send_pulse_irdeo(unsigned long length)
 
 	/* how many bits have to be sent ? */
 	rawbits = length * 1152 / 10000;
-	if (duty_cycle > 50)
+	if (serial_ir.duty_cycle > 50)
 		chunk = 3;
 	else
 		chunk = 1;
@@ -429,6 +386,15 @@ static long send_pulse_irdeo(unsigned long length)
 
 /* To match 8 fractional bits used for pulse/space length */
 
+static void send_space_irdeo(long length)
+{
+	if (length <= 0)
+		return;
+
+	safe_udelay(length);
+}
+
+#ifdef CONFIG_IR_SERIAL_TRANSMITTER
 static long send_pulse_homebrew_softcarrier(unsigned long length)
 {
 	int flag;
@@ -440,19 +406,19 @@ static long send_pulse_homebrew_softcarrier(unsigned long length)
 	while (actual < length) {
 		if (flag) {
 			off();
-			target += space_width;
+			target += serial_ir.space_width;
 		} else {
 			on();
-			target += pulse_width;
+			target += serial_ir.pulse_width;
 		}
 		d = (target - actual -
-		     LIRC_SERIAL_TRANSMITTER_LATENCY + 128) >> 8;
+		     IR_SERIAL_TRANSMITTER_LATENCY + 128) >> 8;
 		/*
 		 * Note - we've checked in ioctl that the pulse/space
 		 * widths are big enough so that d is > 0
 		 */
 		udelay(d);
-		actual += (d << 8) + LIRC_SERIAL_TRANSMITTER_LATENCY;
+		actual += (d << 8) + IR_SERIAL_TRANSMITTER_LATENCY;
 		flag = !flag;
 	}
 	return (actual-length) >> 8;
@@ -471,14 +437,6 @@ static long send_pulse_homebrew(unsigned long length)
 	return 0;
 }
 
-static void send_space_irdeo(long length)
-{
-	if (length <= 0)
-		return;
-
-	safe_udelay(length);
-}
-
 static void send_space_homebrew(long length)
 {
 	off();
@@ -486,67 +444,70 @@ static void send_space_homebrew(long length)
 		return;
 	safe_udelay(length);
 }
+#endif
 
-static void rbwrite(int l)
-{
-	if (lirc_buffer_full(&rbuf)) {
-		/* no new signals will be accepted */
-		pr_debug("Buffer overrun\n");
-		return;
-	}
-	lirc_buffer_write(&rbuf, (void *)&l);
-}
-
-static void frbwrite(int l)
+static void frbwrite(unsigned int l, bool is_pulse)
 {
 	/* simple noise filter */
-	static int pulse, space;
-	static unsigned int ptr;
-
-	if (ptr > 0 && (l & PULSE_BIT)) {
-		pulse += l & PULSE_MASK;
-		if (pulse > 250) {
-			rbwrite(space);
-			rbwrite(pulse | PULSE_BIT);
+	static unsigned int ptr, pulse, space;
+	DEFINE_IR_RAW_EVENT(ev);
+
+	if (ptr > 0 && is_pulse) {
+		pulse += l;
+		if (pulse > 250000) {
+			ev.duration = space;
+			ev.pulse = false;
+			ir_raw_event_store_with_filter(serial_ir.rcdev, &ev);
+			ev.duration = pulse;
+			ev.pulse = true;
+			ir_raw_event_store_with_filter(serial_ir.rcdev, &ev);
 			ptr = 0;
 			pulse = 0;
 		}
 		return;
 	}
-	if (!(l & PULSE_BIT)) {
+	if (!is_pulse) {
 		if (ptr == 0) {
-			if (l > 20000) {
+			if (l > 20000000) {
 				space = l;
 				ptr++;
 				return;
 			}
 		} else {
-			if (l > 20000) {
+			if (l > 20000000) {
 				space += pulse;
-				if (space > PULSE_MASK)
-					space = PULSE_MASK;
+				if (space > IR_MAX_DURATION)
+					space = IR_MAX_DURATION;
 				space += l;
-				if (space > PULSE_MASK)
-					space = PULSE_MASK;
+				if (space > IR_MAX_DURATION)
+					space = IR_MAX_DURATION;
 				pulse = 0;
 				return;
 			}
-			rbwrite(space);
-			rbwrite(pulse | PULSE_BIT);
+
+			ev.duration = space;
+			ev.pulse = false;
+			ir_raw_event_store_with_filter(serial_ir.rcdev, &ev);
+			ev.duration = pulse;
+			ev.pulse = true;
+			ir_raw_event_store_with_filter(serial_ir.rcdev, &ev);
 			ptr = 0;
 			pulse = 0;
 		}
 	}
-	rbwrite(l);
+
+	ev.duration = l;
+	ev.pulse = is_pulse;
+	ir_raw_event_store_with_filter(serial_ir.rcdev, &ev);
 }
 
-static irqreturn_t lirc_irq_handler(int i, void *blah)
+static irqreturn_t serial_ir_irq_handler(int i, void *blah)
 {
 	ktime_t kt;
 	int counter, dcd;
 	u8 status;
 	ktime_t delkt;
-	int data;
+	unsigned int data;
 	static int last_dcd = -1;
 
 	if ((sinp(UART_IIR) & UART_IIR_NO_INT)) {
@@ -559,7 +520,7 @@ static irqreturn_t lirc_irq_handler(int i, void *blah)
 		counter++;
 		status = sinp(UART_MSR);
 		if (counter > RS_ISR_PASS_LIMIT) {
-			pr_warn("AIEEEE: We're caught!\n");
+			dev_err(&serial_ir.pdev->dev, "Trapped in interrupt");
 			break;
 		}
 		if ((status & hardware[type].signal_pin_change)
@@ -567,47 +528,32 @@ static irqreturn_t lirc_irq_handler(int i, void *blah)
 			/* get current time */
 			kt = ktime_get();
 
-			/* New mode, written by Trent Piepho
-			   <xyzzy@u.washington.edu>. */
-
 			/*
-			 * The old format was not very portable.
-			 * We now use an int to pass pulses
-			 * and spaces to user space.
-			 *
-			 * If PULSE_BIT is set a pulse has been
-			 * received, otherwise a space has been
-			 * received.  The driver needs to know if your
-			 * receiver is active high or active low, or
-			 * the space/pulse sense could be
-			 * inverted. The bits denoted by PULSE_MASK are
-			 * the length in microseconds. Lengths greater
-			 * than or equal to 16 seconds are clamped to
-			 * PULSE_MASK.  All other bits are unused.
-			 * This is a much simpler interface for user
-			 * programs, as well as eliminating "out of
-			 * phase" errors with space/pulse
-			 * autodetection.
+			 * The driver needs to know if your receiver is
+			 * active high or active low, or the space/pulse
+			 * sense could be inverted.
 			 */
 
-			/* calc time since last interrupt in microseconds */
+			/* calc time since last interrupt in nanoseconds */
 			dcd = (status & hardware[type].signal_pin) ? 1 : 0;
 
 			if (dcd == last_dcd) {
-				pr_warn("ignoring spike: %d %d %llx %llx\n",
-					dcd, sense, ktime_to_us(kt),
-					ktime_to_us(lastkt));
+				dev_err(&serial_ir.pdev->dev,
+					"ignoring spike: %d %d %lldns %lldns\n",
+					dcd, sense, ktime_to_ns(kt),
+					ktime_to_ns(serial_ir.lastkt));
 				continue;
 			}
 
-			delkt = ktime_sub(kt, lastkt);
+			delkt = ktime_sub(kt, serial_ir.lastkt);
 			if (ktime_compare(delkt, ktime_set(15, 0)) > 0) {
-				data = PULSE_MASK; /* really long time */
+				data = IR_MAX_DURATION; /* really long time */
 				if (!(dcd^sense)) {
 					/* sanity check */
-					pr_warn("AIEEEE: %d %d %llx %llx\n",
-						dcd, sense, ktime_to_us(kt),
-						ktime_to_us(lastkt));
+					dev_err(&serial_ir.pdev->dev,
+						"dcd unexpected: %d %d %lldns %lldns\n",
+						dcd, sense, ktime_to_ns(kt),
+						ktime_to_ns(serial_ir.lastkt));
 					/*
 					 * detecting pulse while this
 					 * MUST be a space!
@@ -615,11 +561,11 @@ static irqreturn_t lirc_irq_handler(int i, void *blah)
 					sense = sense ? 0 : 1;
 				}
 			} else
-				data = (int) ktime_to_us(delkt);
-			frbwrite(dcd^sense ? data : (data|PULSE_BIT));
-			lastkt = kt;
+				data = ktime_to_ns(delkt);
+			frbwrite(data, !(dcd ^ sense));
+			serial_ir.lastkt = kt;
 			last_dcd = dcd;
-			wake_up_interruptible(&rbuf.wait_poll);
+			ir_raw_event_handle(serial_ir.rcdev);
 		}
 	} while (!(sinp(UART_IIR) & UART_IIR_NO_INT)); /* still pending ? */
 	return IRQ_HANDLED;
@@ -652,8 +598,6 @@ static int hardware_init_port(void)
 		return -ENODEV;
 	}
 
-
-
 	/* Set DLAB 0. */
 	soutp(UART_LCR, sinp(UART_LCR) & (~UART_LCR_DLAB));
 
@@ -677,8 +621,8 @@ static int hardware_init_port(void)
 	sinp(UART_MSR);
 
 	switch (type) {
-	case LIRC_IRDEO:
-	case LIRC_IRDEO_REMOTE:
+	case IR_IRDEO:
+	case IR_IRDEO_REMOTE:
 		/* setup port to 7N1 @ 115200 Baud */
 		/* 7N1+start = 9 bits at 115200 ~ 3 bits at 38kHz */
 
@@ -698,13 +642,13 @@ static int hardware_init_port(void)
 	return 0;
 }
 
-static int lirc_serial_probe(struct platform_device *dev)
+static int serial_ir_probe(struct platform_device *dev)
 {
 	int i, nlow, nhigh, result;
 
-	result = devm_request_irq(&dev->dev, irq, lirc_irq_handler,
-			     (share_irq ? IRQF_SHARED : 0),
-			     LIRC_DRIVER_NAME, &hardware);
+	result = devm_request_irq(&dev->dev, irq, serial_ir_irq_handler,
+				  share_irq ? IRQF_SHARED : 0,
+				  KBUILD_MODNAME, &hardware);
 	if (result < 0) {
 		if (result == -EBUSY)
 			dev_err(&dev->dev, "IRQ %d busy\n", irq);
@@ -714,17 +658,12 @@ static int lirc_serial_probe(struct platform_device *dev)
 	}
 
 	/* Reserve io region. */
-	/*
-	 * Future MMAP-Developers: Attention!
-	 * For memory mapped I/O you *might* need to use ioremap() first,
-	 * for the NSLU2 it's done in boot code.
-	 */
 	if (((iommap)
 	     && (devm_request_mem_region(&dev->dev, iommap, 8 << ioshift,
-					 LIRC_DRIVER_NAME) == NULL))
+					 KBUILD_MODNAME) == NULL))
 	   || ((!iommap)
 	       && (devm_request_region(&dev->dev, io, 8,
-				       LIRC_DRIVER_NAME) == NULL))) {
+				       KBUILD_MODNAME) == NULL))) {
 		dev_err(&dev->dev, "port %04x already in use\n", io);
 		dev_warn(&dev->dev, "use 'setserial /dev/ttySX uart none'\n");
 		dev_warn(&dev->dev,
@@ -738,7 +677,7 @@ static int lirc_serial_probe(struct platform_device *dev)
 		return result;
 
 	/* Initialize pulse/space widths */
-	init_timing_params(duty_cycle, freq);
+	init_timing_params(50, 38000);
 
 	/* If pin is high, then this must be an active low receiver. */
 	if (sense == -1) {
@@ -769,12 +708,12 @@ static int lirc_serial_probe(struct platform_device *dev)
 	return 0;
 }
 
-static int set_use_inc(void *data)
+static int serial_ir_open(struct rc_dev *rcdev)
 {
 	unsigned long flags;
 
 	/* initialize timestamp */
-	lastkt = ktime_get();
+	serial_ir.lastkt = ktime_get();
 
 	spin_lock_irqsave(&hardware[type].lock, flags);
 
@@ -788,8 +727,9 @@ static int set_use_inc(void *data)
 	return 0;
 }
 
-static void set_use_dec(void *data)
-{	unsigned long flags;
+static void serial_ir_close(struct rc_dev *rcdev)
+{
+	unsigned long flags;
 
 	spin_lock_irqsave(&hardware[type].lock, flags);
 
@@ -802,136 +742,44 @@ static void set_use_dec(void *data)
 	spin_unlock_irqrestore(&hardware[type].lock, flags);
 }
 
-static ssize_t lirc_write(struct file *file, const char __user *buf,
-			 size_t n, loff_t *ppos)
+static int serial_ir_tx(struct rc_dev *dev, unsigned int *txbuf,
+			unsigned int count)
 {
-	int i, count;
 	unsigned long flags;
 	long delta = 0;
-	int *wbuf;
-
-	if (!(hardware[type].features & LIRC_CAN_SEND_PULSE))
-		return -EPERM;
+	int i;
 
-	count = n / sizeof(int);
-	if (n % sizeof(int) || count % 2 == 0)
-		return -EINVAL;
-	wbuf = memdup_user(buf, n);
-	if (IS_ERR(wbuf))
-		return PTR_ERR(wbuf);
 	spin_lock_irqsave(&hardware[type].lock, flags);
-	if (type == LIRC_IRDEO) {
+	if (type == IR_IRDEO) {
 		/* DTR, RTS down */
 		on();
 	}
 	for (i = 0; i < count; i++) {
 		if (i%2)
-			hardware[type].send_space(wbuf[i] - delta);
+			hardware[type].send_space(txbuf[i] - delta);
 		else
-			delta = hardware[type].send_pulse(wbuf[i]);
+			delta = hardware[type].send_pulse(txbuf[i]);
 	}
 	off();
 	spin_unlock_irqrestore(&hardware[type].lock, flags);
-	kfree(wbuf);
-	return n;
+	return count;
 }
 
-static long lirc_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
+static int serial_ir_tx_duty_cycle(struct rc_dev *dev, u32 cycle)
 {
-	int result;
-	u32 __user *uptr = (u32 __user *)arg;
-	u32 value;
-
-	switch (cmd) {
-	case LIRC_GET_SEND_MODE:
-		if (!(hardware[type].features&LIRC_CAN_SEND_MASK))
-			return -ENOIOCTLCMD;
-
-		result = put_user(LIRC_SEND2MODE
-				  (hardware[type].features&LIRC_CAN_SEND_MASK),
-				  uptr);
-		if (result)
-			return result;
-		break;
-
-	case LIRC_SET_SEND_MODE:
-		if (!(hardware[type].features&LIRC_CAN_SEND_MASK))
-			return -ENOIOCTLCMD;
-
-		result = get_user(value, uptr);
-		if (result)
-			return result;
-		/* only LIRC_MODE_PULSE supported */
-		if (value != LIRC_MODE_PULSE)
-			return -EINVAL;
-		break;
-
-	case LIRC_GET_LENGTH:
-		return -ENOIOCTLCMD;
-
-	case LIRC_SET_SEND_DUTY_CYCLE:
-		pr_debug("SET_SEND_DUTY_CYCLE\n");
-		if (!(hardware[type].features&LIRC_CAN_SET_SEND_DUTY_CYCLE))
-			return -ENOIOCTLCMD;
-
-		result = get_user(value, uptr);
-		if (result)
-			return result;
-		if (value <= 0 || value > 100)
-			return -EINVAL;
-		return init_timing_params(value, freq);
-
-	case LIRC_SET_SEND_CARRIER:
-		pr_debug("SET_SEND_CARRIER\n");
-		if (!(hardware[type].features&LIRC_CAN_SET_SEND_CARRIER))
-			return -ENOIOCTLCMD;
-
-		result = get_user(value, uptr);
-		if (result)
-			return result;
-		if (value > 500000 || value < 20000)
-			return -EINVAL;
-		return init_timing_params(duty_cycle, value);
-
-	default:
-		return lirc_dev_fop_ioctl(filep, cmd, arg);
-	}
-	return 0;
+	return init_timing_params(cycle, serial_ir.freq);
 }
 
-static const struct file_operations lirc_fops = {
-	.owner		= THIS_MODULE,
-	.write		= lirc_write,
-	.unlocked_ioctl	= lirc_ioctl,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl	= lirc_ioctl,
-#endif
-	.read		= lirc_dev_fop_read,
-	.poll		= lirc_dev_fop_poll,
-	.open		= lirc_dev_fop_open,
-	.release	= lirc_dev_fop_close,
-	.llseek		= no_llseek,
-};
-
-static struct lirc_driver driver = {
-	.name		= LIRC_DRIVER_NAME,
-	.minor		= -1,
-	.code_length	= 1,
-	.sample_rate	= 0,
-	.data		= NULL,
-	.add_to_buf	= NULL,
-	.rbuf		= &rbuf,
-	.set_use_inc	= set_use_inc,
-	.set_use_dec	= set_use_dec,
-	.fops		= &lirc_fops,
-	.dev		= NULL,
-	.owner		= THIS_MODULE,
-};
+static int serial_ir_tx_carrier(struct rc_dev *dev, u32 carrier)
+{
+	if (carrier > 500000 || carrier < 20000)
+		return -EINVAL;
 
-static struct platform_device *lirc_serial_dev;
+	return init_timing_params(serial_ir.duty_cycle, carrier);
+}
 
-static int lirc_serial_suspend(struct platform_device *dev,
-			       pm_message_t state)
+static int serial_ir_suspend(struct platform_device *dev,
+			     pm_message_t state)
 {
 	/* Set DLAB 0. */
 	soutp(UART_LCR, sinp(UART_LCR) & (~UART_LCR_DLAB));
@@ -949,10 +797,7 @@ static int lirc_serial_suspend(struct platform_device *dev,
 	return 0;
 }
 
-/* twisty maze... need a forward-declaration here... */
-static void lirc_serial_exit(void);
-
-static int lirc_serial_resume(struct platform_device *dev)
+static int serial_ir_resume(struct platform_device *dev)
 {
 	unsigned long flags;
 	int result;
@@ -963,79 +808,68 @@ static int lirc_serial_resume(struct platform_device *dev)
 
 	spin_lock_irqsave(&hardware[type].lock, flags);
 	/* Enable Interrupt */
-	lastkt = ktime_get();
+	serial_ir.lastkt = ktime_get();
 	soutp(UART_IER, sinp(UART_IER)|UART_IER_MSI);
 	off();
 
-	lirc_buffer_clear(&rbuf);
-
 	spin_unlock_irqrestore(&hardware[type].lock, flags);
 
 	return 0;
 }
 
-static struct platform_driver lirc_serial_driver = {
-	.probe		= lirc_serial_probe,
-	.suspend	= lirc_serial_suspend,
-	.resume		= lirc_serial_resume,
+static struct platform_driver serial_ir_driver = {
+	.probe		= serial_ir_probe,
+	.suspend	= serial_ir_suspend,
+	.resume		= serial_ir_resume,
 	.driver		= {
-		.name	= "lirc_serial",
+		.name	= "serial_ir",
 	},
 };
 
-static int __init lirc_serial_init(void)
+static int __init serial_ir_init(void)
 {
 	int result;
 
-	/* Init read buffer. */
-	result = lirc_buffer_init(&rbuf, sizeof(int), RBUF_LEN);
-	if (result < 0)
+	result = platform_driver_register(&serial_ir_driver);
+	if (result)
 		return result;
 
-	result = platform_driver_register(&lirc_serial_driver);
-	if (result) {
-		printk("lirc register returned %d\n", result);
-		goto exit_buffer_free;
-	}
-
-	lirc_serial_dev = platform_device_alloc("lirc_serial", 0);
-	if (!lirc_serial_dev) {
+	serial_ir.pdev = platform_device_alloc("serial_ir", 0);
+	if (!serial_ir.pdev) {
 		result = -ENOMEM;
 		goto exit_driver_unregister;
 	}
 
-	result = platform_device_add(lirc_serial_dev);
+	result = platform_device_add(serial_ir.pdev);
 	if (result)
 		goto exit_device_put;
 
 	return 0;
 
 exit_device_put:
-	platform_device_put(lirc_serial_dev);
+	platform_device_put(serial_ir.pdev);
 exit_driver_unregister:
-	platform_driver_unregister(&lirc_serial_driver);
-exit_buffer_free:
-	lirc_buffer_free(&rbuf);
+	platform_driver_unregister(&serial_ir_driver);
 	return result;
 }
 
-static void lirc_serial_exit(void)
+static void serial_ir_exit(void)
 {
-	platform_device_unregister(lirc_serial_dev);
-	platform_driver_unregister(&lirc_serial_driver);
-	lirc_buffer_free(&rbuf);
+	platform_device_unregister(serial_ir.pdev);
+	platform_driver_unregister(&serial_ir_driver);
 }
 
-static int __init lirc_serial_init_module(void)
+static int __init serial_ir_init_module(void)
 {
+	struct rc_dev *rcdev;
 	int result;
 
 	switch (type) {
-	case LIRC_HOMEBREW:
-	case LIRC_IRDEO:
-	case LIRC_IRDEO_REMOTE:
-	case LIRC_ANIMAX:
-	case LIRC_IGOR:
+	case IR_HOMEBREW:
+	case IR_IRDEO:
+	case IR_IRDEO_REMOTE:
+	case IR_ANIMAX:
+	case IR_IGOR:
 		/* if nothing specified, use ttyS0/com1 and irq 4 */
 		io = io ? io : 0x3f8;
 		irq = irq ? irq : 4;
@@ -1045,11 +879,10 @@ static int __init lirc_serial_init_module(void)
 	}
 	if (!softcarrier) {
 		switch (type) {
-		case LIRC_HOMEBREW:
-		case LIRC_IGOR:
-			hardware[type].features &=
-				~(LIRC_CAN_SET_SEND_DUTY_CYCLE|
-				  LIRC_CAN_SET_SEND_CARRIER);
+		case IR_HOMEBREW:
+		case IR_IGOR:
+			hardware[type].set_send_carrier = false;
+			hardware[type].set_duty_cycle = false;
 			break;
 		}
 	}
@@ -1058,73 +891,111 @@ static int __init lirc_serial_init_module(void)
 	if (sense != -1)
 		sense = !!sense;
 
-	result = lirc_serial_init();
+	result = serial_ir_init();
 	if (result)
 		return result;
 
-	driver.features = hardware[type].features;
-	driver.dev = &lirc_serial_dev->dev;
-	driver.minor = lirc_register_driver(&driver);
-	if (driver.minor < 0) {
-		pr_err("register_chrdev failed!\n");
-		lirc_serial_exit();
-		return driver.minor;
+	rcdev = devm_rc_allocate_device(&serial_ir.pdev->dev);
+	if (!rcdev) {
+		result = -ENOMEM;
+		goto serial_cleanup;
 	}
-	return 0;
+
+	if (hardware[type].send_pulse && hardware[type].send_space)
+		rcdev->tx_ir = serial_ir_tx;
+	if (hardware[type].set_send_carrier)
+		rcdev->s_tx_carrier = serial_ir_tx_carrier;
+	if (hardware[type].set_duty_cycle)
+		rcdev->s_tx_duty_cycle = serial_ir_tx_duty_cycle;
+
+	switch (type) {
+	case IR_HOMEBREW:
+		rcdev->input_name = "Serial IR type home-brew";
+		break;
+	case IR_IRDEO:
+		rcdev->input_name = "Serial IR type IRdeo";
+		break;
+	case IR_IRDEO_REMOTE:
+		rcdev->input_name = "Serial IR type IRdeo remote";
+		break;
+	case IR_ANIMAX:
+		rcdev->input_name = "Serial IR type AnimaX";
+		break;
+	case IR_IGOR:
+		rcdev->input_name = "Serial IR type IgorPlug";
+		break;
+	}
+
+	rcdev->input_phys = KBUILD_MODNAME "/input0";
+	rcdev->input_id.bustype = BUS_HOST;
+	rcdev->input_id.vendor = 0x0001;
+	rcdev->input_id.product = 0x0001;
+	rcdev->input_id.version = 0x0100;
+	rcdev->open = serial_ir_open;
+	rcdev->close = serial_ir_close;
+	rcdev->dev.parent = &serial_ir.pdev->dev;
+	rcdev->driver_type = RC_DRIVER_IR_RAW;
+	rcdev->allowed_protocols = RC_BIT_ALL;
+	rcdev->driver_name = KBUILD_MODNAME;
+	rcdev->map_name = RC_MAP_RC6_MCE;
+	rcdev->timeout = IR_DEFAULT_TIMEOUT;
+	rcdev->rx_resolution = 250000;
+
+	serial_ir.rcdev = rcdev;
+
+	result = rc_register_device(rcdev);
+
+	if (!result)
+		return 0;
+serial_cleanup:
+	serial_ir_exit();
+	return result;
 }
 
-static void __exit lirc_serial_exit_module(void)
+static void __exit serial_ir_exit_module(void)
 {
-	lirc_unregister_driver(driver.minor);
-	lirc_serial_exit();
-	pr_debug("cleaned up module\n");
+	rc_unregister_device(serial_ir.rcdev);
+	serial_ir_exit();
 }
 
-
-module_init(lirc_serial_init_module);
-module_exit(lirc_serial_exit_module);
+module_init(serial_ir_init_module);
+module_exit(serial_ir_exit_module);
 
 MODULE_DESCRIPTION("Infra-red receiver driver for serial ports.");
-MODULE_AUTHOR("Ralph Metzler, Trent Piepho, Ben Pfaff, "
-	      "Christoph Bartelmus, Andrei Tanas");
+MODULE_AUTHOR("Ralph Metzler, Trent Piepho, Ben Pfaff, Christoph Bartelmus, Andrei Tanas");
 MODULE_LICENSE("GPL");
 
-module_param(type, int, S_IRUGO);
-MODULE_PARM_DESC(type, "Hardware type (0 = home-brew, 1 = IRdeo,"
-		 " 2 = IRdeo Remote, 3 = AnimaX, 4 = IgorPlug,"
-		 " 5 = NSLU2 RX:CTS2/TX:GreenLED)");
+module_param(type, int, 0444);
+MODULE_PARM_DESC(type, "Hardware type (0 = home-brew, 1 = IRdeo, 2 = IRdeo Remote, 3 = AnimaX, 4 = IgorPlug");
 
-module_param(io, int, S_IRUGO);
+module_param(io, int, 0444);
 MODULE_PARM_DESC(io, "I/O address base (0x3f8 or 0x2f8)");
 
 /* some architectures (e.g. intel xscale) have memory mapped registers */
-module_param(iommap, bool, S_IRUGO);
-MODULE_PARM_DESC(iommap, "physical base for memory mapped I/O"
-		" (0 = no memory mapped io)");
+module_param(iommap, bool, 0444);
+MODULE_PARM_DESC(iommap, "physical base for memory mapped I/O (0 = no memory mapped io)");
 
 /*
  * some architectures (e.g. intel xscale) align the 8bit serial registers
  * on 32bit word boundaries.
  * See linux-kernel/drivers/tty/serial/8250/8250.c serial_in()/out()
  */
-module_param(ioshift, int, S_IRUGO);
+module_param(ioshift, int, 0444);
 MODULE_PARM_DESC(ioshift, "shift I/O register offset (0 = no shift)");
 
-module_param(irq, int, S_IRUGO);
+module_param(irq, int, 0444);
 MODULE_PARM_DESC(irq, "Interrupt (4 or 3)");
 
-module_param(share_irq, bool, S_IRUGO);
+module_param(share_irq, bool, 0444);
 MODULE_PARM_DESC(share_irq, "Share interrupts (0 = off, 1 = on)");
 
-module_param(sense, int, S_IRUGO);
-MODULE_PARM_DESC(sense, "Override autodetection of IR receiver circuit"
-		 " (0 = active high, 1 = active low )");
+module_param(sense, int, 0444);
+MODULE_PARM_DESC(sense, "Override autodetection of IR receiver circuit (0 = active high, 1 = active low )");
 
-#ifdef CONFIG_LIRC_SERIAL_TRANSMITTER
-module_param(txsense, bool, S_IRUGO);
-MODULE_PARM_DESC(txsense, "Sense of transmitter circuit"
-		 " (0 = active high, 1 = active low )");
+#ifdef CONFIG_IR_SERIAL_TRANSMITTER
+module_param(txsense, bool, 0444);
+MODULE_PARM_DESC(txsense, "Sense of transmitter circuit (0 = active high, 1 = active low )");
 #endif
 
-module_param(softcarrier, bool, S_IRUGO);
+module_param(softcarrier, bool, 0444);
 MODULE_PARM_DESC(softcarrier, "Software carrier (0 = off, 1 = on, default on)");
-- 
2.7.4

