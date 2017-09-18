Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:3082 "EHLO
        eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751706AbdIRGr3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Sep 2017 02:47:29 -0400
From: Wenyou Yang <wenyou.yang@microchip.com>
To: Jonathan Corbet <corbet@lwn.net>
CC: Nicolas Ferre <nicolas.ferre@microchip.com>,
        <linux-kernel@vger.kernel.org>, Sakari Ailus <sakari.ailus@iki.fi>,
        <linux-arm-kernel@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Wenyou Yang <wenyou.yang@microchip.com>
Subject: [PATCH v4 2/3] media: ov7670: Add the get_fmt callback
Date: Mon, 18 Sep 2017 14:45:13 +0800
Message-ID: <20170918064514.6841-3-wenyou.yang@microchip.com>
In-Reply-To: <20170918064514.6841-1-wenyou.yang@microchip.com>
References: <20170918064514.6841-1-wenyou.yang@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the get_fmt callback, also enable V4L2_SUBDEV_FL_HAS_DEVNODE flag
to make this subdev has device node.

Signed-off-by: Wenyou Yang <wenyou.yang@microchip.com>
---

Changes in v4:
 - Fix the build error when not enabling V4L2 sub-device userspace API option.

Changes in v3:
 - Keep tried format info in the try_fmt member of
   v4l2_subdev__pad_config struct.
 - Add the internal_ops callback to set default format.

Changes in v2: None

 drivers/media/i2c/ov7670.c | 75 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 74 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index 553945d4ca28..456f48057605 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -232,6 +232,7 @@ struct ov7670_info {
 		struct v4l2_ctrl *saturation;
 		struct v4l2_ctrl *hue;
 	};
+	struct v4l2_mbus_framefmt format;
 	struct ov7670_format_struct *fmt;  /* Current format */
 	struct clk *clk;
 	struct gpio_desc *resetb_gpio;
@@ -975,6 +976,9 @@ static int ov7670_try_fmt_internal(struct v4l2_subdev *sd,
 	fmt->width = wsize->width;
 	fmt->height = wsize->height;
 	fmt->colorspace = ov7670_formats[index].colorspace;
+
+	info->format = *fmt;
+
 	return 0;
 }
 
@@ -998,8 +1002,15 @@ static int ov7670_set_fmt(struct v4l2_subdev *sd,
 		ret = ov7670_try_fmt_internal(sd, &format->format, NULL, NULL);
 		if (ret)
 			return ret;
-		cfg->try_fmt = format->format;
+#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
+		struct v4l2_mbus_framefmt *mbus_fmt;
+
+		mbus_fmt = v4l2_subdev_get_try_format(sd, cfg, format->pad);
+		*mbus_fmt = format->format;
 		return 0;
+#else
+		return -ENOTTY;
+#endif
 	}
 
 	ret = ov7670_try_fmt_internal(sd, &format->format, &ovfmt, &wsize);
@@ -1041,6 +1052,29 @@ static int ov7670_set_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
+static int ov7670_get_fmt(struct v4l2_subdev *sd,
+			  struct v4l2_subdev_pad_config *cfg,
+			  struct v4l2_subdev_format *format)
+{
+	struct ov7670_info *info = to_state(sd);
+
+	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
+#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
+		struct v4l2_mbus_framefmt *mbus_fmt;
+
+		mbus_fmt = v4l2_subdev_get_try_format(sd, cfg, 0);
+		format->format = *mbus_fmt;
+		return 0;
+#else
+		return -ENOTTY;
+#endif
+	} else {
+		format->format = info->format;
+	}
+
+	return 0;
+}
+
 /*
  * Implement G/S_PARM.  There is a "high quality" mode we could try
  * to do someday; for now, we just do the frame rate tweak.
@@ -1508,6 +1542,30 @@ static int ov7670_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_regis
 }
 #endif
 
+static void ov7670_get_default_format(struct v4l2_subdev *sd,
+				      struct v4l2_mbus_framefmt *format)
+{
+	struct ov7670_info *info = to_state(sd);
+
+	format->width = info->devtype->win_sizes[0].width;
+	format->height = info->devtype->win_sizes[0].height;
+	format->colorspace = info->fmt->colorspace;
+	format->code = info->fmt->mbus_code;
+	format->field = V4L2_FIELD_NONE;
+}
+
+#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
+static int ov7670_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+	struct v4l2_mbus_framefmt *format =
+				v4l2_subdev_get_try_format(sd, fh->pad, 0);
+
+	ov7670_get_default_format(sd, format);
+
+	return 0;
+}
+#endif
+
 /* ----------------------------------------------------------------------- */
 
 static const struct v4l2_subdev_core_ops ov7670_core_ops = {
@@ -1528,6 +1586,7 @@ static const struct v4l2_subdev_pad_ops ov7670_pad_ops = {
 	.enum_frame_interval = ov7670_enum_frame_interval,
 	.enum_frame_size = ov7670_enum_frame_size,
 	.enum_mbus_code = ov7670_enum_mbus_code,
+	.get_fmt = ov7670_get_fmt,
 	.set_fmt = ov7670_set_fmt,
 };
 
@@ -1537,6 +1596,12 @@ static const struct v4l2_subdev_ops ov7670_ops = {
 	.pad = &ov7670_pad_ops,
 };
 
+#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
+static const struct v4l2_subdev_internal_ops ov7670_subdev_internal_ops = {
+	.open = ov7670_open,
+};
+#endif
+
 /* ----------------------------------------------------------------------- */
 
 static const struct ov7670_devtype ov7670_devdata[] = {
@@ -1589,6 +1654,11 @@ static int ov7670_probe(struct i2c_client *client,
 	sd = &info->sd;
 	v4l2_i2c_subdev_init(sd, client, &ov7670_ops);
 
+#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
+	sd->internal_ops = &ov7670_subdev_internal_ops;
+	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+#endif
+
 	info->clock_speed = 30; /* default: a guess */
 	if (client->dev.platform_data) {
 		struct ov7670_config *config = client->dev.platform_data;
@@ -1645,6 +1715,9 @@ static int ov7670_probe(struct i2c_client *client,
 
 	info->devtype = &ov7670_devdata[id->driver_data];
 	info->fmt = &ov7670_formats[0];
+
+	ov7670_get_default_format(sd, &info->format);
+
 	info->clkrc = 0;
 
 	/* Set default frame rate to 30 fps */
-- 
2.13.0
