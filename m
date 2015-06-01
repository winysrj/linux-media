Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:50474 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752006AbbFAKP7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Jun 2015 06:15:59 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 683B62A007E
	for <linux-media@vger.kernel.org>; Mon,  1 Jun 2015 12:15:53 +0200 (CEST)
Message-ID: <556C30D9.1030800@xs4all.nl>
Date: Mon, 01 Jun 2015 12:15:53 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] vivid: move video loopback control to the capture device
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This has been on my TODO list for some time now: the control that enables the video
loopback was part of the controls of the video output device instead of the video
capture device. In practice this was quite annoying since you expect it at the capture
side since that's where you want to make the decision whether to use the TPG or looped
video.

This patch moves the control from the output to the capture side.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/Documentation/video4linux/vivid.txt b/Documentation/video4linux/vivid.txt
index cd4b5a1..51f57e3 100644
--- a/Documentation/video4linux/vivid.txt
+++ b/Documentation/video4linux/vivid.txt
@@ -888,7 +888,7 @@ Section 10.1: Video and Sliced VBI looping
 
 The way to enable video/VBI looping is currently fairly crude. A 'Loop Video'
 control is available in the "Vivid" control class of the video
-output and VBI output devices. When checked the video looping will be enabled.
+capture and VBI capture devices. When checked the video looping will be enabled.
 Once enabled any video S-Video or HDMI input will show a static test pattern
 until the video output has started. At that time the video output will be
 looped to the video input provided that:
diff --git a/drivers/media/platform/vivid/vivid-core.h b/drivers/media/platform/vivid/vivid-core.h
index aa1b523..a6ffd51 100644
--- a/drivers/media/platform/vivid/vivid-core.h
+++ b/drivers/media/platform/vivid/vivid-core.h
@@ -139,7 +139,7 @@ struct vivid_dev {
 	struct v4l2_ctrl_handler	ctrl_hdl_user_aud;
 	struct v4l2_ctrl_handler	ctrl_hdl_streaming;
 	struct v4l2_ctrl_handler	ctrl_hdl_sdtv_cap;
-	struct v4l2_ctrl_handler	ctrl_hdl_loop_out;
+	struct v4l2_ctrl_handler	ctrl_hdl_loop_cap;
 	struct video_device		vid_cap_dev;
 	struct v4l2_ctrl_handler	ctrl_hdl_vid_cap;
 	struct video_device		vid_out_dev;
diff --git a/drivers/media/platform/vivid/vivid-ctrls.c b/drivers/media/platform/vivid/vivid-ctrls.c
index 2b90700..81ee872 100644
--- a/drivers/media/platform/vivid/vivid-ctrls.c
+++ b/drivers/media/platform/vivid/vivid-ctrls.c
@@ -766,6 +766,37 @@ static const struct v4l2_ctrl_config vivid_ctrl_limited_rgb_range = {
 };
 
 
+/* Video Loop Control */
+
+static int vivid_loop_cap_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct vivid_dev *dev = container_of(ctrl->handler, struct vivid_dev, ctrl_hdl_loop_cap);
+
+	switch (ctrl->id) {
+	case VIVID_CID_LOOP_VIDEO:
+		dev->loop_video = ctrl->val;
+		vivid_update_quality(dev);
+		vivid_send_source_change(dev, SVID);
+		vivid_send_source_change(dev, HDMI);
+		break;
+	}
+	return 0;
+}
+
+static const struct v4l2_ctrl_ops vivid_loop_cap_ctrl_ops = {
+	.s_ctrl = vivid_loop_cap_s_ctrl,
+};
+
+static const struct v4l2_ctrl_config vivid_ctrl_loop_video = {
+	.ops = &vivid_loop_cap_ctrl_ops,
+	.id = VIVID_CID_LOOP_VIDEO,
+	.name = "Loop Video",
+	.type = V4L2_CTRL_TYPE_BOOLEAN,
+	.max = 1,
+	.step = 1,
+};
+
+
 /* VBI Capture Control */
 
 static int vivid_vbi_cap_s_ctrl(struct v4l2_ctrl *ctrl)
@@ -1199,38 +1230,6 @@ static const struct v4l2_ctrl_config vivid_ctrl_radio_tx_rds_blockio = {
 };
 
 
-
-/* Video Loop Control */
-
-static int vivid_loop_out_s_ctrl(struct v4l2_ctrl *ctrl)
-{
-	struct vivid_dev *dev = container_of(ctrl->handler, struct vivid_dev, ctrl_hdl_loop_out);
-
-	switch (ctrl->id) {
-	case VIVID_CID_LOOP_VIDEO:
-		dev->loop_video = ctrl->val;
-		vivid_update_quality(dev);
-		vivid_send_source_change(dev, SVID);
-		vivid_send_source_change(dev, HDMI);
-		break;
-	}
-	return 0;
-}
-
-static const struct v4l2_ctrl_ops vivid_loop_out_ctrl_ops = {
-	.s_ctrl = vivid_loop_out_s_ctrl,
-};
-
-static const struct v4l2_ctrl_config vivid_ctrl_loop_video = {
-	.ops = &vivid_loop_out_ctrl_ops,
-	.id = VIVID_CID_LOOP_VIDEO,
-	.name = "Loop Video",
-	.type = V4L2_CTRL_TYPE_BOOLEAN,
-	.max = 1,
-	.step = 1,
-};
-
-
 static const struct v4l2_ctrl_config vivid_ctrl_class = {
 	.ops = &vivid_user_gen_ctrl_ops,
 	.flags = V4L2_CTRL_FLAG_READ_ONLY | V4L2_CTRL_FLAG_WRITE_ONLY,
@@ -1248,7 +1247,7 @@ int vivid_create_controls(struct vivid_dev *dev, bool show_ccs_cap,
 	struct v4l2_ctrl_handler *hdl_user_aud = &dev->ctrl_hdl_user_aud;
 	struct v4l2_ctrl_handler *hdl_streaming = &dev->ctrl_hdl_streaming;
 	struct v4l2_ctrl_handler *hdl_sdtv_cap = &dev->ctrl_hdl_sdtv_cap;
-	struct v4l2_ctrl_handler *hdl_loop_out = &dev->ctrl_hdl_loop_out;
+	struct v4l2_ctrl_handler *hdl_loop_cap = &dev->ctrl_hdl_loop_cap;
 	struct v4l2_ctrl_handler *hdl_vid_cap = &dev->ctrl_hdl_vid_cap;
 	struct v4l2_ctrl_handler *hdl_vid_out = &dev->ctrl_hdl_vid_out;
 	struct v4l2_ctrl_handler *hdl_vbi_cap = &dev->ctrl_hdl_vbi_cap;
@@ -1274,8 +1273,8 @@ int vivid_create_controls(struct vivid_dev *dev, bool show_ccs_cap,
 	v4l2_ctrl_new_custom(hdl_streaming, &vivid_ctrl_class, NULL);
 	v4l2_ctrl_handler_init(hdl_sdtv_cap, 2);
 	v4l2_ctrl_new_custom(hdl_sdtv_cap, &vivid_ctrl_class, NULL);
-	v4l2_ctrl_handler_init(hdl_loop_out, 1);
-	v4l2_ctrl_new_custom(hdl_loop_out, &vivid_ctrl_class, NULL);
+	v4l2_ctrl_handler_init(hdl_loop_cap, 1);
+	v4l2_ctrl_new_custom(hdl_loop_cap, &vivid_ctrl_class, NULL);
 	v4l2_ctrl_handler_init(hdl_vid_cap, 55);
 	v4l2_ctrl_new_custom(hdl_vid_cap, &vivid_ctrl_class, NULL);
 	v4l2_ctrl_handler_init(hdl_vid_out, 26);
@@ -1445,7 +1444,7 @@ int vivid_create_controls(struct vivid_dev *dev, bool show_ccs_cap,
 	}
 	if ((dev->has_vid_cap && dev->has_vid_out) ||
 	    (dev->has_vbi_cap && dev->has_vbi_out))
-		v4l2_ctrl_new_custom(hdl_loop_out, &vivid_ctrl_loop_video, NULL);
+		v4l2_ctrl_new_custom(hdl_loop_cap, &vivid_ctrl_loop_video, NULL);
 
 	if (dev->has_fb)
 		v4l2_ctrl_new_custom(hdl_user_gen, &vivid_ctrl_clear_fb, NULL);
@@ -1528,8 +1527,8 @@ int vivid_create_controls(struct vivid_dev *dev, bool show_ccs_cap,
 		return hdl_streaming->error;
 	if (hdl_sdr_cap->error)
 		return hdl_sdr_cap->error;
-	if (hdl_loop_out->error)
-		return hdl_loop_out->error;
+	if (hdl_loop_cap->error)
+		return hdl_loop_cap->error;
 
 	if (dev->autogain)
 		v4l2_ctrl_auto_cluster(2, &dev->autogain, 0, true);
@@ -1540,6 +1539,7 @@ int vivid_create_controls(struct vivid_dev *dev, bool show_ccs_cap,
 		v4l2_ctrl_add_handler(hdl_vid_cap, hdl_user_aud, NULL);
 		v4l2_ctrl_add_handler(hdl_vid_cap, hdl_streaming, NULL);
 		v4l2_ctrl_add_handler(hdl_vid_cap, hdl_sdtv_cap, NULL);
+		v4l2_ctrl_add_handler(hdl_vid_cap, hdl_loop_cap, NULL);
 		if (hdl_vid_cap->error)
 			return hdl_vid_cap->error;
 		dev->vid_cap_dev.ctrl_handler = hdl_vid_cap;
@@ -1548,7 +1548,6 @@ int vivid_create_controls(struct vivid_dev *dev, bool show_ccs_cap,
 		v4l2_ctrl_add_handler(hdl_vid_out, hdl_user_gen, NULL);
 		v4l2_ctrl_add_handler(hdl_vid_out, hdl_user_aud, NULL);
 		v4l2_ctrl_add_handler(hdl_vid_out, hdl_streaming, NULL);
-		v4l2_ctrl_add_handler(hdl_vid_out, hdl_loop_out, NULL);
 		if (hdl_vid_out->error)
 			return hdl_vid_out->error;
 		dev->vid_out_dev.ctrl_handler = hdl_vid_out;
@@ -1557,6 +1556,7 @@ int vivid_create_controls(struct vivid_dev *dev, bool show_ccs_cap,
 		v4l2_ctrl_add_handler(hdl_vbi_cap, hdl_user_gen, NULL);
 		v4l2_ctrl_add_handler(hdl_vbi_cap, hdl_streaming, NULL);
 		v4l2_ctrl_add_handler(hdl_vbi_cap, hdl_sdtv_cap, NULL);
+		v4l2_ctrl_add_handler(hdl_vbi_cap, hdl_loop_cap, NULL);
 		if (hdl_vbi_cap->error)
 			return hdl_vbi_cap->error;
 		dev->vbi_cap_dev.ctrl_handler = hdl_vbi_cap;
@@ -1564,7 +1564,6 @@ int vivid_create_controls(struct vivid_dev *dev, bool show_ccs_cap,
 	if (dev->has_vbi_out) {
 		v4l2_ctrl_add_handler(hdl_vbi_out, hdl_user_gen, NULL);
 		v4l2_ctrl_add_handler(hdl_vbi_out, hdl_streaming, NULL);
-		v4l2_ctrl_add_handler(hdl_vbi_out, hdl_loop_out, NULL);
 		if (hdl_vbi_out->error)
 			return hdl_vbi_out->error;
 		dev->vbi_out_dev.ctrl_handler = hdl_vbi_out;
@@ -1607,5 +1606,5 @@ void vivid_free_controls(struct vivid_dev *dev)
 	v4l2_ctrl_handler_free(&dev->ctrl_hdl_user_aud);
 	v4l2_ctrl_handler_free(&dev->ctrl_hdl_streaming);
 	v4l2_ctrl_handler_free(&dev->ctrl_hdl_sdtv_cap);
-	v4l2_ctrl_handler_free(&dev->ctrl_hdl_loop_out);
+	v4l2_ctrl_handler_free(&dev->ctrl_hdl_loop_cap);
 }
