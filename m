Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35328 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753418AbcISWDN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 18:03:13 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: sre@kernel.org
Subject: [PATCH v3 14/18] smiapp: Improve debug messages from frame layout reading
Date: Tue, 20 Sep 2016 01:02:47 +0300
Message-Id: <1474322571-20290-15-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1474322571-20290-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1474322571-20290-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Provide more debugging information on reading the frame layout.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index a7afcea..1337b22 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -100,12 +100,11 @@ static int smiapp_read_frame_fmt(struct smiapp_sensor *sensor)
 		u32 pixels;
 		char *which;
 		char *what;
+		u32 reg;
 
 		if (fmt_model_type == SMIAPP_FRAME_FORMAT_MODEL_TYPE_2BYTE) {
-			rval = smiapp_read(
-				sensor,
-				SMIAPP_REG_U16_FRAME_FORMAT_DESCRIPTOR_2(i),
-				&desc);
+			reg = SMIAPP_REG_U16_FRAME_FORMAT_DESCRIPTOR_2(i);
+			rval = smiapp_read(sensor, reg,	&desc);
 			if (rval)
 				return rval;
 
@@ -116,10 +115,8 @@ static int smiapp_read_frame_fmt(struct smiapp_sensor *sensor)
 			pixels = desc & SMIAPP_FRAME_FORMAT_DESC_2_PIXELS_MASK;
 		} else if (fmt_model_type
 			   == SMIAPP_FRAME_FORMAT_MODEL_TYPE_4BYTE) {
-			rval = smiapp_read(
-				sensor,
-				SMIAPP_REG_U32_FRAME_FORMAT_DESCRIPTOR_4(i),
-				&desc);
+			reg = SMIAPP_REG_U32_FRAME_FORMAT_DESCRIPTOR_4(i);
+			rval = smiapp_read(sensor, reg, &desc);
 			if (rval)
 				return rval;
 
@@ -158,12 +155,12 @@ static int smiapp_read_frame_fmt(struct smiapp_sensor *sensor)
 			break;
 		default:
 			what = "invalid";
-			dev_dbg(&client->dev, "pixelcode %d\n", pixelcode);
 			break;
 		}
 
-		dev_dbg(&client->dev, "%s pixels: %d %s\n",
-			what, pixels, which);
+		dev_dbg(&client->dev,
+			"0x%8.8x %s pixels: %d %s (pixelcode %u)\n", reg,
+			what, pixels, which, pixelcode);
 
 		if (i < ncol_desc) {
 			if (pixelcode ==
-- 
2.1.4

