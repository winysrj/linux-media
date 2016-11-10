Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:60367 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965218AbcKJTZs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Nov 2016 14:25:48 -0500
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH v2 2/2] serial_ir: use precision ktime rather than guessing
Date: Thu, 10 Nov 2016 19:25:46 +0000
Message-Id: <1478805946-11546-2-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This makes transmission more reliable and the code much cleaner.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/serial_ir.c | 260 +++++++++----------------------------------
 1 file changed, 54 insertions(+), 206 deletions(-)

diff --git a/drivers/media/rc/serial_ir.c b/drivers/media/rc/serial_ir.c
index 32db2b7..1d8b5dd 100644
--- a/drivers/media/rc/serial_ir.c
+++ b/drivers/media/rc/serial_ir.c
@@ -21,31 +21,6 @@
  *  GNU General Public License for more details.
  */
 
-/*
- * Steve's changes to improve transmission fidelity:
- *   - for systems with the rdtsc instruction and the clock counter, a
- *     send_pule that times the pulses directly using the counter.
- *     This means that the IR_SERIAL_TRANSMITTER_LATENCY fudge is
- *     not needed. Measurement shows very stable waveform, even where
- *     PCI activity slows the access to the UART, which trips up other
- *     versions.
- *   - For other system, non-integer-microsecond pulse/space lengths,
- *     done using fixed point binary. So, much more accurate carrier
- *     frequency.
- *   - fine tuned transmitter latency, taking advantage of fractional
- *     microseconds in previous change
- *   - Fixed bug in the way transmitter latency was accounted for by
- *     tuning the pulse lengths down - the send_pulse routine ignored
- *     this overhead as it timed the overall pulse length - so the
- *     pulse frequency was right but overall pulse length was too
- *     long. Fixed by accounting for latency on each pulse/space
- *     iteration.
- *
- * Steve Davies <steve@daviesfam.org>  July 2001
- */
-
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/interrupt.h>
@@ -66,8 +41,8 @@ struct serial_ir_hw {
 	u8 off;
 	unsigned set_send_carrier:1;
 	unsigned set_duty_cycle:1;
-	long (*send_pulse)(unsigned long length);
-	void (*send_space)(long length);
+	void (*send_pulse)(unsigned long length, ktime_t edge);
+	void (*send_space)(void);
 	spinlock_t lock;
 };
 
@@ -90,11 +65,11 @@ static int sense = -1;	/* -1 = auto, 0 = active high, 1 = active low */
 static bool txsense;	/* 0 = active high, 1 = active low */
 
 /* forward declarations */
-static long send_pulse_irdeo(unsigned long length);
-static void send_space_irdeo(long length);
+static void send_pulse_irdeo(unsigned long length, ktime_t edge);
+static void send_space_irdeo(void);
 #ifdef CONFIG_IR_SERIAL_TRANSMITTER
-static long send_pulse_homebrew(unsigned long length);
-static void send_space_homebrew(long length);
+static void send_pulse_homebrew(unsigned long length, ktime_t edge);
+static void send_space_homebrew(void);
 #endif
 
 static struct serial_ir_hw hardware[] = {
@@ -140,8 +115,6 @@ static struct serial_ir_hw hardware[] = {
 		.signal_pin_change = UART_MSR_DDCD,
 		.on  = 0,
 		.off = (UART_MCR_RTS | UART_MCR_DTR | UART_MCR_OUT2),
-		.send_pulse = NULL,
-		.send_space = NULL,
 	},
 
 	[IR_IGOR] = {
@@ -180,51 +153,11 @@ struct serial_ir {
 	unsigned int freq;
 	unsigned int duty_cycle;
 
-	unsigned long period;
 	unsigned long pulse_width, space_width;
 };
 
 static struct serial_ir serial_ir;
 
-#if defined(__i386__)
-/*
- * From:
- * Linux I/O port programming mini-HOWTO
- * Author: Riku Saikkonen <Riku.Saikkonen@hut.fi>
- * v, 28 December 1997
- *
- * [...]
- * Actually, a port I/O instruction on most ports in the 0-0x3ff range
- * takes almost exactly 1 microsecond, so if you're, for example, using
- * the parallel port directly, just do additional inb()s from that port
- * to delay.
- * [...]
- */
-/* transmitter latency 1.5625us 0x1.90 - this figure arrived at from
- * comment above plus trimming to match actual measured frequency.
- * This will be sensitive to cpu speed, though hopefully most of the 1.5us
- * is spent in the uart access.  Still - for reference test machine was a
- * 1.13GHz Athlon system - Steve
- */
-
-/*
- * changed from 400 to 450 as this works better on slower machines;
- * faster machines will use the rdtsc code anyway
- */
-#define IR_SERIAL_TRANSMITTER_LATENCY 450
-
-#else
-
-/* does anybody have information on other platforms ? */
-/* 256 = 1<<8 */
-#define IR_SERIAL_TRANSMITTER_LATENCY 256
-
-#endif	/* __i386__ */
-/*
- * FIXME: should we be using hrtimers instead of this
- * IR_SERIAL_TRANSMITTER_LATENCY nonsense?
- */
-
 /* fetch serial input packet (1 byte) from register offset */
 static u8 sinp(int offset)
 {
@@ -276,81 +209,21 @@ static void safe_udelay(unsigned long usecs)
 	udelay(usecs);
 }
 
-#ifdef USE_RDTSC
-/*
- * This is an overflow/precision juggle, complicated in that we can't
- * do long long divide in the kernel
- */
-
-/*
- * When we use the rdtsc instruction to measure clocks, we keep the
- * pulse and space widths as clock cycles.  As this is CPU speed
- * dependent, the widths must be calculated in init_port and ioctl
- * time
- */
-
-static int init_timing_params(unsigned int new_duty_cycle,
+static void init_timing_params(unsigned int new_duty_cycle,
 		unsigned int new_freq)
 {
-	__u64 loops_per_sec, work;
-
 	serial_ir.duty_cycle = new_duty_cycle;
 	serial_ir.freq = new_freq;
 
-	loops_per_sec = __this_cpu_read(cpu.info.loops_per_jiffy);
-	loops_per_sec *= HZ;
-
-	/* How many clocks in a microsecond?, avoiding long long divide */
-	work = loops_per_sec;
-	work *= 4295;  /* 4295 = 2^32 / 1e6 */
-
-	/*
-	 * Carrier period in clocks, approach good up to 32GHz clock,
-	 * gets carrier frequency within 8Hz
-	 */
-	serial_ir.period = loops_per_sec >> 3;
-	serial_ir.pperiod /= (freq >> 3);
-
-	/* Derive pulse and space from the period */
-	serial_ir.ppulse_width = serial_ir.period * serial.ir.duty_cycle / 100;
-	serial_ir.pspace_width = serial_ir.period - serial_ir.pulse_width;
-	pr_debug("in init_timing_params, freq=%d, duty_cycle=%d, clk/jiffy=%ld, pulse=%ld, space=%ld, conv_us_to_clocks=%ld\n",
-		 freq, duty_cycle, __this_cpu_read(cpu_info.loops_per_jiffy),
-		 pulse_width, space_width, conv_us_to_clocks);
-	return 0;
-}
-#else /* ! USE_RDTSC */
-static int init_timing_params(unsigned int new_duty_cycle,
-		unsigned int new_freq)
-{
-/*
- * period, pulse/space width are kept with 8 binary places -
- * IE multiplied by 256.
- */
-	if (256 * 1000000L / new_freq * new_duty_cycle / 100 <=
-	    IR_SERIAL_TRANSMITTER_LATENCY)
-		return -EINVAL;
-	if (256 * 1000000L / new_freq * (100 - new_duty_cycle) / 100 <=
-	    IR_SERIAL_TRANSMITTER_LATENCY)
-		return -EINVAL;
-	serial_ir.duty_cycle = new_duty_cycle;
-	serial_ir.freq = new_freq;
-	serial_ir.period = 256 * 1000000L / serial_ir.freq;
-	serial_ir.pulse_width = serial_ir.period * serial_ir.duty_cycle / 100;
-	serial_ir.space_width = serial_ir.period - serial_ir.pulse_width;
-	pr_debug("in init_timing_params, freq=%d pulse=%ld, space=%ld\n",
-				serial_ir.freq, serial_ir.pulse_width,
-				serial_ir.space_width);
-	return 0;
+	serial_ir.pulse_width = DIV_ROUND_CLOSEST(
+		new_duty_cycle * NSEC_PER_SEC, new_freq * 100l);
+	serial_ir.space_width = DIV_ROUND_CLOSEST(
+		(100l - new_duty_cycle) * NSEC_PER_SEC, new_freq * 100l);
 }
-#endif /* USE_RDTSC */
 
-
-/* return value: space length delta */
-
-static long send_pulse_irdeo(unsigned long length)
+static void send_pulse_irdeo(unsigned long length, ktime_t target)
 {
-	long rawbits, ret;
+	long rawbits;
 	int i;
 	unsigned char output;
 	unsigned char chunk, shifted;
@@ -379,84 +252,49 @@ static long send_pulse_irdeo(unsigned long length)
 		while (!(sinp(UART_LSR) & UART_LSR_TEMT))
 			;
 	}
-
-	if (i == 0)
-		ret = (-rawbits) * 10000 / 1152;
-	else
-		ret = (3 - i) * 3 * 10000 / 1152 + (-rawbits) * 10000 / 1152;
-
-	return ret;
 }
 
-/* Version using udelay() */
-
-/*
- * here we use fixed point arithmetic, with 8
- * fractional bits.  that gets us within 0.1% or so of the right average
- * frequency, albeit with some jitter in pulse length - Steve
- *
- * This should use ndelay instead.
- */
-
-/* To match 8 fractional bits used for pulse/space length */
-
-static void send_space_irdeo(long length)
+static void send_space_irdeo(void)
 {
-	if (length <= 0)
-		return;
-
-	safe_udelay(length);
 }
 
 #ifdef CONFIG_IR_SERIAL_TRANSMITTER
-static long send_pulse_homebrew_softcarrier(unsigned long length)
+static void send_pulse_homebrew_softcarrier(unsigned long length, ktime_t edge)
 {
-	int flag;
-	unsigned long actual, target, d;
+	ktime_t now, target = ktime_add_us(edge, length);
+	s64 delta;
 
-	length <<= 8;
-
-	actual = 0; target = 0; flag = 0;
-	while (actual < length) {
-		if (flag) {
-			off();
-			target += serial_ir.space_width;
-		} else {
-			on();
-			target += serial_ir.pulse_width;
-		}
-		d = (target - actual -
-		     IR_SERIAL_TRANSMITTER_LATENCY + 128) >> 8;
-		/*
-		 * Note - we've checked in ioctl that the pulse/space
-		 * widths are big enough so that d is > 0
-		 */
-		udelay(d);
-		actual += (d << 8) + IR_SERIAL_TRANSMITTER_LATENCY;
-		flag = !flag;
+	for (;;) {
+		now = ktime_get();
+		if (ktime_compare(now, target) >= 0)
+			break;
+		on();
+		edge = ktime_add_ns(edge, serial_ir.pulse_width);
+		delta = ktime_to_ns(ktime_sub(edge, now));
+		if (delta > 0)
+			ndelay(delta);
+		off();
+		edge = ktime_add_ns(edge, serial_ir.space_width);
+		now = ktime_get();
+		if (ktime_compare(now, target) >= 0)
+			break;
+		delta = ktime_to_ns(ktime_sub(edge, now));
+		if (delta > 0)
+			ndelay(delta);
 	}
-	return (actual-length) >> 8;
 }
 
-static long send_pulse_homebrew(unsigned long length)
+static void send_pulse_homebrew(unsigned long length, ktime_t edge)
 {
-	if (length <= 0)
-		return 0;
-
 	if (softcarrier)
-		return send_pulse_homebrew_softcarrier(length);
-
-	on();
-	safe_udelay(length);
-	return 0;
+		send_pulse_homebrew_softcarrier(length, edge);
+	else
+		on();
 }
 
-static void send_space_homebrew(long length)
+static void send_space_homebrew(void)
 {
 	off();
-	if (length <= 0)
-		return;
-	safe_udelay(length);
 }
 #endif
 
@@ -775,7 +613,8 @@ static int serial_ir_tx(struct rc_dev *dev, unsigned int *txbuf,
 							unsigned int count)
 {
 	unsigned long flags;
-	long delta = 0;
+	ktime_t edge;
+	s64 delta;
 	int i;
 
 	spin_lock_irqsave(&hardware[type].lock, flags);
@@ -783,11 +622,18 @@ static int serial_ir_tx(struct rc_dev *dev, unsigned int *txbuf,
 		/* DTR, RTS down */
 		on();
 	}
+
+	edge = ktime_get();
 	for (i = 0; i < count; i++) {
 		if (i%2)
-			hardware[type].send_space(txbuf[i] - delta);
+			hardware[type].send_space();
 		else
-			delta = hardware[type].send_pulse(txbuf[i]);
+			hardware[type].send_pulse(txbuf[i], edge);
+
+		edge = ktime_add_us(edge, txbuf[i]);
+		delta = ktime_us_delta(edge, ktime_get());
+		if (delta > 0)
+			safe_udelay(delta);
 	}
 	off();
 	spin_unlock_irqrestore(&hardware[type].lock, flags);
@@ -796,7 +642,8 @@ static int serial_ir_tx(struct rc_dev *dev, unsigned int *txbuf,
 
 static int serial_ir_tx_duty_cycle(struct rc_dev *dev, u32 cycle)
 {
-	return init_timing_params(cycle, serial_ir.freq);
+	init_timing_params(cycle, serial_ir.freq);
+	return 0;
 }
 
 static int serial_ir_tx_carrier(struct rc_dev *dev, u32 carrier)
@@ -804,7 +651,8 @@ static int serial_ir_tx_carrier(struct rc_dev *dev, u32 carrier)
 	if (carrier > 500000 || carrier < 20000)
 		return -EINVAL;
 
-	return init_timing_params(serial_ir.duty_cycle, carrier);
+	init_timing_params(serial_ir.duty_cycle, carrier);
+	return 0;
 }
 
 static int serial_ir_suspend(struct platform_device *dev,
-- 
2.7.4

