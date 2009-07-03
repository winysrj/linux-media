Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:3056 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756072AbZGCUsi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Jul 2009 16:48:38 -0400
Date: Fri, 3 Jul 2009 22:48:29 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Cc: Andrzej Hajda <andrzej.hajda@wp.pl>
Subject: [PATCH 2/2] cx88: High resolution timer for Remote Controls
Message-ID: <20090703224829.0943886f@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch solves problem of missed keystrokes on some remote controls,
as reported on http://bugzilla.kernel.org/show_bug.cgi?id=9637 .

Signed-off-by: Andrzej Hajda <andrzej.hajda@wp.pl>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
Changes:
* Driver no longer builds on kernels < 2.6.22, so add an entry to
  v4l/versions.txt
* Add a missing static.
Build-tested on 2.6.22.

 linux/drivers/media/video/cx88/cx88-input.c |   37 ++++++++++++----------------
 v4l/versions.txt                            |    2 +
 2 files changed, 19 insertions(+), 20 deletions(-)

--- a/linux/drivers/media/video/cx88/cx88-input.c
+++ b/linux/drivers/media/video/cx88/cx88-input.c
@@ -23,7 +23,7 @@
  */
 
 #include <linux/init.h>
-#include <linux/delay.h>
+#include <linux/hrtimer.h>
 #include <linux/input.h>
 #include <linux/pci.h>
 #include <linux/module.h>
@@ -49,7 +49,7 @@ struct cx88_IR {
 
 	/* poll external decoder */
 	int polling;
-	struct delayed_work work;
+	struct hrtimer timer;
 	u32 gpio_addr;
 	u32 last_gpio;
 	u32 mask_keycode;
@@ -145,31 +145,28 @@ static void cx88_ir_handle_key(struct cx
 	}
 }
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
-static void cx88_ir_work(void *data)
-#else
-static void cx88_ir_work(struct work_struct *work)
-#endif
+static enum hrtimer_restart cx88_ir_work(struct hrtimer *timer)
 {
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
-	struct cx88_IR *ir = data;
-#else
-	struct cx88_IR *ir = container_of(work, struct cx88_IR, work.work);
-#endif
+	unsigned long missed;
+	struct cx88_IR *ir = container_of(timer, struct cx88_IR, timer);
 
 	cx88_ir_handle_key(ir);
-	schedule_delayed_work(&ir->work, msecs_to_jiffies(ir->polling));
+	missed = hrtimer_forward_now(&ir->timer,
+				     ktime_set(0, ir->polling * 1000000));
+	if (missed > 1)
+		ir_dprintk("Missed ticks %ld\n", missed - 1);
+
+	return HRTIMER_RESTART;
 }
 
 void cx88_ir_start(struct cx88_core *core, struct cx88_IR *ir)
 {
 	if (ir->polling) {
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
-		INIT_DELAYED_WORK(&ir->work, cx88_ir_work, ir);
-#else
-		INIT_DELAYED_WORK(&ir->work, cx88_ir_work);
-#endif
-		schedule_delayed_work(&ir->work, 0);
+		hrtimer_init(&ir->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+		ir->timer.function = cx88_ir_work;
+		hrtimer_start(&ir->timer,
+			      ktime_set(0, ir->polling * 1000000),
+			      HRTIMER_MODE_REL);
 	}
 	if (ir->sampling) {
 		core->pci_irqmask |= PCI_INT_IR_SMPINT;
@@ -186,7 +183,7 @@ void cx88_ir_stop(struct cx88_core *core
 	}
 
 	if (ir->polling)
-		cancel_delayed_work_sync(&ir->work);
+		hrtimer_cancel(&ir->timer);
 }
 
 /* ---------------------------------------------------------------------- */
--- a/v4l/versions.txt
+++ b/v4l/versions.txt
@@ -34,6 +34,8 @@ DVB_DRX397XD
 DVB_DM1105
 # This driver needs print_hex_dump
 DVB_FIREDTV
+# This driver needs hrtimer API
+VIDEO_CX88
 
 [2.6.20]
 #This driver requires HID_REQ_GET_REPORT


-- 
Jean Delvare
