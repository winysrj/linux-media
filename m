Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:42987 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753722AbeF1QV2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Jun 2018 12:21:28 -0400
From: Marco Felsch <m.felsch@pengutronix.de>
To: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com
Cc: p.zabel@pengutronix.de, afshin.nasser@gmail.com,
        javierm@redhat.com, sakari.ailus@linux.intel.com,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH 08/22] [media] tvp5150: trigger autodetection on subdev open to reset cropping
Date: Thu, 28 Jun 2018 18:20:40 +0200
Message-Id: <20180628162054.25613-9-m.felsch@pengutronix.de>
In-Reply-To: <20180628162054.25613-1-m.felsch@pengutronix.de>
References: <20180628162054.25613-1-m.felsch@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Philipp Zabel <p.zabel@pengutronix.de>

If cropping isn't set explicitly by userspace, reset it to the maximum
possible rectangle in subdevice open if a standard change is detected.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
[m.felsch@pengutronix.de: move code from internal_ops.open() to pad_ops.init_cfg()]
[m.felsch@pengutronix.de: make use of tvp5150_set_default() helper]
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
---
 drivers/media/i2c/tvp5150.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index c73536cfcc62..dbfc56c87434 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -55,6 +55,7 @@ struct tvp5150 {
 	struct regmap *regmap;
 
 	v4l2_std_id norm;	/* Current set standard */
+	v4l2_std_id detected_norm;
 	u32 input;
 	u32 output;
 	int enable;
@@ -1034,6 +1035,27 @@ static int tvp5150_g_mbus_config(struct v4l2_subdev *sd,
 /****************************************************************************
 			V4L2 subdev pad ops
  ****************************************************************************/
+static int tvp5150_init_cfg(struct v4l2_subdev *sd,
+			    struct v4l2_subdev_pad_config *cfg)
+{
+	struct tvp5150 *decoder = to_tvp5150(sd);
+	v4l2_std_id std;
+
+	/*
+	 * Reset selection to maximum on subdev_open() if autodetection is on
+	 * and a standard change is detected.
+	 */
+	if (decoder->norm == V4L2_STD_ALL) {
+		std = tvp5150_read_std(sd);
+		if (std != decoder->detected_norm) {
+			decoder->detected_norm = std;
+			tvp5150_set_default(std, &decoder->rect);
+		}
+	}
+
+	return 0;
+}
+
 static int tvp5150_enum_mbus_code(struct v4l2_subdev *sd,
 		struct v4l2_subdev_pad_config *cfg,
 		struct v4l2_subdev_mbus_code_enum *code)
@@ -1308,6 +1330,7 @@ static const struct v4l2_subdev_vbi_ops tvp5150_vbi_ops = {
 };
 
 static const struct v4l2_subdev_pad_ops tvp5150_pad_ops = {
+	.init_cfg = tvp5150_init_cfg,
 	.enum_mbus_code = tvp5150_enum_mbus_code,
 	.enum_frame_size = tvp5150_enum_frame_size,
 	.set_fmt = tvp5150_fill_fmt,
@@ -1640,6 +1663,7 @@ static int tvp5150_probe(struct i2c_client *c,
 		return res;
 
 	core->norm = V4L2_STD_ALL;	/* Default is autodetect */
+	core->detected_norm = V4L2_STD_UNKNOWN;
 	core->input = TVP5150_COMPOSITE1;
 	core->enable = true;
 
-- 
2.17.1
