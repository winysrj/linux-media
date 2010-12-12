Return-path: <mchehab@gaivota>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3177 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab0LLRcG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Dec 2010 12:32:06 -0500
Received: from localhost.localdomain (159.80-203-19.nextgentel.com [80.203.19.159])
	(authenticated bits=0)
	by smtp-vbr5.xs4all.nl (8.13.8/8.13.8) with ESMTP id oBCHW1MD002236
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 12 Dec 2010 18:32:04 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFC/PATCH 05/19] bt819: use control framework
Date: Sun, 12 Dec 2010 18:31:47 +0100
Message-Id: <35fdf7748872d3b6ea38695a9dd1c013a384593c.1292174822.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1292174822.git.hverkuil@xs4all.nl>
References: <cover.1292174822.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1292174822.git.hverkuil@xs4all.nl>
References: <cover.1292174822.git.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/bt819.c |  129 ++++++++++++++++--------------------------
 1 files changed, 49 insertions(+), 80 deletions(-)

diff --git a/drivers/media/video/bt819.c b/drivers/media/video/bt819.c
index c38300f..f872044 100644
--- a/drivers/media/video/bt819.c
+++ b/drivers/media/video/bt819.c
@@ -37,6 +37,7 @@
 #include <linux/slab.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-chip-ident.h>
+#include <media/v4l2-ctrls.h>
 #include <media/bt819.h>
 
 MODULE_DESCRIPTION("Brooktree-819 video decoder driver");
@@ -52,16 +53,13 @@ MODULE_PARM_DESC(debug, "Debug level (0-1)");
 
 struct bt819 {
 	struct v4l2_subdev sd;
+	struct v4l2_ctrl_handler hdl;
 	unsigned char reg[32];
 
 	v4l2_std_id norm;
 	int ident;
 	int input;
 	int enable;
-	int bright;
-	int contrast;
-	int hue;
-	int sat;
 };
 
 static inline struct bt819 *to_bt819(struct v4l2_subdev *sd)
@@ -69,6 +67,11 @@ static inline struct bt819 *to_bt819(struct v4l2_subdev *sd)
 	return container_of(sd, struct bt819, sd);
 }
 
+static inline struct v4l2_subdev *to_sd(struct v4l2_ctrl *ctrl)
+{
+	return &container_of(ctrl->handler, struct bt819, hdl)->sd;
+}
+
 struct timing {
 	int hactive;
 	int hdelay;
@@ -333,71 +336,35 @@ static int bt819_s_stream(struct v4l2_subdev *sd, int enable)
 	return 0;
 }
 
-static int bt819_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qc)
-{
-	switch (qc->id) {
-	case V4L2_CID_BRIGHTNESS:
-		v4l2_ctrl_query_fill(qc, -128, 127, 1, 0);
-		break;
-
-	case V4L2_CID_CONTRAST:
-		v4l2_ctrl_query_fill(qc, 0, 511, 1, 256);
-		break;
-
-	case V4L2_CID_SATURATION:
-		v4l2_ctrl_query_fill(qc, 0, 511, 1, 256);
-		break;
-
-	case V4L2_CID_HUE:
-		v4l2_ctrl_query_fill(qc, -128, 127, 1, 0);
-		break;
-
-	default:
-		return -EINVAL;
-	}
-	return 0;
-}
-
-static int bt819_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+static int bt819_s_ctrl(struct v4l2_ctrl *ctrl)
 {
+	struct v4l2_subdev *sd = to_sd(ctrl);
 	struct bt819 *decoder = to_bt819(sd);
 	int temp;
 
 	switch (ctrl->id) {
 	case V4L2_CID_BRIGHTNESS:
-		if (decoder->bright == ctrl->value)
-			break;
-		decoder->bright = ctrl->value;
-		bt819_write(decoder, 0x0a, decoder->bright);
+		bt819_write(decoder, 0x0a, ctrl->val);
 		break;
 
 	case V4L2_CID_CONTRAST:
-		if (decoder->contrast == ctrl->value)
-			break;
-		decoder->contrast = ctrl->value;
-		bt819_write(decoder, 0x0c, decoder->contrast & 0xff);
-		bt819_setbit(decoder, 0x0b, 2, ((decoder->contrast >> 8) & 0x01));
+		bt819_write(decoder, 0x0c, ctrl->val & 0xff);
+		bt819_setbit(decoder, 0x0b, 2, ((ctrl->val >> 8) & 0x01));
 		break;
 
 	case V4L2_CID_SATURATION:
-		if (decoder->sat == ctrl->value)
-			break;
-		decoder->sat = ctrl->value;
-		bt819_write(decoder, 0x0d, (decoder->sat >> 7) & 0xff);
-		bt819_setbit(decoder, 0x0b, 1, ((decoder->sat >> 15) & 0x01));
+		bt819_write(decoder, 0x0d, (ctrl->val >> 7) & 0xff);
+		bt819_setbit(decoder, 0x0b, 1, ((ctrl->val >> 15) & 0x01));
 
 		/* Ratio between U gain and V gain must stay the same as
 		   the ratio between the default U and V gain values. */
-		temp = (decoder->sat * 180) / 254;
+		temp = (ctrl->val * 180) / 254;
 		bt819_write(decoder, 0x0e, (temp >> 7) & 0xff);
 		bt819_setbit(decoder, 0x0b, 0, (temp >> 15) & 0x01);
 		break;
 
 	case V4L2_CID_HUE:
-		if (decoder->hue == ctrl->value)
-			break;
-		decoder->hue = ctrl->value;
-		bt819_write(decoder, 0x0f, decoder->hue);
+		bt819_write(decoder, 0x0f, ctrl->val);
 		break;
 
 	default:
@@ -406,29 +373,6 @@ static int bt819_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 	return 0;
 }
 
-static int bt819_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
-{
-	struct bt819 *decoder = to_bt819(sd);
-
-	switch (ctrl->id) {
-	case V4L2_CID_BRIGHTNESS:
-		ctrl->value = decoder->bright;
-		break;
-	case V4L2_CID_CONTRAST:
-		ctrl->value = decoder->contrast;
-		break;
-	case V4L2_CID_SATURATION:
-		ctrl->value = decoder->sat;
-		break;
-	case V4L2_CID_HUE:
-		ctrl->value = decoder->hue;
-		break;
-	default:
-		return -EINVAL;
-	}
-	return 0;
-}
-
 static int bt819_g_chip_ident(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident *chip)
 {
 	struct bt819 *decoder = to_bt819(sd);
@@ -439,11 +383,19 @@ static int bt819_g_chip_ident(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident
 
 /* ----------------------------------------------------------------------- */
 
+static const struct v4l2_ctrl_ops bt819_ctrl_ops = {
+	.s_ctrl = bt819_s_ctrl,
+};
+
 static const struct v4l2_subdev_core_ops bt819_core_ops = {
 	.g_chip_ident = bt819_g_chip_ident,
-	.g_ctrl = bt819_g_ctrl,
-	.s_ctrl = bt819_s_ctrl,
-	.queryctrl = bt819_queryctrl,
+	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
+	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
+	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
+	.g_ctrl = v4l2_subdev_g_ctrl,
+	.s_ctrl = v4l2_subdev_s_ctrl,
+	.queryctrl = v4l2_subdev_queryctrl,
+	.querymenu = v4l2_subdev_querymenu,
 	.s_std = bt819_s_std,
 };
 
@@ -505,23 +457,40 @@ static int bt819_probe(struct i2c_client *client,
 	decoder->norm = V4L2_STD_NTSC;
 	decoder->input = 0;
 	decoder->enable = 1;
-	decoder->bright = 0;
-	decoder->contrast = 0xd8;	/* 100% of original signal */
-	decoder->hue = 0;
-	decoder->sat = 0xfe;		/* 100% of original signal */
 
 	i = bt819_init(sd);
 	if (i < 0)
 		v4l2_dbg(1, debug, sd, "init status %d\n", i);
+
+	v4l2_ctrl_handler_init(&decoder->hdl, 4);
+	v4l2_ctrl_new_std(&decoder->hdl, &bt819_ctrl_ops,
+			V4L2_CID_BRIGHTNESS, -128, 127, 1, 0);
+	v4l2_ctrl_new_std(&decoder->hdl, &bt819_ctrl_ops,
+			V4L2_CID_CONTRAST, 0, 511, 1, 0xd8);
+	v4l2_ctrl_new_std(&decoder->hdl, &bt819_ctrl_ops,
+			V4L2_CID_SATURATION, 0, 511, 1, 0xfe);
+	v4l2_ctrl_new_std(&decoder->hdl, &bt819_ctrl_ops,
+			V4L2_CID_HUE, -128, 127, 1, 0);
+	sd->ctrl_handler = &decoder->hdl;
+	if (decoder->hdl.error) {
+		int err = decoder->hdl.error;
+
+		v4l2_ctrl_handler_free(&decoder->hdl);
+		kfree(decoder);
+		return err;
+	}
+	v4l2_ctrl_handler_setup(&decoder->hdl);
 	return 0;
 }
 
 static int bt819_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct bt819 *decoder = to_bt819(sd);
 
 	v4l2_device_unregister_subdev(sd);
-	kfree(to_bt819(sd));
+	v4l2_ctrl_handler_free(&decoder->hdl);
+	kfree(decoder);
 	return 0;
 }
 
-- 
1.7.0.4

