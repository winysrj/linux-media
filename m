Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:49884 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752899AbdJLQV5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Oct 2017 12:21:57 -0400
Received: by mail-pf0-f193.google.com with SMTP id l188so5541872pfc.6
        for <linux-media@vger.kernel.org>; Thu, 12 Oct 2017 09:21:56 -0700 (PDT)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 4/4] media: ov7670: add get_fmt() pad ops callback
Date: Fri, 13 Oct 2017 01:21:17 +0900
Message-Id: <1507825277-18364-5-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1507825277-18364-1-git-send-email-akinobu.mita@gmail.com>
References: <1507825277-18364-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This enables to print the current format on the source pad of the ov7670
subdev by media-ctl.

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/i2c/ov7670.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index 38e1876..9fe99c5 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -234,6 +234,7 @@ struct ov7670_info {
 		struct v4l2_ctrl *hue;
 	};
 	struct ov7670_format_struct *fmt;  /* Current format */
+	struct ov7670_win_size *wsize;	/* Current format */
 	struct clk *clk;
 	struct gpio_desc *resetb_gpio;
 	struct gpio_desc *pwdn_gpio;
@@ -875,6 +876,36 @@ static int ov7670_set_framerate_legacy(struct v4l2_subdev *sd,
 	return ov7670_write(sd, REG_CLKRC, info->clkrc);
 }
 
+static int ov7670_get_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *fmt)
+{
+	struct ov7670_info *info = to_state(sd);
+
+	if (fmt->pad)
+		return -EINVAL;
+
+	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
+#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
+		struct v4l2_mbus_framefmt *mf;
+
+		mf = v4l2_subdev_get_try_format(sd, cfg, 0);
+		fmt->format = *mf;
+		return 0;
+#else
+		return -ENOTTY;
+#endif
+	}
+
+	fmt->format.colorspace = info->fmt->colorspace;
+	fmt->format.code = info->fmt->mbus_code;
+	fmt->format.field = V4L2_FIELD_NONE;
+	fmt->format.width = info->wsize->width;
+	fmt->format.height = info->wsize->height;
+
+	return 0;
+}
+
 /*
  * Store a set of start/stop values into the camera.
  */
@@ -1026,6 +1057,7 @@ static int ov7670_set_fmt(struct v4l2_subdev *sd,
 	if (wsize->regs)
 		ret = ov7670_write_array(sd, wsize->regs);
 	info->fmt = ovfmt;
+	info->wsize = wsize;
 
 	/*
 	 * If we're running RGB565, we must rewrite clkrc after setting
@@ -1529,6 +1561,7 @@ static const struct v4l2_subdev_pad_ops ov7670_pad_ops = {
 	.enum_frame_interval = ov7670_enum_frame_interval,
 	.enum_frame_size = ov7670_enum_frame_size,
 	.enum_mbus_code = ov7670_enum_mbus_code,
+	.get_fmt = ov7670_get_fmt,
 	.set_fmt = ov7670_set_fmt,
 };
 
@@ -1647,6 +1680,7 @@ static int ov7670_probe(struct i2c_client *client,
 
 	info->devtype = &ov7670_devdata[id->driver_data];
 	info->fmt = &ov7670_formats[0];
+	info->wsize = &info->devtype->win_sizes[0];
 	info->clkrc = 0;
 
 	/* Set default frame rate to 30 fps */
-- 
2.7.4
