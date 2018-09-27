Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:46287 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727522AbeI0VFD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Sep 2018 17:05:03 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>
CC: <devicetree@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Jacopo Mondi <jacopo@jmondi.org>
Subject: [PATCH 1/4] media: ov5640: move parallel port pixel clock divider out of registers set
Date: Thu, 27 Sep 2018 16:46:04 +0200
Message-ID: <1538059567-8381-2-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1538059567-8381-1-git-send-email-hugues.fruchet@st.com>
References: <1538059567-8381-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Set DVP_PCLK_DIVIDER (0x3824) and VFIFO_CTRL0C (0x460c) registers
in ov5640_set_dvp_pclk() according to mode selected.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/i2c/ov5640.c | 66 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 46 insertions(+), 20 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 1a64bb6..da4d754 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -66,6 +66,7 @@
 #define OV5640_REG_TIMING_VTS		0x380e
 #define OV5640_REG_TIMING_TC_REG20	0x3820
 #define OV5640_REG_TIMING_TC_REG21	0x3821
+#define OV5640_REG_DVP_PCLK_DIVIDER	0x3824
 #define OV5640_REG_AEC_CTRL00		0x3a00
 #define OV5640_REG_AEC_B50_STEP		0x3a08
 #define OV5640_REG_AEC_B60_STEP		0x3a0a
@@ -82,6 +83,7 @@
 #define OV5640_REG_SIGMADELTA_CTRL0C	0x3c0c
 #define OV5640_REG_FRAME_CTRL01		0x4202
 #define OV5640_REG_FORMAT_CONTROL00	0x4300
+#define OV5640_REG_VFIFO_CTRL0C		0x460C
 #define OV5640_REG_POLARITY_CTRL00	0x4740
 #define OV5640_REG_MIPI_CTRL00		0x4800
 #define OV5640_REG_DEBUG_MODE		0x4814
@@ -355,8 +357,8 @@ static const struct reg_value ov5640_setting_VGA_640_480[] = {
 	{0x3a0a, 0x00, 0, 0}, {0x3a0b, 0xf6, 0, 0}, {0x3a0e, 0x03, 0, 0},
 	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
 	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0}, {0x4713, 0x03, 0, 0},
-	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
-	{0x3824, 0x02, 0, 0}, {0x5001, 0xa3, 0, 0},
+	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0},
+	{0x5001, 0xa3, 0, 0},
 };
 
 static const struct reg_value ov5640_setting_XGA_1024_768[] = {
@@ -374,8 +376,8 @@ static const struct reg_value ov5640_setting_XGA_1024_768[] = {
 	{0x3a0a, 0x00, 0, 0}, {0x3a0b, 0xf6, 0, 0}, {0x3a0e, 0x03, 0, 0},
 	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
 	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0}, {0x4713, 0x03, 0, 0},
-	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
-	{0x3824, 0x02, 0, 0}, {0x5001, 0xa3, 0, 0},
+	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0},
+	{0x5001, 0xa3, 0, 0},
 };
 
 static const struct reg_value ov5640_setting_QVGA_320_240[] = {
@@ -393,8 +395,8 @@ static const struct reg_value ov5640_setting_QVGA_320_240[] = {
 	{0x3a0a, 0x00, 0, 0}, {0x3a0b, 0xf6, 0, 0}, {0x3a0e, 0x03, 0, 0},
 	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
 	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0}, {0x4713, 0x03, 0, 0},
-	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
-	{0x3824, 0x02, 0, 0}, {0x5001, 0xa3, 0, 0},
+	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0},
+	{0x5001, 0xa3, 0, 0},
 };
 
 static const struct reg_value ov5640_setting_QCIF_176_144[] = {
@@ -412,8 +414,8 @@ static const struct reg_value ov5640_setting_QCIF_176_144[] = {
 	{0x3a0a, 0x00, 0, 0}, {0x3a0b, 0xf6, 0, 0}, {0x3a0e, 0x03, 0, 0},
 	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
 	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0}, {0x4713, 0x03, 0, 0},
-	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
-	{0x3824, 0x02, 0, 0}, {0x5001, 0xa3, 0, 0},
+	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0},
+	{0x5001, 0xa3, 0, 0},
 };
 
 static const struct reg_value ov5640_setting_NTSC_720_480[] = {
@@ -431,8 +433,8 @@ static const struct reg_value ov5640_setting_NTSC_720_480[] = {
 	{0x3a0a, 0x00, 0, 0}, {0x3a0b, 0xf6, 0, 0}, {0x3a0e, 0x03, 0, 0},
 	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
 	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0}, {0x4713, 0x03, 0, 0},
-	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
-	{0x3824, 0x02, 0, 0}, {0x5001, 0xa3, 0, 0},
+	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0},
+	{0x5001, 0xa3, 0, 0},
 };
 
 static const struct reg_value ov5640_setting_PAL_720_576[] = {
@@ -450,8 +452,8 @@ static const struct reg_value ov5640_setting_PAL_720_576[] = {
 	{0x3a0a, 0x00, 0, 0}, {0x3a0b, 0xf6, 0, 0}, {0x3a0e, 0x03, 0, 0},
 	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
 	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0}, {0x4713, 0x03, 0, 0},
-	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
-	{0x3824, 0x02, 0, 0}, {0x5001, 0xa3, 0, 0},
+	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0},
+	{0x5001, 0xa3, 0, 0},
 };
 
 static const struct reg_value ov5640_setting_720P_1280_720[] = {
@@ -469,8 +471,8 @@ static const struct reg_value ov5640_setting_720P_1280_720[] = {
 	{0x3a0a, 0x01, 0, 0}, {0x3a0b, 0x72, 0, 0}, {0x3a0e, 0x01, 0, 0},
 	{0x3a0d, 0x02, 0, 0}, {0x3a14, 0x02, 0, 0}, {0x3a15, 0xe4, 0, 0},
 	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0}, {0x4713, 0x02, 0, 0},
-	{0x4407, 0x04, 0, 0}, {0x460b, 0x37, 0, 0}, {0x460c, 0x20, 0, 0},
-	{0x3824, 0x04, 0, 0}, {0x5001, 0x83, 0, 0},
+	{0x4407, 0x04, 0, 0}, {0x460b, 0x37, 0, 0},
+	{0x5001, 0x83, 0, 0},
 };
 
 static const struct reg_value ov5640_setting_1080P_1920_1080[] = {
@@ -490,7 +492,7 @@ static const struct reg_value ov5640_setting_1080P_1920_1080[] = {
 	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
 	{0x4001, 0x02, 0, 0}, {0x4004, 0x06, 0, 0}, {0x4713, 0x03, 0, 0},
 	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
-	{0x3824, 0x02, 0, 0}, {0x5001, 0x83, 0, 0},
+	{0x5001, 0x83, 0, 0},
 	{0x3c07, 0x07, 0, 0}, {0x3c08, 0x00, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3800, 0x01, 0, 0}, {0x3801, 0x50, 0, 0}, {0x3802, 0x01, 0, 0},
@@ -501,7 +503,7 @@ static const struct reg_value ov5640_setting_1080P_1920_1080[] = {
 	{0x3a09, 0x50, 0, 0}, {0x3a0a, 0x01, 0, 0}, {0x3a0b, 0x18, 0, 0},
 	{0x3a0e, 0x03, 0, 0}, {0x3a0d, 0x04, 0, 0}, {0x3a14, 0x04, 0, 0},
 	{0x3a15, 0x60, 0, 0}, {0x4713, 0x02, 0, 0}, {0x4407, 0x04, 0, 0},
-	{0x460b, 0x37, 0, 0}, {0x460c, 0x20, 0, 0}, {0x3824, 0x04, 0, 0},
+	{0x460b, 0x37, 0, 0},
 	{0x4005, 0x1a, 0, 0}, {0x3008, 0x02, 0, 0}, {0x3503, 0, 0, 0},
 };
 
@@ -520,8 +522,8 @@ static const struct reg_value ov5640_setting_QSXGA_2592_1944[] = {
 	{0x3a0a, 0x00, 0, 0}, {0x3a0b, 0xf6, 0, 0}, {0x3a0e, 0x03, 0, 0},
 	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
 	{0x4001, 0x02, 0, 0}, {0x4004, 0x06, 0, 0}, {0x4713, 0x03, 0, 0},
-	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
-	{0x3824, 0x02, 0, 0}, {0x5001, 0x83, 0, 70},
+	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0},
+	{0x5001, 0x83, 0, 70},
 };
 
 /* power-on sensor init reg table */
@@ -910,10 +912,34 @@ static unsigned long ov5640_calc_pclk(struct ov5640_dev *sensor,
 	return _rate / *pll_rdiv / *bit_div / *pclk_div;
 }
 
-static int ov5640_set_dvp_pclk(struct ov5640_dev *sensor, unsigned long rate)
+static int ov5640_set_dvp_pclk(struct ov5640_dev *sensor,
+			       const struct ov5640_mode_info *mode,
+			       unsigned long rate)
 {
 	u8 prediv, mult, sysdiv, pll_rdiv, bit_div, pclk_div;
 	int ret;
+	/*
+	 * FIXME, value of PCLK divider deduced from
+	 * mode registers hardcoded sequence and tests
+	 */
+	u8 dvp_pclk_divider = mode->hact < 1024 ? 2 : 1;
+
+	/*
+	 * VIFO CTRL0C:
+	 * - [1]:	PCLK manual enable (0: control by auto-mode,
+	 *		1: manual control by OV5640_REG_DVP_PCLK_DIVIDER)
+	 *
+	 * Always enable PCLK manual control.
+	 */
+	ret = ov5640_mod_reg(sensor, OV5640_REG_VFIFO_CTRL0C,
+			     BIT(1), BIT(1));
+	if (ret)
+		return ret;
+
+	ret = ov5640_write_reg(sensor, OV5640_REG_DVP_PCLK_DIVIDER,
+			       dvp_pclk_divider);
+	if (ret)
+		return ret;
 
 	ov5640_calc_pclk(sensor, rate, &prediv, &mult, &sysdiv, &pll_rdiv,
 			 &bit_div, &pclk_div);
@@ -1699,7 +1725,7 @@ static int ov5640_set_mode(struct ov5640_dev *sensor)
 		ret = ov5640_set_mipi_pclk(sensor, rate);
 	} else {
 		rate = rate / sensor->ep.bus.parallel.bus_width;
-		ret = ov5640_set_dvp_pclk(sensor, rate);
+		ret = ov5640_set_dvp_pclk(sensor, mode, rate);
 	}
 
 	if (ret < 0)
-- 
2.7.4
