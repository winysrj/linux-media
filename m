Return-path: <mchehab@gaivota>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2024 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582Ab0LLRcJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Dec 2010 12:32:09 -0500
Received: from localhost.localdomain (159.80-203-19.nextgentel.com [80.203.19.159])
	(authenticated bits=0)
	by smtp-vbr5.xs4all.nl (8.13.8/8.13.8) with ESMTP id oBCHW1ML002236
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 12 Dec 2010 18:32:08 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFC/PATCH 13/19] vpx3220: use control framework
Date: Sun, 12 Dec 2010 18:31:55 +0100
Message-Id: <fbf27320f01643b6bc08f84dc66cb1fdc95ca30a.1292174822.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1292174822.git.hverkuil@xs4all.nl>
References: <cover.1292174822.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1292174822.git.hverkuil@xs4all.nl>
References: <cover.1292174822.git.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/vpx3220.c |  137 +++++++++++++++--------------------------
 1 files changed, 51 insertions(+), 86 deletions(-)

diff --git a/drivers/media/video/vpx3220.c b/drivers/media/video/vpx3220.c
index 91a01b3..75301d1 100644
--- a/drivers/media/video/vpx3220.c
+++ b/drivers/media/video/vpx3220.c
@@ -28,6 +28,7 @@
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-chip-ident.h>
+#include <media/v4l2-ctrls.h>
 
 MODULE_DESCRIPTION("vpx3220a/vpx3216b/vpx3214c video decoder driver");
 MODULE_AUTHOR("Laurent Pinchart");
@@ -44,16 +45,13 @@ MODULE_PARM_DESC(debug, "Debug level (0-1)");
 
 struct vpx3220 {
 	struct v4l2_subdev sd;
+	struct v4l2_ctrl_handler hdl;
 	unsigned char reg[255];
 
 	v4l2_std_id norm;
 	int ident;
 	int input;
 	int enable;
-	int bright;
-	int contrast;
-	int hue;
-	int sat;
 };
 
 static inline struct vpx3220 *to_vpx3220(struct v4l2_subdev *sd)
@@ -61,6 +59,11 @@ static inline struct vpx3220 *to_vpx3220(struct v4l2_subdev *sd)
 	return container_of(sd, struct vpx3220, sd);
 }
 
+static inline struct v4l2_subdev *to_sd(struct v4l2_ctrl *ctrl)
+{
+	return &container_of(ctrl->handler, struct vpx3220, hdl)->sd;
+}
+
 static char *inputs[] = { "internal", "composite", "svideo" };
 
 /* ----------------------------------------------------------------------- */
@@ -417,88 +420,26 @@ static int vpx3220_s_stream(struct v4l2_subdev *sd, int enable)
 	return 0;
 }
 
-static int vpx3220_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qc)
-{
-	switch (qc->id) {
-	case V4L2_CID_BRIGHTNESS:
-		v4l2_ctrl_query_fill(qc, -128, 127, 1, 0);
-		break;
-
-	case V4L2_CID_CONTRAST:
-		v4l2_ctrl_query_fill(qc, 0, 63, 1, 32);
-		break;
-
-	case V4L2_CID_SATURATION:
-		v4l2_ctrl_query_fill(qc, 0, 4095, 1, 2048);
-		break;
-
-	case V4L2_CID_HUE:
-		v4l2_ctrl_query_fill(qc, -512, 511, 1, 0);
-		break;
-
-	default:
-		return -EINVAL;
-	}
-	return 0;
-}
-
-static int vpx3220_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+static int vpx3220_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	struct vpx3220 *decoder = to_vpx3220(sd);
+	struct v4l2_subdev *sd = to_sd(ctrl);
 
 	switch (ctrl->id) {
 	case V4L2_CID_BRIGHTNESS:
-		ctrl->value = decoder->bright;
-		break;
+		vpx3220_write(sd, 0xe6, ctrl->val);
+		return 0;
 	case V4L2_CID_CONTRAST:
-		ctrl->value = decoder->contrast;
-		break;
+		/* Bit 7 and 8 is for noise shaping */
+		vpx3220_write(sd, 0xe7, ctrl->val + 192);
+		return 0;
 	case V4L2_CID_SATURATION:
-		ctrl->value = decoder->sat;
-		break;
+		vpx3220_fp_write(sd, 0xa0, ctrl->val);
+		return 0;
 	case V4L2_CID_HUE:
-		ctrl->value = decoder->hue;
-		break;
-	default:
-		return -EINVAL;
+		vpx3220_fp_write(sd, 0x1c, ctrl->val);
+		return 0;
 	}
-	return 0;
-}
-
-static int vpx3220_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
-{
-	struct vpx3220 *decoder = to_vpx3220(sd);
-
-	switch (ctrl->id) {
-	case V4L2_CID_BRIGHTNESS:
-		if (decoder->bright != ctrl->value) {
-			decoder->bright = ctrl->value;
-			vpx3220_write(sd, 0xe6, decoder->bright);
-		}
-		break;
-	case V4L2_CID_CONTRAST:
-		if (decoder->contrast != ctrl->value) {
-			/* Bit 7 and 8 is for noise shaping */
-			decoder->contrast = ctrl->value;
-			vpx3220_write(sd, 0xe7, decoder->contrast + 192);
-		}
-		break;
-	case V4L2_CID_SATURATION:
-		if (decoder->sat != ctrl->value) {
-			decoder->sat = ctrl->value;
-			vpx3220_fp_write(sd, 0xa0, decoder->sat);
-		}
-		break;
-	case V4L2_CID_HUE:
-		if (decoder->hue != ctrl->value) {
-			decoder->hue = ctrl->value;
-			vpx3220_fp_write(sd, 0x1c, decoder->hue);
-		}
-		break;
-	default:
-		return -EINVAL;
-	}
-	return 0;
+	return -EINVAL;
 }
 
 static int vpx3220_g_chip_ident(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident *chip)
@@ -511,12 +452,20 @@ static int vpx3220_g_chip_ident(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ide
 
 /* ----------------------------------------------------------------------- */
 
+static const struct v4l2_ctrl_ops vpx3220_ctrl_ops = {
+	.s_ctrl = vpx3220_s_ctrl,
+};
+
 static const struct v4l2_subdev_core_ops vpx3220_core_ops = {
 	.g_chip_ident = vpx3220_g_chip_ident,
 	.init = vpx3220_init,
-	.g_ctrl = vpx3220_g_ctrl,
-	.s_ctrl = vpx3220_s_ctrl,
-	.queryctrl = vpx3220_queryctrl,
+	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
+	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
+	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
+	.g_ctrl = v4l2_subdev_g_ctrl,
+	.s_ctrl = v4l2_subdev_s_ctrl,
+	.queryctrl = v4l2_subdev_queryctrl,
+	.querymenu = v4l2_subdev_querymenu,
 	.s_std = vpx3220_s_std,
 };
 
@@ -558,10 +507,24 @@ static int vpx3220_probe(struct i2c_client *client,
 	decoder->norm = V4L2_STD_PAL;
 	decoder->input = 0;
 	decoder->enable = 1;
-	decoder->bright = 32768;
-	decoder->contrast = 32768;
-	decoder->hue = 32768;
-	decoder->sat = 32768;
+	v4l2_ctrl_handler_init(&decoder->hdl, 4);
+	v4l2_ctrl_new_std(&decoder->hdl, &vpx3220_ctrl_ops,
+		V4L2_CID_BRIGHTNESS, -128, 127, 1, 0);
+	v4l2_ctrl_new_std(&decoder->hdl, &vpx3220_ctrl_ops,
+		V4L2_CID_CONTRAST, 0, 63, 1, 32);
+	v4l2_ctrl_new_std(&decoder->hdl, &vpx3220_ctrl_ops,
+		V4L2_CID_SATURATION, 0, 4095, 1, 2048);
+	v4l2_ctrl_new_std(&decoder->hdl, &vpx3220_ctrl_ops,
+		V4L2_CID_HUE, -512, 511, 1, 0);
+	sd->ctrl_handler = &decoder->hdl;
+	if (decoder->hdl.error) {
+		int err = decoder->hdl.error;
+
+		v4l2_ctrl_handler_free(&decoder->hdl);
+		kfree(decoder);
+		return err;
+	}
+	v4l2_ctrl_handler_setup(&decoder->hdl);
 
 	ver = i2c_smbus_read_byte_data(client, 0x00);
 	pn = (i2c_smbus_read_byte_data(client, 0x02) << 8) +
@@ -599,9 +562,11 @@ static int vpx3220_probe(struct i2c_client *client,
 static int vpx3220_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct vpx3220 *decoder = to_vpx3220(sd);
 
 	v4l2_device_unregister_subdev(sd);
-	kfree(to_vpx3220(sd));
+	v4l2_ctrl_handler_free(&decoder->hdl);
+	kfree(decoder);
 	return 0;
 }
 
-- 
1.7.0.4

