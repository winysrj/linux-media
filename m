Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:51091 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754182AbaGHRA0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Jul 2014 13:00:26 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 7/8] vivi: massive rewrite of this virtual video driver
Date: Tue,  8 Jul 2014 18:31:17 +0200
Message-Id: <1404837078-15608-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1404837078-15608-1-git-send-email-hverkuil@xs4all.nl>
References: <1404837078-15608-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch rewrites the vivi driver almost completely. It now emulates a capture
device that supports four inputs by default:

Input 0 emulates a webcam, input 1 emulates a TV capture device, input 2 emulates
an S-Video capture device and input 3 emulates an HDMI capture device.

These inputs act exactly as a real hardware device would behave. This allows
you to use this driver as a test input for application development, since you
can test the various features without requiring special hardware.

A quick overview of the features implemented by this driver:

- A large list of test patterns and variations thereof
- Working brightness, contrast, saturation and hue controls
- Support for the alpha color component
- Full colorspace support, including limited/full RGB range
- All possible control types are present
- Support for various pixel aspect ratios and video aspect ratios
- Error injection to test what happens if errors occur
- Supports crop/compose/scale in any combination
- Can emulate up to 4K resolutions
- All Field settings are supported for testing interlaced capturing
- Supports all standard YUV and RGB formats, including two multiplanar YUV formats
- Overlay support

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/Kconfig       |    1 +
 drivers/media/platform/Makefile      |    2 +
 drivers/media/platform/vivi-colors.c |  273 +++
 drivers/media/platform/vivi-colors.h |   45 +
 drivers/media/platform/vivi-core.c   | 3996 ++++++++++++++++++++++++++++++++++
 drivers/media/platform/vivi-tpg.c    | 1369 ++++++++++++
 drivers/media/platform/vivi-tpg.h    |  429 ++++
 7 files changed, 6115 insertions(+)
 create mode 100644 drivers/media/platform/vivi-colors.c
 create mode 100644 drivers/media/platform/vivi-colors.h
 create mode 100644 drivers/media/platform/vivi-core.c
 create mode 100644 drivers/media/platform/vivi-tpg.c
 create mode 100644 drivers/media/platform/vivi-tpg.h

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 8108c69..e17b4f7 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -240,6 +240,7 @@ menuconfig V4L_TEST_DRIVERS
 	depends on MEDIA_CAMERA_SUPPORT
 
 if V4L_TEST_DRIVERS
+
 config VIDEO_VIVI
 	tristate "Virtual Video Driver"
 	depends on VIDEO_DEV && VIDEO_V4L2 && !SPARC32 && !SPARC64
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index e5269da..f5ca4e1 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -15,6 +15,8 @@ obj-$(CONFIG_VIDEO_MMP_CAMERA) += marvell-ccic/
 obj-$(CONFIG_VIDEO_OMAP3)	+= omap3isp/
 
 obj-$(CONFIG_VIDEO_VIU) += fsl-viu.o
+
+vivi-objs := vivi-core.o vivi-tpg.o vivi-colors.o
 obj-$(CONFIG_VIDEO_VIVI) += vivi.o
 
 obj-$(CONFIG_VIDEO_MEM2MEM_TESTDEV) += mem2mem_testdev.o
diff --git a/drivers/media/platform/vivi-colors.c b/drivers/media/platform/vivi-colors.c
new file mode 100644
index 0000000..984ccea
--- /dev/null
+++ b/drivers/media/platform/vivi-colors.c
@@ -0,0 +1,273 @@
+#include <linux/videodev2.h>
+
+#include "vivi-colors.h"
+
+/* sRGB colors with range [0-255] */
+const struct color tpg_colors[TPG_COLOR_MAX] = {
+	/*
+	 * Colors to test colorspace conversion: converting these colors
+	 * to other colorspaces will never lead to out-of-gamut colors.
+	 */
+	{ 191, 191, 191 }, /* TPG_COLOR_CSC_WHITE */
+	{ 191, 191,  50 }, /* TPG_COLOR_CSC_YELLOW */
+	{  50, 191, 191 }, /* TPG_COLOR_CSC_CYAN */
+	{  50, 191,  50 }, /* TPG_COLOR_CSC_GREEN */
+	{ 191,  50, 191 }, /* TPG_COLOR_CSC_MAGENTA */
+	{ 191,  50,  50 }, /* TPG_COLOR_CSC_RED */
+	{  50,  50, 191 }, /* TPG_COLOR_CSC_BLUE */
+	{  50,  50,  50 }, /* TPG_COLOR_CSC_BLACK */
+
+	/* 75% colors */
+	{ 191, 191,   0 }, /* TPG_COLOR_75_YELLOW */
+	{   0, 191, 191 }, /* TPG_COLOR_75_CYAN */
+	{   0, 191,   0 }, /* TPG_COLOR_75_GREEN */
+	{ 191,   0, 191 }, /* TPG_COLOR_75_MAGENTA */
+	{ 191,   0,   0 }, /* TPG_COLOR_75_RED */
+	{   0,   0, 191 }, /* TPG_COLOR_75_BLUE */
+
+	/* 100% colors */
+	{ 255, 255, 255 }, /* TPG_COLOR_100_WHITE */
+	{ 255, 255,   0 }, /* TPG_COLOR_100_YELLOW */
+	{   0, 255, 255 }, /* TPG_COLOR_100_CYAN */
+	{   0, 255,   0 }, /* TPG_COLOR_100_GREEN */
+	{ 255,   0, 255 }, /* TPG_COLOR_100_MAGENTA */
+	{ 255,   0,   0 }, /* TPG_COLOR_100_RED */
+	{   0,   0, 255 }, /* TPG_COLOR_100_BLUE */
+	{   0,   0,   0 }, /* TPG_COLOR_100_BLACK */
+
+	{   0,   0,   0 }, /* TPG_COLOR_RANDOM placeholder */
+};
+
+#ifndef COMPILE_APP
+
+/* Generated table */
+const struct color16 tpg_csc_colors[V4L2_COLORSPACE_SRGB + 1][TPG_COLOR_CSC_BLACK + 1] = {
+	[V4L2_COLORSPACE_SMPTE170M][0] = { 2953, 2939, 2939 },
+	[V4L2_COLORSPACE_SMPTE170M][1] = { 2954, 2963, 585 },
+	[V4L2_COLORSPACE_SMPTE170M][2] = { 84, 2967, 2937 },
+	[V4L2_COLORSPACE_SMPTE170M][3] = { 93, 2990, 575 },
+	[V4L2_COLORSPACE_SMPTE170M][4] = { 3030, 259, 2933 },
+	[V4L2_COLORSPACE_SMPTE170M][5] = { 3031, 406, 557 },
+	[V4L2_COLORSPACE_SMPTE170M][6] = { 544, 428, 2931 },
+	[V4L2_COLORSPACE_SMPTE170M][7] = { 551, 547, 547 },
+	[V4L2_COLORSPACE_SMPTE240M][0] = { 2926, 2926, 2926 },
+	[V4L2_COLORSPACE_SMPTE240M][1] = { 2926, 2926, 857 },
+	[V4L2_COLORSPACE_SMPTE240M][2] = { 1594, 2901, 2901 },
+	[V4L2_COLORSPACE_SMPTE240M][3] = { 1594, 2901, 774 },
+	[V4L2_COLORSPACE_SMPTE240M][4] = { 2484, 618, 2858 },
+	[V4L2_COLORSPACE_SMPTE240M][5] = { 2484, 618, 617 },
+	[V4L2_COLORSPACE_SMPTE240M][6] = { 507, 507, 2832 },
+	[V4L2_COLORSPACE_SMPTE240M][7] = { 507, 507, 507 },
+	[V4L2_COLORSPACE_REC709][0] = { 2939, 2939, 2939 },
+	[V4L2_COLORSPACE_REC709][1] = { 2939, 2939, 547 },
+	[V4L2_COLORSPACE_REC709][2] = { 547, 2939, 2939 },
+	[V4L2_COLORSPACE_REC709][3] = { 547, 2939, 547 },
+	[V4L2_COLORSPACE_REC709][4] = { 2939, 547, 2939 },
+	[V4L2_COLORSPACE_REC709][5] = { 2939, 547, 547 },
+	[V4L2_COLORSPACE_REC709][6] = { 547, 547, 2939 },
+	[V4L2_COLORSPACE_REC709][7] = { 547, 547, 547 },
+	[V4L2_COLORSPACE_470_SYSTEM_M][0] = { 2894, 2988, 2808 },
+	[V4L2_COLORSPACE_470_SYSTEM_M][1] = { 2847, 3070, 843 },
+	[V4L2_COLORSPACE_470_SYSTEM_M][2] = { 1656, 2962, 2783 },
+	[V4L2_COLORSPACE_470_SYSTEM_M][3] = { 1572, 3045, 763 },
+	[V4L2_COLORSPACE_470_SYSTEM_M][4] = { 2477, 229, 2743 },
+	[V4L2_COLORSPACE_470_SYSTEM_M][5] = { 2422, 672, 614 },
+	[V4L2_COLORSPACE_470_SYSTEM_M][6] = { 725, 63, 2718 },
+	[V4L2_COLORSPACE_470_SYSTEM_M][7] = { 534, 561, 509 },
+	[V4L2_COLORSPACE_470_SYSTEM_BG][0] = { 2939, 2939, 2939 },
+	[V4L2_COLORSPACE_470_SYSTEM_BG][1] = { 2939, 2939, 621 },
+	[V4L2_COLORSPACE_470_SYSTEM_BG][2] = { 786, 2939, 2939 },
+	[V4L2_COLORSPACE_470_SYSTEM_BG][3] = { 786, 2939, 621 },
+	[V4L2_COLORSPACE_470_SYSTEM_BG][4] = { 2879, 547, 2923 },
+	[V4L2_COLORSPACE_470_SYSTEM_BG][5] = { 2879, 547, 547 },
+	[V4L2_COLORSPACE_470_SYSTEM_BG][6] = { 547, 547, 2923 },
+	[V4L2_COLORSPACE_470_SYSTEM_BG][7] = { 547, 547, 547 },
+	[V4L2_COLORSPACE_SRGB][0] = { 3056, 3056, 3056 },
+	[V4L2_COLORSPACE_SRGB][1] = { 3056, 3056, 800 },
+	[V4L2_COLORSPACE_SRGB][2] = { 800, 3056, 3056 },
+	[V4L2_COLORSPACE_SRGB][3] = { 800, 3056, 800 },
+	[V4L2_COLORSPACE_SRGB][4] = { 3056, 800, 3056 },
+	[V4L2_COLORSPACE_SRGB][5] = { 3056, 800, 800 },
+	[V4L2_COLORSPACE_SRGB][6] = { 800, 800, 3056 },
+	[V4L2_COLORSPACE_SRGB][7] = { 800, 800, 800 },
+};
+
+#else
+
+/* This code generates the table above */
+
+#include <math.h>
+#include <stdio.h>
+#include <stdlib.h>
+
+static const double rec709_to_ntsc1953[3][3] = {
+	{ 0.6698, 0.2678,  0.0323 },
+	{ 0.0185, 1.0742, -0.0603 },
+	{ 0.0162, 0.0432,  0.8551 }
+};
+
+static const double rec709_to_ebu[3][3] = {
+	{ 0.9578, 0.0422, 0      },
+	{ 0     , 1     , 0      },
+	{ 0     , 0.0118, 0.9882 }
+};
+
+static const double rec709_to_170m[3][3] = {
+	{  1.0654, -0.0554, -0.0010 },
+	{ -0.0196,  1.0364, -0.0167 },
+	{  0.0016,  0.0044,  0.9940 }
+};
+
+static const double rec709_to_240m[3][3] = {
+	{ 0.7151, 0.2849, 0      },
+	{ 0.0179, 0.9821, 0      },
+	{ 0.0177, 0.0472, 0.9350 }
+};
+
+
+static void mult_matrix(double *r, double *g, double *b, const double m[3][3])
+{
+	double ir, ig, ib;
+
+	ir = m[0][0] * (*r) + m[0][1] * (*g) + m[0][2] * (*b);
+	ig = m[1][0] * (*r) + m[1][1] * (*g) + m[1][2] * (*b);
+	ib = m[2][0] * (*r) + m[2][1] * (*g) + m[2][2] * (*b);
+	*r = ir;
+	*g = ig;
+	*b = ib;
+}
+
+static double transfer_srgb_to_rgb(double v)
+{
+	return (v <= 0.03928) ? v / 12.92 : pow((v + 0.055) / 1.055, 2.4);
+}
+
+static double transfer_rgb_to_smpte240m(double v)
+{
+	return (v <= 0.0228) ? v * 4.0 : 1.1115 * pow(v, 0.45) - 0.1115;
+}
+
+static double transfer_rgb_to_rec709(double v)
+{
+	return (v < 0.018) ? v * 4.5 : 1.099 * pow(v, 0.45) - 0.099;
+}
+
+static double transfer_srgb_to_rec709(double v)
+{
+	return transfer_rgb_to_rec709(transfer_srgb_to_rgb(v));
+}
+
+static void csc(enum v4l2_colorspace colorspace, double *r, double *g, double *b)
+{
+	/* Convert the primaries of Rec. 709 Linear RGB */
+	switch (colorspace) {
+	case V4L2_COLORSPACE_SMPTE240M:
+		*r = transfer_srgb_to_rgb(*r);
+		*g = transfer_srgb_to_rgb(*g);
+		*b = transfer_srgb_to_rgb(*b);
+		mult_matrix(r, g, b, rec709_to_240m);
+		break;
+	case V4L2_COLORSPACE_SMPTE170M:
+		*r = transfer_srgb_to_rgb(*r);
+		*g = transfer_srgb_to_rgb(*g);
+		*b = transfer_srgb_to_rgb(*b);
+		mult_matrix(r, g, b, rec709_to_170m);
+		break;
+	case V4L2_COLORSPACE_470_SYSTEM_BG:
+		*r = transfer_srgb_to_rgb(*r);
+		*g = transfer_srgb_to_rgb(*g);
+		*b = transfer_srgb_to_rgb(*b);
+		mult_matrix(r, g, b, rec709_to_ebu);
+		break;
+	case V4L2_COLORSPACE_470_SYSTEM_M:
+		*r = transfer_srgb_to_rgb(*r);
+		*g = transfer_srgb_to_rgb(*g);
+		*b = transfer_srgb_to_rgb(*b);
+		mult_matrix(r, g, b, rec709_to_ntsc1953);
+		break;
+	case V4L2_COLORSPACE_SRGB:
+	case V4L2_COLORSPACE_REC709:
+	default:
+		break;
+	}
+
+	*r = ((*r) < 0) ? 0 : (((*r) > 1) ? 1 : (*r));
+	*g = ((*g) < 0) ? 0 : (((*g) > 1) ? 1 : (*g));
+	*b = ((*b) < 0) ? 0 : (((*b) > 1) ? 1 : (*b));
+
+	/* Encode to gamma corrected colorspace */
+	switch (colorspace) {
+	case V4L2_COLORSPACE_SMPTE240M:
+		*r = transfer_rgb_to_smpte240m(*r);
+		*g = transfer_rgb_to_smpte240m(*g);
+		*b = transfer_rgb_to_smpte240m(*b);
+		break;
+	case V4L2_COLORSPACE_SMPTE170M:
+	case V4L2_COLORSPACE_470_SYSTEM_M:
+	case V4L2_COLORSPACE_470_SYSTEM_BG:
+		*r = transfer_rgb_to_rec709(*r);
+		*g = transfer_rgb_to_rec709(*g);
+		*b = transfer_rgb_to_rec709(*b);
+		break;
+	case V4L2_COLORSPACE_SRGB:
+		break;
+	case V4L2_COLORSPACE_REC709:
+	default:
+		*r = transfer_srgb_to_rec709(*r);
+		*g = transfer_srgb_to_rec709(*g);
+		*b = transfer_srgb_to_rec709(*b);
+		break;
+	}
+}
+
+int main(int argc, char **argv)
+{
+	static const unsigned colorspaces[] = {
+		0,
+		V4L2_COLORSPACE_SMPTE170M,
+		V4L2_COLORSPACE_SMPTE240M,
+		V4L2_COLORSPACE_REC709,
+		0,
+		V4L2_COLORSPACE_470_SYSTEM_M,
+		V4L2_COLORSPACE_470_SYSTEM_BG,
+		0,
+		V4L2_COLORSPACE_SRGB,
+	};
+	static const char * const colorspace_names[] = {
+		"",
+		"V4L2_COLORSPACE_SMPTE170M",
+		"V4L2_COLORSPACE_SMPTE240M",
+		"V4L2_COLORSPACE_REC709",
+		"",
+		"V4L2_COLORSPACE_470_SYSTEM_M",
+		"V4L2_COLORSPACE_470_SYSTEM_BG",
+		"",
+		"V4L2_COLORSPACE_SRGB",
+	};
+	int i;
+	int c;
+
+	printf("/* Generated table */\n");
+	printf("const struct color16 tpg_csc_colors[V4L2_COLORSPACE_SRGB + 1][TPG_COLOR_CSC_BLACK + 1] = {\n");
+	for (c = 0; c <= V4L2_COLORSPACE_SRGB; c++) {
+		for (i = 0; i <= TPG_COLOR_CSC_BLACK; i++) {
+			double r, g, b;
+
+			if (colorspaces[c] == 0)
+				continue;
+
+			r = tpg_colors[i].r / 255.0;
+			g = tpg_colors[i].g / 255.0;
+			b = tpg_colors[i].b / 255.0;
+
+			csc(c, &r, &g, &b);
+
+			printf("\t[%s][%d] = { %d, %d, %d },\n", colorspace_names[c], i,
+				(int)(r * 4080), (int)(g * 4080), (int)(b * 4080));
+		}
+	}
+	printf("};\n\n");
+	return 0;
+}
+
+#endif
diff --git a/drivers/media/platform/vivi-colors.h b/drivers/media/platform/vivi-colors.h
new file mode 100644
index 0000000..d9c21bd
--- /dev/null
+++ b/drivers/media/platform/vivi-colors.h
@@ -0,0 +1,45 @@
+#ifndef _VIVI_COLORS_H_
+#define _VIVI_COLORS_H_
+
+struct color {
+	unsigned char r, g, b;
+};
+
+struct color16 {
+	int r, g, b;
+};
+
+enum tpg_color {
+	TPG_COLOR_CSC_WHITE,
+	TPG_COLOR_CSC_YELLOW,
+	TPG_COLOR_CSC_CYAN,
+	TPG_COLOR_CSC_GREEN,
+	TPG_COLOR_CSC_MAGENTA,
+	TPG_COLOR_CSC_RED,
+	TPG_COLOR_CSC_BLUE,
+	TPG_COLOR_CSC_BLACK,
+	TPG_COLOR_75_YELLOW,
+	TPG_COLOR_75_CYAN,
+	TPG_COLOR_75_GREEN,
+	TPG_COLOR_75_MAGENTA,
+	TPG_COLOR_75_RED,
+	TPG_COLOR_75_BLUE,
+	TPG_COLOR_100_WHITE,
+	TPG_COLOR_100_YELLOW,
+	TPG_COLOR_100_CYAN,
+	TPG_COLOR_100_GREEN,
+	TPG_COLOR_100_MAGENTA,
+	TPG_COLOR_100_RED,
+	TPG_COLOR_100_BLUE,
+	TPG_COLOR_100_BLACK,
+	TPG_COLOR_TEXTFG,
+	TPG_COLOR_TEXTBG,
+	TPG_COLOR_RANDOM,
+	TPG_COLOR_RAMP,
+	TPG_COLOR_MAX = TPG_COLOR_RAMP + 256
+};
+
+extern const struct color tpg_colors[TPG_COLOR_MAX];
+extern const struct color16 tpg_csc_colors[V4L2_COLORSPACE_SRGB + 1][TPG_COLOR_CSC_BLACK + 1];
+
+#endif
diff --git a/drivers/media/platform/vivi-core.c b/drivers/media/platform/vivi-core.c
new file mode 100644
index 0000000..af4b9f6
--- /dev/null
+++ b/drivers/media/platform/vivi-core.c
@@ -0,0 +1,3996 @@
+/*
+ * Virtual Video driver - This code emulates a real video device with v4l2 api
+ *
+ * Copyright (c) 2006 by:
+ *      Mauro Carvalho Chehab <mchehab--a.t--infradead.org>
+ *      Ted Walther <ted--a.t--enumera.com>
+ *      John Sokol <sokol--a.t--videotechnology.com>
+ *      http://v4l.videotechnology.com/
+ *
+ *      Conversion to videobuf2 by Pawel Osciak & Marek Szyprowski
+ *      Copyright (c) 2010 Samsung Electronics
+ *
+ * Major rewrite by Hans Verkuil making it behave like a real webcam,
+ * TV/S-Video capture board and HDMI capture board:
+ *	Copyright 2014 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the BSD Licence, GNU General Public License
+ * as published by the Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version
+ */
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/font.h>
+#include <linux/mutex.h>
+#include <linux/videodev2.h>
+#include <linux/kthread.h>
+#include <linux/freezer.h>
+#include <linux/random.h>
+#include <linux/v4l2-dv-timings.h>
+#include <media/videobuf2-vmalloc.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-fh.h>
+#include <media/v4l2-event.h>
+#include <media/v4l2-common.h>
+#include <media/v4l2-dv-timings.h>
+#include "vivi-tpg.h"
+
+#define VIVI_MODULE_NAME "vivi"
+
+/* Maximum allowed frame rate
+ *
+ * Vivi will allow setting timeperframe in [1/FPS_MAX - FPS_MAX/1] range.
+ *
+ * Ideally FPS_MAX should be infinity, i.e. practically UINT_MAX, but that
+ * might hit application errors when they manipulate these values.
+ *
+ * Besides, for tpf < 1ms image-generation logic should be changed, to avoid
+ * producing frames with equal content.
+ */
+#define FPS_MAX 1000
+
+/* The maximum number of vivi devices */
+#define VIVI_MAX_DEVS 64
+/* The maximum up or down scaling factor is 4 */
+#define MAX_ZOOM  4
+/* The maximum image width/height are set to 4K DMT */
+#define MAX_WIDTH  4096
+#define MAX_HEIGHT 2160
+/* The minimum image width/height */
+#define MIN_WIDTH  16
+#define MIN_HEIGHT 16
+/* The maximum number of clip rectangles */
+#define MAX_CLIPS  16
+/* The maximum number of inputs */
+#define MAX_INPUTS 16
+/* The supported frequency range */
+#define MIN_FREQ (44 * 16)
+#define MAX_FREQ (958 * 16)
+/* The data_offset of plane 0 for the multiplanar formats */
+#define PLANE0_DATA_OFFSET 128
+
+#define VIVI_VERSION "1.0.0"
+
+MODULE_DESCRIPTION("Video Technology Magazine Virtual Video Capture Board");
+MODULE_AUTHOR("Hans Verkuil, Mauro Carvalho Chehab, Ted Walther and John Sokol");
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_VERSION(VIVI_VERSION);
+
+static unsigned n_devs = 1;
+module_param(n_devs, uint, 0444);
+MODULE_PARM_DESC(n_devs, "number of video devices to create");
+
+static int video_nr[VIVI_MAX_DEVS] = { [0 ... (VIVI_MAX_DEVS - 1)] = -1 };
+module_param_array(video_nr, int, NULL, 0444);
+MODULE_PARM_DESC(video_nr, "videoX start number, -1 is autodetect");
+
+static int ccs_mode[VIVI_MAX_DEVS] = { [0 ... (VIVI_MAX_DEVS - 1)] = -1 };
+module_param_array(ccs_mode, int, NULL, 0444);
+MODULE_PARM_DESC(ccs_mode, "crop/compose/scale mode: bit 0=crop, 1=compose, 2=scale, -1=user-controlled (default)");
+
+static unsigned multiplanar[VIVI_MAX_DEVS];
+module_param_array(multiplanar, uint, NULL, 0444);
+MODULE_PARM_DESC(multiplanar, "0 (default) is alternating single and multiplanar devices, "
+			      "1 is single planar devices, 2 is multiplanar devices");
+
+static unsigned num_inputs[VIVI_MAX_DEVS] = { [0 ... (VIVI_MAX_DEVS - 1)] = 4 };
+module_param_array(num_inputs, uint, NULL, 0444);
+MODULE_PARM_DESC(num_inputs, "number of inputs, default is 4");
+
+/* Default: input 0 = WEBCAM, 1 = TV, 2 = SVID, 3 = HDMI */
+static unsigned input_types[VIVI_MAX_DEVS] = { [0 ... (VIVI_MAX_DEVS - 1)] = 0xe4 };
+module_param_array(input_types, uint, NULL, 0444);
+MODULE_PARM_DESC(input_types, "input types, default is 0xe4. Two bits per input, bits 0-1 == input 0, "
+			      "bits 31-30 == input 15. Type 0 == webcam, 1 == TV, 2 == S-Video, 3 == HDMI");
+
+static unsigned debug;
+module_param(debug, uint, 0644);
+MODULE_PARM_DESC(debug, "activates debug info");
+
+static bool no_error_inj;
+module_param(no_error_inj, bool, 0444);
+MODULE_PARM_DESC(no_error_inj, "if set disable the error injecting controls");
+
+/* timeperframe: min/max and default */
+static const struct v4l2_fract
+	tpf_min     = {.numerator = 1,		.denominator = FPS_MAX},
+	tpf_max     = {.numerator = FPS_MAX,	.denominator = 1},
+	tpf_default = {.numerator = 1,		.denominator = 30};
+
+#define dprintk(dev, level, fmt, arg...) \
+	v4l2_dbg(level, debug, &dev->v4l2_dev, fmt, ## arg)
+
+static const struct v4l2_dv_timings_cap vivi_dv_timings_cap = {
+	.type = V4L2_DV_BT_656_1120,
+	/* keep this initialization for compatibility with GCC < 4.4.6 */
+	.reserved = { 0 },
+	V4L2_INIT_BT_TIMINGS(0, MAX_WIDTH, 0, MAX_HEIGHT, 25000000, 600000000,
+		V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT,
+		V4L2_DV_BT_CAP_PROGRESSIVE | V4L2_DV_BT_CAP_INTERLACED)
+};
+
+/* ------------------------------------------------------------------
+	Basic structures
+   ------------------------------------------------------------------*/
+
+struct vivi_fmt {
+	const char *name;
+	u32   fourcc;          /* v4l2 format id */
+	u8    depth;
+	bool  is_yuv;
+	u8  planes;
+};
+
+static const struct vivi_fmt formats[] = {
+	{
+		.name     = "4:2:2, packed, YUYV",
+		.fourcc   = V4L2_PIX_FMT_YUYV,
+		.depth    = 16,
+		.is_yuv   = true,
+		.planes   = 1,
+	},
+	{
+		.name     = "4:2:2, packed, UYVY",
+		.fourcc   = V4L2_PIX_FMT_UYVY,
+		.depth    = 16,
+		.is_yuv   = true,
+		.planes   = 1,
+	},
+	{
+		.name     = "4:2:2, packed, YVYU",
+		.fourcc   = V4L2_PIX_FMT_YVYU,
+		.depth    = 16,
+		.is_yuv   = true,
+		.planes   = 1,
+	},
+	{
+		.name     = "4:2:2, packed, VYUY",
+		.fourcc   = V4L2_PIX_FMT_VYUY,
+		.depth    = 16,
+		.is_yuv   = true,
+		.planes   = 1,
+	},
+	{
+		.name     = "RGB565 (LE)",
+		.fourcc   = V4L2_PIX_FMT_RGB565, /* gggbbbbb rrrrrggg */
+		.depth    = 16,
+		.planes   = 1,
+	},
+	{
+		.name     = "RGB565 (BE)",
+		.fourcc   = V4L2_PIX_FMT_RGB565X, /* rrrrrggg gggbbbbb */
+		.depth    = 16,
+		.planes   = 1,
+	},
+	{
+		.name     = "RGB555 (LE)",
+		.fourcc   = V4L2_PIX_FMT_RGB555, /* gggbbbbb arrrrrgg */
+		.depth    = 16,
+		.planes   = 1,
+	},
+	{
+		.name     = "RGB555 (BE)",
+		.fourcc   = V4L2_PIX_FMT_RGB555X, /* arrrrrgg gggbbbbb */
+		.depth    = 16,
+		.planes   = 1,
+	},
+	{
+		.name     = "RGB24 (LE)",
+		.fourcc   = V4L2_PIX_FMT_RGB24, /* rgb */
+		.depth    = 24,
+		.planes   = 1,
+	},
+	{
+		.name     = "RGB24 (BE)",
+		.fourcc   = V4L2_PIX_FMT_BGR24, /* bgr */
+		.depth    = 24,
+		.planes   = 1,
+	},
+	{
+		.name     = "RGB32 (LE)",
+		.fourcc   = V4L2_PIX_FMT_RGB32, /* argb */
+		.depth    = 32,
+		.planes   = 1,
+	},
+	{
+		.name     = "RGB32 (BE)",
+		.fourcc   = V4L2_PIX_FMT_BGR32, /* bgra */
+		.depth    = 32,
+		.planes   = 1,
+	},
+	{
+		.name     = "4:2:2, planar, YUV",
+		.fourcc   = V4L2_PIX_FMT_NV16M,
+		.depth    = 8,
+		.is_yuv   = true,
+		.planes   = 2,
+	},
+	{
+		.name     = "4:2:2, planar, YVU",
+		.fourcc   = V4L2_PIX_FMT_NV61M,
+		.depth    = 8,
+		.is_yuv   = true,
+		.planes   = 2,
+	},
+};
+
+/* There are 2 multiplanar formats in the list */
+#define VIVI_MPLANAR_FORMATS 2
+
+static const struct vivi_fmt formats_ovl[] = {
+	{
+		.name     = "RGB565 (LE)",
+		.fourcc   = V4L2_PIX_FMT_RGB565, /* gggbbbbb rrrrrggg */
+		.depth    = 16,
+		.planes   = 1,
+	},
+	{
+		.name     = "RGB555 (LE)",
+		.fourcc   = V4L2_PIX_FMT_RGB555, /* gggbbbbb arrrrrgg */
+		.depth    = 16,
+		.planes   = 1,
+	},
+};
+
+/* Sizes must be in increasing order */
+static const struct v4l2_frmsize_discrete webcam_sizes[] = {
+	{  320, 180 },
+	{  640, 360 },
+	{ 1280, 720 },
+};
+
+static const struct v4l2_discrete_probe webcam_probe = {
+	webcam_sizes,
+	ARRAY_SIZE(webcam_sizes)
+};
+
+/*
+ * Intervals must be in increasing order and there must be twice as many
+ * elements in this array as there are in webcam_sizes.
+ */
+static const struct v4l2_fract webcam_intervals[] = {
+	{  1, 10 },
+	{  1, 15 },
+	{  1, 25 },
+	{  1, 30 },
+	{  1, 50 },
+	{  1, 60 },
+};
+
+static const u8 vivi_hdmi_edid[256] = {
+	0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00,
+	0x63, 0x3a, 0xaa, 0x55, 0x00, 0x00, 0x00, 0x00,
+	0x0a, 0x18, 0x01, 0x03, 0x80, 0x10, 0x09, 0x78,
+	0x0e, 0x00, 0xb2, 0xa0, 0x57, 0x49, 0x9b, 0x26,
+	0x10, 0x48, 0x4f, 0x2f, 0xcf, 0x00, 0x31, 0x59,
+	0x45, 0x59, 0x81, 0x80, 0x81, 0x40, 0x90, 0x40,
+	0x95, 0x00, 0xa9, 0x40, 0xb3, 0x00, 0x02, 0x3a,
+	0x80, 0x18, 0x71, 0x38, 0x2d, 0x40, 0x58, 0x2c,
+	0x46, 0x00, 0x10, 0x09, 0x00, 0x00, 0x00, 0x1e,
+	0x00, 0x00, 0x00, 0xfd, 0x00, 0x18, 0x55, 0x18,
+	0x5e, 0x11, 0x00, 0x0a, 0x20, 0x20, 0x20, 0x20,
+	0x20, 0x20, 0x00, 0x00, 0x00, 0xfc, 0x00,  'v',
+	'4',   'l',  '2',  '-',  'h',  'd',  'm',  'i',
+	0x0a, 0x0a, 0x0a, 0x0a, 0x00, 0x00, 0x00, 0x10,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0xf0,
+
+	0x02, 0x03, 0x1a, 0xc0, 0x48, 0xa2, 0x10, 0x04,
+	0x02, 0x01, 0x21, 0x14, 0x13, 0x23, 0x09, 0x07,
+	0x07, 0x65, 0x03, 0x0c, 0x00, 0x10, 0x00, 0xe2,
+	0x00, 0x2a, 0x01, 0x1d, 0x00, 0x80, 0x51, 0xd0,
+	0x1c, 0x20, 0x40, 0x80, 0x35, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x1e, 0x8c, 0x0a, 0xd0, 0x8a,
+	0x20, 0xe0, 0x2d, 0x10, 0x10, 0x3e, 0x96, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xd7
+};
+
+/* buffer for one video frame */
+struct vivi_buffer {
+	/* common v4l buffer stuff -- must be first */
+	struct vb2_buffer	vb;
+	struct list_head	list;
+};
+
+struct vivi_dmaqueue {
+	struct list_head       active;
+
+	/* thread for generating video stream*/
+	struct task_struct         *kthread;
+	wait_queue_head_t          wq;
+	/* Counters to control fps rate */
+	int                        frame;
+	int                        ini_jiffies;
+};
+
+static LIST_HEAD(vivi_devlist);
+
+enum vivi_input {
+	WEBCAM,
+	TV,
+	SVID,
+	HDMI,
+};
+
+enum vivi_signal_mode {
+	CURRENT_TIMINGS,
+	CURRENT_STD = CURRENT_TIMINGS,
+	NO_SIGNAL,
+	NO_LOCK,
+	OUT_OF_RANGE,
+	SELECTED_TIMINGS,
+	SELECTED_STD = SELECTED_TIMINGS,
+	CYCLE_TIMINGS,
+	CYCLE_STD = CYCLE_TIMINGS,
+	CUSTOM_TIMINGS,
+};
+
+struct vivi_dev {
+	struct list_head		vivi_devlist;
+	struct v4l2_device		v4l2_dev;
+	struct v4l2_ctrl_handler	ctrl_handler;
+	struct video_device		vdev;
+	bool				multiplanar;
+	unsigned			num_inputs;
+	u8				input_type[MAX_INPUTS];
+	u8				input_name_counter[MAX_INPUTS];
+	bool				have_audio_inputs;
+	bool				have_tuner;
+	bool				sensor_hflip;
+	bool				sensor_vflip;
+	bool				hflip;
+	bool				vflip;
+
+	/* controls */
+	struct v4l2_ctrl		*brightness;
+	struct v4l2_ctrl		*contrast;
+	struct v4l2_ctrl		*saturation;
+	struct v4l2_ctrl		*hue;
+	struct {
+		/* autogain/gain cluster */
+		struct v4l2_ctrl	*autogain;
+		struct v4l2_ctrl	*gain;
+	};
+	struct v4l2_ctrl		*volume;
+	struct v4l2_ctrl		*mute;
+	struct v4l2_ctrl		*alpha;
+	struct v4l2_ctrl		*button;
+	struct v4l2_ctrl		*boolean;
+	struct v4l2_ctrl		*int32;
+	struct v4l2_ctrl		*int64;
+	struct v4l2_ctrl		*menu;
+	struct v4l2_ctrl		*string;
+	struct v4l2_ctrl		*bitmask;
+	struct v4l2_ctrl		*int_menu;
+	struct v4l2_ctrl		*test_pattern;
+	struct v4l2_ctrl		*colorspace;
+	struct v4l2_ctrl		*rgb_range;
+	struct {
+		/* std_signal_mode/standard cluster */
+		struct v4l2_ctrl	*ctrl_std_signal_mode;
+		struct v4l2_ctrl	*ctrl_standard;
+	};
+	struct {
+		/* timings_signal_mode/timings cluster */
+		struct v4l2_ctrl	*ctrl_timings_signal_mode;
+		struct v4l2_ctrl	*ctrl_timings;
+	};
+	struct v4l2_ctrl		*ctrl_has_crop;
+	struct v4l2_ctrl		*ctrl_has_compose;
+	struct v4l2_ctrl		*ctrl_has_scaler;
+	unsigned			input_brightness[MAX_INPUTS];
+
+	/* Overlays */
+	struct v4l2_framebuffer		fb;
+	struct v4l2_fh			*overlay_owner;
+	void				*fb_vbase;
+	int				overlay_top, overlay_left;
+	void				*bitmap;
+	struct v4l2_clip		clips[MAX_CLIPS];
+	struct v4l2_clip		try_clips[MAX_CLIPS];
+	unsigned			clipcount;
+	enum v4l2_field			overlay_field;
+
+	spinlock_t			slock;
+	struct mutex			mutex;
+
+	struct vivi_dmaqueue		vidq;
+
+	/* Several counters */
+	unsigned			ms;
+	unsigned long			jiffies;
+	unsigned			button_pressed;
+
+	unsigned			osd_mode;
+	struct tpg_data			tpg;
+
+	/* Error injection */
+	bool				queue_setup_error;
+	bool				buf_prepare_error;
+	bool				start_streaming_error;
+	bool				dqbuf_error;
+	unsigned			perc_dropped_buffers;
+	enum vivi_signal_mode		std_signal_mode;
+	unsigned			query_std_last;
+	v4l2_std_id			query_std;
+	enum tpg_video_aspect		std_aspect_ratio;
+
+	enum vivi_signal_mode		timings_signal_mode;
+	char				**query_timings_qmenu;
+	unsigned			query_timings_size;
+	unsigned			query_timings_last;
+	unsigned			query_timings;
+	enum tpg_video_aspect		timings_aspect_ratio;
+
+	/* Input */
+	unsigned			input;
+	v4l2_std_id			std;
+	struct v4l2_dv_timings		dv_timings;
+	u8				*edid;
+	unsigned			edid_blocks;
+	unsigned			edid_max_blocks;
+	unsigned			webcam_size_idx;
+	unsigned			webcam_ival_idx;
+	unsigned			tv_freq;
+	unsigned			tv_audmode;
+	unsigned			tv_field;
+	unsigned			tv_audio_input;
+	bool				tstamp_src_is_soe;
+	bool				has_crop;
+	bool				has_compose;
+	bool				has_scaler;
+
+	/* video capture */
+	const struct vivi_fmt		*fmt;
+	struct v4l2_fract		timeperframe;
+	unsigned			width, height;
+	enum v4l2_field			field;
+	struct vb2_queue		vb_vidq;
+	bool				must_blank[VIDEO_MAX_FRAME];
+	unsigned			seq_count;
+	struct v4l2_rect		src_rect;
+	struct v4l2_rect		fmt_rect;
+	struct v4l2_rect		min_rect;
+	struct v4l2_rect		max_rect;
+	struct v4l2_rect		crop_bounds;
+};
+
+static const struct vivi_fmt *__get_format(struct vivi_dev *dev, u32 pixelformat)
+{
+	const struct vivi_fmt *fmt;
+	unsigned k;
+
+	for (k = 0; k < ARRAY_SIZE(formats); k++) {
+		fmt = &formats[k];
+		if (fmt->fourcc == pixelformat)
+			if (fmt->planes == 1 || dev->multiplanar)
+				return fmt;
+	}
+
+	return NULL;
+}
+
+static const struct vivi_fmt *get_format(struct vivi_dev *dev, struct v4l2_format *f)
+{
+	return __get_format(dev, f->fmt.pix.pixelformat);
+}
+
+/*
+ * Get the current picture quality and the associated afc value.
+ */
+static enum tpg_quality vivi_get_quality(struct vivi_dev *dev, s32 *afc)
+{
+	unsigned freq_modulus;
+
+	if (afc)
+		*afc = 0;
+	if (tpg_g_quality(&dev->tpg) == TPG_QUAL_COLOR ||
+	    tpg_g_quality(&dev->tpg) == TPG_QUAL_NOISE)
+		return tpg_g_quality(&dev->tpg);
+
+	/*
+	 * There is a fake channel every 6 MHz at 49.25, 55.25, etc.
+	 * From +/- 0.25 MHz around the channel there is color, and from
+	 * +/- 1 MHz there is grayscale (chroma is lost).
+	 * Everywhere else it is just gray.
+	 */
+	freq_modulus = (dev->tv_freq - 676 /* (43.25-1) * 16 */) % (6 * 16);
+	if (afc)
+		*afc = freq_modulus - 1 * 16;
+	return TPG_QUAL_GRAY;
+}
+
+static inline bool vivi_is_webcam(const struct vivi_dev *dev)
+{
+	return dev->input_type[dev->input] == WEBCAM;
+}
+
+static inline bool vivi_is_tv(const struct vivi_dev *dev)
+{
+	return dev->input_type[dev->input] == TV;
+}
+
+static inline bool vivi_is_svid(const struct vivi_dev *dev)
+{
+	return dev->input_type[dev->input] == SVID;
+}
+
+static inline bool vivi_is_hdmi(const struct vivi_dev *dev)
+{
+	return dev->input_type[dev->input] == HDMI;
+}
+
+static inline bool vivi_is_sdtv(const struct vivi_dev *dev)
+{
+	return vivi_is_tv(dev) || vivi_is_svid(dev);
+}
+
+/*
+ * Determine the 'picture' quality based on the current TV frequency: either
+ * COLOR for a good 'signal', GRAY (grayscale picture) for a slightly off
+ * signal or NOISE for no signal.
+ */
+static void vivi_update_quality(struct vivi_dev *dev)
+{
+	unsigned freq_modulus;
+
+	if (!vivi_is_tv(dev)) {
+		tpg_s_quality(&dev->tpg, TPG_QUAL_COLOR, 0);
+		return;
+	}
+
+	/*
+	 * There is a fake channel every 6 MHz at 49.25, 55.25, etc.
+	 * From +/- 0.25 MHz around the channel there is color, and from
+	 * +/- 1 MHz there is grayscale (chroma is lost).
+	 * Everywhere else it is just noise.
+	 */
+	freq_modulus = (dev->tv_freq - 676 /* (43.25-1) * 16 */) % (6 * 16);
+	if (freq_modulus > 2 * 16) {
+		tpg_s_quality(&dev->tpg, TPG_QUAL_NOISE,
+			next_pseudo_random32(dev->tv_freq ^ 0x55) & 0x3f);
+		return;
+	}
+	if (freq_modulus < 12 /*0.75 * 16*/ || freq_modulus > 20 /*1.25 * 16*/)
+		tpg_s_quality(&dev->tpg, TPG_QUAL_GRAY, 0);
+	else
+		tpg_s_quality(&dev->tpg, TPG_QUAL_COLOR, 0);
+}
+
+static inline v4l2_std_id vivi_get_std(const struct vivi_dev *dev)
+{
+	if (vivi_is_sdtv(dev))
+		return dev->std;
+	return 0;
+}
+
+static inline enum tpg_video_aspect vivi_get_video_aspect(const struct vivi_dev *dev)
+{
+	if (vivi_is_sdtv(dev))
+		return dev->std_aspect_ratio;
+
+	if (vivi_is_hdmi(dev))
+		return dev->timings_aspect_ratio;
+
+	return TPG_VIDEO_ASPECT_IMAGE;
+}
+
+static inline enum tpg_pixel_aspect vivi_get_pixel_aspect(const struct vivi_dev *dev)
+{
+	if (vivi_is_sdtv(dev))
+		return (dev->std & V4L2_STD_525_60) ?
+			TPG_PIXEL_ASPECT_NTSC : TPG_PIXEL_ASPECT_PAL;
+
+	if (vivi_is_hdmi(dev) &&
+	    dev->width == 720 && dev->height <= 576)
+		return dev->height == 480 ?
+			TPG_PIXEL_ASPECT_NTSC : TPG_PIXEL_ASPECT_PAL;
+
+	return TPG_PIXEL_ASPECT_SQUARE;
+}
+
+/* ------------------------------------------------------------------
+	DMA and thread functions
+   ------------------------------------------------------------------*/
+
+static void vivi_fillbuff(struct vivi_dev *dev, struct vivi_buffer *buf)
+{
+	unsigned line_height = V4L2_FIELD_HAS_T_OR_B(dev->field) ? 8 : 16;
+	bool is_tv = vivi_is_sdtv(dev);
+	bool is_60hz = is_tv && (dev->std & V4L2_STD_525_60);
+	unsigned p;
+	int line = 1;
+	u8 *basep[TPG_MAX_PLANES][2];
+	unsigned ms;
+	char str[100];
+	s32 gain;
+
+	buf->vb.v4l2_buf.sequence = dev->seq_count++;
+	/*
+	 * Take the timestamp now if the timestamp source is set to
+	 * "Start of Exposure".
+	 */
+	if (dev->tstamp_src_is_soe)
+		v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
+	if (dev->field == V4L2_FIELD_ALTERNATE) {
+		/*
+		 * 60 Hz standards start with the bottom field, 50 Hz standards
+		 * with the top field. So if the 0-based seq_count is even,
+		 * then the field is TOP for 50 Hz and BOTTOM for 60 Hz
+		 * standards.
+		 */
+		buf->vb.v4l2_buf.field = ((dev->seq_count & 1) ^ is_60hz) ?
+			V4L2_FIELD_TOP : V4L2_FIELD_BOTTOM;
+		/*
+		 * The sequence counter counts frames, not fields. So divide
+		 * by two.
+		 */
+		buf->vb.v4l2_buf.sequence /= 2;
+	} else {
+		buf->vb.v4l2_buf.field = dev->field;
+	}
+	tpg_s_field(&dev->tpg, buf->vb.v4l2_buf.field);
+
+	for (p = 0; p < tpg_g_planes(&dev->tpg); p++) {
+		void *vbuf = vb2_plane_vaddr(&buf->vb, p);
+
+		/*
+		 * The first plane of a multiplanar format has a non-zero
+		 * data_offset. This helps testing whether the application
+		 * correctly supports non-zero data offsets.
+		 */
+		if (tpg_g_planes(&dev->tpg) > 1 && p == 0) {
+			memset(vbuf, PLANE0_DATA_OFFSET, PLANE0_DATA_OFFSET);
+			vbuf += PLANE0_DATA_OFFSET;
+		}
+		tpg_fillbuffer(&dev->tpg, basep, vivi_get_std(dev), p, vbuf);
+	}
+
+	/* Updates stream time, only update at the start of a new frame. */
+	if (dev->field != V4L2_FIELD_ALTERNATE || (buf->vb.v4l2_buf.sequence & 1) == 0) {
+		dev->ms += jiffies_to_msecs(jiffies - dev->jiffies);
+		dev->jiffies = jiffies;
+	}
+
+	ms = dev->ms;
+	if (dev->osd_mode <= 1) {
+		snprintf(str, sizeof(str), " %02d:%02d:%02d:%03d %u%s",
+				(ms / (60 * 60 * 1000)) % 24,
+				(ms / (60 * 1000)) % 60,
+				(ms / 1000) % 60,
+				ms % 1000,
+				buf->vb.v4l2_buf.sequence,
+				(dev->field == V4L2_FIELD_ALTERNATE) ?
+					(buf->vb.v4l2_buf.field == V4L2_FIELD_TOP ?
+					 " top" : " bottom") : "");
+		tpg_gen_text(&dev->tpg, basep, line++ * line_height, 16, str);
+	}
+	if (dev->osd_mode == 0) {
+		snprintf(str, sizeof(str), " %dx%d, input %d ",
+				dev->width, dev->height, dev->input);
+		tpg_gen_text(&dev->tpg, basep, line++ * line_height, 16, str);
+
+		gain = v4l2_ctrl_g_ctrl(dev->gain);
+		mutex_lock(dev->ctrl_handler.lock);
+		snprintf(str, sizeof(str),
+			" brightness %3d, contrast %3d, saturation %3d, hue %d ",
+			dev->brightness->cur.val,
+			dev->contrast->cur.val,
+			dev->saturation->cur.val,
+			dev->hue->cur.val);
+		tpg_gen_text(&dev->tpg, basep, line++ * line_height, 16, str);
+		snprintf(str, sizeof(str),
+			" autogain %d, gain %3d, volume %3d, mute %d, alpha 0x%02x ",
+			dev->autogain->cur.val, gain, dev->volume->cur.val,
+			dev->mute->cur.val, dev->alpha->cur.val);
+		tpg_gen_text(&dev->tpg, basep, line++ * line_height, 16, str);
+		snprintf(str, sizeof(str), " int32 %d, int64 %lld, bitmask %08x ",
+			dev->int32->cur.val,
+			dev->int64->cur.val64,
+			dev->bitmask->cur.val);
+		tpg_gen_text(&dev->tpg, basep, line++ * line_height, 16, str);
+		snprintf(str, sizeof(str), " boolean %d, menu %s, string \"%s\" ",
+			dev->boolean->cur.val,
+			dev->menu->qmenu[dev->menu->cur.val],
+			dev->string->cur.string);
+		tpg_gen_text(&dev->tpg, basep, line++ * line_height, 16, str);
+		snprintf(str, sizeof(str), " integer_menu %lld, value %d ",
+			dev->int_menu->qmenu_int[dev->int_menu->cur.val],
+			dev->int_menu->cur.val);
+		tpg_gen_text(&dev->tpg, basep, line++ * line_height, 16, str);
+		mutex_unlock(dev->ctrl_handler.lock);
+		if (dev->button_pressed) {
+			dev->button_pressed--;
+			snprintf(str, sizeof(str), " button pressed!");
+			tpg_gen_text(&dev->tpg, basep, line++ * line_height, 16, str);
+		}
+	}
+
+	/*
+	 * If "End of Frame" is specified at the timestamp source, then take
+	 * the timestamp now.
+	 */
+	if (!dev->tstamp_src_is_soe)
+		v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
+}
+
+/*
+ * Return true if this pixel coordinate is a valid video pixel.
+ */
+static bool valid_pix(struct vivi_dev *dev, int win_y, int win_x, int fb_y, int fb_x)
+{
+	int i;
+
+	if (dev->bitmap) {
+		/*
+		 * Only if the corresponding bit in the bitmap is set can
+		 * the video pixel be shown. Coordinates are relative to
+		 * the overlay window set by VIDIOC_S_FMT.
+		 */
+		const u8 *p = dev->bitmap;
+		unsigned stride = (dev->width + 7) / 8;
+
+		if (!(p[stride * win_y + win_x / 8] & (1 << (win_x & 7))))
+			return false;
+	}
+
+	for (i = 0; i < dev->clipcount; i++) {
+		/*
+		 * Only if the framebuffer coordinate is not in any of the
+		 * clip rectangles will be video pixel be shown.
+		 */
+		struct v4l2_rect *r = &dev->clips[i].c;
+
+		if (fb_y >= r->top && fb_y < r->top + r->height &&
+				fb_x >= r->left && fb_x < r->left + r->width)
+			return false;
+	}
+	return true;
+}
+
+/*
+ * Draw the image into the overlay buffer.
+ * Note that the combination of overlay and multiplanar is not supported.
+ */
+static void vivi_overlay(struct vivi_dev *dev, struct vivi_buffer *buf)
+{
+	unsigned pixsize = tpg_g_twopixelsize(&dev->tpg, 0) / 2;
+	void *vbase = dev->fb_vbase;
+	void *vbuf = vb2_plane_vaddr(&buf->vb, 0);
+	struct tpg_data *tpg = &dev->tpg;
+	unsigned img_width = tpg->compose.width;
+	unsigned img_height = tpg->compose.height;
+	unsigned stride = tpg->bytesperline[0];
+	/* if quick is true, then valid_pix() doesn't have to be called */
+	bool quick = dev->bitmap == NULL && dev->clipcount == 0;
+	int x, y, w, out_x = 0;
+
+	if ((dev->overlay_field == V4L2_FIELD_TOP ||
+	     dev->overlay_field == V4L2_FIELD_BOTTOM) &&
+	    dev->overlay_field != buf->vb.v4l2_buf.field)
+		return;
+
+	vbuf += tpg->compose.left * pixsize;
+	x = dev->overlay_left;
+	w = img_width;
+	if (x < 0) {
+		out_x = -x;
+		w = w - out_x;
+		x = 0;
+	} else {
+		w = dev->fb.fmt.width - x;
+		if (w > img_width)
+			w = img_width;
+	}
+	if (w <= 0)
+		return;
+	if (dev->overlay_top >= 0)
+		vbase += dev->overlay_top * dev->fb.fmt.bytesperline;
+	for (y = dev->overlay_top;
+	     y < dev->overlay_top + (int)img_height;
+	     y++, vbuf += stride) {
+		int px;
+
+		if (y < 0 || y > dev->fb.fmt.height)
+			continue;
+		if (quick) {
+			memcpy(vbase + x * pixsize,
+			       vbuf + out_x * pixsize, w * pixsize);
+			vbase += dev->fb.fmt.bytesperline;
+			continue;
+		}
+		for (px = 0; px < w; px++) {
+			if (!valid_pix(dev, y - dev->overlay_top,
+				       px + out_x, y, px + x))
+				continue;
+			memcpy(vbase + (px + x) * pixsize,
+			       vbuf + (px + out_x) * pixsize,
+			       pixsize);
+		}
+		vbase += dev->fb.fmt.bytesperline;
+	}
+}
+
+static void vivi_thread_tick(struct vivi_dev *dev)
+{
+	struct vivi_dmaqueue *dma_q = &dev->vidq;
+	struct vivi_buffer *buf;
+
+	dprintk(dev, 1, "Thread tick\n");
+
+	/* Drop a certain percentage of buffers. */
+	if (dev->perc_dropped_buffers &&
+	    prandom_u32_max(100) < dev->perc_dropped_buffers) {
+		dev->seq_count++;
+		goto update_mv;
+	}
+	spin_lock(&dev->slock);
+	if (list_empty(&dma_q->active)) {
+		dprintk(dev, 1, "No active queue to serve\n");
+		spin_unlock(&dev->slock);
+		return;
+	}
+
+	buf = list_entry(dma_q->active.next, struct vivi_buffer, list);
+	list_del(&buf->list);
+	spin_unlock(&dev->slock);
+
+	tpg_s_perc_fill_blank(&dev->tpg, dev->must_blank[buf->vb.v4l2_buf.index]);
+	dev->must_blank[buf->vb.v4l2_buf.index] = false;
+
+	/* Fill buffer */
+	vivi_fillbuff(dev, buf);
+	dprintk(dev, 1, "filled buffer %p\n", buf);
+
+	/* Handle overlay */
+	if (dev->overlay_owner && dev->fb.base &&
+	    dev->fb.fmt.pixelformat == dev->fmt->fourcc)
+		vivi_overlay(dev, buf);
+
+	vb2_buffer_done(&buf->vb, dev->dqbuf_error ?
+			VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
+	dev->dqbuf_error = false;
+	dprintk(dev, 2, "[%p/%d] done\n", buf, buf->vb.v4l2_buf.index);
+
+update_mv:
+	/* Update the test pattern movement counters */
+	tpg_update_mv_count(&dev->tpg, dev->field == V4L2_FIELD_NONE ||
+				       dev->field == V4L2_FIELD_ALTERNATE);
+}
+
+
+static void vivi_sleep(struct vivi_dev *dev)
+{
+	struct vivi_dmaqueue *dma_q = &dev->vidq;
+	int timeout;
+	DECLARE_WAITQUEUE(wait, current);
+	unsigned ms;
+
+	dprintk(dev, 1, "%s dma_q=0x%08lx\n", __func__,
+		(unsigned long)dma_q);
+
+	add_wait_queue(&dma_q->wq, &wait);
+	if (kthread_should_stop())
+		goto stop_task;
+
+	/* Calculate time to wake up */
+	ms = (dev->timeperframe.numerator * 1000UL) / dev->timeperframe.denominator;
+	if (dev->field == V4L2_FIELD_ALTERNATE)
+		ms /= 2;
+	timeout = msecs_to_jiffies(ms);
+
+	mutex_lock(&dev->mutex);
+	vivi_thread_tick(dev);
+	mutex_unlock(&dev->mutex);
+
+	schedule_timeout_interruptible(timeout);
+
+stop_task:
+	remove_wait_queue(&dma_q->wq, &wait);
+	try_to_freeze();
+}
+
+static int vivi_thread(void *data)
+{
+	struct vivi_dev *dev = data;
+
+	dprintk(dev, 1, "thread started\n");
+
+	set_freezable();
+
+	for (;;) {
+		vivi_sleep(dev);
+
+		if (kthread_should_stop())
+			break;
+	}
+	dprintk(dev, 1, "thread: exit\n");
+	return 0;
+}
+
+static void vivi_grab_controls(struct vivi_dev *dev, bool grab)
+{
+	v4l2_ctrl_grab(dev->ctrl_has_crop, grab);
+	v4l2_ctrl_grab(dev->ctrl_has_compose, grab);
+	v4l2_ctrl_grab(dev->ctrl_has_scaler, grab);
+}
+
+static int vivi_start_generating(struct vivi_dev *dev)
+{
+	struct vivi_dmaqueue *dma_q = &dev->vidq;
+
+	dprintk(dev, 1, "%s\n", __func__);
+
+	/* Resets frame counters */
+	dev->ms = 0;
+	tpg_init_mv_count(&dev->tpg);
+	dev->jiffies = jiffies;
+
+	dma_q->frame = 0;
+	dma_q->ini_jiffies = jiffies;
+	dma_q->kthread = kthread_run(vivi_thread, dev, "%s",
+				     dev->v4l2_dev.name);
+
+	if (IS_ERR(dma_q->kthread)) {
+		v4l2_err(&dev->v4l2_dev, "kernel_thread() failed\n");
+		return PTR_ERR(dma_q->kthread);
+	}
+	vivi_grab_controls(dev, true);
+	/* Wakes thread */
+	wake_up_interruptible(&dma_q->wq);
+
+	dprintk(dev, 1, "returning from %s\n", __func__);
+	return 0;
+}
+
+static void vivi_stop_generating(struct vivi_dev *dev)
+{
+	struct vivi_dmaqueue *dma_q = &dev->vidq;
+
+	dprintk(dev, 1, "%s\n", __func__);
+
+	/* shutdown control thread */
+	if (dma_q->kthread) {
+		vivi_grab_controls(dev, false);
+		kthread_stop(dma_q->kthread);
+		dma_q->kthread = NULL;
+	}
+
+	/*
+	 * Typical driver might need to wait here until dma engine stops.
+	 * In this case we can abort imiedetly, so it's just a noop.
+	 */
+
+	/* Release all active buffers */
+	while (!list_empty(&dma_q->active)) {
+		struct vivi_buffer *buf;
+
+		buf = list_entry(dma_q->active.next, struct vivi_buffer, list);
+		list_del(&buf->list);
+		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		dprintk(dev, 2, "[%p/%d] done\n", buf, buf->vb.v4l2_buf.index);
+	}
+}
+
+typedef int (*fmtfunc)(struct file *file, void *priv, struct v4l2_format *f);
+
+/*
+ * Conversion function that converts a single-planar format to a
+ * single-plane multiplanar format.
+ */
+static void fmt_sp2mp(const struct v4l2_format *sp_fmt,
+		      struct v4l2_format *mp_fmt)
+{
+	struct v4l2_pix_format_mplane *mp = &mp_fmt->fmt.pix_mp;
+	struct v4l2_plane_pix_format *ppix = &mp->plane_fmt[0];
+	const struct v4l2_pix_format *pix = &sp_fmt->fmt.pix;
+	bool is_out = sp_fmt->type == V4L2_BUF_TYPE_VIDEO_OUTPUT;
+
+	memset(mp->reserved, 0, sizeof(mp->reserved));
+	mp_fmt->type = is_out ? V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE :
+			   V4L2_CAP_VIDEO_CAPTURE_MPLANE;
+	mp->width = pix->width;
+	mp->height = pix->height;
+	mp->pixelformat = pix->pixelformat;
+	mp->field = pix->field;
+	mp->colorspace = pix->colorspace;
+	mp->num_planes = 1;
+	ppix->sizeimage = pix->sizeimage;
+	ppix->bytesperline = pix->bytesperline;
+	memset(ppix->reserved, 0, sizeof(ppix->reserved));
+}
+
+static int fmt_sp2mp_func(struct file *file, void *priv,
+		struct v4l2_format *f, fmtfunc func)
+{
+	struct v4l2_format fmt;
+	struct v4l2_pix_format_mplane *mp = &fmt.fmt.pix_mp;
+	struct v4l2_plane_pix_format *ppix = &mp->plane_fmt[0];
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	int ret;
+
+	/* Converts to a mplane format */
+	fmt_sp2mp(f, &fmt);
+	/* Passes it to the generic mplane format function */
+	ret = func(file, priv, &fmt);
+	/* Copies back the mplane data to the single plane format */
+	pix->width = mp->width;
+	pix->height = mp->height;
+	pix->pixelformat = mp->pixelformat;
+	pix->field = mp->field;
+	pix->colorspace = mp->colorspace;
+	pix->sizeimage = ppix->sizeimage;
+	pix->bytesperline = ppix->bytesperline;
+	pix->priv = 0;
+	return ret;
+}
+
+/* ------------------------------------------------------------------
+	Videobuf operations
+   ------------------------------------------------------------------*/
+
+static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+		       unsigned *nbuffers, unsigned *nplanes,
+		       unsigned sizes[], void *alloc_ctxs[])
+{
+	struct vivi_dev *dev = vb2_get_drv_priv(vq);
+	unsigned planes = tpg_g_planes(&dev->tpg);
+	unsigned h = dev->fmt_rect.height;
+	unsigned size = tpg_g_bytesperline(&dev->tpg, 0) * h;
+
+	if (dev->queue_setup_error) {
+		/*
+		 * Error injection: test what happens if queue_setup() returns
+		 * an error.
+		 */
+		dev->queue_setup_error = false;
+		return -EINVAL;
+	}
+	if (fmt) {
+		const struct v4l2_pix_format_mplane *mp;
+		struct v4l2_format mp_fmt;
+
+		if (!V4L2_TYPE_IS_MULTIPLANAR(fmt->type)) {
+			fmt_sp2mp(fmt, &mp_fmt);
+			fmt = &mp_fmt;
+		}
+		mp = &fmt->fmt.pix_mp;
+		/*
+		 * Check if the number of planes in the specified format match
+		 * the number of planes in the current format. You can't mix that.
+		 */
+		if (mp->num_planes != planes)
+			return -EINVAL;
+		sizes[0] = mp->plane_fmt[0].sizeimage;
+		if (planes == 2) {
+			sizes[1] = mp->plane_fmt[1].sizeimage;
+			if (sizes[0] < tpg_g_bytesperline(&dev->tpg, 0) * h + PLANE0_DATA_OFFSET ||
+			    sizes[1] < tpg_g_bytesperline(&dev->tpg, 1) * h)
+				return -EINVAL;
+		} else if (sizes[0] < size) {
+			return -EINVAL;
+		}
+	} else {
+		if (planes == 2) {
+			/*
+			 * The first plane of a multiplanar format has a non-zero
+			 * data_offset to help testing such uncommon formats.
+			 */
+			sizes[0] = tpg_g_bytesperline(&dev->tpg, 0) * h + PLANE0_DATA_OFFSET;
+			sizes[1] = tpg_g_bytesperline(&dev->tpg, 1) * h;
+		} else {
+			sizes[0] = size;
+		}
+	}
+
+	if (vq->num_buffers + *nbuffers < 2)
+		*nbuffers = 2 - vq->num_buffers;
+
+	*nplanes = planes;
+
+	/*
+	 * videobuf2-vmalloc allocator is context-less so no need to set
+	 * alloc_ctxs array.
+	 */
+
+	if (planes == 2)
+		dprintk(dev, 1, "%s, count=%d, sizes=%u, %u\n", __func__,
+			*nbuffers, sizes[0], sizes[1]);
+	else
+		dprintk(dev, 1, "%s, count=%d, size=%u\n", __func__,
+			*nbuffers, sizes[0]);
+
+	return 0;
+}
+
+static int buf_prepare(struct vb2_buffer *vb)
+{
+	struct vivi_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+	unsigned long size0, size1;
+	unsigned planes = tpg_g_planes(&dev->tpg);
+
+	dprintk(dev, 1, "%s\n", __func__);
+
+	if (WARN_ON(NULL == dev->fmt))
+		return -EINVAL;
+
+	if (dev->buf_prepare_error) {
+		/*
+		 * Error injection: test what happens if buf_prepare() returns
+		 * an error.
+		 */
+		dev->buf_prepare_error = false;
+		return -EINVAL;
+	}
+	size0 = tpg_g_bytesperline(&dev->tpg, 0) * dev->fmt_rect.height;
+	if (planes == 2) {
+		size1 = tpg_g_bytesperline(&dev->tpg, 1) * dev->fmt_rect.height;
+
+		if (vb2_plane_size(vb, 0) < size0 + PLANE0_DATA_OFFSET) {
+			dprintk(dev, 1, "%s data will not fit into plane 0 (%lu < %lu)\n",
+					__func__, vb2_plane_size(vb, 0), size0);
+			return -EINVAL;
+		}
+		if (vb2_plane_size(vb, 1) < size1) {
+			dprintk(dev, 1, "%s data will not fit into plane 1 (%lu < %lu)\n",
+					__func__, vb2_plane_size(vb, 1), size1);
+			return -EINVAL;
+		}
+
+		vb2_set_plane_payload(vb, 0, size0 + PLANE0_DATA_OFFSET);
+		vb->v4l2_planes[0].data_offset = PLANE0_DATA_OFFSET;
+		vb2_set_plane_payload(vb, 1, size1);
+	} else {
+		if (vb2_plane_size(vb, 0) < size0) {
+			dprintk(dev, 1, "%s data will not fit into plane (%lu < %lu)\n",
+					__func__, vb2_plane_size(vb, 0), size0);
+			return -EINVAL;
+		}
+		vb2_set_plane_payload(vb, 0, size0);
+	}
+
+	return 0;
+}
+
+static void buf_finish(struct vb2_buffer *vb)
+{
+	struct vivi_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct v4l2_timecode *tc = &vb->v4l2_buf.timecode;
+	unsigned fps = 25;
+	unsigned seq = vb->v4l2_buf.sequence;
+
+	if (!vivi_is_sdtv(dev))
+		return;
+
+	/*
+	 * Set the timecode. Rarely used, so it is interesting to
+	 * test this.
+	 */
+	vb->v4l2_buf.flags |= V4L2_BUF_FLAG_TIMECODE;
+	if (dev->std & V4L2_STD_525_60)
+		fps = 30;
+	tc->type = (fps == 30) ? V4L2_TC_TYPE_30FPS : V4L2_TC_TYPE_25FPS;
+	tc->flags = 0;
+	tc->frames = seq % fps;
+	tc->seconds = (seq / fps) % 60;
+	tc->minutes = (seq / (60 * fps)) % 60;
+	tc->hours = (seq / (60 * 60 * fps)) % 24;
+}
+
+static void buf_queue(struct vb2_buffer *vb)
+{
+	struct vivi_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct vivi_buffer *buf = container_of(vb, struct vivi_buffer, vb);
+	struct vivi_dmaqueue *vidq = &dev->vidq;
+
+	dprintk(dev, 1, "%s\n", __func__);
+
+	spin_lock(&dev->slock);
+	list_add_tail(&buf->list, &vidq->active);
+	spin_unlock(&dev->slock);
+}
+
+static int start_streaming(struct vb2_queue *vq, unsigned count)
+{
+	struct vivi_dev *dev = vb2_get_drv_priv(vq);
+	unsigned i;
+	int err;
+
+	dprintk(dev, 1, "%s\n", __func__);
+	dev->seq_count = 0;
+	for (i = 0; i < VIDEO_MAX_FRAME; i++)
+		dev->must_blank[i] = tpg_g_perc_fill(&dev->tpg) < 100;
+	if (dev->start_streaming_error) {
+		dev->start_streaming_error = false;
+		err = -EINVAL;
+	} else {
+		err = vivi_start_generating(dev);
+	}
+	if (err) {
+		struct vivi_buffer *buf, *tmp;
+
+		list_for_each_entry_safe(buf, tmp, &dev->vidq.active, list) {
+			list_del(&buf->list);
+			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+		}
+	}
+	return err;
+}
+
+/* abort streaming and wait for last buffer */
+static void stop_streaming(struct vb2_queue *vq)
+{
+	struct vivi_dev *dev = vb2_get_drv_priv(vq);
+
+	dprintk(dev, 1, "%s\n", __func__);
+	vivi_stop_generating(dev);
+}
+
+static void vivi_lock(struct vb2_queue *vq)
+{
+	struct vivi_dev *dev = vb2_get_drv_priv(vq);
+
+	mutex_lock(&dev->mutex);
+}
+
+static void vivi_unlock(struct vb2_queue *vq)
+{
+	struct vivi_dev *dev = vb2_get_drv_priv(vq);
+
+	mutex_unlock(&dev->mutex);
+}
+
+
+static const struct vb2_ops vivi_video_qops = {
+	.queue_setup		= queue_setup,
+	.buf_prepare		= buf_prepare,
+	.buf_finish		= buf_finish,
+	.buf_queue		= buf_queue,
+	.start_streaming	= start_streaming,
+	.stop_streaming		= stop_streaming,
+	.wait_prepare		= vivi_unlock,
+	.wait_finish		= vivi_lock,
+};
+
+/* ------------------------------------------------------------------
+	IOCTL vidioc handling
+   ------------------------------------------------------------------*/
+static int vidioc_querycap(struct file *file, void  *priv,
+					struct v4l2_capability *cap)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+
+	strcpy(cap->driver, "vivi");
+	strcpy(cap->card, "vivi");
+	snprintf(cap->bus_info, sizeof(cap->bus_info),
+			"platform:%s", dev->v4l2_dev.name);
+	cap->device_caps = dev->multiplanar ?  V4L2_CAP_VIDEO_CAPTURE_MPLANE :
+		V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OVERLAY;
+	cap->device_caps |= V4L2_CAP_STREAMING  | V4L2_CAP_READWRITE;
+	if (dev->have_tuner)
+		cap->device_caps |= V4L2_CAP_TUNER;
+	if (dev->have_audio_inputs)
+		cap->device_caps |= V4L2_CAP_AUDIO;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
+	return 0;
+}
+
+/* Map the field to something that is valid for the current input */
+static enum v4l2_field vivi_field(struct vivi_dev *dev, enum v4l2_field field)
+{
+	if (vivi_is_sdtv(dev)) {
+		switch (field) {
+		case V4L2_FIELD_INTERLACED_TB:
+		case V4L2_FIELD_INTERLACED_BT:
+		case V4L2_FIELD_SEQ_TB:
+		case V4L2_FIELD_SEQ_BT:
+		case V4L2_FIELD_TOP:
+		case V4L2_FIELD_BOTTOM:
+		case V4L2_FIELD_ALTERNATE:
+			return field;
+		case V4L2_FIELD_INTERLACED:
+		default:
+			return V4L2_FIELD_INTERLACED;
+		}
+	}
+	if (vivi_is_hdmi(dev))
+		return dev->dv_timings.bt.interlaced ? V4L2_FIELD_ALTERNATE :
+						       V4L2_FIELD_NONE;
+	return V4L2_FIELD_NONE;
+}
+
+/*
+ * Called whenever the format has to be reset which can occur when
+ * changing inputs, standard, timings, etc.
+ */
+static void update_format(struct vivi_dev *dev, bool keep_controls)
+{
+	struct v4l2_bt_timings *bt = &dev->dv_timings.bt;
+	unsigned size;
+
+	switch (dev->input_type[dev->input]) {
+	case WEBCAM:
+	default:
+		dev->width = webcam_sizes[dev->webcam_size_idx].width;
+		dev->height = webcam_sizes[dev->webcam_size_idx].height;
+		dev->timeperframe = webcam_intervals[dev->webcam_ival_idx];
+		dev->field = V4L2_FIELD_NONE;
+		tpg_s_rgb_range(&dev->tpg, V4L2_DV_RGB_RANGE_AUTO);
+		break;
+	case TV:
+	case SVID:
+		dev->field = dev->tv_field;
+		dev->width = 720;
+		if (dev->std & V4L2_STD_525_60) {
+			dev->height = 480;
+			dev->timeperframe = (struct v4l2_fract) { 1001, 30000 };
+		} else {
+			dev->height = 576;
+			dev->timeperframe = (struct v4l2_fract) { 1000, 25000 };
+		}
+		tpg_s_rgb_range(&dev->tpg, V4L2_DV_RGB_RANGE_AUTO);
+		break;
+	case HDMI:
+		dev->width = bt->width;
+		dev->height = bt->height;
+		size = V4L2_DV_BT_FRAME_WIDTH(bt) * V4L2_DV_BT_FRAME_HEIGHT(bt);
+		dev->timeperframe = (struct v4l2_fract) { size, bt->pixelclock };
+		if (bt->interlaced)
+			dev->field = V4L2_FIELD_ALTERNATE;
+		else
+			dev->field = V4L2_FIELD_NONE;
+
+		/*
+		 * We can be called from within s_ctrl, in that case we can't
+		 * set/get controls. Luckily we don't need to in that case.
+		 */
+		if (keep_controls)
+			break;
+		if (dev->width == 720 && dev->height <= 576)
+			v4l2_ctrl_s_ctrl(dev->colorspace, V4L2_COLORSPACE_SMPTE170M);
+		else
+			v4l2_ctrl_s_ctrl(dev->colorspace, V4L2_COLORSPACE_REC709);
+		tpg_s_rgb_range(&dev->tpg, v4l2_ctrl_g_ctrl(dev->rgb_range));
+		break;
+	}
+	vivi_update_quality(dev);
+	tpg_reset_source(&dev->tpg, dev->width, dev->height, dev->field);
+	dev->src_rect.width = dev->width;
+	dev->src_rect.height = dev->height;
+	dev->crop_bounds = dev->src_rect;
+	dev->fmt_rect = *tpg_g_compose(&dev->tpg);
+	tpg_s_video_aspect(&dev->tpg, vivi_get_video_aspect(dev));
+	tpg_s_pixel_aspect(&dev->tpg, vivi_get_pixel_aspect(dev));
+	tpg_update_mv_step(&dev->tpg);
+}
+
+/* v4l2_rect helper function: copy the width/height values */
+static void rect_set_size_to(struct v4l2_rect *r, const struct v4l2_rect *size)
+{
+	r->width = size->width;
+	r->height = size->height;
+}
+
+/* v4l2_rect helper function: width and height of r should be >= min_size */
+static void rect_set_min_size(struct v4l2_rect *r, const struct v4l2_rect *min_size)
+{
+	if (r->width < min_size->width)
+		r->width = min_size->width;
+	if (r->height < min_size->height)
+		r->height = min_size->height;
+}
+
+/* v4l2_rect helper function: width and height of r should be <= max_size */
+static void rect_set_max_size(struct v4l2_rect *r, const struct v4l2_rect *max_size)
+{
+	if (r->width > max_size->width)
+		r->width = max_size->width;
+	if (r->height > max_size->height)
+		r->height = max_size->height;
+}
+
+/* v4l2_rect helper function: r should be inside boundary */
+static void rect_map_inside(struct v4l2_rect *r, const struct v4l2_rect *boundary)
+{
+	rect_set_max_size(r, boundary);
+	if (r->left < boundary->left)
+		r->left = boundary->left;
+	if (r->top < boundary->top)
+		r->top = boundary->top;
+	if (r->left + r->width > boundary->width)
+		r->left = boundary->width - r->width;
+	if (r->top + r->height > boundary->height)
+		r->top = boundary->height - r->height;
+}
+
+/* v4l2_rect helper function: return true if r1 has the same size as r2 */
+static bool rect_same_size(const struct v4l2_rect *r1, const struct v4l2_rect *r2)
+{
+	return r1->width == r2->width && r1->height == r2->height;
+}
+
+static int vivi_enum_fmt_vid_cap(struct file *file, void  *priv,
+					struct v4l2_fmtdesc *f)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+	const struct vivi_fmt *fmt;
+
+	if (f->index >= ARRAY_SIZE(formats) -
+	    (dev->multiplanar ? 0 : VIVI_MPLANAR_FORMATS))
+		return -EINVAL;
+
+	fmt = &formats[f->index];
+
+	strlcpy(f->description, fmt->name, sizeof(f->description));
+	f->pixelformat = fmt->fourcc;
+	return 0;
+}
+
+static int vivi_g_fmt_vid_cap(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+	struct v4l2_pix_format_mplane *mp = &f->fmt.pix_mp;
+
+	mp->width        = dev->fmt_rect.width;
+	mp->height       = dev->fmt_rect.height;
+	mp->field        = dev->field;
+	mp->pixelformat  = dev->fmt->fourcc;
+	mp->colorspace   = tpg_g_colorspace(&dev->tpg);
+	mp->num_planes = dev->fmt->planes;
+	if (mp->num_planes == 2) {
+		mp->plane_fmt[0].bytesperline = tpg_g_bytesperline(&dev->tpg, 0);
+		mp->plane_fmt[0].sizeimage =
+			mp->plane_fmt[0].bytesperline * mp->height + PLANE0_DATA_OFFSET;
+		mp->plane_fmt[1].bytesperline = tpg_g_bytesperline(&dev->tpg, 1);
+		mp->plane_fmt[1].sizeimage = mp->plane_fmt[1].bytesperline * mp->height;
+	} else {
+		mp->plane_fmt[0].bytesperline = tpg_g_bytesperline(&dev->tpg, 0);
+		mp->plane_fmt[0].sizeimage = mp->plane_fmt[0].bytesperline * mp->height;
+	}
+	return 0;
+}
+
+static int vivi_try_fmt_vid_cap(struct file *file, void *priv,
+			struct v4l2_format *f)
+{
+	struct v4l2_pix_format_mplane *mp = &f->fmt.pix_mp;
+	struct v4l2_plane_pix_format *pfmt = mp->plane_fmt;
+	struct vivi_dev *dev = video_drvdata(file);
+	const struct vivi_fmt *fmt;
+	unsigned bytesperline, max_bpl;
+	unsigned factor = 1;
+	unsigned w, h;
+	unsigned p;
+
+	fmt = get_format(dev, f);
+	if (!fmt) {
+		dprintk(dev, 1, "Fourcc format (0x%08x) unknown.\n",
+			mp->pixelformat);
+		mp->pixelformat = V4L2_PIX_FMT_YUYV;
+		fmt = get_format(dev, f);
+	}
+
+	mp->field = vivi_field(dev, mp->field);
+	if (vivi_is_webcam(dev)) {
+		const struct v4l2_frmsize_discrete *sz =
+			v4l2_find_nearest_format(&webcam_probe, mp->width, mp->height);
+
+		w = sz->width;
+		h = sz->height;
+	} else if (vivi_is_sdtv(dev)) {
+		w = 720;
+		h = (dev->std & V4L2_STD_525_60) ? 480 : 576;
+	} else {
+		w = dev->width;
+		h = dev->height;
+	}
+	if (V4L2_FIELD_HAS_T_OR_B(mp->field))
+		factor = 2;
+	if (vivi_is_webcam(dev) || (!dev->has_scaler && !dev->has_crop && !dev->has_compose)) {
+		mp->width = w;
+		mp->height = h / factor;
+	} else {
+		struct v4l2_rect max_r = { 0, 0, MAX_ZOOM * MAX_WIDTH, MAX_ZOOM * MAX_HEIGHT };
+		struct v4l2_rect r = { 0, 0, mp->width, mp->height * factor };
+
+		rect_set_min_size(&r, &dev->min_rect);
+		rect_set_max_size(&r, &max_r);
+		if (dev->has_scaler && !dev->has_compose) {
+			max_r.width = MAX_ZOOM * w;
+			max_r.height = MAX_ZOOM * h;
+			rect_set_max_size(&r, &max_r);
+		} else if (!dev->has_scaler && dev->has_crop && !dev->has_compose) {
+			rect_set_max_size(&r, &dev->src_rect);
+		} else if (!dev->has_scaler && !dev->has_crop) {
+			rect_set_min_size(&r, &dev->src_rect);
+		}
+		mp->width = r.width;
+		mp->height = r.height / factor;
+	}
+
+	/* This driver supports custom bytesperline values */
+
+	/* Calculate the minimum supported bytesperline value */
+	bytesperline = (mp->width * fmt->depth) >> 3;
+	/* Calculate the maximum supported bytesperline value */
+	max_bpl = (MAX_ZOOM * MAX_WIDTH * fmt->depth) >> 3;
+	mp->num_planes = fmt->planes;
+	if (mp->num_planes == 2) {
+		if (pfmt[0].bytesperline > max_bpl)
+			pfmt[0].bytesperline = max_bpl;
+		if (pfmt[0].bytesperline < bytesperline)
+			pfmt[0].bytesperline = bytesperline;
+		pfmt[0].sizeimage = pfmt[0].bytesperline * mp->height + PLANE0_DATA_OFFSET;
+		if (pfmt[1].bytesperline > MAX_ZOOM * MAX_WIDTH)
+			pfmt[1].bytesperline = MAX_ZOOM * MAX_WIDTH;
+		if (pfmt[1].bytesperline < mp->width)
+			pfmt[1].bytesperline = mp->width;
+		pfmt[1].sizeimage = pfmt[1].bytesperline * mp->height;
+	} else {
+		if (pfmt[0].bytesperline > max_bpl)
+			pfmt[0].bytesperline = max_bpl;
+		if (pfmt[0].bytesperline < bytesperline)
+			pfmt[0].bytesperline = bytesperline;
+		pfmt[0].sizeimage = pfmt[0].bytesperline * mp->height;
+	}
+	for (p = 0; p < mp->num_planes; p++)
+		memset(pfmt[p].reserved, 0, sizeof(pfmt[p].reserved));
+	mp->colorspace = tpg_g_colorspace(&dev->tpg);
+	memset(mp->reserved, 0, sizeof(mp->reserved));
+	return 0;
+}
+
+static int vivi_s_fmt_vid_cap(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	struct v4l2_pix_format_mplane *mp = &f->fmt.pix_mp;
+	struct vivi_dev *dev = video_drvdata(file);
+	struct v4l2_rect *crop = tpg_g_crop(&dev->tpg);
+	struct v4l2_rect *compose = tpg_g_compose(&dev->tpg);
+	struct vb2_queue *q = &dev->vb_vidq;
+	int ret = vivi_try_fmt_vid_cap(file, priv, f);
+	unsigned factor = 1;
+	unsigned i;
+
+	if (ret < 0)
+		return ret;
+
+	if (vb2_is_busy(q)) {
+		dprintk(dev, 1, "%s device busy\n", __func__);
+		return -EBUSY;
+	}
+
+	if (dev->overlay_owner && dev->fb.fmt.pixelformat != mp->pixelformat) {
+		dprintk(dev, 1, "overlay is active, can't change pixelformat\n");
+		return -EBUSY;
+	}
+
+	dev->fmt = get_format(dev, f);
+	if (V4L2_FIELD_HAS_T_OR_B(mp->field))
+		factor = 2;
+
+	/* Note: the webcam input doesn't support scaling, cropping or composing */
+
+	if (!vivi_is_webcam(dev) && (dev->has_scaler || dev->has_crop || dev->has_compose)) {
+		struct v4l2_rect r = { 0, 0, mp->width, mp->height };
+
+		if (dev->has_scaler) {
+			if (dev->has_compose)
+				rect_map_inside(compose, &r);
+			else
+				*compose = r;
+			if (dev->has_crop && !dev->has_compose) {
+				struct v4l2_rect min_r = {
+					0, 0,
+					r.width / MAX_ZOOM,
+					factor * r.height / MAX_ZOOM
+				};
+
+				rect_set_min_size(crop, &min_r);
+				rect_map_inside(crop, &dev->crop_bounds);
+			} else if (dev->has_crop) {
+				struct v4l2_rect min_r = {
+					0, 0,
+					compose->width / MAX_ZOOM,
+					factor * compose->height / MAX_ZOOM
+				};
+
+				rect_set_min_size(crop, &min_r);
+				rect_map_inside(crop, &dev->crop_bounds);
+			}
+		} else if (dev->has_crop && !dev->has_compose) {
+			r.height *= factor;
+			rect_set_size_to(crop, &r);
+			rect_map_inside(crop, &dev->crop_bounds);
+		} else if (!dev->has_crop) {
+			rect_map_inside(compose, &r);
+		} else {
+			r.height *= factor;
+			rect_set_max_size(crop, &r);
+			rect_map_inside(crop, &dev->crop_bounds);
+			compose->top *= factor;
+			compose->height *= factor;
+			rect_set_size_to(compose, crop);
+			rect_map_inside(compose, &r);
+			compose->top /= factor;
+			compose->height /= factor;
+		}
+	}
+	if (vivi_is_webcam(dev)) {
+		/* Guaranteed to be a match */
+		for (i = 0; i < ARRAY_SIZE(webcam_sizes); i++)
+			if (webcam_sizes[i].width == mp->width &&
+					webcam_sizes[i].height == mp->height)
+				break;
+		dev->webcam_size_idx = i;
+		if (dev->webcam_ival_idx >= 2 * (3 - i))
+			dev->webcam_ival_idx = 2 * (3 - i) - 1;
+		update_format(dev, false);
+	}
+
+	dev->fmt_rect.width = mp->width;
+	dev->fmt_rect.height = mp->height;
+	tpg_s_buf_height(&dev->tpg, mp->height);
+	tpg_s_bytesperline(&dev->tpg, 0, mp->plane_fmt[0].bytesperline);
+	if (tpg_g_planes(&dev->tpg) > 1)
+		tpg_s_bytesperline(&dev->tpg, 1, mp->plane_fmt[1].bytesperline);
+	dev->field = mp->field;
+	tpg_s_field(&dev->tpg, dev->field);
+	tpg_s_crop_compose(&dev->tpg);
+	tpg_s_fourcc(&dev->tpg, dev->fmt->fourcc);
+	if (vivi_is_sdtv(dev))
+		dev->tv_field = mp->field;
+	tpg_update_mv_step(&dev->tpg);
+	return 0;
+}
+
+static int vidioc_enum_fmt_vid_cap_mplane(struct file *file, void  *priv,
+					struct v4l2_fmtdesc *f)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+
+	if (!dev->multiplanar)
+		return -ENOTTY;
+	return vivi_enum_fmt_vid_cap(file, priv, f);
+}
+
+static int vidioc_g_fmt_vid_cap_mplane(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+
+	if (!dev->multiplanar)
+		return -ENOTTY;
+	return vivi_g_fmt_vid_cap(file, priv, f);
+}
+
+static int vidioc_try_fmt_vid_cap_mplane(struct file *file, void *priv,
+			struct v4l2_format *f)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+
+	if (!dev->multiplanar)
+		return -ENOTTY;
+	return vivi_try_fmt_vid_cap(file, priv, f);
+}
+
+static int vidioc_s_fmt_vid_cap_mplane(struct file *file, void *priv,
+			struct v4l2_format *f)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+
+	if (!dev->multiplanar)
+		return -ENOTTY;
+	return vivi_s_fmt_vid_cap(file, priv, f);
+}
+
+static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
+					struct v4l2_fmtdesc *f)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+
+	if (dev->multiplanar)
+		return -ENOTTY;
+	return vivi_enum_fmt_vid_cap(file, priv, f);
+}
+
+static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+
+	if (dev->multiplanar)
+		return -ENOTTY;
+	return fmt_sp2mp_func(file, priv, f, vivi_g_fmt_vid_cap);
+}
+
+static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
+			struct v4l2_format *f)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+
+	if (dev->multiplanar)
+		return -ENOTTY;
+	return fmt_sp2mp_func(file, priv, f, vivi_try_fmt_vid_cap);
+}
+
+static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
+			struct v4l2_format *f)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+
+	if (dev->multiplanar)
+		return -ENOTTY;
+	return fmt_sp2mp_func(file, priv, f, vivi_s_fmt_vid_cap);
+}
+
+static int adjust_sel(unsigned flags, struct v4l2_rect *r)
+{
+	unsigned w = r->width;
+	unsigned h = r->height;
+
+	if (!(flags & V4L2_SEL_FLAG_LE)) {
+		w++;
+		h++;
+		if (w < 2)
+			w = 2;
+		if (h < 2)
+			h = 2;
+	}
+	if (!(flags & V4L2_SEL_FLAG_GE)) {
+		if (w > MAX_WIDTH)
+			w = MAX_WIDTH;
+		if (h > MAX_HEIGHT)
+			h = MAX_HEIGHT;
+	}
+	w = w & ~1;
+	h = h & ~1;
+	if (w < 2 || h < 2)
+		return -ERANGE;
+	if (w > MAX_WIDTH || h > MAX_HEIGHT)
+		return -ERANGE;
+	if (r->top < 0)
+		r->top = 0;
+	if (r->left < 0)
+		r->left = 0;
+	r->left &= ~1;
+	r->top &= ~1;
+	if (r->left + w > MAX_WIDTH)
+		r->left = MAX_WIDTH - w;
+	if (r->top + h > MAX_HEIGHT)
+		r->top = MAX_HEIGHT - h;
+	if ((flags & (V4L2_SEL_FLAG_GE | V4L2_SEL_FLAG_LE)) ==
+			(V4L2_SEL_FLAG_GE | V4L2_SEL_FLAG_LE) &&
+	    (r->width != w || r->height != h))
+		return -ERANGE;
+	r->width = w;
+	r->height = h;
+	return 0;
+}
+
+static int vidioc_g_selection(struct file *file, void *priv,
+			      struct v4l2_selection *sel)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+	struct v4l2_rect *crop = tpg_g_crop(&dev->tpg);
+	struct v4l2_rect *compose = tpg_g_compose(&dev->tpg);
+
+	if (!dev->has_crop && !dev->has_compose)
+		return -ENOTTY;
+	if (sel->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+	if (vivi_is_webcam(dev))
+		return -EINVAL;
+
+	sel->r.left = sel->r.top = 0;
+	switch (sel->target) {
+	case V4L2_SEL_TGT_CROP:
+		if (!dev->has_crop)
+			return -EINVAL;
+		sel->r = *crop;
+		break;
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+		if (!dev->has_crop)
+			return -EINVAL;
+		sel->r.width = dev->width;
+		sel->r.height = dev->height;
+		break;
+	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
+		if (!dev->has_compose)
+			return -EINVAL;
+		sel->r.width = MAX_WIDTH * MAX_ZOOM;
+		sel->r.height = MAX_HEIGHT * MAX_ZOOM;
+		if (V4L2_FIELD_HAS_T_OR_B(dev->field))
+			sel->r.height /= 2;
+		break;
+	case V4L2_SEL_TGT_COMPOSE:
+		if (!dev->has_compose)
+			return -EINVAL;
+		sel->r = *compose;
+		break;
+	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
+		if (!dev->has_compose)
+			return -EINVAL;
+		sel->r.width = dev->fmt_rect.width;
+		sel->r.height = dev->fmt_rect.height;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int vidioc_s_selection(struct file *file, void *fh, struct v4l2_selection *s)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+	struct v4l2_rect *crop = tpg_g_crop(&dev->tpg);
+	struct v4l2_rect *compose = tpg_g_compose(&dev->tpg);
+	unsigned factor = V4L2_FIELD_HAS_T_OR_B(dev->field) ? 2 : 1;
+	int ret;
+
+	if (!dev->has_crop && !dev->has_compose)
+		return -ENOTTY;
+	if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+	if (vivi_is_webcam(dev))
+		return -EINVAL;
+
+	switch (s->target) {
+	case V4L2_SEL_TGT_CROP:
+		if (!dev->has_crop)
+			return -EINVAL;
+		ret = adjust_sel(s->flags, &s->r);
+		if (ret)
+			return ret;
+		rect_set_min_size(&s->r, &dev->min_rect);
+		rect_set_max_size(&s->r, &dev->src_rect);
+		rect_map_inside(&s->r, &dev->crop_bounds);
+		s->r.top /= factor;
+		s->r.height /= factor;
+		if (dev->has_scaler) {
+			struct v4l2_rect fmt = dev->fmt_rect;
+			struct v4l2_rect max_rect = {
+				0, 0,
+				s->r.width * MAX_ZOOM,
+				s->r.height * MAX_ZOOM
+			};
+			struct v4l2_rect min_rect = {
+				0, 0,
+				s->r.width / MAX_ZOOM,
+				s->r.height / MAX_ZOOM
+			};
+
+			rect_set_min_size(&fmt, &min_rect);
+			if (!dev->has_compose)
+				rect_set_max_size(&fmt, &max_rect);
+			if (!rect_same_size(&dev->fmt_rect, &fmt) && vb2_is_busy(&dev->vb_vidq))
+				return -EBUSY;
+			if (dev->has_compose) {
+				rect_set_min_size(compose, &min_rect);
+				rect_set_max_size(compose, &max_rect);
+			}
+			dev->fmt_rect = fmt;
+			tpg_s_buf_height(&dev->tpg, fmt.height);
+		} else if (dev->has_compose) {
+			struct v4l2_rect fmt = dev->fmt_rect;
+
+			rect_set_min_size(&fmt, &s->r);
+			if (!rect_same_size(&dev->fmt_rect, &fmt) && vb2_is_busy(&dev->vb_vidq))
+				return -EBUSY;
+			dev->fmt_rect = fmt;
+			tpg_s_buf_height(&dev->tpg, fmt.height);
+			rect_set_size_to(compose, &s->r);
+			rect_map_inside(compose, &dev->fmt_rect);
+		} else {
+			if (!rect_same_size(&s->r, &dev->fmt_rect) && vb2_is_busy(&dev->vb_vidq))
+				return -EBUSY;
+			rect_set_size_to(&dev->fmt_rect, &s->r);
+			tpg_s_buf_height(&dev->tpg, dev->fmt_rect.height);
+		}
+		s->r.top *= factor;
+		s->r.height *= factor;
+		*crop = s->r;
+		break;
+	case V4L2_SEL_TGT_COMPOSE:
+		if (!dev->has_compose)
+			return -EINVAL;
+		ret = adjust_sel(s->flags, &s->r);
+		if (ret)
+			return ret;
+		rect_set_min_size(&s->r, &dev->min_rect);
+		rect_set_max_size(&s->r, &dev->fmt_rect);
+		if (dev->has_scaler) {
+			struct v4l2_rect max_rect = {
+				0, 0,
+				dev->src_rect.width * MAX_ZOOM,
+				(dev->src_rect.height / factor) * MAX_ZOOM
+			};
+
+			rect_set_max_size(&s->r, &max_rect);
+			if (dev->has_crop) {
+				struct v4l2_rect min_rect = {
+					0, 0,
+					s->r.width / MAX_ZOOM,
+					(s->r.height * factor) / MAX_ZOOM
+				};
+
+				rect_set_min_size(crop, &min_rect);
+				rect_map_inside(crop, &dev->crop_bounds);
+			}
+		} else if (dev->has_crop) {
+			s->r.top *= factor;
+			s->r.height *= factor;
+			rect_set_max_size(&s->r, &dev->src_rect);
+			rect_set_size_to(crop, &s->r);
+			rect_map_inside(crop, &dev->crop_bounds);
+			s->r.top /= factor;
+			s->r.height /= factor;
+		} else {
+			rect_set_size_to(&s->r, &dev->src_rect);
+			s->r.height /= factor;
+		}
+		rect_map_inside(&s->r, &dev->fmt_rect);
+		*compose = s->r;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	tpg_s_crop_compose(&dev->tpg);
+	return 0;
+}
+
+static int vidioc_cropcap(struct file *file, void *priv,
+			      struct v4l2_cropcap *cap)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+
+	if (cap->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	switch (vivi_get_pixel_aspect(dev)) {
+	case TPG_PIXEL_ASPECT_NTSC:
+		cap->pixelaspect.numerator = 11;
+		cap->pixelaspect.denominator = 10;
+		break;
+	case TPG_PIXEL_ASPECT_PAL:
+		cap->pixelaspect.numerator = 54;
+		cap->pixelaspect.denominator = 59;
+		break;
+	case TPG_PIXEL_ASPECT_SQUARE:
+		cap->pixelaspect.numerator = 1;
+		cap->pixelaspect.denominator = 1;
+		break;
+	}
+	return 0;
+}
+
+static int vidioc_enum_fmt_vid_overlay(struct file *file, void  *priv,
+					struct v4l2_fmtdesc *f)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+	const struct vivi_fmt *fmt;
+
+	if (dev->multiplanar)
+		return -ENOTTY;
+
+	if (f->index >= ARRAY_SIZE(formats_ovl))
+		return -EINVAL;
+
+	fmt = &formats_ovl[f->index];
+
+	strlcpy(f->description, fmt->name, sizeof(f->description));
+	f->pixelformat = fmt->fourcc;
+	return 0;
+}
+
+static int vidioc_g_fmt_vid_overlay(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+	struct v4l2_rect *compose = tpg_g_compose(&dev->tpg);
+	struct v4l2_window *win = &f->fmt.win;
+	unsigned clipcount = win->clipcount;
+
+	if (dev->multiplanar)
+		return -ENOTTY;
+
+	win->w.top = dev->overlay_top;
+	win->w.left = dev->overlay_left;
+	win->w.width = compose->width;
+	win->w.height = compose->height;
+	win->field = dev->overlay_field;
+	win->clipcount = dev->clipcount;
+	if (clipcount > dev->clipcount)
+		clipcount = dev->clipcount;
+	if (dev->bitmap == NULL)
+		win->bitmap = NULL;
+	else if (win->bitmap) {
+		if (copy_to_user(win->bitmap, dev->bitmap,
+		    ((dev->width + 7) / 8) * compose->height))
+			return -EFAULT;
+	}
+	if (clipcount && win->clips) {
+		if (copy_to_user(win->clips, dev->clips,
+				 clipcount * sizeof(dev->clips[0])))
+			return -EFAULT;
+	}
+	return 0;
+}
+
+static bool rect_overlap(const struct v4l2_rect *r1, const struct v4l2_rect *r2)
+{
+	/*
+	 * IF the left side of r1 is to the right of the right side of r2 OR
+	 *    the left side of r2 is to the right of the right side of r1 THEN
+	 * they do not overlap.
+	 */
+	if (r1->left >= r2->left + r2->width ||
+	    r2->left >= r1->left + r1->width)
+		return false;
+	/*
+	 * IF the top side of r1 is below the bottom of r2 OR
+	 *    the top side of r2 is below the bottom of r1 THEN
+	 * they do not overlap.
+	 */
+	if (r1->top >= r2->top + r2->height ||
+	    r2->top >= r1->top + r1->height)
+		return false;
+	return true;
+}
+
+static int vidioc_try_fmt_vid_overlay(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+	struct v4l2_rect *compose = tpg_g_compose(&dev->tpg);
+	struct v4l2_window *win = &f->fmt.win;
+	int i, j;
+
+	if (dev->multiplanar)
+		return -ENOTTY;
+
+	win->w.left = clamp_t(int, win->w.left,
+			      -dev->fb.fmt.width, dev->fb.fmt.width);
+	win->w.top = clamp_t(int, win->w.top,
+			     -dev->fb.fmt.height, dev->fb.fmt.height);
+	win->w.width = compose->width;
+	win->w.height = compose->height;
+	if (win->field != V4L2_FIELD_BOTTOM && win->field != V4L2_FIELD_TOP)
+		win->field = V4L2_FIELD_ANY;
+	win->chromakey = 0;
+	win->global_alpha = 0;
+	if (win->clipcount && !win->clips)
+		win->clipcount = 0;
+	if (win->clipcount > MAX_CLIPS)
+		win->clipcount = MAX_CLIPS;
+	if (win->clipcount) {
+		if (copy_from_user(dev->try_clips, win->clips,
+				   win->clipcount * sizeof(dev->clips[0])))
+			return -EFAULT;
+		for (i = 0; i < win->clipcount; i++) {
+			struct v4l2_rect *r = &dev->try_clips[i].c;
+
+			r->top = clamp_t(s32, r->top, 0, dev->fb.fmt.height - 1);
+			r->height = clamp_t(s32, r->height, 1, dev->fb.fmt.height - r->top);
+			r->left = clamp_t(u32, r->left, 0, dev->fb.fmt.width - 1);
+			r->width = clamp_t(u32, r->width, 1, dev->fb.fmt.width - r->left);
+		}
+		/*
+		 * Yeah, so sue me, it's an O(n^2) algorithm. But n is a small
+		 * number and it's typically a one-time deal.
+		 */
+		for (i = 0; i < win->clipcount - 1; i++) {
+			struct v4l2_rect *r1 = &dev->try_clips[i].c;
+
+			for (j = i + 1; j < win->clipcount; j++) {
+				struct v4l2_rect *r2 = &dev->try_clips[j].c;
+
+				if (rect_overlap(r1, r2))
+					return -EINVAL;
+			}
+		}
+		if (copy_to_user(win->clips, dev->try_clips,
+				 win->clipcount * sizeof(dev->clips[0])))
+			return -EFAULT;
+	}
+	return 0;
+}
+
+static int vidioc_s_fmt_vid_overlay(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+	struct v4l2_rect *compose = tpg_g_compose(&dev->tpg);
+	struct v4l2_window *win = &f->fmt.win;
+	int ret = vidioc_try_fmt_vid_overlay(file, priv, f);
+	unsigned bitmap_size = ((compose->width + 7) / 8) * compose->height;
+	unsigned clips_size = win->clipcount * sizeof(dev->clips[0]);
+	void *new_bitmap = NULL;
+
+	if (ret)
+		return ret;
+
+	if (win->bitmap) {
+		new_bitmap = vzalloc(bitmap_size);
+
+		if (new_bitmap == NULL)
+			return -ENOMEM;
+		if (copy_from_user(new_bitmap, win->bitmap, bitmap_size)) {
+			vfree(new_bitmap);
+			return -EFAULT;
+		}
+	}
+
+	dev->overlay_top = win->w.top;
+	dev->overlay_left = win->w.left;
+	dev->overlay_field = win->field;
+	vfree(dev->bitmap);
+	dev->bitmap = new_bitmap;
+	dev->clipcount = win->clipcount;
+	if (dev->clipcount)
+		memcpy(dev->clips, dev->try_clips, clips_size);
+	return 0;
+}
+
+static int vidioc_overlay(struct file *file, void *fh, unsigned i)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+
+	if (dev->multiplanar)
+		return -ENOTTY;
+
+	if (i && dev->fb_vbase == NULL)
+		return -EINVAL;
+
+	if (i && dev->fb.fmt.pixelformat != dev->fmt->fourcc) {
+		dprintk(dev, 1, "mismatch between overlay and video capture pixelformats\n");
+		return -EINVAL;
+	}
+
+	if (dev->overlay_owner && dev->overlay_owner != fh)
+		return -EBUSY;
+	dev->overlay_owner = i ? fh : NULL;
+	return 0;
+}
+
+static int vidioc_g_fbuf(struct file *file, void *fh,
+				struct v4l2_framebuffer *a)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+
+	if (dev->multiplanar)
+		return -ENOTTY;
+
+	*a = dev->fb;
+	a->capability = V4L2_FBUF_CAP_BITMAP_CLIPPING |
+			V4L2_FBUF_CAP_LIST_CLIPPING;
+	a->flags = V4L2_FBUF_FLAG_PRIMARY;
+	a->fmt.field = V4L2_FIELD_NONE;
+	a->fmt.colorspace = V4L2_COLORSPACE_SRGB;
+	a->fmt.priv = 0;
+	return 0;
+}
+
+static int vidioc_s_fbuf(struct file *file, void *fh,
+				const struct v4l2_framebuffer *a)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+	const struct vivi_fmt *fmt;
+
+	if (dev->multiplanar)
+		return -ENOTTY;
+
+	if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RAWIO))
+		return -EPERM;
+
+	if (dev->overlay_owner)
+		return -EBUSY;
+
+	if (a->base == NULL) {
+		dev->fb.base = NULL;
+		dev->fb_vbase = NULL;
+		return 0;
+	}
+
+	if (a->fmt.width < 48 || a->fmt.height < 32)
+		return -EINVAL;
+	fmt = __get_format(dev, a->fmt.pixelformat);
+	if (!fmt)
+		return -EINVAL;
+	if (a->fmt.bytesperline < (a->fmt.width * fmt->depth) / 8)
+		return -EINVAL;
+	if (a->fmt.height * a->fmt.bytesperline < a->fmt.sizeimage)
+		return -EINVAL;
+
+	dev->fb_vbase = phys_to_virt((unsigned long)a->base);
+	dev->fb = *a;
+	dev->overlay_left = clamp_t(int, dev->overlay_left,
+				    -dev->fb.fmt.width, dev->fb.fmt.width);
+	dev->overlay_top = clamp_t(int, dev->overlay_top,
+				   -dev->fb.fmt.height, dev->fb.fmt.height);
+	return 0;
+}
+
+static const struct v4l2_audio vivi_audio_inputs[] = {
+	{ 0, "TV", V4L2_AUDCAP_STEREO },
+	{ 1, "Line-In", V4L2_AUDCAP_STEREO },
+};
+
+/* only one input in this sample driver */
+static int vidioc_enum_input(struct file *file, void *priv,
+				struct v4l2_input *inp)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+
+	if (inp->index >= dev->num_inputs)
+		return -EINVAL;
+
+	inp->type = V4L2_INPUT_TYPE_CAMERA;
+	switch (dev->input_type[inp->index]) {
+	case WEBCAM:
+		snprintf(inp->name, sizeof(inp->name), "Webcam %u",
+				dev->input_name_counter[inp->index]);
+		inp->capabilities = 0;
+		break;
+	case TV:
+		snprintf(inp->name, sizeof(inp->name), "TV %u",
+				dev->input_name_counter[inp->index]);
+		inp->type = V4L2_INPUT_TYPE_TUNER;
+		inp->std = V4L2_STD_ALL;
+		if (dev->have_audio_inputs)
+			inp->audioset = (1 << ARRAY_SIZE(vivi_audio_inputs)) - 1;
+		inp->capabilities = V4L2_IN_CAP_STD;
+		break;
+	case SVID:
+		snprintf(inp->name, sizeof(inp->name), "S-Video %u",
+				dev->input_name_counter[inp->index]);
+		inp->std = V4L2_STD_ALL;
+		if (dev->have_audio_inputs)
+			inp->audioset = (1 << ARRAY_SIZE(vivi_audio_inputs)) - 1;
+		inp->capabilities = V4L2_IN_CAP_STD;
+		break;
+	case HDMI:
+		snprintf(inp->name, sizeof(inp->name), "HDMI %u",
+				dev->input_name_counter[inp->index]);
+		inp->capabilities = V4L2_IN_CAP_DV_TIMINGS;
+		if (dev->edid_blocks == 0 ||
+		    dev->timings_signal_mode == NO_SIGNAL)
+			inp->status |= V4L2_IN_ST_NO_SIGNAL;
+		else if (dev->timings_signal_mode == NO_LOCK ||
+			 dev->timings_signal_mode == OUT_OF_RANGE)
+			inp->status |= V4L2_IN_ST_NO_H_LOCK;
+		break;
+	}
+	if (dev->sensor_hflip)
+		inp->status |= V4L2_IN_ST_HFLIP;
+	if (dev->sensor_vflip)
+		inp->status |= V4L2_IN_ST_VFLIP;
+	if (dev->input == inp->index && vivi_is_sdtv(dev)) {
+		if (dev->std_signal_mode == NO_SIGNAL) {
+			inp->status |= V4L2_IN_ST_NO_SIGNAL;
+		} else if (dev->std_signal_mode == NO_LOCK) {
+			inp->status |= V4L2_IN_ST_NO_H_LOCK;
+		} else if (vivi_is_tv(dev)) {
+			switch (tpg_g_quality(&dev->tpg)) {
+			case TPG_QUAL_GRAY:
+				inp->status |= V4L2_IN_ST_COLOR_KILL;
+				break;
+			case TPG_QUAL_NOISE:
+				inp->status |= V4L2_IN_ST_NO_H_LOCK;
+				break;
+			default:
+				break;
+			}
+		}
+	}
+	return 0;
+}
+
+static int vidioc_g_input(struct file *file, void *priv, unsigned *i)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+
+	*i = dev->input;
+	return 0;
+}
+
+static int vidioc_s_input(struct file *file, void *priv, unsigned i)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+	unsigned brightness;
+
+	if (i >= dev->num_inputs)
+		return -EINVAL;
+
+	if (i == dev->input)
+		return 0;
+
+	if (vb2_is_busy(&dev->vb_vidq))
+		return -EBUSY;
+
+	dev->input = i;
+	dev->vdev.tvnorms = 0;
+	if (dev->input_type[i] == TV || dev->input_type[i] == SVID) {
+		dev->tv_audio_input = (dev->input_type[i] == TV) ? 0 : 1;
+		dev->vdev.tvnorms = V4L2_STD_ALL;
+	}
+	update_format(dev, false);
+
+	switch (dev->input_type[i]) {
+	case WEBCAM:
+		v4l2_ctrl_s_ctrl(dev->colorspace, V4L2_COLORSPACE_SRGB);
+		break;
+	case TV:
+	case SVID:
+		v4l2_ctrl_s_ctrl(dev->colorspace, V4L2_COLORSPACE_SMPTE170M);
+		break;
+	case HDMI:
+		if (dev->width == 720 && dev->height <= 576)
+			v4l2_ctrl_s_ctrl(dev->colorspace, V4L2_COLORSPACE_SMPTE170M);
+		else
+			v4l2_ctrl_s_ctrl(dev->colorspace, V4L2_COLORSPACE_REC709);
+		break;
+	}
+
+	/*
+	 * Modify the brightness range depending on the input.
+	 * This makes it easy to use vivi to test if applications can
+	 * handle control range modifications and is also how this is
+	 * typically used in practice as different inputs may be hooked
+	 * up to different receivers with different control ranges.
+	 */
+	brightness = 128 * i + dev->input_brightness[i];
+	v4l2_ctrl_modify_range(dev->brightness,
+			128 * i, 255 + 128 * i, 1, 127 + 128 * i);
+	v4l2_ctrl_s_ctrl(dev->brightness, brightness);
+	return 0;
+}
+
+static int vidioc_enumaudio(struct file *file, void *fh, struct v4l2_audio *vin)
+{
+	if (vin->index >= ARRAY_SIZE(vivi_audio_inputs))
+		return -EINVAL;
+	*vin = vivi_audio_inputs[vin->index];
+	return 0;
+}
+
+static int vidioc_g_audio(struct file *file, void *fh, struct v4l2_audio *vin)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+
+	if (!vivi_is_sdtv(dev))
+		return -EINVAL;
+	*vin = vivi_audio_inputs[dev->tv_audio_input];
+	return 0;
+}
+
+static int vidioc_s_audio(struct file *file, void *fh, const struct v4l2_audio *vin)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+
+	if (!vivi_is_sdtv(dev))
+		return -EINVAL;
+	if (vin->index >= ARRAY_SIZE(vivi_audio_inputs))
+		return -EINVAL;
+	dev->tv_audio_input = vin->index;
+	return 0;
+}
+
+static int vidioc_g_frequency(struct file *file, void *fh, struct v4l2_frequency *vf)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+
+	if (vf->tuner != 0)
+		return -EINVAL;
+	vf->frequency = dev->tv_freq;
+	return 0;
+}
+
+static int vidioc_s_frequency(struct file *file, void *fh, const struct v4l2_frequency *vf)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+
+	if (vf->tuner != 0)
+		return -EINVAL;
+	dev->tv_freq = clamp_t(unsigned, vf->frequency, MIN_FREQ, MAX_FREQ);
+	if (vivi_is_tv(dev))
+		vivi_update_quality(dev);
+	return 0;
+}
+
+static int vidioc_s_tuner(struct file *file, void *fh, const struct v4l2_tuner *vt)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+
+	if (vt->index != 0)
+		return -EINVAL;
+	if (vt->audmode > V4L2_TUNER_MODE_LANG1_LANG2)
+		return -EINVAL;
+	dev->tv_audmode = vt->audmode;
+	return 0;
+}
+
+static int vidioc_g_tuner(struct file *file, void *fh, struct v4l2_tuner *vt)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+	enum tpg_quality qual;
+
+	if (vt->index != 0)
+		return -EINVAL;
+
+	vt->capability = V4L2_TUNER_CAP_NORM | V4L2_TUNER_CAP_STEREO |
+			 V4L2_TUNER_CAP_LANG1 | V4L2_TUNER_CAP_LANG2;
+	vt->audmode = dev->tv_audmode;
+	vt->rangelow = MIN_FREQ;
+	vt->rangehigh = MAX_FREQ;
+	qual = vivi_get_quality(dev, &vt->afc);
+	if (qual == TPG_QUAL_COLOR)
+		vt->signal = 0xffff;
+	else if (qual == TPG_QUAL_GRAY)
+		vt->signal = 0x8000;
+	else
+		vt->signal = 0;
+	if (qual == TPG_QUAL_NOISE) {
+		vt->rxsubchans = 0;
+	} else if (qual == TPG_QUAL_GRAY) {
+		vt->rxsubchans = V4L2_TUNER_SUB_MONO;
+	} else {
+		unsigned channel_nr = dev->tv_freq / (6 * 16);
+		unsigned options = (dev->std & V4L2_STD_NTSC_M) ? 4 : 3;
+
+		switch (channel_nr % options) {
+		case 0:
+			vt->rxsubchans = V4L2_TUNER_SUB_MONO;
+			break;
+		case 1:
+			vt->rxsubchans = V4L2_TUNER_SUB_STEREO;
+			break;
+		case 2:
+			if (dev->std & V4L2_STD_NTSC_M)
+				vt->rxsubchans = V4L2_TUNER_SUB_MONO | V4L2_TUNER_SUB_SAP;
+			else
+				vt->rxsubchans = V4L2_TUNER_SUB_LANG1 | V4L2_TUNER_SUB_LANG2;
+			break;
+		case 3:
+			vt->rxsubchans = V4L2_TUNER_SUB_STEREO | V4L2_TUNER_SUB_SAP;
+			break;
+		}
+	}
+	strlcpy(vt->name, "TV Tuner", sizeof(vt->name));
+	return 0;
+}
+
+/* Must remain in sync with the vivi_ctrl_standard_strings array */
+static const v4l2_std_id vivi_standard[] = {
+	V4L2_STD_NTSC_M,
+	V4L2_STD_NTSC_M_JP,
+	V4L2_STD_NTSC_M_KR,
+	V4L2_STD_NTSC_443,
+	V4L2_STD_PAL_BG | V4L2_STD_PAL_H,
+	V4L2_STD_PAL_I,
+	V4L2_STD_PAL_DK,
+	V4L2_STD_PAL_M,
+	V4L2_STD_PAL_N,
+	V4L2_STD_PAL_Nc,
+	V4L2_STD_PAL_60,
+	V4L2_STD_SECAM_B | V4L2_STD_SECAM_G | V4L2_STD_SECAM_H,
+	V4L2_STD_SECAM_DK,
+	V4L2_STD_SECAM_L,
+	V4L2_STD_SECAM_LC,
+	V4L2_STD_UNKNOWN
+};
+
+static int vidioc_querystd(struct file *file, void *priv, v4l2_std_id *id)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+
+	if (!vivi_is_sdtv(dev))
+		return -ENODATA;
+	if (dev->std_signal_mode == NO_SIGNAL ||
+	    dev->std_signal_mode == NO_LOCK) {
+		*id = V4L2_STD_UNKNOWN;
+		return 0;
+	}
+	if (vivi_is_tv(dev) && tpg_g_quality(&dev->tpg) == TPG_QUAL_NOISE) {
+		*id = V4L2_STD_UNKNOWN;
+	} else if (dev->std_signal_mode == CURRENT_STD) {
+		*id = dev->std;
+	} else if (dev->std_signal_mode == SELECTED_STD) {
+		*id = dev->query_std;
+	} else {
+		*id = vivi_standard[dev->query_std_last];
+		dev->query_std_last = (dev->query_std_last + 1) % ARRAY_SIZE(vivi_standard);
+	}
+
+	return 0;
+}
+
+static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *id)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+
+	if (!vivi_is_sdtv(dev))
+		return -ENODATA;
+	*id = dev->std;
+	return 0;
+}
+
+static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id id)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+
+	if (!vivi_is_sdtv(dev))
+		return -ENODATA;
+	if (dev->std == id)
+		return 0;
+	if (vb2_is_busy(&dev->vb_vidq))
+		return -EBUSY;
+	dev->std = id;
+	update_format(dev, false);
+	return 0;
+}
+
+static int vidioc_s_dv_timings(struct file *file, void *_fh,
+				    struct v4l2_dv_timings *timings)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+
+	if (!vivi_is_hdmi(dev))
+		return -ENODATA;
+	if (vb2_is_busy(&dev->vb_vidq))
+		return -EBUSY;
+	if (!v4l2_find_dv_timings_cap(timings, &vivi_dv_timings_cap,
+				      0, NULL, NULL))
+		return -EINVAL;
+	if (v4l2_match_dv_timings(timings, &dev->dv_timings, 0))
+		return 0;
+	dev->dv_timings = *timings;
+	update_format(dev, false);
+	return 0;
+}
+
+static int vidioc_g_dv_timings(struct file *file, void *_fh,
+				    struct v4l2_dv_timings *timings)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+
+	if (!vivi_is_hdmi(dev))
+		return -ENODATA;
+	*timings = dev->dv_timings;
+	return 0;
+}
+
+static int vidioc_query_dv_timings(struct file *file, void *_fh,
+				    struct v4l2_dv_timings *timings)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+
+	if (!vivi_is_hdmi(dev))
+		return -ENODATA;
+	if (dev->timings_signal_mode == NO_SIGNAL ||
+	    dev->edid_blocks == 0)
+		return -ENOLINK;
+	if (dev->timings_signal_mode == NO_LOCK)
+		return -ENOLCK;
+	if (dev->timings_signal_mode == OUT_OF_RANGE) {
+		timings->bt.pixelclock = vivi_dv_timings_cap.bt.max_pixelclock * 2;
+		return -ERANGE;
+	}
+	if (dev->timings_signal_mode == CURRENT_TIMINGS) {
+		*timings = dev->dv_timings;
+	} else if (dev->timings_signal_mode == SELECTED_TIMINGS) {
+		*timings = v4l2_dv_timings_presets[dev->query_timings];
+	} else {
+		*timings = v4l2_dv_timings_presets[dev->query_timings_last];
+		dev->query_timings_last = (dev->query_timings_last + 1) % dev->query_timings_size;
+	}
+	return 0;
+}
+
+static int vidioc_enum_dv_timings(struct file *file, void *_fh,
+				    struct v4l2_enum_dv_timings *timings)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+
+	if (!vivi_is_hdmi(dev))
+		return -ENODATA;
+	return v4l2_enum_dv_timings_cap(timings, &vivi_dv_timings_cap,
+					NULL, NULL);
+}
+
+static int vidioc_dv_timings_cap(struct file *file, void *_fh,
+				    struct v4l2_dv_timings_cap *cap)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+
+	if (!vivi_is_hdmi(dev))
+		return -ENODATA;
+	*cap = vivi_dv_timings_cap;
+	return 0;
+}
+
+static int vidioc_g_edid(struct file *file, void *_fh,
+			 struct v4l2_edid *edid)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+
+	memset(edid->reserved, 0, sizeof(edid->reserved));
+	if (edid->pad >= dev->num_inputs)
+		return -EINVAL;
+	if (dev->input_type[edid->pad] != HDMI)
+		return -EINVAL;
+	if (edid->start_block == 0 && edid->blocks == 0) {
+		edid->blocks = dev->edid_blocks;
+		return 0;
+	}
+	if (dev->edid_blocks == 0)
+		return -ENODATA;
+	if (edid->start_block >= dev->edid_blocks)
+		return -EINVAL;
+	if (edid->start_block + edid->blocks > dev->edid_blocks)
+		edid->blocks = dev->edid_blocks - edid->start_block;
+	memcpy(edid->edid, dev->edid, edid->blocks * 128);
+	return 0;
+}
+
+static int vidioc_s_edid(struct file *file, void *_fh,
+			 struct v4l2_edid *edid)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+
+	memset(edid->reserved, 0, sizeof(edid->reserved));
+	if (edid->pad >= dev->num_inputs)
+		return -EINVAL;
+	if (dev->input_type[edid->pad] != HDMI || edid->start_block)
+		return -EINVAL;
+	if (edid->blocks == 0) {
+		dev->edid_blocks = 0;
+		return 0;
+	}
+	if (edid->blocks > dev->edid_max_blocks) {
+		edid->blocks = dev->edid_max_blocks;
+		return -E2BIG;
+	}
+	dev->edid_blocks = edid->blocks;
+	memcpy(dev->edid, edid->edid, edid->blocks * 128);
+	return 0;
+}
+
+static int vidioc_enum_framesizes(struct file *file, void *fh,
+					 struct v4l2_frmsizeenum *fsize)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+
+	if (!vivi_is_webcam(dev) && !dev->has_scaler)
+		return -EINVAL;
+	if (__get_format(dev, fsize->pixel_format) == NULL)
+		return -EINVAL;
+	if (vivi_is_webcam(dev)) {
+		if (fsize->index >= ARRAY_SIZE(webcam_sizes))
+			return -EINVAL;
+		fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
+		fsize->discrete = webcam_sizes[fsize->index];
+		return 0;
+	}
+	if (fsize->index)
+		return -EINVAL;
+	fsize->type = V4L2_FRMSIZE_TYPE_STEPWISE;
+	fsize->stepwise.min_width = MIN_WIDTH;
+	fsize->stepwise.max_width = MAX_WIDTH * MAX_ZOOM;
+	fsize->stepwise.step_width = 2;
+	fsize->stepwise.min_height = MIN_HEIGHT;
+	fsize->stepwise.max_height = MAX_HEIGHT * MAX_ZOOM;
+	fsize->stepwise.step_height = 2;
+	return 0;
+}
+
+/* timeperframe is arbitrary and continuous */
+static int vidioc_enum_frameintervals(struct file *file, void *priv,
+					     struct v4l2_frmivalenum *fival)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+	const struct vivi_fmt *fmt;
+	int i;
+
+	if (!vivi_is_webcam(dev))
+		return -EINVAL;
+
+	fmt = __get_format(dev, fival->pixel_format);
+	if (!fmt)
+		return -EINVAL;
+
+	for (i = 0; i < ARRAY_SIZE(webcam_sizes); i++)
+		if (fival->width == webcam_sizes[i].width &&
+				fival->height == webcam_sizes[i].height)
+			break;
+	if (i == ARRAY_SIZE(webcam_sizes))
+		return -EINVAL;
+	if (fival->index >= 2 * (3 - i))
+		return -EINVAL;
+	fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+	fival->discrete = webcam_intervals[fival->index];
+	return 0;
+}
+
+static int vidioc_g_parm(struct file *file, void *priv,
+			  struct v4l2_streamparm *parm)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+
+	if (parm->type != (dev->multiplanar ? V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE :
+					 V4L2_BUF_TYPE_VIDEO_CAPTURE))
+		return -EINVAL;
+
+	parm->parm.capture.capability   = V4L2_CAP_TIMEPERFRAME;
+	parm->parm.capture.timeperframe = dev->timeperframe;
+	parm->parm.capture.readbuffers  = 1;
+	return 0;
+}
+
+#define FRACT_CMP(a, OP, b)	\
+	((u64)(a).numerator * (b).denominator  OP  (u64)(b).numerator * (a).denominator)
+
+static int vidioc_s_parm(struct file *file, void *priv,
+			  struct v4l2_streamparm *parm)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+	unsigned ival_sz = 2 * (3 - dev->webcam_size_idx);
+	struct v4l2_fract tpf;
+	unsigned i;
+
+	if (parm->type != (dev->multiplanar ? V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE :
+					 V4L2_BUF_TYPE_VIDEO_CAPTURE))
+		return -EINVAL;
+	if (!vivi_is_webcam(dev))
+		return vidioc_g_parm(file, priv, parm);
+
+	tpf = parm->parm.capture.timeperframe;
+
+	if (tpf.denominator == 0)
+		tpf = webcam_intervals[ival_sz - 1];
+	for (i = 0; i < ival_sz; i++)
+		if (FRACT_CMP(tpf, >=, webcam_intervals[i]))
+			break;
+	if (i == ival_sz)
+		i = ival_sz - 1;
+	dev->webcam_ival_idx = i;
+	tpf = webcam_intervals[dev->webcam_ival_idx];
+	tpf = FRACT_CMP(tpf, <, tpf_min) ? tpf_min : tpf;
+	tpf = FRACT_CMP(tpf, >, tpf_max) ? tpf_max : tpf;
+
+	dev->timeperframe = tpf;
+	parm->parm.capture.timeperframe = tpf;
+	parm->parm.capture.readbuffers  = 1;
+	return 0;
+}
+
+static void vivi_send_source_change(struct vivi_dev *dev, unsigned type)
+{
+	struct v4l2_event ev = {
+		.type = V4L2_EVENT_SOURCE_CHANGE,
+		.u.src_change.changes = V4L2_EVENT_SRC_CH_RESOLUTION,
+	};
+	unsigned i;
+
+	if (!video_is_registered(&dev->vdev))
+		return;
+	for (i = 0; i < dev->num_inputs; i++) {
+		ev.id = i;
+		if (dev->input_type[i] == type)
+			v4l2_event_queue(&dev->vdev, &ev);
+	}
+}
+
+static int vidioc_subscribe_event(struct v4l2_fh *fh,
+			const struct v4l2_event_subscription *sub)
+{
+	switch (sub->type) {
+	case V4L2_EVENT_CTRL:
+		return v4l2_ctrl_subscribe_event(fh, sub);
+	case V4L2_EVENT_SOURCE_CHANGE:
+		return v4l2_src_change_event_subscribe(fh, sub);
+	default:
+		break;
+	}
+	return -EINVAL;
+}
+
+static int vivi_fop_release(struct file *file)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+
+	mutex_lock(&dev->mutex);
+	if (v4l2_fh_is_singular_file(file))
+		set_bit(V4L2_FL_REGISTERED, &dev->vdev.flags);
+	mutex_unlock(&dev->mutex);
+	if (file->private_data == dev->overlay_owner)
+		dev->overlay_owner = NULL;
+	return vb2_fop_release(file);
+}
+/* --- controls ---------------------------------------------- */
+
+#define VIVI_CID_CUSTOM_BASE		(V4L2_CID_USER_BASE | 0xf000)
+#define VIVI_CID_IMAGE_PROC_BASE	(V4L2_CTRL_CLASS_IMAGE_PROC | 0xf000)
+#define VIVI_CID_OSD_TEXT_MODE		(VIVI_CID_IMAGE_PROC_BASE + 0)
+#define VIVI_CID_HOR_MOVEMENT		(VIVI_CID_IMAGE_PROC_BASE + 1)
+#define VIVI_CID_VERT_MOVEMENT		(VIVI_CID_IMAGE_PROC_BASE + 2)
+#define VIVI_CID_PERCENTAGE_FILL	(VIVI_CID_IMAGE_PROC_BASE + 3)
+#define VIVI_CID_SHOW_BORDER		(VIVI_CID_IMAGE_PROC_BASE + 4)
+#define VIVI_CID_SHOW_SQUARE		(VIVI_CID_IMAGE_PROC_BASE + 5)
+#define VIVI_CID_INSERT_SAV		(VIVI_CID_IMAGE_PROC_BASE + 6)
+#define VIVI_CID_INSERT_EAV		(VIVI_CID_IMAGE_PROC_BASE + 7)
+
+#define VIVI_CID_HFLIP			(VIVI_CID_IMAGE_PROC_BASE + 20)
+#define VIVI_CID_VFLIP			(VIVI_CID_IMAGE_PROC_BASE + 21)
+#define VIVI_CID_STD_ASPECT_RATIO	(VIVI_CID_IMAGE_PROC_BASE + 22)
+#define VIVI_CID_TIMINGS_ASPECT_RATIO	(VIVI_CID_IMAGE_PROC_BASE + 23)
+#define VIVI_CID_TSTAMP_SRC		(VIVI_CID_IMAGE_PROC_BASE + 24)
+#define VIVI_CID_COLORSPACE		(VIVI_CID_IMAGE_PROC_BASE + 25)
+#define VIVI_CID_LIMITED_RGB_RANGE	(VIVI_CID_IMAGE_PROC_BASE + 26)
+#define VIVI_CID_ALPHA_MODE		(VIVI_CID_IMAGE_PROC_BASE + 27)
+#define VIVI_CID_HAS_CROP		(VIVI_CID_IMAGE_PROC_BASE + 28)
+#define VIVI_CID_HAS_COMPOSE		(VIVI_CID_IMAGE_PROC_BASE + 29)
+#define VIVI_CID_HAS_SCALER		(VIVI_CID_IMAGE_PROC_BASE + 30)
+#define VIVI_CID_MAX_EDID_BLOCKS	(VIVI_CID_IMAGE_PROC_BASE + 31)
+
+#define VIVI_CID_STD_SIGNAL_MODE	(VIVI_CID_IMAGE_PROC_BASE + 40)
+#define VIVI_CID_STANDARD		(VIVI_CID_IMAGE_PROC_BASE + 41)
+#define VIVI_CID_TIMINGS_SIGNAL_MODE	(VIVI_CID_IMAGE_PROC_BASE + 42)
+#define VIVI_CID_TIMINGS		(VIVI_CID_IMAGE_PROC_BASE + 43)
+#define VIVI_CID_PERC_DROPPED		(VIVI_CID_IMAGE_PROC_BASE + 44)
+#define VIVI_CID_DISCONNECT		(VIVI_CID_IMAGE_PROC_BASE + 45)
+#define VIVI_CID_DQBUF_ERROR		(VIVI_CID_IMAGE_PROC_BASE + 46)
+#define VIVI_CID_QUEUE_SETUP_ERROR	(VIVI_CID_IMAGE_PROC_BASE + 47)
+#define VIVI_CID_BUF_PREPARE_ERROR	(VIVI_CID_IMAGE_PROC_BASE + 48)
+#define VIVI_CID_START_STR_ERROR	(VIVI_CID_IMAGE_PROC_BASE + 49)
+
+static int vivi_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct vivi_dev *dev = container_of(ctrl->handler, struct vivi_dev, ctrl_handler);
+
+	if (ctrl == dev->autogain)
+		dev->gain->val = dev->jiffies & 0xff;
+	return 0;
+}
+
+static int vivi_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct vivi_dev *dev = container_of(ctrl->handler, struct vivi_dev, ctrl_handler);
+	unsigned i;
+
+	switch (ctrl->id) {
+	case V4L2_CID_BRIGHTNESS:
+		dev->input_brightness[dev->input] = ctrl->val - dev->input * 128;
+		tpg_s_brightness(&dev->tpg, dev->input_brightness[dev->input]);
+		break;
+	case V4L2_CID_CONTRAST:
+		tpg_s_contrast(&dev->tpg, ctrl->val);
+		break;
+	case V4L2_CID_SATURATION:
+		tpg_s_saturation(&dev->tpg, ctrl->val);
+		break;
+	case V4L2_CID_HUE:
+		tpg_s_hue(&dev->tpg, ctrl->val);
+		break;
+	case V4L2_CID_HFLIP:
+		dev->hflip = ctrl->val;
+		tpg_s_hflip(&dev->tpg, dev->sensor_hflip ^ dev->hflip);
+		break;
+	case V4L2_CID_VFLIP:
+		dev->vflip = ctrl->val;
+		tpg_s_vflip(&dev->tpg, dev->sensor_vflip ^ dev->vflip);
+		break;
+	case V4L2_CID_ALPHA_COMPONENT:
+		tpg_s_alpha_component(&dev->tpg, ctrl->val);
+		break;
+	case V4L2_CID_TEST_PATTERN:
+		vivi_update_quality(dev);
+		tpg_s_pattern(&dev->tpg, ctrl->val);
+		break;
+	case VIVI_CID_COLORSPACE:
+		tpg_s_colorspace(&dev->tpg, ctrl->val);
+		vivi_send_source_change(dev, TV);
+		vivi_send_source_change(dev, SVID);
+		vivi_send_source_change(dev, HDMI);
+		vivi_send_source_change(dev, WEBCAM);
+		break;
+	case V4L2_CID_DV_RX_RGB_RANGE:
+		if (!vivi_is_hdmi(dev))
+			break;
+		tpg_s_rgb_range(&dev->tpg, ctrl->val);
+		break;
+	case VIVI_CID_LIMITED_RGB_RANGE:
+		tpg_s_real_rgb_range(&dev->tpg, ctrl->val ?
+				V4L2_DV_RGB_RANGE_LIMITED : V4L2_DV_RGB_RANGE_FULL);
+		break;
+	case VIVI_CID_ALPHA_MODE:
+		tpg_s_alpha_mode(&dev->tpg, ctrl->val);
+		break;
+	case VIVI_CID_HOR_MOVEMENT:
+		tpg_s_mv_hor_mode(&dev->tpg, ctrl->val);
+		break;
+	case VIVI_CID_VERT_MOVEMENT:
+		tpg_s_mv_vert_mode(&dev->tpg, ctrl->val);
+		break;
+	case VIVI_CID_OSD_TEXT_MODE:
+		dev->osd_mode = ctrl->val;
+		break;
+	case VIVI_CID_PERCENTAGE_FILL:
+		tpg_s_perc_fill(&dev->tpg, ctrl->val);
+		for (i = 0; i < VIDEO_MAX_FRAME; i++)
+			dev->must_blank[i] = ctrl->val < 100;
+		break;
+	case VIVI_CID_DISCONNECT:
+		clear_bit(V4L2_FL_REGISTERED, &dev->vdev.flags);
+		break;
+	case VIVI_CID_DQBUF_ERROR:
+		dev->dqbuf_error = true;
+		break;
+	case VIVI_CID_PERC_DROPPED:
+		dev->perc_dropped_buffers = ctrl->val;
+		break;
+	case VIVI_CID_QUEUE_SETUP_ERROR:
+		dev->queue_setup_error = true;
+		break;
+	case VIVI_CID_BUF_PREPARE_ERROR:
+		dev->buf_prepare_error = true;
+		break;
+	case VIVI_CID_START_STR_ERROR:
+		dev->start_streaming_error = true;
+		break;
+	case VIVI_CID_INSERT_SAV:
+		tpg_s_insert_sav(&dev->tpg, ctrl->val);
+		break;
+	case VIVI_CID_INSERT_EAV:
+		tpg_s_insert_eav(&dev->tpg, ctrl->val);
+		break;
+	case VIVI_CID_HFLIP:
+		dev->sensor_hflip = ctrl->val;
+		tpg_s_hflip(&dev->tpg, dev->sensor_hflip ^ dev->hflip);
+		break;
+	case VIVI_CID_VFLIP:
+		dev->sensor_vflip = ctrl->val;
+		tpg_s_vflip(&dev->tpg, dev->sensor_vflip ^ dev->vflip);
+		break;
+	case VIVI_CID_HAS_CROP:
+		dev->has_crop = ctrl->val;
+		update_format(dev, true);
+		break;
+	case VIVI_CID_HAS_COMPOSE:
+		dev->has_compose = ctrl->val;
+		update_format(dev, true);
+		break;
+	case VIVI_CID_HAS_SCALER:
+		dev->has_scaler = ctrl->val;
+		update_format(dev, true);
+		break;
+	case VIVI_CID_SHOW_BORDER:
+		tpg_s_show_border(&dev->tpg, ctrl->val);
+		break;
+	case VIVI_CID_SHOW_SQUARE:
+		tpg_s_show_square(&dev->tpg, ctrl->val);
+		break;
+	case VIVI_CID_STD_SIGNAL_MODE:
+		dev->std_signal_mode = dev->ctrl_std_signal_mode->val;
+		if (dev->std_signal_mode == SELECTED_STD)
+			dev->query_std = vivi_standard[dev->ctrl_standard->val];
+		v4l2_ctrl_activate(dev->ctrl_standard, dev->std_signal_mode == SELECTED_STD);
+		vivi_send_source_change(dev, TV);
+		vivi_send_source_change(dev, SVID);
+		break;
+	case VIVI_CID_STD_ASPECT_RATIO:
+		dev->std_aspect_ratio = ctrl->val;
+		tpg_s_video_aspect(&dev->tpg, vivi_get_video_aspect(dev));
+		break;
+	case VIVI_CID_TIMINGS_SIGNAL_MODE:
+		dev->timings_signal_mode = dev->ctrl_timings_signal_mode->val;
+		if (dev->timings_signal_mode == SELECTED_TIMINGS)
+			dev->query_timings = dev->ctrl_timings->val;
+		v4l2_ctrl_activate(dev->ctrl_timings, dev->timings_signal_mode == SELECTED_TIMINGS);
+		vivi_send_source_change(dev, HDMI);
+		break;
+	case VIVI_CID_TIMINGS_ASPECT_RATIO:
+		dev->timings_aspect_ratio = ctrl->val;
+		tpg_s_video_aspect(&dev->tpg, vivi_get_video_aspect(dev));
+		break;
+	case VIVI_CID_TSTAMP_SRC:
+		dev->tstamp_src_is_soe = ctrl->val;
+		dev->vb_vidq.timestamp_flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+		if (dev->tstamp_src_is_soe)
+			dev->vb_vidq.timestamp_flags |= V4L2_BUF_FLAG_TSTAMP_SRC_SOE;
+		break;
+	case VIVI_CID_MAX_EDID_BLOCKS:
+		dev->edid_max_blocks = ctrl->val;
+		if (dev->edid_blocks > dev->edid_max_blocks)
+			dev->edid_blocks = dev->edid_max_blocks;
+		break;
+	default:
+		if (ctrl == dev->button)
+			dev->button_pressed = 30;
+		break;
+	}
+	return 0;
+}
+
+/* ------------------------------------------------------------------
+	File operations for the device
+   ------------------------------------------------------------------*/
+
+static const struct v4l2_ctrl_ops vivi_ctrl_ops = {
+	.g_volatile_ctrl = vivi_g_volatile_ctrl,
+	.s_ctrl = vivi_s_ctrl,
+};
+
+static const struct v4l2_ctrl_config vivi_ctrl_button = {
+	.ops = &vivi_ctrl_ops,
+	.id = VIVI_CID_CUSTOM_BASE + 0,
+	.name = "Button",
+	.type = V4L2_CTRL_TYPE_BUTTON,
+};
+
+static const struct v4l2_ctrl_config vivi_ctrl_boolean = {
+	.ops = &vivi_ctrl_ops,
+	.id = VIVI_CID_CUSTOM_BASE + 1,
+	.name = "Boolean",
+	.type = V4L2_CTRL_TYPE_BOOLEAN,
+	.min = 0,
+	.max = 1,
+	.step = 1,
+	.def = 1,
+};
+
+static const struct v4l2_ctrl_config vivi_ctrl_int32 = {
+	.ops = &vivi_ctrl_ops,
+	.id = VIVI_CID_CUSTOM_BASE + 2,
+	.name = "Integer 32 Bits",
+	.type = V4L2_CTRL_TYPE_INTEGER,
+	.min = 0x80000000,
+	.max = 0x7fffffff,
+	.step = 1,
+};
+
+static const struct v4l2_ctrl_config vivi_ctrl_int64 = {
+	.ops = &vivi_ctrl_ops,
+	.id = VIVI_CID_CUSTOM_BASE + 3,
+	.name = "Integer 64 Bits",
+	.type = V4L2_CTRL_TYPE_INTEGER64,
+};
+
+static const char * const vivi_ctrl_menu_strings[] = {
+	"Menu Item 0 (Skipped)",
+	"Menu Item 1",
+	"Menu Item 2 (Skipped)",
+	"Menu Item 3",
+	"Menu Item 4",
+	"Menu Item 5 (Skipped)",
+	NULL,
+};
+
+static const struct v4l2_ctrl_config vivi_ctrl_menu = {
+	.ops = &vivi_ctrl_ops,
+	.id = VIVI_CID_CUSTOM_BASE + 4,
+	.name = "Menu",
+	.type = V4L2_CTRL_TYPE_MENU,
+	.min = 1,
+	.max = 4,
+	.def = 3,
+	.menu_skip_mask = 0x04,
+	.qmenu = vivi_ctrl_menu_strings,
+};
+
+static const struct v4l2_ctrl_config vivi_ctrl_string = {
+	.ops = &vivi_ctrl_ops,
+	.id = VIVI_CID_CUSTOM_BASE + 5,
+	.name = "String",
+	.type = V4L2_CTRL_TYPE_STRING,
+	.min = 2,
+	.max = 4,
+	.step = 1,
+};
+
+static const struct v4l2_ctrl_config vivi_ctrl_bitmask = {
+	.ops = &vivi_ctrl_ops,
+	.id = VIVI_CID_CUSTOM_BASE + 6,
+	.name = "Bitmask",
+	.type = V4L2_CTRL_TYPE_BITMASK,
+	.def = 0x80002000,
+	.min = 0,
+	.max = 0x80402010,
+	.step = 0,
+};
+
+static const s64 vivi_ctrl_int_menu_values[] = {
+	1, 1, 2, 3, 5, 8, 13, 21, 42,
+};
+
+static const struct v4l2_ctrl_config vivi_ctrl_int_menu = {
+	.ops = &vivi_ctrl_ops,
+	.id = VIVI_CID_CUSTOM_BASE + 7,
+	.name = "Integer Menu",
+	.type = V4L2_CTRL_TYPE_INTEGER_MENU,
+	.min = 1,
+	.max = 8,
+	.def = 4,
+	.menu_skip_mask = 0x02,
+	.qmenu_int = vivi_ctrl_int_menu_values,
+};
+
+static const char * const vivi_ctrl_hor_movement_strings[] = {
+	"Move Left Fast",
+	"Move Left",
+	"Move Left Slow",
+	"No Movement",
+	"Move Right Slow",
+	"Move Right",
+	"Move Right Fast",
+	NULL,
+};
+
+static const struct v4l2_ctrl_config vivi_ctrl_hor_movement = {
+	.ops = &vivi_ctrl_ops,
+	.id = VIVI_CID_HOR_MOVEMENT,
+	.name = "Horizontal Movement",
+	.type = V4L2_CTRL_TYPE_MENU,
+	.max = TPG_MOVE_POS_FAST,
+	.def = TPG_MOVE_NONE,
+	.qmenu = vivi_ctrl_hor_movement_strings,
+};
+
+static const char * const vivi_ctrl_vert_movement_strings[] = {
+	"Move Up Fast",
+	"Move Up",
+	"Move Up Slow",
+	"No Movement",
+	"Move Down Slow",
+	"Move Down",
+	"Move Down Fast",
+	NULL,
+};
+
+static const struct v4l2_ctrl_config vivi_ctrl_vert_movement = {
+	.ops = &vivi_ctrl_ops,
+	.id = VIVI_CID_VERT_MOVEMENT,
+	.name = "Vertical Movement",
+	.type = V4L2_CTRL_TYPE_MENU,
+	.max = TPG_MOVE_POS_FAST,
+	.def = TPG_MOVE_NONE,
+	.qmenu = vivi_ctrl_vert_movement_strings,
+};
+
+static const struct v4l2_ctrl_config vivi_ctrl_show_border = {
+	.ops = &vivi_ctrl_ops,
+	.id = VIVI_CID_SHOW_BORDER,
+	.name = "Show Border",
+	.type = V4L2_CTRL_TYPE_BOOLEAN,
+	.max = 1,
+	.step = 1,
+};
+
+static const struct v4l2_ctrl_config vivi_ctrl_show_square = {
+	.ops = &vivi_ctrl_ops,
+	.id = VIVI_CID_SHOW_SQUARE,
+	.name = "Show Square",
+	.type = V4L2_CTRL_TYPE_BOOLEAN,
+	.max = 1,
+	.step = 1,
+};
+
+static const char * const vivi_ctrl_osd_mode_strings[] = {
+	"All",
+	"Counters Only",
+	"None",
+	NULL,
+};
+
+static const struct v4l2_ctrl_config vivi_ctrl_osd_mode = {
+	.ops = &vivi_ctrl_ops,
+	.id = VIVI_CID_OSD_TEXT_MODE,
+	.name = "OSD Text Mode",
+	.type = V4L2_CTRL_TYPE_MENU,
+	.max = 2,
+	.qmenu = vivi_ctrl_osd_mode_strings,
+};
+
+static const struct v4l2_ctrl_config vivi_ctrl_perc_fill = {
+	.ops = &vivi_ctrl_ops,
+	.id = VIVI_CID_PERCENTAGE_FILL,
+	.name = "Fill Percentage of Frame",
+	.type = V4L2_CTRL_TYPE_INTEGER,
+	.min = 0,
+	.max = 100,
+	.def = 100,
+	.step = 1,
+};
+
+static const struct v4l2_ctrl_config vivi_ctrl_disconnect = {
+	.ops = &vivi_ctrl_ops,
+	.id = VIVI_CID_DISCONNECT,
+	.name = "Disconnect",
+	.type = V4L2_CTRL_TYPE_BUTTON,
+};
+
+static const struct v4l2_ctrl_config vivi_ctrl_dqbuf_error = {
+	.ops = &vivi_ctrl_ops,
+	.id = VIVI_CID_DQBUF_ERROR,
+	.name = "Inject V4L2_BUF_FLAG_ERROR",
+	.type = V4L2_CTRL_TYPE_BUTTON,
+};
+
+static const struct v4l2_ctrl_config vivi_ctrl_perc_dropped = {
+	.ops = &vivi_ctrl_ops,
+	.id = VIVI_CID_PERC_DROPPED,
+	.name = "Percentage of Dropped Buffers",
+	.type = V4L2_CTRL_TYPE_INTEGER,
+	.min = 0,
+	.max = 100,
+	.step = 1,
+};
+
+static const struct v4l2_ctrl_config vivi_ctrl_queue_setup_error = {
+	.ops = &vivi_ctrl_ops,
+	.id = VIVI_CID_QUEUE_SETUP_ERROR,
+	.name = "Inject VIDIOC_REQBUFS Error",
+	.type = V4L2_CTRL_TYPE_BUTTON,
+};
+
+static const struct v4l2_ctrl_config vivi_ctrl_buf_prepare_error = {
+	.ops = &vivi_ctrl_ops,
+	.id = VIVI_CID_BUF_PREPARE_ERROR,
+	.name = "Inject VIDIOC_QBUF Error",
+	.type = V4L2_CTRL_TYPE_BUTTON,
+};
+
+static const struct v4l2_ctrl_config vivi_ctrl_start_streaming_error = {
+	.ops = &vivi_ctrl_ops,
+	.id = VIVI_CID_START_STR_ERROR,
+	.name = "Inject VIDIOC_STREAMON Error",
+	.type = V4L2_CTRL_TYPE_BUTTON,
+};
+
+static const struct v4l2_ctrl_config vivi_ctrl_insert_sav = {
+	.ops = &vivi_ctrl_ops,
+	.id = VIVI_CID_INSERT_SAV,
+	.name = "Insert SAV Code in Image",
+	.type = V4L2_CTRL_TYPE_BOOLEAN,
+	.max = 1,
+	.step = 1,
+};
+
+static const struct v4l2_ctrl_config vivi_ctrl_insert_eav = {
+	.ops = &vivi_ctrl_ops,
+	.id = VIVI_CID_INSERT_EAV,
+	.name = "Insert EAV Code in Image",
+	.type = V4L2_CTRL_TYPE_BOOLEAN,
+	.max = 1,
+	.step = 1,
+};
+
+static const struct v4l2_ctrl_config vivi_ctrl_hflip = {
+	.ops = &vivi_ctrl_ops,
+	.id = VIVI_CID_HFLIP,
+	.name = "Sensor Flipped Horizontally",
+	.type = V4L2_CTRL_TYPE_BOOLEAN,
+	.max = 1,
+	.step = 1,
+};
+
+static const struct v4l2_ctrl_config vivi_ctrl_vflip = {
+	.ops = &vivi_ctrl_ops,
+	.id = VIVI_CID_VFLIP,
+	.name = "Sensor Flipped Vertically",
+	.type = V4L2_CTRL_TYPE_BOOLEAN,
+	.max = 1,
+	.step = 1,
+};
+
+static const struct v4l2_ctrl_config vivi_ctrl_has_crop = {
+	.ops = &vivi_ctrl_ops,
+	.id = VIVI_CID_HAS_CROP,
+	.name = "Enable Cropping",
+	.type = V4L2_CTRL_TYPE_BOOLEAN,
+	.max = 1,
+	.def = 1,
+	.step = 1,
+};
+
+static const struct v4l2_ctrl_config vivi_ctrl_has_compose = {
+	.ops = &vivi_ctrl_ops,
+	.id = VIVI_CID_HAS_COMPOSE,
+	.name = "Enable Composing",
+	.type = V4L2_CTRL_TYPE_BOOLEAN,
+	.max = 1,
+	.def = 1,
+	.step = 1,
+};
+
+static const struct v4l2_ctrl_config vivi_ctrl_has_scaler = {
+	.ops = &vivi_ctrl_ops,
+	.id = VIVI_CID_HAS_SCALER,
+	.name = "Enable Scaler",
+	.type = V4L2_CTRL_TYPE_BOOLEAN,
+	.max = 1,
+	.def = 1,
+	.step = 1,
+};
+
+static const char * const vivi_ctrl_tstamp_src_strings[] = {
+	"End of Frame",
+	"Start of Exposure",
+	NULL,
+};
+
+static const struct v4l2_ctrl_config vivi_ctrl_tstamp_src = {
+	.ops = &vivi_ctrl_ops,
+	.id = VIVI_CID_TSTAMP_SRC,
+	.name = "Timestamp Source",
+	.type = V4L2_CTRL_TYPE_MENU,
+	.max = 1,
+	.qmenu = vivi_ctrl_tstamp_src_strings,
+};
+
+static const char * const vivi_ctrl_std_signal_mode_strings[] = {
+	"Current Standard",
+	"No Signal",
+	"No Lock",
+	"",
+	"Selected Standard",
+	"Cycle Through All Standards",
+	NULL,
+};
+
+static const struct v4l2_ctrl_config vivi_ctrl_std_signal_mode = {
+	.ops = &vivi_ctrl_ops,
+	.id = VIVI_CID_STD_SIGNAL_MODE,
+	.name = "Standard Signal Mode",
+	.type = V4L2_CTRL_TYPE_MENU,
+	.max = 5,
+	.menu_skip_mask = 1 << 3,
+	.qmenu = vivi_ctrl_std_signal_mode_strings,
+};
+
+/* Must remain in sync with the vivi_standard array */
+static const char * const vivi_ctrl_standard_strings[] = {
+	"NTSC-M",
+	"NTSC-M-JP",
+	"NTSC-M-KR",
+	"NTSC-443",
+	"PAL-BGH",
+	"PAL-I",
+	"PAL-DK",
+	"PAL-M",
+	"PAL-N",
+	"PAL-Nc",
+	"PAL-60",
+	"SECAM-BGH",
+	"SECAM-DK",
+	"SECAM-L",
+	"SECAM-Lc",
+	NULL,
+};
+
+static const struct v4l2_ctrl_config vivi_ctrl_standard = {
+	.ops = &vivi_ctrl_ops,
+	.id = VIVI_CID_STANDARD,
+	.name = "Standard",
+	.type = V4L2_CTRL_TYPE_MENU,
+	.max = 14,
+	.qmenu = vivi_ctrl_standard_strings,
+};
+
+static const struct v4l2_ctrl_config vivi_ctrl_std_aspect_ratio = {
+	.ops = &vivi_ctrl_ops,
+	.id = VIVI_CID_STD_ASPECT_RATIO,
+	.name = "Standard Aspect Ratio",
+	.type = V4L2_CTRL_TYPE_MENU,
+	.min = 1,
+	.max = 3,
+	.def = 1,
+	.qmenu = tpg_aspect_strings,
+};
+
+static const char * const vivi_ctrl_timings_signal_mode_strings[] = {
+	"Current Timings",
+	"No Signal",
+	"No Lock",
+	"Out of Range",
+	"Selected Timings",
+	"Cycle Through All Timings",
+	"Custom Timings",
+	NULL,
+};
+
+static const struct v4l2_ctrl_config vivi_ctrl_timings_signal_mode = {
+	.ops = &vivi_ctrl_ops,
+	.id = VIVI_CID_TIMINGS_SIGNAL_MODE,
+	.name = "Timings Signal Mode",
+	.type = V4L2_CTRL_TYPE_MENU,
+	.max = 5,
+	.qmenu = vivi_ctrl_timings_signal_mode_strings,
+};
+
+static const struct v4l2_ctrl_config vivi_ctrl_timings_aspect_ratio = {
+	.ops = &vivi_ctrl_ops,
+	.id = VIVI_CID_TIMINGS_ASPECT_RATIO,
+	.name = "Timings Aspect Ratio",
+	.type = V4L2_CTRL_TYPE_MENU,
+	.max = 2,
+	.qmenu = tpg_aspect_strings,
+};
+
+static const struct v4l2_ctrl_config vivi_ctrl_max_edid_blocks = {
+	.ops = &vivi_ctrl_ops,
+	.id = VIVI_CID_MAX_EDID_BLOCKS,
+	.name = "Maximum EDID Blocks",
+	.type = V4L2_CTRL_TYPE_INTEGER,
+	.min = 1,
+	.max = 256,
+	.def = 2,
+	.step = 1,
+};
+
+static const char * const vivi_ctrl_colorspace_strings[] = {
+	"",
+	"SMPTE 170M",
+	"SMPTE 240M",
+	"REC 709",
+	"", /* Skip Bt878 entry */
+	"470 System M",
+	"470 System BG",
+	"", /* Skip JPEG entry */
+	"sRGB",
+	NULL,
+};
+
+static const struct v4l2_ctrl_config vivi_ctrl_colorspace = {
+	.ops = &vivi_ctrl_ops,
+	.id = VIVI_CID_COLORSPACE,
+	.name = "Colorspace",
+	.type = V4L2_CTRL_TYPE_MENU,
+	.min = 1,
+	.max = 8,
+	.menu_skip_mask = (1 << 4) | (1 << 7),
+	.def = 8,
+	.qmenu = vivi_ctrl_colorspace_strings,
+};
+
+static const struct v4l2_ctrl_config vivi_ctrl_alpha_mode = {
+	.ops = &vivi_ctrl_ops,
+	.id = VIVI_CID_ALPHA_MODE,
+	.name = "Apply Alpha To Red Only",
+	.type = V4L2_CTRL_TYPE_BOOLEAN,
+	.max = 1,
+	.step = 1,
+};
+
+static const struct v4l2_ctrl_config vivi_ctrl_limited_rgb_range = {
+	.ops = &vivi_ctrl_ops,
+	.id = VIVI_CID_LIMITED_RGB_RANGE,
+	.name = "Limited RGB Range (16-235)",
+	.type = V4L2_CTRL_TYPE_BOOLEAN,
+	.max = 1,
+	.step = 1,
+};
+
+static const struct v4l2_file_operations vivi_fops = {
+	.owner		= THIS_MODULE,
+	.open           = v4l2_fh_open,
+	.release        = vivi_fop_release,
+	.read           = vb2_fop_read,
+	.poll		= vb2_fop_poll,
+	.unlocked_ioctl = video_ioctl2,
+	.mmap           = vb2_fop_mmap,
+};
+
+static const struct v4l2_ioctl_ops vivi_ioctl_ops = {
+	.vidioc_querycap      = vidioc_querycap,
+
+	.vidioc_enum_fmt_vid_cap  = vidioc_enum_fmt_vid_cap,
+	.vidioc_g_fmt_vid_cap     = vidioc_g_fmt_vid_cap,
+	.vidioc_try_fmt_vid_cap   = vidioc_try_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap     = vidioc_s_fmt_vid_cap,
+	.vidioc_enum_fmt_vid_cap_mplane  = vidioc_enum_fmt_vid_cap_mplane,
+	.vidioc_g_fmt_vid_cap_mplane     = vidioc_g_fmt_vid_cap_mplane,
+	.vidioc_try_fmt_vid_cap_mplane   = vidioc_try_fmt_vid_cap_mplane,
+	.vidioc_s_fmt_vid_cap_mplane     = vidioc_s_fmt_vid_cap_mplane,
+
+	.vidioc_g_selection   = vidioc_g_selection,
+	.vidioc_s_selection   = vidioc_s_selection,
+	.vidioc_cropcap       = vidioc_cropcap,
+
+	.vidioc_enum_framesizes   = vidioc_enum_framesizes,
+	.vidioc_enum_frameintervals = vidioc_enum_frameintervals,
+	.vidioc_g_parm        = vidioc_g_parm,
+	.vidioc_s_parm        = vidioc_s_parm,
+
+	.vidioc_enum_fmt_vid_overlay = vidioc_enum_fmt_vid_overlay,
+	.vidioc_g_fmt_vid_overlay    = vidioc_g_fmt_vid_overlay,
+	.vidioc_try_fmt_vid_overlay  = vidioc_try_fmt_vid_overlay,
+	.vidioc_s_fmt_vid_overlay    = vidioc_s_fmt_vid_overlay,
+	.vidioc_overlay       = vidioc_overlay,
+	.vidioc_g_fbuf        = vidioc_g_fbuf,
+	.vidioc_s_fbuf        = vidioc_s_fbuf,
+
+	.vidioc_reqbufs       = vb2_ioctl_reqbufs,
+	.vidioc_create_bufs   = vb2_ioctl_create_bufs,
+	.vidioc_prepare_buf   = vb2_ioctl_prepare_buf,
+	.vidioc_querybuf      = vb2_ioctl_querybuf,
+	.vidioc_qbuf          = vb2_ioctl_qbuf,
+	.vidioc_dqbuf         = vb2_ioctl_dqbuf,
+/* Not yet	.vidioc_expbuf        = vb2_ioctl_expbuf,*/
+	.vidioc_streamon      = vb2_ioctl_streamon,
+	.vidioc_streamoff     = vb2_ioctl_streamoff,
+
+	.vidioc_enum_input    = vidioc_enum_input,
+	.vidioc_g_input       = vidioc_g_input,
+	.vidioc_s_input       = vidioc_s_input,
+	.vidioc_s_audio       = vidioc_s_audio,
+	.vidioc_g_audio       = vidioc_g_audio,
+	.vidioc_enumaudio     = vidioc_enumaudio,
+	.vidioc_g_frequency   = vidioc_g_frequency,
+	.vidioc_s_frequency   = vidioc_s_frequency,
+	.vidioc_s_tuner       = vidioc_s_tuner,
+	.vidioc_g_tuner       = vidioc_g_tuner,
+
+	.vidioc_querystd      = vidioc_querystd,
+	.vidioc_g_std         = vidioc_g_std,
+	.vidioc_s_std         = vidioc_s_std,
+	.vidioc_s_dv_timings	 = vidioc_s_dv_timings,
+	.vidioc_g_dv_timings	 = vidioc_g_dv_timings,
+	.vidioc_query_dv_timings = vidioc_query_dv_timings,
+	.vidioc_enum_dv_timings	 = vidioc_enum_dv_timings,
+	.vidioc_dv_timings_cap	 = vidioc_dv_timings_cap,
+	.vidioc_g_edid		 = vidioc_g_edid,
+	.vidioc_s_edid		 = vidioc_s_edid,
+
+	.vidioc_log_status    = v4l2_ctrl_log_status,
+	.vidioc_subscribe_event = vidioc_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
+};
+
+/* -----------------------------------------------------------------
+	Initialization and module stuff
+   ------------------------------------------------------------------*/
+
+static int vivi_release(void)
+{
+	struct vivi_dev *dev;
+	struct list_head *list;
+
+	while (!list_empty(&vivi_devlist)) {
+		list = vivi_devlist.next;
+		list_del(list);
+		dev = list_entry(list, struct vivi_dev, vivi_devlist);
+
+		v4l2_info(&dev->v4l2_dev, "unregistering %s\n",
+			video_device_node_name(&dev->vdev));
+		video_unregister_device(&dev->vdev);
+		v4l2_device_unregister(&dev->v4l2_dev);
+		v4l2_ctrl_handler_free(&dev->ctrl_handler);
+		vfree(dev->edid);
+		vfree(dev->bitmap);
+		tpg_free(&dev->tpg);
+		kfree(dev->query_timings_qmenu);
+		kfree(dev);
+	}
+
+	return 0;
+}
+
+static int __init vivi_create_instance(int inst)
+{
+	static const struct v4l2_dv_timings def_timings =
+					V4L2_DV_BT_CEA_1280X720P60;
+	unsigned mod_option_idx = inst < VIVI_MAX_DEVS ? inst : VIVI_MAX_DEVS - 1;
+	unsigned type_counter[4] = { 0, 0, 0, 0 };
+	int ccs = ccs_mode[mod_option_idx];
+	struct v4l2_ctrl_config vivi_ctrl_timings = {
+		.ops = &vivi_ctrl_ops,
+		.id = VIVI_CID_TIMINGS,
+		.name = "Timings",
+		.type = V4L2_CTRL_TYPE_MENU,
+	};
+	struct vivi_dev *dev;
+	struct video_device *vfd;
+	struct v4l2_ctrl_handler *hdl;
+	struct vb2_queue *q;
+	int ret;
+	int i;
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev)
+		return -ENOMEM;
+
+	snprintf(dev->v4l2_dev.name, sizeof(dev->v4l2_dev.name),
+			"%s-%03d", VIVI_MODULE_NAME, inst);
+	ret = v4l2_device_register(NULL, &dev->v4l2_dev);
+	if (ret)
+		goto free_dev;
+
+	tpg_init(&dev->tpg, 640, 360);
+	if (tpg_alloc(&dev->tpg, MAX_ZOOM * MAX_WIDTH))
+		goto free_dev;
+	dev->edid = vmalloc(256 * 128);
+	if (!dev->edid)
+		goto free_dev;
+
+	dev->num_inputs = num_inputs[mod_option_idx];
+	if (dev->num_inputs < 1)
+		dev->num_inputs = 1;
+	if (dev->num_inputs >= MAX_INPUTS)
+		dev->num_inputs = MAX_INPUTS;
+	for (i = 0; i < dev->num_inputs; i++) {
+		dev->input_type[i] = (input_types[mod_option_idx] >> (i * 2)) & 0x3;
+		dev->input_name_counter[i] = type_counter[dev->input_type[i]]++;
+	}
+	dev->have_audio_inputs = type_counter[TV] && type_counter[SVID];
+	if (!dev->have_audio_inputs) {
+		v4l2_disable_ioctl(&dev->vdev, VIDIOC_S_AUDIO);
+		v4l2_disable_ioctl(&dev->vdev, VIDIOC_G_AUDIO);
+		v4l2_disable_ioctl(&dev->vdev, VIDIOC_ENUMAUDIO);
+	}
+	if (!type_counter[TV] && !type_counter[SVID]) {
+		v4l2_disable_ioctl(&dev->vdev, VIDIOC_S_STD);
+		v4l2_disable_ioctl(&dev->vdev, VIDIOC_G_STD);
+		v4l2_disable_ioctl(&dev->vdev, VIDIOC_ENUMSTD);
+		v4l2_disable_ioctl(&dev->vdev, VIDIOC_QUERYSTD);
+	}
+	dev->have_tuner = type_counter[TV];
+	if (!dev->have_tuner) {
+		v4l2_disable_ioctl(&dev->vdev, VIDIOC_S_FREQUENCY);
+		v4l2_disable_ioctl(&dev->vdev, VIDIOC_G_FREQUENCY);
+		v4l2_disable_ioctl(&dev->vdev, VIDIOC_S_TUNER);
+		v4l2_disable_ioctl(&dev->vdev, VIDIOC_G_TUNER);
+	}
+	if (type_counter[HDMI] == 0) {
+		v4l2_disable_ioctl(&dev->vdev, VIDIOC_S_EDID);
+		v4l2_disable_ioctl(&dev->vdev, VIDIOC_G_EDID);
+		v4l2_disable_ioctl(&dev->vdev, VIDIOC_DV_TIMINGS_CAP);
+		v4l2_disable_ioctl(&dev->vdev, VIDIOC_G_DV_TIMINGS);
+		v4l2_disable_ioctl(&dev->vdev, VIDIOC_S_DV_TIMINGS);
+		v4l2_disable_ioctl(&dev->vdev, VIDIOC_ENUM_DV_TIMINGS);
+		v4l2_disable_ioctl(&dev->vdev, VIDIOC_QUERY_DV_TIMINGS);
+	}
+	if (type_counter[WEBCAM] == 0)
+		v4l2_disable_ioctl(&dev->vdev, VIDIOC_ENUM_FRAMEINTERVALS);
+
+	dev->min_rect.width = MIN_WIDTH;
+	dev->min_rect.height = MIN_HEIGHT;
+	dev->max_rect.width = MAX_ZOOM * MAX_WIDTH;
+	dev->max_rect.height = MAX_ZOOM * MAX_HEIGHT;
+	dev->fmt = &formats[0];
+	dev->webcam_size_idx = 1;
+	dev->webcam_ival_idx = 3;
+	tpg_s_fourcc(&dev->tpg, dev->fmt->fourcc);
+	dev->std = V4L2_STD_PAL;
+	dev->dv_timings = def_timings;
+	dev->tv_freq = 2804 /* 175.25 * 16 */;
+	dev->tv_audmode = V4L2_TUNER_MODE_STEREO;
+	dev->tv_field = V4L2_FIELD_INTERLACED;
+	dev->edid_max_blocks = dev->edid_blocks = 2;
+	memcpy(dev->edid, vivi_hdmi_edid, sizeof(vivi_hdmi_edid));
+
+	while (v4l2_dv_timings_presets[dev->query_timings_size].bt.width)
+		dev->query_timings_size++;
+	dev->query_timings_qmenu = kmalloc(dev->query_timings_size *
+					   (sizeof(void *) + 32), GFP_KERNEL);
+	if (dev->query_timings_qmenu == NULL)
+		goto free_dev;
+	for (i = 0; i < dev->query_timings_size; i++) {
+		const struct v4l2_bt_timings *bt = &v4l2_dv_timings_presets[i].bt;
+		char *p = (char *)&dev->query_timings_qmenu[dev->query_timings_size];
+		u32 htot, vtot;
+
+		p += i * 32;
+		dev->query_timings_qmenu[i] = p;
+
+		htot = V4L2_DV_BT_FRAME_WIDTH(bt);
+		vtot = V4L2_DV_BT_FRAME_HEIGHT(bt);
+		snprintf(p, 32, "%ux%u%s%u",
+			bt->width, bt->height, bt->interlaced ? "i" : "p",
+			(u32)bt->pixelclock / (htot * vtot));
+	}
+
+	if (multiplanar[mod_option_idx] == 0)
+		dev->multiplanar = inst & 1;
+	else
+		dev->multiplanar = multiplanar[mod_option_idx] > 1;
+	v4l2_info(&dev->v4l2_dev, "using %splanar format API\n",
+			dev->multiplanar ? "multi" : "single ");
+
+	hdl = &dev->ctrl_handler;
+	v4l2_ctrl_handler_init(hdl, 40);
+
+	/* User Controls */
+	dev->volume = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
+			V4L2_CID_AUDIO_VOLUME, 0, 255, 1, 200);
+	dev->mute = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
+			V4L2_CID_AUDIO_MUTE, 0, 1, 1, 0);
+	dev->brightness = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
+			V4L2_CID_BRIGHTNESS, 0, 255, 1, 128);
+	for (i = 0; i < MAX_INPUTS; i++)
+		dev->input_brightness[i] = 128;
+	dev->contrast = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
+			V4L2_CID_CONTRAST, 0, 255, 1, 128);
+	dev->saturation = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
+			V4L2_CID_SATURATION, 0, 255, 1, 128);
+	dev->hue = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
+			V4L2_CID_HUE, -128, 128, 1, 0);
+	v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
+			V4L2_CID_HFLIP, 0, 1, 1, 0);
+	v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
+			V4L2_CID_VFLIP, 0, 1, 1, 0);
+	dev->autogain = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
+			V4L2_CID_AUTOGAIN, 0, 1, 1, 1);
+	dev->gain = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
+			V4L2_CID_GAIN, 0, 255, 1, 100);
+	dev->alpha = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
+			V4L2_CID_ALPHA_COMPONENT, 0, 255, 1, 0);
+	dev->button = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_button, NULL);
+	dev->int32 = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_int32, NULL);
+	dev->int64 = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_int64, NULL);
+	dev->boolean = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_boolean, NULL);
+	dev->menu = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_menu, NULL);
+	dev->string = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_string, NULL);
+	dev->bitmask = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_bitmask, NULL);
+	dev->int_menu = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_int_menu, NULL);
+
+	/* Image Processing Controls */
+	dev->test_pattern = v4l2_ctrl_new_std_menu_items(hdl, &vivi_ctrl_ops,
+			V4L2_CID_TEST_PATTERN,
+			TPG_PAT_NOISE, 0, 0,
+			tpg_pattern_strings);
+	v4l2_ctrl_new_custom(hdl, &vivi_ctrl_perc_fill, NULL);
+	v4l2_ctrl_new_custom(hdl, &vivi_ctrl_hor_movement, NULL);
+	v4l2_ctrl_new_custom(hdl, &vivi_ctrl_vert_movement, NULL);
+	v4l2_ctrl_new_custom(hdl, &vivi_ctrl_osd_mode, NULL);
+	v4l2_ctrl_new_custom(hdl, &vivi_ctrl_show_border, NULL);
+	v4l2_ctrl_new_custom(hdl, &vivi_ctrl_show_square, NULL);
+	v4l2_ctrl_new_custom(hdl, &vivi_ctrl_hflip, NULL);
+	v4l2_ctrl_new_custom(hdl, &vivi_ctrl_vflip, NULL);
+	v4l2_ctrl_new_custom(hdl, &vivi_ctrl_insert_sav, NULL);
+	v4l2_ctrl_new_custom(hdl, &vivi_ctrl_insert_eav, NULL);
+	if (no_error_inj && ccs == -1)
+		ccs = 7;
+	if (ccs == -1) {
+		dev->ctrl_has_crop =
+			v4l2_ctrl_new_custom(hdl, &vivi_ctrl_has_crop, NULL);
+		dev->ctrl_has_compose =
+			v4l2_ctrl_new_custom(hdl, &vivi_ctrl_has_compose, NULL);
+		dev->ctrl_has_scaler =
+			v4l2_ctrl_new_custom(hdl, &vivi_ctrl_has_scaler, NULL);
+	} else {
+		dev->has_crop = ccs & 1;
+		dev->has_compose = ccs & 2;
+		dev->has_scaler = ccs & 4;
+		v4l2_info(&dev->v4l2_dev, "Crop: %c Compose: %c Scaler: %c\n",
+			dev->has_crop ? 'Y' : 'N',
+			dev->has_compose ? 'Y' : 'N',
+			dev->has_scaler ? 'Y' : 'N');
+	}
+
+	v4l2_ctrl_new_custom(hdl, &vivi_ctrl_tstamp_src, NULL);
+	dev->colorspace = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_colorspace, NULL);
+	v4l2_ctrl_new_custom(hdl, &vivi_ctrl_alpha_mode, NULL);
+
+	/*
+	 * Testing this driver with v4l2-compliance will trigger the error
+	 * injection controls, and after that nothing will work as expected.
+	 * So we have a module option to drop these error injecting controls
+	 * allowing us to run v4l2_compliance again.
+	 */
+	if (!no_error_inj) {
+		v4l2_ctrl_new_custom(hdl, &vivi_ctrl_disconnect, NULL);
+		v4l2_ctrl_new_custom(hdl, &vivi_ctrl_dqbuf_error, NULL);
+		v4l2_ctrl_new_custom(hdl, &vivi_ctrl_perc_dropped, NULL);
+		v4l2_ctrl_new_custom(hdl, &vivi_ctrl_queue_setup_error, NULL);
+		v4l2_ctrl_new_custom(hdl, &vivi_ctrl_buf_prepare_error, NULL);
+		v4l2_ctrl_new_custom(hdl, &vivi_ctrl_start_streaming_error, NULL);
+	}
+
+	if (type_counter[TV] || type_counter[SVID]) {
+		v4l2_ctrl_new_custom(hdl, &vivi_ctrl_std_aspect_ratio, NULL);
+		dev->ctrl_std_signal_mode =
+			v4l2_ctrl_new_custom(hdl, &vivi_ctrl_std_signal_mode, NULL);
+		dev->ctrl_standard = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_standard, NULL);
+		v4l2_ctrl_cluster(2, &dev->ctrl_std_signal_mode);
+	}
+
+	if (type_counter[HDMI]) {
+		dev->ctrl_timings_signal_mode =
+			v4l2_ctrl_new_custom(hdl, &vivi_ctrl_timings_signal_mode, NULL);
+
+		vivi_ctrl_timings.max = dev->query_timings_size - 1;
+		vivi_ctrl_timings.qmenu = (const char * const *)dev->query_timings_qmenu;
+		dev->ctrl_timings = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_timings, NULL);
+		v4l2_ctrl_cluster(2, &dev->ctrl_timings_signal_mode);
+
+		v4l2_ctrl_new_custom(hdl, &vivi_ctrl_timings_aspect_ratio, NULL);
+		v4l2_ctrl_new_custom(hdl, &vivi_ctrl_max_edid_blocks, NULL);
+		v4l2_ctrl_new_custom(hdl, &vivi_ctrl_limited_rgb_range, NULL);
+		dev->rgb_range =
+			v4l2_ctrl_new_std_menu(hdl, &vivi_ctrl_ops,
+				V4L2_CID_DV_RX_RGB_RANGE, V4L2_DV_RGB_RANGE_FULL,
+				0, V4L2_DV_RGB_RANGE_AUTO);
+	}
+
+	if (hdl->error) {
+		ret = hdl->error;
+		goto unreg_dev;
+	}
+	v4l2_ctrl_auto_cluster(2, &dev->autogain, 0, true);
+	dev->v4l2_dev.ctrl_handler = hdl;
+
+	update_format(dev, false);
+
+	v4l2_ctrl_handler_setup(hdl);
+
+	/* initialize overlay */
+	dev->fb.fmt.width = dev->width;
+	dev->fb.fmt.height = dev->height;
+	dev->fb.fmt.pixelformat = dev->fmt->fourcc;
+	dev->fb.fmt.bytesperline = dev->width * tpg_g_twopixelsize(&dev->tpg, 0) / 2;
+	dev->fb.fmt.sizeimage = dev->height * dev->fb.fmt.bytesperline;
+
+	/* initialize locks */
+	spin_lock_init(&dev->slock);
+
+	/* initialize queue */
+	q = &dev->vb_vidq;
+	q->type = dev->multiplanar ? V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE :
+				V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_READ;
+	q->drv_priv = dev;
+	q->buf_struct_size = sizeof(struct vivi_buffer);
+	q->ops = &vivi_video_qops;
+	q->mem_ops = &vb2_vmalloc_memops;
+	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+
+	ret = vb2_queue_init(q);
+	if (ret)
+		goto unreg_dev;
+
+	mutex_init(&dev->mutex);
+
+	/* init video dma queues */
+	INIT_LIST_HEAD(&dev->vidq.active);
+	init_waitqueue_head(&dev->vidq.wq);
+
+	vfd = &dev->vdev;
+	strlcpy(vfd->name, "vivi", sizeof(vfd->name));
+	vfd->fops = &vivi_fops;
+	vfd->ioctl_ops = &vivi_ioctl_ops;
+	vfd->release = video_device_release_empty;
+	vfd->v4l2_dev = &dev->v4l2_dev;
+	vfd->queue = q;
+	if (dev->multiplanar) {
+		v4l2_disable_ioctl(vfd, VIDIOC_OVERLAY);
+		v4l2_disable_ioctl(vfd, VIDIOC_G_FBUF);
+		v4l2_disable_ioctl(vfd, VIDIOC_S_FBUF);
+	}
+
+	/*
+	 * Provide a mutex to v4l2 core. It will be used to protect
+	 * all fops and v4l2 ioctls.
+	 */
+	vfd->lock = &dev->mutex;
+	video_set_drvdata(vfd, dev);
+
+	ret = video_register_device(vfd, VFL_TYPE_GRABBER, video_nr[mod_option_idx]);
+	if (ret < 0)
+		goto unreg_dev;
+
+	/* Now that everything is fine, let's add it to device list */
+	list_add_tail(&dev->vivi_devlist, &vivi_devlist);
+
+	v4l2_info(&dev->v4l2_dev, "V4L2 device registered as %s\n",
+		  video_device_node_name(vfd));
+	return 0;
+
+unreg_dev:
+	v4l2_ctrl_handler_free(hdl);
+	v4l2_device_unregister(&dev->v4l2_dev);
+free_dev:
+	vfree(dev->edid);
+	tpg_free(&dev->tpg);
+	kfree(dev->query_timings_qmenu);
+	kfree(dev);
+	return ret;
+}
+
+/* This routine allocates from 1 to n_devs virtual drivers.
+
+   The real maximum number of virtual drivers will depend on how many drivers
+   will succeed. This is limited to the maximum number of devices that
+   videodev supports, which is equal to VIDEO_NUM_DEVICES.
+ */
+static int __init vivi_init(void)
+{
+	const struct font_desc *font = find_font("VGA8x16");
+	int ret = 0, i;
+
+	if (font == NULL) {
+		pr_err("vivi: could not find font\n");
+		return -ENODEV;
+	}
+
+	/* Sanity check, just in case someone messes this up */
+	if (ARRAY_SIZE(webcam_intervals) != ARRAY_SIZE(webcam_sizes) * 2) {
+		pr_err("vivi: webcam_intervals has wrong size!\n");
+		return -ENODEV;
+	}
+
+	tpg_set_font(font->data);
+
+	if (n_devs <= 0)
+		n_devs = 1;
+
+	for (i = 0; i < n_devs; i++) {
+		ret = vivi_create_instance(i);
+		if (ret) {
+			/* If some instantiations succeeded, keep driver */
+			if (i)
+				ret = 0;
+			break;
+		}
+	}
+
+	if (ret < 0) {
+		pr_err("vivi: error %d while loading driver\n", ret);
+		return ret;
+	}
+
+	pr_info("Video Technology Magazine Virtual Video "
+		"Capture Board ver %s successfully loaded.\n",
+		VIVI_VERSION);
+
+	/* n_devs will reflect the actual number of allocated devices */
+	n_devs = i;
+
+	return ret;
+}
+
+static void __exit vivi_exit(void)
+{
+	vivi_release();
+}
+
+module_init(vivi_init);
+module_exit(vivi_exit);
diff --git a/drivers/media/platform/vivi-tpg.c b/drivers/media/platform/vivi-tpg.c
new file mode 100644
index 0000000..5ff153a
--- /dev/null
+++ b/drivers/media/platform/vivi-tpg.c
@@ -0,0 +1,1369 @@
+#include "vivi-tpg.h"
+
+/* Must remain in sync with enum tpg_pattern */
+const char * const tpg_pattern_strings[] = {
+	"75% Colorbar",
+	"100% Colorbar",
+	"CSC Colorbar",
+	"Horizontal 100% Colorbar",
+	"100% Color Squares",
+	"100% Black",
+	"100% White",
+	"100% Red",
+	"100% Green",
+	"100% Blue",
+	"16x16 Checkers",
+	"1x1 Checkers",
+	"Alternating Hor Lines",
+	"Alternating Vert Lines",
+	"One Pixel Wide Cross",
+	"Two Pixels Wide Cross",
+	"Ten Pixels Wide Cross",
+	"Gray Ramp",
+	"Noise",
+	NULL
+};
+
+/* Must remain in sync with enum tpg_aspect */
+const char * const tpg_aspect_strings[] = {
+	"Source Width x Height",
+	"4x3",
+	"16x9",
+	"16x9 Anamorphic",
+	NULL
+};
+
+/*
+ * Sinus table: sin[0] = 127 * sin(-180 degrees)
+ *              sin[128] = 127 * sin(0 degrees)
+ *              sin[256] = 127 * sin(180 degrees)
+ */
+static const s8 sin[257] = {
+	   0,   -4,   -7,  -11,  -13,  -18,  -20,  -22,  -26,  -29,  -33,  -35,  -37,  -41,  -43,  -48,
+	 -50,  -52,  -56,  -58,  -62,  -63,  -65,  -69,  -71,  -75,  -76,  -78,  -82,  -83,  -87,  -88,
+	 -90,  -93,  -94,  -97,  -99, -101, -103, -104, -107, -108, -110, -111, -112, -114, -115, -117,
+	-118, -119, -120, -121, -122, -123, -123, -124, -125, -125, -126, -126, -127, -127, -127, -127,
+	-127, -127, -127, -127, -126, -126, -125, -125, -124, -124, -123, -122, -121, -120, -119, -118,
+	-117, -116, -114, -113, -111, -110, -109, -107, -105, -103, -101, -100,  -97,  -96,  -93,  -91,
+	 -90,  -87,  -85,  -82,  -80,  -76,  -75,  -73,  -69,  -67,  -63,  -62,  -60,  -56,  -54,  -50,
+	 -48,  -46,  -41,  -39,  -35,  -33,  -31,  -26,  -24,  -20,  -18,  -15,  -11,   -9,   -4,   -2,
+	   0,    2,    4,    9,   11,   15,   18,   20,   24,   26,   31,   33,   35,   39,   41,   46,
+	  48,   50,   54,   56,   60,   62,   64,   67,   69,   73,   75,   76,   80,   82,   85,   87,
+	  90,   91,   93,   96,   97,  100,  101,  103,  105,  107,  109,  110,  111,  113,  114,  116,
+	 117,  118,  119,  120,  121,  122,  123,  124,  124,  125,  125,  126,  126,  127,  127,  127,
+	 127,  127,  127,  127,  127,  126,  126,  125,  125,  124,  123,  123,  122,  121,  120,  119,
+	 118,  117,  115,  114,  112,  111,  110,  108,  107,  104,  103,  101,   99,   97,   94,   93,
+	  90,   88,   87,   83,   82,   78,   76,   75,   71,   69,   65,   64,   62,   58,   56,   52,
+	  50,   48,   43,   41,   37,   35,   33,   29,   26,   22,   20,   18,   13,   11,    7,    4,
+	   0,
+};
+
+/*
+ * Cosinus table: cos[0] = 127 * cos(-180 degrees)
+ *                cos[128] = 127 * cos(0 degrees)
+ *                cos[256] = 127 * cos(180 degrees)
+ */
+static const s8 cos[257] = {
+	-127, -127, -127, -127, -126, -126, -125, -125, -124, -124, -123, -122, -121, -120, -119, -118,
+	-117, -116, -114, -113, -111, -110, -109, -107, -105, -103, -101, -100,  -97,  -96,  -93,  -91,
+	 -90,  -87,  -85,  -82,  -80,  -76,  -75,  -73,  -69,  -67,  -63,  -62,  -60,  -56,  -54,  -50,
+	 -48,  -46,  -41,  -39,  -35,  -33,  -31,  -26,  -24,  -20,  -18,  -15,  -11,   -9,   -4,   -2,
+	   0,    4,    7,   11,   13,   18,   20,   22,   26,   29,   33,   35,   37,   41,   43,   48,
+	  50,   52,   56,   58,   62,   64,   65,   69,   71,   75,   76,   78,   82,   83,   87,   88,
+	  90,   93,   94,   97,   99,  101,  103,  104,  107,  108,  110,  111,  112,  114,  115,  117,
+	 118,  119,  120,  121,  122,  123,  123,  124,  125,  125,  126,  126,  127,  127,  127,  127,
+	 127,  127,  127,  127,  127,  126,  126,  125,  125,  124,  123,  123,  122,  121,  120,  119,
+	 118,  117,  115,  114,  112,  111,  110,  108,  107,  104,  103,  101,   99,   97,   94,   93,
+	  90,   88,   87,   83,   82,   78,   76,   75,   71,   69,   65,   64,   62,   58,   56,   52,
+	  50,   48,   43,   41,   37,   35,   33,   29,   26,   22,   20,   18,   13,   11,    7,    4,
+	   0,   -2,   -4,   -9,  -11,  -15,  -18,  -20,  -24,  -26,  -31,  -33,  -35,  -39,  -41,  -46,
+	 -48,  -50,  -54,  -56,  -60,  -62,  -63,  -67,  -69,  -73,  -75,  -76,  -80,  -82,  -85,  -87,
+	 -90,  -91,  -93,  -96,  -97, -100, -101, -103, -105, -107, -109, -110, -111, -113, -114, -116,
+	-117, -118, -119, -120, -121, -122, -123, -124, -124, -125, -125, -126, -126, -127, -127, -127,
+	-127,
+};
+
+/* Global font descriptor */
+static const u8 *font8x16;
+
+void tpg_set_font(const u8 *f)
+{
+	font8x16 = f;
+}
+
+void tpg_init(struct tpg_data *tpg, unsigned w, unsigned h)
+{
+	memset(tpg, 0, sizeof(*tpg));
+	tpg->scaled_width = tpg->src_width = w;
+	tpg->src_height = tpg->buf_height = h;
+	tpg->crop.width = tpg->compose.width = w;
+	tpg->crop.height = tpg->compose.height = h;
+	tpg->recalc_colors = true;
+	tpg->recalc_square_border = true;
+	tpg->brightness = 128;
+	tpg->contrast = 128;
+	tpg->saturation = 128;
+	tpg->hue = 0;
+	tpg->field = V4L2_FIELD_NONE;
+	tpg_s_fourcc(tpg, V4L2_PIX_FMT_RGB24);
+	tpg->colorspace = V4L2_COLORSPACE_SRGB;
+	tpg->perc_fill = 100;
+}
+
+int tpg_alloc(struct tpg_data *tpg, unsigned max_w)
+{
+	unsigned pat;
+	unsigned plane;
+
+	tpg->max_line_width = max_w;
+	for (pat = 0; pat < TPG_MAX_PAT_LINES; pat++) {
+		for (plane = 0; plane < TPG_MAX_PLANES; plane++) {
+			unsigned pixelsz = plane ? 1 : 4;
+
+			tpg->lines[pat][plane] = vzalloc(max_w * 2 * pixelsz);
+			if (!tpg->lines[pat][plane])
+				return -ENOMEM;
+		}
+	}
+	for (plane = 0; plane < TPG_MAX_PLANES; plane++) {
+		unsigned pixelsz = plane ? 1 : 4;
+
+		tpg->contrast_line[plane] = vzalloc(max_w * pixelsz);
+		if (!tpg->contrast_line[plane])
+			return -ENOMEM;
+		tpg->black_line[plane] = vzalloc(max_w * pixelsz);
+		if (!tpg->black_line[plane])
+			return -ENOMEM;
+		tpg->random_line[plane] = vzalloc(max_w * pixelsz);
+		if (!tpg->random_line[plane])
+			return -ENOMEM;
+	}
+	return 0;
+}
+
+void tpg_free(struct tpg_data *tpg)
+{
+	unsigned pat;
+	unsigned plane;
+
+	for (pat = 0; pat < TPG_MAX_PAT_LINES; pat++)
+		for (plane = 0; plane < TPG_MAX_PLANES; plane++) {
+			vfree(tpg->lines[pat][plane]);
+			tpg->lines[pat][plane] = NULL;
+		}
+	for (plane = 0; plane < TPG_MAX_PLANES; plane++) {
+		vfree(tpg->contrast_line[plane]);
+		vfree(tpg->black_line[plane]);
+		vfree(tpg->random_line[plane]);
+		tpg->contrast_line[plane] = NULL;
+		tpg->black_line[plane] = NULL;
+		tpg->random_line[plane] = NULL;
+	}
+}
+
+bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
+{
+	tpg->fourcc = fourcc;
+	tpg->planes = 1;
+	tpg->recalc_colors = true;
+	switch (fourcc) {
+	case V4L2_PIX_FMT_RGB565:
+	case V4L2_PIX_FMT_RGB565X:
+	case V4L2_PIX_FMT_RGB555:
+	case V4L2_PIX_FMT_RGB555X:
+	case V4L2_PIX_FMT_RGB24:
+	case V4L2_PIX_FMT_BGR24:
+	case V4L2_PIX_FMT_RGB32:
+	case V4L2_PIX_FMT_BGR32:
+		tpg->is_yuv = 0;
+		break;
+	case V4L2_PIX_FMT_NV16M:
+	case V4L2_PIX_FMT_NV61M:
+		tpg->planes = 2;
+		/* fall-through */
+	case V4L2_PIX_FMT_YUYV:
+	case V4L2_PIX_FMT_UYVY:
+	case V4L2_PIX_FMT_YVYU:
+	case V4L2_PIX_FMT_VYUY:
+		tpg->is_yuv = 1;
+		break;
+	default:
+		return false;
+	}
+
+	switch (fourcc) {
+	case V4L2_PIX_FMT_RGB565:
+	case V4L2_PIX_FMT_RGB565X:
+	case V4L2_PIX_FMT_RGB555:
+	case V4L2_PIX_FMT_RGB555X:
+	case V4L2_PIX_FMT_YUYV:
+	case V4L2_PIX_FMT_UYVY:
+	case V4L2_PIX_FMT_YVYU:
+	case V4L2_PIX_FMT_VYUY:
+		tpg->twopixelsize[0] = 2 * 2;
+		break;
+	case V4L2_PIX_FMT_RGB24:
+	case V4L2_PIX_FMT_BGR24:
+		tpg->twopixelsize[0] = 2 * 3;
+		break;
+	case V4L2_PIX_FMT_RGB32:
+	case V4L2_PIX_FMT_BGR32:
+		tpg->twopixelsize[0] = 2 * 4;
+		break;
+	case V4L2_PIX_FMT_NV16M:
+	case V4L2_PIX_FMT_NV61M:
+		tpg->twopixelsize[0] = 2;
+		tpg->twopixelsize[1] = 2;
+		break;
+	}
+	return true;
+}
+
+void tpg_s_crop_compose(struct tpg_data *tpg)
+{
+	tpg->scaled_width = (tpg->src_width * tpg->compose.width +
+				 tpg->crop.width - 1) / tpg->crop.width;
+	tpg->scaled_width &= ~1;
+	if (tpg->scaled_width > tpg->max_line_width)
+		tpg->scaled_width = tpg->max_line_width;
+	if (tpg->scaled_width < 2)
+		tpg->scaled_width = 2;
+	tpg->recalc_lines = true;
+}
+
+void tpg_reset_source(struct tpg_data *tpg, unsigned width, unsigned height,
+		       enum v4l2_field field)
+{
+	unsigned p;
+
+	tpg->src_width = width;
+	tpg->src_height = height;
+	tpg->field = field;
+	tpg->buf_height = height;
+	if (V4L2_FIELD_HAS_T_OR_B(field))
+		tpg->buf_height /= 2;
+	tpg->scaled_width = width;
+	tpg->crop.top = tpg->crop.left = 0;
+	tpg->crop.width = width;
+	tpg->crop.height = height;
+	tpg->compose.top = tpg->compose.left = 0;
+	tpg->compose.width = width;
+	tpg->compose.height = tpg->buf_height;
+	for (p = 0; p < tpg->planes; p++)
+		tpg->bytesperline[p] = width * tpg->twopixelsize[p] / 2;
+	tpg->recalc_square_border = true;
+}
+
+static enum tpg_color tpg_get_textbg_color(struct tpg_data *tpg)
+{
+	switch (tpg->pattern) {
+	case TPG_PAT_BLACK:
+		return TPG_COLOR_100_WHITE;
+	case TPG_PAT_CSC_COLORBAR:
+		return TPG_COLOR_CSC_BLACK;
+	default:
+		return TPG_COLOR_100_BLACK;
+	}
+}
+
+static enum tpg_color tpg_get_textfg_color(struct tpg_data *tpg)
+{
+	switch (tpg->pattern) {
+	case TPG_PAT_75_COLORBAR:
+	case TPG_PAT_CSC_COLORBAR:
+		return TPG_COLOR_CSC_WHITE;
+	case TPG_PAT_BLACK:
+		return TPG_COLOR_100_BLACK;
+	default:
+		return TPG_COLOR_100_WHITE;
+	}
+}
+
+static u16 color_to_y(struct tpg_data *tpg, int r, int g, int b)
+{
+	switch (tpg->colorspace) {
+	case V4L2_COLORSPACE_SMPTE170M:
+	case V4L2_COLORSPACE_470_SYSTEM_M:
+	case V4L2_COLORSPACE_470_SYSTEM_BG:
+		return ((16829 * r + 33039 * g + 6416 * b + 16 * 32768) >> 16) + (16 << 4);
+	case V4L2_COLORSPACE_SMPTE240M:
+		return ((11932 * r + 39455 * g + 4897 * b + 16 * 32768) >> 16) + (16 << 4);
+	case V4L2_COLORSPACE_REC709:
+	case V4L2_COLORSPACE_SRGB:
+	default:
+		return ((11966 * r + 40254 * g + 4064 * b + 16 * 32768) >> 16) + (16 << 4);
+	}
+}
+
+static u16 color_to_cb(struct tpg_data *tpg, int r, int g, int b)
+{
+	switch (tpg->colorspace) {
+	case V4L2_COLORSPACE_SMPTE170M:
+	case V4L2_COLORSPACE_470_SYSTEM_M:
+	case V4L2_COLORSPACE_470_SYSTEM_BG:
+		return ((-9714 * r - 19070 * g + 28784 * b + 16 * 32768) >> 16) + (128 << 4);
+	case V4L2_COLORSPACE_SMPTE240M:
+		return ((-6684 * r - 22100 * g + 28784 * b + 16 * 32768) >> 16) + (128 << 4);
+	case V4L2_COLORSPACE_REC709:
+	case V4L2_COLORSPACE_SRGB:
+	default:
+		return ((-6596 * r - 22189 * g + 28784 * b + 16 * 32768) >> 16) + (128 << 4);
+	}
+}
+
+static u16 color_to_cr(struct tpg_data *tpg, int r, int g, int b)
+{
+	switch (tpg->colorspace) {
+	case V4L2_COLORSPACE_SMPTE170M:
+	case V4L2_COLORSPACE_470_SYSTEM_M:
+	case V4L2_COLORSPACE_470_SYSTEM_BG:
+		return ((28784 * r - 24103 * g - 4681 * b + 16 * 32768) >> 16) + (128 << 4);
+	case V4L2_COLORSPACE_SMPTE240M:
+		return ((28784 * r - 25606 * g - 3178 * b + 16 * 32768) >> 16) + (128 << 4);
+	case V4L2_COLORSPACE_REC709:
+	case V4L2_COLORSPACE_SRGB:
+	default:
+		return ((28784 * r - 26145 * g - 2639 * b + 16 * 32768) >> 16) + (128 << 4);
+	}
+}
+
+static u16 ycbcr_to_r(struct tpg_data *tpg, int y, int cb, int cr)
+{
+	int r;
+
+	y -= 16 << 4;
+	cb -= 128 << 4;
+	cr -= 128 << 4;
+	switch (tpg->colorspace) {
+	case V4L2_COLORSPACE_SMPTE170M:
+	case V4L2_COLORSPACE_470_SYSTEM_M:
+	case V4L2_COLORSPACE_470_SYSTEM_BG:
+		r = 4769 * y + 6537 * cr;
+		break;
+	case V4L2_COLORSPACE_SMPTE240M:
+		r = 4769 * y + 7376 * cr;
+		break;
+	case V4L2_COLORSPACE_REC709:
+	case V4L2_COLORSPACE_SRGB:
+	default:
+		r = 4769 * y + 7343 * cr;
+		break;
+	}
+	return clamp(r >> 12, 0, 0xff0);
+}
+
+static u16 ycbcr_to_g(struct tpg_data *tpg, int y, int cb, int cr)
+{
+	int g;
+
+	y -= 16 << 4;
+	cb -= 128 << 4;
+	cr -= 128 << 4;
+	switch (tpg->colorspace) {
+	case V4L2_COLORSPACE_SMPTE170M:
+	case V4L2_COLORSPACE_470_SYSTEM_M:
+	case V4L2_COLORSPACE_470_SYSTEM_BG:
+		g = 4769 * y - 1605 * cb - 3330 * cr;
+		break;
+	case V4L2_COLORSPACE_SMPTE240M:
+		g = 4769 * y - 1055 * cb - 2341 * cr;
+		break;
+	case V4L2_COLORSPACE_REC709:
+	case V4L2_COLORSPACE_SRGB:
+	default:
+		g = 4769 * y - 873 * cb - 2183 * cr;
+		break;
+	}
+	return clamp(g >> 12, 0, 0xff0);
+}
+
+static u16 ycbcr_to_b(struct tpg_data *tpg, int y, int cb, int cr)
+{
+	int b;
+
+	y -= 16 << 4;
+	cb -= 128 << 4;
+	cr -= 128 << 4;
+	switch (tpg->colorspace) {
+	case V4L2_COLORSPACE_SMPTE170M:
+	case V4L2_COLORSPACE_470_SYSTEM_M:
+	case V4L2_COLORSPACE_470_SYSTEM_BG:
+		b = 4769 * y + 7343 * cb;
+		break;
+	case V4L2_COLORSPACE_SMPTE240M:
+		b = 4769 * y + 8552 * cb;
+		break;
+	case V4L2_COLORSPACE_REC709:
+	case V4L2_COLORSPACE_SRGB:
+	default:
+		b = 4769 * y + 8652 * cb;
+		break;
+	}
+	return clamp(b >> 12, 0, 0xff0);
+}
+
+/* precalculate color bar values to speed up rendering */
+static void precalculate_color(struct tpg_data *tpg, int k)
+{
+	int col = k;
+	int r = tpg_colors[col].r;
+	int g = tpg_colors[col].g;
+	int b = tpg_colors[col].b;
+
+	if (k == TPG_COLOR_TEXTBG) {
+		col = tpg_get_textbg_color(tpg);
+
+		r = tpg_colors[col].r;
+		g = tpg_colors[col].g;
+		b = tpg_colors[col].b;
+	} else if (k == TPG_COLOR_TEXTFG) {
+		col = tpg_get_textfg_color(tpg);
+
+		r = tpg_colors[col].r;
+		g = tpg_colors[col].g;
+		b = tpg_colors[col].b;
+	} else if (tpg->pattern == TPG_PAT_NOISE) {
+		r = g = b = prandom_u32_max(256);
+	} else if (k == TPG_COLOR_RANDOM) {
+		r = g = b = tpg->qual_offset + prandom_u32_max(196);
+	} else if (k >= TPG_COLOR_RAMP) {
+		r = g = b = k - TPG_COLOR_RAMP;
+	}
+
+	if (tpg->pattern == TPG_PAT_CSC_COLORBAR) {
+		r = tpg_csc_colors[tpg->colorspace][col].r;
+		g = tpg_csc_colors[tpg->colorspace][col].g;
+		b = tpg_csc_colors[tpg->colorspace][col].b;
+	} else {
+		r <<= 4;
+		g <<= 4;
+		b <<= 4;
+	}
+	if (tpg->qual == TPG_QUAL_GRAY)
+		r = g = b = color_to_y(tpg, r, g, b);
+
+	/*
+	 * The assumption is that the RGB output is always full range,
+	 * so only if the rgb_range overrides the 'real' rgb range do
+	 * we need to convert the RGB values.
+	 *
+	 * Currently there is no way of signalling to userspace if you
+	 * are actually giving it limited range RGB (or full range
+	 * YUV for that matter).
+	 *
+	 * Remember that r, g and b are still in the 0 - 0xff0 range.
+	 */
+	if (tpg->real_rgb_range == V4L2_DV_RGB_RANGE_LIMITED &&
+	    tpg->rgb_range == V4L2_DV_RGB_RANGE_FULL) {
+		/*
+		 * Convert from full range (which is what r, g and b are)
+		 * to limited range (which is the 'real' RGB range), which
+		 * is then interpreted as full range.
+		 */
+		r = (r * 219) / 255 + (16 << 4);
+		g = (g * 219) / 255 + (16 << 4);
+		b = (b * 219) / 255 + (16 << 4);
+	} else if (tpg->real_rgb_range != V4L2_DV_RGB_RANGE_LIMITED &&
+		   tpg->rgb_range == V4L2_DV_RGB_RANGE_LIMITED) {
+		/*
+		 * Clamp r, g and b to the limited range and convert to full
+		 * range since that's what we deliver.
+		 */
+		r = clamp(r, 16 << 4, 235 << 4);
+		g = clamp(g, 16 << 4, 235 << 4);
+		b = clamp(b, 16 << 4, 235 << 4);
+		r = (r - (16 << 4)) * 255 / 219;
+		g = (g - (16 << 4)) * 255 / 219;
+		b = (b - (16 << 4)) * 255 / 219;
+	}
+
+	if (tpg->brightness != 128 || tpg->contrast != 128 ||
+	    tpg->saturation != 128 || tpg->hue) {
+		/* Implement these operations */
+
+		/* First convert to YCbCr */
+		int y = color_to_y(tpg, r, g, b);	/* Luma */
+		int cb = color_to_cb(tpg, r, g, b);	/* Cb */
+		int cr = color_to_cr(tpg, r, g, b);	/* Cr */
+		int tmp_cb, tmp_cr;
+
+		y = (16 << 4) + ((y - (16 << 4)) * tpg->contrast) / 128;
+		y += (tpg->brightness << 4) - (128 << 4);
+
+		cb -= 128 << 4;
+		cr -= 128 << 4;
+		tmp_cb = (cb * cos[128 + tpg->hue]) / 127 + (cr * sin[128 + tpg->hue]) / 127;
+		tmp_cr = (cr * cos[128 + tpg->hue]) / 127 - (cb * sin[128 + tpg->hue]) / 127;
+
+		cb = (128 << 4) + (tmp_cb * tpg->contrast * tpg->saturation) / (128 * 128);
+		cr = (128 << 4) + (tmp_cr * tpg->contrast * tpg->saturation) / (128 * 128);
+		if (tpg->is_yuv) {
+			tpg->colors[k][0] = clamp(y >> 4, 1, 254);
+			tpg->colors[k][1] = clamp(cb >> 4, 1, 254);
+			tpg->colors[k][2] = clamp(cr >> 4, 1, 254);
+			return;
+		}
+		r = ycbcr_to_r(tpg, y, cb, cr);
+		g = ycbcr_to_g(tpg, y, cb, cr);
+		b = ycbcr_to_b(tpg, y, cb, cr);
+	}
+
+	if (tpg->is_yuv) {
+		/* Convert to YCbCr */
+		u16 y = color_to_y(tpg, r, g, b);	/* Luma */
+		u16 cb = color_to_cb(tpg, r, g, b);	/* Cb */
+		u16 cr = color_to_cr(tpg, r, g, b);	/* Cr */
+
+		tpg->colors[k][0] = clamp(y >> 4, 1, 254);
+		tpg->colors[k][1] = clamp(cb >> 4, 1, 254);
+		tpg->colors[k][2] = clamp(cr >> 4, 1, 254);
+	} else {
+		switch (tpg->fourcc) {
+		case V4L2_PIX_FMT_RGB565:
+		case V4L2_PIX_FMT_RGB565X:
+			r >>= 7;
+			g >>= 6;
+			b >>= 7;
+			break;
+		case V4L2_PIX_FMT_RGB555:
+		case V4L2_PIX_FMT_RGB555X:
+			r >>= 7;
+			g >>= 7;
+			b >>= 7;
+			break;
+		default:
+			r >>= 4;
+			g >>= 4;
+			b >>= 4;
+			break;
+		}
+
+		tpg->colors[k][0] = r;
+		tpg->colors[k][1] = g;
+		tpg->colors[k][2] = b;
+	}
+}
+
+static void tpg_precalculate_colors(struct tpg_data *tpg)
+{
+	int k;
+
+	for (k = 0; k < TPG_COLOR_MAX; k++)
+		precalculate_color(tpg, k);
+}
+
+/* 'odd' is true for pixels 1, 3, 5, etc. and false for pixels 0, 2, 4, etc. */
+static void gen_twopix(struct tpg_data *tpg,
+		u8 buf[TPG_MAX_PLANES][8], int color, bool odd)
+{
+	unsigned offset = odd * tpg->twopixelsize[0] / 2;
+	u8 alpha = tpg->alpha_component;
+	u8 r_y, g_u, b_v;
+
+	if (tpg->alpha_red_only && color != TPG_COLOR_CSC_RED &&
+				   color != TPG_COLOR_100_RED &&
+				   color != TPG_COLOR_75_RED)
+		alpha = 0;
+	if (color == TPG_COLOR_RANDOM)
+		precalculate_color(tpg, color);
+	r_y = tpg->colors[color][0]; /* R or precalculated Y */
+	g_u = tpg->colors[color][1]; /* G or precalculated U */
+	b_v = tpg->colors[color][2]; /* B or precalculated V */
+
+	switch (tpg->fourcc) {
+	case V4L2_PIX_FMT_NV16M:
+		buf[0][offset] = r_y;
+		buf[1][offset] = odd ? b_v : g_u;
+		break;
+	case V4L2_PIX_FMT_NV61M:
+		buf[0][offset] = r_y;
+		buf[1][offset] = odd ? g_u : b_v;
+		break;
+
+	case V4L2_PIX_FMT_YUYV:
+		buf[0][offset] = r_y;
+		buf[0][offset + 1] = odd ? b_v : g_u;
+		break;
+	case V4L2_PIX_FMT_UYVY:
+		buf[0][offset] = odd ? b_v : g_u;
+		buf[0][offset + 1] = r_y;
+		break;
+	case V4L2_PIX_FMT_YVYU:
+		buf[0][offset] = r_y;
+		buf[0][offset + 1] = odd ? g_u : b_v;
+		break;
+	case V4L2_PIX_FMT_VYUY:
+		buf[0][offset] = odd ? g_u : b_v;
+		buf[0][offset + 1] = r_y;
+		break;
+	case V4L2_PIX_FMT_RGB565:
+		buf[0][offset] = (g_u << 5) | b_v;
+		buf[0][offset + 1] = (r_y << 3) | (g_u >> 3);
+		break;
+	case V4L2_PIX_FMT_RGB565X:
+		buf[0][offset] = (r_y << 3) | (g_u >> 3);
+		buf[0][offset + 1] = (g_u << 5) | b_v;
+		break;
+	case V4L2_PIX_FMT_RGB555:
+		buf[0][offset] = (g_u << 5) | b_v;
+		buf[0][offset + 1] = (alpha & 0x80) | (r_y << 2) | (g_u >> 3);
+		break;
+	case V4L2_PIX_FMT_RGB555X:
+		buf[0][offset] = (alpha & 0x80) | (r_y << 2) | (g_u >> 3);
+		buf[0][offset + 1] = (g_u << 5) | b_v;
+		break;
+	case V4L2_PIX_FMT_RGB24:
+		buf[0][offset] = r_y;
+		buf[0][offset + 1] = g_u;
+		buf[0][offset + 2] = b_v;
+		break;
+	case V4L2_PIX_FMT_BGR24:
+		buf[0][offset] = b_v;
+		buf[0][offset + 1] = g_u;
+		buf[0][offset + 2] = r_y;
+		break;
+	case V4L2_PIX_FMT_RGB32:
+		buf[0][offset] = alpha;
+		buf[0][offset + 1] = r_y;
+		buf[0][offset + 2] = g_u;
+		buf[0][offset + 3] = b_v;
+		break;
+	case V4L2_PIX_FMT_BGR32:
+		buf[0][offset] = b_v;
+		buf[0][offset + 1] = g_u;
+		buf[0][offset + 2] = r_y;
+		buf[0][offset + 3] = alpha;
+		break;
+	}
+}
+
+/* Return how many pattern lines are used by the current pattern. */
+static unsigned tpg_get_pat_lines(struct tpg_data *tpg)
+{
+	switch (tpg->pattern) {
+	case TPG_PAT_CHECKERS_16X16:
+	case TPG_PAT_CHECKERS_1X1:
+	case TPG_PAT_ALTERNATING_HLINES:
+	case TPG_PAT_CROSS_1_PIXEL:
+	case TPG_PAT_CROSS_2_PIXELS:
+	case TPG_PAT_CROSS_10_PIXELS:
+		return 2;
+	case TPG_PAT_100_COLORSQUARES:
+	case TPG_PAT_100_HCOLORBAR:
+		return 8;
+	default:
+		return 1;
+	}
+}
+
+/* Which pattern line should be used for the given frame line. */
+static unsigned tpg_get_pat_line(struct tpg_data *tpg, unsigned line)
+{
+	switch (tpg->pattern) {
+	case TPG_PAT_CHECKERS_16X16:
+		return (line >> 4) & 1;
+	case TPG_PAT_CHECKERS_1X1:
+	case TPG_PAT_ALTERNATING_HLINES:
+		return line & 1;
+	case TPG_PAT_100_COLORSQUARES:
+	case TPG_PAT_100_HCOLORBAR:
+		return (line * 8) / tpg->src_height;
+	case TPG_PAT_CROSS_1_PIXEL:
+		return line == tpg->src_height / 2;
+	case TPG_PAT_CROSS_2_PIXELS:
+		return (line + 1) / 2 == tpg->src_height / 4;
+	case TPG_PAT_CROSS_10_PIXELS:
+		return (line + 10) / 20 == tpg->src_height / 40;
+	default:
+		return 0;
+	}
+}
+
+/*
+ * Which color should be used for the given pattern line and X coordinate.
+ * Note: x is in the range 0 to 2 * tpg->src_width.
+ */
+static enum tpg_color tpg_get_color(struct tpg_data *tpg, unsigned pat_line, unsigned x)
+{
+	/* Maximum number of bars are TPG_COLOR_MAX - otherwise, the input print code
+	   should be modified */
+	static const enum tpg_color bars[3][8] = {
+		/* Standard ITU-R 75% color bar sequence */
+		{ TPG_COLOR_CSC_WHITE,   TPG_COLOR_75_YELLOW,
+		  TPG_COLOR_75_CYAN,     TPG_COLOR_75_GREEN,
+		  TPG_COLOR_75_MAGENTA,  TPG_COLOR_75_RED,
+		  TPG_COLOR_75_BLUE,     TPG_COLOR_100_BLACK, },
+		/* Standard ITU-R 100% color bar sequence */
+		{ TPG_COLOR_100_WHITE,   TPG_COLOR_100_YELLOW,
+		  TPG_COLOR_100_CYAN,    TPG_COLOR_100_GREEN,
+		  TPG_COLOR_100_MAGENTA, TPG_COLOR_100_RED,
+		  TPG_COLOR_100_BLUE,    TPG_COLOR_100_BLACK, },
+		/* Color bar sequence suitable to test CSC */
+		{ TPG_COLOR_CSC_WHITE,   TPG_COLOR_CSC_YELLOW,
+		  TPG_COLOR_CSC_CYAN,    TPG_COLOR_CSC_GREEN,
+		  TPG_COLOR_CSC_MAGENTA, TPG_COLOR_CSC_RED,
+		  TPG_COLOR_CSC_BLUE,    TPG_COLOR_CSC_BLACK, },
+	};
+
+	switch (tpg->pattern) {
+	case TPG_PAT_75_COLORBAR:
+	case TPG_PAT_100_COLORBAR:
+	case TPG_PAT_CSC_COLORBAR:
+		return bars[tpg->pattern][((x * 8) / tpg->src_width) % 8];
+	case TPG_PAT_100_COLORSQUARES:
+		return bars[1][(pat_line + (x * 8) / tpg->src_width) % 8];
+	case TPG_PAT_100_HCOLORBAR:
+		return bars[1][pat_line];
+	case TPG_PAT_BLACK:
+		return TPG_COLOR_100_BLACK;
+	case TPG_PAT_WHITE:
+		return TPG_COLOR_100_WHITE;
+	case TPG_PAT_RED:
+		return TPG_COLOR_100_RED;
+	case TPG_PAT_GREEN:
+		return TPG_COLOR_100_GREEN;
+	case TPG_PAT_BLUE:
+		return TPG_COLOR_100_BLUE;
+	case TPG_PAT_CHECKERS_16X16:
+		return (((x >> 4) & 1) ^ (pat_line & 1)) ?
+			TPG_COLOR_100_BLACK : TPG_COLOR_100_WHITE;
+	case TPG_PAT_CHECKERS_1X1:
+		return ((x & 1) ^ (pat_line & 1)) ?
+			TPG_COLOR_100_WHITE : TPG_COLOR_100_BLACK;
+	case TPG_PAT_ALTERNATING_HLINES:
+		return pat_line ? TPG_COLOR_100_WHITE : TPG_COLOR_100_BLACK;
+	case TPG_PAT_ALTERNATING_VLINES:
+		return (x & 1) ? TPG_COLOR_100_WHITE : TPG_COLOR_100_BLACK;
+	case TPG_PAT_CROSS_1_PIXEL:
+		if (pat_line || (x % tpg->src_width) == tpg->src_width / 2)
+			return TPG_COLOR_100_BLACK;
+		return TPG_COLOR_100_WHITE;
+	case TPG_PAT_CROSS_2_PIXELS:
+		if (pat_line || ((x % tpg->src_width) + 1) / 2 == tpg->src_width / 4)
+			return TPG_COLOR_100_BLACK;
+		return TPG_COLOR_100_WHITE;
+	case TPG_PAT_CROSS_10_PIXELS:
+		if (pat_line || ((x % tpg->src_width) + 10) / 20 == tpg->src_width / 40)
+			return TPG_COLOR_100_BLACK;
+		return TPG_COLOR_100_WHITE;
+	case TPG_PAT_GRAY_RAMP:
+		return TPG_COLOR_RAMP + ((x % tpg->src_width) * 256) / tpg->src_width;
+	default:
+		return TPG_COLOR_100_RED;
+	}
+}
+
+/*
+ * Given the pixel aspect ratio and video aspect ratio calculate the
+ * coordinates of a centered square and the coordinates of the border of
+ * the active video area. The coordinates are relative to the source
+ * frame rectangle.
+ */
+static void tpg_calculate_square_border(struct tpg_data *tpg)
+{
+	unsigned w = tpg->src_width;
+	unsigned h = tpg->src_height;
+	unsigned sq_w, sq_h;
+
+	sq_w = (w * 2 / 5) & ~1;
+	if (((w - sq_w) / 2) & 1)
+		sq_w += 2;
+	sq_h = sq_w;
+	tpg->square.width = sq_w;
+	if (tpg->vid_aspect == TPG_VIDEO_ASPECT_16X9_ANAMORPHIC) {
+		unsigned ana_sq_w = (sq_w / 4) * 3;
+
+		if (((w - ana_sq_w) / 2) & 1)
+			ana_sq_w += 2;
+		tpg->square.width = ana_sq_w;
+	}
+	tpg->square.left = (w - tpg->square.width) / 2;
+	if (tpg->pix_aspect == TPG_PIXEL_ASPECT_NTSC)
+		sq_h = sq_w * 10 / 11;
+	else if (tpg->pix_aspect == TPG_PIXEL_ASPECT_PAL)
+		sq_h = sq_w * 59 / 54;
+	tpg->square.height = sq_h;
+	tpg->square.top = (h - sq_h) / 2;
+	tpg->border.left = 0;
+	tpg->border.width = w;
+	tpg->border.top = 0;
+	tpg->border.height = h;
+	switch (tpg->vid_aspect) {
+	case TPG_VIDEO_ASPECT_4X3:
+		if (tpg->pix_aspect)
+			return;
+		if (3 * w >= 4 * h) {
+			tpg->border.width = ((4 * h) / 3) & ~1;
+			if (((w - tpg->border.width) / 2) & ~1)
+				tpg->border.width -= 2;
+			tpg->border.left = (w - tpg->border.width) / 2;
+			break;
+		}
+		tpg->border.height = ((3 * w) / 4) & ~1;
+		tpg->border.top = (h - tpg->border.height) / 2;
+		break;
+	case TPG_VIDEO_ASPECT_16X9_CENTRE:
+		if (tpg->pix_aspect) {
+			tpg->border.height = tpg->pix_aspect == TPG_PIXEL_ASPECT_NTSC ? 400 : 430;
+			tpg->border.top = (h - tpg->border.height) / 2;
+			break;
+		}
+		if (9 * w >= 16 * h) {
+			tpg->border.width = ((16 * h) / 9) & ~1;
+			if (((w - tpg->border.width) / 2) & ~1)
+				tpg->border.width -= 2;
+			tpg->border.left = (w - tpg->border.width) / 2;
+			break;
+		}
+		tpg->border.height = ((9 * w) / 16) & ~1;
+		tpg->border.top = (h - tpg->border.height) / 2;
+		break;
+	default:
+		break;
+	}
+}
+
+static void tpg_precalculate_line(struct tpg_data *tpg)
+{
+	enum tpg_color contrast = tpg->pattern == TPG_PAT_GREEN ?
+				TPG_COLOR_100_RED : TPG_COLOR_100_GREEN;
+	unsigned pat;
+	unsigned p;
+	unsigned x;
+
+	for (pat = 0; pat < tpg_get_pat_lines(tpg); pat++) {
+		/* Coarse scaling with Bresenham */
+		unsigned int_part = tpg->src_width / tpg->scaled_width;
+		unsigned fract_part = tpg->src_width % tpg->scaled_width;
+		unsigned src_x = 0;
+		unsigned error = 0;
+
+		for (x = 0; x < tpg->scaled_width * 2; x += 2) {
+			unsigned real_x = src_x;
+			enum tpg_color color1, color2;
+			u8 pix[TPG_MAX_PLANES][8];
+
+			real_x = tpg->hflip ? tpg->src_width * 2 - real_x - 2 : real_x;
+			color1 = tpg_get_color(tpg, pat, real_x);
+
+			src_x += int_part;
+			error += fract_part;
+			if (error >= tpg->scaled_width) {
+				error -= tpg->scaled_width;
+				src_x++;
+			}
+
+			real_x = src_x;
+			real_x = tpg->hflip ? tpg->src_width * 2 - real_x - 2 : real_x;
+			color2 = tpg_get_color(tpg, pat, real_x);
+
+			src_x += int_part;
+			error += fract_part;
+			if (error >= tpg->scaled_width) {
+				error -= tpg->scaled_width;
+				src_x++;
+			}
+
+			gen_twopix(tpg, pix, tpg->hflip ? color2 : color1, 0);
+			gen_twopix(tpg, pix, tpg->hflip ? color1 : color2, 1);
+			for (p = 0; p < tpg->planes; p++) {
+				unsigned twopixsize = tpg->twopixelsize[p];
+				u8 *pos = tpg->lines[pat][p] + x * twopixsize / 2;
+
+				memcpy(pos, pix[p], twopixsize);
+			}
+		}
+	}
+	for (x = 0; x < tpg->scaled_width; x += 2) {
+		u8 pix[TPG_MAX_PLANES][8];
+
+		gen_twopix(tpg, pix, contrast, 0);
+		gen_twopix(tpg, pix, contrast, 1);
+		for (p = 0; p < tpg->planes; p++) {
+			unsigned twopixsize = tpg->twopixelsize[p];
+			u8 *pos = tpg->contrast_line[p] + x * twopixsize / 2;
+
+			memcpy(pos, pix[p], twopixsize);
+		}
+	}
+	for (x = 0; x < tpg->scaled_width; x += 2) {
+		u8 pix[TPG_MAX_PLANES][8];
+
+		gen_twopix(tpg, pix, TPG_COLOR_100_BLACK, 0);
+		gen_twopix(tpg, pix, TPG_COLOR_100_BLACK, 1);
+		for (p = 0; p < tpg->planes; p++) {
+			unsigned twopixsize = tpg->twopixelsize[p];
+			u8 *pos = tpg->black_line[p] + x * twopixsize / 2;
+
+			memcpy(pos, pix[p], twopixsize);
+		}
+	}
+	for (x = 0; x < tpg->scaled_width * 2; x += 2) {
+		u8 pix[TPG_MAX_PLANES][8];
+
+		gen_twopix(tpg, pix, TPG_COLOR_RANDOM, 0);
+		gen_twopix(tpg, pix, TPG_COLOR_RANDOM, 1);
+		for (p = 0; p < tpg->planes; p++) {
+			unsigned twopixsize = tpg->twopixelsize[p];
+			u8 *pos = tpg->random_line[p] + x * twopixsize / 2;
+
+			memcpy(pos, pix[p], twopixsize);
+		}
+	}
+	gen_twopix(tpg, tpg->textbg, TPG_COLOR_TEXTBG, 0);
+	gen_twopix(tpg, tpg->textbg, TPG_COLOR_TEXTBG, 1);
+	gen_twopix(tpg, tpg->textfg, TPG_COLOR_TEXTFG, 0);
+	gen_twopix(tpg, tpg->textfg, TPG_COLOR_TEXTFG, 1);
+}
+
+/* need this to do rgb24 rendering */
+typedef struct { u16 __; u8 _; } __packed x24;
+
+void tpg_gen_text(struct tpg_data *tpg, u8 *basep[TPG_MAX_PLANES][2],
+		int y, int x, char *text)
+{
+	int line;
+	unsigned step = V4L2_FIELD_HAS_T_OR_B(tpg->field) ? 2 : 1;
+	unsigned div = step;
+	unsigned first = 0;
+	unsigned len = strlen(text);
+	unsigned p;
+
+	if (font8x16 == NULL || basep == NULL)
+		return;
+
+	/* Checks if it is possible to show string */
+	if (y + 16 >= tpg->compose.height || x + 8 >= tpg->compose.width)
+		return;
+
+	if (len > (tpg->compose.width - x) / 8)
+		len = (tpg->compose.width - x) / 8;
+	if (tpg->vflip)
+		y = tpg->compose.height - y - 16;
+	if (tpg->hflip)
+		x = tpg->compose.width - x - 8;
+	y += tpg->compose.top;
+	x += tpg->compose.left;
+	if (tpg->field == V4L2_FIELD_BOTTOM)
+		first = 1;
+	else if (tpg->field == V4L2_FIELD_SEQ_TB || tpg->field == V4L2_FIELD_SEQ_BT)
+		div = 2;
+
+	for (p = 0; p < tpg->planes; p++) {
+		/* Print stream time */
+#define PRINTSTR(PIXTYPE) do {	\
+	PIXTYPE fg;	\
+	PIXTYPE bg;	\
+	memcpy(&fg, tpg->textfg[p], sizeof(PIXTYPE));	\
+	memcpy(&bg, tpg->textbg[p], sizeof(PIXTYPE));	\
+	\
+	for (line = first; line < 16; line += step) {	\
+		int l = tpg->vflip ? 15 - line : line; \
+		PIXTYPE *pos = (PIXTYPE *)(basep[p][line & 1] + \
+			       ((y * step + l) / div) * tpg->bytesperline[p] + \
+			       x * sizeof(PIXTYPE));	\
+		unsigned s;	\
+	\
+		for (s = 0; s < len; s++) {	\
+			u8 chr = font8x16[text[s] * 16 + line];	\
+	\
+			if (tpg->hflip) { \
+				pos[7] = (chr & (0x01 << 7) ? fg : bg);	\
+				pos[6] = (chr & (0x01 << 6) ? fg : bg);	\
+				pos[5] = (chr & (0x01 << 5) ? fg : bg);	\
+				pos[4] = (chr & (0x01 << 4) ? fg : bg);	\
+				pos[3] = (chr & (0x01 << 3) ? fg : bg);	\
+				pos[2] = (chr & (0x01 << 2) ? fg : bg);	\
+				pos[1] = (chr & (0x01 << 1) ? fg : bg);	\
+				pos[0] = (chr & (0x01 << 0) ? fg : bg);	\
+			} else { \
+				pos[0] = (chr & (0x01 << 7) ? fg : bg);	\
+				pos[1] = (chr & (0x01 << 6) ? fg : bg);	\
+				pos[2] = (chr & (0x01 << 5) ? fg : bg);	\
+				pos[3] = (chr & (0x01 << 4) ? fg : bg);	\
+				pos[4] = (chr & (0x01 << 3) ? fg : bg);	\
+				pos[5] = (chr & (0x01 << 2) ? fg : bg);	\
+				pos[6] = (chr & (0x01 << 1) ? fg : bg);	\
+				pos[7] = (chr & (0x01 << 0) ? fg : bg);	\
+			} \
+	\
+			pos += tpg->hflip ? -8 : 8;	\
+		}	\
+	}	\
+} while (0)
+
+		switch (tpg->twopixelsize[p]) {
+		case 2:
+			PRINTSTR(u8); break;
+		case 4:
+			PRINTSTR(u16); break;
+		case 6:
+			PRINTSTR(x24); break;
+		case 8:
+			PRINTSTR(u32); break;
+		}
+	}
+}
+
+void tpg_update_mv_step(struct tpg_data *tpg)
+{
+	int factor = tpg->mv_hor_mode > TPG_MOVE_NONE ? -1 : 1;
+
+	if (tpg->hflip)
+		factor = -factor;
+	switch (tpg->mv_hor_mode) {
+	case TPG_MOVE_NEG_FAST:
+	case TPG_MOVE_POS_FAST:
+		tpg->mv_hor_step = ((tpg->src_width + 319) / 320) * 4;
+		break;
+	case TPG_MOVE_NEG:
+	case TPG_MOVE_POS:
+		tpg->mv_hor_step = ((tpg->src_width + 639) / 640) * 4;
+		break;
+	case TPG_MOVE_NEG_SLOW:
+	case TPG_MOVE_POS_SLOW:
+		tpg->mv_hor_step = 2;
+		break;
+	case TPG_MOVE_NONE:
+		tpg->mv_hor_step = 0;
+		break;
+	}
+	tpg->mv_hor_step *= factor;
+
+	factor = tpg->mv_vert_mode > TPG_MOVE_NONE ? -1 : 1;
+	switch (tpg->mv_vert_mode) {
+	case TPG_MOVE_NEG_FAST:
+	case TPG_MOVE_POS_FAST:
+		tpg->mv_vert_step = ((tpg->src_width + 319) / 320) * 4;
+		break;
+	case TPG_MOVE_NEG:
+	case TPG_MOVE_POS:
+		tpg->mv_vert_step = ((tpg->src_width + 639) / 640) * 4;
+		break;
+	case TPG_MOVE_NEG_SLOW:
+	case TPG_MOVE_POS_SLOW:
+		tpg->mv_vert_step = 1;
+		break;
+	case TPG_MOVE_NONE:
+		tpg->mv_vert_step = 0;
+		break;
+	}
+	tpg->mv_vert_step *= factor;
+}
+
+/* Map the line number relative to the crop rectangle to a frame line number */
+static unsigned tpg_calc_frameline(struct tpg_data *tpg, unsigned src_y,
+				    unsigned field)
+{
+	switch (field) {
+	case V4L2_FIELD_TOP:
+		return tpg->crop.top + src_y * 2;
+	case V4L2_FIELD_BOTTOM:
+		return tpg->crop.top + src_y * 2 + 1;
+	default:
+		return src_y + tpg->crop.top;
+	}
+}
+
+/*
+ * Map the line number relative to the compose rectangle to a destination
+ * buffer line number.
+ */
+static unsigned tpg_calc_buffer_line(struct tpg_data *tpg, unsigned y,
+				    unsigned field)
+{
+	y += tpg->compose.top;
+	switch (field) {
+	case V4L2_FIELD_SEQ_TB:
+		if (y & 1)
+			return tpg->buf_height / 2 + y / 2;
+		return y / 2;
+	case V4L2_FIELD_SEQ_BT:
+		if (y & 1)
+			return y / 2;
+		return tpg->buf_height / 2 + y / 2;
+	default:
+		return y;
+	}
+}
+
+void tpg_fillbuffer(struct tpg_data *tpg, u8 *basep[TPG_MAX_PLANES][2],
+		v4l2_std_id std, unsigned p, u8 *vbuf)
+{
+	bool is_tv = std;
+	bool is_60hz = is_tv && (std & V4L2_STD_525_60);
+	unsigned mv_hor_old = tpg->mv_hor_count % tpg->src_width;
+	unsigned mv_hor_new = (tpg->mv_hor_count + tpg->mv_hor_step) % tpg->src_width;
+	unsigned mv_vert_old = tpg->mv_vert_count % tpg->src_height;
+	unsigned mv_vert_new = (tpg->mv_vert_count + tpg->mv_vert_step) % tpg->src_height;
+	unsigned wss_width;
+	unsigned f;
+	int hmax = (tpg->compose.height * tpg->perc_fill) / 100;
+	int h;
+	unsigned twopixsize = tpg->twopixelsize[p];
+	unsigned img_width = tpg->compose.width * twopixsize / 2;
+	unsigned line_offset;
+	unsigned left_pillar_width = 0;
+	unsigned right_pillar_start = img_width;
+	unsigned stride = tpg->bytesperline[p];
+	unsigned factor = V4L2_FIELD_HAS_T_OR_B(tpg->field) ? 2 : 1;
+	u8 *orig_vbuf = vbuf;
+
+	/* Coarse scaling with Bresenham */
+	unsigned int_part = (tpg->crop.height / factor) / tpg->compose.height;
+	unsigned fract_part = (tpg->crop.height / factor) % tpg->compose.height;
+	unsigned src_y = 0;
+	unsigned error = 0;
+
+	if (tpg->recalc_colors) {
+		tpg->recalc_colors = false;
+		tpg->recalc_lines = true;
+		tpg_precalculate_colors(tpg);
+	}
+	if (tpg->recalc_square_border) {
+		tpg->recalc_square_border = false;
+		tpg_calculate_square_border(tpg);
+	}
+	if (tpg->recalc_lines) {
+		tpg->recalc_lines = false;
+		tpg_precalculate_line(tpg);
+	}
+
+	mv_hor_old = (mv_hor_old * tpg->scaled_width / tpg->src_width) & ~1;
+	mv_hor_new = (mv_hor_new * tpg->scaled_width / tpg->src_width) & ~1;
+	wss_width = tpg->crop.left < tpg->src_width / 2 ?
+			tpg->src_width / 2 - tpg->crop.left : 0;
+	if (wss_width > tpg->crop.width)
+		wss_width = tpg->crop.width;
+	wss_width = wss_width * tpg->scaled_width / tpg->src_width;
+
+	if (basep) {
+		basep[p][0] = vbuf;
+		basep[p][1] = vbuf;
+		if (tpg->field == V4L2_FIELD_SEQ_TB)
+			basep[p][1] += tpg->buf_height * stride / 2;
+		else if (tpg->field == V4L2_FIELD_SEQ_BT)
+			basep[p][0] += tpg->buf_height * stride / 2;
+	}
+
+	vbuf += tpg->compose.left * twopixsize / 2;
+	line_offset = tpg->crop.left * tpg->scaled_width / tpg->src_width;
+	line_offset = (line_offset & ~1) * twopixsize / 2;
+	if (tpg->crop.left < tpg->border.left) {
+		left_pillar_width = tpg->border.left - tpg->crop.left;
+		if (left_pillar_width > tpg->crop.width)
+			left_pillar_width = tpg->crop.width;
+		left_pillar_width = (left_pillar_width * tpg->scaled_width) / tpg->src_width;
+		left_pillar_width = (left_pillar_width & ~1) * twopixsize / 2;
+	}
+	if (tpg->crop.left + tpg->crop.width > tpg->border.left + tpg->border.width) {
+		right_pillar_start = tpg->border.left + tpg->border.width - tpg->crop.left;
+		right_pillar_start = (right_pillar_start * tpg->scaled_width) / tpg->src_width;
+		right_pillar_start = (right_pillar_start & ~1) * twopixsize / 2;
+		if (right_pillar_start > img_width)
+			right_pillar_start = img_width;
+	}
+
+	f = tpg->field == (is_60hz ? V4L2_FIELD_TOP : V4L2_FIELD_BOTTOM);
+
+	for (h = 0; h < tpg->compose.height; h++) {
+		bool even;
+		bool fill_blank = false;
+		unsigned frame_line;
+		unsigned buf_line;
+		unsigned pat_line_old;
+		unsigned pat_line_new;
+		u8 *linestart_older;
+		u8 *linestart_newer;
+		u8 *linestart_top;
+		u8 *linestart_bottom;
+
+		frame_line = tpg_calc_frameline(tpg, src_y, tpg->field);
+		even = !(frame_line & 1);
+		buf_line = tpg_calc_buffer_line(tpg, h, tpg->field);
+		src_y += int_part;
+		error += fract_part;
+		if (error >= tpg->compose.height) {
+			error -= tpg->compose.height;
+			src_y++;
+		}
+
+		if (h >= hmax) {
+			if (hmax == tpg->compose.height)
+				continue;
+			if (!tpg->perc_fill_blank)
+				continue;
+			fill_blank = true;
+		}
+
+		if (tpg->vflip)
+			frame_line = tpg->src_height - frame_line - 1;
+
+		if (fill_blank) {
+			linestart_older = tpg->contrast_line[p];
+			linestart_newer = tpg->contrast_line[p];
+		} else if (tpg->qual != TPG_QUAL_NOISE &&
+			   (frame_line < tpg->border.top ||
+			    frame_line >= tpg->border.top + tpg->border.height)) {
+			linestart_older = tpg->black_line[p];
+			linestart_newer = tpg->black_line[p];
+		} else if (tpg->pattern == TPG_PAT_NOISE || tpg->qual == TPG_QUAL_NOISE) {
+			linestart_older = tpg->random_line[p] +
+					  twopixsize * prandom_u32_max(tpg->src_width / 2);
+			linestart_newer = tpg->random_line[p] +
+					  twopixsize * prandom_u32_max(tpg->src_width / 2);
+		} else {
+			pat_line_old = tpg_get_pat_line(tpg,
+						(frame_line + mv_vert_old) % tpg->src_height);
+			pat_line_new = tpg_get_pat_line(tpg,
+						(frame_line + mv_vert_new) % tpg->src_height);
+			linestart_older = tpg->lines[pat_line_old][p] +
+					  mv_hor_old * twopixsize / 2;
+			linestart_newer = tpg->lines[pat_line_new][p] +
+					  mv_hor_new * twopixsize / 2;
+			linestart_older += line_offset;
+			linestart_newer += line_offset;
+		}
+		if (is_60hz) {
+			linestart_top = linestart_newer;
+			linestart_bottom = linestart_older;
+		} else {
+			linestart_top = linestart_older;
+			linestart_bottom = linestart_newer;
+		}
+
+		switch (tpg->field) {
+		case V4L2_FIELD_INTERLACED:
+		case V4L2_FIELD_INTERLACED_TB:
+		case V4L2_FIELD_SEQ_TB:
+		case V4L2_FIELD_SEQ_BT:
+			if (even)
+				memcpy(vbuf + buf_line * stride, linestart_top, img_width);
+			else
+				memcpy(vbuf + buf_line * stride, linestart_bottom, img_width);
+			break;
+		case V4L2_FIELD_INTERLACED_BT:
+			if (even)
+				memcpy(vbuf + buf_line * stride, linestart_bottom, img_width);
+			else
+				memcpy(vbuf + buf_line * stride, linestart_top, img_width);
+			break;
+		case V4L2_FIELD_TOP:
+			memcpy(vbuf + buf_line * stride, linestart_top, img_width);
+			break;
+		case V4L2_FIELD_BOTTOM:
+			memcpy(vbuf + buf_line * stride, linestart_bottom, img_width);
+			break;
+		case V4L2_FIELD_NONE:
+		default:
+			memcpy(vbuf + buf_line * stride, linestart_older, img_width);
+			break;
+		}
+
+		if (is_tv && !is_60hz && frame_line == 0 && wss_width) {
+			/*
+			 * Replace the first half of the top line of a 50 Hz frame
+			 * with random data to simulate a WSS signal.
+			 */
+			u8 *wss = tpg->random_line[p] +
+				  twopixsize * prandom_u32_max(tpg->src_width / 2);
+
+			memcpy(vbuf + buf_line * stride, wss, wss_width * twopixsize / 2);
+		}
+	}
+
+	vbuf = orig_vbuf;
+	vbuf += tpg->compose.left * twopixsize / 2;
+	src_y = 0;
+	error = 0;
+	for (h = 0; h < tpg->compose.height; h++) {
+		unsigned frame_line = tpg_calc_frameline(tpg, src_y, tpg->field);
+		unsigned buf_line = tpg_calc_buffer_line(tpg, h, tpg->field);
+		const struct v4l2_rect *sq = &tpg->square;
+		const struct v4l2_rect *b = &tpg->border;
+		const struct v4l2_rect *c = &tpg->crop;
+
+		src_y += int_part;
+		error += fract_part;
+		if (error >= tpg->compose.height) {
+			error -= tpg->compose.height;
+			src_y++;
+		}
+
+		if (tpg->show_border && frame_line >= b->top &&
+		    frame_line < b->top + b->height) {
+			unsigned bottom = b->top + b->height - 1;
+			unsigned left = left_pillar_width;
+			unsigned right = right_pillar_start;
+
+			if (frame_line == b->top || frame_line == b->top + 1 ||
+			    frame_line == bottom || frame_line == bottom - 1) {
+				memcpy(vbuf + buf_line * stride + left, tpg->contrast_line[p],
+						right - left);
+			} else {
+				if (b->left >= c->left &&
+				    b->left < c->left + c->width)
+					memcpy(vbuf + buf_line * stride + left,
+						tpg->contrast_line[p], twopixsize);
+				if (b->left + b->width > c->left &&
+				    b->left + b->width <= c->left + c->width)
+					memcpy(vbuf + buf_line * stride + right - twopixsize,
+						tpg->contrast_line[p], twopixsize);
+			}
+		}
+		if (tpg->qual != TPG_QUAL_NOISE && frame_line >= b->top &&
+		    frame_line < b->top + b->height) {
+			memcpy(vbuf + buf_line * stride, tpg->black_line[p], left_pillar_width);
+			memcpy(vbuf + buf_line * stride + right_pillar_start, tpg->black_line[p],
+			       img_width - right_pillar_start);
+		}
+		if (tpg->show_square && frame_line >= sq->top &&
+		    frame_line < sq->top + sq->height &&
+		    sq->left < c->left + c->width &&
+		    sq->left + sq->width >= c->left) {
+			unsigned left = sq->left;
+			unsigned width = sq->width;
+
+			if (c->left > left) {
+				width -= c->left - left;
+				left = c->left;
+			}
+			if (c->left + c->width < left + width)
+				width -= left + width - c->left - c->width;
+			left -= c->left;
+			left = (left * tpg->scaled_width) / tpg->src_width;
+			left = (left & ~1) * twopixsize / 2;
+			width = (width * tpg->scaled_width) / tpg->src_width;
+			width = (width & ~1) * twopixsize / 2;
+			memcpy(vbuf + buf_line * stride + left, tpg->contrast_line[p], width);
+		}
+		if (tpg->insert_sav) {
+			unsigned offset = (tpg->compose.width / 6) * twopixsize;
+			u8 *p = vbuf + buf_line * stride + offset;
+			unsigned vact = 0, hact = 0;
+
+			p[0] = 0xff;
+			p[1] = 0;
+			p[2] = 0;
+			p[3] = 0x80 | (f << 6) | (vact << 5) | (hact << 4) |
+				((hact ^ vact) << 3) |
+				((hact ^ f) << 2) |
+				((f ^ vact) << 1) |
+				(hact ^ vact ^ f);
+		}
+		if (tpg->insert_eav) {
+			unsigned offset = (tpg->compose.width / 6) * 2 * twopixsize;
+			u8 *p = vbuf + buf_line * stride + offset;
+			unsigned vact = 0, hact = 1;
+
+			p[0] = 0xff;
+			p[1] = 0;
+			p[2] = 0;
+			p[3] = 0x80 | (f << 6) | (vact << 5) | (hact << 4) |
+				((hact ^ vact) << 3) |
+				((hact ^ f) << 2) |
+				((f ^ vact) << 1) |
+				(hact ^ vact ^ f);
+		}
+	}
+}
diff --git a/drivers/media/platform/vivi-tpg.h b/drivers/media/platform/vivi-tpg.h
new file mode 100644
index 0000000..0c1c339
--- /dev/null
+++ b/drivers/media/platform/vivi-tpg.h
@@ -0,0 +1,429 @@
+#ifndef _VIVI_TPG_H_
+#define _VIVI_TPG_H_
+
+#include <linux/version.h>
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/random.h>
+#include <linux/slab.h>
+#include <linux/videodev2.h>
+
+#include "vivi-colors.h"
+
+enum tpg_pattern {
+	TPG_PAT_75_COLORBAR,
+	TPG_PAT_100_COLORBAR,
+	TPG_PAT_CSC_COLORBAR,
+	TPG_PAT_100_HCOLORBAR,
+	TPG_PAT_100_COLORSQUARES,
+	TPG_PAT_BLACK,
+	TPG_PAT_WHITE,
+	TPG_PAT_RED,
+	TPG_PAT_GREEN,
+	TPG_PAT_BLUE,
+	TPG_PAT_CHECKERS_16X16,
+	TPG_PAT_CHECKERS_1X1,
+	TPG_PAT_ALTERNATING_HLINES,
+	TPG_PAT_ALTERNATING_VLINES,
+	TPG_PAT_CROSS_1_PIXEL,
+	TPG_PAT_CROSS_2_PIXELS,
+	TPG_PAT_CROSS_10_PIXELS,
+	TPG_PAT_GRAY_RAMP,
+
+	/* Must be the last pattern */
+	TPG_PAT_NOISE,
+};
+
+extern const char * const tpg_pattern_strings[];
+
+enum tpg_quality {
+	TPG_QUAL_COLOR,
+	TPG_QUAL_GRAY,
+	TPG_QUAL_NOISE
+};
+
+enum tpg_video_aspect {
+	TPG_VIDEO_ASPECT_IMAGE,
+	TPG_VIDEO_ASPECT_4X3,
+	TPG_VIDEO_ASPECT_16X9_CENTRE,
+	TPG_VIDEO_ASPECT_16X9_ANAMORPHIC,
+};
+
+enum tpg_pixel_aspect {
+	TPG_PIXEL_ASPECT_SQUARE,
+	TPG_PIXEL_ASPECT_NTSC,
+	TPG_PIXEL_ASPECT_PAL,
+};
+
+enum tpg_move_mode {
+	TPG_MOVE_NEG_FAST,
+	TPG_MOVE_NEG,
+	TPG_MOVE_NEG_SLOW,
+	TPG_MOVE_NONE,
+	TPG_MOVE_POS_SLOW,
+	TPG_MOVE_POS,
+	TPG_MOVE_POS_FAST,
+};
+
+extern const char * const tpg_aspect_strings[];
+
+#define TPG_MAX_PLANES 2
+#define TPG_MAX_PAT_LINES 8
+
+struct tpg_data {
+	/* Source frame size */
+	unsigned			src_width, src_height;
+	/* Buffer height */
+	unsigned			buf_height;
+	/* Scaled output frame size */
+	unsigned			scaled_width;
+	u32				field;
+	/* crop coordinates are frame-based */
+	struct v4l2_rect		crop;
+	/* compose coordinates are format-based */
+	struct v4l2_rect		compose;
+	/* border and square coordinates are frame-based */
+	struct v4l2_rect		border;
+	struct v4l2_rect		square;
+
+	/* Color-related fields */
+	enum tpg_quality		qual;
+	unsigned			qual_offset;
+	u8				alpha_component;
+	bool				alpha_red_only;
+	u8				brightness;
+	u8				contrast;
+	u8				saturation;
+	s16				hue;
+	u32				fourcc;
+	bool				is_yuv;
+	u32				colorspace;
+	enum tpg_video_aspect		vid_aspect;
+	enum tpg_pixel_aspect		pix_aspect;
+	unsigned			rgb_range;
+	unsigned			real_rgb_range;
+	unsigned			planes;
+	/* Used to store the colors in native format, either RGB or YUV */
+	u8				colors[TPG_COLOR_MAX][3];
+	u8				textfg[TPG_MAX_PLANES][8], textbg[TPG_MAX_PLANES][8];
+	/* size in bytes for two pixels in each plane */
+	unsigned			twopixelsize[TPG_MAX_PLANES];
+	unsigned			bytesperline[TPG_MAX_PLANES];
+
+	/* Configuration */
+	enum tpg_pattern		pattern;
+	bool				hflip;
+	bool				vflip;
+	unsigned			perc_fill;
+	bool				perc_fill_blank;
+	bool				show_border;
+	bool				show_square;
+	bool				insert_sav;
+	bool				insert_eav;
+
+	/* Test pattern movement */
+	enum tpg_move_mode		mv_hor_mode;
+	int				mv_hor_count;
+	int				mv_hor_step;
+	enum tpg_move_mode		mv_vert_mode;
+	int				mv_vert_count;
+	int				mv_vert_step;
+
+	bool				recalc_colors;
+	bool				recalc_lines;
+	bool				recalc_square_border;
+
+	/* Used to store TPG_MAX_PAT_LINES lines, each with up to two planes */
+	unsigned			max_line_width;
+	u8				*lines[TPG_MAX_PAT_LINES][TPG_MAX_PLANES];
+	u8				*random_line[TPG_MAX_PLANES];
+	u8				*contrast_line[TPG_MAX_PLANES];
+	u8				*black_line[TPG_MAX_PLANES];
+};
+
+void tpg_init(struct tpg_data *tpg, unsigned w, unsigned h);
+int tpg_alloc(struct tpg_data *tpg, unsigned max_w);
+void tpg_free(struct tpg_data *tpg);
+void tpg_reset_source(struct tpg_data *tpg, unsigned width, unsigned height,
+		       u32 field);
+
+void tpg_set_font(const u8 *f);
+void tpg_gen_text(struct tpg_data *tpg, u8 *basep[TPG_MAX_PLANES][2],
+		int y, int x, char *text);
+void tpg_fillbuffer(struct tpg_data *tpg, u8 *basep[TPG_MAX_PLANES][2],
+		v4l2_std_id std, unsigned p, u8 *vbuf);
+bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc);
+void tpg_s_crop_compose(struct tpg_data *tpg);
+
+static inline void tpg_s_pattern(struct tpg_data *tpg, enum tpg_pattern pattern)
+{
+	if (tpg->pattern == pattern)
+		return;
+	tpg->pattern = pattern;
+	tpg->recalc_colors = true;
+}
+
+static inline void tpg_s_quality(struct tpg_data *tpg,
+				    enum tpg_quality qual, unsigned qual_offset)
+{
+	if (tpg->qual == qual && tpg->qual_offset == qual_offset)
+		return;
+	tpg->qual = qual;
+	tpg->qual_offset = qual_offset;
+	tpg->recalc_colors = true;
+}
+
+static inline enum tpg_quality tpg_g_quality(const struct tpg_data *tpg)
+{
+	return tpg->qual;
+}
+
+static inline void tpg_s_alpha_component(struct tpg_data *tpg,
+					    u8 alpha_component)
+{
+	if (tpg->alpha_component == alpha_component)
+		return;
+	tpg->alpha_component = alpha_component;
+	tpg->recalc_colors = true;
+}
+
+static inline void tpg_s_alpha_mode(struct tpg_data *tpg,
+					    bool red_only)
+{
+	if (tpg->alpha_red_only == red_only)
+		return;
+	tpg->alpha_red_only = red_only;
+	tpg->recalc_colors = true;
+}
+
+static inline void tpg_s_brightness(struct tpg_data *tpg,
+					u8 brightness)
+{
+	if (tpg->brightness == brightness)
+		return;
+	tpg->brightness = brightness;
+	tpg->recalc_colors = true;
+}
+
+static inline void tpg_s_contrast(struct tpg_data *tpg,
+					u8 contrast)
+{
+	if (tpg->contrast == contrast)
+		return;
+	tpg->contrast = contrast;
+	tpg->recalc_colors = true;
+}
+
+static inline void tpg_s_saturation(struct tpg_data *tpg,
+					u8 saturation)
+{
+	if (tpg->saturation == saturation)
+		return;
+	tpg->saturation = saturation;
+	tpg->recalc_colors = true;
+}
+
+static inline void tpg_s_hue(struct tpg_data *tpg,
+					s16 hue)
+{
+	if (tpg->hue == hue)
+		return;
+	tpg->hue = hue;
+	tpg->recalc_colors = true;
+}
+
+static inline void tpg_s_rgb_range(struct tpg_data *tpg,
+					unsigned rgb_range)
+{
+	if (tpg->rgb_range == rgb_range)
+		return;
+	tpg->rgb_range = rgb_range;
+	tpg->recalc_colors = true;
+}
+
+static inline void tpg_s_real_rgb_range(struct tpg_data *tpg,
+					unsigned rgb_range)
+{
+	if (tpg->real_rgb_range == rgb_range)
+		return;
+	tpg->real_rgb_range = rgb_range;
+	tpg->recalc_colors = true;
+}
+
+static inline void tpg_s_colorspace(struct tpg_data *tpg, u32 colorspace)
+{
+	if (tpg->colorspace == colorspace)
+		return;
+	tpg->colorspace = colorspace;
+	tpg->recalc_colors = true;
+}
+
+static inline u32 tpg_g_colorspace(const struct tpg_data *tpg)
+{
+	return tpg->colorspace;
+}
+
+static inline unsigned tpg_g_planes(const struct tpg_data *tpg)
+{
+	return tpg->planes;
+}
+
+static inline unsigned tpg_g_twopixelsize(const struct tpg_data *tpg, unsigned plane)
+{
+	return tpg->twopixelsize[plane];
+}
+
+static inline unsigned tpg_g_bytesperline(const struct tpg_data *tpg, unsigned plane)
+{
+	return tpg->bytesperline[plane];
+}
+
+static inline void tpg_s_bytesperline(struct tpg_data *tpg, unsigned plane, unsigned bpl)
+{
+	tpg->bytesperline[plane] = bpl;
+}
+
+static inline void tpg_s_buf_height(struct tpg_data *tpg, unsigned h)
+{
+	tpg->buf_height = h;
+}
+
+static inline struct v4l2_rect *tpg_g_crop(struct tpg_data *tpg)
+{
+	return &tpg->crop;
+}
+
+static inline struct v4l2_rect *tpg_g_compose(struct tpg_data *tpg)
+{
+	return &tpg->compose;
+}
+
+static inline void tpg_s_field(struct tpg_data *tpg, unsigned field)
+{
+	tpg->field = field;
+}
+
+static inline void tpg_s_perc_fill(struct tpg_data *tpg,
+				      unsigned perc_fill)
+{
+	tpg->perc_fill = perc_fill;
+}
+
+static inline unsigned tpg_g_perc_fill(const struct tpg_data *tpg)
+{
+	return tpg->perc_fill;
+}
+
+static inline void tpg_s_perc_fill_blank(struct tpg_data *tpg,
+					 bool perc_fill_blank)
+{
+	tpg->perc_fill_blank = perc_fill_blank;
+}
+
+static inline void tpg_s_video_aspect(struct tpg_data *tpg,
+					enum tpg_video_aspect vid_aspect)
+{
+	if (tpg->vid_aspect == vid_aspect)
+		return;
+	tpg->vid_aspect = vid_aspect;
+	tpg->recalc_square_border = true;
+}
+
+static inline void tpg_s_pixel_aspect(struct tpg_data *tpg,
+					enum tpg_pixel_aspect pix_aspect)
+{
+	if (tpg->pix_aspect == pix_aspect)
+		return;
+	tpg->pix_aspect = pix_aspect;
+	tpg->recalc_square_border = true;
+}
+
+static inline void tpg_s_show_border(struct tpg_data *tpg,
+					bool show_border)
+{
+	tpg->show_border = show_border;
+}
+
+static inline void tpg_s_show_square(struct tpg_data *tpg,
+					bool show_square)
+{
+	tpg->show_square = show_square;
+}
+
+static inline void tpg_s_insert_sav(struct tpg_data *tpg, bool insert_sav)
+{
+	tpg->insert_sav = insert_sav;
+}
+
+static inline void tpg_s_insert_eav(struct tpg_data *tpg, bool insert_eav)
+{
+	tpg->insert_eav = insert_eav;
+}
+
+void tpg_update_mv_step(struct tpg_data *tpg);
+
+static inline void tpg_s_mv_hor_mode(struct tpg_data *tpg,
+				enum tpg_move_mode mv_hor_mode)
+{
+	tpg->mv_hor_mode = mv_hor_mode;
+	tpg_update_mv_step(tpg);
+}
+
+static inline void tpg_s_mv_vert_mode(struct tpg_data *tpg,
+				enum tpg_move_mode mv_vert_mode)
+{
+	tpg->mv_vert_mode = mv_vert_mode;
+	tpg_update_mv_step(tpg);
+}
+
+static inline void tpg_init_mv_count(struct tpg_data *tpg)
+{
+	tpg->mv_hor_count = tpg->mv_vert_count = 0;
+}
+
+static inline void tpg_update_mv_count(struct tpg_data *tpg, bool frame_is_field)
+{
+	tpg->mv_hor_count += tpg->mv_hor_step * (frame_is_field ? 1 : 2);
+	tpg->mv_vert_count += tpg->mv_vert_step * (frame_is_field ? 1 : 2);
+}
+
+static inline void tpg_s_hflip(struct tpg_data *tpg, bool hflip)
+{
+	if (tpg->hflip == hflip)
+		return;
+	tpg->hflip = hflip;
+	tpg_update_mv_step(tpg);
+	tpg->recalc_lines = true;
+}
+
+static inline bool tpg_g_hflip(const struct tpg_data *tpg)
+{
+	return tpg->hflip;
+}
+
+static inline void tpg_s_vflip(struct tpg_data *tpg, bool vflip)
+{
+	tpg->vflip = vflip;
+}
+
+static inline bool tpg_g_vflip(const struct tpg_data *tpg)
+{
+	return tpg->vflip;
+}
+
+static inline bool tpg_pattern_is_static(const struct tpg_data *tpg)
+{
+	return tpg->pattern != TPG_PAT_NOISE &&
+	       tpg->mv_hor_mode == TPG_MOVE_NONE &&
+	       tpg->mv_vert_mode == TPG_MOVE_NONE;
+}
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(3, 14, 0))
+#include <linux/random.h>
+static inline u32 prandom_u32_max(u32 ep_ro)
+{
+	return (u32)(((u64) prandom_u32() * ep_ro) >> 32);
+}
+#endif
+
+#endif
-- 
2.0.0

