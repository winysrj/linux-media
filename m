Return-path: <linux-media-owner@vger.kernel.org>
Received: from ppsw-6.csi.cam.ac.uk ([131.111.8.136]:48610 "EHLO
	ppsw-6.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbZCORee (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2009 13:34:34 -0400
Message-ID: <49BD3669.1070409@cam.ac.uk>
Date: Sun, 15 Mar 2009 17:10:01 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: g.liakhovetski@gmx.de, corbet@lwn.net
Subject: RFC: ov7670 soc-camera driver 
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jonathan Cameron <jic23@cam.ac.uk>

OV7670 driver for soc-camera interfaces.

---
There is already an ov7670 driver in tree, but it is very interface
specific (olpc) and hence not much use for the crossbow IMB400 board
which is plugged into an imote 2 pxa271 main board.

Thanks go to Crossbow (www.xbow.com) for assistance in developing
this driver.

This is my first driver related to v4l let alone soc-camera so this
is probably full of errors.  All comments appreciated!

A couple of questions related to this patch.

Unfortunately the data ordering in rgb565 is not that expected by
the pxa271 which for reasons best known to someone else shuffles
the bit order coming off the camera.  I don't know if this is a
common problem.  I haven't been able to come up with a combination
of sensor and soc colour modes that will let this through. Anyone
else met a similar problem?  At the moment I'm relying on
board specific documentation explaining how to rebuild the data
once an image has been captured, but obviously this is far from
ideal.

The primary control on this chip related to shutter rate is actualy
the frame rate. There are rather complex (and largerly undocumented)
interactions between this setting and the auto brightness controls
etc. Anyone have any suggestions on a better way of specifying this?

Clearly this driver shares considerable portions of code with
Jonathan Corbet's driver (in tree). It would be complex to combine
the two drivers, but perhaps people feel this would be worthwhile?

Thanks,

---

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 19cf3b8..646aab3 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -779,6 +779,12 @@ config SOC_CAMERA_OV772X
 	help
 	  This is a ov772x camera driver
 
+config SOC_CAMERA_OV7670
+       tristate "ov7670 support with soc"
+       depends on SOC_CAMERA && I2C
+       help
+	  This is an ov7670 driver using the soc camera interface
+
 config VIDEO_PXA27x
 	tristate "PXA27x Quick Capture Interface driver"
 	depends on VIDEO_DEV && PXA27x && SOC_CAMERA
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 72f6d03..ba70539 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -142,6 +142,7 @@ obj-$(CONFIG_SOC_CAMERA_MT9M001)	+= mt9m001.o
 obj-$(CONFIG_SOC_CAMERA_MT9M111)	+= mt9m111.o
 obj-$(CONFIG_SOC_CAMERA_MT9T031)	+= mt9t031.o
 obj-$(CONFIG_SOC_CAMERA_MT9V022)	+= mt9v022.o
+obj-$(CONFIG_SOC_CAMERA_OV7670)		+= ov7670_soc.o
 obj-$(CONFIG_SOC_CAMERA_OV772X)		+= ov772x.o
 obj-$(CONFIG_SOC_CAMERA_PLATFORM)	+= soc_camera_platform.o
 obj-$(CONFIG_SOC_CAMERA_TW9910)		+= tw9910.o
diff --git a/drivers/media/video/ov7670_soc.c b/drivers/media/video/ov7670_soc.c
new file mode 100644
index 0000000..63cbe3b
--- /dev/null
+++ b/drivers/media/video/ov7670_soc.c
@@ -0,0 +1,1150 @@
+/*
+ * A V4L2 driver for OmniVision OV7670 cameras via soc interface
+ *
+ * Copyright 2006 One Laptop Per Child Association, Inc.  Written
+ * by Jonathan Corbet with substantial inspiration from Mark
+ * McClelland's ovcamchip code.
+ *
+ * Copyright 2006-7 Jonathan Corbet <corbet@lwn.net>
+ *
+ * Copyright 2009 Jonathan Cameron <jic23@cam.ac.uk>
+ *
+ * This file may be distributed under the terms of the GNU General
+ * Public License, version 2.
+ *
+ * Todo: Currently only VGA image resolution supported.
+ *
+ * Queries for review:
+ * 1) Here I'm using brightness controls for what are effectively shutter
+ * timings.  How should this be done?
+ */
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/videodev2.h>
+#include <media/v4l2-common.h>
+#include <media/v4l2-chip-ident.h>
+#include <linux/i2c.h>
+#include <linux/gpio.h>
+#include <linux/delay.h>
+#include <media/soc_camera.h>
+#include <media/ov7670_soc.h>
+/*
+ * Basic window sizes.  These probably belong somewhere more globally
+ * useful.
+ */
+#define VGA_WIDTH	640
+#define VGA_HEIGHT	480
+#define QVGA_WIDTH	320
+#define QVGA_HEIGHT	240
+#define CIF_WIDTH	352
+#define CIF_HEIGHT	288
+#define QCIF_WIDTH	176
+#define	QCIF_HEIGHT	144
+#define MAX_WIDTH VGA_WIDTH
+#define MAX_HEIGHT VGA_HEIGHT
+
+/* Registers */
+#define	REG_GAIN	0x00	/* Gain lower 8 bits (rest in vref) */
+#define REG_BLUE	0x01	/* blue gain */
+#define REG_RED		0x02	/* red gain */
+#define REG_VREF	0x03	/* Pieces of GAIN, VSTART, VSTOP */
+#define REG_COM1	0x04	/* Control 1 */
+#define		COM1_CCIR656	  0x40  /* CCIR656 enable */
+#define REG_BAVE	0x05	/* U/B Average level */
+#define REG_GbAVE	0x06	/* Y/Gb Average level */
+#define REG_AECHH	0x07	/* AEC MS 5 bits */
+#define REG_RAVE	0x08	/* V/R Average level */
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
+#define REG_CLKRC	0x11	/* Clocl control */
+#define		CLK_EXT	  0x40	  /* Use external clock directly */
+#define		CLK_SCALE	  0x3f	  /* Mask for internal clock scale */
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
+#define		COM7_PBAYER	  0x05	  /* "Processed bayer" */
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
+#define REG_HSYST	0x30	/* HSYNC rising edge delay */
+#define REG_HSYEN	0x31	/* HSYNC falling edge delay */
+#define REG_HREF	0x32	/* HREF pieces */
+#define REG_TSLB	0x3a	/* lots of stuff */
+#define		TSLB_YLAST	  0x04	  /* UYVY or VYUY - see com13 */
+#define REG_COM11	0x3b	/* Control 11 */
+#define		COM11_NIGHT	  0x80	  /* NIght mode enable */
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
+
+#define REG_BRIGHT	0x55	/* Brightness */
+#define REG_CONTRAS	0x56	/* Contrast control */
+
+#define REG_GFIX	0x69	/* Fix gain control */
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
+
+#define REG_BD50MAX	0xa5	/* 50hz banding step limit */
+#define REG_HAECC3	0xa6	/* Hist AEC/AGC control 3 */
+#define REG_HAECC4	0xa7	/* Hist AEC/AGC control 4 */
+#define REG_HAECC5	0xa8	/* Hist AEC/AGC control 5 */
+#define REG_HAECC6	0xa9	/* Hist AEC/AGC control 6 */
+#define REG_HAECC7	0xaa	/* Hist AEC/AGC control 7 */
+#define REG_BD60MAX	0xab	/* 60hz banding step limit */
+struct ov7670_color_format {
+	char				*name;
+	__u32				fourcc;
+	const struct regval_list	*regs;
+	unsigned int			option;
+	int				cmatrix[6];
+};
+
+struct ov7670_soc_win_size {
+	int	width;
+	int	height;
+	unsigned char com7_bit;
+	int	hstart;		/* Start/stop values for the camera.  Note */
+	int	hstop;		/* that they do not always make complete */
+	int	vstart;		/* sense to humans, but evidently the sensor */
+	int	vstop;		/* will do the right thing... */
+	struct regval_list *regs; /* Regs to tweak */
+/* h/vref stuff */
+};
+
+/* Only vga implemented as yet */
+static struct ov7670_soc_win_size  ov7670_soc_win_sizes[] = {
+	/* VGA */
+	{
+		.width		= VGA_WIDTH,
+		.height		= VGA_HEIGHT,
+		.com7_bit	= COM7_FMT_VGA,
+		.hstart		= 158,		/* These values from */
+		.hstop		=  14,		/* Omnivision */
+		.vstart		=  10,
+		.vstop		= 490,
+		.regs 		= NULL,
+	},
+	/* CIF */
+	{
+		.width		= CIF_WIDTH,
+		.height		= CIF_HEIGHT,
+		.com7_bit	= COM7_FMT_CIF,
+		.hstart		= 170,		/* Empirically determined */
+		.hstop		=  90,
+		.vstart		=  14,
+		.vstop		= 494,
+		.regs 		= NULL,
+	},
+	/* QVGA */
+	{
+		.width		= QVGA_WIDTH,
+		.height		= QVGA_HEIGHT,
+		.com7_bit	= COM7_FMT_QVGA,
+		.hstart		= 164,		/* Empirically determined */
+		.hstop		=  20,
+		.vstart		=  14,
+		.vstop		= 494,
+		.regs 		= NULL,
+	},
+};
+
+struct ov7670_soc_priv {
+	struct i2c_client *client;
+	struct soc_camera_link *link;
+	struct soc_camera_device icd;
+	const struct ov7670_color_format *fmt;
+	const struct ov7670_soc_win_size *win;
+	int model;
+	int gpio_reset;
+	int gpio_power;
+	int hue;
+	int sat;
+	int autoexposure;
+};
+
+struct regval_list {
+	unsigned char reg_num;
+	unsigned char value;
+};
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
+		.default_value = 1,
+	}, {
+		.id = V4L2_CID_AUTO_WHITE_BALANCE,
+		.name = "Auto White Balance",
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 1,
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
+		.minimum = 0,
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
+		.maximum = 256,
+		.step = 1,
+		.default_value = 0x80,
+	}
+};
+
+
+static struct regval_list ov7670_default_regs[] = {
+	{ REG_COM7, COM7_RESET },
+/*
+ * Clock scale: 5 Bytes (frequency divided by 1 this)
+ *              3 = 15fps
+ *              2 = 20fps
+ *              1 = 30fps
+ */
+	{ REG_CLKRC, 0x3 },	/* OV: clock scale (15 fps) */
+	{ REG_TSLB,  0x04 },	/* OV */
+	{ REG_COM7, 0 },	/* VGA */
+	/*
+	 * Set the hardware window.  These values from OV don't entirely
+	 * make sense - hstop is less than hstart.  But they work...
+	 */
+	{ REG_HSTART, 0x13 },	{ REG_HSTOP, 0x01 },
+	{ REG_HREF, 0xb6 },	{ REG_VSTART, 0x02 },
+	{ REG_VSTOP, 0x7a },	{ REG_VREF, 0x0a },
+
+	{ REG_COM3, 0 },	{ REG_COM14, 0 },
+	/* Mystery scaling numbers */
+	{ 0x70, 0x3a },		{ 0x71, 0x35 },
+	{ 0x72, 0x11 },		{ 0x73, 0xf0 },
+	{ 0xa2, 0x02 },		{ REG_COM10, 0x0 },
+
+	/* Gamma curve values */
+	{ 0x7a, 0x20 },		{ 0x7b, 0x10 },
+	{ 0x7c, 0x1e },		{ 0x7d, 0x35 },
+	{ 0x7e, 0x5a },		{ 0x7f, 0x69 },
+	{ 0x80, 0x76 },		{ 0x81, 0x80 },
+	{ 0x82, 0x88 },		{ 0x83, 0x8f },
+	{ 0x84, 0x96 },		{ 0x85, 0xa3 },
+	{ 0x86, 0xaf },		{ 0x87, 0xc4 },
+	{ 0x88, 0xd7 },		{ 0x89, 0xe8 },
+
+	/* AGC and AEC parameters.  Note we start by disabling those features,
+	   then turn them only after tweaking the values. */
+	{ REG_COM8, COM8_FASTAEC | COM8_AECSTEP | COM8_BFILT },
+	{ REG_GAIN, 0 },	{ REG_AECH, 0 },
+	{ REG_COM4, 0x40 }, /* magic reserved bit */
+	{ REG_COM9, 0x18 }, /* 4x gain + magic rsvd bit */
+	{ REG_BD50MAX, 0x05 },	{ REG_BD60MAX, 0x07 },
+	{ REG_AEW, 0x95 },	{ REG_AEB, 0x33 },
+	{ REG_VPT, 0xe3 },	{ REG_HAECC1, 0x78 },
+	{ REG_HAECC2, 0x68 },	{ 0xa1, 0x03 }, /* magic */
+	{ REG_HAECC3, 0xd8 },	{ REG_HAECC4, 0xd8 },
+	{ REG_HAECC5, 0xf0 },	{ REG_HAECC6, 0x90 },
+	{ REG_HAECC7, 0x94 },
+	{ REG_COM8, COM8_FASTAEC|COM8_AECSTEP|COM8_BFILT|COM8_AGC|COM8_AEC },
+
+
+	/* Almost all of these are magic "reserved" values.  */
+	{ REG_COM5, 0x61 },	{ REG_COM6, 0x4b },
+	{ 0x16, 0x02 },		{ REG_MVFP, 0x07 },
+	{ 0x21, 0x02 },		{ 0x22, 0x91 },
+	{ 0x29, 0x07 },		{ 0x33, 0x0b },
+	{ 0x35, 0x0b },		{ 0x37, 0x1d },
+	{ 0x38, 0x71 },		{ 0x39, 0x2a },
+	{ REG_COM12, 0x78 },	{ 0x4d, 0x40 },
+	{ 0x4e, 0x20 },		{ REG_GFIX, 0 },
+	{ 0x6b, 0x4a },		{ 0x74, 0x10 },
+	{ 0x8d, 0x4f },		{ 0x8e, 0 },
+	{ 0x8f, 0 },		{ 0x90, 0 },
+	{ 0x91, 0 },		{ 0x96, 0 },
+	{ 0x9a, 0 },		{ 0xb0, 0x84 },
+	{ 0xb1, 0x0c },		{ 0xb2, 0x0e },
+	{ 0xb3, 0x82 },		{ 0xb8, 0x0a },
+
+	/* More reserved magic, some of which tweaks white balance */
+	{ 0x43, 0x0a },		{ 0x44, 0xf0 },
+	{ 0x45, 0x34 },		{ 0x46, 0x58 },
+	{ 0x47, 0x28 },		{ 0x48, 0x3a },
+	{ 0x59, 0x88 },		{ 0x5a, 0x88 },
+	{ 0x5b, 0x44 },		{ 0x5c, 0x67 },
+	{ 0x5d, 0x49 },		{ 0x5e, 0x0e },
+	{ 0x6c, 0x0a },		{ 0x6d, 0x55 },
+	{ 0x6e, 0x11 },		{ 0x6f, 0x9f }, /* "9e for advance AWB" */
+	{ 0x6a, 0x40 },		{ REG_BLUE, 0x40 },
+	{ REG_RED, 0x60 },
+	{ REG_COM8, COM8_FASTAEC
+	  | COM8_AECSTEP
+	  | COM8_BFILT
+	  | COM8_AGC
+	  | COM8_AEC
+	  | COM8_AWB },
+
+	{ REG_COM16, COM16_AWBGAIN },	{ REG_EDGE, 0 },
+	/* Edge enhancement and black pixel / white pixel correction */
+	{ REG_REG75, 0x05 },		{ 0x76, 0xe1 },
+	/* Denoise strength and offest */
+	{ REG_DNSTH, 0 },		{ 0x77, 0x01 },
+	{ REG_COM13, 0xc2 },	{ 0x4b, 0x09 },
+	{ 0xc9, 0x60 },		{ REG_COM16, 0x38 },
+	{ 0x56, 0x40 },
+
+	{ 0x34, 0x11 },		{ REG_COM11, COM11_EXP|COM11_HZAUTO },
+	{ 0xa4, 0x88 },		{ 0x96, 0 },
+	{ 0x97, 0x30 },		{ 0x98, 0x20 },
+	{ 0x99, 0x30 },		{ 0x9a, 0x84 },
+	{ 0x9b, 0x29 },		{ 0x9c, 0x03 },
+	{ 0x9d, 0x4c },		{ 0x9e, 0x3f },
+	{ 0x78, 0x04 },
+
+	/* Extra-weird stuff.  Some sort of multiplexor register */
+	{ 0x79, 0x01 },		{ 0xc8, 0xf0 },
+	{ 0x79, 0x0f },		{ 0xc8, 0x00 },
+	{ 0x79, 0x10 },		{ 0xc8, 0x7e },
+	{ 0x79, 0x0a },		{ 0xc8, 0x80 },
+	{ 0x79, 0x0b },		{ 0xc8, 0x01 },
+	{ 0x79, 0x0c },		{ 0xc8, 0x0f },
+	{ 0x79, 0x0d },		{ 0xc8, 0x20 },
+	{ 0x79, 0x09 },		{ 0xc8, 0x80 },
+	{ 0x79, 0x02 },		{ 0xc8, 0xc0 },
+	{ 0x79, 0x03 },		{ 0xc8, 0x40 },
+	{ 0x79, 0x05 },		{ 0xc8, 0x30 },
+	{ 0x79, 0x26 },
+
+	{ 0xff, 0xff },	/* END MARKER */
+};
+
+/*
+ * Here we'll try to encapsulate the changes for just the output
+ * video format.
+ *
+ * RGB656 and YUV422 come from OV; RGB444 is homebrewed.
+ *
+ * IMPORTANT RULE: the first entry must be for COM7, see ov7670_s_fmt for why.
+ */
+
+
+static struct regval_list ov7670_fmt_yuv422[] = {
+	{ REG_COM7, 0x0 },	/* Selects YUV mode */
+	{ REG_RGB444, 0 },	/* No RGB444 please */
+	{ REG_COM1, 0 },	/* no ccir656 aec low 2 lsb to 0 */
+	{ REG_COM15, COM15_R00FF }, /* data range, 0x00 to 0xff */
+	{ REG_COM9, 0x18 },	/* 4x gain ceiling; 0x8 is reserved bit */
+	{ REG_COM13, 0},
+	{ 0xff, 0xff },
+};
+
+
+static struct regval_list ov7670_fmt_rgb565[] = {
+	{ REG_COM7, COM7_RGB },	/* Selects RGB mode */
+	{ REG_RGB444, 0 },	/* No RGB444 please */
+	{ REG_COM1, 0x0 },
+	{ REG_COM15, COM15_RGB565 },
+	{ REG_COM9, 0x38 }, 	/* 16x gain ceiling; 0x8 is reserved bit */
+	{ REG_COM13, COM13_GAMMA|COM13_UVSAT },
+	{ 0xff, 0xff },
+};
+/* Not currently used */
+static struct regval_list ov7670_fmt_raw[] = {
+	{ REG_COM7, COM7_BAYER },
+	{ REG_COM13, 0x08 }, /* No gamma, magic rsvd bit */
+	{ REG_COM16, 0x3d }, /* Edge enhancement, denoise */
+	{ REG_REG76, 0xe1 }, /* Pix correction, magic rsvd */
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
+	}, {
+		SETFOURCC(SBGGR8),
+		.depth = 8,
+		.colorspace = V4L2_COLORSPACE_SRGB,
+	}
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
+	}, {
+		SETFOURCC(SBGGR8),
+		.regs = ov7670_fmt_raw,
+		.cmatrix = {0, 0, 0, 0, 0, 0},
+	},
+};
+
+#define SIN_STEP 5
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
+		sine = ov7670_sin_table[theta/SIN_STEP];
+	else {
+		theta -= 90;
+		sine = 1000 - ov7670_sin_table[theta/SIN_STEP];
+	}
+	return sine*chs;
+}
+
+static int ov7670_cosine(int theta)
+{
+	theta = 90 - theta;
+	if (theta > 180)
+		theta -= 360;
+	else if (theta < -180)
+		theta += 360;
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
+#define OV_VERSION(pid, ver) ((pid << 8) | (ver & 0xFF))
+#define OV7670_VER OV_VERSION(0x76, 0x73)
+
+/* A quirk in smbus implementation requires a stop before a repeated
+ * start. This necesitates this function.
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
+static int ov7670_soc_video_probe(struct soc_camera_device *icd)
+{
+	struct ov7670_soc_priv *priv
+		= container_of(icd, struct ov7670_soc_priv, icd);
+	s32 pid, ver;
+	s32 ret;
+	const char *devname;
+
+	icd->formats = ov7670_soc_fmt_lists;
+	icd->num_formats = ARRAY_SIZE(ov7670_soc_fmt_lists);
+
+	/* Sanity check? */
+	i2c_smbus_write_byte_data(priv->client, REG_COM7, COM7_RESET);
+	mdelay(1);
+
+	pid = ov7670_smbus_read_byte_data(priv->client, REG_PID);
+	ver = ov7670_smbus_read_byte_data(priv->client, REG_VER);
+	switch (OV_VERSION(pid, ver)) {
+	case OV7670_VER:
+		devname = "ov7670";
+		priv->model = V4L2_IDENT_OV7670;
+		break;
+	default:
+		dev_err(&icd->dev,
+			"Product ID error %x:%x\n", pid, ver);
+		return -ENODEV;
+	}
+	dev_info(&icd->dev,
+		 "%s Product ID %0x:%0x Manufacturer ID %x:%x\n",
+		 devname,
+		 pid,
+		 ver,
+		 ov7670_smbus_read_byte_data(priv->client, REG_MIDH),
+		 ov7670_smbus_read_byte_data(priv->client, REG_MIDL));
+	ret = soc_camera_video_start(icd);
+
+	return ret;
+}
+
+static void ov7670_soc_video_remove(struct soc_camera_device *icd)
+{
+	soc_camera_video_stop(icd);
+}
+
+static int ov7670_store_cmatrix(struct i2c_client *c, const int *matrix)
+{
+	int signbits, i, ret;
+
+	signbits = ov7670_smbus_read_byte_data(c, REG_CMATRIX_SIGN);
+	if (signbits < 0)
+		return -EIO;
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
+	return i2c_smbus_write_byte_data(c, REG_CMATRIX_SIGN, signbits);
+}
+static int ov7670_write_array(struct i2c_client *c, const struct regval_list *vals)
+{
+	while (vals->reg_num != 0xff || vals->value != 0xff) {
+		int ret = i2c_smbus_write_byte_data(c,
+						    vals->reg_num,
+						    vals->value);
+		if (ret < 0)
+			return ret;
+		msleep(1);
+		vals++;
+	}
+	return 0;
+}
+static int ov7670_soc_init(struct soc_camera_device *icd)
+{
+	struct ov7670_soc_priv *priv
+		= container_of(icd, struct ov7670_soc_priv, icd);
+	int ret = 0;
+
+	if (priv->link->power) {
+		ret = priv->link->power(&priv->client->dev, 1);
+		if (ret < 0)
+			return ret;
+	}
+	if (priv->link->reset) {
+		ret = priv->link->reset(&priv->client->dev);
+		if (ret < 0)
+			return ret;
+	}
+	ret = ov7670_write_array(priv->client, ov7670_default_regs);
+	return ret;
+}
+
+static int ov7670_soc_get_chip_id(struct soc_camera_device *icd,
+				  struct v4l2_dbg_chip_ident *id)
+{
+	struct ov7670_soc_priv *priv
+		= container_of(icd, struct ov7670_soc_priv, icd);
+
+	id->ident    = priv->model;
+	id->revision = 0;
+
+	return 0;
+}
+
+static unsigned long ov7670_soc_query_bus_param(struct soc_camera_device *icd)
+{
+	struct ov7670_soc_priv *priv
+		= container_of(icd, struct ov7670_soc_priv, icd);
+	struct soc_camera_link *icl = priv->link;
+	unsigned long flags = SOCAM_PCLK_SAMPLE_RISING | SOCAM_MASTER |
+		SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_HSYNC_ACTIVE_HIGH |
+		SOCAM_DATAWIDTH_8;
+
+	return soc_camera_apply_sensor_flags(icl, flags);
+}
+
+static int ov7670_soc_set_bus_param(struct soc_camera_device *icd,
+				    unsigned long flags)
+{
+	return 0;
+}
+
+static const struct ov7670_soc_win_size *
+ov7670_soc_select_win(u32 width, u32 height)
+{
+	const struct ov7670_soc_win_size *wsize;
+
+	/* relies on them being in size order */
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
+static int ov7670_soc_set_format(struct soc_camera_device *icd,
+			      __u32 pixfmt,
+			      struct v4l2_rect *rect)
+{
+	struct ov7670_soc_priv *priv
+		= container_of(icd, struct ov7670_soc_priv, icd);
+	int ret = -EINVAL;
+	int i;
+	int data = 0 ;
+	int matrix[CMATRIX_LEN];
+	priv->fmt = NULL;
+	for (i = 0; i < ARRAY_SIZE(ov7670_cfmts); i++)
+		if (pixfmt == ov7670_cfmts[i].fourcc) {
+			priv->fmt = ov7670_cfmts + i;
+			ret = 0;
+			break;
+		}
+	if (priv->fmt->fourcc == V4L2_PIX_FMT_RGB565) {
+		data = ov7670_smbus_read_byte_data(priv->client,
+						   REG_CLKRC);
+		if (ret)
+			goto error_ret;
+	}
+
+	if (priv->fmt->regs) {
+		ret = ov7670_write_array(priv->client, priv->fmt->regs);
+		if (ret)
+			goto error_ret;
+	}
+	ov7670_calc_cmatrix(priv, matrix);
+	ret = ov7670_store_cmatrix(priv->client, matrix);
+	if (ret)
+		goto error_ret;
+	priv->win = ov7670_soc_select_win(rect->width, rect->height);
+	if (priv->fmt->fourcc == V4L2_PIX_FMT_RGB565)
+		ret = i2c_smbus_write_byte_data(priv->client,
+						REG_CLKRC,
+						data);
+error_ret:
+	return ret;
+}
+
+static int ov7670_soc_try_format(struct soc_camera_device *icd,
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
+static int ov7670_soc_stop_capture(struct soc_camera_device *icd)
+{
+	return 0;
+}
+
+static int ov7670_soc_start_capture(struct soc_camera_device *icd)
+{
+	return 0;
+}
+
+static int ov7670_soc_release(struct soc_camera_device *icd)
+{
+	return 0;
+}
+
+static int ov7670_soc_get_control(struct soc_camera_device *icd,
+				  struct v4l2_control *ctrl)
+{
+	int data;
+	struct ov7670_soc_priv *priv
+		= container_of(icd, struct ov7670_soc_priv, icd);
+	switch (ctrl->id) {
+	case V4L2_CID_CONTRAST:
+		data = ov7670_smbus_read_byte_data(priv->client, REG_CONTRAS);
+		if (data < 0)
+			return data;
+		ctrl->value = data;
+		break;
+	case V4L2_CID_EXPOSURE_AUTO:
+		data = ov7670_smbus_read_byte_data(priv->client, REG_COM8);
+		if (data < 0)
+			return data;
+		ctrl->value = !!(data & COM8_AEC);
+		break;
+	case V4L2_CID_AUTO_WHITE_BALANCE:
+		data = ov7670_smbus_read_byte_data(priv->client, REG_COM8);
+		if (data < 0)
+			return data;
+		ctrl->value = !!(data & COM8_AWB);
+		break;
+	case V4L2_CID_AUTOGAIN:
+		data = ov7670_smbus_read_byte_data(priv->client, REG_COM8);
+		if (data < 0)
+			return data;
+		ctrl->value = !!(data & COM8_AGC);
+		break;
+	case V4L2_CID_VFLIP:
+		data = ov7670_smbus_read_byte_data(priv->client, REG_MVFP);
+		if (data < 0)
+			return data;
+		ctrl->value = !!(data & MVFP_FLIP);
+		break;
+	case V4L2_CID_HFLIP:
+		data = ov7670_smbus_read_byte_data(priv->client, REG_MVFP);
+		if (data < 0)
+			return data;
+		ctrl->value = !!(data & MVFP_MIRROR);
+		break;
+	case V4L2_CID_BRIGHTNESS:
+		data = ov7670_smbus_read_byte_data(priv->client, REG_CLKRC);
+		if (data < 0)
+			return data;
+		ctrl->value = data & 0x1F;
+		break;
+	case V4L2_CID_HUE:
+		ctrl->value = priv->hue;
+		break;
+	case V4L2_CID_SATURATION:
+		ctrl->value = priv->sat;
+		break;
+	};
+	return 0;
+}
+
+static int ov7670_tweak_hue_or_sat(struct i2c_client *client,
+				   struct ov7670_soc_priv *priv)
+{
+	int matrix[6];
+	ov7670_calc_cmatrix(priv, matrix);
+	return ov7670_store_cmatrix(client, matrix);
+}
+/*
+ * Note that the brightness parameter is used for clock scaling. Effectively
+ * exposure.  This is because soc-camera intercepts exposure (not sure why).
+ */
+static int ov7670_soc_set_control(struct soc_camera_device *icd,
+				  struct v4l2_control *ctrl)
+{
+	int data, ret = 0;
+	struct ov7670_soc_priv *priv
+		= container_of(icd, struct ov7670_soc_priv, icd);
+	switch (ctrl->id) {
+	case V4L2_CID_EXPOSURE_AUTO:
+		data = ov7670_smbus_read_byte_data(priv->client, REG_COM8);
+		if (data < 0) {
+			ret = data;
+			break;
+		}
+		data = ctrl->value ? data | COM8_AEC : data & ~COM8_AEC;
+		ret = i2c_smbus_write_byte_data(priv->client, REG_COM8,
+						data);
+		break;
+	case V4L2_CID_AUTO_WHITE_BALANCE:
+		data = ov7670_smbus_read_byte_data(priv->client, REG_COM8);
+		if (data < 0) {
+			ret = data;
+			break;
+		}
+		data = ctrl->value ? data | COM8_AWB : data & ~COM8_AWB;
+		ret = i2c_smbus_write_byte_data(priv->client, REG_COM8,
+						data);
+		break;
+	case V4L2_CID_AUTOGAIN:
+		data = ov7670_smbus_read_byte_data(priv->client, REG_COM8);
+		if (data < 0) {
+			ret = data;
+			break;
+		}
+		data = ctrl->value ? data | COM8_AGC : data & ~COM8_AGC;
+		ret = i2c_smbus_write_byte_data(priv->client, REG_COM8,
+						data);
+		break;
+	case V4L2_CID_CONTRAST:
+		ret = i2c_smbus_write_byte_data(priv->client, REG_CONTRAS,
+						ctrl->value);
+		break;
+	case V4L2_CID_VFLIP:
+		data = ov7670_smbus_read_byte_data(priv->client, REG_MVFP);
+		if (data < 0) {
+			ret = data;
+			break;
+		}
+		data &= 127;
+		data = ctrl->value ? data | MVFP_FLIP : data & ~MVFP_FLIP;
+		ret = i2c_smbus_write_byte_data(priv->client, REG_MVFP,
+						data);
+		break;
+	case V4L2_CID_HFLIP:
+		data = ov7670_smbus_read_byte_data(priv->client, REG_MVFP);
+		if (data < 0) {
+			ret = data;
+			break;
+		}
+		ret = i2c_smbus_write_byte_data(priv->client, REG_MVFP,
+						ctrl->value ? data | MVFP_MIRROR
+						: data & ~MVFP_MIRROR);
+		break;
+	case V4L2_CID_BRIGHTNESS:
+		data = ov7670_smbus_read_byte_data(priv->client, REG_CLKRC);
+		if (data < 0) {
+			ret = data;
+			break;
+		}
+		ret = i2c_smbus_write_byte_data(priv->client, REG_CLKRC,
+						ctrl->value |
+						(data & 0x80));
+		break;
+	case V4L2_CID_GAIN: /* doesn't seem to write successfully */
+		/* first disable auto stuff */
+		ret = i2c_smbus_write_byte_data(priv->client,
+						REG_COM8,
+						COM8_FASTAEC
+						| COM8_AECSTEP
+						| COM8_BFILT);
+		if (ret)
+			break;
+		ret = i2c_smbus_write_byte_data(priv->client, REG_GAIN,
+						ctrl->value & 0xFF);
+		if (ret)
+			break;
+		data = ov7670_smbus_read_byte_data(priv->client, REG_VREF);
+		if (data < 0) {
+			ret = data;
+			break;
+		}
+		ret = i2c_smbus_write_byte_data(priv->client, REG_VREF,
+						(data & ~0xC0) |
+						((ctrl->value & 0x300) << 6));
+		if (ret)
+			break;
+		/* reenable auto stuff */
+		ret = i2c_smbus_write_byte_data(priv->client, REG_COM8,
+						COM8_FASTAEC |
+						COM8_AECSTEP |
+						COM8_BFILT |
+						COM8_AGC|COM8_AEC);
+		break;
+	case V4L2_CID_HUE:
+		/* update locale storage */
+		if (ctrl->value < -180 || ctrl->value > 180) {
+			ret = -EINVAL;
+			break;
+		}
+		priv->hue = ctrl->value;
+		ov7670_tweak_hue_or_sat(priv->client, priv);
+		break;
+	case V4L2_CID_SATURATION:
+		/* update locale storage */
+		if (ctrl->value < 0 || ctrl->value > 256) {
+			ret = -EINVAL;
+			break;
+		}
+		priv->sat = ctrl->value;
+		ov7670_tweak_hue_or_sat(priv->client, priv);
+		break;
+	};
+	return ret;
+}
+static struct soc_camera_ops ov7670_soc_ops = {
+	.owner = THIS_MODULE,
+	.probe = ov7670_soc_video_probe,
+	.remove = ov7670_soc_video_remove,
+	.init = ov7670_soc_init,
+	.release = ov7670_soc_release,
+	.start_capture = ov7670_soc_start_capture,
+	.stop_capture = ov7670_soc_stop_capture,
+	.set_fmt = ov7670_soc_set_format,
+	.try_fmt = ov7670_soc_try_format,
+	.set_bus_param = ov7670_soc_set_bus_param,
+	.query_bus_param = ov7670_soc_query_bus_param,
+	.get_chip_id = ov7670_soc_get_chip_id,
+	.controls = ov7670_soc_controls,
+	.num_controls = ARRAY_SIZE(ov7670_soc_controls),
+	.get_control = ov7670_soc_get_control,
+	.set_control = ov7670_soc_set_control,
+};
+
+
+
+static int ov7670_soc_probe(struct i2c_client *client,
+			    const struct i2c_device_id *did)
+{
+	struct ov7670_soc_priv *priv;
+	struct soc_camera_device *icd;
+	struct ov7670_soc_camera_info *info = client->dev.platform_data;
+	int ret;
+	/* reset high for normal mode */
+	gpio_direction_output(info->gpio_reset, 1);
+	/* power down normal mode. */
+	gpio_direction_output(info->gpio_pwr, 0);
+
+/* perform a hard reset as per tinyos code */
+
+	gpio_set_value(info->gpio_pwr, 1);
+	gpio_set_value(info->gpio_reset, 1);
+	mdelay(2);
+	gpio_set_value(info->gpio_pwr, 0);
+	gpio_set_value(info->gpio_reset, 0);
+	mdelay(2);
+	gpio_set_value(info->gpio_reset, 1);
+	mdelay(5);
+
+	priv = kzalloc(sizeof *priv, GFP_KERNEL);
+	if (!priv) {
+		dev_err(&client->dev, "private data allocation failed\n");
+		return -ENOMEM;
+	}
+	priv->autoexposure = 1;
+	priv->link = info->iclink;
+	if (!priv->link) {
+		dev_err(&client->dev, "No platform data supplied\n");
+		return -EINVAL;
+	}
+	priv->sat = 128;
+	priv->client = client;
+	i2c_set_clientdata(client, priv);
+
+	icd = &priv->icd;
+	icd->ops = &ov7670_soc_ops;
+	icd->control = &client->dev;
+	icd->width_max = MAX_WIDTH;
+	icd->height_max = MAX_HEIGHT;
+	icd->iface = priv->link->bus_id;
+
+	ret = soc_camera_device_register(icd);
+	if (ret) {
+		dev_err(&client->dev, "failure registering device\n");
+		i2c_set_clientdata(client, NULL);
+		kfree(priv);
+	}
+	return ret;
+}
+
+static int ov7670_soc_remove(struct i2c_client *client)
+{
+	struct ov7670_soc_priv *priv = i2c_get_clientdata(client);
+	soc_camera_device_unregister(&priv->icd);
+	kfree(priv);
+	return 0;
+}
+static const struct i2c_device_id ov7670_soc_id[] = {
+	{ "ov7670_soc", 0x15},
+	{},
+};
+
+MODULE_DEVICE_TABLE(i2c, ov7670_soc_id);
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
index 0000000..e9419a4
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
+	struct soc_camera_link *iclink;
+};
+
+#endif
