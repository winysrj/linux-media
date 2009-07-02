Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:31392 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046AbZGBOum (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jul 2009 10:50:42 -0400
Date: Thu, 2 Jul 2009 16:50:35 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Cc: Andrzej Hajda <andrzej.hajda@wp.pl>,
	Trent Piepho <xyzzy@speakeasy.org>
Subject: [PATCH] cx88: High resolution timer for Remote Controls
Message-ID: <20090702165035.3683b4cb@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Andrzej Hajda <andrzej.hajda@wp.pl>

Patch solves problem of missed keystrokes on some remote controls,
as reported on http://bugzilla.kernel.org/show_bug.cgi?id=9637 .

Signed-off-by: Andrzej Hajda <andrzej.hajda@wp.pl>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
Resending because last attempt resulted in folded lines:
http://www.spinics.net/lists/linux-media/msg06884.html
Patch was already resent by Andrzej on June 4th but apparently it was
overlooked.

Trent Piepho commented on the compatibility with kernels older than
2.6.20 being possibly broken:
http://www.spinics.net/lists/linux-media/msg06885.html
I don't think this is the case. The kernel version test was there
because the workqueue API changed in 2.6.20, but the hrtimer API did
not have such a change. This is why the version check has gone.

It is highly probable that the hrtimer API had its own incompatible
changes since it was introduced in kernel 2.6.16. By looking at the
code, I found the following ones:

* hrtimer_forward_now() was added with kernel 2.6.25 only:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=5e05ad7d4e3b11f935998882b5d9c3b257137f1b
But this is an inline function, so I presume this shouldn't be too
difficult to add to a compatibility header.

* Before 2.6.21, HRTIMER_MODE_REL was named HRTIMER_REL:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=c9cb2e3d7c9178ab75d0942f96abb3abe0369906
This too should be solvable in a compatibility header.

The rest doesn't seem to cause compatibility issues, but only actual
testing would confirm that.

This bug affects me, which is why I am motivated to get this fix
upstream. Please let me know how I can help.

 linux/drivers/media/video/cx88/cx88-input.c |   37 ++++++++++++---------------
 1 file changed, 17 insertions(+), 20 deletions(-)

--- v4l-dvb.orig/linux/drivers/media/video/cx88/cx88-input.c	2009-07-02 15:13:08.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/cx88/cx88-input.c	2009-07-02 15:35:04.000000000 +0200
@@ -23,10 +23,10 @@
  */
 
 #include <linux/init.h>
-#include <linux/delay.h>
 #include <linux/input.h>
 #include <linux/pci.h>
 #include <linux/module.h>
+#include <linux/hrtimer.h>
 
 #include "compat.h"
 #include "cx88.h"
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
+enum hrtimer_restart cx88_ir_work(struct hrtimer *timer)
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


-- 
Jean Delvare
