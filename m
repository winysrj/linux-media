Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:30840 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123Ab0IPBBO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Sep 2010 21:01:14 -0400
Date: Wed, 15 Sep 2010 21:56:39 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Tobias Lorenz <tobias.lorenz@gmx.net>,
	Joonyoung Shim <jy0922.shim@samsung.com>
Subject: [PATCH 2/8] V4L/DVB: radio-si470x: use unlocked ioctl
Message-ID: <20100915215639.0700b225@pedra>
In-Reply-To: <cover.1284597566.git.mchehab@redhat.com>
References: <cover.1284597566.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/radio/si470x/radio-si470x-common.c b/drivers/media/radio/si470x/radio-si470x-common.c
index 9927a59..61be988 100644
--- a/drivers/media/radio/si470x/radio-si470x-common.c
+++ b/drivers/media/radio/si470x/radio-si470x-common.c
@@ -408,17 +408,15 @@ done:
 /*
  * si470x_rds_on - switch on rds reception
  */
-int si470x_rds_on(struct si470x_device *radio)
+static int si470x_rds_on(struct si470x_device *radio)
 {
 	int retval;
 
 	/* sysconfig 1 */
-	mutex_lock(&radio->lock);
 	radio->registers[SYSCONFIG1] |= SYSCONFIG1_RDS;
 	retval = si470x_set_register(radio, SYSCONFIG1);
 	if (retval < 0)
 		radio->registers[SYSCONFIG1] &= ~SYSCONFIG1_RDS;
-	mutex_unlock(&radio->lock);
 
 	return retval;
 }
@@ -440,6 +438,7 @@ static ssize_t si470x_fops_read(struct file *file, char __user *buf,
 	unsigned int block_count = 0;
 
 	/* switch on rds reception */
+	mutex_lock(&radio->lock);
 	if ((radio->registers[SYSCONFIG1] & SYSCONFIG1_RDS) == 0)
 		si470x_rds_on(radio);
 
@@ -480,9 +479,9 @@ static ssize_t si470x_fops_read(struct file *file, char __user *buf,
 		buf += 3;
 		retval += 3;
 	}
-	mutex_unlock(&radio->lock);
 
 done:
+	mutex_unlock(&radio->lock);
 	return retval;
 }
 
@@ -497,8 +496,11 @@ static unsigned int si470x_fops_poll(struct file *file,
 	int retval = 0;
 
 	/* switch on rds reception */
+
+	mutex_lock(&radio->lock);
 	if ((radio->registers[SYSCONFIG1] & SYSCONFIG1_RDS) == 0)
 		si470x_rds_on(radio);
+	mutex_unlock(&radio->lock);
 
 	poll_wait(file, &radio->read_queue, pts);
 
@@ -516,7 +518,7 @@ static const struct v4l2_file_operations si470x_fops = {
 	.owner			= THIS_MODULE,
 	.read			= si470x_fops_read,
 	.poll			= si470x_fops_poll,
-	.ioctl			= video_ioctl2,
+	.unlocked_ioctl		= video_ioctl2,
 	.open			= si470x_fops_open,
 	.release		= si470x_fops_release,
 };
@@ -572,6 +574,7 @@ static int si470x_vidioc_g_ctrl(struct file *file, void *priv,
 	struct si470x_device *radio = video_drvdata(file);
 	int retval = 0;
 
+	mutex_lock(&radio->lock);
 	/* safety checks */
 	retval = si470x_disconnect_check(radio);
 	if (retval)
@@ -594,6 +597,8 @@ done:
 	if (retval < 0)
 		dev_warn(&radio->videodev->dev,
 			"get control failed with %d\n", retval);
+
+	mutex_unlock(&radio->lock);
 	return retval;
 }
 
@@ -607,6 +612,7 @@ static int si470x_vidioc_s_ctrl(struct file *file, void *priv,
 	struct si470x_device *radio = video_drvdata(file);
 	int retval = 0;
 
+	mutex_lock(&radio->lock);
 	/* safety checks */
 	retval = si470x_disconnect_check(radio);
 	if (retval)
@@ -633,6 +639,7 @@ done:
 	if (retval < 0)
 		dev_warn(&radio->videodev->dev,
 			"set control failed with %d\n", retval);
+	mutex_unlock(&radio->lock);
 	return retval;
 }
 
@@ -662,6 +669,7 @@ static int si470x_vidioc_g_tuner(struct file *file, void *priv,
 	struct si470x_device *radio = video_drvdata(file);
 	int retval = 0;
 
+	mutex_lock(&radio->lock);
 	/* safety checks */
 	retval = si470x_disconnect_check(radio);
 	if (retval)
@@ -737,6 +745,7 @@ done:
 	if (retval < 0)
 		dev_warn(&radio->videodev->dev,
 			"get tuner failed with %d\n", retval);
+	mutex_unlock(&radio->lock);
 	return retval;
 }
 
@@ -750,6 +759,7 @@ static int si470x_vidioc_s_tuner(struct file *file, void *priv,
 	struct si470x_device *radio = video_drvdata(file);
 	int retval = 0;
 
+	mutex_lock(&radio->lock);
 	/* safety checks */
 	retval = si470x_disconnect_check(radio);
 	if (retval)
@@ -776,6 +786,7 @@ done:
 	if (retval < 0)
 		dev_warn(&radio->videodev->dev,
 			"set tuner failed with %d\n", retval);
+	mutex_unlock(&radio->lock);
 	return retval;
 }
 
@@ -790,6 +801,7 @@ static int si470x_vidioc_g_frequency(struct file *file, void *priv,
 	int retval = 0;
 
 	/* safety checks */
+	mutex_lock(&radio->lock);
 	retval = si470x_disconnect_check(radio);
 	if (retval)
 		goto done;
@@ -806,6 +818,7 @@ done:
 	if (retval < 0)
 		dev_warn(&radio->videodev->dev,
 			"get frequency failed with %d\n", retval);
+	mutex_unlock(&radio->lock);
 	return retval;
 }
 
@@ -819,6 +832,7 @@ static int si470x_vidioc_s_frequency(struct file *file, void *priv,
 	struct si470x_device *radio = video_drvdata(file);
 	int retval = 0;
 
+	mutex_lock(&radio->lock);
 	/* safety checks */
 	retval = si470x_disconnect_check(radio);
 	if (retval)
@@ -835,6 +849,7 @@ done:
 	if (retval < 0)
 		dev_warn(&radio->videodev->dev,
 			"set frequency failed with %d\n", retval);
+	mutex_unlock(&radio->lock);
 	return retval;
 }
 
@@ -848,6 +863,7 @@ static int si470x_vidioc_s_hw_freq_seek(struct file *file, void *priv,
 	struct si470x_device *radio = video_drvdata(file);
 	int retval = 0;
 
+	mutex_lock(&radio->lock);
 	/* safety checks */
 	retval = si470x_disconnect_check(radio);
 	if (retval)
@@ -864,6 +880,7 @@ done:
 	if (retval < 0)
 		dev_warn(&radio->videodev->dev,
 			"set hardware frequency seek failed with %d\n", retval);
+	mutex_unlock(&radio->lock);
 	return retval;
 }
 
diff --git a/drivers/media/radio/si470x/radio-si470x.h b/drivers/media/radio/si470x/radio-si470x.h
index d3d86ba..ea12782 100644
--- a/drivers/media/radio/si470x/radio-si470x.h
+++ b/drivers/media/radio/si470x/radio-si470x.h
@@ -220,7 +220,6 @@ int si470x_disconnect_check(struct si470x_device *radio);
 int si470x_set_freq(struct si470x_device *radio, unsigned int freq);
 int si470x_start(struct si470x_device *radio);
 int si470x_stop(struct si470x_device *radio);
-int si470x_rds_on(struct si470x_device *radio);
 int si470x_fops_open(struct file *file);
 int si470x_fops_release(struct file *file);
 int si470x_vidioc_querycap(struct file *file, void *priv,
-- 
1.7.1


