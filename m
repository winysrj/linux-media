Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35326 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753412AbcISWDN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 18:03:13 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: sre@kernel.org
Subject: [PATCH v3 13/18] smiapp: Obtain frame layout from the frame descriptor
Date: Tue, 20 Sep 2016 01:02:46 +0300
Message-Id: <1474322571-20290-14-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1474322571-20290-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1474322571-20290-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Besides the image data, SMIA++ compliant sensors also provide embedded
data in form of registers used to capture the image. Store this
information for later use in frame descriptor and routing.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 46 +++++++++++++++++++---------------
 drivers/media/i2c/smiapp/smiapp.h      |  5 +++-
 2 files changed, 30 insertions(+), 21 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 7ac0d4e0..a7afcea 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -68,10 +68,9 @@ static int smiapp_read_frame_fmt(struct smiapp_sensor *sensor)
 	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
 	u32 fmt_model_type, fmt_model_subtype, ncol_desc, nrow_desc;
 	unsigned int i;
-	int rval;
+	int pixel_count = 0;
 	int line_count = 0;
-	int embedded_start = -1, embedded_end = -1;
-	int image_start = 0;
+	int rval;
 
 	rval = smiapp_read(sensor, SMIAPP_REG_U8_FRAME_FORMAT_MODEL_TYPE,
 			   &fmt_model_type);
@@ -166,33 +165,40 @@ static int smiapp_read_frame_fmt(struct smiapp_sensor *sensor)
 		dev_dbg(&client->dev, "%s pixels: %d %s\n",
 			what, pixels, which);
 
-		if (i < ncol_desc)
+		if (i < ncol_desc) {
+			if (pixelcode ==
+			    SMIAPP_FRAME_FORMAT_DESC_PIXELCODE_VISIBLE)
+				sensor->visible_pixel_start = pixel_count;
+			pixel_count += pixels;
 			continue;
+		}
 
 		/* Handle row descriptors */
-		if (pixelcode
-		    == SMIAPP_FRAME_FORMAT_DESC_PIXELCODE_EMBEDDED) {
-			embedded_start = line_count;
-		} else {
-			if (pixelcode == SMIAPP_FRAME_FORMAT_DESC_PIXELCODE_VISIBLE
-			    || pixels >= sensor->limits[SMIAPP_LIMIT_MIN_FRAME_LENGTH_LINES] / 2)
-				image_start = line_count;
-			if (embedded_start != -1 && embedded_end == -1)
-				embedded_end = line_count;
+		switch (pixelcode) {
+		case SMIAPP_FRAME_FORMAT_DESC_PIXELCODE_EMBEDDED:
+			if (sensor->embedded_end)
+				break;
+			sensor->embedded_start = line_count;
+			sensor->embedded_end = line_count + pixels;
+			break;
+		case SMIAPP_FRAME_FORMAT_DESC_PIXELCODE_VISIBLE:
+			sensor->image_start = line_count;
+			break;
 		}
 		line_count += pixels;
 	}
 
-	if (embedded_start == -1 || embedded_end == -1) {
-		embedded_start = 0;
-		embedded_end = 0;
+	if (sensor->embedded_end > sensor->image_start) {
+		dev_dbg(&client->dev,
+			"adjusting image start line to %u (was %u)\n",
+			sensor->embedded_end, sensor->image_start);
+		sensor->image_start = sensor->embedded_end;
 	}
 
-	sensor->image_start = image_start;
-
 	dev_dbg(&client->dev, "embedded data from lines %d to %d\n",
-		embedded_start, embedded_end);
-	dev_dbg(&client->dev, "image data starts at line %d\n", image_start);
+		sensor->embedded_start, sensor->embedded_end);
+	dev_dbg(&client->dev, "image data starts at line %d\n",
+		sensor->image_start);
 
 	return 0;
 }
diff --git a/drivers/media/i2c/smiapp/smiapp.h b/drivers/media/i2c/smiapp/smiapp.h
index f9febe0..d7b52a6 100644
--- a/drivers/media/i2c/smiapp/smiapp.h
+++ b/drivers/media/i2c/smiapp/smiapp.h
@@ -213,7 +213,10 @@ struct smiapp_sensor {
 
 	u8 hvflip_inv_mask; /* H/VFLIP inversion due to sensor orientation */
 	u8 frame_skip;
-	u16 image_start;	/* Offset to first line after metadata lines */
+	u16 embedded_start; /* embedded data start line */
+	u16 embedded_end;
+	u16 image_start; /* image data start line */
+	u16 visible_pixel_start; /* start pixel of the visible image */
 
 	int power_count;
 
-- 
2.1.4

