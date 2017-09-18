Return-path: <linux-media-owner@vger.kernel.org>
Received: from nasmtp01.atmel.com ([192.199.1.245]:28791 "EHLO
        DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751445AbdIRBbo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Sep 2017 21:31:44 -0400
From: Wenyou Yang <wenyou.yang@microchip.com>
To: Jonathan Corbet <corbet@lwn.net>
CC: Nicolas Ferre <nicolas.ferre@microchip.com>,
        <linux-kernel@vger.kernel.org>, Sakari Ailus <sakari.ailus@iki.fi>,
        <linux-arm-kernel@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Wenyou Yang <wenyou.yang@microchip.com>
Subject: [PATCH v3 2/3] media: ov7670: Add the get_fmt callback
Date: Mon, 18 Sep 2017 09:29:26 +0800
Message-ID: <20170918012928.13278-3-wenyou.yang@microchip.com>
In-Reply-To: <20170918012928.13278-1-wenyou.yang@microchip.com>
References: <20170918012928.13278-1-wenyou.yang@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the get_fmt callback, also enable V4L2_SUBDEV_FL_HAS_DEVNODE flag
to make this subdev has device node.

Signed-off-by: Wenyou Yang <wenyou.yang@microchip.com>
---

Changes in v3:
 - Keep tried format info in the try_fmt member of
   v4l2_subdev__pad_config struct.
 - Add the internal_ops callback to set default format.

Changes in v2: None

 drivers/media/i2c/ov7670.c | 58 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 57 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index 5c8460ee65c3..5d6f1859a39b 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -230,6 +230,7 @@ struct ov7670_info {
 		struct v4l2_ctrl *saturation;
 		struct v4l2_ctrl *hue;
 	};
+	struct v4l2_mbus_framefmt format;
 	struct ov7670_format_struct *fmt;  /* Current format */
 	struct clk *clk;
 	struct gpio_desc *resetb_gpio;
@@ -973,6 +974,9 @@ static int ov7670_try_fmt_internal(struct v4l2_subdev *sd,
 	fmt->width = wsize->width;
 	fmt->height = wsize->height;
 	fmt->colorspace = ov7670_formats[index].colorspace;
+
+	info->format = *fmt;
+
 	return 0;
 }
 
@@ -986,6 +990,7 @@ static int ov7670_set_fmt(struct v4l2_subdev *sd,
 	struct ov7670_format_struct *ovfmt;
 	struct ov7670_win_size *wsize;
 	struct ov7670_info *info = to_state(sd);
+	struct v4l2_mbus_framefmt *mbus_fmt;
 	unsigned char com7;
 	int ret;
 
@@ -996,7 +1001,8 @@ static int ov7670_set_fmt(struct v4l2_subdev *sd,
 		ret = ov7670_try_fmt_internal(sd, &format->format, NULL, NULL);
 		if (ret)
 			return ret;
-		cfg->try_fmt = format->format;
+		mbus_fmt = v4l2_subdev_get_try_format(sd, cfg, format->pad);
+		*mbus_fmt = format->format;
 		return 0;
 	}
 
@@ -1039,6 +1045,23 @@ static int ov7670_set_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
+static int ov7670_get_fmt(struct v4l2_subdev *sd,
+			  struct v4l2_subdev_pad_config *cfg,
+			  struct v4l2_subdev_format *format)
+{
+	struct ov7670_info *info = to_state(sd);
+	struct v4l2_mbus_framefmt *mbus_fmt;
+
+	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
+		mbus_fmt = v4l2_subdev_get_try_format(sd, cfg, 0);
+		format->format = *mbus_fmt;
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
@@ -1506,6 +1529,28 @@ static int ov7670_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_regis
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
+static int ov7670_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+	struct v4l2_mbus_framefmt *format =
+				v4l2_subdev_get_try_format(sd, fh->pad, 0);
+
+	ov7670_get_default_format(sd, format);
+
+	return 0;
+}
+
 /* ----------------------------------------------------------------------- */
 
 static const struct v4l2_subdev_core_ops ov7670_core_ops = {
@@ -1526,6 +1571,7 @@ static const struct v4l2_subdev_pad_ops ov7670_pad_ops = {
 	.enum_frame_interval = ov7670_enum_frame_interval,
 	.enum_frame_size = ov7670_enum_frame_size,
 	.enum_mbus_code = ov7670_enum_mbus_code,
+	.get_fmt = ov7670_get_fmt,
 	.set_fmt = ov7670_set_fmt,
 };
 
@@ -1535,6 +1581,10 @@ static const struct v4l2_subdev_ops ov7670_ops = {
 	.pad = &ov7670_pad_ops,
 };
 
+static const struct v4l2_subdev_internal_ops ov7670_subdev_internal_ops = {
+	.open = ov7670_open,
+};
+
 /* ----------------------------------------------------------------------- */
 
 static const struct ov7670_devtype ov7670_devdata[] = {
@@ -1587,6 +1637,9 @@ static int ov7670_probe(struct i2c_client *client,
 	sd = &info->sd;
 	v4l2_i2c_subdev_init(sd, client, &ov7670_ops);
 
+	sd->internal_ops = &ov7670_subdev_internal_ops;
+	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+
 	info->clock_speed = 30; /* default: a guess */
 	if (client->dev.platform_data) {
 		struct ov7670_config *config = client->dev.platform_data;
@@ -1643,6 +1696,9 @@ static int ov7670_probe(struct i2c_client *client,
 
 	info->devtype = &ov7670_devdata[id->driver_data];
 	info->fmt = &ov7670_formats[0];
+
+	ov7670_get_default_format(sd, &info->format);
+
 	info->clkrc = 0;
 
 	/* Set default frame rate to 30 fps */
-- 
2.13.0
