Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40634 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbcFXPcM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2016 11:32:12 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Erik Andren <erik.andren@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 07/19] m5602_ov9650: move skeletons to the .c file
Date: Fri, 24 Jun 2016 12:31:48 -0300
Message-Id: <14ccffa3c1497dff59707f7e55888d83a4896bfe.1466782238.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1466782238.git.mchehab@s-opensource.com>
References: <cover.1466782238.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1466782238.git.mchehab@s-opensource.com>
References: <cover.1466782238.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The header file has some private static structures that
are used only by the C file. Move those structures to the C file,
in order to shut up gcc 6.1 warnings.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/gspca/m5602/m5602_ov9650.c | 152 +++++++++++++++++++++++++++
 drivers/media/usb/gspca/m5602/m5602_ov9650.h | 150 --------------------------
 2 files changed, 152 insertions(+), 150 deletions(-)

diff --git a/drivers/media/usb/gspca/m5602/m5602_ov9650.c b/drivers/media/usb/gspca/m5602/m5602_ov9650.c
index 59bc62bfae26..4544d3a1ad58 100644
--- a/drivers/media/usb/gspca/m5602/m5602_ov9650.c
+++ b/drivers/media/usb/gspca/m5602/m5602_ov9650.c
@@ -1,3 +1,4 @@
+
 /*
  * Driver for the ov9650 sensor
  *
@@ -23,6 +24,157 @@
 static int ov9650_s_ctrl(struct v4l2_ctrl *ctrl);
 static void ov9650_dump_registers(struct sd *sd);
 
+static const unsigned char preinit_ov9650[][3] = {
+	/* [INITCAM] */
+	{BRIDGE, M5602_XB_MCU_CLK_DIV, 0x02},
+	{BRIDGE, M5602_XB_MCU_CLK_CTRL, 0xb0},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0},
+	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0},
+	{BRIDGE, M5602_XB_SENSOR_CTRL, 0x00},
+
+	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x08},
+	{BRIDGE, M5602_XB_GPIO_DIR, 0x05},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x04},
+	{BRIDGE, M5602_XB_GPIO_EN_H, 0x06},
+	{BRIDGE, M5602_XB_GPIO_DIR_H, 0x06},
+	{BRIDGE, M5602_XB_GPIO_DAT_H, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x00},
+	{BRIDGE, M5602_XB_I2C_CLK_DIV, 0x0a},
+	/* Reset chip */
+	{SENSOR, OV9650_COM7, OV9650_REGISTER_RESET},
+	/* Enable double clock */
+	{SENSOR, OV9650_CLKRC, 0x80},
+	/* Do something out of spec with the power */
+	{SENSOR, OV9650_OFON, 0x40}
+};
+
+static const unsigned char init_ov9650[][3] = {
+	/* [INITCAM] */
+	{BRIDGE, M5602_XB_MCU_CLK_DIV, 0x02},
+	{BRIDGE, M5602_XB_MCU_CLK_CTRL, 0xb0},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0},
+	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0},
+	{BRIDGE, M5602_XB_SENSOR_CTRL, 0x00},
+
+	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x08},
+	{BRIDGE, M5602_XB_GPIO_DIR, 0x05},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x04},
+	{BRIDGE, M5602_XB_GPIO_EN_H, 0x06},
+	{BRIDGE, M5602_XB_GPIO_DIR_H, 0x06},
+	{BRIDGE, M5602_XB_GPIO_DAT_H, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x00},
+	{BRIDGE, M5602_XB_I2C_CLK_DIV, 0x0a},
+
+	/* Reset chip */
+	{SENSOR, OV9650_COM7, OV9650_REGISTER_RESET},
+	/* One extra reset is needed in order to make the sensor behave
+	   properly when resuming from ram, could be a timing issue */
+	{SENSOR, OV9650_COM7, OV9650_REGISTER_RESET},
+
+	/* Enable double clock */
+	{SENSOR, OV9650_CLKRC, 0x80},
+	/* Do something out of spec with the power */
+	{SENSOR, OV9650_OFON, 0x40},
+
+	/* Set fast AGC/AEC algorithm with unlimited step size */
+	{SENSOR, OV9650_COM8, OV9650_FAST_AGC_AEC |
+			      OV9650_AEC_UNLIM_STEP_SIZE},
+
+	{SENSOR, OV9650_CHLF, 0x10},
+	{SENSOR, OV9650_ARBLM, 0xbf},
+	{SENSOR, OV9650_ACOM38, 0x81},
+	/* Turn off color matrix coefficient double option */
+	{SENSOR, OV9650_COM16, 0x00},
+	/* Enable color matrix for RGB/YUV, Delay Y channel,
+	set output Y/UV delay to 1 */
+	{SENSOR, OV9650_COM13, 0x19},
+	/* Enable digital BLC, Set output mode to U Y V Y */
+	{SENSOR, OV9650_TSLB, 0x0c},
+	/* Limit the AGC/AEC stable upper region */
+	{SENSOR, OV9650_COM24, 0x00},
+	/* Enable HREF and some out of spec things */
+	{SENSOR, OV9650_COM12, 0x73},
+	/* Set all DBLC offset signs to positive and
+	do some out of spec stuff */
+	{SENSOR, OV9650_DBLC1, 0xdf},
+	{SENSOR, OV9650_COM21, 0x06},
+	{SENSOR, OV9650_RSVD35, 0x91},
+	/* Necessary, no camera stream without it */
+	{SENSOR, OV9650_RSVD16, 0x06},
+	{SENSOR, OV9650_RSVD94, 0x99},
+	{SENSOR, OV9650_RSVD95, 0x99},
+	{SENSOR, OV9650_RSVD96, 0x04},
+	/* Enable full range output */
+	{SENSOR, OV9650_COM15, 0x0},
+	/* Enable HREF at optical black, enable ADBLC bias,
+	enable ADBLC, reset timings at format change */
+	{SENSOR, OV9650_COM6, 0x4b},
+	/* Subtract 32 from the B channel bias */
+	{SENSOR, OV9650_BBIAS, 0xa0},
+	/* Subtract 32 from the Gb channel bias */
+	{SENSOR, OV9650_GbBIAS, 0xa0},
+	/* Do not bypass the analog BLC and to some out of spec stuff */
+	{SENSOR, OV9650_Gr_COM, 0x00},
+	/* Subtract 32 from the R channel bias */
+	{SENSOR, OV9650_RBIAS, 0xa0},
+	/* Subtract 32 from the R channel bias */
+	{SENSOR, OV9650_RBIAS, 0x0},
+	{SENSOR, OV9650_COM26, 0x80},
+	{SENSOR, OV9650_ACOMA9, 0x98},
+	/* Set the AGC/AEC stable region upper limit */
+	{SENSOR, OV9650_AEW, 0x68},
+	/* Set the AGC/AEC stable region lower limit */
+	{SENSOR, OV9650_AEB, 0x5c},
+	/* Set the high and low limit nibbles to 3 */
+	{SENSOR, OV9650_VPT, 0xc3},
+	/* Set the Automatic Gain Ceiling (AGC) to 128x,
+	drop VSYNC at frame drop,
+	limit exposure timing,
+	drop frame when the AEC step is larger than the exposure gap */
+	{SENSOR, OV9650_COM9, 0x6e},
+	/* Set VSYNC negative, Set RESET to SLHS (slave mode horizontal sync)
+	and set PWDN to SLVS (slave mode vertical sync) */
+	{SENSOR, OV9650_COM10, 0x42},
+	/* Set horizontal column start high to default value */
+	{SENSOR, OV9650_HSTART, 0x1a}, /* 210 */
+	/* Set horizontal column end */
+	{SENSOR, OV9650_HSTOP, 0xbf}, /* 1534 */
+	/* Complementing register to the two writes above */
+	{SENSOR, OV9650_HREF, 0xb2},
+	/* Set vertical row start high bits */
+	{SENSOR, OV9650_VSTRT, 0x02},
+	/* Set vertical row end low bits */
+	{SENSOR, OV9650_VSTOP, 0x7e},
+	/* Set complementing vertical frame control */
+	{SENSOR, OV9650_VREF, 0x10},
+	{SENSOR, OV9650_ADC, 0x04},
+	{SENSOR, OV9650_HV, 0x40},
+
+	/* Enable denoise, and white-pixel erase */
+	{SENSOR, OV9650_COM22, OV9650_DENOISE_ENABLE |
+		 OV9650_WHITE_PIXEL_ENABLE |
+		 OV9650_WHITE_PIXEL_OPTION},
+
+	/* Enable VARIOPIXEL */
+	{SENSOR, OV9650_COM3, OV9650_VARIOPIXEL},
+	{SENSOR, OV9650_COM4, OV9650_QVGA_VARIOPIXEL},
+
+	/* Put the sensor in soft sleep mode */
+	{SENSOR, OV9650_COM2, OV9650_SOFT_SLEEP | OV9650_OUTPUT_DRIVE_2X},
+};
+
+static const unsigned char res_init_ov9650[][3] = {
+	{SENSOR, OV9650_COM2, OV9650_OUTPUT_DRIVE_2X},
+
+	{BRIDGE, M5602_XB_LINE_OF_FRAME_H, 0x82},
+	{BRIDGE, M5602_XB_LINE_OF_FRAME_L, 0x00},
+	{BRIDGE, M5602_XB_PIX_OF_LINE_H, 0x82},
+	{BRIDGE, M5602_XB_PIX_OF_LINE_L, 0x00},
+	{BRIDGE, M5602_XB_SIG_INI, 0x01}
+};
+
 /* Vertically and horizontally flips the image if matched, needed for machines
    where the sensor is mounted upside down */
 static
diff --git a/drivers/media/usb/gspca/m5602/m5602_ov9650.h b/drivers/media/usb/gspca/m5602/m5602_ov9650.h
index f9f5870da60f..ce3db062c740 100644
--- a/drivers/media/usb/gspca/m5602/m5602_ov9650.h
+++ b/drivers/media/usb/gspca/m5602/m5602_ov9650.h
@@ -156,154 +156,4 @@ static const struct m5602_sensor ov9650 = {
 	.disconnect = ov9650_disconnect,
 };
 
-static const unsigned char preinit_ov9650[][3] = {
-	/* [INITCAM] */
-	{BRIDGE, M5602_XB_MCU_CLK_DIV, 0x02},
-	{BRIDGE, M5602_XB_MCU_CLK_CTRL, 0xb0},
-	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00},
-	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0},
-	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0},
-	{BRIDGE, M5602_XB_SENSOR_CTRL, 0x00},
-
-	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x08},
-	{BRIDGE, M5602_XB_GPIO_DIR, 0x05},
-	{BRIDGE, M5602_XB_GPIO_DAT, 0x04},
-	{BRIDGE, M5602_XB_GPIO_EN_H, 0x06},
-	{BRIDGE, M5602_XB_GPIO_DIR_H, 0x06},
-	{BRIDGE, M5602_XB_GPIO_DAT_H, 0x00},
-	{BRIDGE, M5602_XB_GPIO_DAT, 0x00},
-	{BRIDGE, M5602_XB_I2C_CLK_DIV, 0x0a},
-	/* Reset chip */
-	{SENSOR, OV9650_COM7, OV9650_REGISTER_RESET},
-	/* Enable double clock */
-	{SENSOR, OV9650_CLKRC, 0x80},
-	/* Do something out of spec with the power */
-	{SENSOR, OV9650_OFON, 0x40}
-};
-
-static const unsigned char init_ov9650[][3] = {
-	/* [INITCAM] */
-	{BRIDGE, M5602_XB_MCU_CLK_DIV, 0x02},
-	{BRIDGE, M5602_XB_MCU_CLK_CTRL, 0xb0},
-	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00},
-	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0},
-	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0},
-	{BRIDGE, M5602_XB_SENSOR_CTRL, 0x00},
-
-	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x08},
-	{BRIDGE, M5602_XB_GPIO_DIR, 0x05},
-	{BRIDGE, M5602_XB_GPIO_DAT, 0x04},
-	{BRIDGE, M5602_XB_GPIO_EN_H, 0x06},
-	{BRIDGE, M5602_XB_GPIO_DIR_H, 0x06},
-	{BRIDGE, M5602_XB_GPIO_DAT_H, 0x00},
-	{BRIDGE, M5602_XB_GPIO_DAT, 0x00},
-	{BRIDGE, M5602_XB_I2C_CLK_DIV, 0x0a},
-
-	/* Reset chip */
-	{SENSOR, OV9650_COM7, OV9650_REGISTER_RESET},
-	/* One extra reset is needed in order to make the sensor behave
-	   properly when resuming from ram, could be a timing issue */
-	{SENSOR, OV9650_COM7, OV9650_REGISTER_RESET},
-
-	/* Enable double clock */
-	{SENSOR, OV9650_CLKRC, 0x80},
-	/* Do something out of spec with the power */
-	{SENSOR, OV9650_OFON, 0x40},
-
-	/* Set fast AGC/AEC algorithm with unlimited step size */
-	{SENSOR, OV9650_COM8, OV9650_FAST_AGC_AEC |
-			      OV9650_AEC_UNLIM_STEP_SIZE},
-
-	{SENSOR, OV9650_CHLF, 0x10},
-	{SENSOR, OV9650_ARBLM, 0xbf},
-	{SENSOR, OV9650_ACOM38, 0x81},
-	/* Turn off color matrix coefficient double option */
-	{SENSOR, OV9650_COM16, 0x00},
-	/* Enable color matrix for RGB/YUV, Delay Y channel,
-	set output Y/UV delay to 1 */
-	{SENSOR, OV9650_COM13, 0x19},
-	/* Enable digital BLC, Set output mode to U Y V Y */
-	{SENSOR, OV9650_TSLB, 0x0c},
-	/* Limit the AGC/AEC stable upper region */
-	{SENSOR, OV9650_COM24, 0x00},
-	/* Enable HREF and some out of spec things */
-	{SENSOR, OV9650_COM12, 0x73},
-	/* Set all DBLC offset signs to positive and
-	do some out of spec stuff */
-	{SENSOR, OV9650_DBLC1, 0xdf},
-	{SENSOR, OV9650_COM21, 0x06},
-	{SENSOR, OV9650_RSVD35, 0x91},
-	/* Necessary, no camera stream without it */
-	{SENSOR, OV9650_RSVD16, 0x06},
-	{SENSOR, OV9650_RSVD94, 0x99},
-	{SENSOR, OV9650_RSVD95, 0x99},
-	{SENSOR, OV9650_RSVD96, 0x04},
-	/* Enable full range output */
-	{SENSOR, OV9650_COM15, 0x0},
-	/* Enable HREF at optical black, enable ADBLC bias,
-	enable ADBLC, reset timings at format change */
-	{SENSOR, OV9650_COM6, 0x4b},
-	/* Subtract 32 from the B channel bias */
-	{SENSOR, OV9650_BBIAS, 0xa0},
-	/* Subtract 32 from the Gb channel bias */
-	{SENSOR, OV9650_GbBIAS, 0xa0},
-	/* Do not bypass the analog BLC and to some out of spec stuff */
-	{SENSOR, OV9650_Gr_COM, 0x00},
-	/* Subtract 32 from the R channel bias */
-	{SENSOR, OV9650_RBIAS, 0xa0},
-	/* Subtract 32 from the R channel bias */
-	{SENSOR, OV9650_RBIAS, 0x0},
-	{SENSOR, OV9650_COM26, 0x80},
-	{SENSOR, OV9650_ACOMA9, 0x98},
-	/* Set the AGC/AEC stable region upper limit */
-	{SENSOR, OV9650_AEW, 0x68},
-	/* Set the AGC/AEC stable region lower limit */
-	{SENSOR, OV9650_AEB, 0x5c},
-	/* Set the high and low limit nibbles to 3 */
-	{SENSOR, OV9650_VPT, 0xc3},
-	/* Set the Automatic Gain Ceiling (AGC) to 128x,
-	drop VSYNC at frame drop,
-	limit exposure timing,
-	drop frame when the AEC step is larger than the exposure gap */
-	{SENSOR, OV9650_COM9, 0x6e},
-	/* Set VSYNC negative, Set RESET to SLHS (slave mode horizontal sync)
-	and set PWDN to SLVS (slave mode vertical sync) */
-	{SENSOR, OV9650_COM10, 0x42},
-	/* Set horizontal column start high to default value */
-	{SENSOR, OV9650_HSTART, 0x1a}, /* 210 */
-	/* Set horizontal column end */
-	{SENSOR, OV9650_HSTOP, 0xbf}, /* 1534 */
-	/* Complementing register to the two writes above */
-	{SENSOR, OV9650_HREF, 0xb2},
-	/* Set vertical row start high bits */
-	{SENSOR, OV9650_VSTRT, 0x02},
-	/* Set vertical row end low bits */
-	{SENSOR, OV9650_VSTOP, 0x7e},
-	/* Set complementing vertical frame control */
-	{SENSOR, OV9650_VREF, 0x10},
-	{SENSOR, OV9650_ADC, 0x04},
-	{SENSOR, OV9650_HV, 0x40},
-
-	/* Enable denoise, and white-pixel erase */
-	{SENSOR, OV9650_COM22, OV9650_DENOISE_ENABLE |
-		 OV9650_WHITE_PIXEL_ENABLE |
-		 OV9650_WHITE_PIXEL_OPTION},
-
-	/* Enable VARIOPIXEL */
-	{SENSOR, OV9650_COM3, OV9650_VARIOPIXEL},
-	{SENSOR, OV9650_COM4, OV9650_QVGA_VARIOPIXEL},
-
-	/* Put the sensor in soft sleep mode */
-	{SENSOR, OV9650_COM2, OV9650_SOFT_SLEEP | OV9650_OUTPUT_DRIVE_2X},
-};
-
-static const unsigned char res_init_ov9650[][3] = {
-	{SENSOR, OV9650_COM2, OV9650_OUTPUT_DRIVE_2X},
-
-	{BRIDGE, M5602_XB_LINE_OF_FRAME_H, 0x82},
-	{BRIDGE, M5602_XB_LINE_OF_FRAME_L, 0x00},
-	{BRIDGE, M5602_XB_PIX_OF_LINE_H, 0x82},
-	{BRIDGE, M5602_XB_PIX_OF_LINE_L, 0x00},
-	{BRIDGE, M5602_XB_SIG_INI, 0x01}
-};
 #endif
-- 
2.7.4


