Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:23186 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756245AbaE2PRO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 May 2014 11:17:14 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: [PATCH v3.1 3/3] smiapp: Implement the test pattern control
Date: Thu, 29 May 2014 18:16:54 +0300
Message-Id: <1401376614-7525-1-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1401374448-30411-4-git-send-email-sakari.ailus@linux.intel.com>
References: <1401374448-30411-4-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for the V4L2_CID_TEST_PATTERN control. When the solid colour
mode is selected, additional controls become available for setting the
solid four solid colour components.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
since v3:
- Remove redundant definition of smiapp_ctrl_ops.

- Initialise min, max and default in control creation time.

 drivers/media/i2c/smiapp/smiapp-core.c | 75 ++++++++++++++++++++++++++++++++--
 drivers/media/i2c/smiapp/smiapp.h      |  4 ++
 2 files changed, 75 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 446c82c..4ac7780 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -404,6 +404,14 @@ static void smiapp_update_mbus_formats(struct smiapp_sensor *sensor)
 		pixel_order_str[pixel_order]);
 }
 
+static const char * const smiapp_test_patterns[] = {
+	"Disabled",
+	"Solid Colour",
+	"Eight Vertical Colour Bars",
+	"Colour Bars With Fade to Grey",
+	"Pseudorandom Sequence (PN9)",
+};
+
 static int smiapp_set_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct smiapp_sensor *sensor =
@@ -477,6 +485,35 @@ static int smiapp_set_ctrl(struct v4l2_ctrl *ctrl)
 
 		return smiapp_pll_update(sensor);
 
+	case V4L2_CID_TEST_PATTERN: {
+		unsigned int i;
+
+		for (i = 0; i < ARRAY_SIZE(sensor->test_data); i++)
+			v4l2_ctrl_activate(
+				sensor->test_data[i],
+				ctrl->val ==
+				V4L2_SMIAPP_TEST_PATTERN_MODE_SOLID_COLOUR);
+
+		return smiapp_write(
+			sensor, SMIAPP_REG_U16_TEST_PATTERN_MODE, ctrl->val);
+	}
+
+	case V4L2_CID_TEST_PATTERN_RED:
+		return smiapp_write(
+			sensor, SMIAPP_REG_U16_TEST_DATA_RED, ctrl->val);
+
+	case V4L2_CID_TEST_PATTERN_GREENR:
+		return smiapp_write(
+			sensor, SMIAPP_REG_U16_TEST_DATA_GREENR, ctrl->val);
+
+	case V4L2_CID_TEST_PATTERN_BLUE:
+		return smiapp_write(
+			sensor, SMIAPP_REG_U16_TEST_DATA_BLUE, ctrl->val);
+
+	case V4L2_CID_TEST_PATTERN_GREENB:
+		return smiapp_write(
+			sensor, SMIAPP_REG_U16_TEST_DATA_GREENB, ctrl->val);
+
 	default:
 		return -EINVAL;
 	}
@@ -489,10 +526,10 @@ static const struct v4l2_ctrl_ops smiapp_ctrl_ops = {
 static int smiapp_init_controls(struct smiapp_sensor *sensor)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
-	unsigned int max;
+	unsigned int max, i;
 	int rval;
 
-	rval = v4l2_ctrl_handler_init(&sensor->pixel_array->ctrl_handler, 7);
+	rval = v4l2_ctrl_handler_init(&sensor->pixel_array->ctrl_handler, 12);
 	if (rval)
 		return rval;
 	sensor->pixel_array->ctrl_handler.lock = &sensor->mutex;
@@ -535,6 +572,19 @@ static int smiapp_init_controls(struct smiapp_sensor *sensor)
 		&sensor->pixel_array->ctrl_handler, &smiapp_ctrl_ops,
 		V4L2_CID_PIXEL_RATE, 0, 0, 1, 0);
 
+	v4l2_ctrl_new_std_menu_items(&sensor->pixel_array->ctrl_handler,
+				     &smiapp_ctrl_ops, V4L2_CID_TEST_PATTERN,
+				     ARRAY_SIZE(smiapp_test_patterns) - 1,
+				     0, 0, smiapp_test_patterns);
+
+	for (i = 0; i < ARRAY_SIZE(sensor->test_data); i++)
+		sensor->test_data[i] =
+			v4l2_ctrl_new_std(
+				&sensor->pixel_array->ctrl_handler,
+				&smiapp_ctrl_ops, V4L2_CID_TEST_PATTERN_RED + i,
+				0, (1 << sensor->csi_format->width) - 1, 1,
+				(1 << sensor->csi_format->width) - 1);
+
 	if (sensor->pixel_array->ctrl_handler.error) {
 		dev_err(&client->dev,
 			"pixel array controls initialization failed (%d)\n",
@@ -1670,17 +1720,34 @@ static int smiapp_set_format(struct v4l2_subdev *subdev,
 	if (fmt->pad == ssd->source_pad) {
 		u32 code = fmt->format.code;
 		int rval = __smiapp_get_format(subdev, fh, fmt);
+		bool range_changed = false;
+		unsigned int i;
 
 		if (!rval && subdev == &sensor->src->sd) {
 			const struct smiapp_csi_data_format *csi_format =
 				smiapp_validate_csi_data_format(sensor, code);
-			if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE)
+
+			if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
+				if (csi_format->width !=
+				    sensor->csi_format->width)
+					range_changed = true;
+
 				sensor->csi_format = csi_format;
+			}
+
 			fmt->format.code = csi_format->code;
 		}
 
 		mutex_unlock(&sensor->mutex);
-		return rval;
+		if (rval || !range_changed)
+			return rval;
+
+		for (i = 0; i < ARRAY_SIZE(sensor->test_data); i++)
+			v4l2_ctrl_modify_range(
+				sensor->test_data[i],
+				0, (1 << sensor->csi_format->width) - 1, 1, 0);
+
+		return 0;
 	}
 
 	/* Sink pad. Width and height are changeable here. */
diff --git a/drivers/media/i2c/smiapp/smiapp.h b/drivers/media/i2c/smiapp/smiapp.h
index 7cc5aae..874b49f 100644
--- a/drivers/media/i2c/smiapp/smiapp.h
+++ b/drivers/media/i2c/smiapp/smiapp.h
@@ -54,6 +54,8 @@
 	(1000 +	(SMIAPP_RESET_DELAY_CLOCKS * 1000	\
 		 + (clk) / 1000 - 1) / ((clk) / 1000))
 
+#define SMIAPP_COLOUR_COMPONENTS	4
+
 #include "smiapp-limits.h"
 
 struct smiapp_quirk;
@@ -241,6 +243,8 @@ struct smiapp_sensor {
 	/* src controls */
 	struct v4l2_ctrl *link_freq;
 	struct v4l2_ctrl *pixel_rate_csi;
+	/* test pattern colour components */
+	struct v4l2_ctrl *test_data[SMIAPP_COLOUR_COMPONENTS];
 };
 
 #define to_smiapp_subdev(_sd)				\
-- 
1.8.3.2

