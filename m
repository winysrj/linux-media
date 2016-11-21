Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:53535 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753891AbcKUVzz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Nov 2016 16:55:55 -0500
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH v4 2/3] [media] lirc_serial: use precision ktime rather than guessing
Date: Mon, 21 Nov 2016 21:55:52 +0000
Message-Id: <1479765353-4098-2-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This makes transmission more reliable and the code much cleaner.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/staging/media/lirc/lirc_serial.c | 286 +++++++------------------------
 1 file changed, 65 insertions(+), 221 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_serial.c b/drivers/staging/media/lirc/lirc_serial.c
index 05a8a47..7d1c2af 100644
--- a/drivers/staging/media/lirc/lirc_serial.c
+++ b/drivers/staging/media/lirc/lirc_serial.c
@@ -21,29 +21,6 @@
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
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/module.h>
@@ -64,8 +41,8 @@ struct serial_ir_hw {
 	u8 off;
 	unsigned set_send_carrier:1;
 	unsigned set_duty_cycle:1;
-	long (*send_pulse)(unsigned long length);
-	void (*send_space)(long length);
+	void (*send_pulse)(unsigned int length, ktime_t edge);
+	void (*send_space)(void);
 	spinlock_t lock;
 };
 
@@ -87,11 +64,11 @@ static int sense = -1;	/* -1 = auto, 0 = active high, 1 = active low */
 static bool txsense;	/* 0 = active high, 1 = active low */
 
 /* forward declarations */
-static long send_pulse_irdeo(unsigned long length);
-static void send_space_irdeo(long length);
+static void send_pulse_irdeo(unsigned int length, ktime_t edge);
+static void send_space_irdeo(void);
 #ifdef CONFIG_IR_SERIAL_TRANSMITTER
-static long send_pulse_homebrew(unsigned long length);
-static void send_space_homebrew(long length);
+static void send_pulse_homebrew(unsigned int length, ktime_t edge);
+static void send_space_homebrew(void);
 #endif
 
 static struct serial_ir_hw hardware[] = {
@@ -137,8 +114,6 @@ static struct serial_ir_hw hardware[] = {
 		.signal_pin_change = UART_MSR_DDCD,
 		.on  = 0,
 		.off = (UART_MCR_RTS | UART_MCR_DTR | UART_MCR_OUT2),
-		.send_pulse = NULL,
-		.send_space = NULL,
 	},
 
 	[IR_IGOR] = {
@@ -166,51 +141,11 @@ struct serial_ir {
 	unsigned int freq;
 	unsigned int duty_cycle;
 
-	unsigned long period;
-	unsigned long pulse_width, space_width;
+	unsigned int pulse_width, space_width;
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
@@ -247,96 +182,21 @@ static void off(void)
 		soutp(UART_MCR, hardware[type].off);
 }
 
-#ifndef MAX_UDELAY_MS
-#define MAX_UDELAY_US 5000
-#else
-#define MAX_UDELAY_US (MAX_UDELAY_MS*1000)
-#endif
-
-static void safe_udelay(unsigned long usecs)
+static void init_timing_params(unsigned int new_duty_cycle,
+			       unsigned int new_freq)
 {
-	while (usecs > MAX_UDELAY_US) {
-		udelay(MAX_UDELAY_US);
-		usecs -= MAX_UDELAY_US;
-	}
-	udelay(usecs);
-}
-
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
-		unsigned int new_freq)
-{
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
+static void send_pulse_irdeo(unsigned int length, ktime_t target)
 {
-	long rawbits, ret;
+	long rawbits;
 	int i;
 	unsigned char output;
 	unsigned char chunk, shifted;
@@ -365,84 +225,53 @@ static long send_pulse_irdeo(unsigned long length)
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
+static void send_pulse_homebrew_softcarrier(unsigned int length, ktime_t edge)
 {
-	int flag;
-	unsigned long actual, target, d;
-
-	length <<= 8;
+	ktime_t now, target = ktime_add_us(edge, length);
+	/*
+	 * delta should never exceed 4 seconds and on m68k
+	 * ndelay(s64) does not compile; so use s32 rather than s64.
+	 */
+	s32 delta;
 
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
+		now = ktime_get();
+		off();
+		if (ktime_compare(now, target) >= 0)
+			break;
+		edge = ktime_add_ns(edge, serial_ir.space_width);
+		delta = ktime_to_ns(ktime_sub(edge, now));
+		if (delta > 0)
+			ndelay(delta);
 	}
-	return (actual-length) >> 8;
 }
 
-static long send_pulse_homebrew(unsigned long length)
+static void send_pulse_homebrew(unsigned int length, ktime_t edge)
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
 
@@ -746,7 +575,8 @@ static int serial_ir_tx(struct rc_dev *dev, unsigned int *txbuf,
 			unsigned int count)
 {
 	unsigned long flags;
-	long delta = 0;
+	ktime_t edge;
+	s64 delta;
 	int i;
 
 	spin_lock_irqsave(&hardware[type].lock, flags);
@@ -754,11 +584,23 @@ static int serial_ir_tx(struct rc_dev *dev, unsigned int *txbuf,
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
+		if (delta > 25) {
+			spin_unlock_irqrestore(&hardware[type].lock, flags);
+			usleep_range(delta - 25, delta + 25);
+			spin_lock_irqsave(&hardware[type].lock, flags);
+		}
+		else if (delta > 0)
+			udelay(delta);
 	}
 	off();
 	spin_unlock_irqrestore(&hardware[type].lock, flags);
@@ -767,7 +609,8 @@ static int serial_ir_tx(struct rc_dev *dev, unsigned int *txbuf,
 
 static int serial_ir_tx_duty_cycle(struct rc_dev *dev, u32 cycle)
 {
-	return init_timing_params(cycle, serial_ir.freq);
+	init_timing_params(cycle, serial_ir.freq);
+	return 0;
 }
 
 static int serial_ir_tx_carrier(struct rc_dev *dev, u32 carrier)
@@ -775,7 +618,8 @@ static int serial_ir_tx_carrier(struct rc_dev *dev, u32 carrier)
 	if (carrier > 500000 || carrier < 20000)
 		return -EINVAL;
 
-	return init_timing_params(serial_ir.duty_cycle, carrier);
+	init_timing_params(serial_ir.duty_cycle, carrier);
+	return 0;
 }
 
 static int serial_ir_suspend(struct platform_device *dev,
-- 
2.7.4

