Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51774 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758708Ab0G3OyT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jul 2010 10:54:19 -0400
From: Michael Grzeschik <m.grzeschik@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: robert.jarzmik@free.fr, g.liakhovetski@gmx.de, p.wiesner@phytec.de,
	Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: [PATCH 18/20] mt9m111: make use of testpattern in debug mode
Date: Fri, 30 Jul 2010 16:53:36 +0200
Message-Id: <1280501618-23634-19-git-send-email-m.grzeschik@pengutronix.de>
In-Reply-To: <1280501618-23634-1-git-send-email-m.grzeschik@pengutronix.de>
References: <1280501618-23634-1-git-send-email-m.grzeschik@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Philipp Wiesner <p.wiesner@phytec.de>
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
 drivers/media/video/mt9m111.c |   63 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 63 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index f327177..799a735 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -87,6 +87,7 @@
  */
 #define MT9M111_OPER_MODE_CTRL		0x106
 #define MT9M111_OUTPUT_FORMAT_CTRL	0x108
+#define MT9M111_TEST_PATTERN_GEN	0x148
 #define MT9M111_REDUCER_XPAN_B		0x19f
 #define MT9M111_REDUCER_XZOOM_B		0x1a0
 #define MT9M111_REDUCER_XSIZE_B		0x1a1
@@ -110,6 +111,15 @@
 #define MT9M111_OUTFMT_FLIP_BAYER_ROW	(1 << 8)
 #define MT9M111_OUTFMT_CFA_1ST_ROW_BLUE	(1 << 1)
 #define MT9M111_OUTFMT_CFA_1ST_COL_R_B	(1 << 0)
+#define MT9M111_TST_PATT_OFF		(0 << 0)
+#define MT9M111_TST_PATT_1		(1 << 0)
+#define MT9M111_TST_PATT_2		(2 << 0)
+#define MT9M111_TST_PATT_3		(3 << 0)
+#define MT9M111_TST_PATT_4		(4 << 0)
+#define MT9M111_TST_PATT_5		(5 << 0)
+#define MT9M111_TST_PATT_6		(6 << 0)
+#define MT9M111_TST_PATT_COLORBARS	(7 << 0)
+#define MT9M111_TST_PATT_FORCE_WB_GAIN_1 (1 << 7)
 #define MT9M111_OUTFMT_PROCESSED_BAYER	(1 << 14)
 #define MT9M111_OUTFMT_BYPASS_IFP	(1 << 10)
 #define MT9M111_OUTFMT_INV_PIX_CLOCK	(1 << 9)
@@ -149,6 +159,13 @@
 #define MT9M111_DEF_HEIGHT	1024
 #define MT9M111_DEF_WIDTH	1280
 
+#ifdef DEBUG
+static int testpattern;
+module_param(testpattern, int, S_IRUGO);
+MODULE_PARM_DESC(testpattern, "Test pattern: a number from 1 to 10, 0 for "
+		"normal usage");
+#endif
+
 static int soft_crop;
 module_param(soft_crop, int, S_IRUGO);
 MODULE_PARM_DESC(soft_crop, "Enables soft-cropping and thus the use of "
@@ -556,6 +573,9 @@ static int mt9m111_set_pixfmt(struct i2c_client *client,
 {
 	u16 data_outfmt1 = 0, data_outfmt2 = 0, mask_outfmt1, mask_outfmt2;
 	u16 data_opermod;
+#ifdef DEBUG
+	u16 pattern = 0;
+#endif
 	int ret;
 
 	data_opermod = MT9M111_OPMODE_AUTOEXPO_EN |
@@ -616,6 +636,49 @@ static int mt9m111_set_pixfmt(struct i2c_client *client,
 
 	ret = reg_mask(OUTPUT_FORMAT_CTRL, data_outfmt1, mask_outfmt1);
 
+#ifdef DEBUG
+	switch (testpattern) {
+	case 1:
+		pattern = MT9M111_TST_PATT_1 | MT9M111_TST_PATT_FORCE_WB_GAIN_1;
+		break;
+	case 2:
+		pattern = MT9M111_TST_PATT_2 | MT9M111_TST_PATT_FORCE_WB_GAIN_1;
+		break;
+	case 3:
+		pattern = MT9M111_TST_PATT_3 | MT9M111_TST_PATT_FORCE_WB_GAIN_1;
+		break;
+	case 4:
+		pattern = MT9M111_TST_PATT_4 | MT9M111_TST_PATT_FORCE_WB_GAIN_1;
+		break;
+	case 5:
+		pattern = MT9M111_TST_PATT_5 | MT9M111_TST_PATT_FORCE_WB_GAIN_1;
+		break;
+	case 6:
+		pattern = MT9M111_TST_PATT_6 | MT9M111_TST_PATT_FORCE_WB_GAIN_1;
+		break;
+	case 7:
+		pattern = MT9M111_TST_PATT_COLORBARS |
+			MT9M111_TST_PATT_FORCE_WB_GAIN_1;
+		break;
+	case 8:
+		data_outfmt2 |= MT9M111_OUTFMT_TST_RAMP_COL;
+		break;
+	case 9:
+		data_outfmt2 |= MT9M111_OUTFMT_TST_RAMP_ROW;
+		break;
+	case 10:
+		data_outfmt2 |= MT9M111_OUTFMT_TST_RAMP_FRAME;
+		break;
+	}
+
+	dev_dbg(&client->dev, "%s: using testpattern %d\n", __func__,
+			testpattern);
+
+	if (!ret)
+		ret = mt9m111_reg_set(client,
+				MT9M111_TEST_PATTERN_GEN, pattern);
+#endif
+
 	if (!ret)
 		ret = reg_mask(OUTPUT_FORMAT_CTRL2_A, data_outfmt2,
 			mask_outfmt2);
-- 
1.7.1

