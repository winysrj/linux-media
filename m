Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33412 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839Ab2CCP2F (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Mar 2012 10:28:05 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Martin Hostettler <martin@neutronstar.dyndns.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v3 10/10] mt9m032: Use generic PLL setup code
Date: Sat,  3 Mar 2012 16:28:15 +0100
Message-Id: <1330788495-18762-11-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1330788495-18762-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1330788495-18762-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Compute the PLL parameters at runtime using the generic Aptina PLL
helper.

Remove the PLL parameters from platform data and pass the external clock
and desired internal clock frequencies instead.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/Kconfig   |    1 +
 drivers/media/video/mt9m032.c |   56 +++++++++++++++++++++++++++--------------
 include/media/mt9m032.h       |    4 +--
 3 files changed, 39 insertions(+), 22 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 410baf2..2b3f4b1 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -949,6 +949,7 @@ config SOC_CAMERA_MT9M001
 config VIDEO_MT9M032
 	tristate "MT9M032 camera sensor support"
 	depends on I2C && VIDEO_V4L2
+	select VIDEO_APTINA_PLL
 	help
 	  This driver supports MT9M032 cameras from Micron, monochrome
 	  models only.
diff --git a/drivers/media/video/mt9m032.c b/drivers/media/video/mt9m032.c
index 4cde779..da69e12 100644
--- a/drivers/media/video/mt9m032.c
+++ b/drivers/media/video/mt9m032.c
@@ -35,6 +35,8 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-subdev.h>
 
+#include "aptina-pll.h"
+
 #define MT9M032_CHIP_VERSION			0x00
 #define     MT9M032_CHIP_VERSION_VALUE		0x1402
 #define MT9M032_ROW_START			0x01
@@ -61,6 +63,7 @@
 #define MT9M032_GAIN_BLUE			0x2c
 #define MT9M032_GAIN_RED			0x2d
 #define MT9M032_GAIN_GREEN2			0x2e
+
 /* write only */
 #define MT9M032_GAIN_ALL			0x35
 #define     MT9M032_GAIN_DIGITAL_MASK		0x7f
@@ -83,6 +86,8 @@
 #define     MT9P031_PLL_CONTROL_PWROFF		0x0050
 #define     MT9P031_PLL_CONTROL_PWRON		0x0051
 #define     MT9P031_PLL_CONTROL_USEPLL		0x0052
+#define MT9P031_PLL_CONFIG2			0x11
+#define     MT9P031_PLL_CONFIG2_P1_DIV_MASK	0x1f
 
 /*
  * width and height include active boundry and black parts
@@ -222,32 +227,45 @@ static int update_formatter2(struct mt9m032 *sensor, bool streaming)
 
 static int mt9m032_setup_pll(struct mt9m032 *sensor)
 {
+	static const struct aptina_pll_limits limits = {
+		.ext_clock_min = 8000000,
+		.ext_clock_max = 16500000,
+		.int_clock_min = 2000000,
+		.int_clock_max = 24000000,
+		.out_clock_min = 322000000,
+		.out_clock_max = 693000000,
+		.pix_clock_max = 99000000,
+		.n_min = 1,
+		.n_max = 64,
+		.m_min = 16,
+		.m_max = 255,
+		.p1_min = 1,
+		.p1_max = 128,
+	};
+
 	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
-	struct mt9m032_platform_data* pdata = sensor->pdata;
-	u16 reg_pll1;
-	unsigned int pre_div;
+	struct mt9m032_platform_data *pdata = sensor->pdata;
+	struct aptina_pll pll;
 	int ret;
 
-	/* TODO: also support other pre-div values */
-	if (pdata->pll_pre_div != 6) {
-		dev_warn(to_dev(sensor),
-			"Unsupported PLL pre-divisor value %u, using default 6\n",
-			pdata->pll_pre_div);
-	}
-	pre_div = 6;
+	pll.ext_clock = pdata->ext_clock;
+	pll.pix_clock = pdata->pix_clock;
 
-	sensor->pix_clock = pdata->ext_clock * pdata->pll_mul /
-		(pre_div * pdata->pll_out_div);
+	ret = aptina_pll_configure(&client->dev, &pll, &limits);
+	if (ret < 0)
+		return ret;
 
-	reg_pll1 = ((pdata->pll_out_div - 1) & MT9M032_PLL_CONFIG1_OUTDIV_MASK)
-		   | pdata->pll_mul << MT9M032_PLL_CONFIG1_MUL_SHIFT;
+	sensor->pix_clock = pll.pix_clock;
 
-	ret = mt9m032_write_reg(client, MT9M032_PLL_CONFIG1, reg_pll1);
+	ret = mt9m032_write_reg(client, MT9M032_PLL_CONFIG1,
+				(pll.m << MT9M032_PLL_CONFIG1_MUL_SHIFT)
+				| (pll.p1 - 1));
 	if (!ret)
-		ret = mt9m032_write_reg(client,
-					MT9P031_PLL_CONTROL,
-					MT9P031_PLL_CONTROL_PWRON | MT9P031_PLL_CONTROL_USEPLL);
-
+		ret = mt9m032_write_reg(client, MT9P031_PLL_CONFIG2, pll.n - 1);
+	if (!ret)
+		ret = mt9m032_write_reg(client, MT9P031_PLL_CONTROL,
+					MT9P031_PLL_CONTROL_PWRON |
+					MT9P031_PLL_CONTROL_USEPLL);
 	if (!ret)
 		ret = mt9m032_write_reg(client, MT9M032_READ_MODE1, 0x8006);
 							/* more reserved, Continuous */
diff --git a/include/media/mt9m032.h b/include/media/mt9m032.h
index 94cefc5..804e0a5 100644
--- a/include/media/mt9m032.h
+++ b/include/media/mt9m032.h
@@ -29,9 +29,7 @@
 
 struct mt9m032_platform_data {
 	u32 ext_clock;
-	u32 pll_pre_div;
-	u32 pll_mul;
-	u32 pll_out_div;
+	u32 pix_clock;
 	int invert_pixclock;
 
 };
-- 
1.7.3.4

