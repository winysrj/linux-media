Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50543 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751554AbaJBIqo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Oct 2014 04:46:44 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH v2 17/18] smiapp: Set valid link frequency range
Date: Thu,  2 Oct 2014 11:46:07 +0300
Message-Id: <1412239568-8524-18-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1412239568-8524-1-git-send-email-sakari.ailus@iki.fi>
References: <1412239568-8524-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Set supported link frequencies in the menu in control initialisation and
when the bpp changes.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index cf8eba8..87d4d5a 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -523,6 +523,8 @@ static const struct v4l2_ctrl_ops smiapp_ctrl_ops = {
 static int smiapp_init_controls(struct smiapp_sensor *sensor)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
+	unsigned long *valid_link_freqs = &sensor->valid_link_freqs[
+		sensor->csi_format->compressed - SMIAPP_COMPRESSED_BASE];
 	unsigned int max, i;
 	int rval;
 
@@ -605,8 +607,8 @@ static int smiapp_init_controls(struct smiapp_sensor *sensor)
 
 	sensor->link_freq = v4l2_ctrl_new_int_menu(
 		&sensor->src->ctrl_handler, &smiapp_ctrl_ops,
-		V4L2_CID_LINK_FREQ, max, 0,
-		sensor->platform_data->op_sys_clock);
+		V4L2_CID_LINK_FREQ, __fls(*valid_link_freqs),
+		__ffs(*valid_link_freqs), sensor->platform_data->op_sys_clock);
 
 	sensor->pixel_rate_csi = v4l2_ctrl_new_std(
 		&sensor->src->ctrl_handler, &smiapp_ctrl_ops,
@@ -1735,6 +1737,7 @@ static int smiapp_set_format_source(struct v4l2_subdev *subdev,
 	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
 	const struct smiapp_csi_data_format *csi_format,
 		*old_csi_format = sensor->csi_format;
+	unsigned long *valid_link_freqs;
 	u32 code = fmt->format.code;
 	unsigned int i;
 	int rval;
@@ -1761,6 +1764,18 @@ static int smiapp_set_format_source(struct v4l2_subdev *subdev,
 				sensor->test_data[i], 0,
 				(1 << csi_format->width) - 1, 1, 0);
 
+	if (csi_format->compressed == old_csi_format->compressed)
+		return 0;
+
+	valid_link_freqs = 
+		&sensor->valid_link_freqs[sensor->csi_format->compressed
+					  - SMIAPP_COMPRESSED_BASE];
+
+	__v4l2_ctrl_modify_range(
+		sensor->link_freq, 0,
+		__fls(*valid_link_freqs), ~*valid_link_freqs,
+		__ffs(*valid_link_freqs));
+
 	return 0;
 }
 
-- 
1.7.10.4

