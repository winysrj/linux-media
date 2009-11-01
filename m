Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:51670 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbZKAGRA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Nov 2009 01:17:00 -0500
Message-ID: <4AED27D2.70301@freemail.hu>
Date: Sun, 01 Nov 2009 07:16:50 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	V4L Mailing List <linux-media@vger.kernel.org>
CC: Thomas Kaiser <thomas@kaiser-linux.li>,
	Theodore Kilgore <kilgota@auburn.edu>,
	Kyle Guinn <elyk03@gmail.com>
Subject: Re: [PATCH 20/21] gspca pac7302/pac7311: separate the two subdrivers
References: <4AECC56C.6090107@freemail.hu>
In-Reply-To: <4AECC56C.6090107@freemail.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

All PAC7311 specific functions remain in pac7311.c. All PAC7302 specific
functions are moved to pac7302.c. The USB device table is also divided into
two parts. This makes it possible to remove the last sensor specific
decision in sd_probe() functions.

The common functions are just copied to both subdrivers. These common
functions can be separated later to a common file or helper module.

Signed-off-by: Márton Németh <nm127@freemail.hu>
Cc: Thomas Kaiser <thomas@kaiser-linux.li>
Cc: Theodore Kilgore <kilgota@auburn.edu>
Cc: Kyle Guinn <elyk03@gmail.com>
---
Patch rebased to the latest http://linuxtv.org/hg/v4l-dvb/ (rev 13254).
---
diff -uprN t/drivers/media/video/gspca/Kconfig u/drivers/media/video/gspca/Kconfig
--- t/drivers/media/video/gspca/Kconfig	2009-11-01 06:54:04.000000000 +0100
+++ u/drivers/media/video/gspca/Kconfig	2009-11-01 06:58:14.000000000 +0100
@@ -104,6 +104,15 @@ config USB_GSPCA_PAC207
 	  To compile this driver as a module, choose M here: the
 	  module will be called gspca_pac207.

+config USB_GSPCA_PAC7302
+	tristate "Pixart PAC7302 USB Camera Driver"
+	depends on VIDEO_V4L2 && USB_GSPCA
+	help
+	  Say Y here if you want support for cameras based on the PAC7302 chip.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called gspca_pac7302.
+
 config USB_GSPCA_PAC7311
 	tristate "Pixart PAC7311 USB Camera Driver"
 	depends on VIDEO_V4L2 && USB_GSPCA
diff -uprN t/drivers/media/video/gspca/Makefile u/drivers/media/video/gspca/Makefile
--- t/drivers/media/video/gspca/Makefile	2009-11-01 06:54:04.000000000 +0100
+++ u/drivers/media/video/gspca/Makefile	2009-11-01 06:58:14.000000000 +0100
@@ -8,6 +8,7 @@ obj-$(CONFIG_USB_GSPCA_MR97310A) += gspc
 obj-$(CONFIG_USB_GSPCA_OV519)    += gspca_ov519.o
 obj-$(CONFIG_USB_GSPCA_OV534)    += gspca_ov534.o
 obj-$(CONFIG_USB_GSPCA_PAC207)   += gspca_pac207.o
+obj-$(CONFIG_USB_GSPCA_PAC7302)  += gspca_pac7302.o
 obj-$(CONFIG_USB_GSPCA_PAC7311)  += gspca_pac7311.o
 obj-$(CONFIG_USB_GSPCA_SN9C20X)  += gspca_sn9c20x.o
 obj-$(CONFIG_USB_GSPCA_SONIXB)   += gspca_sonixb.o
@@ -38,6 +39,7 @@ gspca_mr97310a-objs := mr97310a.o
 gspca_ov519-objs    := ov519.o
 gspca_ov534-objs    := ov534.o
 gspca_pac207-objs   := pac207.o
+gspca_pac7302-objs  := pac7302.o
 gspca_pac7311-objs  := pac7311.o
 gspca_sn9c20x-objs  := sn9c20x.o
 gspca_sonixb-objs   := sonixb.o
diff -uprN t/drivers/media/video/gspca/pac7302.c u/drivers/media/video/gspca/pac7302.c
--- t/drivers/media/video/gspca/pac7302.c	1970-01-01 01:00:00.000000000 +0100
+++ u/drivers/media/video/gspca/pac7302.c	2009-11-01 07:00:04.000000000 +0100
@@ -0,0 +1,978 @@
+/*
+ *		Pixart PAC7302 library
+ *		Copyright (C) 2005 Thomas Kaiser thomas@kaiser-linux.li
+ *
+ * V4L2 by Jean-Francois Moine <http://moinejf.free.fr>
+ *
+ * Separated from Pixart PAC7311 library by Márton Németh <nm127@freemail.hu>
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
+/* Some documentation about various registers as determined by trial and error.
+   When the register addresses differ between the 7202 and the 7311 the 2
+   different addresses are written as 7302addr/7311addr, when one of the 2
+   addresses is a - sign that register description is not valid for the
+   matching IC.
+
+   Register page 1:
+
+   Address	Description
+   -/0x08	Unknown compressor related, must always be 8 except when not
+		in 640x480 resolution and page 4 reg 2 <= 3 then set it to 9 !
+   -/0x1b	Auto white balance related, bit 0 is AWB enable (inverted)
+		bits 345 seem to toggle per color gains on/off (inverted)
+   0x78		Global control, bit 6 controls the LED (inverted)
+   -/0x80	JPEG compression ratio ? Best not touched
+
+   Register page 3/4:
+
+   Address	Description
+   0x02		Clock divider 2-63, fps =~ 60 / val. Must be a multiple of 3 on
+		the 7302, so one of 3, 6, 9, ..., except when between 6 and 12?
+   -/0x0f	Master gain 1-245, low value = high gain
+   0x10/-	Master gain 0-31
+   -/0x10	Another gain 0-15, limited influence (1-2x gain I guess)
+   0x21		Bitfield: 0-1 unused, 2-3 vflip/hflip, 4-5 unknown, 6-7 unused
+   -/0x27	Seems to toggle various gains on / off, Setting bit 7 seems to
+		completely disable the analog amplification block. Set to 0x68
+		for max gain, 0x14 for minimal gain.
+*/
+
+#define MODULE_NAME "pac7302"
+
+#include "gspca.h"
+
+MODULE_AUTHOR("Thomas Kaiser thomas@kaiser-linux.li");
+MODULE_DESCRIPTION("Pixart PAC7302");
+MODULE_LICENSE("GPL");
+
+/* specific webcam descriptor for pac7302 */
+struct pac7302_sd {
+	struct gspca_dev gspca_dev;		/* !! must be the first item */
+
+	unsigned char brightness;
+	unsigned char contrast;
+	unsigned char colors;
+	unsigned char gain;
+	unsigned char exposure;
+	unsigned char autogain;
+	__u8 hflip;
+	__u8 vflip;
+
+#define SENSOR_PAC7302 0
+
+	u8 sof_read;
+	u8 autogain_ignore_frames;
+
+	atomic_t avg_lum;
+};
+
+/* V4L2 controls supported by the driver */
+static int pac7302_sd_setbrightness(struct gspca_dev *gspca_dev, __s32 val);
+static int pac7302_sd_getbrightness(struct gspca_dev *gspca_dev, __s32 *val);
+static int pac7302_sd_setcontrast(struct gspca_dev *gspca_dev, __s32 val);
+static int pac7302_sd_getcontrast(struct gspca_dev *gspca_dev, __s32 *val);
+static int pac7302_sd_setcolors(struct gspca_dev *gspca_dev, __s32 val);
+static int pac7302_sd_getcolors(struct gspca_dev *gspca_dev, __s32 *val);
+static int pac7302_sd_setautogain(struct gspca_dev *gspca_dev, __s32 val);
+static int pac7302_sd_getautogain(struct gspca_dev *gspca_dev, __s32 *val);
+static int pac7302_sd_sethflip(struct gspca_dev *gspca_dev, __s32 val);
+static int pac7302_sd_gethflip(struct gspca_dev *gspca_dev, __s32 *val);
+static int pac7302_sd_setvflip(struct gspca_dev *gspca_dev, __s32 val);
+static int pac7302_sd_getvflip(struct gspca_dev *gspca_dev, __s32 *val);
+static int pac7302_sd_setgain(struct gspca_dev *gspca_dev, __s32 val);
+static int pac7302_sd_getgain(struct gspca_dev *gspca_dev, __s32 *val);
+static int pac7302_sd_setexposure(struct gspca_dev *gspca_dev, __s32 val);
+static int pac7302_sd_getexposure(struct gspca_dev *gspca_dev, __s32 *val);
+
+static struct ctrl pac7302_sd_ctrls[] = {
+/* This control is pac7302 only */
+	{
+	    {
+		.id      = V4L2_CID_BRIGHTNESS,
+		.type    = V4L2_CTRL_TYPE_INTEGER,
+		.name    = "Brightness",
+		.minimum = 0,
+#define BRIGHTNESS_MAX 0x20
+		.maximum = BRIGHTNESS_MAX,
+		.step    = 1,
+#define BRIGHTNESS_DEF 0x10
+		.default_value = BRIGHTNESS_DEF,
+	    },
+	    .set = pac7302_sd_setbrightness,
+	    .get = pac7302_sd_getbrightness,
+	},
+/* This control is for both the 7302 and the 7311 */
+	{
+	    {
+		.id      = V4L2_CID_CONTRAST,
+		.type    = V4L2_CTRL_TYPE_INTEGER,
+		.name    = "Contrast",
+		.minimum = 0,
+#define CONTRAST_MAX 255
+		.maximum = CONTRAST_MAX,
+		.step    = 1,
+#define CONTRAST_DEF 127
+		.default_value = CONTRAST_DEF,
+	    },
+	    .set = pac7302_sd_setcontrast,
+	    .get = pac7302_sd_getcontrast,
+	},
+/* This control is pac7302 only */
+	{
+	    {
+		.id      = V4L2_CID_SATURATION,
+		.type    = V4L2_CTRL_TYPE_INTEGER,
+		.name    = "Saturation",
+		.minimum = 0,
+#define COLOR_MAX 255
+		.maximum = COLOR_MAX,
+		.step    = 1,
+#define COLOR_DEF 127
+		.default_value = COLOR_DEF,
+	    },
+	    .set = pac7302_sd_setcolors,
+	    .get = pac7302_sd_getcolors,
+	},
+/* All controls below are for both the 7302 and the 7311 */
+	{
+	    {
+		.id      = V4L2_CID_GAIN,
+		.type    = V4L2_CTRL_TYPE_INTEGER,
+		.name    = "Gain",
+		.minimum = 0,
+#define GAIN_MAX 255
+		.maximum = GAIN_MAX,
+		.step    = 1,
+#define GAIN_DEF 127
+#define GAIN_KNEE 255 /* Gain seems to cause little noise on the pac73xx */
+		.default_value = GAIN_DEF,
+	    },
+	    .set = pac7302_sd_setgain,
+	    .get = pac7302_sd_getgain,
+	},
+	{
+	    {
+		.id      = V4L2_CID_EXPOSURE,
+		.type    = V4L2_CTRL_TYPE_INTEGER,
+		.name    = "Exposure",
+		.minimum = 0,
+#define EXPOSURE_MAX 255
+		.maximum = EXPOSURE_MAX,
+		.step    = 1,
+#define EXPOSURE_DEF  16 /*  32 ms / 30 fps */
+#define EXPOSURE_KNEE 50 /* 100 ms / 10 fps */
+		.default_value = EXPOSURE_DEF,
+	    },
+	    .set = pac7302_sd_setexposure,
+	    .get = pac7302_sd_getexposure,
+	},
+	{
+	    {
+		.id      = V4L2_CID_AUTOGAIN,
+		.type    = V4L2_CTRL_TYPE_BOOLEAN,
+		.name    = "Auto Gain",
+		.minimum = 0,
+		.maximum = 1,
+		.step    = 1,
+#define AUTOGAIN_DEF 1
+		.default_value = AUTOGAIN_DEF,
+	    },
+	    .set = pac7302_sd_setautogain,
+	    .get = pac7302_sd_getautogain,
+	},
+	{
+	    {
+		.id      = V4L2_CID_HFLIP,
+		.type    = V4L2_CTRL_TYPE_BOOLEAN,
+		.name    = "Mirror",
+		.minimum = 0,
+		.maximum = 1,
+		.step    = 1,
+#define HFLIP_DEF 0
+		.default_value = HFLIP_DEF,
+	    },
+	    .set = pac7302_sd_sethflip,
+	    .get = pac7302_sd_gethflip,
+	},
+	{
+	    {
+		.id      = V4L2_CID_VFLIP,
+		.type    = V4L2_CTRL_TYPE_BOOLEAN,
+		.name    = "Vflip",
+		.minimum = 0,
+		.maximum = 1,
+		.step    = 1,
+#define VFLIP_DEF 0
+		.default_value = VFLIP_DEF,
+	    },
+	    .set = pac7302_sd_setvflip,
+	    .get = pac7302_sd_getvflip,
+	},
+};
+
+static const struct v4l2_pix_format pac7302_vga_mode[] = {
+	{640, 480, V4L2_PIX_FMT_PJPG, V4L2_FIELD_NONE,
+		.bytesperline = 640,
+		.sizeimage = 640 * 480 * 3 / 8 + 590,
+		.colorspace = V4L2_COLORSPACE_JPEG,
+		.priv = 0},
+};
+
+#define LOAD_PAGE3		255
+#define LOAD_PAGE4		254
+#define END_OF_SEQUENCE		0
+
+/* pac 7302 */
+static const __u8 init_7302[] = {
+/*	index,value */
+	0xff, 0x01,		/* page 1 */
+	0x78, 0x00,		/* deactivate */
+	0xff, 0x01,
+	0x78, 0x40,		/* led off */
+};
+static const __u8 start_7302[] = {
+/*	index, len, [value]* */
+	0xff, 1,	0x00,		/* page 0 */
+	0x00, 12,	0x01, 0x40, 0x40, 0x40, 0x01, 0xe0, 0x02, 0x80,
+			0x00, 0x00, 0x00, 0x00,
+	0x0d, 24,	0x03, 0x01, 0x00, 0xb5, 0x07, 0xcb, 0x00, 0x00,
+			0x07, 0xc8, 0x00, 0xea, 0x07, 0xcf, 0x07, 0xf7,
+			0x07, 0x7e, 0x01, 0x0b, 0x00, 0x00, 0x00, 0x11,
+	0x26, 2,	0xaa, 0xaa,
+	0x2e, 1,	0x31,
+	0x38, 1,	0x01,
+	0x3a, 3,	0x14, 0xff, 0x5a,
+	0x43, 11,	0x00, 0x0a, 0x18, 0x11, 0x01, 0x2c, 0x88, 0x11,
+			0x00, 0x54, 0x11,
+	0x55, 1,	0x00,
+	0x62, 4, 	0x10, 0x1e, 0x1e, 0x18,
+	0x6b, 1,	0x00,
+	0x6e, 3,	0x08, 0x06, 0x00,
+	0x72, 3,	0x00, 0xff, 0x00,
+	0x7d, 23,	0x01, 0x01, 0x58, 0x46, 0x50, 0x3c, 0x50, 0x3c,
+			0x54, 0x46, 0x54, 0x56, 0x52, 0x50, 0x52, 0x50,
+			0x56, 0x64, 0xa4, 0x00, 0xda, 0x00, 0x00,
+	0xa2, 10,	0x22, 0x2c, 0x3c, 0x54, 0x69, 0x7c, 0x9c, 0xb9,
+			0xd2, 0xeb,
+	0xaf, 1,	0x02,
+	0xb5, 2,	0x08, 0x08,
+	0xb8, 2,	0x08, 0x88,
+	0xc4, 4,	0xae, 0x01, 0x04, 0x01,
+	0xcc, 1,	0x00,
+	0xd1, 11,	0x01, 0x30, 0x49, 0x5e, 0x6f, 0x7f, 0x8e, 0xa9,
+			0xc1, 0xd7, 0xec,
+	0xdc, 1,	0x01,
+	0xff, 1,	0x01,		/* page 1 */
+	0x12, 3,	0x02, 0x00, 0x01,
+	0x3e, 2,	0x00, 0x00,
+	0x76, 5,	0x01, 0x20, 0x40, 0x00, 0xf2,
+	0x7c, 1,	0x00,
+	0x7f, 10,	0x4b, 0x0f, 0x01, 0x2c, 0x02, 0x58, 0x03, 0x20,
+			0x02, 0x00,
+	0x96, 5,	0x01, 0x10, 0x04, 0x01, 0x04,
+	0xc8, 14,	0x00, 0x00, 0x00, 0x00, 0x00, 0x07, 0x00, 0x00,
+			0x07, 0x00, 0x01, 0x07, 0x04, 0x01,
+	0xd8, 1,	0x01,
+	0xdb, 2,	0x00, 0x01,
+	0xde, 7,	0x00, 0x01, 0x04, 0x04, 0x00, 0x00, 0x00,
+	0xe6, 4,	0x00, 0x00, 0x00, 0x01,
+	0xeb, 1,	0x00,
+	0xff, 1,	0x02,		/* page 2 */
+	0x22, 1,	0x00,
+	0xff, 1,	0x03,		/* page 3 */
+	0, LOAD_PAGE3,			/* load the page 3 */
+	0x11, 1,	0x01,
+	0xff, 1,	0x02,		/* page 2 */
+	0x13, 1,	0x00,
+	0x22, 4,	0x1f, 0xa4, 0xf0, 0x96,
+	0x27, 2,	0x14, 0x0c,
+	0x2a, 5,	0xc8, 0x00, 0x18, 0x12, 0x22,
+	0x64, 8,	0x00, 0x00, 0xf0, 0x01, 0x14, 0x44, 0x44, 0x44,
+	0x6e, 1,	0x08,
+	0xff, 1,	0x01,		/* page 1 */
+	0x78, 1,	0x00,
+	0, END_OF_SEQUENCE		/* end of sequence */
+};
+
+#define SKIP		0xaa
+/* page 3 - the value SKIP says skip the index - see reg_w_page() */
+static const __u8 page3_7302[] = {
+	0x90, 0x40, 0x03, 0x50, 0xc2, 0x01, 0x14, 0x16,
+	0x14, 0x12, 0x00, 0x00, 0x00, 0x02, 0x33, 0x00,
+	0x0f, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x47, 0x01, 0xb3, 0x01, 0x00,
+	0x00, 0x08, 0x00, 0x00, 0x0d, 0x00, 0x00, 0x21,
+	0x00, 0x00, 0x00, 0x54, 0xf4, 0x02, 0x52, 0x54,
+	0xa4, 0xb8, 0xe0, 0x2a, 0xf6, 0x00, 0x00, 0x00,
+	0x00, 0x1e, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0xfc, 0x00, 0xf2, 0x1f, 0x04, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0xc0, 0xc0, 0x10, 0x00, 0x00,
+	0x00, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x40, 0xff, 0x03, 0x19, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0xc8, 0xc8, 0xc8,
+	0xc8, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x50,
+	0x08, 0x10, 0x24, 0x40, 0x00, 0x00, 0x00, 0x00,
+	0x01, 0x00, 0x02, 0x47, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x02, 0xfa, 0x00, 0x64, 0x5a, 0x28, 0x00,
+	0x00
+};
+
+static void reg_w_buf(struct gspca_dev *gspca_dev,
+		  __u8 index,
+		  const char *buffer, int len)
+{
+	memcpy(gspca_dev->usb_buf, buffer, len);
+	usb_control_msg(gspca_dev->dev,
+			usb_sndctrlpipe(gspca_dev->dev, 0),
+			1,		/* request */
+			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+			0,		/* value */
+			index, gspca_dev->usb_buf, len,
+			500);
+}
+
+#if 0 /* not used */
+static __u8 reg_r(struct gspca_dev *gspca_dev,
+			     __u8 index)
+{
+	usb_control_msg(gspca_dev->dev,
+			usb_rcvctrlpipe(gspca_dev->dev, 0),
+			0,			/* request */
+			USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+			0,			/* value */
+			index, gspca_dev->usb_buf, 1,
+			500);
+	return gspca_dev->usb_buf[0];
+}
+#endif
+
+static void reg_w(struct gspca_dev *gspca_dev,
+		  __u8 index,
+		  __u8 value)
+{
+	gspca_dev->usb_buf[0] = value;
+	usb_control_msg(gspca_dev->dev,
+			usb_sndctrlpipe(gspca_dev->dev, 0),
+			0,			/* request */
+			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+			0, index, gspca_dev->usb_buf, 1,
+			500);
+}
+
+static void reg_w_seq(struct gspca_dev *gspca_dev,
+		const __u8 *seq, int len)
+{
+	while (--len >= 0) {
+		reg_w(gspca_dev, seq[0], seq[1]);
+		seq += 2;
+	}
+}
+
+/* load the beginning of a page */
+static void reg_w_page(struct gspca_dev *gspca_dev,
+			const __u8 *page, int len)
+{
+	int index;
+
+	for (index = 0; index < len; index++) {
+		if (page[index] == SKIP)		/* skip this index */
+			continue;
+		gspca_dev->usb_buf[0] = page[index];
+		usb_control_msg(gspca_dev->dev,
+				usb_sndctrlpipe(gspca_dev->dev, 0),
+				0,			/* request */
+			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+				0, index, gspca_dev->usb_buf, 1,
+				500);
+	}
+}
+
+/* output a variable sequence */
+static void reg_w_var(struct gspca_dev *gspca_dev,
+			const __u8 *seq,
+			const __u8 *page3, unsigned int page3_len,
+			const __u8 *page4, unsigned int page4_len)
+{
+	int index, len;
+
+	for (;;) {
+		index = *seq++;
+		len = *seq++;
+		switch (len) {
+		case END_OF_SEQUENCE:
+			return;
+		case LOAD_PAGE4:
+			reg_w_page(gspca_dev, page4, page4_len);
+			break;
+		case LOAD_PAGE3:
+			reg_w_page(gspca_dev, page3, page3_len);
+			break;
+		default:
+			if (len > USB_BUF_SZ) {
+				PDEBUG(D_ERR|D_STREAM,
+					"Incorrect variable sequence");
+				return;
+			}
+			while (len > 0) {
+				if (len < 8) {
+					reg_w_buf(gspca_dev, index, seq, len);
+					seq += len;
+					break;
+				}
+				reg_w_buf(gspca_dev, index, seq, 8);
+				seq += 8;
+				index += 8;
+				len -= 8;
+			}
+		}
+	}
+	/* not reached */
+}
+
+/* this function is called at probe time for pac7302 */
+static int pac7302_sd_config(struct gspca_dev *gspca_dev,
+			const struct usb_device_id *id)
+{
+	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
+	struct cam *cam;
+
+	cam = &gspca_dev->cam;
+
+	PDEBUG(D_CONF, "Find Sensor PAC7302");
+	cam->cam_mode = pac7302_vga_mode;	/* only 640x480 */
+	cam->nmodes = ARRAY_SIZE(pac7302_vga_mode);
+
+	sd->brightness = BRIGHTNESS_DEF;
+	sd->contrast = CONTRAST_DEF;
+	sd->colors = COLOR_DEF;
+	sd->gain = GAIN_DEF;
+	sd->exposure = EXPOSURE_DEF;
+	sd->autogain = AUTOGAIN_DEF;
+	sd->hflip = HFLIP_DEF;
+	sd->vflip = VFLIP_DEF;
+	return 0;
+}
+
+/* This function is used by pac7302 only */
+static void pac7302_setbrightcont(struct gspca_dev *gspca_dev)
+{
+	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
+	int i, v;
+	static const __u8 max[10] =
+		{0x29, 0x33, 0x42, 0x5a, 0x6e, 0x80, 0x9f, 0xbb,
+		 0xd4, 0xec};
+	static const __u8 delta[10] =
+		{0x35, 0x33, 0x33, 0x2f, 0x2a, 0x25, 0x1e, 0x17,
+		 0x11, 0x0b};
+
+	reg_w(gspca_dev, 0xff, 0x00);	/* page 0 */
+	for (i = 0; i < 10; i++) {
+		v = max[i];
+		v += (sd->brightness - BRIGHTNESS_MAX)
+			* 150 / BRIGHTNESS_MAX;		/* 200 ? */
+		v -= delta[i] * sd->contrast / CONTRAST_MAX;
+		if (v < 0)
+			v = 0;
+		else if (v > 0xff)
+			v = 0xff;
+		reg_w(gspca_dev, 0xa2 + i, v);
+	}
+	reg_w(gspca_dev, 0xdc, 0x01);
+}
+
+/* This function is used by pac7302 only */
+static void pac7302_setcolors(struct gspca_dev *gspca_dev)
+{
+	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
+	int i, v;
+	static const int a[9] =
+		{217, -212, 0, -101, 170, -67, -38, -315, 355};
+	static const int b[9] =
+		{19, 106, 0, 19, 106, 1, 19, 106, 1};
+
+	reg_w(gspca_dev, 0xff, 0x03);	/* page 3 */
+	reg_w(gspca_dev, 0x11, 0x01);
+	reg_w(gspca_dev, 0xff, 0x00);	/* page 0 */
+	for (i = 0; i < 9; i++) {
+		v = a[i] * sd->colors / COLOR_MAX + b[i];
+		reg_w(gspca_dev, 0x0f + 2 * i, (v >> 8) & 0x07);
+		reg_w(gspca_dev, 0x0f + 2 * i + 1, v);
+	}
+	reg_w(gspca_dev, 0xdc, 0x01);
+	PDEBUG(D_CONF|D_STREAM, "color: %i", sd->colors);
+}
+
+static void pac7302_setgain(struct gspca_dev *gspca_dev)
+{
+	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
+
+	reg_w(gspca_dev, 0xff, 0x03);		/* page 3 */
+	reg_w(gspca_dev, 0x10, sd->gain >> 3);
+
+	/* load registers to sensor (Bit 0, auto clear) */
+	reg_w(gspca_dev, 0x11, 0x01);
+}
+
+static void pac7302_setexposure(struct gspca_dev *gspca_dev)
+{
+	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
+	__u8 reg;
+
+	/* register 2 of frame 3/4 contains the clock divider configuring the
+	   no fps according to the formula: 60 / reg. sd->exposure is the
+	   desired exposure time in ms. */
+	reg = 120 * sd->exposure / 1000;
+	if (reg < 2)
+		reg = 2;
+	else if (reg > 63)
+		reg = 63;
+
+	/* On the pac7302 reg2 MUST be a multiple of 3, so round it to
+	   the nearest multiple of 3, except when between 6 and 12? */
+	if (reg < 6 || reg > 12)
+		reg = ((reg + 1) / 3) * 3;
+	reg_w(gspca_dev, 0xff, 0x03);		/* page 3 */
+	reg_w(gspca_dev, 0x02, reg);
+
+	/* load registers to sensor (Bit 0, auto clear) */
+	reg_w(gspca_dev, 0x11, 0x01);
+}
+
+static void pac7302_sethvflip(struct gspca_dev *gspca_dev)
+{
+	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
+	__u8 data;
+
+	reg_w(gspca_dev, 0xff, 0x03);		/* page 3 */
+	data = (sd->hflip ? 0x08 : 0x00) | (sd->vflip ? 0x04 : 0x00);
+	reg_w(gspca_dev, 0x21, data);
+	/* load registers to sensor (Bit 0, auto clear) */
+	reg_w(gspca_dev, 0x11, 0x01);
+}
+
+/* this function is called at probe and resume time for pac7302 */
+static int pac7302_sd_init(struct gspca_dev *gspca_dev)
+{
+	reg_w_seq(gspca_dev, init_7302, sizeof init_7302);
+
+	return 0;
+}
+
+static int pac7302_sd_start(struct gspca_dev *gspca_dev)
+{
+	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
+
+	sd->sof_read = 0;
+
+	reg_w_var(gspca_dev, start_7302,
+		page3_7302, sizeof(page3_7302),
+		NULL, 0);
+	pac7302_setbrightcont(gspca_dev);
+	pac7302_setcolors(gspca_dev);
+	pac7302_setgain(gspca_dev);
+	pac7302_setexposure(gspca_dev);
+	pac7302_sethvflip(gspca_dev);
+
+	/* only resolution 640x480 is supported for pac7302 */
+
+	sd->sof_read = 0;
+	sd->autogain_ignore_frames = 0;
+	atomic_set(&sd->avg_lum, -1);
+
+	/* start stream */
+	reg_w(gspca_dev, 0xff, 0x01);
+	reg_w(gspca_dev, 0x78, 0x01);
+
+	return 0;
+}
+
+static void pac7302_sd_stopN(struct gspca_dev *gspca_dev)
+{
+	reg_w(gspca_dev, 0xff, 0x01);
+	reg_w(gspca_dev, 0x78, 0x00);
+	reg_w(gspca_dev, 0x78, 0x00);
+}
+
+/* called on streamoff with alt 0 and on disconnect for pac7302 */
+static void pac7302_sd_stop0(struct gspca_dev *gspca_dev)
+{
+	if (!gspca_dev->present)
+		return;
+	reg_w(gspca_dev, 0xff, 0x01);
+	reg_w(gspca_dev, 0x78, 0x40);
+}
+
+/* Include pac common sof detection functions */
+#include "pac_common.h"
+
+static void pac7302_do_autogain(struct gspca_dev *gspca_dev)
+{
+	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
+	int avg_lum = atomic_read(&sd->avg_lum);
+	int desired_lum, deadzone;
+
+	if (avg_lum == -1)
+		return;
+
+	desired_lum = 270 + sd->brightness * 4;
+	/* Hack hack, with the 7202 the first exposure step is
+	   pretty large, so if we're about to make the first
+	   exposure increase make the deadzone large to avoid
+	   oscilating */
+	if (desired_lum > avg_lum && sd->gain == GAIN_DEF &&
+			sd->exposure > EXPOSURE_DEF &&
+			sd->exposure < 42)
+		deadzone = 90;
+	else
+		deadzone = 30;
+
+	if (sd->autogain_ignore_frames > 0)
+		sd->autogain_ignore_frames--;
+	else if (gspca_auto_gain_n_exposure(gspca_dev, avg_lum, desired_lum,
+			deadzone, GAIN_KNEE, EXPOSURE_KNEE))
+		sd->autogain_ignore_frames = PAC_AUTOGAIN_IGNORE_FRAMES;
+}
+
+/* JPEG header, part 1 */
+static const unsigned char pac_jpeg_header1[] = {
+  0xff, 0xd8,		/* SOI: Start of Image */
+
+  0xff, 0xc0,		/* SOF0: Start of Frame (Baseline DCT) */
+  0x00, 0x11,		/* length = 17 bytes (including this length field) */
+  0x08			/* Precision: 8 */
+  /* 2 bytes is placed here: number of image lines */
+  /* 2 bytes is placed here: samples per line */
+};
+
+/* JPEG header, continued */
+static const unsigned char pac_jpeg_header2[] = {
+  0x03,			/* Number of image components: 3 */
+  0x01, 0x21, 0x00,	/* ID=1, Subsampling 1x1, Quantization table: 0 */
+  0x02, 0x11, 0x01,	/* ID=2, Subsampling 2x1, Quantization table: 1 */
+  0x03, 0x11, 0x01,	/* ID=3, Subsampling 2x1, Quantization table: 1 */
+
+  0xff, 0xda,		/* SOS: Start Of Scan */
+  0x00, 0x0c,		/* length = 12 bytes (including this length field) */
+  0x03,			/* number of components: 3 */
+  0x01, 0x00,		/* selector 1, table 0x00 */
+  0x02, 0x11,		/* selector 2, table 0x11 */
+  0x03, 0x11,		/* selector 3, table 0x11 */
+  0x00, 0x3f,		/* Spectral selection: 0 .. 63 */
+  0x00			/* Successive approximation: 0 */
+};
+
+static void pac_start_frame(struct gspca_dev *gspca_dev,
+		struct gspca_frame *frame,
+		__u16 lines, __u16 samples_per_line)
+{
+	unsigned char tmpbuf[4];
+
+	gspca_frame_add(gspca_dev, FIRST_PACKET, frame,
+		pac_jpeg_header1, sizeof(pac_jpeg_header1));
+
+	tmpbuf[0] = lines >> 8;
+	tmpbuf[1] = lines & 0xff;
+	tmpbuf[2] = samples_per_line >> 8;
+	tmpbuf[3] = samples_per_line & 0xff;
+
+	gspca_frame_add(gspca_dev, INTER_PACKET, frame,
+		tmpbuf, sizeof(tmpbuf));
+	gspca_frame_add(gspca_dev, INTER_PACKET, frame,
+		pac_jpeg_header2, sizeof(pac_jpeg_header2));
+}
+
+/* this function is run at interrupt level */
+static void pac7302_sd_pkt_scan(struct gspca_dev *gspca_dev,
+			struct gspca_frame *frame,	/* target */
+			__u8 *data,			/* isoc packet */
+			int len)			/* iso packet length */
+{
+	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
+	unsigned char *sof;
+
+	sof = pac_find_sof(&sd->sof_read, data, len);
+	if (sof) {
+		int n, lum_offset, footer_length;
+
+		/* 6 bytes after the FF D9 EOF marker a number of lumination
+		   bytes are send corresponding to different parts of the
+		   image, the 14th and 15th byte after the EOF seem to
+		   correspond to the center of the image */
+		lum_offset = 61 + sizeof pac_sof_marker;
+		footer_length = 74;
+
+		/* Finish decoding current frame */
+		n = (sof - data) - (footer_length + sizeof pac_sof_marker);
+		if (n < 0) {
+			frame->data_end += n;
+			n = 0;
+		}
+		frame = gspca_frame_add(gspca_dev, INTER_PACKET, frame,
+					data, n);
+		if (gspca_dev->last_packet_type != DISCARD_PACKET &&
+				frame->data_end[-2] == 0xff &&
+				frame->data_end[-1] == 0xd9)
+			frame = gspca_frame_add(gspca_dev, LAST_PACKET, frame,
+						NULL, 0);
+
+		n = sof - data;
+		len -= n;
+		data = sof;
+
+		/* Get average lumination */
+		if (gspca_dev->last_packet_type == LAST_PACKET &&
+				n >= lum_offset)
+			atomic_set(&sd->avg_lum, data[-lum_offset] +
+						data[-lum_offset + 1]);
+		else
+			atomic_set(&sd->avg_lum, -1);
+
+		/* Start the new frame with the jpeg header */
+		/* The PAC7302 has the image rotated 90 degrees */
+		pac_start_frame(gspca_dev, frame,
+			gspca_dev->width, gspca_dev->height);
+	}
+	gspca_frame_add(gspca_dev, INTER_PACKET, frame, data, len);
+}
+
+static int pac7302_sd_setbrightness(struct gspca_dev *gspca_dev, __s32 val)
+{
+	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
+
+	sd->brightness = val;
+	if (gspca_dev->streaming)
+		pac7302_setbrightcont(gspca_dev);
+	return 0;
+}
+
+static int pac7302_sd_getbrightness(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
+
+	*val = sd->brightness;
+	return 0;
+}
+
+static int pac7302_sd_setcontrast(struct gspca_dev *gspca_dev, __s32 val)
+{
+	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
+
+	sd->contrast = val;
+	if (gspca_dev->streaming) {
+		pac7302_setbrightcont(gspca_dev);
+	}
+	return 0;
+}
+
+static int pac7302_sd_getcontrast(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
+
+	*val = sd->contrast;
+	return 0;
+}
+
+static int pac7302_sd_setcolors(struct gspca_dev *gspca_dev, __s32 val)
+{
+	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
+
+	sd->colors = val;
+	if (gspca_dev->streaming)
+		pac7302_setcolors(gspca_dev);
+	return 0;
+}
+
+static int pac7302_sd_getcolors(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
+
+	*val = sd->colors;
+	return 0;
+}
+
+static int pac7302_sd_setgain(struct gspca_dev *gspca_dev, __s32 val)
+{
+	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
+
+	sd->gain = val;
+	if (gspca_dev->streaming)
+		pac7302_setgain(gspca_dev);
+	return 0;
+}
+
+static int pac7302_sd_getgain(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
+
+	*val = sd->gain;
+	return 0;
+}
+
+static int pac7302_sd_setexposure(struct gspca_dev *gspca_dev, __s32 val)
+{
+	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
+
+	sd->exposure = val;
+	if (gspca_dev->streaming)
+		pac7302_setexposure(gspca_dev);
+	return 0;
+}
+
+static int pac7302_sd_getexposure(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
+
+	*val = sd->exposure;
+	return 0;
+}
+
+static int pac7302_sd_setautogain(struct gspca_dev *gspca_dev, __s32 val)
+{
+	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
+
+	sd->autogain = val;
+	/* when switching to autogain set defaults to make sure
+	   we are on a valid point of the autogain gain /
+	   exposure knee graph, and give this change time to
+	   take effect before doing autogain. */
+	if (sd->autogain) {
+		sd->exposure = EXPOSURE_DEF;
+		sd->gain = GAIN_DEF;
+		if (gspca_dev->streaming) {
+			sd->autogain_ignore_frames =
+				PAC_AUTOGAIN_IGNORE_FRAMES;
+			pac7302_setexposure(gspca_dev);
+			pac7302_setgain(gspca_dev);
+		}
+	}
+
+	return 0;
+}
+
+static int pac7302_sd_getautogain(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
+
+	*val = sd->autogain;
+	return 0;
+}
+
+static int pac7302_sd_sethflip(struct gspca_dev *gspca_dev, __s32 val)
+{
+	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
+
+	sd->hflip = val;
+	if (gspca_dev->streaming)
+		pac7302_sethvflip(gspca_dev);
+	return 0;
+}
+
+static int pac7302_sd_gethflip(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
+
+	*val = sd->hflip;
+	return 0;
+}
+
+static int pac7302_sd_setvflip(struct gspca_dev *gspca_dev, __s32 val)
+{
+	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
+
+	sd->vflip = val;
+	if (gspca_dev->streaming)
+		pac7302_sethvflip(gspca_dev);
+	return 0;
+}
+
+static int pac7302_sd_getvflip(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
+
+	*val = sd->vflip;
+	return 0;
+}
+
+/* sub-driver description for pac7302 */
+static struct sd_desc pac7302_sd_desc = {
+	.name = MODULE_NAME,
+	.ctrls = pac7302_sd_ctrls,
+	.nctrls = ARRAY_SIZE(pac7302_sd_ctrls),
+	.config = pac7302_sd_config,
+	.init = pac7302_sd_init,
+	.start = pac7302_sd_start,
+	.stopN = pac7302_sd_stopN,
+	.stop0 = pac7302_sd_stop0,
+	.pkt_scan = pac7302_sd_pkt_scan,
+	.dq_callback = pac7302_do_autogain,
+};
+
+/* -- module initialisation -- */
+static __devinitdata struct usb_device_id device_table[] = {
+	{USB_DEVICE(0x06f8, 0x3009), .driver_info = SENSOR_PAC7302},
+	{USB_DEVICE(0x093a, 0x2620), .driver_info = SENSOR_PAC7302},
+	{USB_DEVICE(0x093a, 0x2621), .driver_info = SENSOR_PAC7302},
+	{USB_DEVICE(0x093a, 0x2622), .driver_info = SENSOR_PAC7302},
+	{USB_DEVICE(0x093a, 0x2624), .driver_info = SENSOR_PAC7302},
+	{USB_DEVICE(0x093a, 0x2626), .driver_info = SENSOR_PAC7302},
+	{USB_DEVICE(0x093a, 0x2628), .driver_info = SENSOR_PAC7302},
+	{USB_DEVICE(0x093a, 0x2629), .driver_info = SENSOR_PAC7302},
+	{USB_DEVICE(0x093a, 0x262a), .driver_info = SENSOR_PAC7302},
+	{USB_DEVICE(0x093a, 0x262c), .driver_info = SENSOR_PAC7302},
+	{}
+};
+MODULE_DEVICE_TABLE(usb, device_table);
+
+/* -- device connect -- */
+static int sd_probe(struct usb_interface *intf,
+			const struct usb_device_id *id)
+{
+	return gspca_dev_probe(intf, id, &pac7302_sd_desc,
+			sizeof(struct pac7302_sd), THIS_MODULE);
+}
+
+static struct usb_driver sd_driver = {
+	.name = MODULE_NAME,
+	.id_table = device_table,
+	.probe = sd_probe,
+	.disconnect = gspca_disconnect,
+#ifdef CONFIG_PM
+	.suspend = gspca_suspend,
+	.resume = gspca_resume,
+#endif
+};
+
+/* -- module insert / remove -- */
+static int __init sd_mod_init(void)
+{
+	int ret;
+	ret = usb_register(&sd_driver);
+	if (ret < 0)
+		return ret;
+	PDEBUG(D_PROBE, "registered");
+	return 0;
+}
+static void __exit sd_mod_exit(void)
+{
+	usb_deregister(&sd_driver);
+	PDEBUG(D_PROBE, "deregistered");
+}
+
+module_init(sd_mod_init);
+module_exit(sd_mod_exit);
diff -uprN t/drivers/media/video/gspca/pac7311.c u/drivers/media/video/gspca/pac7311.c
--- t/drivers/media/video/gspca/pac7311.c	2009-11-01 06:54:04.000000000 +0100
+++ u/drivers/media/video/gspca/pac7311.c	2009-11-01 07:00:21.000000000 +0100
@@ -57,28 +57,6 @@ MODULE_AUTHOR("Thomas Kaiser thomas@kais
 MODULE_DESCRIPTION("Pixart PAC7311");
 MODULE_LICENSE("GPL");

-/* specific webcam descriptor for pac7302 */
-struct pac7302_sd {
-	struct gspca_dev gspca_dev;		/* !! must be the first item */
-
-	unsigned char brightness;
-	unsigned char contrast;
-	unsigned char colors;
-	unsigned char gain;
-	unsigned char exposure;
-	unsigned char autogain;
-	__u8 hflip;
-	__u8 vflip;
-
-#define SENSOR_PAC7302 0
-#define SENSOR_PAC7311 1
-
-	u8 sof_read;
-	u8 autogain_ignore_frames;
-
-	atomic_t avg_lum;
-};
-
 /* specific webcam descriptor for pac7311 */
 struct pac7311_sd {
 	struct gspca_dev gspca_dev;		/* !! must be the first item */
@@ -90,7 +68,6 @@ struct pac7311_sd {
 	__u8 hflip;
 	__u8 vflip;

-#define SENSOR_PAC7302 0
 #define SENSOR_PAC7311 1

 	u8 sof_read;
@@ -100,161 +77,19 @@ struct pac7311_sd {
 };

 /* V4L2 controls supported by the driver */
-static int pac7302_sd_setbrightness(struct gspca_dev *gspca_dev, __s32 val);
-static int pac7302_sd_getbrightness(struct gspca_dev *gspca_dev, __s32 *val);
-static int pac7302_sd_setcontrast(struct gspca_dev *gspca_dev, __s32 val);
 static int pac7311_sd_setcontrast(struct gspca_dev *gspca_dev, __s32 val);
-static int pac7302_sd_getcontrast(struct gspca_dev *gspca_dev, __s32 *val);
 static int pac7311_sd_getcontrast(struct gspca_dev *gspca_dev, __s32 *val);
-static int pac7302_sd_setcolors(struct gspca_dev *gspca_dev, __s32 val);
-static int pac7302_sd_getcolors(struct gspca_dev *gspca_dev, __s32 *val);
-static int pac7302_sd_setautogain(struct gspca_dev *gspca_dev, __s32 val);
 static int pac7311_sd_setautogain(struct gspca_dev *gspca_dev, __s32 val);
-static int pac7302_sd_getautogain(struct gspca_dev *gspca_dev, __s32 *val);
 static int pac7311_sd_getautogain(struct gspca_dev *gspca_dev, __s32 *val);
-static int pac7302_sd_sethflip(struct gspca_dev *gspca_dev, __s32 val);
 static int pac7311_sd_sethflip(struct gspca_dev *gspca_dev, __s32 val);
-static int pac7302_sd_gethflip(struct gspca_dev *gspca_dev, __s32 *val);
 static int pac7311_sd_gethflip(struct gspca_dev *gspca_dev, __s32 *val);
-static int pac7302_sd_setvflip(struct gspca_dev *gspca_dev, __s32 val);
 static int pac7311_sd_setvflip(struct gspca_dev *gspca_dev, __s32 val);
-static int pac7302_sd_getvflip(struct gspca_dev *gspca_dev, __s32 *val);
 static int pac7311_sd_getvflip(struct gspca_dev *gspca_dev, __s32 *val);
-static int pac7302_sd_setgain(struct gspca_dev *gspca_dev, __s32 val);
 static int pac7311_sd_setgain(struct gspca_dev *gspca_dev, __s32 val);
-static int pac7302_sd_getgain(struct gspca_dev *gspca_dev, __s32 *val);
 static int pac7311_sd_getgain(struct gspca_dev *gspca_dev, __s32 *val);
-static int pac7302_sd_setexposure(struct gspca_dev *gspca_dev, __s32 val);
 static int pac7311_sd_setexposure(struct gspca_dev *gspca_dev, __s32 val);
-static int pac7302_sd_getexposure(struct gspca_dev *gspca_dev, __s32 *val);
 static int pac7311_sd_getexposure(struct gspca_dev *gspca_dev, __s32 *val);

-static struct ctrl pac7302_sd_ctrls[] = {
-/* This control is pac7302 only */
-	{
-	    {
-		.id      = V4L2_CID_BRIGHTNESS,
-		.type    = V4L2_CTRL_TYPE_INTEGER,
-		.name    = "Brightness",
-		.minimum = 0,
-#define BRIGHTNESS_MAX 0x20
-		.maximum = BRIGHTNESS_MAX,
-		.step    = 1,
-#define BRIGHTNESS_DEF 0x10
-		.default_value = BRIGHTNESS_DEF,
-	    },
-	    .set = pac7302_sd_setbrightness,
-	    .get = pac7302_sd_getbrightness,
-	},
-/* This control is for both the 7302 and the 7311 */
-	{
-	    {
-		.id      = V4L2_CID_CONTRAST,
-		.type    = V4L2_CTRL_TYPE_INTEGER,
-		.name    = "Contrast",
-		.minimum = 0,
-#define CONTRAST_MAX 255
-		.maximum = CONTRAST_MAX,
-		.step    = 1,
-#define CONTRAST_DEF 127
-		.default_value = CONTRAST_DEF,
-	    },
-	    .set = pac7302_sd_setcontrast,
-	    .get = pac7302_sd_getcontrast,
-	},
-/* This control is pac7302 only */
-	{
-	    {
-		.id      = V4L2_CID_SATURATION,
-		.type    = V4L2_CTRL_TYPE_INTEGER,
-		.name    = "Saturation",
-		.minimum = 0,
-#define COLOR_MAX 255
-		.maximum = COLOR_MAX,
-		.step    = 1,
-#define COLOR_DEF 127
-		.default_value = COLOR_DEF,
-	    },
-	    .set = pac7302_sd_setcolors,
-	    .get = pac7302_sd_getcolors,
-	},
-/* All controls below are for both the 7302 and the 7311 */
-	{
-	    {
-		.id      = V4L2_CID_GAIN,
-		.type    = V4L2_CTRL_TYPE_INTEGER,
-		.name    = "Gain",
-		.minimum = 0,
-#define GAIN_MAX 255
-		.maximum = GAIN_MAX,
-		.step    = 1,
-#define GAIN_DEF 127
-#define GAIN_KNEE 255 /* Gain seems to cause little noise on the pac73xx */
-		.default_value = GAIN_DEF,
-	    },
-	    .set = pac7302_sd_setgain,
-	    .get = pac7302_sd_getgain,
-	},
-	{
-	    {
-		.id      = V4L2_CID_EXPOSURE,
-		.type    = V4L2_CTRL_TYPE_INTEGER,
-		.name    = "Exposure",
-		.minimum = 0,
-#define EXPOSURE_MAX 255
-		.maximum = EXPOSURE_MAX,
-		.step    = 1,
-#define EXPOSURE_DEF  16 /*  32 ms / 30 fps */
-#define EXPOSURE_KNEE 50 /* 100 ms / 10 fps */
-		.default_value = EXPOSURE_DEF,
-	    },
-	    .set = pac7302_sd_setexposure,
-	    .get = pac7302_sd_getexposure,
-	},
-	{
-	    {
-		.id      = V4L2_CID_AUTOGAIN,
-		.type    = V4L2_CTRL_TYPE_BOOLEAN,
-		.name    = "Auto Gain",
-		.minimum = 0,
-		.maximum = 1,
-		.step    = 1,
-#define AUTOGAIN_DEF 1
-		.default_value = AUTOGAIN_DEF,
-	    },
-	    .set = pac7302_sd_setautogain,
-	    .get = pac7302_sd_getautogain,
-	},
-	{
-	    {
-		.id      = V4L2_CID_HFLIP,
-		.type    = V4L2_CTRL_TYPE_BOOLEAN,
-		.name    = "Mirror",
-		.minimum = 0,
-		.maximum = 1,
-		.step    = 1,
-#define HFLIP_DEF 0
-		.default_value = HFLIP_DEF,
-	    },
-	    .set = pac7302_sd_sethflip,
-	    .get = pac7302_sd_gethflip,
-	},
-	{
-	    {
-		.id      = V4L2_CID_VFLIP,
-		.type    = V4L2_CTRL_TYPE_BOOLEAN,
-		.name    = "Vflip",
-		.minimum = 0,
-		.maximum = 1,
-		.step    = 1,
-#define VFLIP_DEF 0
-		.default_value = VFLIP_DEF,
-	    },
-	    .set = pac7302_sd_setvflip,
-	    .get = pac7302_sd_getvflip,
-	},
-};
-
 static struct ctrl pac7311_sd_ctrls[] = {
 /* This control is for both the 7302 and the 7311 */
 	{
@@ -349,14 +184,6 @@ static struct ctrl pac7311_sd_ctrls[] =
 	},
 };

-static const struct v4l2_pix_format pac7302_vga_mode[] = {
-	{640, 480, V4L2_PIX_FMT_PJPG, V4L2_FIELD_NONE,
-		.bytesperline = 640,
-		.sizeimage = 640 * 480 * 3 / 8 + 590,
-		.colorspace = V4L2_COLORSPACE_JPEG,
-		.priv = 0},
-};
-
 static const struct v4l2_pix_format pac7311_vga_mode[] = {
 	{160, 120, V4L2_PIX_FMT_PJPG, V4L2_FIELD_NONE,
 		.bytesperline = 160,
@@ -379,103 +206,6 @@ static const struct v4l2_pix_format pac7
 #define LOAD_PAGE4		254
 #define END_OF_SEQUENCE		0

-/* pac 7302 */
-static const __u8 init_7302[] = {
-/*	index,value */
-	0xff, 0x01,		/* page 1 */
-	0x78, 0x00,		/* deactivate */
-	0xff, 0x01,
-	0x78, 0x40,		/* led off */
-};
-static const __u8 start_7302[] = {
-/*	index, len, [value]* */
-	0xff, 1,	0x00,		/* page 0 */
-	0x00, 12,	0x01, 0x40, 0x40, 0x40, 0x01, 0xe0, 0x02, 0x80,
-			0x00, 0x00, 0x00, 0x00,
-	0x0d, 24,	0x03, 0x01, 0x00, 0xb5, 0x07, 0xcb, 0x00, 0x00,
-			0x07, 0xc8, 0x00, 0xea, 0x07, 0xcf, 0x07, 0xf7,
-			0x07, 0x7e, 0x01, 0x0b, 0x00, 0x00, 0x00, 0x11,
-	0x26, 2,	0xaa, 0xaa,
-	0x2e, 1,	0x31,
-	0x38, 1,	0x01,
-	0x3a, 3,	0x14, 0xff, 0x5a,
-	0x43, 11,	0x00, 0x0a, 0x18, 0x11, 0x01, 0x2c, 0x88, 0x11,
-			0x00, 0x54, 0x11,
-	0x55, 1,	0x00,
-	0x62, 4, 	0x10, 0x1e, 0x1e, 0x18,
-	0x6b, 1,	0x00,
-	0x6e, 3,	0x08, 0x06, 0x00,
-	0x72, 3,	0x00, 0xff, 0x00,
-	0x7d, 23,	0x01, 0x01, 0x58, 0x46, 0x50, 0x3c, 0x50, 0x3c,
-			0x54, 0x46, 0x54, 0x56, 0x52, 0x50, 0x52, 0x50,
-			0x56, 0x64, 0xa4, 0x00, 0xda, 0x00, 0x00,
-	0xa2, 10,	0x22, 0x2c, 0x3c, 0x54, 0x69, 0x7c, 0x9c, 0xb9,
-			0xd2, 0xeb,
-	0xaf, 1,	0x02,
-	0xb5, 2,	0x08, 0x08,
-	0xb8, 2,	0x08, 0x88,
-	0xc4, 4,	0xae, 0x01, 0x04, 0x01,
-	0xcc, 1,	0x00,
-	0xd1, 11,	0x01, 0x30, 0x49, 0x5e, 0x6f, 0x7f, 0x8e, 0xa9,
-			0xc1, 0xd7, 0xec,
-	0xdc, 1,	0x01,
-	0xff, 1,	0x01,		/* page 1 */
-	0x12, 3,	0x02, 0x00, 0x01,
-	0x3e, 2,	0x00, 0x00,
-	0x76, 5,	0x01, 0x20, 0x40, 0x00, 0xf2,
-	0x7c, 1,	0x00,
-	0x7f, 10,	0x4b, 0x0f, 0x01, 0x2c, 0x02, 0x58, 0x03, 0x20,
-			0x02, 0x00,
-	0x96, 5,	0x01, 0x10, 0x04, 0x01, 0x04,
-	0xc8, 14,	0x00, 0x00, 0x00, 0x00, 0x00, 0x07, 0x00, 0x00,
-			0x07, 0x00, 0x01, 0x07, 0x04, 0x01,
-	0xd8, 1,	0x01,
-	0xdb, 2,	0x00, 0x01,
-	0xde, 7,	0x00, 0x01, 0x04, 0x04, 0x00, 0x00, 0x00,
-	0xe6, 4,	0x00, 0x00, 0x00, 0x01,
-	0xeb, 1,	0x00,
-	0xff, 1,	0x02,		/* page 2 */
-	0x22, 1,	0x00,
-	0xff, 1,	0x03,		/* page 3 */
-	0, LOAD_PAGE3,			/* load the page 3 */
-	0x11, 1,	0x01,
-	0xff, 1,	0x02,		/* page 2 */
-	0x13, 1,	0x00,
-	0x22, 4,	0x1f, 0xa4, 0xf0, 0x96,
-	0x27, 2,	0x14, 0x0c,
-	0x2a, 5,	0xc8, 0x00, 0x18, 0x12, 0x22,
-	0x64, 8,	0x00, 0x00, 0xf0, 0x01, 0x14, 0x44, 0x44, 0x44,
-	0x6e, 1,	0x08,
-	0xff, 1,	0x01,		/* page 1 */
-	0x78, 1,	0x00,
-	0, END_OF_SEQUENCE		/* end of sequence */
-};
-
-#define SKIP		0xaa
-/* page 3 - the value SKIP says skip the index - see reg_w_page() */
-static const __u8 page3_7302[] = {
-	0x90, 0x40, 0x03, 0x50, 0xc2, 0x01, 0x14, 0x16,
-	0x14, 0x12, 0x00, 0x00, 0x00, 0x02, 0x33, 0x00,
-	0x0f, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x47, 0x01, 0xb3, 0x01, 0x00,
-	0x00, 0x08, 0x00, 0x00, 0x0d, 0x00, 0x00, 0x21,
-	0x00, 0x00, 0x00, 0x54, 0xf4, 0x02, 0x52, 0x54,
-	0xa4, 0xb8, 0xe0, 0x2a, 0xf6, 0x00, 0x00, 0x00,
-	0x00, 0x1e, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0xfc, 0x00, 0xf2, 0x1f, 0x04, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0xc0, 0xc0, 0x10, 0x00, 0x00,
-	0x00, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x40, 0xff, 0x03, 0x19, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0xc8, 0xc8, 0xc8,
-	0xc8, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x50,
-	0x08, 0x10, 0x24, 0x40, 0x00, 0x00, 0x00, 0x00,
-	0x01, 0x00, 0x02, 0x47, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x02, 0xfa, 0x00, 0x64, 0x5a, 0x28, 0x00,
-	0x00
-};
-
 /* pac 7311 */
 static const __u8 init_7311[] = {
 	0x78, 0x40,	/* Bit_0=start stream, Bit_6=LED */
@@ -519,6 +249,7 @@ static const __u8 start_7311[] = {
 	0, END_OF_SEQUENCE		/* end of sequence */
 };

+#define SKIP		0xaa
 /* page 4 - the value SKIP says skip the index - see reg_w_page() */
 static const __u8 page4_7311[] = {
 	SKIP, SKIP, 0x04, 0x54, 0x07, 0x2b, 0x09, 0x0f,
@@ -642,30 +373,6 @@ static void reg_w_var(struct gspca_dev *
 	/* not reached */
 }

-/* this function is called at probe time for pac7302 */
-static int pac7302_sd_config(struct gspca_dev *gspca_dev,
-			const struct usb_device_id *id)
-{
-	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
-	struct cam *cam;
-
-	cam = &gspca_dev->cam;
-
-	PDEBUG(D_CONF, "Find Sensor PAC7302");
-	cam->cam_mode = pac7302_vga_mode;	/* only 640x480 */
-	cam->nmodes = ARRAY_SIZE(pac7302_vga_mode);
-
-	sd->brightness = BRIGHTNESS_DEF;
-	sd->contrast = CONTRAST_DEF;
-	sd->colors = COLOR_DEF;
-	sd->gain = GAIN_DEF;
-	sd->exposure = EXPOSURE_DEF;
-	sd->autogain = AUTOGAIN_DEF;
-	sd->hflip = HFLIP_DEF;
-	sd->vflip = VFLIP_DEF;
-	return 0;
-}
-
 /* this function is called at probe time for pac7311 */
 static int pac7311_sd_config(struct gspca_dev *gspca_dev,
 			const struct usb_device_id *id)
@@ -688,33 +395,6 @@ static int pac7311_sd_config(struct gspc
 	return 0;
 }

-/* This function is used by pac7302 only */
-static void pac7302_setbrightcont(struct gspca_dev *gspca_dev)
-{
-	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
-	int i, v;
-	static const __u8 max[10] =
-		{0x29, 0x33, 0x42, 0x5a, 0x6e, 0x80, 0x9f, 0xbb,
-		 0xd4, 0xec};
-	static const __u8 delta[10] =
-		{0x35, 0x33, 0x33, 0x2f, 0x2a, 0x25, 0x1e, 0x17,
-		 0x11, 0x0b};
-
-	reg_w(gspca_dev, 0xff, 0x00);	/* page 0 */
-	for (i = 0; i < 10; i++) {
-		v = max[i];
-		v += (sd->brightness - BRIGHTNESS_MAX)
-			* 150 / BRIGHTNESS_MAX;		/* 200 ? */
-		v -= delta[i] * sd->contrast / CONTRAST_MAX;
-		if (v < 0)
-			v = 0;
-		else if (v > 0xff)
-			v = 0xff;
-		reg_w(gspca_dev, 0xa2 + i, v);
-	}
-	reg_w(gspca_dev, 0xdc, 0x01);
-}
-
 /* This function is used by pac7311 only */
 static void pac7311_setcontrast(struct gspca_dev *gspca_dev)
 {
@@ -726,39 +406,6 @@ static void pac7311_setcontrast(struct g
 	reg_w(gspca_dev, 0x11, 0x01);
 }

-/* This function is used by pac7302 only */
-static void pac7302_setcolors(struct gspca_dev *gspca_dev)
-{
-	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
-	int i, v;
-	static const int a[9] =
-		{217, -212, 0, -101, 170, -67, -38, -315, 355};
-	static const int b[9] =
-		{19, 106, 0, 19, 106, 1, 19, 106, 1};
-
-	reg_w(gspca_dev, 0xff, 0x03);	/* page 3 */
-	reg_w(gspca_dev, 0x11, 0x01);
-	reg_w(gspca_dev, 0xff, 0x00);	/* page 0 */
-	for (i = 0; i < 9; i++) {
-		v = a[i] * sd->colors / COLOR_MAX + b[i];
-		reg_w(gspca_dev, 0x0f + 2 * i, (v >> 8) & 0x07);
-		reg_w(gspca_dev, 0x0f + 2 * i + 1, v);
-	}
-	reg_w(gspca_dev, 0xdc, 0x01);
-	PDEBUG(D_CONF|D_STREAM, "color: %i", sd->colors);
-}
-
-static void pac7302_setgain(struct gspca_dev *gspca_dev)
-{
-	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
-
-	reg_w(gspca_dev, 0xff, 0x03);		/* page 3 */
-	reg_w(gspca_dev, 0x10, sd->gain >> 3);
-
-	/* load registers to sensor (Bit 0, auto clear) */
-	reg_w(gspca_dev, 0x11, 0x01);
-}
-
 static void pac7311_setgain(struct gspca_dev *gspca_dev)
 {
 	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;
@@ -776,31 +423,6 @@ static void pac7311_setgain(struct gspca
 	reg_w(gspca_dev, 0x11, 0x01);
 }

-static void pac7302_setexposure(struct gspca_dev *gspca_dev)
-{
-	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
-	__u8 reg;
-
-	/* register 2 of frame 3/4 contains the clock divider configuring the
-	   no fps according to the formula: 60 / reg. sd->exposure is the
-	   desired exposure time in ms. */
-	reg = 120 * sd->exposure / 1000;
-	if (reg < 2)
-		reg = 2;
-	else if (reg > 63)
-		reg = 63;
-
-	/* On the pac7302 reg2 MUST be a multiple of 3, so round it to
-	   the nearest multiple of 3, except when between 6 and 12? */
-	if (reg < 6 || reg > 12)
-		reg = ((reg + 1) / 3) * 3;
-	reg_w(gspca_dev, 0xff, 0x03);		/* page 3 */
-	reg_w(gspca_dev, 0x02, reg);
-
-	/* load registers to sensor (Bit 0, auto clear) */
-	reg_w(gspca_dev, 0x11, 0x01);
-}
-
 static void pac7311_setexposure(struct gspca_dev *gspca_dev)
 {
 	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;
@@ -830,18 +452,6 @@ static void pac7311_setexposure(struct g
 	reg_w(gspca_dev, 0x11, 0x01);
 }

-static void pac7302_sethvflip(struct gspca_dev *gspca_dev)
-{
-	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
-	__u8 data;
-
-	reg_w(gspca_dev, 0xff, 0x03);		/* page 3 */
-	data = (sd->hflip ? 0x08 : 0x00) | (sd->vflip ? 0x04 : 0x00);
-	reg_w(gspca_dev, 0x21, data);
-	/* load registers to sensor (Bit 0, auto clear) */
-	reg_w(gspca_dev, 0x11, 0x01);
-}
-
 static void pac7311_sethvflip(struct gspca_dev *gspca_dev)
 {
 	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;
@@ -854,14 +464,6 @@ static void pac7311_sethvflip(struct gsp
 	reg_w(gspca_dev, 0x11, 0x01);
 }

-/* this function is called at probe and resume time for pac7302 */
-static int pac7302_sd_init(struct gspca_dev *gspca_dev)
-{
-	reg_w_seq(gspca_dev, init_7302, sizeof init_7302);
-
-	return 0;
-}
-
 /* this function is called at probe and resume time for pac7311 */
 static int pac7311_sd_init(struct gspca_dev *gspca_dev)
 {
@@ -870,34 +472,6 @@ static int pac7311_sd_init(struct gspca_
 	return 0;
 }

-static int pac7302_sd_start(struct gspca_dev *gspca_dev)
-{
-	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
-
-	sd->sof_read = 0;
-
-	reg_w_var(gspca_dev, start_7302,
-		page3_7302, sizeof(page3_7302),
-		NULL, 0);
-	pac7302_setbrightcont(gspca_dev);
-	pac7302_setcolors(gspca_dev);
-	pac7302_setgain(gspca_dev);
-	pac7302_setexposure(gspca_dev);
-	pac7302_sethvflip(gspca_dev);
-
-	/* only resolution 640x480 is supported for pac7302 */
-
-	sd->sof_read = 0;
-	sd->autogain_ignore_frames = 0;
-	atomic_set(&sd->avg_lum, -1);
-
-	/* start stream */
-	reg_w(gspca_dev, 0xff, 0x01);
-	reg_w(gspca_dev, 0x78, 0x01);
-
-	return 0;
-}
-
 static int pac7311_sd_start(struct gspca_dev *gspca_dev)
 {
 	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;
@@ -942,13 +516,6 @@ static int pac7311_sd_start(struct gspca
 	return 0;
 }

-static void pac7302_sd_stopN(struct gspca_dev *gspca_dev)
-{
-	reg_w(gspca_dev, 0xff, 0x01);
-	reg_w(gspca_dev, 0x78, 0x00);
-	reg_w(gspca_dev, 0x78, 0x00);
-}
-
 static void pac7311_sd_stopN(struct gspca_dev *gspca_dev)
 {
 	reg_w(gspca_dev, 0xff, 0x04);
@@ -963,15 +530,6 @@ static void pac7311_sd_stopN(struct gspc
 	reg_w(gspca_dev, 0x78, 0x44); /* Bit_0=start stream, Bit_6=LED */
 }

-/* called on streamoff with alt 0 and on disconnect for pac7302 */
-static void pac7302_sd_stop0(struct gspca_dev *gspca_dev)
-{
-	if (!gspca_dev->present)
-		return;
-	reg_w(gspca_dev, 0xff, 0x01);
-	reg_w(gspca_dev, 0x78, 0x40);
-}
-
 /* called on streamoff with alt 0 and on disconnect for 7311 */
 static void pac7311_sd_stop0(struct gspca_dev *gspca_dev)
 {
@@ -980,34 +538,6 @@ static void pac7311_sd_stop0(struct gspc
 /* Include pac common sof detection functions */
 #include "pac_common.h"

-static void pac7302_do_autogain(struct gspca_dev *gspca_dev)
-{
-	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
-	int avg_lum = atomic_read(&sd->avg_lum);
-	int desired_lum, deadzone;
-
-	if (avg_lum == -1)
-		return;
-
-	desired_lum = 270 + sd->brightness * 4;
-	/* Hack hack, with the 7202 the first exposure step is
-	   pretty large, so if we're about to make the first
-	   exposure increase make the deadzone large to avoid
-	   oscilating */
-	if (desired_lum > avg_lum && sd->gain == GAIN_DEF &&
-			sd->exposure > EXPOSURE_DEF &&
-			sd->exposure < 42)
-		deadzone = 90;
-	else
-		deadzone = 30;
-
-	if (sd->autogain_ignore_frames > 0)
-		sd->autogain_ignore_frames--;
-	else if (gspca_auto_gain_n_exposure(gspca_dev, avg_lum, desired_lum,
-			deadzone, GAIN_KNEE, EXPOSURE_KNEE))
-		sd->autogain_ignore_frames = PAC_AUTOGAIN_IGNORE_FRAMES;
-}
-
 static void pac7311_do_autogain(struct gspca_dev *gspca_dev)
 {
 	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;
@@ -1076,60 +606,6 @@ static void pac_start_frame(struct gspca
 }

 /* this function is run at interrupt level */
-static void pac7302_sd_pkt_scan(struct gspca_dev *gspca_dev,
-			struct gspca_frame *frame,	/* target */
-			__u8 *data,			/* isoc packet */
-			int len)			/* iso packet length */
-{
-	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
-	unsigned char *sof;
-
-	sof = pac_find_sof(&sd->sof_read, data, len);
-	if (sof) {
-		int n, lum_offset, footer_length;
-
-		/* 6 bytes after the FF D9 EOF marker a number of lumination
-		   bytes are send corresponding to different parts of the
-		   image, the 14th and 15th byte after the EOF seem to
-		   correspond to the center of the image */
-		lum_offset = 61 + sizeof pac_sof_marker;
-		footer_length = 74;
-
-		/* Finish decoding current frame */
-		n = (sof - data) - (footer_length + sizeof pac_sof_marker);
-		if (n < 0) {
-			frame->data_end += n;
-			n = 0;
-		}
-		frame = gspca_frame_add(gspca_dev, INTER_PACKET, frame,
-					data, n);
-		if (gspca_dev->last_packet_type != DISCARD_PACKET &&
-				frame->data_end[-2] == 0xff &&
-				frame->data_end[-1] == 0xd9)
-			frame = gspca_frame_add(gspca_dev, LAST_PACKET, frame,
-						NULL, 0);
-
-		n = sof - data;
-		len -= n;
-		data = sof;
-
-		/* Get average lumination */
-		if (gspca_dev->last_packet_type == LAST_PACKET &&
-				n >= lum_offset)
-			atomic_set(&sd->avg_lum, data[-lum_offset] +
-						data[-lum_offset + 1]);
-		else
-			atomic_set(&sd->avg_lum, -1);
-
-		/* Start the new frame with the jpeg header */
-		/* The PAC7302 has the image rotated 90 degrees */
-		pac_start_frame(gspca_dev, frame,
-			gspca_dev->width, gspca_dev->height);
-	}
-	gspca_frame_add(gspca_dev, INTER_PACKET, frame, data, len);
-}
-
-/* this function is run at interrupt level */
 static void pac7311_sd_pkt_scan(struct gspca_dev *gspca_dev,
 			struct gspca_frame *frame,	/* target */
 			__u8 *data,			/* isoc packet */
@@ -1182,35 +658,6 @@ static void pac7311_sd_pkt_scan(struct g
 	gspca_frame_add(gspca_dev, INTER_PACKET, frame, data, len);
 }

-static int pac7302_sd_setbrightness(struct gspca_dev *gspca_dev, __s32 val)
-{
-	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
-
-	sd->brightness = val;
-	if (gspca_dev->streaming)
-		pac7302_setbrightcont(gspca_dev);
-	return 0;
-}
-
-static int pac7302_sd_getbrightness(struct gspca_dev *gspca_dev, __s32 *val)
-{
-	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
-
-	*val = sd->brightness;
-	return 0;
-}
-
-static int pac7302_sd_setcontrast(struct gspca_dev *gspca_dev, __s32 val)
-{
-	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
-
-	sd->contrast = val;
-	if (gspca_dev->streaming) {
-		pac7302_setbrightcont(gspca_dev);
-	}
-	return 0;
-}
-
 static int pac7311_sd_setcontrast(struct gspca_dev *gspca_dev, __s32 val)
 {
 	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;
@@ -1222,14 +669,6 @@ static int pac7311_sd_setcontrast(struct
 	return 0;
 }

-static int pac7302_sd_getcontrast(struct gspca_dev *gspca_dev, __s32 *val)
-{
-	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
-
-	*val = sd->contrast;
-	return 0;
-}
-
 static int pac7311_sd_getcontrast(struct gspca_dev *gspca_dev, __s32 *val)
 {
 	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;
@@ -1238,34 +677,6 @@ static int pac7311_sd_getcontrast(struct
 	return 0;
 }

-static int pac7302_sd_setcolors(struct gspca_dev *gspca_dev, __s32 val)
-{
-	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
-
-	sd->colors = val;
-	if (gspca_dev->streaming)
-		pac7302_setcolors(gspca_dev);
-	return 0;
-}
-
-static int pac7302_sd_getcolors(struct gspca_dev *gspca_dev, __s32 *val)
-{
-	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
-
-	*val = sd->colors;
-	return 0;
-}
-
-static int pac7302_sd_setgain(struct gspca_dev *gspca_dev, __s32 val)
-{
-	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
-
-	sd->gain = val;
-	if (gspca_dev->streaming)
-		pac7302_setgain(gspca_dev);
-	return 0;
-}
-
 static int pac7311_sd_setgain(struct gspca_dev *gspca_dev, __s32 val)
 {
 	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;
@@ -1276,14 +687,6 @@ static int pac7311_sd_setgain(struct gsp
 	return 0;
 }

-static int pac7302_sd_getgain(struct gspca_dev *gspca_dev, __s32 *val)
-{
-	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
-
-	*val = sd->gain;
-	return 0;
-}
-
 static int pac7311_sd_getgain(struct gspca_dev *gspca_dev, __s32 *val)
 {
 	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;
@@ -1292,16 +695,6 @@ static int pac7311_sd_getgain(struct gsp
 	return 0;
 }

-static int pac7302_sd_setexposure(struct gspca_dev *gspca_dev, __s32 val)
-{
-	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
-
-	sd->exposure = val;
-	if (gspca_dev->streaming)
-		pac7302_setexposure(gspca_dev);
-	return 0;
-}
-
 static int pac7311_sd_setexposure(struct gspca_dev *gspca_dev, __s32 val)
 {
 	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;
@@ -1312,14 +705,6 @@ static int pac7311_sd_setexposure(struct
 	return 0;
 }

-static int pac7302_sd_getexposure(struct gspca_dev *gspca_dev, __s32 *val)
-{
-	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
-
-	*val = sd->exposure;
-	return 0;
-}
-
 static int pac7311_sd_getexposure(struct gspca_dev *gspca_dev, __s32 *val)
 {
 	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;
@@ -1328,29 +713,6 @@ static int pac7311_sd_getexposure(struct
 	return 0;
 }

-static int pac7302_sd_setautogain(struct gspca_dev *gspca_dev, __s32 val)
-{
-	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
-
-	sd->autogain = val;
-	/* when switching to autogain set defaults to make sure
-	   we are on a valid point of the autogain gain /
-	   exposure knee graph, and give this change time to
-	   take effect before doing autogain. */
-	if (sd->autogain) {
-		sd->exposure = EXPOSURE_DEF;
-		sd->gain = GAIN_DEF;
-		if (gspca_dev->streaming) {
-			sd->autogain_ignore_frames =
-				PAC_AUTOGAIN_IGNORE_FRAMES;
-			pac7302_setexposure(gspca_dev);
-			pac7302_setgain(gspca_dev);
-		}
-	}
-
-	return 0;
-}
-
 static int pac7311_sd_setautogain(struct gspca_dev *gspca_dev, __s32 val)
 {
 	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;
@@ -1374,14 +736,6 @@ static int pac7311_sd_setautogain(struct
 	return 0;
 }

-static int pac7302_sd_getautogain(struct gspca_dev *gspca_dev, __s32 *val)
-{
-	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
-
-	*val = sd->autogain;
-	return 0;
-}
-
 static int pac7311_sd_getautogain(struct gspca_dev *gspca_dev, __s32 *val)
 {
 	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;
@@ -1390,16 +744,6 @@ static int pac7311_sd_getautogain(struct
 	return 0;
 }

-static int pac7302_sd_sethflip(struct gspca_dev *gspca_dev, __s32 val)
-{
-	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
-
-	sd->hflip = val;
-	if (gspca_dev->streaming)
-		pac7302_sethvflip(gspca_dev);
-	return 0;
-}
-
 static int pac7311_sd_sethflip(struct gspca_dev *gspca_dev, __s32 val)
 {
 	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;
@@ -1410,14 +754,6 @@ static int pac7311_sd_sethflip(struct gs
 	return 0;
 }

-static int pac7302_sd_gethflip(struct gspca_dev *gspca_dev, __s32 *val)
-{
-	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
-
-	*val = sd->hflip;
-	return 0;
-}
-
 static int pac7311_sd_gethflip(struct gspca_dev *gspca_dev, __s32 *val)
 {
 	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;
@@ -1426,16 +762,6 @@ static int pac7311_sd_gethflip(struct gs
 	return 0;
 }

-static int pac7302_sd_setvflip(struct gspca_dev *gspca_dev, __s32 val)
-{
-	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
-
-	sd->vflip = val;
-	if (gspca_dev->streaming)
-		pac7302_sethvflip(gspca_dev);
-	return 0;
-}
-
 static int pac7311_sd_setvflip(struct gspca_dev *gspca_dev, __s32 val)
 {
 	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;
@@ -1446,14 +772,6 @@ static int pac7311_sd_setvflip(struct gs
 	return 0;
 }

-static int pac7302_sd_getvflip(struct gspca_dev *gspca_dev, __s32 *val)
-{
-	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
-
-	*val = sd->vflip;
-	return 0;
-}
-
 static int pac7311_sd_getvflip(struct gspca_dev *gspca_dev, __s32 *val)
 {
 	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;
@@ -1462,20 +780,6 @@ static int pac7311_sd_getvflip(struct gs
 	return 0;
 }

-/* sub-driver description for pac7302 */
-static struct sd_desc pac7302_sd_desc = {
-	.name = MODULE_NAME,
-	.ctrls = pac7302_sd_ctrls,
-	.nctrls = ARRAY_SIZE(pac7302_sd_ctrls),
-	.config = pac7302_sd_config,
-	.init = pac7302_sd_init,
-	.start = pac7302_sd_start,
-	.stopN = pac7302_sd_stopN,
-	.stop0 = pac7302_sd_stop0,
-	.pkt_scan = pac7302_sd_pkt_scan,
-	.dq_callback = pac7302_do_autogain,
-};
-
 /* sub-driver description for pac7311 */
 static struct sd_desc pac7311_sd_desc = {
 	.name = MODULE_NAME,
@@ -1492,22 +796,12 @@ static struct sd_desc pac7311_sd_desc =

 /* -- module initialisation -- */
 static __devinitdata struct usb_device_id device_table[] = {
-	{USB_DEVICE(0x06f8, 0x3009), .driver_info = SENSOR_PAC7302},
 	{USB_DEVICE(0x093a, 0x2600), .driver_info = SENSOR_PAC7311},
 	{USB_DEVICE(0x093a, 0x2601), .driver_info = SENSOR_PAC7311},
 	{USB_DEVICE(0x093a, 0x2603), .driver_info = SENSOR_PAC7311},
 	{USB_DEVICE(0x093a, 0x2608), .driver_info = SENSOR_PAC7311},
 	{USB_DEVICE(0x093a, 0x260e), .driver_info = SENSOR_PAC7311},
 	{USB_DEVICE(0x093a, 0x260f), .driver_info = SENSOR_PAC7311},
-	{USB_DEVICE(0x093a, 0x2620), .driver_info = SENSOR_PAC7302},
-	{USB_DEVICE(0x093a, 0x2621), .driver_info = SENSOR_PAC7302},
-	{USB_DEVICE(0x093a, 0x2622), .driver_info = SENSOR_PAC7302},
-	{USB_DEVICE(0x093a, 0x2624), .driver_info = SENSOR_PAC7302},
-	{USB_DEVICE(0x093a, 0x2626), .driver_info = SENSOR_PAC7302},
-	{USB_DEVICE(0x093a, 0x2628), .driver_info = SENSOR_PAC7302},
-	{USB_DEVICE(0x093a, 0x2629), .driver_info = SENSOR_PAC7302},
-	{USB_DEVICE(0x093a, 0x262a), .driver_info = SENSOR_PAC7302},
-	{USB_DEVICE(0x093a, 0x262c), .driver_info = SENSOR_PAC7302},
 	{}
 };
 MODULE_DEVICE_TABLE(usb, device_table);
@@ -1516,12 +810,8 @@ MODULE_DEVICE_TABLE(usb, device_table);
 static int sd_probe(struct usb_interface *intf,
 			const struct usb_device_id *id)
 {
-	if (id->driver_info == SENSOR_PAC7302)
-		return gspca_dev_probe(intf, id, &pac7302_sd_desc,
-				sizeof(struct pac7302_sd), THIS_MODULE);
-	else
-		return gspca_dev_probe(intf, id, &pac7311_sd_desc,
-				sizeof(struct pac7311_sd), THIS_MODULE);
+	return gspca_dev_probe(intf, id, &pac7311_sd_desc,
+			sizeof(struct pac7311_sd), THIS_MODULE);
 }

 static struct usb_driver sd_driver = {

