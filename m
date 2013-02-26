Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4932 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553Ab3BZRf5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Feb 2013 12:35:57 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 03/11] s2255: add support for control events and prio handling.
Date: Tue, 26 Feb 2013 18:35:38 +0100
Message-Id: <54571ca84296bb510ac25114619a32a1e50af0ba.1361900043.git.hans.verkuil@cisco.com>
In-Reply-To: <1361900146-32759-1-git-send-email-hverkuil@xs4all.nl>
References: <1361900146-32759-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <f11ed501c392d8891c3eefeb4959a117e5ddf94e.1361900043.git.hans.verkuil@cisco.com>
References: <f11ed501c392d8891c3eefeb4959a117e5ddf94e.1361900043.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/s2255/s2255drv.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index 42c3afe..55c972a 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -43,13 +43,14 @@
 #include <linux/slab.h>
 #include <linux/videodev2.h>
 #include <linux/mm.h>
+#include <linux/vmalloc.h>
+#include <linux/usb.h>
 #include <media/videobuf-vmalloc.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-ctrls.h>
-#include <linux/vmalloc.h>
-#include <linux/usb.h>
+#include <media/v4l2-event.h>
 
 #define S2255_VERSION		"1.22.1"
 #define FIRMWARE_FILE_NAME "f2255usb.bin"
@@ -295,6 +296,8 @@ struct s2255_buffer {
 };
 
 struct s2255_fh {
+	/* this must be the first field in this struct */
+	struct v4l2_fh		fh;
 	struct s2255_dev	*dev;
 	struct videobuf_queue	vb_vidq;
 	enum v4l2_buf_type	type;
@@ -1666,7 +1669,9 @@ static int __s2255_open(struct file *file)
 	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
 	if (NULL == fh)
 		return -ENOMEM;
-	file->private_data = fh;
+	v4l2_fh_init(&fh->fh, vdev);
+	v4l2_fh_add(&fh->fh);
+	file->private_data = &fh->fh;
 	fh->dev = dev;
 	fh->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	fh->channel = channel;
@@ -1709,12 +1714,13 @@ static unsigned int s2255_poll(struct file *file,
 {
 	struct s2255_fh *fh = file->private_data;
 	struct s2255_dev *dev = fh->dev;
-	int rc;
+	int rc = v4l2_ctrl_poll(file, wait);
+
 	dprintk(100, "%s\n", __func__);
 	if (V4L2_BUF_TYPE_VIDEO_CAPTURE != fh->type)
 		return POLLERR;
 	mutex_lock(&dev->lock);
-	rc = videobuf_poll_stream(file, &fh->vb_vidq, wait);
+	rc |= videobuf_poll_stream(file, &fh->vb_vidq, wait);
 	mutex_unlock(&dev->lock);
 	return rc;
 }
@@ -1761,6 +1767,8 @@ static int s2255_release(struct file *file)
 	videobuf_mmap_free(&fh->vb_vidq);
 	mutex_unlock(&dev->lock);
 	dprintk(1, "%s (dev=%s)\n", __func__, video_device_node_name(vdev));
+	v4l2_fh_del(&fh->fh);
+	v4l2_fh_exit(&fh->fh);
 	kfree(fh);
 	return 0;
 }
@@ -1815,6 +1823,9 @@ static const struct v4l2_ioctl_ops s2255_ioctl_ops = {
 	.vidioc_s_parm = vidioc_s_parm,
 	.vidioc_g_parm = vidioc_g_parm,
 	.vidioc_enum_frameintervals = vidioc_enum_frameintervals,
+	.vidioc_log_status  = v4l2_ctrl_log_status,
+	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
 static void s2255_video_device_release(struct video_device *vdev)
@@ -1898,6 +1909,7 @@ static int s2255_probe_v4l(struct s2255_dev *dev)
 		channel->vdev.ctrl_handler = &channel->hdl;
 		channel->vdev.lock = &dev->lock;
 		channel->vdev.v4l2_dev = &dev->v4l2_dev;
+		set_bit(V4L2_FL_USE_FH_PRIO, &channel->vdev.flags);
 		video_set_drvdata(&channel->vdev, channel);
 		if (video_nr == -1)
 			ret = video_register_device(&channel->vdev,
-- 
1.7.10.4

