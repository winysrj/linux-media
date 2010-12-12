Return-path: <mchehab@gaivota>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1354 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444Ab0LLRcG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Dec 2010 12:32:06 -0500
Received: from localhost.localdomain (159.80-203-19.nextgentel.com [80.203.19.159])
	(authenticated bits=0)
	by smtp-vbr5.xs4all.nl (8.13.8/8.13.8) with ESMTP id oBCHW1MF002236
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 12 Dec 2010 18:32:05 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFC/PATCH 07/19] saa7110: use control framework
Date: Sun, 12 Dec 2010 18:31:49 +0100
Message-Id: <ccdb5079d985ab32d86f88a432bef4d9948f25e9.1292174822.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1292174822.git.hverkuil@xs4all.nl>
References: <cover.1292174822.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1292174822.git.hverkuil@xs4all.nl>
References: <cover.1292174822.git.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/saa7110.c |  115 ++++++++++++++++------------------------
 1 files changed, 46 insertions(+), 69 deletions(-)

diff --git a/drivers/media/video/saa7110.c b/drivers/media/video/saa7110.c
index 7913f93..9966420 100644
--- a/drivers/media/video/saa7110.c
+++ b/drivers/media/video/saa7110.c
@@ -36,6 +36,7 @@
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-chip-ident.h>
+#include <media/v4l2-ctrls.h>
 
 MODULE_DESCRIPTION("Philips SAA7110 video decoder driver");
 MODULE_AUTHOR("Pauline Middelink");
@@ -53,15 +54,12 @@ MODULE_PARM_DESC(debug, "Debug level (0-1)");
 
 struct saa7110 {
 	struct v4l2_subdev sd;
+	struct v4l2_ctrl_handler hdl;
 	u8 reg[SAA7110_NR_REG];
 
 	v4l2_std_id norm;
 	int input;
 	int enable;
-	int bright;
-	int contrast;
-	int hue;
-	int sat;
 
 	wait_queue_head_t wq;
 };
@@ -71,6 +69,11 @@ static inline struct saa7110 *to_saa7110(struct v4l2_subdev *sd)
 	return container_of(sd, struct saa7110, sd);
 }
 
+static inline struct v4l2_subdev *to_sd(struct v4l2_ctrl *ctrl)
+{
+	return &container_of(ctrl->handler, struct saa7110, hdl)->sd;
+}
+
 /* ----------------------------------------------------------------------- */
 /* I2C support functions						   */
 /* ----------------------------------------------------------------------- */
@@ -326,73 +329,22 @@ static int saa7110_s_stream(struct v4l2_subdev *sd, int enable)
 	return 0;
 }
 
-static int saa7110_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qc)
-{
-	switch (qc->id) {
-	case V4L2_CID_BRIGHTNESS:
-		return v4l2_ctrl_query_fill(qc, 0, 255, 1, 128);
-	case V4L2_CID_CONTRAST:
-	case V4L2_CID_SATURATION:
-		return v4l2_ctrl_query_fill(qc, 0, 127, 1, 64);
-	case V4L2_CID_HUE:
-		return v4l2_ctrl_query_fill(qc, -128, 127, 1, 0);
-	default:
-		return -EINVAL;
-	}
-	return 0;
-}
-
-static int saa7110_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
-{
-	struct saa7110 *decoder = to_saa7110(sd);
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
-static int saa7110_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+static int saa7110_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	struct saa7110 *decoder = to_saa7110(sd);
+	struct v4l2_subdev *sd = to_sd(ctrl);
 
 	switch (ctrl->id) {
 	case V4L2_CID_BRIGHTNESS:
-		if (decoder->bright != ctrl->value) {
-			decoder->bright = ctrl->value;
-			saa7110_write(sd, 0x19, decoder->bright);
-		}
+		saa7110_write(sd, 0x19, ctrl->val);
 		break;
 	case V4L2_CID_CONTRAST:
-		if (decoder->contrast != ctrl->value) {
-			decoder->contrast = ctrl->value;
-			saa7110_write(sd, 0x13, decoder->contrast);
-		}
+		saa7110_write(sd, 0x13, ctrl->val);
 		break;
 	case V4L2_CID_SATURATION:
-		if (decoder->sat != ctrl->value) {
-			decoder->sat = ctrl->value;
-			saa7110_write(sd, 0x12, decoder->sat);
-		}
+		saa7110_write(sd, 0x12, ctrl->val);
 		break;
 	case V4L2_CID_HUE:
-		if (decoder->hue != ctrl->value) {
-			decoder->hue = ctrl->value;
-			saa7110_write(sd, 0x07, decoder->hue);
-		}
+		saa7110_write(sd, 0x07, ctrl->val);
 		break;
 	default:
 		return -EINVAL;
@@ -409,11 +361,19 @@ static int saa7110_g_chip_ident(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ide
 
 /* ----------------------------------------------------------------------- */
 
+static const struct v4l2_ctrl_ops saa7110_ctrl_ops = {
+	.s_ctrl = saa7110_s_ctrl,
+};
+
 static const struct v4l2_subdev_core_ops saa7110_core_ops = {
 	.g_chip_ident = saa7110_g_chip_ident,
-	.g_ctrl = saa7110_g_ctrl,
-	.s_ctrl = saa7110_s_ctrl,
-	.queryctrl = saa7110_queryctrl,
+	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
+	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
+	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
+	.g_ctrl = v4l2_subdev_g_ctrl,
+	.s_ctrl = v4l2_subdev_s_ctrl,
+	.queryctrl = v4l2_subdev_queryctrl,
+	.querymenu = v4l2_subdev_querymenu,
 	.s_std = saa7110_s_std,
 };
 
@@ -454,10 +414,25 @@ static int saa7110_probe(struct i2c_client *client,
 	decoder->norm = V4L2_STD_PAL;
 	decoder->input = 0;
 	decoder->enable = 1;
-	decoder->bright = 32768;
-	decoder->contrast = 32768;
-	decoder->hue = 32768;
-	decoder->sat = 32768;
+	v4l2_ctrl_handler_init(&decoder->hdl, 2);
+	v4l2_ctrl_new_std(&decoder->hdl, &saa7110_ctrl_ops,
+		V4L2_CID_BRIGHTNESS, 0, 255, 1, 128);
+	v4l2_ctrl_new_std(&decoder->hdl, &saa7110_ctrl_ops,
+		V4L2_CID_CONTRAST, 0, 127, 1, 64);
+	v4l2_ctrl_new_std(&decoder->hdl, &saa7110_ctrl_ops,
+		V4L2_CID_SATURATION, 0, 127, 1, 64);
+	v4l2_ctrl_new_std(&decoder->hdl, &saa7110_ctrl_ops,
+		V4L2_CID_HUE, -128, 127, 1, 0);
+	sd->ctrl_handler = &decoder->hdl;
+	if (decoder->hdl.error) {
+		int err = decoder->hdl.error;
+
+		v4l2_ctrl_handler_free(&decoder->hdl);
+		kfree(decoder);
+		return err;
+	}
+	v4l2_ctrl_handler_setup(&decoder->hdl);
+
 	init_waitqueue_head(&decoder->wq);
 
 	rv = saa7110_write_block(sd, initseq, sizeof(initseq));
@@ -490,9 +465,11 @@ static int saa7110_probe(struct i2c_client *client,
 static int saa7110_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct saa7110 *decoder = to_saa7110(sd);
 
 	v4l2_device_unregister_subdev(sd);
-	kfree(to_saa7110(sd));
+	v4l2_ctrl_handler_free(&decoder->hdl);
+	kfree(decoder);
 	return 0;
 }
 
-- 
1.7.0.4

