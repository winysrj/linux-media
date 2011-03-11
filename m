Return-path: <mchehab@pedra>
Received: from mailout1.samsung.com ([203.254.224.24]:35393 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab1CKGyz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2011 01:54:55 -0500
Received: from epmmp2 (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LHV002I9SJE19D0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 11 Mar 2011 15:54:50 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LHV00IINSJED5@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 11 Mar 2011 15:54:51 +0900 (KST)
Date: Fri, 11 Mar 2011 15:54:48 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: [PATCH 3/3] radio-si470x: convert to use request_threaded_irq()
In-reply-to: <1299826488-20506-1-git-send-email-jy0922.shim@samsung.com>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, tobias.lorenz@gmx.net,
	kyungmin.park@samsung.com
Message-id: <1299826488-20506-3-git-send-email-jy0922.shim@samsung.com>
Content-transfer-encoding: 7BIT
References: <1299826488-20506-1-git-send-email-jy0922.shim@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
---
 drivers/media/radio/si470x/radio-si470x-i2c.c |   32 +++++++------------------
 drivers/media/radio/si470x/radio-si470x.h     |    1 -
 2 files changed, 9 insertions(+), 24 deletions(-)

diff --git a/drivers/media/radio/si470x/radio-si470x-i2c.c b/drivers/media/radio/si470x/radio-si470x-i2c.c
index 92ce10d..53d9327 100644
--- a/drivers/media/radio/si470x/radio-si470x-i2c.c
+++ b/drivers/media/radio/si470x/radio-si470x-i2c.c
@@ -262,12 +262,11 @@ int si470x_vidioc_querycap(struct file *file, void *priv,
  **************************************************************************/
 
 /*
- * si470x_i2c_interrupt_work - rds processing function
+ * si470x_i2c_interrupt - interrupt handler
  */
-static void si470x_i2c_interrupt_work(struct work_struct *work)
+static irqreturn_t si470x_i2c_interrupt(int irq, void *dev_id)
 {
-	struct si470x_device *radio = container_of(work,
-			struct si470x_device, radio_work);
+	struct si470x_device *radio = dev_id;
 	unsigned char regnr;
 	unsigned char blocknum;
 	unsigned short bler; /* rds block errors */
@@ -278,26 +277,26 @@ static void si470x_i2c_interrupt_work(struct work_struct *work)
 	/* check Seek/Tune Complete */
 	retval = si470x_get_register(radio, STATUSRSSI);
 	if (retval < 0)
-		return;
+		goto end;
 
 	if (radio->registers[STATUSRSSI] & STATUSRSSI_STC)
 		complete(&radio->completion);
 
 	/* safety checks */
 	if ((radio->registers[SYSCONFIG1] & SYSCONFIG1_RDS) == 0)
-		return;
+		goto end;
 
 	/* Update RDS registers */
 	for (regnr = 1; regnr < RDS_REGISTER_NUM; regnr++) {
 		retval = si470x_get_register(radio, STATUSRSSI + regnr);
 		if (retval < 0)
-			return;
+			goto end;
 	}
 
 	/* get rds blocks */
 	if ((radio->registers[STATUSRSSI] & STATUSRSSI_RDSR) == 0)
 		/* No RDS group ready, better luck next time */
-		return;
+		goto end;
 
 	for (blocknum = 0; blocknum < 4; blocknum++) {
 		switch (blocknum) {
@@ -351,19 +350,8 @@ static void si470x_i2c_interrupt_work(struct work_struct *work)
 
 	if (radio->wr_index != radio->rd_index)
 		wake_up_interruptible(&radio->read_queue);
-}
-
-
-/*
- * si470x_i2c_interrupt - interrupt handler
- */
-static irqreturn_t si470x_i2c_interrupt(int irq, void *dev_id)
-{
-	struct si470x_device *radio = dev_id;
-
-	if (!work_pending(&radio->radio_work))
-		schedule_work(&radio->radio_work);
 
+end:
 	return IRQ_HANDLED;
 }
 
@@ -385,7 +373,6 @@ static int __devinit si470x_i2c_probe(struct i2c_client *client,
 		goto err_initial;
 	}
 
-	INIT_WORK(&radio->radio_work, si470x_i2c_interrupt_work);
 	radio->users = 0;
 	radio->client = client;
 	mutex_init(&radio->lock);
@@ -454,7 +441,7 @@ static int __devinit si470x_i2c_probe(struct i2c_client *client,
 	radio->stci_enabled = true;
 	init_completion(&radio->completion);
 
-	retval = request_irq(client->irq, si470x_i2c_interrupt,
+	retval = request_threaded_irq(client->irq, NULL, si470x_i2c_interrupt,
 			IRQF_TRIGGER_FALLING, DRIVER_NAME, radio);
 	if (retval) {
 		dev_err(&client->dev, "Failed to register interrupt\n");
@@ -492,7 +479,6 @@ static __devexit int si470x_i2c_remove(struct i2c_client *client)
 	struct si470x_device *radio = i2c_get_clientdata(client);
 
 	free_irq(client->irq, radio);
-	cancel_work_sync(&radio->radio_work);
 	video_unregister_device(radio->videodev);
 	kfree(radio);
 
diff --git a/drivers/media/radio/si470x/radio-si470x.h b/drivers/media/radio/si470x/radio-si470x.h
index 9ef6716..68da001 100644
--- a/drivers/media/radio/si470x/radio-si470x.h
+++ b/drivers/media/radio/si470x/radio-si470x.h
@@ -182,7 +182,6 @@ struct si470x_device {
 
 #if defined(CONFIG_I2C_SI470X) || defined(CONFIG_I2C_SI470X_MODULE)
 	struct i2c_client *client;
-	struct work_struct radio_work;
 #endif
 };
 
-- 
1.7.0.4

