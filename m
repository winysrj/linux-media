Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:37029 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753543AbdGCJRF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Jul 2017 05:17:05 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        " H. Nikolaus Schaller" <hns@goldelico.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
CC: <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick Fertre <yannick.fertre@st.com>,
        Hugues Fruchet <hugues.fruchet@st.com>
Subject: [PATCH v2 6/7] [media] ov9650: add support of OV9655 variant
Date: Mon, 3 Jul 2017 11:16:07 +0200
Message-ID: <1499073368-31905-7-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1499073368-31905-1-git-send-email-hugues.fruchet@st.com>
References: <1499073368-31905-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a first support of OV9655 variant.
Because of register set slightly different from OV9650/9652,
not all of the driver features are supported (controls).
Supported resolutions are limited to VGA, QVGA, QQVGA.
Supported format is limited to RGB565.
Controls are limited to color bar test pattern for test purpose.

Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/i2c/Kconfig  |   4 +-
 drivers/media/i2c/ov9650.c | 487 ++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 457 insertions(+), 34 deletions(-)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 168115c..0f7542f 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -614,11 +614,11 @@ config VIDEO_OV7670
 	  controller.
 
 config VIDEO_OV9650
-	tristate "OmniVision OV9650/OV9652 sensor support"
+	tristate "OmniVision OV9650/OV9652/OV9655 sensor support"
 	depends on GPIOLIB && I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	---help---
 	  This is a V4L2 sensor-level driver for the Omnivision
-	  OV9650 and OV9652 camera sensors.
+	  OV9650 and OV9652 and OV9655 camera sensors.
 
 config VIDEO_OV13858
 	tristate "OmniVision OV13858 sensor support"
diff --git a/drivers/media/i2c/ov9650.c b/drivers/media/i2c/ov9650.c
index 50397e6..9ff0782 100644
--- a/drivers/media/i2c/ov9650.c
+++ b/drivers/media/i2c/ov9650.c
@@ -1,5 +1,5 @@
 /*
- * Omnivision OV9650/OV9652 CMOS Image Sensor driver
+ * Omnivision OV9650/OV9652/OV9655 CMOS Image Sensor driver
  *
  * Copyright (C) 2013, Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
  *
@@ -7,6 +7,15 @@
  * by Vladimir Fonov.
  * Copyright (c) 2010, Vladimir Fonov
  *
+ *
+ * Copyright (C) STMicroelectronics SA 2017
+ * Author: Hugues Fruchet <hugues.fruchet@st.com> for STMicroelectronics.
+ *
+ * OV9655 initial support based on a driver written by H. Nikolaus Schaller:
+ *   http://git.goldelico.com/?p=gta04-kernel.git;a=shortlog;h=refs/heads/work/hns/video/ov9655
+ * OV9655 registers sequence from STM32CubeF7 embedded software, see:
+ *   https://developer.mbed.org/teams/ST/code/BSP_DISCO_F746NG/file/e1d9da7fe856/Drivers/BSP/Components/ov9655/ov9655.c
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
@@ -58,14 +67,21 @@
 #define REG_PID			0x0a	/* Product ID MSB */
 #define REG_VER			0x0b	/* Product ID LSB */
 #define REG_COM3		0x0c
-#define  COM3_SWAP		0x40
+#define  COM3_COLORBAR		0x80
+#define  COM3_RGB565		0x00
+#define  COM3_SWAP		0x40	/* Doesn't work in RGB */
+#define  COM3_RESETB		0x08
 #define  COM3_VARIOPIXEL1	0x04
+#define  OV9655_SINGLEFRAME	0x01
 #define REG_COM4		0x0d	/* Vario Pixels  */
 #define  COM4_VARIOPIXEL2	0x80
+#define  OV9655_TRISTATE		/* seems to have a different function */
 #define REG_COM5		0x0e	/* System clock options */
 #define  COM5_SLAVE_MODE	0x10
-#define  COM5_SYSTEMCLOCK48MHZ	0x80
+#define  COM5_SYSTEMCLOCK48MHZ	0x80	/* not on OV9655 */
+#define  OV9655_EXPOSURESTEP	0x01
 #define REG_COM6		0x0f	/* HREF & ADBLC options */
+#define  COM6_BLC_OPTICAL	0x40	/* Optical black */
 #define REG_AECH		0x10	/* Exposure value, AEC[9:2] */
 #define REG_CLKRC		0x11	/* Clock control */
 #define  CLK_EXT		0x40	/* Use external clock directly */
@@ -74,13 +90,18 @@
 #define  COM7_RESET		0x80
 #define  COM7_FMT_MASK		0x38
 #define  COM7_FMT_VGA		0x40
-#define	 COM7_FMT_CIF		0x20
+#define  COM7_FMT_CIF		0x20
 #define  COM7_FMT_QVGA		0x10
 #define  COM7_FMT_QCIF		0x08
-#define	 COM7_RGB		0x04
-#define	 COM7_YUV		0x00
-#define	 COM7_BAYER		0x01
-#define	 COM7_PBAYER		0x05
+#define  COM7_RGB		0x04
+#define  COM7_YUV		0x00
+#define  COM7_BAYER		0x01
+#define  COM7_PBAYER		0x05
+#define  OV9655_COM7_VGA	0x60
+#define  OV9655_COM7_RAWRGB	0x00	/* different format encoding */
+#define  OV9655_COM7_RAWRGBINT	0x01
+#define  OV9655_COM7_YUV	0x02
+#define  OV9655_COM7_RGB	0x03
 #define REG_COM8		0x13	/* AGC/AEC options */
 #define  COM8_FASTAEC		0x80	/* Enable fast AGC/AEC */
 #define  COM8_AECSTEP		0x40	/* Unlimited AEC step size */
@@ -89,14 +110,23 @@
 #define  COM8_AWB		0x02	/* White balance enable */
 #define  COM8_AEC		0x01	/* Auto exposure enable */
 #define REG_COM9		0x14	/* Gain ceiling */
-#define  COM9_GAIN_CEIL_MASK	0x70	/* */
+#define  COM9_GAIN_CEIL_MASK	0x70
+#define  COM9_GAIN_CEIL_16X	0x30
+#define  OV9655_COM9_EXPTIMING	0x08
+#define  OV9655_COM9_VSYNCDROP	0x04
+#define  OV9655_COM9_AECDROP	0x02
 #define REG_COM10		0x15	/* PCLK, HREF, HSYNC signals polarity */
+#define  OV9655_SLAVE_PIN	0x80	/* SLHS/SLVS instead of RESETB/PWDN */
 #define  COM10_HSYNC		0x40	/* HSYNC instead of HREF */
 #define  COM10_PCLK_HB		0x20	/* Suppress PCLK on horiz blank */
-#define  COM10_HREF_REV		0x08	/* Reverse HREF */
+#define  OV9655_COM10_PCLK_REV		0x10	/* PCLK reverse */
+#define  COM10_HREF_REV	0x08	/* Reverse HREF */
 #define  COM10_VS_LEAD		0x04	/* VSYNC on clock leading edge */
+#define  OV9655_COM10_RESET_OPTION	0x04	/* Reset signal end point */
 #define  COM10_VS_NEG		0x02	/* VSYNC negative */
 #define  COM10_HS_NEG		0x01	/* HSYNC negative */
+#define OV9655_REG16		0x16	/* dummy frame and blanking */
+#define   OV9655_REG16_DUMMY_8	0x20	/* dummy frame when gain > 8 */
 #define REG_HSTART		0x17	/* Horiz start high bits */
 #define REG_HSTOP		0x18	/* Horiz stop high bits */
 #define REG_VSTART		0x19	/* Vert start high bits */
@@ -117,6 +147,7 @@
 #define REG_BBIAS		0x27	/* B channel output bias */
 #define REG_GBBIAS		0x28	/* Gb channel output bias */
 #define REG_GRCOM		0x29	/* Analog BLC & regulator */
+#define OV9655_PREGAIN		0x29
 #define REG_EXHCH		0x2a	/* Dummy pixel insert MSB */
 #define REG_EXHCL		0x2b	/* Dummy pixel insert LSB */
 #define REG_RBIAS		0x2c	/* R channel output bias */
@@ -127,12 +158,30 @@
 #define REG_HSYEN		0x31	/* HSYNC falling edge delay LSB*/
 #define REG_HREF		0x32	/* HREF pieces */
 #define REG_CHLF		0x33	/* reserved */
+#define OV9655_CLKF		0x33	/* Array current control */
+#define OV9655_AREF1		0x34	/* Array reference control */
+#define OV9655_AREF2		0x35	/* Array reference control */
+#define OV9655_AREF3		0x36	/* Array reference control */
 #define REG_ADC			0x37	/* reserved */
+#define OV9655_ADC		0x37	/* ADC Control 1 (Range adjustment) */
 #define REG_ACOM		0x38	/* reserved */
-#define REG_OFON		0x39	/* Power down register */
+#define OV9655_ADC2		0x38	/* ADC Control 2 (Range adjustment) */
+#define REG_OFON		0x39	/* Power down register (ov9650 only) */
 #define  OFON_PWRDN		0x08	/* Power down bit */
+#define OV9655_AREF4		0x39	/* Array reference control */
 #define REG_TSLB		0x3a	/* YUVU format */
+#define  OV9655_PCLKDELAY2NS	0x40
+#define  OV9655_PCLKDELAY4NS	0x80
+#define  OV9655_PCLKDELAY6NS	0xc0
+#define  OV9655_OUTREVERSE	0x20
+#define  OV9655_FIXEDUV	0x10
 #define  TSLB_YUYV_MASK		0x0c	/* UYVY or VYUY - see com13 */
+#define  TSLB_YUYV		0x00
+#define  TSLB_YVYU		0x04
+#define  TSLB_VYUY		0x08
+#define  TSLB_UYVY		0x0c
+#define  OV9655_BANDINGAUTO	0x02
+
 #define REG_COM11		0x3b	/* Night mode, banding filter enable */
 #define  COM11_NIGHT		0x80	/* Night mode enable */
 #define  COM11_NMFR		0x60	/* Two bit NM frame rate */
@@ -142,25 +191,38 @@
 #define  COM12_HREF		0x80	/* HREF always */
 #define REG_COM13		0x3d	/* Gamma selection, Color matrix en. */
 #define  COM13_GAMMA		0x80	/* Gamma enable */
-#define	 COM13_UVSAT		0x40	/* UV saturation auto adjustment */
+#define  COM13_UVSAT		0x40	/* UV saturation auto adjustment */
+#define  COM13_Y_DELAY		0x08	/* Delay Y channel */
 #define  COM13_UVSWAP		0x01	/* V before U - w/TSLB */
 #define REG_COM14		0x3e	/* Edge enhancement options */
 #define  COM14_EDGE_EN		0x02
 #define  COM14_EEF_X2		0x01
+#define OV9655_REG_COM14	0x3e	/* pixel correction/zoom ON/OFF sel. */
+#define  OV9655_COM14_BLACK_PIX	0x08	/* Black pixel correction */
+#define  OV9655_COM14_WHITE_PIX	0x04	/* White pixel correction */
+#define  OV9655_COM14_ZOOM	0x02	/* Zoom function ON */
 #define REG_EDGE		0x3f	/* Edge enhancement factor */
 #define  EDGE_FACTOR_MASK	0x0f
 #define REG_COM15		0x40	/* Output range, RGB 555/565 */
 #define  COM15_R10F0		0x00	/* Data range 10 to F0 */
-#define	 COM15_R01FE		0x80	/* 01 to FE */
+#define  COM15_R01FE		0x80	/* 01 to FE */
 #define  COM15_R00FF		0xc0	/* 00 to FF */
 #define  COM15_RGB565		0x10	/* RGB565 output */
 #define  COM15_RGB555		0x30	/* RGB555 output */
 #define  COM15_SWAPRB		0x04	/* Swap R&B */
 #define REG_COM16		0x41	/* Color matrix coeff options */
 #define REG_COM17		0x42	/* Single frame out, banding filter */
+#define OV9655_REG_COM17	0x42	/* Denoise, edge, auto gain, ... */
+#define   OV9655_COM17_EDGE_AUTO	0x40	/* Edge auto */
+#define   OV9655_COM17_DENOISE_AUTO	0x80	/* Denoise auto */
+#define OV9655_REG_RSVD(__n)	(0x43 + (__n) - 1) /* reserved but used... */
 /* n = 1...9, 0x4f..0x57 */
-#define	REG_MTX(__n)		(0x4f + (__n) - 1)
+#define REG_MTX(__n)		(0x4f + (__n) - 1)
 #define REG_MTXS		0x58
+#define REG_AWBOP(__n)		(0x59 + (__n) - 1) /* AWB control options */
+#define REG_BLMT		0x5F	/* AWB Blue Component Gain Limit */
+#define REG_RLMT		0x60	/* AWB Red Component Gain Limit */
+#define REG_GLMT		0x61	/* AWB Green Component Gain Limit */
 /* Lens Correction Option 1...5, __n = 0...5 */
 #define REG_LCC(__n)		(0x62 + (__n) - 1)
 #define  LCC5_LCC_ENABLE	0x01	/* LCC5, enable lens correction */
@@ -170,10 +232,26 @@
 #define REG_HV			0x69	/* Manual banding filter MSB */
 #define REG_MBD			0x6a	/* Manual banding filter value */
 #define REG_DBLV		0x6b	/* reserved */
+#define OV9655_REG_DBLV		0x6b	/* PLL, DVDD regu bypass, bandgap */
+#define  OV9655_DBLV_BANDGAP	0x0a	/* default value */
+#define  OV9655_DBLV_LDO_BYPASS	0x10
+#define  OV9655_DBLV_PLL_BYPASS	0x00
+#define  OV9655_DBLV_PLL_4X	0x40
+#define  OV9655_DBLV_PLL_6X	0x80
+#define  OV9655_DBLV_PLL_8X	0xc0
 #define REG_GSP			0x6c	/* Gamma curve */
 #define  GSP_LEN		15
+#define OV9655_REG_DNSTH	0x70	/* De-noise Function Threshold Adj. */
+#define OV9655_REG_POIDX	0x72	/* Pixel output index */
+#define OV9655_REG_PCKDV	0x73	/* Pixel Clock Output Selection */
+#define OV9655_REG_XINDX	0x74	/* Horizontal Scaling Down Coeff. */
+#define OV9655_REG_YINDX	0x75	/* Vertical Scaling Down Coeff. */
+#define OV9655_REG_SLOP		0x7A	/* Gamma Curve Highest Segment Slope */
+#define OV9655_REG_GAM(__n)	(0x7B + (__n) - 1)	/* Gamma curve */
 #define REG_GST			0x7c	/* Gamma curve */
 #define  GST_LEN		15
+#define OV9655_REG_COM18	0x8b	/* Zoom mode in VGA */
+#define OV9655_REG_COM19	0x8c	/* UV adjustment */
 #define REG_COM21		0x8b
 #define REG_COM22		0x8c	/* Edge enhancement, denoising */
 #define  COM22_WHTPCOR		0x02	/* White pixel correction enable */
@@ -181,6 +259,8 @@
 #define  COM22_DENOISE		0x10	/* White pixel correction option */
 #define REG_COM23		0x8d	/* Color bar test, color gain */
 #define  COM23_TEST_MODE	0x10
+#define OV9655_REG_COM20	0x8d
+#define  OV9655_COM20_TEST_MODE	0x10
 #define REG_DBLC1		0x8f	/* Digital BLC */
 #define REG_DBLC_B		0x90	/* Digital BLC B channel offset */
 #define REG_DBLC_R		0x91	/* Digital BLC R channel offset */
@@ -193,6 +273,17 @@
 #define REG_AECHM		0xa1	/* Exposure value - bits AEC[15:10] */
 #define REG_BD50ST		0xa2	/* Banding filter value for 50Hz */
 #define REG_BD60ST		0xa3	/* Banding filter value for 60Hz */
+#define OV9655_REG_COM21	0xa4	/* Digital gain */
+#define OV9655_REG_AWB_GREEN	0xa6	/* AWB green */
+#define OV9655_REG_REF_A8	0xa8	/* Analog Reference Control */
+#define OV9655_REG_REF_A9	0xa9	/* Analog Reference Control */
+#define OV9655_REG_BLC(__n)	(0xac + (__n) - 1) /* Black Level Control */
+#define OV9655_REG_CTRLB4	0xb4	/* UV adjustment */
+#define OV9655_REG_ADBOFF	0xbc	/* ADC B channel offset setting */
+#define OV9655_REG_ADROFF	0xbd	/* ADC R channel offset setting */
+#define OV9655_REG_ADGBOFF	0xbe	/* ADC Gb channel offset setting */
+#define OV9655_REG_ADGEOFF	0xbf	/* ADC Gr channel offset setting */
+#define OV9655_REG_COM24	0xc7	/* Pixel clock frequency selection */
 #define REG_NULL		0xff	/* Array end token */
 
 #define DEF_CLKRC		0x80
@@ -200,6 +291,7 @@
 #define OV965X_ID(_msb, _lsb)	((_msb) << 8 | (_lsb))
 #define OV9650_ID		0x9650
 #define OV9652_ID		0x9652
+#define OV9655V5_ID		0x9657
 
 struct ov965x_ctrls {
 	struct v4l2_ctrl_handler handler;
@@ -458,6 +550,291 @@ struct ov965x {
 	{{ 1,   25  }, { QVGA_WIDTH, QVGA_HEIGHT }, 1 },  /* 25 fps */
 };
 
+/* OV9655 */
+static const struct i2c_rv ov9655_init_regs[] = {
+	{ REG_GAIN, 0x00 },
+	{ REG_BLUE, 0x80 },
+	{ REG_RED, 0x80 },
+	{ REG_VREF, 0x02 },
+	{ REG_COM1, 0x03 },
+	{ REG_COM2, 0x01 },/* Output drive x2 */
+	{ REG_COM3, COM3_RGB565 },/* Output drive x2, RGB565 */
+	{ REG_COM5, 0x60 | OV9655_EXPOSURESTEP },/* 0x60 ? */
+	{ REG_COM6, COM6_BLC_OPTICAL },
+	{ REG_CLKRC, 0x01 },/* F(internal clk) = F(input clk) / 2 */
+	{ REG_COM7, OV9655_COM7_VGA | OV9655_COM7_YUV },
+	{ REG_COM8, COM8_FASTAEC | COM8_AECSTEP |
+			COM8_AGC | COM8_AWB | COM8_AEC },
+	{ REG_COM9, COM9_GAIN_CEIL_16X | OV9655_COM9_EXPTIMING |
+			OV9655_COM9_AECDROP },
+	{ OV9655_REG16, OV9655_REG16_DUMMY_8 | 0x4 },
+	{ REG_HSTART, 0x18 },
+	{ REG_HSTOP, 0x04 },
+	{ REG_VSTART, 0x01 },
+	{ REG_VSTOP, 0x81 },
+	{ REG_MVFP, 0x00 },/* No mirror/flip */
+	{ REG_AEW, 0x3c },
+	{ REG_AEB, 0x36 },
+	{ REG_VPT, 0x72 },
+	{ REG_BBIAS, 0x08 },
+	{ REG_GBBIAS, 0x08 },
+	{ OV9655_PREGAIN, 0x15 },
+	{ REG_EXHCH, 0x00 },
+	{ REG_EXHCL, 0x00 },
+	{ REG_RBIAS, 0x08 },
+	{ REG_HREF, 0x12 },/* QVGA */
+	{ REG_CHLF, 0x00 },
+	{ OV9655_AREF1, 0x3f },
+	{ OV9655_AREF2, 0x00 },
+	{ OV9655_AREF3, 0x3a },
+	{ OV9655_ADC2, 0x72 },
+	{ OV9655_AREF4, 0x57 },
+	{ REG_TSLB, OV9655_PCLKDELAY6NS | TSLB_UYVY },
+	{ REG_COM11, 0x04 },/* 0x04 ? */
+	{ REG_COM13, COM13_GAMMA | 0x10 |
+			COM13_Y_DELAY | COM13_UVSWAP },/* 0x10 ? */
+	{OV9655_REG_COM14, OV9655_COM14_ZOOM }, /* QVGA */
+	{ REG_EDGE, 0xc1 },
+	{ REG_COM15, COM15_R00FF },/* Full range output */
+	{ REG_COM16, 0x41 },/* 0x41 ? */
+	{ OV9655_REG_COM17, OV9655_COM17_EDGE_AUTO |
+			OV9655_COM17_DENOISE_AUTO },
+	{ OV9655_REG_RSVD(1), 0x0a },
+	{ OV9655_REG_RSVD(2), 0xf0 },
+	{ OV9655_REG_RSVD(3), 0x46 },
+	{ OV9655_REG_RSVD(4), 0x62 },
+	{ OV9655_REG_RSVD(5), 0x2a },
+	{ OV9655_REG_RSVD(6), 0x3c },
+	{ OV9655_REG_RSVD(7), 0xfc },
+	{ OV9655_REG_RSVD(8), 0xfc },
+	{ OV9655_REG_RSVD(9), 0x7f },
+	{ OV9655_REG_RSVD(10), 0x7f },
+	{ OV9655_REG_RSVD(11), 0x7f },
+	{ REG_MTX(1), 0x98 },
+	{ REG_MTX(2), 0x98 },
+	{ REG_MTX(3), 0x00 },
+	{ REG_MTX(4), 0x28 },
+	{ REG_MTX(5), 0x70 },
+	{ REG_MTX(6), 0x98 },
+	{ REG_MTXS, 0x1a },
+	{ REG_AWBOP(1), 0x85 },
+	{ REG_AWBOP(2), 0xa9 },
+	{ REG_AWBOP(3), 0x64 },
+	{ REG_AWBOP(4), 0x84 },
+	{ REG_AWBOP(5), 0x53 },
+	{ REG_AWBOP(6), 0x0e },
+	{ REG_BLMT, 0xf0 },
+	{ REG_RLMT, 0xf0 },
+	{ REG_GLMT, 0xf0 },
+	{ REG_LCC(1), 0x00 },
+	{ REG_LCC(2), 0x00 },
+	{ REG_LCC(3), 0x02 },
+	{ REG_LCC(4), 0x20 },
+	{ REG_LCC(5), 0x00 },
+	{ 0x69, 0x0a },/* Reserved... */
+	{ OV9655_REG_DBLV, OV9655_DBLV_PLL_4X | OV9655_DBLV_LDO_BYPASS |
+			OV9655_DBLV_BANDGAP },
+	{ 0x6c, 0x04 },/* Reserved... */
+	{ 0x6d, 0x55 },/* Reserved... */
+	{ 0x6e, 0x00 },/* Reserved... */
+	{ 0x6f, 0x9d },/* Reserved... */
+	{ OV9655_REG_DNSTH, 0x21 },
+	{ 0x71, 0x78 },/* Reserved... */
+	{ OV9655_REG_POIDX, 0x11 },/* QVGA */
+	{ OV9655_REG_PCKDV, 0x01 },/* QVGA */
+	{ OV9655_REG_XINDX, 0x10 },
+	{ OV9655_REG_YINDX, 0x10 },
+	{ 0x76, 0x01 },/* Reserved... */
+	{ 0x77, 0x02 },/* Reserved... */
+	{ 0x7A, 0x12 },/* Reserved... */
+	{ OV9655_REG_GAM(1), 0x08 },
+	{ OV9655_REG_GAM(2), 0x16 },
+	{ OV9655_REG_GAM(3), 0x30 },
+	{ OV9655_REG_GAM(4), 0x5e },
+	{ OV9655_REG_GAM(5), 0x72 },
+	{ OV9655_REG_GAM(6), 0x82 },
+	{ OV9655_REG_GAM(7), 0x8e },
+	{ OV9655_REG_GAM(8), 0x9a },
+	{ OV9655_REG_GAM(9), 0xa4 },
+	{ OV9655_REG_GAM(10), 0xac },
+	{ OV9655_REG_GAM(11), 0xb8 },
+	{ OV9655_REG_GAM(12), 0xc3 },
+	{ OV9655_REG_GAM(13), 0xd6 },
+	{ OV9655_REG_GAM(14), 0xe6 },
+	{ OV9655_REG_GAM(15), 0xf2 },
+	{ 0x8a, 0x24 },/* Reserved... */
+	{ OV9655_REG_COM19, 0x80 },
+	{ 0x90, 0x7d },/* Reserved... */
+	{ 0x91, 0x7b },/* Reserved... */
+	{ REG_LCCFB, 0x02 },
+	{ REG_LCCFR, 0x02 },
+	{ REG_DBLC_GB, 0x7a },
+	{ REG_DBLC_GR, 0x79 },
+	{ REG_AECHM, 0x40 },
+	{ OV9655_REG_COM21, 0x50 },
+	{ 0xa5, 0x68 },/* Reserved... */
+	{ OV9655_REG_AWB_GREEN, 0x4a },
+	{ OV9655_REG_REF_A8, 0xc1 },
+	{ OV9655_REG_REF_A9, 0xef },
+	{ 0xaa, 0x92 },/* Reserved... */
+	{ 0xab, 0x04 },/* Reserved... */
+	{ OV9655_REG_BLC(1), 0x80 },
+	{ OV9655_REG_BLC(2), 0x80 },
+	{ OV9655_REG_BLC(3), 0x80 },
+	{ OV9655_REG_BLC(4), 0x80 },
+	{ OV9655_REG_BLC(7), 0xf2 },
+	{ OV9655_REG_BLC(8), 0x20 },
+	{ OV9655_REG_CTRLB4, 0x20 },
+	{ 0xb5, 0x00 },/* Reserved... */
+	{ 0xb6, 0xaf },/* Reserved... */
+	{ 0xb6, 0xaf },/* Reserved... */
+	{ 0xbb, 0xae },/* Reserved... */
+	{ OV9655_REG_ADBOFF, 0x7f },
+	{ OV9655_REG_ADROFF, 0x7f },
+	{ OV9655_REG_ADGBOFF, 0x7f },
+	{ OV9655_REG_ADGEOFF, 0x7f },
+	{ OV9655_REG_ADGEOFF, 0x7f },
+	{ 0xc0, 0xaa },/* Reserved... */
+	{ 0xc1, 0xc0 },/* Reserved... */
+	{ 0xc2, 0x01 },/* Reserved... */
+	{ 0xc3, 0x4e },/* Reserved... */
+	{ 0xc6, 0x05 },/* Reserved... */
+	{ OV9655_REG_COM24, 0x81 },/* QVGA */
+	{ 0xc9, 0xe0 },/* Reserved... */
+	{ 0xca, 0xe8 },/* Reserved... */
+	{ 0xcb, 0xf0 },/* Reserved... */
+	{ 0xcc, 0xd8 },/* Reserved... */
+	{ 0xcd, 0x93 },/* Reserved... */
+	{ REG_COM7, OV9655_COM7_VGA | OV9655_COM7_RGB },
+	{ REG_COM15, COM15_RGB565 },
+	{ REG_NULL, 0}
+};
+
+static const struct i2c_rv ov9655_qvga_regs[] = {
+	{ REG_HREF, 0x12 },
+	{ OV9655_REG_COM14, OV9655_COM14_ZOOM },
+	{ OV9655_REG_POIDX, 0x11 },
+	{ OV9655_REG_PCKDV, 0x01 },
+	{ OV9655_REG_COM24, 0x81 },
+	{ REG_NULL, 0}
+};
+
+static const struct i2c_rv ov9655_qqvga_regs[] = {
+	{ REG_HREF, 0xa4 },
+	{ REG_COM14, OV9655_COM14_BLACK_PIX | OV9655_COM14_WHITE_PIX |
+			OV9655_COM14_ZOOM },
+	{ OV9655_REG_POIDX, 0x22 },
+	{ OV9655_REG_PCKDV, 0x02 },
+	{ OV9655_REG_COM24, 0x82 },
+	{ REG_NULL, 0}
+};
+
+static const struct i2c_rv ov9655_vga_regs[] = {
+	{ REG_GAIN, 0x11 },
+	{ REG_VREF, 0x12 },
+	{ REG_B_AVE, 0x2e },
+	{ REG_GB_AVE, 0x2e },
+	{ REG_GR_AVE, 0x2e },
+	{ REG_R_AVE, 0x2e },
+	{ REG_COM6, 0x48 },
+	{ REG_AECH, 0x7b },
+	{ REG_CLKRC, 0x03 },
+	{ REG_COM8, COM8_FASTAEC | COM8_AECSTEP | COM8_BFILT |
+			COM8_AGC | COM8_AWB | COM8_AEC },
+	{ REG_HSTART, 0x16 },
+	{ REG_HSTOP, 0x02 },
+	{ REG_VSTART, 0x01 },
+	{ REG_VSTOP, 0x3d },
+	{ REG_MVFP, 0x04 },
+	{ REG_YAVE, 0x2e },
+	{ REG_HREF, 0xff },
+	{ OV9655_AREF1, 0x3d },
+	{ OV9655_AREF3, 0xfa },
+	{ REG_TSLB, 0xcc },
+	{ REG_COM11, 0xcc },
+	{ REG_COM14, 0x0c },
+	{ REG_EDGE, 0x82 },
+	{ REG_COM15, COM15_R00FF | COM15_RGB565 },/* full range */
+	{ REG_COM16, 0x40 },
+	{ OV9655_REG_RSVD(1), 0x14 },
+	{ OV9655_REG_RSVD(2), 0xf0 },
+	{ OV9655_REG_RSVD(3), 0x46 },
+	{ OV9655_REG_RSVD(4), 0x62 },
+	{ OV9655_REG_RSVD(5), 0x2a },
+	{ OV9655_REG_RSVD(6), 0x3c },
+	{ OV9655_REG_RSVD(8), 0xe9 },
+	{ OV9655_REG_RSVD(9), 0xdd },
+	{ OV9655_REG_RSVD(10), 0xdd },
+	{ OV9655_REG_RSVD(11), 0xdd },
+	{ OV9655_REG_RSVD(12), 0xdd },
+	{ REG_LCC(1), 0x00 },
+	{ REG_LCC(2), 0x00 },
+	{ REG_LCC(3), 0x02 },
+	{ REG_LCC(4), 0x20 },
+	{ REG_LCC(5), 0x01 },
+	{ REG_GSP, 0x0c },
+	{ 0x6f, 0x9e },/* Reserved... */
+	{ OV9655_REG_DNSTH, 0x06 },
+	{ OV9655_REG_POIDX, 0x00 },
+	{ OV9655_REG_PCKDV, 0x00 },
+	{ OV9655_REG_XINDX, 0x3a },
+	{ OV9655_REG_YINDX, 0x35 },
+	{ OV9655_REG_SLOP, 0x20 },
+	{ OV9655_REG_GAM(1), 0x1c },
+	{ OV9655_REG_GAM(2), 0x28 },
+	{ OV9655_REG_GAM(3), 0x3c },
+	{ OV9655_REG_GAM(4), 0x5a },
+	{ OV9655_REG_GAM(5), 0x68 },
+	{ OV9655_REG_GAM(6), 0x76 },
+	{ OV9655_REG_GAM(7), 0x80 },
+	{ OV9655_REG_GAM(8), 0x88 },
+	{ OV9655_REG_GAM(9), 0x8f },
+	{ OV9655_REG_GAM(10), 0x96 },
+	{ OV9655_REG_GAM(11), 0xa3 },
+	{ OV9655_REG_GAM(12), 0xaf },
+	{ OV9655_REG_GAM(13), 0xc4 },
+	{ OV9655_REG_GAM(14), 0xd7 },
+	{ OV9655_REG_GAM(15), 0xe8 },
+	{ 0x8a, 0x23 },/* Reserved... */
+	{ OV9655_REG_COM19, 0x8d },
+	{ 0x90, 0x92 },/* Reserved... */
+	{ 0x91, 0x92 },/* Reserved... */
+	{ REG_DBLC_GB, 0x90 },
+	{ REG_DBLC_GR, 0x90 },
+	{ OV9655_REG_AWB_GREEN, 0x40 },
+	{ OV9655_REG_ADBOFF, 0x02 },
+	{ OV9655_REG_ADROFF, 0x01 },
+	{ OV9655_REG_ADGBOFF, 0x02 },
+	{ OV9655_REG_ADGEOFF, 0x01 },
+	{ 0xc1, 0xc8 },/* Reserved... */
+	{ 0xc6, 0x85 },/* Reserved... */
+	{ OV9655_REG_COM24, 0x80 },
+	{ REG_NULL, 0}
+};
+
+static const struct ov965x_framesize ov9655_framesizes[] = {
+	{
+		.width		= VGA_WIDTH,
+		.height		= VGA_HEIGHT,
+		.regs		= ov9655_vga_regs,
+		.max_exp_lines	= 498,
+	}, {
+		.width		= QVGA_WIDTH,
+		.height		= QVGA_HEIGHT,
+		.regs		= ov9655_qvga_regs,
+		.max_exp_lines	= 248,
+	}, {
+		.width		= QQVGA_WIDTH,
+		.height		= QQVGA_HEIGHT,
+		.regs		= ov9655_qqvga_regs,
+		.max_exp_lines	= 124,
+	},
+};
+
+static const struct ov965x_pixfmt ov9655_formats[] = {
+	{ MEDIA_BUS_FMT_RGB565_2X8_LE, V4L2_COLORSPACE_SRGB, 0x08},
+};
+
 static inline struct v4l2_subdev *ctrl_to_sd(struct v4l2_ctrl *ctrl)
 {
 	return &container_of(ctrl->handler, struct ov965x, ctrls.handler)->sd;
@@ -894,12 +1271,16 @@ static int ov965x_set_test_pattern(struct ov965x *ov965x, int value)
 {
 	int ret;
 	u8 reg;
+	u8 addr = (ov965x->id == OV9655V5_ID) ?
+			REG_COM3 : REG_COM23;
+	u8 mask = (ov965x->id == OV9655V5_ID) ?
+			COM3_COLORBAR : COM23_TEST_MODE;
 
-	ret = ov965x_read(ov965x->client, REG_COM23, &reg);
+	ret = ov965x_read(ov965x->client, addr, &reg);
 	if (ret < 0)
 		return ret;
-	reg = value ? reg | COM23_TEST_MODE : reg & ~COM23_TEST_MODE;
-	return ov965x_write(ov965x->client, REG_COM23, reg);
+	reg = value ? reg | mask : reg & ~mask;
+	return ov965x_write(ov965x->client, addr, reg);
 }
 
 static int __g_volatile_ctrl(struct ov965x *ov965x, struct v4l2_ctrl *ctrl)
@@ -1102,6 +1483,30 @@ static int ov965x_initialize_controls(struct ov965x *ov965x)
 	return 0;
 }
 
+static int ov9655_initialize_controls(struct ov965x *ov965x)
+{
+	const struct v4l2_ctrl_ops *ops = &ov965x_ctrl_ops;
+	struct ov965x_ctrls *ctrls = &ov965x->ctrls;
+	struct v4l2_ctrl_handler *hdl = &ctrls->handler;
+	int ret;
+
+	ret = v4l2_ctrl_handler_init(hdl, 16);
+	if (ret < 0)
+		return ret;
+
+	v4l2_ctrl_new_std_menu_items(hdl, ops, V4L2_CID_TEST_PATTERN,
+				     ARRAY_SIZE(test_pattern_menu) - 1, 0, 0,
+				     test_pattern_menu);
+	if (hdl->error) {
+		ret = hdl->error;
+		v4l2_ctrl_handler_free(hdl);
+		return ret;
+	}
+
+	ov965x->sd.ctrl_handler = hdl;
+	return 0;
+}
+
 /*
  * V4L2 subdev video and pad level operations
  */
@@ -1516,9 +1921,15 @@ static int ov965x_detect_sensor(struct v4l2_subdev *sd)
 
 	if (!ret) {
 		ov965x->id = OV965X_ID(pid, ver);
-		if (ov965x->id == OV9650_ID || ov965x->id == OV9652_ID) {
+		switch (ov965x->id) {
+		case OV9650_ID:
+		case OV9652_ID:
 			v4l2_info(sd, "Found OV%04X sensor\n", ov965x->id);
-		} else {
+			break;
+		case OV9655V5_ID:
+			v4l2_info(sd, "Found OV%04X sensor\n", ov965x->id - 2);
+			break;
+		default:
 			v4l2_err(sd, "Sensor detection failed (%04X, %d)\n",
 				 ov965x->id, ret);
 			ret = -ENODEV;
@@ -1595,18 +2006,28 @@ static int ov965x_probe(struct i2c_client *client,
 	if (ret < 0)
 		goto err_me;
 
-	ov965x->init_regs = ov965x_init_regs;
-	ov965x->initialize_controls = ov965x_initialize_controls;
-	ov965x->framesizes = ov965x_framesizes;
-	ov965x->nb_of_framesizes = ARRAY_SIZE(ov965x_framesizes);
-	ov965x->formats = ov965x_formats;
-	ov965x->nb_of_formats = ARRAY_SIZE(ov965x_formats);
-	ov965x->intervals = ov965x_intervals;
-	ov965x->nb_of_intervals = ARRAY_SIZE(ov965x_intervals);
-	ov965x->fiv = &ov965x_intervals[0];
-	ov965x->set_frame_interval = __ov965x_set_frame_interval;
-	ov965x->update_exposure_ctrl = ov965x_update_exposure_ctrl;
-	ov965x->set_params = __ov965x_set_params;
+	if (ov965x->id != OV9655V5_ID) {
+		ov965x->init_regs = ov965x_init_regs;
+		ov965x->initialize_controls = ov965x_initialize_controls;
+		ov965x->framesizes = ov965x_framesizes;
+		ov965x->nb_of_framesizes = ARRAY_SIZE(ov965x_framesizes);
+		ov965x->formats = ov965x_formats;
+		ov965x->nb_of_formats = ARRAY_SIZE(ov965x_formats);
+		ov965x->intervals = ov965x_intervals;
+		ov965x->nb_of_intervals = ARRAY_SIZE(ov965x_intervals);
+		ov965x->fiv = &ov965x_intervals[0];
+		ov965x->set_frame_interval = __ov965x_set_frame_interval;
+		ov965x->update_exposure_ctrl = ov965x_update_exposure_ctrl;
+		ov965x->set_params = __ov965x_set_params;
+	} else {
+		ov965x->init_regs = ov9655_init_regs;
+		ov965x->initialize_controls = ov9655_initialize_controls;
+		ov965x->framesizes = ov9655_framesizes;
+		ov965x->nb_of_framesizes = ARRAY_SIZE(ov9655_framesizes);
+		ov965x->formats = ov9655_formats;
+		ov965x->nb_of_formats = ARRAY_SIZE(ov9655_formats);
+		ov965x->set_params = ov965x_set_frame_size;
+	}
 
 	ov965x->frame_size = &ov965x->framesizes[0];
 	ov965x_get_default_format(ov965x, &ov965x->format);
@@ -1650,6 +2071,7 @@ static int ov965x_remove(struct i2c_client *client)
 static const struct i2c_device_id ov965x_id[] = {
 	{ "ov9650", 0 },
 	{ "ov9652", 0 },
+	{ "ov9655", 0 },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(i2c, ov965x_id);
@@ -1657,6 +2079,7 @@ static int ov965x_remove(struct i2c_client *client)
 static const struct of_device_id ov965x_of_match[] = {
 	{ .compatible = "ovti,ov9650", },
 	{ .compatible = "ovti,ov9652", },
+	{ .compatible = "ovti,ov9655", },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, ov965x_of_match);
@@ -1674,5 +2097,5 @@ static int ov965x_remove(struct i2c_client *client)
 module_i2c_driver(ov965x_i2c_driver);
 
 MODULE_AUTHOR("Sylwester Nawrocki <sylvester.nawrocki@gmail.com>");
-MODULE_DESCRIPTION("OV9650/OV9652 CMOS Image Sensor driver");
+MODULE_DESCRIPTION("OV9650/OV9652/OV9655 CMOS Image Sensor driver");
 MODULE_LICENSE("GPL");
-- 
1.9.1
