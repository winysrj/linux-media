Return-path: <mchehab@pedra>
Received: from queueout02-winn.ispmail.ntl.com ([81.103.221.56]:63822 "EHLO
	queueout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757335Ab0IXS2X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Sep 2010 14:28:23 -0400
From: Daniel Drake <dsd@laptop.org>
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org
Cc: corbet@lwn.net
Subject: [PATCH 1/4] cafe_ccic: Fix hang in command write processing
Message-Id: <20100924171717.B3A969D401B@zog.reactivated.net>
Date: Fri, 24 Sep 2010 18:17:17 +0100 (BST)
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch, which basically reverts 6d77444ac, fixes an occasional
on-boot or on-capture hang on the XO-1 laptop.

It seems like the cafe hardware is flakier than we thought and that in
some cases, the commands get executed but are never reported as completed
(even if we substantially increase the delays before reading registers).

Reintroduce the 1-second CAFE_SMBUS_TIMEOUT to catch and avoid this
strange hardware bug.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/media/video/cafe_ccic.c |   36 +++++++++++++++++-------------------
 1 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/drivers/media/video/cafe_ccic.c b/drivers/media/video/cafe_ccic.c
index be35e69..8ddd2b6 100644
--- a/drivers/media/video/cafe_ccic.c
+++ b/drivers/media/video/cafe_ccic.c
@@ -319,7 +319,6 @@ static int cafe_smbus_write_data(struct cafe_camera *cam,
 {
 	unsigned int rval;
 	unsigned long flags;
-	DEFINE_WAIT(the_wait);
 
 	spin_lock_irqsave(&cam->dev_lock, flags);
 	rval = TWSIC0_EN | ((addr << TWSIC0_SID_SHIFT) & TWSIC0_SID);
@@ -334,28 +333,27 @@ static int cafe_smbus_write_data(struct cafe_camera *cam,
 	cafe_reg_write(cam, REG_TWSIC1, rval);
 	spin_unlock_irqrestore(&cam->dev_lock, flags);
 
+	/* Unfortunately, reading TWSIC1 too soon after sending a command
+	 * causes the device to die.
+	 * Use a busy-wait because we often send a large quantity of small
+	 * commands at-once; using msleep() would cause a lot of context
+	 * switches which take longer than 2ms, resulting in a noticable
+	 * boot-time and capture-start delays.
+	 */
+	mdelay(2);
+
 	/*
-	 * Time to wait for the write to complete.  THIS IS A RACY
-	 * WAY TO DO IT, but the sad fact is that reading the TWSIC1
-	 * register too quickly after starting the operation sends
-	 * the device into a place that may be kinder and better, but
-	 * which is absolutely useless for controlling the sensor.  In
-	 * practice we have plenty of time to get into our sleep state
-	 * before the interrupt hits, and the worst case is that we
-	 * time out and then see that things completed, so this seems
-	 * the best way for now.
+	 * Another sad fact is that sometimes, commands silently complete but
+	 * cafe_smbus_write_done() never becomes aware of this.
+	 * This happens at random and appears to possible occur with any
+	 * command.
+	 * We don't understand why this is. We work around this issue
+	 * with the timeout in the wait below, assuming that all commands
+	 * complete within the timeout.
 	 */
-	do {
-		prepare_to_wait(&cam->smbus_wait, &the_wait,
-				TASK_UNINTERRUPTIBLE);
-		schedule_timeout(1); /* even 1 jiffy is too long */
-		finish_wait(&cam->smbus_wait, &the_wait);
-	} while (!cafe_smbus_write_done(cam));
-
-#ifdef IF_THE_CAFE_HARDWARE_WORKED_RIGHT
 	wait_event_timeout(cam->smbus_wait, cafe_smbus_write_done(cam),
 			CAFE_SMBUS_TIMEOUT);
-#endif
+
 	spin_lock_irqsave(&cam->dev_lock, flags);
 	rval = cafe_reg_read(cam, REG_TWSIC1);
 	spin_unlock_irqrestore(&cam->dev_lock, flags);
-- 
1.7.2.2

