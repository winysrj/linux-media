Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:44015 "EHLO butterbrot.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754049AbeBGNAp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Feb 2018 08:00:45 -0500
From: Florian Echtler <floe@butterbrot.org>
To: hverkuil@xs4all.nl, linux-media@vger.kernel.org
Cc: linux-input@vger.kernel.org, modin@yuri.at,
        Florian Echtler <floe@butterbrot.org>
Subject: [PATCH 4/4] add video control handlers using V4L2 control framework
Date: Wed,  7 Feb 2018 14:00:38 +0100
Message-Id: <1518008438-26603-5-git-send-email-floe@butterbrot.org>
In-Reply-To: <1518008438-26603-1-git-send-email-floe@butterbrot.org>
References: <1518008438-26603-1-git-send-email-floe@butterbrot.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch registers four standard control handlers using the corresponding
V4L2 framework.

Signed-off-by: Florian Echtler <floe@butterbrot.org>
---
 drivers/input/touchscreen/sur40.c | 64 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/drivers/input/touchscreen/sur40.c b/drivers/input/touchscreen/sur40.c
index d6fa25e..b92325b 100644
--- a/drivers/input/touchscreen/sur40.c
+++ b/drivers/input/touchscreen/sur40.c
@@ -38,6 +38,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-ctrls.h>
 #include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-dma-sg.h>
 
@@ -209,6 +210,7 @@ struct sur40_state {
 	struct video_device vdev;
 	struct mutex lock;
 	struct v4l2_pix_format pix_fmt;
+	struct v4l2_ctrl_handler ctrls;
 
 	struct vb2_queue queue;
 	struct list_head buf_list;
@@ -218,6 +220,7 @@ struct sur40_state {
 	struct sur40_data *bulk_in_buffer;
 	size_t bulk_in_size;
 	u8 bulk_in_epaddr;
+	u8 vsvideo;
 
 	char phys[64];
 };
@@ -231,6 +234,11 @@ struct sur40_buffer {
 static const struct video_device sur40_video_device;
 static const struct vb2_queue sur40_queue;
 static void sur40_process_video(struct sur40_state *sur40);
+static int sur40_s_ctrl(struct v4l2_ctrl *ctrl);
+
+static const struct v4l2_ctrl_ops sur40_ctrl_ops = {
+	.s_ctrl = sur40_s_ctrl,
+};
 
 /*
  * Note: an earlier, non-public version of this driver used USB_RECIP_ENDPOINT
@@ -737,6 +745,36 @@ static int sur40_probe(struct usb_interface *interface,
 	sur40->vdev.queue = &sur40->queue;
 	video_set_drvdata(&sur40->vdev, sur40);
 
+	/* initialize the control handler for 4 controls */
+	v4l2_ctrl_handler_init(&sur40->ctrls, 4);
+	sur40->v4l2.ctrl_handler = &sur40->ctrls;
+	sur40->vsvideo = (SUR40_CONTRAST_DEF << 4) | SUR40_GAIN_DEF;
+
+	v4l2_ctrl_new_std(&sur40->ctrls, &sur40_ctrl_ops, V4L2_CID_BRIGHTNESS,
+	  SUR40_BRIGHTNESS_MIN, SUR40_BRIGHTNESS_MAX, 1, clamp(brightness,
+	  (uint)SUR40_BRIGHTNESS_MIN, (uint)SUR40_BRIGHTNESS_MAX));
+
+	v4l2_ctrl_new_std(&sur40->ctrls, &sur40_ctrl_ops, V4L2_CID_CONTRAST,
+	  SUR40_CONTRAST_MIN, SUR40_CONTRAST_MAX, 1, clamp(contrast,
+	  (uint)SUR40_CONTRAST_MIN, (uint)SUR40_CONTRAST_MAX));
+
+	v4l2_ctrl_new_std(&sur40->ctrls, &sur40_ctrl_ops, V4L2_CID_GAIN,
+	  SUR40_GAIN_MIN, SUR40_GAIN_MAX, 1, clamp(gain,
+	  (uint)SUR40_GAIN_MIN, (uint)SUR40_GAIN_MAX));
+
+	v4l2_ctrl_new_std(&sur40->ctrls, &sur40_ctrl_ops,
+	  V4L2_CID_BACKLIGHT_COMPENSATION, SUR40_BACKLIGHT_MIN,
+	  SUR40_BACKLIGHT_MAX, 1, SUR40_BACKLIGHT_DEF);
+
+	v4l2_ctrl_handler_setup(&sur40->ctrls);
+
+	if (sur40->ctrls.error) {
+		dev_err(&interface->dev,
+			"Unable to register video controls.");
+		v4l2_ctrl_handler_free(&sur40->ctrls);
+		goto err_unreg_v4l2;
+	}
+
 	error = video_register_device(&sur40->vdev, VFL_TYPE_TOUCH, -1);
 	if (error) {
 		dev_err(&interface->dev,
@@ -769,6 +807,7 @@ static void sur40_disconnect(struct usb_interface *interface)
 {
 	struct sur40_state *sur40 = usb_get_intfdata(interface);
 
+	v4l2_ctrl_handler_free(&sur40->ctrls);
 	video_unregister_device(&sur40->vdev);
 	v4l2_device_unregister(&sur40->v4l2);
 
@@ -962,6 +1001,31 @@ static int sur40_vidioc_g_fmt(struct file *file, void *priv,
 	return 0;
 }
 
+static int sur40_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct sur40_state *sur40  = container_of(ctrl->handler,
+	  struct sur40_state, ctrls);
+	u8 value = sur40->vsvideo;
+
+	switch (ctrl->id) {
+	case V4L2_CID_BRIGHTNESS:
+		sur40_set_irlevel(sur40, ctrl->val);
+		break;
+	case V4L2_CID_CONTRAST:
+		value = (value & 0x0F) | (ctrl->val << 4);
+		sur40_set_vsvideo(sur40, value);
+		break;
+	case V4L2_CID_GAIN:
+		value = (value & 0xF0) | (ctrl->val);
+		sur40_set_vsvideo(sur40, value);
+		break;
+	case V4L2_CID_BACKLIGHT_COMPENSATION:
+		sur40_set_preprocessor(sur40, ctrl->val);
+		break;
+	}
+	return 0;
+}
+
 static int sur40_ioctl_parm(struct file *file, void *priv,
 			    struct v4l2_streamparm *p)
 {
-- 
2.7.4
