Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:15433 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554AbZCGKoU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Mar 2009 05:44:20 -0500
Received: from jdelvare.pck.nerim.net ([62.212.121.182] helo=hyperion.delvare)
	by services.gcu-squad.org (GCU Mailer Daemon) with esmtpsa id 1Lfv55-00005S-7c
	(TLSv1:AES256-SHA:256)
	(envelope-from <khali@linux-fr.org>)
	for linux-media@vger.kernel.org; Sat, 07 Mar 2009 12:52:39 +0100
Date: Sat, 7 Mar 2009 11:44:12 +0100
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Subject: [PATCH] saa6588: Prevent general protection fault on rmmod
Message-ID: <20090307114412.265d6991@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The removal of the timer which polls the infrared input is racy.
Replacing the timer with a delayed work solves the problem.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 linux/drivers/media/video/saa6588.c |   26 +++++++-------------------
 1 file changed, 7 insertions(+), 19 deletions(-)

--- v4l-dvb.orig/linux/drivers/media/video/saa6588.c	2009-03-06 13:59:37.000000000 +0100
+++ v4l-dvb/linux/drivers/media/video/saa6588.c	2009-03-06 14:02:50.000000000 +0100
@@ -77,8 +77,7 @@ MODULE_LICENSE("GPL");
 
 struct saa6588 {
 	struct v4l2_subdev sd;
-	struct work_struct work;
-	struct timer_list timer;
+	struct delayed_work work;
 	spinlock_t lock;
 	unsigned char *buffer;
 	unsigned int buf_size;
@@ -323,13 +322,6 @@ static void saa6588_i2c_poll(struct saa6
 	wake_up_interruptible(&s->read_queue);
 }
 
-static void saa6588_timer(unsigned long data)
-{
-	struct saa6588 *s = (struct saa6588 *)data;
-
-	schedule_work(&s->work);
-}
-
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
 static void saa6588_work(void *data)
 #else
@@ -339,11 +331,11 @@ static void saa6588_work(struct work_str
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
 	struct saa6588 *s = (struct saa6588 *)data;
 #else
-	struct saa6588 *s = container_of(work, struct saa6588, work);
+	struct saa6588 *s = container_of(work, struct saa6588, work.work);
 #endif
 
 	saa6588_i2c_poll(s);
-	mod_timer(&s->timer, jiffies + msecs_to_jiffies(20));
+	schedule_delayed_work(&s->work, msecs_to_jiffies(20));
 }
 
 static int saa6588_configure(struct saa6588 *s)
@@ -500,14 +492,11 @@ static int saa6588_probe(struct i2c_clie
 
 	/* start polling via eventd */
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 20)
-	INIT_WORK(&s->work, saa6588_work, s);
+	INIT_DELAYED_WORK(&s->work, saa6588_work, s);
 #else
-	INIT_WORK(&s->work, saa6588_work);
+	INIT_DELAYED_WORK(&s->work, saa6588_work);
 #endif
-	init_timer(&s->timer);
-	s->timer.function = saa6588_timer;
-	s->timer.data = (unsigned long)s;
-	schedule_work(&s->work);
+	schedule_delayed_work(&s->work, 0);
 	return 0;
 }
 
@@ -518,8 +507,7 @@ static int saa6588_remove(struct i2c_cli
 
 	v4l2_device_unregister_subdev(sd);
 
-	del_timer_sync(&s->timer);
-	flush_scheduled_work();
+	cancel_delayed_work_sync(&s->work);
 
 	kfree(s->buffer);
 	kfree(s);


-- 
Jean Delvare
