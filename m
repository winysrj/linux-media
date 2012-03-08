Return-path: <linux-media-owner@vger.kernel.org>
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:28608 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752711Ab2CHJgp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 8 Mar 2012 04:36:45 -0500
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	<linux-media@vger.kernel.org>,
	<uclinux-dist-devel@blackfin.uclinux.org>
CC: Scott Jiang <scott.jiang.linux@gmail.com>
Subject: [PATCH 2/3 v3] [FOR 3.3] v4l2: add vs6624 sensor driver
Date: Thu, 8 Mar 2012 16:44:16 -0500
Message-ID: <1331243057-15763-2-git-send-email-scott.jiang.linux@gmail.com>
In-Reply-To: <1331243057-15763-1-git-send-email-scott.jiang.linux@gmail.com>
References: <1331243057-15763-1-git-send-email-scott.jiang.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a v4l2 sensor-level driver for the ST VS6624 camera.

Signed-off-by: Scott Jiang <scott.jiang.linux@gmail.com>
---
 drivers/media/video/Kconfig       |   10 +
 drivers/media/video/Makefile      |    1 +
 drivers/media/video/vs6624.c      |  928 +++++++++++++++++++++++++++++++++++++
 drivers/media/video/vs6624_regs.h |  337 ++++++++++++++
 include/media/v4l2-chip-ident.h   |    3 +
 5 files changed, 1279 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/vs6624.c
 create mode 100644 drivers/media/video/vs6624_regs.h

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 1088b8b..88eb68f 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -477,6 +477,16 @@ config VIDEO_OV7670
 	  OV7670 VGA camera.  It currently only works with the M88ALP01
 	  controller.
 
+config VIDEO_VS6624
+	tristate "ST VS6624 sensor support"
+	depends on VIDEO_V4L2 && I2C
+	---help---
+	  This is a Video4Linux2 sensor-level driver for the ST VS6624
+	  camera.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called vs6624.
+
 config VIDEO_MT9P031
 	tristate "Aptina MT9P031 support"
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 97dbc72..a83d13f 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -43,6 +43,7 @@ obj-$(CONFIG_VIDEO_ADV7180) += adv7180.o
 obj-$(CONFIG_VIDEO_ADV7183) += adv7183.o
 obj-$(CONFIG_VIDEO_ADV7343) += adv7343.o
 obj-$(CONFIG_VIDEO_VPX3220) += vpx3220.o
+obj-$(CONFIG_VIDEO_VS6624)  += vs6624.o
 obj-$(CONFIG_VIDEO_BT819) += bt819.o
 obj-$(CONFIG_VIDEO_BT856) += bt856.o
 obj-$(CONFIG_VIDEO_BT866) += bt866.o
diff --git a/drivers/media/video/vs6624.c b/drivers/media/video/vs6624.c
new file mode 100644
index 0000000..42ae9dc
--- /dev/null
+++ b/drivers/media/video/vs6624.c
@@ -0,0 +1,928 @@
+/*
+ * vs6624.c ST VS6624 CMOS image sensor driver
+ *
+ * Copyright (c) 2011 Analog Devices Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/gpio.h>
+#include <linux/i2c.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/videodev2.h>
+
+#include <media/v4l2-chip-ident.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-mediabus.h>
+
+#include "vs6624_regs.h"
+
+#define VGA_WIDTH       640
+#define VGA_HEIGHT      480
+#define QVGA_WIDTH      320
+#define QVGA_HEIGHT     240
+#define QQVGA_WIDTH     160
+#define QQVGA_HEIGHT    120
+#define CIF_WIDTH       352
+#define CIF_HEIGHT      288
+#define QCIF_WIDTH      176
+#define QCIF_HEIGHT     144
+#define QQCIF_WIDTH     88
+#define QQCIF_HEIGHT    72
+
+#define MAX_FRAME_RATE  30
+
+struct vs6624 {
+	struct v4l2_subdev sd;
+	struct v4l2_ctrl_handler hdl;
+	struct v4l2_fract frame_rate;
+	struct v4l2_mbus_framefmt fmt;
+	unsigned ce_pin;
+};
+
+static const struct vs6624_format {
+	enum v4l2_mbus_pixelcode mbus_code;
+	enum v4l2_colorspace colorspace;
+} vs6624_formats[] = {
+	{
+		.mbus_code      = V4L2_MBUS_FMT_UYVY8_2X8,
+		.colorspace     = V4L2_COLORSPACE_JPEG,
+	},
+	{
+		.mbus_code      = V4L2_MBUS_FMT_YUYV8_2X8,
+		.colorspace     = V4L2_COLORSPACE_JPEG,
+	},
+	{
+		.mbus_code      = V4L2_MBUS_FMT_RGB565_2X8_LE,
+		.colorspace     = V4L2_COLORSPACE_SRGB,
+	},
+};
+
+static struct v4l2_mbus_framefmt vs6624_default_fmt = {
+	.width = VGA_WIDTH,
+	.height = VGA_HEIGHT,
+	.code = V4L2_MBUS_FMT_UYVY8_2X8,
+	.field = V4L2_FIELD_NONE,
+	.colorspace = V4L2_COLORSPACE_JPEG,
+};
+
+static const u16 vs6624_p1[] = {
+	0x8104, 0x03,
+	0x8105, 0x01,
+	0xc900, 0x03,
+	0xc904, 0x47,
+	0xc905, 0x10,
+	0xc906, 0x80,
+	0xc907, 0x3a,
+	0x903a, 0x02,
+	0x903b, 0x47,
+	0x903c, 0x15,
+	0xc908, 0x31,
+	0xc909, 0xdc,
+	0xc90a, 0x80,
+	0xc90b, 0x44,
+	0x9044, 0x02,
+	0x9045, 0x31,
+	0x9046, 0xe2,
+	0xc90c, 0x07,
+	0xc90d, 0xe0,
+	0xc90e, 0x80,
+	0xc90f, 0x47,
+	0x9047, 0x90,
+	0x9048, 0x83,
+	0x9049, 0x81,
+	0x904a, 0xe0,
+	0x904b, 0x60,
+	0x904c, 0x08,
+	0x904d, 0x90,
+	0x904e, 0xc0,
+	0x904f, 0x43,
+	0x9050, 0x74,
+	0x9051, 0x01,
+	0x9052, 0xf0,
+	0x9053, 0x80,
+	0x9054, 0x05,
+	0x9055, 0xE4,
+	0x9056, 0x90,
+	0x9057, 0xc0,
+	0x9058, 0x43,
+	0x9059, 0xf0,
+	0x905a, 0x02,
+	0x905b, 0x07,
+	0x905c, 0xec,
+	0xc910, 0x5d,
+	0xc911, 0xca,
+	0xc912, 0x80,
+	0xc913, 0x5d,
+	0x905d, 0xa3,
+	0x905e, 0x04,
+	0x905f, 0xf0,
+	0x9060, 0xa3,
+	0x9061, 0x04,
+	0x9062, 0xf0,
+	0x9063, 0x22,
+	0xc914, 0x72,
+	0xc915, 0x92,
+	0xc916, 0x80,
+	0xc917, 0x64,
+	0x9064, 0x74,
+	0x9065, 0x01,
+	0x9066, 0x02,
+	0x9067, 0x72,
+	0x9068, 0x95,
+	0xc918, 0x47,
+	0xc919, 0xf2,
+	0xc91a, 0x81,
+	0xc91b, 0x69,
+	0x9169, 0x74,
+	0x916a, 0x02,
+	0x916b, 0xf0,
+	0x916c, 0xec,
+	0x916d, 0xb4,
+	0x916e, 0x10,
+	0x916f, 0x0a,
+	0x9170, 0x90,
+	0x9171, 0x80,
+	0x9172, 0x16,
+	0x9173, 0xe0,
+	0x9174, 0x70,
+	0x9175, 0x04,
+	0x9176, 0x90,
+	0x9177, 0xd3,
+	0x9178, 0xc4,
+	0x9179, 0xf0,
+	0x917a, 0x22,
+	0xc91c, 0x0a,
+	0xc91d, 0xbe,
+	0xc91e, 0x80,
+	0xc91f, 0x73,
+	0x9073, 0xfc,
+	0x9074, 0xa3,
+	0x9075, 0xe0,
+	0x9076, 0xf5,
+	0x9077, 0x82,
+	0x9078, 0x8c,
+	0x9079, 0x83,
+	0x907a, 0xa3,
+	0x907b, 0xa3,
+	0x907c, 0xe0,
+	0x907d, 0xfc,
+	0x907e, 0xa3,
+	0x907f, 0xe0,
+	0x9080, 0xc3,
+	0x9081, 0x9f,
+	0x9082, 0xff,
+	0x9083, 0xec,
+	0x9084, 0x9e,
+	0x9085, 0xfe,
+	0x9086, 0x02,
+	0x9087, 0x0a,
+	0x9088, 0xea,
+	0xc920, 0x47,
+	0xc921, 0x38,
+	0xc922, 0x80,
+	0xc923, 0x89,
+	0x9089, 0xec,
+	0x908a, 0xd3,
+	0x908b, 0x94,
+	0x908c, 0x20,
+	0x908d, 0x40,
+	0x908e, 0x01,
+	0x908f, 0x1c,
+	0x9090, 0x90,
+	0x9091, 0xd3,
+	0x9092, 0xd4,
+	0x9093, 0xec,
+	0x9094, 0xf0,
+	0x9095, 0x02,
+	0x9096, 0x47,
+	0x9097, 0x3d,
+	0xc924, 0x45,
+	0xc925, 0xca,
+	0xc926, 0x80,
+	0xc927, 0x98,
+	0x9098, 0x12,
+	0x9099, 0x77,
+	0x909a, 0xd6,
+	0x909b, 0x02,
+	0x909c, 0x45,
+	0x909d, 0xcd,
+	0xc928, 0x20,
+	0xc929, 0xd5,
+	0xc92a, 0x80,
+	0xc92b, 0x9e,
+	0x909e, 0x90,
+	0x909f, 0x82,
+	0x90a0, 0x18,
+	0x90a1, 0xe0,
+	0x90a2, 0xb4,
+	0x90a3, 0x03,
+	0x90a4, 0x0e,
+	0x90a5, 0x90,
+	0x90a6, 0x83,
+	0x90a7, 0xbf,
+	0x90a8, 0xe0,
+	0x90a9, 0x60,
+	0x90aa, 0x08,
+	0x90ab, 0x90,
+	0x90ac, 0x81,
+	0x90ad, 0xfc,
+	0x90ae, 0xe0,
+	0x90af, 0xff,
+	0x90b0, 0xc3,
+	0x90b1, 0x13,
+	0x90b2, 0xf0,
+	0x90b3, 0x90,
+	0x90b4, 0x81,
+	0x90b5, 0xfc,
+	0x90b6, 0xe0,
+	0x90b7, 0xff,
+	0x90b8, 0x02,
+	0x90b9, 0x20,
+	0x90ba, 0xda,
+	0xc92c, 0x70,
+	0xc92d, 0xbc,
+	0xc92e, 0x80,
+	0xc92f, 0xbb,
+	0x90bb, 0x90,
+	0x90bc, 0x82,
+	0x90bd, 0x18,
+	0x90be, 0xe0,
+	0x90bf, 0xb4,
+	0x90c0, 0x03,
+	0x90c1, 0x06,
+	0x90c2, 0x90,
+	0x90c3, 0xc1,
+	0x90c4, 0x06,
+	0x90c5, 0x74,
+	0x90c6, 0x05,
+	0x90c7, 0xf0,
+	0x90c8, 0x90,
+	0x90c9, 0xd3,
+	0x90ca, 0xa0,
+	0x90cb, 0x02,
+	0x90cc, 0x70,
+	0x90cd, 0xbf,
+	0xc930, 0x72,
+	0xc931, 0x21,
+	0xc932, 0x81,
+	0xc933, 0x3b,
+	0x913b, 0x7d,
+	0x913c, 0x02,
+	0x913d, 0x7f,
+	0x913e, 0x7b,
+	0x913f, 0x02,
+	0x9140, 0x72,
+	0x9141, 0x25,
+	0xc934, 0x28,
+	0xc935, 0xae,
+	0xc936, 0x80,
+	0xc937, 0xd2,
+	0x90d2, 0xf0,
+	0x90d3, 0x90,
+	0x90d4, 0xd2,
+	0x90d5, 0x0a,
+	0x90d6, 0x02,
+	0x90d7, 0x28,
+	0x90d8, 0xb4,
+	0xc938, 0x28,
+	0xc939, 0xb1,
+	0xc93a, 0x80,
+	0xc93b, 0xd9,
+	0x90d9, 0x90,
+	0x90da, 0x83,
+	0x90db, 0xba,
+	0x90dc, 0xe0,
+	0x90dd, 0xff,
+	0x90de, 0x90,
+	0x90df, 0xd2,
+	0x90e0, 0x08,
+	0x90e1, 0xe0,
+	0x90e2, 0xe4,
+	0x90e3, 0xef,
+	0x90e4, 0xf0,
+	0x90e5, 0xa3,
+	0x90e6, 0xe0,
+	0x90e7, 0x74,
+	0x90e8, 0xff,
+	0x90e9, 0xf0,
+	0x90ea, 0x90,
+	0x90eb, 0xd2,
+	0x90ec, 0x0a,
+	0x90ed, 0x02,
+	0x90ee, 0x28,
+	0x90ef, 0xb4,
+	0xc93c, 0x29,
+	0xc93d, 0x79,
+	0xc93e, 0x80,
+	0xc93f, 0xf0,
+	0x90f0, 0xf0,
+	0x90f1, 0x90,
+	0x90f2, 0xd2,
+	0x90f3, 0x0e,
+	0x90f4, 0x02,
+	0x90f5, 0x29,
+	0x90f6, 0x7f,
+	0xc940, 0x29,
+	0xc941, 0x7c,
+	0xc942, 0x80,
+	0xc943, 0xf7,
+	0x90f7, 0x90,
+	0x90f8, 0x83,
+	0x90f9, 0xba,
+	0x90fa, 0xe0,
+	0x90fb, 0xff,
+	0x90fc, 0x90,
+	0x90fd, 0xd2,
+	0x90fe, 0x0c,
+	0x90ff, 0xe0,
+	0x9100, 0xe4,
+	0x9101, 0xef,
+	0x9102, 0xf0,
+	0x9103, 0xa3,
+	0x9104, 0xe0,
+	0x9105, 0x74,
+	0x9106, 0xff,
+	0x9107, 0xf0,
+	0x9108, 0x90,
+	0x9109, 0xd2,
+	0x910a, 0x0e,
+	0x910b, 0x02,
+	0x910c, 0x29,
+	0x910d, 0x7f,
+	0xc944, 0x2a,
+	0xc945, 0x42,
+	0xc946, 0x81,
+	0xc947, 0x0e,
+	0x910e, 0xf0,
+	0x910f, 0x90,
+	0x9110, 0xd2,
+	0x9111, 0x12,
+	0x9112, 0x02,
+	0x9113, 0x2a,
+	0x9114, 0x48,
+	0xc948, 0x2a,
+	0xc949, 0x45,
+	0xc94a, 0x81,
+	0xc94b, 0x15,
+	0x9115, 0x90,
+	0x9116, 0x83,
+	0x9117, 0xba,
+	0x9118, 0xe0,
+	0x9119, 0xff,
+	0x911a, 0x90,
+	0x911b, 0xd2,
+	0x911c, 0x10,
+	0x911d, 0xe0,
+	0x911e, 0xe4,
+	0x911f, 0xef,
+	0x9120, 0xf0,
+	0x9121, 0xa3,
+	0x9122, 0xe0,
+	0x9123, 0x74,
+	0x9124, 0xff,
+	0x9125, 0xf0,
+	0x9126, 0x90,
+	0x9127, 0xd2,
+	0x9128, 0x12,
+	0x9129, 0x02,
+	0x912a, 0x2a,
+	0x912b, 0x48,
+	0xc900, 0x01,
+	0x0000, 0x00,
+};
+
+static const u16 vs6624_p2[] = {
+	0x806f, 0x01,
+	0x058c, 0x01,
+	0x0000, 0x00,
+};
+
+static const u16 vs6624_run_setup[] = {
+	0x1d18, 0x00,				/* Enableconstrainedwhitebalance */
+	VS6624_PEAK_MIN_OUT_G_MSB, 0x3c,	/* Damper PeakGain Output MSB */
+	VS6624_PEAK_MIN_OUT_G_LSB, 0x66,	/* Damper PeakGain Output LSB */
+	VS6624_CM_LOW_THR_MSB, 0x65,		/* Damper Low MSB */
+	VS6624_CM_LOW_THR_LSB, 0xd1,		/* Damper Low LSB */
+	VS6624_CM_HIGH_THR_MSB, 0x66,		/* Damper High MSB */
+	VS6624_CM_HIGH_THR_LSB, 0x62,		/* Damper High LSB */
+	VS6624_CM_MIN_OUT_MSB, 0x00,		/* Damper Min output MSB */
+	VS6624_CM_MIN_OUT_LSB, 0x00,		/* Damper Min output LSB */
+	VS6624_NORA_DISABLE, 0x00,		/* Nora fDisable */
+	VS6624_NORA_USAGE, 0x04,		/* Nora usage */
+	VS6624_NORA_LOW_THR_MSB, 0x63,		/* Damper Low MSB Changed 0x63 to 0x65 */
+	VS6624_NORA_LOW_THR_LSB, 0xd1,		/* Damper Low LSB */
+	VS6624_NORA_HIGH_THR_MSB, 0x68,		/* Damper High MSB */
+	VS6624_NORA_HIGH_THR_LSB, 0xdd,		/* Damper High LSB */
+	VS6624_NORA_MIN_OUT_MSB, 0x3a,		/* Damper Min output MSB */
+	VS6624_NORA_MIN_OUT_LSB, 0x00,		/* Damper Min output LSB */
+	VS6624_F2B_DISABLE, 0x00,		/* Disable */
+	0x1d8a, 0x30,				/* MAXWeightHigh */
+	0x1d91, 0x62,				/* fpDamperLowThresholdHigh MSB */
+	0x1d92, 0x4a,				/* fpDamperLowThresholdHigh LSB */
+	0x1d95, 0x65,				/* fpDamperHighThresholdHigh MSB */
+	0x1d96, 0x0e,				/* fpDamperHighThresholdHigh LSB */
+	0x1da1, 0x3a,				/* fpMinimumDamperOutputLow MSB */
+	0x1da2, 0xb8,				/* fpMinimumDamperOutputLow LSB */
+	0x1e08, 0x06,				/* MAXWeightLow */
+	0x1e0a, 0x0a,				/* MAXWeightHigh */
+	0x1601, 0x3a,				/* Red A MSB */
+	0x1602, 0x14,				/* Red A LSB */
+	0x1605, 0x3b,				/* Blue A MSB */
+	0x1606, 0x85,				/* BLue A LSB */
+	0x1609, 0x3b,				/* RED B MSB */
+	0x160a, 0x85,				/* RED B LSB */
+	0x160d, 0x3a,				/* Blue B MSB */
+	0x160e, 0x14,				/* Blue B LSB */
+	0x1611, 0x30,				/* Max Distance from Locus MSB */
+	0x1612, 0x8f,				/* Max Distance from Locus MSB */
+	0x1614, 0x01,				/* Enable constrainer */
+	0x0000, 0x00,
+};
+
+static const u16 vs6624_default[] = {
+	VS6624_CONTRAST0, 0x84,
+	VS6624_SATURATION0, 0x75,
+	VS6624_GAMMA0, 0x11,
+	VS6624_CONTRAST1, 0x84,
+	VS6624_SATURATION1, 0x75,
+	VS6624_GAMMA1, 0x11,
+	VS6624_MAN_RG, 0x80,
+	VS6624_MAN_GG, 0x80,
+	VS6624_MAN_BG, 0x80,
+	VS6624_WB_MODE, 0x1,
+	VS6624_EXPO_COMPENSATION, 0xfe,
+	VS6624_EXPO_METER, 0x0,
+	VS6624_LIGHT_FREQ, 0x64,
+	VS6624_PEAK_GAIN, 0xe,
+	VS6624_PEAK_LOW_THR, 0x28,
+	VS6624_HMIRROR0, 0x0,
+	VS6624_VFLIP0, 0x0,
+	VS6624_ZOOM_HSTEP0_MSB, 0x0,
+	VS6624_ZOOM_HSTEP0_LSB, 0x1,
+	VS6624_ZOOM_VSTEP0_MSB, 0x0,
+	VS6624_ZOOM_VSTEP0_LSB, 0x1,
+	VS6624_PAN_HSTEP0_MSB, 0x0,
+	VS6624_PAN_HSTEP0_LSB, 0xf,
+	VS6624_PAN_VSTEP0_MSB, 0x0,
+	VS6624_PAN_VSTEP0_LSB, 0xf,
+	VS6624_SENSOR_MODE, 0x1,
+	VS6624_SYNC_CODE_SETUP, 0x21,
+	VS6624_DISABLE_FR_DAMPER, 0x0,
+	VS6624_FR_DEN, 0x1,
+	VS6624_FR_NUM_LSB, 0xf,
+	VS6624_INIT_PIPE_SETUP, 0x0,
+	VS6624_IMG_FMT0, 0x0,
+	VS6624_YUV_SETUP, 0x1,
+	VS6624_IMAGE_SIZE0, 0x2,
+	0x0000, 0x00,
+};
+
+static inline struct vs6624 *to_vs6624(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct vs6624, sd);
+}
+static inline struct v4l2_subdev *to_sd(struct v4l2_ctrl *ctrl)
+{
+	return &container_of(ctrl->handler, struct vs6624, hdl)->sd;
+}
+
+static int vs6624_read(struct v4l2_subdev *sd, u16 index)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	u8 buf[2];
+
+	buf[0] = index >> 8;
+	buf[1] = index;
+	i2c_master_send(client, buf, 2);
+	i2c_master_recv(client, buf, 1);
+
+	return buf[0];
+}
+
+static int vs6624_write(struct v4l2_subdev *sd, u16 index,
+				u8 value)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	u8 buf[3];
+
+	buf[0] = index >> 8;
+	buf[1] = index;
+	buf[2] = value;
+
+	return i2c_master_send(client, buf, 3);
+}
+
+static int vs6624_writeregs(struct v4l2_subdev *sd, const u16 *regs)
+{
+	u16 reg;
+	u8 data;
+
+	while (*regs != 0x00) {
+		reg = *regs++;
+		data = *regs++;
+
+		vs6624_write(sd, reg, data);
+	}
+	return 0;
+}
+
+static int vs6624_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct v4l2_subdev *sd = to_sd(ctrl);
+
+	switch (ctrl->id) {
+	case V4L2_CID_CONTRAST:
+		vs6624_write(sd, VS6624_CONTRAST0, ctrl->val);
+		break;
+	case V4L2_CID_SATURATION:
+		vs6624_write(sd, VS6624_SATURATION0, ctrl->val);
+		break;
+	case V4L2_CID_HFLIP:
+		vs6624_write(sd, VS6624_HMIRROR0, ctrl->val);
+		break;
+	case V4L2_CID_VFLIP:
+		vs6624_write(sd, VS6624_VFLIP0, ctrl->val);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int vs6624_enum_mbus_fmt(struct v4l2_subdev *sd, unsigned index,
+				enum v4l2_mbus_pixelcode *code)
+{
+	if (index >= ARRAY_SIZE(vs6624_formats))
+		return -EINVAL;
+
+	*code = vs6624_formats[index].mbus_code;
+	return 0;
+}
+
+static int vs6624_try_mbus_fmt(struct v4l2_subdev *sd,
+				struct v4l2_mbus_framefmt *fmt)
+{
+	int index;
+
+	for (index = 0; index < ARRAY_SIZE(vs6624_formats); index++)
+		if (vs6624_formats[index].mbus_code == fmt->code)
+			break;
+	if (index >= ARRAY_SIZE(vs6624_formats)) {
+		/* default to first format */
+		index = 0;
+		fmt->code = vs6624_formats[0].mbus_code;
+	}
+
+	/* sensor mode is VGA */
+	if (fmt->width > VGA_WIDTH)
+		fmt->width = VGA_WIDTH;
+	if (fmt->height > VGA_HEIGHT)
+		fmt->height = VGA_HEIGHT;
+	fmt->width = fmt->width & (~3);
+	fmt->height = fmt->height & (~3);
+	fmt->field = V4L2_FIELD_NONE;
+	fmt->colorspace = vs6624_formats[index].colorspace;
+	return 0;
+}
+
+static int vs6624_s_mbus_fmt(struct v4l2_subdev *sd,
+				struct v4l2_mbus_framefmt *fmt)
+{
+	struct vs6624 *sensor = to_vs6624(sd);
+	int ret;
+
+	ret = vs6624_try_mbus_fmt(sd, fmt);
+	if (ret)
+		return ret;
+
+	/* set image format */
+	switch (fmt->code) {
+	case V4L2_MBUS_FMT_UYVY8_2X8:
+		vs6624_write(sd, VS6624_IMG_FMT0, 0x0);
+		vs6624_write(sd, VS6624_YUV_SETUP, 0x1);
+		break;
+	case V4L2_MBUS_FMT_YUYV8_2X8:
+		vs6624_write(sd, VS6624_IMG_FMT0, 0x0);
+		vs6624_write(sd, VS6624_YUV_SETUP, 0x3);
+		break;
+	case V4L2_MBUS_FMT_RGB565_2X8_LE:
+		vs6624_write(sd, VS6624_IMG_FMT0, 0x4);
+		vs6624_write(sd, VS6624_RGB_SETUP, 0x0);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/* set image size */
+	if ((fmt->width == VGA_WIDTH) && (fmt->height == VGA_HEIGHT))
+		vs6624_write(sd, VS6624_IMAGE_SIZE0, 0x2);
+	else if ((fmt->width == QVGA_WIDTH) && (fmt->height == QVGA_HEIGHT))
+		vs6624_write(sd, VS6624_IMAGE_SIZE0, 0x4);
+	else if ((fmt->width == QQVGA_WIDTH) && (fmt->height == QQVGA_HEIGHT))
+		vs6624_write(sd, VS6624_IMAGE_SIZE0, 0x6);
+	else if ((fmt->width == CIF_WIDTH) && (fmt->height == CIF_HEIGHT))
+		vs6624_write(sd, VS6624_IMAGE_SIZE0, 0x3);
+	else if ((fmt->width == QCIF_WIDTH) && (fmt->height == QCIF_HEIGHT))
+		vs6624_write(sd, VS6624_IMAGE_SIZE0, 0x5);
+	else if ((fmt->width == QQCIF_WIDTH) && (fmt->height == QQCIF_HEIGHT))
+		vs6624_write(sd, VS6624_IMAGE_SIZE0, 0x7);
+	else {
+		vs6624_write(sd, VS6624_IMAGE_SIZE0, 0x8);
+		vs6624_write(sd, VS6624_MAN_HSIZE0_MSB, fmt->width >> 8);
+		vs6624_write(sd, VS6624_MAN_HSIZE0_LSB, fmt->width & 0xFF);
+		vs6624_write(sd, VS6624_MAN_VSIZE0_MSB, fmt->height >> 8);
+		vs6624_write(sd, VS6624_MAN_VSIZE0_LSB, fmt->height & 0xFF);
+		vs6624_write(sd, VS6624_CROP_CTRL0, 0x1);
+	}
+
+	sensor->fmt = *fmt;
+
+	return 0;
+}
+
+static int vs6624_g_mbus_fmt(struct v4l2_subdev *sd,
+				struct v4l2_mbus_framefmt *fmt)
+{
+	struct vs6624 *sensor = to_vs6624(sd);
+
+	*fmt = sensor->fmt;
+	return 0;
+}
+
+static int vs6624_g_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *parms)
+{
+	struct vs6624 *sensor = to_vs6624(sd);
+	struct v4l2_captureparm *cp = &parms->parm.capture;
+
+	if (parms->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	memset(cp, 0, sizeof(*cp));
+	cp->capability = V4L2_CAP_TIMEPERFRAME;
+	cp->timeperframe.numerator = sensor->frame_rate.denominator;
+	cp->timeperframe.denominator = sensor->frame_rate.numerator;
+	return 0;
+}
+
+static int vs6624_s_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *parms)
+{
+	struct vs6624 *sensor = to_vs6624(sd);
+	struct v4l2_captureparm *cp = &parms->parm.capture;
+	struct v4l2_fract *tpf = &cp->timeperframe;
+
+	if (parms->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+	if (cp->extendedmode != 0)
+		return -EINVAL;
+
+	if (tpf->numerator == 0 || tpf->denominator == 0
+		|| (tpf->denominator > tpf->numerator * MAX_FRAME_RATE)) {
+		/* reset to max frame rate */
+		tpf->numerator = 1;
+		tpf->denominator = MAX_FRAME_RATE;
+	}
+	sensor->frame_rate.numerator = tpf->denominator;
+	sensor->frame_rate.denominator = tpf->numerator;
+	vs6624_write(sd, VS6624_DISABLE_FR_DAMPER, 0x0);
+	vs6624_write(sd, VS6624_FR_NUM_MSB,
+			sensor->frame_rate.numerator >> 8);
+	vs6624_write(sd, VS6624_FR_NUM_LSB,
+			sensor->frame_rate.numerator & 0xFF);
+	vs6624_write(sd, VS6624_FR_DEN,
+			sensor->frame_rate.denominator & 0xFF);
+	return 0;
+}
+
+static int vs6624_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	if (enable)
+		vs6624_write(sd, VS6624_USER_CMD, 0x2);
+	else
+		vs6624_write(sd, VS6624_USER_CMD, 0x4);
+	udelay(100);
+	return 0;
+}
+
+static int vs6624_g_chip_ident(struct v4l2_subdev *sd,
+		struct v4l2_dbg_chip_ident *chip)
+{
+	int rev;
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	rev = (vs6624_read(sd, VS6624_FW_VSN_MAJOR) << 8)
+		| vs6624_read(sd, VS6624_FW_VSN_MINOR);
+
+	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_VS6624, rev);
+}
+
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+static int vs6624_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	if (!v4l2_chip_match_i2c_client(client, &reg->match))
+		return -EINVAL;
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+	reg->val = vs6624_read(sd, reg->reg & 0xffff);
+	reg->size = 1;
+	return 0;
+}
+
+static int vs6624_s_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	if (!v4l2_chip_match_i2c_client(client, &reg->match))
+		return -EINVAL;
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+	vs6624_write(sd, reg->reg & 0xffff, reg->val & 0xff);
+	return 0;
+}
+#endif
+
+static const struct v4l2_ctrl_ops vs6624_ctrl_ops = {
+	.s_ctrl = vs6624_s_ctrl,
+};
+
+static const struct v4l2_subdev_core_ops vs6624_core_ops = {
+	.g_chip_ident = vs6624_g_chip_ident,
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	.g_register = vs6624_g_register,
+	.s_register = vs6624_s_register,
+#endif
+};
+
+static const struct v4l2_subdev_video_ops vs6624_video_ops = {
+	.enum_mbus_fmt = vs6624_enum_mbus_fmt,
+	.try_mbus_fmt = vs6624_try_mbus_fmt,
+	.s_mbus_fmt = vs6624_s_mbus_fmt,
+	.g_mbus_fmt = vs6624_g_mbus_fmt,
+	.s_parm = vs6624_s_parm,
+	.g_parm = vs6624_g_parm,
+	.s_stream = vs6624_s_stream,
+};
+
+static const struct v4l2_subdev_ops vs6624_ops = {
+	.core = &vs6624_core_ops,
+	.video = &vs6624_video_ops,
+};
+
+static int __devinit vs6624_probe(struct i2c_client *client,
+			const struct i2c_device_id *id)
+{
+	struct vs6624 *sensor;
+	struct v4l2_subdev *sd;
+	struct v4l2_ctrl_handler *hdl;
+	const unsigned *ce;
+	int ret;
+
+	/* Check if the adapter supports the needed features */
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
+		return -EIO;
+
+	ce = client->dev.platform_data;
+	if (ce == NULL)
+		return -EINVAL;
+
+	ret = gpio_request(*ce, "VS6624 Chip Enable");
+	if (ret) {
+		v4l_err(client, "failed to request GPIO %d\n", *ce);
+		return ret;
+	}
+	gpio_direction_output(*ce, 1);
+	/* wait 100ms before any further i2c writes are performed */
+	mdelay(100);
+
+	sensor = kzalloc(sizeof(*sensor), GFP_KERNEL);
+	if (sensor == NULL) {
+		gpio_free(*ce);
+		return -ENOMEM;
+	}
+
+	sd = &sensor->sd;
+	v4l2_i2c_subdev_init(sd, client, &vs6624_ops);
+
+	vs6624_writeregs(sd, vs6624_p1);
+	vs6624_write(sd, VS6624_MICRO_EN, 0x2);
+	vs6624_write(sd, VS6624_DIO_EN, 0x1);
+	mdelay(10);
+	vs6624_writeregs(sd, vs6624_p2);
+
+	vs6624_writeregs(sd, vs6624_default);
+	vs6624_write(sd, VS6624_HSYNC_SETUP, 0xF);
+	vs6624_writeregs(sd, vs6624_run_setup);
+
+	/* set frame rate */
+	sensor->frame_rate.numerator = MAX_FRAME_RATE;
+	sensor->frame_rate.denominator = 1;
+	vs6624_write(sd, VS6624_DISABLE_FR_DAMPER, 0x0);
+	vs6624_write(sd, VS6624_FR_NUM_MSB,
+			sensor->frame_rate.numerator >> 8);
+	vs6624_write(sd, VS6624_FR_NUM_LSB,
+			sensor->frame_rate.numerator & 0xFF);
+	vs6624_write(sd, VS6624_FR_DEN,
+			sensor->frame_rate.denominator & 0xFF);
+
+	sensor->fmt = vs6624_default_fmt;
+	sensor->ce_pin = *ce;
+
+	v4l_info(client, "chip found @ 0x%02x (%s)\n",
+			client->addr << 1, client->adapter->name);
+
+	hdl = &sensor->hdl;
+	v4l2_ctrl_handler_init(hdl, 4);
+	v4l2_ctrl_new_std(hdl, &vs6624_ctrl_ops,
+			V4L2_CID_CONTRAST, 0, 0xFF, 1, 0x87);
+	v4l2_ctrl_new_std(hdl, &vs6624_ctrl_ops,
+			V4L2_CID_SATURATION, 0, 0xFF, 1, 0x78);
+	v4l2_ctrl_new_std(hdl, &vs6624_ctrl_ops,
+			V4L2_CID_HFLIP, 0, 1, 1, 0);
+	v4l2_ctrl_new_std(hdl, &vs6624_ctrl_ops,
+			V4L2_CID_VFLIP, 0, 1, 1, 0);
+	/* hook the control handler into the driver */
+	sd->ctrl_handler = hdl;
+	if (hdl->error) {
+		int err = hdl->error;
+
+		v4l2_ctrl_handler_free(hdl);
+		kfree(sensor);
+		gpio_free(*ce);
+		return err;
+	}
+
+	/* initialize the hardware to the default control values */
+	ret = v4l2_ctrl_handler_setup(hdl);
+	if (ret) {
+		v4l2_ctrl_handler_free(hdl);
+		kfree(sensor);
+		gpio_free(*ce);
+	}
+	return ret;
+}
+
+static int __devexit vs6624_remove(struct i2c_client *client)
+{
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct vs6624 *sensor = to_vs6624(sd);
+
+	v4l2_device_unregister_subdev(sd);
+	v4l2_ctrl_handler_free(sd->ctrl_handler);
+	gpio_free(sensor->ce_pin);
+	kfree(sensor);
+	return 0;
+}
+
+static const struct i2c_device_id vs6624_id[] = {
+	{"vs6624", 0},
+	{},
+};
+
+MODULE_DEVICE_TABLE(i2c, vs6624_id);
+
+static struct i2c_driver vs6624_driver = {
+	.driver = {
+		.owner  = THIS_MODULE,
+		.name   = "vs6624",
+	},
+	.probe          = vs6624_probe,
+	.remove         = __devexit_p(vs6624_remove),
+	.id_table       = vs6624_id,
+};
+
+static __init int vs6624_init(void)
+{
+	return i2c_add_driver(&vs6624_driver);
+}
+
+static __exit void vs6624_exit(void)
+{
+	i2c_del_driver(&vs6624_driver);
+}
+
+module_init(vs6624_init);
+module_exit(vs6624_exit);
+
+MODULE_DESCRIPTION("VS6624 sensor driver");
+MODULE_AUTHOR("Scott Jiang <Scott.Jiang.Linux@gmail.com>");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/media/video/vs6624_regs.h b/drivers/media/video/vs6624_regs.h
new file mode 100644
index 0000000..6ba2ee2
--- /dev/null
+++ b/drivers/media/video/vs6624_regs.h
@@ -0,0 +1,337 @@
+/*
+ * vs6624 - ST VS6624 CMOS image sensor registers
+ *
+ * Copyright (c) 2011 Analog Devices Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef _VS6624_REGS_H_
+#define _VS6624_REGS_H_
+
+/* low level control registers */
+#define VS6624_MICRO_EN               0xC003 /* power enable for all MCU clock */
+#define VS6624_DIO_EN                 0xC044 /* enable digital I/O */
+/* device parameters */
+#define VS6624_DEV_ID_MSB             0x0001 /* device id MSB */
+#define VS6624_DEV_ID_LSB             0x0002 /* device id LSB */
+#define VS6624_FW_VSN_MAJOR           0x0004 /* firmware version major */
+#define VS6624_FW_VSN_MINOR           0x0006 /* firmware version minor */
+#define VS6624_PATCH_VSN_MAJOR        0x0008 /* patch version major */
+#define VS6624_PATCH_VSN_MINOR        0x000A /* patch version minor */
+/* host interface manager control */
+#define VS6624_USER_CMD               0x0180 /* user level control of operating states */
+/* host interface manager status */
+#define VS6624_STATE                  0x0202 /* current state of the mode manager */
+/* run mode control */
+#define VS6624_METER_ON               0x0280 /* if false AE and AWB are disabled */
+/* mode setup */
+#define VS6624_ACTIVE_PIPE_SETUP      0x0302 /* select the active bank for non view live mode */
+#define VS6624_SENSOR_MODE            0x0308 /* select the different sensor mode */
+/* pipe setup bank0 */
+#define VS6624_IMAGE_SIZE0            0x0380 /* required output dimension */
+#define VS6624_MAN_HSIZE0_MSB         0x0383 /* input required manual H size MSB */
+#define VS6624_MAN_HSIZE0_LSB         0x0384 /* input required manual H size LSB */
+#define VS6624_MAN_VSIZE0_MSB         0x0387 /* input required manual V size MSB */
+#define VS6624_MAN_VSIZE0_LSB         0x0388 /* input required manual V size LSB */
+#define VS6624_ZOOM_HSTEP0_MSB        0x038B /* set the zoom H step MSB */
+#define VS6624_ZOOM_HSTEP0_LSB        0x038C /* set the zoom H step LSB */
+#define VS6624_ZOOM_VSTEP0_MSB        0x038F /* set the zoom V step MSB */
+#define VS6624_ZOOM_VSTEP0_LSB        0x0390 /* set the zoom V step LSB */
+#define VS6624_ZOOM_CTRL0             0x0392 /* control zoon in, out and stop */
+#define VS6624_PAN_HSTEP0_MSB         0x0395 /* set the pan H step MSB */
+#define VS6624_PAN_HSTEP0_LSB         0x0396 /* set the pan H step LSB */
+#define VS6624_PAN_VSTEP0_MSB         0x0399 /* set the pan V step MSB */
+#define VS6624_PAN_VSTEP0_LSB         0x039A /* set the pan V step LSB */
+#define VS6624_PAN_CTRL0              0x039C /* control pan operation */
+#define VS6624_CROP_CTRL0             0x039E /* select cropping mode */
+#define VS6624_CROP_HSTART0_MSB       0x03A1 /* set the cropping H start address MSB */
+#define VS6624_CROP_HSTART0_LSB       0x03A2 /* set the cropping H start address LSB */
+#define VS6624_CROP_HSIZE0_MSB        0x03A5 /* set the cropping H size MSB */
+#define VS6624_CROP_HSIZE0_LSB        0x03A6 /* set the cropping H size LSB */
+#define VS6624_CROP_VSTART0_MSB       0x03A9 /* set the cropping V start address MSB */
+#define VS6624_CROP_VSTART0_LSB       0x03AA /* set the cropping V start address LSB */
+#define VS6624_CROP_VSIZE0_MSB        0x03AD /* set the cropping V size MSB */
+#define VS6624_CROP_VSIZE0_LSB        0x03AE /* set the cropping V size LSB */
+#define VS6624_IMG_FMT0               0x03B0 /* select required output image format */
+#define VS6624_BAYER_OUT_ALIGN0       0x03B2 /* set bayer output alignment */
+#define VS6624_CONTRAST0              0x03B4 /* contrast control for output */
+#define VS6624_SATURATION0            0x03B6 /* saturation control for output */
+#define VS6624_GAMMA0                 0x03B8 /* gamma settings */
+#define VS6624_HMIRROR0               0x03BA /* horizontal image orientation flip */
+#define VS6624_VFLIP0                 0x03BC /* vertical image orientation flip */
+#define VS6624_CHANNEL_ID0            0x03BE /* logical DMA channel number */
+/* pipe setup bank1 */
+#define VS6624_IMAGE_SIZE1            0x0400 /* required output dimension */
+#define VS6624_MAN_HSIZE1_MSB         0x0403 /* input required manual H size MSB */
+#define VS6624_MAN_HSIZE1_LSB         0x0404 /* input required manual H size LSB */
+#define VS6624_MAN_VSIZE1_MSB         0x0407 /* input required manual V size MSB */
+#define VS6624_MAN_VSIZE1_LSB         0x0408 /* input required manual V size LSB */
+#define VS6624_ZOOM_HSTEP1_MSB        0x040B /* set the zoom H step MSB */
+#define VS6624_ZOOM_HSTEP1_LSB        0x040C /* set the zoom H step LSB */
+#define VS6624_ZOOM_VSTEP1_MSB        0x040F /* set the zoom V step MSB */
+#define VS6624_ZOOM_VSTEP1_LSB        0x0410 /* set the zoom V step LSB */
+#define VS6624_ZOOM_CTRL1             0x0412 /* control zoon in, out and stop */
+#define VS6624_PAN_HSTEP1_MSB         0x0415 /* set the pan H step MSB */
+#define VS6624_PAN_HSTEP1_LSB         0x0416 /* set the pan H step LSB */
+#define VS6624_PAN_VSTEP1_MSB         0x0419 /* set the pan V step MSB */
+#define VS6624_PAN_VSTEP1_LSB         0x041A /* set the pan V step LSB */
+#define VS6624_PAN_CTRL1              0x041C /* control pan operation */
+#define VS6624_CROP_CTRL1             0x041E /* select cropping mode */
+#define VS6624_CROP_HSTART1_MSB       0x0421 /* set the cropping H start address MSB */
+#define VS6624_CROP_HSTART1_LSB       0x0422 /* set the cropping H start address LSB */
+#define VS6624_CROP_HSIZE1_MSB        0x0425 /* set the cropping H size MSB */
+#define VS6624_CROP_HSIZE1_LSB        0x0426 /* set the cropping H size LSB */
+#define VS6624_CROP_VSTART1_MSB       0x0429 /* set the cropping V start address MSB */
+#define VS6624_CROP_VSTART1_LSB       0x042A /* set the cropping V start address LSB */
+#define VS6624_CROP_VSIZE1_MSB        0x042D /* set the cropping V size MSB */
+#define VS6624_CROP_VSIZE1_LSB        0x042E /* set the cropping V size LSB */
+#define VS6624_IMG_FMT1               0x0430 /* select required output image format */
+#define VS6624_BAYER_OUT_ALIGN1       0x0432 /* set bayer output alignment */
+#define VS6624_CONTRAST1              0x0434 /* contrast control for output */
+#define VS6624_SATURATION1            0x0436 /* saturation control for output */
+#define VS6624_GAMMA1                 0x0438 /* gamma settings */
+#define VS6624_HMIRROR1               0x043A /* horizontal image orientation flip */
+#define VS6624_VFLIP1                 0x043C /* vertical image orientation flip */
+#define VS6624_CHANNEL_ID1            0x043E /* logical DMA channel number */
+/* view live control */
+#define VS6624_VIEW_LIVE_EN           0x0480 /* enable view live mode */
+#define VS6624_INIT_PIPE_SETUP        0x0482 /* select initial pipe setup bank */
+/* view live status */
+#define VS6624_CUR_PIPE_SETUP         0x0500 /* indicates most recently applied setup bank */
+/* power management */
+#define VS6624_TIME_TO_POWER_DOWN     0x0580 /* automatically transition time to stop mode */
+/* video timing parameter host inputs */
+#define VS6624_EXT_CLK_FREQ_NUM_MSB   0x0605 /* external clock frequency numerator MSB */
+#define VS6624_EXT_CLK_FREQ_NUM_LSB   0x0606 /* external clock frequency numerator LSB */
+#define VS6624_EXT_CLK_FREQ_DEN       0x0608 /* external clock frequency denominator */
+/* video timing control */
+#define VS6624_SYS_CLK_MODE           0x0880 /* decides system clock frequency */
+/* frame dimension parameter host inputs */
+#define VS6624_LIGHT_FREQ             0x0C80 /* AC frequency used for flicker free time */
+#define VS6624_FLICKER_COMPAT         0x0C82 /* flicker compatible frame length */
+/* static frame rate control */
+#define VS6624_FR_NUM_MSB             0x0D81 /* desired frame rate numerator MSB */
+#define VS6624_FR_NUM_LSB             0x0D82 /* desired frame rate numerator LSB */
+#define VS6624_FR_DEN                 0x0D84 /* desired frame rate denominator */
+/* automatic frame rate control */
+#define VS6624_DISABLE_FR_DAMPER      0x0E80 /* defines frame rate mode */
+#define VS6624_MIN_DAMPER_OUT_MSB     0x0E8C /* minimum frame rate MSB */
+#define VS6624_MIN_DAMPER_OUT_LSB     0x0E8A /* minimum frame rate LSB */
+/* exposure controls */
+#define VS6624_EXPO_MODE              0x1180 /* exposure mode */
+#define VS6624_EXPO_METER             0x1182 /* weights to be associated with the zones */
+#define VS6624_EXPO_TIME_NUM          0x1184 /* exposure time numerator */
+#define VS6624_EXPO_TIME_DEN          0x1186 /* exposure time denominator */
+#define VS6624_EXPO_TIME_MSB          0x1189 /* exposure time for the Manual Mode MSB */
+#define VS6624_EXPO_TIME_LSB          0x118A /* exposure time for the Manual Mode LSB */
+#define VS6624_EXPO_COMPENSATION      0x1190 /* exposure compensation */
+#define VS6624_DIRECT_COARSE_MSB      0x1195 /* coarse integration lines for Direct Mode MSB */
+#define VS6624_DIRECT_COARSE_LSB      0x1196 /* coarse integration lines for Direct Mode LSB */
+#define VS6624_DIRECT_FINE_MSB        0x1199 /* fine integration pixels for Direct Mode MSB */
+#define VS6624_DIRECT_FINE_LSB        0x119A /* fine integration pixels for Direct Mode LSB */
+#define VS6624_DIRECT_ANAL_GAIN_MSB   0x119D /* analog gain for Direct Mode MSB */
+#define VS6624_DIRECT_ANAL_GAIN_LSB   0x119E /* analog gain for Direct Mode LSB */
+#define VS6624_DIRECT_DIGI_GAIN_MSB   0x11A1 /* digital gain for Direct Mode MSB */
+#define VS6624_DIRECT_DIGI_GAIN_LSB   0x11A2 /* digital gain for Direct Mode LSB */
+#define VS6624_FLASH_COARSE_MSB       0x11A5 /* coarse integration lines for Flash Gun Mode MSB */
+#define VS6624_FLASH_COARSE_LSB       0x11A6 /* coarse integration lines for Flash Gun Mode LSB */
+#define VS6624_FLASH_FINE_MSB         0x11A9 /* fine integration pixels for Flash Gun Mode MSB */
+#define VS6624_FLASH_FINE_LSB         0x11AA /* fine integration pixels for Flash Gun Mode LSB */
+#define VS6624_FLASH_ANAL_GAIN_MSB    0x11AD /* analog gain for Flash Gun Mode MSB */
+#define VS6624_FLASH_ANAL_GAIN_LSB    0x11AE /* analog gain for Flash Gun Mode LSB */
+#define VS6624_FLASH_DIGI_GAIN_MSB    0x11B1 /* digital gain for Flash Gun Mode MSB */
+#define VS6624_FLASH_DIGI_GAIN_LSB    0x11B2 /* digital gain for Flash Gun Mode LSB */
+#define VS6624_FREEZE_AE              0x11B4 /* freeze auto exposure */
+#define VS6624_MAX_INT_TIME_MSB       0x11B7 /* user maximum integration time MSB */
+#define VS6624_MAX_INT_TIME_LSB       0x11B8 /* user maximum integration time LSB */
+#define VS6624_FLASH_AG_THR_MSB       0x11BB /* recommend flash gun analog gain threshold MSB */
+#define VS6624_FLASH_AG_THR_LSB       0x11BC /* recommend flash gun analog gain threshold LSB */
+#define VS6624_ANTI_FLICKER_MODE      0x11C0 /* anti flicker mode */
+/* white balance control */
+#define VS6624_WB_MODE                0x1480 /* set white balance mode */
+#define VS6624_MAN_RG                 0x1482 /* user setting for red channel gain */
+#define VS6624_MAN_GG                 0x1484 /* user setting for green channel gain */
+#define VS6624_MAN_BG                 0x1486 /* user setting for blue channel gain */
+#define VS6624_FLASH_RG_MSB           0x148B /* red gain for Flash Gun MSB */
+#define VS6624_FLASH_RG_LSB           0x148C /* red gain for Flash Gun LSB */
+#define VS6624_FLASH_GG_MSB           0x148F /* green gain for Flash Gun MSB */
+#define VS6624_FLASH_GG_LSB           0x1490 /* green gain for Flash Gun LSB */
+#define VS6624_FLASH_BG_MSB           0x1493 /* blue gain for Flash Gun MSB */
+#define VS6624_FLASH_BG_LSB           0x1494 /* blue gain for Flash Gun LSB */
+/* sensor setup */
+#define VS6624_BC_OFFSET              0x1990 /* Black Correction Offset */
+/* image stability */
+#define VS6624_STABLE_WB              0x1900 /* white balance stable */
+#define VS6624_STABLE_EXPO            0x1902 /* exposure stable */
+#define VS6624_STABLE                 0x1906 /* system stable */
+/* flash control */
+#define VS6624_FLASH_MODE             0x1A80 /* flash mode */
+#define VS6624_FLASH_OFF_LINE_MSB     0x1A83 /* off line at flash pulse mode MSB */
+#define VS6624_FLASH_OFF_LINE_LSB     0x1A84 /* off line at flash pulse mode LSB */
+/* flash status */
+#define VS6624_FLASH_RECOM            0x1B00 /* flash gun is recommended */
+#define VS6624_FLASH_GRAB_COMPLETE    0x1B02 /* flash gun image has been grabbed */
+/* scythe filter controls */
+#define VS6624_SCYTHE_FILTER          0x1D80 /* disable scythe defect correction */
+/* jack filter controls */
+#define VS6624_JACK_FILTER            0x1E00 /* disable jack defect correction */
+/* demosaic control */
+#define VS6624_ANTI_ALIAS_FILTER      0x1E80 /* anti alias filter suppress */
+/* color matrix dampers */
+#define VS6624_CM_DISABLE             0x1F00 /* disable color matrix damper */
+#define VS6624_CM_LOW_THR_MSB         0x1F03 /* low threshold for exposure MSB */
+#define VS6624_CM_LOW_THR_LSB         0x1F04 /* low threshold for exposure LSB */
+#define VS6624_CM_HIGH_THR_MSB        0x1F07 /* high threshold for exposure MSB */
+#define VS6624_CM_HIGH_THR_LSB        0x1F08 /* high threshold for exposure LSB */
+#define VS6624_CM_MIN_OUT_MSB         0x1F0B /* minimum possible damper output MSB */
+#define VS6624_CM_MIN_OUT_LSB         0x1F0C /* minimum possible damper output LSB */
+/* peaking control */
+#define VS6624_PEAK_GAIN              0x2000 /* controls peaking gain */
+#define VS6624_PEAK_G_DISABLE         0x2002 /* disable peak gain damping */
+#define VS6624_PEAK_LOW_THR_G_MSB     0x2005 /* low threshold for exposure for gain MSB */
+#define VS6624_PEAK_LOW_THR_G_LSB     0x2006 /* low threshold for exposure for gain LSB */
+#define VS6624_PEAK_HIGH_THR_G_MSB    0x2009 /* high threshold for exposure for gain MSB */
+#define VS6624_PEAK_HIGH_THR_G_LSB    0x200A /* high threshold for exposure for gain LSB */
+#define VS6624_PEAK_MIN_OUT_G_MSB     0x200D /* minimum damper output for gain MSB */
+#define VS6624_PEAK_MIN_OUT_G_LSB     0x200E /* minimum damper output for gain LSB */
+#define VS6624_PEAK_LOW_THR           0x2010 /* adjust degree of coring */
+#define VS6624_PEAK_C_DISABLE         0x2012 /* disable coring damping */
+#define VS6624_PEAK_HIGH_THR          0x2014 /* adjust maximum gain */
+#define VS6624_PEAK_LOW_THR_C_MSB     0x2017 /* low threshold for exposure for coring MSB */
+#define VS6624_PEAK_LOW_THR_C_LSB     0x2018 /* low threshold for exposure for coring LSB */
+#define VS6624_PEAK_HIGH_THR_C_MSB    0x201B /* high threshold for exposure for coring MSB */
+#define VS6624_PEAK_HIGH_THR_C_LSB    0x201C /* high threshold for exposure for coring LSB */
+#define VS6624_PEAK_MIN_OUT_C_MSB     0x201F /* minimum damper output for coring MSB */
+#define VS6624_PEAK_MIN_OUT_C_LSB     0x2020 /* minimum damper output for coring LSB */
+/* pipe 0 RGB to YUV matrix manual control */
+#define VS6624_RYM0_MAN_CTRL          0x2180 /* enable manual RGB to YUV matrix */
+#define VS6624_RYM0_W00_MSB           0x2183 /* row 0 column 0 of YUV matrix MSB */
+#define VS6624_RYM0_W00_LSB           0x2184 /* row 0 column 0 of YUV matrix LSB */
+#define VS6624_RYM0_W01_MSB           0x2187 /* row 0 column 1 of YUV matrix MSB */
+#define VS6624_RYM0_W01_LSB           0x2188 /* row 0 column 1 of YUV matrix LSB */
+#define VS6624_RYM0_W02_MSB           0x218C /* row 0 column 2 of YUV matrix MSB */
+#define VS6624_RYM0_W02_LSB           0x218D /* row 0 column 2 of YUV matrix LSB */
+#define VS6624_RYM0_W10_MSB           0x2190 /* row 1 column 0 of YUV matrix MSB */
+#define VS6624_RYM0_W10_LSB           0x218F /* row 1 column 0 of YUV matrix LSB */
+#define VS6624_RYM0_W11_MSB           0x2193 /* row 1 column 1 of YUV matrix MSB */
+#define VS6624_RYM0_W11_LSB           0x2194 /* row 1 column 1 of YUV matrix LSB */
+#define VS6624_RYM0_W12_MSB           0x2197 /* row 1 column 2 of YUV matrix MSB */
+#define VS6624_RYM0_W12_LSB           0x2198 /* row 1 column 2 of YUV matrix LSB */
+#define VS6624_RYM0_W20_MSB           0x219B /* row 2 column 0 of YUV matrix MSB */
+#define VS6624_RYM0_W20_LSB           0x219C /* row 2 column 0 of YUV matrix LSB */
+#define VS6624_RYM0_W21_MSB           0x21A0 /* row 2 column 1 of YUV matrix MSB */
+#define VS6624_RYM0_W21_LSB           0x219F /* row 2 column 1 of YUV matrix LSB */
+#define VS6624_RYM0_W22_MSB           0x21A3 /* row 2 column 2 of YUV matrix MSB */
+#define VS6624_RYM0_W22_LSB           0x21A4 /* row 2 column 2 of YUV matrix LSB */
+#define VS6624_RYM0_YINY_MSB          0x21A7 /* Y in Y MSB */
+#define VS6624_RYM0_YINY_LSB          0x21A8 /* Y in Y LSB */
+#define VS6624_RYM0_YINCB_MSB         0x21AB /* Y in Cb MSB */
+#define VS6624_RYM0_YINCB_LSB         0x21AC /* Y in Cb LSB */
+#define VS6624_RYM0_YINCR_MSB         0x21B0 /* Y in Cr MSB */
+#define VS6624_RYM0_YINCR_LSB         0x21AF /* Y in Cr LSB */
+/* pipe 1 RGB to YUV matrix manual control */
+#define VS6624_RYM1_MAN_CTRL          0x2200 /* enable manual RGB to YUV matrix */
+#define VS6624_RYM1_W00_MSB           0x2203 /* row 0 column 0 of YUV matrix MSB */
+#define VS6624_RYM1_W00_LSB           0x2204 /* row 0 column 0 of YUV matrix LSB */
+#define VS6624_RYM1_W01_MSB           0x2207 /* row 0 column 1 of YUV matrix MSB */
+#define VS6624_RYM1_W01_LSB           0x2208 /* row 0 column 1 of YUV matrix LSB */
+#define VS6624_RYM1_W02_MSB           0x220C /* row 0 column 2 of YUV matrix MSB */
+#define VS6624_RYM1_W02_LSB           0x220D /* row 0 column 2 of YUV matrix LSB */
+#define VS6624_RYM1_W10_MSB           0x2210 /* row 1 column 0 of YUV matrix MSB */
+#define VS6624_RYM1_W10_LSB           0x220F /* row 1 column 0 of YUV matrix LSB */
+#define VS6624_RYM1_W11_MSB           0x2213 /* row 1 column 1 of YUV matrix MSB */
+#define VS6624_RYM1_W11_LSB           0x2214 /* row 1 column 1 of YUV matrix LSB */
+#define VS6624_RYM1_W12_MSB           0x2217 /* row 1 column 2 of YUV matrix MSB */
+#define VS6624_RYM1_W12_LSB           0x2218 /* row 1 column 2 of YUV matrix LSB */
+#define VS6624_RYM1_W20_MSB           0x221B /* row 2 column 0 of YUV matrix MSB */
+#define VS6624_RYM1_W20_LSB           0x221C /* row 2 column 0 of YUV matrix LSB */
+#define VS6624_RYM1_W21_MSB           0x2220 /* row 2 column 1 of YUV matrix MSB */
+#define VS6624_RYM1_W21_LSB           0x221F /* row 2 column 1 of YUV matrix LSB */
+#define VS6624_RYM1_W22_MSB           0x2223 /* row 2 column 2 of YUV matrix MSB */
+#define VS6624_RYM1_W22_LSB           0x2224 /* row 2 column 2 of YUV matrix LSB */
+#define VS6624_RYM1_YINY_MSB          0x2227 /* Y in Y MSB */
+#define VS6624_RYM1_YINY_LSB          0x2228 /* Y in Y LSB */
+#define VS6624_RYM1_YINCB_MSB         0x222B /* Y in Cb MSB */
+#define VS6624_RYM1_YINCB_LSB         0x222C /* Y in Cb LSB */
+#define VS6624_RYM1_YINCR_MSB         0x2220 /* Y in Cr MSB */
+#define VS6624_RYM1_YINCR_LSB         0x222F /* Y in Cr LSB */
+/* pipe 0 gamma manual control */
+#define VS6624_GAMMA_MAN_CTRL0        0x2280 /* enable manual gamma setup */
+#define VS6624_GAMMA_PEAK_R0          0x2282 /* peaked red channel gamma value */
+#define VS6624_GAMMA_PEAK_G0          0x2284 /* peaked green channel gamma value */
+#define VS6624_GAMMA_PEAK_B0          0x2286 /* peaked blue channel gamma value */
+#define VS6624_GAMMA_UNPEAK_R0        0x2288 /* unpeaked red channel gamma value */
+#define VS6624_GAMMA_UNPEAK_G0        0x228A /* unpeaked green channel gamma value */
+#define VS6624_GAMMA_UNPEAK_B0        0x228C /* unpeaked blue channel gamma value */
+/* pipe 1 gamma manual control */
+#define VS6624_GAMMA_MAN_CTRL1        0x2300 /* enable manual gamma setup */
+#define VS6624_GAMMA_PEAK_R1          0x2302 /* peaked red channel gamma value */
+#define VS6624_GAMMA_PEAK_G1          0x2304 /* peaked green channel gamma value */
+#define VS6624_GAMMA_PEAK_B1          0x2306 /* peaked blue channel gamma value */
+#define VS6624_GAMMA_UNPEAK_R1        0x2308 /* unpeaked red channel gamma value */
+#define VS6624_GAMMA_UNPEAK_G1        0x230A /* unpeaked green channel gamma value */
+#define VS6624_GAMMA_UNPEAK_B1        0x230C /* unpeaked blue channel gamma value */
+/* fade to black */
+#define VS6624_F2B_DISABLE            0x2480 /* disable fade to black */
+#define VS6624_F2B_BLACK_VAL_MSB      0x2483 /* black value MSB */
+#define VS6624_F2B_BLACK_VAL_LSB      0x2484 /* black value LSB */
+#define VS6624_F2B_LOW_THR_MSB        0x2487 /* low threshold for exposure MSB */
+#define VS6624_F2B_LOW_THR_LSB        0x2488 /* low threshold for exposure LSB */
+#define VS6624_F2B_HIGH_THR_MSB       0x248B /* high threshold for exposure MSB */
+#define VS6624_F2B_HIGH_THR_LSB       0x248C /* high threshold for exposure LSB */
+#define VS6624_F2B_MIN_OUT_MSB        0x248F /* minimum damper output MSB */
+#define VS6624_F2B_MIN_OUT_LSB        0x2490 /* minimum damper output LSB */
+/* output formatter control */
+#define VS6624_CODE_CK_EN             0x2580 /* code check enable */
+#define VS6624_BLANK_FMT              0x2582 /* blank format */
+#define VS6624_SYNC_CODE_SETUP        0x2584 /* sync code setup */
+#define VS6624_HSYNC_SETUP            0x2586 /* H sync setup */
+#define VS6624_VSYNC_SETUP            0x2588 /* V sync setup */
+#define VS6624_PCLK_SETUP             0x258A /* PCLK setup */
+#define VS6624_PCLK_EN                0x258C /* PCLK enable */
+#define VS6624_OPF_SP_SETUP           0x258E /* output formatter sp setup */
+#define VS6624_BLANK_DATA_MSB         0x2590 /* blank data MSB */
+#define VS6624_BLANK_DATA_LSB         0x2592 /* blank data LSB */
+#define VS6624_RGB_SETUP              0x2594 /* RGB setup */
+#define VS6624_YUV_SETUP              0x2596 /* YUV setup */
+#define VS6624_VSYNC_RIS_COARSE_H     0x2598 /* V sync rising coarse high */
+#define VS6624_VSYNC_RIS_COARSE_L     0x259A /* V sync rising coarse low */
+#define VS6624_VSYNC_RIS_FINE_H       0x259C /* V sync rising fine high */
+#define VS6624_VSYNC_RIS_FINE_L       0x259E /* V sync rising fine low */
+#define VS6624_VSYNC_FALL_COARSE_H    0x25A0 /* V sync falling coarse high */
+#define VS6624_VSYNC_FALL_COARSE_L    0x25A2 /* V sync falling coarse low */
+#define VS6624_VSYNC_FALL_FINE_H      0x25A4 /* V sync falling fine high */
+#define VS6624_VSYNC_FALL_FINE_L      0x25A6 /* V sync falling fine low */
+#define VS6624_HSYNC_RIS_H            0x25A8 /* H sync rising high */
+#define VS6624_HSYNC_RIS_L            0x25AA /* H sync rising low */
+#define VS6624_HSYNC_FALL_H           0x25AC /* H sync falling high */
+#define VS6624_HSYNC_FALL_L           0x25AE /* H sync falling low */
+#define VS6624_OUT_IF                 0x25B0 /* output interface */
+#define VS6624_CCP_EXT_DATA           0x25B2 /* CCP extra data */
+/* NoRA controls */
+#define VS6624_NORA_DISABLE           0x2600 /* NoRA control mode */
+#define VS6624_NORA_USAGE             0x2602 /* usage */
+#define VS6624_NORA_SPLIT_KN          0x2604 /* split kn */
+#define VS6624_NORA_SPLIT_NI          0x2606 /* split ni */
+#define VS6624_NORA_TIGHT_G           0x2608 /* tight green */
+#define VS6624_NORA_DISABLE_NP        0x260A /* disable noro promoting */
+#define VS6624_NORA_LOW_THR_MSB       0x260D /* low threshold for exposure MSB */
+#define VS6624_NORA_LOW_THR_LSB       0x260E /* low threshold for exposure LSB */
+#define VS6624_NORA_HIGH_THR_MSB      0x2611 /* high threshold for exposure MSB */
+#define VS6624_NORA_HIGH_THR_LSB      0x2612 /* high threshold for exposure LSB */
+#define VS6624_NORA_MIN_OUT_MSB       0x2615 /* minimum damper output MSB */
+#define VS6624_NORA_MIN_OUT_LSB       0x2616 /* minimum damper output LSB */
+
+#endif
diff --git a/include/media/v4l2-chip-ident.h b/include/media/v4l2-chip-ident.h
index 6da4ed0..7395c81 100644
--- a/include/media/v4l2-chip-ident.h
+++ b/include/media/v4l2-chip-ident.h
@@ -143,6 +143,9 @@ enum {
 	/* module saa6588: just ident 6588 */
 	V4L2_IDENT_SAA6588 = 6588,
 
+	/* module vs6624: just ident 6624 */
+	V4L2_IDENT_VS6624 = 6624,
+
 	/* module saa6752hs: reserved range 6750-6759 */
 	V4L2_IDENT_SAA6752HS = 6752,
 	V4L2_IDENT_SAA6752HS_AC3 = 6753,
-- 
1.7.0.4


