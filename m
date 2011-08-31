Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60206 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab1HaLR5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Aug 2011 07:17:57 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-fbdev@vger.kernel.org
Cc: linux-media@vger.kernel.org, magnus.damm@gmail.com
Subject: [PATCH v3 3/3] fbdev: sh_mobile_lcdc: Support FOURCC-based format API
Date: Wed, 31 Aug 2011 13:18:21 +0200
Message-Id: <1314789501-824-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1314789501-824-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1314789501-824-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 arch/arm/mach-shmobile/board-ag5evm.c   |    2 +-
 arch/arm/mach-shmobile/board-ap4evb.c   |    4 +-
 arch/arm/mach-shmobile/board-mackerel.c |    4 +-
 arch/sh/boards/mach-ap325rxa/setup.c    |    2 +-
 arch/sh/boards/mach-ecovec24/setup.c    |    2 +-
 arch/sh/boards/mach-kfr2r09/setup.c     |    2 +-
 arch/sh/boards/mach-migor/setup.c       |    4 +-
 arch/sh/boards/mach-se/7724/setup.c     |    2 +-
 drivers/video/sh_mobile_lcdcfb.c        |  362 +++++++++++++++++++++----------
 include/video/sh_mobile_lcdc.h          |    4 +-
 10 files changed, 255 insertions(+), 133 deletions(-)

diff --git a/arch/arm/mach-shmobile/board-ag5evm.c b/arch/arm/mach-shmobile/board-ag5evm.c
index ce5c251..e6dabaa 100644
--- a/arch/arm/mach-shmobile/board-ag5evm.c
+++ b/arch/arm/mach-shmobile/board-ag5evm.c
@@ -270,7 +270,7 @@ static struct sh_mobile_lcdc_info lcdc0_info = {
 		.flags = LCDC_FLAGS_DWPOL,
 		.lcd_size_cfg.width = 44,
 		.lcd_size_cfg.height = 79,
-		.bpp = 16,
+		.fourcc = V4L2_PIX_FMT_RGB565,
 		.lcd_cfg = lcdc0_modes,
 		.num_cfg = ARRAY_SIZE(lcdc0_modes),
 		.board_cfg = {
diff --git a/arch/arm/mach-shmobile/board-ap4evb.c b/arch/arm/mach-shmobile/board-ap4evb.c
index 9e0856b..6f5db07 100644
--- a/arch/arm/mach-shmobile/board-ap4evb.c
+++ b/arch/arm/mach-shmobile/board-ap4evb.c
@@ -489,7 +489,7 @@ static struct sh_mobile_lcdc_info lcdc_info = {
 	.meram_dev = &meram_info,
 	.ch[0] = {
 		.chan = LCDC_CHAN_MAINLCD,
-		.bpp = 16,
+		.fourcc = V4L2_PIX_FMT_RGB565,
 		.lcd_cfg = ap4evb_lcdc_modes,
 		.num_cfg = ARRAY_SIZE(ap4evb_lcdc_modes),
 		.meram_cfg = &lcd_meram_cfg,
@@ -783,7 +783,7 @@ static struct sh_mobile_lcdc_info sh_mobile_lcdc1_info = {
 	.meram_dev = &meram_info,
 	.ch[0] = {
 		.chan = LCDC_CHAN_MAINLCD,
-		.bpp = 16,
+		.fourcc = V4L2_PIX_FMT_RGB565,
 		.interface_type = RGB24,
 		.clock_divider = 1,
 		.flags = LCDC_FLAGS_DWPOL,
diff --git a/arch/arm/mach-shmobile/board-mackerel.c b/arch/arm/mach-shmobile/board-mackerel.c
index 6e3c2df..6e36349 100644
--- a/arch/arm/mach-shmobile/board-mackerel.c
+++ b/arch/arm/mach-shmobile/board-mackerel.c
@@ -387,7 +387,7 @@ static struct sh_mobile_lcdc_info lcdc_info = {
 	.clock_source = LCDC_CLK_BUS,
 	.ch[0] = {
 		.chan = LCDC_CHAN_MAINLCD,
-		.bpp = 16,
+		.fourcc = V4L2_PIX_FMT_RGB565,
 		.lcd_cfg = mackerel_lcdc_modes,
 		.num_cfg = ARRAY_SIZE(mackerel_lcdc_modes),
 		.interface_type		= RGB24,
@@ -450,7 +450,7 @@ static struct sh_mobile_lcdc_info hdmi_lcdc_info = {
 	.clock_source = LCDC_CLK_EXTERNAL,
 	.ch[0] = {
 		.chan = LCDC_CHAN_MAINLCD,
-		.bpp = 16,
+		.fourcc = V4L2_PIX_FMT_RGB565,
 		.interface_type = RGB24,
 		.clock_divider = 1,
 		.flags = LCDC_FLAGS_DWPOL,
diff --git a/arch/sh/boards/mach-ap325rxa/setup.c b/arch/sh/boards/mach-ap325rxa/setup.c
index d362657..0a53ecd 100644
--- a/arch/sh/boards/mach-ap325rxa/setup.c
+++ b/arch/sh/boards/mach-ap325rxa/setup.c
@@ -207,7 +207,7 @@ static struct sh_mobile_lcdc_info lcdc_info = {
 	.clock_source = LCDC_CLK_EXTERNAL,
 	.ch[0] = {
 		.chan = LCDC_CHAN_MAINLCD,
-		.bpp = 16,
+		.fourcc = V4L2_PIX_FMT_RGB565,
 		.interface_type = RGB18,
 		.clock_divider = 1,
 		.lcd_cfg = ap325rxa_lcdc_modes,
diff --git a/arch/sh/boards/mach-ecovec24/setup.c b/arch/sh/boards/mach-ecovec24/setup.c
index b24d69d..75e466f 100644
--- a/arch/sh/boards/mach-ecovec24/setup.c
+++ b/arch/sh/boards/mach-ecovec24/setup.c
@@ -326,7 +326,7 @@ static struct sh_mobile_lcdc_info lcdc_info = {
 	.ch[0] = {
 		.interface_type = RGB18,
 		.chan = LCDC_CHAN_MAINLCD,
-		.bpp = 16,
+		.fourcc = V4L2_PIX_FMT_RGB565,
 		.lcd_size_cfg = { /* 7.0 inch */
 			.width = 152,
 			.height = 91,
diff --git a/arch/sh/boards/mach-kfr2r09/setup.c b/arch/sh/boards/mach-kfr2r09/setup.c
index f65271a..208c9b0 100644
--- a/arch/sh/boards/mach-kfr2r09/setup.c
+++ b/arch/sh/boards/mach-kfr2r09/setup.c
@@ -146,7 +146,7 @@ static struct sh_mobile_lcdc_info kfr2r09_sh_lcdc_info = {
 	.clock_source = LCDC_CLK_BUS,
 	.ch[0] = {
 		.chan = LCDC_CHAN_MAINLCD,
-		.bpp = 16,
+		.fourcc = V4L2_PIX_FMT_RGB565,
 		.interface_type = SYS18,
 		.clock_divider = 6,
 		.flags = LCDC_FLAGS_DWPOL,
diff --git a/arch/sh/boards/mach-migor/setup.c b/arch/sh/boards/mach-migor/setup.c
index 2d4c9c8..69f8d7d 100644
--- a/arch/sh/boards/mach-migor/setup.c
+++ b/arch/sh/boards/mach-migor/setup.c
@@ -244,7 +244,7 @@ static struct sh_mobile_lcdc_info sh_mobile_lcdc_info = {
 	.clock_source = LCDC_CLK_BUS,
 	.ch[0] = {
 		.chan = LCDC_CHAN_MAINLCD,
-		.bpp = 16,
+		.fourcc = V4L2_PIX_FMT_RGB565,
 		.interface_type = RGB16,
 		.clock_divider = 2,
 		.lcd_cfg = migor_lcd_modes,
@@ -258,7 +258,7 @@ static struct sh_mobile_lcdc_info sh_mobile_lcdc_info = {
 	.clock_source = LCDC_CLK_PERIPHERAL,
 	.ch[0] = {
 		.chan = LCDC_CHAN_MAINLCD,
-		.bpp = 16,
+		.fourcc = V4L2_PIX_FMT_RGB565,
 		.interface_type = SYS16A,
 		.clock_divider = 10,
 		.lcd_cfg = migor_lcd_modes,
diff --git a/arch/sh/boards/mach-se/7724/setup.c b/arch/sh/boards/mach-se/7724/setup.c
index d007567..ab81abd 100644
--- a/arch/sh/boards/mach-se/7724/setup.c
+++ b/arch/sh/boards/mach-se/7724/setup.c
@@ -179,7 +179,7 @@ static struct sh_mobile_lcdc_info lcdc_info = {
 	.clock_source = LCDC_CLK_EXTERNAL,
 	.ch[0] = {
 		.chan = LCDC_CHAN_MAINLCD,
-		.bpp = 16,
+		.fourcc = V4L2_PIX_FMT_RGB565,
 		.clock_divider = 1,
 		.lcd_size_cfg = { /* 7.0 inch */
 			.width = 152,
diff --git a/drivers/video/sh_mobile_lcdcfb.c b/drivers/video/sh_mobile_lcdcfb.c
index 97ab8ba..6e4c292 100644
--- a/drivers/video/sh_mobile_lcdcfb.c
+++ b/drivers/video/sh_mobile_lcdcfb.c
@@ -17,6 +17,7 @@
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
 #include <linux/interrupt.h>
+#include <linux/videodev2.h>
 #include <linux/vmalloc.h>
 #include <linux/ioctl.h>
 #include <linux/slab.h>
@@ -101,7 +102,7 @@ struct sh_mobile_lcdc_priv {
 	struct sh_mobile_lcdc_chan ch[2];
 	struct notifier_block notifier;
 	int started;
-	int forced_bpp; /* 2 channel LCDC must share bpp setting */
+	int forced_fourcc; /* 2 channel LCDC must share fourcc setting */
 	struct sh_mobile_meram_info *meram_dev;
 };
 
@@ -214,6 +215,42 @@ struct sh_mobile_lcdc_sys_bus_ops sh_mobile_lcdc_sys_bus_ops = {
 	lcdc_sys_read_data,
 };
 
+static int sh_mobile_format_fourcc(const struct fb_var_screeninfo *var)
+{
+	if (var->fourcc.fourcc > 1)
+		return var->fourcc.fourcc;
+
+	switch (var->bits_per_pixel) {
+	case 16:
+		return V4L2_PIX_FMT_RGB565;
+	case 24:
+		return V4L2_PIX_FMT_BGR24;
+	case 32:
+		return V4L2_PIX_FMT_BGR32;
+	default:
+		return 0;
+	}
+}
+
+static bool sh_mobile_format_yuv(const struct fb_var_screeninfo *var)
+{
+	if (var->fourcc.fourcc <= 1)
+		return false;
+
+	switch (var->fourcc.fourcc) {
+	case V4L2_PIX_FMT_NV12:
+	case V4L2_PIX_FMT_NV21:
+	case V4L2_PIX_FMT_NV16:
+	case V4L2_PIX_FMT_NV61:
+	case V4L2_PIX_FMT_NV24:
+	case V4L2_PIX_FMT_NV42:
+		return true;
+
+	default:
+		return false;
+	}
+}
+
 static void sh_mobile_lcdc_clk_on(struct sh_mobile_lcdc_priv *priv)
 {
 	if (atomic_inc_and_test(&priv->hw_usecnt)) {
@@ -434,7 +471,6 @@ static void __sh_mobile_lcdc_start(struct sh_mobile_lcdc_priv *priv)
 {
 	struct sh_mobile_lcdc_chan *ch;
 	unsigned long tmp;
-	int bpp = 0;
 	int k, m;
 
 	/* Enable LCDC channels. Read data from external memory, avoid using the
@@ -453,9 +489,6 @@ static void __sh_mobile_lcdc_start(struct sh_mobile_lcdc_priv *priv)
 		if (!ch->enabled)
 			continue;
 
-		if (!bpp)
-			bpp = ch->info->var.bits_per_pixel;
-
 		/* Power supply */
 		lcdc_write_chan(ch, LDPMR, 0);
 
@@ -486,31 +519,37 @@ static void __sh_mobile_lcdc_start(struct sh_mobile_lcdc_priv *priv)
 
 		sh_mobile_lcdc_geometry(ch);
 
-		if (ch->info->var.nonstd) {
-			tmp = (ch->info->var.nonstd << 16);
-			switch (ch->info->var.bits_per_pixel) {
-			case 12:
-				tmp |= LDDFR_YF_420;
-				break;
-			case 16:
-				tmp |= LDDFR_YF_422;
-				break;
-			case 24:
-			default:
-				tmp |= LDDFR_YF_444;
-				break;
-			}
-		} else {
-			switch (ch->info->var.bits_per_pixel) {
-			case 16:
-				tmp = LDDFR_PKF_RGB16;
-				break;
-			case 24:
-				tmp = LDDFR_PKF_RGB24;
+		switch (sh_mobile_format_fourcc(&ch->info->var)) {
+		case V4L2_PIX_FMT_RGB565:
+			tmp = LDDFR_PKF_RGB16;
+			break;
+		case V4L2_PIX_FMT_BGR24:
+			tmp = LDDFR_PKF_RGB24;
+			break;
+		case V4L2_PIX_FMT_BGR32:
+			tmp = LDDFR_PKF_ARGB32;
+			break;
+		case V4L2_PIX_FMT_NV12:
+		case V4L2_PIX_FMT_NV21:
+			tmp = LDDFR_CC | LDDFR_YF_420;
+			break;
+		case V4L2_PIX_FMT_NV16:
+		case V4L2_PIX_FMT_NV61:
+			tmp = LDDFR_CC | LDDFR_YF_422;
+			break;
+		case V4L2_PIX_FMT_NV24:
+		case V4L2_PIX_FMT_NV42:
+			tmp = LDDFR_CC | LDDFR_YF_444;
+			break;
+		}
+
+		if (sh_mobile_format_yuv(&ch->info->var)) {
+			switch (ch->info->var.fourcc.colorspace) {
+			case V4L2_COLORSPACE_REC709:
+				tmp |= LDDFR_CF1;
 				break;
-			case 32:
-			default:
-				tmp = LDDFR_PKF_ARGB32;
+			case V4L2_COLORSPACE_JPEG:
+				tmp |= LDDFR_CF0;
 				break;
 			}
 		}
@@ -518,7 +557,7 @@ static void __sh_mobile_lcdc_start(struct sh_mobile_lcdc_priv *priv)
 		lcdc_write_chan(ch, LDDFR, tmp);
 		lcdc_write_chan(ch, LDMLSR, ch->pitch);
 		lcdc_write_chan(ch, LDSA1R, ch->base_addr_y);
-		if (ch->info->var.nonstd)
+		if (sh_mobile_format_yuv(&ch->info->var))
 			lcdc_write_chan(ch, LDSA2R, ch->base_addr_c);
 
 		/* When using deferred I/O mode, configure the LCDC for one-shot
@@ -535,21 +574,23 @@ static void __sh_mobile_lcdc_start(struct sh_mobile_lcdc_priv *priv)
 	}
 
 	/* Word and long word swap. */
-	if  (priv->ch[0].info->var.nonstd)
+	switch (sh_mobile_format_fourcc(&priv->ch[0].info->var)) {
+	case V4L2_PIX_FMT_RGB565:
+	case V4L2_PIX_FMT_NV21:
+	case V4L2_PIX_FMT_NV61:
+	case V4L2_PIX_FMT_NV42:
+		tmp = LDDDSR_LS | LDDDSR_WS;
+		break;
+	case V4L2_PIX_FMT_BGR24:
+	case V4L2_PIX_FMT_NV12:
+	case V4L2_PIX_FMT_NV16:
+	case V4L2_PIX_FMT_NV24:
 		tmp = LDDDSR_LS | LDDDSR_WS | LDDDSR_BS;
-	else {
-		switch (bpp) {
-		case 16:
-			tmp = LDDDSR_LS | LDDDSR_WS;
-			break;
-		case 24:
-			tmp = LDDDSR_LS | LDDDSR_WS | LDDDSR_BS;
-			break;
-		case 32:
-		default:
-			tmp = LDDDSR_LS;
-			break;
-		}
+		break;
+	case V4L2_PIX_FMT_BGR32:
+	default:
+		tmp = LDDDSR_LS;
+		break;
 	}
 	lcdc_write(priv, _LDDDSR, tmp);
 
@@ -621,12 +662,24 @@ static int sh_mobile_lcdc_start(struct sh_mobile_lcdc_priv *priv)
 			ch->meram_enabled = 0;
 		}
 
-		if (!ch->info->var.nonstd)
-			pixelformat = SH_MOBILE_MERAM_PF_RGB;
-		else if (ch->info->var.bits_per_pixel == 24)
-			pixelformat = SH_MOBILE_MERAM_PF_NV24;
-		else
+		switch (sh_mobile_format_fourcc(&ch->info->var)) {
+		case V4L2_PIX_FMT_NV12:
+		case V4L2_PIX_FMT_NV21:
+		case V4L2_PIX_FMT_NV16:
+		case V4L2_PIX_FMT_NV61:
 			pixelformat = SH_MOBILE_MERAM_PF_NV;
+			break;
+		case V4L2_PIX_FMT_NV24:
+		case V4L2_PIX_FMT_NV42:
+			pixelformat = SH_MOBILE_MERAM_PF_NV24;
+			break;
+		case V4L2_PIX_FMT_RGB565:
+		case V4L2_PIX_FMT_BGR24:
+		case V4L2_PIX_FMT_BGR32:
+		default:
+			pixelformat = SH_MOBILE_MERAM_PF_RGB;
+			break;
+		}
 
 		ret = mdev->ops->meram_register(mdev, cfg, ch->pitch,
 					ch->info->var.yres, pixelformat,
@@ -844,6 +897,7 @@ static struct fb_fix_screeninfo sh_mobile_lcdc_fix  = {
 	.xpanstep =	0,
 	.ypanstep =	1,
 	.ywrapstep =	0,
+	.capabilities =	FB_CAP_FOURCC,
 };
 
 static void sh_mobile_lcdc_fillrect(struct fb_info *info,
@@ -876,8 +930,9 @@ static int sh_mobile_fb_pan_display(struct fb_var_screeninfo *var,
 	unsigned long new_pan_offset;
 	unsigned long base_addr_y, base_addr_c;
 	unsigned long c_offset;
+	bool yuv = sh_mobile_format_yuv(&info->var);
 
-	if (!info->var.nonstd)
+	if (!yuv)
 		new_pan_offset = var->yoffset * info->fix.line_length
 			       + var->xoffset * (info->var.bits_per_pixel / 8);
 	else
@@ -891,7 +946,7 @@ static int sh_mobile_fb_pan_display(struct fb_var_screeninfo *var,
 
 	/* Set the source address for the next refresh */
 	base_addr_y = ch->dma_handle + new_pan_offset;
-	if (info->var.nonstd) {
+	if (yuv) {
 		/* Set y offset */
 		c_offset = var->yoffset * info->fix.line_length
 			 * (info->var.bits_per_pixel - 8) / 8;
@@ -899,7 +954,7 @@ static int sh_mobile_fb_pan_display(struct fb_var_screeninfo *var,
 			    + info->var.xres * info->var.yres_virtual
 			    + c_offset;
 		/* Set x offset */
-		if (info->var.bits_per_pixel == 24)
+		if (sh_mobile_format_fourcc(&info->var) == V4L2_PIX_FMT_NV24)
 			base_addr_c += 2 * var->xoffset;
 		else
 			base_addr_c += var->xoffset;
@@ -923,7 +978,7 @@ static int sh_mobile_fb_pan_display(struct fb_var_screeninfo *var,
 	ch->base_addr_c = base_addr_c;
 
 	lcdc_write_chan_mirror(ch, LDSA1R, base_addr_y);
-	if (info->var.nonstd)
+	if (yuv)
 		lcdc_write_chan_mirror(ch, LDSA2R, base_addr_c);
 
 	if (lcdc_chan_is_sublcd(ch))
@@ -1099,51 +1154,91 @@ static int sh_mobile_check_var(struct fb_var_screeninfo *var, struct fb_info *in
 	if (var->yres_virtual < var->yres)
 		var->yres_virtual = var->yres;
 
-	if (var->bits_per_pixel <= 16) {		/* RGB 565 */
-		var->bits_per_pixel = 16;
-		var->red.offset = 11;
-		var->red.length = 5;
-		var->green.offset = 5;
-		var->green.length = 6;
-		var->blue.offset = 0;
-		var->blue.length = 5;
-		var->transp.offset = 0;
-		var->transp.length = 0;
-	} else if (var->bits_per_pixel <= 24) {		/* RGB 888 */
-		var->bits_per_pixel = 24;
-		var->red.offset = 16;
-		var->red.length = 8;
-		var->green.offset = 8;
-		var->green.length = 8;
-		var->blue.offset = 0;
-		var->blue.length = 8;
-		var->transp.offset = 0;
-		var->transp.length = 0;
-	} else if (var->bits_per_pixel <= 32) {		/* RGBA 888 */
-		var->bits_per_pixel = 32;
-		var->red.offset = 16;
-		var->red.length = 8;
-		var->green.offset = 8;
-		var->green.length = 8;
-		var->blue.offset = 0;
-		var->blue.length = 8;
-		var->transp.offset = 24;
-		var->transp.length = 8;
-	} else
-		return -EINVAL;
+	if (var->fourcc.fourcc > 1) {
+		unsigned int fourcc = var->fourcc.fourcc;
+		unsigned int colorspace = var->fourcc.colorspace;
+
+		memset(&var->fourcc, 0, sizeof(var->fourcc));
+		var->fourcc.fourcc = fourcc;
+		var->fourcc.colorspace = colorspace;
 
-	var->red.msb_right = 0;
-	var->green.msb_right = 0;
-	var->blue.msb_right = 0;
-	var->transp.msb_right = 0;
+		switch (var->fourcc.fourcc) {
+		case V4L2_PIX_FMT_NV12:
+		case V4L2_PIX_FMT_NV21:
+			var->bits_per_pixel = 12;
+			break;
+		case V4L2_PIX_FMT_RGB565:
+		case V4L2_PIX_FMT_NV16:
+		case V4L2_PIX_FMT_NV61:
+			var->bits_per_pixel = 16;
+			break;
+		case V4L2_PIX_FMT_BGR24:
+		case V4L2_PIX_FMT_NV24:
+		case V4L2_PIX_FMT_NV42:
+			var->bits_per_pixel = 24;
+			break;
+		case V4L2_PIX_FMT_BGR32:
+			var->bits_per_pixel = 32;
+			break;
+		default:
+			return -EINVAL;
+		}
+
+		/* Default to RGB and JPEG color-spaces for RGB and YUV formats
+		 * respectively.
+		 */
+		if (!sh_mobile_format_yuv(var))
+			var->fourcc.colorspace = V4L2_COLORSPACE_SRGB;
+		else if (var->fourcc.colorspace != V4L2_COLORSPACE_REC709)
+			var->fourcc.colorspace = V4L2_COLORSPACE_JPEG;
+	} else {
+		if (var->bits_per_pixel <= 16) {		/* RGB 565 */
+			var->bits_per_pixel = 16;
+			var->red.offset = 11;
+			var->red.length = 5;
+			var->green.offset = 5;
+			var->green.length = 6;
+			var->blue.offset = 0;
+			var->blue.length = 5;
+			var->transp.offset = 0;
+			var->transp.length = 0;
+		} else if (var->bits_per_pixel <= 24) {		/* RGB 888 */
+			var->bits_per_pixel = 24;
+			var->red.offset = 16;
+			var->red.length = 8;
+			var->green.offset = 8;
+			var->green.length = 8;
+			var->blue.offset = 0;
+			var->blue.length = 8;
+			var->transp.offset = 0;
+			var->transp.length = 0;
+		} else if (var->bits_per_pixel <= 32) {		/* RGBA 888 */
+			var->bits_per_pixel = 32;
+			var->red.offset = 16;
+			var->red.length = 8;
+			var->green.offset = 8;
+			var->green.length = 8;
+			var->blue.offset = 0;
+			var->blue.length = 8;
+			var->transp.offset = 24;
+			var->transp.length = 8;
+		} else
+			return -EINVAL;
+
+		var->red.msb_right = 0;
+		var->green.msb_right = 0;
+		var->blue.msb_right = 0;
+		var->transp.msb_right = 0;
+	}
 
 	/* Make sure we don't exceed our allocated memory. */
 	if (var->xres_virtual * var->yres_virtual * var->bits_per_pixel / 8 >
 	    info->fix.smem_len)
 		return -EINVAL;
 
-	/* only accept the forced_bpp for dual channel configurations */
-	if (p->forced_bpp && p->forced_bpp != var->bits_per_pixel)
+	/* only accept the forced_fourcc for dual channel configurations */
+	if (p->forced_fourcc &&
+	    p->forced_fourcc != sh_mobile_format_fourcc(var))
 		return -EINVAL;
 
 	return 0;
@@ -1157,7 +1252,7 @@ static int sh_mobile_set_par(struct fb_info *info)
 
 	sh_mobile_lcdc_stop(ch->lcdc);
 
-	if (info->var.nonstd)
+	if (sh_mobile_format_yuv(&info->var))
 		info->fix.line_length = info->var.xres;
 	else
 		info->fix.line_length = info->var.xres
@@ -1169,6 +1264,14 @@ static int sh_mobile_set_par(struct fb_info *info)
 		info->fix.line_length = line_length;
 	}
 
+	if (info->var.fourcc.fourcc > 1) {
+		info->fix.type = FB_TYPE_FOURCC;
+		info->fix.visual = FB_VISUAL_FOURCC;
+	} else {
+		info->fix.type = FB_TYPE_PACKED_PIXELS;
+		info->fix.visual = FB_VISUAL_TRUECOLOR;
+	}
+
 	return ret;
 }
 
@@ -1463,9 +1566,9 @@ static int __devinit sh_mobile_lcdc_channel_init(struct sh_mobile_lcdc_chan *ch,
 	for (i = 0, mode = cfg->lcd_cfg; i < cfg->num_cfg; i++, mode++) {
 		unsigned int size = mode->yres * mode->xres;
 
-		/* NV12 buffers must have even number of lines */
-		if ((cfg->nonstd) && cfg->bpp == 12 &&
-				(mode->yres & 0x1)) {
+		/* NV12/NV21 buffers must have even number of lines */
+		if ((cfg->fourcc == V4L2_PIX_FMT_NV12 ||
+		     cfg->fourcc == V4L2_PIX_FMT_NV21) && (mode->yres & 0x1)) {
 			dev_err(dev, "yres must be multiple of 2 for YCbCr420 "
 				"mode.\n");
 			return -EINVAL;
@@ -1483,14 +1586,6 @@ static int __devinit sh_mobile_lcdc_channel_init(struct sh_mobile_lcdc_chan *ch,
 		dev_dbg(dev, "Found largest videomode %ux%u\n",
 			max_mode->xres, max_mode->yres);
 
-	/* Initialize fixed screen information. Restrict pan to 2 lines steps
-	 * for NV12.
-	 */
-	info->fix = sh_mobile_lcdc_fix;
-	info->fix.smem_len = max_size * 2 * cfg->bpp / 8;
-	if (cfg->nonstd && cfg->bpp == 12)
-		info->fix.ypanstep = 2;
-
 	/* Create the mode list. */
 	if (cfg->lcd_cfg == NULL) {
 		mode = &default_720p;
@@ -1508,19 +1603,38 @@ static int __devinit sh_mobile_lcdc_channel_init(struct sh_mobile_lcdc_chan *ch,
 	 */
 	var = &info->var;
 	fb_videomode_to_var(var, mode);
-	var->bits_per_pixel = cfg->bpp;
 	var->width = cfg->lcd_size_cfg.width;
 	var->height = cfg->lcd_size_cfg.height;
 	var->yres_virtual = var->yres * 2;
 	var->activate = FB_ACTIVATE_NOW;
 
+	switch (cfg->fourcc) {
+	case V4L2_PIX_FMT_RGB565:
+		var->bits_per_pixel = 16;
+		break;
+	case V4L2_PIX_FMT_BGR24:
+		var->bits_per_pixel = 24;
+		break;
+	case V4L2_PIX_FMT_BGR32:
+		var->bits_per_pixel = 32;
+		break;
+	default:
+		var->fourcc.fourcc = cfg->fourcc;
+		break;
+	}
+
+	/* Make sure the memory size check won't fail. smem_len is initialized
+	 * later based on var.
+	 */
+	info->fix.smem_len = UINT_MAX;
 	ret = sh_mobile_check_var(var, info);
 	if (ret)
 		return ret;
 
+	max_size = max_size * var->bits_per_pixel / 8 * 2;
+
 	/* Allocate frame buffer memory and color map. */
-	buf = dma_alloc_coherent(dev, info->fix.smem_len, &ch->dma_handle,
-				 GFP_KERNEL);
+	buf = dma_alloc_coherent(dev, max_size, &ch->dma_handle, GFP_KERNEL);
 	if (!buf) {
 		dev_err(dev, "unable to allocate buffer\n");
 		return -ENOMEM;
@@ -1529,16 +1643,27 @@ static int __devinit sh_mobile_lcdc_channel_init(struct sh_mobile_lcdc_chan *ch,
 	ret = fb_alloc_cmap(&info->cmap, PALETTE_NR, 0);
 	if (ret < 0) {
 		dev_err(dev, "unable to allocate cmap\n");
-		dma_free_coherent(dev, info->fix.smem_len,
-				  buf, ch->dma_handle);
+		dma_free_coherent(dev, max_size, buf, ch->dma_handle);
 		return ret;
 	}
 
+	/* Initialize fixed screen information. Restrict pan to 2 lines steps
+	 * for NV12 and NV21.
+	 */
+	info->fix = sh_mobile_lcdc_fix;
 	info->fix.smem_start = ch->dma_handle;
-	if (var->nonstd)
+	info->fix.smem_len = max_size;
+	if (cfg->fourcc == V4L2_PIX_FMT_NV12 ||
+	    cfg->fourcc == V4L2_PIX_FMT_NV21)
+		info->fix.ypanstep = 2;
+
+	if (sh_mobile_format_yuv(var)) {
 		info->fix.line_length = var->xres;
-	else
-		info->fix.line_length = var->xres * (cfg->bpp / 8);
+		info->fix.visual = FB_VISUAL_FOURCC;
+	} else {
+		info->fix.line_length = var->xres * var->bits_per_pixel / 8;
+		info->fix.visual = FB_VISUAL_TRUECOLOR;
+	}
 
 	info->screen_base = buf;
 	info->device = dev;
@@ -1625,9 +1750,9 @@ static int __devinit sh_mobile_lcdc_probe(struct platform_device *pdev)
 		goto err1;
 	}
 
-	/* for dual channel LCDC (MAIN + SUB) force shared bpp setting */
+	/* for dual channel LCDC (MAIN + SUB) force shared format setting */
 	if (num_channels == 2)
-		priv->forced_bpp = pdata->ch[0].bpp;
+		priv->forced_fourcc = pdata->ch[0].fourcc;
 
 	priv->base = ioremap_nocache(res->start, resource_size(res));
 	if (!priv->base)
@@ -1674,13 +1799,10 @@ static int __devinit sh_mobile_lcdc_probe(struct platform_device *pdev)
 		if (error < 0)
 			goto err1;
 
-		dev_info(info->dev,
-			 "registered %s/%s as %dx%d %dbpp.\n",
-			 pdev->name,
-			 (ch->cfg.chan == LCDC_CHAN_MAINLCD) ?
-			 "mainlcd" : "sublcd",
-			 info->var.xres, info->var.yres,
-			 ch->cfg.bpp);
+		dev_info(info->dev, "registered %s/%s as %dx%d %dbpp.\n",
+			 pdev->name, (ch->cfg.chan == LCDC_CHAN_MAINLCD) ?
+			 "mainlcd" : "sublcd", info->var.xres, info->var.yres,
+			 info->var.bits_per_pixel);
 
 		/* deferred io mode: disable clock to save power */
 		if (info->fbdefio || info->state == FBINFO_STATE_SUSPENDED)
diff --git a/include/video/sh_mobile_lcdc.h b/include/video/sh_mobile_lcdc.h
index 8101b72..fe30b75 100644
--- a/include/video/sh_mobile_lcdc.h
+++ b/include/video/sh_mobile_lcdc.h
@@ -174,7 +174,8 @@ struct sh_mobile_lcdc_bl_info {
 
 struct sh_mobile_lcdc_chan_cfg {
 	int chan;
-	int bpp;
+	int fourcc;
+	int colorspace;
 	int interface_type; /* selects RGBn or SYSn I/F, see above */
 	int clock_divider;
 	unsigned long flags; /* LCDC_FLAGS_... */
@@ -184,7 +185,6 @@ struct sh_mobile_lcdc_chan_cfg {
 	struct sh_mobile_lcdc_board_cfg board_cfg;
 	struct sh_mobile_lcdc_bl_info bl_info;
 	struct sh_mobile_lcdc_sys_bus_cfg sys_bus_cfg; /* only for SYSn I/F */
-	int nonstd;
 	struct sh_mobile_meram_cfg *meram_cfg;
 };
 
-- 
1.7.3.4

