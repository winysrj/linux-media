Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:37605 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbZCGKmX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Mar 2009 05:42:23 -0500
Date: Sat, 7 Mar 2009 11:42:12 +0100
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Cc: Trent Piepho <xyzzy@speakeasy.org>
Subject: [PATCH] cx88: Prevent general protection fault on rmmod
Message-ID: <20090307114212.1cdd70f2@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When unloading the cx8800 driver I sometimes get a general protection
fault. Analysis revealed a race in cx88_ir_stop(). It can be solved by
using a delayed work instead of a timer for infrared input polling.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
Thanks to Trent's compatibility patches, we can go without the bunch of
#ifdef's my initial patch had.

 linux/drivers/media/video/cx88/cx88-input.c |   27 ++++++++-------------------
 1 file changed, 8 insertions(+), 19 deletions(-)

--- v4l-dvb.orig/linux/drivers/media/video/cx88/cx88-input.c	2009-03-05 10:36:23.000000000 +0100
+++ v4l-dvb/linux/drivers/media/video/cx88/cx88-input.c	2009-03-06 13:59:56.000000000 +0100
@@ -49,8 +49,7 @@ struct cx88_IR {
 
 	/* poll external decoder */
 	int polling;
-	struct work_struct work;
-	struct timer_list timer;
+	struct delayed_work work;
 	u32 gpio_addr;
 	u32 last_gpio;
 	u32 mask_keycode;
@@ -144,13 +143,6 @@ static void cx88_ir_handle_key(struct cx
 	}
 }
 
-static void ir_timer(unsigned long data)
-{
-	struct cx88_IR *ir = (struct cx88_IR *)data;
-
-	schedule_work(&ir->work);
-}
-
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
 static void cx88_ir_work(void *data)
 #else
@@ -160,23 +152,22 @@ static void cx88_ir_work(struct work_str
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
 	struct cx88_IR *ir = data;
 #else
-	struct cx88_IR *ir = container_of(work, struct cx88_IR, work);
+	struct cx88_IR *ir = container_of(work, struct cx88_IR, work.work);
 #endif
 
 	cx88_ir_handle_key(ir);
-	mod_timer(&ir->timer, jiffies + msecs_to_jiffies(ir->polling));
+	schedule_delayed_work(&ir->work, msecs_to_jiffies(ir->polling));
 }
 
 void cx88_ir_start(struct cx88_core *core, struct cx88_IR *ir)
 {
 	if (ir->polling) {
-		setup_timer(&ir->timer, ir_timer, (unsigned long)ir);
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
-		INIT_WORK(&ir->work, cx88_ir_work, ir);
+		INIT_DELAYED_WORK(&ir->work, cx88_ir_work, ir);
 #else
-		INIT_WORK(&ir->work, cx88_ir_work);
+		INIT_DELAYED_WORK(&ir->work, cx88_ir_work);
 #endif
-		schedule_work(&ir->work);
+		schedule_delayed_work(&ir->work, 0);
 	}
 	if (ir->sampling) {
 		core->pci_irqmask |= PCI_INT_IR_SMPINT;
@@ -192,10 +183,8 @@ void cx88_ir_stop(struct cx88_core *core
 		core->pci_irqmask &= ~PCI_INT_IR_SMPINT;
 	}
 
-	if (ir->polling) {
-		del_timer_sync(&ir->timer);
-		flush_scheduled_work();
-	}
+	if (ir->polling)
+		cancel_delayed_work_sync(&ir->work);
 }
 
 /* ---------------------------------------------------------------------- */


-- 
Jean Delvare
