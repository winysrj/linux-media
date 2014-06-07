Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:48072 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbaFGV5X (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jun 2014 17:57:23 -0400
Received: by mail-pb0-f44.google.com with SMTP id rq2so3913284pbb.17
        for <linux-media@vger.kernel.org>; Sat, 07 Jun 2014 14:57:23 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
	Drew Moseley <drew_moseley@mentor.com>
Subject: [PATCH 22/43] imx-drm: ipu-v3: Add ipu-cpmem unit
Date: Sat,  7 Jun 2014 14:56:24 -0700
Message-Id: <1402178205-22697-23-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move channel parameter memory setup functions and macros into a new
submodule ipu-cpmem. In the process, cleanup arguments to the functions
to take a channel pointer instead of a pointer into cpmem for that
channel. That allows the structure of the parameter memory to be
private to ipu-cpmem.c.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
Signed-off-by: Drew Moseley <drew_moseley@mentor.com>
---
 drivers/staging/imx-drm/ipu-v3/Makefile     |    2 +-
 drivers/staging/imx-drm/ipu-v3/ipu-common.c |  457 +-------------------
 drivers/staging/imx-drm/ipu-v3/ipu-cpmem.c  |  595 +++++++++++++++++++++++++++
 drivers/staging/imx-drm/ipu-v3/ipu-prv.h    |   14 +-
 drivers/staging/imx-drm/ipuv3-plane.c       |   16 +-
 include/linux/platform_data/imx-ipu-v3.h    |  190 ++-------
 6 files changed, 662 insertions(+), 612 deletions(-)
 create mode 100644 drivers/staging/imx-drm/ipu-v3/ipu-cpmem.c

diff --git a/drivers/staging/imx-drm/ipu-v3/Makefile b/drivers/staging/imx-drm/ipu-v3/Makefile
index 79c0c88..147a1b7 100644
--- a/drivers/staging/imx-drm/ipu-v3/Makefile
+++ b/drivers/staging/imx-drm/ipu-v3/Makefile
@@ -1,4 +1,4 @@
 obj-$(CONFIG_DRM_IMX_IPUV3_CORE) += imx-ipu-v3.o
 
-imx-ipu-v3-objs := ipu-common.o ipu-csi.o ipu-dc.o ipu-di.o \
+imx-ipu-v3-objs := ipu-common.o ipu-cpmem.o ipu-csi.o ipu-dc.o ipu-di.o \
 	ipu-dp.o ipu-dmfc.o ipu-ic.o ipu-irt.o ipu-smfc.o
diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-common.c b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
index 8a03ad2..b9d759d 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-common.c
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
@@ -44,17 +44,6 @@ static inline void ipu_cm_write(struct ipu_soc *ipu, u32 value, unsigned offset)
 	writel(value, ipu->cm_reg + offset);
 }
 
-static inline u32 ipu_idmac_read(struct ipu_soc *ipu, unsigned offset)
-{
-	return readl(ipu->idmac_reg + offset);
-}
-
-static inline void ipu_idmac_write(struct ipu_soc *ipu, u32 value,
-		unsigned offset)
-{
-	writel(value, ipu->idmac_reg + offset);
-}
-
 int ipu_get_num(struct ipu_soc *ipu)
 {
 	return ipu->id;
@@ -71,379 +60,6 @@ void ipu_srm_dp_sync_update(struct ipu_soc *ipu)
 }
 EXPORT_SYMBOL_GPL(ipu_srm_dp_sync_update);
 
-struct ipu_ch_param __iomem *ipu_get_cpmem(struct ipuv3_channel *channel)
-{
-	struct ipu_soc *ipu = channel->ipu;
-
-	return ipu->cpmem_base + channel->num;
-}
-EXPORT_SYMBOL_GPL(ipu_get_cpmem);
-
-void ipu_cpmem_set_high_priority(struct ipuv3_channel *channel)
-{
-	struct ipu_soc *ipu = channel->ipu;
-	struct ipu_ch_param __iomem *p = ipu_get_cpmem(channel);
-	u32 val;
-
-	if (ipu->ipu_type == IPUV3EX)
-		ipu_ch_param_write_field(p, IPU_FIELD_ID, 1);
-
-	val = ipu_idmac_read(ipu, IDMAC_CHA_PRI(channel->num));
-	val |= 1 << (channel->num % 32);
-	ipu_idmac_write(ipu, val, IDMAC_CHA_PRI(channel->num));
-};
-EXPORT_SYMBOL_GPL(ipu_cpmem_set_high_priority);
-
-void ipu_ch_param_write_field(struct ipu_ch_param __iomem *base, u32 wbs, u32 v)
-{
-	u32 bit = (wbs >> 8) % 160;
-	u32 size = wbs & 0xff;
-	u32 word = (wbs >> 8) / 160;
-	u32 i = bit / 32;
-	u32 ofs = bit % 32;
-	u32 mask = (1 << size) - 1;
-	u32 val;
-
-	pr_debug("%s %d %d %d\n", __func__, word, bit , size);
-
-	val = readl(&base->word[word].data[i]);
-	val &= ~(mask << ofs);
-	val |= v << ofs;
-	writel(val, &base->word[word].data[i]);
-
-	if ((bit + size - 1) / 32 > i) {
-		val = readl(&base->word[word].data[i + 1]);
-		val &= ~(mask >> (ofs ? (32 - ofs) : 0));
-		val |= v >> (ofs ? (32 - ofs) : 0);
-		writel(val, &base->word[word].data[i + 1]);
-	}
-}
-EXPORT_SYMBOL_GPL(ipu_ch_param_write_field);
-
-u32 ipu_ch_param_read_field(struct ipu_ch_param __iomem *base, u32 wbs)
-{
-	u32 bit = (wbs >> 8) % 160;
-	u32 size = wbs & 0xff;
-	u32 word = (wbs >> 8) / 160;
-	u32 i = bit / 32;
-	u32 ofs = bit % 32;
-	u32 mask = (1 << size) - 1;
-	u32 val = 0;
-
-	pr_debug("%s %d %d %d\n", __func__, word, bit , size);
-
-	val = (readl(&base->word[word].data[i]) >> ofs) & mask;
-
-	if ((bit + size - 1) / 32 > i) {
-		u32 tmp;
-		tmp = readl(&base->word[word].data[i + 1]);
-		tmp &= mask >> (ofs ? (32 - ofs) : 0);
-		val |= tmp << (ofs ? (32 - ofs) : 0);
-	}
-
-	return val;
-}
-EXPORT_SYMBOL_GPL(ipu_ch_param_read_field);
-
-int ipu_cpmem_set_format_rgb(struct ipu_ch_param __iomem *p,
-		const struct ipu_rgb *rgb)
-{
-	int bpp = 0, npb = 0, ro, go, bo, to;
-
-	ro = rgb->bits_per_pixel - rgb->red.length - rgb->red.offset;
-	go = rgb->bits_per_pixel - rgb->green.length - rgb->green.offset;
-	bo = rgb->bits_per_pixel - rgb->blue.length - rgb->blue.offset;
-	to = rgb->bits_per_pixel - rgb->transp.length - rgb->transp.offset;
-
-	ipu_ch_param_write_field(p, IPU_FIELD_WID0, rgb->red.length - 1);
-	ipu_ch_param_write_field(p, IPU_FIELD_OFS0, ro);
-	ipu_ch_param_write_field(p, IPU_FIELD_WID1, rgb->green.length - 1);
-	ipu_ch_param_write_field(p, IPU_FIELD_OFS1, go);
-	ipu_ch_param_write_field(p, IPU_FIELD_WID2, rgb->blue.length - 1);
-	ipu_ch_param_write_field(p, IPU_FIELD_OFS2, bo);
-
-	if (rgb->transp.length) {
-		ipu_ch_param_write_field(p, IPU_FIELD_WID3,
-				rgb->transp.length - 1);
-		ipu_ch_param_write_field(p, IPU_FIELD_OFS3, to);
-	} else {
-		ipu_ch_param_write_field(p, IPU_FIELD_WID3, 7);
-		ipu_ch_param_write_field(p, IPU_FIELD_OFS3,
-				rgb->bits_per_pixel);
-	}
-
-	switch (rgb->bits_per_pixel) {
-	case 32:
-		bpp = 0;
-		npb = 15;
-		break;
-	case 24:
-		bpp = 1;
-		npb = 19;
-		break;
-	case 16:
-		bpp = 3;
-		npb = 31;
-		break;
-	case 8:
-		bpp = 5;
-		npb = 63;
-		break;
-	default:
-		return -EINVAL;
-	}
-	ipu_ch_param_write_field(p, IPU_FIELD_BPP, bpp);
-	ipu_ch_param_write_field(p, IPU_FIELD_NPB, npb);
-	ipu_ch_param_write_field(p, IPU_FIELD_PFS, 7); /* rgb mode */
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(ipu_cpmem_set_format_rgb);
-
-int ipu_cpmem_set_format_passthrough(struct ipu_ch_param __iomem *p,
-		int width)
-{
-	int bpp = 0, npb = 0;
-
-	switch (width) {
-	case 32:
-		bpp = 0;
-		npb = 15;
-		break;
-	case 24:
-		bpp = 1;
-		npb = 19;
-		break;
-	case 16:
-		bpp = 3;
-		npb = 31;
-		break;
-	case 8:
-		bpp = 5;
-		npb = 63;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	ipu_ch_param_write_field(p, IPU_FIELD_BPP, bpp);
-	ipu_ch_param_write_field(p, IPU_FIELD_NPB, npb);
-	ipu_ch_param_write_field(p, IPU_FIELD_PFS, 6); /* raw mode */
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(ipu_cpmem_set_format_passthrough);
-
-void ipu_cpmem_set_yuv_interleaved(struct ipu_ch_param __iomem *p,
-				   u32 pixel_format)
-{
-	switch (pixel_format) {
-	case V4L2_PIX_FMT_UYVY:
-		ipu_ch_param_write_field(p, IPU_FIELD_BPP, 3);    /* bits/pixel */
-		ipu_ch_param_write_field(p, IPU_FIELD_PFS, 0xA);  /* pix format */
-		ipu_ch_param_write_field(p, IPU_FIELD_NPB, 31);   /* burst size */
-		break;
-	case V4L2_PIX_FMT_YUYV:
-		ipu_ch_param_write_field(p, IPU_FIELD_BPP, 3);    /* bits/pixel */
-		ipu_ch_param_write_field(p, IPU_FIELD_PFS, 0x8);  /* pix format */
-		ipu_ch_param_write_field(p, IPU_FIELD_NPB, 31);   /* burst size */
-		break;
-	}
-}
-EXPORT_SYMBOL_GPL(ipu_cpmem_set_yuv_interleaved);
-
-void ipu_cpmem_set_yuv_planar_full(struct ipu_ch_param __iomem *p,
-		u32 pixel_format, int stride, int u_offset, int v_offset)
-{
-	switch (pixel_format) {
-	case V4L2_PIX_FMT_YUV420:
-		ipu_ch_param_write_field(p, IPU_FIELD_SLUV, (stride / 2) - 1);
-		ipu_ch_param_write_field(p, IPU_FIELD_UBO, u_offset / 8);
-		ipu_ch_param_write_field(p, IPU_FIELD_VBO, v_offset / 8);
-		break;
-	case V4L2_PIX_FMT_YVU420:
-		ipu_ch_param_write_field(p, IPU_FIELD_SLUV, (stride / 2) - 1);
-		ipu_ch_param_write_field(p, IPU_FIELD_UBO, v_offset / 8);
-		ipu_ch_param_write_field(p, IPU_FIELD_VBO, u_offset / 8);
-		break;
-	}
-}
-EXPORT_SYMBOL_GPL(ipu_cpmem_set_yuv_planar_full);
-
-void ipu_cpmem_set_yuv_planar(struct ipu_ch_param __iomem *p, u32 pixel_format,
-		int stride, int height)
-{
-	int u_offset, v_offset;
-	int uv_stride = 0;
-
-	switch (pixel_format) {
-	case V4L2_PIX_FMT_YUV420:
-	case V4L2_PIX_FMT_YVU420:
-		uv_stride = stride / 2;
-		u_offset = stride * height;
-		v_offset = u_offset + (uv_stride * height / 2);
-		ipu_cpmem_set_yuv_planar_full(p, pixel_format, stride,
-				u_offset, v_offset);
-		break;
-	}
-}
-EXPORT_SYMBOL_GPL(ipu_cpmem_set_yuv_planar);
-
-static const struct ipu_rgb def_rgb_32 = {
-	.red	= { .offset = 16, .length = 8, },
-	.green	= { .offset =  8, .length = 8, },
-	.blue	= { .offset =  0, .length = 8, },
-	.transp = { .offset = 24, .length = 8, },
-	.bits_per_pixel = 32,
-};
-
-static const struct ipu_rgb def_bgr_32 = {
-	.red	= { .offset =  0, .length = 8, },
-	.green	= { .offset =  8, .length = 8, },
-	.blue	= { .offset = 16, .length = 8, },
-	.transp = { .offset = 24, .length = 8, },
-	.bits_per_pixel = 32,
-};
-
-static const struct ipu_rgb def_rgb_24 = {
-	.red	= { .offset = 16, .length = 8, },
-	.green	= { .offset =  8, .length = 8, },
-	.blue	= { .offset =  0, .length = 8, },
-	.transp = { .offset =  0, .length = 0, },
-	.bits_per_pixel = 24,
-};
-
-static const struct ipu_rgb def_bgr_24 = {
-	.red	= { .offset =  0, .length = 8, },
-	.green	= { .offset =  8, .length = 8, },
-	.blue	= { .offset = 16, .length = 8, },
-	.transp = { .offset =  0, .length = 0, },
-	.bits_per_pixel = 24,
-};
-
-static const struct ipu_rgb def_rgb_16 = {
-	.red	= { .offset = 11, .length = 5, },
-	.green	= { .offset =  5, .length = 6, },
-	.blue	= { .offset =  0, .length = 5, },
-	.transp = { .offset =  0, .length = 0, },
-	.bits_per_pixel = 16,
-};
-
-static const struct ipu_rgb def_bgr_16 = {
-	.red	= { .offset =  0, .length = 5, },
-	.green	= { .offset =  5, .length = 6, },
-	.blue	= { .offset = 11, .length = 5, },
-	.transp = { .offset =  0, .length = 0, },
-	.bits_per_pixel = 16,
-};
-
-#define Y_OFFSET(pix, x, y)	((x) + pix->width * (y))
-#define U_OFFSET(pix, x, y)	((pix->width * pix->height) + \
-					(pix->width * (y) / 4) + (x) / 2)
-#define V_OFFSET(pix, x, y)	((pix->width * pix->height) + \
-					(pix->width * pix->height / 4) + \
-					(pix->width * (y) / 4) + (x) / 2)
-
-int ipu_cpmem_set_fmt(struct ipu_ch_param __iomem *cpmem, u32 drm_fourcc)
-{
-	switch (drm_fourcc) {
-	case DRM_FORMAT_YUV420:
-	case DRM_FORMAT_YVU420:
-		/* pix format */
-		ipu_ch_param_write_field(cpmem, IPU_FIELD_PFS, 2);
-		/* burst size */
-		ipu_ch_param_write_field(cpmem, IPU_FIELD_NPB, 63);
-		break;
-	case DRM_FORMAT_UYVY:
-		/* bits/pixel */
-		ipu_ch_param_write_field(cpmem, IPU_FIELD_BPP, 3);
-		/* pix format */
-		ipu_ch_param_write_field(cpmem, IPU_FIELD_PFS, 0xA);
-		/* burst size */
-		ipu_ch_param_write_field(cpmem, IPU_FIELD_NPB, 31);
-		break;
-	case DRM_FORMAT_YUYV:
-		/* bits/pixel */
-		ipu_ch_param_write_field(cpmem, IPU_FIELD_BPP, 3);
-		/* pix format */
-		ipu_ch_param_write_field(cpmem, IPU_FIELD_PFS, 0x8);
-		/* burst size */
-		ipu_ch_param_write_field(cpmem, IPU_FIELD_NPB, 31);
-		break;
-	case DRM_FORMAT_ABGR8888:
-	case DRM_FORMAT_XBGR8888:
-		ipu_cpmem_set_format_rgb(cpmem, &def_bgr_32);
-		break;
-	case DRM_FORMAT_ARGB8888:
-	case DRM_FORMAT_XRGB8888:
-		ipu_cpmem_set_format_rgb(cpmem, &def_rgb_32);
-		break;
-	case DRM_FORMAT_BGR888:
-		ipu_cpmem_set_format_rgb(cpmem, &def_bgr_24);
-		break;
-	case DRM_FORMAT_RGB888:
-		ipu_cpmem_set_format_rgb(cpmem, &def_rgb_24);
-		break;
-	case DRM_FORMAT_RGB565:
-		ipu_cpmem_set_format_rgb(cpmem, &def_rgb_16);
-		break;
-	case DRM_FORMAT_BGR565:
-		ipu_cpmem_set_format_rgb(cpmem, &def_bgr_16);
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(ipu_cpmem_set_fmt);
-
-/*
- * The V4L2 spec defines packed RGB formats in memory byte order, which from
- * point of view of the IPU corresponds to little-endian words with the first
- * component in the least significant bits.
- * The DRM pixel formats and IPU internal representation are ordered the other
- * way around, with the first named component ordered at the most significant
- * bits. Further, V4L2 formats are not well defined:
- *     http://linuxtv.org/downloads/v4l-dvb-apis/packed-rgb.html
- * We choose the interpretation which matches GStreamer behavior.
- */
-static int v4l2_pix_fmt_to_drm_fourcc(u32 pixelformat)
-{
-	switch (pixelformat) {
-	case V4L2_PIX_FMT_RGB565:
-		/*
-		 * Here we choose the 'corrected' interpretation of RGBP, a
-		 * little-endian 16-bit word with the red component at the most
-		 * significant bits:
-		 * g[2:0]b[4:0] r[4:0]g[5:3] <=> [16:0] R:G:B
-		 */
-		return DRM_FORMAT_RGB565;
-	case V4L2_PIX_FMT_BGR24:
-		/* B G R <=> [24:0] R:G:B */
-		return DRM_FORMAT_RGB888;
-	case V4L2_PIX_FMT_RGB24:
-		/* R G B <=> [24:0] B:G:R */
-		return DRM_FORMAT_BGR888;
-	case V4L2_PIX_FMT_BGR32:
-		/* B G R A <=> [32:0] A:B:G:R */
-		return DRM_FORMAT_XRGB8888;
-	case V4L2_PIX_FMT_RGB32:
-		/* R G B A <=> [32:0] A:B:G:R */
-		return DRM_FORMAT_XBGR8888;
-	case V4L2_PIX_FMT_UYVY:
-		return DRM_FORMAT_UYVY;
-	case V4L2_PIX_FMT_YUYV:
-		return DRM_FORMAT_YUYV;
-	case V4L2_PIX_FMT_YUV420:
-		return DRM_FORMAT_YUV420;
-	case V4L2_PIX_FMT_YVU420:
-		return DRM_FORMAT_YVU420;
-	}
-
-	return -EINVAL;
-}
-
 enum ipu_color_space ipu_drm_fourcc_to_colorspace(u32 drm_fourcc)
 {
 	switch (drm_fourcc) {
@@ -471,66 +87,6 @@ enum ipu_color_space ipu_drm_fourcc_to_colorspace(u32 drm_fourcc)
 }
 EXPORT_SYMBOL_GPL(ipu_drm_fourcc_to_colorspace);
 
-int ipu_cpmem_set_image(struct ipu_ch_param __iomem *cpmem,
-		struct ipu_image *image)
-{
-	struct v4l2_pix_format *pix = &image->pix;
-	int y_offset, u_offset, v_offset;
-
-	pr_debug("%s: resolution: %dx%d stride: %d\n",
-			__func__, pix->width, pix->height,
-			pix->bytesperline);
-
-	ipu_cpmem_set_resolution(cpmem, image->rect.width,
-			image->rect.height);
-	ipu_cpmem_set_stride(cpmem, pix->bytesperline);
-
-	ipu_cpmem_set_fmt(cpmem, v4l2_pix_fmt_to_drm_fourcc(pix->pixelformat));
-
-	switch (pix->pixelformat) {
-	case V4L2_PIX_FMT_YUV420:
-	case V4L2_PIX_FMT_YVU420:
-		y_offset = Y_OFFSET(pix, image->rect.left, image->rect.top);
-		u_offset = U_OFFSET(pix, image->rect.left,
-				image->rect.top) - y_offset;
-		v_offset = V_OFFSET(pix, image->rect.left,
-				image->rect.top) - y_offset;
-
-		ipu_cpmem_set_yuv_planar_full(cpmem, pix->pixelformat,
-				pix->bytesperline, u_offset, v_offset);
-		ipu_cpmem_set_buffer(cpmem, 0, image->phys + y_offset);
-		break;
-	case V4L2_PIX_FMT_UYVY:
-	case V4L2_PIX_FMT_YUYV:
-		ipu_cpmem_set_buffer(cpmem, 0, image->phys +
-				image->rect.left * 2 +
-				image->rect.top * image->pix.bytesperline);
-		break;
-	case V4L2_PIX_FMT_RGB32:
-	case V4L2_PIX_FMT_BGR32:
-		ipu_cpmem_set_buffer(cpmem, 0, image->phys +
-				image->rect.left * 4 +
-				image->rect.top * image->pix.bytesperline);
-		break;
-	case V4L2_PIX_FMT_RGB565:
-		ipu_cpmem_set_buffer(cpmem, 0, image->phys +
-				image->rect.left * 2 +
-				image->rect.top * image->pix.bytesperline);
-		break;
-	case V4L2_PIX_FMT_RGB24:
-	case V4L2_PIX_FMT_BGR24:
-		ipu_cpmem_set_buffer(cpmem, 0, image->phys +
-				image->rect.left * 3 +
-				image->rect.top * image->pix.bytesperline);
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(ipu_cpmem_set_image);
-
 enum ipu_color_space ipu_pixelformat_to_colorspace(u32 pixelformat)
 {
 	switch (pixelformat) {
@@ -1424,6 +980,12 @@ static int ipu_submodules_init(struct ipu_soc *ipu,
 	struct device *dev = &pdev->dev;
 	const struct ipu_devtype *devtype = ipu->devtype;
 
+	ret = ipu_cpmem_init(ipu, dev, ipu_base + devtype->cpmem_ofs);
+	if (ret) {
+		unit = "cpmem";
+		goto err_cpmem;
+	}
+
 	ret = ipu_csi_init(ipu, dev, 0, ipu_base + devtype->csi0_ofs,
 			   IPU_CONF_CSI0_EN, ipu_clk);
 	if (ret) {
@@ -1515,6 +1077,8 @@ err_smfc:
 err_csi_1:
 	ipu_csi_exit(ipu, 0);
 err_csi_0:
+	ipu_cpmem_exit(ipu);
+err_cpmem:
 	dev_err(&pdev->dev, "init %s failed with %d\n", unit, ret);
 	return ret;
 }
@@ -1587,6 +1151,7 @@ static void ipu_submodules_exit(struct ipu_soc *ipu)
 	ipu_smfc_exit(ipu);
 	ipu_csi_exit(ipu, 1);
 	ipu_csi_exit(ipu, 0);
+	ipu_cpmem_exit(ipu);
 }
 
 static int platform_remove_devices_fn(struct device *dev, void *unused)
@@ -1807,10 +1372,8 @@ static int ipu_probe(struct platform_device *pdev)
 	ipu->idmac_reg = devm_ioremap(&pdev->dev,
 			ipu_base + devtype->cm_ofs + IPU_CM_IDMAC_REG_OFS,
 			PAGE_SIZE);
-	ipu->cpmem_base = devm_ioremap(&pdev->dev,
-			ipu_base + devtype->cpmem_ofs, PAGE_SIZE);
 
-	if (!ipu->cm_reg || !ipu->idmac_reg || !ipu->cpmem_base)
+	if (!ipu->cm_reg || !ipu->idmac_reg)
 		return -ENOMEM;
 
 	ipu->gp_reg = syscon_regmap_lookup_by_compatible(
diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-cpmem.c b/drivers/staging/imx-drm/ipu-v3/ipu-cpmem.c
new file mode 100644
index 0000000..06471ee
--- /dev/null
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-cpmem.c
@@ -0,0 +1,595 @@
+/*
+ * Copyright (C) 2012 Mentor Graphics Inc.
+ * Copyright 2005-2012 Freescale Semiconductor, Inc. All Rights Reserved.
+ *
+ * The code contained herein is licensed under the GNU General Public
+ * License. You may obtain a copy of the GNU General Public License
+ * Version 2 or later at the following locations:
+ *
+ * http://www.opensource.org/licenses/gpl-license.html
+ * http://www.gnu.org/copyleft/gpl.html
+ */
+#include <linux/types.h>
+#include <linux/bitrev.h>
+#include <linux/io.h>
+#include <drm/drm_fourcc.h>
+#include "ipu-prv.h"
+
+struct ipu_cpmem_word {
+	u32 data[5];
+	u32 res[3];
+};
+
+struct ipu_ch_param {
+	struct ipu_cpmem_word word[2];
+};
+
+struct ipu_cpmem {
+	struct ipu_ch_param __iomem *base;
+	u32 module;
+	spinlock_t lock;
+	int use_count;
+	struct ipu_soc *ipu;
+};
+
+#define IPU_CPMEM_WORD(word, ofs, size) ((((word) * 160 + (ofs)) << 8) | (size))
+
+#define IPU_FIELD_UBO		IPU_CPMEM_WORD(0, 46, 22)
+#define IPU_FIELD_VBO		IPU_CPMEM_WORD(0, 68, 22)
+#define IPU_FIELD_IOX		IPU_CPMEM_WORD(0, 90, 4)
+#define IPU_FIELD_RDRW		IPU_CPMEM_WORD(0, 94, 1)
+#define IPU_FIELD_SO		IPU_CPMEM_WORD(0, 113, 1)
+#define IPU_FIELD_SLY		IPU_CPMEM_WORD(1, 102, 14)
+#define IPU_FIELD_SLUV		IPU_CPMEM_WORD(1, 128, 14)
+
+#define IPU_FIELD_XV		IPU_CPMEM_WORD(0, 0, 10)
+#define IPU_FIELD_YV		IPU_CPMEM_WORD(0, 10, 9)
+#define IPU_FIELD_XB		IPU_CPMEM_WORD(0, 19, 13)
+#define IPU_FIELD_YB		IPU_CPMEM_WORD(0, 32, 12)
+#define IPU_FIELD_NSB_B		IPU_CPMEM_WORD(0, 44, 1)
+#define IPU_FIELD_CF		IPU_CPMEM_WORD(0, 45, 1)
+#define IPU_FIELD_SX		IPU_CPMEM_WORD(0, 46, 12)
+#define IPU_FIELD_SY		IPU_CPMEM_WORD(0, 58, 11)
+#define IPU_FIELD_NS		IPU_CPMEM_WORD(0, 69, 10)
+#define IPU_FIELD_SDX		IPU_CPMEM_WORD(0, 79, 7)
+#define IPU_FIELD_SM		IPU_CPMEM_WORD(0, 86, 10)
+#define IPU_FIELD_SCC		IPU_CPMEM_WORD(0, 96, 1)
+#define IPU_FIELD_SCE		IPU_CPMEM_WORD(0, 97, 1)
+#define IPU_FIELD_SDY		IPU_CPMEM_WORD(0, 98, 7)
+#define IPU_FIELD_SDRX		IPU_CPMEM_WORD(0, 105, 1)
+#define IPU_FIELD_SDRY		IPU_CPMEM_WORD(0, 106, 1)
+#define IPU_FIELD_BPP		IPU_CPMEM_WORD(0, 107, 3)
+#define IPU_FIELD_DEC_SEL	IPU_CPMEM_WORD(0, 110, 2)
+#define IPU_FIELD_DIM		IPU_CPMEM_WORD(0, 112, 1)
+#define IPU_FIELD_BNDM		IPU_CPMEM_WORD(0, 114, 3)
+#define IPU_FIELD_BM		IPU_CPMEM_WORD(0, 117, 2)
+#define IPU_FIELD_ROT		IPU_CPMEM_WORD(0, 119, 1)
+#define IPU_FIELD_HF		IPU_CPMEM_WORD(0, 120, 1)
+#define IPU_FIELD_VF		IPU_CPMEM_WORD(0, 121, 1)
+#define IPU_FIELD_THE		IPU_CPMEM_WORD(0, 122, 1)
+#define IPU_FIELD_CAP		IPU_CPMEM_WORD(0, 123, 1)
+#define IPU_FIELD_CAE		IPU_CPMEM_WORD(0, 124, 1)
+#define IPU_FIELD_FW		IPU_CPMEM_WORD(0, 125, 13)
+#define IPU_FIELD_FH		IPU_CPMEM_WORD(0, 138, 12)
+#define IPU_FIELD_EBA0		IPU_CPMEM_WORD(1, 0, 29)
+#define IPU_FIELD_EBA1		IPU_CPMEM_WORD(1, 29, 29)
+#define IPU_FIELD_ILO		IPU_CPMEM_WORD(1, 58, 20)
+#define IPU_FIELD_NPB		IPU_CPMEM_WORD(1, 78, 7)
+#define IPU_FIELD_PFS		IPU_CPMEM_WORD(1, 85, 4)
+#define IPU_FIELD_ALU		IPU_CPMEM_WORD(1, 89, 1)
+#define IPU_FIELD_ALBM		IPU_CPMEM_WORD(1, 90, 3)
+#define IPU_FIELD_ID		IPU_CPMEM_WORD(1, 93, 2)
+#define IPU_FIELD_TH		IPU_CPMEM_WORD(1, 95, 7)
+#define IPU_FIELD_SL		IPU_CPMEM_WORD(1, 102, 14)
+#define IPU_FIELD_WID0		IPU_CPMEM_WORD(1, 116, 3)
+#define IPU_FIELD_WID1		IPU_CPMEM_WORD(1, 119, 3)
+#define IPU_FIELD_WID2		IPU_CPMEM_WORD(1, 122, 3)
+#define IPU_FIELD_WID3		IPU_CPMEM_WORD(1, 125, 3)
+#define IPU_FIELD_OFS0		IPU_CPMEM_WORD(1, 128, 5)
+#define IPU_FIELD_OFS1		IPU_CPMEM_WORD(1, 133, 5)
+#define IPU_FIELD_OFS2		IPU_CPMEM_WORD(1, 138, 5)
+#define IPU_FIELD_OFS3		IPU_CPMEM_WORD(1, 143, 5)
+#define IPU_FIELD_SXYS		IPU_CPMEM_WORD(1, 148, 1)
+#define IPU_FIELD_CRE		IPU_CPMEM_WORD(1, 149, 1)
+#define IPU_FIELD_DEC_SEL2	IPU_CPMEM_WORD(1, 150, 1)
+
+static inline struct ipu_ch_param __iomem *
+ipu_get_cpmem(struct ipuv3_channel *ch)
+{
+	struct ipu_cpmem *cpmem = ch->ipu->cpmem_priv;
+	return cpmem->base + ch->num;
+}
+
+static void ipu_ch_param_write_field(struct ipuv3_channel *ch, u32 wbs, u32 v)
+{
+	struct ipu_ch_param __iomem *base = ipu_get_cpmem(ch);
+	u32 bit = (wbs >> 8) % 160;
+	u32 size = wbs & 0xff;
+	u32 word = (wbs >> 8) / 160;
+	u32 i = bit / 32;
+	u32 ofs = bit % 32;
+	u32 mask = (1 << size) - 1;
+	u32 val;
+
+	pr_debug("%s %d %d %d\n", __func__, word, bit , size);
+
+	val = readl(&base->word[word].data[i]);
+	val &= ~(mask << ofs);
+	val |= v << ofs;
+	writel(val, &base->word[word].data[i]);
+
+	if ((bit + size - 1) / 32 > i) {
+		val = readl(&base->word[word].data[i + 1]);
+		val &= ~(mask >> (ofs ? (32 - ofs) : 0));
+		val |= v >> (ofs ? (32 - ofs) : 0);
+		writel(val, &base->word[word].data[i + 1]);
+	}
+}
+
+static u32 ipu_ch_param_read_field(struct ipuv3_channel *ch, u32 wbs)
+{
+	struct ipu_ch_param __iomem *base = ipu_get_cpmem(ch);
+	u32 bit = (wbs >> 8) % 160;
+	u32 size = wbs & 0xff;
+	u32 word = (wbs >> 8) / 160;
+	u32 i = bit / 32;
+	u32 ofs = bit % 32;
+	u32 mask = (1 << size) - 1;
+	u32 val = 0;
+
+	pr_debug("%s %d %d %d\n", __func__, word, bit , size);
+
+	val = (readl(&base->word[word].data[i]) >> ofs) & mask;
+
+	if ((bit + size - 1) / 32 > i) {
+		u32 tmp;
+		tmp = readl(&base->word[word].data[i + 1]);
+		tmp &= mask >> (ofs ? (32 - ofs) : 0);
+		val |= tmp << (ofs ? (32 - ofs) : 0);
+	}
+
+	return val;
+}
+
+/*
+ * The V4L2 spec defines packed RGB formats in memory byte order, which from
+ * point of view of the IPU corresponds to little-endian words with the first
+ * component in the least significant bits.
+ * The DRM pixel formats and IPU internal representation are ordered the other
+ * way around, with the first named component ordered at the most significant
+ * bits. Further, V4L2 formats are not well defined:
+ *     http://linuxtv.org/downloads/v4l-dvb-apis/packed-rgb.html
+ * We choose the interpretation which matches GStreamer behavior.
+ */
+static int v4l2_pix_fmt_to_drm_fourcc(u32 pixelformat)
+{
+	switch (pixelformat) {
+	case V4L2_PIX_FMT_RGB565:
+		/*
+		 * Here we choose the 'corrected' interpretation of RGBP, a
+		 * little-endian 16-bit word with the red component at the most
+		 * significant bits:
+		 * g[2:0]b[4:0] r[4:0]g[5:3] <=> [16:0] R:G:B
+		 */
+		return DRM_FORMAT_RGB565;
+	case V4L2_PIX_FMT_BGR24:
+		/* B G R <=> [24:0] R:G:B */
+		return DRM_FORMAT_RGB888;
+	case V4L2_PIX_FMT_RGB24:
+		/* R G B <=> [24:0] B:G:R */
+		return DRM_FORMAT_BGR888;
+	case V4L2_PIX_FMT_BGR32:
+		/* B G R A <=> [32:0] A:B:G:R */
+		return DRM_FORMAT_XRGB8888;
+	case V4L2_PIX_FMT_RGB32:
+		/* R G B A <=> [32:0] A:B:G:R */
+		return DRM_FORMAT_XBGR8888;
+	case V4L2_PIX_FMT_UYVY:
+		return DRM_FORMAT_UYVY;
+	case V4L2_PIX_FMT_YUYV:
+		return DRM_FORMAT_YUYV;
+	case V4L2_PIX_FMT_YUV420:
+		return DRM_FORMAT_YUV420;
+	case V4L2_PIX_FMT_YVU420:
+		return DRM_FORMAT_YVU420;
+	}
+
+	return -EINVAL;
+}
+
+void ipu_cpmem_zero(struct ipuv3_channel *ch)
+{
+	struct ipu_ch_param __iomem *p = ipu_get_cpmem(ch);
+	void __iomem *base = p;
+	int i;
+
+	for (i = 0; i < sizeof(*p) / sizeof(u32); i++)
+		writel(0, base + i * sizeof(u32));
+}
+EXPORT_SYMBOL_GPL(ipu_cpmem_zero);
+
+void ipu_cpmem_set_resolution(struct ipuv3_channel *ch, int xres, int yres)
+{
+	ipu_ch_param_write_field(ch, IPU_FIELD_FW, xres - 1);
+	ipu_ch_param_write_field(ch, IPU_FIELD_FH, yres - 1);
+}
+EXPORT_SYMBOL_GPL(ipu_cpmem_set_resolution);
+
+void ipu_cpmem_set_stride(struct ipuv3_channel *ch, int stride)
+{
+	ipu_ch_param_write_field(ch, IPU_FIELD_SLY, stride - 1);
+}
+EXPORT_SYMBOL_GPL(ipu_cpmem_set_stride);
+
+void ipu_cpmem_set_high_priority(struct ipuv3_channel *ch)
+{
+	struct ipu_soc *ipu = ch->ipu;
+	u32 val;
+
+	if (ipu->ipu_type == IPUV3EX)
+		ipu_ch_param_write_field(ch, IPU_FIELD_ID, 1);
+
+	val = ipu_idmac_read(ipu, IDMAC_CHA_PRI(ch->num));
+	val |= 1 << (ch->num % 32);
+	ipu_idmac_write(ipu, val, IDMAC_CHA_PRI(ch->num));
+};
+EXPORT_SYMBOL_GPL(ipu_cpmem_set_high_priority);
+
+void ipu_cpmem_set_buffer(struct ipuv3_channel *ch, int bufnum, dma_addr_t buf)
+{
+	if (bufnum)
+		ipu_ch_param_write_field(ch, IPU_FIELD_EBA1, buf >> 3);
+	else
+		ipu_ch_param_write_field(ch, IPU_FIELD_EBA0, buf >> 3);
+}
+EXPORT_SYMBOL_GPL(ipu_cpmem_set_buffer);
+
+void ipu_cpmem_interlaced_scan(struct ipuv3_channel *ch, int stride)
+{
+	ipu_ch_param_write_field(ch, IPU_FIELD_SO, 1);
+	ipu_ch_param_write_field(ch, IPU_FIELD_ILO, stride / 8);
+	ipu_ch_param_write_field(ch, IPU_FIELD_SLY, (stride * 2) - 1);
+};
+EXPORT_SYMBOL_GPL(ipu_cpmem_interlaced_scan);
+
+void ipu_cpmem_set_burstsize(struct ipuv3_channel *ch, int burstsize)
+{
+	ipu_ch_param_write_field(ch, IPU_FIELD_NPB, burstsize - 1);
+};
+EXPORT_SYMBOL_GPL(ipu_cpmem_set_burstsize);
+
+int ipu_cpmem_set_format_rgb(struct ipuv3_channel *ch,
+			     const struct ipu_rgb *rgb)
+{
+	int bpp = 0, npb = 0, ro, go, bo, to;
+
+	ro = rgb->bits_per_pixel - rgb->red.length - rgb->red.offset;
+	go = rgb->bits_per_pixel - rgb->green.length - rgb->green.offset;
+	bo = rgb->bits_per_pixel - rgb->blue.length - rgb->blue.offset;
+	to = rgb->bits_per_pixel - rgb->transp.length - rgb->transp.offset;
+
+	ipu_ch_param_write_field(ch, IPU_FIELD_WID0, rgb->red.length - 1);
+	ipu_ch_param_write_field(ch, IPU_FIELD_OFS0, ro);
+	ipu_ch_param_write_field(ch, IPU_FIELD_WID1, rgb->green.length - 1);
+	ipu_ch_param_write_field(ch, IPU_FIELD_OFS1, go);
+	ipu_ch_param_write_field(ch, IPU_FIELD_WID2, rgb->blue.length - 1);
+	ipu_ch_param_write_field(ch, IPU_FIELD_OFS2, bo);
+
+	if (rgb->transp.length) {
+		ipu_ch_param_write_field(ch, IPU_FIELD_WID3,
+				rgb->transp.length - 1);
+		ipu_ch_param_write_field(ch, IPU_FIELD_OFS3, to);
+	} else {
+		ipu_ch_param_write_field(ch, IPU_FIELD_WID3, 7);
+		ipu_ch_param_write_field(ch, IPU_FIELD_OFS3,
+				rgb->bits_per_pixel);
+	}
+
+	switch (rgb->bits_per_pixel) {
+	case 32:
+		bpp = 0;
+		npb = 15;
+		break;
+	case 24:
+		bpp = 1;
+		npb = 19;
+		break;
+	case 16:
+		bpp = 3;
+		npb = 31;
+		break;
+	case 8:
+		bpp = 5;
+		npb = 63;
+		break;
+	default:
+		return -EINVAL;
+	}
+	ipu_ch_param_write_field(ch, IPU_FIELD_BPP, bpp);
+	ipu_ch_param_write_field(ch, IPU_FIELD_NPB, npb);
+	ipu_ch_param_write_field(ch, IPU_FIELD_PFS, 7); /* rgb mode */
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ipu_cpmem_set_format_rgb);
+
+int ipu_cpmem_set_format_passthrough(struct ipuv3_channel *ch, int width)
+{
+	int bpp = 0, npb = 0;
+
+	switch (width) {
+	case 32:
+		bpp = 0;
+		npb = 15;
+		break;
+	case 24:
+		bpp = 1;
+		npb = 19;
+		break;
+	case 16:
+		bpp = 3;
+		npb = 31;
+		break;
+	case 8:
+		bpp = 5;
+		npb = 63;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	ipu_ch_param_write_field(ch, IPU_FIELD_BPP, bpp);
+	ipu_ch_param_write_field(ch, IPU_FIELD_NPB, npb);
+	ipu_ch_param_write_field(ch, IPU_FIELD_PFS, 6); /* raw mode */
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ipu_cpmem_set_format_passthrough);
+
+void ipu_cpmem_set_yuv_interleaved(struct ipuv3_channel *ch, u32 pixel_format)
+{
+	switch (pixel_format) {
+	case V4L2_PIX_FMT_UYVY:
+		ipu_ch_param_write_field(ch, IPU_FIELD_BPP, 3); /* bits/pixel */
+		ipu_ch_param_write_field(ch, IPU_FIELD_PFS, 0xA);/* pix fmt */
+		ipu_ch_param_write_field(ch, IPU_FIELD_NPB, 31);/* burst size */
+		break;
+	case V4L2_PIX_FMT_YUYV:
+		ipu_ch_param_write_field(ch, IPU_FIELD_BPP, 3); /* bits/pixel */
+		ipu_ch_param_write_field(ch, IPU_FIELD_PFS, 0x8);/* pix fmt */
+		ipu_ch_param_write_field(ch, IPU_FIELD_NPB, 31);/* burst size */
+		break;
+	}
+}
+EXPORT_SYMBOL_GPL(ipu_cpmem_set_yuv_interleaved);
+
+void ipu_cpmem_set_yuv_planar_full(struct ipuv3_channel *ch,
+				   u32 pixel_format, int stride,
+				   int u_offset, int v_offset)
+{
+	switch (pixel_format) {
+	case V4L2_PIX_FMT_YUV420:
+		ipu_ch_param_write_field(ch, IPU_FIELD_SLUV, (stride / 2) - 1);
+		ipu_ch_param_write_field(ch, IPU_FIELD_UBO, u_offset / 8);
+		ipu_ch_param_write_field(ch, IPU_FIELD_VBO, v_offset / 8);
+		break;
+	case V4L2_PIX_FMT_YVU420:
+		ipu_ch_param_write_field(ch, IPU_FIELD_SLUV, (stride / 2) - 1);
+		ipu_ch_param_write_field(ch, IPU_FIELD_UBO, v_offset / 8);
+		ipu_ch_param_write_field(ch, IPU_FIELD_VBO, u_offset / 8);
+		break;
+	}
+}
+EXPORT_SYMBOL_GPL(ipu_cpmem_set_yuv_planar_full);
+
+void ipu_cpmem_set_yuv_planar(struct ipuv3_channel *ch,
+			      u32 pixel_format, int stride, int height)
+{
+	int u_offset, v_offset;
+	int uv_stride = 0;
+
+	switch (pixel_format) {
+	case V4L2_PIX_FMT_YUV420:
+	case V4L2_PIX_FMT_YVU420:
+		uv_stride = stride / 2;
+		u_offset = stride * height;
+		v_offset = u_offset + (uv_stride * height / 2);
+		ipu_cpmem_set_yuv_planar_full(ch, pixel_format, stride,
+					      u_offset, v_offset);
+		break;
+	}
+}
+EXPORT_SYMBOL_GPL(ipu_cpmem_set_yuv_planar);
+
+static const struct ipu_rgb def_rgb_32 = {
+	.red	= { .offset = 16, .length = 8, },
+	.green	= { .offset =  8, .length = 8, },
+	.blue	= { .offset =  0, .length = 8, },
+	.transp = { .offset = 24, .length = 8, },
+	.bits_per_pixel = 32,
+};
+
+static const struct ipu_rgb def_bgr_32 = {
+	.red	= { .offset =  0, .length = 8, },
+	.green	= { .offset =  8, .length = 8, },
+	.blue	= { .offset = 16, .length = 8, },
+	.transp = { .offset = 24, .length = 8, },
+	.bits_per_pixel = 32,
+};
+
+static const struct ipu_rgb def_rgb_24 = {
+	.red	= { .offset = 16, .length = 8, },
+	.green	= { .offset =  8, .length = 8, },
+	.blue	= { .offset =  0, .length = 8, },
+	.transp = { .offset =  0, .length = 0, },
+	.bits_per_pixel = 24,
+};
+
+static const struct ipu_rgb def_bgr_24 = {
+	.red	= { .offset =  0, .length = 8, },
+	.green	= { .offset =  8, .length = 8, },
+	.blue	= { .offset = 16, .length = 8, },
+	.transp = { .offset =  0, .length = 0, },
+	.bits_per_pixel = 24,
+};
+
+static const struct ipu_rgb def_rgb_16 = {
+	.red	= { .offset = 11, .length = 5, },
+	.green	= { .offset =  5, .length = 6, },
+	.blue	= { .offset =  0, .length = 5, },
+	.transp = { .offset =  0, .length = 0, },
+	.bits_per_pixel = 16,
+};
+
+static const struct ipu_rgb def_bgr_16 = {
+	.red	= { .offset =  0, .length = 5, },
+	.green	= { .offset =  5, .length = 6, },
+	.blue	= { .offset = 11, .length = 5, },
+	.transp = { .offset =  0, .length = 0, },
+	.bits_per_pixel = 16,
+};
+
+#define Y_OFFSET(pix, x, y)	((x) + pix->width * (y))
+#define U_OFFSET(pix, x, y)	((pix->width * pix->height) + \
+					(pix->width * (y) / 4) + (x) / 2)
+#define V_OFFSET(pix, x, y)	((pix->width * pix->height) + \
+					(pix->width * pix->height / 4) + \
+					(pix->width * (y) / 4) + (x) / 2)
+
+int ipu_cpmem_set_fmt(struct ipuv3_channel *ch, u32 drm_fourcc)
+{
+	switch (drm_fourcc) {
+	case DRM_FORMAT_YUV420:
+	case DRM_FORMAT_YVU420:
+		/* pix format */
+		ipu_ch_param_write_field(ch, IPU_FIELD_PFS, 2);
+		/* burst size */
+		ipu_ch_param_write_field(ch, IPU_FIELD_NPB, 31);
+		break;
+	case DRM_FORMAT_UYVY:
+		/* bits/pixel */
+		ipu_ch_param_write_field(ch, IPU_FIELD_BPP, 3);
+		/* pix format */
+		ipu_ch_param_write_field(ch, IPU_FIELD_PFS, 0xA);
+		/* burst size */
+		ipu_ch_param_write_field(ch, IPU_FIELD_NPB, 31);
+		break;
+	case DRM_FORMAT_YUYV:
+		/* bits/pixel */
+		ipu_ch_param_write_field(ch, IPU_FIELD_BPP, 3);
+		/* pix format */
+		ipu_ch_param_write_field(ch, IPU_FIELD_PFS, 0x8);
+		/* burst size */
+		ipu_ch_param_write_field(ch, IPU_FIELD_NPB, 31);
+		break;
+	case DRM_FORMAT_ABGR8888:
+	case DRM_FORMAT_XBGR8888:
+		ipu_cpmem_set_format_rgb(ch, &def_bgr_32);
+		break;
+	case DRM_FORMAT_ARGB8888:
+	case DRM_FORMAT_XRGB8888:
+		ipu_cpmem_set_format_rgb(ch, &def_rgb_32);
+		break;
+	case DRM_FORMAT_BGR888:
+		ipu_cpmem_set_format_rgb(ch, &def_bgr_24);
+		break;
+	case DRM_FORMAT_RGB888:
+		ipu_cpmem_set_format_rgb(ch, &def_rgb_24);
+		break;
+	case DRM_FORMAT_RGB565:
+		ipu_cpmem_set_format_rgb(ch, &def_rgb_16);
+		break;
+	case DRM_FORMAT_BGR565:
+		ipu_cpmem_set_format_rgb(ch, &def_bgr_16);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ipu_cpmem_set_fmt);
+
+int ipu_cpmem_set_image(struct ipuv3_channel *ch, struct ipu_image *image)
+{
+	struct v4l2_pix_format *pix = &image->pix;
+	int y_offset, u_offset, v_offset;
+
+	pr_debug("%s: resolution: %dx%d stride: %d\n",
+		 __func__, pix->width, pix->height,
+		 pix->bytesperline);
+
+	ipu_cpmem_set_resolution(ch, image->rect.width, image->rect.height);
+	ipu_cpmem_set_stride(ch, pix->bytesperline);
+
+	ipu_cpmem_set_fmt(ch, v4l2_pix_fmt_to_drm_fourcc(pix->pixelformat));
+
+	switch (pix->pixelformat) {
+	case V4L2_PIX_FMT_YUV420:
+	case V4L2_PIX_FMT_YVU420:
+		y_offset = Y_OFFSET(pix, image->rect.left, image->rect.top);
+		u_offset = U_OFFSET(pix, image->rect.left,
+				    image->rect.top) - y_offset;
+		v_offset = V_OFFSET(pix, image->rect.left,
+				    image->rect.top) - y_offset;
+
+		ipu_cpmem_set_yuv_planar_full(ch, pix->pixelformat,
+				pix->bytesperline, u_offset, v_offset);
+		ipu_cpmem_set_buffer(ch, 0, image->phys + y_offset);
+		break;
+	case V4L2_PIX_FMT_UYVY:
+	case V4L2_PIX_FMT_YUYV:
+		ipu_cpmem_set_buffer(ch, 0, image->phys +
+				     image->rect.left * 2 +
+				     image->rect.top * image->pix.bytesperline);
+		break;
+	case V4L2_PIX_FMT_RGB32:
+	case V4L2_PIX_FMT_BGR32:
+		ipu_cpmem_set_buffer(ch, 0, image->phys +
+				     image->rect.left * 4 +
+				     image->rect.top * image->pix.bytesperline);
+		break;
+	case V4L2_PIX_FMT_RGB565:
+		ipu_cpmem_set_buffer(ch, 0, image->phys +
+				     image->rect.left * 2 +
+				     image->rect.top * image->pix.bytesperline);
+		break;
+	case V4L2_PIX_FMT_RGB24:
+	case V4L2_PIX_FMT_BGR24:
+		ipu_cpmem_set_buffer(ch, 0, image->phys +
+				     image->rect.left * 3 +
+				     image->rect.top * image->pix.bytesperline);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ipu_cpmem_set_image);
+
+int ipu_cpmem_init(struct ipu_soc *ipu, struct device *dev, unsigned long base)
+{
+	struct ipu_cpmem *cpmem;
+
+	cpmem = devm_kzalloc(dev, sizeof(*cpmem), GFP_KERNEL);
+	if (!cpmem)
+		return -ENOMEM;
+
+	ipu->cpmem_priv = cpmem;
+
+	spin_lock_init(&cpmem->lock);
+	cpmem->base = devm_ioremap(dev, base, SZ_128K);
+	if (!cpmem->base)
+		return -ENOMEM;
+
+	dev_dbg(dev, "CPMEM base: 0x%08lx remapped to %p\n",
+		base, cpmem->base);
+	cpmem->ipu = ipu;
+
+	return 0;
+}
+
+void ipu_cpmem_exit(struct ipu_soc *ipu)
+{
+}
diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-prv.h b/drivers/staging/imx-drm/ipu-v3/ipu-prv.h
index d10e624..f56b3fd 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-prv.h
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-prv.h
@@ -195,6 +195,7 @@ struct ipuv3_channel {
 	struct ipu_soc *ipu;
 };
 
+struct ipu_cpmem;
 struct ipu_dc_priv;
 struct ipu_dmfc_priv;
 struct ipu_di;
@@ -213,7 +214,6 @@ struct ipu_soc {
 
 	void __iomem		*cm_reg;
 	void __iomem		*idmac_reg;
-	struct ipu_ch_param __iomem	*cpmem_base;
 	struct regmap		*gp_reg;
 
 	int			id;
@@ -227,6 +227,7 @@ struct ipu_soc {
 	int			irq_err;
 	struct irq_domain	*domain;
 
+	struct ipu_cpmem	*cpmem_priv;
 	struct ipu_dc_priv	*dc_priv;
 	struct ipu_dp_priv	*dp_priv;
 	struct ipu_dmfc_priv	*dmfc_priv;
@@ -237,6 +238,17 @@ struct ipu_soc {
 	struct ipu_irt		*irt_priv;
 };
 
+static inline u32 ipu_idmac_read(struct ipu_soc *ipu, unsigned offset)
+{
+	return readl(ipu->idmac_reg + offset);
+}
+
+static inline void ipu_idmac_write(struct ipu_soc *ipu, u32 value,
+		unsigned offset)
+{
+	writel(value, ipu->idmac_reg + offset);
+}
+
 void ipu_srm_dp_sync_update(struct ipu_soc *ipu);
 
 int ipu_module_enable(struct ipu_soc *ipu, u32 mask);
diff --git a/drivers/staging/imx-drm/ipuv3-plane.c b/drivers/staging/imx-drm/ipuv3-plane.c
index e9e4e7a..f962cc8 100644
--- a/drivers/staging/imx-drm/ipuv3-plane.c
+++ b/drivers/staging/imx-drm/ipuv3-plane.c
@@ -62,7 +62,6 @@ static inline int calc_bandwidth(int width, int height, unsigned int vref)
 int ipu_plane_set_base(struct ipu_plane *ipu_plane, struct drm_framebuffer *fb,
 		       int x, int y)
 {
-	struct ipu_ch_param __iomem *cpmem;
 	struct drm_gem_cma_object *cma_obj;
 	unsigned long eba;
 
@@ -75,13 +74,12 @@ int ipu_plane_set_base(struct ipu_plane *ipu_plane, struct drm_framebuffer *fb,
 	dev_dbg(ipu_plane->base.dev->dev, "phys = %pad, x = %d, y = %d",
 		&cma_obj->paddr, x, y);
 
-	cpmem = ipu_get_cpmem(ipu_plane->ipu_ch);
-	ipu_cpmem_set_stride(cpmem, fb->pitches[0]);
+	ipu_cpmem_set_stride(ipu_plane->ipu_ch, fb->pitches[0]);
 
 	eba = cma_obj->paddr + fb->offsets[0] +
 	      fb->pitches[0] * y + (fb->bits_per_pixel >> 3) * x;
-	ipu_cpmem_set_buffer(cpmem, 0, eba);
-	ipu_cpmem_set_buffer(cpmem, 1, eba);
+	ipu_cpmem_set_buffer(ipu_plane->ipu_ch, 0, eba);
+	ipu_cpmem_set_buffer(ipu_plane->ipu_ch, 1, eba);
 
 	/* cache offsets for subsequent pageflips */
 	ipu_plane->x = x;
@@ -97,7 +95,6 @@ int ipu_plane_mode_set(struct ipu_plane *ipu_plane, struct drm_crtc *crtc,
 		       uint32_t src_x, uint32_t src_y,
 		       uint32_t src_w, uint32_t src_h)
 {
-	struct ipu_ch_param __iomem *cpmem;
 	struct device *dev = ipu_plane->base.dev->dev;
 	int ret;
 
@@ -175,10 +172,9 @@ int ipu_plane_mode_set(struct ipu_plane *ipu_plane, struct drm_crtc *crtc,
 		return ret;
 	}
 
-	cpmem = ipu_get_cpmem(ipu_plane->ipu_ch);
-	ipu_ch_param_zero(cpmem);
-	ipu_cpmem_set_resolution(cpmem, src_w, src_h);
-	ret = ipu_cpmem_set_fmt(cpmem, fb->pixel_format);
+	ipu_cpmem_zero(ipu_plane->ipu_ch);
+	ipu_cpmem_set_resolution(ipu_plane->ipu_ch, src_w, src_h);
+	ret = ipu_cpmem_set_fmt(ipu_plane->ipu_ch, fb->pixel_format);
 	if (ret < 0) {
 		dev_err(dev, "unsupported pixel format 0x%08x\n",
 			fb->pixel_format);
diff --git a/include/linux/platform_data/imx-ipu-v3.h b/include/linux/platform_data/imx-ipu-v3.h
index 49e69a9..91986ed 100644
--- a/include/linux/platform_data/imx-ipu-v3.h
+++ b/include/linux/platform_data/imx-ipu-v3.h
@@ -205,6 +205,43 @@ int ipu_idmac_current_buffer(struct ipuv3_channel *channel);
 void ipu_idmac_enable_watermark(struct ipuv3_channel *channel, bool enable);
 int ipu_idmac_lock_enable(struct ipuv3_channel *channel, int num_bursts);
 
+/*
+ * IPU Channel Parameter Memory (cpmem) functions
+ */
+struct ipu_rgb {
+	struct fb_bitfield	red;
+	struct fb_bitfield	green;
+	struct fb_bitfield	blue;
+	struct fb_bitfield	transp;
+	int			bits_per_pixel;
+};
+
+struct ipu_image {
+	struct v4l2_pix_format pix;
+	struct v4l2_rect rect;
+	dma_addr_t phys;
+};
+
+void ipu_cpmem_zero(struct ipuv3_channel *ch);
+void ipu_cpmem_set_resolution(struct ipuv3_channel *ch, int xres, int yres);
+void ipu_cpmem_set_stride(struct ipuv3_channel *ch, int stride);
+void ipu_cpmem_set_high_priority(struct ipuv3_channel *ch);
+void ipu_cpmem_set_buffer(struct ipuv3_channel *ch, int bufnum, dma_addr_t buf);
+void ipu_cpmem_interlaced_scan(struct ipuv3_channel *ch, int stride);
+void ipu_cpmem_set_burstsize(struct ipuv3_channel *ch, int burstsize);
+int ipu_cpmem_set_format_rgb(struct ipuv3_channel *ch,
+			     const struct ipu_rgb *rgb);
+int ipu_cpmem_set_format_passthrough(struct ipuv3_channel *ch, int width);
+void ipu_cpmem_set_yuv_interleaved(struct ipuv3_channel *ch, u32 pixel_format);
+void ipu_cpmem_set_yuv_planar_full(struct ipuv3_channel *ch,
+				   u32 pixel_format, int stride,
+				   int u_offset, int v_offset);
+void ipu_cpmem_set_yuv_planar(struct ipuv3_channel *ch,
+			      u32 pixel_format, int stride, int height);
+int ipu_cpmem_set_fmt(struct ipuv3_channel *ch, u32 drm_fourcc);
+int ipu_cpmem_set_image(struct ipuv3_channel *ch, struct ipu_image *image);
+
+/* Channel linking functions */
 int ipu_link_prp_enc_rot_enc(struct ipu_soc *ipu);
 int ipu_unlink_prp_enc_rot_enc(struct ipu_soc *ipu);
 int ipu_link_prpvf_rot_prpvf(struct ipu_soc *ipu);
@@ -359,153 +396,6 @@ int ipu_irt_disable(struct ipu_irt *irt);
 struct ipu_irt *ipu_irt_get(struct ipu_soc *ipu);
 void ipu_irt_put(struct ipu_irt *irt);
 
-#define IPU_CPMEM_WORD(word, ofs, size) ((((word) * 160 + (ofs)) << 8) | (size))
-
-#define IPU_FIELD_UBO		IPU_CPMEM_WORD(0, 46, 22)
-#define IPU_FIELD_VBO		IPU_CPMEM_WORD(0, 68, 22)
-#define IPU_FIELD_IOX		IPU_CPMEM_WORD(0, 90, 4)
-#define IPU_FIELD_RDRW		IPU_CPMEM_WORD(0, 94, 1)
-#define IPU_FIELD_SO		IPU_CPMEM_WORD(0, 113, 1)
-#define IPU_FIELD_SLY		IPU_CPMEM_WORD(1, 102, 14)
-#define IPU_FIELD_SLUV		IPU_CPMEM_WORD(1, 128, 14)
-
-#define IPU_FIELD_XV		IPU_CPMEM_WORD(0, 0, 10)
-#define IPU_FIELD_YV		IPU_CPMEM_WORD(0, 10, 9)
-#define IPU_FIELD_XB		IPU_CPMEM_WORD(0, 19, 13)
-#define IPU_FIELD_YB		IPU_CPMEM_WORD(0, 32, 12)
-#define IPU_FIELD_NSB_B		IPU_CPMEM_WORD(0, 44, 1)
-#define IPU_FIELD_CF		IPU_CPMEM_WORD(0, 45, 1)
-#define IPU_FIELD_SX		IPU_CPMEM_WORD(0, 46, 12)
-#define IPU_FIELD_SY		IPU_CPMEM_WORD(0, 58, 11)
-#define IPU_FIELD_NS		IPU_CPMEM_WORD(0, 69, 10)
-#define IPU_FIELD_SDX		IPU_CPMEM_WORD(0, 79, 7)
-#define IPU_FIELD_SM		IPU_CPMEM_WORD(0, 86, 10)
-#define IPU_FIELD_SCC		IPU_CPMEM_WORD(0, 96, 1)
-#define IPU_FIELD_SCE		IPU_CPMEM_WORD(0, 97, 1)
-#define IPU_FIELD_SDY		IPU_CPMEM_WORD(0, 98, 7)
-#define IPU_FIELD_SDRX		IPU_CPMEM_WORD(0, 105, 1)
-#define IPU_FIELD_SDRY		IPU_CPMEM_WORD(0, 106, 1)
-#define IPU_FIELD_BPP		IPU_CPMEM_WORD(0, 107, 3)
-#define IPU_FIELD_DEC_SEL	IPU_CPMEM_WORD(0, 110, 2)
-#define IPU_FIELD_DIM		IPU_CPMEM_WORD(0, 112, 1)
-#define IPU_FIELD_BNDM		IPU_CPMEM_WORD(0, 114, 3)
-#define IPU_FIELD_BM		IPU_CPMEM_WORD(0, 117, 2)
-#define IPU_FIELD_ROT		IPU_CPMEM_WORD(0, 119, 1)
-#define IPU_FIELD_HF		IPU_CPMEM_WORD(0, 120, 1)
-#define IPU_FIELD_VF		IPU_CPMEM_WORD(0, 121, 1)
-#define IPU_FIELD_THE		IPU_CPMEM_WORD(0, 122, 1)
-#define IPU_FIELD_CAP		IPU_CPMEM_WORD(0, 123, 1)
-#define IPU_FIELD_CAE		IPU_CPMEM_WORD(0, 124, 1)
-#define IPU_FIELD_FW		IPU_CPMEM_WORD(0, 125, 13)
-#define IPU_FIELD_FH		IPU_CPMEM_WORD(0, 138, 12)
-#define IPU_FIELD_EBA0		IPU_CPMEM_WORD(1, 0, 29)
-#define IPU_FIELD_EBA1		IPU_CPMEM_WORD(1, 29, 29)
-#define IPU_FIELD_ILO		IPU_CPMEM_WORD(1, 58, 20)
-#define IPU_FIELD_NPB		IPU_CPMEM_WORD(1, 78, 7)
-#define IPU_FIELD_PFS		IPU_CPMEM_WORD(1, 85, 4)
-#define IPU_FIELD_ALU		IPU_CPMEM_WORD(1, 89, 1)
-#define IPU_FIELD_ALBM		IPU_CPMEM_WORD(1, 90, 3)
-#define IPU_FIELD_ID		IPU_CPMEM_WORD(1, 93, 2)
-#define IPU_FIELD_TH		IPU_CPMEM_WORD(1, 95, 7)
-#define IPU_FIELD_SL		IPU_CPMEM_WORD(1, 102, 14)
-#define IPU_FIELD_WID0		IPU_CPMEM_WORD(1, 116, 3)
-#define IPU_FIELD_WID1		IPU_CPMEM_WORD(1, 119, 3)
-#define IPU_FIELD_WID2		IPU_CPMEM_WORD(1, 122, 3)
-#define IPU_FIELD_WID3		IPU_CPMEM_WORD(1, 125, 3)
-#define IPU_FIELD_OFS0		IPU_CPMEM_WORD(1, 128, 5)
-#define IPU_FIELD_OFS1		IPU_CPMEM_WORD(1, 133, 5)
-#define IPU_FIELD_OFS2		IPU_CPMEM_WORD(1, 138, 5)
-#define IPU_FIELD_OFS3		IPU_CPMEM_WORD(1, 143, 5)
-#define IPU_FIELD_SXYS		IPU_CPMEM_WORD(1, 148, 1)
-#define IPU_FIELD_CRE		IPU_CPMEM_WORD(1, 149, 1)
-#define IPU_FIELD_DEC_SEL2	IPU_CPMEM_WORD(1, 150, 1)
-
-struct ipu_cpmem_word {
-	u32 data[5];
-	u32 res[3];
-};
-
-struct ipu_ch_param {
-	struct ipu_cpmem_word word[2];
-};
-
-void ipu_ch_param_write_field(struct ipu_ch_param __iomem *base,
-			      u32 wbs, u32 v);
-u32 ipu_ch_param_read_field(struct ipu_ch_param __iomem *base, u32 wbs);
-struct ipu_ch_param __iomem *ipu_get_cpmem(struct ipuv3_channel *channel);
-void ipu_ch_param_dump(struct ipu_ch_param __iomem *p);
-
-static inline void ipu_ch_param_zero(struct ipu_ch_param __iomem *p)
-{
-	int i;
-	void __iomem *base = p;
-
-	for (i = 0; i < sizeof(*p) / sizeof(u32); i++)
-		writel(0, base + i * sizeof(u32));
-}
-
-static inline void ipu_cpmem_set_buffer(struct ipu_ch_param __iomem *p,
-		int bufnum, dma_addr_t buf)
-{
-	if (bufnum)
-		ipu_ch_param_write_field(p, IPU_FIELD_EBA1, buf >> 3);
-	else
-		ipu_ch_param_write_field(p, IPU_FIELD_EBA0, buf >> 3);
-}
-
-static inline void ipu_cpmem_set_resolution(struct ipu_ch_param __iomem *p,
-		int xres, int yres)
-{
-	ipu_ch_param_write_field(p, IPU_FIELD_FW, xres - 1);
-	ipu_ch_param_write_field(p, IPU_FIELD_FH, yres - 1);
-}
-
-static inline void ipu_cpmem_set_stride(struct ipu_ch_param __iomem *p,
-		int stride)
-{
-	ipu_ch_param_write_field(p, IPU_FIELD_SLY, stride - 1);
-}
-
-void ipu_cpmem_set_high_priority(struct ipuv3_channel *channel);
-
-struct ipu_rgb {
-	struct fb_bitfield	red;
-	struct fb_bitfield	green;
-	struct fb_bitfield	blue;
-	struct fb_bitfield	transp;
-	int			bits_per_pixel;
-};
-
-struct ipu_image {
-	struct v4l2_pix_format pix;
-	struct v4l2_rect rect;
-	dma_addr_t phys;
-};
-
-int ipu_cpmem_set_format_passthrough(struct ipu_ch_param __iomem *p,
-		int width);
-
-int ipu_cpmem_set_format_rgb(struct ipu_ch_param __iomem *,
-		const struct ipu_rgb *rgb);
-
-static inline void ipu_cpmem_interlaced_scan(struct ipu_ch_param *p,
-		int stride)
-{
-	ipu_ch_param_write_field(p, IPU_FIELD_SO, 1);
-	ipu_ch_param_write_field(p, IPU_FIELD_ILO, stride / 8);
-	ipu_ch_param_write_field(p, IPU_FIELD_SLY, (stride * 2) - 1);
-};
-
-void ipu_cpmem_set_yuv_planar(struct ipu_ch_param __iomem *p, u32 pixel_format,
-			int stride, int height);
-void ipu_cpmem_set_yuv_interleaved(struct ipu_ch_param __iomem *p,
-				   u32 pixel_format);
-void ipu_cpmem_set_yuv_planar_full(struct ipu_ch_param __iomem *p,
-		u32 pixel_format, int stride, int u_offset, int v_offset);
-int ipu_cpmem_set_fmt(struct ipu_ch_param __iomem *cpmem, u32 pixelformat);
-int ipu_cpmem_set_image(struct ipu_ch_param __iomem *cpmem,
-		struct ipu_image *image);
-
 enum ipu_color_space ipu_drm_fourcc_to_colorspace(u32 drm_fourcc);
 enum ipu_color_space ipu_pixelformat_to_colorspace(u32 pixelformat);
 enum ipu_color_space ipu_mbus_code_to_colorspace(u32 mbus_code);
@@ -517,12 +407,6 @@ int ipu_degrees_to_rot_mode(enum ipu_rotate_mode *mode, int degrees,
 int ipu_rot_mode_to_degrees(int *degrees, enum ipu_rotate_mode mode,
 			    bool hflip, bool vflip);
 
-static inline void ipu_cpmem_set_burstsize(struct ipu_ch_param __iomem *p,
-		int burstsize)
-{
-	ipu_ch_param_write_field(p, IPU_FIELD_NPB, burstsize - 1);
-};
-
 struct ipu_client_platformdata {
 	int di;
 	int dc;
-- 
1.7.9.5

