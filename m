Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:57203 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994Ab3EMTVo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 May 2013 15:21:44 -0400
Received: by mail-la0-f41.google.com with SMTP id lx15so4098568lab.14
        for <linux-media@vger.kernel.org>; Mon, 13 May 2013 12:21:42 -0700 (PDT)
To: mchehab@redhat.com, linux-media@vger.kernel.org
Subject: [PATCH v3] adv7180: add more subdev video ops
Cc: vladimir.barinov@cogentembedded.com, linux-sh@vger.kernel.org,
	matsu@igel.co.jp
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Date: Mon, 13 May 2013 23:21:39 +0400
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305132321.39495.sergei.shtylyov@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>

Add subdev video ops for ADV7180 video decoder.  This makes decoder usable on
the soc-camera drivers.

Signed-off-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

---
This patch is against the 'media_tree.git' repo.

Changes from version 2:
- set the field format depending on video standard in try_mbus_fmt() method;
- removed querystd() method calls from try_mbus_fmt() and cropcap() methods;
- removed g_crop() method.

 drivers/media/i2c/adv7180.c |   86 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 86 insertions(+)

Index: media_tree/drivers/media/i2c/adv7180.c
===================================================================
--- media_tree.orig/drivers/media/i2c/adv7180.c
+++ media_tree/drivers/media/i2c/adv7180.c
@@ -1,6 +1,8 @@
 /*
  * adv7180.c Analog Devices ADV7180 video decoder driver
  * Copyright (c) 2009 Intel Corporation
+ * Copyright (C) 2013 Cogent Embedded, Inc.
+ * Copyright (C) 2013 Renesas Solutions Corp.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -128,6 +130,7 @@ struct adv7180_state {
 	v4l2_std_id		curr_norm;
 	bool			autodetect;
 	u8			input;
+	struct v4l2_mbus_framefmt fmt;
 };
 #define to_adv7180_sd(_ctrl) (&container_of(_ctrl->handler,		\
 					    struct adv7180_state,	\
@@ -397,10 +400,93 @@ static void adv7180_exit_controls(struct
 	v4l2_ctrl_handler_free(&state->ctrl_hdl);
 }
 
+static int adv7180_enum_mbus_fmt(struct v4l2_subdev *sd, unsigned int index,
+				 enum v4l2_mbus_pixelcode *code)
+{
+	if (index > 0)
+		return -EINVAL;
+
+	*code = V4L2_MBUS_FMT_YUYV8_2X8;
+
+	return 0;
+}
+
+static int adv7180_try_mbus_fmt(struct v4l2_subdev *sd,
+				struct v4l2_mbus_framefmt *fmt)
+{
+	struct adv7180_state *state = to_state(sd);
+
+	fmt->code = V4L2_MBUS_FMT_YUYV8_2X8;
+	fmt->colorspace = V4L2_COLORSPACE_SMPTE170M;
+	fmt->field = state->curr_norm & V4L2_STD_525_60 ?
+		     V4L2_FIELD_INTERLACED_BT : V4L2_FIELD_INTERLACED_TB;
+	fmt->width = 720;
+	fmt->height = state->curr_norm & V4L2_STD_525_60 ? 480 : 576;
+
+	return 0;
+}
+
+static int adv7180_g_mbus_fmt(struct v4l2_subdev *sd,
+			      struct v4l2_mbus_framefmt *fmt)
+{
+	struct adv7180_state *state = to_state(sd);
+
+	*fmt = state->fmt;
+
+	return 0;
+}
+
+static int adv7180_s_mbus_fmt(struct v4l2_subdev *sd,
+			      struct v4l2_mbus_framefmt *fmt)
+{
+	struct adv7180_state *state = to_state(sd);
+
+	adv7180_try_mbus_fmt(sd, fmt);
+	state->fmt = *fmt;
+
+	return 0;
+}
+
+static int adv7180_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
+{
+	struct adv7180_state *state = to_state(sd);
+
+	a->bounds.left = 0;
+	a->bounds.top = 0;
+	a->bounds.width = 720;
+	a->bounds.height = state->curr_norm & V4L2_STD_525_60 ? 480 : 576;
+	a->defrect = a->bounds;
+	a->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	a->pixelaspect.numerator = 1;
+	a->pixelaspect.denominator = 1;
+
+	return 0;
+}
+
+static int adv7180_g_mbus_config(struct v4l2_subdev *sd,
+				 struct v4l2_mbus_config *cfg)
+{
+	/*
+	 * The ADV7180 sensor supports BT.601/656 output modes.
+	 * The BT.656 is default and not yet configurable by s/w.
+	 */
+	cfg->flags = V4L2_MBUS_MASTER | V4L2_MBUS_PCLK_SAMPLE_RISING |
+		     V4L2_MBUS_DATA_ACTIVE_HIGH;
+	cfg->type = V4L2_MBUS_BT656;
+
+	return 0;
+}
+
 static const struct v4l2_subdev_video_ops adv7180_video_ops = {
 	.querystd = adv7180_querystd,
 	.g_input_status = adv7180_g_input_status,
 	.s_routing = adv7180_s_routing,
+	.enum_mbus_fmt = adv7180_enum_mbus_fmt,
+	.try_mbus_fmt = adv7180_try_mbus_fmt,
+	.g_mbus_fmt = adv7180_g_mbus_fmt,
+	.s_mbus_fmt = adv7180_s_mbus_fmt,
+	.cropcap = adv7180_cropcap,
+	.g_mbus_config = adv7180_g_mbus_config,
 };
 
 static const struct v4l2_subdev_core_ops adv7180_core_ops = {
