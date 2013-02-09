Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1213 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab3BIKBS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Feb 2013 05:01:18 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Srinivasa Deevi <srinivasa.deevi@conexant.com>,
	Palash.Bandyopadhyay@conexant.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 10/26] cx231xx: add struct v4l2_fh to get prio and event support.
Date: Sat,  9 Feb 2013 11:00:40 +0100
Message-Id: <fa45f5d7301fd2bb4ec846520c8307d0bacea726.1360403310.git.hans.verkuil@cisco.com>
In-Reply-To: <1360404056-9614-1-git-send-email-hverkuil@xs4all.nl>
References: <1360404056-9614-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <9e42c08a9181147e28836646a93756f0077df9fc.1360403309.git.hans.verkuil@cisco.com>
References: <9e42c08a9181147e28836646a93756f0077df9fc.1360403309.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Required to resolve v4l2-compliance failures.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/cx231xx/cx231xx-video.c |   31 ++++++++++++++++++++++++-----
 drivers/media/usb/cx231xx/cx231xx.h       |    2 ++
 2 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index e2a4330..48a0269 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -35,6 +35,7 @@
 
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-event.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/msp3400.h>
 #include <media/tuner.h>
@@ -1870,6 +1871,7 @@ static int cx231xx_v4l2_open(struct file *filp)
 	fh->radio = radio;
 	fh->type = fh_type;
 	filp->private_data = fh;
+	v4l2_fh_init(&fh->fh, vdev);
 
 	if (fh->type == V4L2_BUF_TYPE_VIDEO_CAPTURE && dev->users == 0) {
 		dev->width = norm_maxw(dev);
@@ -1925,6 +1927,7 @@ static int cx231xx_v4l2_open(struct file *filp)
 					    fh, &dev->lock);
 	}
 	mutex_unlock(&dev->lock);
+	v4l2_fh_add(&fh->fh);
 
 	return errCode;
 }
@@ -2019,12 +2022,15 @@ static int cx231xx_close(struct file *filp)
 			else
 				cx231xx_set_alt_setting(dev, INDEX_HANC, 0);
 
+			v4l2_fh_del(&fh->fh);
+			v4l2_fh_exit(&fh->fh);
 			kfree(fh);
 			dev->users--;
 			wake_up_interruptible_nr(&dev->open, 1);
 			return 0;
 		}
 
+	v4l2_fh_del(&fh->fh);
 	dev->users--;
 	if (!dev->users) {
 		videobuf_stop(&fh->vb_vidq);
@@ -2051,6 +2057,7 @@ static int cx231xx_close(struct file *filp)
 		/* set alternate 0 */
 		cx231xx_set_alt_setting(dev, INDEX_VIDEO, 0);
 	}
+	v4l2_fh_exit(&fh->fh);
 	kfree(fh);
 	wake_up_interruptible_nr(&dev->open, 1);
 	return 0;
@@ -2107,29 +2114,37 @@ cx231xx_v4l2_read(struct file *filp, char __user *buf, size_t count,
  */
 static unsigned int cx231xx_v4l2_poll(struct file *filp, poll_table *wait)
 {
+	unsigned long req_events = poll_requested_events(wait);
 	struct cx231xx_fh *fh = filp->private_data;
 	struct cx231xx *dev = fh->dev;
+	unsigned res = 0;
 	int rc;
 
 	rc = check_dev(dev);
 	if (rc < 0)
-		return rc;
+		return POLLERR;
 
 	rc = res_get(fh);
 
 	if (unlikely(rc < 0))
 		return POLLERR;
 
+	if (v4l2_event_pending(&fh->fh))
+		res |= POLLPRI;
+	else
+		poll_wait(filp, &fh->fh.wait, wait);
+
+	if (!(req_events & (POLLIN | POLLRDNORM)))
+		return res;
+
 	if ((V4L2_BUF_TYPE_VIDEO_CAPTURE == fh->type) ||
 	    (V4L2_BUF_TYPE_VBI_CAPTURE == fh->type)) {
-		unsigned int res;
-
 		mutex_lock(&dev->lock);
-		res = videobuf_poll_stream(filp, &fh->vb_vidq, wait);
+		res |= videobuf_poll_stream(filp, &fh->vb_vidq, wait);
 		mutex_unlock(&dev->lock);
 		return res;
 	}
-	return POLLERR;
+	return res | POLLERR;
 }
 
 /*
@@ -2203,6 +2218,8 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_g_register             = vidioc_g_register,
 	.vidioc_s_register             = vidioc_s_register,
 #endif
+	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
 static struct video_device cx231xx_vbi_template;
@@ -2219,6 +2236,7 @@ static const struct v4l2_file_operations radio_fops = {
 	.owner   = THIS_MODULE,
 	.open   = cx231xx_v4l2_open,
 	.release = cx231xx_v4l2_close,
+	.poll = v4l2_ctrl_poll,
 	.ioctl   = video_ioctl2,
 };
 
@@ -2233,6 +2251,8 @@ static const struct v4l2_ioctl_ops radio_ioctl_ops = {
 	.vidioc_g_register  = vidioc_g_register,
 	.vidioc_s_register  = vidioc_s_register,
 #endif
+	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
 static struct video_device cx231xx_radio_template = {
@@ -2258,6 +2278,7 @@ static struct video_device *cx231xx_vdev_init(struct cx231xx *dev,
 	vfd->release = video_device_release;
 	vfd->debug = video_debug;
 	vfd->lock = &dev->lock;
+	set_bit(V4L2_FL_USE_FH_PRIO, &vfd->flags);
 
 	snprintf(vfd->name, sizeof(vfd->name), "%s %s", dev->name, type_name);
 
diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
index 53408ce..4c83ff5 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -34,6 +34,7 @@
 #include <media/videobuf-vmalloc.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
+#include <media/v4l2-fh.h>
 #include <media/rc-core.h>
 #include <media/ir-kbd-i2c.h>
 #include <media/videobuf-dvb.h>
@@ -429,6 +430,7 @@ struct cx231xx_audio {
 struct cx231xx;
 
 struct cx231xx_fh {
+	struct v4l2_fh fh;
 	struct cx231xx *dev;
 	unsigned int stream_on:1;	/* Locks streams */
 	int radio;
-- 
1.7.10.4

