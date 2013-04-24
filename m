Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52913 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757976Ab3DXMBT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Apr 2013 08:01:19 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	LMML <linux-media@vger.kernel.org>,
	LFBDEV <linux-fbdev@vger.kernel.org>,
	LAK <linux-arm-kernel@lists.infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 3/6] davinci: vpbe: add fbdev driver
Date: Wed, 24 Apr 2013 17:30:05 +0530
Message-Id: <1366804808-22720-4-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1366804808-22720-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1366804808-22720-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

add the fbdev driver for DMX which uses an OSD layer
with RGB565/RGB888 support and an attribute window which can
also be doubled as another RGB565 window. The fbdev supports
fb0 and fb2 for  OSD0 and OSD1, and also supports video windows
with fb1 and fb3.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/video/Kconfig     |   12 +
 drivers/video/Makefile    |    1 +
 drivers/video/davincifb.c | 2523 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/video/davincifb.h |  194 ++++
 4 files changed, 2730 insertions(+), 0 deletions(-)
 create mode 100644 drivers/video/davincifb.c
 create mode 100644 drivers/video/davincifb.h

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 4c1546f..fa264a3 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -2451,6 +2451,18 @@ config FB_PUV3_UNIGFX
 	  Choose this option if you want to use the Unigfx device as a
 	  framebuffer device. Without the support of PCI & AGP.
 
+config FB_DAVINCI_DMX
+	tristate "Davinci Framebuffer driver"
+	depends on FB && ARCH_DAVINCI
+	select VIDEO_DMXXX_VPBE
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+		Enables Davinci Framebuffer driver on a DMX device
+		To compile this driver as a module, choose M here: the
+		module will be called vpbe_fb.
+
 source "drivers/video/omap/Kconfig"
 source "drivers/video/omap2/Kconfig"
 source "drivers/video/exynos/Kconfig"
diff --git a/drivers/video/Makefile b/drivers/video/Makefile
index 9df3873..bf4f5f2 100644
--- a/drivers/video/Makefile
+++ b/drivers/video/Makefile
@@ -165,6 +165,7 @@ obj-$(CONFIG_FB_MX3)		  += mx3fb.o
 obj-$(CONFIG_FB_DA8XX)		  += da8xx-fb.o
 obj-$(CONFIG_FB_MXS)		  += mxsfb.o
 obj-$(CONFIG_FB_SSD1307)	  += ssd1307fb.o
+obj-$(CONFIG_FB_DAVINCI_DMX)	  += davincifb.o
 
 # the test framebuffer is last
 obj-$(CONFIG_FB_VIRTUAL)          += vfb.o
diff --git a/drivers/video/davincifb.c b/drivers/video/davincifb.c
new file mode 100644
index 0000000..59b6cf7
--- /dev/null
+++ b/drivers/video/davincifb.c
@@ -0,0 +1,2523 @@
+/*
+ * Copyright (C) 2007 MontaVista Software Inc.
+ * Copyright (C) 2013 Texas Instruments Inc
+ *
+ * Andy Lowe (alowe@mvista.com), MontaVista Software
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option)any later version.
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
+#include <linux/fb.h>
+#include <linux/dma-mapping.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+
+#include <mach/cputype.h>
+
+#include <media/davinci/vpbe.h>
+#include <media/davinci/vpbe_types.h>
+#include <media/v4l2-subdev.h>
+
+#include "davincifb.h"
+
+static struct osd_state *osd_device;
+
+/* return non-zero if the info structure corresponds to OSD0 or OSD1 */
+static int is_osd_win(const struct fb_info *info)
+{
+	const struct vpbe_dm_win_info *win = info->par;
+
+	if (win->layer == WIN_OSD0 || win->layer == WIN_OSD1)
+		return 1;
+	return 0;
+}
+
+/* return non-zero if the info structure corresponds to VID0 or VID1 */
+#define is_vid_win(info) (!is_osd_win(info))
+
+/*
+ * Convert a framebuffer info pointer to a osd_layer enumeration.
+ * It is up to the caller to verify that the info structure corresponds to
+ * either OSD0 or OSD1.
+ */
+static enum osd_layer fb_info_to_osd_enum(const struct fb_info *info)
+{
+	const struct vpbe_dm_win_info *win = info->par;
+
+	if (win->layer == WIN_OSD1)
+		return OSDWIN_OSD1;
+	return OSDWIN_OSD0;
+}
+
+/* macros for testing fb_var_screeninfo attributes */
+#define is_attribute_mode(var) (((var)->bits_per_pixel == 4) && \
+	((var)->nonstd != 0))
+#define is_yuv(var) ((((var)->bits_per_pixel == 16) || \
+	((var)->bits_per_pixel == 8)) && \
+	((var)->nonstd != 0))
+#define is_window_interlaced(var) (((var)->vmode & FB_VMODE_INTERLACED) \
+	== FB_VMODE_INTERLACED)
+
+/* macros for testing fb_videomode attributes */
+#define is_display_interlaced(mode) (((mode)->vmode & FB_VMODE_INTERLACED) \
+	== FB_VMODE_INTERLACED)
+
+static unsigned int fb_cbcr_ofst;
+
+/*
+ * Convert an fb_var_screeninfo struct to a Davinci display layer configuration.
+ * lconfig->xpos, lconfig->ypos, and lconfig->line_length are not modified
+ * because no information about them is contained in var.
+ * The value of the yc_pixfmt argument is returned in lconfig->pixfmt if a
+ * the var specifies a YC pixel format.  The value of yc_pixfmt must be either
+ * PIXFMT_YCBCRI or PIXFMT_YCRCBI.
+ */
+static void convert_fb_var_to_osd(const struct fb_var_screeninfo *var,
+				  struct osd_layer_config *lconfig,
+				  enum osd_pix_format yc_pixfmt)
+{
+	lconfig->xsize = var->xres;
+	lconfig->ysize = var->yres;
+	lconfig->interlaced = is_window_interlaced(var);
+
+	switch (var->bits_per_pixel) {
+	case 1:
+		lconfig->pixfmt = PIXFMT_1BPP;
+		break;
+	case 2:
+		lconfig->pixfmt = PIXFMT_2BPP;
+		break;
+	case 4:
+		if (is_attribute_mode(var))
+			lconfig->pixfmt = PIXFMT_OSD_ATTR;
+		else
+			lconfig->pixfmt = PIXFMT_4BPP;
+		break;
+	case 8:
+		if (is_yuv(var))
+			lconfig->pixfmt = PIXFMT_NV12;
+		else
+			lconfig->pixfmt = PIXFMT_8BPP;
+		break;
+	case 16:
+	default:
+		if (is_yuv(var))
+			lconfig->pixfmt = yc_pixfmt;
+		else
+			lconfig->pixfmt = PIXFMT_RGB565;
+		break;
+	case 24:
+	case 32:
+		lconfig->pixfmt = PIXFMT_RGB888;
+		break;
+	}
+}
+
+/*
+ * Convert an fb_info struct to a OSD display layer configuration.
+ */
+static void convert_fb_info_to_osd(const struct fb_info *info,
+				   struct osd_layer_config *lconfig)
+{
+	const struct vpbe_dm_win_info *win = info->par;
+
+	lconfig->line_length = info->fix.line_length;
+	lconfig->xpos = win->xpos;
+	lconfig->ypos = win->ypos;
+	convert_fb_var_to_osd(&info->var, lconfig, win->dm->yc_pixfmt);
+}
+
+/*
+ * Convert a OSD display layer configuration to var info.
+ * The following members of var are not modified:
+ *	var->xres_virtual
+ *	var->yres_virtual
+ *	var->xoffset
+ *	var->yoffset
+ *	var->pixclock
+ *	var->left_margin
+ *	var->right_margin
+ *	var->upper_margin
+ *	var->lower_margin
+ *	var->hsync_len
+ *	var->vsync_len
+ *	var->sync
+ * Only bit 0 of var->vmode (FB_VMODE_INTERLACED) is modified.  All other bits
+ * of var->vmode are retained.
+ */
+static void convert_osd_to_fb_var(const struct osd_layer_config *lconfig,
+				  struct fb_var_screeninfo *var)
+{
+	var->xres = lconfig->xsize;
+	var->yres = lconfig->ysize;
+	if (lconfig->interlaced)
+		var->vmode |= FB_VMODE_INTERLACED;
+	else
+		var->vmode &= ~FB_VMODE_INTERLACED;
+
+	var->red.offset = 0;
+	var->green.offset = 0;
+	var->blue.offset = 0;
+	var->red.msb_right = 0;
+	var->green.msb_right = 0;
+	var->blue.msb_right = 0;
+	var->transp.offset = 0;
+	var->transp.length = 0;
+	var->transp.msb_right = 0;
+	var->nonstd = 0;
+
+	if (lconfig->pixfmt == PIXFMT_1BPP ||
+	    lconfig->pixfmt == PIXFMT_2BPP ||
+	    lconfig->pixfmt == PIXFMT_4BPP ||
+	    lconfig->pixfmt == PIXFMT_8BPP) {
+		var->red.length = var->bits_per_pixel;
+		var->green.length = var->bits_per_pixel;
+		var->blue.length = var->bits_per_pixel;
+	}
+
+	switch (lconfig->pixfmt) {
+	case PIXFMT_1BPP:
+		var->bits_per_pixel = 1;
+		break;
+	case PIXFMT_2BPP:
+		var->bits_per_pixel = 2;
+		break;
+	case PIXFMT_4BPP:
+		var->bits_per_pixel = 4;
+		break;
+	case PIXFMT_8BPP:
+		var->bits_per_pixel = 8;
+		break;
+	case PIXFMT_RGB565:
+		var->bits_per_pixel = 16;
+		var->red.offset = 11;
+		var->red.length = 5;
+		var->green.offset = 5;
+		var->green.length = 6;
+		var->blue.offset = 0;
+		var->blue.length = 5;
+		break;
+	case PIXFMT_YCBCRI:
+	case PIXFMT_YCRCBI:
+		var->bits_per_pixel = 16;
+		var->red.length = 0;
+		var->green.length = 0;
+		var->blue.length = 0;
+		var->nonstd = 1;
+		break;
+	case PIXFMT_NV12:
+		if (cpu_is_davinci_dm365()) {
+			var->bits_per_pixel = 8;
+			var->red.length = 0;
+			var->green.length = 0;
+			var->blue.length = 0;
+			var->nonstd = 1;
+		}
+	case PIXFMT_RGB888:
+		if (cpu_is_davinci_dm644x()) {
+			var->bits_per_pixel = 24;
+			var->red.offset = 0;
+			var->red.length = 8;
+			var->green.offset = 8;
+			var->green.length = 8;
+			var->blue.offset = 16;
+			var->blue.length = 8;
+		} else {
+			var->bits_per_pixel = 32;
+			var->red.offset = 16;
+			var->red.length = 8;
+			var->green.offset = 8;
+			var->green.length = 8;
+			var->blue.offset = 0;
+			var->blue.length = 8;
+			var->transp.offset = 24;
+			var->transp.length = 3;
+		}
+		break;
+	case PIXFMT_OSD_ATTR:
+		var->bits_per_pixel = 4;
+		var->red.length = 0;
+		var->green.length = 0;
+		var->blue.length = 0;
+		var->nonstd = 1;
+		break;
+	}
+
+	var->grayscale = 0;
+	var->activate = FB_ACTIVATE_NOW;
+	var->height = 0;
+	var->width = 0;
+	var->accel_flags = 0;
+	var->rotate = 0;
+}
+
+/*
+ * Get the video mode from the encoder manager.
+ */
+static int get_video_mode(struct vpbe_device *vpbe_dev,
+			  struct fb_videomode *mode)
+{
+	struct vpbe_enc_mode_info mode_info;
+	int ret;
+
+	memset(&mode_info, 0, sizeof(mode_info));
+	memset(mode, 0, sizeof(*mode));
+
+	ret = vpbe_dev->ops.get_mode_info(vpbe_dev, &mode_info);
+	if (ret < 0)
+		return ret;
+
+	mode->name = mode_info.name;
+	if (mode_info.fps.denominator) {
+		unsigned fps_1000;	/* frames per 1000 seconds */
+		unsigned lps;	/* lines per second */
+		unsigned pps;	/* pixels per second */
+		unsigned vtotal;	/* total lines per frame */
+		unsigned htotal;	/* total pixels per line */
+		unsigned interlace = (mode_info.interlaced) ? 2 : 1;
+
+		fps_1000 = (1000 * mode_info.fps.numerator +
+		     mode_info.fps.denominator / 2) / mode_info.fps.denominator;
+
+		mode->refresh = (interlace * fps_1000 + 1000 / 2) / 1000;
+
+		vtotal = mode_info.yres + mode_info.lower_margin +
+		    mode_info.vsync_len + mode_info.upper_margin;
+		lps = (fps_1000 * vtotal + 1000 / 2) / 1000;
+
+		htotal = mode_info.xres + mode_info.right_margin +
+		    mode_info.hsync_len + mode_info.left_margin;
+		pps = lps * htotal;
+
+		if (pps)
+			mode->pixclock =
+				((1000000000UL + pps / 2) / pps) * 1000;
+	}
+	mode->xres = mode_info.xres;
+	mode->yres = mode_info.yres;
+	mode->left_margin = mode_info.left_margin;
+	mode->right_margin = mode_info.right_margin;
+	mode->upper_margin = mode_info.upper_margin;
+	mode->lower_margin = mode_info.lower_margin;
+	mode->hsync_len = mode_info.hsync_len;
+	mode->vsync_len = mode_info.vsync_len;
+	if (mode_info.flags & (1 << 0))
+		mode->sync |= FB_SYNC_HOR_HIGH_ACT;
+	if (mode_info.flags & (1 << 1))
+		mode->sync |= FB_SYNC_VERT_HIGH_ACT;
+	if ((mode_info.timings_type & VPBE_ENC_STD) ||
+	    (mode_info.timings_type & VPBE_ENC_DV_TIMINGS))
+		mode->sync |= FB_SYNC_BROADCAST;
+	if (mode_info.interlaced)
+		mode->vmode |= FB_VMODE_INTERLACED;
+
+	return 0;
+}
+
+/*
+ * Set a video mode with the encoder manager.
+ */
+static int set_video_mode(struct vpbe_device *vpbe_dev,
+			  struct fb_videomode *mode)
+{
+	struct vpbe_enc_mode_info mode_info;
+	int ret;
+
+	ret = vpbe_dev->ops.get_mode_info(vpbe_dev, &mode_info);
+	if (ret < 0)
+		return ret;
+
+	mode_info.name = (unsigned char *)mode->name;
+	mode_info.fps.numerator = 0;
+	mode_info.fps.denominator = 0;
+	if (mode->pixclock && mode->xres && mode->yres) {
+		unsigned fps_1000;	/* frames per 1000 seconds */
+		unsigned lps;	/* lines per second */
+		unsigned pps;	/* pixels per second */
+		unsigned vtotal;	/* total lines per frame */
+		unsigned htotal;	/* total pixels per line */
+
+		pps = ((1000000000UL + mode->pixclock / 2) / mode->pixclock) *
+								1000;
+
+		htotal = mode->xres + mode->right_margin + mode->hsync_len +
+						mode->left_margin;
+		lps = (pps + htotal / 2) / htotal;
+
+		vtotal = mode->yres + mode->lower_margin + mode->vsync_len +
+						mode->upper_margin;
+		fps_1000 = (lps * 1000 + vtotal / 2) / vtotal;
+
+		mode_info.fps.numerator = fps_1000;
+		mode_info.fps.denominator = 1000;
+
+		/*
+		 * 1000 == 2*2*2*5*5*5, so factor out any common multiples of 2
+		 * or 5
+		 */
+		while ((((mode_info.fps.numerator / 2) * 2) ==
+			mode_info.fps.numerator) &&
+			(((mode_info.fps.denominator / 2) * 2) ==
+			   mode_info.fps.denominator)) {
+			mode_info.fps.numerator = mode_info.fps.numerator / 2;
+			mode_info.fps.denominator =
+			    mode_info.fps.denominator / 2;
+		}
+		while ((((mode_info.fps.numerator / 5) * 5) ==
+			mode_info.fps.numerator) &&
+			(((mode_info.fps.denominator / 5) * 5) ==
+			   mode_info.fps.denominator)) {
+			mode_info.fps.numerator = mode_info.fps.numerator / 5;
+			mode_info.fps.denominator =
+			    mode_info.fps.denominator / 5;
+		}
+	}
+	mode_info.xres = mode->xres;
+	mode_info.yres = mode->yres;
+	mode_info.left_margin = mode->left_margin;
+	mode_info.right_margin = mode->right_margin;
+	mode_info.upper_margin = mode->upper_margin;
+	mode_info.lower_margin = mode->lower_margin;
+	mode_info.hsync_len = mode->hsync_len;
+	mode_info.vsync_len = mode->vsync_len;
+	if (mode->sync & FB_SYNC_HOR_HIGH_ACT)
+		mode_info.flags |= (1 << 0);
+	else
+		mode_info.flags &= ~(1 << 0);
+	if (mode->sync & FB_SYNC_VERT_HIGH_ACT)
+		mode_info.flags |= (1 << 1);
+	else
+		mode_info.flags &= ~(1 << 1);
+	/*
+	 * seems like a flag std is used in earlier version of the driver to
+	 * indicate if it is a standard timings non standard timings. We use
+	 * timings_type for the same.
+	 */
+	if (mode->sync & FB_SYNC_BROADCAST)
+		mode_info.timings_type = VPBE_ENC_TIMINGS_INVALID;
+	else
+		mode_info.timings_type = VPBE_ENC_DV_TIMINGS;
+	if (mode->vmode & FB_VMODE_INTERLACED)
+		mode_info.interlaced = 1;
+	else
+		mode_info.interlaced = 0;
+
+	ret = vpbe_dev->ops.set_mode(vpbe_dev, &mode_info);
+
+	return ret;
+}
+
+/*
+ * Construct an fb_var_screeninfo structure from an fb_videomode structure
+ * describing the display and a osd_layer_config structure describing a window.
+ * The following members of var not modified:
+ *	var->xoffset
+ *	var->yoffset
+ *	var->xres_virtual
+ *	var->yres_virtual
+ * The following members of var are loaded with values derived from mode:
+ *	var->pixclock
+ *	var->left_margin
+ *	var->hsync_len
+ *	var->vsync_len
+ *	var->right_margin
+ *	var->upper_margin
+ *	var->lower_margin
+ *	var->sync
+ *	var->vmode (all bits except bit 0: FB_VMODE_INTERLACED)
+ * The following members of var are loaded with values derived from lconfig:
+ *	var->xres
+ *	var->yres
+ *	var->bits_per_pixel
+ *	var->red
+ *	var->green
+ *	var->blue
+ *	var->transp
+ *	var->nonstd
+ *	var->grayscale
+ *	var->activate
+ *	var->height
+ *	var->width
+ *	var->accel_flags
+ *	var->rotate
+ *	var->vmode (only bit 0: FB_VMODE_INTERLACED)
+ *
+ * If the display resolution (xres and yres) specified in mode matches the
+ * window resolution specified in lconfig, then the display timing info returned
+ * in var is valid and var->pixclock will be the value derived from mode.
+ * If the display resolution does not match the window resolution, then
+ * var->pixclock will be set to 0 to indicate that the display timing info
+ * returned in var is not valid.
+ *
+ * mode and lconfig are not modified.
+ */
+static void construct_fb_var(struct fb_var_screeninfo *var,
+			     struct fb_videomode *mode,
+			     struct osd_layer_config *lconfig)
+{
+	fb_videomode_to_var(var, mode);
+	convert_osd_to_fb_var(lconfig, var);
+	if (lconfig->xsize != mode->xres || lconfig->ysize != mode->yres)
+		var->pixclock = 0;
+}
+
+/*
+ * Update the values in an fb_fix_screeninfo structure based on the values in an
+ * fb_var_screeninfo structure.
+ * The following members of fix are updated:
+ *	fix->visual
+ *	fix->xpanstep
+ *	fix->ypanstep
+ *	fix->ywrapstep
+ *	fix->line_length
+ * All other members of fix are unmodified.
+ */
+static void update_fix_info(const struct fb_var_screeninfo *var,
+			    struct fb_fix_screeninfo *fix)
+{
+	fix->visual = (var->bits_per_pixel > 8) ? FB_VISUAL_TRUECOLOR :
+						FB_VISUAL_PSEUDOCOLOR;
+	/*
+	 * xpanstep must correspond to a multiple of the 32-byte cache line size
+	 */
+	switch (var->bits_per_pixel) {
+	case 1:
+	case 2:
+	case 4:
+	case 8:
+	case 12:
+	case 16:
+	case 32:
+		fix->xpanstep = (8 * 32) / var->bits_per_pixel;
+		break;
+	case 24:
+		fix->xpanstep = 32;	/* 32 pixels = 3 cache lines */
+		break;
+	default:
+		fix->xpanstep = 0;
+		break;
+	}
+	fix->ypanstep = 1;
+	fix->ywrapstep = 0;
+	fix->line_length = (var->xres_virtual * var->bits_per_pixel + 7) / 8;
+	/* line_length must be a multiple of the 32-byte cache line size */
+	fix->line_length = ((fix->line_length + 31) / 32) * 32;
+}
+
+/*
+ * Determine if the window configuration specified by var will fit in a
+ * framebuffer of size fb_size.
+ * Returns 1 if the window will fit in the framebuffer, or 0 otherwise.
+ */
+static int window_will_fit_framebuffer(const struct fb_var_screeninfo *var,
+				       unsigned fb_size)
+{
+	unsigned line_length;
+
+	line_length = (var->bits_per_pixel * var->xres_virtual + 7) / 8;
+	/* line length must be a multiple of the cache line size (32) */
+	line_length = ((line_length + 31) / 32) * 32;
+
+	if (var->yres_virtual * line_length <= fb_size)
+		return 1;
+	return 0;
+}
+
+/*
+ * FBIO_WAITFORVSYNC handler
+ */
+static int davincifb_wait_for_vsync(struct fb_info *info)
+{
+	struct vpbe_dm_win_info *win = info->par;
+	unsigned long cnt;
+	wait_queue_t wq;
+	int ret;
+
+	init_waitqueue_entry(&wq, current);
+
+	cnt = win->dm->vsync_cnt;
+	ret = wait_event_interruptible_timeout(win->dm->vsync_wait,
+			cnt != win->dm->vsync_cnt, win->dm->timeout);
+	if (ret < 0)
+		return ret;
+	if (ret == 0)
+		return -ETIMEDOUT;
+
+	return 0;
+}
+
+static void davincifb_vsync_callback(unsigned event, void *arg)
+{
+	struct vpbe_dm_info *dm = (struct vpbe_dm_info *)arg;
+	static unsigned last_event;
+	unsigned long addr = 0;
+
+	event &= ~VENC_END_OF_FRAME;
+	if (event == last_event) {
+		/* progressive */
+		xchg(&addr, dm->win[WIN_OSD0].sdram_address);
+		if (addr) {
+			osd_device->ops.start_layer(osd_device,
+					dm->win[WIN_OSD0].layer,
+					dm->win[WIN_OSD0].sdram_address,
+					fb_cbcr_ofst);
+			dm->win[WIN_OSD0].sdram_address = 0;
+		}
+		addr = 0;
+		xchg(&addr, dm->win[WIN_OSD1].sdram_address);
+		if (addr) {
+			osd_device->ops.start_layer(osd_device,
+					dm->win[WIN_OSD1].layer,
+					dm->win[WIN_OSD1].sdram_address,
+					fb_cbcr_ofst);
+			dm->win[WIN_OSD1].sdram_address = 0;
+		}
+		addr = 0;
+		xchg(&addr, dm->win[WIN_VID0].sdram_address);
+		if (addr) {
+			osd_device->ops.start_layer(osd_device,
+					dm->win[WIN_VID0].layer,
+					dm->win[WIN_VID0].sdram_address,
+					fb_cbcr_ofst);
+			dm->win[WIN_VID0].sdram_address = 0;
+		}
+		addr = 0;
+		xchg(&addr, dm->win[WIN_VID1].sdram_address);
+		if (addr) {
+			osd_device->ops.start_layer(osd_device,
+					dm->win[WIN_VID1].layer,
+					dm->win[WIN_VID1].sdram_address,
+					fb_cbcr_ofst);
+
+			dm->win[WIN_VID1].sdram_address = 0;
+		}
+		++dm->vsync_cnt;
+		wake_up_interruptible(&dm->vsync_wait);
+		last_event = event;
+		return;
+	}
+	/* interlaced */
+	if (!(event & VENC_SECOND_FIELD)) {
+		++dm->vsync_cnt;
+		wake_up_interruptible(&dm->vsync_wait);
+		last_event = event;
+		return;
+	}
+	xchg(&addr, dm->win[WIN_OSD0].sdram_address);
+	if (addr) {
+		osd_device->ops.start_layer(osd_device,
+				dm->win[WIN_OSD0].layer,
+				dm->win[WIN_OSD0].sdram_address,
+				fb_cbcr_ofst);
+
+		dm->win[WIN_OSD0].sdram_address = 0;
+	}
+	addr = 0;
+	xchg(&addr, dm->win[WIN_OSD1].sdram_address);
+	if (addr) {
+		osd_device->ops.start_layer(osd_device,
+				dm->win[WIN_OSD1].layer,
+				dm->win[WIN_OSD1].sdram_address,
+				fb_cbcr_ofst);
+		dm->win[WIN_OSD1].sdram_address = 0;
+	}
+	addr = 0;
+	xchg(&addr, dm->win[WIN_VID0].sdram_address);
+	if (addr) {
+		osd_device->ops.start_layer(osd_device,
+				dm->win[WIN_VID0].layer,
+				dm->win[WIN_VID0].sdram_address,
+				fb_cbcr_ofst);
+		dm->win[WIN_VID0].sdram_address = 0;
+	}
+	addr = 0;
+	xchg(&addr, dm->win[WIN_VID1].sdram_address);
+	if (addr) {
+		osd_device->ops.start_layer(osd_device,
+				dm->win[WIN_VID1].layer,
+				dm->win[WIN_VID1].sdram_address,
+				fb_cbcr_ofst);
+		dm->win[WIN_VID1].sdram_address = 0;
+	}
+	last_event = event;
+}
+
+/*
+ * FBIO_SETATTRIBUTE handler
+ *
+ * This ioctl is deprecated.  The user can write the attribute values directly
+ * to the OSD1 framebuffer.
+ *
+ * Set a uniform attribute value over a rectangular area on the attribute
+ * window. The attribute value (0 to 15) is passed through the fb_fillrect's
+ * color parameter.  r->dx and r->width must both be even.  If not, they are
+ * rounded down.
+ */
+static int davincifb_set_attr_blend(struct fb_info *info, struct fb_fillrect *r)
+{
+	struct fb_var_screeninfo *var = &info->var;
+	struct vpbe_dm_win_info *win = info->par;
+	char __iomem *start;
+	u32 width_bytes;
+	u8 blend;
+
+	if (win->layer != WIN_OSD1)
+		return -EINVAL;
+	if (!is_attribute_mode(var))
+		return -EINVAL;
+
+	if (r->dx + r->width > var->xres_virtual)
+		return -EINVAL;
+	if (r->dy + r->height > var->yres_virtual)
+		return -EINVAL;
+	if (r->color > 15)
+		return -EINVAL;
+	width_bytes = (r->width * var->bits_per_pixel) / 8;
+	start = info->screen_base + r->dy * info->fix.line_length +
+				(r->dx * var->bits_per_pixel) / 8;
+
+	blend = (((u8) r->color & 0xf) << 4) | ((u8) r->color);
+	while (r->height--) {
+		memset(start, blend, width_bytes);
+		start += info->fix.line_length * 3;
+	}
+
+	return 0;
+}
+
+/*
+ * FBIO_SETPOSX handler
+ */
+static int davincifb_setposx(struct fb_info *info, unsigned xpos)
+{
+	struct fb_var_screeninfo *var = &info->var;
+	struct vpbe_dm_win_info *win = info->par;
+	unsigned old_xpos = win->xpos;
+	struct fb_var_screeninfo v;
+	int retval;
+
+	if (!win->own_window)
+		return -ENODEV;
+
+	memcpy(&v, var, sizeof(v));
+	win->xpos = xpos;
+	retval = info->fbops->fb_check_var(&v, info);
+	if (retval) {
+		win->xpos = old_xpos;
+		return retval;
+	}
+
+	/* update the window position */
+	memcpy(var, &v, sizeof(v));
+	retval = info->fbops->fb_set_par(info);
+
+	return retval;
+}
+
+/*
+ * FBIO_SETPOSY handler
+ */
+static int davincifb_setposy(struct fb_info *info, unsigned ypos)
+{
+	struct fb_var_screeninfo *var = &info->var;
+	struct vpbe_dm_win_info *win = info->par;
+	unsigned old_ypos = win->ypos;
+	struct fb_var_screeninfo v;
+	int retval;
+
+	if (!win->own_window)
+		return -ENODEV;
+
+	memcpy(&v, var, sizeof(v));
+	win->ypos = ypos;
+	retval = info->fbops->fb_check_var(&v, info);
+	if (retval) {
+		win->ypos = old_ypos;
+		return retval;
+	}
+
+	/* update the window position */
+	memcpy(var, &v, sizeof(v));
+	retval = info->fbops->fb_set_par(info);
+
+	return retval;
+}
+
+/*
+ * FBIO_SETZOOM handler
+ */
+static int davincifb_set_zoom(struct fb_info *info, struct zoom_params *zoom)
+{
+	struct vpbe_dm_win_info *win = info->par;
+	enum osd_zoom_factor h_zoom, v_zoom;
+
+	if (!win->own_window)
+		return -ENODEV;
+
+	switch (zoom->zoom_h) {
+	case 0:
+		h_zoom = ZOOM_X1;
+		break;
+	case 1:
+		h_zoom = ZOOM_X2;
+		break;
+	case 2:
+		h_zoom = ZOOM_X4;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	switch (zoom->zoom_v) {
+	case 0:
+		v_zoom = ZOOM_X1;
+		break;
+	case 1:
+		v_zoom = ZOOM_X2;
+		break;
+	case 2:
+		v_zoom = ZOOM_X4;
+		break;
+	default:
+		return -EINVAL;
+	}
+	osd_device->ops.set_zoom(osd_device,
+			 win->layer, h_zoom, v_zoom);
+	return 0;
+}
+
+/*
+ * FBIO_ENABLE_DISABLE_WIN handler
+ *
+ * This ioctl is deprecated.  Use the standard FBIOBLANK ioctl instead.
+ */
+static int davincifb_enable_disable_win(struct fb_info *info, int enable)
+{
+	struct vpbe_dm_win_info *win = info->par;
+	int retval = 0;
+
+	if (!win->own_window)
+		return -ENODEV;
+
+	if (!enable) {
+		win->display_window = 0;
+		osd_device->ops.disable_layer(osd_device, win->layer);
+		return retval;
+	}
+	win->display_window = 1;
+	retval = info->fbops->fb_check_var(&info->var, info);
+	if (retval)
+		return retval;
+	retval = info->fbops->fb_set_par(info);
+	return retval;
+}
+
+/*
+ * FBIO_SET_BITMAP_BLEND_FACTOR handler
+ */
+static int
+davincifb_bitmap_set_blend_factor(struct fb_info *info,
+				  struct vpbe_bitmap_blend_params *para)
+{
+	enum osd_layer osdwin = fb_info_to_osd_enum(info);
+
+	if (!is_osd_win(info))
+		return -EINVAL;
+
+	if (para->bf > OSD_8_VID_0)
+		return -EINVAL;
+
+	osd_device->ops.set_blending_factor(osd_device, osdwin, para->bf);
+	if (para->enable_colorkeying)
+		osd_device->ops.enable_color_key(osd_device,
+				 osdwin, para->colorkey);
+	else
+		osd_device->ops.disable_color_key(osd_device, osdwin);
+	return 0;
+}
+
+/*
+ * FBIO_SET_BITMAP_WIN_RAM_CLUT handler
+ *
+ * This ioctl is deprecated.  Use the standard framebuffer ioctl FBIOPUTCMAP
+ * instead.  Note that FBIOPUTCMAP colors are expressed in RGB space instead of
+ * YCbCr space.
+ */
+static int
+davincifb_bitmap_set_ram_clut(struct fb_info *info,
+			      unsigned char ram_clut[256][3])
+{
+	int i;
+
+	if (!is_osd_win(info))
+		return -EINVAL;
+
+	for (i = 0; i < 256; i++)
+		osd_device->ops.set_clut_ycbcr(osd_device, i, ram_clut[i][0],
+				ram_clut[i][1], ram_clut[i][2]);
+
+	return 0;
+}
+
+/*
+ * FBIO_ENABLE_DISABLE_ATTRIBUTE_WIN handler
+ *
+ * This ioctl is deprecated.  Attribute mode can be enabled via the standard
+ * framebuffer ioctl FBIOPUT_VSCREENINFO by setting var->bits_per_pixel to 4
+ * and var->nonstd to a non-zero value.  Attribute mode can be disabled by using
+ * FBIOPUT_VSCREENINFO to set a standard pixel format.
+ *
+ * The enabled/disabled status of OSD1 is unchanged by this ioctl.  To avoid
+ * display glitches, you should disable OSD1 prior to calling this ioctl.
+ *
+ * When enabling attribute mode, var->bits_per_pixel is set to 4.  var->xres,
+ * var->yres, var->xres_virtual, var->yres_virtual, win->xpos, and win->ypos are
+ * all copied from OSD0.  var->xoffset and var->yoffset are set to 0.
+ * fix->line_length is updated to be consistent with 4 bits per pixel.  No
+ * changes are made to the OSD1 configuration if OSD1 is already in attribute
+ * mode.
+ *
+ * When disabling attribute mode, the window geometry is unchanged.
+ * var->bits_per_pixel remains set to 4.  No changes are made to the OSD1
+ * configuration if OSD1 is not in attribute mode.
+ */
+static int
+davincifb_enable_disable_attribute_window(struct fb_info *info, u32 flag)
+{
+	struct fb_var_screeninfo *var = &info->var;
+	struct vpbe_dm_win_info *win = info->par;
+	struct osd_layer_config lconfig;
+	struct fb_var_screeninfo v;
+	int retval;
+
+	if (win->layer != WIN_OSD1)
+		return -EINVAL;
+
+	/* return with no error if there is nothing to do */
+	if ((is_attribute_mode(var) && flag) ||
+	    (!is_attribute_mode(var) && !flag))
+		return 0;
+
+	/* start with the current OSD1 var */
+	memcpy(&v, var, sizeof(v));
+
+	if (flag) {
+		/* enable attribute mode */
+		const struct vpbe_dm_win_info *osd0 = &win->dm->win[WIN_OSD0];
+		const struct fb_var_screeninfo *osd0_var = &osd0->info->var;
+		unsigned old_xpos = win->xpos;
+		unsigned old_ypos = win->ypos;
+		/* get the OSD0 window configuration */
+		convert_fb_var_to_osd(osd0_var, &lconfig, win->dm->yc_pixfmt);
+		/* change the pixfmt to attribute mode */
+		lconfig.pixfmt = PIXFMT_OSD_ATTR;
+		/* update the var for OSD1 */
+		convert_osd_to_fb_var(&lconfig, &v);
+		/* copy xres_virtual and yres_virtual from OSD0 */
+		v.xres_virtual = osd0_var->xres_virtual;
+		v.yres_virtual = osd0_var->yres_virtual;
+		/* zero xoffset and yoffset */
+		v.xoffset = 0;
+		v.yoffset = 0;
+		/* copy xpos and ypos from OSD0 */
+		win->xpos = osd0->xpos;
+		win->ypos = osd0->ypos;
+
+		retval = info->fbops->fb_check_var(&v, info);
+		if (retval) {
+			win->xpos = old_xpos;
+			win->ypos = old_ypos;
+			return retval;
+		}
+
+		/*
+		 * Enable attribute mode by replacing info->var and calling
+		 * the fb_set_par method to activate it.
+		 */
+		memcpy(var, &v, sizeof(v));
+		retval = info->fbops->fb_set_par(info);
+		return retval;
+	}
+	/* disable attribute mode */
+	/* get the current OSD1 window configuration */
+	convert_fb_var_to_osd(var, &lconfig, win->dm->yc_pixfmt);
+	/* change the pixfmt to 4-bits-per-pixel bitmap */
+	lconfig.pixfmt = PIXFMT_4BPP;
+	/* update the var for OSD1 */
+	convert_osd_to_fb_var(&lconfig, &v);
+
+	retval = info->fbops->fb_check_var(&v, info);
+	if (retval)
+		return retval;
+
+	/*
+	  * Disable attribute mode by replacing info->var and calling
+	  * the fb_set_par method to activate it.
+	  */
+	memcpy(var, &v, sizeof(v));
+	retval = info->fbops->fb_set_par(info);
+	return retval;
+}
+
+/*
+ * FBIO_GET_BLINK_INTERVAL handler
+ */
+static int
+davincifb_get_blinking(struct fb_info *info,
+		       struct vpbe_blink_option *blink_option)
+{
+	struct vpbe_dm_win_info *win = info->par;
+	enum osd_blink_interval blink;
+	int enabled;
+
+	if (win->layer != WIN_OSD1)
+		return -EINVAL;
+
+	osd_device->ops.get_blink_attribute(osd_device, &enabled, &blink);
+	blink_option->blinking = enabled;
+	blink_option->interval = blink;
+
+	return 0;
+}
+
+/*
+ * FBIO_SET_BLINK_INTERVAL handler
+ */
+static int
+davincifb_set_blinking(struct fb_info *info,
+		       struct vpbe_blink_option *blink_option)
+{
+	struct vpbe_dm_win_info *win = info->par;
+
+	if (win->layer != WIN_OSD1)
+		return -EINVAL;
+
+	if (blink_option->interval > BLINK_X4)
+		return -EINVAL;
+	osd_device->ops.set_blink_attribute(osd_device,
+			 blink_option->blinking, blink_option->interval);
+
+	return 0;
+}
+
+/*
+ * FBIO_GET_VIDEO_CONFIG_PARAMS handler
+ *
+ * Despite the name, this ioctl can be used on both video windows and OSD
+ * (bitmap) windows.
+ */
+static int
+davincifb_get_vid_params(struct fb_info *info,
+			 struct vpbe_video_config_params *vid_conf_params)
+{
+	struct vpbe_dm_win_info *win = info->par;
+	enum osd_h_exp_ratio h_exp;
+	enum osd_v_exp_ratio v_exp;
+
+	if (!win->own_window)
+		return -ENODEV;
+
+	if (is_vid_win(info))
+		osd_device->ops.get_vid_expansion(osd_device,
+				 &h_exp, &v_exp);
+	else
+		osd_device->ops.get_osd_expansion(osd_device,
+				 &h_exp, &v_exp);
+
+	vid_conf_params->cb_cr_order =
+	    (win->dm->yc_pixfmt == PIXFMT_YCBCRI) ? 0 : 1;
+	vid_conf_params->exp_info.horizontal = h_exp;
+	vid_conf_params->exp_info.vertical = v_exp;
+
+	return 0;
+}
+
+/*
+ * FBIO_SET_VIDEO_CONFIG_PARAMS handler
+ *
+ * Despite the name, this ioctl can be used on both video windows and OSD
+ * (bitmap) windows.
+ *
+ * NOTE: If the cb_cr_order is changed, it won't take effect until an
+ * FBIOPUT_VSCREENINFO ioctl is executed on a window with a YC pixel format.
+ */
+static int
+davincifb_set_vid_params(struct fb_info *info,
+			 struct vpbe_video_config_params *vid_conf_params)
+{
+	struct vpbe_dm_win_info *win = info->par;
+	enum osd_h_exp_ratio h_exp;
+	enum osd_v_exp_ratio v_exp;
+
+	if (!win->own_window)
+		return -ENODEV;
+
+	if (vid_conf_params->exp_info.horizontal > H_EXP_3_OVER_2)
+		return -EINVAL;
+
+	if (vid_conf_params->exp_info.vertical > V_EXP_6_OVER_5)
+		return -EINVAL;
+
+	win->dm->yc_pixfmt =
+	    vid_conf_params->cb_cr_order ? PIXFMT_YCRCBI : PIXFMT_YCBCRI;
+
+	h_exp = vid_conf_params->exp_info.horizontal;
+	v_exp = vid_conf_params->exp_info.vertical;
+	if (is_vid_win(info))
+		osd_device->ops.set_vid_expansion(osd_device,
+				 h_exp, v_exp);
+	else
+		osd_device->ops.set_osd_expansion(osd_device,
+				 h_exp, v_exp);
+
+	return 0;
+}
+
+/*
+ * FBIO_GET_BITMAP_CONFIG_PARAMS handler
+ */
+static int
+davincifb_bitmap_get_params(struct fb_info *info,
+			    struct vpbe_bitmap_config_params*
+			    bitmap_conf_params)
+{
+	enum osd_layer osdwin = fb_info_to_osd_enum(info);
+	enum osd_clut clut;
+
+	if (!is_osd_win(info))
+		return -EINVAL;
+
+	clut = osd_device->ops.get_osd_clut(osd_device, osdwin);
+	if (clut == ROM_CLUT)
+		bitmap_conf_params->clut_select =
+			osd_device->ops.get_rom_clut(osd_device);
+	else
+		bitmap_conf_params->clut_select = 2;
+
+	bitmap_conf_params->attenuation_enable =
+	    osd_device->ops.get_rec601_attenuation(osd_device,
+			     osdwin);
+
+	memset(&bitmap_conf_params->clut_idx, 0,
+	       sizeof(bitmap_conf_params->clut_idx));
+
+	switch (info->var.bits_per_pixel) {
+	case 1:
+		bitmap_conf_params->clut_idx.for_1bit_bitmap.bitmap_val_0 =
+		    osd_device->ops.get_palette_map(osd_device,
+				     osdwin, 0);
+		bitmap_conf_params->clut_idx.for_1bit_bitmap.bitmap_val_1 =
+		    osd_device->ops.get_palette_map(osd_device,
+				     osdwin, 1);
+		break;
+	case 2:
+		bitmap_conf_params->clut_idx.for_2bit_bitmap.bitmap_val_0 =
+		    osd_device->ops.get_palette_map(osd_device,
+				     osdwin, 0);
+		bitmap_conf_params->clut_idx.for_2bit_bitmap.bitmap_val_1 =
+		    osd_device->ops.get_palette_map(osd_device,
+				     osdwin, 1);
+
+		bitmap_conf_params->clut_idx.for_2bit_bitmap.bitmap_val_2 =
+		    osd_device->ops.get_palette_map(osd_device,
+				     osdwin, 2);
+		bitmap_conf_params->clut_idx.for_2bit_bitmap.bitmap_val_3 =
+		    osd_device->ops.get_palette_map(osd_device,
+				     osdwin, 3);
+		break;
+	case 4:
+		bitmap_conf_params->clut_idx.for_4bit_bitmap.bitmap_val_0 =
+		    osd_device->ops.get_palette_map(osd_device,
+				     osdwin, 0);
+		bitmap_conf_params->clut_idx.for_4bit_bitmap.bitmap_val_1 =
+		    osd_device->ops.get_palette_map(osd_device,
+				     osdwin, 1);
+		bitmap_conf_params->clut_idx.for_4bit_bitmap.bitmap_val_2 =
+		    osd_device->ops.get_palette_map(osd_device,
+				     osdwin, 2);
+		bitmap_conf_params->clut_idx.for_4bit_bitmap.bitmap_val_3 =
+		    osd_device->ops.get_palette_map(osd_device,
+				     osdwin, 3);
+		bitmap_conf_params->clut_idx.for_4bit_bitmap.bitmap_val_4 =
+		    osd_device->ops.get_palette_map(osd_device,
+				     osdwin, 4);
+		bitmap_conf_params->clut_idx.for_4bit_bitmap.bitmap_val_5 =
+		    osd_device->ops.get_palette_map(osd_device,
+				     osdwin, 5);
+		bitmap_conf_params->clut_idx.for_4bit_bitmap.bitmap_val_6 =
+		    osd_device->ops.get_palette_map(osd_device,
+				     osdwin, 6);
+
+		bitmap_conf_params->clut_idx.for_4bit_bitmap.bitmap_val_7 =
+		    osd_device->ops.get_palette_map(osd_device,
+						    osdwin, 7);
+		bitmap_conf_params->clut_idx.for_4bit_bitmap.bitmap_val_8 =
+		    osd_device->ops.get_palette_map(osd_device,
+				     osdwin, 8);
+		bitmap_conf_params->clut_idx.for_4bit_bitmap.bitmap_val_9 =
+		    osd_device->ops.get_palette_map(osd_device,
+				     osdwin, 9);
+
+		bitmap_conf_params->clut_idx.for_4bit_bitmap.bitmap_val_10 =
+		    osd_device->ops.get_palette_map(osd_device,
+				     osdwin, 10);
+
+		bitmap_conf_params->clut_idx.for_4bit_bitmap.bitmap_val_11 =
+		    osd_device->ops.get_palette_map(osd_device,
+				     osdwin, 11);
+
+		bitmap_conf_params->clut_idx.for_4bit_bitmap.bitmap_val_12 =
+		    osd_device->ops.get_palette_map(osd_device,
+				     osdwin, 12);
+		bitmap_conf_params->clut_idx.for_4bit_bitmap.bitmap_val_13 =
+		    osd_device->ops.get_palette_map(osd_device,
+				     osdwin, 13);
+		bitmap_conf_params->clut_idx.for_4bit_bitmap.bitmap_val_14 =
+		    osd_device->ops.get_palette_map(osd_device,
+				     osdwin, 14);
+		bitmap_conf_params->clut_idx.for_4bit_bitmap.bitmap_val_15 =
+		    osd_device->ops.get_palette_map(osd_device,
+				     osdwin, 15);
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+/*
+ * FBIO_SET_BITMAP_CONFIG_PARAMS handler
+ *
+ * The palette map is ignored unless the color depth is set to 1, 2, or 4 bits
+ * per pixel.  A default palette map is supplied for these color depths where
+ * the clut index is equal to the pixel value.  It is not necessary to change
+ * the default palette map when using the RAM clut, because the RAM clut values
+ * can be changed.  It is only necessary to modify the default palette map when
+ * using a ROM clut.
+ */
+static int
+davincifb_bitmap_set_params(struct fb_info *info,
+			    struct vpbe_bitmap_config_params*
+			    bitmap_conf_params)
+{
+	enum osd_layer osdwin = fb_info_to_osd_enum(info);
+	enum osd_clut clut = ROM_CLUT;
+
+	if (!is_osd_win(info))
+		return -EINVAL;
+
+	if (bitmap_conf_params->clut_select == 0)
+		osd_device->ops.set_rom_clut(osd_device, ROM_CLUT0);
+	else if (bitmap_conf_params->clut_select == 1)
+		osd_device->ops.set_rom_clut(osd_device, ROM_CLUT1);
+	else if (bitmap_conf_params->clut_select == 2)
+		clut = RAM_CLUT;
+	else
+		return -EINVAL;
+
+	osd_device->ops.set_osd_clut(osd_device, osdwin, clut);
+
+	osd_device->ops.set_rec601_attenuation(osd_device, osdwin,
+				bitmap_conf_params->attenuation_enable);
+
+	switch (info->var.bits_per_pixel) {
+	case 1:
+		osd_device->ops.set_palette_map(osd_device,
+				 osdwin, 0, bitmap_conf_params->clut_idx.
+				 for_1bit_bitmap.bitmap_val_0);
+		osd_device->ops.set_palette_map(osd_device,
+				 osdwin, 1, bitmap_conf_params->clut_idx.
+				 for_1bit_bitmap.bitmap_val_1);
+		break;
+	case 2:
+		osd_device->ops.set_palette_map(osd_device,
+				 osdwin, 0, bitmap_conf_params->clut_idx.
+				 for_2bit_bitmap.bitmap_val_0);
+		osd_device->ops.set_palette_map(osd_device,
+				 osdwin, 1, bitmap_conf_params->clut_idx.
+				 for_2bit_bitmap.bitmap_val_1);
+		osd_device->ops.set_palette_map(osd_device,
+				 osdwin, 2, bitmap_conf_params->clut_idx.
+				 for_2bit_bitmap.bitmap_val_2);
+		osd_device->ops.set_palette_map(osd_device,
+				 osdwin, 3, bitmap_conf_params->clut_idx.
+				 for_2bit_bitmap.bitmap_val_3);
+
+		break;
+	case 4:
+		osd_device->ops.set_palette_map(osd_device,
+				 osdwin, 0, bitmap_conf_params->clut_idx.
+				 for_4bit_bitmap.bitmap_val_0);
+		osd_device->ops.set_palette_map(osd_device,
+				 osdwin, 1, bitmap_conf_params->clut_idx.
+				 for_4bit_bitmap.bitmap_val_1);
+		osd_device->ops.set_palette_map(osd_device,
+				 osdwin, 2, bitmap_conf_params->clut_idx.
+				 for_4bit_bitmap.bitmap_val_2);
+		osd_device->ops.set_palette_map(osd_device,
+				 osdwin, 3, bitmap_conf_params->clut_idx.
+				 for_4bit_bitmap.bitmap_val_3);
+		osd_device->ops.set_palette_map(osd_device,
+				 osdwin, 4, bitmap_conf_params->clut_idx.
+				 for_4bit_bitmap.bitmap_val_4);
+		osd_device->ops.set_palette_map(osd_device,
+				 osdwin, 5, bitmap_conf_params->clut_idx.
+				 for_4bit_bitmap.bitmap_val_5);
+		osd_device->ops.set_palette_map(osd_device,
+				 osdwin, 6, bitmap_conf_params->clut_idx.
+				 for_4bit_bitmap.bitmap_val_6);
+		osd_device->ops.set_palette_map(osd_device,
+				 osdwin, 7, bitmap_conf_params->clut_idx.
+				 for_4bit_bitmap.bitmap_val_7);
+		osd_device->ops.set_palette_map(osd_device,
+				 osdwin, 8, bitmap_conf_params->clut_idx.
+				 for_4bit_bitmap.bitmap_val_8);
+		osd_device->ops.set_palette_map(osd_device,
+				 osdwin, 9, bitmap_conf_params->clut_idx.
+				 for_4bit_bitmap.bitmap_val_9);
+		osd_device->ops.set_palette_map(osd_device,
+				 osdwin, 10, bitmap_conf_params->clut_idx.
+				 for_4bit_bitmap.bitmap_val_10);
+		osd_device->ops.set_palette_map(osd_device,
+				 osdwin, 11, bitmap_conf_params->clut_idx.
+				 for_4bit_bitmap.bitmap_val_11);
+		osd_device->ops.set_palette_map(osd_device,
+				 osdwin, 12, bitmap_conf_params->clut_idx.
+				 for_4bit_bitmap.bitmap_val_12);
+		osd_device->ops.set_palette_map(osd_device,
+				 osdwin, 13, bitmap_conf_params->clut_idx.
+				 for_4bit_bitmap.bitmap_val_13);
+		osd_device->ops.set_palette_map(osd_device,
+				 osdwin, 14, bitmap_conf_params->clut_idx.
+				 for_4bit_bitmap.bitmap_val_14);
+		osd_device->ops.set_palette_map(osd_device,
+				 osdwin, 15, bitmap_conf_params->clut_idx.
+				 for_4bit_bitmap.bitmap_val_15);
+
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+/*
+ * FBIO_SET_BACKG_COLOR handler
+ */
+static int
+davincifb_set_backg_color(struct fb_info *info,
+			  struct vpbe_backg_color *backg_color)
+{
+	enum osd_clut clut = ROM_CLUT;
+
+	if (backg_color->clut_select == 0)
+		osd_device->ops.set_rom_clut(osd_device, ROM_CLUT0);
+	else if (backg_color->clut_select == 1)
+		osd_device->ops.set_rom_clut(osd_device, ROM_CLUT1);
+	else if (backg_color->clut_select == 2)
+		clut = RAM_CLUT;
+	else
+		return -EINVAL;
+
+	osd_device->ops.set_background(osd_device, clut,
+			 backg_color->color_offset);
+
+	return 0;
+}
+
+/*
+ * FBIO_SETPOS handler
+ */
+static int
+davincifb_setpos(struct fb_info *info,
+		 struct vpbe_window_position *win_pos)
+{
+	struct vpbe_dm_win_info *win = info->par;
+	struct fb_var_screeninfo *var = &info->var;
+	unsigned old_xpos = win->xpos;
+	unsigned old_ypos = win->ypos;
+	struct fb_var_screeninfo v;
+	int retval;
+
+	if (!win->own_window)
+		return -ENODEV;
+
+	memcpy(&v, var, sizeof(v));
+	win->xpos = win_pos->xpos;
+	win->ypos = win_pos->ypos;
+	retval = info->fbops->fb_check_var(&v, info);
+	if (retval) {
+		win->xpos = old_xpos;
+		win->ypos = old_ypos;
+		return retval;
+	}
+	/* update the window position */
+	memcpy(var, &v, sizeof(v));
+	retval = info->fbops->fb_set_par(info);
+
+	return retval;
+}
+
+/*
+ * FBIO_SET_CURSOR handler
+ */
+static int
+davincifb_set_cursor_params(struct fb_info *info,
+			    struct fb_cursor *fbcursor)
+{
+	struct osd_cursor_config cursor;
+
+	if (!fbcursor->enable) {
+		osd_device->ops.cursor_disable(osd_device);
+		return 0;
+	}
+
+	cursor.xsize = fbcursor->image.width;
+	cursor.ysize = fbcursor->image.height;
+	cursor.xpos = fbcursor->image.dx;
+	cursor.ypos = fbcursor->image.dy;
+	cursor.interlaced = is_window_interlaced(&info->var);
+	cursor.h_width =
+	    (fbcursor->image.depth > 7) ? 7 : fbcursor->image.depth;
+	cursor.v_width = cursor.h_width;
+	cursor.clut = ROM_CLUT;
+	cursor.clut_index = fbcursor->image.fg_color;
+	osd_device->ops.set_cursor_config(osd_device, &cursor);
+	osd_device->ops.cursor_enable(osd_device);
+
+	return 0;
+}
+
+static int
+davincifb_ioctl(struct fb_info *info, unsigned int cmd,	unsigned long arg)
+{
+	struct vpbe_bitmap_config_params bitmap_conf_params;
+	struct vpbe_video_config_params vid_conf_params;
+	struct vpbe_bitmap_blend_params blend_para;
+	struct vpbe_dm_win_info *win = info->par;
+	void __user *argp = (void __user *)arg;
+	struct vpbe_blink_option blink_option;
+	struct vpbe_backg_color backg_color;
+	struct vpbe_window_position win_pos;
+	struct fb_fillrect rect;
+	struct zoom_params zoom;
+	struct fb_cursor cursor;
+	int retval = 0;
+
+	switch (cmd) {
+	case FBIO_WAITFORVSYNC:
+		/* This ioctl accepts an integer argument to specify a
+		 * display.  We only support one display, so we will
+		 * simply ignore the argument.
+		 */
+		return davincifb_wait_for_vsync(info);
+
+	case FBIO_SETATTRIBUTE:
+		if (copy_from_user(&rect, argp, sizeof(rect)))
+			return -EFAULT;
+		return davincifb_set_attr_blend(info, &rect);
+
+	case FBIO_SETPOSX:
+		return davincifb_setposx(info, arg);
+
+	case FBIO_SETPOSY:
+		return davincifb_setposy(info, arg);
+
+	case FBIO_SETZOOM:
+		if (copy_from_user(&zoom, argp, sizeof(zoom)))
+			return -EFAULT;
+		return davincifb_set_zoom(info, &zoom);
+
+	case FBIO_ENABLE_DISABLE_WIN:
+		return davincifb_enable_disable_win(info, arg);
+
+	case FBIO_SET_BITMAP_BLEND_FACTOR:
+		if (copy_from_user(&blend_para, argp, sizeof(blend_para)))
+			return -EFAULT;
+		return davincifb_bitmap_set_blend_factor(info, &blend_para);
+
+	case FBIO_SET_BITMAP_WIN_RAM_CLUT:
+		if (copy_from_user(win->dm->ram_clut[0], argp, RAM_CLUT_SIZE))
+			return -EFAULT;
+		return davincifb_bitmap_set_ram_clut(info, win->dm->ram_clut);
+
+	case FBIO_ENABLE_DISABLE_ATTRIBUTE_WIN:
+		return davincifb_enable_disable_attribute_window(info, arg);
+
+	case FBIO_GET_BLINK_INTERVAL:
+		retval = davincifb_get_blinking(info, &blink_option);
+		if (retval < 0)
+			return retval;
+		if (copy_to_user(argp, &blink_option, sizeof(blink_option)))
+			return -EFAULT;
+		return 0;
+
+	case FBIO_SET_BLINK_INTERVAL:
+		if (copy_from_user(&blink_option, argp, sizeof(blink_option)))
+			return -EFAULT;
+		return davincifb_set_blinking(info, &blink_option);
+
+	case FBIO_GET_VIDEO_CONFIG_PARAMS:
+		retval = davincifb_get_vid_params(info, &vid_conf_params);
+		if (retval < 0)
+			return retval;
+		if (copy_to_user
+		    (argp, &vid_conf_params, sizeof(vid_conf_params)))
+			return -EFAULT;
+		return 0;
+
+	case FBIO_SET_VIDEO_CONFIG_PARAMS:
+		if (copy_from_user
+		    (&vid_conf_params, argp, sizeof(vid_conf_params)))
+			return -EFAULT;
+		return davincifb_set_vid_params(info, &vid_conf_params);
+
+	case FBIO_GET_BITMAP_CONFIG_PARAMS:
+		retval = davincifb_bitmap_get_params(info, &bitmap_conf_params);
+		if (retval < 0)
+			return retval;
+		if (copy_to_user
+		    (argp, &bitmap_conf_params, sizeof(bitmap_conf_params)))
+			return -EFAULT;
+		return 0;
+
+	case FBIO_SET_BITMAP_CONFIG_PARAMS:
+		if (copy_from_user
+		    (&bitmap_conf_params, argp, sizeof(bitmap_conf_params)))
+			return -EFAULT;
+		return davincifb_bitmap_set_params(info, &bitmap_conf_params);
+
+	case FBIO_SET_BACKG_COLOR:
+		if (copy_from_user(&backg_color, argp, sizeof(backg_color)))
+			return -EFAULT;
+		return davincifb_set_backg_color(info, &backg_color);
+
+	case FBIO_SETPOS:
+		if (copy_from_user(&win_pos, argp, sizeof(win_pos)))
+			return -EFAULT;
+		return davincifb_setpos(info, &win_pos);
+
+	case FBIO_SET_CURSOR:
+		if (copy_from_user(&cursor, argp, sizeof(cursor)))
+			return -EFAULT;
+		return davincifb_set_cursor_params(info, &cursor);
+
+	default:
+		return -EINVAL;
+	}
+}
+
+static int
+davincifb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
+{
+	struct vpbe_dm_win_info *win = info->par;
+	struct fb_videomode *mode = &win->dm->mode;
+	struct osd_layer_config lconfig;
+	struct fb_fix_screeninfo fix;
+
+	/*
+	 * Get an updated copy of the video mode from the encoder manager, just
+	 * in case the display has been switched.
+	 */
+	get_video_mode(win->dm->vpbe_dev, mode);
+
+	/*
+	 * xres, yres, xres_virtual, or yres_virtual equal to zero is treated as
+	 * a special case.  It indicates that the window should be disabled.  If
+	 * the window is a video window, it will also be released.
+	 */
+	if (var->xres == 0 || var->yres == 0 ||
+	    var->xres_virtual == 0 || var->yres_virtual == 0) {
+		var->xres = 0;
+		var->yres = 0;
+		var->xres_virtual = 0;
+		var->yres_virtual = 0;
+		return 0;
+	}
+
+	switch (var->bits_per_pixel) {
+	case 1:
+	case 2:
+	case 4:
+	case 8:
+	case 16:
+		break;
+	case 24:
+		if (cpu_is_davinci_dm355())
+			return -EINVAL;
+		break;
+	case 32:
+		if (cpu_is_davinci_dm644x())
+			return -EINVAL;
+		break;
+	default:
+		return -EINVAL;
+	}
+	if (var->xres_virtual < var->xres || var->yres_virtual < var->yres)
+		return -EINVAL;
+	if (var->xoffset > var->xres_virtual - var->xres)
+		return -EINVAL;
+	if (var->yoffset > var->yres_virtual - var->yres)
+		return -EINVAL;
+	if (mode->xres < var->xres || mode->yres < var->yres)
+		return -EINVAL;
+	if (win->xpos > mode->xres - var->xres)
+		return -EINVAL;
+	if (win->ypos > mode->yres - var->yres)
+		return -EINVAL;
+	convert_fb_var_to_osd(var, &lconfig, win->dm->yc_pixfmt);
+
+	update_fix_info(var, &fix);
+	lconfig.line_length = fix.line_length;
+	lconfig.xpos = win->xpos;
+	lconfig.ypos = win->ypos;
+	/* xoffset must be a multiple of xpanstep */
+	if (var->xoffset & ~(fix.xpanstep - 1))
+		return -EINVAL;
+
+	/* check if we have enough video memory to support this mode */
+	if (!window_will_fit_framebuffer(var, info->fix.smem_len))
+		return -EINVAL;
+	/* see if the OSD manager approves of this configuration */
+	if (osd_device->ops.try_layer_config(osd_device, win->layer, &lconfig))
+		return -EINVAL;
+	/*
+	 * Reject this var if the OSD manager would have to modify the window
+	 * geometry to make it work.
+	 */
+	if (lconfig.xsize != var->xres || lconfig.ysize != var->yres)
+		return -EINVAL;
+	if (lconfig.xpos != win->xpos || lconfig.ypos != win->ypos)
+		return -EINVAL;
+	/*
+	 * At this point we have accepted the var, so now we convert our layer
+	 * configuration struct back to the var in order to make all of the
+	 * pixel format and geometry values consistent.  The var timing values
+	 * will be unmodified, as we have no way to verify them.
+	 */
+	convert_osd_to_fb_var(&lconfig, var);
+	return 0;
+}
+
+static int davincifb_set_par(struct fb_info *info)
+{
+	struct vpbe_dm_win_info *win = info->par;
+	struct vpbe_device *vpbe_dev = win->dm->vpbe_dev;
+	struct fb_var_screeninfo *var = &info->var;
+	struct osd_layer_config lconfig;
+	struct fb_videomode mode;
+	unsigned start;
+
+	/* update the fix info to be consistent with the var */
+	update_fix_info(var, &info->fix);
+	convert_fb_info_to_osd(info, &lconfig);
+
+	/* See if we need to pass the timing values to the encoder manager. */
+	memcpy(&mode, &win->dm->mode, sizeof(mode));
+	fb_var_to_videomode(&mode, var);
+	mode.name = win->dm->mode.name;
+	if (mode.xres == win->dm->mode.xres && mode.yres ==
+		win->dm->mode.yres && mode.pixclock != 0 &&
+		!fb_mode_is_equal(&mode, &win->dm->mode)) {
+		/*
+		 * If the timing parameters from the var are different than the
+		 * timing parameters from the encoder, try to update the
+		 * timing parameters with the encoder manager.
+		 */
+		set_video_mode(vpbe_dev, &mode);
+	}
+	/* update our copy of the encoder video mode */
+	get_video_mode(vpbe_dev, &win->dm->mode);
+
+	/*
+	 * Update the var with the encoder timing info.  The window geometry
+	 * will be preserved.
+	 */
+	construct_fb_var(var, &win->dm->mode, &lconfig);
+
+	/* need to update interlaced since the mode may have changed */
+	lconfig.interlaced = win->dm->mode.vmode;
+	var->vmode = win->dm->mode.vmode;
+	/*
+	 * xres, yres, xres_virtual, or yres_virtual equal to zero is treated as
+	 * a special case.  It indicates that the window should be disabled.  If
+	 * the window is a video window, it will also be released.
+	 * Note that we disable the window, but we do not set the
+	 * win->disable_window flag.  This allows the window to be re-enabled
+	 * simply by using the FBIOPUT_VSCREENINFO ioctl to set a valid
+	 * configuration.
+	 */
+	if (lconfig.xsize == 0 || lconfig.ysize == 0) {
+		if (win->own_window) {
+			osd_device->ops.disable_layer(osd_device, win->layer);
+			if (is_vid_win(info)) {
+				win->own_window = 0;
+				osd_device->ops.release_layer(osd_device,
+							      win->layer);
+			}
+		}
+		return 0;
+	}
+
+	/*
+	 * If we don't currently own this window, we must claim it from the OSD
+	 * manager.
+	 */
+	if (!win->own_window) {
+		if (osd_device->ops.request_layer(osd_device, win->layer))
+			return -ENODEV;
+		win->own_window = 1;
+	}
+
+	if (!win->own_window) {
+		if (osd_device->ops.request_layer(osd_device, win->layer))
+			return -ENODEV;
+		win->own_window = 1;
+	}
+
+	/* DM365 YUV420 Planar */
+	if (cpu_is_davinci_dm365() && info->var.bits_per_pixel == 8 &&
+	    (win->layer == WIN_VID0 || win->layer == WIN_VID1))
+		start = info->fix.smem_start + (var->xoffset * 12) / 8 +
+			var->yoffset * 3 / 2 * info->fix.line_length;
+	else
+		start = info->fix.smem_start + (var->xoffset *
+			var->bits_per_pixel) / 8 + var->yoffset *
+			info->fix.line_length;
+
+	osd_device->ops.set_layer_config(osd_device, win->layer, &lconfig);
+	osd_device->ops.start_layer(osd_device, win->layer, start,
+						fb_cbcr_ofst);
+	if (win->display_window)
+		osd_device->ops.enable_layer(osd_device,
+				 win->layer, 0);
+
+	return 0;
+}
+
+/*
+ * This macro converts a 16-bit color passed to fb_setcolreg to the width
+ * supported by the pixel format.
+ */
+#define CNVT_TOHW(val, width) ((((val)<<(width))+0x7FFF-(val))>>16)
+
+static int davincifb_setcolreg(unsigned regno, unsigned red, unsigned green,
+			       unsigned blue, unsigned transp,
+			       struct fb_info *info)
+{
+	unsigned r;
+	unsigned g;
+	unsigned b;
+	unsigned t;
+
+	/* no. of hw registers */
+	if (regno >= 256)
+		return -EINVAL;
+
+	/*
+	 * An RGB color palette isn't applicable to a window with a YUV pixel
+	 * format or to a window in attribute mode.
+	 */
+	if (is_yuv(&info->var) || is_attribute_mode(&info->var))
+		return -EINVAL;
+
+	switch (info->fix.visual) {
+	case FB_VISUAL_TRUECOLOR:
+		r = CNVT_TOHW(red, info->var.red.length);
+		g = CNVT_TOHW(green, info->var.green.length);
+		b = CNVT_TOHW(blue, info->var.blue.length);
+		t = CNVT_TOHW(transp, info->var.transp.length);
+		break;
+	case FB_VISUAL_PSEUDOCOLOR:
+	default:
+		r = CNVT_TOHW(red, 8);
+		g = CNVT_TOHW(green, 8);
+		b = CNVT_TOHW(blue, 8);
+		t = 0;
+		break;
+	}
+
+	/* Truecolor has hardware independent palette */
+	if (info->fix.visual == FB_VISUAL_TRUECOLOR) {
+		u32 v;
+
+		if (regno >= 16)
+			return -EINVAL;
+
+		v = (r << info->var.red.offset) |
+		    (g << info->var.green.offset) |
+		    (b << info->var.blue.offset) |
+		    (t << info->var.transp.offset);
+
+		switch (info->var.bits_per_pixel) {
+		case 16:
+			((u16 *)info->pseudo_palette)[regno] = v;
+			break;
+		case 24:
+		case 32:
+			((u32 *)info->pseudo_palette)[regno] = v;
+			break;
+		}
+		return 0;
+	}
+
+	if (!is_osd_win(info))
+		return -EINVAL;
+
+	osd_device->ops.set_clut_rgb(osd_device, regno, r, g, b);
+
+	return 0;
+}
+
+static int venc_is_second_field(struct vpbe_device *vpbe_dev)
+{
+	int ret;
+	int val = 0;
+	ret = v4l2_subdev_call(vpbe_dev->venc, core, ioctl, VENC_GET_FLD,
+				&val);
+	if (ret < 0)
+		dev_err(vpbe_dev->pdev, "Error in getting Field ID 0\n");
+	return val;
+}
+
+/*
+ * davincifb_pan_display(): Pan the display using the `xoffset' and `yoffset'
+ *                          fields of the `var' structure.  We don't support
+ *                          wrapping and ignore the FB_VMODE_YWRAP flag.
+ */
+static int
+davincifb_pan_display(struct fb_var_screeninfo *var, struct fb_info *info)
+{
+	struct vpbe_dm_win_info *win = info->par;
+	struct vpbe_device *vpbe_dev = win->dm->vpbe_dev;
+	unsigned start;
+
+	if (!win->own_window)
+		return -ENODEV;
+
+	if (var->xoffset > info->var.xres_virtual - info->var.xres)
+		return -EINVAL;
+	if (var->yoffset > info->var.yres_virtual - info->var.yres)
+		return -EINVAL;
+
+	/* xoffset must be a multiple of xpanstep */
+	if (var->xoffset & ~(info->fix.xpanstep - 1))
+		return -EINVAL;
+
+	/* For DM365 video windows:
+	 * using bits_per_pixel to calculate start/offset address
+	 * needs to be changed for YUV420 planar format since
+	 * it is 8. But consider CbCr the real (avg) bits per pixel
+	 * is 12. line_length is calcuate using 8, so offset needs
+	 * to time 1.5 to take C plane into account.
+	 */
+	if (cpu_is_davinci_dm365() && info->var.bits_per_pixel == 8 &&
+	    (win->layer == WIN_VID0 || win->layer == WIN_VID1))
+		start = info->fix.smem_start + (var->xoffset * 12) / 8 +
+			var->yoffset * 3 / 2 * info->fix.line_length;
+	else
+		start = info->fix.smem_start + (var->xoffset *
+			info->var.bits_per_pixel) / 8 + var->yoffset *
+			info->fix.line_length;
+
+	if (venc_is_second_field(vpbe_dev))
+		osd_device->ops.start_layer(osd_device, win->layer, start,
+					    fb_cbcr_ofst);
+	else
+		win->sdram_address = start;
+
+	return 0;
+}
+
+/*
+ * davincifb_blank(): Blank the screen if blank_mode != 0, else unblank.
+ */
+int davincifb_blank(int blank_mode, struct fb_info *info)
+{
+	struct vpbe_dm_win_info *win = info->par;
+	int retval = 0;
+
+	if (!win->own_window)
+		return -ENODEV;
+
+	if (blank_mode) {
+		win->display_window = 0;
+		osd_device->ops.disable_layer(osd_device, win->layer);
+		return retval;
+	}
+	win->display_window = 1;
+	retval = info->fbops->fb_check_var(&info->var, info);
+	if (retval)
+		return retval;
+	retval = info->fbops->fb_set_par(info);
+	return retval;
+}
+
+/*
+ *  Frame buffer operations
+ */
+static struct fb_ops vpbe_fb_ops = {
+	.owner = THIS_MODULE,
+	.fb_check_var = davincifb_check_var,
+	.fb_set_par = davincifb_set_par,
+	.fb_setcolreg = davincifb_setcolreg,
+	.fb_blank = davincifb_blank,
+	.fb_pan_display = davincifb_pan_display,
+	.fb_fillrect = cfb_fillrect,
+	.fb_copyarea = cfb_copyarea,
+	.fb_imageblit = cfb_imageblit,
+	.fb_rotate = NULL,
+	.fb_sync = NULL,
+	.fb_ioctl = davincifb_ioctl,
+};
+
+static void davincifb_release_window(struct device *dev,
+				     struct vpbe_dm_win_info *win)
+{
+	struct fb_info *info = win->info;
+
+	if (info) {
+		unregister_framebuffer(info);
+		win->info = NULL;
+	}
+
+	if (win->own_window) {
+		osd_device->ops.release_layer(osd_device,
+				 win->layer);
+		win->own_window = 0;
+	}
+	win->display_window = 0;
+
+	if (info) {
+		dma_free_coherent(dev, info->fix.smem_len, info->screen_base,
+				  info->fix.smem_start);
+		fb_dealloc_cmap(&info->cmap);
+		kfree(info);
+	}
+}
+
+static int davincifb_init_window(struct device *dev,
+				 struct vpbe_dm_win_info *win,
+				 struct osd_layer_config *lconfig,
+				 unsigned fb_size, const char *name)
+{
+	struct fb_info *info;
+	int err = 0;
+
+	if (!fb_size)
+		return 0;
+
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info) {
+		dev_err(dev, "%s: Can't allocate memory for fb_info struct.\n",
+			name);
+		return -ENOMEM;
+	}
+
+	win->info = info;
+	/* initialize fb_info */
+	info->par = win;
+	info->flags = FBINFO_DEFAULT | FBINFO_HWACCEL_COPYAREA |
+		FBINFO_HWACCEL_FILLRECT | FBINFO_HWACCEL_IMAGEBLIT |
+		FBINFO_HWACCEL_XPAN | FBINFO_HWACCEL_YPAN;
+	info->fbops = &vpbe_fb_ops;
+	info->screen_size = fb_size;
+	info->pseudo_palette = win->pseudo_palette;
+	if (fb_alloc_cmap(&info->cmap, 256, 0) < 0) {
+		dev_err(dev, "%s: Can't allocate color map.\n", name);
+		err = -ENODEV;
+		goto cmap_out;
+	}
+
+	/* initialize fb_fix_screeninfo */
+	strlcpy(info->fix.id, name, sizeof(info->fix.id));
+	info->fix.smem_len = fb_size;
+	info->fix.type = FB_TYPE_PACKED_PIXELS;
+
+	/* allocate the framebuffer */
+	info->screen_base =
+		dma_alloc_coherent(dev, info->fix.smem_len,
+				   (dma_addr_t *)&info->fix.smem_start,
+				   GFP_KERNEL | GFP_DMA);
+	if (!info->screen_base) {
+		dev_err(dev, "%s: dma_alloc_coherent failed\n", name);
+		err = -ENOMEM;
+		goto fb_alloc_out;
+	}
+
+	/*
+	 * Fill the framebuffer with zeros unless it is an OSD1 window in
+	 * attribute mode, in which case we fill it with 0x77 to make the OSD0
+	 * pixels opaque.
+	 */
+	memset(info->screen_base,
+	       (lconfig->pixfmt == PIXFMT_OSD_ATTR) ? 0x77 : 0,
+	       info->fix.smem_len);
+
+	/* initialize fb_var_screeninfo */
+	construct_fb_var(&info->var, &win->dm->mode, lconfig);
+	win->xpos = lconfig->xpos;
+	win->ypos = lconfig->ypos;
+	info->var.xres_virtual = info->var.xres;
+	info->var.yres_virtual = info->var.yres;
+
+	/* update the fix info to be consistent with the var */
+	update_fix_info(&info->var, &info->fix);
+
+	/*
+	 * Request ownership of the window from the OSD manager unless this is
+	 * a video window and the window size is 0.
+	 */
+
+	if ((is_osd_win(info) || (info->var.xres != 0 && info->var.yres !=
+	    0)) && !osd_device->ops.request_layer(osd_device, win->layer)) {
+			win->own_window = 1;
+	}
+	/* bail out if this is an OSD window and we don't own it */
+	if (is_osd_win(info) && !win->own_window) {
+		dev_err(dev,
+			"%s:Failed to obtain ownership of OSD window\n", name);
+		err = -ENODEV;
+		goto own_out;
+	}
+
+	win->display_window = 1;
+
+	if (win->own_window) {
+		/* check if our initial window configuration is valid */
+		if (info->fbops->fb_check_var(&info->var, info))
+			dev_warn(dev,
+				 "%s:Initial window configuration is invalid\n",
+				 name);
+		else
+			info->fbops->fb_set_par(info);
+	}
+
+	/* register the framebuffer */
+	if (register_framebuffer(info)) {
+		dev_err(dev, "%s: Failed to register framebuffer.\n", name);
+		err = -ENODEV;
+		goto register_out;
+	}
+
+	dev_info(dev, "%s: %dx%dx%d@%d,%d with framebuffer size %dKB\n",
+		 info->fix.id, info->var.xres, info->var.yres,
+		 info->var.bits_per_pixel, win->xpos, win->ypos,
+		 info->fix.smem_len >> 10);
+
+	return 0;
+
+register_out:
+	if (win->own_window)
+		osd_device->ops.release_layer(osd_device,
+				 win->layer);
+	win->own_window = 0;
+own_out:
+	dma_free_coherent(dev, info->fix.smem_len, info->screen_base,
+			  info->fix.smem_start);
+fb_alloc_out:
+	fb_dealloc_cmap(&info->cmap);
+cmap_out:
+	kfree(info);
+
+	return err;
+}
+
+static int davincifb_remove(struct platform_device *pdev)
+{
+	struct vpbe_dm_info *dm = platform_get_drvdata(pdev);
+	struct vpbe_device *vpbe_dev = dm->vpbe_dev;
+
+	platform_set_drvdata(pdev, NULL);
+
+	v4l2_subdev_call(vpbe_dev->venc, core, ioctl,
+			 VENC_UNREG_CALLBACK, &dm->vsync_callback);
+
+	davincifb_release_window(&pdev->dev, &dm->win[WIN_VID1]);
+	davincifb_release_window(&pdev->dev, &dm->win[WIN_OSD1]);
+	davincifb_release_window(&pdev->dev, &dm->win[WIN_VID0]);
+	davincifb_release_window(&pdev->dev, &dm->win[WIN_OSD0]);
+	kfree(dm);
+
+	return 0;
+}
+
+/*
+ * Return the maximum number of bytes per screen for a display layer at a
+ * resolution specified by an fb_videomode struct.
+ */
+static unsigned davincifb_max_screen_size(enum osd_layer layer,
+					  const struct fb_videomode *mode)
+{
+	unsigned max_bpp = 32;
+	unsigned line_length;
+	unsigned size;
+
+	switch (layer) {
+	case WIN_OSD0:
+	case WIN_OSD1:
+		if (cpu_is_davinci_dm355())
+			max_bpp = 32;
+		else
+			max_bpp = 16;
+		break;
+	case WIN_VID0:
+	case WIN_VID1:
+		if (cpu_is_davinci_dm355())
+			max_bpp = 16;
+		else
+			max_bpp = 24;
+		break;
+	}
+
+	line_length = (mode->xres * max_bpp + 7) / 8;
+	line_length = ((line_length + 31) / 32) * 32;
+	size = mode->yres * line_length;
+
+	return size;
+}
+
+static void parse_win_params(struct vpbe_dm_win_info *win,
+			     struct osd_layer_config *lconfig,
+			     unsigned *fb_size, char *opt)
+{
+	char *s, *p, c = 0;
+	unsigned bits_per_pixel;
+
+	if (!opt)
+		return;
+
+	/* xsize */
+	p = strpbrk(opt, "x,@");
+	if (p)
+		c = *p;
+	s = strsep(&opt, "x,@");
+	if (s == NULL)
+		return;
+	if (*s && kstrtoul(s, 0, (long unsigned*)&lconfig->xsize))
+		goto parse_error;
+	if (!p || !opt)
+		return;
+
+	/* ysize */
+	if (c == 'x') {
+		p = strpbrk(opt, "x,@");
+		if (p)
+			c = *p;
+		s = strsep(&opt, "x,@");
+		if (s == NULL)
+			return;
+		if (*s && kstrtoul(s, 0, (long unsigned*)&lconfig->ysize))
+			goto parse_error;
+		if (!p || !opt)
+			return;
+	}
+
+	/* bits per pixel */
+	if (c == 'x') {
+		p = strpbrk(opt, ",@");
+		if (p)
+			c = *p;
+		s = strsep(&opt, ",@");
+		if (s == NULL)
+			return;
+		if (*s) {
+			if (kstrtoul(s, 0, (long unsigned*)&bits_per_pixel))
+				goto parse_error;
+			switch (bits_per_pixel) {
+			case 1:
+				if (win->layer == WIN_OSD0 ||
+				    win->layer == WIN_OSD1)
+					lconfig->pixfmt = PIXFMT_1BPP;
+				break;
+			case 2:
+				if (win->layer == WIN_OSD0 ||
+				    win->layer == WIN_OSD1)
+					lconfig->pixfmt = PIXFMT_2BPP;
+				break;
+			case 4:
+				if (win->layer == WIN_OSD0 ||
+				    win->layer == WIN_OSD1)
+					lconfig->pixfmt = PIXFMT_4BPP;
+				break;
+			case 8:
+				if (win->layer == WIN_OSD0 ||
+				    win->layer == WIN_OSD1)
+					lconfig->pixfmt = PIXFMT_8BPP;
+				if (cpu_is_davinci_dm365())
+					if (win->layer == WIN_VID0 ||
+					    win->layer == WIN_VID1)
+						lconfig->pixfmt = PIXFMT_NV12;
+				break;
+			case 16:
+				if (win->layer == WIN_OSD0 ||
+				    win->layer == WIN_OSD1)
+					lconfig->pixfmt = PIXFMT_RGB565;
+				else
+					lconfig->pixfmt = win->dm->yc_pixfmt;
+				break;
+			case 24:
+				if (cpu_is_davinci_dm644x() &&
+				    (win->layer == WIN_VID0 ||
+				     win->layer == WIN_VID1))
+					lconfig->pixfmt = PIXFMT_RGB888;
+				break;
+			case 32:
+				if (cpu_is_davinci_dm355() &&
+				    (win->layer == WIN_OSD0 ||
+				     win->layer == WIN_OSD1))
+					lconfig->pixfmt = PIXFMT_RGB888;
+				break;
+			default:
+				break;
+			}
+		}
+		if (!p || !opt)
+			return;
+	}
+
+	/* framebuffer size */
+	if (c == ',') {
+		p = strpbrk(opt, "@");
+		if (p)
+			c = *p;
+		s = strsep(&opt, "@");
+		if (s == NULL)
+			return;
+		if (*s) {
+			*fb_size = simple_strtoul(s, &s, 0);
+			if (*s == 'K')
+				*fb_size <<= 10;
+			if (*s == 'M')
+				*fb_size <<= 20;
+		}
+		if (!p || !opt)
+			return;
+	}
+
+	/* xpos */
+	if (c == '@') {
+		p = strpbrk(opt, ",");
+		if (p)
+			c = *p;
+		s = strsep(&opt, ",");
+		if (s == NULL)
+			return;
+		if (*s && kstrtoul(s, 0, (long unsigned*)&lconfig->xpos))
+			goto parse_error;
+		if (!p || !opt)
+			return;
+	}
+
+	/* ypos */
+	if (c == ',') {
+		s = opt;
+		if (*s && kstrtoul(s, 0, (long unsigned*)&lconfig->ypos))
+			goto parse_error;
+	}
+
+	return;
+parse_error:
+	pr_err("davincifb bootparams parse error\n");
+}
+
+/*
+ * Pass boot-time options by adding the following string to the boot params:
+ *	video=vpbe_fb:options
+ * Valid options:
+ *	osd0=[MxNxP,S@X,Y]
+ *      osd1=[MxNxP,S@X,Y]
+ *	vid0=[off|MxNxP,S@X,Y]
+ *	vid1=[off|MxNxP,S@X,Y]
+ *		MxN are the horizontal and vertical window size
+ *		P is the color depth (bits per pixel)
+ *		S is the framebuffer size with a size suffix such as 'K' or 'M'
+ *		X,Y are the window position
+ *
+ * Only video windows can be turned off.  Turning off a video window means that
+ * no framebuffer device will be registered for it,
+ *
+ * To cause a window to be supported by the framebuffer driver but not displayed
+ * initially, pass a value of 0 struct vpbe_dm_win_info *win = info->par;
+ * struct vpbe_device *vpbe_dev = win->dm->vpbe_dev; for the window size.
+ *
+ * For example:
+ *      video=vpbe_fb:osd0=720x480x16@0,0:osd1=720x480:vid0=off:vid1=off
+ *
+ * This routine returns 1 if the window is to be turned off, or 0 otherwise.
+ */
+static int
+davincifb_get_default_win_config(struct device *dev,
+				 struct vpbe_dm_win_info *win,
+				 struct osd_layer_config *lconfig,
+				 unsigned *fb_size,
+				 const char *options)
+{
+	const char *win_names[] = { "osd0=", "vid0=", "osd1=", "vid1=" };
+	static char opt_buf[128];
+	const char *this_opt;
+	const char *next_opt;
+	int this_len;
+	int opt_len;
+
+	/* supply default values for lconfig and fb_size */
+	switch (win->layer) {
+	case WIN_OSD0:
+		lconfig->pixfmt = PIXFMT_RGB565;
+		lconfig->xsize = win->dm->mode.xres;
+		lconfig->ysize = win->dm->mode.yres;
+		break;
+	case WIN_OSD1:
+		lconfig->pixfmt = PIXFMT_OSD_ATTR;
+		lconfig->xsize = win->dm->mode.xres;
+		lconfig->ysize = win->dm->mode.yres;
+		break;
+	case WIN_VID0:
+	case WIN_VID1:
+		lconfig->pixfmt = win->dm->yc_pixfmt;
+		lconfig->xsize = 0;
+		lconfig->ysize = 0;
+		break;
+	}
+	lconfig->xpos = 0;
+	lconfig->ypos = 0;
+
+	lconfig->interlaced = is_display_interlaced(&win->dm->mode);
+	*fb_size = davincifb_max_screen_size(win->layer, &win->dm->mode);
+
+	next_opt = options;
+	while ((this_opt = next_opt)) {
+		this_len = strcspn(this_opt, ":");
+		next_opt = strpbrk(this_opt, ":");
+		if (next_opt)
+			++next_opt;
+
+		opt_len = strlen(win_names[win->layer]);
+		if (this_len >= opt_len) {
+			if (strncmp(this_opt, win_names[win->layer], opt_len))
+				continue;
+			this_len -= opt_len;
+			this_opt += opt_len;
+			if ((this_len >= strlen("off")) &&
+			    !strncmp(this_opt, "off", strlen("off")))
+				return 1;
+			else {
+				strlcpy(opt_buf, this_opt,
+					min_t(int, sizeof(opt_buf),
+					      this_len + 1));
+				parse_win_params(win, lconfig, fb_size,
+						 opt_buf);
+				return 0;
+			}
+		}
+	}
+
+	return 0;
+}
+
+/*
+ *     Module parameter definitions
+ */
+static char *options = "";
+
+module_param(options, charp, S_IRUGO);
+
+static int davincifb_callback_init(struct device *dev, void *data)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct vpbe_dm_info *dm = (struct vpbe_dm_info *)data;
+
+	if (strcmp("vpbe_controller", pdev->name) == 0)
+		dm->vpbe_dev = platform_get_drvdata(pdev);
+
+	return 0;
+}
+
+static int davincifb_device_get(struct device *dev, void *data)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	if (strstr(pdev->name, "vpbe-osd") != NULL)
+		osd_device = platform_get_drvdata(pdev);
+
+	return 0;
+}
+
+static int davincifb_probe(struct platform_device *pdev)
+{
+	struct osd_layer_config lconfig;
+	struct device_driver *drv;
+	struct vpbe_dm_info *dm;
+	unsigned fb_size;
+	int err;
+
+	dm = kzalloc(sizeof(*dm), GFP_KERNEL);
+	if (!dm) {
+		dev_err(&pdev->dev, "Can't allocate memory for driver state.\n");
+		return -ENOMEM;
+	}
+
+	/*
+	 * Scan all the platform devices to find the vpbe
+	 * controller device and get the vpbe_dev object
+	 */
+	drv = driver_find("vpbe_controller", &platform_bus_type);
+	err = driver_for_each_device(drv, NULL, dm, davincifb_callback_init);
+	if ((err < 0) || (dm->vpbe_dev == NULL))
+		return -ENODEV;
+
+	if (!dm->vpbe_dev->initialized) {
+		dev_err(&pdev->dev, "vpbe controller not initialized\n");
+		return -ENODEV;
+	}
+
+	err = bus_for_each_dev(&platform_bus_type, NULL, NULL,
+			davincifb_device_get);
+	if (err < 0)
+		return err;
+
+	platform_set_drvdata(pdev, dm);
+
+	/* get the video mode from the encoder manager */
+	get_video_mode(dm->vpbe_dev, &dm->mode);
+
+	/* set the default Cb/Cr order */
+	dm->yc_pixfmt = PIXFMT_YCBCRI;
+
+	/* initialize OSD0 */
+	dm->win[WIN_OSD0].layer = WIN_OSD0;
+	dm->win[WIN_OSD0].dm = dm;
+	dm->win[WIN_OSD0].sdram_address = 0;
+	davincifb_get_default_win_config(&pdev->dev, &dm->win[WIN_OSD0],
+					 &lconfig, &fb_size, options);
+	err = davincifb_init_window(&pdev->dev, &dm->win[WIN_OSD0],
+				    &lconfig, fb_size, OSD0_FBNAME);
+	if (err)
+		goto osd0_out;
+
+	/* initialize VID0 */
+	dm->win[WIN_VID0].layer = WIN_VID0;
+	dm->win[WIN_VID0].dm = dm;
+	dm->win[WIN_VID0].sdram_address = 0;
+	if (!davincifb_get_default_win_config(&pdev->dev, &dm->win[WIN_VID0],
+					      &lconfig, &fb_size, options)) {
+		err = davincifb_init_window(&pdev->dev, &dm->win[WIN_VID0],
+					    &lconfig, fb_size, VID0_FBNAME);
+		if (err)
+			goto vid0_out;
+	}
+
+	/* initialize OSD1 */
+	dm->win[WIN_OSD1].layer = WIN_OSD1;
+	dm->win[WIN_OSD1].dm = dm;
+	dm->win[WIN_OSD1].sdram_address = 0;
+	davincifb_get_default_win_config(&pdev->dev, &dm->win[WIN_OSD1],
+					 &lconfig, &fb_size, options);
+	err =
+	    davincifb_init_window(&pdev->dev, &dm->win[WIN_OSD1],
+				  &lconfig, fb_size, OSD1_FBNAME);
+	if (err)
+		goto osd1_out;
+
+	/* initialize VID1 */
+	dm->win[WIN_VID1].layer = WIN_VID1;
+	dm->win[WIN_VID1].dm = dm;
+	dm->win[WIN_VID1].sdram_address = 0;
+	if (!davincifb_get_default_win_config(&pdev->dev, &dm->win[WIN_VID1],
+					      &lconfig, &fb_size, options)) {
+		err = davincifb_init_window(&pdev->dev, &dm->win[WIN_VID1],
+					    &lconfig, fb_size, VID1_FBNAME);
+		if (err)
+			goto vid1_out;
+	}
+
+	/* initialize the vsync wait queue */
+	init_waitqueue_head(&dm->vsync_wait);
+	dm->timeout = HZ / 5;
+
+	/* register the end-of-frame callback */
+	dm->vsync_callback.mask = VENC_FIRST_FIELD |
+	    VENC_SECOND_FIELD | VENC_END_OF_FRAME;
+
+	dm->vsync_callback.handler = davincifb_vsync_callback;
+	dm->vsync_callback.arg = dm;
+
+	v4l2_subdev_call(dm->vpbe_dev->venc, core, ioctl,
+			 VENC_REG_CALLBACK, &dm->vsync_callback);
+
+	dev_info(&pdev->dev, "Davinci VPBE FB Driver probe success\n");
+
+	return 0;
+
+vid1_out:
+	davincifb_release_window(&pdev->dev, &dm->win[WIN_OSD1]);
+osd1_out:
+	davincifb_release_window(&pdev->dev, &dm->win[WIN_VID0]);
+vid0_out:
+	davincifb_release_window(&pdev->dev, &dm->win[WIN_OSD0]);
+osd0_out:
+	kfree(dm);
+
+	return err;
+}
+
+static struct platform_driver davincifb_driver = {
+	.driver = {
+		.name = "davinci-vpbe-fb",
+		.owner = THIS_MODULE,
+		.bus = &platform_bus_type,
+	},
+	.probe = davincifb_probe,
+	.remove = davincifb_remove,
+};
+
+
+static int __init davincifb_init(void)
+{
+#ifndef MODULE
+	{
+		char *names[] = { "vpbe_fb", "dm64xxfb", "dm355fb" };
+		int i, num_names = 3;
+
+		for (i = 0; i < num_names; i++) {
+			if (fb_get_options(names[i], &options)) {
+				pr_err("Disabled on command-line.\n");
+				return -ENODEV;
+			}
+			if (options)
+				break;
+		}
+	}
+#endif
+	/* Register the driver with LDM */
+	if (platform_driver_register(&davincifb_driver)) {
+		pr_err("failed to register vpbe_fb driver\n");
+		return -ENODEV;
+	}
+	return 0;
+}
+
+static void __exit davincifb_cleanup(void)
+{
+	platform_driver_unregister(&davincifb_driver);
+}
+
+late_initcall(davincifb_init);
+module_exit(davincifb_cleanup);
+
+MODULE_DESCRIPTION("TI VPBE Framebuffer driver");
+MODULE_AUTHOR("Texas Instruments Ltd");
+MODULE_LICENSE("GPL");
diff --git a/drivers/video/davincifb.h b/drivers/video/davincifb.h
new file mode 100644
index 0000000..8166b9d9
--- /dev/null
+++ b/drivers/video/davincifb.h
@@ -0,0 +1,194 @@
+/*
+ * Copyright (C) 2009 MontaVista Software Inc.
+ * Copyright (C) 2013 Texas Instruments Inc
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option)any later version.
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
+#ifndef DAVINCIFB_H
+#define DAVINCIFB_H
+
+/* There are 4 framebuffer devices, one per window. */
+#define OSD0_FBNAME "dm_osd0_fb"
+#define OSD1_FBNAME "dm_osd1_fb"
+#define VID0_FBNAME "dm_vid0_fb"
+#define VID1_FBNAME "dm_vid1_fb"
+
+/*  Structure for each window */
+struct vpbe_dm_win_info {
+	struct fb_info *info;
+	struct vpbe_dm_info *dm;
+	enum osd_layer layer;
+	unsigned xpos;
+	unsigned ypos;
+	unsigned own_window; /* Does the framebuffer driver own this window? */
+	unsigned display_window;
+	unsigned sdram_address;
+	unsigned int pseudo_palette[16];
+};
+
+/*
+ * Structure for the driver holding information of windows,
+ *  memory base addresses etc.
+ */
+struct vpbe_dm_info {
+	struct vpbe_dm_win_info win[4];
+
+	wait_queue_head_t vsync_wait;
+	unsigned int vsync_cnt;
+	int timeout;
+	struct venc_callback vsync_callback;
+
+	unsigned char ram_clut[256][3];
+	enum osd_pix_format yc_pixfmt;
+
+	struct fb_videomode mode;
+	struct vpbe_device *vpbe_dev;
+};
+
+struct zoom_params {
+	u_int32_t window_id;
+	u_int32_t zoom_h;
+	u_int32_t zoom_v;
+};
+
+/* Structure for transparency and the blending factor for the bitmap window */
+struct vpbe_bitmap_blend_params {
+	unsigned int colorkey;	/* color key to be blended */
+	unsigned int enable_colorkeying;	/* enable color keying */
+	unsigned int bf;	/* valid range from 0 to 7 only. */
+};
+
+/*  Structure for window expansion  */
+struct vpbe_win_expansion {
+	unsigned char horizontal;
+	unsigned char  vertical;	/* 1: Enable 0:disable */
+};
+
+/*  Structure for OSD window blinking options */
+struct vpbe_blink_option {
+	unsigned char blinking;	/* 1: Enable blinking 0: Disable */
+	unsigned int interval;	/* Valid only if blinking is 1 */
+};
+
+/*  Structure for background color  */
+struct vpbe_backg_color {
+	/* 2: RAM CLUT 1:ROM1 CLUT 0:ROM0 CLUT */
+	unsigned char clut_select;
+	unsigned char color_offset;	/* index of color */
+};
+
+/*  Structure for Video window configurable parameters  */
+struct vpbe_video_config_params {
+	/* Cb/Cr order in input data for a pixel. */
+	unsigned char cb_cr_order;	/*    0: cb cr  1:  cr cb */
+	/* HZ/VT Expansion enable disable */
+	struct vpbe_win_expansion exp_info;
+};
+
+/*
+ * Union of structures giving the CLUT index for the 1, 2, 4 bit bitmap values
+ */
+union vpbe_clut_idx {
+	struct _for_4bit_bitmap {
+		unsigned char bitmap_val_0;
+		unsigned char bitmap_val_1;
+		unsigned char bitmap_val_2;
+		unsigned char bitmap_val_3;
+		unsigned char bitmap_val_4;
+		unsigned char bitmap_val_5;
+		unsigned char bitmap_val_6;
+		unsigned char bitmap_val_7;
+		unsigned char bitmap_val_8;
+		unsigned char bitmap_val_9;
+		unsigned char bitmap_val_10;
+		unsigned char bitmap_val_11;
+		unsigned char bitmap_val_12;
+		unsigned char bitmap_val_13;
+		unsigned char bitmap_val_14;
+		unsigned char bitmap_val_15;
+	} for_4bit_bitmap;
+	struct _for_2bit_bitmap {
+		unsigned char bitmap_val_0;
+		unsigned char dummy0[4];
+		unsigned char bitmap_val_1;
+		unsigned char dummy1[4];
+		unsigned char bitmap_val_2;
+		unsigned char dummy2[4];
+		unsigned char bitmap_val_3;
+	} for_2bit_bitmap;
+	struct _for_1bit_bitmap {
+		unsigned char bitmap_val_0;
+		unsigned char dummy0[14];
+		unsigned char bitmap_val_1;
+	} for_1bit_bitmap;
+};
+
+/* Structure for bitmap window configurable parameters */
+struct vpbe_bitmap_config_params {
+	/* Only for bitmap width = 1,2,4 bits */
+	union vpbe_clut_idx clut_idx;
+	/* Attenuation value for YUV o/p for bitmap window */
+	unsigned char attenuation_enable;
+	/* 0: ROM DM270, 1:ROM DM320, 2:RAM CLUT */
+	unsigned char clut_select;
+};
+
+/* Structure to hold window position */
+struct vpbe_window_position {
+	unsigned int xpos;	/* X position of the window */
+	unsigned int ypos;	/* Y position of the window */
+};
+
+#define	RAM_CLUT_SIZE	(256*3)
+
+#define FBIO_SETATTRIBUTE	_IOW('F', 0x21, struct fb_fillrect)
+#define FBIO_SETPOSX		_IOW('F', 0x22, u_int32_t)
+#define FBIO_SETPOSY		_IOW('F', 0x23, u_int32_t)
+#define FBIO_SETZOOM		_IOW('F', 0x24, struct zoom_params)
+#define FBIO_ENABLE_DISABLE_WIN		\
+	_IOW('F', 0x30, unsigned char)
+#define FBIO_SET_BITMAP_BLEND_FACTOR	\
+	_IOW('F', 0x31, struct vpbe_bitmap_blend_params)
+#define FBIO_SET_BITMAP_WIN_RAM_CLUT	\
+	_IOW('F', 0x32, unsigned char[RAM_CLUT_SIZE])
+#define FBIO_ENABLE_DISABLE_ATTRIBUTE_WIN \
+	_IOW('F', 0x33, unsigned int)
+#define FBIO_GET_BLINK_INTERVAL		\
+	_IOR('F', 0x34, struct vpbe_blink_option)
+#define FBIO_SET_BLINK_INTERVAL		\
+	_IOW('F', 0x35, struct vpbe_blink_option)
+#define FBIO_GET_VIDEO_CONFIG_PARAMS	\
+	_IOR('F', 0x36, struct vpbe_video_config_params)
+#define FBIO_SET_VIDEO_CONFIG_PARAMS	\
+	_IOW('F', 0x37, struct vpbe_video_config_params)
+#define FBIO_GET_BITMAP_CONFIG_PARAMS	\
+	_IOR('F', 0x38, struct vpbe_bitmap_config_params)
+#define FBIO_SET_BITMAP_CONFIG_PARAMS	\
+	_IOW('F', 0x39, struct vpbe_bitmap_config_params)
+#define FBIO_SET_BACKG_COLOR		\
+	_IOW('F', 0x47, struct vpbe_backg_color)
+#define FBIO_SETPOS			\
+	_IOW('F', 0x49, u_int32_t)
+#define FBIO_SET_CURSOR			\
+	_IOW('F', 0x50, struct fb_cursor)
+
+/*  Window ID definitions */
+#define OSD0 0
+#define VID0 1
+#define OSD1 2
+#define VID1 3
+
+#endif		/* DAVINCIFB_H */
-- 
1.7.4.1

