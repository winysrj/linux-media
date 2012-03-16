Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:63484 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161205Ab2CPWQN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Mar 2012 18:16:13 -0400
Received: by wibhq7 with SMTP id hq7so1484967wib.1
        for <linux-media@vger.kernel.org>; Fri, 16 Mar 2012 15:16:11 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: linux-media@vger.kernel.org
Cc: moinejf@free.fr, mchehab@redhat.com,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH] [RFT/RFC] Add gspca subdriver for Speedlink VAD Laplace (EM2765+OV2640)
Date: Fri, 16 Mar 2012 23:15:45 +0100
Message-Id: <1331936145-11839-1-git-send-email-fschaefer.oss@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch is the result of 3 months of reverse engineering work.
It is NOT intended for kernel inclusion.
No decision has been made yet wether support for this device should be added this way or as enhancement/modification of the em28xx driver.
Hence the main purpose of this patch is to provide an insight into the charactersitics and functionality of this device.
Anyway, I would be glad to get some feedback concerning form and content of the code, becausse I'm still a newbie to kernel programming.

The driver is feature complete and working stable, but some cleanups are outstanding (see coments).
For a better understanding of the device, see http://linuxtv.org/wiki/index.php/VAD_Laplace
---
 drivers/media/video/gspca/Kconfig  |    9 +
 drivers/media/video/gspca/Makefile |    2 +
 drivers/media/video/gspca/em27xx.c | 1822 ++++++++++++++++++++++++++++++++++++
 drivers/media/video/gspca/gspca.c  |    5 +-
 4 files changed, 1836 insertions(+), 2 deletions(-)
 create mode 100644 drivers/media/video/gspca/em27xx.c

diff --git a/drivers/media/video/gspca/Kconfig b/drivers/media/video/gspca/Kconfig
index dfe268b..02c0c2a 100644
--- a/drivers/media/video/gspca/Kconfig
+++ b/drivers/media/video/gspca/Kconfig
@@ -50,6 +50,15 @@ config USB_GSPCA_CPIA1
 	  To compile this driver as a module, choose M here: the
 	  module will be called gspca_cpia1.
 
+config USB_GSPCA_EM27XX
+	tristate "EM27xx USB Camera Driver"
+	depends on VIDEO_V4L2 && USB_GSPCA
+	help
+	  Say Y here if you want support for EM27xx cameras.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called gspca_em27xx.
+
 config USB_GSPCA_ETOMS
 	tristate "Etoms USB Camera Driver"
 	depends on VIDEO_V4L2 && USB_GSPCA
diff --git a/drivers/media/video/gspca/Makefile b/drivers/media/video/gspca/Makefile
index 79ebe46..8c2bd29 100644
--- a/drivers/media/video/gspca/Makefile
+++ b/drivers/media/video/gspca/Makefile
@@ -2,6 +2,7 @@ obj-$(CONFIG_USB_GSPCA)          += gspca_main.o
 obj-$(CONFIG_USB_GSPCA_BENQ)     += gspca_benq.o
 obj-$(CONFIG_USB_GSPCA_CONEX)    += gspca_conex.o
 obj-$(CONFIG_USB_GSPCA_CPIA1)    += gspca_cpia1.o
+obj-$(CONFIG_USB_GSPCA_EM27XX)   += gspca_em27xx.o
 obj-$(CONFIG_USB_GSPCA_ETOMS)    += gspca_etoms.o
 obj-$(CONFIG_USB_GSPCA_FINEPIX)  += gspca_finepix.o
 obj-$(CONFIG_USB_GSPCA_JEILINJ)  += gspca_jeilinj.o
@@ -47,6 +48,7 @@ gspca_main-objs     := gspca.o
 gspca_benq-objs     := benq.o
 gspca_conex-objs    := conex.o
 gspca_cpia1-objs    := cpia1.o
+gspca_em27xx-objs   := em27xx.o
 gspca_etoms-objs    := etoms.o
 gspca_finepix-objs  := finepix.o
 gspca_jeilinj-objs  := jeilinj.o
diff --git a/drivers/media/video/gspca/em27xx.c b/drivers/media/video/gspca/em27xx.c
new file mode 100644
index 0000000..3147f55
--- /dev/null
+++ b/drivers/media/video/gspca/em27xx.c
@@ -0,0 +1,1822 @@
+/*
+ * gspca subdriver for em27xx cameras
+ *
+ * Copyright (C) 2011-2012  Frank Schaefer <fschaefer.oss@googlemail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+
+#define MODULE_NAME "em27xx"
+
+#include "gspca.h"
+#include <media/v4l2-chip-ident.h>
+#include <linux/workqueue.h>
+#include <linux/input.h>
+
+
+#define CHIP_ID_EM2765		0x36
+
+#define CHIP_ID_OMNIVISION	0x7fa2
+#define	CHIP_ID_OV2640		0x2642 /* also 0x2641 ? */
+
+
+/* EM27xx */
+#define EM27XX_R05_I2CSTATUS		0x05
+#define EM27XX_R06_I2CCLK		0x06
+#define EM27XX_R08_GPIO			0x08
+#define EM27XX_R0A_CHIPID		0x0a
+#define EM27XX_R0C_USBSUSP		0x0c
+#define EM27XX_R0D			0x0d
+#define EM27XX_R0F_XCLK			0x0f
+#define EM27XX_R10_VINMODE		0x10
+#define EM27XX_R11_VINCTRL		0x11
+#define EM27XX_R12_VINENABLE		0x12
+#define EM27XX_R13			0x13
+#define EM27XX_R14_GAMMA		0x14
+#define EM27XX_R15_RGAIN		0x15
+#define EM27XX_R16_GGAIN		0x16
+#define EM27XX_R17_BGAIN		0x17
+#define EM27XX_R18_ROFFSET		0x18
+#define EM27XX_R19_GOFFSET		0x19
+#define EM27XX_R1A_BOFFSET		0x1a
+#define EM27XX_R1B_OFLOW		0x1b
+#define EM27XX_R1C_HSTART		0x1c
+#define EM27XX_R1D_VSTART		0x1d
+#define EM27XX_R1E_CWIDTH		0x1e
+#define EM27XX_R1F_CHEIGHT		0x1f
+#define EM27XX_R20_YGAIN		0x20	/* Contrast */
+#define EM27XX_R21_YOFFSET		0x21	/* Brightness */
+#define EM27XX_R22_UVGAIN		0x22	/* Saturation */
+#define EM27XX_R23_UOFFSET		0x23
+#define EM27XX_R24_VOFFSET		0x24
+#define EM27XX_R25_SHARPNESS		0x25	/* Sharpness */
+#define EM27XX_R26_COMPR		0x26
+#define EM27XX_R27_OUTFMT		0x27
+#define EM27XX_R28_XMIN			0x28
+#define EM27XX_R29_XMAX			0x29
+#define EM27XX_R2A_YMIN			0x2a
+#define EM27XX_R2B_YMAX			0x2b
+#define EM27XX_R30_HSCALELOW		0x30
+#define EM27XX_R31_HSCALEHIGH		0x31
+#define EM27XX_R32_VSCALELOW		0x32
+#define EM27XX_R33_VSCALEHIGH		0x33
+#define EM27XX_R34_START_H		0x34
+#define EM27XX_R35_START_V		0x35
+#define EM27XX_R44_AUDIOCTRL		0x44
+#define EM27XX_R80_GPIO_1_W		0x80
+#define EM27XX_R84_GPIO_1_R		0x84
+#define EM27XX_R85_GPIO_2_R		0x85
+
+/* EM27XX_R84_GPIO_1_R + EM27XX_R80_GPIO_1_W */
+#define EM27XX_GPIO_1_LED_STREAM	0x01	/* inverted */
+#define EM27XX_GPIO_1_LED_LIGHT		0x40	/* inverted */
+#define EM27XX_GPIO_1_BUTTON_MUTE	0x04	/* inverted */
+#define EM27XX_GPIO_1_BUTTON_LIGHT	0x08	/* inverted */
+
+/* EM27XX_R85_GPIO_1_R */
+#define EM27XX_GPIO_2_BUTTON_SNAPSHOT	0x80	/* inverted */
+
+
+#define CTRL_TIMEOUT 		HZ	/* 1 sec */
+#define GPIO_POLL_INTERVAL	100
+#define LED_BLINK_INTERVAL	500
+
+
+#define BRIGHTNESS_DEFAULT		-0x0e	/* -0x80 to 0x7f (s8 !) */
+#define CONTRAST_DEFAULT		0x0f	/* 0x00 to 0x1f */
+#define SATURATION_DEFAULT		0x0f	/* 0x00 to 0x1f */
+#define SHARPNESS_DEFAULT		0x00	/* 0x00 to 0x0f */
+#define POWERLINEFREQFILTER_DEFAULT	0x00	/* 0 to 2 */
+
+
+#define BULK_HEADER_FRAME_STILL_IMAGE	0x20
+#define BULK_HEADER_FRAME_END		0x02
+#define BULK_HEADER_FRAME_ID		0x01
+
+
+
+MODULE_AUTHOR("Frank Schaefer <fschaefer.oss@googlemail.com>");
+MODULE_DESCRIPTION("GSPCA/em27xx camera driver");
+MODULE_LICENSE("GPL");
+
+
+
+/* specific webcam descriptor */
+struct sd {
+	struct gspca_dev gspca_dev; /* must be the first item */
+	u8 sensor;
+	u8 sensor_addr;
+
+	u8 eeprom_addr;
+	
+	s8 brightness;
+	u8 contrast;
+	u8 saturation;
+	u8 sharpness;
+	u8 plfreqfilter;
+
+	bool muted;
+	bool illuminated;
+
+	bool mutebutton_locked;
+	bool lightbutton_locked;
+
+	struct delayed_work gpio_query_work;
+	struct delayed_work led_blink_work;
+};
+
+static u8 sensor_slave_addresses[] = {
+	0x22,	/* UNKNOWN */
+	0x66,	/* UNKNOWN */
+	0x42,	/* UNKNOWN */
+	0x60,	/* OV2640 */
+};
+
+#define	SENSOR_OV2640		0	/* must match index in sensor_ident */
+
+static u16 sensor_ident[] = {
+	V4L2_IDENT_OV2640,
+};
+
+static int sd_getbrightness(struct gspca_dev *gspca_dev, s32 *val);
+static int sd_setbrightness(struct gspca_dev *gspca_dev, s32 val);
+static int sd_getcontrast(struct gspca_dev *gspca_dev, s32 *val);
+static int sd_setcontrast(struct gspca_dev *gspca_dev, s32 val);
+static int sd_getsaturation(struct gspca_dev *gspca_dev, s32 *val);
+static int sd_setsaturation(struct gspca_dev *gspca_dev, s32 val);
+static int sd_getsharpness(struct gspca_dev *gspca_dev, s32 *val);
+static int sd_setsharpness(struct gspca_dev *gspca_dev, s32 val);
+static int sd_getpowerlinefreqfilter(struct gspca_dev *gspca_dev, s32 *val);
+static int sd_setpowerlinefreqfilter(struct gspca_dev *gspca_dev, s32 val);
+
+/* V4L2 controls supported by the driver */
+static const struct ctrl sd_ctrls[] = {
+	{
+		{
+		    .id      = V4L2_CID_BRIGHTNESS,
+		    .type    = V4L2_CTRL_TYPE_INTEGER,
+		    .name    = "Brightness",
+		    .minimum = -0x80,
+		    .maximum = 0x7f,
+		    .step    = 1,
+		    .default_value = BRIGHTNESS_DEFAULT,
+		    /* NOTE: value stored in register as signed 8 bit */
+		},
+		.get = sd_getbrightness,
+		.set = sd_setbrightness,
+	},
+	{
+		{
+		    .id      = V4L2_CID_CONTRAST,
+		    .type    = V4L2_CTRL_TYPE_INTEGER,
+		    .name    = "Contrast",
+		    .minimum = 0,
+		    .maximum = 0x1f,
+		    .step    = 1,
+		    .default_value = CONTRAST_DEFAULT,
+		},
+		.get = sd_getcontrast,
+		.set = sd_setcontrast,
+	},
+	{
+		{
+		    .id      = V4L2_CID_SATURATION,
+		    .type    = V4L2_CTRL_TYPE_INTEGER,
+		    .name    = "Saturation",
+		    .minimum = 0,
+		    .maximum = 0x1f,
+		    .step    = 1,
+		    .default_value = SATURATION_DEFAULT,
+		},
+		.get = sd_getsaturation,
+		.set = sd_setsaturation,
+	},
+	{
+		{
+		    .id      = V4L2_CID_SHARPNESS,
+		    .type    = V4L2_CTRL_TYPE_INTEGER,
+		    .name    = "Sharpness",
+		    .minimum = 0,
+		    .maximum = 0x0f,
+		    .step    = 1,
+		    .default_value = SHARPNESS_DEFAULT,
+		},
+		.get = sd_getsharpness,
+		.set = sd_setsharpness,
+	},
+	{
+		{
+			.id	 = V4L2_CID_POWER_LINE_FREQUENCY,
+			.type    = V4L2_CTRL_TYPE_MENU,
+			.name    = "Power line frequency filter",
+			.minimum = 0,
+			.maximum = 2,	/* 0: off, 1: 50Hz, 2: 60Hz */
+			.step    = 1,
+			.default_value = POWERLINEFREQFILTER_DEFAULT,
+		},
+		.get = sd_getpowerlinefreqfilter,
+		.set = sd_setpowerlinefreqfilter,
+	},
+};
+
+/* Picture formats supported by the driver */
+static const struct v4l2_pix_format video_camera_mode[] = {
+	/* NOTE: The windows driver provides 176x144 and 160x120 resolutions
+	 * by software downscaling from 320x240
+	 */
+	{320, 240, V4L2_PIX_FMT_RGB565, V4L2_FIELD_NONE,
+	 .bytesperline = 320 * 2,
+	 .sizeimage = 320 * 240 * 2,
+	 .colorspace = V4L2_COLORSPACE_SRGB,
+	 .priv = 0},
+	{320, 240, V4L2_PIX_FMT_YUYV, V4L2_FIELD_NONE,
+	 .bytesperline = 320 * 2,
+	 .sizeimage = 320 * 240 * 2,
+	 .colorspace = V4L2_COLORSPACE_SRGB,
+	 .priv = 0},
+	{640, 480, V4L2_PIX_FMT_RGB565, V4L2_FIELD_NONE,
+	 .bytesperline = 640 * 2,
+	 .sizeimage = 640 * 480 * 2,
+	 .colorspace = V4L2_COLORSPACE_SRGB,
+	 .priv = 0},
+	{640, 480, V4L2_PIX_FMT_YUYV, V4L2_FIELD_NONE,
+	 .bytesperline = 640 * 2,
+	 .sizeimage = 640 * 480 * 2,
+	 .colorspace = V4L2_COLORSPACE_SRGB,
+	 .priv = 0},
+	{1280, 1024, V4L2_PIX_FMT_SRGGB8, V4L2_FIELD_NONE,
+	 .bytesperline = 1280 * 1,
+	 .sizeimage = 1280 * 1024 * 1,
+	 .colorspace = V4L2_COLORSPACE_SRGB,
+	 .priv = 0},
+/*	{1280, 1024, V4L2_PIX_FMT_YUV211, V4L2_FIELD_NONE,		
+	 .bytesperline = 1280 * 1,
+	 .sizeimage = 1280 * 1024 * 1,
+	 .colorspace = V4L2_COLORSPACE_SRGB,
+	 .priv = 0},						*/
+	// TODO: add support to the kernel
+	{1600, 1200, V4L2_PIX_FMT_SRGGB8, V4L2_FIELD_NONE,
+	 .bytesperline = 1600 * 1,
+	 .sizeimage = 1600 * 1200 * 1,
+	 .colorspace = V4L2_COLORSPACE_SRGB,
+	 .priv = 0},
+/*	{1600, 1200, V4L2_PIX_FMT_YUV211, V4L2_FIELD_NONE,
+	 .bytesperline = 1600 * 1,
+	 .sizeimage = 1600 * 1200 * 1,
+	 .colorspace = V4L2_COLORSPACE_SRGB,
+	 .priv = 0},						*/
+	// TODO: add support to the kernel
+};
+
+/* This sequence is common to all resolutions / operation modes */
+static u8 ov2640_init[][2] = {
+	{0xff, 0x01}, {0x12, 0x80}, {0xff, 0x00}, {0x2c, 0xff}, {0x2e, 0xdf},
+	{0xff, 0x01}, {0x3c, 0x32}, {0x11, 0x00}, {0x09, 0x02}, {0x04, 0x28},
+	{0x13, 0xe5}, {0x14, 0x40}, {0x2c, 0x0c}, {0x33, 0x78}, {0x3a, 0x33},
+	{0x3b, 0xfb}, {0x3e, 0x00}, {0x43, 0x11}, {0x16, 0x10}, {0x39, 0x02},
+	{0x35, 0x88}, {0x22, 0x0a}, {0x37, 0x40}, {0x23, 0x00}, {0x34, 0xa0},
+	{0x36, 0x1a}, {0x06, 0x02}, {0x07, 0xc0}, {0x0d, 0xb7}, {0x0e, 0x01},
+	{0x4c, 0x00}, {0x4a, 0x81}, {0x21, 0x99}, {0x24, 0x40}, {0x25, 0x38},
+	{0x26, 0x82}, {0x5c, 0x00}, {0x63, 0x00}, {0x20, 0x80}, {0x28, 0x30},
+	{0x6c, 0x00}, {0x6d, 0x80}, {0x6e, 0x00}, {0x70, 0x02}, {0x71, 0x94},
+	{0x73, 0xc1}, {0x3d, 0x34}, {0x5a, 0x57}, {0x4e, 0x00}, {0x4f, 0xca},
+	{0x50, 0xa8}, {0xff, 0x00}, {0xe5, 0x7f}, {0xf9, 0xc0}, {0x41, 0x24},
+	{0xe0, 0x14}, {0x76, 0xff}, {0x33, 0xa0}, {0x42, 0x20}, {0x43, 0x18},
+	{0x4c, 0x00}, {0x87, 0xd0}, {0x88, 0x3f}, {0xd7, 0x03}, {0xd9, 0x10},
+	{0xd3, 0x82}, {0xc8, 0x08}, {0xc9, 0x80}, {0x7c, 0x00}, {0x7d, 0x00},
+	{0x7c, 0x03}, {0x7d, 0x48}, {0x7d, 0x48}, {0x7c, 0x08}, {0x7d, 0x20},
+	{0x7d, 0x10}, {0x7d, 0x0e}, {0x92, 0x00}, {0x93, 0x06}, {0x93, 0xe4},
+	{0x93, 0x05}, {0x93, 0x05}, {0x93, 0x00}, {0x93, 0x04}, {0x93, 0x00},
+	{0x93, 0x00}, {0x93, 0x00}, {0x93, 0x00}, {0x93, 0x00}, {0x93, 0x00},
+	{0x93, 0x00}, {0xc3, 0xed}, {0xa4, 0x00}, {0xa8, 0x00}, {0xc5, 0x11},
+	{0xc6, 0x51}, {0xbf, 0x80}, {0xc7, 0x00}, {0xb6, 0x4d}, {0xb8, 0xa5},
+	{0xb7, 0x64}, {0xb9, 0x7c}, {0xb3, 0xaf}, {0xb4, 0x97}, {0xb5, 0xff},
+	{0xb0, 0xc5}, {0xb1, 0x94}, {0xb2, 0x0f}, {0xc4, 0x5c}, {0xc0, 0xc8},
+	{0xc1, 0x96}, {0x86, 0x1d}, {0x50, 0x00}, {0x51, 0x90}, {0x52, 0x18},
+	{0x53, 0x00}, {0x54, 0x00}, {0x55, 0x88}, {0x57, 0x00}, {0x5a, 0x90},
+	{0x5b, 0x18}, {0x5c, 0x05}, {0xc3, 0xed}, {0x7f, 0x00}, {0xda, 0x00},
+	{0xe5, 0x1f}, {0xe1, 0x67}, {0xe0, 0x00}, {0xdd, 0x7f}, {0x05, 0x00},
+	{0xff, 0x01}, {0x7c, 0x05}, {0x79, 0xa3}, {0x62, 0x6f}, {0x61, 0x63},
+	{0x75, 0xe0}, {0x76, 0xe0}, {0x77, 0xf0}, {0x78, 0xef}, {0xff, 0x00},
+	{0x90, 0x00}, {0x91, 0x0e}, {0x91, 0x1a}, {0x91, 0x31}, {0x91, 0x5a},
+	{0x91, 0x69}, {0x91, 0x75}, {0x91, 0x7e}, {0x91, 0x88}, {0x91, 0x8f},
+	{0x91, 0x96}, {0x91, 0xa3}, {0x91, 0xaf}, {0x91, 0xc4}, {0x91, 0xd7},
+	{0x91, 0xe8}, {0x91, 0x20}, {0xff, 0x00}, {0xc8, 0x00}, {0x96, 0x00},
+	{0x97, 0x08}, {0x97, 0x19}, {0x97, 0x02}, {0x97, 0x0c}, {0x97, 0x23},
+	{0x97, 0x31}, {0x97, 0x29}, {0x97, 0x25}, {0x97, 0x02}, {0x97, 0x98},
+	{0x97, 0x80}, {0x97, 0x00}, {0xff, 0x00}, {0xa6, 0x00}, {0xa7, 0xb8},
+	{0xa7, 0x38}, {0xa7, 0x19}, {0xa7, 0x21}, {0xa7, 0x59}, {0xa7, 0x23},
+	{0xa7, 0xb8}, {0xa7, 0x38}, {0xa7, 0x17}, {0xa7, 0x21}, {0xa7, 0x59},
+	{0xa7, 0x24}, {0xa7, 0xb8}, {0xa7, 0x38}, {0xa7, 0x18}, {0xa7, 0x21},
+	{0xa7, 0x59}, {0xa7, 0x27}, {0xc3, 0xef}, {0xff, 0x01}, {0x14, 0x40},
+	{0x0f, 0x4b}, {0x03, 0x8f}, {0xff, 0x00}, {0xbf, 0x00}, {0xba, 0xff},
+	{0xbb, 0x00}, {0xb6, 0x4d}, {0xb8, 0x78}, {0xb7, 0x20}, {0xb9, 0x40},
+	{0xb3, 0xb8}, {0xb4, 0xc5}, {0xb5, 0xed}, {0xb0, 0x7f}, {0xb1, 0x5e},
+	{0xb2, 0x07}, {0xc7, 0x00}, {0xc6, 0x51}, {0xc5, 0x11}, {0xc4, 0x5c},
+	{0xff, 0x00}, {0x86, 0x1d}, {0xc8, 0x08}, {0xc9, 0x92}, {0x7c, 0x03},
+	{0xff, 0x01}, {0x22, 0x0a},
+};
+
+static int read_usbdev(struct gspca_dev *gspca_dev, u8 request, u16 index,
+		       u8 *data, u16 length)
+{
+	int ret;
+	int err;
+	if (unlikely(length > USB_BUF_SZ))
+		return -EMSGSIZE;
+	for (err=0; err<3; err++) {
+		ret = usb_control_msg(gspca_dev->dev,
+				      usb_rcvctrlpipe(gspca_dev->dev, 0),
+				      request,
+				      USB_DIR_IN | USB_TYPE_VENDOR
+				       | USB_RECIP_DEVICE,
+				      0,
+				      index,
+				      gspca_dev->usb_buf, length,
+				      CTRL_TIMEOUT);
+		if (ret == length) {
+			memcpy(data, gspca_dev->usb_buf, length);
+			break;
+		}
+	}
+	return ret;
+}
+
+static int write_usbdev(struct gspca_dev *gspca_dev, u8 request, u16 index,
+			u8 *data, u16 length)
+{
+	int ret;
+	int err;
+	if (unlikely(length > USB_BUF_SZ))
+		return -EMSGSIZE;
+	memcpy(gspca_dev->usb_buf, data, length);
+	for (err=0; err<3; err++) {
+		ret = usb_control_msg(gspca_dev->dev,
+				      usb_sndctrlpipe(gspca_dev->dev, 0),
+				      request,
+				      USB_DIR_OUT | USB_TYPE_VENDOR
+				       | USB_RECIP_DEVICE,
+				      0,
+				      index,
+				      gspca_dev->usb_buf, length,
+				      CTRL_TIMEOUT);
+		if (ret == length)
+			break;
+	}
+	return ret;
+}
+
+static int read_em27xx(struct gspca_dev *gspca_dev, u16 reg, u8 *data,
+		       u16 len)
+{
+	u8 request = 0x00;
+	u16 index = reg;
+	int ret;
+
+	if ((reg + len - 1) > 0xffff)
+		return -EOVERFLOW;
+	ret = read_usbdev(gspca_dev, request, index, data, len);
+	if (ret < 0)
+		PDEBUG(D_ERR | D_USBI,
+		       "error: failed to read %d bytes from em27xx "
+		       "register 0x%04x",
+		       len, reg);
+	else
+		PDEBUG(D_USBI, "%d byte(s) read from EM27xx register 0x%04x",
+		       len, reg); 
+	return ret;
+}
+
+static int write_em27xx(struct gspca_dev *gspca_dev, u16 reg, u8 *data,
+			u16 len)
+{
+	u8 request = 0x00;
+	u16 index = reg;
+	int ret;
+
+	if ((reg + len - 1) > 0xffff)
+		return -EOVERFLOW;
+	ret =  write_usbdev(gspca_dev, request, index, data, len);
+	if (ret < 0)
+		PDEBUG(D_ERR | D_USBO,
+		       "error: failed to write %d bytes to em27xx "
+		       "register 0x%04x",
+		       len, reg);
+	else
+		PDEBUG(D_USBO, "%d byte(s) written to EM27xx register 0x%04x",
+		       len, reg);
+	return ret;
+}
+
+static int write_em27xx_single(struct gspca_dev *gspca_dev, u16 reg, u8 data)
+{
+	return write_em27xx(gspca_dev, reg, &data, 1);
+}
+
+/* 16 bit address and 8 bit register width */
+static int read_i2c(struct gspca_dev *gspca_dev, u8 i2c_slave_addr, u16 reg,
+		    u8 *data, u16 len)
+{
+	u8 request;
+	u16 index;
+	u8 buf[2];
+	int ret;
+	int err;
+
+	if ((reg + len - 1) > 0xffff)
+		return -EOVERFLOW;
+
+	index = i2c_slave_addr;
+
+	for (err=0; err<3; err++) {
+		/* Set register */
+		request = 0x03;
+		buf[0] = reg >> 8;
+		buf[1] = reg & 0xff;
+		ret = write_usbdev(gspca_dev, request, index, buf, 2);
+		if (ret < 0) {
+			PDEBUG(D_ERR | D_USBO,
+			       "error: sending i2c set register request "
+			       "failed: %d",
+			       ret);
+			break;
+		}
+
+		/* Check success */
+		ret = read_em27xx(gspca_dev, EM27XX_R05_I2CSTATUS, buf, 1);
+		if (ret < 0) {
+			PDEBUG(D_ERR,
+			       "error: sending check i2c status request "
+			       "failed: %d",
+			       ret);
+			continue;
+		}
+		if (buf[0] != 0x00) {
+		  	/* NOTE: the only error we've seen so far is 
+			 * 0x10 when the slave device is not present */
+			PDEBUG(D_ERR,
+			       "error: setting i2c register failed: "
+			       "i2c status 0x%02x",
+			       buf[0]);
+			ret = -EIO;
+			continue;
+		}
+
+		/* Read value */
+		request = 0x02;
+		ret = read_usbdev(gspca_dev, request, index, data, len);
+		if (ret < 0) {
+			PDEBUG(D_ERR | D_USBI,
+			       "error: sending i2c read register failed: %d",
+			       ret);
+			continue;
+		}
+
+		/* Check success */
+		ret = read_em27xx(gspca_dev, EM27XX_R05_I2CSTATUS, buf, 1);
+		if (ret < 0) {
+			PDEBUG(D_ERR,
+			       "error: sending check i2c status request "
+			       "failed: %d",
+			       ret);
+			continue;
+		}
+		if (buf[0] != 0x00) {
+			PDEBUG(D_ERR, 
+			       "error: reading i2c register failed: "
+			       "i2c status 0x%02x",
+			       buf[0]);
+			ret = -EIO;
+			continue;
+		}
+
+		PDEBUG(D_USBI,
+		       "%d byte(s) read from i2c slave address 0x%02x, "
+		       "register 0x%04x",
+		       len, i2c_slave_addr, reg);
+		return len;
+	}
+
+	PDEBUG(D_ERR | D_USBO, 
+	       "error: failed to read %d byte(s) from i2c slave "
+	       "address 0x%02x, register 0x%04x",
+	       len, i2c_slave_addr, reg);
+	return ret;
+}
+
+/* 16 bit address and 8 bit register width */
+/*
+static int write_i2c_single(struct gspca_dev *gspca_dev, u8 i2c_slave_addr,
+                            u16 reg, u8 data)
+{
+	u8 request;
+	u16 index;
+	u8 buf[3];
+	int ret;
+	int err;
+
+	for (err=0; err<3; err++) {
+		// Set register and write data
+		request = 0x03;
+		index = i2c_slave_addr;
+		buf[0] = reg >> 8;
+		buf[1] = reg & 0xff;
+		buf[2] = data;
+		ret = write_usbdev(gspca_dev, request, index, buf, 3);
+		if (ret < 0) {
+			PDEBUG(D_ERR | D_USBO,
+			       "error: sending i2c write register request "
+			       "failed: %d",
+			       ret);
+			break;
+		}
+
+		// Check success
+		ret = read_em27xx(gspca_dev, EM27XX_R05_I2CSTATUS, buf, 1);
+		if (ret < 0) {
+			PDEBUG(D_ERR,
+			       "error: sending check i2c status request "
+			       "failed: %d",
+			       ret);
+			continue;
+		}
+		if (buf[0] != 0x00) {
+			// NOTE: the only error we've seen so far is
+			// 0x10 when the slave device is not present
+			PDEBUG(D_ERR,
+			       "error: reading i2c register failed: "
+			       "i2c status 0x%02x",
+			       buf[0]);
+			ret = -EIO;
+			continue;
+		}
+
+		PDEBUG(D_USBO, 
+		       "1 byte written to i2c slave 0x%02x, register 0x%04x",
+		       i2c_slave_addr, reg);
+		return 1;
+	}
+	PDEBUG(D_ERR | D_USBO, 
+	       "error: failed to write 1 byte to slave address 0x%02x, "
+	       "register 0x%04x",
+	       i2c_slave_addr, reg);
+	return ret;
+
+	// NOTE: we could write more than 1 byte...
+
+} // NOT YET NEEDED, COMPLETELY UNTESTED !
+*/
+
+/* 8 bit address and register width */
+static int read_prop(struct gspca_dev *gspca_dev, u8 slave_addr, u8 reg,
+		     u8 *data, u8 len)
+{
+	u8 request;
+	u16 index;
+	u8 buf[2];
+	int ret;
+	int err;
+	int i;
+
+	if ((reg + len - 1) > 0xff)
+		return -EOVERFLOW;
+
+	for (i=0; i<len; i++) {
+		for (err=0; err<3; err++) {
+			/* Set register */
+			request = 0x06;
+			index = slave_addr;
+			buf[0] = reg + i;
+			ret = write_usbdev(gspca_dev, request, index, buf, 1);
+			if (ret < 0) {
+				PDEBUG(D_ERR | D_USBO,
+				       "error: sending proprietary set "
+				       "register request failed: %d",
+				       ret);
+				return ret;
+			}
+
+			/* Check success */
+			request = 0x08;
+			index = 0x0000;
+			ret = read_usbdev(gspca_dev, request, index, buf, 1);
+			if (ret < 0) {
+				PDEBUG(D_ERR | D_USBI,
+				       "error: sending check proprietary comm"
+				       "unication status request failed: %d",
+				       ret);
+				continue;
+			}
+			if (buf[0] != 0x00) {
+				/* NOTE: the only error we've seen so far is
+				 * 0x01 when the slave device is not present */
+				PDEBUG(D_ERR,
+				       "error: proprietary set register failed: "
+				       "status 0x%02x",
+				       buf[0]);
+				ret = -EIO;
+				continue;
+			}
+
+			/* Read value  */
+			request = 0x06;
+			index = slave_addr;	// need cast ?
+			ret = read_usbdev(gspca_dev, request, index, data + i, 1);
+			if (ret < 0) {
+				PDEBUG(D_ERR | D_USBI,
+				       "error: sending proprietary read "
+				       "register request failed: %d",
+				       ret);
+				continue;
+			}
+			/* NOTE:
+			 * Only 1 byte can be read per request. If n > 1 bytes
+			 * are requested, the device returns n bytes which have
+			 * all the same value (the value of the current
+			 * register).					     */
+
+			/* Check success */
+			request = 0x08;
+			index = 0x0000;
+			ret = read_usbdev(gspca_dev, request, index, buf, 1);
+			if (ret < 0) {
+				PDEBUG(D_ERR | D_USBI,
+				       "error: sending check proprietary comm"
+				       "unication status request failed: %d",
+				       ret);
+				continue;
+			}
+			if (buf[0] != 0x00) {
+				PDEBUG(D_ERR, 
+				       "error: proprietary read register "
+				       "failed: status 0x%02x",
+				       buf[0]);
+				ret = -EIO;
+				continue;
+			}
+			
+			break;
+		}
+		if (ret < 0) {
+			PDEBUG(D_ERR | D_USBO,
+			       "error: failed to read %d byte(s) from slave "
+			       "address 0x%02x, register 0x%02x",
+			       len, slave_addr, reg);
+			return ret;
+		}
+	}
+
+	PDEBUG(D_USBI,
+	       "%d byte(s) read from proprietary slave address 0x%02x, "
+	       "register 0x%02x",
+	       len, slave_addr, reg);
+	return len;
+}
+
+/* 8 bit address and register width */
+static int write_prop(struct gspca_dev *gspca_dev, u8 slave_addr,
+		      u8 reg, u8 *data, u8 len)
+{
+	u8 request;
+	u16 index;
+	u8 buf[2];
+	int ret;
+	int err;
+	int i;
+
+	if ((reg + len - 1) > 0xff)
+		return -EOVERFLOW;
+
+	for (i=0; i<len; i++) {
+		for (err=0; err<3; err++) {
+			/* Set register and write value */
+			request = 0x06;
+			index = slave_addr;
+			buf[0] = reg + i;
+			buf[1] = data[i];
+			ret = write_usbdev(gspca_dev, request, index, buf, 2);
+			if (ret < 0) {
+				PDEBUG(D_ERR | D_USBO,
+				       "error: sending proprietary write "
+				       "register request failed: %d",
+				       ret);
+				break;
+			}
+			/* NOTE:
+			* The device always uses the first submitted byte as
+			* address and the last submitted byte as value.
+			* All other bytes are ignored !			    */
+
+			/* Check success */
+			request = 0x08;
+			index = 0x0000;
+			ret = read_usbdev(gspca_dev, request, index, buf, 1);
+			if (ret < 0) {
+				PDEBUG(D_ERR | D_USBI,
+				       "error: sending check proprietary comm"
+				       "unication status request failed: %d",
+				       ret);
+				continue;
+			}
+			if (buf[0] != 0x00) {
+				PDEBUG(D_ERR,
+				       "error: proprietary write register "
+				       "failed: status 0x%02x",
+				       buf[0]);
+				ret = -EIO;
+				continue;
+			}
+
+			break;
+		}
+		if (ret < 0) {
+			PDEBUG(D_ERR | D_USBO,
+			       "error: failed to write %d byte(s) to slave "
+			       "address 0x%02x, register 0x%02x",
+			       len, slave_addr, reg);
+			return ret;
+		}
+	}
+
+	PDEBUG(D_USBO,
+	       "%d byte(s) written to proprietary slave address 0x%02x, "
+	       "register 0x%02x",
+	       len, slave_addr, reg);
+	return len;
+}
+
+/* 8 bit address and register width */
+static int write_prop_single(struct gspca_dev *gspca_dev, u8 slave_addr,
+			     u8 reg, u8 data)
+{
+	return write_prop(gspca_dev, slave_addr, reg, &data, 1);
+}
+
+static int sd_getbrightness(struct gspca_dev *gspca_dev, s32 *val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	*val = sd->brightness;
+	return 0;
+}
+
+static int sd_setbrightness(struct gspca_dev *gspca_dev, s32 val)
+{
+	int ret;
+	struct sd *sd = (struct sd *) gspca_dev;
+	if (!sd->muted)
+	{
+		ret = write_em27xx_single(gspca_dev, EM27XX_R21_YOFFSET,
+					  (u8)val);
+		if (ret < 0)
+		return ret;
+	}
+	sd->brightness = val;
+	return 0;
+}
+
+static int sd_getcontrast(struct gspca_dev *gspca_dev, s32 *val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	*val = sd->contrast;
+	return 0;
+}
+
+static int sd_setcontrast(struct gspca_dev *gspca_dev, s32 val)
+{
+	int ret;
+	struct sd *sd = (struct sd *) gspca_dev;
+	if (!sd->muted)
+	{
+		ret = write_em27xx_single(gspca_dev, EM27XX_R20_YGAIN, val);
+		if (ret < 0)
+			return ret;
+	}
+	sd->contrast = val;
+	return 0;
+}
+
+static int sd_getsaturation(struct gspca_dev *gspca_dev, s32 *val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	*val = sd->saturation;
+	return 0;
+}
+
+static int sd_setsaturation(struct gspca_dev *gspca_dev, s32 val)
+{
+	int ret;
+	struct sd *sd = (struct sd *) gspca_dev;
+	if (!sd->muted)
+	{
+		ret = write_em27xx_single(gspca_dev, EM27XX_R22_UVGAIN, val);
+		if (ret < 0)
+			return ret;
+	}
+	sd->saturation = val;
+	return 0;
+}
+
+static int sd_getsharpness(struct gspca_dev *gspca_dev, s32 *val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	*val = sd->sharpness;
+	return 0;
+}
+
+static int sd_setsharpness(struct gspca_dev *gspca_dev, s32 val)
+{
+	int ret;
+	struct sd *sd = (struct sd *) gspca_dev;
+	ret = write_em27xx_single(gspca_dev, EM27XX_R25_SHARPNESS, val);
+	if (ret < 0)
+		return ret;
+
+	sd->sharpness = val;
+	return 0;
+}
+
+static int sd_getpowerlinefreqfilter(struct gspca_dev *gspca_dev, s32 *val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	*val = sd->plfreqfilter;
+	return 0;
+}
+
+static int sd_setpowerlinefreqfilter(struct gspca_dev *gspca_dev, s32 val)
+{
+	int ret;
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	ret = write_prop_single(gspca_dev, sd->sensor_addr, 0xff, 0x01);
+	ret = write_prop_single(gspca_dev, sd->sensor_addr, 0x13, 0xe5); // COM8: auto exposure + auto AGC + banding filter on
+	if (val == 1) {
+		ret = write_prop_single(gspca_dev, sd->sensor_addr,
+					0x0c, 0x3c); // COM3: snapshot option=live video output after snapshot sequence, manual banding selection, banding=50Hz
+		if (gspca_dev->cam.cam_mode[gspca_dev->curr_mode].width
+		     <= 640)                                            {
+			ret = write_prop_single(gspca_dev, sd->sensor_addr,
+						0x4e, 0x00); // COM25: banding AEC 2 MSBs
+			ret = write_prop_single(gspca_dev, sd->sensor_addr,
+						0x4f, 0xca); // BD50: 50Hz banding AEC 8 LSBs
+		} else {
+			ret = write_prop_single(gspca_dev, sd->sensor_addr,
+						0x4e, 0x50); // COM25: banding AEC 2 MSBs
+			ret = write_prop_single(gspca_dev, sd->sensor_addr,
+						0x4f, 0x74); // BD50: 50Hz banding AEC 8 LSBs
+		}
+	} else if (val == 2) {
+		ret = write_prop_single(gspca_dev, sd->sensor_addr,
+					0x0c, 0x38); // COM3: snapshot option=live video output after snapshot sequence, manual banding selection, banding=60Hz
+		if (gspca_dev->cam.cam_mode[gspca_dev->curr_mode].width
+		     <= 640)                                            {
+			ret = write_prop_single(gspca_dev, sd->sensor_addr,
+						0x4e, 0x00); // COM25: banding AEC 2 MSBs
+			ret = write_prop_single(gspca_dev, sd->sensor_addr,
+						0x50, 0xa8); // BD60: 60Hz banding AEC 8 LSBs
+		} else {
+			ret = write_prop_single(gspca_dev, sd->sensor_addr,
+						0x4e, 0x50); // COM25: banding AEC 2 MSBs
+			ret = write_prop_single(gspca_dev, sd->sensor_addr,
+						0x50, 0x38); // BD60: 60Hz banding AEC 8 LSBs
+		}
+	}
+	ret = write_prop_single(gspca_dev, sd->sensor_addr, 0x4a, 0x81); // UNKNOWN/RESERVED
+	ret = write_prop_single(gspca_dev, sd->sensor_addr, 0x5a, 0x23); // UNKNOWN/RESERVED
+
+	sd->plfreqfilter = val;
+	return 0;
+}
+
+static int sd_querymenu(struct gspca_dev *gspca_dev,
+			struct v4l2_querymenu *menu)
+{
+	switch (menu->id) {
+	case V4L2_CID_POWER_LINE_FREQUENCY:
+		switch (menu->index) {
+		case 0:		/* V4L2_CID_POWER_LINE_FREQUENCY_DISABLED */
+			strcpy((char *) menu->name, "off");
+			return 0;
+		case 1:		/* V4L2_CID_POWER_LINE_FREQUENCY_50HZ */
+			strcpy((char *) menu->name, "50Hz");
+			return 0;
+		case 2:		/* V4L2_CID_POWER_LINE_FREQUENCY_60HZ */
+			strcpy((char *) menu->name, "60Hz");
+			return 0;
+		}
+		break;
+	}
+	return -EINVAL;
+}
+
+static void em27xx_mute(struct gspca_dev *gspca_dev)
+{
+	u8 value;
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	pr_info("muting audio/video");
+	/* Mute audio */
+	if (write_em27xx_single(gspca_dev, EM27XX_R44_AUDIOCTRL, 0x80) < 0)	// only set bit 8 ?
+		PDEBUG(D_ERR, "em27xx_mute: error: muting audio failed");
+	/* Mute video */
+	/* NOTE: do NOT call sd_set... because this will also save the values to struct sd and we need the original values for restoring ! */
+	if (write_em27xx_single(gspca_dev, EM27XX_R20_YGAIN, 0x00) < 0)
+		PDEBUG(D_ERR, "em27xx_mute: error: setting contrast to 0 failed");
+	if (write_em27xx_single(gspca_dev, EM27XX_R21_YOFFSET, 0x80) < 0)
+		PDEBUG(D_ERR, "em27xx_mute: error: setting brightness to 0 failed");
+	if (write_em27xx_single(gspca_dev, EM27XX_R22_UVGAIN, 0x00) < 0)
+		PDEBUG(D_ERR, "em27xx_mute: error: setting saturation to 0 failed");
+	/* Switch off LED and start blinking */
+	read_em27xx(gspca_dev, EM27XX_R84_GPIO_1_R, &value, 1);
+	value |= EM27XX_GPIO_1_LED_STREAM;	// switch LED off
+	write_em27xx_single(gspca_dev, EM27XX_R80_GPIO_1_W, value);
+	schedule_delayed_work(&sd->led_blink_work, msecs_to_jiffies(LED_BLINK_INTERVAL));
+	sd->muted = true;
+}
+
+static void em27xx_unmute(struct gspca_dev *gspca_dev)
+{
+	u8 value;
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	pr_info("unmuting audio/video");
+	/* Unmute audio */
+	if (write_em27xx_single(gspca_dev, EM27XX_R44_AUDIOCTRL, 0x00) < 0)	//  only clear bit 8 ?
+		PDEBUG(D_ERR, "em27xx_unmute: error: unmuting audio failed");
+	/* Unmute video */
+	/* NOTE: do NOT call sd_set... because this will not work when sd->muted is set */
+	if (write_em27xx_single(gspca_dev, EM27XX_R20_YGAIN, sd->contrast) < 0)
+		PDEBUG(D_ERR, "em27xx_unmute: error: failed to restore contrast setting");
+	if (write_em27xx_single(gspca_dev, EM27XX_R21_YOFFSET, sd->brightness) < 0)
+		PDEBUG(D_ERR, "em27xx_unmute: error: failed to restore brightness setting");
+	if (write_em27xx_single(gspca_dev, EM27XX_R22_UVGAIN, sd->saturation) < 0)
+		PDEBUG(D_ERR, "em27xx_unmute: error: failed to restore saturation setting");
+	/* Stop blinking and switch on LED */
+	cancel_delayed_work_sync(&sd->led_blink_work);
+	read_em27xx(gspca_dev, EM27XX_R84_GPIO_1_R, &value, 1);
+	value &= ~EM27XX_GPIO_1_LED_STREAM;	// switch LED on
+	write_em27xx_single(gspca_dev, EM27XX_R80_GPIO_1_W, value);
+	sd->muted = false;
+}
+
+static void toggle_led(struct work_struct *work)
+{
+	u8 value;
+	struct delayed_work *dw 
+	        = container_of(work, struct delayed_work, work);
+	struct sd *sd = container_of(dw, struct sd, led_blink_work);
+	struct gspca_dev *gspca_dev = &sd->gspca_dev;
+
+	if (mutex_lock_interruptible(&gspca_dev->usb_lock))
+		return;
+	if (read_em27xx(gspca_dev, EM27XX_R84_GPIO_1_R, &value, 1) < 1) {
+		PDEBUG(D_ERR,
+		       "toggle_led: error: reading of the capturing "
+		       "LED status failed");
+		goto end;
+	}
+	if (value & EM27XX_GPIO_1_LED_STREAM)	// LED is off
+		value &= ~EM27XX_GPIO_1_LED_STREAM;	// switch LED on
+	else					// LED is on
+		value |= EM27XX_GPIO_1_LED_STREAM;	// switch LED off
+	if (write_em27xx_single(gspca_dev, EM27XX_R80_GPIO_1_W, value) < 1)
+		PDEBUG(D_ERR,
+		       "toggle_led: error: toggling the capturing LED failed");
+
+end:
+	mutex_unlock(&gspca_dev->usb_lock);
+	schedule_delayed_work(&sd->led_blink_work,
+			      msecs_to_jiffies(LED_BLINK_INTERVAL));
+}
+
+static void check_button(struct work_struct *work)
+{
+	int ret;
+	uint8_t value;
+	struct delayed_work *dw = container_of(work, struct delayed_work, work);
+	struct sd *sd = container_of(dw, struct sd, gpio_query_work);
+	struct gspca_dev *gspca_dev = &sd->gspca_dev;
+
+	if (mutex_lock_interruptible(&gspca_dev->usb_lock))
+		return;
+	ret = read_em27xx(gspca_dev, EM27XX_R84_GPIO_1_R, &value, 1);
+	if (ret < 0) {
+		PDEBUG(D_ERR,
+		       "check_button: error: reading of the "
+		       "button states failed");
+	} else {
+		/* MUTE-BUTTON */
+		if (!(value & EM27XX_GPIO_1_BUTTON_MUTE)) {
+			PDEBUG(D_USBI, "check_button: mute button is pressed");
+			if (!sd->mutebutton_locked) {
+				if (gspca_dev->streaming) {
+					if (!sd->muted) {
+						em27xx_mute(gspca_dev);
+						value |= EM27XX_GPIO_1_LED_STREAM;	// LED off
+					} else {
+						em27xx_unmute(gspca_dev);
+						value &= ~EM27XX_GPIO_1_LED_STREAM;	// LED on
+					}
+				}
+				sd->mutebutton_locked = true;
+			}
+		} else {
+			sd->mutebutton_locked = false;
+		}
+		/* LIGHT-BUTTON */
+		if (!(value & EM27XX_GPIO_1_BUTTON_LIGHT)) {
+			PDEBUG(D_USBI, "check_button: light button is pressed");
+			if (!sd->lightbutton_locked) {
+				if (value & EM27XX_GPIO_1_LED_LIGHT) {	// LIGHT IS OFF
+					pr_info("switching light on");
+					value &= ~EM27XX_GPIO_1_LED_LIGHT;// SWITCH LIGHT ON
+					sd->illuminated = true;
+				} else {				// LIGHT IS ON
+					pr_info("switching light off");
+					value |= EM27XX_GPIO_1_LED_LIGHT; // SWITCH LIGHT OFF
+					sd->illuminated = false;
+				}
+				sd->lightbutton_locked = true;
+			} else {
+				PDEBUG(D_USBI, "check_button: light button is"
+				       " still pressed");
+			}
+		} else {
+			sd->lightbutton_locked = false;
+		}
+		/* Reset button states */
+		value |= EM27XX_GPIO_1_BUTTON_MUTE;	// CLEAR MUTE BUTTON STATE
+		value |= EM27XX_GPIO_1_BUTTON_LIGHT;	// CLEAR LIGHT BUTTON STATE
+
+		ret = write_em27xx(gspca_dev, EM27XX_R80_GPIO_1_W, &value, 1);
+		if (ret < 0)
+			PDEBUG(D_ERR, "check_button: error: write to GPIO register 0x80 failed");
+	}
+
+#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
+	/* SNAPSHOT-BUTTON */
+	ret = read_em27xx(gspca_dev, EM27XX_R85_GPIO_2_R, &value, 1);
+	if (ret < 0)
+		PDEBUG(D_ERR,
+		       "check_button: error: reading of snapshot "
+		       "button status failed");
+	else {
+		if (!(value & EM27XX_GPIO_2_BUTTON_SNAPSHOT)) {
+			pr_info("snapshot button pressed");
+			input_report_key(gspca_dev->input_dev, KEY_CAMERA, 1);
+			input_sync(gspca_dev->input_dev);
+			input_report_key(gspca_dev->input_dev, KEY_CAMERA, 0);
+			input_sync(gspca_dev->input_dev);
+		}
+	}
+#endif
+	mutex_unlock(&gspca_dev->usb_lock);
+	/* Schedule next poll */
+	schedule_delayed_work(&sd->gpio_query_work,
+			      msecs_to_jiffies(GPIO_POLL_INTERVAL));
+}
+
+static int probe_sensor(struct gspca_dev *gspca_dev)
+{
+	u8 slave_addr;
+	u8 reg;
+	u8 buf[2];
+	u16 id;
+	int ret;
+	int i;
+	struct sd *sd = (struct sd *) gspca_dev;
+#ifdef GSPCA_DEBUG
+	int gspca_debug_bak = gspca_debug;
+
+	gspca_debug &= ~D_ERR;// suppress error messages during sensor probing
+#endif
+	for (i = 0; i < ARRAY_SIZE(sensor_slave_addresses); i++) {
+		slave_addr = sensor_slave_addresses[i];
+		/* OmniVision sensors */
+		reg = 0x1c;	// OmniVision manufacturer ID (MSB)
+		ret = read_prop(gspca_dev, slave_addr, reg, buf, 2);
+		if (ret == 2) {
+			id = (buf[0] << 8) + buf[1];
+			if (id == CHIP_ID_OMNIVISION) {
+#ifdef GSPCA_DEBUG
+				gspca_debug = gspca_debug_bak;
+#endif
+				reg = 0x0a;	// OmniVision product ID (MSB)
+				ret = read_prop(gspca_dev, slave_addr, reg,
+						buf, 2);
+				if (ret == 2) {
+					id = (buf[0] << 8) + buf[1];
+					if (id == CHIP_ID_OV2640) {
+						PDEBUG(D_PROBE,
+						       "OV2640 sensor "
+						       "detected at slave "
+						       "address 0x%02x",
+						       slave_addr);
+						sd->sensor = SENSOR_OV2640;
+						sd->sensor_addr = slave_addr;
+						return 0;
+					} else {
+						PDEBUG(D_PROBE | D_ERR,
+						       "unknown OmniVision "
+						       "sensor detected: "
+						       "0x%02x",
+						       id);
+						return -ENODEV;
+					}
+				}
+			}
+			PDEBUG(D_PROBE | D_ERR,
+			       "unknown sensor detected at slave "
+			       "address 0x%02x",
+			       slave_addr);
+			return -ENODEV;
+		} else {
+			PDEBUG(D_PROBE,
+			       "no sensor detected at slave address 0x%02x",
+			       slave_addr);
+		}
+	}
+#ifdef GSPCA_DEBUG
+	gspca_debug = gspca_debug_bak;
+#endif
+
+	PDEBUG(D_PROBE | D_ERR, "error: no sensor detected");
+	return -ENODEV;
+}
+
+/* this function is called at probe time */
+static int sd_config(struct gspca_dev *gspca_dev,
+		     const struct usb_device_id *id)
+{
+	struct cam *cam;
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	cam = &gspca_dev->cam;
+
+	cam->cam_mode = video_camera_mode;
+	cam->nmodes = ARRAY_SIZE(video_camera_mode);
+	
+	cam->bulk = USB_ENDPOINT_XFER_BULK;
+	cam->bulk_nurbs = 1;
+	
+	sd->brightness = BRIGHTNESS_DEFAULT;
+	sd->contrast = CONTRAST_DEFAULT;
+	sd->saturation = SATURATION_DEFAULT;
+	sd->sharpness = SHARPNESS_DEFAULT;
+	sd->plfreqfilter = POWERLINEFREQFILTER_DEFAULT;
+
+	INIT_DELAYED_WORK(&sd->led_blink_work, toggle_led);
+	INIT_DELAYED_WORK(&sd->gpio_query_work, check_button);
+	schedule_delayed_work(&sd->gpio_query_work,
+			      msecs_to_jiffies(GPIO_POLL_INTERVAL));
+
+	return 0;
+}
+
+/* this function is called at probe and resume time */
+static int sd_init(struct gspca_dev *gspca_dev)
+{
+	u8 i2c_slave_addr;
+	u8 buf[4];
+	int ret, i;
+	u8 reg;
+	u8 val;
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	if (mutex_lock_interruptible(&gspca_dev->usb_lock))
+		return -ERESTARTSYS;
+	if (!sd->sensor_addr) {
+		/* Search for EEPROM */
+		i2c_slave_addr = 0xa0;	// NOTE: also 0xa1
+		ret = read_i2c(gspca_dev, i2c_slave_addr, 0x0000, buf, 4);
+		if (ret < 0) {
+			PDEBUG(D_PROBE, "no EEPROM found");
+		} else {
+			struct sd *sd = (struct sd *) gspca_dev;
+			sd->eeprom_addr = i2c_slave_addr;
+			
+			if ((buf[0] == 0x26) && (buf[3] == 0x00)) {
+				PDEBUG(D_PROBE, "EEPROM found: type em25xx");
+			} else if ((buf[0] == 0x1a) && (buf[1] == 0xeb) 
+			           && (buf[2] == 0x67) && (buf[3] == 0x95)) {
+				PDEBUG(D_PROBE, "EEPROM found: type em28xx");
+			} else {
+				PDEBUG(D_PROBE, "EEPROM found: unknown type");
+				PDEBUG(D_PROBE,
+				       "EEPROM data at addresses \
+				        0x0000 to 0x0003: %02x %02x %02x %02x",
+				       buf[0], buf[1], buf[2], buf[3]);	
+			}
+		}
+
+		/* Verify bridge */
+		ret = read_em27xx(gspca_dev, EM27XX_R0A_CHIPID, buf, 1);
+		if (ret < 0)
+			return ret;
+		if (buf[0] == CHIP_ID_EM2765) {
+			PDEBUG(D_PROBE, "EM2765 bridge detected");
+		} else {
+			PDEBUG(D_PROBE | D_ERR,
+			       "error: unknown bridge detected: %02x", buf[0]);
+			return -ENODEV;
+		}
+
+		/* NOTE: the windows driver now does the following:
+		* - read addresses 0x68-0x6b with a single 4 byte read
+		*   from (em25xx-) eeprom: 00 00 00 00
+		* - read addresses 0x70, 0x6c, 0x71, 0x6d, 0x72, 0x6e, 0x73,
+		*   0x6f from (em25xx-) eeprom: all 00			     */
+	}
+
+	/* Bridge init part 1 */
+	write_em27xx_single(gspca_dev, EM27XX_R06_I2CCLK, 0x40);
+	write_em27xx_single(gspca_dev, EM27XX_R08_GPIO, 0xf7);
+	write_em27xx_single(gspca_dev, EM27XX_R0C_USBSUSP, 0x00);
+
+	/* Probe sensor */
+	if (!sd->sensor_addr) {
+		ret = probe_sensor(gspca_dev);
+		if (ret < 0)
+			return ret;
+	}
+
+	/* NOTE: the windows driver now does the following:
+	 * - read addresses 0x86-0x89 with a single 4 byte read
+	 *   from (em25xx-) eeprom: 1e 40 1e 72
+	 * - read addresses 0x8a-0x91 with 1 byte reads from (em25xx-) eeprom:
+	 *   00 20 01 01 00 01 01 00
+	 */
+	
+	/* Bridge init part 2 */
+	write_em27xx_single(gspca_dev, EM27XX_R12_VINENABLE, 0x27);
+	write_em27xx_single(gspca_dev, EM27XX_R0D, 0x42);
+	if (read_em27xx(gspca_dev, EM27XX_R84_GPIO_1_R, buf, 1) < 1)
+		buf[0] = 0xff;
+	buf[0] |= EM27XX_GPIO_1_LED_STREAM;	// switch LED off
+	if (sd->illuminated)
+		buf[0] &= ~EM27XX_GPIO_1_LED_LIGHT;	// switch light on
+	else
+		buf[0] |= EM27XX_GPIO_1_LED_LIGHT;	// switch light on
+	write_em27xx_single(gspca_dev, EM27XX_R80_GPIO_1_W, buf[0]);
+
+	// Init sensor:
+	if (sd->sensor == SENSOR_OV2640) {
+		for (i = 0; i < ARRAY_SIZE(ov2640_init); i++) {
+			reg = ov2640_init[i][0];
+			val = ov2640_init[i][1];
+			ret = write_prop_single(gspca_dev, sd->sensor_addr, reg, val);
+			if (ret < 0)
+				err("error: sensor initialisation failed: reg %02x", reg);
+		}
+	} else {
+		return -ENODEV;
+	}
+
+	mutex_unlock(&gspca_dev->usb_lock);
+
+	return 0;
+}
+
+/* called on stream on before getting the EP */
+static int sd_init_transfer(struct gspca_dev *gspca_dev)
+{
+	/* Set bulk packet size */
+	gspca_dev->cam.bulk_size = gspca_dev
+	                           ->cam.cam_mode[gspca_dev->curr_mode]
+	                           .sizeimage + 2;
+	PDEBUG(D_USBI | D_CONF,
+	       "sd_init_transfer: setting bulk transfer buffer size to %d",
+	       gspca_dev->cam.bulk_size);
+	/* NOTE: DO NOT USE gspca_dev->frsz !
+	 * frame_alloc() in gspca.c calls PAGE_ALIGN(frsz)
+	 * which can increase this value !			 */
+	return 0;
+}
+
+static int em27xx_set_videooutfmt(struct gspca_dev *gspca_dev)
+{
+	u8 value;
+	switch (gspca_dev->cam.cam_mode[gspca_dev->curr_mode].pixelformat) {
+		case V4L2_PIX_FMT_SRGGB8:
+			value = 0x00;	// RGB_8_RGRG
+			break;
+		case V4L2_PIX_FMT_RGB565:
+			value = 0x04;	// RGB_16_656
+			break;
+/*		case V4L2_PIX_FMT_YUV211:
+			value = 0x10;	// YUV211
+			break;				*/
+			// TODO: add support to the kernel
+		case V4L2_PIX_FMT_YUYV:
+			value = 0x14;	// YUV422_Y0UY1V
+			break;
+		default:
+			err("error: invalid pixel format selected");
+			return -EINVAL;
+	}
+	return write_em27xx_single(gspca_dev, EM27XX_R27_OUTFMT, value);
+}
+
+static void em27xx_set_resolution(struct gspca_dev *gspca_dev)
+{
+	if (gspca_dev->cam.cam_mode[gspca_dev->curr_mode].width < 1600)
+		write_em27xx_single(gspca_dev, EM27XX_R0F_XCLK, 0x0b); // 24MHz
+	else
+		write_em27xx_single(gspca_dev, EM27XX_R0F_XCLK, 0x07); // 12MHz
+
+	if ((gspca_dev->cam.cam_mode[gspca_dev->curr_mode].width == 320)
+	    || (gspca_dev->cam.cam_mode[gspca_dev->curr_mode].width == 640)) {
+
+		write_em27xx_single(gspca_dev, EM27XX_R28_XMIN, 0x1b);
+		write_em27xx_single(gspca_dev, EM27XX_R29_XMAX, 0x83);
+		write_em27xx_single(gspca_dev, EM27XX_R2A_YMIN, 0x13);
+		write_em27xx_single(gspca_dev, EM27XX_R2B_YMAX, 0x63);
+
+		write_em27xx_single(gspca_dev, EM27XX_R1C_HSTART, 0x00);
+		write_em27xx_single(gspca_dev, EM27XX_R1D_VSTART, 0x00);
+
+		write_em27xx_single(gspca_dev, EM27XX_R1E_CWIDTH, 0xa0);
+		write_em27xx_single(gspca_dev, EM27XX_R1F_CHEIGHT, 0x78);
+
+		write_em27xx_single(gspca_dev, EM27XX_R1B_OFLOW, 0x00);
+		write_em27xx_single(gspca_dev, EM27XX_R1B_OFLOW, 0x00);
+
+		if (gspca_dev->cam.cam_mode[gspca_dev->curr_mode].width
+		     == 640)                                            {
+			write_em27xx_single(gspca_dev,
+					    EM27XX_R34_START_H, 0x28);
+			write_em27xx_single(gspca_dev,
+					    EM27XX_R35_START_V, 0x1e);
+		} else { // 320x240
+			write_em27xx_single(gspca_dev,
+					    EM27XX_R34_START_H, 0x14);
+			write_em27xx_single(gspca_dev,
+					    EM27XX_R35_START_V, 0x0f);
+		}
+	} else if (gspca_dev->cam.cam_mode[gspca_dev->curr_mode].width
+	            == 1280)                                           {
+		write_em27xx_single(gspca_dev, EM27XX_R28_XMIN, 0x6b);
+		write_em27xx_single(gspca_dev, EM27XX_R29_XMAX, 0xd3);
+		write_em27xx_single(gspca_dev, EM27XX_R2A_YMIN, 0x57);
+		write_em27xx_single(gspca_dev, EM27XX_R2B_YMAX, 0xa7);
+
+		write_em27xx_single(gspca_dev, EM27XX_R1C_HSTART, 0x00);
+		write_em27xx_single(gspca_dev, EM27XX_R1D_VSTART, 0x00);
+
+		write_em27xx_single(gspca_dev, EM27XX_R1E_CWIDTH, 0x40);
+		write_em27xx_single(gspca_dev, EM27XX_R1F_CHEIGHT, 0x00);
+
+		write_em27xx_single(gspca_dev, EM27XX_R1B_OFLOW, 0x01);
+		write_em27xx_single(gspca_dev, EM27XX_R1B_OFLOW, 0x03);
+
+		write_em27xx_single(gspca_dev, EM27XX_R34_START_H, 0x50);
+		write_em27xx_single(gspca_dev, EM27XX_R35_START_V, 0x40);
+	} else if (gspca_dev->cam.cam_mode[gspca_dev->curr_mode].width
+	            == 1600)                                           {
+		write_em27xx_single(gspca_dev, EM27XX_R28_XMIN, 0x93);
+		write_em27xx_single(gspca_dev, EM27XX_R29_XMAX, 0xfb);
+		write_em27xx_single(gspca_dev, EM27XX_R2A_YMIN, 0x6d);
+		write_em27xx_single(gspca_dev, EM27XX_R2B_YMAX, 0xbd);
+
+		write_em27xx_single(gspca_dev, EM27XX_R1C_HSTART, 0x00);
+		write_em27xx_single(gspca_dev, EM27XX_R1D_VSTART, 0x00);
+
+		write_em27xx_single(gspca_dev, EM27XX_R1E_CWIDTH, 0x90);
+		write_em27xx_single(gspca_dev, EM27XX_R1F_CHEIGHT, 0x2c);
+
+		write_em27xx_single(gspca_dev, EM27XX_R1B_OFLOW, 0x03);
+		write_em27xx_single(gspca_dev, EM27XX_R1B_OFLOW, 0x03);
+
+		write_em27xx_single(gspca_dev, EM27XX_R34_START_H, 0x64);
+		write_em27xx_single(gspca_dev, EM27XX_R35_START_V, 0x4b);
+	} else {
+		PDEBUG(D_ERR, "em27xx_set_resolution: error: "
+		       "invalid resolution");
+	}
+	
+	if (gspca_dev->cam.cam_mode[gspca_dev->curr_mode].width < 640) {
+		write_em27xx_single(gspca_dev, EM27XX_R26_COMPR, 0x10);
+		write_em27xx_single(gspca_dev, EM27XX_R30_HSCALELOW, 0x00);
+		write_em27xx_single(gspca_dev, EM27XX_R31_HSCALEHIGH, 0x10);
+		write_em27xx_single(gspca_dev, EM27XX_R26_COMPR, 0x30);
+		write_em27xx_single(gspca_dev, EM27XX_R32_VSCALELOW, 0x00);
+		write_em27xx_single(gspca_dev, EM27XX_R33_VSCALEHIGH, 0x10);
+	}
+}
+
+static void ov2640_config(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	// SENSOR REGISTERS
+	write_prop_single(gspca_dev, sd->sensor_addr, 0xff, 0x01);	// SELECT DEVICE CONTROL REGISTER SET: REGISTER SET 1
+
+	if (gspca_dev->cam.cam_mode[gspca_dev->curr_mode].width < 1600)
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x03, 0x8f);	// COM1: allow 3 dummy frame; Vertical windows start/end line control
+	else
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x03, 0x4f);	// COM1: allow 1 dummy frame; Vertical windows start/end line control
+
+	if (gspca_dev->cam.cam_mode[gspca_dev->curr_mode].width < 1280) {
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x12, 0x40);	// COM7: SVGA-mode
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x17, 0x11);	// HREFST (horizontal windows start)
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x18, 0x43);	// HREFEND
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x19, 0x00);	// VSTART
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x1a, 0x4b);	// VEND
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x32, 0x09);	// REG32 (horizontal window start/end position, clock dividing)
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x6d, 0x00);	// UNKNOWN/RESERVED
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x3d, 0x38);	// UNKNOWN/RESERVED
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x39, 0x12);	// UNKNOWN/RESERVED
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x35, 0xda);	// UNKNOWN/RESERVED
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x22, 0x1a);	// UNKNOWN/RESERVED
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x37, 0xc3);	// UNKNOWN/RESERVED
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x23, 0x00);	// UNKNOWN/RESERVED
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x34, 0xc0);	// ARCOM2: RESERVED/UNKNOWN
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x36, 0x1a);	// UNKNOWN/RESERVED
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x06, 0x88);	// UNKNOWN/RESERVED
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x07, 0xc0);	// UNKNOWN/RESERVED
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x0d, 0x87);	// UNKNOWN/RESERVED
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x0e, 0x41);	// UNKNOWN/RESERVED
+	} else {
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x12, 0x00);	// COM7: UXGA-mode (full size mode)
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x17, 0x11);	// HREFST (horizontal windows start)
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x18, 0x75);	// HREFEND
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x19, 0x01);	// VSTART
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x1a, 0x97);	// VEND
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x32, 0x36);	// REG32 (horizontal window start/end position, clock dividing)
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x6d, 0x80);	// UNKNOWN/RESERVED
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x3d, 0x34);	// UNKNOWN/RESERVED
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x39, 0x02);	// UNKNOWN/RESERVED
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x35, 0x88);	// UNKNOWN/RESERVED
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x22, 0x0a);	// UNKNOWN/RESERVED
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x37, 0x40);	// UNKNOWN/RESERVED
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x23, 0x00);	// UNKNOWN/RESERVED
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x34, 0xa0);	// ARCOM2: RESERVED/UNKNOWN
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x36, 0x1a);	// UNKNOWN/RESERVED
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x06, 0x02);	// UNKNOWN/RESERVED
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x07, 0xc0);	// UNKNOWN/RESERVED
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x0d, 0xb7);	// UNKNOWN/RESERVED
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x0e, 0x01);	// UNKNOWN/RESERVED
+	}
+	write_prop_single(gspca_dev, sd->sensor_addr, 0x4c, 0x00);		// UNKNOWN/RESERVED
+
+	// DSP REGISTERS
+	write_prop_single(gspca_dev, sd->sensor_addr, 0xff, 0x00);		// SELECT DEVICE CONTROL REGISTER SET: REGISTER SET 0
+
+	if (gspca_dev->cam.cam_mode[gspca_dev->curr_mode].width == 1600)
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x86, 0x1d);	// CTRL2: enable SDE+UV_ADJ+UV_AVG+CMX
+	else
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x86, 0x3d);	// CTRL2: enable DCW+SDE+UV_ADJ+UV_AVG+CMX
+
+	if (gspca_dev->cam.cam_mode[gspca_dev->curr_mode].width < 1280) {
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x87, 0xd5);	// CTRL3: enable BPC + WPC + UNKNOWN
+		write_prop_single(gspca_dev, sd->sensor_addr, 0xc0, 0x64);	// HSIZE8 (Image horizontal size)
+		write_prop_single(gspca_dev, sd->sensor_addr, 0xc1, 0x4b);	// VSIZE8 (Image vertical size)
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x8c, 0x00);	// SIZEL (HSIZE, VSIZE settings)
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x50, 0x00);	// CTRLI: disable LP_DP, ROUND, H_DIVIDER, V_DIVIDER
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x51, 0xc8);	// HSIZE (in real/4)
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x52, 0x96);	// VSIZE (in real/4)
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x53, 0x00);	// XOFFL (X-offset)
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x54, 0x00);	// YOFFL (Y-offset)
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x55, 0x00);	// VHYX (HSIZE, VSIZE, X-offset, y-offset)
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x5a, 0xa0);	// ZMOW (OUTW)
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x5b, 0x78);	// ZMOH (OUTH)
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x5c, 0x00);	// ZMHH (zoom speed, OUTH, OUTW
+	} else {
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x87, 0xd0);	// CTRL3: enable BPC + WPC + UNKNOWN
+		write_prop_single(gspca_dev, sd->sensor_addr, 0xc0, 0xc8);	// HSIZE8 (Image horizontal size)
+		write_prop_single(gspca_dev, sd->sensor_addr, 0xc1, 0x96);	// VSIZE8 (Image vertical size)
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x8c, 0x00);	// SIZEL (HSIZE, VSIZE settings)
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x50, 0x00);	// CTRLI: disable LP_DP, ROUND, H_DIVIDER, V_DIVIDER
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x51, 0x90);	// HSIZE (in real/4)
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x52, 0x2c);	// VSIZE (in real/4)
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x53, 0x00);	// XOFFL (X-offset)
+		write_prop_single(gspca_dev, sd->sensor_addr, 0x54, 0x00);	// YOFFL (Y-offset)
+		if (gspca_dev->cam.cam_mode[gspca_dev->curr_mode].width
+		     < 1600)                                            {
+			write_prop_single(gspca_dev, sd->sensor_addr,
+					  0x55, 0x88);		// VHYX (HSIZE, VSIZE, X-offset, y-offset)
+			write_prop_single(gspca_dev, sd->sensor_addr,
+					  0x5a, 0x40);		// ZMOW (OUTW)
+			write_prop_single(gspca_dev, sd->sensor_addr,
+					  0x5b, 0x00);		// ZMOH (OUTH)
+			write_prop_single(gspca_dev, sd->sensor_addr,
+					  0x5c, 0x05);		// ZMHH (zoom speed, OUTH, OUTW
+		} else {
+			write_prop_single(gspca_dev, sd->sensor_addr,
+					  0x55, 0xc8);		// VHYX (HSIZE, VSIZE, X-offset, y-offset)
+			write_prop_single(gspca_dev, sd->sensor_addr,
+					  0x5a, 0x90);		// ZMOW (OUTW)
+			write_prop_single(gspca_dev, sd->sensor_addr,
+					  0x5b, 0x2c);		// ZMOH (OUTH)
+			write_prop_single(gspca_dev, sd->sensor_addr,
+					  0x5c, 0x05);		// ZMHH (zoom speed, OUTH, OUTW
+		}
+	}
+	write_prop_single(gspca_dev, sd->sensor_addr, 0xd3, 0x82);	// R_DVP_SP: auto mode, DVP output speed control = sysclk (48)/2 for YUV0, sysclk (48)/4 for RAW,
+	write_prop_single(gspca_dev, sd->sensor_addr, 0xe0, 0x00);	// RESET
+
+	sd_setpowerlinefreqfilter(gspca_dev, sd->plfreqfilter);
+}
+
+/* called on stream on after URBs creation */
+static int sd_start(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	u8 value;
+
+	PDEBUG(D_STREAM, "sd_start: starting streaming");
+
+	write_em27xx_single(gspca_dev, EM27XX_R0F_XCLK, 0x08);		// 20MHz
+	write_em27xx_single(gspca_dev, EM27XX_R26_COMPR, 0x00);
+	write_em27xx_single(gspca_dev, EM27XX_R13, 0x08);
+
+	em27xx_set_videooutfmt(gspca_dev);
+	em27xx_set_resolution(gspca_dev);
+
+	if (sd->sensor == SENSOR_OV2640)
+		ov2640_config(gspca_dev);
+	else
+		return -ENODEV;
+
+	write_em27xx_single(gspca_dev, EM27XX_R15_RGAIN, 0x20);
+	write_em27xx_single(gspca_dev, EM27XX_R16_GGAIN, 0x20);
+	write_em27xx_single(gspca_dev, EM27XX_R17_BGAIN, 0x20);
+	write_em27xx_single(gspca_dev, EM27XX_R18_ROFFSET, 0x00);
+	write_em27xx_single(gspca_dev, EM27XX_R19_GOFFSET, 0x00);
+	write_em27xx_single(gspca_dev, EM27XX_R1A_BOFFSET, 0x00);
+	write_em27xx_single(gspca_dev, EM27XX_R23_UOFFSET, 0x00);
+	write_em27xx_single(gspca_dev, EM27XX_R24_VOFFSET, 0x00);
+	sd_setbrightness(gspca_dev, sd->brightness);
+	sd_setcontrast(gspca_dev, sd->contrast);
+	sd_setsaturation(gspca_dev, sd->saturation);
+	write_em27xx_single(gspca_dev, EM27XX_R14_GAMMA, 0x20);
+	sd_setsharpness(gspca_dev, sd->sharpness);
+
+	write_em27xx_single(gspca_dev, EM27XX_R10_VINMODE, 0x08);
+	write_em27xx_single(gspca_dev, EM27XX_R11_VINCTRL, 0x00);
+	write_em27xx_single(gspca_dev, EM27XX_R12_VINENABLE, 0x67);	// ON, analog mode
+
+	write_em27xx_single(gspca_dev, EM27XX_R0C_USBSUSP, 0x10);
+
+	read_em27xx(gspca_dev, EM27XX_R84_GPIO_1_R, &value, 1);
+	value &= ~EM27XX_GPIO_1_LED_STREAM;				// turn on LED
+	write_em27xx_single(gspca_dev, EM27XX_R80_GPIO_1_W, value);
+
+	return 0;
+}
+
+static void sd_stop(struct gspca_dev *gspca_dev)
+{
+	u8 value;
+
+	PDEBUG(D_STREAM, "sd_stop: stopping streaming");
+	em27xx_unmute(gspca_dev);
+
+	write_em27xx_single(gspca_dev, EM27XX_R12_VINENABLE, 0x27);
+	write_em27xx_single(gspca_dev, EM27XX_R0C_USBSUSP, 0x00);
+
+	read_em27xx(gspca_dev, EM27XX_R84_GPIO_1_R, &value, 1);
+	value |= EM27XX_GPIO_1_LED_STREAM;				// turn off LED
+	write_em27xx_single(gspca_dev, EM27XX_R80_GPIO_1_W, value);
+}
+
+static void sd_pkt_scan(struct gspca_dev *gspca_dev, u8 *data, int len)
+{
+	u8 header[2];
+	u32 img_size;
+	
+	header[0] = data[0];
+	header[1] = data[1];
+	if (header[0] != 0x02) {
+		PDEBUG(D_PACK,
+		       "sd_pkt_scan: invalid packet header, ignoring packet");
+		// NOTE: should we already discard the packet here ?
+		return;
+	}
+
+	img_size = gspca_dev->image_len;
+
+	if ((gspca_dev->last_packet_type == LAST_PACKET)
+	    || (gspca_dev->last_packet_type == DISCARD_PACKET)) {
+		PDEBUG(D_PACK | D_FRAM, "sd_pkt_scan: setting up new frame");
+		gspca_frame_add(gspca_dev, FIRST_PACKET, data + 2, len - 2);
+	} else {
+		PDEBUG(D_PACK | D_FRAM,
+		       "sd_pkt_scan: adding packet to current frame");
+		gspca_frame_add(gspca_dev, INTER_PACKET, data + 2, len - 2);
+	}
+
+	if (header[1] & BULK_HEADER_FRAME_END) {
+		PDEBUG(D_PACK,
+		       "sd_pkt_scan: packet header indicates frame end");
+		/* NOTE: DO NOT CHECK gspca_dev->frsz !
+		 * frame_alloc() in gspca.c calls PAGE_ALIGN(frsz)
+		 * which can increase this value !			 */
+		if (img_size + (len - 2)
+		    != gspca_dev->cam.cam_mode[gspca_dev->curr_mode]
+		       .sizeimage) {
+			PDEBUG(D_PACK | D_FRAM,
+			       "sd_pkt_scan: discarding frame due to invalid "
+			       "frame size");
+			gspca_frame_add(gspca_dev, DISCARD_PACKET, NULL, 0);
+			gspca_dev->image_len = 0;
+		} else {
+			gspca_frame_add(gspca_dev, LAST_PACKET, NULL, 0);
+			PDEBUG(D_FRAM, "sd_pkt_scan: frame complete");
+		}
+	}
+}
+
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+static int sd_dbg_get_register(struct gspca_dev *gspca_dev,
+			struct v4l2_dbg_register *reg)
+{
+	u8 val;
+	struct sd *sd = (struct sd *) gspca_dev;
+	switch (reg->match.type) {
+	case V4L2_CHIP_MATCH_HOST:
+		if (reg->match.addr != 0)
+			return -ENXIO;
+		if (reg->reg > 0xffff)
+			return -EINVAL;
+		if (read_em27xx(gspca_dev, reg->reg, &val, 1) < 0)
+			return -EIO;
+		reg->val = val;
+		reg->size = 1;
+		return 0;
+	case V4L2_CHIP_MATCH_I2C_ADDR:
+		if (reg->match.addr == sd->sensor_addr) {
+			if (reg->reg > 0xff)
+				return -EINVAL;
+			if (read_prop(gspca_dev, reg->match.addr,
+			              reg->reg, &val, 1)          < 0)
+				return -EIO;
+		} else if (sd->eeprom_addr 
+		           && (reg->match.addr == sd->eeprom_addr)) {
+			if (reg->reg > 0xffff)
+				return -EINVAL;
+			if (read_i2c(gspca_dev, reg->match.addr,
+			             reg->reg, &val, 1)          < 0)
+				return -EIO;
+		} else {
+			return -ENXIO;
+		}
+		reg->val = val;
+		reg->size = 1;
+		return 0;
+	}
+	return -EINVAL;
+}
+
+static int sd_dbg_set_register(struct gspca_dev *gspca_dev,
+                               struct v4l2_dbg_register *reg)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	switch (reg->match.type) {
+	case V4L2_CHIP_MATCH_HOST:
+		if (reg->match.addr != 0)
+			return -ENXIO;
+		if (reg->reg > 0xffff)
+			return -EINVAL;
+		if (reg->val > 0xff)
+			return -EINVAL;
+		if (write_em27xx_single(gspca_dev, reg->reg, reg->val) < 0)
+			return -EIO;
+		return 0;
+	case V4L2_CHIP_MATCH_I2C_ADDR:
+		if (reg->match.addr == sd->sensor_addr) {
+			if (reg->reg > 0xff)
+				return -EINVAL;
+			if (reg->val > 0xff)
+				return -EINVAL;
+			if (write_prop_single(gspca_dev, sd->sensor_addr,
+			                      reg->reg, reg->val)         < 0)
+				return -EIO;
+		} else if (sd->eeprom_addr 
+		           && (reg->match.addr == sd->eeprom_addr)) {
+			return -EACCES;
+		} else {
+			return -ENXIO;
+		}
+		return 0;
+	}
+	return -EINVAL;
+}
+#endif
+
+static int sd_get_chip_ident(struct gspca_dev *gspca_dev,
+                             struct v4l2_dbg_chip_ident *chip)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	switch (chip->match.type) {
+	case V4L2_CHIP_MATCH_HOST:
+		if (chip->match.addr != 0)
+			return -EINVAL;
+		chip->revision = 0;
+		chip->ident = 0;// V4L2_IDENT_EM2765;	// FIXME: ADD TO KERNEL
+		return 0;
+	case V4L2_CHIP_MATCH_I2C_ADDR:
+		if (chip->match.addr != sd->sensor_addr)
+			return -EINVAL;
+		chip->revision = 0;
+		chip->ident = sensor_ident[sd->sensor];
+		return 0;
+	}
+	return -EINVAL;
+}
+
+/* sub-driver description */
+static const struct sd_desc sd_desc = {
+	.name      = MODULE_NAME,
+	.ctrls     = sd_ctrls,
+	.nctrls    = ARRAY_SIZE(sd_ctrls),
+	.config    = sd_config,
+	.init      = sd_init,
+	.start     = sd_start,
+	.pkt_scan  = sd_pkt_scan,
+	.isoc_init = sd_init_transfer,
+	.stopN     = sd_stop,
+	.querymenu = sd_querymenu,
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	.set_register = sd_dbg_set_register,
+	.get_register = sd_dbg_get_register,
+#endif
+	.get_chip_ident = sd_get_chip_ident,
+#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
+	.other_input = 1,
+#endif
+};
+
+/* -- module initialisation -- */
+static const struct usb_device_id device_table[] = {
+	{USB_DEVICE(0x1ae7, 0x9003)},
+	{USB_DEVICE(0x1ae7, 0x9004)},
+	{}
+};
+
+MODULE_DEVICE_TABLE(usb, device_table);
+
+/* -- device connect -- */
+static int sd_probe(struct usb_interface *intf, const struct usb_device_id *id)
+{
+	if (intf->cur_altsetting->desc.bInterfaceNumber != 3)
+		return -ENODEV;
+	return gspca_dev_probe2(intf, id, &sd_desc,
+				sizeof(struct sd), THIS_MODULE);
+}
+
+static void sd_disconnect(struct usb_interface *intf)
+{
+	struct gspca_dev *gspca_dev = usb_get_intfdata(intf);
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	cancel_delayed_work_sync(&sd->gpio_query_work);
+	cancel_delayed_work_sync(&sd->led_blink_work);
+
+	sd->muted = false;
+	sd->illuminated = false;
+
+	sd->mutebutton_locked = false;
+	sd->lightbutton_locked = false;
+
+	gspca_disconnect(intf);
+}
+
+static struct usb_driver sd_driver = {
+	.name       = MODULE_NAME,
+	.id_table   = device_table,
+	.probe      = sd_probe,
+	.disconnect = sd_disconnect,
+#ifdef CONFIG_PM
+	.suspend    = gspca_suspend,
+	.resume     = gspca_resume,
+	.reset_resume = gspca_resume,
+#endif
+};
+
+/* -- module insert / remove -- */
+static int __init sd_mod_init(void)
+{
+	return usb_register(&sd_driver);
+}
+
+static void __exit sd_mod_exit(void)
+{
+	usb_deregister(&sd_driver);
+}
+
+module_init(sd_mod_init);
+module_exit(sd_mod_exit);
+
diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
index ca5a2b1..4414c09 100644
--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -2348,6 +2348,9 @@ int gspca_dev_probe2(struct usb_interface *intf,
 	gspca_dev->nbufread = 2;
 	gspca_dev->empty_packet = -1;	/* don't check the empty packets */
 
+	mutex_init(&gspca_dev->usb_lock);
+	mutex_init(&gspca_dev->queue_lock);
+	
 	/* configure the subdriver and initialize the USB device */
 	ret = sd_desc->config(gspca_dev, id);
 	if (ret < 0)
@@ -2363,8 +2366,6 @@ int gspca_dev_probe2(struct usb_interface *intf,
 	if (ret)
 		goto out;
 
-	mutex_init(&gspca_dev->usb_lock);
-	mutex_init(&gspca_dev->queue_lock);
 	init_waitqueue_head(&gspca_dev->wq);
 
 	/* init video stuff */
-- 
1.7.7

