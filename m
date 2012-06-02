Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1878 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758929Ab2FBL6e (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Jun 2012 07:58:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 5/6] zr364xx: add support for control events.
Date: Sat,  2 Jun 2012 13:58:19 +0200
Message-Id: <82d4c189153c19795db29939171a21db8cf5040d.1338638167.git.hans.verkuil@cisco.com>
In-Reply-To: <1338638300-9769-1-git-send-email-hverkuil@xs4all.nl>
References: <1338638300-9769-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <dd538e942bd8b7a7fb4e02ea9b4b6df72b32f9f1.1338638167.git.hans.verkuil@cisco.com>
References: <dd538e942bd8b7a7fb4e02ea9b4b6df72b32f9f1.1338638167.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/zr364xx.c |   45 +++++++++++++++++------------------------
 1 file changed, 18 insertions(+), 27 deletions(-)

diff --git a/drivers/media/video/zr364xx.c b/drivers/media/video/zr364xx.c
index a1729b3..bdf562d 100644
--- a/drivers/media/video/zr364xx.c
+++ b/drivers/media/video/zr364xx.c
@@ -39,6 +39,8 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
+#include <media/v4l2-fh.h>
+#include <media/v4l2-event.h>
 #include <media/videobuf-vmalloc.h>
 
 
@@ -195,7 +197,6 @@ struct zr364xx_camera {
 
 	const struct zr364xx_fmt *fmt;
 	struct videobuf_queue	vb_vidq;
-	enum v4l2_buf_type	type;
 };
 
 /* buffer for one video frame */
@@ -473,8 +474,7 @@ static ssize_t zr364xx_read(struct file *file, char __user *buf, size_t count,
 	if (mutex_lock_interruptible(&cam->lock))
 		return -ERESTARTSYS;
 
-	if (cam->type == V4L2_BUF_TYPE_VIDEO_CAPTURE &&
-	    zr364xx_vidioc_streamon(file, cam, cam->type) == 0) {
+	if (zr364xx_vidioc_streamon(file, cam, V4L2_BUF_TYPE_VIDEO_CAPTURE) == 0) {
 		DBG("%s: reading %d bytes at pos %d.\n", __func__, (int) count,
 		    (int) *ppos);
 
@@ -1146,14 +1146,8 @@ static int zr364xx_vidioc_streamon(struct file *file, void *priv,
 
 	DBG("%s\n", __func__);
 
-	if (cam->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
-		dev_err(&cam->udev->dev, "invalid fh type0\n");
+	if (type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
-	}
-	if (cam->type != type) {
-		dev_err(&cam->udev->dev, "invalid fh type1\n");
-		return -EINVAL;
-	}
 
 	if (!res_get(cam)) {
 		dev_err(&cam->udev->dev, "stream busy\n");
@@ -1183,14 +1177,8 @@ static int zr364xx_vidioc_streamoff(struct file *file, void *priv,
 	struct zr364xx_camera *cam = video_drvdata(file);
 
 	DBG("%s\n", __func__);
-	if (cam->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
-		dev_err(&cam->udev->dev, "invalid fh type0\n");
+	if (type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
-	}
-	if (cam->type != type) {
-		dev_err(&cam->udev->dev, "invalid fh type1\n");
-		return -EINVAL;
-	}
 	zr364xx_stop_acquire(cam);
 	res = videobuf_streamoff(&cam->vb_vidq);
 	if (res < 0)
@@ -1203,7 +1191,6 @@ static int zr364xx_vidioc_streamoff(struct file *file, void *priv,
 /* open the camera */
 static int zr364xx_open(struct file *file)
 {
-	struct video_device *vdev = video_devdata(file);
 	struct zr364xx_camera *cam = video_drvdata(file);
 	struct usb_device *udev = cam->udev;
 	int i, err;
@@ -1218,6 +1205,10 @@ static int zr364xx_open(struct file *file)
 		goto out;
 	}
 
+	err = v4l2_fh_open(file);
+	if (err)
+		goto out;
+
 	for (i = 0; init[cam->method][i].size != -1; i++) {
 		err =
 		    send_control_msg(udev, 1, init[cam->method][i].value,
@@ -1226,19 +1217,18 @@ static int zr364xx_open(struct file *file)
 		if (err < 0) {
 			dev_err(&cam->udev->dev,
 				"error during open sequence: %d\n", i);
+			v4l2_fh_release(file);
 			goto out;
 		}
 	}
 
 	cam->skip = 2;
 	cam->users++;
-	file->private_data = vdev;
-	cam->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	cam->fmt = formats;
 
 	videobuf_queue_vmalloc_init(&cam->vb_vidq, &zr364xx_video_qops,
 				    NULL, &cam->slock,
-				    cam->type,
+				    V4L2_BUF_TYPE_VIDEO_CAPTURE,
 				    V4L2_FIELD_NONE,
 				    sizeof(struct zr364xx_buffer), cam, &cam->lock);
 
@@ -1301,7 +1291,6 @@ static int zr364xx_close(struct file *file)
 	}
 
 	cam->users--;
-	file->private_data = NULL;
 
 	for (i = 0; i < 2; i++) {
 		send_control_msg(udev, 1, init[cam->method][i].value,
@@ -1314,7 +1303,7 @@ static int zr364xx_close(struct file *file)
 	 */
 	mdelay(100);
 	mutex_unlock(&cam->lock);
-	return 0;
+	return v4l2_fh_release(file);
 }
 
 
@@ -1342,12 +1331,11 @@ static unsigned int zr364xx_poll(struct file *file,
 {
 	struct zr364xx_camera *cam = video_drvdata(file);
 	struct videobuf_queue *q = &cam->vb_vidq;
-	_DBG("%s\n", __func__);
+	unsigned res = v4l2_ctrl_poll(file, wait);
 
-	if (cam->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return POLLERR;
+	_DBG("%s\n", __func__);
 
-	return videobuf_poll_stream(file, q, wait);
+	return res | videobuf_poll_stream(file, q, wait);
 }
 
 static const struct v4l2_ctrl_ops zr364xx_ctrl_ops = {
@@ -1379,6 +1367,9 @@ static const struct v4l2_ioctl_ops zr364xx_ioctl_ops = {
 	.vidioc_querybuf        = zr364xx_vidioc_querybuf,
 	.vidioc_qbuf            = zr364xx_vidioc_qbuf,
 	.vidioc_dqbuf           = zr364xx_vidioc_dqbuf,
+	.vidioc_log_status      = v4l2_ctrl_log_status,
+	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
 static struct video_device zr364xx_template = {
-- 
1.7.10

