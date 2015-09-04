Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:33376 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759601AbbIDUEi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Sep 2015 16:04:38 -0400
Received: by lbcjc2 with SMTP id jc2so17026136lbc.0
        for <linux-media@vger.kernel.org>; Fri, 04 Sep 2015 13:04:36 -0700 (PDT)
From: Maciek Borzecki <maciek.borzecki@gmail.com>
To: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: maciek.borzecki@gmail.com
Subject: [PATCH 3/3] [media] staging: lirc: lirc_serial: use dynamic debugs
Date: Fri,  4 Sep 2015 22:04:05 +0200
Message-Id: <2a1321e6367ab740be266e358aa929af13186bcd.1441396162.git.maciek.borzecki@gmail.com>
In-Reply-To: <cover.1441396162.git.maciek.borzecki@gmail.com>
References: <cover.1441396162.git.maciek.borzecki@gmail.com>
In-Reply-To: <cover.1441396162.git.maciek.borzecki@gmail.com>
References: <cover.1441396162.git.maciek.borzecki@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace custom debug macro dprintk() with pr_debug() or
dev_dbg(). Remove unused module param `debug`.

This removes the following checkpatch warning:
WARNING: Prefer [subsystem eg: netdev]_dbg([subsystem]dev, ... then dev_dbg(dev, ... then pr_debug(...  to printk(KERN_DEBUG ...
+                       printk(KERN_DEBUG LIRC_DRIVER_NAME ": " \

Signed-off-by: Maciek Borzecki <maciek.borzecki@gmail.com>
---
 drivers/staging/media/lirc/lirc_serial.c | 32 ++++++++++----------------------
 1 file changed, 10 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_serial.c b/drivers/staging/media/lirc/lirc_serial.c
index 465796a686c417f2c23716c8fcc32e9d51489eed..64a7b2fc5289b6c1c0c0cabfa865756fb92208ed 100644
--- a/drivers/staging/media/lirc/lirc_serial.c
+++ b/drivers/staging/media/lirc/lirc_serial.c
@@ -109,17 +109,9 @@ static bool iommap;
 static int ioshift;
 static bool softcarrier = true;
 static bool share_irq;
-static bool debug;
 static int sense = -1;	/* -1 = auto, 0 = active high, 1 = active low */
 static bool txsense;	/* 0 = active high, 1 = active low */
 
-#define dprintk(fmt, args...)					\
-	do {							\
-		if (debug)					\
-			printk(KERN_DEBUG LIRC_DRIVER_NAME ": "	\
-			       fmt, ## args);			\
-	} while (0)
-
 /* forward declarations */
 static long send_pulse_irdeo(unsigned long length);
 static long send_pulse_homebrew(unsigned long length);
@@ -352,10 +344,9 @@ static int init_timing_params(unsigned int new_duty_cycle,
 	/* Derive pulse and space from the period */
 	pulse_width = period * duty_cycle / 100;
 	space_width = period - pulse_width;
-	dprintk("in init_timing_params, freq=%d, duty_cycle=%d, "
-		"clk/jiffy=%ld, pulse=%ld, space=%ld\n",
-		freq, duty_cycle, __this_cpu_read(cpu_info.loops_per_jiffy),
-		pulse_width, space_width);
+	pr_debug("in init_timing_params, freq=%d, duty_cycle=%d, clk/jiffy=%ld, pulse=%ld, space=%ld, conv_us_to_clocks=%ld\n",
+		 freq, duty_cycle, __this_cpu_read(cpu_info.loops_per_jiffy),
+		 pulse_width, space_width, conv_us_to_clocks);
 	return 0;
 }
 #else /* ! USE_RDTSC */
@@ -377,8 +368,8 @@ static int init_timing_params(unsigned int new_duty_cycle,
 	period = 256 * 1000000L / freq;
 	pulse_width = period * duty_cycle / 100;
 	space_width = period - pulse_width;
-	dprintk("in init_timing_params, freq=%d pulse=%ld, space=%ld\n",
-		freq, pulse_width, space_width);
+	pr_debug("in init_timing_params, freq=%d pulse=%ld, space=%ld\n",
+		 freq, pulse_width, space_width);
 	return 0;
 }
 #endif /* USE_RDTSC */
@@ -500,7 +491,7 @@ static void rbwrite(int l)
 {
 	if (lirc_buffer_full(&rbuf)) {
 		/* no new signals will be accepted */
-		dprintk("Buffer overrun\n");
+		pr_debug("Buffer overrun\n");
 		return;
 	}
 	lirc_buffer_write(&rbuf, (void *)&l);
@@ -790,7 +781,7 @@ static int lirc_serial_probe(struct platform_device *dev)
 		dev_info(&dev->dev, "Manually using active %s receiver\n",
 			 sense ? "low" : "high");
 
-	dprintk("Interrupt %d, port %04x obtained\n", irq, io);
+	dev_dbg(&dev->dev, "Interrupt %d, port %04x obtained\n", irq, io);
 	return 0;
 }
 
@@ -895,7 +886,7 @@ static long lirc_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 		return -ENOIOCTLCMD;
 
 	case LIRC_SET_SEND_DUTY_CYCLE:
-		dprintk("SET_SEND_DUTY_CYCLE\n");
+		pr_debug("SET_SEND_DUTY_CYCLE\n");
 		if (!(hardware[type].features&LIRC_CAN_SET_SEND_DUTY_CYCLE))
 			return -ENOIOCTLCMD;
 
@@ -907,7 +898,7 @@ static long lirc_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 		return init_timing_params(value, freq);
 
 	case LIRC_SET_SEND_CARRIER:
-		dprintk("SET_SEND_CARRIER\n");
+		pr_debug("SET_SEND_CARRIER\n");
 		if (!(hardware[type].features&LIRC_CAN_SET_SEND_CARRIER))
 			return -ENOIOCTLCMD;
 
@@ -1102,7 +1093,7 @@ static void __exit lirc_serial_exit_module(void)
 {
 	lirc_unregister_driver(driver.minor);
 	lirc_serial_exit();
-	dprintk("cleaned up module\n");
+	pr_debug("cleaned up module\n");
 }
 
 
@@ -1153,6 +1144,3 @@ MODULE_PARM_DESC(txsense, "Sense of transmitter circuit"
 
 module_param(softcarrier, bool, S_IRUGO);
 MODULE_PARM_DESC(softcarrier, "Software carrier (0 = off, 1 = on, default on)");
-
-module_param(debug, bool, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(debug, "Enable debugging messages");
-- 
2.5.1

