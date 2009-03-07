Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:35533 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbZCGKnv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Mar 2009 05:43:51 -0500
Received: from jdelvare.pck.nerim.net ([62.212.121.182] helo=hyperion.delvare)
	by services.gcu-squad.org (GCU Mailer Daemon) with esmtpsa id 1Lfv4c-0000N8-L4
	(TLSv1:AES256-SHA:256)
	(envelope-from <khali@linux-fr.org>)
	for linux-media@vger.kernel.org; Sat, 07 Mar 2009 12:52:10 +0100
Date: Sat, 7 Mar 2009 11:43:43 +0100
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Subject: [PATCH] ir-kbd-i2c: Prevent general protection fault on rmmod
Message-ID: <20090307114343.7e3d795e@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The removal of the timer which polls the infrared input is racy.
Replacing the timer with a delayed work solves the problem.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 linux/drivers/media/video/ir-kbd-i2c.c |   22 ++++++----------------
 linux/include/media/ir-kbd-i2c.h       |    3 +--
 2 files changed, 7 insertions(+), 18 deletions(-)

--- v4l-dvb.orig/linux/drivers/media/video/ir-kbd-i2c.c	2009-03-06 13:59:38.000000000 +0100
+++ v4l-dvb/linux/drivers/media/video/ir-kbd-i2c.c	2009-03-06 14:02:17.000000000 +0100
@@ -280,12 +280,6 @@ static void ir_key_poll(struct IR_i2c *i
 	}
 }
 
-static void ir_timer(unsigned long data)
-{
-	struct IR_i2c *ir = (struct IR_i2c*)data;
-	schedule_work(&ir->work);
-}
-
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
 static void ir_work(void *data)
 #else
@@ -295,7 +289,7 @@ static void ir_work(struct work_struct *
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
 	struct IR_i2c *ir = data;
 #else
-	struct IR_i2c *ir = container_of(work, struct IR_i2c, work);
+	struct IR_i2c *ir = container_of(work, struct IR_i2c, work.work);
 #endif
 	int polling_interval = 100;
 
@@ -305,7 +299,7 @@ static void ir_work(struct work_struct *
 		polling_interval = 50;
 
 	ir_key_poll(ir);
-	mod_timer(&ir->timer, jiffies + msecs_to_jiffies(polling_interval));
+	schedule_delayed_work(&ir->work, msecs_to_jiffies(polling_interval));
 }
 
 /* ----------------------------------------------------------------------- */
@@ -462,14 +456,11 @@ static int ir_attach(struct i2c_adapter
 
 	/* start polling via eventd */
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
-	INIT_WORK(&ir->work, ir_work, ir);
+	INIT_DELAYED_WORK(&ir->work, ir_work, ir);
 #else
-	INIT_WORK(&ir->work, ir_work);
+	INIT_DELAYED_WORK(&ir->work, ir_work);
 #endif
-	init_timer(&ir->timer);
-	ir->timer.function = ir_timer;
-	ir->timer.data     = (unsigned long)ir;
-	schedule_work(&ir->work);
+	schedule_delayed_work(&ir->work, 0);
 
 	return 0;
 
@@ -486,8 +477,7 @@ static int ir_detach(struct i2c_client *
 	struct IR_i2c *ir = i2c_get_clientdata(client);
 
 	/* kill outstanding polls */
-	del_timer_sync(&ir->timer);
-	flush_scheduled_work();
+	cancel_delayed_work_sync(&ir->work);
 
 	/* unregister devices */
 	input_unregister_device(ir->input);
--- v4l-dvb.orig/linux/include/media/ir-kbd-i2c.h	2009-03-06 13:59:38.000000000 +0100
+++ v4l-dvb/linux/include/media/ir-kbd-i2c.h	2009-03-06 14:01:47.000000000 +0100
@@ -14,8 +14,7 @@ struct IR_i2c {
 	/* Used to avoid fast repeating */
 	unsigned char          old;
 
-	struct work_struct     work;
-	struct timer_list      timer;
+	struct delayed_work    work;
 	char                   phys[32];
 	int                    (*get_key)(struct IR_i2c*, u32*, u32*);
 };


-- 
Jean Delvare
