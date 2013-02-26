Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3697 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755556Ab3BZRf6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Feb 2013 12:35:58 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 01/11] s2255: convert to the control framework.
Date: Tue, 26 Feb 2013 18:35:36 +0100
Message-Id: <f11ed501c392d8891c3eefeb4959a117e5ddf94e.1361900043.git.hans.verkuil@cisco.com>
In-Reply-To: <1361900146-32759-1-git-send-email-hverkuil@xs4all.nl>
References: <1361900146-32759-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/s2255/s2255drv.c |  172 ++++++++++++------------------------
 include/uapi/linux/v4l2-controls.h |    4 +
 2 files changed, 59 insertions(+), 117 deletions(-)

diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index 498c57e..2dcb29b 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -47,6 +47,7 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-ctrls.h>
 #include <linux/vmalloc.h>
 #include <linux/usb.h>
 
@@ -217,6 +218,7 @@ struct s2255_dev;
 
 struct s2255_channel {
 	struct video_device	vdev;
+	struct v4l2_ctrl_handler hdl;
 	int			resources;
 	struct s2255_dmaqueue	vidq;
 	struct s2255_bufferi	buffer;
@@ -336,7 +338,7 @@ struct s2255_fh {
  */
 #define S2255_V4L2_YC_ON  1
 #define S2255_V4L2_YC_OFF 0
-#define V4L2_CID_PRIVATE_COLORFILTER (V4L2_CID_PRIVATE_BASE + 0)
+#define V4L2_CID_S2255_COLORFILTER (V4L2_CID_USER_S2255_BASE + 0)
 
 /* frame prefix size (sent once every frame) */
 #define PREFIX_SIZE		512
@@ -810,28 +812,6 @@ static void res_free(struct s2255_fh *fh)
 	dprintk(1, "res: put\n");
 }
 
-static int vidioc_querymenu(struct file *file, void *priv,
-			    struct v4l2_querymenu *qmenu)
-{
-	static const char *colorfilter[] = {
-		"Off",
-		"On",
-		NULL
-	};
-	if (qmenu->id == V4L2_CID_PRIVATE_COLORFILTER) {
-		int i;
-		const char **menu_items = colorfilter;
-		for (i = 0; i < qmenu->index && menu_items[i]; i++)
-			; /* do nothing (from v4l2-common.c) */
-		if (menu_items[i] == NULL || menu_items[i][0] == '\0')
-			return -EINVAL;
-		strlcpy(qmenu->name, menu_items[qmenu->index],
-			sizeof(qmenu->name));
-		return 0;
-	}
-	return v4l2_ctrl_query_menu(qmenu, NULL, NULL);
-}
-
 static int vidioc_querycap(struct file *file, void *priv,
 			   struct v4l2_capability *cap)
 {
@@ -1427,109 +1407,32 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
 	return 0;
 }
 
-/* --- controls ---------------------------------------------- */
-static int vidioc_queryctrl(struct file *file, void *priv,
-			    struct v4l2_queryctrl *qc)
+static int s2255_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	struct s2255_fh *fh = priv;
-	struct s2255_channel *channel = fh->channel;
-	struct s2255_dev *dev = fh->dev;
-	switch (qc->id) {
-	case V4L2_CID_BRIGHTNESS:
-		v4l2_ctrl_query_fill(qc, -127, 127, 1, DEF_BRIGHT);
-		break;
-	case V4L2_CID_CONTRAST:
-		v4l2_ctrl_query_fill(qc, 0, 255, 1, DEF_CONTRAST);
-		break;
-	case V4L2_CID_SATURATION:
-		v4l2_ctrl_query_fill(qc, 0, 255, 1, DEF_SATURATION);
-		break;
-	case V4L2_CID_HUE:
-		v4l2_ctrl_query_fill(qc, 0, 255, 1, DEF_HUE);
-		break;
-	case V4L2_CID_PRIVATE_COLORFILTER:
-		if (dev->dsp_fw_ver < S2255_MIN_DSP_COLORFILTER)
-			return -EINVAL;
-		if ((dev->pid == 0x2257) && (channel->idx > 1))
-			return -EINVAL;
-		strlcpy(qc->name, "Color Filter", sizeof(qc->name));
-		qc->type = V4L2_CTRL_TYPE_MENU;
-		qc->minimum = 0;
-		qc->maximum = 1;
-		qc->step = 1;
-		qc->default_value = 1;
-		qc->flags = 0;
-		break;
-	default:
-		return -EINVAL;
-	}
-	dprintk(4, "%s, id %d\n", __func__, qc->id);
-	return 0;
-}
-
-static int vidioc_g_ctrl(struct file *file, void *priv,
-			 struct v4l2_control *ctrl)
-{
-	struct s2255_fh *fh = priv;
-	struct s2255_dev *dev = fh->dev;
-	struct s2255_channel *channel = fh->channel;
-	switch (ctrl->id) {
-	case V4L2_CID_BRIGHTNESS:
-		ctrl->value = channel->mode.bright;
-		break;
-	case V4L2_CID_CONTRAST:
-		ctrl->value = channel->mode.contrast;
-		break;
-	case V4L2_CID_SATURATION:
-		ctrl->value = channel->mode.saturation;
-		break;
-	case V4L2_CID_HUE:
-		ctrl->value = channel->mode.hue;
-		break;
-	case V4L2_CID_PRIVATE_COLORFILTER:
-		if (dev->dsp_fw_ver < S2255_MIN_DSP_COLORFILTER)
-			return -EINVAL;
-		if ((dev->pid == 0x2257) && (channel->idx > 1))
-			return -EINVAL;
-		ctrl->value = !((channel->mode.color & MASK_INPUT_TYPE) >> 16);
-		break;
-	default:
-		return -EINVAL;
-	}
-	dprintk(4, "%s, id %d val %d\n", __func__, ctrl->id, ctrl->value);
-	return 0;
-}
-
-static int vidioc_s_ctrl(struct file *file, void *priv,
-			 struct v4l2_control *ctrl)
-{
-	struct s2255_fh *fh = priv;
-	struct s2255_channel *channel = fh->channel;
-	struct s2255_dev *dev = to_s2255_dev(channel->vdev.v4l2_dev);
+	struct s2255_channel *channel =
+		container_of(ctrl->handler, struct s2255_channel, hdl);
 	struct s2255_mode mode;
+
 	mode = channel->mode;
 	dprintk(4, "%s\n", __func__);
+
 	/* update the mode to the corresponding value */
 	switch (ctrl->id) {
 	case V4L2_CID_BRIGHTNESS:
-		mode.bright = ctrl->value;
+		mode.bright = ctrl->val;
 		break;
 	case V4L2_CID_CONTRAST:
-		mode.contrast = ctrl->value;
+		mode.contrast = ctrl->val;
 		break;
 	case V4L2_CID_HUE:
-		mode.hue = ctrl->value;
+		mode.hue = ctrl->val;
 		break;
 	case V4L2_CID_SATURATION:
-		mode.saturation = ctrl->value;
+		mode.saturation = ctrl->val;
 		break;
-	case V4L2_CID_PRIVATE_COLORFILTER:
-		if (dev->dsp_fw_ver < S2255_MIN_DSP_COLORFILTER)
-			return -EINVAL;
-		if ((dev->pid == 0x2257) && (channel->idx > 1))
-			return -EINVAL;
+	case V4L2_CID_S2255_COLORFILTER:
 		mode.color &= ~MASK_INPUT_TYPE;
-		mode.color |= ((ctrl->value ? 0 : 1) << 16);
+		mode.color |= !ctrl->val << 16;
 		break;
 	default:
 		return -EINVAL;
@@ -1539,7 +1442,7 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
 	   some V4L programs restart stream unnecessarily
 	   after a s_crtl.
 	*/
-	s2255_set_mode(fh->channel, &mode);
+	s2255_set_mode(channel, &mode);
 	return 0;
 }
 
@@ -1886,7 +1789,6 @@ static const struct v4l2_file_operations s2255_fops_v4l = {
 };
 
 static const struct v4l2_ioctl_ops s2255_ioctl_ops = {
-	.vidioc_querymenu = vidioc_querymenu,
 	.vidioc_querycap = vidioc_querycap,
 	.vidioc_enum_fmt_vid_cap = vidioc_enum_fmt_vid_cap,
 	.vidioc_g_fmt_vid_cap = vidioc_g_fmt_vid_cap,
@@ -1900,9 +1802,6 @@ static const struct v4l2_ioctl_ops s2255_ioctl_ops = {
 	.vidioc_enum_input = vidioc_enum_input,
 	.vidioc_g_input = vidioc_g_input,
 	.vidioc_s_input = vidioc_s_input,
-	.vidioc_queryctrl = vidioc_queryctrl,
-	.vidioc_g_ctrl = vidioc_g_ctrl,
-	.vidioc_s_ctrl = vidioc_s_ctrl,
 	.vidioc_streamon = vidioc_streamon,
 	.vidioc_streamoff = vidioc_streamoff,
 	.vidioc_s_jpegcomp = vidioc_s_jpegcomp,
@@ -1915,8 +1814,13 @@ static const struct v4l2_ioctl_ops s2255_ioctl_ops = {
 static void s2255_video_device_release(struct video_device *vdev)
 {
 	struct s2255_dev *dev = to_s2255_dev(vdev->v4l2_dev);
-	dprintk(4, "%s, chnls: %d \n", __func__,
+	struct s2255_channel *channel =
+		container_of(vdev, struct s2255_channel, vdev);
+
+	v4l2_ctrl_handler_free(&channel->hdl);
+	dprintk(4, "%s, chnls: %d\n", __func__,
 		atomic_read(&dev->num_channels));
+
 	if (atomic_dec_and_test(&dev->num_channels))
 		s2255_destroy(dev);
 	return;
@@ -1931,6 +1835,20 @@ static struct video_device template = {
 	.current_norm = V4L2_STD_NTSC_M,
 };
 
+static const struct v4l2_ctrl_ops s2255_ctrl_ops = {
+	.s_ctrl = s2255_s_ctrl,
+};
+
+static const struct v4l2_ctrl_config color_filter_ctrl = {
+	.ops = &s2255_ctrl_ops,
+	.name = "Color Filter",
+	.id = V4L2_CID_S2255_COLORFILTER,
+	.type = V4L2_CTRL_TYPE_BOOLEAN,
+	.max = 1,
+	.step = 1,
+	.def = 1,
+};
+
 static int s2255_probe_v4l(struct s2255_dev *dev)
 {
 	int ret;
@@ -1945,9 +1863,29 @@ static int s2255_probe_v4l(struct s2255_dev *dev)
 	for (i = 0; i < MAX_CHANNELS; i++) {
 		channel = &dev->channel[i];
 		INIT_LIST_HEAD(&channel->vidq.active);
+
+		v4l2_ctrl_handler_init(&channel->hdl, 5);
+		v4l2_ctrl_new_std(&channel->hdl, &s2255_ctrl_ops,
+				V4L2_CID_BRIGHTNESS, -127, 127, 1, DEF_BRIGHT);
+		v4l2_ctrl_new_std(&channel->hdl, &s2255_ctrl_ops,
+				V4L2_CID_CONTRAST, 0, 255, 1, DEF_CONTRAST);
+		v4l2_ctrl_new_std(&channel->hdl, &s2255_ctrl_ops,
+				V4L2_CID_SATURATION, 0, 255, 1, DEF_SATURATION);
+		v4l2_ctrl_new_std(&channel->hdl, &s2255_ctrl_ops,
+				V4L2_CID_HUE, 0, 255, 1, DEF_HUE);
+		if (dev->dsp_fw_ver >= S2255_MIN_DSP_COLORFILTER &&
+		    (dev->pid != 0x2257 || channel->idx <= 1))
+			v4l2_ctrl_new_custom(&channel->hdl, &color_filter_ctrl, NULL);
+		if (channel->hdl.error) {
+			ret = channel->hdl.error;
+			v4l2_ctrl_handler_free(&channel->hdl);
+			dev_err(&dev->udev->dev, "couldn't register control\n");
+			break;
+		}
 		channel->vidq.dev = dev;
 		/* register 4 video devices */
 		channel->vdev = template;
+		channel->vdev.ctrl_handler = &channel->hdl;
 		channel->vdev.lock = &dev->lock;
 		channel->vdev.v4l2_dev = &dev->v4l2_dev;
 		video_set_drvdata(&channel->vdev, channel);
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index dcd6374..f6ba2fc 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -146,6 +146,10 @@ enum v4l2_colorfx {
  * of controls. We reserve 16 controls for this driver. */
 #define V4L2_CID_USER_MEYE_BASE			(V4L2_CID_USER_BASE + 0x1000)
 
+/* The base for the s2255 driver controls.
+ * We reserve 8 controls for this driver. */
+#define V4L2_CID_USER_S2255_BASE		(V4L2_CID_USER_BASE + 0x1010)
+
 /* MPEG-class control IDs */
 
 #define V4L2_CID_MPEG_BASE 			(V4L2_CTRL_CLASS_MPEG | 0x900)
-- 
1.7.10.4

