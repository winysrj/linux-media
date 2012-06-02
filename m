Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3402 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759335Ab2FBL6f (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Jun 2012 07:58:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 6/6] zr364xx: allow multiple opens.
Date: Sat,  2 Jun 2012 13:58:20 +0200
Message-Id: <824e77c414a08c5e54e8095ed0a761b0a9d02b4f.1338638167.git.hans.verkuil@cisco.com>
In-Reply-To: <1338638300-9769-1-git-send-email-hverkuil@xs4all.nl>
References: <1338638300-9769-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <dd538e942bd8b7a7fb4e02ea9b4b6df72b32f9f1.1338638167.git.hans.verkuil@cisco.com>
References: <dd538e942bd8b7a7fb4e02ea9b4b6df72b32f9f1.1338638167.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This driver allowed only one open filehandle. This is against the spec, so
fix the driver by assigning proper ownership when streaming.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/zr364xx.c |  137 +++++++++++++++--------------------------
 1 file changed, 51 insertions(+), 86 deletions(-)

diff --git a/drivers/media/video/zr364xx.c b/drivers/media/video/zr364xx.c
index bdf562d..333f696 100644
--- a/drivers/media/video/zr364xx.c
+++ b/drivers/media/video/zr364xx.c
@@ -175,6 +175,7 @@ struct zr364xx_camera {
 	struct v4l2_device v4l2_dev;
 	struct v4l2_ctrl_handler ctrl_handler;
 	struct video_device vdev;	/* v4l video device */
+	struct v4l2_fh *owner;		/* owns the streaming */
 	int nb;
 	struct zr364xx_bufferi		buffer;
 	int skip;
@@ -182,11 +183,9 @@ struct zr364xx_camera {
 	int height;
 	int method;
 	struct mutex lock;
-	int users;
 
 	spinlock_t		slock;
 	struct zr364xx_dmaqueue	vidq;
-	int			resources;
 	int			last_frame;
 	int			cur_frame;
 	unsigned long		frame_count;
@@ -474,9 +473,11 @@ static ssize_t zr364xx_read(struct file *file, char __user *buf, size_t count,
 	if (mutex_lock_interruptible(&cam->lock))
 		return -ERESTARTSYS;
 
-	if (zr364xx_vidioc_streamon(file, cam, V4L2_BUF_TYPE_VIDEO_CAPTURE) == 0) {
-		DBG("%s: reading %d bytes at pos %d.\n", __func__, (int) count,
-		    (int) *ppos);
+	err = zr364xx_vidioc_streamon(file, file->private_data,
+				V4L2_BUF_TYPE_VIDEO_CAPTURE);
+	if (err == 0) {
+		DBG("%s: reading %d bytes at pos %d.\n", __func__,
+				(int) count, (int) *ppos);
 
 		/* NoMan Sux ! */
 		err = videobuf_read_one(&cam->vb_vidq, buf, count, ppos,
@@ -698,30 +699,6 @@ static int zr364xx_read_video_callback(struct zr364xx_camera *cam,
 	return 0;
 }
 
-static int res_get(struct zr364xx_camera *cam)
-{
-	/* is it free? */
-	if (cam->resources) {
-		/* no, someone else uses it */
-		return 0;
-	}
-	/* it's free, grab it */
-	cam->resources = 1;
-	_DBG("res: get\n");
-	return 1;
-}
-
-static inline int res_check(struct zr364xx_camera *cam)
-{
-	return cam->resources;
-}
-
-static void res_free(struct zr364xx_camera *cam)
-{
-	cam->resources = 0;
-	_DBG("res: put\n");
-}
-
 static int zr364xx_vidioc_querycap(struct file *file, void *priv,
 				   struct v4l2_capability *cap)
 {
@@ -877,7 +854,7 @@ static int zr364xx_vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 		goto out;
 	}
 
-	if (res_check(cam)) {
+	if (cam->owner) {
 		DBG("%s can't change format after started\n", __func__);
 		ret = -EBUSY;
 		goto out;
@@ -885,7 +862,7 @@ static int zr364xx_vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 
 	cam->width = f->fmt.pix.width;
 	cam->height = f->fmt.pix.height;
-	dev_info(&cam->udev->dev, "%s: %dx%d mode selected\n", __func__,
+	DBG("%s: %dx%d mode selected\n", __func__,
 		 cam->width, cam->height);
 	f->fmt.pix.bytesperline = f->fmt.pix.width * 2;
 	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
@@ -955,10 +932,11 @@ out:
 static int zr364xx_vidioc_reqbufs(struct file *file, void *priv,
 			  struct v4l2_requestbuffers *p)
 {
-	int rc;
 	struct zr364xx_camera *cam = video_drvdata(file);
-	rc = videobuf_reqbufs(&cam->vb_vidq, p);
-	return rc;
+
+	if (cam->owner && cam->owner != priv)
+		return -EBUSY;
+	return videobuf_reqbufs(&cam->vb_vidq, p);
 }
 
 static int zr364xx_vidioc_querybuf(struct file *file,
@@ -978,6 +956,8 @@ static int zr364xx_vidioc_qbuf(struct file *file,
 	int rc;
 	struct zr364xx_camera *cam = video_drvdata(file);
 	_DBG("%s\n", __func__);
+	if (cam->owner && cam->owner != priv)
+		return -EBUSY;
 	rc = videobuf_qbuf(&cam->vb_vidq, p);
 	return rc;
 }
@@ -989,6 +969,8 @@ static int zr364xx_vidioc_dqbuf(struct file *file,
 	int rc;
 	struct zr364xx_camera *cam = video_drvdata(file);
 	_DBG("%s\n", __func__);
+	if (cam->owner && cam->owner != priv)
+		return -EBUSY;
 	rc = videobuf_dqbuf(&cam->vb_vidq, p, file->f_flags & O_NONBLOCK);
 	return rc;
 }
@@ -1141,7 +1123,7 @@ static int zr364xx_vidioc_streamon(struct file *file, void *priv,
 				   enum v4l2_buf_type type)
 {
 	struct zr364xx_camera *cam = video_drvdata(file);
-	int j;
+	int i, j;
 	int res;
 
 	DBG("%s\n", __func__);
@@ -1149,11 +1131,21 @@ static int zr364xx_vidioc_streamon(struct file *file, void *priv,
 	if (type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
-	if (!res_get(cam)) {
-		dev_err(&cam->udev->dev, "stream busy\n");
+	if (cam->owner && cam->owner != priv)
 		return -EBUSY;
+
+	for (i = 0; init[cam->method][i].size != -1; i++) {
+		res = send_control_msg(cam->udev, 1, init[cam->method][i].value,
+				     0, init[cam->method][i].bytes,
+				     init[cam->method][i].size);
+		if (res < 0) {
+			dev_err(&cam->udev->dev,
+				"error during open sequence: %d\n", i);
+			return res;
+		}
 	}
 
+	cam->skip = 2;
 	cam->last_frame = -1;
 	cam->cur_frame = 0;
 	cam->frame_count = 0;
@@ -1164,8 +1156,7 @@ static int zr364xx_vidioc_streamon(struct file *file, void *priv,
 	res = videobuf_streamon(&cam->vb_vidq);
 	if (res == 0) {
 		zr364xx_start_acquire(cam);
-	} else {
-		res_free(cam);
+		cam->owner = file->private_data;
 	}
 	return res;
 }
@@ -1173,18 +1164,15 @@ static int zr364xx_vidioc_streamon(struct file *file, void *priv,
 static int zr364xx_vidioc_streamoff(struct file *file, void *priv,
 				    enum v4l2_buf_type type)
 {
-	int res;
 	struct zr364xx_camera *cam = video_drvdata(file);
 
 	DBG("%s\n", __func__);
 	if (type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
+	if (cam->owner && cam->owner != priv)
+		return -EBUSY;
 	zr364xx_stop_acquire(cam);
-	res = videobuf_streamoff(&cam->vb_vidq);
-	if (res < 0)
-		return res;
-	res_free(cam);
-	return 0;
+	return videobuf_streamoff(&cam->vb_vidq);
 }
 
 
@@ -1192,46 +1180,17 @@ static int zr364xx_vidioc_streamoff(struct file *file, void *priv,
 static int zr364xx_open(struct file *file)
 {
 	struct zr364xx_camera *cam = video_drvdata(file);
-	struct usb_device *udev = cam->udev;
-	int i, err;
+	int err;
 
 	DBG("%s\n", __func__);
 
 	if (mutex_lock_interruptible(&cam->lock))
 		return -ERESTARTSYS;
 
-	if (cam->users) {
-		err = -EBUSY;
-		goto out;
-	}
-
 	err = v4l2_fh_open(file);
 	if (err)
 		goto out;
 
-	for (i = 0; init[cam->method][i].size != -1; i++) {
-		err =
-		    send_control_msg(udev, 1, init[cam->method][i].value,
-				     0, init[cam->method][i].bytes,
-				     init[cam->method][i].size);
-		if (err < 0) {
-			dev_err(&cam->udev->dev,
-				"error during open sequence: %d\n", i);
-			v4l2_fh_release(file);
-			goto out;
-		}
-	}
-
-	cam->skip = 2;
-	cam->users++;
-	cam->fmt = formats;
-
-	videobuf_queue_vmalloc_init(&cam->vb_vidq, &zr364xx_video_qops,
-				    NULL, &cam->slock,
-				    V4L2_BUF_TYPE_VIDEO_CAPTURE,
-				    V4L2_FIELD_NONE,
-				    sizeof(struct zr364xx_buffer), cam, &cam->lock);
-
 	/* Added some delay here, since opening/closing the camera quickly,
 	 * like Ekiga does during its startup, can crash the webcam
 	 */
@@ -1282,20 +1241,18 @@ static int zr364xx_close(struct file *file)
 	mutex_lock(&cam->lock);
 	udev = cam->udev;
 
-	/* turn off stream */
-	if (res_check(cam)) {
+	if (file->private_data == cam->owner) {
+		/* turn off stream */
 		if (cam->b_acquire)
 			zr364xx_stop_acquire(cam);
 		videobuf_streamoff(&cam->vb_vidq);
-		res_free(cam);
-	}
 
-	cam->users--;
-
-	for (i = 0; i < 2; i++) {
-		send_control_msg(udev, 1, init[cam->method][i].value,
-				     0, init[cam->method][i].bytes,
-				     init[cam->method][i].size);
+		for (i = 0; i < 2; i++) {
+			send_control_msg(udev, 1, init[cam->method][i].value,
+					0, init[cam->method][i].bytes,
+					init[cam->method][i].size);
+		}
+		cam->owner = NULL;
 	}
 
 	/* Added some delay here, since opening/closing the camera quickly,
@@ -1490,6 +1447,7 @@ static int zr364xx_probe(struct usb_interface *intf,
 	cam->vdev.lock = &cam->lock;
 	cam->vdev.v4l2_dev = &cam->v4l2_dev;
 	cam->vdev.ctrl_handler = &cam->ctrl_handler;
+	set_bit(V4L2_FL_USE_FH_PRIO, &cam->vdev.flags);
 	video_set_drvdata(&cam->vdev, cam);
 	if (debug)
 		cam->vdev.debug = V4L2_DEBUG_IOCTL | V4L2_DEBUG_IOCTL_ARG;
@@ -1538,7 +1496,6 @@ static int zr364xx_probe(struct usb_interface *intf,
 	header2[439] = cam->width / 256;
 	header2[440] = cam->width % 256;
 
-	cam->users = 0;
 	cam->nb = 0;
 
 	DBG("dev: %p, udev %p interface %p\n", cam, cam->udev, intf);
@@ -1575,6 +1532,14 @@ static int zr364xx_probe(struct usb_interface *intf,
 
 	spin_lock_init(&cam->slock);
 
+	cam->fmt = formats;
+
+	videobuf_queue_vmalloc_init(&cam->vb_vidq, &zr364xx_video_qops,
+				    NULL, &cam->slock,
+				    V4L2_BUF_TYPE_VIDEO_CAPTURE,
+				    V4L2_FIELD_NONE,
+				    sizeof(struct zr364xx_buffer), cam, &cam->lock);
+
 	err = video_register_device(&cam->vdev, VFL_TYPE_GRABBER, -1);
 	if (err) {
 		dev_err(&udev->dev, "video_register_device failed\n");
-- 
1.7.10

