Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:40777 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755844Ab1EATGG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 May 2011 15:06:06 -0400
Received: from tobias-t61p.localnet (unknown [10.2.3.10])
	by mail.lorenz.priv (Postfix) with ESMTPS id CB133141ED
	for <linux-media@vger.kernel.org>; Sun,  1 May 2011 21:06:02 +0200 (CEST)
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: linux-media@vger.kernel.org
Subject: [PATCH 6/6] removement of locking mechanisms
Date: Sun, 1 May 2011 21:03:32 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105012103.32066.tobias.lorenz@gmx.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch minimized the use of locking.
Basically locking is only required where open/close/disconnect is done.

Interfering calls usually happen only to rds read/write operations.
The code for ring buffer handling is changed in a way that makes locking there 
unnecessary.
In case of extensive compiler optimization, the worst that can happen is 
dropped new data or redundant read of data.

The good thing is that the clicking noise problem seems finally resolved with 
that patch!

Signed-off-by: Tobias Lorenz <tobias.lorenz@gmx.net>
---
 drivers/media/radio/si470x/radio-si470x-common.c |   39 +++++----------------
 drivers/media/radio/si470x/radio-si470x-i2c.c    |   16 ++++++---
 drivers/media/radio/si470x/radio-si470x-usb.c    |   19 +++++++----
 drivers/media/radio/si470x/radio-si470x.h        |    2 +-
 4 files changed, 34 insertions(+), 42 deletions(-)

diff --git a/drivers/media/radio/si470x/radio-si470x-common.c 
b/drivers/media/radio/si470x/radio-si470x-common.c
index 60bd95d..b184292 100644
--- a/drivers/media/radio/si470x/radio-si470x-common.c
+++ b/drivers/media/radio/si470x/radio-si470x-common.c
@@ -347,7 +347,8 @@ static ssize_t si470x_fops_read(struct file *file, char 
__user *buf,
 {
 	struct si470x_device *radio = video_drvdata(file);
 	int retval = 0;
-	unsigned int block_count = 0;
+	size_t copied = 0;
+	unsigned int new_rd_index = 0;
 
 	/* switch on rds reception */
 	if ((radio->registers[SYSCONFIG1] & SYSCONFIG1_RDS) == 0)
@@ -366,31 +367,28 @@ static ssize_t si470x_fops_read(struct file *file, char 
__user *buf,
 		}
 	}
 
-	/* calculate block count from byte count */
-	count /= 3;
-
 	/* copy RDS block out of internal buffer and to user buffer */
-	mutex_lock(&radio->lock);
-	while (block_count < count) {
+	while (copied < count) {
 		if (radio->rd_index == radio->wr_index)
 			break;
 
-		/* always transfer rds complete blocks */
+		/* always transfer complete rds blocks */
 		if (copy_to_user(buf, &radio->buffer[radio->rd_index], 3))
 			/* retval = -EFAULT; */
 			break;
 
 		/* increment and wrap read pointer */
-		radio->rd_index += 3;
-		if (radio->rd_index >= radio->buf_size)
+		new_rd_index = radio->rd_index + 3;
+		if (new_rd_index < radio->buf_size)
+			radio->rd_index = new_rd_index;
+		else
 			radio->rd_index = 0;
 
 		/* increment counters */
-		block_count++;
+		copied += 3;
 		buf += 3;
-		retval += 3;
 	}
-	mutex_unlock(&radio->lock);
+	retval = copied;
 
 done:
 	return retval;
@@ -407,11 +405,8 @@ static unsigned int si470x_fops_poll(struct file *file,
 	int retval = 0;
 
 	/* switch on rds reception */
-
-	mutex_lock(&radio->lock);
 	if ((radio->registers[SYSCONFIG1] & SYSCONFIG1_RDS) == 0)
 		si470x_rds_on(radio);
-	mutex_unlock(&radio->lock);
 
 	poll_wait(file, &radio->read_queue, pts);
 
@@ -485,7 +480,6 @@ static int si470x_vidioc_g_ctrl(struct file *file, void 
*priv,
 	struct si470x_device *radio = video_drvdata(file);
 	int retval = 0;
 
-	mutex_lock(&radio->lock);
 	/* safety checks */
 	retval = si470x_disconnect_check(radio);
 	if (retval)
@@ -509,7 +503,6 @@ done:
 		dev_warn(&radio->videodev->dev,
 			"get control failed with %d\n", retval);
 
-	mutex_unlock(&radio->lock);
 	return retval;
 }
 
@@ -523,7 +516,6 @@ static int si470x_vidioc_s_ctrl(struct file *file, void 
*priv,
 	struct si470x_device *radio = video_drvdata(file);
 	int retval = 0;
 
-	mutex_lock(&radio->lock);
 	/* safety checks */
 	retval = si470x_disconnect_check(radio);
 	if (retval)
@@ -550,7 +542,6 @@ done:
 	if (retval < 0)
 		dev_warn(&radio->videodev->dev,
 			"set control failed with %d\n", retval);
-	mutex_unlock(&radio->lock);
 	return retval;
 }
 
@@ -580,7 +571,6 @@ static int si470x_vidioc_g_tuner(struct file *file, void 
*priv,
 	struct si470x_device *radio = video_drvdata(file);
 	int retval = 0;
 
-	mutex_lock(&radio->lock);
 	/* safety checks */
 	retval = si470x_disconnect_check(radio);
 	if (retval)
@@ -650,7 +640,6 @@ done:
 	if (retval < 0)
 		dev_warn(&radio->videodev->dev,
 			"get tuner failed with %d\n", retval);
-	mutex_unlock(&radio->lock);
 	return retval;
 }
 
@@ -664,7 +653,6 @@ static int si470x_vidioc_s_tuner(struct file *file, void 
*priv,
 	struct si470x_device *radio = video_drvdata(file);
 	int retval = 0;
 
-	mutex_lock(&radio->lock);
 	/* safety checks */
 	retval = si470x_disconnect_check(radio);
 	if (retval)
@@ -691,7 +679,6 @@ done:
 	if (retval < 0)
 		dev_warn(&radio->videodev->dev,
 			"set tuner failed with %d\n", retval);
-	mutex_unlock(&radio->lock);
 	return retval;
 }
 
@@ -706,7 +693,6 @@ static int si470x_vidioc_g_frequency(struct file *file, 
void *priv,
 	int retval = 0;
 
 	/* safety checks */
-	mutex_lock(&radio->lock);
 	retval = si470x_disconnect_check(radio);
 	if (retval)
 		goto done;
@@ -723,7 +709,6 @@ done:
 	if (retval < 0)
 		dev_warn(&radio->videodev->dev,
 			"get frequency failed with %d\n", retval);
-	mutex_unlock(&radio->lock);
 	return retval;
 }
 
@@ -737,7 +722,6 @@ static int si470x_vidioc_s_frequency(struct file *file, 
void *priv,
 	struct si470x_device *radio = video_drvdata(file);
 	int retval = 0;
 
-	mutex_lock(&radio->lock);
 	/* safety checks */
 	retval = si470x_disconnect_check(radio);
 	if (retval)
@@ -754,7 +738,6 @@ done:
 	if (retval < 0)
 		dev_warn(&radio->videodev->dev,
 			"set frequency failed with %d\n", retval);
-	mutex_unlock(&radio->lock);
 	return retval;
 }
 
@@ -768,7 +751,6 @@ static int si470x_vidioc_s_hw_freq_seek(struct file *file, 
void *priv,
 	struct si470x_device *radio = video_drvdata(file);
 	int retval = 0;
 
-	mutex_lock(&radio->lock);
 	/* safety checks */
 	retval = si470x_disconnect_check(radio);
 	if (retval)
@@ -785,7 +767,6 @@ done:
 	if (retval < 0)
 		dev_warn(&radio->videodev->dev,
 			"set hardware frequency seek failed with %d\n", retval);
-	mutex_unlock(&radio->lock);
 	return retval;
 }
 
diff --git a/drivers/media/radio/si470x/radio-si470x-i2c.c 
b/drivers/media/radio/si470x/radio-si470x-i2c.c
index 4ce541a..e956bcc 100644
--- a/drivers/media/radio/si470x/radio-si470x-i2c.c
+++ b/drivers/media/radio/si470x/radio-si470x-i2c.c
@@ -273,6 +273,8 @@ static void si470x_i2c_interrupt_work(struct work_struct 
*work)
 	unsigned short rds;
 	unsigned char tmpbuf[3];
 	int retval = 0;
+	unsigned int new_wr_index = 0;
+	unsigned int new_rd_index = 0;
 
 	/* safety checks */
 	if ((radio->registers[SYSCONFIG1] & SYSCONFIG1_RDS) == 0)
@@ -325,17 +327,21 @@ static void si470x_i2c_interrupt_work(struct work_struct 
*work)
 
 		/* copy RDS block to internal buffer */
 		memcpy(&radio->buffer[radio->wr_index], &tmpbuf, 3);
-		radio->wr_index += 3;
 
-		/* wrap write pointer */
-		if (radio->wr_index >= radio->buf_size)
+		/* increment and wrap write pointer */
+		new_wr_index = radio->wr_index + 3;
+		if (radio->wr_index < radio->buf_size)
+			radio->wr_index = new_wr_index;
+		else
 			radio->wr_index = 0;
 
 		/* check for overflow */
 		if (radio->wr_index == radio->rd_index) {
 			/* increment and wrap read pointer */
-			radio->rd_index += 3;
-			if (radio->rd_index >= radio->buf_size)
+			new_rd_index = radio->rd_index + 3;
+			if (radio->rd_index < radio->buf_size)
+				radio->rd_index = new_rd_index;
+			else
 				radio->rd_index = 0;
 		}
 	}
diff --git a/drivers/media/radio/si470x/radio-si470x-usb.c 
b/drivers/media/radio/si470x/radio-si470x-usb.c
index 57462b3..4df6d32e 100644
--- a/drivers/media/radio/si470x/radio-si470x-usb.c
+++ b/drivers/media/radio/si470x/radio-si470x-usb.c
@@ -375,8 +375,6 @@ int si470x_disconnect_check(struct si470x_device *radio)
 
 /*
  * si470x_int_in_callback - rds callback and processing function
- *
- * TODO: do we need to use mutex locks in some sections?
  */
 static void si470x_int_in_callback(struct urb *urb)
 {
@@ -388,6 +386,8 @@ static void si470x_int_in_callback(struct urb *urb)
 	unsigned short bler; /* rds block errors */
 	unsigned short rds;
 	unsigned char tmpbuf[3];
+	unsigned int new_wr_index = 0;
+	unsigned int new_rd_index = 0;
 
 	if (urb->status) {
 		if (urb->status == -ENOENT ||
@@ -458,20 +458,25 @@ static void si470x_int_in_callback(struct urb *urb)
 
 			/* copy RDS block to internal buffer */
 			memcpy(&radio->buffer[radio->wr_index], &tmpbuf, 3);
-			radio->wr_index += 3;
 
-			/* wrap write pointer */
-			if (radio->wr_index >= radio->buf_size)
+			/* increment and wrap write pointer */
+			new_wr_index = radio->wr_index + 3;
+			if (radio->wr_index < radio->buf_size)
+				radio->wr_index = new_wr_index;
+			else
 				radio->wr_index = 0;
 
 			/* check for overflow */
 			if (radio->wr_index == radio->rd_index) {
 				/* increment and wrap read pointer */
-				radio->rd_index += 3;
-				if (radio->rd_index >= radio->buf_size)
+				new_rd_index = radio->rd_index + 3;
+				if (radio->rd_index < radio->buf_size)
+					radio->rd_index = new_rd_index;
+				else
 					radio->rd_index = 0;
 			}
 		}
+
 		if (radio->wr_index != radio->rd_index)
 			wake_up_interruptible(&radio->read_queue);
 	}
diff --git a/drivers/media/radio/si470x/radio-si470x.h 
b/drivers/media/radio/si470x/radio-si470x.h
index 7e1cc47..283275d 100644
--- a/drivers/media/radio/si470x/radio-si470x.h
+++ b/drivers/media/radio/si470x/radio-si470x.h
@@ -147,13 +147,13 @@ struct si470x_device {
 
 	/* driver management */
 	unsigned int users;
+	struct mutex lock;
 
 	/* Silabs internal registers (0..15) */
 	unsigned short registers[RADIO_REGISTER_NUM];
 
 	/* RDS receive buffer */
 	wait_queue_head_t read_queue;
-	struct mutex lock;		/* buffer locking */
 	unsigned char *buffer;		/* size is always multiple of three */
 	unsigned int buf_size;
 	unsigned int rd_index;
-- 
1.7.4.1

