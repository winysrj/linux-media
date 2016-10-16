Return-path: <linux-media-owner@vger.kernel.org>
Received: from shell.v3.sk ([92.60.52.57]:42376 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753953AbcJPJsj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 16 Oct 2016 05:48:39 -0400
From: Lubomir Rintel <lkundrak@v3.sk>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Federico Simoncelli <fsimonce@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        patrick keshishian <pkeshish@gmail.com>,
        Lubomir Rintel <lkundrak@v3.sk>
Subject: [PATCH] [media] usbtv: add video controls
Date: Sun, 16 Oct 2016 11:38:22 +0200
Message-Id: <1476610702-12848-1-git-send-email-lkundrak@v3.sk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Brightness, Contrast, Hue and Color Saturation are supported.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
---
 drivers/media/usb/usbtv/usbtv-video.c | 97 ++++++++++++++++++++++++++++++++++-
 drivers/media/usb/usbtv/usbtv.h       |  3 ++
 2 files changed, 99 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbtv/usbtv-video.c
index 2a08975..dca4fcb 100644
--- a/drivers/media/usb/usbtv/usbtv-video.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2013 Lubomir Rintel
+ * Copyright (c) 2013,2016 Lubomir Rintel
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -259,6 +259,10 @@ static int usbtv_setup_capture(struct usbtv *usbtv)
 	if (ret)
 		return ret;
 
+	ret = v4l2_ctrl_handler_setup(&usbtv->ctrl);
+	if (ret)
+		return ret;
+
 	return 0;
 }
 
@@ -696,11 +700,83 @@ static struct vb2_ops usbtv_vb2_ops = {
 	.stop_streaming = usbtv_stop_streaming,
 };
 
+static int usbtv_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct usbtv *usbtv = container_of(ctrl->handler, struct usbtv,
+								ctrl);
+	u8 data[3];
+	u16 index, size;
+	int ret;
+
+	/*
+	 * Read in the current brightness/contrast registers. We need them
+	 * both, because the values are for some reason interleaved.
+	 */
+	if (ctrl->id == V4L2_CID_BRIGHTNESS || ctrl->id == V4L2_CID_CONTRAST) {
+		ret = usb_control_msg(usbtv->udev,
+			usb_sndctrlpipe(usbtv->udev, 0), USBTV_CONTROL_REG,
+			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+			0, USBTV_BASE + 0x0244, (void *)data, 3, 0);
+	}
+
+	switch (ctrl->id) {
+	case V4L2_CID_BRIGHTNESS:
+		index = USBTV_BASE + 0x0244;
+		size = 3;
+		data[0] &= 0xf0;
+		data[0] |= (ctrl->val >> 8) & 0xf;
+		data[2] = ctrl->val & 0xff;
+		break;
+	case V4L2_CID_CONTRAST:
+		index = USBTV_BASE + 0x0244;
+		size = 3;
+		data[0] &= 0x0f;
+		data[0] |= (ctrl->val >> 4) & 0xf0;
+		data[1] = ctrl->val & 0xff;
+		break;
+	case V4L2_CID_SATURATION:
+		index = USBTV_BASE + 0x0242;
+		data[0] = ctrl->val >> 8;
+		data[1] = ctrl->val & 0xff;
+		size = 2;
+		break;
+	case V4L2_CID_HUE:
+		index = USBTV_BASE + 0x0240;
+		size = 2;
+		if (ctrl->val > 0) {
+			data[0] = 0x92 + (ctrl->val >> 8);
+			data[1] = ctrl->val & 0xff;
+		} else {
+			data[0] = 0x82 + (-ctrl->val >> 8);
+			data[1] = -ctrl->val & 0xff;
+		}
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	ret = usb_control_msg(usbtv->udev, usb_sndctrlpipe(usbtv->udev, 0),
+			USBTV_CONTROL_REG,
+			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+			0, index, (void *)data, size, 0);
+	if (ret < 0) {
+		dev_warn(usbtv->dev, "Failed to submit a control request.\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static const struct v4l2_ctrl_ops usbtv_ctrl_ops = {
+	.s_ctrl = usbtv_s_ctrl,
+};
+
 static void usbtv_release(struct v4l2_device *v4l2_dev)
 {
 	struct usbtv *usbtv = container_of(v4l2_dev, struct usbtv, v4l2_dev);
 
 	v4l2_device_unregister(&usbtv->v4l2_dev);
+	v4l2_ctrl_handler_free(&usbtv->ctrl);
 	vb2_queue_release(&usbtv->vb2q);
 	kfree(usbtv);
 }
@@ -731,7 +807,24 @@ int usbtv_video_init(struct usbtv *usbtv)
 		return ret;
 	}
 
+	/* controls */
+	v4l2_ctrl_handler_init(&usbtv->ctrl, 4);
+	v4l2_ctrl_new_std(&usbtv->ctrl, &usbtv_ctrl_ops,
+			V4L2_CID_CONTRAST, 0, 0x3ff, 1, 0x1d0);
+	v4l2_ctrl_new_std(&usbtv->ctrl, &usbtv_ctrl_ops,
+			V4L2_CID_BRIGHTNESS, 0, 0x3ff, 1, 0x1c0);
+	v4l2_ctrl_new_std(&usbtv->ctrl, &usbtv_ctrl_ops,
+			V4L2_CID_SATURATION, 0, 0x3ff, 1, 0x200);
+	v4l2_ctrl_new_std(&usbtv->ctrl, &usbtv_ctrl_ops,
+			V4L2_CID_HUE, -0xdff, 0xdff, 1, 0x000);
+	ret = usbtv->ctrl.error;
+	if (ret < 0) {
+		dev_warn(usbtv->dev, "Could not initialize controls\n");
+		goto ctrl_fail;
+	}
+
 	/* v4l2 structure */
+	usbtv->v4l2_dev.ctrl_handler = &usbtv->ctrl;
 	usbtv->v4l2_dev.release = usbtv_release;
 	ret = v4l2_device_register(usbtv->dev, &usbtv->v4l2_dev);
 	if (ret < 0) {
@@ -760,6 +853,8 @@ int usbtv_video_init(struct usbtv *usbtv)
 vdev_fail:
 	v4l2_device_unregister(&usbtv->v4l2_dev);
 v4l2_fail:
+ctrl_fail:
+	v4l2_ctrl_handler_free(&usbtv->ctrl);
 	vb2_queue_release(&usbtv->vb2q);
 
 	return ret;
diff --git a/drivers/media/usb/usbtv/usbtv.h b/drivers/media/usb/usbtv/usbtv.h
index 011f9fd..0231e44 100644
--- a/drivers/media/usb/usbtv/usbtv.h
+++ b/drivers/media/usb/usbtv/usbtv.h
@@ -38,6 +38,7 @@
 #include <linux/usb.h>
 
 #include <media/v4l2-device.h>
+#include <media/v4l2-ctrls.h>
 #include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-vmalloc.h>
 
@@ -45,6 +46,7 @@
 #define USBTV_VIDEO_ENDP	0x81
 #define USBTV_AUDIO_ENDP	0x83
 #define USBTV_BASE		0xc000
+#define USBTV_CONTROL_REG	11
 #define USBTV_REQUEST_REG	12
 
 /* Number of concurrent isochronous urbs submitted.
@@ -87,6 +89,7 @@ struct usbtv {
 
 	/* video */
 	struct v4l2_device v4l2_dev;
+	struct v4l2_ctrl_handler ctrl;
 	struct video_device vdev;
 	struct vb2_queue vb2q;
 	struct mutex v4l2_lock;
-- 
2.7.4

