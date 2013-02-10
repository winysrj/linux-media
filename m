Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1401 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756078Ab3BJRxF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Feb 2013 12:53:05 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 04/12] stk-webcam: convert to the control framework.
Date: Sun, 10 Feb 2013 18:52:45 +0100
Message-Id: <c028ec1b64de15125a0d232fc4ff71bda1bf2395.1360518391.git.hans.verkuil@cisco.com>
In-Reply-To: <1360518773-1065-1-git-send-email-hverkuil@xs4all.nl>
References: <1360518773-1065-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <21a2f157a80755483630be6aab26f67dc9f041c6.1360518390.git.hans.verkuil@cisco.com>
References: <21a2f157a80755483630be6aab26f67dc9f041c6.1360518390.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Arvydas Sidorenko <asido4@gmail.com>
---
 drivers/media/usb/stkwebcam/stk-webcam.c |  119 ++++++++----------------------
 drivers/media/usb/stkwebcam/stk-webcam.h |    3 +-
 2 files changed, 33 insertions(+), 89 deletions(-)

diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c b/drivers/media/usb/stkwebcam/stk-webcam.c
index f21ba43..aef7365 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.c
+++ b/drivers/media/usb/stkwebcam/stk-webcam.c
@@ -768,99 +768,25 @@ static int stk_vidioc_s_input(struct file *filp, void *priv, unsigned int i)
 		return 0;
 }
 
-/* List of all V4Lv2 controls supported by the driver */
-static struct v4l2_queryctrl stk_controls[] = {
-	{
-		.id      = V4L2_CID_BRIGHTNESS,
-		.type    = V4L2_CTRL_TYPE_INTEGER,
-		.name    = "Brightness",
-		.minimum = 0,
-		.maximum = 0xffff,
-		.step    = 0x0100,
-		.default_value = 0x6000,
-	},
-	{
-		.id      = V4L2_CID_HFLIP,
-		.type    = V4L2_CTRL_TYPE_BOOLEAN,
-		.name    = "Horizontal Flip",
-		.minimum = 0,
-		.maximum = 1,
-		.step    = 1,
-		.default_value = 1,
-	},
-	{
-		.id      = V4L2_CID_VFLIP,
-		.type    = V4L2_CTRL_TYPE_BOOLEAN,
-		.name    = "Vertical Flip",
-		.minimum = 0,
-		.maximum = 1,
-		.step    = 1,
-		.default_value = 1,
-	},
-};
-
-static int stk_vidioc_queryctrl(struct file *filp,
-		void *priv, struct v4l2_queryctrl *c)
+static int stk_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	int i;
-	int nbr;
-	nbr = ARRAY_SIZE(stk_controls);
-
-	for (i = 0; i < nbr; i++) {
-		if (stk_controls[i].id == c->id) {
-			memcpy(c, &stk_controls[i],
-				sizeof(struct v4l2_queryctrl));
-			return 0;
-		}
-	}
-	return -EINVAL;
-}
-
-static int stk_vidioc_g_ctrl(struct file *filp,
-		void *priv, struct v4l2_control *c)
-{
-	struct stk_camera *dev = priv;
-	switch (c->id) {
-	case V4L2_CID_BRIGHTNESS:
-		c->value = dev->vsettings.brightness;
-		break;
-	case V4L2_CID_HFLIP:
-		if (dmi_check_system(stk_upside_down_dmi_table))
-			c->value = !dev->vsettings.hflip;
-		else
-			c->value = dev->vsettings.hflip;
-		break;
-	case V4L2_CID_VFLIP:
-		if (dmi_check_system(stk_upside_down_dmi_table))
-			c->value = !dev->vsettings.vflip;
-		else
-			c->value = dev->vsettings.vflip;
-		break;
-	default:
-		return -EINVAL;
-	}
-	return 0;
-}
+	struct stk_camera *dev =
+		container_of(ctrl->handler, struct stk_camera, hdl);
 
-static int stk_vidioc_s_ctrl(struct file *filp,
-		void *priv, struct v4l2_control *c)
-{
-	struct stk_camera *dev = priv;
-	switch (c->id) {
+	switch (ctrl->id) {
 	case V4L2_CID_BRIGHTNESS:
-		dev->vsettings.brightness = c->value;
-		return stk_sensor_set_brightness(dev, c->value >> 8);
+		return stk_sensor_set_brightness(dev, ctrl->val);
 	case V4L2_CID_HFLIP:
 		if (dmi_check_system(stk_upside_down_dmi_table))
-			dev->vsettings.hflip = !c->value;
+			dev->vsettings.hflip = !ctrl->val;
 		else
-			dev->vsettings.hflip = c->value;
+			dev->vsettings.hflip = ctrl->val;
 		return 0;
 	case V4L2_CID_VFLIP:
 		if (dmi_check_system(stk_upside_down_dmi_table))
-			dev->vsettings.vflip = !c->value;
+			dev->vsettings.vflip = !ctrl->val;
 		else
-			dev->vsettings.vflip = c->value;
+			dev->vsettings.vflip = ctrl->val;
 		return 0;
 	default:
 		return -EINVAL;
@@ -1200,6 +1126,10 @@ static int stk_vidioc_enum_framesizes(struct file *filp,
 	}
 }
 
+static const struct v4l2_ctrl_ops stk_ctrl_ops = {
+	.s_ctrl = stk_s_ctrl,
+};
+
 static struct v4l2_file_operations v4l_stk_fops = {
 	.owner = THIS_MODULE,
 	.open = v4l_stk_open,
@@ -1225,9 +1155,6 @@ static const struct v4l2_ioctl_ops v4l_stk_ioctl_ops = {
 	.vidioc_dqbuf = stk_vidioc_dqbuf,
 	.vidioc_streamon = stk_vidioc_streamon,
 	.vidioc_streamoff = stk_vidioc_streamoff,
-	.vidioc_queryctrl = stk_vidioc_queryctrl,
-	.vidioc_g_ctrl = stk_vidioc_g_ctrl,
-	.vidioc_s_ctrl = stk_vidioc_s_ctrl,
 	.vidioc_g_parm = stk_vidioc_g_parm,
 	.vidioc_enum_framesizes = stk_vidioc_enum_framesizes,
 };
@@ -1272,8 +1199,9 @@ static int stk_register_video_device(struct stk_camera *dev)
 static int stk_camera_probe(struct usb_interface *interface,
 		const struct usb_device_id *id)
 {
-	int i;
+	struct v4l2_ctrl_handler *hdl;
 	int err = 0;
+	int i;
 
 	struct stk_camera *dev = NULL;
 	struct usb_device *udev = interface_to_usbdev(interface);
@@ -1291,6 +1219,20 @@ static int stk_camera_probe(struct usb_interface *interface,
 		kfree(dev);
 		return err;
 	}
+	hdl = &dev->hdl;
+	v4l2_ctrl_handler_init(hdl, 3);
+	v4l2_ctrl_new_std(hdl, &stk_ctrl_ops,
+			  V4L2_CID_BRIGHTNESS, 0, 0xff, 0x1, 0x60);
+	v4l2_ctrl_new_std(hdl, &stk_ctrl_ops,
+			  V4L2_CID_HFLIP, 0, 1, 1, 1);
+	v4l2_ctrl_new_std(hdl, &stk_ctrl_ops,
+			  V4L2_CID_VFLIP, 0, 1, 1, 1);
+	if (hdl->error) {
+		err = hdl->error;
+		dev_err(&udev->dev, "couldn't register control\n");
+		goto error;
+	}
+	dev->v4l2_dev.ctrl_handler = hdl;
 
 	spin_lock_init(&dev->spinlock);
 	init_waitqueue_head(&dev->wait_frame);
@@ -1334,7 +1276,6 @@ static int stk_camera_probe(struct usb_interface *interface,
 		err = -ENODEV;
 		goto error;
 	}
-	dev->vsettings.brightness = 0x7fff;
 	dev->vsettings.palette = V4L2_PIX_FMT_RGB565;
 	dev->vsettings.mode = MODE_VGA;
 	dev->frame_size = 640 * 480 * 2;
@@ -1351,6 +1292,7 @@ static int stk_camera_probe(struct usb_interface *interface,
 	return 0;
 
 error:
+	v4l2_ctrl_handler_free(hdl);
 	v4l2_device_unregister(&dev->v4l2_dev);
 	kfree(dev);
 	return err;
@@ -1369,6 +1311,7 @@ static void stk_camera_disconnect(struct usb_interface *interface)
 		 video_device_node_name(&dev->vdev));
 
 	video_unregister_device(&dev->vdev);
+	v4l2_ctrl_handler_free(&dev->hdl);
 	v4l2_device_unregister(&dev->v4l2_dev);
 }
 
diff --git a/drivers/media/usb/stkwebcam/stk-webcam.h b/drivers/media/usb/stkwebcam/stk-webcam.h
index 49ebe85..901f0df 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.h
+++ b/drivers/media/usb/stkwebcam/stk-webcam.h
@@ -24,6 +24,7 @@
 
 #include <linux/usb.h>
 #include <media/v4l2-device.h>
+#include <media/v4l2-ctrls.h>
 #include <media/v4l2-common.h>
 
 #define DRIVER_VERSION		"v0.0.1"
@@ -60,7 +61,6 @@ enum stk_mode {MODE_VGA, MODE_SXGA, MODE_CIF, MODE_QVGA, MODE_QCIF};
 
 struct stk_video {
 	enum stk_mode mode;
-	int brightness;
 	__u32 palette;
 	int hflip;
 	int vflip;
@@ -93,6 +93,7 @@ struct regval {
 
 struct stk_camera {
 	struct v4l2_device v4l2_dev;
+	struct v4l2_ctrl_handler hdl;
 	struct video_device vdev;
 	struct usb_device *udev;
 	struct usb_interface *interface;
-- 
1.7.10.4

