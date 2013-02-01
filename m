Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2485 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471Ab3BAMRd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Feb 2013 07:17:33 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 3/6] tm6000: add support for control events and prio handling.
Date: Fri,  1 Feb 2013 13:17:18 +0100
Message-Id: <0ce93f1b37cd9a580683349c00c1f21d9457e0a7.1359720708.git.hans.verkuil@cisco.com>
In-Reply-To: <1359721041-5133-1-git-send-email-hverkuil@xs4all.nl>
References: <1359721041-5133-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <db596a5954282c998c516d9a8ebd719df71549b3.1359720708.git.hans.verkuil@cisco.com>
References: <db596a5954282c998c516d9a8ebd719df71549b3.1359720708.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/tm6000/tm6000-video.c |   31 +++++++++++++++++++++++--------
 drivers/media/usb/tm6000/tm6000.h       |    2 ++
 2 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/tm6000/tm6000-video.c b/drivers/media/usb/tm6000/tm6000-video.c
index 4329fbc..25202a7 100644
--- a/drivers/media/usb/tm6000/tm6000-video.c
+++ b/drivers/media/usb/tm6000/tm6000-video.c
@@ -34,6 +34,7 @@
 #include <linux/usb.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-event.h>
 #include <media/tuner.h>
 #include <linux/interrupt.h>
 #include <linux/kthread.h>
@@ -1350,6 +1351,7 @@ static int __tm6000_open(struct file *file)
 		return -ENOMEM;
 	}
 
+	v4l2_fh_init(&fh->fh, vdev);
 	file->private_data = fh;
 	fh->dev      = dev;
 	fh->radio    = radio;
@@ -1393,6 +1395,7 @@ static int __tm6000_open(struct file *file)
 		tm6000_prepare_isoc(dev);
 		tm6000_start_thread(dev);
 	}
+	v4l2_fh_add(&fh->fh);
 
 	return 0;
 }
@@ -1433,29 +1436,35 @@ tm6000_read(struct file *file, char __user *data, size_t count, loff_t *pos)
 static unsigned int
 __tm6000_poll(struct file *file, struct poll_table_struct *wait)
 {
+	unsigned long req_events = poll_requested_events(wait);
 	struct tm6000_fh        *fh = file->private_data;
 	struct tm6000_buffer    *buf;
+	int res = 0;
 
+	if (v4l2_event_pending(&fh->fh))
+		res = POLLPRI;
+	else if (req_events & POLLPRI)
+		poll_wait(file, &fh->fh.wait, wait);
 	if (V4L2_BUF_TYPE_VIDEO_CAPTURE != fh->type)
-		return POLLERR;
+		return res | POLLERR;
 
 	if (!!is_res_streaming(fh->dev, fh))
-		return POLLERR;
+		return res | POLLERR;
 
 	if (!is_res_read(fh->dev, fh)) {
 		/* streaming capture */
 		if (list_empty(&fh->vb_vidq.stream))
-			return POLLERR;
+			return res | POLLERR;
 		buf = list_entry(fh->vb_vidq.stream.next, struct tm6000_buffer, vb.stream);
-	} else {
+	} else if (req_events & (POLLIN | POLLRDNORM)) {
 		/* read() capture */
-		return videobuf_poll_stream(file, &fh->vb_vidq, wait);
+		return res | videobuf_poll_stream(file, &fh->vb_vidq, wait);
 	}
 	poll_wait(file, &buf->vb.done, wait);
 	if (buf->vb.state == VIDEOBUF_DONE ||
 	    buf->vb.state == VIDEOBUF_ERROR)
-		return POLLIN | POLLRDNORM;
-	return 0;
+		return res | POLLIN | POLLRDNORM;
+	return res;
 }
 
 static unsigned int tm6000_poll(struct file *file, struct poll_table_struct *wait)
@@ -1505,7 +1514,8 @@ static int tm6000_release(struct file *file)
 		if (!fh->radio)
 			videobuf_mmap_free(&fh->vb_vidq);
 	}
-
+	v4l2_fh_del(&fh->fh);
+	v4l2_fh_exit(&fh->fh);
 	kfree(fh);
 	mutex_unlock(&dev->lock);
 
@@ -1555,6 +1565,8 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_querybuf          = vidioc_querybuf,
 	.vidioc_qbuf              = vidioc_qbuf,
 	.vidioc_dqbuf             = vidioc_dqbuf,
+	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
 static struct video_device tm6000_template = {
@@ -1579,6 +1591,8 @@ static const struct v4l2_ioctl_ops radio_ioctl_ops = {
 	.vidioc_s_tuner		= radio_s_tuner,
 	.vidioc_g_frequency	= vidioc_g_frequency,
 	.vidioc_s_frequency	= vidioc_s_frequency,
+	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
 static struct video_device tm6000_radio_template = {
@@ -1607,6 +1621,7 @@ static struct video_device *vdev_init(struct tm6000_core *dev,
 	vfd->release = video_device_release;
 	vfd->debug = tm6000_debug;
 	vfd->lock = &dev->lock;
+	set_bit(V4L2_FL_USE_FH_PRIO, &vfd->flags);
 
 	snprintf(vfd->name, sizeof(vfd->name), "%s %s", dev->name, type_name);
 
diff --git a/drivers/media/usb/tm6000/tm6000.h b/drivers/media/usb/tm6000/tm6000.h
index a9ac262..08bd074 100644
--- a/drivers/media/usb/tm6000/tm6000.h
+++ b/drivers/media/usb/tm6000/tm6000.h
@@ -28,6 +28,7 @@
 #include <linux/mutex.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
+#include <media/v4l2-fh.h>
 
 #include <linux/dvb/frontend.h>
 #include "dvb_demux.h"
@@ -290,6 +291,7 @@ struct tm6000_ops {
 };
 
 struct tm6000_fh {
+	struct v4l2_fh		     fh;
 	struct tm6000_core           *dev;
 	unsigned int                 radio;
 
-- 
1.7.10.4

