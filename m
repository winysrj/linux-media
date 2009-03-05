Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:47719 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbZCEJig (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Mar 2009 04:38:36 -0500
Received: from jdelvare.pck.nerim.net ([62.212.121.182] helo=hyperion.delvare)
	by services.gcu-squad.org (GCU Mailer Daemon) with esmtpsa id 1LfB6G-00011w-3z
	(TLSv1:AES256-SHA:256)
	(envelope-from <khali@linux-fr.org>)
	for linux-media@vger.kernel.org; Thu, 05 Mar 2009 11:46:48 +0100
Date: Thu, 5 Mar 2009 10:38:24 +0100
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Subject: [PATCH] cx88: Prevent general protection fault on rmmod
Message-ID: <20090305103824.351d0110@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jean Delvare <khali@linux-fr.org>
Subject: cx88: Prevent general protection fault on rmmod

When unloading the cx8800 driver I sometimes get a general protection
fault. Analysis revealed a race in cx88_ir_stop(). It can be solved by
using a delayed work instead of a timer for infrared input polling.

This fixes kernel.org bug #12802.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 linux/drivers/media/video/cx88/cx88-input.c |   25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

--- v4l-dvb.orig/linux/drivers/media/video/cx88/cx88-input.c	2009-03-04 09:52:20.000000000 +0100
+++ v4l-dvb/linux/drivers/media/video/cx88/cx88-input.c	2009-03-04 19:03:17.000000000 +0100
@@ -49,8 +49,12 @@ struct cx88_IR {
 
 	/* poll external decoder */
 	int polling;
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
 	struct work_struct work;
 	struct timer_list timer;
+#else
+	struct delayed_work work;
+#endif
 	u32 gpio_addr;
 	u32 last_gpio;
 	u32 mask_keycode;
@@ -144,6 +148,7 @@ static void cx88_ir_handle_key(struct cx
 	}
 }
 
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
 static void ir_timer(unsigned long data)
 {
 	struct cx88_IR *ir = (struct cx88_IR *)data;
@@ -151,7 +156,6 @@ static void ir_timer(unsigned long data)
 	schedule_work(&ir->work);
 }
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
 static void cx88_ir_work(void *data)
 #else
 static void cx88_ir_work(struct work_struct *work)
@@ -160,23 +164,30 @@ static void cx88_ir_work(struct work_str
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
 	struct cx88_IR *ir = data;
 #else
-	struct cx88_IR *ir = container_of(work, struct cx88_IR, work);
+	struct delayed_work *dwork = container_of(work, struct delayed_work,
+						  work);
+	struct cx88_IR *ir = container_of(dwork, struct cx88_IR, work);
 #endif
 
 	cx88_ir_handle_key(ir);
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
 	mod_timer(&ir->timer, jiffies + msecs_to_jiffies(ir->polling));
+#else
+	schedule_delayed_work(dwork, msecs_to_jiffies(ir->polling));
+#endif
 }
 
 void cx88_ir_start(struct cx88_core *core, struct cx88_IR *ir)
 {
 	if (ir->polling) {
-		setup_timer(&ir->timer, ir_timer, (unsigned long)ir);
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
+		setup_timer(&ir->timer, ir_timer, (unsigned long)ir);
 		INIT_WORK(&ir->work, cx88_ir_work, ir);
+		schedule_work(&ir->work);
 #else
-		INIT_WORK(&ir->work, cx88_ir_work);
+		INIT_DELAYED_WORK(&ir->work, cx88_ir_work);
+		schedule_delayed_work(&ir->work, msecs_to_jiffies(ir->polling));
 #endif
-		schedule_work(&ir->work);
 	}
 	if (ir->sampling) {
 		core->pci_irqmask |= PCI_INT_IR_SMPINT;
@@ -193,8 +204,12 @@ void cx88_ir_stop(struct cx88_core *core
 	}
 
 	if (ir->polling) {
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
 		del_timer_sync(&ir->timer);
 		flush_scheduled_work();
+#else
+		cancel_delayed_work_sync(&ir->work);
+#endif
 	}
 }
 


-- 
Jean Delvare
