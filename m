Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45057 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030454Ab2CFMJc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Mar 2012 07:09:32 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Martin Hostettler <martin@neutronstar.dyndns.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 4/5] mt9p031: Use generic PLL setup code
Date: Tue,  6 Mar 2012 13:09:45 +0100
Message-Id: <1331035786-8938-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1331035786-8938-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1331035786-8938-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Compute the PLL parameters at runtime using the generic Aptina PLL
helper.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/Kconfig   |    1 +
 drivers/media/video/mt9p031.c |   62 ++++++++++++++++++-----------------------
 2 files changed, 28 insertions(+), 35 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 7867b0b..666836d 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -473,6 +473,7 @@ config VIDEO_OV7670
 config VIDEO_MT9P031
 	tristate "Aptina MT9P031 support"
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
+	select VIDEO_APTINA_PLL
 	---help---
 	  This is a Video4Linux2 sensor-level driver for the Aptina
 	  (Micron) mt9p031 5 Mpixel camera.
diff --git a/drivers/media/video/mt9p031.c b/drivers/media/video/mt9p031.c
index 52dd9f8..3bcd14b 100644
--- a/drivers/media/video/mt9p031.c
+++ b/drivers/media/video/mt9p031.c
@@ -27,6 +27,8 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-subdev.h>
 
+#include "aptina-pll.h"
+
 #define MT9P031_PIXEL_ARRAY_WIDTH			2752
 #define MT9P031_PIXEL_ARRAY_HEIGHT			2004
 
@@ -97,14 +99,6 @@
 #define MT9P031_TEST_PATTERN_RED			0xa2
 #define MT9P031_TEST_PATTERN_BLUE			0xa3
 
-struct mt9p031_pll_divs {
-	u32 ext_freq;
-	u32 target_freq;
-	u8 m;
-	u8 n;
-	u8 p1;
-};
-
 struct mt9p031 {
 	struct v4l2_subdev subdev;
 	struct media_pad pad;
@@ -115,7 +109,7 @@ struct mt9p031 {
 	struct mutex power_lock; /* lock to protect power_count */
 	int power_count;
 
-	const struct mt9p031_pll_divs *pll;
+	struct aptina_pll pll;
 
 	/* Registers cache */
 	u16 output_control;
@@ -183,33 +177,31 @@ static int mt9p031_reset(struct mt9p031 *mt9p031)
 					  0);
 }
 
-/*
- * This static table uses ext_freq and vdd_io values to select suitable
- * PLL dividers m, n and p1 which have been calculated as specifiec in p36
- * of Aptina's mt9p031 datasheet. New values should be added here.
- */
-static const struct mt9p031_pll_divs mt9p031_divs[] = {
-	/* ext_freq	target_freq	m	n	p1 */
-	{21000000,	48000000,	26,	2,	6}
-};
-
-static int mt9p031_pll_get_divs(struct mt9p031 *mt9p031)
+static int mt9p031_pll_setup(struct mt9p031 *mt9p031)
 {
+	static const struct aptina_pll_limits limits = {
+		.ext_clock_min = 6000000,
+		.ext_clock_max = 27000000,
+		.int_clock_min = 2000000,
+		.int_clock_max = 13500000,
+		.out_clock_min = 180000000,
+		.out_clock_max = 360000000,
+		.pix_clock_max = 96000000,
+		.n_min = 1,
+		.n_max = 64,
+		.m_min = 16,
+		.m_max = 255,
+		.p1_min = 1,
+		.p1_max = 128,
+	};
+
 	struct i2c_client *client = v4l2_get_subdevdata(&mt9p031->subdev);
-	int i;
+	struct mt9p031_platform_data *pdata = mt9p031->pdata;
 
-	for (i = 0; i < ARRAY_SIZE(mt9p031_divs); i++) {
-		if (mt9p031_divs[i].ext_freq == mt9p031->pdata->ext_freq &&
-		  mt9p031_divs[i].target_freq == mt9p031->pdata->target_freq) {
-			mt9p031->pll = &mt9p031_divs[i];
-			return 0;
-		}
-	}
+	mt9p031->pll.ext_clock = pdata->ext_freq;
+	mt9p031->pll.pix_clock = pdata->target_freq;
 
-	dev_err(&client->dev, "Couldn't find PLL dividers for ext_freq = %d, "
-		"target_freq = %d\n", mt9p031->pdata->ext_freq,
-		mt9p031->pdata->target_freq);
-	return -EINVAL;
+	return aptina_pll_calculate(&client->dev, &limits, &mt9p031->pll);
 }
 
 static int mt9p031_pll_enable(struct mt9p031 *mt9p031)
@@ -223,11 +215,11 @@ static int mt9p031_pll_enable(struct mt9p031 *mt9p031)
 		return ret;
 
 	ret = mt9p031_write(client, MT9P031_PLL_CONFIG_1,
-			    (mt9p031->pll->m << 8) | (mt9p031->pll->n - 1));
+			    (mt9p031->pll.m << 8) | (mt9p031->pll.n - 1));
 	if (ret < 0)
 		return ret;
 
-	ret = mt9p031_write(client, MT9P031_PLL_CONFIG_2, mt9p031->pll->p1 - 1);
+	ret = mt9p031_write(client, MT9P031_PLL_CONFIG_2, mt9p031->pll.p1 - 1);
 	if (ret < 0)
 		return ret;
 
@@ -900,7 +892,7 @@ static int mt9p031_probe(struct i2c_client *client,
 	mt9p031->format.field = V4L2_FIELD_NONE;
 	mt9p031->format.colorspace = V4L2_COLORSPACE_SRGB;
 
-	ret = mt9p031_pll_get_divs(mt9p031);
+	ret = mt9p031_pll_setup(mt9p031);
 
 done:
 	if (ret < 0) {
-- 
1.7.3.4

