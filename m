Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4826 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759812Ab2FBL6d (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Jun 2012 07:58:33 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 3/6] zr364xx: convert to the control framework.
Date: Sat,  2 Jun 2012 13:58:17 +0200
Message-Id: <04cdbf1c58fd3fe3cfa9e7becbf2db69abadb36f.1338638167.git.hans.verkuil@cisco.com>
In-Reply-To: <1338638300-9769-1-git-send-email-hverkuil@xs4all.nl>
References: <1338638300-9769-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <dd538e942bd8b7a7fb4e02ea9b4b6df72b32f9f1.1338638167.git.hans.verkuil@cisco.com>
References: <dd538e942bd8b7a7fb4e02ea9b4b6df72b32f9f1.1338638167.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/zr364xx.c |  111 +++++++++++++----------------------------
 1 file changed, 36 insertions(+), 75 deletions(-)

diff --git a/drivers/media/video/zr364xx.c b/drivers/media/video/zr364xx.c
index 95fd990..974515d 100644
--- a/drivers/media/video/zr364xx.c
+++ b/drivers/media/video/zr364xx.c
@@ -38,6 +38,7 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-device.h>
+#include <media/v4l2-ctrls.h>
 #include <media/videobuf-vmalloc.h>
 
 
@@ -121,11 +122,6 @@ static struct usb_device_id device_table[] = {
 
 MODULE_DEVICE_TABLE(usb, device_table);
 
-struct zr364xx_mode {
-	u32 color;	/* output video color format */
-	u32 brightness;	/* brightness */
-};
-
 /* frame structure */
 struct zr364xx_framei {
 	unsigned long ulState;	/* ulState:ZR364XX_READ_IDLE,
@@ -175,6 +171,7 @@ struct zr364xx_camera {
 	struct usb_device *udev;	/* save off the usb device pointer */
 	struct usb_interface *interface;/* the interface for this device */
 	struct v4l2_device v4l2_dev;
+	struct v4l2_ctrl_handler ctrl_handler;
 	struct video_device vdev;	/* v4l video device */
 	int nb;
 	struct zr364xx_bufferi		buffer;
@@ -199,7 +196,6 @@ struct zr364xx_camera {
 	const struct zr364xx_fmt *fmt;
 	struct videobuf_queue	vb_vidq;
 	enum v4l2_buf_type	type;
-	struct zr364xx_mode	mode;
 };
 
 /* buffer for one video frame */
@@ -767,47 +763,17 @@ static int zr364xx_vidioc_s_input(struct file *file, void *priv,
 	return 0;
 }
 
-static int zr364xx_vidioc_queryctrl(struct file *file, void *priv,
-				    struct v4l2_queryctrl *c)
+static int zr364xx_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	struct zr364xx_camera *cam;
-
-	if (file == NULL)
-		return -ENODEV;
-	cam = video_drvdata(file);
-
-	switch (c->id) {
-	case V4L2_CID_BRIGHTNESS:
-		c->type = V4L2_CTRL_TYPE_INTEGER;
-		strcpy(c->name, "Brightness");
-		c->minimum = 0;
-		c->maximum = 127;
-		c->step = 1;
-		c->default_value = cam->mode.brightness;
-		c->flags = 0;
-		break;
-	default:
-		return -EINVAL;
-	}
-	return 0;
-}
-
-static int zr364xx_vidioc_s_ctrl(struct file *file, void *priv,
-				 struct v4l2_control *c)
-{
-	struct zr364xx_camera *cam;
+	struct zr364xx_camera *cam =
+		container_of(ctrl->handler, struct zr364xx_camera, ctrl_handler);
 	int temp;
 
-	if (file == NULL)
-		return -ENODEV;
-	cam = video_drvdata(file);
-
-	switch (c->id) {
+	switch (ctrl->id) {
 	case V4L2_CID_BRIGHTNESS:
-		cam->mode.brightness = c->value;
 		/* hardware brightness */
 		send_control_msg(cam->udev, 1, 0x2001, 0, NULL, 0);
-		temp = (0x60 << 8) + 127 - cam->mode.brightness;
+		temp = (0x60 << 8) + 127 - ctrl->val;
 		send_control_msg(cam->udev, 1, temp, 0, NULL, 0);
 		break;
 	default:
@@ -817,25 +783,6 @@ static int zr364xx_vidioc_s_ctrl(struct file *file, void *priv,
 	return 0;
 }
 
-static int zr364xx_vidioc_g_ctrl(struct file *file, void *priv,
-				 struct v4l2_control *c)
-{
-	struct zr364xx_camera *cam;
-
-	if (file == NULL)
-		return -ENODEV;
-	cam = video_drvdata(file);
-
-	switch (c->id) {
-	case V4L2_CID_BRIGHTNESS:
-		c->value = cam->mode.brightness;
-		break;
-	default:
-		return -EINVAL;
-	}
-	return 0;
-}
-
 static int zr364xx_vidioc_enum_fmt_vid_cap(struct file *file,
 				       void *priv, struct v4l2_fmtdesc *f)
 {
@@ -944,7 +891,6 @@ static int zr364xx_vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 	f->fmt.pix.colorspace = 0;
 	f->fmt.pix.priv = 0;
 	cam->vb_vidq.field = f->fmt.pix.field;
-	cam->mode.color = V4L2_PIX_FMT_JPEG;
 
 	if (f->fmt.pix.width == 160 && f->fmt.pix.height == 120)
 		mode = 1;
@@ -1326,6 +1272,7 @@ static void zr364xx_release(struct v4l2_device *v4l2_dev)
 		cam->buffer.frame[i].lpvbits = NULL;
 	}
 
+	v4l2_ctrl_handler_free(&cam->ctrl_handler);
 	/* release transfer buffer */
 	kfree(cam->pipe->transfer_buffer);
 	kfree(cam);
@@ -1402,6 +1349,10 @@ static unsigned int zr364xx_poll(struct file *file,
 	return videobuf_poll_stream(file, q, wait);
 }
 
+static const struct v4l2_ctrl_ops zr364xx_ctrl_ops = {
+	.s_ctrl = zr364xx_s_ctrl,
+};
+
 static const struct v4l2_file_operations zr364xx_fops = {
 	.owner = THIS_MODULE,
 	.open = zr364xx_open,
@@ -1423,9 +1374,6 @@ static const struct v4l2_ioctl_ops zr364xx_ioctl_ops = {
 	.vidioc_s_input		= zr364xx_vidioc_s_input,
 	.vidioc_streamon	= zr364xx_vidioc_streamon,
 	.vidioc_streamoff	= zr364xx_vidioc_streamoff,
-	.vidioc_queryctrl	= zr364xx_vidioc_queryctrl,
-	.vidioc_g_ctrl		= zr364xx_vidioc_g_ctrl,
-	.vidioc_s_ctrl		= zr364xx_vidioc_s_ctrl,
 	.vidioc_reqbufs         = zr364xx_vidioc_reqbufs,
 	.vidioc_querybuf        = zr364xx_vidioc_querybuf,
 	.vidioc_qbuf            = zr364xx_vidioc_qbuf,
@@ -1510,6 +1458,7 @@ static int zr364xx_probe(struct usb_interface *intf,
 	struct zr364xx_camera *cam = NULL;
 	struct usb_host_interface *iface_desc;
 	struct usb_endpoint_descriptor *endpoint;
+	struct v4l2_ctrl_handler *hdl;
 	int err;
 	int i;
 
@@ -1533,12 +1482,22 @@ static int zr364xx_probe(struct usb_interface *intf,
 		kfree(cam);
 		return err;
 	}
+	hdl = &cam->ctrl_handler;
+	v4l2_ctrl_handler_init(hdl, 1);
+	v4l2_ctrl_new_std(hdl, &zr364xx_ctrl_ops,
+			  V4L2_CID_BRIGHTNESS, 0, 127, 1, 64);
+	if (hdl->error) {
+		err = hdl->error;
+		dev_err(&udev->dev, "couldn't register control\n");
+		goto fail;
+	}
 	/* save the init method used by this camera */
 	cam->method = id->driver_info;
 	mutex_init(&cam->lock);
 	cam->vdev = zr364xx_template;
 	cam->vdev.lock = &cam->lock;
 	cam->vdev.v4l2_dev = &cam->v4l2_dev;
+	cam->vdev.ctrl_handler = &cam->ctrl_handler;
 	video_set_drvdata(&cam->vdev, cam);
 	if (debug)
 		cam->vdev.debug = V4L2_DEBUG_IOCTL | V4L2_DEBUG_IOCTL_ARG;
@@ -1589,7 +1548,6 @@ static int zr364xx_probe(struct usb_interface *intf,
 
 	cam->users = 0;
 	cam->nb = 0;
-	cam->mode.brightness = 64;
 
 	DBG("dev: %p, udev %p interface %p\n", cam, cam->udev, intf);
 
@@ -1605,10 +1563,9 @@ static int zr364xx_probe(struct usb_interface *intf,
 	}
 
 	if (!cam->read_endpoint) {
+		err = -ENOMEM;
 		dev_err(&intf->dev, "Could not find bulk-in endpoint\n");
-		v4l2_device_unregister(&cam->v4l2_dev);
-		kfree(cam);
-		return -ENOMEM;
+		goto fail;
 	}
 
 	/* v4l */
@@ -1619,24 +1576,28 @@ static int zr364xx_probe(struct usb_interface *intf,
 
 	/* load zr364xx board specific */
 	err = zr364xx_board_init(cam);
-	if (err) {
-		kfree(cam);
-		return err;
-	}
+	if (!err)
+		err = v4l2_ctrl_handler_setup(hdl);
+	if (err)
+		goto fail;
 
 	spin_lock_init(&cam->slock);
 
 	err = video_register_device(&cam->vdev, VFL_TYPE_GRABBER, -1);
 	if (err) {
 		dev_err(&udev->dev, "video_register_device failed\n");
-		v4l2_device_unregister(&cam->v4l2_dev);
-		kfree(cam);
-		return err;
+		goto fail;
 	}
 
 	dev_info(&udev->dev, DRIVER_DESC " controlling device %s\n",
 		 video_device_node_name(&cam->vdev));
 	return 0;
+
+fail:
+	v4l2_ctrl_handler_free(hdl);
+	v4l2_device_unregister(&cam->v4l2_dev);
+	kfree(cam);
+	return err;
 }
 
 
-- 
1.7.10

