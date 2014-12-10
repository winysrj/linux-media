Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40807 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933329AbaLJVQi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Dec 2014 16:16:38 -0500
Received: from lanttu.localdomain (lanttu.localdomain [192.168.5.64])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 103A76009F
	for <linux-media@vger.kernel.org>; Wed, 10 Dec 2014 23:16:35 +0200 (EET)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [REVIEW PATCH 4/7] smiapp: Separate late controls from the rest
Date: Wed, 10 Dec 2014 23:16:17 +0200
Message-Id: <1418246180-667-5-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1418246180-667-1-git-send-email-sakari.ailus@iki.fi>
References: <1418246180-667-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The default values and limits for certain controls need the knowledge of
available media bus codes or link frequencies. Create such controls later
on, so that most of the initialisation of the sensor has already been done
when the init quirk is called.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c |   54 +++++++++++++++++++++-----------
 1 file changed, 35 insertions(+), 19 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 66d94c3..e8e88bd 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -519,9 +519,6 @@ static const struct v4l2_ctrl_ops smiapp_ctrl_ops = {
 static int smiapp_init_controls(struct smiapp_sensor *sensor)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
-	unsigned long *valid_link_freqs = &sensor->valid_link_freqs[
-		sensor->csi_format->compressed - SMIAPP_COMPRESSED_BASE];
-	unsigned int max, i;
 	int rval;
 
 	rval = v4l2_ctrl_handler_init(&sensor->pixel_array->ctrl_handler, 12);
@@ -573,15 +570,6 @@ static int smiapp_init_controls(struct smiapp_sensor *sensor)
 				     ARRAY_SIZE(smiapp_test_patterns) - 1,
 				     0, 0, smiapp_test_patterns);
 
-	for (i = 0; i < ARRAY_SIZE(sensor->test_data); i++) {
-		int max_value = (1 << sensor->csi_format->width) - 1;
-		sensor->test_data[i] =
-			v4l2_ctrl_new_std(
-				&sensor->pixel_array->ctrl_handler,
-				&smiapp_ctrl_ops, V4L2_CID_TEST_PATTERN_RED + i,
-				0, max_value, 1, max_value);
-	}
-
 	if (sensor->pixel_array->ctrl_handler.error) {
 		dev_err(&client->dev,
 			"pixel array controls initialization failed (%d)\n",
@@ -600,13 +588,6 @@ static int smiapp_init_controls(struct smiapp_sensor *sensor)
 
 	sensor->src->ctrl_handler.lock = &sensor->mutex;
 
-	for (max = 0; sensor->platform_data->op_sys_clock[max + 1]; max++);
-
-	sensor->link_freq = v4l2_ctrl_new_int_menu(
-		&sensor->src->ctrl_handler, &smiapp_ctrl_ops,
-		V4L2_CID_LINK_FREQ, __fls(*valid_link_freqs),
-		__ffs(*valid_link_freqs), sensor->platform_data->op_sys_clock);
-
 	sensor->pixel_rate_csi = v4l2_ctrl_new_std(
 		&sensor->src->ctrl_handler, &smiapp_ctrl_ops,
 		V4L2_CID_PIXEL_RATE, 1, INT_MAX, 1, 1);
@@ -623,6 +604,35 @@ static int smiapp_init_controls(struct smiapp_sensor *sensor)
 	return 0;
 }
 
+/*
+ * For controls that require information on available media bus codes
+ * and linke frequencies.
+ */
+static int smiapp_init_late_controls(struct smiapp_sensor *sensor)
+{
+	unsigned long *valid_link_freqs = &sensor->valid_link_freqs[
+		sensor->csi_format->compressed - SMIAPP_COMPRESSED_BASE];
+	unsigned int max, i;
+
+	for (i = 0; i < ARRAY_SIZE(sensor->test_data); i++) {
+		int max_value = (1 << sensor->csi_format->width) - 1;
+		sensor->test_data[i] =
+			v4l2_ctrl_new_std(
+				&sensor->pixel_array->ctrl_handler,
+				&smiapp_ctrl_ops, V4L2_CID_TEST_PATTERN_RED + i,
+				0, max_value, 1, max_value);
+	}
+
+	for (max = 0; sensor->platform_data->op_sys_clock[max + 1]; max++);
+
+	sensor->link_freq = v4l2_ctrl_new_int_menu(
+		&sensor->src->ctrl_handler, &smiapp_ctrl_ops,
+		V4L2_CID_LINK_FREQ, __fls(*valid_link_freqs),
+		__ffs(*valid_link_freqs), sensor->platform_data->op_sys_clock);
+
+	return sensor->src->ctrl_handler.error;
+}
+
 static void smiapp_free_controls(struct smiapp_sensor *sensor)
 {
 	unsigned int i;
@@ -2768,6 +2778,12 @@ static int smiapp_init(struct smiapp_sensor *sensor)
 	if (rval < 0)
 		goto out_cleanup;
 
+	rval = smiapp_init_late_controls(sensor);
+	if (rval) {
+		rval = -ENODEV;
+		goto out_cleanup;
+	}
+
 	mutex_lock(&sensor->mutex);
 	rval = smiapp_update_mode(sensor);
 	mutex_unlock(&sensor->mutex);
-- 
1.7.10.4

