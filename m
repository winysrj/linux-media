Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34528 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab2HTLoN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Aug 2012 07:44:13 -0400
Received: by bkwj10 with SMTP id j10so1821851bkw.19
        for <linux-media@vger.kernel.org>; Mon, 20 Aug 2012 04:44:11 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH] [RFC v2] Add gspca subdriver for webcam Speedlink VAD Laplace (EM2765+OV2640)
Date: Mon, 20 Aug 2012 13:44:22 +0200
Message-Id: <1345463062-4945-1-git-send-email-fschaefer.oss@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch is the result of 3 months of reverse engineering work.
Although the driver is feature complete and working stable, it is NOT intended for kernel inclusion at this point.
Its main purpose is to provide an insight into the charactersitics and functionality of this device and to start a
discussion about the best approach to add support for this device to the kernel.
The "natural" driver for this device would be the em28xx driver, which is very complicating and would require heavy modifications/extensions.
For a better understanding of the device, also see http://linuxtv.org/wiki/index.php/VAD_Laplace.

Changelog V2:
- converted the driver to the new V4L2 control framework
- fixed exposure/gain fluctuations during the first 1-2 seconds after streaming start
  by moving the sensor initialization from sd_init to sd_start
- addressed remarks from Jean-Francois Moine:
	- moved start of gpio polling from sd_config() to sd_init()
	- removed the debug messages which were using the obsolete flags debug flags D_USBI, D_USBO
	- use macro module_usb_driver();
	- added a delay before retrying after read/write errors
	- killed the last C++ comments
- some error handling fixes
- coding style and comment fixes/cleanups

ToDo:
- driver name ?
- add EM2765 chip ID to v4l2-chip-ident.h
- returned errors ok ?
- stricter error handling ?

ToDo (long term):
- use ov2640-sub-driver (needs modifictions)
---
 drivers/media/usb/gspca/Kconfig  |    9 +
 drivers/media/usb/gspca/Makefile |    2 +
 drivers/media/usb/gspca/em27xx.c | 1792 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 1803 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/usb/gspca/em27xx.c

diff --git a/drivers/media/usb/gspca/Kconfig b/drivers/media/usb/gspca/Kconfig
index 6345f93..233debd 100644
--- a/drivers/media/usb/gspca/Kconfig
+++ b/drivers/media/usb/gspca/Kconfig
@@ -50,6 +50,15 @@ config USB_GSPCA_CPIA1
 	  To compile this driver as a module, choose M here: the
 	  module will be called gspca_cpia1.
 
+config USB_GSPCA_EM27XX
+	tristate "EM27xx USB Camera Driver"
+	depends on VIDEO_V4L2 && USB_GSPCA
+	help
+	  Say Y here if you want support for cameras based on EM27xx chips.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called gspca_em27xx.
+
 config USB_GSPCA_ETOMS
 	tristate "Etoms USB Camera Driver"
 	depends on VIDEO_V4L2 && USB_GSPCA
diff --git a/drivers/media/usb/gspca/Makefile b/drivers/media/usb/gspca/Makefile
index c901da0..651b1a6 100644
--- a/drivers/media/usb/gspca/Makefile
+++ b/drivers/media/usb/gspca/Makefile
@@ -2,6 +2,7 @@ obj-$(CONFIG_USB_GSPCA)          += gspca_main.o
 obj-$(CONFIG_USB_GSPCA_BENQ)     += gspca_benq.o
 obj-$(CONFIG_USB_GSPCA_CONEX)    += gspca_conex.o
 obj-$(CONFIG_USB_GSPCA_CPIA1)    += gspca_cpia1.o
+obj-$(CONFIG_USB_GSPCA_EM27XX)   += gspca_em27xx.o
 obj-$(CONFIG_USB_GSPCA_ETOMS)    += gspca_etoms.o
 obj-$(CONFIG_USB_GSPCA_FINEPIX)  += gspca_finepix.o
 obj-$(CONFIG_USB_GSPCA_JEILINJ)  += gspca_jeilinj.o
@@ -47,6 +48,7 @@ gspca_main-objs     := gspca.o autogain_functions.o
 gspca_benq-objs     := benq.o
 gspca_conex-objs    := conex.o
 gspca_cpia1-objs    := cpia1.o
+gspca_em27xx-objs    := em27xx.o
 gspca_etoms-objs    := etoms.o
 gspca_finepix-objs  := finepix.o
 gspca_jeilinj-objs  := jeilinj.o
diff --git a/drivers/media/usb/gspca/em27xx.c b/drivers/media/usb/gspca/em27xx.c
new file mode 100644
index 0000000..13d6b0a
--- /dev/null
+++ b/drivers/media/usb/gspca/em27xx.c
@@ -0,0 +1,1792 @@
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
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+
+#define MODULE_NAME "em27xx"
+
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
+#define USB_XFER_TIMEOUT		HZ	/* 1 sec */
+#define USB_XFER_ERR_WAIT		10	/* [ms] */
+#define GPIO_POLL_INTERVAL		100	/* [ms] */
+#define LED_BLINK_INTERVAL		500	/* [ms] */
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
+struct sd {
+	struct gspca_dev gspca_dev; /* must be the first item */
+	u8 sensor;
+	u8 sensor_addr;
+
+	u8 eeprom_addr;
+
+	bool muted;
+	bool illuminated;
+
+	bool mutebutton_locked;
+	bool lightbutton_locked;
+
+	struct v4l2_ctrl_handler ctrl_handler;
+	struct v4l2_ctrl *brightness;
+	struct v4l2_ctrl *contrast;
+	struct v4l2_ctrl *saturation;
+	struct v4l2_ctrl *sharpness;
+	struct v4l2_ctrl *powerlinefreq;
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
+	/* TODO: add support to the kernel */
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
+	/* TODO: add support to the kernel */
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
+	for (err = 0; err < 3; err++) {
+		ret = usb_control_msg(gspca_dev->dev,
+				      usb_rcvctrlpipe(gspca_dev->dev, 0),
+				      request,
+				      USB_DIR_IN | USB_TYPE_VENDOR
+				       | USB_RECIP_DEVICE,
+				      0,
+				      index,
+				      gspca_dev->usb_buf, length,
+				      USB_XFER_TIMEOUT);
+		if (ret == length) {
+			memcpy(data, gspca_dev->usb_buf, length);
+			break;
+		} else {
+			msleep(USB_XFER_ERR_WAIT);
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
+	for (err = 0; err < 3; err++) {
+		ret = usb_control_msg(gspca_dev->dev,
+				      usb_sndctrlpipe(gspca_dev->dev, 0),
+				      request,
+				      USB_DIR_OUT | USB_TYPE_VENDOR
+				       | USB_RECIP_DEVICE,
+				      0,
+				      index,
+				      gspca_dev->usb_buf, length,
+				      USB_XFER_TIMEOUT);
+		if (ret == length)
+			break;
+		else
+			msleep(USB_XFER_ERR_WAIT);
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
+		PDEBUG(D_ERR,
+		       "error: failed to read %d bytes from em27xx "
+		       "register 0x%04x\n",
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
+		PDEBUG(D_ERR,
+		       "error: failed to write %d bytes to em27xx "
+		       "register 0x%04x\n",
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
+	for (err = 0; err < 3; err++) {
+		/* Set register */
+		request = 0x03;
+		buf[0] = reg >> 8;
+		buf[1] = reg & 0xff;
+		ret = write_usbdev(gspca_dev, request, index, buf, 2);
+		if (ret < 0) {
+			PDEBUG(D_ERR,
+			       "error: sending i2c set register request "
+			       "failed: %d\n",
+			       ret);
+			break;
+		}
+
+		/* Check success */
+		ret = read_em27xx(gspca_dev, EM27XX_R05_I2CSTATUS, buf, 1);
+		if (ret < 0) {
+			PDEBUG(D_ERR,
+			       "error: sending check i2c status request "
+			       "failed: %d\n",
+			       ret);
+			continue;
+		}
+		if (buf[0] != 0x00) {
+			/* NOTE: the only error we've seen so far is
+			 * 0x10 when the slave device is not present */
+			PDEBUG(D_ERR,
+			       "error: setting i2c register failed: "
+			       "i2c status 0x%02x\n",
+			       buf[0]);
+			ret = -EIO;
+			continue;
+		}
+
+		/* Read value */
+		request = 0x02;
+		ret = read_usbdev(gspca_dev, request, index, data, len);
+		if (ret < 0) {
+			PDEBUG(D_ERR,
+			       "error: sending i2c read register failed: %d\n",
+			       ret);
+			continue;
+		}
+
+		/* Check success */
+		ret = read_em27xx(gspca_dev, EM27XX_R05_I2CSTATUS, buf, 1);
+		if (ret < 0) {
+			PDEBUG(D_ERR,
+			       "error: sending check i2c status request "
+			       "failed: %d\n",
+			       ret);
+			continue;
+		}
+		if (buf[0] != 0x00) {
+			PDEBUG(D_ERR,
+			       "error: reading i2c register failed: "
+			       "i2c status 0x%02x\n",
+			       buf[0]);
+			ret = -EIO;
+			continue;
+		}
+
+		return len;
+	}
+
+	PDEBUG(D_ERR,
+	       "error: failed to read %d byte(s) from i2c slave "
+	       "address 0x%02x, register 0x%04x\n",
+	       len, i2c_slave_addr, reg);
+	return ret;
+}
+
+#if 0
+/* 16 bit address and 8 bit register width */
+static int write_i2c_single(struct gspca_dev *gspca_dev, u8 i2c_slave_addr,
+			    u16 reg, u8 data)
+{
+	u8 request;
+	u16 index;
+	u8 buf[3];
+	int ret;
+	int err;
+
+	for (err = 0; err < 3; err++) {
+		/* Set register and write data */
+		request = 0x03;
+		index = i2c_slave_addr;
+		buf[0] = reg >> 8;
+		buf[1] = reg & 0xff;
+		buf[2] = data;
+		ret = write_usbdev(gspca_dev, request, index, buf, 3);
+		if (ret < 0) {
+			PDEBUG(D_ERR,
+			       "error: sending i2c write register request "
+			       "failed: %d\n",
+			       ret);
+			break;
+		}
+
+		/* Check success */
+		ret = read_em27xx(gspca_dev, EM27XX_R05_I2CSTATUS, buf, 1);
+		if (ret < 0) {
+			PDEBUG(D_ERR,
+			       "error: sending check i2c status request "
+			       "failed: %d\n",
+			       ret);
+			continue;
+		}
+		if (buf[0] != 0x00) {
+			/* NOTE: the only error we've seen so far is
+			 * 0x10 when the slave device is not present */
+			PDEBUG(D_ERR,
+			       "error: reading i2c register failed: "
+			       "i2c status 0x%02x\n",
+			       buf[0]);
+			ret = -EIO;
+			continue;
+		}
+
+		return 1;
+	}
+	PDEBUG(D_ERR,
+	       "error: failed to write 1 byte to slave address 0x%02x, "
+	       "register 0x%04x\n",
+	       i2c_slave_addr, reg);
+	return ret;
+
+	/* NOTE: we could write more than 1 byte... */
+
+} /* NOT YET NEEDED, COMPLETELY UNTESTED ! */
+#endif
+
+/* 8 bit address and register width */
+static int read_propr(struct gspca_dev *gspca_dev, u8 slave_addr, u8 reg,
+		      u8 *data, u8 len)
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
+	for (i = 0; i < len; i++) {
+		for (err = 0; err < 3; err++) {
+			/* Set register */
+			request = 0x06;
+			index = slave_addr;
+			buf[0] = reg + i;
+			ret = write_usbdev(gspca_dev, request, index, buf, 1);
+			if (ret < 0) {
+				PDEBUG(D_ERR,
+				       "error: sending proprietary set "
+				       "register request failed: %d\n",
+				       ret);
+				return ret;
+			}
+
+			/* Check success */
+			request = 0x08;
+			index = 0x0000;
+			ret = read_usbdev(gspca_dev, request, index, buf, 1);
+			if (ret < 0) {
+				PDEBUG(D_ERR,
+				       "error: sending check proprietary comm"
+				       "unication status request failed: %d\n",
+				       ret);
+				continue;
+			}
+			if (buf[0] != 0x00) {
+				/* NOTE: the only error we've seen so far is
+				 * 0x01 when the slave device is not present */
+				PDEBUG(D_ERR,
+				       "error: proprietary set register failed: "
+				       "status 0x%02x\n",
+				       buf[0]);
+				ret = -EIO;
+				continue;
+			}
+
+			/* Read value  */
+			request = 0x06;
+			index = slave_addr;
+			ret = read_usbdev(gspca_dev, request, index,
+					  data + i, 1);
+			if (ret < 0) {
+				PDEBUG(D_ERR,
+				       "error: sending proprietary read "
+				       "register request failed: %d\n",
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
+				PDEBUG(D_ERR,
+				       "error: sending check proprietary comm"
+				       "unication status request failed: %d\n",
+				       ret);
+				continue;
+			}
+			if (buf[0] != 0x00) {
+				PDEBUG(D_ERR,
+				       "error: proprietary read register "
+				       "failed: status 0x%02x\n",
+				       buf[0]);
+				ret = -EIO;
+				continue;
+			}
+
+			break;
+		}
+		if (ret < 0) {
+			PDEBUG(D_ERR,
+			       "error: failed to read %d byte(s) from slave "
+			       "address 0x%02x, register 0x%02x\n",
+			       len, slave_addr, reg);
+			return ret;
+		}
+	}
+
+	return len;
+}
+
+/* 8 bit address and register width */
+static int write_propr(struct gspca_dev *gspca_dev, u8 slave_addr,
+		       u8 reg, u8 *data, u8 len)
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
+	for (i = 0; i < len; i++) {
+		for (err = 0; err < 3; err++) {
+			/* Set register and write value */
+			request = 0x06;
+			index = slave_addr;
+			buf[0] = reg + i;
+			buf[1] = data[i];
+			ret = write_usbdev(gspca_dev, request, index, buf, 2);
+			if (ret < 0) {
+				PDEBUG(D_ERR,
+				       "error: sending proprietary write "
+				       "register request failed: %d\n",
+				       ret);
+				break;
+			}
+			/* NOTE:
+			 * The device always uses the first submitted byte as
+			 * address and the last submitted byte as value.
+			 * All other bytes are ignored !		     */
+
+			/* Check success */
+			request = 0x08;
+			index = 0x0000;
+			ret = read_usbdev(gspca_dev, request, index, buf, 1);
+			if (ret < 0) {
+				PDEBUG(D_ERR,
+				       "error: sending check proprietary comm"
+				       "unication status request failed: %d\n",
+				       ret);
+				continue;
+			}
+			if (buf[0] != 0x00) {
+				PDEBUG(D_ERR,
+				       "error: proprietary write register "
+				       "failed: status 0x%02x\n",
+				       buf[0]);
+				ret = -EIO;
+				continue;
+			}
+
+			break;
+		}
+		if (ret < 0) {
+			PDEBUG(D_ERR,
+			       "error: failed to write %d byte(s) to slave "
+			       "address 0x%02x, register 0x%02x\n",
+			       len, slave_addr, reg);
+			return ret;
+		}
+	}
+
+	return len;
+}
+
+/* 8 bit address and register width */
+static int write_propr_single(struct gspca_dev *gspca_dev, u8 slave_addr,
+			      u8 reg, u8 data)
+{
+	return write_propr(gspca_dev, slave_addr, reg, &data, 1);
+}
+
+static int set_brightness(struct gspca_dev *gspca_dev, s32 val)
+{
+	int ret;
+	struct sd *sd = (struct sd *) gspca_dev;
+	if (!sd->muted) {
+		ret = write_em27xx_single(gspca_dev, EM27XX_R21_YOFFSET,
+					  (u8)val);
+		if (ret < 0) {
+			PDEBUG(D_ERR, "error: failed to set brightness\n");
+			return ret;
+		}
+	}
+	return 0;
+}
+
+static int set_contrast(struct gspca_dev *gspca_dev, s32 val)
+{
+	int ret;
+	struct sd *sd = (struct sd *) gspca_dev;
+	if (!sd->muted) {
+		ret = write_em27xx_single(gspca_dev, EM27XX_R20_YGAIN, val);
+		if (ret < 0) {
+			PDEBUG(D_ERR, "error: failed to set contrast\n");
+			return ret;
+		}
+	}
+	return 0;
+}
+
+static int set_saturation(struct gspca_dev *gspca_dev, s32 val)
+{
+	int ret;
+	struct sd *sd = (struct sd *) gspca_dev;
+	if (!sd->muted) {
+		ret = write_em27xx_single(gspca_dev, EM27XX_R22_UVGAIN, val);
+		if (ret < 0) {
+			PDEBUG(D_ERR, "error: failed to set saturation\n");
+			return ret;
+		}
+	}
+	return 0;
+}
+
+static int set_sharpness(struct gspca_dev *gspca_dev, s32 val)
+{
+	int ret;
+	ret = write_em27xx_single(gspca_dev, EM27XX_R25_SHARPNESS, val);
+	if (ret < 0) {
+		PDEBUG(D_ERR, "error: failed to set sharpness\n");
+		return ret;
+	}
+	return 0;
+}
+
+static int set_powerlinefreqfilter(struct gspca_dev *gspca_dev, s32 val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	int ret;
+
+	if (sd->sensor != SENSOR_OV2640)
+		return -ENODEV;
+
+	ret = write_propr_single(gspca_dev, sd->sensor_addr, 0xff, 0x01);
+	if (ret < 0)
+		return ret;
+	 /* NOTE: reg 0xff = register set selection
+	  *       => too risky to continue on error ! */
+
+	/* COM8: auto exposure + auto AGC + banding filter on */
+	write_propr_single(gspca_dev, sd->sensor_addr, 0x13, 0xe5);
+
+	if (val == V4L2_CID_POWER_LINE_FREQUENCY_50HZ) {
+		/* COM3: snapshot option=live video output after snapshot seq.,
+		 *       manual banding selection, banding=50Hz               */
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x0c, 0x3c);
+		/* banding 50 Hz AEC value */
+		if (gspca_dev->cam.cam_mode[gspca_dev->curr_mode].width
+		     <= 640)                                            {
+			write_propr_single(gspca_dev, sd->sensor_addr,
+					   0x4e, 0x00); /* 2 MSBs */
+			write_propr_single(gspca_dev, sd->sensor_addr,
+					   0x4f, 0xca); /* 8 LSBs */
+		} else {
+			write_propr_single(gspca_dev, sd->sensor_addr,
+					   0x4e, 0x50);
+			write_propr_single(gspca_dev, sd->sensor_addr,
+					   0x4f, 0x74);
+		}
+	} else if (val == V4L2_CID_POWER_LINE_FREQUENCY_60HZ) {
+		/* COM3: snapshot option=live video output after snapshot seq.,
+		 *       manual banding selection, banding=60Hz               */
+		write_propr_single(gspca_dev, sd->sensor_addr,
+				   0x0c, 0x38);
+		/* banding 60 Hz AEC value */
+		if (gspca_dev->cam.cam_mode[gspca_dev->curr_mode].width
+		     <= 640)                                            {
+			write_propr_single(gspca_dev, sd->sensor_addr,
+					   0x4e, 0x00); /* 2 MSBs */
+			write_propr_single(gspca_dev, sd->sensor_addr,
+					   0x50, 0xa8); /* 8 LSBs */
+		} else {
+			write_propr_single(gspca_dev, sd->sensor_addr,
+					   0x4e, 0x50);
+			write_propr_single(gspca_dev, sd->sensor_addr,
+					   0x50, 0x38);
+		}
+	}
+
+	/* UNKNOWN/RESERVED */
+	write_propr_single(gspca_dev, sd->sensor_addr, 0x4a, 0x81);
+	write_propr_single(gspca_dev, sd->sensor_addr, 0x5a, 0x23);
+	return 0;
+}
+
+static int sd_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct sd *sd = container_of(ctrl->handler, struct sd, ctrl_handler);
+	struct gspca_dev *gspca_dev = &sd->gspca_dev;
+
+	if (!gspca_dev->streaming)
+		return 0;
+
+	switch (ctrl->id) {
+	case V4L2_CID_BRIGHTNESS:
+		return set_brightness(&sd->gspca_dev, ctrl->val);
+		break;
+	case V4L2_CID_CONTRAST:
+		return set_contrast(&sd->gspca_dev, ctrl->val);
+		break;
+	case V4L2_CID_SATURATION:
+		return set_saturation(&sd->gspca_dev, ctrl->val);
+		break;
+	case V4L2_CID_SHARPNESS:
+		return set_sharpness(&sd->gspca_dev, ctrl->val);
+		break;
+	case V4L2_CID_POWER_LINE_FREQUENCY:
+		return set_powerlinefreqfilter(&sd->gspca_dev, ctrl->val);
+		break;
+	}
+	return 0;
+}
+
+static const struct v4l2_ctrl_ops sd_ctrl_ops = {
+	.s_ctrl = sd_s_ctrl,
+};
+
+static void mute(struct gspca_dev *gspca_dev)
+{
+	u8 value;
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	pr_info("muting audio/video\n");
+	/* Mute audio */
+	value = 0x00;
+	if (read_em27xx(gspca_dev, EM27XX_R44_AUDIOCTRL, &value, 1) < 0)
+		PDEBUG(D_ERR,
+		       "em27xx_mute: error: failed to read from reg 0x%02x\n",
+		       EM27XX_R44_AUDIOCTRL);
+	value |= 0x80;	/* switch LED off */
+	if (write_em27xx_single(gspca_dev, EM27XX_R44_AUDIOCTRL, value) < 0)
+		PDEBUG(D_ERR, "em27xx_mute: error: muting audio failed\n");
+	/* NOTE: the windows driver reads value 0x00 from this register and
+	 *       then writes 0x80, so we assume that only bit 7 is relevant */
+	/* Mute video */
+	if (write_em27xx_single(gspca_dev, EM27XX_R20_YGAIN, 0x00) < 0)
+		PDEBUG(D_ERR,
+		       "em27xx_mute: error: setting contrast to 0 failed\n");
+	if (write_em27xx_single(gspca_dev, EM27XX_R21_YOFFSET, 0x80) < 0)
+		PDEBUG(D_ERR,
+		       "em27xx_mute: error: setting brightness to 0 failed\n");
+	if (write_em27xx_single(gspca_dev, EM27XX_R22_UVGAIN, 0x00) < 0)
+		PDEBUG(D_ERR,
+		       "em27xx_mute: error: setting saturation to 0 failed\n");
+	/* Switch off LED and start blinking */
+	read_em27xx(gspca_dev, EM27XX_R84_GPIO_1_R, &value, 1);
+	value |= EM27XX_GPIO_1_LED_STREAM;	/* switch LED off */
+	write_em27xx_single(gspca_dev, EM27XX_R80_GPIO_1_W, value);
+	schedule_delayed_work(&sd->led_blink_work,
+			      msecs_to_jiffies(LED_BLINK_INTERVAL));
+	sd->muted = true;
+}
+
+static void unmute(struct gspca_dev *gspca_dev)
+{
+	u8 value;
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	pr_info("unmuting audio/video\n");
+	/* Unmute audio */
+	value = 0x80;
+	if (read_em27xx(gspca_dev, EM27XX_R44_AUDIOCTRL, &value, 1) < 0)
+		PDEBUG(D_ERR,
+		       "em27xx_mute: error: failed to read from reg 0x%02x\n",
+		       EM27XX_R44_AUDIOCTRL);
+	value &= ~0x80;	/* switch LED off */
+	if (write_em27xx_single(gspca_dev, EM27XX_R44_AUDIOCTRL, value) < 0)
+		PDEBUG(D_ERR, "em27xx_unmute: error: unmuting audio failed\n");
+	/* NOTE: the windows driver reads value 0x80 from this register and
+	 *       then writes 0x00, so we assume that only bit 7 is relevant */
+	/* Unmute video */
+	/* NOTE: do NOT call set_... because this will not work when
+	 *       sd->muted is set                                    */
+	if (write_em27xx_single(gspca_dev, EM27XX_R20_YGAIN,
+				v4l2_ctrl_g_ctrl(sd->contrast)) < 0)
+		PDEBUG(D_ERR,
+		       "em27xx_unmute: error: "
+		       "failed to restore contrast setting\n");
+	if (write_em27xx_single(gspca_dev, EM27XX_R21_YOFFSET,
+				v4l2_ctrl_g_ctrl(sd->brightness)) < 0)
+		PDEBUG(D_ERR,
+		       "em27xx_unmute: error: "
+		       "failed to restore brightness setting\n");
+	if (write_em27xx_single(gspca_dev, EM27XX_R22_UVGAIN,
+				v4l2_ctrl_g_ctrl(sd->saturation)) < 0)
+		PDEBUG(D_ERR,
+		       "em27xx_unmute: error: "
+		       "failed to restore saturation setting\n");
+	/* Stop blinking and switch on LED */
+	cancel_delayed_work_sync(&sd->led_blink_work);
+	read_em27xx(gspca_dev, EM27XX_R84_GPIO_1_R, &value, 1);
+	value &= ~EM27XX_GPIO_1_LED_STREAM;	/* switch LED on */
+	write_em27xx_single(gspca_dev, EM27XX_R80_GPIO_1_W, value);
+	sd->muted = false;
+}
+
+static void toggle_led(struct work_struct *work)
+{
+	u8 value;
+	struct delayed_work *dw
+		 = container_of(work, struct delayed_work, work);
+	struct sd *sd = container_of(dw, struct sd, led_blink_work);
+	struct gspca_dev *gspca_dev = &sd->gspca_dev;
+
+	if (mutex_lock_interruptible(&gspca_dev->usb_lock))
+		return;
+	if (read_em27xx(gspca_dev, EM27XX_R84_GPIO_1_R, &value, 1) < 1) {
+		PDEBUG(D_ERR,
+		       "toggle_led: error: reading of the capturing "
+		       "LED status failed\n");
+		goto end;
+	}
+	if (value & EM27XX_GPIO_1_LED_STREAM)	/* LED is off */
+		value &= ~EM27XX_GPIO_1_LED_STREAM;	/* switch LED on */
+	else					/* LED is on */
+		value |= EM27XX_GPIO_1_LED_STREAM;	/* switch LED off */
+	if (write_em27xx_single(gspca_dev, EM27XX_R80_GPIO_1_W, value) < 1)
+		PDEBUG(D_ERR,
+		       "toggle_led: error: toggling the capturing "
+		       "LED failed\n");
+
+end:
+	mutex_unlock(&gspca_dev->usb_lock);
+	schedule_delayed_work(&sd->led_blink_work,
+			      msecs_to_jiffies(LED_BLINK_INTERVAL));
+}
+
+static void check_button(struct work_struct *work)
+{
+	uint8_t value;
+	struct delayed_work *dw = container_of(work, struct delayed_work, work);
+	struct sd *sd = container_of(dw, struct sd, gpio_query_work);
+	struct gspca_dev *gspca_dev = &sd->gspca_dev;
+
+	if (mutex_lock_interruptible(&gspca_dev->usb_lock))
+		return;
+	if (read_em27xx(gspca_dev, EM27XX_R84_GPIO_1_R, &value, 1) < 0) {
+		PDEBUG(D_ERR,
+		       "check_button: error: reading of the "
+		       "button states failed\n");
+	} else {
+		/* MUTE-BUTTON */
+		if (!(value & EM27XX_GPIO_1_BUTTON_MUTE)) {
+			if (!sd->mutebutton_locked) {
+				if (gspca_dev->streaming) {
+					if (!sd->muted) {
+						mute(gspca_dev);
+						value
+						  |= EM27XX_GPIO_1_LED_STREAM;
+					} else {
+						unmute(gspca_dev);
+						value
+						  &= ~EM27XX_GPIO_1_LED_STREAM;
+					}
+				}
+				sd->mutebutton_locked = true;
+			}
+		} else {
+			sd->mutebutton_locked = false;
+		}
+		/* LIGHT-BUTTON */
+		if (!(value & EM27XX_GPIO_1_BUTTON_LIGHT)) {
+			if (!sd->lightbutton_locked) {
+				if (value & EM27XX_GPIO_1_LED_LIGHT) {
+					pr_info("switching light on\n");
+					value &= ~EM27XX_GPIO_1_LED_LIGHT;
+					sd->illuminated = true;
+				} else {
+					pr_info("switching light off\n");
+					value |= EM27XX_GPIO_1_LED_LIGHT;
+					sd->illuminated = false;
+				}
+				sd->lightbutton_locked = true;
+			}
+		} else {
+			sd->lightbutton_locked = false;
+		}
+		/* Reset button states */
+		value |= EM27XX_GPIO_1_BUTTON_MUTE;
+		value |= EM27XX_GPIO_1_BUTTON_LIGHT;
+
+		if (write_em27xx_single(gspca_dev, EM27XX_R80_GPIO_1_W, value)
+		     < 0)
+			PDEBUG(D_ERR,
+			       "check_button: error: write to GPIO register 0x80 failed\n");
+	}
+
+#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
+	/* SNAPSHOT-BUTTON */
+	if (read_em27xx(gspca_dev, EM27XX_R85_GPIO_2_R, &value, 1) < 0)
+		PDEBUG(D_ERR,
+		       "check_button: error: reading of snapshot "
+		       "button status failed\n");
+	else {
+		if (!(value & EM27XX_GPIO_2_BUTTON_SNAPSHOT)) {
+			pr_info("snapshot button pressed\n");
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
+	gspca_debug &= ~D_ERR; /* suppress error while probing */
+#endif
+	for (i = 0; i < ARRAY_SIZE(sensor_slave_addresses); i++) {
+		slave_addr = sensor_slave_addresses[i];
+		/* OmniVision sensors */
+		reg = 0x1c;	/* OmniVision manufacturer ID (MSB) */
+		ret = read_propr(gspca_dev, slave_addr, reg, buf, 2);
+		if (ret == 2) {
+			id = (buf[0] << 8) + buf[1];
+			if (id == CHIP_ID_OMNIVISION) {
+#ifdef GSPCA_DEBUG
+				gspca_debug = gspca_debug_bak;
+#endif
+				reg = 0x0a; /* OmniVision product ID (MSB) */
+				ret = read_propr(gspca_dev, slave_addr, reg,
+						buf, 2);
+				if (ret == 2) {
+					id = (buf[0] << 8) + buf[1];
+					if (id == CHIP_ID_OV2640) {
+						PDEBUG(D_PROBE,
+						       "OV2640 sensor "
+						       "detected at slave "
+						       "address 0x%02x\n",
+						       slave_addr);
+						sd->sensor = SENSOR_OV2640;
+						sd->sensor_addr = slave_addr;
+						return 0;
+					} else {
+						PDEBUG(D_PROBE | D_ERR,
+						       "unknown OmniVision "
+						       "sensor detected: "
+						       "0x%02x\n",
+						       id);
+						return -ENODEV;
+					}
+				}
+			}
+			PDEBUG(D_PROBE | D_ERR,
+			       "unknown sensor detected at slave "
+			       "address 0x%02x\n",
+			       slave_addr);
+			return -ENODEV;
+		} else {
+			PDEBUG(D_PROBE,
+			       "no sensor detected at slave address 0x%02x\n",
+			       slave_addr);
+		}
+	}
+#ifdef GSPCA_DEBUG
+	gspca_debug = gspca_debug_bak;
+#endif
+
+	PDEBUG(D_PROBE | D_ERR, "error: no sensor detected\n");
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
+	INIT_DELAYED_WORK(&sd->led_blink_work, toggle_led);
+	INIT_DELAYED_WORK(&sd->gpio_query_work, check_button);
+
+	return 0;
+}
+
+/* this function is called at probe and resume time */
+static int sd_init(struct gspca_dev *gspca_dev)
+{
+	u8 i2c_slave_addr;
+	u8 buf[4];
+	int ret;
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	if (mutex_lock_interruptible(&gspca_dev->usb_lock))
+		return -ERESTARTSYS;
+	if (!sd->sensor_addr) {
+		/* Search for EEPROM */
+		i2c_slave_addr = 0xa0;	/* NOTE: also 0xa1 */
+		ret = read_i2c(gspca_dev, i2c_slave_addr, 0x0000, buf, 4);
+		if (ret < 0) {
+			PDEBUG(D_PROBE, "no EEPROM found\n");
+		} else {
+			struct sd *sd = (struct sd *) gspca_dev;
+			sd->eeprom_addr = i2c_slave_addr;
+
+			if ((buf[0] == 0x26) && (buf[3] == 0x00)) {
+				PDEBUG(D_PROBE, "EEPROM found: type em25xx\n");
+			} else if ((buf[0] == 0x1a) && (buf[1] == 0xeb)
+				    && (buf[2] == 0x67) && (buf[3] == 0x95)) {
+				PDEBUG(D_PROBE, "EEPROM found: type em28xx\n");
+			} else {
+				PDEBUG(D_PROBE, "EEPROM found: unknown type\n");
+				PDEBUG(D_PROBE,
+				       "EEPROM data at addresses "
+				       "0x0000 to 0x0003: "
+				       "%02x %02x %02x %02x\n",
+				       buf[0], buf[1], buf[2], buf[3]);
+			}
+		}
+
+		/* Verify bridge */
+		ret = read_em27xx(gspca_dev, EM27XX_R0A_CHIPID, buf, 1);
+		if (ret < 0)
+			return ret;
+		if (buf[0] == CHIP_ID_EM2765) {
+			PDEBUG(D_PROBE, "EM2765 bridge detected\n");
+		} else {
+			PDEBUG(D_PROBE | D_ERR,
+			       "error: unknown bridge detected: %02x\n",
+			       buf[0]);
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
+	buf[0] |= EM27XX_GPIO_1_LED_STREAM;	/* switch LED off */
+	if (sd->illuminated)
+		buf[0] &= ~EM27XX_GPIO_1_LED_LIGHT;	/* switch light on */
+	else
+		buf[0] |= EM27XX_GPIO_1_LED_LIGHT;	/* switch light on */
+	write_em27xx_single(gspca_dev, EM27XX_R80_GPIO_1_W, buf[0]);
+
+	mutex_unlock(&gspca_dev->usb_lock);
+
+	schedule_delayed_work(&sd->gpio_query_work,
+			      msecs_to_jiffies(GPIO_POLL_INTERVAL));
+
+	return 0;
+}
+
+static int sd_init_controls(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	struct v4l2_ctrl_handler *hdl = &sd->ctrl_handler;
+
+	gspca_dev->vdev.ctrl_handler = hdl;
+	v4l2_ctrl_handler_init(hdl, 5);
+
+	sd->brightness = v4l2_ctrl_new_std(hdl, &sd_ctrl_ops,
+					   V4L2_CID_BRIGHTNESS, -0x80, 0x7f, 1,
+					   BRIGHTNESS_DEFAULT);
+	/* NOTE: value stored in register as signed 8 bit */
+	sd->contrast = v4l2_ctrl_new_std(hdl, &sd_ctrl_ops,
+					 V4L2_CID_CONTRAST, 0, 0x1f, 1,
+					 CONTRAST_DEFAULT);
+	sd->saturation = v4l2_ctrl_new_std(hdl, &sd_ctrl_ops,
+					   V4L2_CID_SATURATION, 0, 0x1f, 1,
+					   SATURATION_DEFAULT);
+	sd->sharpness = v4l2_ctrl_new_std(hdl, &sd_ctrl_ops,
+					  V4L2_CID_SHARPNESS, 0, 0x0f, 1,
+					  SHARPNESS_DEFAULT);
+	sd->powerlinefreq
+	  = v4l2_ctrl_new_std_menu(hdl, &sd_ctrl_ops,
+				   V4L2_CID_POWER_LINE_FREQUENCY,
+				   V4L2_CID_POWER_LINE_FREQUENCY_60HZ, 0,
+				   POWERLINEFREQFILTER_DEFAULT);
+
+	if (hdl->error) {
+		pr_err("error: could not initialize controls\n");
+		return hdl->error;
+	}
+	return 0;
+}
+
+/* called on stream on before getting the EP */
+static int sd_init_transfer(struct gspca_dev *gspca_dev)
+{
+	/* Set bulk packet size */
+	gspca_dev->cam.bulk_size = gspca_dev
+				   ->cam.cam_mode[gspca_dev->curr_mode]
+				   .sizeimage + 2;
+	PDEBUG(D_CONF,
+	       "sd_init_transfer: setting bulk transfer buffer size to %d\n",
+	       gspca_dev->cam.bulk_size);
+	/* NOTE: DO NOT USE gspca_dev->frsz !
+	 * frame_alloc() in gspca.c calls PAGE_ALIGN(frsz)
+	 * which can increase this value !			 */
+	return 0;
+}
+
+static int set_videooutfmt(struct gspca_dev *gspca_dev)
+{
+	u8 value;
+	switch (gspca_dev->cam.cam_mode[gspca_dev->curr_mode].pixelformat) {
+	case V4L2_PIX_FMT_SRGGB8:
+		value = 0x00;	/* RGB_8_RGRG */
+		break;
+	case V4L2_PIX_FMT_RGB565:
+		value = 0x04;	/* RGB_16_656 */
+		break;
+/*	case V4L2_PIX_FMT_YUV211:
+		value = 0x10;	// YUV211
+		break;				*/
+		/* TODO: add support to the kernel */
+	case V4L2_PIX_FMT_YUYV:
+		value = 0x14;	/* YUV422_Y0UY1V */
+		break;
+	default:
+		pr_err("error: invalid pixel format selected\n");
+		return -EINVAL;
+	}
+	return write_em27xx_single(gspca_dev, EM27XX_R27_OUTFMT, value);
+}
+
+static void set_resolution(struct gspca_dev *gspca_dev)
+{
+	if (gspca_dev->cam.cam_mode[gspca_dev->curr_mode].width < 1600)
+		write_em27xx_single(gspca_dev, EM27XX_R0F_XCLK, 0x0b); /*24MHz*/
+	else
+		write_em27xx_single(gspca_dev, EM27XX_R0F_XCLK, 0x07); /*12MHz*/
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
+		} else { /* 320x240 */
+			write_em27xx_single(gspca_dev,
+					    EM27XX_R34_START_H, 0x14);
+			write_em27xx_single(gspca_dev,
+					    EM27XX_R35_START_V, 0x0f);
+		}
+	} else if (gspca_dev->cam.cam_mode[gspca_dev->curr_mode].width
+		    == 1280)                                           {
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
+		    == 1600)                                           {
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
+		PDEBUG(D_ERR,
+		       "em27xx_set_resolution: error: invalid resolution\n");
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
+	/* Select sensor register set */
+	if (write_propr_single(gspca_dev, sd->sensor_addr, 0xff, 0x01) < 0)
+		return;
+
+	/* COM1: dummy frames, vertical window start/end line control */
+	if (gspca_dev->cam.cam_mode[gspca_dev->curr_mode].width < 1600)
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x03, 0x8f);
+	else
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x03, 0x4f);
+
+	if (gspca_dev->cam.cam_mode[gspca_dev->curr_mode].width < 1280) {
+		/* Select SVGA mode */
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x12, 0x40);
+		/* Configure Window */
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x17, 0x11);
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x18, 0x43);
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x19, 0x00);
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x1a, 0x4b);
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x32, 0x09);
+		/* UNKNOWN/RESERVED */
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x6d, 0x00);
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x3d, 0x38);
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x39, 0x12);
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x35, 0xda);
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x22, 0x1a);
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x37, 0xc3);
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x23, 0x00);
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x34, 0xc0);
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x36, 0x1a);
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x06, 0x88);
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x07, 0xc0);
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x0d, 0x87);
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x0e, 0x41);
+	} else {
+		/* Select UXGA (full size) mode */
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x12, 0x00);
+		/* Configure Window */
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x17, 0x11);
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x18, 0x75);
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x19, 0x01);
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x1a, 0x97);
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x32, 0x36);
+		/* UNKNOWN/RESERVED */
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x6d, 0x80);
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x3d, 0x34);
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x39, 0x02);
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x35, 0x88);
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x22, 0x0a);
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x37, 0x40);
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x23, 0x00);
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x34, 0xa0);
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x36, 0x1a);
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x06, 0x02);
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x07, 0xc0);
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x0d, 0xb7);
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x0e, 0x01);
+	}
+	write_propr_single(gspca_dev, sd->sensor_addr, 0x4c, 0x00);
+
+	/* Select DSP register set */
+	if (write_propr_single(gspca_dev, sd->sensor_addr, 0xff, 0x00) < 0)
+		return;
+
+	/* CTRL2: module enable */
+	if (gspca_dev->cam.cam_mode[gspca_dev->curr_mode].width == 1600)
+		/* enable SDE+UV_ADJ+UV_AVG+CMX */
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x86, 0x1d);
+	else
+		/* enable DCW+SDE+UV_ADJ+UV_AVG+CMX */
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x86, 0x3d);
+
+	if (gspca_dev->cam.cam_mode[gspca_dev->curr_mode].width < 1280) {
+		/* CTRL3: enable BPC + WPC + UNKNOWN */
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x87, 0xd5);
+		/* Image size */
+		write_propr_single(gspca_dev, sd->sensor_addr, 0xc0, 0x64);
+		write_propr_single(gspca_dev, sd->sensor_addr, 0xc1, 0x4b);
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x8c, 0x00);
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x50, 0x00);
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x51, 0xc8);
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x52, 0x96);
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x53, 0x00);
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x54, 0x00);
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x55, 0x00);
+		/* Zoom settings */
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x5a, 0xa0);
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x5b, 0x78);
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x5c, 0x00);
+	} else {
+		/* CTRL3: enable BPC + WPC + UNKNOWN */
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x87, 0xd0);
+		/* Image size */
+		write_propr_single(gspca_dev, sd->sensor_addr, 0xc0, 0xc8);
+		write_propr_single(gspca_dev, sd->sensor_addr, 0xc1, 0x96);
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x8c, 0x00);
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x50, 0x00);
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x51, 0x90);
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x52, 0x2c);
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x53, 0x00);
+		write_propr_single(gspca_dev, sd->sensor_addr, 0x54, 0x00);
+		if (gspca_dev->cam.cam_mode[gspca_dev->curr_mode].width
+		     < 1600)                                            {
+			write_propr_single(gspca_dev, sd->sensor_addr,
+					   0x55, 0x88);
+			/* Zoom settings */
+			write_propr_single(gspca_dev, sd->sensor_addr,
+					   0x5a, 0x40);
+			write_propr_single(gspca_dev, sd->sensor_addr,
+					   0x5b, 0x00);
+			write_propr_single(gspca_dev, sd->sensor_addr,
+					   0x5c, 0x05);
+		} else {
+			write_propr_single(gspca_dev, sd->sensor_addr,
+					   0x55, 0xc8);
+			/* Zoom settings */
+			write_propr_single(gspca_dev, sd->sensor_addr,
+					   0x5a, 0x90);
+			write_propr_single(gspca_dev, sd->sensor_addr,
+					   0x5b, 0x2c);
+			write_propr_single(gspca_dev, sd->sensor_addr,
+					   0x5c, 0x05);
+		}
+	}
+	/* DVP speed control */
+	write_propr_single(gspca_dev, sd->sensor_addr, 0xd3, 0x82);
+	/* Disable reset mode */
+	write_propr_single(gspca_dev, sd->sensor_addr, 0xe0, 0x00);
+
+	set_powerlinefreqfilter(gspca_dev, v4l2_ctrl_g_ctrl(sd->powerlinefreq));
+}
+
+/* called on stream on after URBs creation */
+static int sd_start(struct gspca_dev *gspca_dev)
+{
+	int ret, i;
+	u8 reg, val;
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	PDEBUG(D_STREAM, "sd_start: starting streaming\n");
+
+	write_em27xx_single(gspca_dev, EM27XX_R0F_XCLK, 0x08);      /* 20MHz */
+	write_em27xx_single(gspca_dev, EM27XX_R26_COMPR, 0x00);
+	write_em27xx_single(gspca_dev, EM27XX_R13, 0x08);
+
+	set_videooutfmt(gspca_dev);
+	set_resolution(gspca_dev);
+
+	if (sd->sensor == SENSOR_OV2640) {
+		/* Basic sensor setup (constant register settings) */
+		/* NOTE: in theory, we could already do this in sd_init but
+		 * that causes strong exposure/gain fluctuations during the
+		 * first 1-2 seconds !
+		 * It seems that the sensor needs to be reset each time and
+		 * this is also what the windows driver does...            */
+		for (i = 0; i < ARRAY_SIZE(ov2640_init); i++) {
+			reg = ov2640_init[i][0];
+			val = ov2640_init[i][1];
+			ret = write_propr_single(gspca_dev, sd->sensor_addr,
+						 reg, val);
+			if (ret < 0) {
+				pr_err("error: sensor initialization failed: reg %02x\n",
+				       reg);
+				if (reg == 0xff)
+					break;
+				/* NOTE: reg 0xff = register set selection
+				  * => too risky to continue on error ! */
+			}
+		}
+		/* Variable sensor settings */
+		ov2640_config(gspca_dev);
+	} else
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
+	set_brightness(gspca_dev, v4l2_ctrl_g_ctrl(sd->brightness));
+	set_contrast(gspca_dev, v4l2_ctrl_g_ctrl(sd->contrast));
+	set_saturation(gspca_dev, v4l2_ctrl_g_ctrl(sd->saturation));
+	write_em27xx_single(gspca_dev, EM27XX_R14_GAMMA, 0x20);
+	set_sharpness(gspca_dev, v4l2_ctrl_g_ctrl(sd->sharpness));
+
+	write_em27xx_single(gspca_dev, EM27XX_R10_VINMODE, 0x08);
+	write_em27xx_single(gspca_dev, EM27XX_R11_VINCTRL, 0x00);
+	write_em27xx_single(gspca_dev, EM27XX_R12_VINENABLE, 0x67);
+
+	write_em27xx_single(gspca_dev, EM27XX_R0C_USBSUSP, 0x10);
+
+	read_em27xx(gspca_dev, EM27XX_R84_GPIO_1_R, &val, 1);
+	val &= ~EM27XX_GPIO_1_LED_STREAM;			/* LED ON */
+	write_em27xx_single(gspca_dev, EM27XX_R80_GPIO_1_W, val);
+
+	return 0;
+}
+
+static void sd_stop(struct gspca_dev *gspca_dev)
+{
+	u8 value;
+
+	PDEBUG(D_STREAM, "sd_stop: stopping streaming\n");
+	unmute(gspca_dev);
+
+	write_em27xx_single(gspca_dev, EM27XX_R12_VINENABLE, 0x27);
+	write_em27xx_single(gspca_dev, EM27XX_R0C_USBSUSP, 0x00);
+
+	read_em27xx(gspca_dev, EM27XX_R84_GPIO_1_R, &value, 1);
+	value |= EM27XX_GPIO_1_LED_STREAM;	/* turn off LED */
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
+		       "sd_pkt_scan: invalid packet header, ignoring packet\n");
+		/* NOTE: should we already discard the packet here ? */
+		return;
+	}
+
+	img_size = gspca_dev->image_len;
+
+	if ((gspca_dev->last_packet_type == LAST_PACKET)
+	    || (gspca_dev->last_packet_type == DISCARD_PACKET)) {
+		PDEBUG(D_PACK | D_FRAM, "sd_pkt_scan: setting up new frame\n");
+		gspca_frame_add(gspca_dev, FIRST_PACKET, data + 2, len - 2);
+	} else {
+		PDEBUG(D_PACK | D_FRAM,
+		       "sd_pkt_scan: adding packet to current frame\n");
+		gspca_frame_add(gspca_dev, INTER_PACKET, data + 2, len - 2);
+	}
+
+	if (header[1] & BULK_HEADER_FRAME_END) {
+		PDEBUG(D_PACK,
+		       "sd_pkt_scan: packet header indicates frame end\n");
+		/* NOTE: DO NOT CHECK gspca_dev->frsz !
+		 * frame_alloc() in gspca.c calls PAGE_ALIGN(frsz)
+		 * which can increase this value !			 */
+		if (img_size + (len - 2)
+		    != gspca_dev->cam.cam_mode[gspca_dev->curr_mode]
+		       .sizeimage) {
+			PDEBUG(D_PACK | D_FRAM,
+			       "sd_pkt_scan: discarding frame due to invalid "
+			       "frame size\n");
+			gspca_frame_add(gspca_dev, DISCARD_PACKET, NULL, 0);
+			gspca_dev->image_len = 0;
+		} else {
+			gspca_frame_add(gspca_dev, LAST_PACKET, NULL, 0);
+			PDEBUG(D_FRAM, "sd_pkt_scan: frame complete\n");
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
+			if (read_propr(gspca_dev, reg->match.addr,
+				       reg->reg, &val, 1)          < 0)
+				return -EIO;
+		} else if (sd->eeprom_addr
+			   && (reg->match.addr == sd->eeprom_addr)) {
+			if (reg->reg > 0xffff)
+				return -EINVAL;
+			if (read_i2c(gspca_dev, reg->match.addr,
+				      reg->reg, &val, 1)         < 0)
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
+			       struct v4l2_dbg_register *reg)
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
+			if (write_propr_single(gspca_dev, sd->sensor_addr,
+					       reg->reg, reg->val)         < 0)
+				return -EIO;
+		} else if (sd->eeprom_addr
+			   && (reg->match.addr == sd->eeprom_addr)) {
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
+			     struct v4l2_dbg_chip_ident *chip)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	switch (chip->match.type) {
+	case V4L2_CHIP_MATCH_HOST:
+		if (chip->match.addr != 0)
+			return -EINVAL;
+		chip->revision = 0;
+		chip->ident = 0; /* V4L2_IDENT_EM2765; */	/* FIXME: ADD TO KERNEL */
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
+	.config    = sd_config,
+	.init      = sd_init,
+	.init_controls = sd_init_controls,
+	.start     = sd_start,
+	.pkt_scan  = sd_pkt_scan,
+	.isoc_init = sd_init_transfer,
+	.stopN     = sd_stop,
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
+	/* NOTE: devices 1ae7:9003 and 1ae7:9004 have 3 interfaces:
+	 *       0, 1: audio; 2: [missing]; 3: video (bulk)           */
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
+module_usb_driver(sd_driver);
-- 
1.7.7

