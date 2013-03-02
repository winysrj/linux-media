Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1051 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab3CBXpw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Mar 2013 18:45:52 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 05/20] solo6x10: add control framework.
Date: Sun,  3 Mar 2013 00:45:21 +0100
Message-Id: <a201688c8322de403941387c4fad0bfa8e77bb4f.1362266529.git.hans.verkuil@cisco.com>
In-Reply-To: <1362267936-6772-1-git-send-email-hverkuil@xs4all.nl>
References: <1362267936-6772-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <5384481a4f621f619f37dd5716df122283e80704.1362266529.git.hans.verkuil@cisco.com>
References: <5384481a4f621f619f37dd5716df122283e80704.1362266529.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/solo6x10/solo6x10.h |   12 +-
 drivers/staging/media/solo6x10/tw28.c     |   12 +-
 drivers/staging/media/solo6x10/tw28.h     |    1 +
 drivers/staging/media/solo6x10/v4l2-enc.c |  342 ++++++++---------------------
 drivers/staging/media/solo6x10/v4l2.c     |   83 +++----
 5 files changed, 130 insertions(+), 320 deletions(-)

diff --git a/drivers/staging/media/solo6x10/solo6x10.h b/drivers/staging/media/solo6x10/solo6x10.h
index 8fd3a6a..4e32065 100644
--- a/drivers/staging/media/solo6x10/solo6x10.h
+++ b/drivers/staging/media/solo6x10/solo6x10.h
@@ -34,6 +34,7 @@
 #include <linux/videodev2.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-device.h>
+#include <media/v4l2-ctrls.h>
 #include <media/videobuf-core.h>
 #include "registers.h"
 
@@ -114,11 +115,14 @@
 #define V4L2_BUF_FLAG_MOTION_ON		0x0400
 #define V4L2_BUF_FLAG_MOTION_DETECTED	0x0800
 #endif
+
 #ifndef V4L2_CID_MOTION_ENABLE
 #define PRIVATE_CIDS
-#define V4L2_CID_MOTION_ENABLE		(V4L2_CID_PRIVATE_BASE+0)
-#define V4L2_CID_MOTION_THRESHOLD	(V4L2_CID_PRIVATE_BASE+1)
-#define V4L2_CID_MOTION_TRACE		(V4L2_CID_PRIVATE_BASE+2)
+#define SOLO_CID_CUSTOM_BASE		(V4L2_CID_USER_BASE | 0xf000)
+#define V4L2_CID_MOTION_ENABLE		(SOLO_CID_CUSTOM_BASE+0)
+#define V4L2_CID_MOTION_THRESHOLD	(SOLO_CID_CUSTOM_BASE+1)
+#define V4L2_CID_MOTION_TRACE		(SOLO_CID_CUSTOM_BASE+2)
+#define V4L2_CID_OSD_TEXT		(SOLO_CID_CUSTOM_BASE+3)
 #endif
 
 enum SOLO_I2C_STATE {
@@ -152,6 +156,7 @@ enum solo_enc_types {
 struct solo_enc_dev {
 	struct solo_dev		*solo_dev;
 	/* V4L2 Items */
+	struct v4l2_ctrl_handler hdl;
 	struct video_device	*vfd;
 	/* General accounting */
 	wait_queue_head_t	thread_wait;
@@ -215,6 +220,7 @@ struct solo_dev {
 	unsigned int		frame_blank;
 	u8			cur_disp_ch;
 	wait_queue_head_t	disp_thread_wait;
+	struct v4l2_ctrl_handler disp_hdl;
 
 	/* V4L2 Encoder items */
 	struct solo_enc_dev	*v4l2_enc[SOLO_MAX_CHANNELS];
diff --git a/drivers/staging/media/solo6x10/tw28.c b/drivers/staging/media/solo6x10/tw28.c
index db56b42..aea56c7 100644
--- a/drivers/staging/media/solo6x10/tw28.c
+++ b/drivers/staging/media/solo6x10/tw28.c
@@ -635,6 +635,11 @@ u16 tw28_get_audio_status(struct solo_dev *solo_dev)
 }
 #endif
 
+bool tw28_has_sharpness(struct solo_dev *solo_dev, u8 ch)
+{
+	return is_tw286x(solo_dev, ch / 4);
+}
+
 int tw28_set_ctrl_val(struct solo_dev *solo_dev, u32 ctrl, u8 ch, s32 val)
 {
 	char sval;
@@ -650,8 +655,6 @@ int tw28_set_ctrl_val(struct solo_dev *solo_dev, u32 ctrl, u8 ch, s32 val)
 	switch (ctrl) {
 	case V4L2_CID_SHARPNESS:
 		/* Only 286x has sharpness */
-		if (val > 0x0f || val < 0)
-			return -ERANGE;
 		if (is_tw286x(solo_dev, chip_num)) {
 			u8 v = solo_i2c_readbyte(solo_dev, SOLO_I2C_TW,
 						 TW_CHIP_OFFSET_ADDR(chip_num),
@@ -661,8 +664,9 @@ int tw28_set_ctrl_val(struct solo_dev *solo_dev, u32 ctrl, u8 ch, s32 val)
 			solo_i2c_writebyte(solo_dev, SOLO_I2C_TW,
 					   TW_CHIP_OFFSET_ADDR(chip_num),
 					   TW286x_SHARPNESS(chip_num), v);
-		} else if (val != 0)
-			return -ERANGE;
+		} else {
+			return -EINVAL;
+		}
 		break;
 
 	case V4L2_CID_HUE:
diff --git a/drivers/staging/media/solo6x10/tw28.h b/drivers/staging/media/solo6x10/tw28.h
index a44a03a..9a6c733 100644
--- a/drivers/staging/media/solo6x10/tw28.h
+++ b/drivers/staging/media/solo6x10/tw28.h
@@ -50,6 +50,7 @@ int solo_tw28_init(struct solo_dev *solo_dev);
 
 int tw28_set_ctrl_val(struct solo_dev *solo_dev, u32 ctrl, u8 ch, s32 val);
 int tw28_get_ctrl_val(struct solo_dev *solo_dev, u32 ctrl, u8 ch, s32 *val);
+bool tw28_has_sharpness(struct solo_dev *solo_dev, u8 ch);
 
 u8 tw28_get_audio_gain(struct solo_dev *solo_dev, u8 ch);
 void tw28_set_audio_gain(struct solo_dev *solo_dev, u8 ch, u8 val);
diff --git a/drivers/staging/media/solo6x10/v4l2-enc.c b/drivers/staging/media/solo6x10/v4l2-enc.c
index a949a14..71d9656f 100644
--- a/drivers/staging/media/solo6x10/v4l2-enc.c
+++ b/drivers/staging/media/solo6x10/v4l2-enc.c
@@ -48,40 +48,6 @@ struct solo_enc_fh {
 	struct p2m_desc		desc[SOLO_NR_P2M_DESC];
 };
 
-static const u32 solo_user_ctrls[] = {
-	V4L2_CID_BRIGHTNESS,
-	V4L2_CID_CONTRAST,
-	V4L2_CID_SATURATION,
-	V4L2_CID_HUE,
-	V4L2_CID_SHARPNESS,
-	0
-};
-
-static const u32 solo_mpeg_ctrls[] = {
-	V4L2_CID_MPEG_VIDEO_ENCODING,
-	V4L2_CID_MPEG_VIDEO_GOP_SIZE,
-	0
-};
-
-static const u32 solo_private_ctrls[] = {
-	V4L2_CID_MOTION_ENABLE,
-	V4L2_CID_MOTION_THRESHOLD,
-	0
-};
-
-static const u32 solo_fmtx_ctrls[] = {
-	V4L2_CID_RDS_TX_RADIO_TEXT,
-	0
-};
-
-static const u32 *solo_ctrl_classes[] = {
-	solo_user_ctrls,
-	solo_mpeg_ctrls,
-	solo_fmtx_ctrls,
-	solo_private_ctrls,
-	NULL
-};
-
 static int solo_is_motion_on(struct solo_enc_dev *solo_enc)
 {
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
@@ -1438,123 +1404,10 @@ static int solo_s_parm(struct file *file, void *priv,
 	return 0;
 }
 
-static int solo_queryctrl(struct file *file, void *priv,
-			  struct v4l2_queryctrl *qc)
+static int solo_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	struct solo_enc_fh *fh = priv;
-	struct solo_enc_dev *solo_enc = fh->enc;
-	struct solo_dev *solo_dev = solo_enc->solo_dev;
-
-	qc->id = v4l2_ctrl_next(solo_ctrl_classes, qc->id);
-	if (!qc->id)
-		return -EINVAL;
-
-	switch (qc->id) {
-	case V4L2_CID_BRIGHTNESS:
-	case V4L2_CID_CONTRAST:
-	case V4L2_CID_SATURATION:
-	case V4L2_CID_HUE:
-		return v4l2_ctrl_query_fill(qc, 0x00, 0xff, 1, 0x80);
-	case V4L2_CID_SHARPNESS:
-		return v4l2_ctrl_query_fill(qc, 0x00, 0x0f, 1, 0x00);
-	case V4L2_CID_MPEG_VIDEO_ENCODING:
-		return v4l2_ctrl_query_fill(
-			qc, V4L2_MPEG_VIDEO_ENCODING_MPEG_1,
-			V4L2_MPEG_VIDEO_ENCODING_MPEG_4_AVC, 1,
-			V4L2_MPEG_VIDEO_ENCODING_MPEG_4_AVC);
-	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
-		return v4l2_ctrl_query_fill(qc, 1, 255, 1, solo_dev->fps);
-#ifdef PRIVATE_CIDS
-	case V4L2_CID_MOTION_THRESHOLD:
-		qc->flags |= V4L2_CTRL_FLAG_SLIDER;
-		qc->type = V4L2_CTRL_TYPE_INTEGER;
-		qc->minimum = 0;
-		qc->maximum = 0xffff;
-		qc->step = 1;
-		qc->default_value = SOLO_DEF_MOT_THRESH;
-		strlcpy(qc->name, "Motion Detection Threshold",
-			sizeof(qc->name));
-		return 0;
-	case V4L2_CID_MOTION_ENABLE:
-		qc->type = V4L2_CTRL_TYPE_BOOLEAN;
-		qc->minimum = 0;
-		qc->maximum = qc->step = 1;
-		qc->default_value = 0;
-		strlcpy(qc->name, "Motion Detection Enable", sizeof(qc->name));
-		return 0;
-#else
-	case V4L2_CID_MOTION_THRESHOLD:
-		return v4l2_ctrl_query_fill(qc, 0, 0xffff, 1,
-					    SOLO_DEF_MOT_THRESH);
-	case V4L2_CID_MOTION_ENABLE:
-		return v4l2_ctrl_query_fill(qc, 0, 1, 1, 0);
-#endif
-	case V4L2_CID_RDS_TX_RADIO_TEXT:
-		qc->type = V4L2_CTRL_TYPE_STRING;
-		qc->minimum = 0;
-		qc->maximum = OSD_TEXT_MAX;
-		qc->step = 1;
-		qc->default_value = 0;
-		strlcpy(qc->name, "OSD Text", sizeof(qc->name));
-		return 0;
-	}
-
-	return -EINVAL;
-}
-
-static int solo_querymenu(struct file *file, void *priv,
-			  struct v4l2_querymenu *qmenu)
-{
-	struct v4l2_queryctrl qctrl;
-	int err;
-
-	qctrl.id = qmenu->id;
-	err = solo_queryctrl(file, priv, &qctrl);
-	if (err)
-		return err;
-
-	return v4l2_ctrl_query_menu(qmenu, &qctrl, NULL);
-}
-
-static int solo_g_ctrl(struct file *file, void *priv,
-		       struct v4l2_control *ctrl)
-{
-	struct solo_enc_fh *fh = priv;
-	struct solo_enc_dev *solo_enc = fh->enc;
-	struct solo_dev *solo_dev = solo_enc->solo_dev;
-
-	switch (ctrl->id) {
-	case V4L2_CID_BRIGHTNESS:
-	case V4L2_CID_CONTRAST:
-	case V4L2_CID_SATURATION:
-	case V4L2_CID_HUE:
-	case V4L2_CID_SHARPNESS:
-		return tw28_get_ctrl_val(solo_dev, ctrl->id, solo_enc->ch,
-					 &ctrl->value);
-	case V4L2_CID_MPEG_VIDEO_ENCODING:
-		ctrl->value = V4L2_MPEG_VIDEO_ENCODING_MPEG_4_AVC;
-		break;
-	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
-		ctrl->value = solo_enc->gop;
-		break;
-	case V4L2_CID_MOTION_THRESHOLD:
-		ctrl->value = solo_enc->motion_thresh;
-		break;
-	case V4L2_CID_MOTION_ENABLE:
-		ctrl->value = solo_is_motion_on(solo_enc);
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-static int solo_s_ctrl(struct file *file, void *priv,
-		       struct v4l2_control *ctrl)
-{
-	struct solo_enc_fh *fh = priv;
-	struct solo_enc_dev *solo_enc = fh->enc;
+	struct solo_enc_dev *solo_enc =
+		container_of(ctrl->handler, struct solo_enc_dev, hdl);
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
 
 	switch (ctrl->id) {
@@ -1564,112 +1417,31 @@ static int solo_s_ctrl(struct file *file, void *priv,
 	case V4L2_CID_HUE:
 	case V4L2_CID_SHARPNESS:
 		return tw28_set_ctrl_val(solo_dev, ctrl->id, solo_enc->ch,
-					 ctrl->value);
+					 ctrl->val);
 	case V4L2_CID_MPEG_VIDEO_ENCODING:
-		if (ctrl->value != V4L2_MPEG_VIDEO_ENCODING_MPEG_4_AVC)
-			return -ERANGE;
-		break;
+		return 0;
 	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
-		if (ctrl->value < 1 || ctrl->value > 255)
-			return -ERANGE;
-		solo_enc->gop = ctrl->value;
+		solo_enc->gop = ctrl->val;
 		solo_reg_write(solo_dev, SOLO_VE_CH_GOP(solo_enc->ch),
 			       solo_enc->gop);
 		solo_reg_write(solo_dev, SOLO_VE_CH_GOP_E(solo_enc->ch),
 			       solo_enc->gop);
-		break;
+		return 0;
 	case V4L2_CID_MOTION_THRESHOLD:
-		/* TODO accept value on lower 16-bits and use high
-		 * 16-bits to assign the value to a specific block */
-		if (ctrl->value < 0 || ctrl->value > 0xffff)
-			return -ERANGE;
-		solo_enc->motion_thresh = ctrl->value;
-		solo_set_motion_threshold(solo_dev, solo_enc->ch, ctrl->value);
-		break;
+		solo_enc->motion_thresh = ctrl->val;
+		solo_set_motion_threshold(solo_dev, solo_enc->ch, ctrl->val);
+		return 0;
 	case V4L2_CID_MOTION_ENABLE:
-		solo_motion_toggle(solo_enc, ctrl->value);
-		break;
+		solo_motion_toggle(solo_enc, ctrl->val);
+		return 0;
+	case V4L2_CID_OSD_TEXT:
+		strcpy(solo_enc->osd_text, ctrl->string);
+		return solo_osd_print(solo_enc);
 	default:
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-static int solo_s_ext_ctrls(struct file *file, void *priv,
-			    struct v4l2_ext_controls *ctrls)
-{
-	struct solo_enc_fh *fh = priv;
-	struct solo_enc_dev *solo_enc = fh->enc;
-	int i;
-
-	for (i = 0; i < ctrls->count; i++) {
-		struct v4l2_ext_control *ctrl = (ctrls->controls + i);
-		int err;
-
-		switch (ctrl->id) {
-		case V4L2_CID_RDS_TX_RADIO_TEXT:
-			if (ctrl->size - 1 > OSD_TEXT_MAX)
-				err = -ERANGE;
-			else {
-				err = copy_from_user(solo_enc->osd_text,
-						     ctrl->string,
-						     OSD_TEXT_MAX);
-				solo_enc->osd_text[OSD_TEXT_MAX] = '\0';
-				if (!err)
-					err = solo_osd_print(solo_enc);
-				else
-					err = -EFAULT;
-			}
-			break;
-		default:
-			err = -EINVAL;
-		}
-
-		if (err < 0) {
-			ctrls->error_idx = i;
-			return err;
-		}
-	}
-
-	return 0;
-}
-
-static int solo_g_ext_ctrls(struct file *file, void *priv,
-			    struct v4l2_ext_controls *ctrls)
-{
-	struct solo_enc_fh *fh = priv;
-	struct solo_enc_dev *solo_enc = fh->enc;
-	int i;
-
-	for (i = 0; i < ctrls->count; i++) {
-		struct v4l2_ext_control *ctrl = (ctrls->controls + i);
-		int err;
-
-		switch (ctrl->id) {
-		case V4L2_CID_RDS_TX_RADIO_TEXT:
-			if (ctrl->size < OSD_TEXT_MAX) {
-				ctrl->size = OSD_TEXT_MAX;
-				err = -ENOSPC;
-			} else {
-				err = copy_to_user(ctrl->string,
-						   solo_enc->osd_text,
-						   OSD_TEXT_MAX);
-				if (err)
-					err = -EFAULT;
-			}
-			break;
-		default:
-			err = -EINVAL;
-		}
-
-		if (err < 0) {
-			ctrls->error_idx = i;
-			return err;
-		}
+		break;
 	}
 
-	return 0;
+	return -EINVAL;
 }
 
 static const struct v4l2_file_operations solo_enc_fops = {
@@ -1707,13 +1479,6 @@ static const struct v4l2_ioctl_ops solo_enc_ioctl_ops = {
 	/* Video capture parameters */
 	.vidioc_s_parm			= solo_s_parm,
 	.vidioc_g_parm			= solo_g_parm,
-	/* Controls */
-	.vidioc_queryctrl		= solo_queryctrl,
-	.vidioc_querymenu		= solo_querymenu,
-	.vidioc_g_ctrl			= solo_g_ctrl,
-	.vidioc_s_ctrl			= solo_s_ctrl,
-	.vidioc_g_ext_ctrls		= solo_g_ext_ctrls,
-	.vidioc_s_ext_ctrls		= solo_s_ext_ctrls,
 };
 
 static struct video_device solo_enc_template = {
@@ -1727,8 +1492,42 @@ static struct video_device solo_enc_template = {
 	.current_norm		= V4L2_STD_NTSC_M,
 };
 
+static const struct v4l2_ctrl_ops solo_ctrl_ops = {
+	.s_ctrl = solo_s_ctrl,
+};
+
+static const struct v4l2_ctrl_config solo_motion_threshold_ctrl = {
+	.ops = &solo_ctrl_ops,
+	.id = V4L2_CID_MOTION_THRESHOLD,
+	.name = "Motion Detection Threshold",
+	.type = V4L2_CTRL_TYPE_INTEGER,
+	.max = 0xffff,
+	.def = SOLO_DEF_MOT_THRESH,
+	.step = 1,
+	.flags = V4L2_CTRL_FLAG_SLIDER,
+};
+
+static const struct v4l2_ctrl_config solo_motion_enable_ctrl = {
+	.ops = &solo_ctrl_ops,
+	.id = V4L2_CID_MOTION_ENABLE,
+	.name = "Motion Detection Enable",
+	.type = V4L2_CTRL_TYPE_BOOLEAN,
+	.max = 1,
+	.step = 1,
+};
+
+static const struct v4l2_ctrl_config solo_osd_text_ctrl = {
+	.ops = &solo_ctrl_ops,
+	.id = V4L2_CID_OSD_TEXT,
+	.name = "OSD Text",
+	.type = V4L2_CTRL_TYPE_STRING,
+	.max = OSD_TEXT_MAX,
+	.step = 1,
+};
+
 static struct solo_enc_dev *solo_enc_alloc(struct solo_dev *solo_dev, u8 ch)
 {
+	struct v4l2_ctrl_handler *hdl;
 	struct solo_enc_dev *solo_enc;
 	int ret;
 
@@ -1736,8 +1535,38 @@ static struct solo_enc_dev *solo_enc_alloc(struct solo_dev *solo_dev, u8 ch)
 	if (!solo_enc)
 		return ERR_PTR(-ENOMEM);
 
+	hdl = &solo_enc->hdl;
+	v4l2_ctrl_handler_init(hdl, 10);
+	v4l2_ctrl_new_std(hdl, &solo_ctrl_ops,
+			V4L2_CID_BRIGHTNESS, 0, 255, 1, 127);
+	v4l2_ctrl_new_std(hdl, &solo_ctrl_ops,
+			V4L2_CID_CONTRAST, 0, 255, 1, 127);
+	v4l2_ctrl_new_std(hdl, &solo_ctrl_ops,
+			V4L2_CID_SATURATION, 0, 255, 1, 127);
+	v4l2_ctrl_new_std(hdl, &solo_ctrl_ops,
+			V4L2_CID_HUE, 0, 255, 1, 127);
+	if (tw28_has_sharpness(solo_dev, ch))
+		v4l2_ctrl_new_std(hdl, &solo_ctrl_ops,
+			V4L2_CID_SHARPNESS, 0, 15, 1, 0);
+	v4l2_ctrl_new_std_menu(hdl, &solo_ctrl_ops,
+			V4L2_CID_MPEG_VIDEO_ENCODING,
+			V4L2_MPEG_VIDEO_ENCODING_MPEG_4_AVC, 3,
+			V4L2_MPEG_VIDEO_ENCODING_MPEG_4_AVC);
+	v4l2_ctrl_new_std(hdl, &solo_ctrl_ops,
+			V4L2_CID_MPEG_VIDEO_GOP_SIZE, 1, 255, 1, solo_dev->fps);
+	v4l2_ctrl_new_custom(hdl, &solo_motion_threshold_ctrl, NULL);
+	v4l2_ctrl_new_custom(hdl, &solo_motion_enable_ctrl, NULL);
+	v4l2_ctrl_new_custom(hdl, &solo_osd_text_ctrl, NULL);
+	if (hdl->error) {
+		ret = hdl->error;
+		v4l2_ctrl_handler_free(hdl);
+		kfree(solo_enc);
+		return ERR_PTR(ret);
+	}
+
 	solo_enc->vfd = video_device_alloc();
 	if (!solo_enc->vfd) {
+		v4l2_ctrl_handler_free(hdl);
 		kfree(solo_enc);
 		return ERR_PTR(-ENOMEM);
 	}
@@ -1747,10 +1576,12 @@ static struct solo_enc_dev *solo_enc_alloc(struct solo_dev *solo_dev, u8 ch)
 
 	*solo_enc->vfd = solo_enc_template;
 	solo_enc->vfd->v4l2_dev = &solo_dev->v4l2_dev;
+	solo_enc->vfd->ctrl_handler = hdl;
 	ret = video_register_device(solo_enc->vfd, VFL_TYPE_GRABBER,
 				    video_nr);
 	if (ret < 0) {
 		video_device_release(solo_enc->vfd);
+		v4l2_ctrl_handler_free(hdl);
 		kfree(solo_enc);
 		return ERR_PTR(ret);
 	}
@@ -1781,12 +1612,13 @@ static struct solo_enc_dev *solo_enc_alloc(struct solo_dev *solo_dev, u8 ch)
 	return solo_enc;
 }
 
-static void solo_enc_free(struct solo_enc_dev *solo_enc)
+static void solo_enc_free(struct solo_enc_dev *solo_enc, int ch)
 {
 	if (solo_enc == NULL)
 		return;
 
 	video_unregister_device(solo_enc->vfd);
+	v4l2_ctrl_handler_free(&solo_enc->hdl);
 	kfree(solo_enc);
 }
 
@@ -1803,7 +1635,7 @@ int solo_enc_v4l2_init(struct solo_dev *solo_dev)
 	if (i != solo_dev->nr_chans) {
 		int ret = PTR_ERR(solo_dev->v4l2_enc[i]);
 		while (i--)
-			solo_enc_free(solo_dev->v4l2_enc[i]);
+			solo_enc_free(solo_dev->v4l2_enc[i], i);
 		return ret;
 	}
 
@@ -1824,5 +1656,5 @@ void solo_enc_v4l2_exit(struct solo_dev *solo_dev)
 	solo_irq_off(solo_dev, SOLO_IRQ_MOTION);
 
 	for (i = 0; i < solo_dev->nr_chans; i++)
-		solo_enc_free(solo_dev->v4l2_enc[i]);
+		solo_enc_free(solo_dev->v4l2_enc[i], i);
 }
diff --git a/drivers/staging/media/solo6x10/v4l2.c b/drivers/staging/media/solo6x10/v4l2.c
index f15ca03..e0cf498 100644
--- a/drivers/staging/media/solo6x10/v4l2.c
+++ b/drivers/staging/media/solo6x10/v4l2.c
@@ -777,64 +777,14 @@ static int solo_s_std(struct file *file, void *priv, v4l2_std_id *i)
 	return 0;
 }
 
-static const u32 solo_motion_ctrls[] = {
-	V4L2_CID_MOTION_TRACE,
-	0
-};
-
-static const u32 *solo_ctrl_classes[] = {
-	solo_motion_ctrls,
-	NULL
-};
-
-static int solo_disp_queryctrl(struct file *file, void *priv,
-			       struct v4l2_queryctrl *qc)
-{
-	qc->id = v4l2_ctrl_next(solo_ctrl_classes, qc->id);
-	if (!qc->id)
-		return -EINVAL;
-
-	switch (qc->id) {
-#ifdef PRIVATE_CIDS
-	case V4L2_CID_MOTION_TRACE:
-		qc->type = V4L2_CTRL_TYPE_BOOLEAN;
-		qc->minimum = 0;
-		qc->maximum = qc->step = 1;
-		qc->default_value = 0;
-		strlcpy(qc->name, "Motion Detection Trace", sizeof(qc->name));
-		return 0;
-#else
-	case V4L2_CID_MOTION_TRACE:
-		return v4l2_ctrl_query_fill(qc, 0, 1, 1, 0);
-#endif
-	}
-	return -EINVAL;
-}
-
-static int solo_disp_g_ctrl(struct file *file, void *priv,
-			    struct v4l2_control *ctrl)
+static int solo_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	struct solo_filehandle *fh = priv;
-	struct solo_dev *solo_dev = fh->solo_dev;
+	struct solo_dev *solo_dev =
+		container_of(ctrl->handler, struct solo_dev, disp_hdl);
 
 	switch (ctrl->id) {
 	case V4L2_CID_MOTION_TRACE:
-		ctrl->value = solo_reg_read(solo_dev, SOLO_VI_MOTION_BAR)
-			? 1 : 0;
-		return 0;
-	}
-	return -EINVAL;
-}
-
-static int solo_disp_s_ctrl(struct file *file, void *priv,
-			    struct v4l2_control *ctrl)
-{
-	struct solo_filehandle *fh = priv;
-	struct solo_dev *solo_dev = fh->solo_dev;
-
-	switch (ctrl->id) {
-	case V4L2_CID_MOTION_TRACE:
-		if (ctrl->value) {
+		if (ctrl->val) {
 			solo_reg_write(solo_dev, SOLO_VI_MOTION_BORDER,
 					SOLO_VI_MOTION_Y_ADD |
 					SOLO_VI_MOTION_Y_VALUE(0x20) |
@@ -850,6 +800,8 @@ static int solo_disp_s_ctrl(struct file *file, void *priv,
 			solo_reg_write(solo_dev, SOLO_VI_MOTION_BAR, 0);
 		}
 		return 0;
+	default:
+		break;
 	}
 	return -EINVAL;
 }
@@ -883,10 +835,6 @@ static const struct v4l2_ioctl_ops solo_v4l2_ioctl_ops = {
 	.vidioc_dqbuf			= solo_dqbuf,
 	.vidioc_streamon		= solo_streamon,
 	.vidioc_streamoff		= solo_streamoff,
-	/* Controls */
-	.vidioc_queryctrl		= solo_disp_queryctrl,
-	.vidioc_g_ctrl			= solo_disp_g_ctrl,
-	.vidioc_s_ctrl			= solo_disp_s_ctrl,
 };
 
 static struct video_device solo_v4l2_template = {
@@ -900,6 +848,19 @@ static struct video_device solo_v4l2_template = {
 	.current_norm		= V4L2_STD_NTSC_M,
 };
 
+static const struct v4l2_ctrl_ops solo_ctrl_ops = {
+	.s_ctrl = solo_s_ctrl,
+};
+
+static const struct v4l2_ctrl_config solo_motion_trace_ctrl = {
+	.ops = &solo_ctrl_ops,
+	.id = V4L2_CID_MOTION_TRACE,
+	.name = "Motion Detection Trace",
+	.type = V4L2_CTRL_TYPE_BOOLEAN,
+	.max = 1,
+	.step = 1,
+};
+
 int solo_v4l2_init(struct solo_dev *solo_dev)
 {
 	int ret;
@@ -913,6 +874,11 @@ int solo_v4l2_init(struct solo_dev *solo_dev)
 
 	*solo_dev->vfd = solo_v4l2_template;
 	solo_dev->vfd->v4l2_dev = &solo_dev->v4l2_dev;
+	v4l2_ctrl_handler_init(&solo_dev->disp_hdl, 1);
+	v4l2_ctrl_new_custom(&solo_dev->disp_hdl, &solo_motion_trace_ctrl, NULL);
+	if (solo_dev->disp_hdl.error)
+		return solo_dev->disp_hdl.error;
+	solo_dev->vfd->ctrl_handler = &solo_dev->disp_hdl;
 
 	ret = video_register_device(solo_dev->vfd, VFL_TYPE_GRABBER, video_nr);
 	if (ret < 0) {
@@ -957,4 +923,5 @@ void solo_v4l2_exit(struct solo_dev *solo_dev)
 		video_unregister_device(solo_dev->vfd);
 		solo_dev->vfd = NULL;
 	}
+	v4l2_ctrl_handler_free(&solo_dev->disp_hdl);
 }
-- 
1.7.10.4

