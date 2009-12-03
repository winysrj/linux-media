Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:33016 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957AbZLCM5Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Dec 2009 07:57:16 -0500
Received: from epmmp1 (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KU200C7UUNLNO@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 03 Dec 2009 21:57:21 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0KU200KR8UNK31@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 03 Dec 2009 21:57:20 +0900 (KST)
Date: Thu, 03 Dec 2009 21:57:22 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: [PATCH v2 1/3] radio-si470x: move some file operations to common file
To: linux-media@vger.kernel.org
Cc: tobias.lorenz@gmx.net, kyungmin.park@samsung.com
Message-id: <4B17B5B2.7020103@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The read and poll file operations of the si470x usb driver can be used
also equally on the si470x i2c driver, so they go to the common file.

Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
---
 drivers/media/radio/si470x/radio-si470x-common.c |   98 ++++++++++++++++++++++
 drivers/media/radio/si470x/radio-si470x-i2c.c    |   15 +---
 drivers/media/radio/si470x/radio-si470x-usb.c    |   97 +---------------------
 drivers/media/radio/si470x/radio-si470x.h        |    3 +-
 4 files changed, 104 insertions(+), 109 deletions(-)

diff --git a/drivers/media/radio/si470x/radio-si470x-common.c b/drivers/media/radio/si470x/radio-si470x-common.c
index 7296cf4..f4645d4 100644
--- a/drivers/media/radio/si470x/radio-si470x-common.c
+++ b/drivers/media/radio/si470x/radio-si470x-common.c
@@ -426,6 +426,104 @@ int si470x_rds_on(struct si470x_device *radio)
 
 
 /**************************************************************************
+ * File Operations Interface
+ **************************************************************************/
+
+/*
+ * si470x_fops_read - read RDS data
+ */
+static ssize_t si470x_fops_read(struct file *file, char __user *buf,
+		size_t count, loff_t *ppos)
+{
+	struct si470x_device *radio = video_drvdata(file);
+	int retval = 0;
+	unsigned int block_count = 0;
+
+	/* switch on rds reception */
+	if ((radio->registers[SYSCONFIG1] & SYSCONFIG1_RDS) == 0)
+		si470x_rds_on(radio);
+
+	/* block if no new data available */
+	while (radio->wr_index == radio->rd_index) {
+		if (file->f_flags & O_NONBLOCK) {
+			retval = -EWOULDBLOCK;
+			goto done;
+		}
+		if (wait_event_interruptible(radio->read_queue,
+			radio->wr_index != radio->rd_index) < 0) {
+			retval = -EINTR;
+			goto done;
+		}
+	}
+
+	/* calculate block count from byte count */
+	count /= 3;
+
+	/* copy RDS block out of internal buffer and to user buffer */
+	mutex_lock(&radio->lock);
+	while (block_count < count) {
+		if (radio->rd_index == radio->wr_index)
+			break;
+
+		/* always transfer rds complete blocks */
+		if (copy_to_user(buf, &radio->buffer[radio->rd_index], 3))
+			/* retval = -EFAULT; */
+			break;
+
+		/* increment and wrap read pointer */
+		radio->rd_index += 3;
+		if (radio->rd_index >= radio->buf_size)
+			radio->rd_index = 0;
+
+		/* increment counters */
+		block_count++;
+		buf += 3;
+		retval += 3;
+	}
+	mutex_unlock(&radio->lock);
+
+done:
+	return retval;
+}
+
+
+/*
+ * si470x_fops_poll - poll RDS data
+ */
+static unsigned int si470x_fops_poll(struct file *file,
+		struct poll_table_struct *pts)
+{
+	struct si470x_device *radio = video_drvdata(file);
+	int retval = 0;
+
+	/* switch on rds reception */
+	if ((radio->registers[SYSCONFIG1] & SYSCONFIG1_RDS) == 0)
+		si470x_rds_on(radio);
+
+	poll_wait(file, &radio->read_queue, pts);
+
+	if (radio->rd_index != radio->wr_index)
+		retval = POLLIN | POLLRDNORM;
+
+	return retval;
+}
+
+
+/*
+ * si470x_fops - file operations interface
+ */
+static const struct v4l2_file_operations si470x_fops = {
+	.owner			= THIS_MODULE,
+	.read			= si470x_fops_read,
+	.poll			= si470x_fops_poll,
+	.ioctl			= video_ioctl2,
+	.open			= si470x_fops_open,
+	.release		= si470x_fops_release,
+};
+
+
+
+/**************************************************************************
  * Video4Linux Interface
  **************************************************************************/
 
diff --git a/drivers/media/radio/si470x/radio-si470x-i2c.c b/drivers/media/radio/si470x/radio-si470x-i2c.c
index 2d53b6a..4816a6d 100644
--- a/drivers/media/radio/si470x/radio-si470x-i2c.c
+++ b/drivers/media/radio/si470x/radio-si470x-i2c.c
@@ -173,7 +173,7 @@ int si470x_disconnect_check(struct si470x_device *radio)
 /*
  * si470x_fops_open - file open
  */
-static int si470x_fops_open(struct file *file)
+int si470x_fops_open(struct file *file)
 {
 	struct si470x_device *radio = video_drvdata(file);
 	int retval = 0;
@@ -194,7 +194,7 @@ static int si470x_fops_open(struct file *file)
 /*
  * si470x_fops_release - file release
  */
-static int si470x_fops_release(struct file *file)
+int si470x_fops_release(struct file *file)
 {
 	struct si470x_device *radio = video_drvdata(file);
 	int retval = 0;
@@ -215,17 +215,6 @@ static int si470x_fops_release(struct file *file)
 }
 
 
-/*
- * si470x_fops - file operations interface
- */
-const struct v4l2_file_operations si470x_fops = {
-	.owner		= THIS_MODULE,
-	.ioctl		= video_ioctl2,
-	.open		= si470x_fops_open,
-	.release	= si470x_fops_release,
-};
-
-
 
 /**************************************************************************
  * Video4Linux Interface
diff --git a/drivers/media/radio/si470x/radio-si470x-usb.c b/drivers/media/radio/si470x/radio-si470x-usb.c
index f2d0e1d..a96e1b9 100644
--- a/drivers/media/radio/si470x/radio-si470x-usb.c
+++ b/drivers/media/radio/si470x/radio-si470x-usb.c
@@ -509,89 +509,9 @@ resubmit:
  **************************************************************************/
 
 /*
- * si470x_fops_read - read RDS data
- */
-static ssize_t si470x_fops_read(struct file *file, char __user *buf,
-		size_t count, loff_t *ppos)
-{
-	struct si470x_device *radio = video_drvdata(file);
-	int retval = 0;
-	unsigned int block_count = 0;
-
-	/* switch on rds reception */
-	if ((radio->registers[SYSCONFIG1] & SYSCONFIG1_RDS) == 0)
-		si470x_rds_on(radio);
-
-	/* block if no new data available */
-	while (radio->wr_index == radio->rd_index) {
-		if (file->f_flags & O_NONBLOCK) {
-			retval = -EWOULDBLOCK;
-			goto done;
-		}
-		if (wait_event_interruptible(radio->read_queue,
-			radio->wr_index != radio->rd_index) < 0) {
-			retval = -EINTR;
-			goto done;
-		}
-	}
-
-	/* calculate block count from byte count */
-	count /= 3;
-
-	/* copy RDS block out of internal buffer and to user buffer */
-	mutex_lock(&radio->lock);
-	while (block_count < count) {
-		if (radio->rd_index == radio->wr_index)
-			break;
-
-		/* always transfer rds complete blocks */
-		if (copy_to_user(buf, &radio->buffer[radio->rd_index], 3))
-			/* retval = -EFAULT; */
-			break;
-
-		/* increment and wrap read pointer */
-		radio->rd_index += 3;
-		if (radio->rd_index >= radio->buf_size)
-			radio->rd_index = 0;
-
-		/* increment counters */
-		block_count++;
-		buf += 3;
-		retval += 3;
-	}
-	mutex_unlock(&radio->lock);
-
-done:
-	return retval;
-}
-
-
-/*
- * si470x_fops_poll - poll RDS data
- */
-static unsigned int si470x_fops_poll(struct file *file,
-		struct poll_table_struct *pts)
-{
-	struct si470x_device *radio = video_drvdata(file);
-	int retval = 0;
-
-	/* switch on rds reception */
-	if ((radio->registers[SYSCONFIG1] & SYSCONFIG1_RDS) == 0)
-		si470x_rds_on(radio);
-
-	poll_wait(file, &radio->read_queue, pts);
-
-	if (radio->rd_index != radio->wr_index)
-		retval = POLLIN | POLLRDNORM;
-
-	return retval;
-}
-
-
-/*
  * si470x_fops_open - file open
  */
-static int si470x_fops_open(struct file *file)
+int si470x_fops_open(struct file *file)
 {
 	struct si470x_device *radio = video_drvdata(file);
 	int retval;
@@ -645,7 +565,7 @@ done:
 /*
  * si470x_fops_release - file release
  */
-static int si470x_fops_release(struct file *file)
+int si470x_fops_release(struct file *file)
 {
 	struct si470x_device *radio = video_drvdata(file);
 	int retval = 0;
@@ -688,19 +608,6 @@ done:
 }
 
 
-/*
- * si470x_fops - file operations interface
- */
-const struct v4l2_file_operations si470x_fops = {
-	.owner		= THIS_MODULE,
-	.read		= si470x_fops_read,
-	.poll		= si470x_fops_poll,
-	.ioctl		= video_ioctl2,
-	.open		= si470x_fops_open,
-	.release	= si470x_fops_release,
-};
-
-
 
 /**************************************************************************
  * Video4Linux Interface
diff --git a/drivers/media/radio/si470x/radio-si470x.h b/drivers/media/radio/si470x/radio-si470x.h
index d0af194..f646f79 100644
--- a/drivers/media/radio/si470x/radio-si470x.h
+++ b/drivers/media/radio/si470x/radio-si470x.h
@@ -212,7 +212,6 @@ struct si470x_device {
 /**************************************************************************
  * Common Functions
  **************************************************************************/
-extern const struct v4l2_file_operations si470x_fops;
 extern struct video_device si470x_viddev_template;
 int si470x_get_register(struct si470x_device *radio, int regnr);
 int si470x_set_register(struct si470x_device *radio, int regnr);
@@ -221,5 +220,7 @@ int si470x_set_freq(struct si470x_device *radio, unsigned int freq);
 int si470x_start(struct si470x_device *radio);
 int si470x_stop(struct si470x_device *radio);
 int si470x_rds_on(struct si470x_device *radio);
+int si470x_fops_open(struct file *file);
+int si470x_fops_release(struct file *file);
 int si470x_vidioc_querycap(struct file *file, void *priv,
 		struct v4l2_capability *capability);
-- 
1.6.3.3
