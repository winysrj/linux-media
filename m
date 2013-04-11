Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:38539 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824Ab3DKWJJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Apr 2013 18:09:09 -0400
Received: by mail-la0-f46.google.com with SMTP id ea20so1958436lab.33
        for <linux-media@vger.kernel.org>; Thu, 11 Apr 2013 15:09:07 -0700 (PDT)
To: mchehab@redhat.com, linux-media@vger.kernel.org
Subject: [PATCH v2 2/2] adv7180: add more subdev video ops
Cc: vladimir.barinov@cogentembedded.com
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Date: Fri, 12 Apr 2013 02:08:09 +0400
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304120208.09564.sergei.shtylyov@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>

Add subdev video ops for ADV7180 video decoder.  This makes decoder usable on
the soc-camera drivers.

Signed-off-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

---
 drivers/media/i2c/adv7180.c |  105 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 105 insertions(+)

Index: linux/drivers/media/i2c/adv7180.c
===================================================================
--- linux.orig/drivers/media/i2c/adv7180.c
+++ linux/drivers/media/i2c/adv7180.c
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
@@ -397,10 +400,112 @@ static void adv7180_exit_controls(struct
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
+	adv7180_querystd(sd, &state->curr_norm);
+
+	fmt->code = V4L2_MBUS_FMT_YUYV8_2X8;
+	fmt->colorspace = V4L2_COLORSPACE_SMPTE170M;
+	fmt->field = V4L2_FIELD_INTERLACED;
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
+	adv7180_querystd(sd, &state->curr_norm);
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
+static int adv7180_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
+{
+	struct adv7180_state *state = to_state(sd);
+
+	adv7180_querystd(sd, &state->curr_norm);
+
+	a->c.left = 0;
+	a->c.top = 0;
+	a->c.width = 720;
+	a->c.height = state->curr_norm & V4L2_STD_525_60 ? 480 : 576;
+	a->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
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
+	.g_crop = adv7180_g_crop,
+	.g_mbus_config = adv7180_g_mbus_config,
 };
 
 static const struct v4l2_subdev_core_ops adv7180_core_ops = {
