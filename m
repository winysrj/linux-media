Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:51029 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821AbZLCM5U (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Dec 2009 07:57:20 -0500
Received: from epmmp2 (mailout3.samsung.com [203.254.224.33])
 by mailout1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KU200E5JUNP5E@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 03 Dec 2009 21:57:25 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0KU200DYXUNQCP@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 03 Dec 2009 21:57:26 +0900 (KST)
Date: Thu, 03 Dec 2009 21:57:27 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: [PATCH v2 2/3] radio-si470x: support RDS on si470x i2c driver
To: linux-media@vger.kernel.org
Cc: tobias.lorenz@gmx.net, kyungmin.park@samsung.com
Message-id: <4B17B5B7.8070300@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch is to support RDS on si470x i2c driver. The routine of RDS
operation is almost same with thing of usb driver, but this uses RDS
interrupt.

Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
---
 drivers/media/radio/si470x/radio-si470x-i2c.c |  164 +++++++++++++++++++++++--
 drivers/media/radio/si470x/radio-si470x.h     |    1 +
 2 files changed, 155 insertions(+), 10 deletions(-)

diff --git a/drivers/media/radio/si470x/radio-si470x-i2c.c b/drivers/media/radio/si470x/radio-si470x-i2c.c
index 6a40db8..5466015 100644
--- a/drivers/media/radio/si470x/radio-si470x-i2c.c
+++ b/drivers/media/radio/si470x/radio-si470x-i2c.c
@@ -22,22 +22,17 @@
  */
 
 
-/*
- * ToDo:
- * - RDS support
- */
-
-
 /* driver definitions */
 #define DRIVER_AUTHOR "Joonyoung Shim <jy0922.shim@samsung.com>";
-#define DRIVER_KERNEL_VERSION KERNEL_VERSION(1, 0, 0)
+#define DRIVER_KERNEL_VERSION KERNEL_VERSION(1, 0, 1)
 #define DRIVER_CARD "Silicon Labs Si470x FM Radio Receiver"
 #define DRIVER_DESC "I2C radio driver for Si470x FM Radio Receivers"
-#define DRIVER_VERSION "1.0.0"
+#define DRIVER_VERSION "1.0.1"
 
 /* kernel includes */
 #include <linux/i2c.h>
 #include <linux/delay.h>
+#include <linux/interrupt.h>
 
 #include "radio-si470x.h"
 
@@ -62,6 +57,20 @@ static int radio_nr = -1;
 module_param(radio_nr, int, 0444);
 MODULE_PARM_DESC(radio_nr, "Radio Nr");
 
+/* RDS buffer blocks */
+static unsigned int rds_buf = 100;
+module_param(rds_buf, uint, 0444);
+MODULE_PARM_DESC(rds_buf, "RDS buffer entries: *100*");
+
+/* RDS maximum block errors */
+static unsigned short max_rds_errors = 1;
+/* 0 means   0  errors requiring correction */
+/* 1 means 1-2  errors requiring correction (used by original USBRadio.exe) */
+/* 2 means 3-5  errors requiring correction */
+/* 3 means   6+ errors or errors in checkword, correction not possible */
+module_param(max_rds_errors, ushort, 0644);
+MODULE_PARM_DESC(max_rds_errors, "RDS maximum block errors: *1*");
+
 
 
 /**************************************************************************
@@ -181,12 +190,21 @@ int si470x_fops_open(struct file *file)
 	mutex_lock(&radio->lock);
 	radio->users++;
 
-	if (radio->users == 1)
+	if (radio->users == 1) {
 		/* start radio */
 		retval = si470x_start(radio);
+		if (retval < 0)
+			goto done;
+
+		/* enable RDS interrupt */
+		radio->registers[SYSCONFIG1] |= SYSCONFIG1_RDSIEN;
+		radio->registers[SYSCONFIG1] &= ~SYSCONFIG1_GPIO2;
+		radio->registers[SYSCONFIG1] |= 0x1 << 2;
+		retval = si470x_set_register(radio, SYSCONFIG1);
+	}
 
+done:
 	mutex_unlock(&radio->lock);
-
 	return retval;
 }
 
@@ -242,6 +260,105 @@ int si470x_vidioc_querycap(struct file *file, void *priv,
  **************************************************************************/
 
 /*
+ * si470x_i2c_interrupt_work - rds processing function
+ */
+static void si470x_i2c_interrupt_work(struct work_struct *work)
+{
+	struct si470x_device *radio = container_of(work,
+			struct si470x_device, radio_work);
+	unsigned char regnr;
+	unsigned char blocknum;
+	unsigned short bler; /* rds block errors */
+	unsigned short rds;
+	unsigned char tmpbuf[3];
+	int retval = 0;
+
+	/* safety checks */
+	if ((radio->registers[SYSCONFIG1] & SYSCONFIG1_RDS) == 0)
+		return;
+
+	/* Update RDS registers */
+	for (regnr = 0; regnr < RDS_REGISTER_NUM; regnr++) {
+		retval = si470x_get_register(radio, STATUSRSSI + regnr);
+		if (retval < 0)
+			return;
+	}
+
+	/* get rds blocks */
+	if ((radio->registers[STATUSRSSI] & STATUSRSSI_RDSR) == 0)
+		/* No RDS group ready, better luck next time */
+		return;
+
+	for (blocknum = 0; blocknum < 4; blocknum++) {
+		switch (blocknum) {
+		default:
+			bler = (radio->registers[STATUSRSSI] &
+					STATUSRSSI_BLERA) >> 9;
+			rds = radio->registers[RDSA];
+			break;
+		case 1:
+			bler = (radio->registers[READCHAN] &
+					READCHAN_BLERB) >> 14;
+			rds = radio->registers[RDSB];
+			break;
+		case 2:
+			bler = (radio->registers[READCHAN] &
+					READCHAN_BLERC) >> 12;
+			rds = radio->registers[RDSC];
+			break;
+		case 3:
+			bler = (radio->registers[READCHAN] &
+					READCHAN_BLERD) >> 10;
+			rds = radio->registers[RDSD];
+			break;
+		};
+
+		/* Fill the V4L2 RDS buffer */
+		put_unaligned_le16(rds, &tmpbuf);
+		tmpbuf[2] = blocknum;		/* offset name */
+		tmpbuf[2] |= blocknum << 3;	/* received offset */
+		if (bler > max_rds_errors)
+			tmpbuf[2] |= 0x80;	/* uncorrectable errors */
+		else if (bler > 0)
+			tmpbuf[2] |= 0x40;	/* corrected error(s) */
+
+		/* copy RDS block to internal buffer */
+		memcpy(&radio->buffer[radio->wr_index], &tmpbuf, 3);
+		radio->wr_index += 3;
+
+		/* wrap write pointer */
+		if (radio->wr_index >= radio->buf_size)
+			radio->wr_index = 0;
+
+		/* check for overflow */
+		if (radio->wr_index == radio->rd_index) {
+			/* increment and wrap read pointer */
+			radio->rd_index += 3;
+			if (radio->rd_index >= radio->buf_size)
+				radio->rd_index = 0;
+		}
+	}
+
+	if (radio->wr_index != radio->rd_index)
+		wake_up_interruptible(&radio->read_queue);
+}
+
+
+/*
+ * si470x_i2c_interrupt - interrupt handler
+ */
+static irqreturn_t si470x_i2c_interrupt(int irq, void *dev_id)
+{
+	struct si470x_device *radio = dev_id;
+
+	if (!work_pending(&radio->radio_work))
+		schedule_work(&radio->radio_work);
+
+	return IRQ_HANDLED;
+}
+
+
+/*
  * si470x_i2c_probe - probe for the device
  */
 static int __devinit si470x_i2c_probe(struct i2c_client *client,
@@ -257,6 +374,8 @@ static int __devinit si470x_i2c_probe(struct i2c_client *client,
 		retval = -ENOMEM;
 		goto err_initial;
 	}
+
+	INIT_WORK(&radio->radio_work, si470x_i2c_interrupt_work);
 	radio->users = 0;
 	radio->client = client;
 	mutex_init(&radio->lock);
@@ -308,6 +427,26 @@ static int __devinit si470x_i2c_probe(struct i2c_client *client,
 	/* set initial frequency */
 	si470x_set_freq(radio, 87.5 * FREQ_MUL); /* available in all regions */
 
+	/* rds buffer allocation */
+	radio->buf_size = rds_buf * 3;
+	radio->buffer = kmalloc(radio->buf_size, GFP_KERNEL);
+	if (!radio->buffer) {
+		retval = -EIO;
+		goto err_video;
+	}
+
+	/* rds buffer configuration */
+	radio->wr_index = 0;
+	radio->rd_index = 0;
+	init_waitqueue_head(&radio->read_queue);
+
+	retval = request_irq(client->irq, si470x_i2c_interrupt,
+			IRQF_TRIGGER_FALLING, DRIVER_NAME, radio);
+	if (retval) {
+		dev_err(&client->dev, "Failed to register interrupt\n");
+		goto err_rds;
+	}
+
 	/* register video device */
 	retval = video_register_device(radio->videodev, VFL_TYPE_RADIO,
 			radio_nr);
@@ -319,6 +458,9 @@ static int __devinit si470x_i2c_probe(struct i2c_client *client,
 
 	return 0;
 err_all:
+	free_irq(client->irq, radio);
+err_rds:
+	kfree(radio->buffer);
 err_video:
 	video_device_release(radio->videodev);
 err_radio:
@@ -335,6 +477,8 @@ static __devexit int si470x_i2c_remove(struct i2c_client *client)
 {
 	struct si470x_device *radio = i2c_get_clientdata(client);
 
+	free_irq(client->irq, radio);
+	cancel_work_sync(&radio->radio_work);
 	video_unregister_device(radio->videodev);
 	kfree(radio);
 	i2c_set_clientdata(client, NULL);
diff --git a/drivers/media/radio/si470x/radio-si470x.h b/drivers/media/radio/si470x/radio-si470x.h
index f646f79..29e05cf 100644
--- a/drivers/media/radio/si470x/radio-si470x.h
+++ b/drivers/media/radio/si470x/radio-si470x.h
@@ -181,6 +181,7 @@ struct si470x_device {
 
 #if defined(CONFIG_I2C_SI470X) || defined(CONFIG_I2C_SI470X_MODULE)
 	struct i2c_client *client;
+	struct work_struct radio_work;
 #endif
 };
 
-- 
1.6.3.3
