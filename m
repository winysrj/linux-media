Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59626 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbbGPQTr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jul 2015 12:19:47 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <kamil@wypas.org>
Cc: linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <philipp.zabel@gmail.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 2/3] [media] coda: add macroblock tiling support
Date: Thu, 16 Jul 2015 18:19:38 +0200
Message-Id: <1437063579-10064-2-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1437063579-10064-1-git-send-email-p.zabel@pengutronix.de>
References: <1437063579-10064-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Philipp Zabel <philipp.zabel@gmail.com>

Storing internal frames in macroblock tiled order improves memory
access patterns by allowing increased burst sizes when transferring
the uncompressed macroblocks to or from main memory.
The translation logic only supports a single chroma base address,
so this is only supported for the chroma interleaved NV12 format.

Since the rotator used to copy the decoder output into the v4l2
capture buffers does not seem to support the tiled format correctly,
only enable it in the encoder for now.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/Makefile      |   2 +-
 drivers/media/platform/coda/coda-bit.c    |  48 +++++++---
 drivers/media/platform/coda/coda-common.c |  74 +++++----------
 drivers/media/platform/coda/coda-gdi.c    | 150 ++++++++++++++++++++++++++++++
 drivers/media/platform/coda/coda.h        |  11 +--
 drivers/media/platform/coda/coda_regs.h   |   6 ++
 6 files changed, 221 insertions(+), 70 deletions(-)
 create mode 100644 drivers/media/platform/coda/coda-gdi.c

diff --git a/drivers/media/platform/coda/Makefile b/drivers/media/platform/coda/Makefile
index 834e504..9342ac5 100644
--- a/drivers/media/platform/coda/Makefile
+++ b/drivers/media/platform/coda/Makefile
@@ -1,5 +1,5 @@
 ccflags-y += -I$(src)
 
-coda-objs := coda-common.o coda-bit.o coda-h264.o coda-jpeg.o
+coda-objs := coda-common.o coda-bit.o coda-gdi.o coda-h264.o coda-jpeg.o
 
 obj-$(CONFIG_VIDEO_CODA) += coda.o
diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 46c7054..3d434a4 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -340,7 +340,6 @@ static int coda_alloc_framebuffers(struct coda_ctx *ctx,
 {
 	struct coda_dev *dev = ctx->dev;
 	int width, height;
-	dma_addr_t paddr;
 	int ysize;
 	int ret;
 	int i;
@@ -360,7 +359,10 @@ static int coda_alloc_framebuffers(struct coda_ctx *ctx,
 		size_t size;
 		char *name;
 
-		size = ysize + ysize / 2;
+		if (ctx->tiled_map_type == GDI_TILED_FRAME_MB_RASTER_MAP)
+			size = round_up(ysize, 4096) + ysize / 2;
+		else
+			size = ysize + ysize / 2;
 		if (ctx->codec->src_fourcc == V4L2_PIX_FMT_H264 &&
 		    dev->devtype->product != CODA_DX6)
 			size += ysize / 4;
@@ -376,11 +378,23 @@ static int coda_alloc_framebuffers(struct coda_ctx *ctx,
 
 	/* Register frame buffers in the parameter buffer */
 	for (i = 0; i < ctx->num_internal_frames; i++) {
-		paddr = ctx->internal_frames[i].paddr;
+		u32 y, cb, cr;
+
 		/* Start addresses of Y, Cb, Cr planes */
-		coda_parabuf_write(ctx, i * 3 + 0, paddr);
-		coda_parabuf_write(ctx, i * 3 + 1, paddr + ysize);
-		coda_parabuf_write(ctx, i * 3 + 2, paddr + ysize + ysize / 4);
+		y = ctx->internal_frames[i].paddr;
+		cb = y + ysize;
+		cr = y + ysize + ysize/4;
+		if (ctx->tiled_map_type == GDI_TILED_FRAME_MB_RASTER_MAP) {
+			cb = round_up(cb, 4096);
+			cr = 0;
+			/* Packed 20-bit MSB of base addresses */
+			/* YYYYYCCC, CCyyyyyc, cccc.... */
+			y = (y & 0xfffff000) | cb >> 20;
+			cb = (cb & 0x000ff000) << 12;
+		}
+		coda_parabuf_write(ctx, i * 3 + 0, y);
+		coda_parabuf_write(ctx, i * 3 + 1, cb);
+		coda_parabuf_write(ctx, i * 3 + 2, cr);
 
 		/* mvcol buffer for h.264 */
 		if (ctx->codec->src_fourcc == V4L2_PIX_FMT_H264 &&
@@ -725,9 +739,15 @@ static void coda9_set_frame_cache(struct coda_ctx *ctx, u32 fourcc)
 {
 	u32 cache_size, cache_config;
 
-	/* Luma 2x0 page, 2x6 cache, chroma 2x0 page, 2x4 cache size */
-	cache_size = 0x20262024;
-	cache_config = 2 << CODA9_CACHE_PAGEMERGE_OFFSET;
+	if (ctx->tiled_map_type == GDI_LINEAR_FRAME_MAP) {
+		/* Luma 2x0 page, 2x6 cache, chroma 2x0 page, 2x4 cache size */
+		cache_size = 0x20262024;
+		cache_config = 2 << CODA9_CACHE_PAGEMERGE_OFFSET;
+	} else {
+		/* Luma 0x2 page, 4x4 cache, chroma 0x2 page, 4x3 cache size */
+		cache_size = 0x02440243;
+		cache_config = 1 << CODA9_CACHE_PAGEMERGE_OFFSET;
+	}
 	coda_write(ctx->dev, cache_size, CODA9_CMD_SET_FRAME_CACHE_SIZE);
 	if (fourcc == V4L2_PIX_FMT_NV12) {
 		cache_config |= 32 << CODA9_CACHE_LUMA_BUFFER_SIZE_OFFSET |
@@ -818,9 +838,12 @@ static int coda_start_encoding(struct coda_ctx *ctx)
 		break;
 	}
 
-	ctx->frame_mem_ctrl &= ~CODA_FRAME_CHROMA_INTERLEAVE;
+	ctx->frame_mem_ctrl &= ~(CODA_FRAME_CHROMA_INTERLEAVE | (0x3 << 9) |
+				 CODA9_FRAME_TILED2LINEAR);
 	if (q_data_src->fourcc == V4L2_PIX_FMT_NV12)
 		ctx->frame_mem_ctrl |= CODA_FRAME_CHROMA_INTERLEAVE;
+	if (ctx->tiled_map_type == GDI_TILED_FRAME_MB_RASTER_MAP)
+		ctx->frame_mem_ctrl |= (0x3 << 9) | CODA9_FRAME_TILED2LINEAR;
 	coda_write(dev, ctx->frame_mem_ctrl, CODA_REG_BIT_FRAME_MEM_CTRL);
 
 	if (dev->devtype->product == CODA_DX6) {
@@ -1497,9 +1520,12 @@ static int __coda_start_decoding(struct coda_ctx *ctx)
 	/* Update coda bitstream read and write pointers from kfifo */
 	coda_kfifo_sync_to_device_full(ctx);
 
-	ctx->frame_mem_ctrl &= ~CODA_FRAME_CHROMA_INTERLEAVE;
+	ctx->frame_mem_ctrl &= ~(CODA_FRAME_CHROMA_INTERLEAVE | (0x3 << 9) |
+				 CODA9_FRAME_TILED2LINEAR);
 	if (dst_fourcc == V4L2_PIX_FMT_NV12)
 		ctx->frame_mem_ctrl |= CODA_FRAME_CHROMA_INTERLEAVE;
+	if (ctx->tiled_map_type == GDI_TILED_FRAME_MB_RASTER_MAP)
+		ctx->frame_mem_ctrl |= (0x3 << 9) | CODA9_FRAME_TILED2LINEAR;
 	coda_write(dev, ctx->frame_mem_ctrl, CODA_REG_BIT_FRAME_MEM_CTRL);
 
 	ctx->display_idx = -1;
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index a7cab14..d62b828 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -62,6 +62,10 @@ int coda_debug;
 module_param(coda_debug, int, 0644);
 MODULE_PARM_DESC(coda_debug, "Debug level (0-2)");
 
+static int disable_tiling;
+module_param(disable_tiling, int, 0644);
+MODULE_PARM_DESC(disable_tiling, "Disable tiled frame buffers");
+
 void coda_write(struct coda_dev *dev, u32 data, u32 reg)
 {
 	v4l2_dbg(2, coda_debug, &dev->v4l2_dev,
@@ -585,6 +589,22 @@ static int coda_s_fmt(struct coda_ctx *ctx, struct v4l2_format *f)
 	q_data->rect.width = f->fmt.pix.width;
 	q_data->rect.height = f->fmt.pix.height;
 
+	switch (f->fmt.pix.pixelformat) {
+	case V4L2_PIX_FMT_NV12:
+		if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
+			ctx->tiled_map_type = GDI_TILED_FRAME_MB_RASTER_MAP;
+			if (!disable_tiling)
+				break;
+		}
+		/* else fall through */
+	case V4L2_PIX_FMT_YUV420:
+	case V4L2_PIX_FMT_YVU420:
+		ctx->tiled_map_type = GDI_LINEAR_FRAME_MAP;
+		break;
+	default:
+		break;
+	}
+
 	v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
 		"Setting format for type %d, wxh: %dx%d, fmt: %d\n",
 		f->type, q_data->width, q_data->height, q_data->fourcc);
@@ -916,27 +936,6 @@ static const struct v4l2_ioctl_ops coda_ioctl_ops = {
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
-void coda_set_gdi_regs(struct coda_ctx *ctx)
-{
-	struct gdi_tiled_map *tiled_map = &ctx->tiled_map;
-	struct coda_dev *dev = ctx->dev;
-	int i;
-
-	for (i = 0; i < 16; i++)
-		coda_write(dev, tiled_map->xy2ca_map[i],
-				CODA9_GDI_XY2_CAS_0 + 4 * i);
-	for (i = 0; i < 4; i++)
-		coda_write(dev, tiled_map->xy2ba_map[i],
-				CODA9_GDI_XY2_BA_0 + 4 * i);
-	for (i = 0; i < 16; i++)
-		coda_write(dev, tiled_map->xy2ra_map[i],
-				CODA9_GDI_XY2_RAS_0 + 4 * i);
-	coda_write(dev, tiled_map->xy2rbc_config, CODA9_GDI_XY2_RBC_CONFIG);
-	for (i = 0; i < 32; i++)
-		coda_write(dev, tiled_map->rbc2axi_map[i],
-				CODA9_GDI_RBC2_AXI_0 + 4 * i);
-}
-
 /*
  * Mem-to-mem operations.
  */
@@ -1084,32 +1083,6 @@ static const struct v4l2_m2m_ops coda_m2m_ops = {
 	.unlock		= coda_unlock,
 };
 
-static void coda_set_tiled_map_type(struct coda_ctx *ctx, int tiled_map_type)
-{
-	struct gdi_tiled_map *tiled_map = &ctx->tiled_map;
-	int luma_map, chro_map, i;
-
-	memset(tiled_map, 0, sizeof(*tiled_map));
-
-	luma_map = 64;
-	chro_map = 64;
-	tiled_map->map_type = tiled_map_type;
-	for (i = 0; i < 16; i++)
-		tiled_map->xy2ca_map[i] = luma_map << 8 | chro_map;
-	for (i = 0; i < 4; i++)
-		tiled_map->xy2ba_map[i] = luma_map << 8 | chro_map;
-	for (i = 0; i < 16; i++)
-		tiled_map->xy2ra_map[i] = luma_map << 8 | chro_map;
-
-	if (tiled_map_type == GDI_LINEAR_FRAME_MAP) {
-		tiled_map->xy2rbc_config = 0;
-	} else {
-		dev_err(&ctx->dev->plat_dev->dev, "invalid map type: %d\n",
-			tiled_map_type);
-		return;
-	}
-}
-
 static void set_default_params(struct coda_ctx *ctx)
 {
 	unsigned int max_w, max_h, usize, csize;
@@ -1148,8 +1121,11 @@ static void set_default_params(struct coda_ctx *ctx)
 	ctx->q_data[V4L2_M2M_DST].rect.width = max_w;
 	ctx->q_data[V4L2_M2M_DST].rect.height = max_h;
 
-	if (ctx->dev->devtype->product == CODA_960)
-		coda_set_tiled_map_type(ctx, GDI_LINEAR_FRAME_MAP);
+	/*
+	 * Since the RBC2AXI logic only supports a single chroma plane,
+	 * macroblock tiling only works for to NV12 pixel format.
+	 */
+	ctx->tiled_map_type = GDI_LINEAR_FRAME_MAP;
 }
 
 /*
diff --git a/drivers/media/platform/coda/coda-gdi.c b/drivers/media/platform/coda/coda-gdi.c
new file mode 100644
index 0000000..aaa7afc
--- /dev/null
+++ b/drivers/media/platform/coda/coda-gdi.c
@@ -0,0 +1,150 @@
+/*
+ * Coda multi-standard codec IP
+ *
+ * Copyright (C) 2014 Philipp Zabel, Pengutronix
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/bitops.h>
+#include "coda.h"
+
+#define XY2_INVERT	BIT(7)
+#define XY2_ZERO	BIT(6)
+#define XY2_TB_XOR	BIT(5)
+#define XY2_XYSEL	BIT(4)
+#define XY2_Y		(1 << 4)
+#define XY2_X		(0 << 4)
+
+#define XY2(luma_sel, luma_bit, chroma_sel, chroma_bit) \
+	(((XY2_##luma_sel) | (luma_bit)) << 8 | \
+	 (XY2_##chroma_sel) | (chroma_bit))
+
+static const u16 xy2ca_zero_map[16] = {
+	XY2(ZERO, 0, ZERO, 0),
+	XY2(ZERO, 0, ZERO, 0),
+	XY2(ZERO, 0, ZERO, 0),
+	XY2(ZERO, 0, ZERO, 0),
+	XY2(ZERO, 0, ZERO, 0),
+	XY2(ZERO, 0, ZERO, 0),
+	XY2(ZERO, 0, ZERO, 0),
+	XY2(ZERO, 0, ZERO, 0),
+	XY2(ZERO, 0, ZERO, 0),
+	XY2(ZERO, 0, ZERO, 0),
+	XY2(ZERO, 0, ZERO, 0),
+	XY2(ZERO, 0, ZERO, 0),
+	XY2(ZERO, 0, ZERO, 0),
+	XY2(ZERO, 0, ZERO, 0),
+	XY2(ZERO, 0, ZERO, 0),
+	XY2(ZERO, 0, ZERO, 0),
+};
+
+static const u16 xy2ca_tiled_map[16] = {
+	XY2(Y,    0, Y,    0),
+	XY2(Y,    1, Y,    1),
+	XY2(Y,    2, Y,    2),
+	XY2(Y,    3, X,    3),
+	XY2(X,    3, ZERO, 0),
+	XY2(ZERO, 0, ZERO, 0),
+	XY2(ZERO, 0, ZERO, 0),
+	XY2(ZERO, 0, ZERO, 0),
+	XY2(ZERO, 0, ZERO, 0),
+	XY2(ZERO, 0, ZERO, 0),
+	XY2(ZERO, 0, ZERO, 0),
+	XY2(ZERO, 0, ZERO, 0),
+	XY2(ZERO, 0, ZERO, 0),
+	XY2(ZERO, 0, ZERO, 0),
+	XY2(ZERO, 0, ZERO, 0),
+	XY2(ZERO, 0, ZERO, 0),
+};
+
+/*
+ * RA[15:0], CA[15:8] are hardwired to contain the 24-bit macroblock
+ * start offset (macroblock size is 16x16 for luma, 16x8 for chroma).
+ * Bits CA[4:0] are set using XY2CA above. BA[3:0] seems to be unused.
+ */
+
+#define RBC_CA		(0 << 4)
+#define RBC_BA		(1 << 4)
+#define RBC_RA		(2 << 4)
+#define RBC_ZERO	(3 << 4)
+
+#define RBC(luma_sel, luma_bit, chroma_sel, chroma_bit) \
+	(((RBC_##luma_sel) | (luma_bit)) << 6 | \
+	 (RBC_##chroma_sel) | (chroma_bit))
+
+static const u16 rbc2axi_tiled_map[32] = {
+	RBC(ZERO, 0, ZERO, 0),
+	RBC(ZERO, 0, ZERO, 0),
+	RBC(ZERO, 0, ZERO, 0),
+	RBC(CA,   0, CA,   0),
+	RBC(CA,   1, CA,   1),
+	RBC(CA,   2, CA,   2),
+	RBC(CA,   3, CA,   3),
+	RBC(CA,   4, CA,   8),
+	RBC(CA,   8, CA,   9),
+	RBC(CA,   9, CA,  10),
+	RBC(CA,  10, CA,  11),
+	RBC(CA,  11, CA,  12),
+	RBC(CA,  12, CA,  13),
+	RBC(CA,  13, CA,  14),
+	RBC(CA,  14, CA,  15),
+	RBC(CA,  15, RA,   0),
+	RBC(RA,   0, RA,   1),
+	RBC(RA,   1, RA,   2),
+	RBC(RA,   2, RA,   3),
+	RBC(RA,   3, RA,   4),
+	RBC(RA,   4, RA,   5),
+	RBC(RA,   5, RA,   6),
+	RBC(RA,   6, RA,   7),
+	RBC(RA,   7, RA,   8),
+	RBC(RA,   8, RA,   9),
+	RBC(RA,   9, RA,  10),
+	RBC(RA,  10, RA,  11),
+	RBC(RA,  11, RA,  12),
+	RBC(RA,  12, RA,  13),
+	RBC(RA,  13, RA,  14),
+	RBC(RA,  14, RA,  15),
+	RBC(RA,  15, ZERO, 0),
+};
+
+void coda_set_gdi_regs(struct coda_ctx *ctx)
+{
+	struct coda_dev *dev = ctx->dev;
+	const u16 *xy2ca_map;
+	u32 xy2rbc_config;
+	int i;
+
+	switch (ctx->tiled_map_type) {
+	case GDI_LINEAR_FRAME_MAP:
+	default:
+		xy2ca_map = xy2ca_zero_map;
+		xy2rbc_config = 0;
+		break;
+	case GDI_TILED_FRAME_MB_RASTER_MAP:
+		xy2ca_map = xy2ca_tiled_map;
+		xy2rbc_config = CODA9_XY2RBC_TILED_MAP |
+				CODA9_XY2RBC_CA_INC_HOR |
+				(16 - 1) << 12 | (8 - 1) << 4;
+		break;
+	}
+
+	for (i = 0; i < 16; i++)
+		coda_write(dev, xy2ca_map[i],
+				CODA9_GDI_XY2_CAS_0 + 4 * i);
+	for (i = 0; i < 4; i++)
+		coda_write(dev, XY2(ZERO, 0, ZERO, 0),
+				CODA9_GDI_XY2_BA_0 + 4 * i);
+	for (i = 0; i < 16; i++)
+		coda_write(dev, XY2(ZERO, 0, ZERO, 0),
+				CODA9_GDI_XY2_RAS_0 + 4 * i);
+	coda_write(dev, xy2rbc_config, CODA9_GDI_XY2_RBC_CONFIG);
+	if (xy2rbc_config) {
+		for (i = 0; i < 32; i++)
+			coda_write(dev, rbc2axi_tiled_map[i],
+					CODA9_GDI_RBC2_AXI_0 + 4 * i);
+	}
+}
diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
index 26c9c4b..59b2af9 100644
--- a/drivers/media/platform/coda/coda.h
+++ b/drivers/media/platform/coda/coda.h
@@ -167,15 +167,8 @@ struct coda_iram_info {
 	phys_addr_t	next_paddr;
 };
 
-struct gdi_tiled_map {
-	int xy2ca_map[16];
-	int xy2ba_map[16];
-	int xy2ra_map[16];
-	int rbc2axi_map[32];
-	int xy2rbc_config;
-	int map_type;
 #define GDI_LINEAR_FRAME_MAP 0
-};
+#define GDI_TILED_FRAME_MB_RASTER_MAP 1
 
 struct coda_ctx;
 
@@ -236,7 +229,7 @@ struct coda_ctx {
 	int				idx;
 	int				reg_idx;
 	struct coda_iram_info		iram_info;
-	struct gdi_tiled_map		tiled_map;
+	int				tiled_map_type;
 	u32				bit_stream_param;
 	u32				frm_dis_flg;
 	u32				frame_mem_ctrl;
diff --git a/drivers/media/platform/coda/coda_regs.h b/drivers/media/platform/coda/coda_regs.h
index 00e4f51..3490602 100644
--- a/drivers/media/platform/coda/coda_regs.h
+++ b/drivers/media/platform/coda/coda_regs.h
@@ -51,6 +51,7 @@
 #define		CODA7_STREAM_SEL_64BITS_ENDIAN	(1 << 1)
 #define		CODA_STREAM_ENDIAN_SELECT	(1 << 0)
 #define CODA_REG_BIT_FRAME_MEM_CTRL		0x110
+#define		CODA9_FRAME_TILED2LINEAR	(1 << 11)
 #define		CODA_FRAME_CHROMA_INTERLEAVE	(1 << 2)
 #define		CODA_IMAGE_ENDIAN_SELECT	(1 << 0)
 #define CODA_REG_BIT_BIT_STREAM_PARAM		0x114
@@ -452,7 +453,12 @@
 #define CODA9_GDI_XY2_RAS_F			(CODA9_GDMA_BASE + 0x88c)
 
 #define CODA9_GDI_XY2_RBC_CONFIG		(CODA9_GDMA_BASE + 0x890)
+#define		CODA9_XY2RBC_SEPARATE_MAP		BIT(19)
+#define		CODA9_XY2RBC_TOP_BOT_SPLIT		BIT(18)
+#define		CODA9_XY2RBC_TILED_MAP			BIT(17)
+#define		CODA9_XY2RBC_CA_INC_HOR			BIT(16)
 #define CODA9_GDI_RBC2_AXI_0			(CODA9_GDMA_BASE + 0x8a0)
 #define CODA9_GDI_RBC2_AXI_1F			(CODA9_GDMA_BASE + 0x91c)
+#define	CODA9_GDI_TILEDBUF_BASE			(CODA9_GDMA_BASE + 0x920)
 
 #endif
-- 
2.1.4

