Return-path: <linux-media-owner@vger.kernel.org>
Received: from ppsw-0.csi.cam.ac.uk ([131.111.8.130]:33503 "EHLO
	ppsw-0.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbZFOOVn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jun 2009 10:21:43 -0400
Message-ID: <4A365918.40801@cam.ac.uk>
Date: Mon, 15 Jun 2009 14:22:16 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Darius <augulis.darius@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH] soc-camera: ov7670 merged multiple drivers and moved over
 to v4l2-subdev
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jonathan Cameron <jic23@cam.ac.uk>

OV7670 soc-camera driver. Merge of drivers from Jonathan Corbet,
Darius Augulis and Jonathan Cameron

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---

This is my first cut at a merge of the various ov7670 drivers to work
with Guennadi Liakhovetski's work on moving soc-camera over to v4l2-subdev
framework.

Thanks to Darius Augulis for many of the register settings, though a few
sets marked as untested in his driver don't seem to work.

I'm not entirely happy with the mapping of various parameters onto
the standard v4l controls and would greatly appreciate any suggestions
about these.

There are still a lot of magic numbers in here but I've tried to identify
the purposes of as many as possible.

At the moment I've deliberately kept it separate in naming etc from the
in tree ov7670 driver as I don't want to go breaking that driver. Is there
anyone out there who has the hardware and would consider doing the relevant
board support code and testing?

All comments welcome.


 drivers/media/video/Kconfig      |    6 +
 drivers/media/video/Makefile     |    1 +
 drivers/media/video/ov7670_soc.c | 1475 ++++++++++++++++++++++++++++++++++++++
 include/media/ov7670_soc.h       |   21 +
 4 files changed, 1503 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 9ff760c..4580d7a 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -746,6 +746,12 @@ config SOC_CAMERA_OV772X
 	help
 	  This is a ov772x camera driver
 
+config SOC_CAMERA_OV7670_SOC
+       tristate "ov7670 soc camera support"
+       depends on SOC_CAMERA && I2C
+       help
+         This is an ov7670 soc camera driver
+
 config MX1_VIDEO
 	bool
 
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 7aefac6..1249326 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -141,6 +141,7 @@ obj-$(CONFIG_SOC_CAMERA_MT9M111)	+= mt9m111.o
 obj-$(CONFIG_SOC_CAMERA_MT9T031)	+= mt9t031.o
 obj-$(CONFIG_SOC_CAMERA_MT9V022)	+= mt9v022.o
 obj-$(CONFIG_SOC_CAMERA_OV772X)		+= ov772x.o
+obj-$(CONFIG_SOC_CAMERA_OV7670_SOC)	+= ov7670_soc.o
 obj-$(CONFIG_SOC_CAMERA_PLATFORM)	+= soc_camera_platform.o
 obj-$(CONFIG_SOC_CAMERA_TW9910)		+= tw9910.o
 # soc-camera host drivers have to be linked after camera drivers
diff --git a/drivers/media/video/ov7670_soc.c b/drivers/media/video/ov7670_soc.c
new file mode 100644
index 0000000..5494427
--- /dev/null
+++ b/drivers/media/video/ov7670_soc.c
@@ -0,0 +1,1475 @@
+/*
+ * A V4L2 driver for OmniVision OV7670 cameras via soc interface
+ *
+ * Copyright 2006 One Laptop Per Child Association, Inc.  Written
+ * by Jonathan Corbet with substantial inspiration from Mark
+ * McClelland's ovcamchip code.
+ *
+ * Copyright 2006-7 Jonathan Corbet <corbet@lwn.net>
+ *
+ * Copyright 2008-9 Jonathan Cameron <jic23@cam.ac.uk>
+ *
+ * Copyright 2008 Darius Augulis <augulis.darius@gmail.com>
+ *
+ * This file may be distributed under the terms of the GNU General
+ * Public License, version 2.
+ *
+ * Todo: Add control for auto saturation control
+ *       Inversion of sync signals etc.
+ *       Driver 2 had a qqvga mode, but register settings don't seem to
+ *       be right so I've removed it.
+ *
+ * Queries for review:
+ * 1) Here I'm using brightness controls for what are effectively shutter
+ * timings.  How should this be done?
+ */
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/videodev2.h>
+#include <media/v4l2-common.h>
+#include <media/v4l2-chip-ident.h>
+#include <linux/i2c.h>
+#include <linux/gpio.h>
+#include <linux/delay.h>
+#include <media/soc_camera.h>
+#include <media/ov7670_soc.h>
+
+#define MAX_WIDTH	640
+#define MAX_HEIGHT	480
+
+/* Registers */
+#define	REG_GAIN	0x00	/* Gain lower 8 bits (rest in vref) */
+#define REG_BLUE	0x01	/* blue gain */
+#define REG_RED		0x02	/* red gain */
+#define REG_VREF	0x03	/* Pieces of GAIN, VSTART, VSTOP */
+#define REG_COM1	0x04	/* Control 1 */
+#define		COM1_CCIR656	  0x40  /* CCIR656 enable */
+
+#define REG_AECHH	0x07	/* AEC MS 5 bits */
+
+#define REG_COM2	0x09	/* Control 2 */
+#define		COM2_SSLEEP	  0x10	/* Soft sleep mode */
+#define REG_PID		0x0a	/* Product ID MSB */
+#define REG_VER		0x0b	/* Product ID LSB */
+#define REG_COM3	0x0c	/* Control 3 */
+#define		COM3_SWAP	  0x40	  /* Byte swap */
+#define		COM3_SCALEEN	  0x08	  /* Enable scaling */
+#define		COM3_DCWEN	  0x04	  /* Enable downsamp/crop/window */
+#define REG_COM4	0x0d	/* Control 4 */
+#define REG_COM5	0x0e	/* All "reserved" */
+#define REG_COM6	0x0f	/* Control 6 */
+#define REG_AECH	0x10	/* More bits of AEC value */
+#define REG_CLKRC	0x11	/* Clock control */
+#define		CLK_EXT	  0x40	  /* Use external clock directly */
+#define REG_COM7	0x12	/* Control 7 */
+#define		COM7_RESET	  0x80	  /* Register reset */
+#define		COM7_FMT_MASK	  0x38
+#define		COM7_FMT_VGA	  0x00
+#define		COM7_FMT_CIF	  0x20	  /* CIF format */
+#define		COM7_FMT_QVGA	  0x10	  /* QVGA format */
+#define		COM7_FMT_QCIF	  0x08	  /* QCIF format */
+#define		COM7_RGB	  0x04	  /* bits 0 and 2 - RGB format */
+#define		COM7_YUV	  0x00	  /* YUV */
+#define		COM7_BAYER	  0x01	  /* Bayer format */
+#define		COM7_PBAYER	  0x05	  /* "Processed bayer?" */
+#define REG_COM8	0x13	/* Control 8 */
+#define		COM8_FASTAEC	  0x80	  /* Enable fast AGC/AEC */
+#define		COM8_AECSTEP	  0x40	  /* Unlimited AEC step size */
+#define		COM8_BFILT	  0x20	  /* Band filter enable */
+#define		COM8_AGC	  0x04	  /* Auto gain enable */
+#define		COM8_AWB	  0x02	  /* White balance enable */
+#define		COM8_AEC	  0x01	  /* Auto exposure enable */
+#define REG_COM9	0x14	/* Control 9  - gain ceiling */
+#define REG_COM10	0x15	/* Control 10 */
+#define		COM10_HSYNC	  0x40	  /* HSYNC instead of HREF */
+#define		COM10_PCLK_HB	  0x20	  /* Suppress PCLK on horiz blank */
+#define		COM10_HREF_REV  0x08	  /* Reverse HREF */
+#define		COM10_VS_LEAD	  0x04	  /* VSYNC on clock leading edge */
+#define		COM10_VS_NEG	  0x02	  /* VSYNC negative */
+#define		COM10_HS_NEG	  0x01	  /* HSYNC negative */
+#define REG_HSTART	0x17	/* Horiz start high bits */
+#define REG_HSTOP	0x18	/* Horiz stop high bits */
+#define REG_VSTART	0x19	/* Vert start high bits */
+#define REG_VSTOP	0x1a	/* Vert stop high bits */
+#define REG_PSHFT	0x1b	/* Pixel delay after HREF */
+#define REG_MIDH	0x1c	/* Manuf. ID high */
+#define REG_MIDL	0x1d	/* Manuf. ID low */
+#define REG_MVFP	0x1e	/* Mirror / vflip */
+#define		MVFP_MIRROR	  0x20	  /* Mirror image */
+#define		MVFP_FLIP	  0x10	  /* Vertical flip */
+
+#define REG_AEW		0x24	/* AGC upper limit */
+#define REG_AEB		0x25	/* AGC lower limit */
+#define REG_VPT		0x26	/* AGC/AEC fast mode op region */
+
+#define REG_HSYST	0x30	/* HSYNC rising edge delay */
+#define REG_HSYEN	0x31	/* HSYNC falling edge delay */
+#define REG_HREF	0x32	/* HREF pieces */
+#define REG_TSLB	0x3a	/* Line buffer test options */
+#define		TSLB_YLAST	  0x04	  /* UYVY or VYUY - see com13 */
+#define REG_COM11	0x3b	/* Control 11 */
+#define		COM11_NIGHT	  0x80	  /* Night mode enable */
+#define		COM11_NMFR	  0x60	  /* Two bit NM frame rate */
+#define		COM11_HZAUTO	  0x10	  /* Auto detect 50/60 Hz */
+#define		COM11_50HZ	  0x08	  /* Manual 50Hz select */
+#define		COM11_EXP	  0x02
+#define REG_COM12	0x3c	/* Control 12 */
+#define		COM12_HREF	  0x80	  /* HREF always */
+#define REG_COM13	0x3d	/* Control 13 */
+#define		COM13_GAMMA	  0x80	  /* Gamma enable */
+#define		COM13_UVSAT	  0x40	  /* UV saturation auto adjustment */
+#define		COM13_UVSWAP	  0x01	  /* V before U - w/TSLB */
+#define REG_COM14	0x3e	/* Control 14 */
+#define		COM14_DCWEN	  0x10	  /* DCW/PCLK-scale enable */
+#define REG_EDGE	0x3f	/* Edge enhancement factor */
+#define REG_COM15	0x40	/* Control 15 */
+#define		COM15_R10F0	  0x00	  /* Data range 10 to F0 */
+#define		COM15_R01FE	  0x80	  /*            01 to FE */
+#define		COM15_R00FF	  0xc0	  /*            00 to FF */
+#define		COM15_RGB565	  0x10	  /* RGB565 output */
+#define		COM15_RGB555	  0x30	  /* RGB555 output */
+#define REG_COM16	0x41	/* Control 16 */
+#define		COM16_AWBGAIN   0x08	  /* AWB gain enable */
+#define		COM16_DN_THRESH_AUTO 0x10 /* denoise threshold auto adj */
+#define		COM16_EDGE_THRESH_AUTO 0x20 /* yuv edge enhancement auto adj*/
+#define REG_COM17	0x42	/* Control 17 */
+#define		COM17_AECWIN	  0xc0	  /* AEC window - must match COM4 */
+#define		COM17_CBAR	  0x08	  /* DSP Color bar */
+
+#define REG_DNSTH	0x4C
+/*
+ * This matrix defines how the colors are generated, must be
+ * tweaked to adjust hue and saturation.
+ *
+ * Order: v-red, v-green, v-blue, u-red, u-green, u-blue
+ *
+ * They are nine-bit signed quantities, with the sign bit
+ * stored in 0x58.  Sign for v-red is bit 0, and up from there.
+ */
+#define	REG_CMATRIX_BASE 0x4f
+#define		CMATRIX_LEN 6
+#define REG_CMATRIX_SIGN 0x58
+
+#define REG_BRIGHT	0x55	/* Brightness */
+#define REG_CONTRAST	0x56	/* Contrast control */
+
+#define REG_GFIX	0x69	/* Fix gain control */
+
+#define REG_SCALING_XSC 0x70 /* Horizontal scale factor */
+#define REG_SCALING_YSC 0x71 /* Vertical scale factor */
+#define REG_SCALING_DCWCTR 0x72 /* DCW control */
+#define REG_SCALING_PCLK_DIV 0x73 /* Clock divider for scale control */
+
+#define REG_REG75	0x75	/* Edge enhancement lower limit */
+#define REG_REG76	0x76	/* OV's name */
+#define		R76_BLKPCOR	  0x80	  /* Black pixel correction enable */
+#define		R76_WHTPCOR	  0x40	  /* White pixel correction enable */
+#define REG_REG77	0x77	/* Denoise offset */
+#define REG_RGB444	0x8c	/* RGB 444 control */
+#define		R444_ENABLE	  0x02	  /* Turn on RGB444, overrides 5x5 */
+#define		R444_RGBX	  0x01	  /* Empty nibble at end */
+
+#define REG_HAECC1	0x9f	/* Hist AEC/AGC control 1 */
+#define REG_HAECC2	0xa0	/* Hist AEC/AGC control 2 */
+#define REG_SCALING_PCLK_DELAY 0xa2/* Scaling output delay */
+#define REG_BD50MAX	0xa5	/* 50hz banding step limit */
+#define REG_HAECC3	0xa6	/* Hist AEC/AGC control 3 */
+#define REG_HAECC4	0xa7	/* Hist AEC/AGC control 4 */
+#define REG_HAECC5	0xa8	/* Hist AEC/AGC control 5 */
+#define REG_HAECC6	0xa9	/* Hist AEC/AGC control 6 */
+#define REG_HAECC7	0xaa	/* Hist AEC/AGC control 7 */
+#define REG_BD60MAX	0xab	/* 60hz banding step limit */
+
+/**
+ * struct regval_list - settings for a particular register
+ * @reg_num: register address
+ * @value: the value to be set
+ * @mask: a mask to optionally set only part of the register
+ **/
+struct regval_list {
+	unsigned char reg_num;
+	unsigned char value;
+	unsigned char mask;
+};
+
+/**
+ * struct ov7670_color_format - colour format specific settings
+ * @name: identifying string
+ * @fourcc: V4L2_PIX_FMT_ idenifier
+ * @regs: colour format specific register values
+ * @cmatrix: colour conversion matrix defaults
+ **/
+struct ov7670_color_format {
+	char				*name;
+	__u32				fourcc;
+	const struct regval_list	*regs;
+	int				cmatrix[6];
+};
+
+/**
+ * struct ov7670_soc_win_size - device parameters for particular resolution
+ * @width: image width
+ * @height: image height
+ * @regs: resolution specific register values
+ **/
+struct ov7670_soc_win_size {
+	int	width;
+	int	height;
+	struct regval_list *regs;
+};
+
+/* dubious colours */
+static struct regval_list ov7670_vga_regs[] = {
+	{ REG_COM7, COM7_FMT_VGA, 0x38 },
+	/* hstart = 158, hstop = 14  */
+	{ REG_HSTART, 0x13 }, { REG_HSTOP, 0x01 }, { REG_HREF, 0x3C, 0x3F },
+	/* vstart = 10, vstop = 490 */
+	{ REG_VSTART, 0x02 }, { REG_VSTOP, 0x7A }, { REG_VREF, 0x0A, 0x0F },
+	{ REG_COM3, 0, 0x0C },
+	{ REG_COM14, 0 },
+	{ REG_SCALING_PCLK_DIV, 0xf0 },
+	{ 0x3d, 0xc1}, /* minor edit to gamma curve */
+	{ 0xff, 0xff }, /* END MARKER */
+};
+
+static struct regval_list ov7670_cif_regs[] = {
+	{ REG_COM7, COM7_FMT_CIF, 0x38 },
+	/* hstart = 174, hstop = 94 */
+	{ REG_HSTART, 0x15 }, { REG_HSTOP, 0x0B }, { REG_HREF, 0x0C, 0x3F },
+	/* vstart = 14, vstop = 492 */
+	{ REG_VSTART, 0x03 }, { REG_VSTOP, 0x7A }, { REG_VREF, 0x0E, 0x0F},
+	{ REG_COM3, 0x08, 0x0C }, /* enable scale? */
+	{ REG_COM14, 0x11 }, /* divide pclk 2 and enable dcw and scaling pclk */
+	{ REG_SCALING_PCLK_DIV, 0xF1 }, /* dsp scale ctrl clock div 2 */
+	{ 0x3d, 0xc0}, /* minor edit to gamma curve */
+	{ 0xff, 0xff }, /* END MARKER */
+};
+
+/* dubious colours */
+static struct regval_list ov7670_qvga_regs[] = {
+	{ REG_COM7, COM7_FMT_QVGA, 0x38 },
+	/* hstart = 176, hstop = 32 */
+	{ REG_HSTART, 0x16 }, { REG_HSTOP, 0x04 }, { REG_HREF, 0, 0x3F },
+	/* vstart = 10, vstop = 490  */
+	{ REG_VSTART, 0x02 }, { REG_VSTOP, 0x7a }, { REG_VREF, 0x0A, 0x0F },
+	{ REG_COM3, COM3_DCWEN, 0x0C }, /* downsample/crop/window enable */
+	{ REG_COM14, 0x19 },
+	{ REG_SCALING_PCLK_DIV, 0xF1 }, /* dsp scale ctrl clock div 2 */
+	{ 0x3d, 0xc0}, /* minor edit to gamma curve */
+	{ 0xff, 0xff }, /* END MARKER */
+};
+
+/*
+ * This register set is not perfect. Anyone have a better one?
+ * Note that driver 2 suggested a larger value in 0xa2 which is a bad idea.
+ */
+static struct regval_list ov7670_qcif_regs[] = {
+	{ REG_COM7, COM7_FMT_QCIF, 0x38 },
+	/* hstart = 174, hstop = 94 */
+	{ REG_HSTART, 0x14 }, { REG_HSTOP, 0x03 }, { REG_HREF, 0x00, 0x3F },
+	/* vstart = 14, vstop = 492 */
+	{ REG_VSTART, 0x03 }, { REG_VSTOP, 0x7B }, { REG_VREF, 0x02, 0x0F},
+	{ REG_COM3, 0x0c, 0x0C }, /* enable scale? */
+	{ REG_COM14, 0x12 }, /* divide pclk 2 and enable dcw and scaling pclk */
+	{ REG_SCALING_PCLK_DIV, 0xf2 }, /* dsp scale ctrl clock div 2 */
+	{ 0x3d, 0xc1}, /* minor edit to gamma curve */
+	{ 0xff, 0xff }, /* END MARKER */
+};
+
+static struct ov7670_soc_win_size  ov7670_soc_win_sizes[] = {
+	{
+		.width		= 640,
+		.height		= 480,
+		.regs		= ov7670_vga_regs,
+
+	}, {
+		.width		= 352,
+		.height		= 288,
+		.regs		= ov7670_cif_regs,
+	}, {
+		.width		= 320,
+		.height		= 240,
+		.regs		= ov7670_qvga_regs,
+	}, {
+		.width		= 176,
+		.height		= 144,
+		.regs		= ov7670_qcif_regs,
+	},
+};
+
+struct ov7670_soc_priv {
+	struct v4l2_subdev			subdev;
+	struct ov7670_soc_camera_info		*info;
+	const struct ov7670_color_format	*fmt;
+	const struct ov7670_soc_win_size	*win;
+	int					gpio_reset;
+	int					gpio_power;
+	int					hue;
+	int					sat;
+};
+
+
+static const struct v4l2_queryctrl ov7670_soc_controls[] = {
+	{ /* Contrast register documentation is very vague */
+		.id = V4L2_CID_CONTRAST,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "Contrast",
+		.minimum = 0,
+		.maximum = 255,
+		.step = 1,
+		.default_value = 40,
+	}, {
+		.id = V4L2_CID_EXPOSURE_AUTO,
+		.name = "Auto Exposure",
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	}, {
+		.id = V4L2_CID_EXPOSURE_ABSOLUTE,
+		.name = "Exposure Target",
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = 0,
+		.maximum = 0xFFFF,
+		.step = 1,
+		.default_value = 0,
+	}, {
+		.id = V4L2_CID_AUTO_WHITE_BALANCE,
+		.name = "Auto White Balance",
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	}, {
+		.id = V4L2_CID_AUTOGAIN,
+		.name = "Auto gain",
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	}, {
+		V4L2_CID_AUDIO_VOLUME,
+		.name = "gain",
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = 0,
+		.maximum = 0x3FF,
+		.step = 1,
+		.default_value = 0,
+	}, {
+		.id = V4L2_CID_VFLIP,
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.name = "Flip Vertically",
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	}, {
+		.id = V4L2_CID_HFLIP,
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.name = "Flip Horizontally",
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	}, {
+		.id = V4L2_CID_BRIGHTNESS,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "Clock scaling", /* technically clock scaling */
+		.minimum = 1,
+		.maximum = 0x1F,
+		.step = 1,
+		.default_value = 3,
+	}, {
+		.id = V4L2_CID_HUE,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "Hue",
+		.minimum = -180,
+		.maximum = 180,
+		.step = 5,
+		.default_value = 0,
+	}, {
+		.id = V4L2_CID_SATURATION,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "Saturation",
+		.minimum = 0,
+		.maximum = 255,
+		.step = 1,
+		.default_value = 0x80,
+	}, {
+		.id = V4L2_CID_BLUE_BALANCE,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "Blue Gain",
+		.minimum = 0,
+		.maximum = 255,
+		.step = 1,
+		.default_value = 0x40,
+	} , {
+		.id = V4L2_CID_RED_BALANCE,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "Red Gain",
+		.minimum = 0,
+		.maximum = 255,
+		.step = 1,
+		.default_value = 0x40,
+	}
+};
+
+static struct regval_list ov7670_default_regs[] = {
+	{ REG_COM7, COM7_RESET },
+	{ REG_CLKRC, 0x03 }, /* clock scale (15 fps) */
+	{ REG_TSLB, 0x04 }, /* magic */
+	{ REG_COM7, 0 }, /* Disable Color bar */
+	{ REG_COM15, COM15_R00FF },
+	{ REG_COM3, 0 },
+	{ REG_COM14, 0 },
+
+	/* Mystery scaling numbers */
+	{ REG_SCALING_XSC, 0x3A },
+	{ REG_SCALING_YSC, 0x35 },
+	{ REG_SCALING_DCWCTR, 0x11 },
+	{ REG_SCALING_PCLK_DELAY, 0x02 },
+
+	{ REG_COM10, 0x0 },
+
+	/* Gamma curve values */
+	{ 0x7a, 0x20 },	{ 0x7b, 0x10 },
+	{ 0x7c, 0x1e },	{ 0x7d, 0x35 },
+	{ 0x7e, 0x5a },	{ 0x7f, 0x69 },
+	{ 0x80, 0x76 },	{ 0x81, 0x80 },
+	{ 0x82, 0x88 },	{ 0x83, 0x8f },
+	{ 0x84, 0x96 },	{ 0x85, 0xa3 },
+	{ 0x86, 0xaf },	{ 0x87, 0xc4 },
+	{ 0x88, 0xd7 },	{ 0x89, 0xe8 },
+
+	/* AGC and AEC parameters.  Note we start by disabling those features,
+	   then turn them only after tweaking the values. */
+	{ REG_COM8, COM8_FASTAEC | COM8_AECSTEP | COM8_BFILT },
+	{ REG_GAIN, 0 },
+	{ REG_AECH, 0 },
+	{ REG_COM4, 0x40 }, /* magic reserved bit */
+	{ REG_COM9, 0x18 }, /* 4x gain + magic rsvd bit */
+	{ REG_BD50MAX, 0x05 },
+	{ REG_BD60MAX, 0x07 },
+	{ REG_AEW, 0x95 },
+	{ REG_AEB, 0x33 },
+	{ REG_VPT, 0xe3 },
+	{ REG_HAECC1, 0x78 },
+	{ REG_HAECC2, 0x68 },
+	{ 0xa1, 0x03 }, /* magic */
+	{ REG_HAECC3, 0xd8 },
+	{ REG_HAECC4, 0xd8 },
+	{ REG_HAECC5, 0xf0 },
+	{ REG_HAECC6, 0x90 },
+	{ REG_HAECC7, 0x14 },
+	{ REG_COM8, COM8_FASTAEC|COM8_AECSTEP|COM8_BFILT|COM8_AGC|COM8_AEC },
+
+	{ REG_COM5, 0x61 },
+
+	/*
+	 * Reset timing on format change,
+	 * Signal output biases enabled (GbBIAS, Red bias, Blue bias)
+	 * The rest are magic
+	 */
+	{ REG_COM6, 0x4b },
+
+	{ 0x16, 0x02 }, /* magic */
+	{ REG_MVFP, 0x07 },
+	{ 0x21, 0x02 }, /* ADCCTR1 - magic */
+	{ 0x22, 0x91 }, /* ADCCTR2 - magic */
+	{ 0x29, 0x07 }, /* magic */
+	{ 0x33, 0x0b }, /* Array current control -magic */
+	{ 0x35, 0x0b }, /* magic */
+	{ 0x37, 0x1d }, /* ADC control - magic*/
+	{ 0x38, 0x71 }, /* ADC and analog common mode control - magic */
+	{ 0x39, 0x2a }, /* ADC offset control - magic*/
+	{ REG_COM12, 0x78 },
+	{ 0x4d, 0x40 }, /* magic */
+	{ 0x4e, 0x20 }, /* magic */
+	{ REG_GFIX, 0 },
+	{ 0x6b, 0x4a },	/* internal reg enabled, pll input clock x4, magic */
+
+	{ 0x74, 0x00 }, /* digital gain control by reg 74, bypass set */
+	{ 0x8d, 0x4f }, /* magic */
+	{ 0x8e, 0 }, /* magic */
+	{ 0x8f, 0 }, /* magic */
+	{ 0x90, 0 }, /* magic */
+	{ 0x91, 0 }, /* magic */
+	{ 0x96, 0 }, /* magic */
+	{ 0x9a, 0x80 }, /* magic, note in tinyos driver 0x00 */
+	{ 0xb0, 0x84 }, /* magic */
+	{ 0xb1, 0x0c }, /* ABLC1, magic */
+	{ 0xb2, 0x0e }, /* magic */
+	{ 0xb3, 0x82 }, /* ABLC target */
+	{ 0xb8, 0x0a }, /* magic */
+
+	/* More reserved magic, some of which tweaks white balance */
+	{ 0x43, 0x0a },	{ 0x44, 0xf0 },
+	{ 0x45, 0x34 },	{ 0x46, 0x58 },
+	{ 0x47, 0x28 },	{ 0x48, 0x3a },
+	{ 0x59, 0x88 },	{ 0x5a, 0x88 },
+	{ 0x5b, 0x44 },	{ 0x5c, 0x67 },
+	{ 0x5d, 0x49 },	{ 0x5e, 0x0e },
+	{ 0x6c, 0x0a },	{ 0x6d, 0x55 },
+	{ 0x6e, 0x11 },	{ 0x6f, 0x9f }, /* "9e for advance AWB" */
+
+	{ 0x6a, 0x40 }, /* G channel AWB gain */
+	{ REG_BLUE, 0x40 },
+	{ REG_RED, 0x40 },
+	{ REG_COM16, COM16_AWBGAIN },
+	{ REG_EDGE, 0 },
+	{ REG_REG75, 0x05 }, /* Edge enhancement and black / white pixel cor.*/
+	{ REG_REG76, R76_BLKPCOR | R76_WHTPCOR | 0x01 },
+	/* Denoise strength and offest */
+	{ REG_DNSTH, 0 },
+	{ REG_REG77, 0x01 },
+	{ 0x4b, 0x09 }, /* UV everage enable */
+	{ 0xc9, 0x60 }, /* Saturation control min as 6 */
+	{ REG_COM16, (COM16_AWBGAIN |
+		      COM16_DN_THRESH_AUTO |
+		      COM16_EDGE_THRESH_AUTO)},
+	{ 0x56, 0x40 }, /* contrast control - magic */
+	{ 0x34, 0x11 }, /* Array reference control - magic */
+	{ REG_COM11, COM11_EXP | COM11_HZAUTO },
+	{ 0xa4, 0x80 }, /* Auto FR: reduce FR by half and magic */
+
+	/* next group are all magic */
+	{ 0x96, 0x00 }, { 0x97, 0x30 }, { 0x98, 0x20 }, { 0x99, 0x30 },
+	{ 0x9a, 0x84 }, { 0x9b, 0x29 }, { 0x9c, 0x03 }, { 0x9d, 0x4c },
+	{ 0x9e, 0x3f }, { 0x78, 0x04 },
+
+	/*
+	 * Undocumented in prelimenary data sheet
+	 * Looks like a multiplexor register, 0x79 sets sub address
+	 * c8 is the access
+	 */
+	/* none of this in driver 2 for vga. */
+	{ 0x79, 0x01 },	{ 0xc8, 0xf0 },
+	{ 0x79, 0x0f },	{ 0xc8, 0x00 },
+	{ 0x79, 0x10 },	{ 0xc8, 0x7e },
+	{ 0x79, 0x0a }, { 0xc8, 0x80 },
+	{ 0x79, 0x0b }, { 0xc8, 0x01 },
+	{ 0x79, 0x0c },	{ 0xc8, 0x0f },
+	{ 0x79, 0x0d },	{ 0xc8, 0x20 },
+	{ 0x79, 0x09 },	{ 0xc8, 0x80 },
+	{ 0x79, 0x02 },	{ 0xc8, 0xc0 },
+	{ 0x79, 0x03 },	{ 0xc8, 0x40 },
+	{ 0x79, 0x05 },	{ 0xc8, 0x30 },
+	{ 0x79, 0x26 }, /* magic number? */
+
+	{ 0xff, 0xff },	/* END MARKER */
+};
+
+static struct regval_list ov7670_fmt_yuv422[] = {
+	{ REG_COM7, COM7_YUV, 0x05 },
+	{ REG_RGB444, 0 },	/* No RGB444 please */
+	{ REG_COM1, 0, 0x40 },	/* no ccir656 aec low 2 lsb to 0 */
+	{ REG_COM15, 0x00, 0x30 },
+	{ REG_COM9, 0x10, 0x70 }, /*  AGC 4x gain ceiling */
+	 /* set YUYV byte order and uv saturation off */
+	{ REG_COM13, COM13_GAMMA | COM13_UVSAT },
+	{ 0xff, 0xff },
+};
+
+static struct regval_list ov7670_fmt_rgb565[] = {
+	{ REG_COM7, COM7_RGB, 0x05 },
+	{ REG_RGB444, 0 }, /* No RGB444 */
+	{ REG_COM1, 0x0, 0x40 }, /* No CCIR656 */
+	{ REG_COM15, COM15_RGB565, 0x30 },
+	{ REG_COM9, 0x30, 0x70 }, /* AGC 16x gain ceiling */
+	{ REG_COM13, COM13_GAMMA | COM13_UVSAT },
+	{ 0xff, 0xff },
+};
+
+#define SETFOURCC(type) .name = (#type), .fourcc = (V4L2_PIX_FMT_ ## type)
+static const struct soc_camera_data_format ov7670_soc_fmt_lists[] = {
+	{
+		SETFOURCC(YUYV),
+		.depth = 16,
+		.colorspace = V4L2_COLORSPACE_JPEG,
+	}, {
+		SETFOURCC(RGB565),
+		.depth = 16,
+		.colorspace = V4L2_COLORSPACE_SRGB,
+	},
+};
+
+static const struct ov7670_color_format ov7670_cfmts[] = {
+	{
+		SETFOURCC(YUYV),
+		.regs = ov7670_fmt_yuv422,
+		.cmatrix = { 128, -128, 0, -34, -94, 128 },
+	}, {
+		SETFOURCC(RGB565),
+		.regs = ov7670_fmt_rgb565,
+		.cmatrix = { 179, -179, 0, -61, -176, 228 },
+	},
+};
+
+#define OV7670_SIN_STEP 5
+static const int ov7670_sin_table[] = {
+	   0,	 87,   173,   258,   342,   422,
+	 499,	573,   642,   707,   766,   819,
+	 866,	906,   939,   965,   984,   996,
+	1000
+};
+
+static int ov7670_sine(int theta)
+{
+	int chs = 1;
+	int sine;
+
+	if (theta < 0) {
+		theta = -theta;
+		chs = -1;
+	}
+	if (theta <= 90)
+		sine = ov7670_sin_table[theta/OV7670_SIN_STEP];
+	else {
+		theta -= 90;
+		sine = 1000 - ov7670_sin_table[theta/OV7670_SIN_STEP];
+	}
+	return (sine * chs);
+}
+
+static int ov7670_cosine(int theta)
+{
+	theta = 90 - theta;
+	if (theta > 180)
+		theta -= 360;
+	else if (theta < -180)
+		theta += 360;
+
+	return ov7670_sine(theta);
+}
+
+static void ov7670_calc_cmatrix(struct ov7670_soc_priv *priv,
+				int matrix[CMATRIX_LEN])
+{
+	int i;
+
+	/*
+	 * Apply the current saturation setting first.
+	 */
+	for (i = 0; i < CMATRIX_LEN; i++)
+		matrix[i] = (priv->fmt->cmatrix[i]*priv->sat) >> 7;
+	/*
+	 * Then, if need be, rotate the hue value.
+	 */
+	if (priv->hue != 0) {
+		int sinth, costh, tmpmatrix[CMATRIX_LEN];
+
+		memcpy(tmpmatrix, matrix, CMATRIX_LEN*sizeof(int));
+		sinth = ov7670_sine(priv->hue);
+		costh = ov7670_cosine(priv->hue);
+
+		matrix[0] = (matrix[3]*sinth + matrix[0]*costh)/1000;
+		matrix[1] = (matrix[4]*sinth + matrix[1]*costh)/1000;
+		matrix[2] = (matrix[5]*sinth + matrix[2]*costh)/1000;
+		matrix[3] = (matrix[3]*costh - matrix[0]*sinth)/1000;
+		matrix[4] = (matrix[4]*costh - matrix[1]*sinth)/1000;
+		matrix[5] = (matrix[5]*costh - matrix[2]*sinth)/1000;
+	}
+}
+
+#define OV_VERSION(pid, ver) ((pid << 8) | (ver & 0xFF))
+#define OV7670_VER OV_VERSION(0x76, 0x73)
+
+static struct ov7670_soc_priv *to_ov7670_soc(const struct i2c_client *client)
+{
+	return container_of(i2c_get_clientdata(client),
+			    struct ov7670_soc_priv, subdev);
+}
+
+/*
+ * A quirk in smbus implementation (SCCB) requires a stop before a repeated
+ * start. This necesitates this function.  Without this I was getting
+ * all reads succeeding on second try.  Can anyone else verify this isn't
+ * a board specific quirk?
+ */
+static s32 ov7670_smbus_read_byte_data(struct i2c_client *client, u8 command)
+{
+	/* lifted from i2c_smbus_xfer_emulated */
+	unsigned char msgbuf0[I2C_SMBUS_BLOCK_MAX+3];
+	unsigned char msgbuf1[I2C_SMBUS_BLOCK_MAX+2];
+
+	struct i2c_msg msg[2] =	{ {
+			client->addr,
+			client->flags,
+			1,
+			msgbuf0
+		}, {
+			client->addr,
+			client->flags | I2C_M_RD,
+			1,
+			msgbuf1
+		},
+	};
+	int status;
+
+	msgbuf0[0] = command;
+	/* send the register address to read */
+	status = i2c_transfer(client->adapter, msg, 1);
+	if (status < 0)
+		return status;
+	status = i2c_transfer(client->adapter, &msg[1], 1);
+	if (status < 0)
+		return status;
+
+	return msgbuf1[0];
+}
+
+static int ov7670_write_array(struct i2c_client *c,
+			      const struct regval_list *vals)
+{
+	int ret, val;
+	while (vals->reg_num != 0xff || vals->value != 0xff) {
+		if (vals->mask) {
+			val = ov7670_smbus_read_byte_data(c,
+							  vals->reg_num);
+			ret = i2c_smbus_write_byte_data(c,
+							vals->reg_num,
+							(val & ~vals->mask) |
+							vals->value);
+			if (ret)
+				return ret;
+			vals++;
+		} else {
+			ret = i2c_smbus_write_byte_data(c,
+							vals->reg_num,
+							vals->value);
+			if (ret)
+				return ret;
+			vals++;
+		}
+	}
+
+	return 0;
+}
+
+static int ov7670_soc_video_probe(struct soc_camera_device *icd,
+				  struct i2c_client *client)
+{
+	s32 pid, ver;
+	int ret;
+
+	icd->formats = ov7670_soc_fmt_lists;
+	icd->num_formats = ARRAY_SIZE(ov7670_soc_fmt_lists);
+
+	/* Sanity check? */
+	i2c_smbus_write_byte_data(client, REG_COM7, COM7_RESET);
+	mdelay(1);
+
+	pid = ov7670_smbus_read_byte_data(client, REG_PID);
+	ver = ov7670_smbus_read_byte_data(client, REG_VER);
+
+	if (OV_VERSION(pid, ver) != OV7670_VER) {
+		dev_err(&icd->dev,
+			"Product ID error %x:%x\n", pid, ver);
+		return -ENODEV;
+	}
+
+	dev_info(&icd->dev,
+		 "ov7670 Product ID %0x:%0x Manufacturer ID %x:%x\n",
+		 pid,
+		 ver,
+		 ov7670_smbus_read_byte_data(client, REG_MIDH),
+		 ov7670_smbus_read_byte_data(client, REG_MIDL));
+	/* Write a default set of registers so we have a consistent state */
+	ret = ov7670_write_array(client, ov7670_default_regs);
+	return ret;
+}
+
+static void ov7670_soc_video_remove(struct soc_camera_device *icd)
+{
+	icd->ops = NULL;
+}
+
+static int ov7670_store_cmatrix(struct i2c_client *c, const int *matrix)
+{
+	int signbits, i, ret;
+
+	signbits = ov7670_smbus_read_byte_data(c, REG_CMATRIX_SIGN);
+	if (signbits < 0)
+		return -EIO;
+
+	signbits &= 0xc0;
+
+	for (i = 0; i < 6; i++) {
+		u8 raw;
+		if (matrix[i] < 0) {
+			signbits |= (1 << i);
+			if (matrix[i] < -255)
+				raw = 0xff;
+			else
+				raw = (-1 * matrix[i]) & 0xff;
+		} else {
+			if (matrix[i] > 255)
+				raw = 0xff;
+			else
+				raw = matrix[i] & 0xff;
+		}
+		ret = i2c_smbus_write_byte_data(c, REG_CMATRIX_BASE + i, raw);
+		if (ret)
+			return -EIO;
+	}
+
+	return i2c_smbus_write_byte_data(c, REG_CMATRIX_SIGN, signbits);
+}
+
+static int ov7670_soc_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct i2c_client *client = sd->priv;
+	struct ov7670_soc_priv *priv = to_ov7670_soc(client);
+	int data, ret;
+
+	if (!enable) {
+		data = ov7670_smbus_read_byte_data(client, REG_COM2);
+		return i2c_smbus_write_byte_data(client,
+						 REG_COM2,
+						 data | COM2_SSLEEP);
+	}
+
+	if (!priv->win || !priv->fmt) {
+		dev_err(&client->dev, "norm or win select error\n");
+		return -EPERM;
+	}
+
+	data = ov7670_smbus_read_byte_data(client, REG_COM2);
+
+	return ret = i2c_smbus_write_byte_data(client,
+					       REG_COM2,
+					       data & ~COM2_SSLEEP);
+}
+
+static int ov7670_soc_g_chip_ident(struct v4l2_subdev *sd,
+				   struct v4l2_dbg_chip_ident *id)
+{
+	id->ident = V4L2_IDENT_OV7670;
+	id->revision = 0;
+
+	return 0;
+}
+
+static unsigned long ov7670_soc_query_bus_param(struct soc_camera_device *icd)
+{
+	struct soc_camera_link *icl = to_soc_camera_link(icd);
+
+	unsigned long flags = SOCAM_PCLK_SAMPLE_RISING | SOCAM_MASTER |
+		SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_HSYNC_ACTIVE_HIGH |
+		SOCAM_DATAWIDTH_8 | SOCAM_DATA_ACTIVE_HIGH;
+
+	return soc_camera_apply_sensor_flags(icl, flags);
+}
+
+/* This device only supports one bus option */
+static int ov7670_soc_set_bus_param(struct soc_camera_device *icd,
+				    unsigned long flags)
+{
+	return 0;
+}
+
+
+static const struct ov7670_soc_win_size *ov7670_soc_select_win(u32 width,
+							       u32 height)
+{
+	const struct ov7670_soc_win_size *wsize;
+
+	/* relies on size order */
+	for (wsize = ov7670_soc_win_sizes;
+	     wsize < ov7670_soc_win_sizes + ARRAY_SIZE(ov7670_soc_win_sizes);
+	     wsize++)
+		if (width >= wsize->width && height >= wsize->height)
+			break;
+	if (wsize >= ov7670_soc_win_sizes + ARRAY_SIZE(ov7670_soc_win_sizes))
+		wsize--;
+
+	return wsize;
+}
+
+static int ov7670_soc_set_params(struct i2c_client *client,
+				 u32 width, u32 height, u32 pixfmt)
+{
+	struct ov7670_soc_priv *priv = to_ov7670_soc(client);
+	int ret = -EINVAL;
+	int i;
+	int data = 0;
+	int matrix[CMATRIX_LEN];
+
+	priv->fmt = NULL;
+
+	for (i = 0; i < ARRAY_SIZE(ov7670_cfmts); i++)
+		if (pixfmt == ov7670_cfmts[i].fourcc) {
+			priv->fmt = ov7670_cfmts + i;
+			ret = 0;
+			break;
+		}
+	if (!priv->fmt)
+		goto error_ret;
+
+	priv->win = ov7670_soc_select_win(width, height);
+
+	if (priv->fmt->fourcc == V4L2_PIX_FMT_RGB565) {
+		data = ov7670_smbus_read_byte_data(client,
+						   REG_CLKRC);
+		if (data < 0) {
+			ret = data;
+			goto error_ret;
+		}
+	}
+	if (priv->fmt->regs) {
+		ret = ov7670_write_array(client, priv->fmt->regs);
+		if (ret)
+			goto error_ret;
+	}
+
+	ov7670_calc_cmatrix(priv, matrix);
+	ret = ov7670_store_cmatrix(client, matrix);
+	if (ret)
+		goto error_ret;
+	priv->win = ov7670_soc_select_win(width, height);
+
+	/*
+	 * set size format
+	 **/
+	ret = ov7670_write_array(client, priv->win->regs);
+	if (ret)
+		goto error_ret;
+
+	if (priv->fmt->fourcc == V4L2_PIX_FMT_RGB565)
+		ret = i2c_smbus_write_byte_data(client,
+						REG_CLKRC,
+						data);
+
+error_ret:
+	return ret;
+}
+
+static int ov7670_soc_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+{
+	struct i2c_client *client = sd->priv;
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	return ov7670_soc_set_params(client, pix->width, pix->height,
+				     pix->pixelformat);
+}
+
+static int ov7670_soc_try_fmt(struct v4l2_subdev *sd,
+			      struct v4l2_format *f)
+{
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	const struct ov7670_soc_win_size *win;
+
+	win = ov7670_soc_select_win(pix->width, pix->height);
+	pix->width = win->width;
+	pix->height = win->height;
+	pix->field = V4L2_FIELD_NONE;
+
+	return 0;
+}
+
+static int ov7670_soc_g_ctrl(struct v4l2_subdev *sd,
+				  struct v4l2_control *ctrl)
+{
+	int data, data2, data3;
+	struct i2c_client *client = sd->priv;
+	struct ov7670_soc_priv *priv = to_ov7670_soc(client);
+
+	switch (ctrl->id) {
+	case V4L2_CID_CONTRAST:
+		data = ov7670_smbus_read_byte_data(client, REG_CONTRAST);
+		if (data < 0)
+			return data;
+		ctrl->value = data;
+		break;
+
+	case V4L2_CID_EXPOSURE_AUTO:
+		data = ov7670_smbus_read_byte_data(client, REG_COM8);
+		if (data < 0)
+			return data;
+		ctrl->value = !!(data & COM8_AEC);
+		break;
+
+	case V4L2_CID_EXPOSURE_ABSOLUTE:
+		data = ov7670_smbus_read_byte_data(client, REG_AECHH);
+		if (data < 0)
+			return data;
+		data2 = ov7670_smbus_read_byte_data(client, REG_AECH);
+		if (data2 < 0)
+			return data2;
+		data3 = ov7670_smbus_read_byte_data(client, REG_COM1);
+		if (data3 < 0)
+			return data3;
+		ctrl->value = ((data & 0x1F) << 10) |
+			(data2 << 2) |
+			(data3 & 0x03);
+		break;
+
+	case V4L2_CID_AUTO_WHITE_BALANCE:
+		data = ov7670_smbus_read_byte_data(client, REG_COM8);
+		if (data < 0)
+			return data;
+		ctrl->value = !!(data & COM8_AWB);
+		break;
+
+	case V4L2_CID_AUTOGAIN:
+		data = ov7670_smbus_read_byte_data(client, REG_COM8);
+		if (data < 0)
+			return data;
+		ctrl->value = !!(data & COM8_AGC);
+		break;
+
+	case V4L2_CID_AUDIO_VOLUME:
+		data = ov7670_smbus_read_byte_data(client, REG_GAIN);
+		if (data < 0)
+			return data;
+		data2 = ov7670_smbus_read_byte_data(client, REG_VREF);
+		if (data2 < 0)
+			return data2;
+		ctrl->value = ((data2 & 0xC0) << 2) | data;
+		break;
+
+	case V4L2_CID_VFLIP:
+		data = ov7670_smbus_read_byte_data(client, REG_MVFP);
+		if (data < 0)
+			return data;
+		ctrl->value = !!(data & MVFP_FLIP);
+		break;
+
+	case V4L2_CID_HFLIP:
+		data = ov7670_smbus_read_byte_data(client, REG_MVFP);
+		if (data < 0)
+			return data;
+		ctrl->value = !!(data & MVFP_MIRROR);
+		break;
+
+	case V4L2_CID_BRIGHTNESS:
+		data = ov7670_smbus_read_byte_data(client, REG_CLKRC);
+		if (data < 0)
+			return data;
+		ctrl->value = data & 0x1F;
+		break;
+
+	case V4L2_CID_HUE:
+		ctrl->value = priv->hue;
+		break;
+
+	case V4L2_CID_SATURATION:
+		ctrl->value = priv->sat;
+		break;
+	};
+
+	return 0;
+}
+
+static int ov7670_tweak_hue_or_sat(struct i2c_client *client,
+				   struct ov7670_soc_priv *priv)
+{
+	int matrix[6];
+
+	ov7670_calc_cmatrix(priv, matrix);
+
+	return ov7670_store_cmatrix(client, matrix);
+}
+
+static int ov7670_soc_set_crop(struct soc_camera_device *icd,
+			       struct v4l2_rect *rect)
+{
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct ov7670_soc_priv *priv = to_ov7670_soc(client);
+
+	if (!priv->fmt)
+		return -EINVAL;
+
+	return ov7670_soc_set_params(client, rect->width, rect->height,
+				     priv->fmt->fourcc);
+}
+
+/*
+ * Note that the brightness parameter is used for clock scaling. What would
+ * be more approriate?
+ */
+static int ov7670_soc_s_ctrl(struct v4l2_subdev *sd,
+			     struct v4l2_control *ctrl)
+{
+	int data, ret = 0, data2;
+	struct i2c_client *client = sd->priv;
+	struct ov7670_soc_priv *priv = to_ov7670_soc(client);
+	switch (ctrl->id) {
+	case V4L2_CID_EXPOSURE_AUTO:
+		data = ov7670_smbus_read_byte_data(client, REG_COM8);
+		if (data < 0) {
+			ret = data;
+			break;
+		}
+		data = ctrl->value ? data | COM8_AEC : data & ~COM8_AEC;
+		ret = i2c_smbus_write_byte_data(client, REG_COM8,
+						data);
+		break;
+
+	case V4L2_CID_EXPOSURE_ABSOLUTE:
+		data2 = ov7670_smbus_read_byte_data(client, REG_COM8);
+		if (data2 < 0) {
+			ret = data2;
+			break;
+		}
+
+		ret = i2c_smbus_write_byte_data(client, REG_COM8,
+						data2 & ~(COM8_AGC | COM8_AEC));
+		if (ret)
+			break;
+		data = ov7670_smbus_read_byte_data(client, REG_AECHH);
+		if (data < 0) {
+			ret = data;
+			break;
+		}
+		ret = i2c_smbus_write_byte_data(client, REG_AECHH,
+						(data & ~0x1F) |
+						((ctrl->value >> 10) & 0x1F));
+		if (ret)
+			break;
+
+		ret = i2c_smbus_write_byte_data(client, REG_AECH,
+						(ctrl->value >> 2) & 0xFF);
+		if (ret)
+			break;
+
+		data = ov7670_smbus_read_byte_data(client, REG_COM1);
+		if (data < 0) {
+			ret = data;
+			break;
+		}
+		ret = i2c_smbus_write_byte_data(client, REG_COM1,
+						(data & ~0x03) |
+						(ctrl->value & 0x03));
+		ret = i2c_smbus_write_byte_data(client, REG_COM8, data2);
+		if (ret)
+			break;
+		break;
+
+	case V4L2_CID_AUTO_WHITE_BALANCE:
+		data = ov7670_smbus_read_byte_data(client, REG_COM8);
+		if (data < 0) {
+			ret = data;
+			break;
+		}
+		data = ctrl->value ? data | COM8_AWB : data & ~COM8_AWB;
+		ret = i2c_smbus_write_byte_data(client, REG_COM8,
+						data);
+		break;
+
+	case V4L2_CID_AUTOGAIN:
+		data = ov7670_smbus_read_byte_data(client, REG_COM8);
+		if (data < 0) {
+			ret = data;
+			break;
+		}
+		data = ctrl->value ? data | COM8_AGC : data & ~COM8_AGC;
+		ret = i2c_smbus_write_byte_data(client, REG_COM8,
+						data);
+		break;
+
+	case V4L2_CID_CONTRAST:
+		ret = i2c_smbus_write_byte_data(client, REG_CONTRAST,
+						ctrl->value);
+		break;
+
+	case V4L2_CID_AUDIO_VOLUME:
+		/* need to disable the AGC and AEC before writing this */
+		data2 = ov7670_smbus_read_byte_data(client, REG_COM8);
+		if (data2 < 0) {
+			ret = data2;
+			break;
+		}
+		ret = i2c_smbus_write_byte_data(client, REG_COM8,
+						data2 & ~(COM8_AGC | COM8_AEC));
+		if (ret)
+			break;
+		ret = i2c_smbus_write_byte_data(client, REG_GAIN,
+						ctrl->value & 0xFF);
+		if (ret)
+			break;
+		data = ov7670_smbus_read_byte_data(client, REG_VREF);
+		if (data < 0) {
+			ret = data;
+			break;
+		}
+		ret = i2c_smbus_write_byte_data(client, REG_VREF,
+						((data & ~0xC0) |
+						 ((ctrl->value >> 2) & 0xC0)));
+		ret = i2c_smbus_write_byte_data(client, REG_COM8, data2);
+		break;
+
+	case V4L2_CID_VFLIP:
+		data = ov7670_smbus_read_byte_data(client, REG_MVFP);
+		if (data < 0) {
+			ret = data;
+			break;
+		}
+		data &= 127;
+		data = ctrl->value ? data | MVFP_FLIP : data & ~MVFP_FLIP;
+		ret = i2c_smbus_write_byte_data(client, REG_MVFP,
+						data);
+		break;
+
+	case V4L2_CID_HFLIP:
+		data = ov7670_smbus_read_byte_data(client, REG_MVFP);
+		if (data < 0) {
+			ret = data;
+			break;
+		}
+		ret = i2c_smbus_write_byte_data(client, REG_MVFP,
+						ctrl->value ? data | MVFP_MIRROR
+						: data & ~MVFP_MIRROR);
+		break;
+
+	case V4L2_CID_BRIGHTNESS:
+		data = ov7670_smbus_read_byte_data(client, REG_CLKRC);
+		if (data < 0) {
+			ret = data;
+			break;
+		}
+
+		ret = i2c_smbus_write_byte_data(client, REG_CLKRC,
+						ctrl->value |
+						(data & 0x80));
+		break;
+
+	case V4L2_CID_GAIN: /* doesn't seem to write successfully */
+		/* first disable auto stuff */
+		ret = i2c_smbus_write_byte_data(client,
+						REG_COM8,
+						COM8_FASTAEC
+						| COM8_AECSTEP
+						| COM8_BFILT);
+		if (ret)
+			break;
+		ret = i2c_smbus_write_byte_data(client, REG_GAIN,
+						ctrl->value & 0xFF);
+		if (ret)
+			break;
+		data = ov7670_smbus_read_byte_data(client, REG_VREF);
+		if (data < 0) {
+			ret = data;
+			break;
+		}
+		ret = i2c_smbus_write_byte_data(client, REG_VREF,
+						(data & ~0xC0) |
+						((ctrl->value & 0x300) << 6));
+		if (ret)
+			break;
+		/* reenable auto stuff */
+		ret = i2c_smbus_write_byte_data(client, REG_COM8,
+						COM8_FASTAEC |
+						COM8_AECSTEP |
+						COM8_BFILT |
+						COM8_AGC|COM8_AEC);
+		break;
+
+	case V4L2_CID_HUE:
+		/* update locale storage */
+		if (ctrl->value < -180 || ctrl->value > 180) {
+			ret = -EINVAL;
+			break;
+		}
+		priv->hue = ctrl->value;
+		ov7670_tweak_hue_or_sat(client, priv);
+		break;
+
+	case V4L2_CID_SATURATION:
+		/* update locale storage */
+		if (ctrl->value < 0 || ctrl->value > 256) {
+			ret = -EINVAL;
+			break;
+		}
+		priv->sat = ctrl->value;
+		ov7670_tweak_hue_or_sat(client, priv);
+		break;
+
+	case V4L2_CID_RED_BALANCE:
+		ret = i2c_smbus_write_byte_data(client, REG_RED,
+						ctrl->value);
+		break;
+
+	case V4L2_CID_BLUE_BALANCE:
+		ret = i2c_smbus_write_byte_data(client, REG_BLUE,
+						ctrl->value);
+		break;
+	}
+
+	return ret;
+}
+
+static struct soc_camera_ops ov7670_soc_ops = {
+	.set_crop = ov7670_soc_set_crop,
+	.set_bus_param = ov7670_soc_set_bus_param,
+	.query_bus_param = ov7670_soc_query_bus_param,
+	.controls = ov7670_soc_controls,
+	.num_controls = ARRAY_SIZE(ov7670_soc_controls),
+};
+
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+static int ov7670_soc_s_register(struct v4l2_subdev *sd,
+				 struct v4l2_dbg_register *reg)
+{
+	struct i2c_client *client = sd->priv;
+
+	if (reg->reg > 0xff ||
+	    reg->val > 0xff)
+		return -EINVAL;
+
+	return i2c_smbus_write_byte_data(client, reg->reg, reg->val);
+}
+
+static int ov7670_soc_g_register(struct v4l2_subdev *sd,
+				 struct v4l2_dbg_register *reg)
+{
+	struct i2c_client *client = sd->priv;
+	int ret;
+
+	reg->size = 1;
+	if (reg->reg > 0xff)
+		return -EINVAL;
+	ret = ov7670_smbus_read_byte_data(client, reg->reg);
+	if (ret < 0)
+		return ret;
+
+	reg->val = (__u64)ret;
+
+	return 0;
+}
+#endif /* CONFIG_VIDEO_ADV_DEBUG */
+
+static struct v4l2_subdev_core_ops ov7670_soc_subdev_core_ops = {
+	.g_ctrl = ov7670_soc_g_ctrl,
+	.s_ctrl = ov7670_soc_s_ctrl,
+	.g_chip_ident = ov7670_soc_g_chip_ident,
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	.g_register = ov7670_soc_g_register,
+	.s_register = ov7670_soc_s_register,
+#endif
+};
+
+static struct v4l2_subdev_video_ops ov7670_soc_subdev_video_ops = {
+	.s_fmt = ov7670_soc_s_fmt,
+	.try_fmt = ov7670_soc_try_fmt,
+	.s_stream = ov7670_soc_s_stream,
+};
+
+static struct v4l2_subdev_ops ov7670_soc_subdev_ops = {
+	.core = &ov7670_soc_subdev_core_ops,
+	.video = &ov7670_soc_subdev_video_ops,
+};
+
+
+static int ov7670_soc_probe(struct i2c_client *client,
+			    const struct i2c_device_id *did)
+{
+	struct ov7670_soc_priv *priv;
+	struct soc_camera_device *icd = client->dev.platform_data;
+	struct i2c_adapter        *adapter = to_i2c_adapter(client->dev.parent);
+	struct ov7670_soc_camera_info *info;
+	struct soc_camera_link *icl;
+	int ret;
+
+	if (!icd) {
+		dev_err(&client->dev, "OV7670_SOC: missing soc-camera data!\n");
+		return -EINVAL;
+	}
+
+	icl = to_soc_camera_link(icd);
+	if (!icl)
+		return -EINVAL;
+
+	info = container_of(icl, struct ov7670_soc_camera_info, link);
+
+	gpio_request(info->gpio_reset, "ov7670 soc reset");
+	gpio_request(info->gpio_pwr, "ov7670 soc power");
+
+	/* reset high for normal mode */
+	gpio_direction_output(info->gpio_reset, 1);
+	/* power down normal mode. */
+	gpio_direction_output(info->gpio_pwr, 0);
+	/* perform a hard reset as per tinyos code */
+	gpio_set_value(info->gpio_pwr, 1);
+	gpio_set_value(info->gpio_reset, 1);
+	mdelay(2);
+	gpio_set_value(info->gpio_pwr, 0);
+	gpio_set_value(info->gpio_reset, 0);
+	mdelay(2);
+	gpio_set_value(info->gpio_reset, 1);
+	mdelay(5);
+
+	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA)) {
+		dev_err(&adapter->dev,
+			"I2C-Adapter doesn't support "
+			"I2C_FUNC_SMBUS_BYTE_DATA\n");
+		return -EIO;
+	}
+
+	priv = kzalloc(sizeof *priv, GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->sat = 128;
+	priv->info = info;
+
+	v4l2_i2c_subdev_init(&priv->subdev, client, &ov7670_soc_subdev_ops);
+
+	icd->ops = &ov7670_soc_ops;
+	icd->width_max = MAX_WIDTH;
+	icd->height_max = MAX_HEIGHT;
+
+	ret = ov7670_soc_video_probe(icd, client);
+	if (ret) {
+		dev_err(&client->dev, "failure registering device\n");
+		i2c_set_clientdata(client, NULL);
+		kfree(priv);
+	}
+
+	return ret;
+}
+
+static int ov7670_soc_remove(struct i2c_client *client)
+{
+	struct ov7670_soc_priv *priv = i2c_get_clientdata(client);
+	struct soc_camera_deivce *icd = client->dev.platform_data;
+
+	ov7670_soc_video_remove(icd);
+	i2c_set_clientdata(client, NULL);
+	kfree(priv);
+
+	return 0;
+}
+static const struct i2c_device_id ov7670_soc_id[] = {
+	{ "ov7670_soc", 0x15},
+	{},
+};
+
+MODULE_DEVICE_TABLE(i2c, ov7670_soc_id);
+
+static struct i2c_driver ov7670_soc_i2c_driver = {
+	.driver = {
+		.name = "ov7670_soc",
+	},
+	.probe = ov7670_soc_probe,
+	.remove = ov7670_soc_remove,
+	.id_table = ov7670_soc_id,
+};
+
+static int __init ov7670_module_init(void)
+{
+	return i2c_add_driver(&ov7670_soc_i2c_driver);
+}
+
+static void __exit ov7670_module_exit(void)
+{
+	return i2c_del_driver(&ov7670_soc_i2c_driver);
+}
+
+module_init(ov7670_module_init);
+module_exit(ov7670_module_exit);
+
+MODULE_LICENSE("GPL");
diff --git a/include/media/ov7670_soc.h b/include/media/ov7670_soc.h
new file mode 100644
index 0000000..2f264b2
--- /dev/null
+++ b/include/media/ov7670_soc.h
@@ -0,0 +1,21 @@
+/* ov7670_soc Camera
+ *
+ * Copyright (C) 2009 Jonathan Cameron <jic23@cam.ac.uk>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __OV7670_SOC_H__
+#define __OV7670_SOC_H__
+
+#include <media/soc_camera.h>
+
+struct ov7670_soc_camera_info {
+	int gpio_pwr;
+	int gpio_reset;
+	struct soc_camera_link link;
+};
+
+#endif
