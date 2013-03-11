Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2451 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603Ab3CKVBN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 17:01:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Steven Toth <stoth@kernellabs.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 15/15] au0828: improve firmware loading & locking.
Date: Mon, 11 Mar 2013 22:00:46 +0100
Message-Id: <d0b1a102aa80aafd657c9855baff05f2b6fa0aa0.1363035203.git.hans.verkuil@cisco.com>
In-Reply-To: <1363035646-25244-1-git-send-email-hverkuil@xs4all.nl>
References: <1363035646-25244-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <0e2409cf677013b9cad1ba4aee17fe434dae7146.1363035203.git.hans.verkuil@cisco.com>
References: <0e2409cf677013b9cad1ba4aee17fe434dae7146.1363035203.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

- open/close/read and poll need to take the core lock as well.
- when the tuner goes to sleep we should set std_set_in_tuner_core
  to 0 since the tuner loses the firmware at that time.
- initialize the tuner if std_set_in_tuner_core == 0 whenever:
  1) g/s_tuner, s_std or s_frequency is called
  2) read or poll is called
  3) streamon is called

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/au0828/au0828-video.c |   66 ++++++++++++++++++++++++-------
 1 file changed, 52 insertions(+), 14 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index cc1e861..1aee330 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -998,11 +998,17 @@ static int au0828_v4l2_open(struct file *filp)
 	v4l2_fh_init(&fh->fh, vdev);
 	filp->private_data = fh;
 
-	if (fh->type == V4L2_BUF_TYPE_VIDEO_CAPTURE && dev->users == 0) {
+	if (mutex_lock_interruptible(&dev->lock)) {
+		kfree(fh);
+		return -ERESTARTSYS;
+	}
+	if (dev->users == 0) {
 		/* set au0828 interface0 to AS5 here again */
 		ret = usb_set_interface(dev->usbdev, 0, 5);
 		if (ret < 0) {
+			mutex_unlock(&dev->lock);
 			printk(KERN_INFO "Au0828 can't set alternate to 5!\n");
+			kfree(fh);
 			return -EBUSY;
 		}
 
@@ -1017,6 +1023,7 @@ static int au0828_v4l2_open(struct file *filp)
 	}
 
 	dev->users++;
+	mutex_unlock(&dev->lock);
 
 	videobuf_queue_vmalloc_init(&fh->vb_vidq, &au0828_video_qops,
 				    NULL, &dev->slock,
@@ -1044,6 +1051,7 @@ static int au0828_v4l2_close(struct file *filp)
 
 	v4l2_fh_del(&fh->fh);
 	v4l2_fh_exit(&fh->fh);
+	mutex_lock(&dev->lock);
 	if (res_check(fh, AU0828_RESOURCE_VIDEO)) {
 		/* Cancel timeout thread in case they didn't call streamoff */
 		dev->vid_timeout_running = 0;
@@ -1069,6 +1077,7 @@ static int au0828_v4l2_close(struct file *filp)
 
 		/* Save some power by putting tuner to sleep */
 		v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_power, 0);
+		dev->std_set_in_tuner_core = 0;
 
 		/* When close the device, set the usb intf0 into alt0 to free
 		   USB bandwidth */
@@ -1076,6 +1085,7 @@ static int au0828_v4l2_close(struct file *filp)
 		if (ret < 0)
 			printk(KERN_INFO "Au0828 can't set alternate to 0!\n");
 	}
+	mutex_unlock(&dev->lock);
 
 	videobuf_mmap_free(&fh->vb_vidq);
 	videobuf_mmap_free(&fh->vb_vbiq);
@@ -1085,6 +1095,26 @@ static int au0828_v4l2_close(struct file *filp)
 	return 0;
 }
 
+/* Must be called with dev->lock held */
+static void au0828_init_tuner(struct au0828_dev *dev)
+{
+	struct v4l2_frequency f = {
+		.frequency = dev->ctrl_freq,
+		.type = V4L2_TUNER_ANALOG_TV,
+	};
+
+	if (dev->std_set_in_tuner_core)
+		return;
+	dev->std_set_in_tuner_core = 1;
+	i2c_gate_ctrl(dev, 1);
+	/* If we've never sent the standard in tuner core, do so now.
+	   We don't do this at device probe because we don't want to
+	   incur the cost of a firmware load */
+	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_std, dev->std);
+	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_frequency, &f);
+	i2c_gate_ctrl(dev, 0);
+}
+
 static ssize_t au0828_v4l2_read(struct file *filp, char __user *buf,
 				size_t count, loff_t *pos)
 {
@@ -1096,6 +1126,11 @@ static ssize_t au0828_v4l2_read(struct file *filp, char __user *buf,
 	if (rc < 0)
 		return rc;
 
+	if (mutex_lock_interruptible(&dev->lock))
+		return -ERESTARTSYS;
+	au0828_init_tuner(dev);
+	mutex_unlock(&dev->lock);
+
 	if (fh->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
 		if (res_locked(dev, AU0828_RESOURCE_VIDEO))
 			return -EBUSY;
@@ -1136,6 +1171,11 @@ static unsigned int au0828_v4l2_poll(struct file *filp, poll_table *wait)
 	if (!(req_events & (POLLIN | POLLRDNORM)))
 		return res;
 
+	if (mutex_lock_interruptible(&dev->lock))
+		return -ERESTARTSYS;
+	au0828_init_tuner(dev);
+	mutex_unlock(&dev->lock);
+
 	if (fh->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
 		if (!res_get(fh, AU0828_RESOURCE_VIDEO))
 			return POLLERR;
@@ -1319,6 +1359,10 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *norm)
 	struct au0828_fh *fh = priv;
 	struct au0828_dev *dev = fh->dev;
 
+	dev->std = *norm;
+
+	au0828_init_tuner(dev);
+
 	i2c_gate_ctrl(dev, 1);
 
 	/* FIXME: when we support something other than NTSC, we are going to
@@ -1326,10 +1370,8 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *norm)
 	   buffer, which is currently hardcoded at 720x480 */
 
 	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_std, *norm);
-	dev->std_set_in_tuner_core = 1;
 
 	i2c_gate_ctrl(dev, 0);
-	dev->std = *norm;
 
 	return 0;
 }
@@ -1506,7 +1548,11 @@ static int vidioc_g_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
 		return -EINVAL;
 
 	strcpy(t->name, "Auvitek tuner");
+
+	au0828_init_tuner(dev);
+	i2c_gate_ctrl(dev, 1);
 	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, g_tuner, t);
+	i2c_gate_ctrl(dev, 0);
 	return 0;
 }
 
@@ -1519,10 +1565,9 @@ static int vidioc_s_tuner(struct file *file, void *priv,
 	if (t->index != 0)
 		return -EINVAL;
 
+	au0828_init_tuner(dev);
 	i2c_gate_ctrl(dev, 1);
-
 	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_tuner, t);
-
 	i2c_gate_ctrl(dev, 0);
 
 	dprintk(1, "VIDIOC_S_TUNER: signal = %x, afc = %x\n", t->signal,
@@ -1553,17 +1598,9 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 	if (freq->tuner != 0)
 		return -EINVAL;
 
+	au0828_init_tuner(dev);
 	i2c_gate_ctrl(dev, 1);
 
-	if (dev->std_set_in_tuner_core == 0) {
-		/* If we've never sent the standard in tuner core, do so now.
-		   We don't do this at device probe because we don't want to
-		   incur the cost of a firmware load */
-		v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_std,
-				     dev->vdev->tvnorms);
-		dev->std_set_in_tuner_core = 1;
-	}
-
 	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_frequency, freq);
 	/* Get the actual set (and possibly clamped) frequency */
 	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, g_frequency, freq);
@@ -1662,6 +1699,7 @@ static int vidioc_streamon(struct file *file, void *priv,
 	if (unlikely(!res_get(fh, get_ressource(fh))))
 		return -EBUSY;
 
+	au0828_init_tuner(dev);
 	if (type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
 		au0828_analog_stream_enable(dev);
 		v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_stream, 1);
-- 
1.7.10.4

