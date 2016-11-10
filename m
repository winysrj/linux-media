Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:49673 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965208AbcKJTZt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Nov 2016 14:25:49 -0500
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH v2 1/2] [media] serial_ir: port lirc_serial to rc-core
Date: Thu, 10 Nov 2016 19:25:45 +0000
Message-Id: <1478805946-11546-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tested with a homebrew serial ir.

Signed-off-by: Sean Young <sean@mess.org>
---
 MAINTAINERS                              |    6 +
 drivers/media/rc/Kconfig                 |   17 +
 drivers/media/rc/Makefile                |    1 +
 drivers/media/rc/serial_ir.c             | 1025 +++++++++++++++++++++++++++
 drivers/staging/media/lirc/Kconfig       |   13 -
 drivers/staging/media/lirc/Makefile      |    1 -
 drivers/staging/media/lirc/lirc_serial.c | 1130 ------------------------------
 7 files changed, 1049 insertions(+), 1144 deletions(-)
 create mode 100644 drivers/media/rc/serial_ir.c
 delete mode 100644 drivers/staging/media/lirc/lirc_serial.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 93e9f42..cd8fd50 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10604,6 +10604,12 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/serial/
 F:	drivers/tty/serial/
 
+SERIAL IR RECEIVER
+M:	Sean Young <sean@mess.org>
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	drivers/media/rc/serial_ir.c
+
 STI CEC DRIVER
 M:	Benjamin Gaignard <benjamin.gaignard@linaro.org>
 L:	kernel@stlinux.com
diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index 370e16e..629e8ca 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -389,4 +389,21 @@ config IR_SUNXI
 	   To compile this driver as a module, choose M here: the module will
 	   be called sunxi-ir.
 
+config IR_SERIAL
+	tristate "Homebrew Serial Port Receiver"
+	depends on RC_CORE
+	---help---
+	   Say Y if you want to use Homebrew Serial Port Receivers and
+	   Transceivers.
+
+	   To compile this driver as a module, choose M here: the module will
+	   be called serial-ir.
+
+config IR_SERIAL_TRANSMITTER
+	bool "Serial Port Transmitter"
+	default y
+	depends on IR_SERIAL
+	---help---
+	   Serial Port Transmitter support
+
 endif #RC_DEVICES
diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
index 379a5c0..3a984ee 100644
--- a/drivers/media/rc/Makefile
+++ b/drivers/media/rc/Makefile
@@ -37,3 +37,4 @@ obj-$(CONFIG_IR_TTUSBIR) += ttusbir.o
 obj-$(CONFIG_RC_ST) += st_rc.o
 obj-$(CONFIG_IR_SUNXI) += sunxi-cir.o
 obj-$(CONFIG_IR_IMG) += img-ir/
+obj-$(CONFIG_IR_SERIAL) += serial_ir.o
diff --git a/drivers/media/rc/serial_ir.c b/drivers/media/rc/serial_ir.c
new file mode 100644
index 0000000..32db2b7
--- /dev/null
+++ b/drivers/media/rc/serial_ir.c
@@ -0,0 +1,1025 @@
+/*
+ * serial-ir.c
+ *
+ * serial-ir - Device driver that records pulse- and pause-lengths
+ *	       (space-lengths) between DDCD event on a serial port.
+ *
+ * Copyright (C) 1996,97 Ralph Metzler <rjkm@thp.uni-koeln.de>
+ * Copyright (C) 1998 Trent Piepho <xyzzy@u.washington.edu>
+ * Copyright (C) 1998 Ben Pfaff <blp@gnu.org>
+ * Copyright (C) 1999 Christoph Bartelmus <lirc@bartelmus.de>
+ * Copyright (C) 2007 Andrei Tanas <andrei@tanas.ca> (suspend/resume support)
+ * Copyright (C) 2016 Sean Young <sean@mess.org> (port to rc-core)
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ */
+
+/*
+ * Steve's changes to improve transmission fidelity:
+ *   - for systems with the rdtsc instruction and the clock counter, a
+ *     send_pule that times the pulses directly using the counter.
+ *     This means that the IR_SERIAL_TRANSMITTER_LATENCY fudge is
+ *     not needed. Measurement shows very stable waveform, even where
+ *     PCI activity slows the access to the UART, which trips up other
+ *     versions.
+ *   - For other system, non-integer-microsecond pulse/space lengths,
+ *     done using fixed point binary. So, much more accurate carrier
+ *     frequency.
+ *   - fine tuned transmitter latency, taking advantage of fractional
+ *     microseconds in previous change
+ *   - Fixed bug in the way transmitter latency was accounted for by
+ *     tuning the pulse lengths down - the send_pulse routine ignored
+ *     this overhead as it timed the overall pulse length - so the
+ *     pulse frequency was right but overall pulse length was too
+ *     long. Fixed by accounting for latency on each pulse/space
+ *     iteration.
+ *
+ * Steve Davies <steve@daviesfam.org>  July 2001
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/serial_reg.h>
+#include <linux/types.h>
+#include <linux/delay.h>
+#include <linux/platform_device.h>
+#include <linux/spinlock.h>
+#include <media/rc-core.h>
+
+#define DRIVER_NAME "serial_ir"
+
+struct serial_ir_hw {
+	int signal_pin;
+	int signal_pin_change;
+	u8 on;
+	u8 off;
+	unsigned set_send_carrier:1;
+	unsigned set_duty_cycle:1;
+	long (*send_pulse)(unsigned long length);
+	void (*send_space)(long length);
+	spinlock_t lock;
+};
+
+#define IR_HOMEBREW	0
+#define IR_IRDEO	1
+#define IR_IRDEO_REMOTE	2
+#define IR_ANIMAX	3
+#define IR_IGOR		4
+#define IR_NSLU2	5
+
+/*** module parameters ***/
+static int type;
+static int io;
+static int irq;
+static bool iommap;
+static int ioshift;
+static bool softcarrier = true;
+static bool share_irq;
+static int sense = -1;	/* -1 = auto, 0 = active high, 1 = active low */
+static bool txsense;	/* 0 = active high, 1 = active low */
+
+/* forward declarations */
+static long send_pulse_irdeo(unsigned long length);
+static void send_space_irdeo(long length);
+#ifdef CONFIG_IR_SERIAL_TRANSMITTER
+static long send_pulse_homebrew(unsigned long length);
+static void send_space_homebrew(long length);
+#endif
+
+static struct serial_ir_hw hardware[] = {
+	[IR_HOMEBREW] = {
+		.lock = __SPIN_LOCK_UNLOCKED(hardware[IR_HOMEBREW].lock),
+		.signal_pin	   = UART_MSR_DCD,
+		.signal_pin_change = UART_MSR_DDCD,
+		.on  = (UART_MCR_RTS | UART_MCR_OUT2 | UART_MCR_DTR),
+		.off = (UART_MCR_RTS | UART_MCR_OUT2),
+#ifdef CONFIG_IR_SERIAL_TRANSMITTER
+		.send_pulse = send_pulse_homebrew,
+		.send_space = send_space_homebrew,
+		.set_send_carrier = true,
+		.set_duty_cycle = true,
+#endif
+	},
+
+	[IR_IRDEO] = {
+		.lock = __SPIN_LOCK_UNLOCKED(hardware[IR_IRDEO].lock),
+		.signal_pin	   = UART_MSR_DSR,
+		.signal_pin_change = UART_MSR_DDSR,
+		.on  = UART_MCR_OUT2,
+		.off = (UART_MCR_RTS | UART_MCR_DTR | UART_MCR_OUT2),
+		.send_pulse  = send_pulse_irdeo,
+		.send_space  = send_space_irdeo,
+		.set_duty_cycle = true,
+	},
+
+	[IR_IRDEO_REMOTE] = {
+		.lock = __SPIN_LOCK_UNLOCKED(hardware[IR_IRDEO_REMOTE].lock),
+		.signal_pin	   = UART_MSR_DSR,
+		.signal_pin_change = UART_MSR_DDSR,
+		.on  = (UART_MCR_RTS | UART_MCR_DTR | UART_MCR_OUT2),
+		.off = (UART_MCR_RTS | UART_MCR_DTR | UART_MCR_OUT2),
+		.send_pulse  = send_pulse_irdeo,
+		.send_space  = send_space_irdeo,
+		.set_duty_cycle = true,
+	},
+
+	[IR_ANIMAX] = {
+		.lock = __SPIN_LOCK_UNLOCKED(hardware[IR_ANIMAX].lock),
+		.signal_pin	   = UART_MSR_DCD,
+		.signal_pin_change = UART_MSR_DDCD,
+		.on  = 0,
+		.off = (UART_MCR_RTS | UART_MCR_DTR | UART_MCR_OUT2),
+		.send_pulse = NULL,
+		.send_space = NULL,
+	},
+
+	[IR_IGOR] = {
+		.lock = __SPIN_LOCK_UNLOCKED(hardware[IR_IGOR].lock),
+		.signal_pin	   = UART_MSR_DSR,
+		.signal_pin_change = UART_MSR_DDSR,
+		.on  = (UART_MCR_RTS | UART_MCR_OUT2 | UART_MCR_DTR),
+		.off = (UART_MCR_RTS | UART_MCR_OUT2),
+#ifdef CONFIG_IR_SERIAL_TRANSMITTER
+		.send_pulse = send_pulse_homebrew,
+		.send_space = send_space_homebrew,
+		.set_send_carrier = true,
+		.set_duty_cycle = true,
+#endif
+	},
+};
+
+#define RS_ISR_PASS_LIMIT 256
+
+/*
+ * A long pulse code from a remote might take up to 300 bytes.	The
+ * daemon should read the bytes as soon as they are generated, so take
+ * the number of keys you think you can push before the daemon runs
+ * and multiply by 300.  The driver will warn you if you overrun this
+ * buffer.  If you have a slow computer or non-busmastering IDE disks,
+ * maybe you will need to increase this.
+ */
+
+/* This MUST be a power of two!  It has to be larger than 1 as well. */
+
+struct serial_ir {
+	ktime_t lastkt;
+	struct rc_dev *rcdev;
+	struct platform_device *pdev;
+
+	unsigned int freq;
+	unsigned int duty_cycle;
+
+	unsigned long period;
+	unsigned long pulse_width, space_width;
+};
+
+static struct serial_ir serial_ir;
+
+#if defined(__i386__)
+/*
+ * From:
+ * Linux I/O port programming mini-HOWTO
+ * Author: Riku Saikkonen <Riku.Saikkonen@hut.fi>
+ * v, 28 December 1997
+ *
+ * [...]
+ * Actually, a port I/O instruction on most ports in the 0-0x3ff range
+ * takes almost exactly 1 microsecond, so if you're, for example, using
+ * the parallel port directly, just do additional inb()s from that port
+ * to delay.
+ * [...]
+ */
+/* transmitter latency 1.5625us 0x1.90 - this figure arrived at from
+ * comment above plus trimming to match actual measured frequency.
+ * This will be sensitive to cpu speed, though hopefully most of the 1.5us
+ * is spent in the uart access.  Still - for reference test machine was a
+ * 1.13GHz Athlon system - Steve
+ */
+
+/*
+ * changed from 400 to 450 as this works better on slower machines;
+ * faster machines will use the rdtsc code anyway
+ */
+#define IR_SERIAL_TRANSMITTER_LATENCY 450
+
+#else
+
+/* does anybody have information on other platforms ? */
+/* 256 = 1<<8 */
+#define IR_SERIAL_TRANSMITTER_LATENCY 256
+
+#endif	/* __i386__ */
+/*
+ * FIXME: should we be using hrtimers instead of this
+ * IR_SERIAL_TRANSMITTER_LATENCY nonsense?
+ */
+
+/* fetch serial input packet (1 byte) from register offset */
+static u8 sinp(int offset)
+{
+	if (iommap)
+		/* the register is memory-mapped */
+		offset <<= ioshift;
+
+	return inb(io + offset);
+}
+
+/* write serial output packet (1 byte) of value to register offset */
+static void soutp(int offset, u8 value)
+{
+	if (iommap)
+		/* the register is memory-mapped */
+		offset <<= ioshift;
+
+	outb(value, io + offset);
+}
+
+static void on(void)
+{
+	if (txsense)
+		soutp(UART_MCR, hardware[type].off);
+	else
+		soutp(UART_MCR, hardware[type].on);
+}
+
+static void off(void)
+{
+	if (txsense)
+		soutp(UART_MCR, hardware[type].on);
+	else
+		soutp(UART_MCR, hardware[type].off);
+}
+
+#ifndef MAX_UDELAY_MS
+#define MAX_UDELAY_US 5000
+#else
+#define MAX_UDELAY_US (MAX_UDELAY_MS*1000)
+#endif
+
+static void safe_udelay(unsigned long usecs)
+{
+	while (usecs > MAX_UDELAY_US) {
+		udelay(MAX_UDELAY_US);
+		usecs -= MAX_UDELAY_US;
+	}
+	udelay(usecs);
+}
+
+#ifdef USE_RDTSC
+/*
+ * This is an overflow/precision juggle, complicated in that we can't
+ * do long long divide in the kernel
+ */
+
+/*
+ * When we use the rdtsc instruction to measure clocks, we keep the
+ * pulse and space widths as clock cycles.  As this is CPU speed
+ * dependent, the widths must be calculated in init_port and ioctl
+ * time
+ */
+
+static int init_timing_params(unsigned int new_duty_cycle,
+		unsigned int new_freq)
+{
+	__u64 loops_per_sec, work;
+
+	serial_ir.duty_cycle = new_duty_cycle;
+	serial_ir.freq = new_freq;
+
+	loops_per_sec = __this_cpu_read(cpu.info.loops_per_jiffy);
+	loops_per_sec *= HZ;
+
+	/* How many clocks in a microsecond?, avoiding long long divide */
+	work = loops_per_sec;
+	work *= 4295;  /* 4295 = 2^32 / 1e6 */
+
+	/*
+	 * Carrier period in clocks, approach good up to 32GHz clock,
+	 * gets carrier frequency within 8Hz
+	 */
+	serial_ir.period = loops_per_sec >> 3;
+	serial_ir.pperiod /= (freq >> 3);
+
+	/* Derive pulse and space from the period */
+	serial_ir.ppulse_width = serial_ir.period * serial.ir.duty_cycle / 100;
+	serial_ir.pspace_width = serial_ir.period - serial_ir.pulse_width;
+	pr_debug("in init_timing_params, freq=%d, duty_cycle=%d, clk/jiffy=%ld, pulse=%ld, space=%ld, conv_us_to_clocks=%ld\n",
+		 freq, duty_cycle, __this_cpu_read(cpu_info.loops_per_jiffy),
+		 pulse_width, space_width, conv_us_to_clocks);
+	return 0;
+}
+#else /* ! USE_RDTSC */
+static int init_timing_params(unsigned int new_duty_cycle,
+		unsigned int new_freq)
+{
+/*
+ * period, pulse/space width are kept with 8 binary places -
+ * IE multiplied by 256.
+ */
+	if (256 * 1000000L / new_freq * new_duty_cycle / 100 <=
+	    IR_SERIAL_TRANSMITTER_LATENCY)
+		return -EINVAL;
+	if (256 * 1000000L / new_freq * (100 - new_duty_cycle) / 100 <=
+	    IR_SERIAL_TRANSMITTER_LATENCY)
+		return -EINVAL;
+	serial_ir.duty_cycle = new_duty_cycle;
+	serial_ir.freq = new_freq;
+	serial_ir.period = 256 * 1000000L / serial_ir.freq;
+	serial_ir.pulse_width = serial_ir.period * serial_ir.duty_cycle / 100;
+	serial_ir.space_width = serial_ir.period - serial_ir.pulse_width;
+	pr_debug("in init_timing_params, freq=%d pulse=%ld, space=%ld\n",
+				serial_ir.freq, serial_ir.pulse_width,
+				serial_ir.space_width);
+	return 0;
+}
+#endif /* USE_RDTSC */
+
+
+/* return value: space length delta */
+
+static long send_pulse_irdeo(unsigned long length)
+{
+	long rawbits, ret;
+	int i;
+	unsigned char output;
+	unsigned char chunk, shifted;
+
+	/* how many bits have to be sent ? */
+	rawbits = length * 1152 / 10000;
+	if (serial_ir.duty_cycle > 50)
+		chunk = 3;
+	else
+		chunk = 1;
+	for (i = 0, output = 0x7f; rawbits > 0; rawbits -= 3) {
+		shifted = chunk << (i * 3);
+		shifted >>= 1;
+		output &= (~shifted);
+		i++;
+		if (i == 3) {
+			soutp(UART_TX, output);
+			while (!(sinp(UART_LSR) & UART_LSR_THRE))
+				;
+			output = 0x7f;
+			i = 0;
+		}
+	}
+	if (i != 0) {
+		soutp(UART_TX, output);
+		while (!(sinp(UART_LSR) & UART_LSR_TEMT))
+			;
+	}
+
+	if (i == 0)
+		ret = (-rawbits) * 10000 / 1152;
+	else
+		ret = (3 - i) * 3 * 10000 / 1152 + (-rawbits) * 10000 / 1152;
+
+	return ret;
+}
+
+/* Version using udelay() */
+
+/*
+ * here we use fixed point arithmetic, with 8
+ * fractional bits.  that gets us within 0.1% or so of the right average
+ * frequency, albeit with some jitter in pulse length - Steve
+ *
+ * This should use ndelay instead.
+ */
+
+/* To match 8 fractional bits used for pulse/space length */
+
+static void send_space_irdeo(long length)
+{
+	if (length <= 0)
+		return;
+
+	safe_udelay(length);
+}
+
+#ifdef CONFIG_IR_SERIAL_TRANSMITTER
+static long send_pulse_homebrew_softcarrier(unsigned long length)
+{
+	int flag;
+	unsigned long actual, target, d;
+
+	length <<= 8;
+
+	actual = 0; target = 0; flag = 0;
+	while (actual < length) {
+		if (flag) {
+			off();
+			target += serial_ir.space_width;
+		} else {
+			on();
+			target += serial_ir.pulse_width;
+		}
+		d = (target - actual -
+		     IR_SERIAL_TRANSMITTER_LATENCY + 128) >> 8;
+		/*
+		 * Note - we've checked in ioctl that the pulse/space
+		 * widths are big enough so that d is > 0
+		 */
+		udelay(d);
+		actual += (d << 8) + IR_SERIAL_TRANSMITTER_LATENCY;
+		flag = !flag;
+	}
+	return (actual-length) >> 8;
+}
+
+static long send_pulse_homebrew(unsigned long length)
+{
+	if (length <= 0)
+		return 0;
+
+	if (softcarrier)
+		return send_pulse_homebrew_softcarrier(length);
+
+	on();
+	safe_udelay(length);
+	return 0;
+}
+
+static void send_space_homebrew(long length)
+{
+	off();
+	if (length <= 0)
+		return;
+	safe_udelay(length);
+}
+#endif
+
+static void frbwrite(unsigned int l, bool is_pulse)
+{
+	/* simple noise filter */
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
+			ptr = 0;
+			pulse = 0;
+		}
+		return;
+	}
+	if (!is_pulse) {
+		if (ptr == 0) {
+			if (l > 20000000) {
+				space = l;
+				ptr++;
+				return;
+			}
+		} else {
+			if (l > 20000000) {
+				space += pulse;
+				if (space > IR_MAX_DURATION)
+					space = IR_MAX_DURATION;
+				space += l;
+				if (space > IR_MAX_DURATION)
+					space = IR_MAX_DURATION;
+				pulse = 0;
+				return;
+			}
+
+			ev.duration = space;
+			ev.pulse = false;
+			ir_raw_event_store_with_filter(serial_ir.rcdev, &ev);
+			ev.duration = pulse;
+			ev.pulse = true;
+			ir_raw_event_store_with_filter(serial_ir.rcdev, &ev);
+			ptr = 0;
+			pulse = 0;
+		}
+	}
+
+	ev.duration = l;
+	ev.pulse = is_pulse;
+	ir_raw_event_store_with_filter(serial_ir.rcdev, &ev);
+}
+
+static irqreturn_t serial_ir_irq_handler(int i, void *blah)
+{
+	ktime_t kt;
+	int counter, dcd;
+	u8 status;
+	ktime_t delkt;
+	unsigned int data;
+	static int last_dcd = -1;
+
+	if ((sinp(UART_IIR) & UART_IIR_NO_INT)) {
+		/* not our interrupt */
+		return IRQ_NONE;
+	}
+
+	counter = 0;
+	do {
+		counter++;
+		status = sinp(UART_MSR);
+		if (counter > RS_ISR_PASS_LIMIT) {
+			dev_err(&serial_ir.pdev->dev, "Trapped in interrupt");
+			break;
+		}
+		if ((status & hardware[type].signal_pin_change)
+		    && sense != -1) {
+			/* get current time */
+			kt = ktime_get();
+
+			/*
+			 * If PULSE_BIT is set a pulse has been
+			 * received, otherwise a space has been
+			 * received.  The driver needs to know if your
+			 * receiver is active high or active low, or
+			 * the space/pulse sense could be
+			 * inverted. The bits denoted by PULSE_MASK are
+			 * the length in microseconds. Lengths greater
+			 * than or equal to 16 seconds are clamped to
+			 * PULSE_MASK.	All other bits are unused.
+			 * This is a much simpler interface for user
+			 * programs, as well as eliminating "out of
+			 * phase" errors with space/pulse
+			 * autodetection.
+			 */
+
+			/* calc time since last interrupt in microseconds */
+			dcd = (status & hardware[type].signal_pin) ? 1 : 0;
+
+			if (dcd == last_dcd) {
+				dev_err(&serial_ir.pdev->dev,
+					"ignoring spike: %d %d %lldns %lldns\n",
+					dcd, sense, ktime_to_ns(kt),
+					ktime_to_ns(serial_ir.lastkt));
+				continue;
+			}
+
+			delkt = ktime_sub(kt, serial_ir.lastkt);
+			if (ktime_compare(delkt, ktime_set(15, 0)) > 0) {
+				data = IR_MAX_DURATION; /* really long time */
+				if (!(dcd^sense)) {
+					/* sanity check */
+					dev_err(&serial_ir.pdev->dev,
+						"dcd unexpected: %d %d %lldns %lldns\n",
+						dcd, sense, ktime_to_ns(kt),
+						ktime_to_ns(serial_ir.lastkt));
+					/*
+					 * detecting pulse while this
+					 * MUST be a space!
+					 */
+					sense = sense ? 0 : 1;
+				}
+			} else
+				data = (unsigned int)ktime_to_ns(delkt);
+			frbwrite(data, !(dcd^sense));
+			serial_ir.lastkt = kt;
+			last_dcd = dcd;
+			ir_raw_event_handle(serial_ir.rcdev);
+		}
+	} while (!(sinp(UART_IIR) & UART_IIR_NO_INT)); /* still pending ? */
+	return IRQ_HANDLED;
+}
+
+
+static int hardware_init_port(void)
+{
+	u8 scratch, scratch2, scratch3;
+
+	/*
+	 * This is a simple port existence test, borrowed from the autoconfig
+	 * function in drivers/serial/8250.c
+	 */
+	scratch = sinp(UART_IER);
+	soutp(UART_IER, 0);
+#ifdef __i386__
+	outb(0xff, 0x080);
+#endif
+	scratch2 = sinp(UART_IER) & 0x0f;
+	soutp(UART_IER, 0x0f);
+#ifdef __i386__
+	outb(0x00, 0x080);
+#endif
+	scratch3 = sinp(UART_IER) & 0x0f;
+	soutp(UART_IER, scratch);
+	if (scratch2 != 0 || scratch3 != 0x0f) {
+		/* we fail, there's nothing here */
+		pr_err("port existence test failed, cannot continue\n");
+		return -ENODEV;
+	}
+
+	/* Set DLAB 0. */
+	soutp(UART_LCR, sinp(UART_LCR) & (~UART_LCR_DLAB));
+
+	/* First of all, disable all interrupts */
+	soutp(UART_IER, sinp(UART_IER) &
+	      (~(UART_IER_MSI|UART_IER_RLSI|UART_IER_THRI|UART_IER_RDI)));
+
+	/* Clear registers. */
+	sinp(UART_LSR);
+	sinp(UART_RX);
+	sinp(UART_IIR);
+	sinp(UART_MSR);
+
+	/* Set line for power source */
+	off();
+
+	/* Clear registers again to be sure. */
+	sinp(UART_LSR);
+	sinp(UART_RX);
+	sinp(UART_IIR);
+	sinp(UART_MSR);
+
+	switch (type) {
+	case IR_IRDEO:
+	case IR_IRDEO_REMOTE:
+		/* setup port to 7N1 @ 115200 Baud */
+		/* 7N1+start = 9 bits at 115200 ~ 3 bits at 38kHz */
+
+		/* Set DLAB 1. */
+		soutp(UART_LCR, sinp(UART_LCR) | UART_LCR_DLAB);
+		/* Set divisor to 1 => 115200 Baud */
+		soutp(UART_DLM, 0);
+		soutp(UART_DLL, 1);
+		/* Set DLAB 0 +  7N1 */
+		soutp(UART_LCR, UART_LCR_WLEN7);
+		/* THR interrupt already disabled at this point */
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+static int serial_ir_probe(struct platform_device *dev)
+{
+	int i, nlow, nhigh, result;
+
+	result = devm_request_irq(&dev->dev, irq, serial_ir_irq_handler,
+			     (share_irq ? IRQF_SHARED : 0),
+			     DRIVER_NAME, &hardware);
+	if (result < 0) {
+		if (result == -EBUSY)
+			dev_err(&dev->dev, "IRQ %d busy\n", irq);
+		else if (result == -EINVAL)
+			dev_err(&dev->dev, "Bad irq number or handler\n");
+		return result;
+	}
+
+	/* Reserve io region. */
+	/*
+	 * Future MMAP-Developers: Attention!
+	 * For memory mapped I/O you *might* need to use ioremap() first,
+	 * for the NSLU2 it's done in boot code.
+	 */
+	if (((iommap)
+	     && (devm_request_mem_region(&dev->dev, iommap, 8 << ioshift,
+					 DRIVER_NAME) == NULL))
+	   || ((!iommap)
+	       && (devm_request_region(&dev->dev, io, 8,
+				       DRIVER_NAME) == NULL))) {
+		dev_err(&dev->dev, "port %04x already in use\n", io);
+		dev_warn(&dev->dev, "use 'setserial /dev/ttySX uart none'\n");
+		dev_warn(&dev->dev,
+			 "or compile the serial port driver as module and\n");
+		dev_warn(&dev->dev, "make sure this module is loaded first\n");
+		return -EBUSY;
+	}
+
+	result = hardware_init_port();
+	if (result < 0)
+		return result;
+
+	/* Initialize pulse/space widths */
+	init_timing_params(50, 38000);
+
+	/* If pin is high, then this must be an active low receiver. */
+	if (sense == -1) {
+		/* wait 1/2 sec for the power supply */
+		msleep(500);
+
+		/*
+		 * probe 9 times every 0.04s, collect "votes" for
+		 * active high/low
+		 */
+		nlow = 0;
+		nhigh = 0;
+		for (i = 0; i < 9; i++) {
+			if (sinp(UART_MSR) & hardware[type].signal_pin)
+				nlow++;
+			else
+				nhigh++;
+			msleep(40);
+		}
+		sense = nlow >= nhigh ? 1 : 0;
+		dev_info(&dev->dev, "auto-detected active %s receiver\n",
+			 sense ? "low" : "high");
+	} else
+		dev_info(&dev->dev, "Manually using active %s receiver\n",
+			 sense ? "low" : "high");
+
+	dev_dbg(&dev->dev, "Interrupt %d, port %04x obtained\n", irq, io);
+	return 0;
+}
+
+static int serial_ir_open(struct rc_dev *rcdev)
+{
+	unsigned long flags;
+
+	/* initialize timestamp */
+	serial_ir.lastkt = ktime_get();
+
+	spin_lock_irqsave(&hardware[type].lock, flags);
+
+	/* Set DLAB 0. */
+	soutp(UART_LCR, sinp(UART_LCR) & (~UART_LCR_DLAB));
+
+	soutp(UART_IER, sinp(UART_IER)|UART_IER_MSI);
+
+	spin_unlock_irqrestore(&hardware[type].lock, flags);
+
+	return 0;
+}
+
+static void serial_ir_close(struct rc_dev *rcdev)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&hardware[type].lock, flags);
+
+	/* Set DLAB 0. */
+	soutp(UART_LCR, sinp(UART_LCR) & (~UART_LCR_DLAB));
+
+	/* First of all, disable all interrupts */
+	soutp(UART_IER, sinp(UART_IER) &
+	      (~(UART_IER_MSI|UART_IER_RLSI|UART_IER_THRI|UART_IER_RDI)));
+	spin_unlock_irqrestore(&hardware[type].lock, flags);
+}
+
+static int serial_ir_tx(struct rc_dev *dev, unsigned int *txbuf,
+							unsigned int count)
+{
+	unsigned long flags;
+	long delta = 0;
+	int i;
+
+	spin_lock_irqsave(&hardware[type].lock, flags);
+	if (type == IR_IRDEO) {
+		/* DTR, RTS down */
+		on();
+	}
+	for (i = 0; i < count; i++) {
+		if (i%2)
+			hardware[type].send_space(txbuf[i] - delta);
+		else
+			delta = hardware[type].send_pulse(txbuf[i]);
+	}
+	off();
+	spin_unlock_irqrestore(&hardware[type].lock, flags);
+	return count;
+}
+
+static int serial_ir_tx_duty_cycle(struct rc_dev *dev, u32 cycle)
+{
+	return init_timing_params(cycle, serial_ir.freq);
+}
+
+static int serial_ir_tx_carrier(struct rc_dev *dev, u32 carrier)
+{
+	if (carrier > 500000 || carrier < 20000)
+		return -EINVAL;
+
+	return init_timing_params(serial_ir.duty_cycle, carrier);
+}
+
+static int serial_ir_suspend(struct platform_device *dev,
+			       pm_message_t state)
+{
+	/* Set DLAB 0. */
+	soutp(UART_LCR, sinp(UART_LCR) & (~UART_LCR_DLAB));
+
+	/* Disable all interrupts */
+	soutp(UART_IER, sinp(UART_IER) &
+	      (~(UART_IER_MSI|UART_IER_RLSI|UART_IER_THRI|UART_IER_RDI)));
+
+	/* Clear registers. */
+	sinp(UART_LSR);
+	sinp(UART_RX);
+	sinp(UART_IIR);
+	sinp(UART_MSR);
+
+	return 0;
+}
+
+static int serial_ir_resume(struct platform_device *dev)
+{
+	unsigned long flags;
+	int result;
+
+	result = hardware_init_port();
+	if (result < 0)
+		return result;
+
+	spin_lock_irqsave(&hardware[type].lock, flags);
+	/* Enable Interrupt */
+	serial_ir.lastkt = ktime_get();
+	soutp(UART_IER, sinp(UART_IER)|UART_IER_MSI);
+	off();
+
+	spin_unlock_irqrestore(&hardware[type].lock, flags);
+
+	return 0;
+}
+
+static struct platform_driver serial_ir_driver = {
+	.probe		= serial_ir_probe,
+	.suspend	= serial_ir_suspend,
+	.resume		= serial_ir_resume,
+	.driver		= {
+		.name	= "serial_ir",
+	},
+};
+
+static int __init serial_ir_init(void)
+{
+	int result;
+
+	result = platform_driver_register(&serial_ir_driver);
+	if (result)
+		return result;
+
+	serial_ir.pdev = platform_device_alloc("serial_ir", 0);
+	if (!serial_ir.pdev) {
+		result = -ENOMEM;
+		goto exit_driver_unregister;
+	}
+
+	result = platform_device_add(serial_ir.pdev);
+	if (result)
+		goto exit_device_put;
+
+	return 0;
+
+exit_device_put:
+	platform_device_put(serial_ir.pdev);
+exit_driver_unregister:
+	platform_driver_unregister(&serial_ir_driver);
+	return result;
+}
+
+static void serial_ir_exit(void)
+{
+	platform_device_unregister(serial_ir.pdev);
+	platform_driver_unregister(&serial_ir_driver);
+}
+
+static int __init serial_ir_init_module(void)
+{
+	struct rc_dev *rcdev;
+	int result;
+
+	switch (type) {
+	case IR_HOMEBREW:
+	case IR_IRDEO:
+	case IR_IRDEO_REMOTE:
+	case IR_ANIMAX:
+	case IR_IGOR:
+	case IR_NSLU2:
+		/* if nothing specified, use ttyS0/com1 and irq 4 */
+		io = io ? io : 0x3f8;
+		irq = irq ? irq : 4;
+		break;
+	default:
+		return -EINVAL;
+	}
+	if (!softcarrier) {
+		switch (type) {
+		case IR_HOMEBREW:
+		case IR_IGOR:
+			hardware[type].set_send_carrier = false;
+			hardware[type].set_duty_cycle = false;
+			break;
+		}
+	}
+
+	/* make sure sense is either -1, 0, or 1 */
+	if (sense != -1)
+		sense = !!sense;
+
+	result = serial_ir_init();
+	if (result)
+		return result;
+
+	rcdev = devm_rc_allocate_device(&serial_ir.pdev->dev);
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
+	case IR_NSLU2:
+		rcdev->input_name = "Serial IR type NSLU2 RX:CTS2/TX:GreenLED)";
+		break;
+	}
+
+	rcdev->input_phys = DRIVER_NAME "/input0";
+	rcdev->input_id.bustype = BUS_HOST;
+	rcdev->input_id.vendor = 0x0001;
+	rcdev->input_id.product = 0x0001;
+	rcdev->input_id.version = 0x0100;
+	rcdev->open = serial_ir_open;
+	rcdev->close = serial_ir_close;
+	rcdev->dev.parent = &serial_ir.pdev->dev;
+	rcdev->driver_type = RC_DRIVER_IR_RAW;
+	rcdev->allowed_protocols = RC_BIT_ALL;
+	rcdev->driver_name = DRIVER_NAME;
+	rcdev->map_name = RC_MAP_RC6_MCE;
+	rcdev->timeout = IR_DEFAULT_TIMEOUT;
+	rcdev->rx_resolution = 250000;
+
+	serial_ir.rcdev = rcdev;
+
+	return rc_register_device(rcdev);
+}
+
+static void __exit serial_ir_exit_module(void)
+{
+	rc_unregister_device(serial_ir.rcdev);
+	serial_ir_exit();
+}
+
+
+module_init(serial_ir_init_module);
+module_exit(serial_ir_exit_module);
+
+MODULE_DESCRIPTION("Infra-red receiver driver for serial ports.");
+MODULE_AUTHOR("Ralph Metzler, Trent Piepho, Ben Pfaff, Christoph Bartelmus, Andrei Tanas");
+MODULE_LICENSE("GPL");
+
+module_param(type, int, 0444);
+MODULE_PARM_DESC(type, "Hardware type (0 = home-brew, 1 = IRdeo, 2 = IRdeo Remote, 3 = AnimaX, 4 = IgorPlug, 5 = NSLU2 RX:CTS2/TX:GreenLED)");
+
+module_param(io, int, 0444);
+MODULE_PARM_DESC(io, "I/O address base (0x3f8 or 0x2f8)");
+
+/* some architectures (e.g. intel xscale) have memory mapped registers */
+module_param(iommap, bool, 0444);
+MODULE_PARM_DESC(iommap, "physical base for memory mapped I/O (0 = no memory mapped io)");
+
+/*
+ * some architectures (e.g. intel xscale) align the 8bit serial registers
+ * on 32bit word boundaries.
+ * See linux-kernel/drivers/tty/serial/8250/8250.c serial_in()/out()
+ */
+module_param(ioshift, int, 0444);
+MODULE_PARM_DESC(ioshift, "shift I/O register offset (0 = no shift)");
+
+module_param(irq, int, 0444);
+MODULE_PARM_DESC(irq, "Interrupt (4 or 3)");
+
+module_param(share_irq, bool, 0444);
+MODULE_PARM_DESC(share_irq, "Share interrupts (0 = off, 1 = on)");
+
+module_param(sense, int, 0444);
+MODULE_PARM_DESC(sense, "Override autodetection of IR receiver circuit (0 = active high, 1 = active low )");
+
+#ifdef CONFIG_IR_SERIAL_TRANSMITTER
+module_param(txsense, bool, 0444);
+MODULE_PARM_DESC(txsense, "Sense of transmitter circuit (0 = active high, 1 = active low )");
+#endif
+
+module_param(softcarrier, bool, 0444);
+MODULE_PARM_DESC(softcarrier, "Software carrier (0 = off, 1 = on, default on)");
diff --git a/drivers/staging/media/lirc/Kconfig b/drivers/staging/media/lirc/Kconfig
index 6879c46..25b7e7c 100644
--- a/drivers/staging/media/lirc/Kconfig
+++ b/drivers/staging/media/lirc/Kconfig
@@ -38,19 +38,6 @@ config LIRC_SASEM
 	help
 	  Driver for the Sasem OnAir Remocon-V or Dign HV5 HTPC IR/VFD Module
 
-config LIRC_SERIAL
-	tristate "Homebrew Serial Port Receiver"
-	depends on LIRC
-	help
-	  Driver for Homebrew Serial Port Receivers
-
-config LIRC_SERIAL_TRANSMITTER
-	bool "Serial Port Transmitter"
-	default y
-	depends on LIRC_SERIAL
-	help
-	  Serial Port Transmitter support
-
 config LIRC_SIR
 	tristate "Built-in SIR IrDA port"
 	depends on LIRC
diff --git a/drivers/staging/media/lirc/Makefile b/drivers/staging/media/lirc/Makefile
index 5430adf..7f919ea 100644
--- a/drivers/staging/media/lirc/Makefile
+++ b/drivers/staging/media/lirc/Makefile
@@ -7,6 +7,5 @@ obj-$(CONFIG_LIRC_BT829)	+= lirc_bt829.o
 obj-$(CONFIG_LIRC_IMON)		+= lirc_imon.o
 obj-$(CONFIG_LIRC_PARALLEL)	+= lirc_parallel.o
 obj-$(CONFIG_LIRC_SASEM)	+= lirc_sasem.o
-obj-$(CONFIG_LIRC_SERIAL)	+= lirc_serial.o
 obj-$(CONFIG_LIRC_SIR)		+= lirc_sir.o
 obj-$(CONFIG_LIRC_ZILOG)	+= lirc_zilog.o
diff --git a/drivers/staging/media/lirc/lirc_serial.c b/drivers/staging/media/lirc/lirc_serial.c
deleted file mode 100644
index b798b31..0000000
--- a/drivers/staging/media/lirc/lirc_serial.c
+++ /dev/null
@@ -1,1130 +0,0 @@
-/*
- * lirc_serial.c
- *
- * lirc_serial - Device driver that records pulse- and pause-lengths
- *	       (space-lengths) between DDCD event on a serial port.
- *
- * Copyright (C) 1996,97 Ralph Metzler <rjkm@thp.uni-koeln.de>
- * Copyright (C) 1998 Trent Piepho <xyzzy@u.washington.edu>
- * Copyright (C) 1998 Ben Pfaff <blp@gnu.org>
- * Copyright (C) 1999 Christoph Bartelmus <lirc@bartelmus.de>
- * Copyright (C) 2007 Andrei Tanas <andrei@tanas.ca> (suspend/resume support)
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; either version 2 of the License, or
- *  (at your option) any later version.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- *
- */
-
-/*
- * Steve's changes to improve transmission fidelity:
- *   - for systems with the rdtsc instruction and the clock counter, a
- *     send_pule that times the pulses directly using the counter.
- *     This means that the LIRC_SERIAL_TRANSMITTER_LATENCY fudge is
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
-#include <linux/module.h>
-#include <linux/errno.h>
-#include <linux/signal.h>
-#include <linux/sched.h>
-#include <linux/fs.h>
-#include <linux/interrupt.h>
-#include <linux/ioport.h>
-#include <linux/kernel.h>
-#include <linux/serial_reg.h>
-#include <linux/ktime.h>
-#include <linux/string.h>
-#include <linux/types.h>
-#include <linux/wait.h>
-#include <linux/mm.h>
-#include <linux/delay.h>
-#include <linux/poll.h>
-#include <linux/platform_device.h>
-#include <linux/gpio.h>
-#include <linux/io.h>
-#include <linux/irq.h>
-#include <linux/fcntl.h>
-#include <linux/spinlock.h>
-
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
-	int signal_pin;
-	int signal_pin_change;
-	u8 on;
-	u8 off;
-	long (*send_pulse)(unsigned long length);
-	void (*send_space)(long length);
-	int features;
-	spinlock_t lock;
-};
-
-#define LIRC_HOMEBREW		0
-#define LIRC_IRDEO		1
-#define LIRC_IRDEO_REMOTE	2
-#define LIRC_ANIMAX		3
-#define LIRC_IGOR		4
-#define LIRC_NSLU2		5
-
-/*** module parameters ***/
-static int type;
-static int io;
-static int irq;
-static bool iommap;
-static int ioshift;
-static bool softcarrier = true;
-static bool share_irq;
-static int sense = -1;	/* -1 = auto, 0 = active high, 1 = active low */
-static bool txsense;	/* 0 = active high, 1 = active low */
-
-/* forward declarations */
-static long send_pulse_irdeo(unsigned long length);
-static long send_pulse_homebrew(unsigned long length);
-static void send_space_irdeo(long length);
-static void send_space_homebrew(long length);
-
-static struct lirc_serial hardware[] = {
-	[LIRC_HOMEBREW] = {
-		.lock = __SPIN_LOCK_UNLOCKED(hardware[LIRC_HOMEBREW].lock),
-		.signal_pin        = UART_MSR_DCD,
-		.signal_pin_change = UART_MSR_DDCD,
-		.on  = (UART_MCR_RTS | UART_MCR_OUT2 | UART_MCR_DTR),
-		.off = (UART_MCR_RTS | UART_MCR_OUT2),
-		.send_pulse = send_pulse_homebrew,
-		.send_space = send_space_homebrew,
-#ifdef CONFIG_LIRC_SERIAL_TRANSMITTER
-		.features    = (LIRC_CAN_SET_SEND_DUTY_CYCLE |
-				LIRC_CAN_SET_SEND_CARRIER |
-				LIRC_CAN_SEND_PULSE | LIRC_CAN_REC_MODE2)
-#else
-		.features    = LIRC_CAN_REC_MODE2
-#endif
-	},
-
-	[LIRC_IRDEO] = {
-		.lock = __SPIN_LOCK_UNLOCKED(hardware[LIRC_IRDEO].lock),
-		.signal_pin        = UART_MSR_DSR,
-		.signal_pin_change = UART_MSR_DDSR,
-		.on  = UART_MCR_OUT2,
-		.off = (UART_MCR_RTS | UART_MCR_DTR | UART_MCR_OUT2),
-		.send_pulse  = send_pulse_irdeo,
-		.send_space  = send_space_irdeo,
-		.features    = (LIRC_CAN_SET_SEND_DUTY_CYCLE |
-				LIRC_CAN_SEND_PULSE | LIRC_CAN_REC_MODE2)
-	},
-
-	[LIRC_IRDEO_REMOTE] = {
-		.lock = __SPIN_LOCK_UNLOCKED(hardware[LIRC_IRDEO_REMOTE].lock),
-		.signal_pin        = UART_MSR_DSR,
-		.signal_pin_change = UART_MSR_DDSR,
-		.on  = (UART_MCR_RTS | UART_MCR_DTR | UART_MCR_OUT2),
-		.off = (UART_MCR_RTS | UART_MCR_DTR | UART_MCR_OUT2),
-		.send_pulse  = send_pulse_irdeo,
-		.send_space  = send_space_irdeo,
-		.features    = (LIRC_CAN_SET_SEND_DUTY_CYCLE |
-				LIRC_CAN_SEND_PULSE | LIRC_CAN_REC_MODE2)
-	},
-
-	[LIRC_ANIMAX] = {
-		.lock = __SPIN_LOCK_UNLOCKED(hardware[LIRC_ANIMAX].lock),
-		.signal_pin        = UART_MSR_DCD,
-		.signal_pin_change = UART_MSR_DDCD,
-		.on  = 0,
-		.off = (UART_MCR_RTS | UART_MCR_DTR | UART_MCR_OUT2),
-		.send_pulse = NULL,
-		.send_space = NULL,
-		.features   = LIRC_CAN_REC_MODE2
-	},
-
-	[LIRC_IGOR] = {
-		.lock = __SPIN_LOCK_UNLOCKED(hardware[LIRC_IGOR].lock),
-		.signal_pin        = UART_MSR_DSR,
-		.signal_pin_change = UART_MSR_DDSR,
-		.on  = (UART_MCR_RTS | UART_MCR_OUT2 | UART_MCR_DTR),
-		.off = (UART_MCR_RTS | UART_MCR_OUT2),
-		.send_pulse = send_pulse_homebrew,
-		.send_space = send_space_homebrew,
-#ifdef CONFIG_LIRC_SERIAL_TRANSMITTER
-		.features    = (LIRC_CAN_SET_SEND_DUTY_CYCLE |
-				LIRC_CAN_SET_SEND_CARRIER |
-				LIRC_CAN_SEND_PULSE | LIRC_CAN_REC_MODE2)
-#else
-		.features    = LIRC_CAN_REC_MODE2
-#endif
-	},
-};
-
-#define RS_ISR_PASS_LIMIT 256
-
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
-
-static ktime_t lastkt;
-
-static struct lirc_buffer rbuf;
-
-static unsigned int freq = 38000;
-static unsigned int duty_cycle = 50;
-
-/* Initialized in init_timing_params() */
-static unsigned long period;
-static unsigned long pulse_width;
-static unsigned long space_width;
-
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
-#define LIRC_SERIAL_TRANSMITTER_LATENCY 450
-
-#else
-
-/* does anybody have information on other platforms ? */
-/* 256 = 1<<8 */
-#define LIRC_SERIAL_TRANSMITTER_LATENCY 256
-
-#endif  /* __i386__ */
-/*
- * FIXME: should we be using hrtimers instead of this
- * LIRC_SERIAL_TRANSMITTER_LATENCY nonsense?
- */
-
-/* fetch serial input packet (1 byte) from register offset */
-static u8 sinp(int offset)
-{
-	if (iommap)
-		/* the register is memory-mapped */
-		offset <<= ioshift;
-
-	return inb(io + offset);
-}
-
-/* write serial output packet (1 byte) of value to register offset */
-static void soutp(int offset, u8 value)
-{
-	if (iommap)
-		/* the register is memory-mapped */
-		offset <<= ioshift;
-
-	outb(value, io + offset);
-}
-
-static void on(void)
-{
-	if (txsense)
-		soutp(UART_MCR, hardware[type].off);
-	else
-		soutp(UART_MCR, hardware[type].on);
-}
-
-static void off(void)
-{
-	if (txsense)
-		soutp(UART_MCR, hardware[type].on);
-	else
-		soutp(UART_MCR, hardware[type].off);
-}
-
-#ifndef MAX_UDELAY_MS
-#define MAX_UDELAY_US 5000
-#else
-#define MAX_UDELAY_US (MAX_UDELAY_MS*1000)
-#endif
-
-static void safe_udelay(unsigned long usecs)
-{
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
-	duty_cycle = new_duty_cycle;
-	freq = new_freq;
-
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
-	period = loops_per_sec >> 3;
-	period /= (freq >> 3);
-
-	/* Derive pulse and space from the period */
-	pulse_width = period * duty_cycle / 100;
-	space_width = period - pulse_width;
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
-	    LIRC_SERIAL_TRANSMITTER_LATENCY)
-		return -EINVAL;
-	if (256 * 1000000L / new_freq * (100 - new_duty_cycle) / 100 <=
-	    LIRC_SERIAL_TRANSMITTER_LATENCY)
-		return -EINVAL;
-	duty_cycle = new_duty_cycle;
-	freq = new_freq;
-	period = 256 * 1000000L / freq;
-	pulse_width = period * duty_cycle / 100;
-	space_width = period - pulse_width;
-	pr_debug("in init_timing_params, freq=%d pulse=%ld, space=%ld\n",
-		 freq, pulse_width, space_width);
-	return 0;
-}
-#endif /* USE_RDTSC */
-
-
-/* return value: space length delta */
-
-static long send_pulse_irdeo(unsigned long length)
-{
-	long rawbits, ret;
-	int i;
-	unsigned char output;
-	unsigned char chunk, shifted;
-
-	/* how many bits have to be sent ? */
-	rawbits = length * 1152 / 10000;
-	if (duty_cycle > 50)
-		chunk = 3;
-	else
-		chunk = 1;
-	for (i = 0, output = 0x7f; rawbits > 0; rawbits -= 3) {
-		shifted = chunk << (i * 3);
-		shifted >>= 1;
-		output &= (~shifted);
-		i++;
-		if (i == 3) {
-			soutp(UART_TX, output);
-			while (!(sinp(UART_LSR) & UART_LSR_THRE))
-				;
-			output = 0x7f;
-			i = 0;
-		}
-	}
-	if (i != 0) {
-		soutp(UART_TX, output);
-		while (!(sinp(UART_LSR) & UART_LSR_TEMT))
-			;
-	}
-
-	if (i == 0)
-		ret = (-rawbits) * 10000 / 1152;
-	else
-		ret = (3 - i) * 3 * 10000 / 1152 + (-rawbits) * 10000 / 1152;
-
-	return ret;
-}
-
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
-static long send_pulse_homebrew_softcarrier(unsigned long length)
-{
-	int flag;
-	unsigned long actual, target, d;
-
-	length <<= 8;
-
-	actual = 0; target = 0; flag = 0;
-	while (actual < length) {
-		if (flag) {
-			off();
-			target += space_width;
-		} else {
-			on();
-			target += pulse_width;
-		}
-		d = (target - actual -
-		     LIRC_SERIAL_TRANSMITTER_LATENCY + 128) >> 8;
-		/*
-		 * Note - we've checked in ioctl that the pulse/space
-		 * widths are big enough so that d is > 0
-		 */
-		udelay(d);
-		actual += (d << 8) + LIRC_SERIAL_TRANSMITTER_LATENCY;
-		flag = !flag;
-	}
-	return (actual-length) >> 8;
-}
-
-static long send_pulse_homebrew(unsigned long length)
-{
-	if (length <= 0)
-		return 0;
-
-	if (softcarrier)
-		return send_pulse_homebrew_softcarrier(length);
-
-	on();
-	safe_udelay(length);
-	return 0;
-}
-
-static void send_space_irdeo(long length)
-{
-	if (length <= 0)
-		return;
-
-	safe_udelay(length);
-}
-
-static void send_space_homebrew(long length)
-{
-	off();
-	if (length <= 0)
-		return;
-	safe_udelay(length);
-}
-
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
-{
-	/* simple noise filter */
-	static int pulse, space;
-	static unsigned int ptr;
-
-	if (ptr > 0 && (l & PULSE_BIT)) {
-		pulse += l & PULSE_MASK;
-		if (pulse > 250) {
-			rbwrite(space);
-			rbwrite(pulse | PULSE_BIT);
-			ptr = 0;
-			pulse = 0;
-		}
-		return;
-	}
-	if (!(l & PULSE_BIT)) {
-		if (ptr == 0) {
-			if (l > 20000) {
-				space = l;
-				ptr++;
-				return;
-			}
-		} else {
-			if (l > 20000) {
-				space += pulse;
-				if (space > PULSE_MASK)
-					space = PULSE_MASK;
-				space += l;
-				if (space > PULSE_MASK)
-					space = PULSE_MASK;
-				pulse = 0;
-				return;
-			}
-			rbwrite(space);
-			rbwrite(pulse | PULSE_BIT);
-			ptr = 0;
-			pulse = 0;
-		}
-	}
-	rbwrite(l);
-}
-
-static irqreturn_t lirc_irq_handler(int i, void *blah)
-{
-	ktime_t kt;
-	int counter, dcd;
-	u8 status;
-	ktime_t delkt;
-	int data;
-	static int last_dcd = -1;
-
-	if ((sinp(UART_IIR) & UART_IIR_NO_INT)) {
-		/* not our interrupt */
-		return IRQ_NONE;
-	}
-
-	counter = 0;
-	do {
-		counter++;
-		status = sinp(UART_MSR);
-		if (counter > RS_ISR_PASS_LIMIT) {
-			pr_warn("AIEEEE: We're caught!\n");
-			break;
-		}
-		if ((status & hardware[type].signal_pin_change)
-		    && sense != -1) {
-			/* get current time */
-			kt = ktime_get();
-
-			/* New mode, written by Trent Piepho
-			   <xyzzy@u.washington.edu>. */
-
-			/*
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
-			 */
-
-			/* calc time since last interrupt in microseconds */
-			dcd = (status & hardware[type].signal_pin) ? 1 : 0;
-
-			if (dcd == last_dcd) {
-				pr_warn("ignoring spike: %d %d %llx %llx\n",
-					dcd, sense, ktime_to_us(kt),
-					ktime_to_us(lastkt));
-				continue;
-			}
-
-			delkt = ktime_sub(kt, lastkt);
-			if (ktime_compare(delkt, ktime_set(15, 0)) > 0) {
-				data = PULSE_MASK; /* really long time */
-				if (!(dcd^sense)) {
-					/* sanity check */
-					pr_warn("AIEEEE: %d %d %llx %llx\n",
-						dcd, sense, ktime_to_us(kt),
-						ktime_to_us(lastkt));
-					/*
-					 * detecting pulse while this
-					 * MUST be a space!
-					 */
-					sense = sense ? 0 : 1;
-				}
-			} else
-				data = (int) ktime_to_us(delkt);
-			frbwrite(dcd^sense ? data : (data|PULSE_BIT));
-			lastkt = kt;
-			last_dcd = dcd;
-			wake_up_interruptible(&rbuf.wait_poll);
-		}
-	} while (!(sinp(UART_IIR) & UART_IIR_NO_INT)); /* still pending ? */
-	return IRQ_HANDLED;
-}
-
-
-static int hardware_init_port(void)
-{
-	u8 scratch, scratch2, scratch3;
-
-	/*
-	 * This is a simple port existence test, borrowed from the autoconfig
-	 * function in drivers/serial/8250.c
-	 */
-	scratch = sinp(UART_IER);
-	soutp(UART_IER, 0);
-#ifdef __i386__
-	outb(0xff, 0x080);
-#endif
-	scratch2 = sinp(UART_IER) & 0x0f;
-	soutp(UART_IER, 0x0f);
-#ifdef __i386__
-	outb(0x00, 0x080);
-#endif
-	scratch3 = sinp(UART_IER) & 0x0f;
-	soutp(UART_IER, scratch);
-	if (scratch2 != 0 || scratch3 != 0x0f) {
-		/* we fail, there's nothing here */
-		pr_err("port existence test failed, cannot continue\n");
-		return -ENODEV;
-	}
-
-
-
-	/* Set DLAB 0. */
-	soutp(UART_LCR, sinp(UART_LCR) & (~UART_LCR_DLAB));
-
-	/* First of all, disable all interrupts */
-	soutp(UART_IER, sinp(UART_IER) &
-	      (~(UART_IER_MSI|UART_IER_RLSI|UART_IER_THRI|UART_IER_RDI)));
-
-	/* Clear registers. */
-	sinp(UART_LSR);
-	sinp(UART_RX);
-	sinp(UART_IIR);
-	sinp(UART_MSR);
-
-	/* Set line for power source */
-	off();
-
-	/* Clear registers again to be sure. */
-	sinp(UART_LSR);
-	sinp(UART_RX);
-	sinp(UART_IIR);
-	sinp(UART_MSR);
-
-	switch (type) {
-	case LIRC_IRDEO:
-	case LIRC_IRDEO_REMOTE:
-		/* setup port to 7N1 @ 115200 Baud */
-		/* 7N1+start = 9 bits at 115200 ~ 3 bits at 38kHz */
-
-		/* Set DLAB 1. */
-		soutp(UART_LCR, sinp(UART_LCR) | UART_LCR_DLAB);
-		/* Set divisor to 1 => 115200 Baud */
-		soutp(UART_DLM, 0);
-		soutp(UART_DLL, 1);
-		/* Set DLAB 0 +  7N1 */
-		soutp(UART_LCR, UART_LCR_WLEN7);
-		/* THR interrupt already disabled at this point */
-		break;
-	default:
-		break;
-	}
-
-	return 0;
-}
-
-static int lirc_serial_probe(struct platform_device *dev)
-{
-	int i, nlow, nhigh, result;
-
-	result = devm_request_irq(&dev->dev, irq, lirc_irq_handler,
-			     (share_irq ? IRQF_SHARED : 0),
-			     LIRC_DRIVER_NAME, &hardware);
-	if (result < 0) {
-		if (result == -EBUSY)
-			dev_err(&dev->dev, "IRQ %d busy\n", irq);
-		else if (result == -EINVAL)
-			dev_err(&dev->dev, "Bad irq number or handler\n");
-		return result;
-	}
-
-	/* Reserve io region. */
-	/*
-	 * Future MMAP-Developers: Attention!
-	 * For memory mapped I/O you *might* need to use ioremap() first,
-	 * for the NSLU2 it's done in boot code.
-	 */
-	if (((iommap)
-	     && (devm_request_mem_region(&dev->dev, iommap, 8 << ioshift,
-					 LIRC_DRIVER_NAME) == NULL))
-	   || ((!iommap)
-	       && (devm_request_region(&dev->dev, io, 8,
-				       LIRC_DRIVER_NAME) == NULL))) {
-		dev_err(&dev->dev, "port %04x already in use\n", io);
-		dev_warn(&dev->dev, "use 'setserial /dev/ttySX uart none'\n");
-		dev_warn(&dev->dev,
-			 "or compile the serial port driver as module and\n");
-		dev_warn(&dev->dev, "make sure this module is loaded first\n");
-		return -EBUSY;
-	}
-
-	result = hardware_init_port();
-	if (result < 0)
-		return result;
-
-	/* Initialize pulse/space widths */
-	init_timing_params(duty_cycle, freq);
-
-	/* If pin is high, then this must be an active low receiver. */
-	if (sense == -1) {
-		/* wait 1/2 sec for the power supply */
-		msleep(500);
-
-		/*
-		 * probe 9 times every 0.04s, collect "votes" for
-		 * active high/low
-		 */
-		nlow = 0;
-		nhigh = 0;
-		for (i = 0; i < 9; i++) {
-			if (sinp(UART_MSR) & hardware[type].signal_pin)
-				nlow++;
-			else
-				nhigh++;
-			msleep(40);
-		}
-		sense = nlow >= nhigh ? 1 : 0;
-		dev_info(&dev->dev, "auto-detected active %s receiver\n",
-			 sense ? "low" : "high");
-	} else
-		dev_info(&dev->dev, "Manually using active %s receiver\n",
-			 sense ? "low" : "high");
-
-	dev_dbg(&dev->dev, "Interrupt %d, port %04x obtained\n", irq, io);
-	return 0;
-}
-
-static int set_use_inc(void *data)
-{
-	unsigned long flags;
-
-	/* initialize timestamp */
-	lastkt = ktime_get();
-
-	spin_lock_irqsave(&hardware[type].lock, flags);
-
-	/* Set DLAB 0. */
-	soutp(UART_LCR, sinp(UART_LCR) & (~UART_LCR_DLAB));
-
-	soutp(UART_IER, sinp(UART_IER)|UART_IER_MSI);
-
-	spin_unlock_irqrestore(&hardware[type].lock, flags);
-
-	return 0;
-}
-
-static void set_use_dec(void *data)
-{	unsigned long flags;
-
-	spin_lock_irqsave(&hardware[type].lock, flags);
-
-	/* Set DLAB 0. */
-	soutp(UART_LCR, sinp(UART_LCR) & (~UART_LCR_DLAB));
-
-	/* First of all, disable all interrupts */
-	soutp(UART_IER, sinp(UART_IER) &
-	      (~(UART_IER_MSI|UART_IER_RLSI|UART_IER_THRI|UART_IER_RDI)));
-	spin_unlock_irqrestore(&hardware[type].lock, flags);
-}
-
-static ssize_t lirc_write(struct file *file, const char __user *buf,
-			 size_t n, loff_t *ppos)
-{
-	int i, count;
-	unsigned long flags;
-	long delta = 0;
-	int *wbuf;
-
-	if (!(hardware[type].features & LIRC_CAN_SEND_PULSE))
-		return -EPERM;
-
-	count = n / sizeof(int);
-	if (n % sizeof(int) || count % 2 == 0)
-		return -EINVAL;
-	wbuf = memdup_user(buf, n);
-	if (IS_ERR(wbuf))
-		return PTR_ERR(wbuf);
-	spin_lock_irqsave(&hardware[type].lock, flags);
-	if (type == LIRC_IRDEO) {
-		/* DTR, RTS down */
-		on();
-	}
-	for (i = 0; i < count; i++) {
-		if (i%2)
-			hardware[type].send_space(wbuf[i] - delta);
-		else
-			delta = hardware[type].send_pulse(wbuf[i]);
-	}
-	off();
-	spin_unlock_irqrestore(&hardware[type].lock, flags);
-	kfree(wbuf);
-	return n;
-}
-
-static long lirc_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
-{
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
-}
-
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
-
-static struct platform_device *lirc_serial_dev;
-
-static int lirc_serial_suspend(struct platform_device *dev,
-			       pm_message_t state)
-{
-	/* Set DLAB 0. */
-	soutp(UART_LCR, sinp(UART_LCR) & (~UART_LCR_DLAB));
-
-	/* Disable all interrupts */
-	soutp(UART_IER, sinp(UART_IER) &
-	      (~(UART_IER_MSI|UART_IER_RLSI|UART_IER_THRI|UART_IER_RDI)));
-
-	/* Clear registers. */
-	sinp(UART_LSR);
-	sinp(UART_RX);
-	sinp(UART_IIR);
-	sinp(UART_MSR);
-
-	return 0;
-}
-
-/* twisty maze... need a forward-declaration here... */
-static void lirc_serial_exit(void);
-
-static int lirc_serial_resume(struct platform_device *dev)
-{
-	unsigned long flags;
-	int result;
-
-	result = hardware_init_port();
-	if (result < 0)
-		return result;
-
-	spin_lock_irqsave(&hardware[type].lock, flags);
-	/* Enable Interrupt */
-	lastkt = ktime_get();
-	soutp(UART_IER, sinp(UART_IER)|UART_IER_MSI);
-	off();
-
-	lirc_buffer_clear(&rbuf);
-
-	spin_unlock_irqrestore(&hardware[type].lock, flags);
-
-	return 0;
-}
-
-static struct platform_driver lirc_serial_driver = {
-	.probe		= lirc_serial_probe,
-	.suspend	= lirc_serial_suspend,
-	.resume		= lirc_serial_resume,
-	.driver		= {
-		.name	= "lirc_serial",
-	},
-};
-
-static int __init lirc_serial_init(void)
-{
-	int result;
-
-	/* Init read buffer. */
-	result = lirc_buffer_init(&rbuf, sizeof(int), RBUF_LEN);
-	if (result < 0)
-		return result;
-
-	result = platform_driver_register(&lirc_serial_driver);
-	if (result) {
-		printk("lirc register returned %d\n", result);
-		goto exit_buffer_free;
-	}
-
-	lirc_serial_dev = platform_device_alloc("lirc_serial", 0);
-	if (!lirc_serial_dev) {
-		result = -ENOMEM;
-		goto exit_driver_unregister;
-	}
-
-	result = platform_device_add(lirc_serial_dev);
-	if (result)
-		goto exit_device_put;
-
-	return 0;
-
-exit_device_put:
-	platform_device_put(lirc_serial_dev);
-exit_driver_unregister:
-	platform_driver_unregister(&lirc_serial_driver);
-exit_buffer_free:
-	lirc_buffer_free(&rbuf);
-	return result;
-}
-
-static void lirc_serial_exit(void)
-{
-	platform_device_unregister(lirc_serial_dev);
-	platform_driver_unregister(&lirc_serial_driver);
-	lirc_buffer_free(&rbuf);
-}
-
-static int __init lirc_serial_init_module(void)
-{
-	int result;
-
-	switch (type) {
-	case LIRC_HOMEBREW:
-	case LIRC_IRDEO:
-	case LIRC_IRDEO_REMOTE:
-	case LIRC_ANIMAX:
-	case LIRC_IGOR:
-		/* if nothing specified, use ttyS0/com1 and irq 4 */
-		io = io ? io : 0x3f8;
-		irq = irq ? irq : 4;
-		break;
-	default:
-		return -EINVAL;
-	}
-	if (!softcarrier) {
-		switch (type) {
-		case LIRC_HOMEBREW:
-		case LIRC_IGOR:
-			hardware[type].features &=
-				~(LIRC_CAN_SET_SEND_DUTY_CYCLE|
-				  LIRC_CAN_SET_SEND_CARRIER);
-			break;
-		}
-	}
-
-	/* make sure sense is either -1, 0, or 1 */
-	if (sense != -1)
-		sense = !!sense;
-
-	result = lirc_serial_init();
-	if (result)
-		return result;
-
-	driver.features = hardware[type].features;
-	driver.dev = &lirc_serial_dev->dev;
-	driver.minor = lirc_register_driver(&driver);
-	if (driver.minor < 0) {
-		pr_err("register_chrdev failed!\n");
-		lirc_serial_exit();
-		return driver.minor;
-	}
-	return 0;
-}
-
-static void __exit lirc_serial_exit_module(void)
-{
-	lirc_unregister_driver(driver.minor);
-	lirc_serial_exit();
-	pr_debug("cleaned up module\n");
-}
-
-
-module_init(lirc_serial_init_module);
-module_exit(lirc_serial_exit_module);
-
-MODULE_DESCRIPTION("Infra-red receiver driver for serial ports.");
-MODULE_AUTHOR("Ralph Metzler, Trent Piepho, Ben Pfaff, "
-	      "Christoph Bartelmus, Andrei Tanas");
-MODULE_LICENSE("GPL");
-
-module_param(type, int, S_IRUGO);
-MODULE_PARM_DESC(type, "Hardware type (0 = home-brew, 1 = IRdeo,"
-		 " 2 = IRdeo Remote, 3 = AnimaX, 4 = IgorPlug,"
-		 " 5 = NSLU2 RX:CTS2/TX:GreenLED)");
-
-module_param(io, int, S_IRUGO);
-MODULE_PARM_DESC(io, "I/O address base (0x3f8 or 0x2f8)");
-
-/* some architectures (e.g. intel xscale) have memory mapped registers */
-module_param(iommap, bool, S_IRUGO);
-MODULE_PARM_DESC(iommap, "physical base for memory mapped I/O"
-		" (0 = no memory mapped io)");
-
-/*
- * some architectures (e.g. intel xscale) align the 8bit serial registers
- * on 32bit word boundaries.
- * See linux-kernel/drivers/tty/serial/8250/8250.c serial_in()/out()
- */
-module_param(ioshift, int, S_IRUGO);
-MODULE_PARM_DESC(ioshift, "shift I/O register offset (0 = no shift)");
-
-module_param(irq, int, S_IRUGO);
-MODULE_PARM_DESC(irq, "Interrupt (4 or 3)");
-
-module_param(share_irq, bool, S_IRUGO);
-MODULE_PARM_DESC(share_irq, "Share interrupts (0 = off, 1 = on)");
-
-module_param(sense, int, S_IRUGO);
-MODULE_PARM_DESC(sense, "Override autodetection of IR receiver circuit"
-		 " (0 = active high, 1 = active low )");
-
-#ifdef CONFIG_LIRC_SERIAL_TRANSMITTER
-module_param(txsense, bool, S_IRUGO);
-MODULE_PARM_DESC(txsense, "Sense of transmitter circuit"
-		 " (0 = active high, 1 = active low )");
-#endif
-
-module_param(softcarrier, bool, S_IRUGO);
-MODULE_PARM_DESC(softcarrier, "Software carrier (0 = off, 1 = on, default on)");
-- 
2.7.4

