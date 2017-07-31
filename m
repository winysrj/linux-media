Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36230 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750977AbdGaG7h (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 31 Jul 2017 02:59:37 -0400
From: Jacob Chen <jacob-chen@iotwrt.com>
To: linux-rockchip@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, heiko@sntech.de, robh+dt@kernel.org,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        laurent.pinchart+renesas@ideasonboard.com, hans.verkuil@cisco.com,
        s.nawrocki@samsung.com, tfiga@chromium.org, nicolas@ndufresne.ca,
        Jacob Chen <jacob-chen@iotwrt.com>
Subject: [PATCH v3 2/5] [RESEND] [media]: rockchip/rga: v4l2 m2m support
Date: Mon, 31 Jul 2017 14:59:27 +0800
Message-Id: <1501484367-18689-1-git-send-email-jacob-chen@iotwrt.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rockchip RGA is a separate 2D raster graphic acceleration unit. It
accelerates 2D graphics operations, such as point/line drawing, image
scaling, rotation, BitBLT, alpha blending and image blur/sharpness

The drvier is mostly based on s5p-g2d v4l2 m2m driver
And supports various operations from the rendering pipeline.
 - copy
 - fast solid color fill
 - rotation
 - flip
 - alpha blending

The code in rga-hw.c is used to configure regs accroding to operations
The code in rga-buf.c is used to create (1-Level)mmu table for RGA

Signed-off-by: Jacob Chen <jacob-chen@iotwrt.com>
---
 drivers/media/platform/Kconfig                |  11 +
 drivers/media/platform/Makefile               |   2 +
 drivers/media/platform/rockchip-rga/Makefile  |   3 +
 drivers/media/platform/rockchip-rga/rga-buf.c | 141 ++++
 drivers/media/platform/rockchip-rga/rga-hw.c  | 650 +++++++++++++++++
 drivers/media/platform/rockchip-rga/rga-hw.h  | 437 ++++++++++++
 drivers/media/platform/rockchip-rga/rga.c     | 987 ++++++++++++++++++++++++++
 drivers/media/platform/rockchip-rga/rga.h     | 110 +++
 8 files changed, 2341 insertions(+)
 create mode 100644 drivers/media/platform/rockchip-rga/Makefile
 create mode 100644 drivers/media/platform/rockchip-rga/rga-buf.c
 create mode 100644 drivers/media/platform/rockchip-rga/rga-hw.c
 create mode 100644 drivers/media/platform/rockchip-rga/rga-hw.h
 create mode 100644 drivers/media/platform/rockchip-rga/rga.c
 create mode 100644 drivers/media/platform/rockchip-rga/rga.h

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index c9106e1..8199bcf 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -411,6 +411,17 @@ config VIDEO_RENESAS_VSP1
 	  To compile this driver as a module, choose M here: the module
 	  will be called vsp1.
 
+config VIDEO_ROCKCHIP_RGA
+	tristate "Rockchip Raster 2d Grapphic Acceleration Unit"
+	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
+	depends on ARCH_ROCKCHIP || COMPILE_TEST
+	select VIDEOBUF2_DMA_SG
+	select V4L2_MEM2MEM_DEV
+	default n
+	---help---
+	  This is a v4l2 driver for Rockchip SOC RGA2
+	  2d graphics accelerator.
+
 config VIDEO_TI_VPE
 	tristate "TI VPE (Video Processing Engine) driver"
 	depends on VIDEO_DEV && VIDEO_V4L2
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 349ddf6..3bf096f 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -54,6 +54,8 @@ obj-$(CONFIG_VIDEO_RENESAS_FDP1)	+= rcar_fdp1.o
 obj-$(CONFIG_VIDEO_RENESAS_JPU) 	+= rcar_jpu.o
 obj-$(CONFIG_VIDEO_RENESAS_VSP1)	+= vsp1/
 
+obj-$(CONFIG_VIDEO_ROCKCHIP_RGA)	+= rockchip-rga/
+
 obj-y	+= omap/
 
 obj-$(CONFIG_VIDEO_AM437X_VPFE)		+= am437x/
diff --git a/drivers/media/platform/rockchip-rga/Makefile b/drivers/media/platform/rockchip-rga/Makefile
new file mode 100644
index 0000000..92fe254
--- /dev/null
+++ b/drivers/media/platform/rockchip-rga/Makefile
@@ -0,0 +1,3 @@
+rockchip-rga-objs := rga.o rga-hw.o rga-buf.o
+
+obj-$(CONFIG_VIDEO_ROCKCHIP_RGA) += rockchip-rga.o
diff --git a/drivers/media/platform/rockchip-rga/rga-buf.c b/drivers/media/platform/rockchip-rga/rga-buf.c
new file mode 100644
index 0000000..b4d28e3
--- /dev/null
+++ b/drivers/media/platform/rockchip-rga/rga-buf.c
@@ -0,0 +1,141 @@
+/*
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author: Jacob Chen <jacob-chen@iotwrt.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/pm_runtime.h>
+
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-mem2mem.h>
+#include <media/videobuf2-dma-sg.h>
+#include <media/videobuf2-v4l2.h>
+
+#include "rga-hw.h"
+#include "rga.h"
+
+static int
+rga_queue_setup(struct vb2_queue *vq,
+		unsigned int *nbuffers, unsigned int *nplanes,
+		unsigned int sizes[], struct device *alloc_devs[])
+{
+	struct rga_ctx *ctx = vb2_get_drv_priv(vq);
+	struct rga_frame *f = rga_get_frame(ctx, vq->type);
+
+	if (IS_ERR(f))
+		return PTR_ERR(f);
+
+	sizes[0] = f->size;
+	*nplanes = 1;
+
+	if (*nbuffers == 0)
+		*nbuffers = 1;
+
+	return 0;
+}
+
+static int rga_buf_prepare(struct vb2_buffer *vb)
+{
+	struct rga_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct rga_frame *f = rga_get_frame(ctx, vb->vb2_queue->type);
+
+	if (IS_ERR(f))
+		return PTR_ERR(f);
+
+	vb2_set_plane_payload(vb, 0, f->size);
+
+	return 0;
+}
+
+static void rga_buf_queue(struct vb2_buffer *vb)
+{
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct rga_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+
+	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
+}
+
+static int rga_buf_start_streaming(struct vb2_queue *q, unsigned int count)
+{
+	struct rga_ctx *ctx = vb2_get_drv_priv(q);
+	struct rockchip_rga *rga = ctx->rga;
+	int ret;
+
+	ret = pm_runtime_get_sync(rga->dev);
+	return ret > 0 ? 0 : ret;
+}
+
+static void rga_buf_stop_streaming(struct vb2_queue *q)
+{
+	struct rga_ctx *ctx = vb2_get_drv_priv(q);
+	struct rockchip_rga *rga = ctx->rga;
+	struct vb2_v4l2_buffer *vbuf;
+
+	for (;;) {
+		if (V4L2_TYPE_IS_OUTPUT(q->type))
+			vbuf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
+		else
+			vbuf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
+		if (!vbuf)
+			break;
+		v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_ERROR);
+	}
+
+	pm_runtime_put(rga->dev);
+}
+
+const struct vb2_ops rga_qops = {
+	.queue_setup = rga_queue_setup,
+	.buf_prepare = rga_buf_prepare,
+	.buf_queue = rga_buf_queue,
+	.start_streaming = rga_buf_start_streaming,
+	.stop_streaming = rga_buf_stop_streaming,
+};
+
+/* RGA MMU is a 1-Level MMU, so it can't be used through the IOMMU API.
+ * We use it more like a scatter-gather list.
+ */
+void rga_buf_map(struct vb2_buffer *vb)
+{
+	struct rga_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct rockchip_rga *rga = ctx->rga;
+	struct sg_table *sgt;
+	struct scatterlist *sgl;
+	unsigned int *pages;
+	unsigned int address, len, i, p;
+	unsigned int mapped_size = 0;
+
+	if (vb->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+		pages = rga->src_mmu_pages;
+	else
+		pages = rga->dst_mmu_pages;
+
+	/* Create local MMU table for RGA */
+	sgt = vb2_plane_cookie(vb, 0);
+
+	for_each_sg(sgt->sgl, sgl, sgt->nents, i) {
+		len = sg_dma_len(sgl) >> PAGE_SHIFT;
+		address = sg_phys(sgl);
+
+		for (p = 0; p < len; p++) {
+			dma_addr_t phys = address + (p << PAGE_SHIFT);
+
+			pages[mapped_size + p] = phys;
+		}
+
+		mapped_size += len;
+	}
+
+	/* sync local MMU table for RGA */
+	dma_sync_single_for_device(rga->dev, virt_to_phys(pages),
+				   8 * PAGE_SIZE, DMA_BIDIRECTIONAL);
+}
diff --git a/drivers/media/platform/rockchip-rga/rga-hw.c b/drivers/media/platform/rockchip-rga/rga-hw.c
new file mode 100644
index 0000000..2261c01
--- /dev/null
+++ b/drivers/media/platform/rockchip-rga/rga-hw.c
@@ -0,0 +1,650 @@
+/*
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author: Jacob Chen <jacob-chen@iotwrt.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/pm_runtime.h>
+
+#include "rga-hw.h"
+#include "rga.h"
+
+enum e_rga_start_pos {
+	LT = 0,
+	LB = 1,
+	RT = 2,
+	RB = 3,
+};
+
+struct rga_addr_offset {
+	unsigned int y_off;
+	unsigned int u_off;
+	unsigned int v_off;
+};
+
+struct rga_corners_addr_offset {
+	struct rga_addr_offset left_top;
+	struct rga_addr_offset right_top;
+	struct rga_addr_offset left_bottom;
+	struct rga_addr_offset right_bottom;
+};
+
+static unsigned int rga_get_scaling(unsigned int src, unsigned int dst)
+{
+	/*
+	 * The rga hw scaling factor is a normalized inverse of the scaling factor.
+	 * For example: When source width is 100 and destination width is 200
+	 * (scaling of 2x), then the hw factor is NC * 100 / 200.
+	 * The normalization factor (NC) is 2^16 = 0x10000.
+	 */
+
+	return (src > dst) ? ((dst << 16) / src) : ((src << 16) / dst);
+}
+
+static struct rga_corners_addr_offset
+rga_get_addr_offset(struct rga_frame *frm, unsigned int x, unsigned int y,
+		    unsigned int w, unsigned int h)
+{
+	struct rga_corners_addr_offset offsets;
+	struct rga_addr_offset *lt, *lb, *rt, *rb;
+	unsigned int x_div = 0,
+		     y_div = 0, uv_stride = 0, pixel_width = 0, uv_factor = 0;
+
+	lt = &offsets.left_top;
+	lb = &offsets.left_bottom;
+	rt = &offsets.right_top;
+	rb = &offsets.right_bottom;
+
+	x_div = frm->fmt->x_div;
+	y_div = frm->fmt->y_div;
+	uv_factor = frm->fmt->uv_factor;
+	uv_stride = frm->stride / x_div;
+	pixel_width = frm->stride / frm->width;
+
+	lt->y_off = y * frm->stride + x * pixel_width;
+	lt->u_off =
+		frm->width * frm->height + (y / y_div) * uv_stride + x / x_div;
+	lt->v_off = lt->u_off + frm->width * frm->height / uv_factor;
+
+	lb->y_off = lt->y_off + (h - 1) * frm->stride;
+	lb->u_off = lt->u_off + (h / y_div - 1) * uv_stride;
+	lb->v_off = lt->v_off + (h / y_div - 1) * uv_stride;
+
+	rt->y_off = lt->y_off + (w - 1) * pixel_width;
+	rt->u_off = lt->u_off + w / x_div - 1;
+	rt->v_off = lt->v_off + w / x_div - 1;
+
+	rb->y_off = lb->y_off + (w - 1) * pixel_width;
+	rb->u_off = lb->u_off + w / x_div - 1;
+	rb->v_off = lb->v_off + w / x_div - 1;
+
+	return offsets;
+}
+
+static struct rga_addr_offset *rga_lookup_draw_pos(struct
+		rga_corners_addr_offset
+		* offsets, u32 rotate_mode,
+		u32 mirr_mode)
+{
+	static enum e_rga_start_pos rot_mir_point_matrix[4][4] = {
+		{
+			LT, RT, LB, RB,
+		},
+		{
+			RT, LT, RB, LB,
+		},
+		{
+			RB, LB, RT, LT,
+		},
+		{
+			LB, RB, LT, RT,
+		},
+	};
+
+	if (offsets == NULL)
+		return NULL;
+
+	switch (rot_mir_point_matrix[rotate_mode][mirr_mode]) {
+	case LT:
+		return &offsets->left_top;
+	case LB:
+		return &offsets->left_bottom;
+	case RT:
+		return &offsets->right_top;
+	case RB:
+		return &offsets->right_bottom;
+	}
+
+	return NULL;
+}
+
+static void rga_cmd_set_src_addr(struct rga_ctx *ctx, void *mmu_pages)
+{
+	struct rockchip_rga *rga = ctx->rga;
+	u32 *dest = rga->cmdbuf_virt;
+	unsigned int reg;
+
+	reg = RGA_MMU_SRC_BASE - RGA_MODE_BASE_REG;
+	dest[reg >> 2] = virt_to_phys(mmu_pages) >> 4;
+
+	reg = RGA_MMU_CTRL1 - RGA_MODE_BASE_REG;
+	dest[reg >> 2] |= 0x7;
+}
+
+static void rga_cmd_set_src1_addr(struct rga_ctx *ctx, void *mmu_pages)
+{
+	struct rockchip_rga *rga = ctx->rga;
+	u32 *dest = rga->cmdbuf_virt;
+	unsigned int reg;
+
+	reg = RGA_MMU_SRC1_BASE - RGA_MODE_BASE_REG;
+	dest[reg >> 2] = virt_to_phys(mmu_pages) >> 4;
+
+	reg = RGA_MMU_CTRL1 - RGA_MODE_BASE_REG;
+	dest[reg >> 2] |= 0x7 << 4;
+}
+
+static void rga_cmd_set_dst_addr(struct rga_ctx *ctx, void *mmu_pages)
+{
+	struct rockchip_rga *rga = ctx->rga;
+	u32 *dest = rga->cmdbuf_virt;
+	unsigned int reg;
+
+	reg = RGA_MMU_DST_BASE - RGA_MODE_BASE_REG;
+	dest[reg >> 2] = virt_to_phys(mmu_pages) >> 4;
+
+	reg = RGA_MMU_CTRL1 - RGA_MODE_BASE_REG;
+	dest[reg >> 2] |= 0x7 << 8;
+}
+
+static void rga_cmd_set_trans_info(struct rga_ctx *ctx)
+{
+	struct rockchip_rga *rga = ctx->rga;
+	u32 *dest = rga->cmdbuf_virt;
+	unsigned int scale_dst_w, scale_dst_h;
+	unsigned int src_h, src_w, src_x, src_y, dst_h, dst_w, dst_x, dst_y;
+	union rga_src_info src_info;
+	union rga_dst_info dst_info;
+	union rga_src_x_factor x_factor;
+	union rga_src_y_factor y_factor;
+	union rga_src_vir_info src_vir_info;
+	union rga_src_act_info src_act_info;
+	union rga_dst_vir_info dst_vir_info;
+	union rga_dst_act_info dst_act_info;
+
+	struct rga_addr_offset *dst_offset;
+	struct rga_corners_addr_offset offsets;
+	struct rga_corners_addr_offset src_offsets;
+
+	src_h = ctx->in.crop.height;
+	src_w = ctx->in.crop.width;
+	src_x = ctx->in.crop.left;
+	src_y = ctx->in.crop.top;
+	dst_h = ctx->out.crop.height;
+	dst_w = ctx->out.crop.width;
+	dst_x = ctx->out.crop.left;
+	dst_y = ctx->out.crop.top;
+
+	src_info.val = dest[(RGA_SRC_INFO - RGA_MODE_BASE_REG) >> 2];
+	dst_info.val = dest[(RGA_DST_INFO - RGA_MODE_BASE_REG) >> 2];
+	x_factor.val = dest[(RGA_SRC_X_FACTOR - RGA_MODE_BASE_REG) >> 2];
+	y_factor.val = dest[(RGA_SRC_Y_FACTOR - RGA_MODE_BASE_REG) >> 2];
+	src_vir_info.val = dest[(RGA_SRC_VIR_INFO - RGA_MODE_BASE_REG) >> 2];
+	src_act_info.val = dest[(RGA_SRC_ACT_INFO - RGA_MODE_BASE_REG) >> 2];
+	dst_vir_info.val = dest[(RGA_DST_VIR_INFO - RGA_MODE_BASE_REG) >> 2];
+	dst_act_info.val = dest[(RGA_DST_ACT_INFO - RGA_MODE_BASE_REG) >> 2];
+
+	src_info.data.format = ctx->in.fmt->hw_format;
+	src_info.data.swap = ctx->in.fmt->color_swap;
+	dst_info.data.format = ctx->out.fmt->hw_format;
+	dst_info.data.swap = ctx->out.fmt->color_swap;
+
+	if (ctx->in.fmt->hw_format >= RGA_COLOR_FMT_YUV422SP) {
+		if (ctx->out.fmt->hw_format < RGA_COLOR_FMT_YUV422SP)
+			src_info.data.csc_mode = RGA_SRC_CSC_MODE_BT601_R0;
+	}
+	if (ctx->out.fmt->hw_format >= RGA_COLOR_FMT_YUV422SP)
+		dst_info.data.csc_mode = RGA_DST_CSC_MODE_BT601_R0;
+
+	if (ctx->op == V4L2_PORTER_DUFF_CLEAR) {
+
+		/*
+		 * Configure the target color to foreground color.
+		 */
+		dest[(RGA_SRC_FG_COLOR - RGA_MODE_BASE_REG) >> 2] =
+			ctx->fill_color;
+		dst_vir_info.data.vir_stride = ctx->out.stride >> 2;
+		dst_act_info.data.act_height = dst_h - 1;
+		dst_act_info.data.act_width = dst_w - 1;
+
+		offsets =
+			rga_get_addr_offset(&ctx->out, dst_x, dst_y, dst_w, dst_h);
+		dst_offset = &offsets.left_top;
+
+		goto write_dst;
+	}
+
+	if (ctx->vflip)
+		src_info.data.mir_mode |= RGA_SRC_MIRR_MODE_X;
+
+	if (ctx->hflip)
+		src_info.data.mir_mode |= RGA_SRC_MIRR_MODE_Y;
+
+	switch (ctx->rotate) {
+	case 90:
+		src_info.data.rot_mode = RGA_SRC_ROT_MODE_90_DEGREE;
+		break;
+	case 180:
+		src_info.data.rot_mode = RGA_SRC_ROT_MODE_180_DEGREE;
+		break;
+	case 270:
+		src_info.data.rot_mode = RGA_SRC_ROT_MODE_270_DEGREE;
+		break;
+	default:
+		src_info.data.rot_mode = RGA_SRC_ROT_MODE_0_DEGREE;
+		break;
+	}
+
+	/*
+	 * Cacluate the up/down scaling mode/factor.
+	 *
+	 * RGA used to scale the picture first, and then rotate second,
+	 * so we need to swap the w/h when rotate degree is 90/270.
+	 */
+	if (src_info.data.rot_mode == RGA_SRC_ROT_MODE_90_DEGREE
+	    || src_info.data.rot_mode == RGA_SRC_ROT_MODE_270_DEGREE) {
+		if (rga->version.major == 0 || rga->version.minor == 0) {
+			if (dst_w == src_h)
+				src_h -= 8;
+			if (abs(src_w - dst_h) < 16)
+				src_w -= 16;
+		}
+
+		scale_dst_h = dst_w;
+		scale_dst_w = dst_h;
+	} else {
+		scale_dst_w = dst_w;
+		scale_dst_h = dst_h;
+	}
+
+	if (src_w == scale_dst_w) {
+		src_info.data.hscl_mode = RGA_SRC_HSCL_MODE_NO;
+		x_factor.val = 0;
+	} else if (src_w > scale_dst_w) {
+		src_info.data.hscl_mode = RGA_SRC_HSCL_MODE_DOWN;
+		x_factor.data.down_scale_factor =
+			rga_get_scaling(src_w, scale_dst_w) + 1;
+	} else {
+		src_info.data.hscl_mode = RGA_SRC_HSCL_MODE_UP;
+		x_factor.data.up_scale_factor =
+			rga_get_scaling(src_w - 1, scale_dst_w - 1);
+	}
+
+	if (src_h == scale_dst_h) {
+		src_info.data.vscl_mode = RGA_SRC_VSCL_MODE_NO;
+		y_factor.val = 0;
+	} else if (src_h > scale_dst_h) {
+		src_info.data.vscl_mode = RGA_SRC_VSCL_MODE_DOWN;
+		y_factor.data.down_scale_factor =
+			rga_get_scaling(src_h, scale_dst_h) + 1;
+	} else {
+		src_info.data.vscl_mode = RGA_SRC_VSCL_MODE_UP;
+		y_factor.data.up_scale_factor =
+			rga_get_scaling(src_h - 1, scale_dst_h - 1);
+	}
+
+	/*
+	 * Cacluate the framebuffer virtual strides and active size,
+	 * note that the step of vir_stride / vir_width is 4 byte words
+	 */
+	src_vir_info.data.vir_stride = ctx->in.stride >> 2;
+	src_vir_info.data.vir_width = ctx->in.stride >> 2;
+
+	src_act_info.data.act_height = src_h - 1;
+	src_act_info.data.act_width = src_w - 1;
+
+	dst_vir_info.data.vir_stride = ctx->out.stride >> 2;
+	dst_act_info.data.act_height = dst_h - 1;
+	dst_act_info.data.act_width = dst_w - 1;
+
+	/*
+	 * Cacluate the source framebuffer base address with offset pixel.
+	 */
+	src_offsets = rga_get_addr_offset(&ctx->in, src_x, src_y, src_w, src_h);
+
+	/*
+	 * Configure the dest framebuffer base address with pixel offset.
+	 */
+	offsets = rga_get_addr_offset(&ctx->out, dst_x, dst_y, dst_w, dst_h);
+	dst_offset = rga_lookup_draw_pos(&offsets, src_info.data.rot_mode,
+					 src_info.data.mir_mode);
+
+	dest[(RGA_SRC_Y_RGB_BASE_ADDR - RGA_MODE_BASE_REG) >> 2] =
+		src_offsets.left_top.y_off;
+	dest[(RGA_SRC_CB_BASE_ADDR - RGA_MODE_BASE_REG) >> 2] =
+		src_offsets.left_top.u_off;
+	dest[(RGA_SRC_CR_BASE_ADDR - RGA_MODE_BASE_REG) >> 2] =
+		src_offsets.left_top.v_off;
+
+	dest[(RGA_SRC_X_FACTOR - RGA_MODE_BASE_REG) >> 2] = x_factor.val;
+	dest[(RGA_SRC_Y_FACTOR - RGA_MODE_BASE_REG) >> 2] = y_factor.val;
+	dest[(RGA_SRC_VIR_INFO - RGA_MODE_BASE_REG) >> 2] = src_vir_info.val;
+	dest[(RGA_SRC_ACT_INFO - RGA_MODE_BASE_REG) >> 2] = src_act_info.val;
+
+	dest[(RGA_SRC_INFO - RGA_MODE_BASE_REG) >> 2] = src_info.val;
+
+write_dst:
+	dest[(RGA_DST_Y_RGB_BASE_ADDR - RGA_MODE_BASE_REG) >> 2] =
+		dst_offset->y_off;
+	dest[(RGA_DST_CB_BASE_ADDR - RGA_MODE_BASE_REG) >> 2] =
+		dst_offset->u_off;
+	dest[(RGA_DST_CR_BASE_ADDR - RGA_MODE_BASE_REG) >> 2] =
+		dst_offset->v_off;
+
+	dest[(RGA_DST_VIR_INFO - RGA_MODE_BASE_REG) >> 2] = dst_vir_info.val;
+	dest[(RGA_DST_ACT_INFO - RGA_MODE_BASE_REG) >> 2] = dst_act_info.val;
+
+	dest[(RGA_DST_INFO - RGA_MODE_BASE_REG) >> 2] = dst_info.val;
+}
+
+static void rga_cmd_set_mode(struct rga_ctx *ctx)
+{
+	struct rockchip_rga *rga = ctx->rga;
+	u32 *dest = rga->cmdbuf_virt;
+	union rga_mode_ctrl mode;
+	union rga_alpha_ctrl0 alpha_ctrl0;
+	union rga_alpha_ctrl1 alpha_ctrl1;
+
+	mode.val = 0;
+	alpha_ctrl0.val = 0;
+	alpha_ctrl1.val = 0;
+
+	switch (ctx->op) {
+	case V4L2_PORTER_DUFF_CLEAR:
+		mode.data.gradient_sat = 1;
+		mode.data.render = RGA_MODE_RENDER_RECTANGLE_FILL;
+		mode.data.cf_rop4_pat = RGA_MODE_CF_ROP4_SOLID;
+		mode.data.bitblt = RGA_MODE_BITBLT_MODE_SRC_TO_DST;
+		break;
+	case V4L2_PORTER_DUFF_DST:
+	case V4L2_PORTER_DUFF_DSTATOP:
+	case V4L2_PORTER_DUFF_DSTIN:
+	case V4L2_PORTER_DUFF_DSTOUT:
+	case V4L2_PORTER_DUFF_DSTOVER:
+	case V4L2_PORTER_DUFF_SRCATOP:
+	case V4L2_PORTER_DUFF_SRCIN:
+	case V4L2_PORTER_DUFF_SRCOUT:
+	case V4L2_PORTER_DUFF_SRCOVER:
+		mode.data.gradient_sat = 1;
+		mode.data.render = RGA_MODE_RENDER_BITBLT;
+		mode.data.bitblt = RGA_MODE_BITBLT_MODE_SRC_TO_DST;
+
+		alpha_ctrl0.data.rop_en = 1;
+		alpha_ctrl0.data.rop_mode = RGA_ALPHA_ROP_MODE_3;
+		alpha_ctrl0.data.rop_select = RGA_ALPHA_SELECT_ALPHA;
+
+		alpha_ctrl1.data.dst_alpha_cal_m0 = RGA_ALPHA_CAL_NORMAL;
+		alpha_ctrl1.data.src_alpha_cal_m0 = RGA_ALPHA_CAL_NORMAL;
+		alpha_ctrl1.data.dst_alpha_cal_m1 = RGA_ALPHA_CAL_NORMAL;
+		alpha_ctrl1.data.src_alpha_cal_m1 = RGA_ALPHA_CAL_NORMAL;
+		break;
+	default:
+		mode.data.gradient_sat = 1;
+		mode.data.render = RGA_MODE_RENDER_BITBLT;
+		mode.data.bitblt = RGA_MODE_BITBLT_MODE_SRC_TO_DST;
+		break;
+	}
+
+	switch (ctx->op) {
+	case V4L2_PORTER_DUFF_DST:
+		/* A=Dst.a */
+		alpha_ctrl1.data.src_factor_m1 = RGA_ALPHA_FACTOR_ZERO;
+
+		alpha_ctrl1.data.dst_alpha_m1 = RGA_ALPHA_NORMAL;
+		alpha_ctrl1.data.dst_blend_m1 = RGA_ALPHA_BLEND_NORMAL;
+		alpha_ctrl1.data.dst_factor_m1 = RGA_ALPHA_FACTOR_ONE;
+
+		/* C=Dst.c */
+		alpha_ctrl1.data.src_factor_m0 = RGA_ALPHA_FACTOR_ZERO;
+
+		alpha_ctrl1.data.dst_color_m0 = RGA_ALPHA_COLOR_NORMAL;
+		alpha_ctrl1.data.dst_alpha_m0 = RGA_ALPHA_NORMAL;
+		alpha_ctrl1.data.dst_blend_m0 = RGA_ALPHA_BLEND_NORMAL;
+		alpha_ctrl1.data.dst_factor_m0 = RGA_ALPHA_FACTOR_ONE;
+		break;
+	case V4L2_PORTER_DUFF_DSTATOP:
+		/* A=Src.a */
+		alpha_ctrl1.data.src_alpha_m1 = RGA_ALPHA_NORMAL;
+		alpha_ctrl1.data.src_blend_m1 = RGA_ALPHA_BLEND_NORMAL;
+		alpha_ctrl1.data.src_factor_m1 = RGA_ALPHA_FACTOR_ONE;
+
+		alpha_ctrl1.data.dst_factor_m1 = RGA_ALPHA_FACTOR_ZERO;
+
+		/* C=Src.a*Dst.c+Src.c*(1.0-Dst.a) */
+		alpha_ctrl1.data.src_color_m0 = RGA_ALPHA_COLOR_NORMAL;
+		alpha_ctrl1.data.src_alpha_m0 = RGA_ALPHA_NORMAL;
+		alpha_ctrl1.data.src_blend_m0 = RGA_ALPHA_BLEND_NORMAL;
+		alpha_ctrl1.data.src_factor_m0 = RGA_ALPHA_FACTOR_OTHER_REVERSE;
+
+		alpha_ctrl1.data.dst_color_m0 = RGA_ALPHA_COLOR_NORMAL;
+		alpha_ctrl1.data.dst_alpha_m0 = RGA_ALPHA_NORMAL;
+		alpha_ctrl1.data.dst_blend_m0 = RGA_ALPHA_BLEND_NORMAL;
+		alpha_ctrl1.data.dst_factor_m0 = RGA_ALPHA_FACTOR_OTHER;
+		break;
+	case V4L2_PORTER_DUFF_DSTIN:
+		/* A=Dst.a*Src.a */
+		alpha_ctrl1.data.src_alpha_m1 = RGA_ALPHA_NORMAL;
+		alpha_ctrl1.data.src_blend_m1 = RGA_ALPHA_BLEND_NORMAL;
+		alpha_ctrl1.data.src_factor_m1 = RGA_ALPHA_FACTOR_ZERO;
+
+		alpha_ctrl1.data.dst_alpha_m1 = RGA_ALPHA_NORMAL;
+		alpha_ctrl1.data.dst_blend_m1 = RGA_ALPHA_BLEND_NORMAL;
+		alpha_ctrl1.data.dst_factor_m1 = RGA_ALPHA_FACTOR_OTHER;
+
+		/* C=Dst.c*Src.a */
+		alpha_ctrl1.data.src_color_m0 = RGA_ALPHA_COLOR_NORMAL;
+		alpha_ctrl1.data.src_alpha_m0 = RGA_ALPHA_NORMAL;
+		alpha_ctrl1.data.src_blend_m0 = RGA_ALPHA_BLEND_NORMAL;
+		alpha_ctrl1.data.src_factor_m0 = RGA_ALPHA_FACTOR_ZERO;
+
+		alpha_ctrl1.data.dst_color_m0 = RGA_ALPHA_COLOR_NORMAL;
+		alpha_ctrl1.data.dst_alpha_m0 = RGA_ALPHA_NORMAL;
+		alpha_ctrl1.data.dst_blend_m0 = RGA_ALPHA_BLEND_NORMAL;
+		alpha_ctrl1.data.dst_factor_m0 = RGA_ALPHA_FACTOR_OTHER;
+		break;
+	case V4L2_PORTER_DUFF_DSTOUT:
+		/* A=Dst.a*(1.0-Src.a) */
+		alpha_ctrl1.data.src_alpha_m1 = RGA_ALPHA_NORMAL;
+		alpha_ctrl1.data.src_blend_m1 = RGA_ALPHA_BLEND_NORMAL;
+		alpha_ctrl1.data.src_factor_m1 = RGA_ALPHA_FACTOR_ZERO;
+
+		alpha_ctrl1.data.dst_alpha_m1 = RGA_ALPHA_NORMAL;
+		alpha_ctrl1.data.dst_blend_m1 = RGA_ALPHA_BLEND_NORMAL;
+		alpha_ctrl1.data.dst_factor_m1 = RGA_ALPHA_FACTOR_OTHER_REVERSE;
+
+		/* C=Dst.c*(1.0-Src.a) */
+		alpha_ctrl1.data.src_color_m0 = RGA_ALPHA_COLOR_NORMAL;
+		alpha_ctrl1.data.src_alpha_m0 = RGA_ALPHA_NORMAL;
+		alpha_ctrl1.data.src_blend_m0 = RGA_ALPHA_BLEND_NORMAL;
+		alpha_ctrl1.data.src_factor_m0 = RGA_ALPHA_FACTOR_ZERO;
+
+		alpha_ctrl1.data.dst_color_m0 = RGA_ALPHA_COLOR_NORMAL;
+		alpha_ctrl1.data.dst_alpha_m0 = RGA_ALPHA_NORMAL;
+		alpha_ctrl1.data.dst_blend_m0 = RGA_ALPHA_BLEND_NORMAL;
+		alpha_ctrl1.data.dst_factor_m0 = RGA_ALPHA_FACTOR_OTHER_REVERSE;
+		break;
+	case V4L2_PORTER_DUFF_DSTOVER:
+		/* A=Src.a+Dst.a*(1.0-Src.a) */
+		alpha_ctrl1.data.src_alpha_m1 = RGA_ALPHA_NORMAL;
+		alpha_ctrl1.data.src_blend_m1 = RGA_ALPHA_BLEND_NORMAL;
+		alpha_ctrl1.data.src_factor_m1 = RGA_ALPHA_FACTOR_ONE;
+
+		alpha_ctrl1.data.dst_alpha_m1 = RGA_ALPHA_NORMAL;
+		alpha_ctrl1.data.dst_blend_m1 = RGA_ALPHA_BLEND_NORMAL;
+		alpha_ctrl1.data.dst_factor_m1 = RGA_ALPHA_FACTOR_OTHER_REVERSE;
+
+		/* C=Dst.c+Src.c*(1.0-Dst.a) */
+		alpha_ctrl1.data.src_color_m0 = RGA_ALPHA_COLOR_NORMAL;
+		alpha_ctrl1.data.src_alpha_m0 = RGA_ALPHA_NORMAL;
+		alpha_ctrl1.data.src_blend_m0 = RGA_ALPHA_BLEND_NORMAL;
+		alpha_ctrl1.data.src_factor_m0 = RGA_ALPHA_FACTOR_OTHER_REVERSE;
+
+		alpha_ctrl1.data.dst_color_m0 = RGA_ALPHA_COLOR_NORMAL;
+		alpha_ctrl1.data.dst_alpha_m0 = RGA_ALPHA_NORMAL;
+		alpha_ctrl1.data.dst_blend_m0 = RGA_ALPHA_BLEND_NORMAL;
+		alpha_ctrl1.data.dst_factor_m0 = RGA_ALPHA_FACTOR_ONE;
+		break;
+	case V4L2_PORTER_DUFF_SRCATOP:
+		/* A=Dst.a */
+		alpha_ctrl1.data.src_factor_m1 = RGA_ALPHA_FACTOR_ZERO;
+
+		alpha_ctrl1.data.dst_alpha_m1 = RGA_ALPHA_NORMAL;
+		alpha_ctrl1.data.dst_blend_m1 = RGA_ALPHA_BLEND_NORMAL;
+		alpha_ctrl1.data.dst_factor_m1 = RGA_ALPHA_FACTOR_ONE;
+
+		/* C=Dst.a*Src.c+Dst.c*(1.0-Src.a) */
+		alpha_ctrl1.data.src_color_m0 = RGA_ALPHA_COLOR_NORMAL;
+		alpha_ctrl1.data.src_alpha_m0 = RGA_ALPHA_NORMAL;
+		alpha_ctrl1.data.src_blend_m0 = RGA_ALPHA_BLEND_NORMAL;
+		alpha_ctrl1.data.src_factor_m0 = RGA_ALPHA_FACTOR_OTHER;
+
+		alpha_ctrl1.data.dst_color_m0 = RGA_ALPHA_COLOR_NORMAL;
+		alpha_ctrl1.data.dst_alpha_m0 = RGA_ALPHA_NORMAL;
+		alpha_ctrl1.data.dst_blend_m0 = RGA_ALPHA_BLEND_NORMAL;
+		alpha_ctrl1.data.dst_factor_m0 = RGA_ALPHA_FACTOR_OTHER_REVERSE;
+		break;
+	case V4L2_PORTER_DUFF_SRCIN:
+		/* A=Src.a*Dst.a */
+		alpha_ctrl1.data.src_alpha_m1 = RGA_ALPHA_NORMAL;
+		alpha_ctrl1.data.src_blend_m1 = RGA_ALPHA_BLEND_NORMAL;
+		alpha_ctrl1.data.src_factor_m1 = RGA_ALPHA_FACTOR_ZERO;
+
+		alpha_ctrl1.data.dst_alpha_m1 = RGA_ALPHA_NORMAL;
+		alpha_ctrl1.data.dst_blend_m1 = RGA_ALPHA_BLEND_NORMAL;
+		alpha_ctrl1.data.dst_factor_m1 = RGA_ALPHA_FACTOR_OTHER;
+
+		/* C=Src.c*Dst.a */
+		alpha_ctrl1.data.src_color_m0 = RGA_ALPHA_COLOR_NORMAL;
+		alpha_ctrl1.data.src_alpha_m0 = RGA_ALPHA_NORMAL;
+		alpha_ctrl1.data.src_blend_m0 = RGA_ALPHA_BLEND_NORMAL;
+		alpha_ctrl1.data.src_factor_m0 = RGA_ALPHA_FACTOR_OTHER;
+
+		alpha_ctrl1.data.dst_color_m0 = RGA_ALPHA_COLOR_NORMAL;
+		alpha_ctrl1.data.dst_alpha_m0 = RGA_ALPHA_NORMAL;
+		alpha_ctrl1.data.dst_blend_m0 = RGA_ALPHA_BLEND_NORMAL;
+		alpha_ctrl1.data.dst_factor_m0 = RGA_ALPHA_FACTOR_ZERO;
+		break;
+	case V4L2_PORTER_DUFF_SRCOUT:
+		/* A=Src.a*(1.0-Dst.a) */
+		alpha_ctrl1.data.src_alpha_m1 = RGA_ALPHA_NORMAL;
+		alpha_ctrl1.data.src_blend_m1 = RGA_ALPHA_BLEND_NORMAL;
+		alpha_ctrl1.data.src_factor_m1 = RGA_ALPHA_FACTOR_OTHER_REVERSE;
+
+		alpha_ctrl1.data.dst_alpha_m1 = RGA_ALPHA_NORMAL;
+		alpha_ctrl1.data.dst_blend_m1 = RGA_ALPHA_BLEND_NORMAL;
+		alpha_ctrl1.data.dst_factor_m1 = RGA_ALPHA_FACTOR_ZERO;
+
+		/* C=Src.c*(1.0-Dst.a) */
+		alpha_ctrl1.data.src_color_m0 = RGA_ALPHA_COLOR_NORMAL;
+		alpha_ctrl1.data.src_alpha_m0 = RGA_ALPHA_NORMAL;
+		alpha_ctrl1.data.src_blend_m0 = RGA_ALPHA_BLEND_NORMAL;
+		alpha_ctrl1.data.src_factor_m0 = RGA_ALPHA_FACTOR_OTHER_REVERSE;
+
+		alpha_ctrl1.data.dst_color_m0 = RGA_ALPHA_COLOR_NORMAL;
+		alpha_ctrl1.data.dst_alpha_m0 = RGA_ALPHA_NORMAL;
+		alpha_ctrl1.data.dst_blend_m0 = RGA_ALPHA_BLEND_NORMAL;
+		alpha_ctrl1.data.dst_factor_m0 = RGA_ALPHA_FACTOR_ZERO;
+		break;
+	case V4L2_PORTER_DUFF_SRCOVER:
+		/* A=Src.a+Dst.a*(1.0-Src.a) */
+		alpha_ctrl1.data.src_alpha_m1 = RGA_ALPHA_NORMAL;
+		alpha_ctrl1.data.src_blend_m1 = RGA_ALPHA_BLEND_NORMAL;
+		alpha_ctrl1.data.src_factor_m1 = RGA_ALPHA_FACTOR_ONE;
+
+		alpha_ctrl1.data.dst_alpha_m1 = RGA_ALPHA_NORMAL;
+		alpha_ctrl1.data.dst_blend_m1 = RGA_ALPHA_BLEND_NORMAL;
+		alpha_ctrl1.data.dst_factor_m1 = RGA_ALPHA_FACTOR_OTHER_REVERSE;
+
+		/* C=Src.c+Dst.c*(1.0-Src.a) */
+		alpha_ctrl1.data.src_color_m0 = RGA_ALPHA_COLOR_NORMAL;
+		alpha_ctrl1.data.src_alpha_m0 = RGA_ALPHA_NORMAL;
+		alpha_ctrl1.data.src_blend_m0 = RGA_ALPHA_BLEND_NORMAL;
+		alpha_ctrl1.data.src_factor_m0 = RGA_ALPHA_FACTOR_ONE;
+
+		alpha_ctrl1.data.dst_color_m0 = RGA_ALPHA_COLOR_NORMAL;
+		alpha_ctrl1.data.dst_alpha_m0 = RGA_ALPHA_NORMAL;
+		alpha_ctrl1.data.dst_blend_m0 = RGA_ALPHA_BLEND_NORMAL;
+		alpha_ctrl1.data.dst_factor_m0 = RGA_ALPHA_FACTOR_OTHER_REVERSE;
+		break;
+	default:
+		break;
+	}
+
+	dest[(RGA_ALPHA_CTRL0 - RGA_MODE_BASE_REG) >> 2] = alpha_ctrl0.val;
+	dest[(RGA_ALPHA_CTRL1 - RGA_MODE_BASE_REG) >> 2] = alpha_ctrl1.val;
+
+	dest[(RGA_MODE_CTRL - RGA_MODE_BASE_REG) >> 2] = mode.val;
+}
+
+void rga_cmd_set(struct rga_ctx *ctx)
+{
+	struct rockchip_rga *rga = ctx->rga;
+
+	memset(rga->cmdbuf_virt, 0, RGA_CMDBUF_SIZE * 4);
+
+	if (ctx->op != V4L2_PORTER_DUFF_CLEAR) {
+		rga_cmd_set_src_addr(ctx, rga->src_mmu_pages);
+		/*
+		 * Due to hardware bug,
+		 * src1 mmu also should be configured when using alpha blending.
+		 */
+		rga_cmd_set_src1_addr(ctx, rga->dst_mmu_pages);
+	}
+	rga_cmd_set_dst_addr(ctx, rga->dst_mmu_pages);
+	rga_cmd_set_mode(ctx);
+
+	rga_cmd_set_trans_info(ctx);
+
+	rga_write(rga, RGA_CMD_BASE, rga->cmdbuf_phy);
+}
+
+void rga_write(struct rockchip_rga *rga, u32 reg, u32 value)
+{
+	writel(value, rga->regs + reg);
+}
+
+u32 rga_read(struct rockchip_rga *rga, u32 reg)
+{
+	return readl(rga->regs + reg);
+}
+
+void rga_mod(struct rockchip_rga *rga, u32 reg, u32 val, u32 mask)
+{
+	u32 temp = rga_read(rga, reg) & ~(mask);
+
+	temp |= val & mask;
+	rga_write(rga, reg, temp);
+}
+
+void rga_start(struct rockchip_rga *rga)
+{
+	/* sync CMD buf for RGA */
+	dma_sync_single_for_device(rga->dev, rga->cmdbuf_phy,
+				   PAGE_SIZE, DMA_BIDIRECTIONAL);
+
+	rga_write(rga, RGA_SYS_CTRL, 0x00);
+
+	rga_write(rga, RGA_SYS_CTRL, 0x22);
+
+	rga_write(rga, RGA_INT, 0x600);
+
+	rga_write(rga, RGA_CMD_CTRL, 0x1);
+}
diff --git a/drivers/media/platform/rockchip-rga/rga-hw.h b/drivers/media/platform/rockchip-rga/rga-hw.h
new file mode 100644
index 0000000..5c6569c
--- /dev/null
+++ b/drivers/media/platform/rockchip-rga/rga-hw.h
@@ -0,0 +1,437 @@
+/*
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author: Jacob Chen <jacob-chen@iotwrt.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#ifndef __RGA_HW_H__
+#define __RGA_HW_H__
+
+#define RGA_CMDBUF_SIZE 0x20
+
+/* Hardware limits */
+#define MAX_WIDTH 8192
+#define MAX_HEIGHT 8192
+
+#define MIN_WIDTH 34
+#define MIN_HEIGHT 34
+
+#define DEFAULT_WIDTH 100
+#define DEFAULT_HEIGHT 100
+
+#define RGA_TIMEOUT 500
+
+/* Registers address */
+#define RGA_SYS_CTRL 0x0000
+#define RGA_CMD_CTRL 0x0004
+#define RGA_CMD_BASE 0x0008
+#define RGA_INT 0x0010
+#define RGA_MMU_CTRL0 0x0014
+#define RGA_VERSION_INFO 0x0028
+
+#define RGA_MODE_BASE_REG 0x0100
+#define RGA_MODE_MAX_REG 0x017C
+
+#define RGA_MODE_CTRL 0x0100
+#define RGA_SRC_INFO 0x0104
+#define RGA_SRC_Y_RGB_BASE_ADDR 0x0108
+#define RGA_SRC_CB_BASE_ADDR 0x010c
+#define RGA_SRC_CR_BASE_ADDR 0x0110
+#define RGA_SRC1_RGB_BASE_ADDR 0x0114
+#define RGA_SRC_VIR_INFO 0x0118
+#define RGA_SRC_ACT_INFO 0x011c
+#define RGA_SRC_X_FACTOR 0x0120
+#define RGA_SRC_Y_FACTOR 0x0124
+#define RGA_SRC_BG_COLOR 0x0128
+#define RGA_SRC_FG_COLOR 0x012c
+#define RGA_SRC_TR_COLOR0 0x0130
+#define RGA_SRC_TR_COLOR1 0x0134
+
+#define RGA_DST_INFO 0x0138
+#define RGA_DST_Y_RGB_BASE_ADDR 0x013c
+#define RGA_DST_CB_BASE_ADDR 0x0140
+#define RGA_DST_CR_BASE_ADDR 0x0144
+#define RGA_DST_VIR_INFO 0x0148
+#define RGA_DST_ACT_INFO 0x014c
+
+#define RGA_ALPHA_CTRL0 0x0150
+#define RGA_ALPHA_CTRL1 0x0154
+#define RGA_FADING_CTRL 0x0158
+#define RGA_PAT_CON 0x015c
+#define RGA_ROP_CON0 0x0160
+#define RGA_ROP_CON1 0x0164
+#define RGA_MASK_BASE 0x0168
+
+#define RGA_MMU_CTRL1 0x016C
+#define RGA_MMU_SRC_BASE 0x0170
+#define RGA_MMU_SRC1_BASE 0x0174
+#define RGA_MMU_DST_BASE 0x0178
+
+/* Registers value */
+#define RGA_MODE_RENDER_BITBLT 0
+#define RGA_MODE_RENDER_COLOR_PALETTE 1
+#define RGA_MODE_RENDER_RECTANGLE_FILL 2
+#define RGA_MODE_RENDER_UPDATE_PALETTE_LUT_RAM 3
+
+#define RGA_MODE_BITBLT_MODE_SRC_TO_DST 0
+#define RGA_MODE_BITBLT_MODE_SRC_SRC1_TO_DST 1
+
+#define RGA_MODE_CF_ROP4_SOLID 0
+#define RGA_MODE_CF_ROP4_PATTERN 1
+
+#define RGA_COLOR_FMT_ABGR8888 0
+#define RGA_COLOR_FMT_XBGR8888 1
+#define RGA_COLOR_FMT_BGR888 2
+#define RGA_COLOR_FMT_BGR565 4
+#define RGA_COLOR_FMT_ABGR1555 5
+#define RGA_COLOR_FMT_ABGR4444 6
+#define RGA_COLOR_FMT_YUV422SP 8
+#define RGA_COLOR_FMT_YUV422P 9
+#define RGA_COLOR_FMT_YUV420SP 10
+#define RGA_COLOR_FMT_YUV420P 11
+/* SRC_COLOR Palette */
+#define RGA_COLOR_FMT_CP_1BPP 12
+#define RGA_COLOR_FMT_CP_2BPP 13
+#define RGA_COLOR_FMT_CP_4BPP 14
+#define RGA_COLOR_FMT_CP_8BPP 15
+#define RGA_COLOR_FMT_MASK 15
+
+#define RGA_COLOR_NONE_SWAP 0
+#define RGA_COLOR_RB_SWAP 1
+#define RGA_COLOR_ALPHA_SWAP 2
+#define RGA_COLOR_UV_SWAP 4
+
+#define RGA_SRC_CSC_MODE_BYPASS 0
+#define RGA_SRC_CSC_MODE_BT601_R0 1
+#define RGA_SRC_CSC_MODE_BT601_R1 2
+#define RGA_SRC_CSC_MODE_BT709_R0 3
+#define RGA_SRC_CSC_MODE_BT709_R1 4
+
+#define RGA_SRC_ROT_MODE_0_DEGREE 0
+#define RGA_SRC_ROT_MODE_90_DEGREE 1
+#define RGA_SRC_ROT_MODE_180_DEGREE 2
+#define RGA_SRC_ROT_MODE_270_DEGREE 3
+
+#define RGA_SRC_MIRR_MODE_NO 0
+#define RGA_SRC_MIRR_MODE_X 1
+#define RGA_SRC_MIRR_MODE_Y 2
+#define RGA_SRC_MIRR_MODE_X_Y 3
+
+#define RGA_SRC_HSCL_MODE_NO 0
+#define RGA_SRC_HSCL_MODE_DOWN 1
+#define RGA_SRC_HSCL_MODE_UP 2
+
+#define RGA_SRC_VSCL_MODE_NO 0
+#define RGA_SRC_VSCL_MODE_DOWN 1
+#define RGA_SRC_VSCL_MODE_UP 2
+
+#define RGA_SRC_TRANS_ENABLE_R 1
+#define RGA_SRC_TRANS_ENABLE_G 2
+#define RGA_SRC_TRANS_ENABLE_B 4
+#define RGA_SRC_TRANS_ENABLE_A 8
+
+#define RGA_SRC_BIC_COE_SELEC_CATROM 0
+#define RGA_SRC_BIC_COE_SELEC_MITCHELL 1
+#define RGA_SRC_BIC_COE_SELEC_HERMITE 2
+#define RGA_SRC_BIC_COE_SELEC_BSPLINE 3
+
+#define RGA_DST_DITHER_MODE_888_TO_666 0
+#define RGA_DST_DITHER_MODE_888_TO_565 1
+#define RGA_DST_DITHER_MODE_888_TO_555 2
+#define RGA_DST_DITHER_MODE_888_TO_444 3
+
+#define RGA_DST_CSC_MODE_BYPASS 0
+#define RGA_DST_CSC_MODE_BT601_R0 1
+#define RGA_DST_CSC_MODE_BT601_R1 2
+#define RGA_DST_CSC_MODE_BT709_R0 3
+
+#define RGA_ALPHA_ROP_MODE_2 0
+#define RGA_ALPHA_ROP_MODE_3 1
+#define RGA_ALPHA_ROP_MODE_4 2
+
+#define RGA_ALPHA_SELECT_ALPHA 0
+#define RGA_ALPHA_SELECT_ROP 1
+
+#define RGA_ALPHA_MASK_BIG_ENDIAN 0
+#define RGA_ALPHA_MASK_LITTLE_ENDIAN 1
+
+#define RGA_ALPHA_NORMAL 0
+#define RGA_ALPHA_REVERSE 1
+
+#define RGA_ALPHA_BLEND_GLOBAL 0
+#define RGA_ALPHA_BLEND_NORMAL 1
+#define RGA_ALPHA_BLEND_MULTIPLY 2
+
+#define RGA_ALPHA_CAL_CUT 0
+#define RGA_ALPHA_CAL_NORMAL 1
+
+#define RGA_ALPHA_FACTOR_ZERO 0
+#define RGA_ALPHA_FACTOR_ONE 1
+#define RGA_ALPHA_FACTOR_OTHER 2
+#define RGA_ALPHA_FACTOR_OTHER_REVERSE 3
+#define RGA_ALPHA_FACTOR_SELF 4
+
+#define RGA_ALPHA_COLOR_NORMAL 0
+#define RGA_ALPHA_COLOR_MULTIPLY_CAL 1
+
+/* Registers union */
+union rga_mode_ctrl {
+	unsigned int val;
+	struct {
+		/* [0:2] */
+		unsigned int render:3;
+		/* [3:6] */
+		unsigned int bitblt:1;
+		unsigned int cf_rop4_pat:1;
+		unsigned int alpha_zero_key:1;
+		unsigned int gradient_sat:1;
+		/* [7:31] */
+		unsigned int reserved:25;
+	} data;
+};
+
+union rga_src_info {
+	unsigned int val;
+	struct {
+		/* [0:3] */
+		unsigned int format:4;
+		/* [4:7] */
+		unsigned int swap:3;
+		unsigned int cp_endian:1;
+		/* [8:17] */
+		unsigned int csc_mode:2;
+		unsigned int rot_mode:2;
+		unsigned int mir_mode:2;
+		unsigned int hscl_mode:2;
+		unsigned int vscl_mode:2;
+		/* [18:22] */
+		unsigned int trans_mode:1;
+		unsigned int trans_enable:4;
+		/* [23:25] */
+		unsigned int dither_up_en:1;
+		unsigned int bic_coe_sel:2;
+		/* [26:31] */
+		unsigned int reserved:6;
+	} data;
+};
+
+union rga_src_vir_info {
+	unsigned int val;
+	struct {
+		/* [0:15] */
+		unsigned int vir_width:15;
+		unsigned int reserved:1;
+		/* [16:25] */
+		unsigned int vir_stride:10;
+		/* [26:31] */
+		unsigned int reserved1:6;
+	} data;
+};
+
+union rga_src_act_info {
+	unsigned int val;
+	struct {
+		/* [0:15] */
+		unsigned int act_width:13;
+		unsigned int reserved:3;
+		/* [16:31] */
+		unsigned int act_height:13;
+		unsigned int reserved1:3;
+	} data;
+};
+
+union rga_src_x_factor {
+	unsigned int val;
+	struct {
+		/* [0:15] */
+		unsigned int down_scale_factor:16;
+		/* [16:31] */
+		unsigned int up_scale_factor:16;
+	} data;
+};
+
+union rga_src_y_factor {
+	unsigned int val;
+	struct {
+		/* [0:15] */
+		unsigned int down_scale_factor:16;
+		/* [16:31] */
+		unsigned int up_scale_factor:16;
+	} data;
+};
+
+/* Alpha / Red / Green / Blue */
+union rga_src_cp_gr_color {
+	unsigned int val;
+	struct {
+		/* [0:15] */
+		unsigned int gradient_x:16;
+		/* [16:31] */
+		unsigned int gradient_y:16;
+	} data;
+};
+
+union rga_src_transparency_color0 {
+	unsigned int val;
+	struct {
+		/* [0:7] */
+		unsigned int trans_rmin:8;
+		/* [8:15] */
+		unsigned int trans_gmin:8;
+		/* [16:23] */
+		unsigned int trans_bmin:8;
+		/* [24:31] */
+		unsigned int trans_amin:8;
+	} data;
+};
+
+union rga_src_transparency_color1 {
+	unsigned int val;
+	struct {
+		/* [0:7] */
+		unsigned int trans_rmax:8;
+		/* [8:15] */
+		unsigned int trans_gmax:8;
+		/* [16:23] */
+		unsigned int trans_bmax:8;
+		/* [24:31] */
+		unsigned int trans_amax:8;
+	} data;
+};
+
+union rga_dst_info {
+	unsigned int val;
+	struct {
+		/* [0:3] */
+		unsigned int format:4;
+		/* [4:6] */
+		unsigned int swap:3;
+		/* [7:9] */
+		unsigned int src1_format:3;
+		/* [10:11] */
+		unsigned int src1_swap:2;
+		/* [12:15] */
+		unsigned int dither_up_en:1;
+		unsigned int dither_down_en:1;
+		unsigned int dither_down_mode:2;
+		/* [16:18] */
+		unsigned int csc_mode:2;
+		unsigned int csc_clip:1;
+		/* [19:31] */
+		unsigned int reserved:13;
+	} data;
+};
+
+union rga_dst_vir_info {
+	unsigned int val;
+	struct {
+		/* [0:15] */
+		unsigned int vir_stride:15;
+		unsigned int reserved:1;
+		/* [16:31] */
+		unsigned int src1_vir_stride:15;
+		unsigned int reserved1:1;
+	} data;
+};
+
+union rga_dst_act_info {
+	unsigned int val;
+	struct {
+		/* [0:15] */
+		unsigned int act_width:12;
+		unsigned int reserved:4;
+		/* [16:31] */
+		unsigned int act_height:12;
+		unsigned int reserved1:4;
+	} data;
+};
+
+union rga_alpha_ctrl0 {
+	unsigned int val;
+	struct {
+		/* [0:3] */
+		unsigned int rop_en:1;
+		unsigned int rop_select:1;
+		unsigned int rop_mode:2;
+		/* [4:11] */
+		unsigned int src_fading_val:8;
+		/* [12:20] */
+		unsigned int dst_fading_val:8;
+		unsigned int mask_endian:1;
+		/* [21:31] */
+		unsigned int reserved:11;
+	} data;
+};
+
+union rga_alpha_ctrl1 {
+	unsigned int val;
+	struct {
+		/* [0:1] */
+		unsigned int dst_color_m0:1;
+		unsigned int src_color_m0:1;
+		/* [2:7] */
+		unsigned int dst_factor_m0:3;
+		unsigned int src_factor_m0:3;
+		/* [8:9] */
+		unsigned int dst_alpha_cal_m0:1;
+		unsigned int src_alpha_cal_m0:1;
+		/* [10:13] */
+		unsigned int dst_blend_m0:2;
+		unsigned int src_blend_m0:2;
+		/* [14:15] */
+		unsigned int dst_alpha_m0:1;
+		unsigned int src_alpha_m0:1;
+		/* [16:21] */
+		unsigned int dst_factor_m1:3;
+		unsigned int src_factor_m1:3;
+		/* [22:23] */
+		unsigned int dst_alpha_cal_m1:1;
+		unsigned int src_alpha_cal_m1:1;
+		/* [24:27] */
+		unsigned int dst_blend_m1:2;
+		unsigned int src_blend_m1:2;
+		/* [28:29] */
+		unsigned int dst_alpha_m1:1;
+		unsigned int src_alpha_m1:1;
+		/* [30:31] */
+		unsigned int reserved:2;
+	} data;
+};
+
+union rga_fading_ctrl {
+	unsigned int val;
+	struct {
+		/* [0:7] */
+		unsigned int fading_offset_r:8;
+		/* [8:15] */
+		unsigned int fading_offset_g:8;
+		/* [16:23] */
+		unsigned int fading_offset_b:8;
+		/* [24:31] */
+		unsigned int fading_en:1;
+		unsigned int reserved:7;
+	} data;
+};
+
+union rga_pat_con {
+	unsigned int val;
+	struct {
+		/* [0:7] */
+		unsigned int width:8;
+		/* [8:15] */
+		unsigned int height:8;
+		/* [16:23] */
+		unsigned int offset_x:8;
+		/* [24:31] */
+		unsigned int offset_y:8;
+	} data;
+};
+
+#endif
diff --git a/drivers/media/platform/rockchip-rga/rga.c b/drivers/media/platform/rockchip-rga/rga.c
new file mode 100644
index 0000000..738e649
--- /dev/null
+++ b/drivers/media/platform/rockchip-rga/rga.c
@@ -0,0 +1,987 @@
+/*
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author: Jacob Chen <jacob-chen@iotwrt.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/clk.h>
+#include <linux/debugfs.h>
+#include <linux/delay.h>
+#include <linux/fs.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/pm_runtime.h>
+#include <linux/reset.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/timer.h>
+
+#include <linux/platform_device.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-mem2mem.h>
+#include <media/videobuf2-dma-sg.h>
+#include <media/videobuf2-v4l2.h>
+
+#include "rga-hw.h"
+#include "rga.h"
+
+static void job_abort(void *prv)
+{
+	struct rga_ctx *ctx = prv;
+	struct rockchip_rga *rga = ctx->rga;
+
+	if (rga->curr == NULL)	/* No job currently running */
+		return;
+
+	wait_event_timeout(rga->irq_queue,
+			   rga->curr == NULL, msecs_to_jiffies(RGA_TIMEOUT));
+}
+
+static void device_run(void *prv)
+{
+	struct rga_ctx *ctx = prv;
+	struct rockchip_rga *rga = ctx->rga;
+	struct vb2_buffer *src, *dst;
+	unsigned long flags;
+
+	spin_lock_irqsave(&rga->ctrl_lock, flags);
+
+	rga->curr = ctx;
+
+	src = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
+	dst = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
+
+	rga_buf_map(src);
+	rga_buf_map(dst);
+
+	rga_cmd_set(ctx);
+
+	rga_start(rga);
+
+	spin_unlock_irqrestore(&rga->ctrl_lock, flags);
+}
+
+static irqreturn_t rga_isr(int irq, void *prv)
+{
+	struct rockchip_rga *rga = prv;
+	int intr;
+
+	intr = rga_read(rga, RGA_INT) & 0xf;
+
+	rga_mod(rga, RGA_INT, intr << 4, 0xf << 4);
+
+	if (intr & 0x04) {
+		struct vb2_v4l2_buffer *src, *dst;
+		struct rga_ctx *ctx = rga->curr;
+
+		BUG_ON(ctx == NULL);
+
+		rga->curr = NULL;
+
+		src = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
+		dst = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
+
+		BUG_ON(src == NULL);
+		BUG_ON(dst == NULL);
+
+		dst->timecode = src->timecode;
+		dst->vb2_buf.timestamp = src->vb2_buf.timestamp;
+		dst->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+		dst->flags |= src->flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+
+		v4l2_m2m_buf_done(src, VB2_BUF_STATE_DONE);
+		v4l2_m2m_buf_done(dst, VB2_BUF_STATE_DONE);
+		v4l2_m2m_job_finish(rga->m2m_dev, ctx->fh.m2m_ctx);
+
+		wake_up(&rga->irq_queue);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static struct v4l2_m2m_ops rga_m2m_ops = {
+	.device_run = device_run,
+	.job_abort = job_abort,
+};
+
+static int
+queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *dst_vq)
+{
+	struct rga_ctx *ctx = priv;
+	int ret;
+
+	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
+	src_vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
+	src_vq->drv_priv = ctx;
+	src_vq->ops = &rga_qops;
+	src_vq->mem_ops = &vb2_dma_sg_memops;
+	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
+	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	src_vq->lock = &ctx->rga->mutex;
+	src_vq->dev = ctx->rga->v4l2_dev.dev;
+
+	ret = vb2_queue_init(src_vq);
+	if (ret)
+		return ret;
+
+	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	dst_vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
+	dst_vq->drv_priv = ctx;
+	dst_vq->ops = &rga_qops;
+	dst_vq->mem_ops = &vb2_dma_sg_memops;
+	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
+	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	dst_vq->lock = &ctx->rga->mutex;
+	dst_vq->dev = ctx->rga->v4l2_dev.dev;
+
+	return vb2_queue_init(dst_vq);
+}
+
+static int rga_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct rga_ctx *ctx = container_of(ctrl->handler, struct rga_ctx,
+					   ctrl_handler);
+	unsigned long flags;
+
+	spin_lock_irqsave(&ctx->rga->ctrl_lock, flags);
+	switch (ctrl->id) {
+	case V4L2_CID_PORTER_DUFF_MODE:
+		ctx->op = ctrl->val;
+		break;
+	case V4L2_CID_HFLIP:
+		ctx->hflip = ctrl->val;
+		break;
+	case V4L2_CID_VFLIP:
+		ctx->vflip = ctrl->val;
+		break;
+	case V4L2_CID_ROTATE:
+		ctx->rotate = ctrl->val;
+		break;
+	case V4L2_CID_BG_COLOR:
+		ctx->fill_color = ctrl->val;
+		break;
+	}
+	spin_unlock_irqrestore(&ctx->rga->ctrl_lock, flags);
+	return 0;
+}
+
+static const struct v4l2_ctrl_ops rga_ctrl_ops = {
+	.s_ctrl = rga_s_ctrl,
+};
+
+static int rga_setup_ctrls(struct rga_ctx *ctx)
+{
+	struct rockchip_rga *rga = ctx->rga;
+
+	v4l2_ctrl_handler_init(&ctx->ctrl_handler, 7);
+
+	v4l2_ctrl_new_std_menu(&ctx->ctrl_handler, &rga_ctrl_ops,
+			       V4L2_CID_PORTER_DUFF_MODE,
+			       V4L2_PORTER_DUFF_CLEAR, 0,
+			       V4L2_PORTER_DUFF_SRC);
+
+	v4l2_ctrl_new_std(&ctx->ctrl_handler, &rga_ctrl_ops,
+			  V4L2_CID_HFLIP, 0, 1, 1, 0);
+
+	v4l2_ctrl_new_std(&ctx->ctrl_handler, &rga_ctrl_ops,
+			  V4L2_CID_VFLIP, 0, 1, 1, 0);
+
+	v4l2_ctrl_new_std(&ctx->ctrl_handler, &rga_ctrl_ops,
+			  V4L2_CID_ROTATE, 0, 270, 90, 0);
+
+	v4l2_ctrl_new_std(&ctx->ctrl_handler, &rga_ctrl_ops,
+			  V4L2_CID_BG_COLOR, 0, 0xffffffff, 1, 0);
+
+	if (ctx->ctrl_handler.error) {
+		int err = ctx->ctrl_handler.error;
+
+		v4l2_err(&rga->v4l2_dev, "%s failed\n", __func__);
+		v4l2_ctrl_handler_free(&ctx->ctrl_handler);
+		return err;
+	}
+
+	return 0;
+}
+
+struct rga_fmt formats[] = {
+	{
+		.name = "ARGB_8888",
+		.fourcc = V4L2_PIX_FMT_ARGB32,
+		.color_swap = RGA_COLOR_RB_SWAP,
+		.hw_format = RGA_COLOR_FMT_ABGR8888,
+		.depth = 32,
+		.uv_factor = 1,
+		.y_div = 1,
+		.x_div = 1,
+	},
+	{
+		.name = "XRGB_8888",
+		.fourcc = V4L2_PIX_FMT_XRGB32,
+		.color_swap = RGA_COLOR_RB_SWAP,
+		.hw_format = RGA_COLOR_FMT_XBGR8888,
+		.depth = 32,
+		.uv_factor = 1,
+		.y_div = 1,
+		.x_div = 1,
+	},
+	{
+		.name = "BGRA_8888",
+		.fourcc = V4L2_PIX_FMT_ABGR32,
+		.color_swap = RGA_COLOR_ALPHA_SWAP,
+		.hw_format = RGA_COLOR_FMT_ABGR8888,
+		.depth = 32,
+		.uv_factor = 1,
+		.y_div = 1,
+		.x_div = 1,
+	},
+	{
+		.name = "BGRX_8888",
+		.fourcc = V4L2_PIX_FMT_XBGR32,
+		.color_swap = RGA_COLOR_ALPHA_SWAP,
+		.hw_format = RGA_COLOR_FMT_XBGR8888,
+		.depth = 32,
+		.uv_factor = 1,
+		.y_div = 1,
+		.x_div = 1,
+	},
+	{
+		.name = "RGB_888",
+		.fourcc = V4L2_PIX_FMT_RGB24,
+		.color_swap = RGA_COLOR_RB_SWAP,
+		.hw_format = RGA_COLOR_FMT_BGR888,
+		.depth = 24,
+		.uv_factor = 1,
+		.y_div = 1,
+		.x_div = 1,
+	},
+	{
+		.name = "ARGB_444",
+		.fourcc = V4L2_PIX_FMT_ARGB444,
+		.color_swap = RGA_COLOR_RB_SWAP,
+		.hw_format = RGA_COLOR_FMT_ABGR4444,
+		.depth = 16,
+		.uv_factor = 1,
+		.y_div = 1,
+		.x_div = 1,
+	},
+	{
+		.name = "ARGB_1555",
+		.fourcc = V4L2_PIX_FMT_ARGB555,
+		.color_swap = RGA_COLOR_RB_SWAP,
+		.hw_format = RGA_COLOR_FMT_ABGR1555,
+		.depth = 16,
+		.uv_factor = 1,
+		.y_div = 1,
+		.x_div = 1,
+	},
+	{
+		.name = "RGB_565",
+		.fourcc = V4L2_PIX_FMT_RGB565,
+		.color_swap = RGA_COLOR_RB_SWAP,
+		.hw_format = RGA_COLOR_FMT_BGR565,
+		.depth = 16,
+		.uv_factor = 1,
+		.y_div = 1,
+		.x_div = 1,
+	},
+	{
+		.name = "NV_21",
+		.fourcc = V4L2_PIX_FMT_NV21,
+		.color_swap = RGA_COLOR_UV_SWAP,
+		.hw_format = RGA_COLOR_FMT_YUV420SP,
+		.depth = 12,
+		.uv_factor = 4,
+		.y_div = 2,
+		.x_div = 1,
+	},
+	{
+		.name = "NV_61",
+		.fourcc = V4L2_PIX_FMT_NV61,
+		.color_swap = RGA_COLOR_UV_SWAP,
+		.hw_format = RGA_COLOR_FMT_YUV422SP,
+		.depth = 16,
+		.uv_factor = 2,
+		.y_div = 1,
+		.x_div = 1,
+	},
+	{
+		.name = "NV_12",
+		.fourcc = V4L2_PIX_FMT_NV12,
+		.color_swap = RGA_COLOR_NONE_SWAP,
+		.hw_format = RGA_COLOR_FMT_YUV420SP,
+		.depth = 12,
+		.uv_factor = 4,
+		.y_div = 2,
+		.x_div = 1,
+	},
+	{
+		.name = "NV_16",
+		.fourcc = V4L2_PIX_FMT_NV16,
+		.color_swap = RGA_COLOR_NONE_SWAP,
+		.hw_format = RGA_COLOR_FMT_YUV422SP,
+		.depth = 16,
+		.uv_factor = 2,
+		.y_div = 1,
+		.x_div = 1,
+	},
+	{
+		.name = "YUV_420",
+		.fourcc = V4L2_PIX_FMT_YUV420,
+		.color_swap = RGA_COLOR_NONE_SWAP,
+		.hw_format = RGA_COLOR_FMT_YUV420P,
+		.depth = 12,
+		.uv_factor = 4,
+		.y_div = 2,
+		.x_div = 2,
+	},
+	{
+		.name = "YUV_422",
+		.fourcc = V4L2_PIX_FMT_YUV422P,
+		.color_swap = RGA_COLOR_NONE_SWAP,
+		.hw_format = RGA_COLOR_FMT_YUV422P,
+		.depth = 16,
+		.uv_factor = 2,
+		.y_div = 1,
+		.x_div = 2,
+	},
+	{
+		.name = "YVU_420",
+		.fourcc = V4L2_PIX_FMT_YVU420,
+		.color_swap = RGA_COLOR_UV_SWAP,
+		.hw_format = RGA_COLOR_FMT_YUV420P,
+		.depth = 12,
+		.uv_factor = 4,
+		.y_div = 2,
+		.x_div = 2,
+	},
+};
+
+#define NUM_FORMATS ARRAY_SIZE(formats)
+
+struct rga_fmt *rga_fmt_find(struct v4l2_format *f)
+{
+	unsigned int i;
+
+	for (i = 0; i < NUM_FORMATS; i++) {
+		if (formats[i].fourcc == f->fmt.pix.pixelformat)
+			return &formats[i];
+	}
+	return NULL;
+}
+
+static struct rga_frame def_frame = {
+	.width = DEFAULT_WIDTH,
+	.height = DEFAULT_HEIGHT,
+	.crop.left = 0,
+	.crop.top = 0,
+	.crop.width = DEFAULT_WIDTH,
+	.crop.height = DEFAULT_HEIGHT,
+	.fmt = &formats[0],
+};
+
+struct rga_frame *rga_get_frame(struct rga_ctx *ctx, enum v4l2_buf_type type)
+{
+	switch (type) {
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
+		return &ctx->in;
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+		return &ctx->out;
+	default:
+		return ERR_PTR(-EINVAL);
+	}
+}
+
+static int rga_open(struct file *file)
+{
+	struct rockchip_rga *rga = video_drvdata(file);
+	struct rga_ctx *ctx = NULL;
+	int ret = 0;
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+	ctx->rga = rga;
+	/* Set default formats */
+	ctx->in = def_frame;
+	ctx->out = def_frame;
+
+	if (mutex_lock_interruptible(&rga->mutex)) {
+		kfree(ctx);
+		return -ERESTARTSYS;
+	}
+	ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(rga->m2m_dev, ctx, &queue_init);
+	if (IS_ERR(ctx->fh.m2m_ctx)) {
+		ret = PTR_ERR(ctx->fh.m2m_ctx);
+		mutex_unlock(&rga->mutex);
+		kfree(ctx);
+		return ret;
+	}
+	v4l2_fh_init(&ctx->fh, video_devdata(file));
+	file->private_data = &ctx->fh;
+	v4l2_fh_add(&ctx->fh);
+
+	rga_setup_ctrls(ctx);
+
+	/* Write the default values to the ctx struct */
+	v4l2_ctrl_handler_setup(&ctx->ctrl_handler);
+
+	ctx->fh.ctrl_handler = &ctx->ctrl_handler;
+	mutex_unlock(&rga->mutex);
+
+	v4l2_info(&rga->v4l2_dev, "instance opened\n");
+	return 0;
+}
+
+static int rga_release(struct file *file)
+{
+	struct rockchip_rga *rga = video_drvdata(file);
+	struct rga_ctx *ctx =
+		container_of(file->private_data, struct rga_ctx, fh);
+
+	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
+
+	v4l2_ctrl_handler_free(&ctx->ctrl_handler);
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
+	kfree(ctx);
+	v4l2_info(&rga->v4l2_dev, "instance closed\n");
+	return 0;
+}
+
+static const struct v4l2_file_operations rga_fops = {
+	.owner = THIS_MODULE,
+	.open = rga_open,
+	.release = rga_release,
+	.poll = v4l2_m2m_fop_poll,
+	.unlocked_ioctl = video_ioctl2,
+	.mmap = v4l2_m2m_fop_mmap,
+};
+
+static int
+vidioc_querycap(struct file *file, void *priv, struct v4l2_capability *cap)
+{
+	strncpy(cap->driver, RGA_NAME, sizeof(cap->driver) - 1);
+	strncpy(cap->card, RGA_NAME, sizeof(cap->card) - 1);
+	cap->bus_info[0] = 0;
+	cap->device_caps = V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
+	return 0;
+}
+
+static int vidioc_enum_fmt(struct file *file, void *prv, struct v4l2_fmtdesc *f)
+{
+	struct rga_fmt *fmt;
+
+	if (f->index >= NUM_FORMATS)
+		return -EINVAL;
+
+	fmt = &formats[f->index];
+	f->pixelformat = fmt->fourcc;
+	strncpy(f->description, fmt->name, sizeof(f->description) - 1);
+	return 0;
+}
+
+static int vidioc_g_fmt(struct file *file, void *prv, struct v4l2_format *f)
+{
+	struct rga_ctx *ctx = prv;
+	struct vb2_queue *vq;
+	struct rga_frame *frm;
+
+	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
+	if (!vq)
+		return -EINVAL;
+	frm = rga_get_frame(ctx, f->type);
+	if (IS_ERR(frm))
+		return PTR_ERR(frm);
+
+	f->fmt.pix.width = frm->width;
+	f->fmt.pix.height = frm->height;
+	f->fmt.pix.field = V4L2_FIELD_NONE;
+	f->fmt.pix.pixelformat = frm->fmt->fourcc;
+	f->fmt.pix.bytesperline = frm->stride;
+	f->fmt.pix.sizeimage = frm->size;
+
+	return 0;
+}
+
+static int vidioc_try_fmt(struct file *file, void *prv, struct v4l2_format *f)
+{
+	struct rga_fmt *fmt;
+	enum v4l2_field *field;
+
+	fmt = rga_fmt_find(f);
+	if (!fmt)
+		return -EINVAL;
+
+	field = &f->fmt.pix.field;
+	if (*field == V4L2_FIELD_ANY)
+		*field = V4L2_FIELD_NONE;
+	else if (*field != V4L2_FIELD_NONE)
+		return -EINVAL;
+
+	if (f->fmt.pix.width > MAX_WIDTH)
+		f->fmt.pix.width = MAX_WIDTH;
+	if (f->fmt.pix.height > MAX_HEIGHT)
+		f->fmt.pix.height = MAX_HEIGHT;
+
+	if (f->fmt.pix.width < MIN_WIDTH)
+		f->fmt.pix.width = MIN_WIDTH;
+	if (f->fmt.pix.height < MIN_HEIGHT)
+		f->fmt.pix.height = MIN_HEIGHT;
+
+	if (fmt->hw_format >= RGA_COLOR_FMT_YUV422SP)
+		f->fmt.pix.bytesperline = f->fmt.pix.width;
+	else
+		f->fmt.pix.bytesperline = (f->fmt.pix.width * fmt->depth) >> 3;
+
+	f->fmt.pix.sizeimage =
+		f->fmt.pix.height * (f->fmt.pix.width * fmt->depth) >> 3;
+
+	return 0;
+}
+
+static int vidioc_s_fmt(struct file *file, void *prv, struct v4l2_format *f)
+{
+	struct rga_ctx *ctx = prv;
+	struct rockchip_rga *rga = ctx->rga;
+	struct vb2_queue *vq;
+	struct rga_frame *frm;
+	struct rga_fmt *fmt;
+	int ret = 0;
+
+	/* Adjust all values accordingly to the hardware capabilities
+	 * and chosen format.
+	 */
+	ret = vidioc_try_fmt(file, prv, f);
+	if (ret)
+		return ret;
+	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
+	if (vb2_is_busy(vq)) {
+		v4l2_err(&rga->v4l2_dev, "queue (%d) bust\n", f->type);
+		return -EBUSY;
+	}
+	frm = rga_get_frame(ctx, f->type);
+	if (IS_ERR(frm))
+		return PTR_ERR(frm);
+	fmt = rga_fmt_find(f);
+	if (!fmt)
+		return -EINVAL;
+	frm->width = f->fmt.pix.width;
+	frm->height = f->fmt.pix.height;
+	frm->size = f->fmt.pix.sizeimage;
+	frm->fmt = fmt;
+	frm->stride = f->fmt.pix.bytesperline;
+
+	/* Reset crop settings */
+	frm->crop.left = 0;
+	frm->crop.top = 0;
+	frm->crop.width = frm->width;
+	frm->crop.height = frm->height;
+	return 0;
+}
+
+static int
+vidioc_cropcap(struct file *file, void *priv, struct v4l2_cropcap *cr)
+{
+	struct rga_ctx *ctx = priv;
+	struct rga_frame *f;
+
+	f = rga_get_frame(ctx, cr->type);
+	if (IS_ERR(f))
+		return PTR_ERR(f);
+
+	cr->bounds.left = 0;
+	cr->bounds.top = 0;
+	cr->bounds.width = f->width;
+	cr->bounds.height = f->height;
+	cr->defrect = cr->bounds;
+	return 0;
+}
+
+static int vidioc_g_crop(struct file *file, void *prv, struct v4l2_crop *cr)
+{
+	struct rga_ctx *ctx = prv;
+	struct rga_frame *f;
+
+	f = rga_get_frame(ctx, cr->type);
+	if (IS_ERR(f))
+		return PTR_ERR(f);
+
+	cr->c = f->crop;
+
+	return 0;
+}
+
+static int
+vidioc_try_crop(struct file *file, void *prv, const struct v4l2_crop *cr)
+{
+	struct rga_ctx *ctx = prv;
+	struct rockchip_rga *rga = ctx->rga;
+	struct rga_frame *f;
+
+	f = rga_get_frame(ctx, cr->type);
+	if (IS_ERR(f))
+		return PTR_ERR(f);
+
+	if (cr->c.top < 0 || cr->c.left < 0) {
+		v4l2_err(&rga->v4l2_dev,
+			 "doesn't support negative values for top & left.\n");
+		return -EINVAL;
+	}
+
+	if (cr->c.left + cr->c.width > f->width ||
+	    cr->c.top + cr->c.height > f->height ||
+	    cr->c.width < MIN_WIDTH || cr->c.height < MIN_HEIGHT) {
+
+		v4l2_err(&rga->v4l2_dev, "unsupport crop value.\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int
+vidioc_s_crop(struct file *file, void *prv, const struct v4l2_crop *cr)
+{
+	struct rga_ctx *ctx = prv;
+	struct rga_frame *f;
+	int ret;
+
+	ret = vidioc_try_crop(file, prv, cr);
+	if (ret)
+		return ret;
+	f = rga_get_frame(ctx, cr->type);
+	if (IS_ERR(f))
+		return PTR_ERR(f);
+
+	f->crop = cr->c;
+
+	return 0;
+}
+
+static const struct v4l2_ioctl_ops rga_ioctl_ops = {
+	.vidioc_querycap = vidioc_querycap,
+
+	.vidioc_enum_fmt_vid_cap = vidioc_enum_fmt,
+	.vidioc_g_fmt_vid_cap = vidioc_g_fmt,
+	.vidioc_try_fmt_vid_cap = vidioc_try_fmt,
+	.vidioc_s_fmt_vid_cap = vidioc_s_fmt,
+
+	.vidioc_enum_fmt_vid_out = vidioc_enum_fmt,
+	.vidioc_g_fmt_vid_out = vidioc_g_fmt,
+	.vidioc_try_fmt_vid_out = vidioc_try_fmt,
+	.vidioc_s_fmt_vid_out = vidioc_s_fmt,
+
+	.vidioc_reqbufs = v4l2_m2m_ioctl_reqbufs,
+	.vidioc_querybuf = v4l2_m2m_ioctl_querybuf,
+	.vidioc_qbuf = v4l2_m2m_ioctl_qbuf,
+	.vidioc_dqbuf = v4l2_m2m_ioctl_dqbuf,
+	.vidioc_prepare_buf = v4l2_m2m_ioctl_prepare_buf,
+	.vidioc_create_bufs = v4l2_m2m_ioctl_create_bufs,
+	.vidioc_expbuf = v4l2_m2m_ioctl_expbuf,
+
+	.vidioc_streamon = v4l2_m2m_ioctl_streamon,
+	.vidioc_streamoff = v4l2_m2m_ioctl_streamoff,
+
+	.vidioc_g_crop = vidioc_g_crop,
+	.vidioc_s_crop = vidioc_s_crop,
+	.vidioc_cropcap = vidioc_cropcap,
+};
+
+static struct video_device rga_videodev = {
+	.name = "rockchip-rga",
+	.fops = &rga_fops,
+	.ioctl_ops = &rga_ioctl_ops,
+	.minor = -1,
+	.release = video_device_release,
+	.vfl_dir = VFL_DIR_M2M,
+};
+
+static int rga_enable_clocks(struct rockchip_rga *rga)
+{
+	int ret;
+
+	ret = clk_prepare_enable(rga->sclk);
+	if (ret) {
+		dev_err(rga->dev, "Cannot enable rga sclk: %d\n", ret);
+		return ret;
+	}
+
+	ret = clk_prepare_enable(rga->aclk);
+	if (ret) {
+		dev_err(rga->dev, "Cannot enable rga aclk: %d\n", ret);
+		goto err_disable_sclk;
+	}
+
+	ret = clk_prepare_enable(rga->hclk);
+	if (ret) {
+		dev_err(rga->dev, "Cannot enable rga hclk: %d\n", ret);
+		goto err_disable_aclk;
+	}
+
+	return 0;
+
+err_disable_sclk:
+	clk_disable_unprepare(rga->sclk);
+err_disable_aclk:
+	clk_disable_unprepare(rga->aclk);
+
+	return ret;
+}
+
+static void rga_disable_clocks(struct rockchip_rga *rga)
+{
+	clk_disable_unprepare(rga->sclk);
+	clk_disable_unprepare(rga->hclk);
+	clk_disable_unprepare(rga->aclk);
+}
+
+static int rga_parse_dt(struct rockchip_rga *rga)
+{
+	struct reset_control *core_rst, *axi_rst, *ahb_rst;
+
+	core_rst = devm_reset_control_get(rga->dev, "core");
+	if (IS_ERR(core_rst)) {
+		dev_err(rga->dev, "failed to get core reset controller\n");
+		return PTR_ERR(core_rst);
+	}
+
+	axi_rst = devm_reset_control_get(rga->dev, "axi");
+	if (IS_ERR(axi_rst)) {
+		dev_err(rga->dev, "failed to get axi reset controller\n");
+		return PTR_ERR(axi_rst);
+	}
+
+	ahb_rst = devm_reset_control_get(rga->dev, "ahb");
+	if (IS_ERR(ahb_rst)) {
+		dev_err(rga->dev, "failed to get ahb reset controller\n");
+		return PTR_ERR(ahb_rst);
+	}
+
+	reset_control_assert(core_rst);
+	udelay(1);
+	reset_control_deassert(core_rst);
+
+	reset_control_assert(axi_rst);
+	udelay(1);
+	reset_control_deassert(axi_rst);
+
+	reset_control_assert(ahb_rst);
+	udelay(1);
+	reset_control_deassert(ahb_rst);
+
+	rga->sclk = devm_clk_get(rga->dev, "sclk");
+	if (IS_ERR(rga->sclk)) {
+		dev_err(rga->dev, "failed to get sclk clock\n");
+		return PTR_ERR(rga->sclk);
+	}
+
+	rga->aclk = devm_clk_get(rga->dev, "aclk");
+	if (IS_ERR(rga->aclk)) {
+		dev_err(rga->dev, "failed to get aclk clock\n");
+		return PTR_ERR(rga->aclk);
+	}
+
+	rga->hclk = devm_clk_get(rga->dev, "hclk");
+	if (IS_ERR(rga->hclk)) {
+		dev_err(rga->dev, "failed to get hclk clock\n");
+		return PTR_ERR(rga->hclk);
+	}
+
+	return 0;
+}
+
+static int rga_probe(struct platform_device *pdev)
+{
+	struct rockchip_rga *rga;
+	struct video_device *vfd;
+	struct resource *res;
+	int ret = 0;
+	int irq;
+
+	if (!pdev->dev.of_node)
+		return -ENODEV;
+
+	rga = devm_kzalloc(&pdev->dev, sizeof(*rga), GFP_KERNEL);
+	if (!rga)
+		return -ENOMEM;
+
+	rga->dev = &pdev->dev;
+	spin_lock_init(&rga->ctrl_lock);
+	mutex_init(&rga->mutex);
+
+	init_waitqueue_head(&rga->irq_queue);
+
+	ret = rga_parse_dt(rga);
+	if (ret)
+		dev_err(&pdev->dev, "Unable to parse OF data\n");
+
+	pm_runtime_enable(rga->dev);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+
+	rga->regs = devm_ioremap_resource(rga->dev, res);
+	if (IS_ERR(rga->regs)) {
+		ret = PTR_ERR(rga->regs);
+		goto err_put_clk;
+	}
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		dev_err(rga->dev, "failed to get irq\n");
+		ret = irq;
+		goto err_put_clk;
+	}
+
+	ret = devm_request_irq(rga->dev, irq, rga_isr, 0,
+			       dev_name(rga->dev), rga);
+	if (ret < 0) {
+		dev_err(rga->dev, "failed to request irq\n");
+		goto err_put_clk;
+	}
+
+	ret = v4l2_device_register(&pdev->dev, &rga->v4l2_dev);
+	if (ret)
+		goto err_put_clk;
+	vfd = video_device_alloc();
+	if (!vfd) {
+		v4l2_err(&rga->v4l2_dev, "Failed to allocate video device\n");
+		ret = -ENOMEM;
+		goto unreg_v4l2_dev;
+	}
+	*vfd = rga_videodev;
+	vfd->lock = &rga->mutex;
+	vfd->v4l2_dev = &rga->v4l2_dev;
+	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
+	if (ret) {
+		v4l2_err(&rga->v4l2_dev, "Failed to register video device\n");
+		goto rel_vdev;
+	}
+
+	video_set_drvdata(vfd, rga);
+	snprintf(vfd->name, sizeof(vfd->name), "%s", rga_videodev.name);
+	rga->vfd = vfd;
+	v4l2_info(&rga->v4l2_dev, "device registered as /dev/video%d\n",
+		  vfd->num);
+	platform_set_drvdata(pdev, rga);
+	rga->m2m_dev = v4l2_m2m_init(&rga_m2m_ops);
+	if (IS_ERR(rga->m2m_dev)) {
+		v4l2_err(&rga->v4l2_dev, "Failed to init mem2mem device\n");
+		ret = PTR_ERR(rga->m2m_dev);
+		goto unreg_video_dev;
+	}
+
+	pm_runtime_get_sync(rga->dev);
+
+	rga->version.major = (rga_read(rga, RGA_VERSION_INFO) >> 24) & 0xFF;
+	rga->version.minor = (rga_read(rga, RGA_VERSION_INFO) >> 20) & 0x0F;
+
+	pm_runtime_put(rga->dev);
+
+	/* Create CMD buffer */
+	rga->cmdbuf_virt = dma_alloc_attrs(rga->dev, RGA_CMDBUF_SIZE,
+					   &rga->cmdbuf_phy, GFP_KERNEL,
+					   DMA_ATTR_WRITE_COMBINE);
+
+	rga->src_mmu_pages =
+		(unsigned int *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 3);
+	rga->dst_mmu_pages =
+		(unsigned int *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 3);
+
+	def_frame.stride = (def_frame.width * def_frame.fmt->depth) >> 3;
+
+	return 0;
+
+unreg_video_dev:
+	video_unregister_device(rga->vfd);
+rel_vdev:
+	video_device_release(vfd);
+unreg_v4l2_dev:
+	v4l2_device_unregister(&rga->v4l2_dev);
+err_put_clk:
+	pm_runtime_disable(rga->dev);
+
+	return ret;
+}
+
+static int rga_remove(struct platform_device *pdev)
+{
+	struct rockchip_rga *rga = platform_get_drvdata(pdev);
+
+	dma_free_attrs(rga->dev, RGA_CMDBUF_SIZE, &rga->cmdbuf_virt,
+		       rga->cmdbuf_phy, DMA_ATTR_WRITE_COMBINE);
+
+	free_pages((unsigned long)rga->src_mmu_pages, 3);
+	free_pages((unsigned long)rga->dst_mmu_pages, 3);
+
+	v4l2_info(&rga->v4l2_dev, "Removing\n");
+
+	v4l2_m2m_release(rga->m2m_dev);
+	video_unregister_device(rga->vfd);
+	v4l2_device_unregister(&rga->v4l2_dev);
+
+	pm_runtime_disable(rga->dev);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int rga_runtime_suspend(struct device *dev)
+{
+	struct rockchip_rga *rga = dev_get_drvdata(dev);
+
+	rga_disable_clocks(rga);
+
+	return 0;
+}
+
+static int rga_runtime_resume(struct device *dev)
+{
+	struct rockchip_rga *rga = dev_get_drvdata(dev);
+
+	return rga_enable_clocks(rga);
+}
+#endif
+
+static const struct dev_pm_ops rga_pm = {
+	SET_RUNTIME_PM_OPS(rga_runtime_suspend,
+			   rga_runtime_resume, NULL)
+};
+
+static const struct of_device_id rockchip_rga_match[] = {
+	{
+		.compatible = "rockchip,rk3288-rga",
+	},
+	{
+		.compatible = "rockchip,rk3399-rga",
+	},
+	{},
+};
+
+MODULE_DEVICE_TABLE(of, rockchip_rga_match);
+
+static struct platform_driver rga_pdrv = {
+	.probe = rga_probe,
+	.remove = rga_remove,
+	.driver = {
+		.name = "rockchip-rga",
+		.pm = &rga_pm,
+		.of_match_table = rockchip_rga_match,
+	},
+};
+
+module_platform_driver(rga_pdrv);
+
+MODULE_AUTHOR("Jacob Chen <jacob-chen@iotwrt.com>");
+MODULE_DESCRIPTION("Rockchip Raster 2d Grapphic Acceleration Unit");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/platform/rockchip-rga/rga.h b/drivers/media/platform/rockchip-rga/rga.h
new file mode 100644
index 0000000..9d30b41
--- /dev/null
+++ b/drivers/media/platform/rockchip-rga/rga.h
@@ -0,0 +1,110 @@
+/*
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author: Jacob Chen <jacob-chen@iotwrt.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#ifndef __RGA_H__
+#define __RGA_H__
+
+#include <linux/platform_device.h>
+#include <media/videobuf2-v4l2.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+
+#define RGA_NAME "rockchip-rga"
+
+struct rga_fmt {
+	char *name;
+	u32 fourcc;
+	int depth;
+	u8 uv_factor;
+	u8 y_div;
+	u8 x_div;
+	u8 color_swap;
+	u8 hw_format;
+};
+
+struct rga_frame {
+	/* Original dimensions */
+	u32 width;
+	u32 height;
+
+	/* Crop */
+	struct v4l2_rect crop;
+
+	/* Image format */
+	struct rga_fmt *fmt;
+
+	/* Variables that can calculated once and reused */
+	u32 stride;
+	u32 size;
+};
+
+struct rockchip_rga_version {
+	u32 major;
+	u32 minor;
+};
+
+struct rga_ctx {
+	struct v4l2_fh fh;
+	struct rockchip_rga *rga;
+	struct rga_frame in;
+	struct rga_frame out;
+	struct v4l2_ctrl_handler ctrl_handler;
+
+	/* Control values */
+	u32 op;
+	u32 hflip;
+	u32 vflip;
+	u32 rotate;
+	u32 fill_color;
+};
+
+struct rockchip_rga {
+	struct v4l2_device v4l2_dev;
+	struct v4l2_m2m_dev *m2m_dev;
+	struct video_device *vfd;
+
+	struct device *dev;
+	struct regmap *grf;
+	void __iomem *regs;
+	struct clk *sclk;
+	struct clk *aclk;
+	struct clk *hclk;
+	struct rockchip_rga_version version;
+
+	struct mutex mutex;
+	spinlock_t ctrl_lock;
+
+	wait_queue_head_t irq_queue;
+
+	struct rga_ctx *curr;
+	dma_addr_t cmdbuf_phy;
+	void *cmdbuf_virt;
+	unsigned int *src_mmu_pages;
+	unsigned int *dst_mmu_pages;
+};
+
+struct rga_frame *rga_get_frame(struct rga_ctx *ctx, enum v4l2_buf_type type);
+
+/* RGA Buffers Manage Part */
+extern const struct vb2_ops rga_qops;
+void rga_buf_map(struct vb2_buffer *vb);
+
+/* RGA Hardware Part */
+void rga_write(struct rockchip_rga *rga, u32 reg, u32 value);
+u32 rga_read(struct rockchip_rga *rga, u32 reg);
+void rga_mod(struct rockchip_rga *rga, u32 reg, u32 val, u32 mask);
+void rga_start(struct rockchip_rga *rga);
+
+void rga_cmd_set(struct rga_ctx *ctx);
+
+#endif
-- 
2.7.4
