Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33860 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754810Ab2EGTUg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 May 2012 15:20:36 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: hverkuil@xs4all.nl, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 15/23] gspca: Don't use the global video_dev lock for fops other then ioctl
Date: Mon,  7 May 2012 21:01:26 +0200
Message-Id: <1336417294-4566-16-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1336417294-4566-1-git-send-email-hdegoede@redhat.com>
References: <1336417294-4566-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Otherwise we can get an undesirable high latency on poll().

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/video/gspca/gspca.c |   25 ++++++++++++++++++++-----
 drivers/media/video/gspca/gspca.h |    8 ++++++--
 2 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
index b3af68c..8dca187 100644
--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -1323,8 +1323,15 @@ static int dev_close(struct file *file)
 	struct gspca_dev *gspca_dev = video_drvdata(file);
 
 	PDEBUG(D_STREAM, "[%s] close", current->comm);
-	if (mutex_lock_interruptible(&gspca_dev->queue_lock))
+
+	/* Needed for gspca_stream_off, always lock before queue_lock! */
+	if (mutex_lock_interruptible(&gspca_dev->usb_lock))
+		return -ERESTARTSYS;
+
+	if (mutex_lock_interruptible(&gspca_dev->queue_lock)) {
+		mutex_unlock(&gspca_dev->usb_lock);
 		return -ERESTARTSYS;
+	}
 
 	/* if the file did the capture, free the streaming resources */
 	if (gspca_dev->capt_file == file) {
@@ -1336,6 +1343,7 @@ static int dev_close(struct file *file)
 	}
 	module_put(gspca_dev->module);
 	mutex_unlock(&gspca_dev->queue_lock);
+	mutex_unlock(&gspca_dev->usb_lock);
 
 	PDEBUG(D_STREAM, "close done");
 
@@ -1981,6 +1989,10 @@ static int read_alloc(struct gspca_dev *gspca_dev,
 	int i, ret;
 
 	PDEBUG(D_STREAM, "read alloc");
+
+	if (mutex_lock_interruptible(&gspca_dev->usb_lock))
+		return -ERESTARTSYS;
+
 	if (gspca_dev->nframes == 0) {
 		struct v4l2_requestbuffers rb;
 
@@ -1991,7 +2003,7 @@ static int read_alloc(struct gspca_dev *gspca_dev,
 		ret = vidioc_reqbufs(file, gspca_dev, &rb);
 		if (ret != 0) {
 			PDEBUG(D_STREAM, "read reqbuf err %d", ret);
-			return ret;
+			goto out;
 		}
 		memset(&v4l2_buf, 0, sizeof v4l2_buf);
 		v4l2_buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
@@ -2001,7 +2013,7 @@ static int read_alloc(struct gspca_dev *gspca_dev,
 			ret = vidioc_qbuf(file, gspca_dev, &v4l2_buf);
 			if (ret != 0) {
 				PDEBUG(D_STREAM, "read qbuf err: %d", ret);
-				return ret;
+				goto out;
 			}
 		}
 		gspca_dev->memory = GSPCA_MEMORY_READ;
@@ -2011,6 +2023,8 @@ static int read_alloc(struct gspca_dev *gspca_dev,
 	ret = vidioc_streamon(file, gspca_dev, V4L2_BUF_TYPE_VIDEO_CAPTURE);
 	if (ret != 0)
 		PDEBUG(D_STREAM, "read streamon err %d", ret);
+out:
+	mutex_unlock(&gspca_dev->usb_lock);
 	return ret;
 }
 
@@ -2266,13 +2280,14 @@ int gspca_dev_probe2(struct usb_interface *intf,
 	if (ret)
 		goto out;
 
-	/* These ioctls use just queue_lock and not usb_lock.
-	   This improves latency if the usb lock is taken for a
+	/* These ioctls and the non ioctl fops use just queue_lock and not
+	   usb_lock. This improves latency if the usb lock is taken for a
 	   long time, e.g. when changing a control value, and a
 	   new frame is ready to be dequeued. */
 	v4l2_dont_use_lock(&gspca_dev->vdev, VIDIOC_DQBUF);
 	v4l2_dont_use_lock(&gspca_dev->vdev, VIDIOC_QBUF);
 	v4l2_dont_use_lock(&gspca_dev->vdev, VIDIOC_QUERYBUF);
+	set_bit(V4L2_FL_DONT_USE_LOCK, &gspca_dev->vdev.flags);
 
 	/* init video stuff */
 	ret = video_register_device(&gspca_dev->vdev,
diff --git a/drivers/media/video/gspca/gspca.h b/drivers/media/video/gspca/gspca.h
index c1ebf7c..224d4d6 100644
--- a/drivers/media/video/gspca/gspca.h
+++ b/drivers/media/video/gspca/gspca.h
@@ -162,7 +162,7 @@ struct gspca_dev {
 	struct module *module;		/* subdriver handling the device */
 	struct v4l2_device v4l2_dev;
 	struct usb_device *dev;
-	struct file *capt_file;		/* file doing video capture */
+	struct file *capt_file;		/* file doing video capture (*) */
 #if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
 	struct input_dev *input_dev;
 	char phys[64];			/* physical device path */
@@ -192,7 +192,7 @@ struct gspca_dev {
 	u8 fr_o;				/* next frame to dequeue */
 	__u8 last_packet_type;
 	__s8 empty_packet;		/* if (-1) don't check empty packets */
-	__u8 streaming;
+	__u8 streaming;			/* protected by usb_lock */
 
 	__u8 curr_mode;			/* current camera mode */
 	__u32 pixfmt;			/* current mode parameters */
@@ -214,6 +214,10 @@ struct gspca_dev {
 	__u8 iface;			/* USB interface number */
 	__u8 alt;			/* USB alternate setting */
 	u8 audio;			/* presence of audio device */
+
+	/* (*) These variables are proteced by both usb_lock and queue_lock,
+	   that is any code setting them is holding *both*, which means that
+	   any code getting them needs to hold at least one of them */
 };
 
 int gspca_dev_probe(struct usb_interface *intf,
-- 
1.7.10

