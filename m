Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.uni-paderborn.de ([131.234.142.9]:38774 "EHLO
	mail.uni-paderborn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbZDFO7q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Apr 2009 10:59:46 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH] Add ov9655 camera driver
Message-Id: <dcfc60e44b2c05b865fd.1239026767@SCT-Book>
Date: Mon, 06 Apr 2009 16:06:07 +0200
From: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a driver for the OmniVision ov9655 camera sensor.
The driver use the soc_camera framework.
It was tested on the BeBot robot with a PXA270 processor.

Signed-off-by: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
---

diff --git a/linux/drivers/media/video/Kconfig b/linux/drivers/media/video/Kconfig
--- a/linux/drivers/media/video/Kconfig
+++ b/linux/drivers/media/video/Kconfig
@@ -746,6 +746,12 @@ config SOC_CAMERA_OV772X
 	help
 	  This is a ov772x camera driver
 
+config SOC_CAMERA_OV9655
+	tristate "ov9655 camera support"
+	depends on SOC_CAMERA && I2C
+	help
+	  This driver supports OV9655 cameras from OmniVision
+
 config MX1_VIDEO
 	bool
 
diff --git a/linux/drivers/media/video/Makefile b/linux/drivers/media/video/Makefile
--- a/linux/drivers/media/video/Makefile
+++ b/linux/drivers/media/video/Makefile
@@ -145,6 +145,7 @@ obj-$(CONFIG_SOC_CAMERA_MT9T031)	+= mt9t
 obj-$(CONFIG_SOC_CAMERA_MT9T031)	+= mt9t031.o
 obj-$(CONFIG_SOC_CAMERA_MT9V022)	+= mt9v022.o
 obj-$(CONFIG_SOC_CAMERA_OV772X)		+= ov772x.o
+obj-$(CONFIG_SOC_CAMERA_OV9655)		+= ov9655.o
 obj-$(CONFIG_SOC_CAMERA_PLATFORM)	+= soc_camera_platform.o
 obj-$(CONFIG_SOC_CAMERA_TW9910)		+= tw9910.o
 
diff --git a/linux/drivers/media/video/ov9655.c b/linux/drivers/media/video/ov9655.c
new file mode 100644
--- /dev/null
+++ b/linux/drivers/media/video/ov9655.c
@@ -0,0 +1,1307 @@
+/*
+ * Driver for OV9655 CMOS Image Sensor from OmniVision
+ *
+ * Copyright (C) 2008 - 2009
+ * Heinz Nixdorf Institute - University of Paderborn
+ * Department of System and Circuit Technology
+ * Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
+ *
+ * Based on mt9t031 and soc_camera_platform driver
+ *
+ * Copyright (C) 2008, Guennadi Liakhovetski, DENX Software Engineering <lg@denx.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/videodev2.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/i2c.h>
+
+#include <media/v4l2-common.h>
+#include <media/v4l2-chip-ident.h>
+#include <media/soc_camera.h>
+
+/* ov9655 i2c address 0x30
+ * The platform has to define i2c_board_info
+ * and call i2c_register_board_info() */
+
+/* ov9655 register addresses */
+#define OV9655_GAIN			0x00
+#define OV9655_BLUE			0x01
+#define OV9655_RED			0x02
+#define OV9655_VREF			0x03
+#define OV9655_COM1			0x04
+#define OV9655_BAVE			0x05
+#define OV9655_GBAVE			0x06
+#define OV9655_GRAVE			0x07
+#define OV9655_RAVE			0x08
+#define OV9655_COM2			0x09
+	#define OV9655_COM2_SLEEP	0x10
+#define OV9655_PID			0x0A
+#define OV9655_VER			0x0B
+#define OV9655_COM3			0x0C
+	#define OV9655_COM3_SWAP	0x40
+#define OV9655_COM4			0x0D
+#define OV9655_COM5			0x0E
+#define OV9655_COM6			0x0F
+	#define OV9655_COM6_TIMING	0x02	
+	#define OV9655_COM6_WINDOW	0x04
+#define OV9655_AEC			0x10
+#define OV9655_CLKRC			0x11
+#define OV9655_COM7			0x12
+	#define OV9655_COM7_FMT_MASK	0x03
+	#define OV9655_COM7_RAW		0x00
+	#define OV9655_COM7_RAW_INT	0x01
+	#define OV9655_COM7_YUV		0x02
+	#define OV9655_COM7_RGB		0x03
+	#define OV9655_COM7_SXGA	0x00
+	#define OV9655_COM7_VGA		0x60
+#define OV9655_COM8			0x13
+	#define OV9655_COM8_AGC		0x04
+	#define OV9655_COM8_AWB		0x02
+	#define OV9655_COM8_AEC		0x01
+#define OV9655_COM9			0x14
+#define OV9655_COM10			0x15
+#define OV9655_REG16			0x16
+#define OV9655_HSTART			0x17
+#define OV9655_HSTOP			0x18
+#define OV9655_VSTART			0x19
+#define OV9655_VSTOP			0x1A
+#define OV9655_PSHFT			0x1B
+#define OV9655_MIDH			0x1C
+#define OV9655_MIDL			0x1D
+#define OV9655_MVFP			0x1E
+	#define OV9655_MVFP_VFLIP	0x10
+	#define OV9655_MVFP_MIRROR	0x20
+#define OV9655_LAEC			0x1F
+#define OV9655_BOS			0x20
+#define OV9655_GBOS			0x21
+#define OV9655_GROS			0x22
+#define OV9655_ROS			0x23
+#define OV9655_AEW			0x24
+#define OV9655_AEB			0x25
+#define OV9655_VPT			0x26
+#define OV9655_BBIAS			0x27
+#define OV9655_GBBIAS			0x28
+#define OV9655_PREGAIN			0x29
+#define OV9655_EXHCH			0x2A
+#define OV9655_EXHCL			0x2B
+#define OV9655_RBIAS			0x2C
+#define OV9655_ADVFL			0x2D
+#define OV9655_ADVFH			0x2E
+#define OV9655_YAVE			0x2F
+#define OV9655_HSYST			0x30
+#define OV9655_HSYEN			0x31
+#define OV9655_HREF			0x32
+#define OV9655_CHLF			0x33
+#define OV9655_AREF1			0x34
+#define OV9655_AREF2			0x35
+#define OV9655_AREF3			0x36
+#define OV9655_ADC1			0x37
+#define OV9655_ADC2			0x38
+#define OV9655_AREF4			0x39
+#define OV9655_TSLB			0x3A
+	#define OV9655_TSLB_YUV_MASK	0x0C
+	#define OV9655_TSLB_YUYV	0x00
+	#define OV9655_TSLB_YVYU	0x04
+	#define OV9655_TSLB_VYUY	0x08
+	#define OV9655_TSLB_UYVY	0x0C
+#define OV9655_COM11			0x3B
+#define OV9655_COM12			0x3C
+#define OV9655_COM13			0x3D
+#define OV9655_COM14			0x3E
+	#define OV9655_COM14_ZOOM	0x02
+#define OV9655_EDGE			0x3F
+#define OV9655_COM15			0x40
+	#define OV9655_COM15_RGB	0x00
+	#define OV9655_COM15_RGB565	0x10
+	#define OV9655_COM15_RGB555	0x30
+#define OV9655_COM16			0x41
+	#define OV9655_COM16_SCALING	0x01
+#define OV9655_COM17			0x42
+#define OV9655_MTX1			0x4F
+#define OV9655_MTX2			0x50
+#define OV9655_MTX3			0x51
+#define OV9655_MTX4			0x52
+#define OV9655_MTX5			0x53
+#define OV9655_MTX6			0x54
+#define OV9655_BRTN			0x55
+#define OV9655_CNST1			0x56
+#define OV9655_CNST2			0x57
+#define OV9655_MTXS			0x58
+#define OV9655_AWBOP1			0x59
+#define OV9655_AWBOP2			0x5A
+#define OV9655_AWBOP3			0x5B
+#define OV9655_AWBOP4			0x5C
+#define OV9655_AWBOP5			0x5D
+#define OV9655_AWBOP6			0x5E
+#define OV9655_BLMT			0x5F
+#define OV9655_RLMT			0x60
+#define OV9655_GLMT			0x61
+#define OV9655_LCC1			0x62
+#define OV9655_LCC2			0x63
+#define OV9655_LCC3			0x64
+#define OV9655_LCC4			0x65
+#define OV9655_LCC5			0x66
+#define OV9655_MANU			0x67
+#define OV9655_MANV			0x68
+#define OV9655_BD50MAX			0x6A
+#define OV9655_DBLV			0x6B
+#define OV9655_DNSTH			0x70
+#define OV9655_POIDX			0x72
+	#define OV9655_POIDX_VDROP	0x40
+#define OV9655_PCKDV			0x73
+#define OV9655_XINDX			0x74
+#define OV9655_YINDX			0x75
+#define OV9655_SLOP			0x7A
+#define OV9655_GAM1			0x7B
+#define OV9655_GAM2			0x7C
+#define OV9655_GAM3			0x7D
+#define OV9655_GAM4			0x7E
+#define OV9655_GAM5			0x7F
+#define OV9655_GAM6			0x80
+#define OV9655_GAM7			0x81
+#define OV9655_GAM8			0x82
+#define OV9655_GAM9			0x83
+#define OV9655_GAM10			0x84
+#define OV9655_GAM11			0x85
+#define OV9655_GAM12			0x86
+#define OV9655_GAM13			0x87
+#define OV9655_GAM14			0x88
+#define OV9655_GAM15			0x89
+#define OV9655_COM18			0x8B
+#define OV9655_COM19			0x8C
+#define OV9655_COM20			0x8D
+#define OV9655_DMLNL			0x92
+#define OV9655_DMNLH			0x93
+#define OV9655_LCC6			0x9D
+#define OV9655_LCC7			0x9E
+#define OV9655_AECH			0xA1
+#define OV9655_BD50			0xA2
+#define OV9655_BD60			0xA3
+#define OV9655_COM21			0xA4
+#define OV9655_GREEN			0xA6
+#define OV9655_VZST			0xA7
+#define OV9655_REFA8			0xA8
+#define OV9655_REFA9			0xA9
+#define OV9655_BLC1			0xAC
+#define OV9655_BLC2			0xAD
+#define OV9655_BLC3			0xAE
+#define OV9655_BLC4			0xAF
+#define OV9655_BLC5			0xB0
+#define OV9655_BLC6			0xB1
+#define OV9655_BLC7			0xB2
+#define OV9655_BLC8			0xB3
+#define OV9655_CTRLB4			0xB4
+#define OV9655_FRSTL			0xB7
+#define OV9655_FRSTH			0xB8
+#define OV9655_ADBOFF			0xBC
+#define OV9655_ADROFF			0xBD
+#define OV9655_ADGBOFF			0xBE
+#define OV9655_ADGROFF			0xBF
+#define OV9655_COM23			0xC4
+#define OV9655_BD60MAX			0xC5
+#define OV9655_COM24			0xC7
+
+#define OV9655_WIDTH_MAX		1280
+#define OV9655_WIDTH_MIN		2
+#define OV9655_HEIGHT_MAX		1024
+#define OV9655_HEIGHT_MIN		2
+#define OV9655_HSTART_MIN		244
+#define OV9655_VSTART_MIN		11
+#define OV9655_TOP_SKIP			1
+
+struct regval {
+	u8 reg;
+	u8 value;
+};
+
+#define ENDMARKER { 0xff, 0xff }
+
+static struct regval ov9655_init_regs[] = {
+	{ OV9655_GAIN, 0x00 },
+	{ OV9655_BLUE, 0x80 },
+	{ OV9655_RED, 0x80 },
+	{ OV9655_VREF, 0x1b },
+	{ OV9655_COM1, 0x03 },
+	{ OV9655_COM5, 0x61 },
+	{ OV9655_COM6, 0x40 }, /* manually update window size and timing */
+	{ OV9655_CLKRC, 0x03 },
+	{ OV9655_COM7, 0x02 },
+	{ OV9655_COM8, 0xe7 },
+	{ OV9655_COM9, 0x2a },
+	{ OV9655_REG16, 0x24 },
+	{ OV9655_HSTART, 0x1d },
+	{ OV9655_HSTOP, 0xbd },
+	{ OV9655_VSTART, 0x01 },
+	{ OV9655_VSTOP, 0x81 },
+	{ OV9655_MVFP, 0x00 },
+	{ OV9655_AEW, 0x3c },
+	{ OV9655_AEB, 0x36 },
+	{ OV9655_VPT, 0x72 },
+	{ OV9655_BBIAS, 0x08 },
+	{ OV9655_GBBIAS, 0x08 },
+	{ OV9655_PREGAIN, 0x15 },
+	{ OV9655_EXHCH, 0x00 },
+	{ OV9655_EXHCL, 0x00 },
+	{ OV9655_RBIAS, 0x08 },
+	{ OV9655_HREF, 0x3f },
+	{ OV9655_CHLF, 0x00 },
+	{ OV9655_AREF2, 0x00 },
+	{ OV9655_ADC2, 0x72 },
+	{ OV9655_AREF4, 0x57 },
+	{ OV9655_TSLB, 0x80 },
+	{ OV9655_COM11, 0xcc }, // was 0xa4; 0x05 disable night mode
+	{ OV9655_COM13, 0x99 },
+	{ OV9655_COM14, 0x0c },
+	{ OV9655_EDGE, 0x82 }, // was 0xc1
+	{ OV9655_COM15, 0xc0 },
+	{ OV9655_COM16, 0x00 },
+	{ OV9655_COM17, 0xc1 }, // 0x00 diable banding filter
+	{ 0x43, 0x0a },
+	{ 0x44, 0xf0 },
+	{ 0x45, 0x46 },
+	{ 0x46, 0x62 },
+	{ 0x47, 0x2a },
+	{ 0x48, 0x3c },
+	{ 0x4a, 0xfc },
+	{ 0x4b, 0xfc },
+	{ 0x4c, 0x7f },
+	{ 0x4d, 0x7f },
+	{ 0x4e, 0x7f },
+	{ OV9655_AWBOP1, 0x85 },
+	{ OV9655_AWBOP2, 0xa9 },
+	{ OV9655_AWBOP3, 0x64 },
+	{ OV9655_AWBOP4, 0x84 },
+	{ OV9655_AWBOP5, 0x53 },
+	{ OV9655_AWBOP6, 0x0e },
+	{ OV9655_BLMT, 0xf0 },
+	{ OV9655_RLMT, 0xf0 },
+	{ OV9655_GLMT, 0xf0 },
+	{ OV9655_LCC1, 0x00 },
+	{ OV9655_LCC2, 0x00 },
+	{ OV9655_LCC3, 0x02 },
+	{ OV9655_DBLV, 0xda }, // 4x PLL	// // 0x5a
+	{ 0x6c, 0x04 },
+	{ 0x6d, 0x55 },
+	{ 0x6e, 0x00 },
+	{ 0x6f, 0x9d },
+	{ OV9655_DNSTH, 0x21 },
+	{ 0x71, 0x78 },
+	{ 0x77, 0x02 },
+	{ OV9655_SLOP, 0x12 },
+	{ OV9655_GAM1, 0x08 },
+/*	{ OV9655_GAM2, 0x15 },
+	{ OV9655_GAM3, 0x24 },
+	{ OV9655_GAM4, 0x45 },
+	{ OV9655_GAM5, 0x55 },
+	{ OV9655_GAM6, 0x6a },
+	{ OV9655_GAM7, 0x78 },
+	{ OV9655_GAM8, 0x87 },
+	{ OV9655_GAM9, 0x96 },
+	{ OV9655_GAM10, 0xa3 },
+	{ OV9655_GAM11, 0xb4 },
+*/	{ OV9655_GAM2, 0x16 },
+	{ OV9655_GAM3, 0x30 },
+	{ OV9655_GAM4, 0x5e },
+	{ OV9655_GAM5, 0x72 },
+	{ OV9655_GAM6, 0x82 },
+	{ OV9655_GAM7, 0x8e },
+	{ OV9655_GAM8, 0x9a },
+	{ OV9655_GAM9, 0xa4 },
+	{ OV9655_GAM10, 0xac },
+	{ OV9655_GAM11, 0xb8 },
+	{ OV9655_GAM12, 0xc3 },
+	{ OV9655_GAM13, 0xd6 },
+	{ OV9655_GAM14, 0xe6 },
+	{ OV9655_GAM15, 0xf2 },
+	{ 0x8a, 0x03 },
+	{ 0x90, 0x7d },
+	{ 0x91, 0x7b },
+	{ OV9655_LCC6, 0x03 },
+	{ 0x9f, 0x7a },
+	{ 0xa0, 0x79 },
+	{ OV9655_AECH, 0x40 },
+	{ OV9655_COM21, 0x50 },
+	{ 0xa5,0x68 },
+	{ OV9655_GREEN, 0x4a },
+	{ OV9655_REFA8, 0xc1 },
+	{ OV9655_REFA9, 0xef },
+	{ 0xaa, 0x92 },
+	{ 0xab, 0x04 },
+	{ OV9655_BLC1, 0x80 },
+	{ OV9655_BLC2, 0x80 },
+	{ OV9655_BLC3, 0x80 },
+	{ OV9655_BLC4, 0x80 },
+	{ OV9655_BLC7, 0xf2 },
+	{ OV9655_BLC8, 0x20 },
+	{ OV9655_CTRLB4, 0x20 }, // was 0x22
+	{ 0xb5, 0x00 },
+	{ 0xb6, 0xaf },
+	{ 0xbb, 0xae },
+	{ OV9655_ADBOFF, 0x7f },
+	{ OV9655_ADROFF, 0x7f },
+	{ OV9655_ADGBOFF, 0x7f },
+	{ OV9655_ADGROFF, 0x7f },
+	{ 0xc1, 0xc0 },
+	{ 0xc2, 0x01 },
+	{ 0xc3, 0x4e },
+	{ 0xc6, 0x85 }, // 0x05 ?  was 0x85
+	{ OV9655_COM24, 0x80 },
+	{ 0xc9, 0xe0 },
+	{ 0xca, 0xe8 },
+	{ 0xcb, 0xf0 },
+	{ 0xcc, 0xd8 },
+	{ 0xcd, 0x93 },
+	/* without VarioPixel */
+	{ OV9655_AREF1, 0x3d },
+	{ OV9655_AREF3, 0x34 /* 0xf8 */ },
+	{ OV9655_LCC4, 0x16 },
+	{ OV9655_LCC5, 0x01 },
+	{ 0x69, 0x02 },
+	{ OV9655_COM19, 0x0d }, // 0x09
+	{ OV9655_COM20, 0x03 },
+	{ OV9655_LCC7, 0x04 },
+	{ 0xc0, 0xe2 },
+	{ OV9655_BD50MAX, 0x05 },
+	{ OV9655_BD50, 0x9d },
+	{ OV9655_BD60, 0x83 },
+	{ OV9655_BD60MAX, 0x07 },
+	{ 0x76, 0x01 },
+	ENDMARKER,
+};
+
+/* Register values for YUV format */
+static struct regval ov9655_yuv_regs[] = {
+	{ OV9655_MTX1, 0x80 },
+	{ OV9655_MTX2, 0x80 },
+	{ OV9655_MTX3, 0x00 },
+	{ OV9655_MTX4, 0x22 },
+	{ OV9655_MTX5, 0x5e },
+	{ OV9655_MTX6, 0x80 },
+	{ OV9655_MTXS, 0x1e },
+	ENDMARKER,
+};
+
+struct ov9655 {
+	struct i2c_client *client;
+	struct soc_camera_device icd;
+	unsigned char hskip, vskip;
+};
+
+/*
+ * supported format list
+ */
+
+#define SETFOURCC(type) .name = (#type), .fourcc = (V4L2_PIX_FMT_##type)
+
+static const struct soc_camera_data_format ov9655_formats[] = {
+	{
+		SETFOURCC(YUYV),
+		.depth		= 16,
+		.colorspace	= V4L2_COLORSPACE_JPEG,
+	}, {
+		SETFOURCC(YVYU),
+		.depth		= 16,
+		.colorspace	= V4L2_COLORSPACE_JPEG,
+	}, {
+		SETFOURCC(UYVY),
+		.depth		= 16,
+		.colorspace	= V4L2_COLORSPACE_JPEG,
+	}, {
+		SETFOURCC(VYUY),
+		.depth		= 16,
+		.colorspace	= V4L2_COLORSPACE_JPEG,
+	}, {
+		SETFOURCC(RGB555),
+		.depth      = 16,
+		.colorspace = V4L2_COLORSPACE_SRGB,
+	}, {
+		SETFOURCC(RGB555X),
+		.depth      = 16,
+		.colorspace = V4L2_COLORSPACE_SRGB,
+	}, {
+		SETFOURCC(RGB565),
+		.depth      = 16,
+		.colorspace = V4L2_COLORSPACE_SRGB,
+	}, {
+		SETFOURCC(RGB565X),
+		.depth      = 16,
+		.colorspace = V4L2_COLORSPACE_SRGB,
+	}
+};
+
+static int inline ov9655_read(struct soc_camera_device *icd, const u8 reg)
+{
+	struct ov9655 *ov9655 = container_of(icd, struct ov9655, icd);
+	return i2c_smbus_read_byte_data(ov9655->client, reg);
+}
+
+static int inline ov9655_write(struct soc_camera_device *icd, const u8 reg,
+			       const u8 value)
+{
+	struct ov9655 *ov9655 = container_of(icd, struct ov9655, icd);
+	return i2c_smbus_write_byte_data(ov9655->client, reg, value);
+}
+
+static int inline ov9655_write_mask(struct soc_camera_device *icd, const u8 reg,
+				    const u8 value, const u8 mask)
+{
+	int ret = 0;
+
+	if (mask != 0xff)
+		ret = ov9655_read(icd, reg);
+	if (ret >= 0)
+		ret = ov9655_write(icd, reg, (ret & ~mask) | (value & mask));
+
+	return ret;
+}
+
+static int ov9655_write_array(struct soc_camera_device *icd, struct regval *rv)
+{
+	int ret;
+
+	if (rv == NULL)
+		return 0;
+
+	while (rv->reg != 0xff || rv->value != 0xff) {
+		ret = ov9655_write(icd, rv->reg, rv->value);
+		if (ret < 0)
+			return ret;
+		rv++;
+	}
+	return 0;
+}
+
+
+/* Interface active, can use i2c. If it fails, it can indeed mean, that
+ * this wasn't our capture interface, so, we wait for the right one */
+static int ov9655_video_probe(struct soc_camera_device *icd)
+{
+	struct ov9655 *ov9655 = container_of(icd, struct ov9655, icd);
+	s32 midh, midl, pid, ver;
+	int ret = 0;
+
+	if (!icd->dev.parent ||
+	    to_soc_camera_host(icd->dev.parent)->nr != icd->iface)
+		return -ENODEV;
+
+	/* Read chip manufacturer register */
+	if ((midh = ov9655_read(icd, OV9655_MIDH)) < 0
+	    || (midl = ov9655_read(icd, OV9655_MIDL)) < 0) {
+		dev_err(&icd->dev, "Strange error reading sensor"
+			" manufacturer\n");
+		return -ENODEV;
+	}
+
+	if (midh != 0x7f || midl != 0xa2) {
+		dev_err(&icd->dev, "No OmniVision sensor detected, manufacturer"
+			" register read 0x %i %i\n", midh, midl);
+		return -ENODEV;
+	}
+
+	/* Read chip product register */
+	pid = ov9655_read(icd, OV9655_PID);
+
+	if (pid != 0x96) {
+		dev_info(&icd->dev, "No OmniVision OV9655 sensor detected,"
+			 " product register read 0x%x\n", pid);
+		return -ENODEV;
+	}
+
+	/* Read out the chip version register */
+	ver = ov9655_read(icd, OV9655_VER);
+
+	switch (ver) {
+	case 0x56:
+	case 0x57:
+		icd->formats = ov9655_formats;
+		icd->num_formats = ARRAY_SIZE(ov9655_formats);
+		break;
+	default:
+		dev_err(&icd->dev, "No OmniVision OV9655 sensor detected,"
+			" version register read 0x%x\n", ver);
+		return -ENODEV;
+	}
+
+	ret = soc_camera_video_start(icd);
+	if (ret < 0)
+		return ret;
+
+	dev_info(&icd->dev, "Detected a OmniVision (0x%02x%02x) OV9655 sensor,"
+		 " id 0x%02x%02x at adress %x without VarioPixel\n",
+		 midh, midl, pid, ver, ov9655->client->addr);
+
+	return 0;
+}
+
+static void ov9655_video_remove(struct soc_camera_device *icd)
+{
+	soc_camera_video_stop(icd);
+}
+
+static int ov9655_init(struct soc_camera_device *icd)
+{
+	struct ov9655 *ov9655 = container_of(icd, struct ov9655, icd);
+	struct soc_camera_link *icl = ov9655->client->dev.platform_data;
+	int ret = 0;
+
+	/* Enable the camera chip */
+	if (icl->power) {
+		ret = icl->power(&ov9655->client->dev, 1);
+		if (ret < 0) {
+			dev_err(icd->vdev->parent,
+				"Platform failed to power-on the camera.\n");
+			return ret;
+		}
+	}
+
+	/*  Reset all registers to default values */
+	if (icl->reset)
+		ret = icl->reset(&ov9655->client->dev);
+	else
+		ret = -ENODEV;
+
+	if (ret < 0) {
+		/* Either no platform reset, or platform reset failed */
+		ret = ov9655_write(icd, OV9655_COM7, 0x80);
+		mdelay(10);
+	}
+
+	/*  Set registers to init values */
+	if (ret >= 0)
+		ov9655_write_array(icd, ov9655_init_regs);
+
+	if (ret >= 0)
+		ov9655_write_array(icd, ov9655_yuv_regs);
+
+	/* Disable the chip output */
+	if (ret >= 0)
+		ov9655_write_mask(icd, OV9655_COM2, OV9655_COM2_SLEEP,
+				  OV9655_COM2_SLEEP);
+
+	return ret >= 0 ? 0 : -EIO;
+}
+
+static int ov9655_release(struct soc_camera_device *icd)
+{
+	struct ov9655 *ov9655 = container_of(icd, struct ov9655, icd);
+	struct soc_camera_link *icl = ov9655->client->dev.platform_data;
+
+	/* Disable the chip */
+	ov9655_write_mask(icd, OV9655_COM2, OV9655_COM2_SLEEP,
+			  OV9655_COM2_SLEEP);
+
+	if (icl->power)
+		icl->power(&ov9655->client->dev, 0);
+
+	return 0;
+}
+
+static int ov9655_start_capture(struct soc_camera_device *icd)
+{
+	/* Enable the chip output */
+	ov9655_write_mask(icd, OV9655_COM2, 0, OV9655_COM2_SLEEP);
+	return 0;
+}
+
+static int ov9655_stop_capture(struct soc_camera_device *icd)
+{
+	/* Disable the chip output */
+	ov9655_write_mask(icd, OV9655_COM2, OV9655_COM2_SLEEP,
+			  OV9655_COM2_SLEEP);
+	return 0;
+}
+
+static int ov9655_try_fmt(struct soc_camera_device *icd,
+			  struct v4l2_format *f)
+{
+	if (f->fmt.pix.height < OV9655_HEIGHT_MIN)
+		f->fmt.pix.height = OV9655_HEIGHT_MIN;
+	if (f->fmt.pix.height > OV9655_HEIGHT_MAX)
+		f->fmt.pix.height = OV9655_HEIGHT_MAX;
+
+	if (f->fmt.pix.width < OV9655_WIDTH_MIN)
+		f->fmt.pix.width = OV9655_WIDTH_MIN;
+	if (f->fmt.pix.width > OV9655_WIDTH_MAX)
+		f->fmt.pix.width = OV9655_WIDTH_MAX;
+
+	f->fmt.pix.width &= ~0x01; /* has to be even */
+	f->fmt.pix.height &= ~0x01; /* has to be even */	
+
+	return 0;
+}
+
+static int ov9655_set_crop(struct soc_camera_device *icd,
+			   struct v4l2_rect *rect)
+{
+	struct ov9655 *ov9655 = container_of(icd, struct ov9655, icd);
+	unsigned short hstart, hstop, vstart, vstop;
+	int ret;
+
+	dev_err(&icd->dev, "set_crop: left: %u, width: %u, top: %u, height: %u\n",
+		rect->left, rect->width, rect->top, rect->height);
+
+	/* Make sure we don't exceed sensor limits */
+	if (rect->width > icd->width_max)
+		rect->width = icd->width_max;
+
+	if (rect->height > icd->height_max)
+		rect->height = icd->height_max;
+
+	if (rect->left + rect->width > icd->width_max)
+		rect->left = icd->width_max - rect->width;
+
+	if (rect->top + rect->height > icd->height_max)
+		rect->top = icd->height_max - rect->height;
+
+	hstart = OV9655_HSTART_MIN + (rect->left * ov9655->hskip);
+	hstop = hstart + (rect->width * ov9655->hskip);
+	vstart = OV9655_VSTART_MIN + (rect->top * ov9655->vskip);
+	vstop = vstart + (rect->height * ov9655->vskip) +
+		(icd->y_skip_top * ov9655->vskip);
+
+	dev_err(&icd->dev, "hstart %u, hstop %u, vstart %u, vstop %u, "
+		"size %ux%u/%ux%u\n",
+		hstart, hstop, vstart, vstop, hstop - hstart, vstop - vstart,
+		rect->width, rect->height);
+
+	/*
+ 	* Horizontal: 11 bits, top 8 live in hstart and hstop.  Bottom 3 of
+ 	* hstart are in href[2:0], bottom 3 of hstop in href[5:3].  There is
+ 	* a mystery "edge offset" value in the top two bits of href.
+ 	*
+ 	* HSTOP values above 1520 don't work. Truncate with 1520 works!
+ 	*/
+	ret =  ov9655_write(icd, OV9655_HSTART, (hstart >> 3) & 0xff);
+	if (ret >= 0)
+		ret = ov9655_write(icd, OV9655_HSTOP, ((hstop % 1520) >> 3) & 0xff);
+	if (ret >= 0)
+		ret = ov9655_write_mask(icd, OV9655_HREF,
+					((hstop & 0x7) << 3) | (hstart & 0x7), 0x3f);
+
+	/*
+	 * Vertical: similar arrangement
+	 */
+	ret =  ov9655_write(icd, OV9655_VSTART, (vstart >> 3) & 0xff);
+	if (ret >= 0)
+		ret = ov9655_write(icd, OV9655_VSTOP, (vstop >> 3) & 0xff);
+	if (ret >= 0)
+		ret = ov9655_write_mask(icd, OV9655_VREF,
+					((vstop & 0x7) << 3) | (vstart & 0x7), 0x3f);
+
+	return (ret < 0) ? ret : 0;
+}
+
+static int ov9655_set_fmt(struct soc_camera_device *icd,
+			  struct v4l2_format *f)
+{
+	struct ov9655 *ov9655 = container_of(icd, struct ov9655, icd);
+	struct regval *fmt_rv = NULL;
+	unsigned char format = 0xff;
+	unsigned char sequence = 0xff;
+	unsigned char hpoidx, vpoidx, zoom, scaling;
+	struct regval frm_rv[] = {
+		{ OV9655_POIDX, 0x00 },
+		{ OV9655_PCKDV, 0x01 },
+		{ OV9655_XINDX, 0x3a },
+		{ OV9655_YINDX, 0x35 },
+		{ OV9655_COM24, 0x80 },
+		ENDMARKER,
+	};
+	unsigned char *poidx = &frm_rv[0].value;
+	unsigned char *pckdv = &frm_rv[1].value;
+	unsigned char *xindx = &frm_rv[2].value;
+	unsigned char *yindx = &frm_rv[3].value;
+	unsigned char *com24 = &frm_rv[4].value;
+	int ret = 0;
+
+	struct v4l2_rect rect = {
+		.left	= 0,
+		.top	= 0,
+		.width	= f->fmt.pix.width,
+		.height	= f->fmt.pix.height,
+	};
+
+	dev_err(&icd->dev, "set_fmt\n");
+
+	/* pixel format specific values */
+	switch (f->fmt.pix.pixelformat) {
+	case V4L2_PIX_FMT_SBGGR8:
+		format = OV9655_COM7_RAW;
+		break;
+	case V4L2_PIX_FMT_UYVY:
+		format = OV9655_COM7_YUV;
+		sequence = OV9655_TSLB_UYVY;
+		fmt_rv = ov9655_yuv_regs;
+		break;
+	case V4L2_PIX_FMT_VYUY:
+		format = OV9655_COM7_YUV;
+		sequence |= OV9655_TSLB_VYUY;
+		fmt_rv = ov9655_yuv_regs;
+		break;
+	case V4L2_PIX_FMT_YUYV:
+		format = OV9655_COM7_YUV;
+		sequence = OV9655_TSLB_YUYV;
+		fmt_rv = ov9655_yuv_regs;
+		break;
+	case V4L2_PIX_FMT_YVYU:
+		format = OV9655_COM7_YUV;
+		sequence |= OV9655_TSLB_YVYU;
+		fmt_rv = ov9655_yuv_regs;
+		break;
+	case 0:
+		/* No format change, only geometry */
+		break;
+	default:
+		dev_err(&icd->dev, "Unsupported colorspace %x\n", f->fmt.pix.pixelformat);
+		return -EINVAL;
+	}
+
+	/* pixel format */
+	if (f->fmt.pix.pixelformat)
+		ret = ov9655_write_mask(icd, OV9655_COM7, format,
+					OV9655_COM7_FMT_MASK);
+	msleep(50);
+
+	/* YUV output sequence */
+	if (ret >= 0 && sequence != 0xff)
+		ret = ov9655_write_mask(icd, OV9655_TSLB, sequence,
+					OV9655_TSLB_YUV_MASK);
+		
+	/* pixel format specific registers */
+	if (ret >= 0 && fmt_rv)
+		ret = ov9655_write_array(icd, fmt_rv);
+
+	for (hpoidx = 3; hpoidx > 0; hpoidx--)
+		if (rect.width * (1 << hpoidx) <= OV9655_WIDTH_MAX)
+			break;
+	ov9655->hskip = 1 << hpoidx;
+
+	for (vpoidx = 3; vpoidx > 0; vpoidx--)
+		if (rect.height * (1 << vpoidx) <= OV9655_HEIGHT_MAX)
+			break;
+	ov9655->vskip = 1 << vpoidx;
+
+	dev_err(&icd->dev, "hpoidx %u, vpoidx %u\n", hpoidx, vpoidx);
+
+	icd->width_min = (OV9655_WIDTH_MIN + ov9655->hskip - 1) / ov9655->hskip;
+	icd->height_min = (OV9655_HEIGHT_MIN + ov9655->vskip - 1) / ov9655->vskip;
+	icd->width_max = OV9655_WIDTH_MAX / ov9655->vskip;
+	icd->height_max = OV9655_HEIGHT_MAX / ov9655->hskip;
+
+	ov9655_set_crop(icd, &rect);
+
+	zoom = 0;
+	scaling = 0;
+
+	/* Scaling down / zoom */
+	if (hpoidx || vpoidx) {
+		zoom = OV9655_COM14_ZOOM;
+		scaling = OV9655_COM16_SCALING;
+
+		*poidx = ((vpoidx & 0x3) << 4) | (hpoidx & 0x3);
+
+		/* Drop unused vertical pixel data to avoid green image on left side */ 
+		if (vpoidx == 1)
+			*poidx |= OV9655_POIDX_VDROP;	
+
+		*pckdv = hpoidx & 0x3;
+		*xindx = 0x10;
+		*yindx = 0x10; 
+		*com24 = 0x80 | (hpoidx & 0x3);
+	}
+
+	if (ret >= 0)
+		ret = ov9655_write_array(icd, frm_rv);
+
+	if (ret >= 0)
+		ret = ov9655_write_mask(icd, OV9655_COM14, zoom,
+					OV9655_COM14_ZOOM);
+	if (ret >= 0)
+		ret = ov9655_write_mask(icd, OV9655_COM16, scaling,
+					OV9655_COM16_SCALING);
+
+	return (ret < 0) ? ret : 0;
+}
+
+static unsigned long ov9655_query_bus_param(struct soc_camera_device *icd)
+{
+	struct ov9655 *ov9655 = container_of(icd, struct ov9655, icd);
+	struct soc_camera_link *icl = ov9655->client->dev.platform_data;
+
+	unsigned long flags = SOCAM_PCLK_SAMPLE_RISING | SOCAM_PCLK_SAMPLE_FALLING |
+			      SOCAM_HSYNC_ACTIVE_HIGH | SOCAM_HSYNC_ACTIVE_LOW |
+			      SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_VSYNC_ACTIVE_LOW |
+			      SOCAM_DATA_ACTIVE_HIGH | SOCAM_MASTER |
+			      SOCAM_DATAWIDTH_8;
+
+	return soc_camera_apply_sensor_flags(icl, flags);
+}
+
+static int ov9655_set_bus_param(struct soc_camera_device *icd,
+				 unsigned long flags)
+{
+	u8 com10 = 0x0;
+	int ret;
+
+	/* PCLK reverse */
+	if (flags & SOCAM_PCLK_SAMPLE_RISING)
+		com10 |= 0x10;
+
+	/* HREF negative */
+	if (flags & SOCAM_HSYNC_ACTIVE_LOW)
+		com10 |= 0x08;
+
+	/* VSYNC negative */
+	if (flags & SOCAM_VSYNC_ACTIVE_LOW)
+		com10 |= 0x02;
+
+	ret = ov9655_write(icd, OV9655_COM10, com10);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int ov9655_get_chip_id(struct soc_camera_device *icd,
+			      struct v4l2_dbg_chip_ident *id)
+{
+	struct ov9655 *ov9655 = container_of(icd, struct ov9655, icd);
+
+	if (id->match.type != V4L2_CHIP_MATCH_I2C_ADDR)
+		return -EINVAL;
+
+	if (id->match.addr != ov9655->client->addr)
+		return -ENODEV;
+
+	id->ident	= V4L2_IDENT_UNKNOWN;
+	id->revision	= 0;
+
+	return 0;
+}
+
+const struct v4l2_queryctrl ov9655_controls[] = {
+	{
+		.id		= V4L2_CID_BRIGHTNESS,
+		.type		= V4L2_CTRL_TYPE_INTEGER,
+		.name		= "Brightness",
+		.minimum	= 3,
+		.maximum	= 252,
+		.step		= 1,
+		.default_value	= 0x39,
+		.flags		= V4L2_CTRL_FLAG_SLIDER
+	}, {
+		.id		= V4L2_CID_EXPOSURE,
+		.type		= V4L2_CTRL_TYPE_INTEGER,
+		.name		= "Exposure",
+		.minimum	= 0,
+		.maximum	= 255,
+		.step		= 1,
+		.default_value	= 0x40,
+		.flags		= V4L2_CTRL_FLAG_SLIDER,
+	}, {
+		.id		= V4L2_CID_GAIN,
+		.type		= V4L2_CTRL_TYPE_INTEGER,
+		.name		= "Gain",
+		.minimum	= 0,
+		.maximum	= 255,
+		.step		= 1,
+		.default_value	= 0,
+		.flags		= V4L2_CTRL_FLAG_SLIDER,
+	}, {
+		.id		= V4L2_CID_BLUE_BALANCE,
+		.type		= V4L2_CTRL_TYPE_INTEGER,
+		.name		= "Blue Channel Gain",
+		.minimum	= 0,
+		.maximum	= 255,
+		.step		= 1,
+		.default_value	= 0x80,
+		.flags		= V4L2_CTRL_FLAG_SLIDER,
+	}, {
+		.id		= V4L2_CID_RED_BALANCE,
+		.type		= V4L2_CTRL_TYPE_INTEGER,
+		.name		= "Red Channel Gain",
+		.minimum	= 0,
+		.maximum	= 255,
+		.step		= 1,
+		.default_value	= 0x80,
+		.flags		= V4L2_CTRL_FLAG_SLIDER,
+	}, {
+		.id		= V4L2_CID_AUTO_WHITE_BALANCE,
+		.type		= V4L2_CTRL_TYPE_BOOLEAN,
+		.name		= "Automatic White Balance",
+		.minimum	= 0,
+		.maximum	= 1,
+		.step		= 1,
+		.default_value	= 1,
+	}, {
+		.id		= V4L2_CID_EXPOSURE_AUTO,
+		.type		= V4L2_CTRL_TYPE_BOOLEAN,
+		.name		= "Automatic Exposure",
+		.minimum	= 0,
+		.maximum	= 1,
+		.step		= 1,
+		.default_value	= 1,
+	}, {
+		.id		= V4L2_CID_AUTOGAIN,
+		.type		= V4L2_CTRL_TYPE_BOOLEAN,
+		.name		= "Automatic Gain",
+		.minimum	= 0,
+		.maximum	= 1,
+		.step		= 1,
+		.default_value	= 1,
+	}, {
+		.id		= V4L2_CID_VFLIP,
+		.type		= V4L2_CTRL_TYPE_BOOLEAN,
+		.name		= "Flip Vertically",
+		.minimum	= 0,
+		.maximum	= 1,
+		.step		= 1,
+		.default_value	= 0,
+	}, {
+		.id		= V4L2_CID_HFLIP,
+		.type		= V4L2_CTRL_TYPE_BOOLEAN,
+		.name		= "Horizontal mirror",
+		.minimum	= 0,
+		.maximum	= 1,
+		.step		= 1,
+		.default_value	= 0,
+	}
+};
+
+static int ov9655_get_control(struct soc_camera_device *icd,
+			      struct v4l2_control *ctrl)
+{
+	int value;
+
+	switch (ctrl->id) {
+	case V4L2_CID_BRIGHTNESS:
+		value = ov9655_read(icd, OV9655_AEW);
+		if (value < 0)
+			return -EIO;
+		ctrl->value = value + 3;
+		break;
+	case V4L2_CID_EXPOSURE:
+		value = ov9655_read(icd, OV9655_AEC);
+		if (value < 0)
+			return -EIO;
+		ctrl->value = value;
+		break;
+	case V4L2_CID_GAIN:
+		value = ov9655_read(icd, OV9655_GAIN);
+		if (value < 0)
+			return -EIO;
+		ctrl->value = value;
+		break;
+	case V4L2_CID_RED_BALANCE:
+		value = ov9655_read(icd, OV9655_RED);
+		if (value < 0)
+			return -EIO;
+		ctrl->value = value;
+		break;
+	case V4L2_CID_BLUE_BALANCE:
+		value = ov9655_read(icd, OV9655_BLUE);
+		if (value < 0)
+			return -EIO;
+		ctrl->value = value;
+		break;
+	case V4L2_CID_AUTO_WHITE_BALANCE:
+		value = ov9655_read(icd, OV9655_COM8);
+		if (value < 0)
+			return -EIO;
+		ctrl->value = !!(value & OV9655_COM8_AWB);
+		break;
+	case V4L2_CID_EXPOSURE_AUTO:
+		value = ov9655_read(icd, OV9655_COM8);
+		if (value < 0)
+			return -EIO;
+		ctrl->value = !!(value & OV9655_COM8_AEC);
+		break;
+	case V4L2_CID_AUTOGAIN:
+		value = ov9655_read(icd, OV9655_COM8);
+		if (value < 0)
+			return -EIO;
+		ctrl->value = !!(value & OV9655_COM8_AGC);
+		break;
+	case V4L2_CID_HFLIP:
+		value = ov9655_read(icd, OV9655_MVFP);
+		if (value < 0)
+			return -EIO;
+		ctrl->value = !!(value & OV9655_MVFP_MIRROR);
+		break;
+	case V4L2_CID_VFLIP:
+		value = ov9655_read(icd, OV9655_MVFP);
+		if (value < 0)
+			return -EIO;
+		ctrl->value = !!(value & OV9655_MVFP_VFLIP);
+		break;
+	}
+	return 0;
+}
+
+static struct soc_camera_ops ov9655_ops;
+
+static int ov9655_set_control(struct soc_camera_device *icd,
+			      struct v4l2_control *ctrl)
+{
+	const struct v4l2_queryctrl *qctrl;
+	int value = 0;
+	int ret = 0;
+
+	qctrl = soc_camera_find_qctrl(&ov9655_ops, ctrl->id);
+
+	if (!qctrl)
+		return -EINVAL;
+
+	switch (ctrl->id) {
+	case V4L2_CID_BRIGHTNESS:
+		if (ctrl->value > qctrl->maximum ||
+		    ctrl->value < qctrl->minimum)
+			return -EINVAL;
+		ret = ov9655_write(icd, OV9655_AEB, ctrl->value - 3);
+		if (ret >= 0)
+			ret = ov9655_write(icd, OV9655_AEW, ctrl->value + 3);
+		break;
+	case V4L2_CID_EXPOSURE:
+		if (ctrl->value > qctrl->maximum ||
+		    ctrl->value < qctrl->minimum)
+			return -EINVAL;
+		/* The user wants to set exposure manually, hope, she
+		 * knows, what she's doing... Switch AEC off. */
+		ret = ov9655_write_mask(icd, OV9655_COM8, 0,
+					OV9655_COM8_AEC);
+		if (ret >= 0)
+			ret = ov9655_write(icd, OV9655_AEC, ctrl->value);
+		if (ret >= 0)
+			icd->exposure = ctrl->value;
+		break;
+	case V4L2_CID_GAIN:
+		if (ctrl->value > qctrl->maximum ||
+		    ctrl->value < qctrl->minimum)
+			return -EINVAL;
+		/* The user wants to set gain manually, hope, she
+		 * knows, what she's doing... Switch AGC off. */
+		ret = ov9655_write_mask(icd, OV9655_COM8, 0,
+					OV9655_COM8_AGC);
+		if (ret >= 0)
+			ret = ov9655_write(icd, OV9655_GAIN, ctrl->value);
+		if (ret >= 0)
+			icd->gain = ctrl->value;
+		break;
+	case V4L2_CID_RED_BALANCE:
+		if (ctrl->value > qctrl->maximum ||
+		    ctrl->value < qctrl->minimum)
+			return -EINVAL;
+		/* The user wantsvpoidx to set red gain manually, hope, she
+		 * knows, what she's doing... Switch AWB off. */
+		ret = ov9655_write_mask(icd, OV9655_COM8, 0,
+					OV9655_COM8_AWB);
+		if (ret >= 0)
+			ret = ov9655_write(icd, OV9655_RED, ctrl->value);
+		break;
+	case V4L2_CID_BLUE_BALANCE:
+		if (ctrl->value > qctrl->maximum ||
+		    ctrl->value < qctrl->minimum)
+			return -EINVAL;
+		/* The user wants to set blue gain manually, hope, she
+		 * knows, what she's doing... Switch AWB off. */
+		ret = ov9655_write_mask(icd, OV9655_COM8, 0,
+					OV9655_COM8_AWB);
+		if (ret >= 0)
+			ret = ov9655_write(icd, OV9655_BLUE, ctrl->value);
+		break;
+	case V4L2_CID_AUTO_WHITE_BALANCE:
+		if (ctrl->value)
+			value = OV9655_COM8_AGC;
+		ret = ov9655_write_mask(icd, OV9655_COM8, value,
+					OV9655_COM8_AWB);
+		break;
+	case V4L2_CID_EXPOSURE_AUTO:
+		if (ctrl->value)
+			value = OV9655_COM8_AGC;
+		ret = ov9655_write_mask(icd, OV9655_COM8, value,
+					OV9655_COM8_AEC);
+		break;
+	case V4L2_CID_AUTOGAIN:
+		if (ctrl->value)
+			value = OV9655_COM8_AGC;
+		ret = ov9655_write_mask(icd, OV9655_COM8, value,
+					OV9655_COM8_AGC);
+		break;
+	case V4L2_CID_HFLIP:
+		if (ctrl->value)
+			value = OV9655_MVFP_MIRROR;
+		ret = ov9655_write_mask(icd, OV9655_MVFP, value,
+					OV9655_MVFP_MIRROR);
+		break;
+	case V4L2_CID_VFLIP:
+		if (ctrl->value)
+			value = OV9655_MVFP_VFLIP;
+		ret = ov9655_write_mask(icd, OV9655_MVFP, value,
+					OV9655_MVFP_VFLIP);
+		break;
+	}
+	return (ret < 0) ? -EIO : 0;
+}
+
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+static int ov9655_get_register(struct soc_camera_device *icd,
+			       struct v4l2_dbg_register *reg)
+{
+	struct ov9655 *ov9655 = container_of(icd, struct ov9655, icd);
+	int ret;
+
+	reg->size = 1;
+	if (reg->reg > 0xff)
+		return -EINVAL;
+
+	ret = i2c_smbus_read_byte_data(ov9655->client, reg->reg);
+	if (ret < 0)
+		return ret;
+
+	reg->val = (__u64) ret;
+
+	return 0;
+}
+
+static int ov9655_set_register(struct soc_camera_device *icd,
+			       struct v4l2_dbg_register *reg)
+{
+	struct ov9655 *ov9655 = container_of(icd, struct ov9655, icd);
+
+	if (reg->reg > 0xff ||
+	    reg->val > 0xff)
+		return -EINVAL;
+
+	return i2c_smbus_write_byte_data(ov9655->client, reg->reg, reg->val);
+}
+#endif
+
+
+static struct soc_camera_ops ov9655_ops = {
+	.owner			= THIS_MODULE,
+	.probe			= ov9655_video_probe,
+	.remove			= ov9655_video_remove,
+	.init			= ov9655_init,
+	.release		= ov9655_release,
+	.start_capture		= ov9655_start_capture,
+	.stop_capture		= ov9655_stop_capture,
+	.set_crop		= ov9655_set_crop,
+	.set_fmt		= ov9655_set_fmt,
+	.try_fmt		= ov9655_try_fmt,
+	.query_bus_param	= ov9655_query_bus_param,
+	.set_bus_param		= ov9655_set_bus_param,
+	.get_chip_id		= ov9655_get_chip_id,
+	.get_control		= ov9655_get_control,
+	.set_control		= ov9655_set_control,
+	.controls		= ov9655_controls,
+	.num_controls		= ARRAY_SIZE(ov9655_controls),
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	.get_register		= ov9655_get_register,
+	.set_register		= ov9655_set_register,
+#endif
+};
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 26)
+static int ov9655_probe(struct i2c_client *client)
+#else
+static int ov9655_probe(struct i2c_client *client,
+			const struct i2c_device_id *did)
+#endif
+{
+	struct ov9655 *ov9655;
+	struct soc_camera_device *icd;
+	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
+	struct soc_camera_link *icl = client->dev.platform_data;
+	int ret;
+
+	if (!icl) {
+		dev_err(&client->dev, "OV9655 driver needs platform data\n");
+		return -EINVAL;
+	}
+
+	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA)) {
+		dev_warn(&adapter->dev,
+			 "I2C-Adapter doesn't support I2C_FUNC_SMBUS_BYTE_DATA\n");
+		return -EIO;
+	}
+
+	ov9655 = kzalloc(sizeof(struct ov9655), GFP_KERNEL);
+	if (!ov9655)
+		return -ENOMEM;
+
+	ov9655->client = client;
+	i2c_set_clientdata(client, ov9655);
+
+	icd = &ov9655->icd;
+	icd->ops = &ov9655_ops;
+	icd->control = &client->dev;
+	icd->width_min = OV9655_WIDTH_MIN;
+	icd->width_max = OV9655_WIDTH_MAX;
+	icd->height_min = OV9655_HEIGHT_MIN;
+	icd->height_max = OV9655_HEIGHT_MAX;
+	icd->y_skip_top	= OV9655_TOP_SKIP;
+	icd->iface = icl->bus_id;
+
+	ret = soc_camera_device_register(icd);
+	if (ret)
+		goto exit;
+
+	return 0;
+
+exit:
+	kfree(ov9655);
+	return ret;
+}
+
+static int ov9655_remove(struct i2c_client *client)
+{
+	struct ov9655 *ov9655 = i2c_get_clientdata(client);
+
+	soc_camera_device_unregister(&ov9655->icd);
+
+	i2c_set_clientdata(client, NULL);
+
+	kfree(ov9655);
+
+	return 0;
+}
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 26)
+static const struct i2c_device_id ov9655_id[] = {
+	{ "ov9655", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, ov9655_id);
+#endif
+
+static struct i2c_driver ov9655_i2c_driver = {
+	.driver = {
+		.name = "ov9655",
+	},
+	.probe		= ov9655_probe,
+	.remove		= ov9655_remove,
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 26)
+	.id_table	= ov9655_id,
+#endif
+};
+
+static int __init ov9655_mod_init(void)
+{
+	return i2c_add_driver(&ov9655_i2c_driver);
+}
+
+static void __exit ov9655_mod_exit(void)
+{
+	i2c_del_driver(&ov9655_i2c_driver);
+}
+
+module_init(ov9655_mod_init);
+module_exit(ov9655_mod_exit);
+
+MODULE_DESCRIPTION("OmniVision OV9655 Camera driver");
+MODULE_AUTHOR("Stefan Herbrechtsmeier <hbmeier@hni.upb.de>");
+MODULE_LICENSE("GPL");
