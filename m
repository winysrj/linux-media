Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3448 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804Ab3BDMgi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Feb 2013 07:36:38 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 8/8] stk-webcam: enable core-locking.
Date: Mon,  4 Feb 2013 13:36:21 +0100
Message-Id: <c3d728ecb277026fb93aa7644b9ea47517582adb.1359981193.git.hans.verkuil@cisco.com>
In-Reply-To: <1359981381-23901-1-git-send-email-hverkuil@xs4all.nl>
References: <1359981381-23901-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <2d4b37cad1af7790d44cc541b4a5519716e6a98c.1359981193.git.hans.verkuil@cisco.com>
References: <2d4b37cad1af7790d44cc541b4a5519716e6a98c.1359981193.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This makes it possible to switch to unlocked_ioctl.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/stkwebcam/stk-webcam.c |   24 ++++++++++++++++++++++--
 drivers/media/usb/stkwebcam/stk-webcam.h |    1 +
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c b/drivers/media/usb/stkwebcam/stk-webcam.c
index d1ef797..3fbcb7f 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.c
+++ b/drivers/media/usb/stkwebcam/stk-webcam.c
@@ -572,6 +572,8 @@ static int v4l_stk_open(struct file *fp)
 	if (dev == NULL || !is_present(dev))
 		return -ENXIO;
 
+	if (mutex_lock_interruptible(&dev->lock))
+		return -ERESTARTSYS;
 	if (!dev->first_init)
 		stk_camera_write_reg(dev, 0x0, 0x24);
 	else
@@ -580,6 +582,7 @@ static int v4l_stk_open(struct file *fp)
 	err = v4l2_fh_open(fp);
 	if (!err)
 		usb_autopm_get_interface(dev->interface);
+	mutex_unlock(&dev->lock);
 	return err;
 }
 
@@ -587,6 +590,7 @@ static int v4l_stk_release(struct file *fp)
 {
 	struct stk_camera *dev = video_drvdata(fp);
 
+	mutex_lock(&dev->lock);
 	if (dev->owner == fp) {
 		stk_stop_stream(dev);
 		stk_free_buffers(dev);
@@ -597,10 +601,11 @@ static int v4l_stk_release(struct file *fp)
 
 	if (is_present(dev))
 		usb_autopm_put_interface(dev->interface);
+	mutex_unlock(&dev->lock);
 	return v4l2_fh_release(fp);
 }
 
-static ssize_t v4l_stk_read(struct file *fp, char __user *buf,
+static ssize_t stk_read(struct file *fp, char __user *buf,
 		size_t count, loff_t *f_pos)
 {
 	int i;
@@ -661,6 +666,19 @@ static ssize_t v4l_stk_read(struct file *fp, char __user *buf,
 	return count;
 }
 
+static ssize_t v4l_stk_read(struct file *fp, char __user *buf,
+		size_t count, loff_t *f_pos)
+{
+	struct stk_camera *dev = video_drvdata(fp);
+	int ret;
+
+	if (mutex_lock_interruptible(&dev->lock))
+		return -ERESTARTSYS;
+	ret = stk_read(fp, buf, count, f_pos);
+	mutex_unlock(&dev->lock);
+	return ret;
+}
+
 static unsigned int v4l_stk_poll(struct file *fp, poll_table *wait)
 {
 	struct stk_camera *dev = video_drvdata(fp);
@@ -1146,7 +1164,7 @@ static struct v4l2_file_operations v4l_stk_fops = {
 	.read = v4l_stk_read,
 	.poll = v4l_stk_poll,
 	.mmap = v4l_stk_mmap,
-	.ioctl = video_ioctl2,
+	.unlocked_ioctl = video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops v4l_stk_ioctl_ops = {
@@ -1194,6 +1212,7 @@ static int stk_register_video_device(struct stk_camera *dev)
 	int err;
 
 	dev->vdev = stk_v4l_data;
+	dev->vdev.lock = &dev->lock;
 	dev->vdev.debug = debug;
 	dev->vdev.v4l2_dev = &dev->v4l2_dev;
 	set_bit(V4L2_FL_USE_FH_PRIO, &dev->vdev.flags);
@@ -1249,6 +1268,7 @@ static int stk_camera_probe(struct usb_interface *interface,
 	dev->v4l2_dev.ctrl_handler = hdl;
 
 	spin_lock_init(&dev->spinlock);
+	mutex_init(&dev->lock);
 	init_waitqueue_head(&dev->wait_frame);
 	dev->first_init = 1; /* webcam LED management */
 
diff --git a/drivers/media/usb/stkwebcam/stk-webcam.h b/drivers/media/usb/stkwebcam/stk-webcam.h
index 2156320..03550cf 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.h
+++ b/drivers/media/usb/stkwebcam/stk-webcam.h
@@ -99,6 +99,7 @@ struct stk_camera {
 	struct usb_interface *interface;
 	int webcam_model;
 	struct file *owner;
+	struct mutex lock;
 	int first_init;
 
 	u8 isoc_ep;
-- 
1.7.10.4

