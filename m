Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:41340 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbZCGKnK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Mar 2009 05:43:10 -0500
Date: Sat, 7 Mar 2009 11:43:01 +0100
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Cc: Devin Heitmueller <devin.heitmueller@gmail.com>
Subject: [PATCH] em28xx: Prevent general protection fault on rmmod
Message-ID: <20090307114301.1d4a12f6@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The removal of the timer which polls the infrared input is racy.
Replacing the timer with a delayed work solves the problem.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Devin Heitmueller <devin.heitmueller@gmail.com>
---
 linux/drivers/media/video/em28xx/em28xx-input.c |   24 ++++++-----------------
 1 file changed, 7 insertions(+), 17 deletions(-)

--- v4l-dvb.orig/linux/drivers/media/video/em28xx/em28xx-input.c	2009-03-06 13:59:37.000000000 +0100
+++ v4l-dvb/linux/drivers/media/video/em28xx/em28xx-input.c	2009-03-06 14:02:35.000000000 +0100
@@ -69,8 +69,7 @@ struct em28xx_IR {
 
 	/* poll external decoder */
 	int polling;
-	struct work_struct work;
-	struct timer_list timer;
+	struct delayed_work work;
 	unsigned int last_toggle:1;
 	unsigned int last_readcount;
 	unsigned int repeat_interval;
@@ -298,13 +297,6 @@ static void em28xx_ir_handle_key(struct
 	return;
 }
 
-static void ir_timer(unsigned long data)
-{
-	struct em28xx_IR *ir = (struct em28xx_IR *)data;
-
-	schedule_work(&ir->work);
-}
-
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 20)
 static void em28xx_ir_work(void *data)
 #else
@@ -314,28 +306,26 @@ static void em28xx_ir_work(struct work_s
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 20)
 	struct em28xx_IR *ir = data;
 #else
-	struct em28xx_IR *ir = container_of(work, struct em28xx_IR, work);
+	struct em28xx_IR *ir = container_of(work, struct em28xx_IR, work.work);
 #endif
 
 	em28xx_ir_handle_key(ir);
-	mod_timer(&ir->timer, jiffies + msecs_to_jiffies(ir->polling));
+	schedule_delayed_work(&ir->work, msecs_to_jiffies(ir->polling));
 }
 
 static void em28xx_ir_start(struct em28xx_IR *ir)
 {
-	setup_timer(&ir->timer, ir_timer, (unsigned long)ir);
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 20)
-	INIT_WORK(&ir->work, em28xx_ir_work, ir);
+	INIT_DELAYED_WORK(&ir->work, em28xx_ir_work, ir);
 #else
-	INIT_WORK(&ir->work, em28xx_ir_work);
+	INIT_DELAYED_WORK(&ir->work, em28xx_ir_work);
 #endif
-	schedule_work(&ir->work);
+	schedule_delayed_work(&ir->work, 0);
 }
 
 static void em28xx_ir_stop(struct em28xx_IR *ir)
 {
-	del_timer_sync(&ir->timer);
-	flush_scheduled_work();
+	cancel_delayed_work_sync(&ir->work);
 }
 
 int em28xx_ir_init(struct em28xx *dev)


-- 
Jean Delvare
