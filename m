Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:42052 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751765AbeA3K1G (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Jan 2018 05:27:06 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Daniel Mentz <danielmentz@google.com>,
        Hans Verkuil <hans.verkuil@cisco.com>, stable@vger.kernel.org
Subject: [PATCHv2 01/13] vivid: fix module load error when enabling fb and no_error_inj=1
Date: Tue, 30 Jan 2018 11:26:49 +0100
Message-Id: <20180130102701.13664-2-hverkuil@xs4all.nl>
In-Reply-To: <20180130102701.13664-1-hverkuil@xs4all.nl>
References: <20180130102701.13664-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

If the framebuffer is enabled and error injection is disabled, then
creating the controls for the video output device would fail with an
error.

This is because the Clear Framebuffer control uses the 'vivid control
class' and that control class isn't added if error injection is disabled.

In addition, this control was added to e.g. vbi devices as well, which
makes no sense.

Move this control to its own control handler and handle it correctly.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: <stable@vger.kernel.org>      # for v4.15 and up
---
 drivers/media/platform/vivid/vivid-core.h  |  1 +
 drivers/media/platform/vivid/vivid-ctrls.c | 35 +++++++++++++++++++++++++-----
 2 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-core.h b/drivers/media/platform/vivid/vivid-core.h
index 50802e650750..c90e4a0ab94e 100644
--- a/drivers/media/platform/vivid/vivid-core.h
+++ b/drivers/media/platform/vivid/vivid-core.h
@@ -154,6 +154,7 @@ struct vivid_dev {
 	struct v4l2_ctrl_handler	ctrl_hdl_streaming;
 	struct v4l2_ctrl_handler	ctrl_hdl_sdtv_cap;
 	struct v4l2_ctrl_handler	ctrl_hdl_loop_cap;
+	struct v4l2_ctrl_handler	ctrl_hdl_fb;
 	struct video_device		vid_cap_dev;
 	struct v4l2_ctrl_handler	ctrl_hdl_vid_cap;
 	struct video_device		vid_out_dev;
diff --git a/drivers/media/platform/vivid/vivid-ctrls.c b/drivers/media/platform/vivid/vivid-ctrls.c
index 34731f71cc00..3f9d354827af 100644
--- a/drivers/media/platform/vivid/vivid-ctrls.c
+++ b/drivers/media/platform/vivid/vivid-ctrls.c
@@ -120,9 +120,6 @@ static int vivid_user_gen_s_ctrl(struct v4l2_ctrl *ctrl)
 		clear_bit(V4L2_FL_REGISTERED, &dev->radio_rx_dev.flags);
 		clear_bit(V4L2_FL_REGISTERED, &dev->radio_tx_dev.flags);
 		break;
-	case VIVID_CID_CLEAR_FB:
-		vivid_clear_fb(dev);
-		break;
 	case VIVID_CID_BUTTON:
 		dev->button_pressed = 30;
 		break;
@@ -274,8 +271,28 @@ static const struct v4l2_ctrl_config vivid_ctrl_disconnect = {
 	.type = V4L2_CTRL_TYPE_BUTTON,
 };
 
+
+/* Framebuffer Controls */
+
+static int vivid_fb_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct vivid_dev *dev = container_of(ctrl->handler,
+					     struct vivid_dev, ctrl_hdl_fb);
+
+	switch (ctrl->id) {
+	case VIVID_CID_CLEAR_FB:
+		vivid_clear_fb(dev);
+		break;
+	}
+	return 0;
+}
+
+static const struct v4l2_ctrl_ops vivid_fb_ctrl_ops = {
+	.s_ctrl = vivid_fb_s_ctrl,
+};
+
 static const struct v4l2_ctrl_config vivid_ctrl_clear_fb = {
-	.ops = &vivid_user_gen_ctrl_ops,
+	.ops = &vivid_fb_ctrl_ops,
 	.id = VIVID_CID_CLEAR_FB,
 	.name = "Clear Framebuffer",
 	.type = V4L2_CTRL_TYPE_BUTTON,
@@ -1357,6 +1374,7 @@ int vivid_create_controls(struct vivid_dev *dev, bool show_ccs_cap,
 	struct v4l2_ctrl_handler *hdl_streaming = &dev->ctrl_hdl_streaming;
 	struct v4l2_ctrl_handler *hdl_sdtv_cap = &dev->ctrl_hdl_sdtv_cap;
 	struct v4l2_ctrl_handler *hdl_loop_cap = &dev->ctrl_hdl_loop_cap;
+	struct v4l2_ctrl_handler *hdl_fb = &dev->ctrl_hdl_fb;
 	struct v4l2_ctrl_handler *hdl_vid_cap = &dev->ctrl_hdl_vid_cap;
 	struct v4l2_ctrl_handler *hdl_vid_out = &dev->ctrl_hdl_vid_out;
 	struct v4l2_ctrl_handler *hdl_vbi_cap = &dev->ctrl_hdl_vbi_cap;
@@ -1384,10 +1402,12 @@ int vivid_create_controls(struct vivid_dev *dev, bool show_ccs_cap,
 	v4l2_ctrl_new_custom(hdl_sdtv_cap, &vivid_ctrl_class, NULL);
 	v4l2_ctrl_handler_init(hdl_loop_cap, 1);
 	v4l2_ctrl_new_custom(hdl_loop_cap, &vivid_ctrl_class, NULL);
+	v4l2_ctrl_handler_init(hdl_fb, 1);
+	v4l2_ctrl_new_custom(hdl_fb, &vivid_ctrl_class, NULL);
 	v4l2_ctrl_handler_init(hdl_vid_cap, 55);
 	v4l2_ctrl_new_custom(hdl_vid_cap, &vivid_ctrl_class, NULL);
 	v4l2_ctrl_handler_init(hdl_vid_out, 26);
-	if (!no_error_inj)
+	if (!no_error_inj || dev->has_fb)
 		v4l2_ctrl_new_custom(hdl_vid_out, &vivid_ctrl_class, NULL);
 	v4l2_ctrl_handler_init(hdl_vbi_cap, 21);
 	v4l2_ctrl_new_custom(hdl_vbi_cap, &vivid_ctrl_class, NULL);
@@ -1561,7 +1581,7 @@ int vivid_create_controls(struct vivid_dev *dev, bool show_ccs_cap,
 		v4l2_ctrl_new_custom(hdl_loop_cap, &vivid_ctrl_loop_video, NULL);
 
 	if (dev->has_fb)
-		v4l2_ctrl_new_custom(hdl_user_gen, &vivid_ctrl_clear_fb, NULL);
+		v4l2_ctrl_new_custom(hdl_fb, &vivid_ctrl_clear_fb, NULL);
 
 	if (dev->has_radio_rx) {
 		v4l2_ctrl_new_custom(hdl_radio_rx, &vivid_ctrl_radio_hw_seek_mode, NULL);
@@ -1658,6 +1678,7 @@ int vivid_create_controls(struct vivid_dev *dev, bool show_ccs_cap,
 		v4l2_ctrl_add_handler(hdl_vid_cap, hdl_streaming, NULL);
 		v4l2_ctrl_add_handler(hdl_vid_cap, hdl_sdtv_cap, NULL);
 		v4l2_ctrl_add_handler(hdl_vid_cap, hdl_loop_cap, NULL);
+		v4l2_ctrl_add_handler(hdl_vid_cap, hdl_fb, NULL);
 		if (hdl_vid_cap->error)
 			return hdl_vid_cap->error;
 		dev->vid_cap_dev.ctrl_handler = hdl_vid_cap;
@@ -1666,6 +1687,7 @@ int vivid_create_controls(struct vivid_dev *dev, bool show_ccs_cap,
 		v4l2_ctrl_add_handler(hdl_vid_out, hdl_user_gen, NULL);
 		v4l2_ctrl_add_handler(hdl_vid_out, hdl_user_aud, NULL);
 		v4l2_ctrl_add_handler(hdl_vid_out, hdl_streaming, NULL);
+		v4l2_ctrl_add_handler(hdl_vid_out, hdl_fb, NULL);
 		if (hdl_vid_out->error)
 			return hdl_vid_out->error;
 		dev->vid_out_dev.ctrl_handler = hdl_vid_out;
@@ -1725,4 +1747,5 @@ void vivid_free_controls(struct vivid_dev *dev)
 	v4l2_ctrl_handler_free(&dev->ctrl_hdl_streaming);
 	v4l2_ctrl_handler_free(&dev->ctrl_hdl_sdtv_cap);
 	v4l2_ctrl_handler_free(&dev->ctrl_hdl_loop_cap);
+	v4l2_ctrl_handler_free(&dev->ctrl_hdl_fb);
 }
-- 
2.15.1
