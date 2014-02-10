Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42214 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbaBJVxx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 16:53:53 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Subject: [PATCH 5/5] mt9p031: Add support for PLL bypass
Date: Mon, 10 Feb 2014 22:54:44 +0100
Message-Id: <1392069284-18024-6-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1392069284-18024-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1392069284-18024-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When the input clock frequency is out of bounds for the PLL, bypass the
PLL and just divide the input clock to achieve the requested output
frequency.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/mt9p031.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
index 14a616e..5483ab2 100644
--- a/drivers/media/i2c/mt9p031.c
+++ b/drivers/media/i2c/mt9p031.c
@@ -78,6 +78,9 @@
 #define	MT9P031_PLL_CONFIG_1				0x11
 #define	MT9P031_PLL_CONFIG_2				0x12
 #define MT9P031_PIXEL_CLOCK_CONTROL			0x0a
+#define		MT9P031_PIXEL_CLOCK_INVERT		(1 << 15)
+#define		MT9P031_PIXEL_CLOCK_SHIFT(n)		((n) << 8)
+#define		MT9P031_PIXEL_CLOCK_DIVIDE(n)		((n) << 0)
 #define MT9P031_FRAME_RESTART				0x0b
 #define MT9P031_SHUTTER_DELAY				0x0c
 #define MT9P031_RST					0x0d
@@ -130,6 +133,8 @@ struct mt9p031 {
 
 	enum mt9p031_model model;
 	struct aptina_pll pll;
+	unsigned int clk_div;
+	bool use_pll;
 	int reset;
 
 	struct v4l2_ctrl_handler ctrls;
@@ -198,6 +203,11 @@ static int mt9p031_reset(struct mt9p031 *mt9p031)
 	if (ret < 0)
 		return ret;
 
+	ret = mt9p031_write(client, MT9P031_PIXEL_CLOCK_CONTROL,
+			    MT9P031_PIXEL_CLOCK_DIVIDE(mt9p031->clk_div));
+	if (ret < 0)
+		return ret;
+
 	return mt9p031_set_output_control(mt9p031, MT9P031_OUTPUT_CONTROL_CEN,
 					  0);
 }
@@ -232,8 +242,24 @@ static int mt9p031_clk_setup(struct mt9p031 *mt9p031)
 	if (ret < 0)
 		return ret;
 
+	/* If the external clock frequency is out of bounds for the PLL use the
+	 * pixel clock divider only and disable the PLL.
+	 */
+	if (pdata->ext_freq > limits.ext_clock_max) {
+		unsigned int div;
+
+		div = DIV_ROUND_UP(pdata->ext_freq, pdata->target_freq);
+		div = roundup_pow_of_two(div) / 2;
+
+		mt9p031->clk_div = max_t(unsigned int, div, 64);
+		mt9p031->use_pll = false;
+
+		return 0;
+	}
+
 	mt9p031->pll.ext_clock = pdata->ext_freq;
 	mt9p031->pll.pix_clock = pdata->target_freq;
+	mt9p031->use_pll = true;
 
 	return aptina_pll_calculate(&client->dev, &limits, &mt9p031->pll);
 }
@@ -243,6 +269,9 @@ static int mt9p031_pll_enable(struct mt9p031 *mt9p031)
 	struct i2c_client *client = v4l2_get_subdevdata(&mt9p031->subdev);
 	int ret;
 
+	if (!mt9p031->use_pll)
+		return 0;
+
 	ret = mt9p031_write(client, MT9P031_PLL_CONTROL,
 			    MT9P031_PLL_CONTROL_PWRON);
 	if (ret < 0)
@@ -268,6 +297,9 @@ static inline int mt9p031_pll_disable(struct mt9p031 *mt9p031)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&mt9p031->subdev);
 
+	if (!mt9p031->use_pll)
+		return 0;
+
 	return mt9p031_write(client, MT9P031_PLL_CONTROL,
 			     MT9P031_PLL_CONTROL_PWROFF);
 }
-- 
1.8.3.2

