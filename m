Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57627 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933154Ab2JWPmz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Oct 2012 11:42:55 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: timo.ahonen@nokia.com, laurent.pinchart@ideasonboard.com
Subject: [PATCH 4/6] smiapp-pll: Parallel bus support
Date: Tue, 23 Oct 2012 18:42:48 +0300
Message-Id: <1351006971-32308-4-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20121023154231.GB23685@valkosipuli.retiisi.org.uk>
References: <20121023154231.GB23685@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Support sensors with parallel interface.

Make smiapp_pll.flags also 8-bit so it fits nicely into two 32-bit words
with the other 8-bit fields.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/i2c/smiapp-pll.c         |   19 +++++++++++++++----
 drivers/media/i2c/smiapp-pll.h         |   26 ++++++++++++++++++++------
 drivers/media/i2c/smiapp/smiapp-core.c |    3 ++-
 3 files changed, 37 insertions(+), 11 deletions(-)

diff --git a/drivers/media/i2c/smiapp-pll.c b/drivers/media/i2c/smiapp-pll.c
index d7e3475..d324360 100644
--- a/drivers/media/i2c/smiapp-pll.c
+++ b/drivers/media/i2c/smiapp-pll.c
@@ -371,7 +371,7 @@ int smiapp_pll_calculate(struct device *dev, struct smiapp_pll_limits *limits,
 	int rval = -EINVAL;
 
 	if (pll->flags & SMIAPP_PLL_FLAG_OP_PIX_CLOCK_PER_LANE)
-		lane_op_clock_ratio = pll->lanes;
+		lane_op_clock_ratio = pll->csi2.lanes;
 	else
 		lane_op_clock_ratio = 1;
 	dev_dbg(dev, "lane_op_clock_ratio: %d\n", lane_op_clock_ratio);
@@ -379,9 +379,20 @@ int smiapp_pll_calculate(struct device *dev, struct smiapp_pll_limits *limits,
 	dev_dbg(dev, "binning: %dx%d\n", pll->binning_horizontal,
 		pll->binning_vertical);
 
-	/* CSI transfers 2 bits per clock per lane; thus times 2 */
-	pll->pll_op_clk_freq_hz = pll->link_freq * 2
-		* (pll->lanes / lane_op_clock_ratio);
+	switch (pll->bus_type) {
+	case SMIAPP_PLL_BUS_TYPE_CSI2:
+		/* CSI transfers 2 bits per clock per lane; thus times 2 */
+		pll->pll_op_clk_freq_hz = pll->link_freq * 2
+			* (pll->csi2.lanes / lane_op_clock_ratio);
+		break;
+	case SMIAPP_PLL_BUS_TYPE_PARALLEL:
+		pll->pll_op_clk_freq_hz = pll->link_freq * pll->bits_per_pixel
+			/ DIV_ROUND_UP(pll->bits_per_pixel,
+				       pll->parallel.bus_width);
+		break;
+	default:
+		return -EINVAL;
+	}
 
 	/* Figure out limits for pre-pll divider based on extclk */
 	dev_dbg(dev, "min / max pre_pll_clk_div: %d / %d\n",
diff --git a/drivers/media/i2c/smiapp-pll.h b/drivers/media/i2c/smiapp-pll.h
index cb2d2db..439fe5d 100644
--- a/drivers/media/i2c/smiapp-pll.h
+++ b/drivers/media/i2c/smiapp-pll.h
@@ -27,16 +27,34 @@
 
 #include <linux/device.h>
 
+/* CSI-2 or CCP-2 */
+#define SMIAPP_PLL_BUS_TYPE_CSI2				0x00
+#define SMIAPP_PLL_BUS_TYPE_PARALLEL				0x01
+
+/* op pix clock is for all lanes in total normally */
+#define SMIAPP_PLL_FLAG_OP_PIX_CLOCK_PER_LANE			(1 << 0)
+#define SMIAPP_PLL_FLAG_NO_OP_CLOCKS				(1 << 1)
+
 struct smiapp_pll {
-	uint8_t lanes;
+	/* input values */
+	uint8_t bus_type;
+	union {
+		struct {
+			uint8_t lanes;
+		} csi2;
+		struct {
+			uint8_t bus_width;
+		} parallel;
+	};
+	uint8_t flags;
 	uint8_t binning_horizontal;
 	uint8_t binning_vertical;
 	uint8_t scale_m;
 	uint8_t scale_n;
 	uint8_t bits_per_pixel;
-	uint16_t flags;
 	uint32_t link_freq;
 
+	/* output values */
 	uint16_t pre_pll_clk_div;
 	uint16_t pll_multiplier;
 	uint16_t op_sys_clk_div;
@@ -91,10 +109,6 @@ struct smiapp_pll_limits {
 	uint32_t min_line_length_pck;
 };
 
-/* op pix clock is for all lanes in total normally */
-#define SMIAPP_PLL_FLAG_OP_PIX_CLOCK_PER_LANE			(1 << 0)
-#define SMIAPP_PLL_FLAG_NO_OP_CLOCKS				(1 << 1)
-
 struct device;
 
 int smiapp_pll_calculate(struct device *dev, struct smiapp_pll_limits *limits,
diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 868ad0b..42316cb 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2625,7 +2625,8 @@ static int smiapp_registered(struct v4l2_subdev *subdev)
 		goto out_nvm_release;
 
 	/* prepare PLL configuration input values */
-	pll->lanes = sensor->platform_data->lanes;
+	pll->bus_type = SMIAPP_PLL_BUS_TYPE_CSI2;
+	pll->csi2.lanes = sensor->platform_data->lanes;
 	pll->ext_clk_freq_hz = sensor->platform_data->ext_clk;
 	/* Profile 0 sensors have no separate OP clock branch. */
 	if (sensor->minfo.smiapp_profile == SMIAPP_PROFILE_0)
-- 
1.7.2.5

