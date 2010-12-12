Return-path: <mchehab@gaivota>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4212 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609Ab0LLRcL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Dec 2010 12:32:11 -0500
Received: from localhost.localdomain (159.80-203-19.nextgentel.com [80.203.19.159])
	(authenticated bits=0)
	by smtp-vbr5.xs4all.nl (8.13.8/8.13.8) with ESMTP id oBCHW1MO002236
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 12 Dec 2010 18:32:09 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFC/PATCH 16/19] vivi: convert to the control framework and add test controls.
Date: Sun, 12 Dec 2010 18:31:58 +0100
Message-Id: <f5855fac551ae2390ac17738fd68d9ed8a8bc4db.1292174822.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1292174822.git.hverkuil@xs4all.nl>
References: <cover.1292174822.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1292174822.git.hverkuil@xs4all.nl>
References: <cover.1292174822.git.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/vivi.c |  228 +++++++++++++++++++++++++++-----------------
 1 files changed, 139 insertions(+), 89 deletions(-)

diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index 9797e5a..6e1f37f 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -29,6 +29,7 @@
 #include <media/videobuf-vmalloc.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-ctrls.h>
 #include <media/v4l2-common.h>
 
 #define VIVI_MODULE_NAME "vivi"
@@ -162,13 +163,20 @@ static LIST_HEAD(vivi_devlist);
 struct vivi_dev {
 	struct list_head           vivi_devlist;
 	struct v4l2_device 	   v4l2_dev;
+	struct v4l2_ctrl_handler   ctrl_handler;
 
 	/* controls */
-	int 			   brightness;
-	int 			   contrast;
-	int 			   saturation;
-	int 			   hue;
-	int 			   volume;
+	struct v4l2_ctrl	   *brightness;
+	struct v4l2_ctrl	   *contrast;
+	struct v4l2_ctrl	   *saturation;
+	struct v4l2_ctrl	   *hue;
+	struct v4l2_ctrl	   *volume;
+	struct v4l2_ctrl	   *button;
+	struct v4l2_ctrl	   *boolean;
+	struct v4l2_ctrl	   *int32;
+	struct v4l2_ctrl	   *int64;
+	struct v4l2_ctrl	   *menu;
+	struct v4l2_ctrl	   *string;
 
 	spinlock_t                 slock;
 	struct mutex		   mutex;
@@ -181,6 +189,7 @@ struct vivi_dev {
 	/* Several counters */
 	unsigned 		   ms;
 	unsigned long              jiffies;
+	unsigned		   button_pressed;
 
 	int			   mv_count;	/* Controls bars movement */
 
@@ -472,14 +481,30 @@ static void vivi_fillbuff(struct vivi_dev *dev, struct vivi_buffer *buf)
 			dev->width, dev->height, dev->input);
 	gen_text(dev, vbuf, line++ * 16, 16, str);
 
+	mutex_lock(&dev->ctrl_handler.lock);
 	snprintf(str, sizeof(str), " brightness %3d, contrast %3d, saturation %3d, hue %d ",
-			dev->brightness,
-			dev->contrast,
-			dev->saturation,
-			dev->hue);
+			dev->brightness->cur.val,
+			dev->contrast->cur.val,
+			dev->saturation->cur.val,
+			dev->hue->cur.val);
 	gen_text(dev, vbuf, line++ * 16, 16, str);
-	snprintf(str, sizeof(str), " volume %3d ", dev->volume);
+	snprintf(str, sizeof(str), " volume %3d ", dev->volume->cur.val);
 	gen_text(dev, vbuf, line++ * 16, 16, str);
+	snprintf(str, sizeof(str), " int32 %d, int64 %lld ",
+			dev->int32->cur.val,
+			dev->int64->cur.val64);
+	gen_text(dev, vbuf, line++ * 16, 16, str);
+	snprintf(str, sizeof(str), " boolean %d, menu %s, string \"%s\" ",
+			dev->boolean->cur.val,
+			dev->menu->qmenu[dev->menu->cur.val],
+			dev->string->cur.string);
+	mutex_unlock(&dev->ctrl_handler.lock);
+	gen_text(dev, vbuf, line++ * 16, 16, str);
+	if (dev->button_pressed) {
+		dev->button_pressed--;
+		snprintf(str, sizeof(str), " button pressed!");
+		gen_text(dev, vbuf, line++ * 16, 16, str);
+	}
 
 	dev->mv_count += 2;
 
@@ -947,80 +972,14 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
 }
 
 /* --- controls ---------------------------------------------- */
-static int vidioc_queryctrl(struct file *file, void *priv,
-			    struct v4l2_queryctrl *qc)
-{
-	switch (qc->id) {
-	case V4L2_CID_AUDIO_VOLUME:
-		return v4l2_ctrl_query_fill(qc, 0, 255, 1, 200);
-	case V4L2_CID_BRIGHTNESS:
-		return v4l2_ctrl_query_fill(qc, 0, 255, 1, 127);
-	case V4L2_CID_CONTRAST:
-		return v4l2_ctrl_query_fill(qc, 0, 255, 1, 16);
-	case V4L2_CID_SATURATION:
-		return v4l2_ctrl_query_fill(qc, 0, 255, 1, 127);
-	case V4L2_CID_HUE:
-		return v4l2_ctrl_query_fill(qc, -128, 127, 1, 0);
-	}
-	return -EINVAL;
-}
 
-static int vidioc_g_ctrl(struct file *file, void *priv,
-			 struct v4l2_control *ctrl)
+static int vivi_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	struct vivi_dev *dev = video_drvdata(file);
+	struct vivi_dev *dev = container_of(ctrl->handler, struct vivi_dev, ctrl_handler);
 
-	switch (ctrl->id) {
-	case V4L2_CID_AUDIO_VOLUME:
-		ctrl->value = dev->volume;
-		return 0;
-	case V4L2_CID_BRIGHTNESS:
-		ctrl->value = dev->brightness;
-		return 0;
-	case V4L2_CID_CONTRAST:
-		ctrl->value = dev->contrast;
-		return 0;
-	case V4L2_CID_SATURATION:
-		ctrl->value = dev->saturation;
-		return 0;
-	case V4L2_CID_HUE:
-		ctrl->value = dev->hue;
-		return 0;
-	}
-	return -EINVAL;
-}
-
-static int vidioc_s_ctrl(struct file *file, void *priv,
-				struct v4l2_control *ctrl)
-{
-	struct vivi_dev *dev = video_drvdata(file);
-	struct v4l2_queryctrl qc;
-	int err;
-
-	qc.id = ctrl->id;
-	err = vidioc_queryctrl(file, priv, &qc);
-	if (err < 0)
-		return err;
-	if (ctrl->value < qc.minimum || ctrl->value > qc.maximum)
-		return -ERANGE;
-	switch (ctrl->id) {
-	case V4L2_CID_AUDIO_VOLUME:
-		dev->volume = ctrl->value;
-		return 0;
-	case V4L2_CID_BRIGHTNESS:
-		dev->brightness = ctrl->value;
-		return 0;
-	case V4L2_CID_CONTRAST:
-		dev->contrast = ctrl->value;
-		return 0;
-	case V4L2_CID_SATURATION:
-		dev->saturation = ctrl->value;
-		return 0;
-	case V4L2_CID_HUE:
-		dev->hue = ctrl->value;
-		return 0;
-	}
-	return -EINVAL;
+	if (ctrl == dev->button)
+		dev->button_pressed = 30;
+	return 0;
 }
 
 /* ------------------------------------------------------------------
@@ -1077,6 +1036,79 @@ static int vivi_mmap(struct file *file, struct vm_area_struct *vma)
 	return ret;
 }
 
+static const struct v4l2_ctrl_ops vivi_ctrl_ops = {
+	.s_ctrl = vivi_s_ctrl,
+};
+
+#define VIVI_CID_CUSTOM_BASE	(V4L2_CID_USER_BASE | 0xf000)
+
+static const struct v4l2_ctrl_config vivi_ctrl_button = {
+	.ops = &vivi_ctrl_ops,
+	.id = VIVI_CID_CUSTOM_BASE + 0,
+	.name = "Button",
+	.type = V4L2_CTRL_TYPE_BUTTON,
+};
+
+static const struct v4l2_ctrl_config vivi_ctrl_boolean = {
+	.ops = &vivi_ctrl_ops,
+	.id = VIVI_CID_CUSTOM_BASE + 1,
+	.name = "Boolean",
+	.type = V4L2_CTRL_TYPE_BOOLEAN,
+	.min = 0,
+	.max = 1,
+	.step = 1,
+	.def = 1,
+};
+
+static const struct v4l2_ctrl_config vivi_ctrl_int32 = {
+	.ops = &vivi_ctrl_ops,
+	.id = VIVI_CID_CUSTOM_BASE + 2,
+	.name = "Integer 32 Bits",
+	.type = V4L2_CTRL_TYPE_INTEGER,
+	.min = -2147483648,
+	.max = 2147483647,
+	.step = 1,
+};
+
+static const struct v4l2_ctrl_config vivi_ctrl_int64 = {
+	.ops = &vivi_ctrl_ops,
+	.id = VIVI_CID_CUSTOM_BASE + 3,
+	.name = "Integer 64 Bits",
+	.type = V4L2_CTRL_TYPE_INTEGER64,
+};
+
+static const char * const vivi_ctrl_menu_strings[] = {
+	"Menu Item 0 (Skipped)",
+	"Menu Item 1",
+	"Menu Item 2 (Skipped)",
+	"Menu Item 3",
+	"Menu Item 4",
+	"Menu Item 5 (Skipped)",
+	NULL,
+};
+
+static const struct v4l2_ctrl_config vivi_ctrl_menu = {
+	.ops = &vivi_ctrl_ops,
+	.id = VIVI_CID_CUSTOM_BASE + 4,
+	.name = "Menu",
+	.type = V4L2_CTRL_TYPE_MENU,
+	.min = 1,
+	.max = 4,
+	.def = 3,
+	.menu_skip_mask = 0x04,
+	.qmenu = vivi_ctrl_menu_strings,
+};
+
+static const struct v4l2_ctrl_config vivi_ctrl_string = {
+	.ops = &vivi_ctrl_ops,
+	.id = VIVI_CID_CUSTOM_BASE + 5,
+	.name = "String",
+	.type = V4L2_CTRL_TYPE_STRING,
+	.min = 2,
+	.max = 4,
+	.step = 1,
+};
+
 static const struct v4l2_file_operations vivi_fops = {
 	.owner		= THIS_MODULE,
 	.release        = vivi_close,
@@ -1102,9 +1134,6 @@ static const struct v4l2_ioctl_ops vivi_ioctl_ops = {
 	.vidioc_s_input       = vidioc_s_input,
 	.vidioc_streamon      = vidioc_streamon,
 	.vidioc_streamoff     = vidioc_streamoff,
-	.vidioc_queryctrl     = vidioc_queryctrl,
-	.vidioc_g_ctrl        = vidioc_g_ctrl,
-	.vidioc_s_ctrl        = vidioc_s_ctrl,
 #ifdef CONFIG_VIDEO_V4L1_COMPAT
 	.vidiocgmbuf          = vidiocgmbuf,
 #endif
@@ -1138,6 +1167,7 @@ static int vivi_release(void)
 			video_device_node_name(dev->vfd));
 		video_unregister_device(dev->vfd);
 		v4l2_device_unregister(&dev->v4l2_dev);
+		v4l2_ctrl_handler_free(&dev->ctrl_handler);
 		kfree(dev);
 	}
 
@@ -1148,6 +1178,7 @@ static int __init vivi_create_instance(int inst)
 {
 	struct vivi_dev *dev;
 	struct video_device *vfd;
+	struct v4l2_ctrl_handler *hdl;
 	int ret;
 
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
@@ -1163,11 +1194,29 @@ static int __init vivi_create_instance(int inst)
 	dev->fmt = &formats[0];
 	dev->width = 640;
 	dev->height = 480;
-	dev->volume = 200;
-	dev->brightness = 127;
-	dev->contrast = 16;
-	dev->saturation = 127;
-	dev->hue = 0;
+	hdl = &dev->ctrl_handler;
+	v4l2_ctrl_handler_init(hdl, 11);
+	dev->volume = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
+			V4L2_CID_AUDIO_VOLUME, 0, 255, 1, 200);
+	dev->brightness = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
+			V4L2_CID_BRIGHTNESS, 0, 255, 1, 127);
+	dev->contrast = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
+			V4L2_CID_CONTRAST, 0, 255, 1, 16);
+	dev->saturation = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
+			V4L2_CID_SATURATION, 0, 255, 1, 127);
+	dev->hue = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
+			V4L2_CID_HUE, -128, 127, 1, 0);
+	dev->button = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_button, NULL);
+	dev->int32 = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_int32, NULL);
+	dev->int64 = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_int64, NULL);
+	dev->boolean = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_boolean, NULL);
+	dev->menu = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_menu, NULL);
+	dev->string = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_string, NULL);
+	if (hdl->error) {
+		ret = hdl->error;
+		goto unreg_dev;
+	}
+	dev->v4l2_dev.ctrl_handler = hdl;
 
 	/* initialize locks */
 	spin_lock_init(&dev->slock);
@@ -1212,6 +1261,7 @@ static int __init vivi_create_instance(int inst)
 rel_vdev:
 	video_device_release(vfd);
 unreg_dev:
+	v4l2_ctrl_handler_free(hdl);
 	v4l2_device_unregister(&dev->v4l2_dev);
 free_dev:
 	kfree(dev);
-- 
1.7.0.4

