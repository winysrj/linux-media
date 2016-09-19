Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35312 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753410AbcISWDN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 18:03:13 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: sre@kernel.org
Subject: [PATCH v3 06/18] smiapp: Remove unnecessary BUG_ON()'s
Date: Tue, 20 Sep 2016 01:02:39 +0300
Message-Id: <1474322571-20290-7-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1474322571-20290-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1474322571-20290-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead, calculate how much is needed and then allocate the memory
dynamically.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 24 ++++++++++++++++++------
 drivers/media/i2c/smiapp/smiapp.h      |  8 ++------
 2 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index e5d4584..9873b3d 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -621,7 +621,7 @@ static int smiapp_init_controls(struct smiapp_sensor *sensor)
 static int smiapp_init_late_controls(struct smiapp_sensor *sensor)
 {
 	unsigned long *valid_link_freqs = &sensor->valid_link_freqs[
-		sensor->csi_format->compressed - SMIAPP_COMPRESSED_BASE];
+		sensor->csi_format->compressed - sensor->compressed_min_bpp];
 	unsigned int max, i;
 
 	for (i = 0; i < ARRAY_SIZE(sensor->test_data); i++) {
@@ -754,6 +754,7 @@ static int smiapp_get_mbus_formats(struct smiapp_sensor *sensor)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
 	struct smiapp_pll *pll = &sensor->pll;
+	u8 compressed_max_bpp = 0;
 	unsigned int type, n;
 	unsigned int i, pixel_order;
 	int rval;
@@ -826,16 +827,27 @@ static int smiapp_get_mbus_formats(struct smiapp_sensor *sensor)
 	pll->scale_m = sensor->scale_m;
 
 	for (i = 0; i < ARRAY_SIZE(smiapp_csi_data_formats); i++) {
+		sensor->compressed_min_bpp =
+			min(smiapp_csi_data_formats[i].compressed,
+			    sensor->compressed_min_bpp);
+		compressed_max_bpp =
+			max(smiapp_csi_data_formats[i].compressed,
+			    compressed_max_bpp);
+	}
+
+	sensor->valid_link_freqs = devm_kcalloc(
+		&client->dev,
+		compressed_max_bpp - sensor->compressed_min_bpp + 1,
+		sizeof(*sensor->valid_link_freqs), GFP_KERNEL);
+
+	for (i = 0; i < ARRAY_SIZE(smiapp_csi_data_formats); i++) {
 		const struct smiapp_csi_data_format *f =
 			&smiapp_csi_data_formats[i];
 		unsigned long *valid_link_freqs =
 			&sensor->valid_link_freqs[
-				f->compressed - SMIAPP_COMPRESSED_BASE];
+				f->compressed - sensor->compressed_min_bpp];
 		unsigned int j;
 
-		BUG_ON(f->compressed < SMIAPP_COMPRESSED_BASE);
-		BUG_ON(f->compressed > SMIAPP_COMPRESSED_MAX);
-
 		if (!(sensor->default_mbus_frame_fmts & 1 << i))
 			continue;
 
@@ -1769,7 +1781,7 @@ static int smiapp_set_format_source(struct v4l2_subdev *subdev,
 
 	valid_link_freqs = 
 		&sensor->valid_link_freqs[sensor->csi_format->compressed
-					  - SMIAPP_COMPRESSED_BASE];
+					  - sensor->compressed_min_bpp];
 
 	__v4l2_ctrl_modify_range(
 		sensor->link_freq, 0,
diff --git a/drivers/media/i2c/smiapp/smiapp.h b/drivers/media/i2c/smiapp/smiapp.h
index aae72bc..e71271e 100644
--- a/drivers/media/i2c/smiapp/smiapp.h
+++ b/drivers/media/i2c/smiapp/smiapp.h
@@ -150,11 +150,6 @@ struct smiapp_csi_data_format {
 #define SMIAPP_PAD_SRC			1
 #define SMIAPP_PADS			2
 
-#define SMIAPP_COMPRESSED_BASE		8
-#define SMIAPP_COMPRESSED_MAX		16
-#define SMIAPP_NR_OF_COMPRESSED		(SMIAPP_COMPRESSED_MAX - \
-					 SMIAPP_COMPRESSED_BASE + 1)
-
 struct smiapp_binning_subtype {
 	u8 horizontal:4;
 	u8 vertical:4;
@@ -224,6 +219,7 @@ struct smiapp_sensor {
 
 	bool streaming;
 	bool dev_init_done;
+	u8 compressed_min_bpp;
 
 	u8 *nvm;		/* nvm memory buffer */
 	unsigned int nvm_size;	/* bytes */
@@ -233,7 +229,7 @@ struct smiapp_sensor {
 	struct smiapp_pll pll;
 
 	/* Is a default format supported for a given BPP? */
-	unsigned long valid_link_freqs[SMIAPP_NR_OF_COMPRESSED];
+	unsigned long *valid_link_freqs;
 
 	/* Pixel array controls */
 	struct v4l2_ctrl *analog_gain;
-- 
2.1.4

