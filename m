Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:4483 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027Ab2FXL3H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jun 2012 07:29:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Andy Walls <awalls@md.metrocast.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Manjunatha Halli <manjunatha_halli@ti.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>,
	Anatolij Gustschin <agust@denx.de>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Sensoray Linux Development <linux-dev@sensoray.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Sachin Kamat <sachin.kamat@linaro.org>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	mitov@issp.bas.bg, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 09/26] wl128x: remove V4L2_FL_LOCK_ALL_FOPS
Date: Sun, 24 Jun 2012 13:26:01 +0200
Message-Id: <4081389063248c64b58a971e5b08160798ae1bb5.1340536092.git.hans.verkuil@cisco.com>
In-Reply-To: <1340537178-18768-1-git-send-email-hverkuil@xs4all.nl>
References: <1340537178-18768-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <f854d2a0a932187cd895bf9cd81d2da8343b52c9.1340536092.git.hans.verkuil@cisco.com>
References: <f854d2a0a932187cd895bf9cd81d2da8343b52c9.1340536092.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add proper locking to the file operations, allowing for the removal
of the V4L2_FL_LOCK_ALL_FOPS flag.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/radio/wl128x/fmdrv_v4l2.c |   38 +++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 12 deletions(-)

diff --git a/drivers/media/radio/wl128x/fmdrv_v4l2.c b/drivers/media/radio/wl128x/fmdrv_v4l2.c
index 49a11ec..db2248e 100644
--- a/drivers/media/radio/wl128x/fmdrv_v4l2.c
+++ b/drivers/media/radio/wl128x/fmdrv_v4l2.c
@@ -56,23 +56,29 @@ static ssize_t fm_v4l2_fops_read(struct file *file, char __user * buf,
 		return -EIO;
 	}
 
-	/* Turn on RDS mode , if it is disabled */
+	if (mutex_lock_interruptible(&fmdev->mutex))
+		return -ERESTARTSYS;
+
+	/* Turn on RDS mode if it is disabled */
 	ret = fm_rx_get_rds_mode(fmdev, &rds_mode);
 	if (ret < 0) {
 		fmerr("Unable to read current rds mode\n");
-		return ret;
+		goto read_unlock;
 	}
 
 	if (rds_mode == FM_RDS_DISABLE) {
 		ret = fmc_set_rds_mode(fmdev, FM_RDS_ENABLE);
 		if (ret < 0) {
 			fmerr("Failed to enable rds mode\n");
-			return ret;
+			goto read_unlock;
 		}
 	}
 
 	/* Copy RDS data from internal buffer to user buffer */
-	return fmc_transfer_rds_from_internal_buff(fmdev, file, buf, count);
+	ret = fmc_transfer_rds_from_internal_buff(fmdev, file, buf, count);
+read_unlock:
+	mutex_unlock(&fmdev->mutex);
+	return ret;
 }
 
 /* Write TX RDS data */
@@ -91,8 +97,11 @@ static ssize_t fm_v4l2_fops_write(struct file *file, const char __user * buf,
 		return -EFAULT;
 
 	fmdev = video_drvdata(file);
+	if (mutex_lock_interruptible(&fmdev->mutex))
+		return -ERESTARTSYS;
 	fm_tx_set_radio_text(fmdev, rds.text, rds.text_type);
 	fm_tx_set_af(fmdev, rds.af_freq);
+	mutex_unlock(&fmdev->mutex);
 
 	return sizeof(rds);
 }
@@ -103,7 +112,9 @@ static u32 fm_v4l2_fops_poll(struct file *file, struct poll_table_struct *pts)
 	struct fmdev *fmdev;
 
 	fmdev = video_drvdata(file);
+	mutex_lock(&fmdev->mutex);
 	ret = fmc_is_rds_data_available(fmdev, file, pts);
+	mutex_unlock(&fmdev->mutex);
 	if (ret < 0)
 		return POLLIN | POLLRDNORM;
 
@@ -127,10 +138,12 @@ static int fm_v4l2_fops_open(struct file *file)
 
 	fmdev = video_drvdata(file);
 
+	if (mutex_lock_interruptible(&fmdev->mutex))
+		return -ERESTARTSYS;
 	ret = fmc_prepare(fmdev);
 	if (ret < 0) {
 		fmerr("Unable to prepare FM CORE\n");
-		return ret;
+		goto open_unlock;
 	}
 
 	fmdbg("Load FM RX firmware..\n");
@@ -138,10 +151,12 @@ static int fm_v4l2_fops_open(struct file *file)
 	ret = fmc_set_mode(fmdev, FM_MODE_RX);
 	if (ret < 0) {
 		fmerr("Unable to load FM RX firmware\n");
-		return ret;
+		goto open_unlock;
 	}
 	radio_disconnected = 1;
 
+open_unlock:
+	mutex_unlock(&fmdev->mutex);
 	return ret;
 }
 
@@ -156,19 +171,22 @@ static int fm_v4l2_fops_release(struct file *file)
 		return 0;
 	}
 
+	mutex_lock(&fmdev->mutex);
 	ret = fmc_set_mode(fmdev, FM_MODE_OFF);
 	if (ret < 0) {
 		fmerr("Unable to turn off the chip\n");
-		return ret;
+		goto release_unlock;
 	}
 
 	ret = fmc_release(fmdev);
 	if (ret < 0) {
 		fmerr("FM CORE release failed\n");
-		return ret;
+		goto release_unlock;
 	}
 	radio_disconnected = 0;
 
+release_unlock:
+	mutex_unlock(&fmdev->mutex);
 	return ret;
 }
 
@@ -520,10 +538,6 @@ int fm_v4l2_init_video_device(struct fmdev *fmdev, int radio_nr)
 	video_set_drvdata(gradio_dev, fmdev);
 
 	gradio_dev->lock = &fmdev->mutex;
-	/* Locking in file operations other than ioctl should be done
-	   by the driver, not the V4L2 core.
-	   This driver needs auditing so that this flag can be removed. */
-	set_bit(V4L2_FL_LOCK_ALL_FOPS, &gradio_dev->flags);
 
 	/* Register with V4L2 subsystem as RADIO device */
 	if (video_register_device(gradio_dev, VFL_TYPE_RADIO, radio_nr)) {
-- 
1.7.10

