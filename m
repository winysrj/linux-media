Return-path: <mchehab@pedra>
Received: from mailout1.samsung.com ([203.254.224.24]:35393 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab1CKGyx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2011 01:54:53 -0500
Received: from epmmp2 (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LHV002I9SJE19D0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 11 Mar 2011 15:54:50 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LHV00IINSJED5@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 11 Mar 2011 15:54:51 +0900 (KST)
Date: Fri, 11 Mar 2011 15:54:46 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: [PATCH 1/3] radio-si470x: support seek and tune interrupt enable
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, tobias.lorenz@gmx.net,
	kyungmin.park@samsung.com
Message-id: <1299826488-20506-1-git-send-email-jy0922.shim@samsung.com>
Content-transfer-encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Currently we use busy waiting to seek and tune, it can replace to
interrupt way. SI470X I2C driver supports interrupt way to week and tune
via this patch.

Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
---
 drivers/media/radio/si470x/radio-si470x-common.c |   60 +++++++++++++++-------
 drivers/media/radio/si470x/radio-si470x-i2c.c    |   17 +++++-
 drivers/media/radio/si470x/radio-si470x.h        |    3 +
 3 files changed, 60 insertions(+), 20 deletions(-)

diff --git a/drivers/media/radio/si470x/radio-si470x-common.c b/drivers/media/radio/si470x/radio-si470x-common.c
index 60c176f..0a5d83d 100644
--- a/drivers/media/radio/si470x/radio-si470x-common.c
+++ b/drivers/media/radio/si470x/radio-si470x-common.c
@@ -174,15 +174,27 @@ static int si470x_set_chan(struct si470x_device *radio, unsigned short chan)
 	if (retval < 0)
 		goto done;
 
-	/* wait till tune operation has completed */
-	timeout = jiffies + msecs_to_jiffies(tune_timeout);
-	do {
-		retval = si470x_get_register(radio, STATUSRSSI);
-		if (retval < 0)
-			goto stop;
-		timed_out = time_after(jiffies, timeout);
-	} while (((radio->registers[STATUSRSSI] & STATUSRSSI_STC) == 0) &&
-		(!timed_out));
+	/* currently I2C driver only uses interrupt way to tune */
+	if (radio->stci_enabled) {
+		INIT_COMPLETION(radio->completion);
+
+		/* wait till tune operation has completed */
+		retval = wait_for_completion_timeout(&radio->completion,
+				msecs_to_jiffies(tune_timeout));
+		if (!retval)
+			timed_out = true;
+	} else {
+		/* wait till tune operation has completed */
+		timeout = jiffies + msecs_to_jiffies(tune_timeout);
+		do {
+			retval = si470x_get_register(radio, STATUSRSSI);
+			if (retval < 0)
+				goto stop;
+			timed_out = time_after(jiffies, timeout);
+		} while (((radio->registers[STATUSRSSI] & STATUSRSSI_STC) == 0)
+				&& (!timed_out));
+	}
+
 	if ((radio->registers[STATUSRSSI] & STATUSRSSI_STC) == 0)
 		dev_warn(&radio->videodev->dev, "tune does not complete\n");
 	if (timed_out)
@@ -310,15 +322,27 @@ static int si470x_set_seek(struct si470x_device *radio,
 	if (retval < 0)
 		goto done;
 
-	/* wait till seek operation has completed */
-	timeout = jiffies + msecs_to_jiffies(seek_timeout);
-	do {
-		retval = si470x_get_register(radio, STATUSRSSI);
-		if (retval < 0)
-			goto stop;
-		timed_out = time_after(jiffies, timeout);
-	} while (((radio->registers[STATUSRSSI] & STATUSRSSI_STC) == 0) &&
-		(!timed_out));
+	/* currently I2C driver only uses interrupt way to seek */
+	if (radio->stci_enabled) {
+		INIT_COMPLETION(radio->completion);
+
+		/* wait till seek operation has completed */
+		retval = wait_for_completion_timeout(&radio->completion,
+				msecs_to_jiffies(seek_timeout));
+		if (!retval)
+			timed_out = true;
+	} else {
+		/* wait till seek operation has completed */
+		timeout = jiffies + msecs_to_jiffies(seek_timeout);
+		do {
+			retval = si470x_get_register(radio, STATUSRSSI);
+			if (retval < 0)
+				goto stop;
+			timed_out = time_after(jiffies, timeout);
+		} while (((radio->registers[STATUSRSSI] & STATUSRSSI_STC) == 0)
+				&& (!timed_out));
+	}
+
 	if ((radio->registers[STATUSRSSI] & STATUSRSSI_STC) == 0)
 		dev_warn(&radio->videodev->dev, "seek does not complete\n");
 	if (radio->registers[STATUSRSSI] & STATUSRSSI_SF)
diff --git a/drivers/media/radio/si470x/radio-si470x-i2c.c b/drivers/media/radio/si470x/radio-si470x-i2c.c
index 4ce541a..81b0a1a 100644
--- a/drivers/media/radio/si470x/radio-si470x-i2c.c
+++ b/drivers/media/radio/si470x/radio-si470x-i2c.c
@@ -197,8 +197,9 @@ int si470x_fops_open(struct file *file)
 		if (retval < 0)
 			goto done;
 
-		/* enable RDS interrupt */
+		/* enable RDS / STC interrupt */
 		radio->registers[SYSCONFIG1] |= SYSCONFIG1_RDSIEN;
+		radio->registers[SYSCONFIG1] |= SYSCONFIG1_STCIEN;
 		radio->registers[SYSCONFIG1] &= ~SYSCONFIG1_GPIO2;
 		radio->registers[SYSCONFIG1] |= 0x1 << 2;
 		retval = si470x_set_register(radio, SYSCONFIG1);
@@ -274,12 +275,20 @@ static void si470x_i2c_interrupt_work(struct work_struct *work)
 	unsigned char tmpbuf[3];
 	int retval = 0;
 
+	/* check Seek/Tune Complete */
+	retval = si470x_get_register(radio, STATUSRSSI);
+	if (retval < 0)
+		return;
+
+	if (radio->registers[STATUSRSSI] & STATUSRSSI_STC)
+		complete(&radio->completion);
+
 	/* safety checks */
 	if ((radio->registers[SYSCONFIG1] & SYSCONFIG1_RDS) == 0)
 		return;
 
 	/* Update RDS registers */
-	for (regnr = 0; regnr < RDS_REGISTER_NUM; regnr++) {
+	for (regnr = 1; regnr < RDS_REGISTER_NUM; regnr++) {
 		retval = si470x_get_register(radio, STATUSRSSI + regnr);
 		if (retval < 0)
 			return;
@@ -441,6 +450,10 @@ static int __devinit si470x_i2c_probe(struct i2c_client *client,
 	radio->rd_index = 0;
 	init_waitqueue_head(&radio->read_queue);
 
+	/* mark Seek/Tune Complete Interrupt enabled */
+	radio->stci_enabled = true;
+	init_completion(&radio->completion);
+
 	retval = request_irq(client->irq, si470x_i2c_interrupt,
 			IRQF_TRIGGER_FALLING, DRIVER_NAME, radio);
 	if (retval) {
diff --git a/drivers/media/radio/si470x/radio-si470x.h b/drivers/media/radio/si470x/radio-si470x.h
index 4a4e908..9ef6716 100644
--- a/drivers/media/radio/si470x/radio-si470x.h
+++ b/drivers/media/radio/si470x/radio-si470x.h
@@ -158,6 +158,9 @@ struct si470x_device {
 	unsigned int rd_index;
 	unsigned int wr_index;
 
+	struct completion completion;
+	bool stci_enabled;		/* Seek/Tune Complete Interrupt */
+
 #if defined(CONFIG_USB_SI470X) || defined(CONFIG_USB_SI470X_MODULE)
 	/* reference to USB and video device */
 	struct usb_device *usbdev;
-- 
1.7.0.4

