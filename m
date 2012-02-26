Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58445 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab2BZD1g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Feb 2012 22:27:36 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Martin Hostettler <martin@neutronstar.dyndns.org>
Subject: [PATCH 11/11] mt9m032: Use generic PLL setup code
Date: Sun, 26 Feb 2012 04:27:37 +0100
Message-Id: <1330226857-8651-12-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1330226857-8651-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1330226857-8651-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Compute the PLL parameters at runtime using the generic Aptina PLL
helper.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/mt9m032.c |   57 ++++++++++++++++++++++++++++-------------
 include/media/mt9m032.h       |    2 +-
 2 files changed, 40 insertions(+), 19 deletions(-)

diff --git a/drivers/media/video/mt9m032.c b/drivers/media/video/mt9m032.c
index 8109bf1..5fb891a 100644
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
@@ -218,27 +223,43 @@ static int update_formatter2(struct mt9m032 *sensor, bool streaming)
 static int mt9m032_setup_pll(struct mt9m032 *sensor)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
-	struct mt9m032_platform_data* pdata = sensor->pdata;
-	u16 reg_pll1;
-	unsigned int pre_div;
-	unsigned int pll_out_div;
-	unsigned int pll_mul;
+	struct mt9m032_platform_data *pdata = sensor->pdata;
+	struct aptina_pll_limits limits;
+	struct aptina_pll pll;
 	int ret;
 
-	pre_div = 6;
-
-	sensor->pix_clock = pdata->ext_clock * pll_mul /
-		(pre_div * pll_out_div);
+	limits.ext_clock_min = 8000000;
+	limits.ext_clock_max = 16500000;
+	limits.int_clock_min = 2000000;
+	limits.int_clock_max = 24000000;
+	limits.out_clock_min = 322000000;
+	limits.out_clock_max = 693000000;
+	limits.pix_clock_max = 99000000;
+	limits.n_min = 1;
+	limits.n_max = 64;
+	limits.m_min = 16;
+	limits.m_max = 255;
+	limits.p1_min = 1;
+	limits.p1_max = 128;
+
+	pll.ext_clock = pdata->ext_clock;
+	pll.pix_clock = pdata->pix_clock;
+
+	ret = aptina_pll_configure(&client->dev, &pll, &limits);
+	if (ret < 0)
+		return ret;
 
-	reg_pll1 = ((pll_out_div - 1) & MT9M032_PLL_CONFIG1_OUTDIV_MASK)
-		 | (pll_mul << MT9M032_PLL_CONFIG1_MUL_SHIFT);
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
index 4e84840..804e0a5 100644
--- a/include/media/mt9m032.h
+++ b/include/media/mt9m032.h
@@ -29,7 +29,7 @@
 
 struct mt9m032_platform_data {
 	u32 ext_clock;
-	u32 int_clock;
+	u32 pix_clock;
 	int invert_pixclock;
 
 };
-- 
1.7.3.4

