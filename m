Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay10.mail.gandi.net ([217.70.178.230]:56421 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728129AbeJRDen (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 Oct 2018 23:34:43 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: maxime.ripard@bootlin.com, sam@elite-embedded.com,
        mchehab@kernel.org
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, hans.verkuil@cisco.com,
        sakari.ailus@linux.intel.com, linux-media@vger.kernel.org,
        hugues.fruchet@st.com, loic.poulain@linaro.org, daniel@zonque.org
Subject: [PATCH 1/2] media: ov5640: Add check for PLL1 output max frequency
Date: Wed, 17 Oct 2018 21:37:17 +0200
Message-Id: <1539805038-22321-2-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1539805038-22321-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1539805038-22321-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Check that the PLL1 output frequency does not exceed the maximum allowed 1GHz
frequency.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/i2c/ov5640.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index e098435..1f2e72d 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -770,7 +770,7 @@ static int ov5640_mod_reg(struct ov5640_dev *sensor, u16 reg,
  * always set to either 1 or 2 in the vendor kernels.
  */
 #define OV5640_SYSDIV_MIN	1
-#define OV5640_SYSDIV_MAX	2
+#define OV5640_SYSDIV_MAX	16
 
 /*
  * This is supposed to be ranging from 1 to 16, but the value is always
@@ -806,15 +806,20 @@ static int ov5640_mod_reg(struct ov5640_dev *sensor, u16 reg,
  * This is supposed to be ranging from 1 to 8, but the value is always
  * set to 1 in the vendor kernels.
  */
-#define OV5640_PCLK_ROOT_DIV	1
+#define OV5640_PCLK_ROOT_DIV			1
+#define OV5640_PLL_SYS_ROOT_DIVIDER_BYPASS	0x00
 
 static unsigned long ov5640_compute_sys_clk(struct ov5640_dev *sensor,
 					    u8 pll_prediv, u8 pll_mult,
 					    u8 sysdiv)
 {
-	unsigned long rate = clk_get_rate(sensor->xclk);
+	unsigned long sysclk = sensor->xclk_freq / pll_prediv * pll_mult;
 
-	return rate / pll_prediv * pll_mult / sysdiv;
+	/* PLL1 output cannot exceed 1GHz. */
+	if (sysclk / 1000000 > 1000)
+		return 0;
+
+	return sysclk / sysdiv;
 }
 
 static unsigned long ov5640_calc_sys_clk(struct ov5640_dev *sensor,
@@ -844,6 +849,16 @@ static unsigned long ov5640_calc_sys_clk(struct ov5640_dev *sensor,
 			_rate = ov5640_compute_sys_clk(sensor,
 						       OV5640_PLL_PREDIV,
 						       _pll_mult, _sysdiv);
+
+			/*
+			 * We have reached the maximum allowed PLL1 output,
+			 * increase sysdiv.
+			 */
+			if (rate == 0) {
+				_pll_mult = OV5640_PLL_MULT_MAX + 1;
+				continue;
+			}
+
 			if (abs(rate - _rate) < abs(rate - best)) {
 				best = _rate;
 				best_sysdiv = _sysdiv;
-- 
2.7.4
