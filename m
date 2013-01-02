Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33122 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674Ab3ABLNi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jan 2013 06:13:38 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Martin Hostettler <martin@neutronstar.dyndns.org>
Subject: [PATCH 1/2] mt9m032: Fix PLL setup
Date: Wed,  2 Jan 2013 12:15:03 +0100
Message-Id: <1357125304-6128-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The MT9M032 PLL was assumed to be identical to the MT9P031 PLL but
differs significantly. Update the registers definitions and PLL limits
according to the datasheet.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/mt9m032.c |   24 +++++++++++++-----------
 1 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/media/i2c/mt9m032.c b/drivers/media/i2c/mt9m032.c
index f80c1d7e..30d755a 100644
--- a/drivers/media/i2c/mt9m032.c
+++ b/drivers/media/i2c/mt9m032.c
@@ -87,7 +87,7 @@
 #define MT9M032_RESTART					0x0b
 #define MT9M032_RESET					0x0d
 #define MT9M032_PLL_CONFIG1				0x11
-#define		MT9M032_PLL_CONFIG1_OUTDIV_MASK		0x3f
+#define		MT9M032_PLL_CONFIG1_PREDIV_MASK		0x3f
 #define		MT9M032_PLL_CONFIG1_MUL_SHIFT		8
 #define MT9M032_READ_MODE1				0x1e
 #define MT9M032_READ_MODE2				0x20
@@ -106,6 +106,8 @@
 #define		MT9M032_GAIN_AMUL_SHIFT			6
 #define		MT9M032_GAIN_ANALOG_MASK		0x3f
 #define MT9M032_FORMATTER1				0x9e
+#define		MT9M032_FORMATTER1_PLL_P1_6		(1 << 8)
+#define		MT9M032_FORMATTER1_PARALLEL		(1 << 12)
 #define MT9M032_FORMATTER2				0x9f
 #define		MT9M032_FORMATTER2_DOUT_EN		0x1000
 #define		MT9M032_FORMATTER2_PIXCLK_EN		0x2000
@@ -121,8 +123,6 @@
 #define		MT9P031_PLL_CONTROL_PWROFF		0x0050
 #define		MT9P031_PLL_CONTROL_PWRON		0x0051
 #define		MT9P031_PLL_CONTROL_USEPLL		0x0052
-#define MT9P031_PLL_CONFIG2				0x11
-#define		MT9P031_PLL_CONFIG2_P1_DIV_MASK		0x1f
 
 struct mt9m032 {
 	struct v4l2_subdev subdev;
@@ -255,13 +255,14 @@ static int mt9m032_setup_pll(struct mt9m032 *sensor)
 		.n_max = 64,
 		.m_min = 16,
 		.m_max = 255,
-		.p1_min = 1,
-		.p1_max = 128,
+		.p1_min = 6,
+		.p1_max = 7,
 	};
 
 	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
 	struct mt9m032_platform_data *pdata = sensor->pdata;
 	struct aptina_pll pll;
+	u16 reg_val;
 	int ret;
 
 	pll.ext_clock = pdata->ext_clock;
@@ -274,18 +275,19 @@ static int mt9m032_setup_pll(struct mt9m032 *sensor)
 	sensor->pix_clock = pdata->pix_clock;
 
 	ret = mt9m032_write(client, MT9M032_PLL_CONFIG1,
-			    (pll.m << MT9M032_PLL_CONFIG1_MUL_SHIFT)
-			    | (pll.p1 - 1));
-	if (!ret)
-		ret = mt9m032_write(client, MT9P031_PLL_CONFIG2, pll.n - 1);
+			    (pll.m << MT9M032_PLL_CONFIG1_MUL_SHIFT) |
+			    ((pll.n - 1) & MT9M032_PLL_CONFIG1_PREDIV_MASK));
 	if (!ret)
 		ret = mt9m032_write(client, MT9P031_PLL_CONTROL,
 				    MT9P031_PLL_CONTROL_PWRON |
 				    MT9P031_PLL_CONTROL_USEPLL);
 	if (!ret)		/* more reserved, Continuous, Master Mode */
 		ret = mt9m032_write(client, MT9M032_READ_MODE1, 0x8006);
-	if (!ret)		/* Set 14-bit mode, select 7 divider */
-		ret = mt9m032_write(client, MT9M032_FORMATTER1, 0x111e);
+	if (!ret) {
+		reg_val = (pll.p1 == 6 ? MT9M032_FORMATTER1_PLL_P1_6 : 0)
+			| MT9M032_FORMATTER1_PARALLEL | 0x001e; /* 14-bit */
+		ret = mt9m032_write(client, MT9M032_FORMATTER1, reg_val);
+	}
 
 	return ret;
 }
-- 
1.7.8.6

