Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.wp.pl ([212.77.101.5]:47593 "EHLO mx1.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753587AbZFDQtf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Jun 2009 12:49:35 -0400
Received: from chello084010244108.chello.pl (HELO [84.10.244.108]) (andrzej.hajda@[84.10.244.108])
          (envelope-sender <andrzej.hajda@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with SMTP
          for <linux-media@vger.kernel.org>; 4 Jun 2009 18:49:32 +0200
Message-ID: <4A27FB1C.6080704@wp.pl>
Date: Thu, 04 Jun 2009 18:49:32 +0200
From: AH <andrzej.hajda@wp.pl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] cx88: High resolution timer for Remote Controls
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch solves problem of missed keystrokes on some remote controls,
as reported on http://bugzilla.kernel.org/show_bug.cgi?id=9637 .

---
Signed-off-by: Andrzej Hajda <andrzej.hajda@wp.pl <mailto:andrzej.hajda@wp.pl>>
Acked-by: Jean Delvare <khali@linux-fr.org <mailto:khali@linux-fr.org>>

---
diff -r 315bc4b65b4f linux/drivers/media/video/cx88/cx88-input.c
--- a/linux/drivers/media/video/cx88/cx88-input.c    Sun May 17 12:28:55 
2009 +0000
+++ b/linux/drivers/media/video/cx88/cx88-input.c    Sat May 30 14:16:24 
2009 +0200
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
-    struct delayed_work work;
+    struct hrtimer timer;
     u32 gpio_addr;
     u32 last_gpio;
     u32 mask_keycode;
@@ -144,31 +144,27 @@ static void cx88_ir_handle_key(struct cx
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
-    struct cx88_IR *ir = data;
-#else
-    struct cx88_IR *ir = container_of(work, struct cx88_IR, work.work);
-#endif
+    unsigned long missed;
+    struct cx88_IR *ir = container_of(timer, struct cx88_IR, timer);
 
     cx88_ir_handle_key(ir);
-    schedule_delayed_work(&ir->work, msecs_to_jiffies(ir->polling));
+    missed = hrtimer_forward_now(&ir->timer,
+                     ktime_set(0, ir->polling * 1000000));
+    if (missed > 1)
+        ir_dprintk("Missed ticks %ld\n", missed - 1);
+
+    return HRTIMER_RESTART;
 }
 
 void cx88_ir_start(struct cx88_core *core, struct cx88_IR *ir)
 {
     if (ir->polling) {
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
-        INIT_DELAYED_WORK(&ir->work, cx88_ir_work, ir);
-#else
-        INIT_DELAYED_WORK(&ir->work, cx88_ir_work);
-#endif
-        schedule_delayed_work(&ir->work, 0);
+        hrtimer_init(&ir->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+        ir->timer.function = cx88_ir_work;
+        hrtimer_start(&ir->timer, ktime_set(0, ir->polling * 1000000),
+                  HRTIMER_MODE_REL);
     }
     if (ir->sampling) {
         core->pci_irqmask |= PCI_INT_IR_SMPINT;
@@ -185,7 +181,7 @@ void cx88_ir_stop(struct cx88_core *core
     }
 
     if (ir->polling)
-        cancel_delayed_work_sync(&ir->work);
+        hrtimer_cancel(&ir->timer);
 }
 
 /* 
---------------------------------------------------------------------- */

