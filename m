Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:41506 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755639AbcIFL4u (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Sep 2016 07:56:50 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [PATCH v4 8/8] smiapp: Add support for 14 and 16 bits per sample depths
Date: Tue,  6 Sep 2016 14:55:40 +0300
Message-Id: <1473162940-31486-9-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1473162940-31486-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1473162940-31486-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SMIA++ supports 14 and 16 bits per pixel formats as well. Add support to
these formats in the driver.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 8 ++++++++
 drivers/media/i2c/smiapp/smiapp.h      | 2 +-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index d8b78c6..44f8c7e 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -328,6 +328,14 @@ static void __smiapp_update_exposure_limits(struct smiapp_sensor *sensor)
  *    orders must be defined.
  */
 static const struct smiapp_csi_data_format smiapp_csi_data_formats[] = {
+	{ MEDIA_BUS_FMT_SGRBG16_1X16, 16, 16, SMIAPP_PIXEL_ORDER_GRBG, },
+	{ MEDIA_BUS_FMT_SRGGB16_1X16, 16, 16, SMIAPP_PIXEL_ORDER_RGGB, },
+	{ MEDIA_BUS_FMT_SBGGR16_1X16, 16, 16, SMIAPP_PIXEL_ORDER_BGGR, },
+	{ MEDIA_BUS_FMT_SGBRG16_1X16, 16, 16, SMIAPP_PIXEL_ORDER_GBRG, },
+	{ MEDIA_BUS_FMT_SGRBG14_1X14, 14, 14, SMIAPP_PIXEL_ORDER_GRBG, },
+	{ MEDIA_BUS_FMT_SRGGB14_1X14, 14, 14, SMIAPP_PIXEL_ORDER_RGGB, },
+	{ MEDIA_BUS_FMT_SBGGR14_1X14, 14, 14, SMIAPP_PIXEL_ORDER_BGGR, },
+	{ MEDIA_BUS_FMT_SGBRG14_1X14, 14, 14, SMIAPP_PIXEL_ORDER_GBRG, },
 	{ MEDIA_BUS_FMT_SGRBG12_1X12, 12, 12, SMIAPP_PIXEL_ORDER_GRBG, },
 	{ MEDIA_BUS_FMT_SRGGB12_1X12, 12, 12, SMIAPP_PIXEL_ORDER_RGGB, },
 	{ MEDIA_BUS_FMT_SBGGR12_1X12, 12, 12, SMIAPP_PIXEL_ORDER_BGGR, },
diff --git a/drivers/media/i2c/smiapp/smiapp.h b/drivers/media/i2c/smiapp/smiapp.h
index c504bd8..aae72bc 100644
--- a/drivers/media/i2c/smiapp/smiapp.h
+++ b/drivers/media/i2c/smiapp/smiapp.h
@@ -151,7 +151,7 @@ struct smiapp_csi_data_format {
 #define SMIAPP_PADS			2
 
 #define SMIAPP_COMPRESSED_BASE		8
-#define SMIAPP_COMPRESSED_MAX		12
+#define SMIAPP_COMPRESSED_MAX		16
 #define SMIAPP_NR_OF_COMPRESSED		(SMIAPP_COMPRESSED_MAX - \
 					 SMIAPP_COMPRESSED_BASE + 1)
 
-- 
2.7.4

