Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:21517 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752425AbcKDFvj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 4 Nov 2016 01:51:39 -0400
From: Rick Chang <rick.chang@mediatek.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <srv_heupstream@mediatek.com>,
        <linux-mediatek@lists.infradead.org>,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        Rick Chang <rick.chang@mediatek.com>
Subject: [PATCH v3 2/3] vcodec: mediatek: Add Mediatek JPEG Decoder Driver
Date: Fri, 4 Nov 2016 13:51:19 +0800
Message-ID: <1478238680-11310-3-git-send-email-rick.chang@mediatek.com>
In-Reply-To: <1478238680-11310-1-git-send-email-rick.chang@mediatek.com>
References: <1478238680-11310-1-git-send-email-rick.chang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add v4l2 driver for Mediatek JPEG Decoder

Signed-off-by: Rick Chang <rick.chang@mediatek.com>
Signed-off-by: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
---
 drivers/media/platform/Kconfig                   |   15 +
 drivers/media/platform/Makefile                  |    2 +
 drivers/media/platform/mtk-jpeg/Makefile         |    2 +
 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c  | 1271 ++++++++++++++++++++++
 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.h  |  141 +++
 drivers/media/platform/mtk-jpeg/mtk_jpeg_hw.c    |  417 +++++++
 drivers/media/platform/mtk-jpeg/mtk_jpeg_hw.h    |   91 ++
 drivers/media/platform/mtk-jpeg/mtk_jpeg_parse.c |  160 +++
 drivers/media/platform/mtk-jpeg/mtk_jpeg_parse.h |   25 +
 drivers/media/platform/mtk-jpeg/mtk_jpeg_reg.h   |   58 +
 10 files changed, 2182 insertions(+)
 create mode 100644 drivers/media/platform/mtk-jpeg/Makefile
 create mode 100644 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
 create mode 100644 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.h
 create mode 100644 drivers/media/platform/mtk-jpeg/mtk_jpeg_hw.c
 create mode 100644 drivers/media/platform/mtk-jpeg/mtk_jpeg_hw.h
 create mode 100644 drivers/media/platform/mtk-jpeg/mtk_jpeg_parse.c
 create mode 100644 drivers/media/platform/mtk-jpeg/mtk_jpeg_parse.h
 create mode 100644 drivers/media/platform/mtk-jpeg/mtk_jpeg_reg.h

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 754edbf1..96c9887 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -162,6 +162,21 @@ config VIDEO_CODA
 	   Coda is a range of video codec IPs that supports
 	   H.264, MPEG-4, and other video formats.
 
+config VIDEO_MEDIATEK_JPEG
+	tristate "Mediatek JPEG Codec driver"
+	depends on MTK_IOMMU_V1 || COMPILE_TEST
+	depends on VIDEO_DEV && VIDEO_V4L2
+	depends on ARCH_MEDIATEK || COMPILE_TEST
+	depends on HAS_DMA
+	select VIDEOBUF2_DMA_CONTIG
+	select V4L2_MEM2MEM_DEV
+	---help---
+	  Mediatek jpeg codec driver provides HW capability to decode
+	  JPEG format
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called mtk-jpeg
+
 config VIDEO_MEDIATEK_VPU
 	tristate "Mediatek Video Processor Unit"
 	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index f842933..cf701e3 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -68,3 +68,5 @@ obj-$(CONFIG_VIDEO_MEDIATEK_VPU)	+= mtk-vpu/
 obj-$(CONFIG_VIDEO_MEDIATEK_VCODEC)	+= mtk-vcodec/
 
 obj-$(CONFIG_VIDEO_MEDIATEK_MDP)	+= mtk-mdp/
+
+obj-$(CONFIG_VIDEO_MEDIATEK_JPEG)	+= mtk-jpeg/
diff --git a/drivers/media/platform/mtk-jpeg/Makefile b/drivers/media/platform/mtk-jpeg/Makefile
new file mode 100644
index 0000000..b2e6069
--- /dev/null
+++ b/drivers/media/platform/mtk-jpeg/Makefile
@@ -0,0 +1,2 @@
+mtk_jpeg-objs := mtk_jpeg_core.o mtk_jpeg_hw.o mtk_jpeg_parse.o
+obj-$(CONFIG_VIDEO_MEDIATEK_JPEG) += mtk_jpeg.o
diff --git a/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c b/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
new file mode 100644
index 0000000..64a2044
--- /dev/null
+++ b/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
@@ -0,0 +1,1271 @@
+/*
+ * Copyright (c) 2016 MediaTek Inc.
+ * Author: Ming Hsiu Tsai <minghsiu.tsai@mediatek.com>
+ *         Rick Chang <rick.chang@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+#include <linux/spinlock.h>
+#include <media/v4l2-event.h>
+#include <media/v4l2-mem2mem.h>
+#include <media/v4l2-ioctl.h>
+#include <media/videobuf2-core.h>
+#include <media/videobuf2-dma-contig.h>
+#include <soc/mediatek/smi.h>
+#include <asm/dma-iommu.h>
+
+#include "mtk_jpeg_hw.h"
+#include "mtk_jpeg_core.h"
+#include "mtk_jpeg_parse.h"
+
+static struct mtk_jpeg_fmt mtk_jpeg_formats[] = {
+	{
+		.name		= "JPEG JFIF",
+		.fourcc		= V4L2_PIX_FMT_JPEG,
+		.colplanes	= 1,
+		.flags		= MTK_JPEG_FMT_FLAG_DEC_OUTPUT,
+	},
+	{
+		.name		= "YUV 4:2:0 non-contiguous 3-planar, Y/Cb/Cr",
+		.fourcc		= V4L2_PIX_FMT_YUV420M,
+		.h_sample	= {4, 2, 2},
+		.v_sample	= {4, 2, 2},
+		.colplanes	= 3,
+		.h_align	= 5,
+		.v_align	= 4,
+		.flags		= MTK_JPEG_FMT_FLAG_DEC_CAPTURE,
+	},
+	{
+		.name		= "YUV 4:2:2 non-contiguous 3-planar, Y/Cb/Cr",
+		.fourcc		= V4L2_PIX_FMT_YUV422M,
+		.h_sample	= {4, 2, 2},
+		.v_sample	= {4, 4, 4},
+		.colplanes	= 3,
+		.h_align	= 5,
+		.v_align	= 3,
+		.flags		= MTK_JPEG_FMT_FLAG_DEC_CAPTURE,
+	},
+};
+
+#define MTK_JPEG_NUM_FORMATS ARRAY_SIZE(mtk_jpeg_formats)
+
+enum {
+	MTK_JPEG_BUF_FLAGS_INIT			= 0,
+	MTK_JPEG_BUF_FLAGS_LAST_FRAME		= 1,
+};
+
+struct mtk_jpeg_src_buf {
+	struct vb2_v4l2_buffer b;
+	struct list_head list;
+	int flags;
+	struct mtk_jpeg_dec_param dec_param;
+};
+
+static int debug;
+module_param(debug, int, 0644);
+
+static inline struct mtk_jpeg_ctx *mtk_jpeg_fh_to_ctx(struct v4l2_fh *fh)
+{
+	return container_of(fh, struct mtk_jpeg_ctx, fh);
+}
+
+static inline struct mtk_jpeg_src_buf *mtk_jpeg_vb2_to_srcbuf(
+							struct vb2_buffer *vb)
+{
+	return container_of(to_vb2_v4l2_buffer(vb), struct mtk_jpeg_src_buf, b);
+}
+
+static int mtk_jpeg_querycap(struct file *file, void *priv,
+			     struct v4l2_capability *cap)
+{
+	struct mtk_jpeg_dev *jpeg = video_drvdata(file);
+
+	strlcpy(cap->driver, MTK_JPEG_NAME " decoder", sizeof(cap->driver));
+	strlcpy(cap->card, MTK_JPEG_NAME " decoder", sizeof(cap->card));
+	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
+		 dev_name(jpeg->dev));
+
+	return 0;
+}
+
+static int mtk_jpeg_enum_fmt(struct mtk_jpeg_fmt *mtk_jpeg_formats, int n,
+			     struct v4l2_fmtdesc *f, u32 type)
+{
+	int i, num = 0;
+
+	for (i = 0; i < n; ++i) {
+		if (mtk_jpeg_formats[i].flags & type) {
+			if (num == f->index)
+				break;
+			++num;
+		}
+	}
+
+	if (i >= n)
+		return -EINVAL;
+
+	f->pixelformat = mtk_jpeg_formats[i].fourcc;
+
+	return 0;
+}
+
+static int mtk_jpeg_enum_fmt_vid_cap(struct file *file, void *priv,
+				     struct v4l2_fmtdesc *f)
+{
+	return mtk_jpeg_enum_fmt(mtk_jpeg_formats, MTK_JPEG_NUM_FORMATS, f,
+				 MTK_JPEG_FMT_FLAG_DEC_CAPTURE);
+}
+
+static int mtk_jpeg_enum_fmt_vid_out(struct file *file, void *priv,
+				     struct v4l2_fmtdesc *f)
+{
+	return mtk_jpeg_enum_fmt(mtk_jpeg_formats, MTK_JPEG_NUM_FORMATS, f,
+				 MTK_JPEG_FMT_FLAG_DEC_OUTPUT);
+}
+
+static struct mtk_jpeg_q_data *mtk_jpeg_get_q_data(struct mtk_jpeg_ctx *ctx,
+						   enum v4l2_buf_type type)
+{
+	if (V4L2_TYPE_IS_OUTPUT(type))
+		return &ctx->out_q;
+	else
+		return &ctx->cap_q;
+}
+
+static struct mtk_jpeg_fmt *mtk_jpeg_find_format(struct mtk_jpeg_ctx *ctx,
+						 u32 pixelformat,
+						 unsigned int fmt_type)
+{
+	unsigned int k, fmt_flag;
+
+	fmt_flag = (fmt_type == MTK_JPEG_FMT_TYPE_OUTPUT) ?
+		   MTK_JPEG_FMT_FLAG_DEC_OUTPUT :
+		   MTK_JPEG_FMT_FLAG_DEC_CAPTURE;
+
+	for (k = 0; k < MTK_JPEG_NUM_FORMATS; k++) {
+		struct mtk_jpeg_fmt *fmt = &mtk_jpeg_formats[k];
+
+		if (fmt->fourcc == pixelformat && fmt->flags & fmt_flag)
+			return fmt;
+	}
+
+	return NULL;
+}
+
+static void mtk_jpeg_bound_align_image(u32 *w, unsigned int wmin,
+				       unsigned int wmax, unsigned int walign,
+				       u32 *h, unsigned int hmin,
+				       unsigned int hmax, unsigned int halign)
+{
+	int width, height, w_step, h_step;
+
+	width = *w;
+	height = *h;
+	w_step = 1 << walign;
+	h_step = 1 << halign;
+
+	v4l_bound_align_image(w, wmin, wmax, walign, h, hmin, hmax, halign, 0);
+	if (*w < width && (*w + w_step) <= wmax)
+		*w += w_step;
+	if (*h < height && (*h + h_step) <= hmax)
+		*h += h_step;
+}
+
+static void mtk_jpeg_adjust_fmt_mplane(struct mtk_jpeg_ctx *ctx,
+				       struct v4l2_format *f)
+{
+	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
+	struct mtk_jpeg_q_data *q_data;
+	int i;
+
+	q_data = mtk_jpeg_get_q_data(ctx, f->type);
+
+	pix_mp->width = q_data->w;
+	pix_mp->height = q_data->h;
+	pix_mp->pixelformat = q_data->fmt->fourcc;
+	pix_mp->num_planes = q_data->fmt->colplanes;
+
+	for (i = 0; i < pix_mp->num_planes; i++) {
+		pix_mp->plane_fmt[i].bytesperline = q_data->bytesperline[i];
+		pix_mp->plane_fmt[i].sizeimage = q_data->sizeimage[i];
+	}
+}
+
+static int mtk_jpeg_try_fmt_mplane(struct v4l2_format *f,
+				   struct mtk_jpeg_fmt *fmt,
+				   struct mtk_jpeg_ctx *ctx, int q_type)
+{
+	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
+	struct mtk_jpeg_dev *jpeg = ctx->jpeg;
+	int i;
+
+	memset(pix_mp->reserved, 0, sizeof(pix_mp->reserved));
+	pix_mp->field = V4L2_FIELD_NONE;
+
+	if (ctx->state != MTK_JPEG_INIT) {
+		mtk_jpeg_adjust_fmt_mplane(ctx, f);
+		goto end;
+	}
+
+	pix_mp->num_planes = fmt->colplanes;
+	pix_mp->pixelformat = fmt->fourcc;
+
+	if (q_type == MTK_JPEG_FMT_TYPE_OUTPUT) {
+		struct v4l2_plane_pix_format *pfmt = &pix_mp->plane_fmt[0];
+
+		mtk_jpeg_bound_align_image(&pix_mp->width, MTK_JPEG_MIN_WIDTH,
+					   MTK_JPEG_MAX_WIDTH, 0,
+					   &pix_mp->height, MTK_JPEG_MIN_HEIGHT,
+					   MTK_JPEG_MAX_HEIGHT, 0);
+
+		memset(pfmt->reserved, 0, sizeof(pfmt->reserved));
+		pfmt->bytesperline = 0;
+		/* Source size must be aligned to 128 */
+		pfmt->sizeimage = mtk_jpeg_align(pfmt->sizeimage, 128);
+		if (pfmt->sizeimage == 0)
+			pfmt->sizeimage = MTK_JPEG_DEFAULT_SIZEIMAGE;
+		goto end;
+	}
+
+	/* type is MTK_JPEG_FMT_TYPE_CAPTURE */
+	mtk_jpeg_bound_align_image(&pix_mp->width, MTK_JPEG_MIN_WIDTH,
+				   MTK_JPEG_MAX_WIDTH, fmt->h_align,
+				   &pix_mp->height, MTK_JPEG_MIN_HEIGHT,
+				   MTK_JPEG_MAX_HEIGHT, fmt->v_align);
+
+	for (i = 0; i < fmt->colplanes; i++) {
+		struct v4l2_plane_pix_format *pfmt = &pix_mp->plane_fmt[i];
+		u32 stride = pix_mp->width * fmt->h_sample[i] / 4;
+		u32 h = pix_mp->height * fmt->v_sample[i] / 4;
+
+		memset(pfmt->reserved, 0, sizeof(pfmt->reserved));
+		pfmt->bytesperline = stride;
+		pfmt->sizeimage = stride * h;
+	}
+end:
+	v4l2_dbg(2, debug, &jpeg->v4l2_dev, "wxh:%ux%u\n",
+		 pix_mp->width, pix_mp->height);
+	for (i = 0; i < pix_mp->num_planes; i++) {
+		v4l2_dbg(2, debug, &jpeg->v4l2_dev,
+			 "plane[%d] bpl=%u, size=%u\n",
+			 i,
+			 pix_mp->plane_fmt[i].bytesperline,
+			 pix_mp->plane_fmt[i].sizeimage);
+	}
+	return 0;
+}
+
+static int mtk_jpeg_g_fmt_vid_mplane(struct file *file, void *priv,
+				     struct v4l2_format *f)
+{
+	struct vb2_queue *vq;
+	struct mtk_jpeg_q_data *q_data = NULL;
+	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
+	struct mtk_jpeg_ctx *ctx = mtk_jpeg_fh_to_ctx(priv);
+	struct mtk_jpeg_dev *jpeg = ctx->jpeg;
+	int i;
+
+	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
+	if (!vq)
+		return -EINVAL;
+
+	q_data = mtk_jpeg_get_q_data(ctx, f->type);
+
+	memset(pix_mp->reserved, 0, sizeof(pix_mp->reserved));
+	pix_mp->width = q_data->w;
+	pix_mp->height = q_data->h;
+	pix_mp->field = V4L2_FIELD_NONE;
+	pix_mp->pixelformat = q_data->fmt->fourcc;
+	pix_mp->num_planes = q_data->fmt->colplanes;
+	pix_mp->colorspace = ctx->colorspace;
+	pix_mp->ycbcr_enc = ctx->ycbcr_enc;
+	pix_mp->xfer_func = ctx->xfer_func;
+	pix_mp->quantization = ctx->quantization;
+
+	v4l2_dbg(1, debug, &jpeg->v4l2_dev, "(%d) g_fmt:%s wxh:%ux%u\n",
+		 f->type, q_data->fmt->name, pix_mp->width, pix_mp->height);
+
+	for (i = 0; i < pix_mp->num_planes; i++) {
+		struct v4l2_plane_pix_format *pfmt = &pix_mp->plane_fmt[i];
+
+		pfmt->bytesperline = q_data->bytesperline[i];
+		pfmt->sizeimage = q_data->sizeimage[i];
+		memset(pfmt->reserved, 0, sizeof(pfmt->reserved));
+
+		v4l2_dbg(1, debug, &jpeg->v4l2_dev,
+			 "plane[%d] bpl=%u, size=%u\n",
+			 i,
+			 pfmt->bytesperline,
+			 pfmt->sizeimage);
+	}
+	return 0;
+}
+
+static int mtk_jpeg_try_fmt_vid_cap_mplane(struct file *file, void *priv,
+					   struct v4l2_format *f)
+{
+	struct mtk_jpeg_ctx *ctx = mtk_jpeg_fh_to_ctx(priv);
+	struct mtk_jpeg_fmt *fmt;
+
+	fmt = mtk_jpeg_find_format(ctx, f->fmt.pix_mp.pixelformat,
+				   MTK_JPEG_FMT_TYPE_CAPTURE);
+	if (!fmt)
+		fmt = ctx->cap_q.fmt;
+
+	v4l2_dbg(2, debug, &ctx->jpeg->v4l2_dev, "(%d) try_fmt:%s\n",
+		 f->type, fmt->name);
+
+	return mtk_jpeg_try_fmt_mplane(f, fmt, ctx, MTK_JPEG_FMT_TYPE_CAPTURE);
+}
+
+static int mtk_jpeg_try_fmt_vid_out_mplane(struct file *file, void *priv,
+					   struct v4l2_format *f)
+{
+	struct mtk_jpeg_ctx *ctx = mtk_jpeg_fh_to_ctx(priv);
+	struct mtk_jpeg_fmt *fmt;
+
+	fmt = mtk_jpeg_find_format(ctx, f->fmt.pix_mp.pixelformat,
+				   MTK_JPEG_FMT_TYPE_OUTPUT);
+	if (!fmt)
+		fmt = ctx->out_q.fmt;
+
+	v4l2_dbg(2, debug, &ctx->jpeg->v4l2_dev, "(%d) try_fmt:%s\n",
+		 f->type, fmt->name);
+
+	return mtk_jpeg_try_fmt_mplane(f, fmt, ctx, MTK_JPEG_FMT_TYPE_OUTPUT);
+}
+
+static int mtk_jpeg_s_fmt_mplane(struct mtk_jpeg_ctx *ctx,
+				 struct v4l2_format *f)
+{
+	struct vb2_queue *vq;
+	struct mtk_jpeg_q_data *q_data = NULL;
+	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
+	struct mtk_jpeg_dev *jpeg = ctx->jpeg;
+	unsigned int f_type;
+	int i;
+
+	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
+	if (!vq)
+		return -EINVAL;
+
+	q_data = mtk_jpeg_get_q_data(ctx, f->type);
+
+	if (vb2_is_busy(vq)) {
+		v4l2_err(&jpeg->v4l2_dev, "queue busy\n");
+		return -EBUSY;
+	}
+
+	f_type = V4L2_TYPE_IS_OUTPUT(f->type) ?
+			 MTK_JPEG_FMT_TYPE_OUTPUT : MTK_JPEG_FMT_TYPE_CAPTURE;
+
+	q_data->fmt = mtk_jpeg_find_format(ctx, pix_mp->pixelformat, f_type);
+	q_data->w = pix_mp->width;
+	q_data->h = pix_mp->height;
+	ctx->colorspace = pix_mp->colorspace;
+	ctx->ycbcr_enc = pix_mp->ycbcr_enc;
+	ctx->xfer_func = pix_mp->xfer_func;
+	ctx->quantization = pix_mp->quantization;
+
+	v4l2_dbg(1, debug, &jpeg->v4l2_dev, "(%d) s_fmt:%s wxh:%ux%u\n",
+		 f->type, q_data->fmt->name, q_data->w, q_data->h);
+
+	for (i = 0; i < q_data->fmt->colplanes; i++) {
+		q_data->bytesperline[i] = pix_mp->plane_fmt[i].bytesperline;
+		q_data->sizeimage[i] = pix_mp->plane_fmt[i].sizeimage;
+
+		v4l2_dbg(1, debug, &jpeg->v4l2_dev,
+			 "plane[%d] bpl=%u, size=%u\n",
+			 i, q_data->bytesperline[i], q_data->sizeimage[i]);
+	}
+
+	return 0;
+}
+
+static int mtk_jpeg_s_fmt_vid_out_mplane(struct file *file, void *priv,
+					 struct v4l2_format *f)
+{
+	int ret;
+
+	ret = mtk_jpeg_try_fmt_vid_out_mplane(file, priv, f);
+	if (ret)
+		return ret;
+
+	return mtk_jpeg_s_fmt_mplane(mtk_jpeg_fh_to_ctx(priv), f);
+}
+
+static int mtk_jpeg_s_fmt_vid_cap_mplane(struct file *file, void *priv,
+					 struct v4l2_format *f)
+{
+	int ret;
+
+	ret = mtk_jpeg_try_fmt_vid_cap_mplane(file, priv, f);
+	if (ret)
+		return ret;
+
+	return mtk_jpeg_s_fmt_mplane(mtk_jpeg_fh_to_ctx(priv), f);
+}
+
+static void mtk_jpeg_queue_src_chg_event(struct mtk_jpeg_ctx *ctx)
+{
+	static const struct v4l2_event ev_src_ch = {
+		.type = V4L2_EVENT_SOURCE_CHANGE,
+		.u.src_change.changes =
+		V4L2_EVENT_SRC_CH_RESOLUTION,
+	};
+
+	v4l2_event_queue_fh(&ctx->fh, &ev_src_ch);
+}
+
+static int mtk_jpeg_subscribe_event(struct v4l2_fh *fh,
+				    const struct v4l2_event_subscription *sub)
+{
+	switch (sub->type) {
+	case V4L2_EVENT_SOURCE_CHANGE:
+		return v4l2_src_change_event_subscribe(fh, sub);
+	default:
+		return -EINVAL;
+	}
+}
+
+static int mtk_jpeg_g_selection(struct file *file, void *priv,
+				struct v4l2_selection *s)
+{
+	struct mtk_jpeg_ctx *ctx = mtk_jpeg_fh_to_ctx(priv);
+
+	if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	switch (s->target) {
+	case V4L2_SEL_TGT_COMPOSE:
+	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
+		s->r.width = ctx->out_q.w;
+		s->r.height = ctx->out_q.h;
+		s->r.left = 0;
+		s->r.top = 0;
+		break;
+	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
+	case V4L2_SEL_TGT_COMPOSE_PADDED:
+		s->r.width = ctx->cap_q.w;
+		s->r.height = ctx->cap_q.h;
+		s->r.left = 0;
+		s->r.top = 0;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int mtk_jpeg_s_selection(struct file *file, void *priv,
+				struct v4l2_selection *s)
+{
+	struct mtk_jpeg_ctx *ctx = mtk_jpeg_fh_to_ctx(priv);
+
+	if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	switch (s->target) {
+	case V4L2_SEL_TGT_COMPOSE:
+		s->r.left = 0;
+		s->r.top = 0;
+		s->r.width = ctx->out_q.w;
+		s->r.height = ctx->out_q.h;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int mtk_jpeg_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
+{
+	struct v4l2_fh *fh = file->private_data;
+	struct vb2_queue *vq;
+	struct vb2_buffer *vb;
+	struct mtk_jpeg_src_buf *jpeg_src_buf;
+
+	if (buf->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		goto end;
+
+	vq = v4l2_m2m_get_vq(fh->m2m_ctx, buf->type);
+	vb = vq->bufs[buf->index];
+	jpeg_src_buf = mtk_jpeg_vb2_to_srcbuf(vb);
+	jpeg_src_buf->flags = (buf->m.planes[0].bytesused == 0) ?
+		MTK_JPEG_BUF_FLAGS_LAST_FRAME : MTK_JPEG_BUF_FLAGS_INIT;
+end:
+	return v4l2_m2m_qbuf(file, fh->m2m_ctx, buf);
+}
+
+static const struct v4l2_ioctl_ops mtk_jpeg_ioctl_ops = {
+	.vidioc_querycap                = mtk_jpeg_querycap,
+	.vidioc_enum_fmt_vid_cap_mplane = mtk_jpeg_enum_fmt_vid_cap,
+	.vidioc_enum_fmt_vid_out_mplane = mtk_jpeg_enum_fmt_vid_out,
+	.vidioc_try_fmt_vid_cap_mplane	= mtk_jpeg_try_fmt_vid_cap_mplane,
+	.vidioc_try_fmt_vid_out_mplane	= mtk_jpeg_try_fmt_vid_out_mplane,
+	.vidioc_g_fmt_vid_cap_mplane    = mtk_jpeg_g_fmt_vid_mplane,
+	.vidioc_g_fmt_vid_out_mplane    = mtk_jpeg_g_fmt_vid_mplane,
+	.vidioc_s_fmt_vid_cap_mplane    = mtk_jpeg_s_fmt_vid_cap_mplane,
+	.vidioc_s_fmt_vid_out_mplane    = mtk_jpeg_s_fmt_vid_out_mplane,
+	.vidioc_qbuf                    = mtk_jpeg_qbuf,
+	.vidioc_subscribe_event         = mtk_jpeg_subscribe_event,
+	.vidioc_g_selection		= mtk_jpeg_g_selection,
+	.vidioc_s_selection		= mtk_jpeg_s_selection,
+
+	.vidioc_create_bufs		= v4l2_m2m_ioctl_create_bufs,
+	.vidioc_prepare_buf		= v4l2_m2m_ioctl_prepare_buf,
+	.vidioc_reqbufs                 = v4l2_m2m_ioctl_reqbufs,
+	.vidioc_querybuf                = v4l2_m2m_ioctl_querybuf,
+	.vidioc_dqbuf                   = v4l2_m2m_ioctl_dqbuf,
+	.vidioc_expbuf                  = v4l2_m2m_ioctl_expbuf,
+	.vidioc_streamon                = v4l2_m2m_ioctl_streamon,
+	.vidioc_streamoff               = v4l2_m2m_ioctl_streamoff,
+
+	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
+};
+
+static int mtk_jpeg_queue_setup(struct vb2_queue *q,
+				unsigned int *num_buffers,
+				unsigned int *num_planes,
+				unsigned int sizes[],
+				struct device *alloc_ctxs[])
+{
+	struct mtk_jpeg_ctx *ctx = vb2_get_drv_priv(q);
+	struct mtk_jpeg_q_data *q_data = NULL;
+	struct mtk_jpeg_dev *jpeg = ctx->jpeg;
+	int i;
+
+	v4l2_dbg(1, debug, &jpeg->v4l2_dev, "(%d) buf_req count=%u\n",
+		 q->type, *num_buffers);
+
+	q_data = mtk_jpeg_get_q_data(ctx, q->type);
+	if (!q_data)
+		return -EINVAL;
+
+	*num_planes = q_data->fmt->colplanes;
+	for (i = 0; i < q_data->fmt->colplanes; i++) {
+		sizes[i] = q_data->sizeimage[i];
+		v4l2_dbg(1, debug, &jpeg->v4l2_dev, "sizeimage[%d]=%u\n",
+			 i, sizes[i]);
+	}
+
+	return 0;
+}
+
+static int mtk_jpeg_buf_prepare(struct vb2_buffer *vb)
+{
+	struct mtk_jpeg_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct mtk_jpeg_q_data *q_data = NULL;
+	int i;
+
+	q_data = mtk_jpeg_get_q_data(ctx, vb->vb2_queue->type);
+	if (!q_data)
+		return -EINVAL;
+
+	for (i = 0; i < q_data->fmt->colplanes; i++)
+		vb2_set_plane_payload(vb, i, q_data->sizeimage[i]);
+
+	return 0;
+}
+
+static bool mtk_jpeg_check_resolution_change(struct mtk_jpeg_ctx *ctx,
+					     struct mtk_jpeg_dec_param *param)
+{
+	struct mtk_jpeg_dev *jpeg = ctx->jpeg;
+	struct mtk_jpeg_q_data *q_data;
+
+	q_data = &ctx->out_q;
+	if (q_data->w != param->pic_w || q_data->h != param->pic_h) {
+		v4l2_dbg(1, debug, &jpeg->v4l2_dev, "Picture size change\n");
+		return true;
+	}
+
+	q_data = &ctx->cap_q;
+	if (q_data->fmt != mtk_jpeg_find_format(ctx, param->dst_fourcc,
+						MTK_JPEG_FMT_TYPE_CAPTURE)) {
+		v4l2_dbg(1, debug, &jpeg->v4l2_dev, "format change\n");
+		return true;
+	}
+	return false;
+}
+
+static void mtk_jpeg_set_queue_data(struct mtk_jpeg_ctx *ctx,
+				    struct mtk_jpeg_dec_param *param)
+{
+	struct mtk_jpeg_dev *jpeg = ctx->jpeg;
+	struct mtk_jpeg_q_data *q_data;
+	int i;
+
+	q_data = &ctx->out_q;
+	q_data->w = param->pic_w;
+	q_data->h = param->pic_h;
+
+	q_data = &ctx->cap_q;
+	q_data->w = param->dec_w;
+	q_data->h = param->dec_h;
+	q_data->fmt = mtk_jpeg_find_format(ctx,
+					   param->dst_fourcc,
+					   MTK_JPEG_FMT_TYPE_CAPTURE);
+
+	for (i = 0; i < q_data->fmt->colplanes; i++) {
+		q_data->bytesperline[i] = param->mem_stride[i];
+		q_data->sizeimage[i] = param->comp_size[i];
+	}
+
+	v4l2_dbg(1, debug, &jpeg->v4l2_dev,
+		 "set_parse cap:%s pic(%u, %u), buf(%u, %u)\n",
+		 q_data->fmt->name, param->pic_w, param->pic_h,
+		 param->dec_w, param->dec_h);
+}
+
+static void mtk_jpeg_buf_queue(struct vb2_buffer *vb)
+{
+	struct mtk_jpeg_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct mtk_jpeg_dec_param *param;
+	struct mtk_jpeg_dev *jpeg = ctx->jpeg;
+	struct mtk_jpeg_src_buf *jpeg_src_buf;
+	bool header_valid;
+
+	v4l2_dbg(2, debug, &jpeg->v4l2_dev, "(%d) buf_q id=%d, vb=%p",
+		 vb->vb2_queue->type, vb->index, vb);
+
+	if (vb->vb2_queue->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		goto end;
+
+	jpeg_src_buf = mtk_jpeg_vb2_to_srcbuf(vb);
+	param = &jpeg_src_buf->dec_param;
+	memset(param, 0, sizeof(*param));
+
+	if (jpeg_src_buf->flags & MTK_JPEG_BUF_FLAGS_LAST_FRAME) {
+		v4l2_dbg(1, debug, &jpeg->v4l2_dev, "Got eos");
+		goto end;
+	}
+	header_valid = mtk_jpeg_parse(param, (u8 *)vb2_plane_vaddr(vb, 0),
+				      vb2_get_plane_payload(vb, 0));
+	if (!header_valid) {
+		v4l2_err(&jpeg->v4l2_dev, "Header invalid.\n");
+		vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
+		return;
+	}
+
+	if (ctx->state == MTK_JPEG_INIT) {
+		mtk_jpeg_queue_src_chg_event(ctx);
+		mtk_jpeg_set_queue_data(ctx, param);
+		ctx->state = MTK_JPEG_RUNNING;
+	}
+end:
+	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, to_vb2_v4l2_buffer(vb));
+}
+
+static void *mtk_jpeg_buf_remove(struct mtk_jpeg_ctx *ctx,
+				 enum v4l2_buf_type type)
+{
+	if (V4L2_TYPE_IS_OUTPUT(type))
+		return v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
+	else
+		return v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
+}
+
+static int mtk_jpeg_start_streaming(struct vb2_queue *q, unsigned int count)
+{
+	struct mtk_jpeg_ctx *ctx = vb2_get_drv_priv(q);
+	int ret = 0;
+
+	ret = pm_runtime_get_sync(ctx->jpeg->dev);
+
+	return ret > 0 ? 0 : ret;
+}
+
+static void mtk_jpeg_stop_streaming(struct vb2_queue *q)
+{
+	struct mtk_jpeg_ctx *ctx = vb2_get_drv_priv(q);
+	struct vb2_buffer *vb;
+
+	/*
+	 * STREAMOFF is an acknowledgment for source change event.
+	 * Before STREAMOFF, we still have to return the old resolution and
+	 * subsampling. Update capture queue when the stream is off.
+	 */
+	if (ctx->state == MTK_JPEG_SOURCE_CHANGE &&
+	    !V4L2_TYPE_IS_OUTPUT(q->type)) {
+		struct mtk_jpeg_src_buf *src_buf;
+
+		vb = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
+		src_buf = mtk_jpeg_vb2_to_srcbuf(vb);
+		mtk_jpeg_set_queue_data(ctx, &src_buf->dec_param);
+		ctx->state = MTK_JPEG_RUNNING;
+	} else if (V4L2_TYPE_IS_OUTPUT(q->type)) {
+		ctx->state = MTK_JPEG_INIT;
+	}
+
+	vb = mtk_jpeg_buf_remove(ctx, q->type);
+	while (vb) {
+		v4l2_m2m_buf_done(to_vb2_v4l2_buffer(vb), VB2_BUF_STATE_ERROR);
+		vb = mtk_jpeg_buf_remove(ctx, q->type);
+	}
+
+	pm_runtime_put_sync(ctx->jpeg->dev);
+}
+
+static struct vb2_ops mtk_jpeg_qops = {
+	.queue_setup        = mtk_jpeg_queue_setup,
+	.buf_prepare        = mtk_jpeg_buf_prepare,
+	.buf_queue          = mtk_jpeg_buf_queue,
+	.wait_prepare       = vb2_ops_wait_prepare,
+	.wait_finish        = vb2_ops_wait_finish,
+	.start_streaming    = mtk_jpeg_start_streaming,
+	.stop_streaming     = mtk_jpeg_stop_streaming,
+};
+
+static void mtk_jpeg_set_dec_src(struct mtk_jpeg_ctx *ctx,
+				 struct vb2_buffer *src_buf,
+				 struct mtk_jpeg_bs *bs)
+{
+	bs->str_addr = vb2_dma_contig_plane_dma_addr(src_buf, 0);
+	bs->end_addr = bs->str_addr +
+			 mtk_jpeg_align(vb2_get_plane_payload(src_buf, 0), 16);
+	bs->size = mtk_jpeg_align(vb2_plane_size(src_buf, 0), 128);
+}
+
+static int mtk_jpeg_set_dec_dst(struct mtk_jpeg_ctx *ctx,
+				struct mtk_jpeg_dec_param *param,
+				struct vb2_buffer *dst_buf,
+				struct mtk_jpeg_fb *fb)
+{
+	int i;
+
+	if (param->comp_num != dst_buf->num_planes) {
+		dev_err(ctx->jpeg->dev, "plane number mismatch (%u != %u)\n",
+			param->comp_num, dst_buf->num_planes);
+		return -EINVAL;
+	}
+
+	for (i = 0; i < dst_buf->num_planes; i++) {
+		if (vb2_plane_size(dst_buf, i) < param->comp_size[i]) {
+			dev_err(ctx->jpeg->dev,
+				"buffer size is underflow (%lu < %u)\n",
+				vb2_plane_size(dst_buf, 0),
+				param->comp_size[i]);
+			return -EINVAL;
+		}
+		fb->plane_addr[i] = vb2_dma_contig_plane_dma_addr(dst_buf, i);
+	}
+
+	return 0;
+}
+
+static void mtk_jpeg_device_run(void *priv)
+{
+	struct mtk_jpeg_ctx *ctx = priv;
+	struct mtk_jpeg_dev *jpeg = ctx->jpeg;
+	struct vb2_buffer *src_buf, *dst_buf;
+	enum vb2_buffer_state buf_state = VB2_BUF_STATE_ERROR;
+	unsigned long flags;
+	struct mtk_jpeg_src_buf *jpeg_src_buf;
+	struct mtk_jpeg_bs bs;
+	struct mtk_jpeg_fb fb;
+	int i;
+
+	src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
+	dst_buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
+	jpeg_src_buf = mtk_jpeg_vb2_to_srcbuf(src_buf);
+
+	if (jpeg_src_buf->flags & MTK_JPEG_BUF_FLAGS_LAST_FRAME) {
+		for (i = 0; i < dst_buf->num_planes; i++)
+			vb2_set_plane_payload(dst_buf, i, 0);
+		buf_state = VB2_BUF_STATE_DONE;
+		goto dec_end;
+	}
+
+	if (mtk_jpeg_check_resolution_change(ctx, &jpeg_src_buf->dec_param)) {
+		mtk_jpeg_queue_src_chg_event(ctx);
+		ctx->state = MTK_JPEG_SOURCE_CHANGE;
+		v4l2_m2m_job_finish(jpeg->m2m_dev, ctx->fh.m2m_ctx);
+		return;
+	}
+
+	mtk_jpeg_set_dec_src(ctx, src_buf, &bs);
+	if (mtk_jpeg_set_dec_dst(ctx, &jpeg_src_buf->dec_param, dst_buf, &fb))
+		goto dec_end;
+
+	spin_lock_irqsave(&jpeg->hw_lock, flags);
+	mtk_jpeg_dec_reset(jpeg->dec_reg_base);
+	mtk_jpeg_dec_set_config(jpeg->dec_reg_base,
+				&jpeg_src_buf->dec_param, &bs, &fb);
+
+	mtk_jpeg_dec_start(jpeg->dec_reg_base);
+	spin_unlock_irqrestore(&jpeg->hw_lock, flags);
+	return;
+
+dec_end:
+	v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
+	v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
+	v4l2_m2m_buf_done(to_vb2_v4l2_buffer(src_buf), buf_state);
+	v4l2_m2m_buf_done(to_vb2_v4l2_buffer(dst_buf), buf_state);
+	v4l2_m2m_job_finish(jpeg->m2m_dev, ctx->fh.m2m_ctx);
+}
+
+static int mtk_jpeg_job_ready(void *priv)
+{
+	struct mtk_jpeg_ctx *ctx = priv;
+
+	return (ctx->state == MTK_JPEG_RUNNING) ? 1 : 0;
+}
+
+static void mtk_jpeg_job_abort(void *priv)
+{
+	struct mtk_jpeg_ctx *ctx = priv;
+	struct mtk_jpeg_dev *jpeg = ctx->jpeg;
+	struct vb2_buffer *src_buf, *dst_buf;
+
+	src_buf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
+	dst_buf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
+	v4l2_m2m_buf_done(to_vb2_v4l2_buffer(src_buf), VB2_BUF_STATE_ERROR);
+	v4l2_m2m_buf_done(to_vb2_v4l2_buffer(dst_buf), VB2_BUF_STATE_ERROR);
+	v4l2_m2m_job_finish(jpeg->m2m_dev, ctx->fh.m2m_ctx);
+}
+
+static struct v4l2_m2m_ops mtk_jpeg_m2m_ops = {
+	.device_run = mtk_jpeg_device_run,
+	.job_ready  = mtk_jpeg_job_ready,
+	.job_abort  = mtk_jpeg_job_abort,
+};
+
+static int mtk_jpeg_queue_init(void *priv, struct vb2_queue *src_vq,
+			       struct vb2_queue *dst_vq)
+{
+	struct mtk_jpeg_ctx *ctx = priv;
+	int ret;
+
+	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
+	src_vq->io_modes = VB2_DMABUF | VB2_MMAP | VB2_USERPTR;
+	src_vq->drv_priv = ctx;
+	src_vq->buf_struct_size = sizeof(struct mtk_jpeg_src_buf);
+	src_vq->ops = &mtk_jpeg_qops;
+	src_vq->mem_ops = &vb2_dma_contig_memops;
+	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	src_vq->lock = &ctx->jpeg->lock;
+	src_vq->dev = ctx->jpeg->dev;
+	ret = vb2_queue_init(src_vq);
+	if (ret)
+		return ret;
+
+	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+	dst_vq->io_modes = VB2_DMABUF | VB2_MMAP | VB2_USERPTR;
+	dst_vq->drv_priv = ctx;
+	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
+	dst_vq->ops = &mtk_jpeg_qops;
+	dst_vq->mem_ops = &vb2_dma_contig_memops;
+	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	dst_vq->lock = &ctx->jpeg->lock;
+	dst_vq->dev = ctx->jpeg->dev;
+	ret = vb2_queue_init(dst_vq);
+
+	return ret;
+}
+
+static void mtk_jpeg_clk_on(struct mtk_jpeg_dev *jpeg)
+{
+	int ret;
+
+	ret = mtk_smi_larb_get(jpeg->larb);
+	if (ret)
+		dev_err(jpeg->dev, "mtk_smi_larb_get larbvdec fail %d\n", ret);
+	clk_prepare_enable(jpeg->clk_jdec_smi);
+	clk_prepare_enable(jpeg->clk_jdec);
+}
+
+static void mtk_jpeg_clk_off(struct mtk_jpeg_dev *jpeg)
+{
+	clk_disable_unprepare(jpeg->clk_jdec);
+	clk_disable_unprepare(jpeg->clk_jdec_smi);
+	mtk_smi_larb_put(jpeg->larb);
+}
+
+static irqreturn_t mtk_jpeg_dec_irq(int irq, void *priv)
+{
+	struct mtk_jpeg_dev *jpeg = priv;
+	struct mtk_jpeg_ctx *ctx;
+	struct vb2_buffer *src_buf, *dst_buf;
+	struct mtk_jpeg_src_buf *jpeg_src_buf;
+	enum vb2_buffer_state buf_state = VB2_BUF_STATE_ERROR;
+	u32	dec_irq_ret;
+	u32 dec_ret;
+	int i;
+
+	ctx = v4l2_m2m_get_curr_priv(jpeg->m2m_dev);
+	if (!ctx) {
+		v4l2_err(&jpeg->v4l2_dev, "Context is NULL\n");
+		return IRQ_HANDLED;
+	}
+
+	src_buf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
+	dst_buf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
+	jpeg_src_buf = mtk_jpeg_vb2_to_srcbuf(src_buf);
+
+	dec_ret = mtk_jpeg_dec_get_int_status(jpeg->dec_reg_base);
+	dec_irq_ret = mtk_jpeg_dec_enum_result(dec_ret);
+
+	if (dec_irq_ret >= MTK_JPEG_DEC_RESULT_UNDERFLOW)
+		mtk_jpeg_dec_reset(jpeg->dec_reg_base);
+
+	if (dec_irq_ret != MTK_JPEG_DEC_RESULT_EOF_DONE) {
+		dev_err(jpeg->dev, "decode failed\n");
+		goto dec_end;
+	}
+
+	for (i = 0; i < dst_buf->num_planes; i++)
+		vb2_set_plane_payload(dst_buf, i,
+				      jpeg_src_buf->dec_param.comp_size[i]);
+
+	buf_state = VB2_BUF_STATE_DONE;
+
+dec_end:
+	v4l2_m2m_buf_done(to_vb2_v4l2_buffer(src_buf), buf_state);
+	v4l2_m2m_buf_done(to_vb2_v4l2_buffer(dst_buf), buf_state);
+	v4l2_m2m_job_finish(jpeg->m2m_dev, ctx->fh.m2m_ctx);
+	return IRQ_HANDLED;
+}
+
+static void mtk_jpeg_set_default_params(struct mtk_jpeg_ctx *ctx)
+{
+	struct mtk_jpeg_q_data *q = &ctx->out_q;
+	int i;
+
+	ctx->colorspace = V4L2_COLORSPACE_JPEG,
+	ctx->ycbcr_enc = V4L2_YCBCR_ENC_DEFAULT;
+	ctx->quantization = V4L2_QUANTIZATION_DEFAULT;
+	ctx->xfer_func = V4L2_XFER_FUNC_DEFAULT;
+
+	q->fmt = mtk_jpeg_find_format(ctx, V4L2_PIX_FMT_JPEG,
+					      MTK_JPEG_FMT_TYPE_OUTPUT);
+	q->w = MTK_JPEG_MIN_WIDTH;
+	q->h = MTK_JPEG_MIN_HEIGHT;
+	q->bytesperline[0] = 0;
+	q->sizeimage[0] = MTK_JPEG_DEFAULT_SIZEIMAGE;
+
+	q = &ctx->cap_q;
+	q->fmt = mtk_jpeg_find_format(ctx, V4L2_PIX_FMT_YUV420M,
+					      MTK_JPEG_FMT_TYPE_CAPTURE);
+	q->w = MTK_JPEG_MIN_WIDTH;
+	q->h = MTK_JPEG_MIN_HEIGHT;
+
+	for (i = 0; i < q->fmt->colplanes; i++) {
+		u32 stride = q->w * q->fmt->h_sample[i] / 4;
+		u32 h = q->h * q->fmt->v_sample[i] / 4;
+
+		q->bytesperline[i] = stride;
+		q->sizeimage[i] = stride * h;
+	}
+}
+
+static int mtk_jpeg_open(struct file *file)
+{
+	struct mtk_jpeg_dev *jpeg = video_drvdata(file);
+	struct video_device *vfd = video_devdata(file);
+	struct mtk_jpeg_ctx *ctx;
+	int ret = 0;
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	if (mutex_lock_interruptible(&jpeg->lock)) {
+		ret = -ERESTARTSYS;
+		goto free;
+	}
+
+	v4l2_fh_init(&ctx->fh, vfd);
+	file->private_data = &ctx->fh;
+	v4l2_fh_add(&ctx->fh);
+
+	ctx->jpeg = jpeg;
+	ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(jpeg->m2m_dev, ctx,
+					    mtk_jpeg_queue_init);
+	if (IS_ERR(ctx->fh.m2m_ctx)) {
+		ret = PTR_ERR(ctx->fh.m2m_ctx);
+		goto error;
+	}
+
+	mtk_jpeg_set_default_params(ctx);
+	mutex_unlock(&jpeg->lock);
+	return 0;
+
+error:
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
+	mutex_unlock(&jpeg->lock);
+free:
+	kfree(ctx);
+	return ret;
+}
+
+static int mtk_jpeg_release(struct file *file)
+{
+	struct mtk_jpeg_dev *jpeg = video_drvdata(file);
+	struct mtk_jpeg_ctx *ctx = mtk_jpeg_fh_to_ctx(file->private_data);
+
+	mutex_lock(&jpeg->lock);
+	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
+	kfree(ctx);
+	mutex_unlock(&jpeg->lock);
+	return 0;
+}
+
+static const struct v4l2_file_operations mtk_jpeg_fops = {
+	.owner          = THIS_MODULE,
+	.open           = mtk_jpeg_open,
+	.release        = mtk_jpeg_release,
+	.poll           = v4l2_m2m_fop_poll,
+	.unlocked_ioctl = video_ioctl2,
+	.mmap           = v4l2_m2m_fop_mmap,
+};
+
+static int mtk_jpeg_clk_init(struct mtk_jpeg_dev *jpeg)
+{
+	struct device_node *node;
+	struct platform_device *pdev;
+
+	node = of_parse_phandle(jpeg->dev->of_node, "mediatek,larb", 0);
+	if (!node)
+		return -EINVAL;
+	pdev = of_find_device_by_node(node);
+	if (WARN_ON(!pdev)) {
+		of_node_put(node);
+		return -EINVAL;
+	}
+	of_node_put(node);
+
+	jpeg->larb = &pdev->dev;
+
+	jpeg->clk_jdec = devm_clk_get(jpeg->dev, "jpgdec");
+	if (IS_ERR(jpeg->clk_jdec))
+		return -EINVAL;
+
+	jpeg->clk_jdec_smi = devm_clk_get(jpeg->dev, "jpgdec-smi");
+	if (IS_ERR(jpeg->clk_jdec_smi))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int mtk_jpeg_probe(struct platform_device *pdev)
+{
+	struct mtk_jpeg_dev *jpeg;
+	struct resource *res;
+	int dec_irq;
+	int ret;
+
+	jpeg = devm_kzalloc(&pdev->dev, sizeof(*jpeg), GFP_KERNEL);
+	if (!jpeg)
+		return -ENOMEM;
+
+	mutex_init(&jpeg->lock);
+	spin_lock_init(&jpeg->hw_lock);
+	jpeg->dev = &pdev->dev;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	jpeg->dec_reg_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(jpeg->dec_reg_base)) {
+		ret = PTR_ERR(jpeg->dec_reg_base);
+		return ret;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	dec_irq = platform_get_irq(pdev, 0);
+	if (!res || dec_irq < 0) {
+		dev_err(&pdev->dev, "Failed to get dec_irq %d.\n", dec_irq);
+		ret = -EINVAL;
+		return ret;
+	}
+
+	ret = devm_request_irq(&pdev->dev, dec_irq, mtk_jpeg_dec_irq, 0,
+			       pdev->name, jpeg);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to request dec_irq %d (%d)\n",
+			dec_irq, ret);
+		ret = -EINVAL;
+		goto err_req_irq;
+	}
+
+	ret = mtk_jpeg_clk_init(jpeg);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to init clk, err %d\n", ret);
+		goto err_clk_init;
+	}
+
+	ret = v4l2_device_register(&pdev->dev, &jpeg->v4l2_dev);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to register v4l2 device\n");
+		ret = -EINVAL;
+		goto err_dev_register;
+	}
+
+	jpeg->m2m_dev = v4l2_m2m_init(&mtk_jpeg_m2m_ops);
+	if (IS_ERR(jpeg->m2m_dev)) {
+		v4l2_err(&jpeg->v4l2_dev, "Failed to init mem2mem device\n");
+		ret = PTR_ERR(jpeg->m2m_dev);
+		goto err_m2m_init;
+	}
+
+	jpeg->dec_vdev = video_device_alloc();
+	if (!jpeg->dec_vdev) {
+		ret = -ENOMEM;
+		goto err_dec_vdev_alloc;
+	}
+	snprintf(jpeg->dec_vdev->name, sizeof(jpeg->dec_vdev->name),
+		 "%s-dec", MTK_JPEG_NAME);
+	jpeg->dec_vdev->fops = &mtk_jpeg_fops;
+	jpeg->dec_vdev->ioctl_ops = &mtk_jpeg_ioctl_ops;
+	jpeg->dec_vdev->minor = -1;
+	jpeg->dec_vdev->release = video_device_release;
+	jpeg->dec_vdev->lock = &jpeg->lock;
+	jpeg->dec_vdev->v4l2_dev = &jpeg->v4l2_dev;
+	jpeg->dec_vdev->vfl_dir = VFL_DIR_M2M;
+	jpeg->dec_vdev->device_caps = V4L2_CAP_STREAMING |
+				      V4L2_CAP_VIDEO_M2M_MPLANE;
+
+	ret = video_register_device(jpeg->dec_vdev, VFL_TYPE_GRABBER, 3);
+	if (ret) {
+		v4l2_err(&jpeg->v4l2_dev, "Failed to register video device\n");
+		goto err_dec_vdev_register;
+	}
+
+	video_set_drvdata(jpeg->dec_vdev, jpeg);
+	v4l2_info(&jpeg->v4l2_dev,
+		  "decoder device registered as /dev/video%d (%d,%d)\n",
+		  jpeg->dec_vdev->num, VIDEO_MAJOR, jpeg->dec_vdev->minor);
+
+	platform_set_drvdata(pdev, jpeg);
+
+	pm_runtime_enable(&pdev->dev);
+
+	return 0;
+
+err_dec_vdev_register:
+	video_device_release(jpeg->dec_vdev);
+
+err_dec_vdev_alloc:
+	v4l2_m2m_release(jpeg->m2m_dev);
+
+err_m2m_init:
+	v4l2_device_unregister(&jpeg->v4l2_dev);
+
+err_dev_register:
+
+err_clk_init:
+
+err_req_irq:
+
+	return ret;
+}
+
+static int mtk_jpeg_remove(struct platform_device *pdev)
+{
+	struct mtk_jpeg_dev *jpeg = platform_get_drvdata(pdev);
+
+	pm_runtime_disable(&pdev->dev);
+	video_unregister_device(jpeg->dec_vdev);
+	video_device_release(jpeg->dec_vdev);
+	v4l2_m2m_release(jpeg->m2m_dev);
+	v4l2_device_unregister(&jpeg->v4l2_dev);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int mtk_jpeg_pm_suspend(struct device *dev)
+{
+	struct mtk_jpeg_dev *jpeg = dev_get_drvdata(dev);
+
+	mtk_jpeg_dec_reset(jpeg->dec_reg_base);
+	mtk_jpeg_clk_off(jpeg);
+
+	return 0;
+}
+
+static int mtk_jpeg_pm_resume(struct device *dev)
+{
+	struct mtk_jpeg_dev *jpeg = dev_get_drvdata(dev);
+
+	mtk_jpeg_clk_on(jpeg);
+	mtk_jpeg_dec_reset(jpeg->dec_reg_base);
+
+	return 0;
+}
+#endif /* CONFIG_PM */
+
+#ifdef CONFIG_PM_SLEEP
+static int mtk_jpeg_suspend(struct device *dev)
+{
+	int ret;
+
+	if (pm_runtime_suspended(dev))
+		return 0;
+
+	ret = mtk_jpeg_pm_suspend(dev);
+	return ret;
+}
+
+static int mtk_jpeg_resume(struct device *dev)
+{
+	int ret;
+
+	if (pm_runtime_suspended(dev))
+		return 0;
+
+	ret = mtk_jpeg_pm_resume(dev);
+
+	return ret;
+}
+#endif /* CONFIG_PM_SLEEP */
+
+static const struct dev_pm_ops mtk_jpeg_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(mtk_jpeg_suspend, mtk_jpeg_resume)
+	SET_RUNTIME_PM_OPS(mtk_jpeg_pm_suspend, mtk_jpeg_pm_resume, NULL)
+};
+
+static const struct of_device_id mtk_jpeg_match[] = {
+	{
+		.compatible = "mediatek,mt2701-jpgdec",
+		.data       = NULL,
+	},
+	{},
+};
+
+MODULE_DEVICE_TABLE(of, mtk_jpeg_match);
+
+static struct platform_driver mtk_jpeg_driver = {
+	.probe = mtk_jpeg_probe,
+	.remove = mtk_jpeg_remove,
+	.driver = {
+		.owner          = THIS_MODULE,
+		.name           = MTK_JPEG_NAME,
+		.of_match_table = mtk_jpeg_match,
+		.pm             = &mtk_jpeg_pm_ops,
+	},
+};
+
+module_platform_driver(mtk_jpeg_driver);
+
+MODULE_DESCRIPTION("MediaTek JPEG codec driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.h b/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.h
new file mode 100644
index 0000000..d862e3b
--- /dev/null
+++ b/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.h
@@ -0,0 +1,141 @@
+/*
+ * Copyright (c) 2016 MediaTek Inc.
+ * Author: Ming Hsiu Tsai <minghsiu.tsai@mediatek.com>
+ *         Rick Chang <rick.chang@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _MTK_JPEG_CORE_H
+#define _MTK_JPEG_CORE_H
+
+#include <linux/interrupt.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-fh.h>
+
+#define MTK_JPEG_NAME		"mtk-jpeg"
+
+#define MTK_JPEG_FMT_FLAG_DEC_OUTPUT	BIT(0)
+#define MTK_JPEG_FMT_FLAG_DEC_CAPTURE	BIT(1)
+
+#define MTK_JPEG_FMT_TYPE_OUTPUT	1
+#define MTK_JPEG_FMT_TYPE_CAPTURE	2
+
+#define MTK_JPEG_MIN_WIDTH	32
+#define MTK_JPEG_MIN_HEIGHT	32
+#define MTK_JPEG_MAX_WIDTH	8192
+#define MTK_JPEG_MAX_HEIGHT	8192
+
+#define MTK_JPEG_DEFAULT_SIZEIMAGE	(1 * 1024 * 1024)
+
+enum mtk_jpeg_ctx_state {
+	MTK_JPEG_INIT = 0,
+	MTK_JPEG_RUNNING,
+	MTK_JPEG_SOURCE_CHANGE,
+};
+
+/**
+ * struct mt_jpeg - JPEG IP abstraction
+ * @lock:		the mutex protecting this structure
+ * @hw_lock:		spinlock protecting the hw device resource
+ * @workqueue:		decode work queue
+ * @dev:		JPEG device
+ * @v4l2_dev:		v4l2 device for mem2mem mode
+ * @m2m_dev:		v4l2 mem2mem device data
+ * @alloc_ctx:		videobuf2 memory allocator's context
+ * @dec_vdev:		video device node for decoder mem2mem mode
+ * @dec_reg_base:	JPEG registers mapping
+ * @clk_jdec:		JPEG hw working clock
+ * @clk_jdec_smi:	JPEG SMI bus clock
+ * @larb:		SMI device
+ */
+struct mtk_jpeg_dev {
+	struct mutex		lock;
+	spinlock_t		hw_lock;
+	struct workqueue_struct	*workqueue;
+	struct device		*dev;
+	struct v4l2_device	v4l2_dev;
+	struct v4l2_m2m_dev	*m2m_dev;
+	void			*alloc_ctx;
+	struct video_device	*dec_vdev;
+	void __iomem		*dec_reg_base;
+	struct clk		*clk_jdec;
+	struct clk		*clk_jdec_smi;
+	struct device		*larb;
+};
+
+/**
+ * struct jpeg_fmt - driver's internal color format data
+ * @name:	format descritpion
+ * @fourcc:	the fourcc code, 0 if not applicable
+ * @h_sample:	horizontal sample count of plane in 4 * 4 pixel image
+ * @v_sample:	vertical sample count of plane in 4 * 4 pixel image
+ * @colplanes:	number of color planes (1 for packed formats)
+ * @h_align:	horizontal alignment order (align to 2^h_align)
+ * @v_align:	vertical alignment order (align to 2^v_align)
+ * @flags:	flags describing format applicability
+ */
+struct mtk_jpeg_fmt {
+	char	*name;
+	u32	fourcc;
+	int	h_sample[VIDEO_MAX_PLANES];
+	int	v_sample[VIDEO_MAX_PLANES];
+	int	colplanes;
+	int	h_align;
+	int	v_align;
+	u32	flags;
+};
+
+/**
+ * mtk_jpeg_q_data - parameters of one queue
+ * @fmt:	  driver-specific format of this queue
+ * @w:		  image width
+ * @h:		  image height
+ * @bytesperline: distance in bytes between the leftmost pixels in two adjacent
+ *                lines
+ * @sizeimage:	  image buffer size in bytes
+ */
+struct mtk_jpeg_q_data {
+	struct mtk_jpeg_fmt	*fmt;
+	u32			w;
+	u32			h;
+	u32			bytesperline[VIDEO_MAX_PLANES];
+	u32			sizeimage[VIDEO_MAX_PLANES];
+};
+
+/**
+ * mtk_jpeg_ctx - the device context data
+ * @jpeg:		JPEG IP device for this context
+ * @out_q:		source (output) queue information
+ * @cap_q:		destination (capture) queue queue information
+ * @fh:			V4L2 file handle
+ * @dec_param		parameters for HW decoding
+ * @state:		state of the context
+ * @header_valid:	set if header has been parsed and valid
+ * @colorspace: enum v4l2_colorspace; supplemental to pixelformat
+ * @ycbcr_enc: enum v4l2_ycbcr_encoding, Y'CbCr encoding
+ * @quantization: enum v4l2_quantization, colorspace quantization
+ * @xfer_func: enum v4l2_xfer_func, colorspace transfer function
+ */
+struct mtk_jpeg_ctx {
+	struct mtk_jpeg_dev		*jpeg;
+	struct mtk_jpeg_q_data		out_q;
+	struct mtk_jpeg_q_data		cap_q;
+	struct v4l2_fh			fh;
+	enum mtk_jpeg_ctx_state		state;
+
+	enum v4l2_colorspace colorspace;
+	enum v4l2_ycbcr_encoding ycbcr_enc;
+	enum v4l2_quantization quantization;
+	enum v4l2_xfer_func xfer_func;
+};
+
+#endif /* _MTK_JPEG_CORE_H */
diff --git a/drivers/media/platform/mtk-jpeg/mtk_jpeg_hw.c b/drivers/media/platform/mtk-jpeg/mtk_jpeg_hw.c
new file mode 100644
index 0000000..a6315f3
--- /dev/null
+++ b/drivers/media/platform/mtk-jpeg/mtk_jpeg_hw.c
@@ -0,0 +1,417 @@
+/*
+ * Copyright (c) 2016 MediaTek Inc.
+ * Author: Ming Hsiu Tsai <minghsiu.tsai@mediatek.com>
+ *         Rick Chang <rick.chang@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <media/videobuf2-core.h>
+
+#include "mtk_jpeg_hw.h"
+
+#define MTK_JPEG_DUNUM_MASK(val)	(((val) - 1) & 0x3)
+
+enum mtk_jpeg_color {
+	MTK_JPEG_COLOR_420		= 0x00221111,
+	MTK_JPEG_COLOR_422		= 0x00211111,
+	MTK_JPEG_COLOR_444		= 0x00111111,
+	MTK_JPEG_COLOR_422V		= 0x00121111,
+	MTK_JPEG_COLOR_422X2		= 0x00412121,
+	MTK_JPEG_COLOR_422VX2		= 0x00222121,
+	MTK_JPEG_COLOR_400		= 0x00110000
+};
+
+static inline int mtk_jpeg_verify_align(u32 val, int align, u32 reg)
+{
+	if (val & (align - 1)) {
+		pr_err("mtk-jpeg: write reg %x without %d align\n", reg, align);
+		return -1;
+	}
+
+	return 0;
+}
+
+static int mtk_jpeg_decide_format(struct mtk_jpeg_dec_param *param)
+{
+	param->src_color = (param->sampling_w[0] << 20) |
+			   (param->sampling_h[0] << 16) |
+			   (param->sampling_w[1] << 12) |
+			   (param->sampling_h[1] << 8) |
+			   (param->sampling_w[2] << 4) |
+			   (param->sampling_h[2]);
+
+	param->uv_brz_w = 0;
+	switch (param->src_color) {
+	case MTK_JPEG_COLOR_444:
+		param->uv_brz_w = 1;
+		param->dst_fourcc = V4L2_PIX_FMT_YUV422M;
+		break;
+	case MTK_JPEG_COLOR_422X2:
+	case MTK_JPEG_COLOR_422:
+		param->dst_fourcc = V4L2_PIX_FMT_YUV422M;
+		break;
+	case MTK_JPEG_COLOR_422V:
+	case MTK_JPEG_COLOR_422VX2:
+		param->uv_brz_w = 1;
+		param->dst_fourcc = V4L2_PIX_FMT_YUV420M;
+		break;
+	case MTK_JPEG_COLOR_420:
+		param->dst_fourcc = V4L2_PIX_FMT_YUV420M;
+		break;
+	case MTK_JPEG_COLOR_400:
+		param->dst_fourcc = V4L2_PIX_FMT_GREY;
+		break;
+	default:
+		param->dst_fourcc = 0;
+		return -1;
+	}
+
+	return 0;
+}
+
+static void mtk_jpeg_calc_mcu(struct mtk_jpeg_dec_param *param)
+{
+	u32 factor_w, factor_h;
+	u32 i, comp, blk;
+
+	factor_w = 2 + param->sampling_w[0];
+	factor_h = 2 + param->sampling_h[0];
+	param->mcu_w = (param->pic_w + (1 << factor_w) - 1) >> factor_w;
+	param->mcu_h = (param->pic_h + (1 << factor_h) - 1) >> factor_h;
+	param->total_mcu = param->mcu_w * param->mcu_h;
+	param->unit_num = ((param->pic_w + 7) >> 3) * ((param->pic_h + 7) >> 3);
+	param->blk_num = 0;
+	for (i = 0; i < MTK_JPEG_COMP_MAX; i++) {
+		param->blk_comp[i] = 0;
+		if (i >= param->comp_num)
+			continue;
+		param->blk_comp[i] = param->sampling_w[i] *
+				     param->sampling_h[i];
+		param->blk_num += param->blk_comp[i];
+	}
+
+	param->membership = 0;
+	for (i = 0, blk = 0, comp = 0; i < MTK_JPEG_BLOCK_MAX; i++) {
+		if (i < param->blk_num && comp < param->comp_num) {
+			u32 tmp;
+
+			tmp = (0x04 + (comp & 0x3));
+			param->membership |= tmp << (i * 3);
+			if (++blk == param->blk_comp[comp]) {
+				comp++;
+				blk = 0;
+			}
+		} else {
+			param->membership |=  7 << (i * 3);
+		}
+	}
+}
+
+static void mtk_jpeg_calc_dma_group(struct mtk_jpeg_dec_param *param)
+{
+	u32 factor_mcu = 3;
+
+	if (param->src_color == MTK_JPEG_COLOR_444 &&
+	    param->dst_fourcc == V4L2_PIX_FMT_YUV422M)
+		factor_mcu = 4;
+	else if (param->src_color == MTK_JPEG_COLOR_422V &&
+		 param->dst_fourcc == V4L2_PIX_FMT_YUV420M)
+		factor_mcu = 4;
+	else if (param->src_color == MTK_JPEG_COLOR_422X2 &&
+		 param->dst_fourcc == V4L2_PIX_FMT_YUV422M)
+		factor_mcu = 2;
+	else if (param->src_color == MTK_JPEG_COLOR_400 ||
+		 (param->src_color & 0x0FFFF) == 0)
+		factor_mcu = 4;
+
+	param->dma_mcu = 1 << factor_mcu;
+	param->dma_group = param->mcu_w / param->dma_mcu;
+	param->dma_last_mcu = param->mcu_w % param->dma_mcu;
+	if (param->dma_last_mcu)
+		param->dma_group++;
+	else
+		param->dma_last_mcu = param->dma_mcu;
+}
+
+static int mtk_jpeg_calc_dst_size(struct mtk_jpeg_dec_param *param)
+{
+	u32 i, padding_w;
+	u32 ds_row_h[3];
+	u32 brz_w[3];
+
+	brz_w[0] = 0;
+	brz_w[1] = param->uv_brz_w;
+	brz_w[2] = brz_w[1];
+
+	for (i = 0; i < param->comp_num; i++) {
+		if (brz_w[i] > 3)
+			return -1;
+
+		padding_w = param->mcu_w * MTK_JPEG_DCTSIZE *
+				param->sampling_w[i];
+		/* output format is 420/422 */
+		param->comp_w[i] = padding_w >> brz_w[i];
+		param->comp_w[i] = mtk_jpeg_align(param->comp_w[i],
+						  MTK_JPEG_DCTSIZE);
+		param->img_stride[i] = i ? mtk_jpeg_align(param->comp_w[i], 16)
+					: mtk_jpeg_align(param->comp_w[i], 32);
+		ds_row_h[i] = (MTK_JPEG_DCTSIZE * param->sampling_h[i]);
+	}
+	param->dec_w = param->img_stride[0];
+	param->dec_h = ds_row_h[0] * param->mcu_h;
+
+	for (i = 0; i < MTK_JPEG_COMP_MAX; i++) {
+		/* They must be equal in frame mode. */
+		param->mem_stride[i] = param->img_stride[i];
+		param->comp_size[i] = param->mem_stride[i] * ds_row_h[i] *
+				      param->mcu_h;
+	}
+
+	param->y_size = param->comp_size[0];
+	param->uv_size = param->comp_size[1];
+	param->dec_size = param->y_size + (param->uv_size << 1);
+
+	return 0;
+}
+
+int mtk_jpeg_dec_fill_param(struct mtk_jpeg_dec_param *param)
+{
+	if (mtk_jpeg_decide_format(param))
+		return -1;
+
+	mtk_jpeg_calc_mcu(param);
+	mtk_jpeg_calc_dma_group(param);
+	if (mtk_jpeg_calc_dst_size(param))
+		return -2;
+
+	return 0;
+}
+
+u32 mtk_jpeg_dec_get_int_status(void __iomem *base)
+{
+	u32 ret;
+
+	ret = readl(base + JPGDEC_REG_INTERRUPT_STATUS) & BIT_INQST_MASK_ALLIRQ;
+	if (ret)
+		writel(ret, base + JPGDEC_REG_INTERRUPT_STATUS);
+
+	return ret;
+}
+
+u32 mtk_jpeg_dec_enum_result(u32 irq_result)
+{
+	if (irq_result & BIT_INQST_MASK_EOF)
+		return MTK_JPEG_DEC_RESULT_EOF_DONE;
+	else if (irq_result & BIT_INQST_MASK_PAUSE)
+		return MTK_JPEG_DEC_RESULT_PAUSE;
+	else if (irq_result & BIT_INQST_MASK_UNDERFLOW)
+		return MTK_JPEG_DEC_RESULT_UNDERFLOW;
+	else if (irq_result & BIT_INQST_MASK_OVERFLOW)
+		return MTK_JPEG_DEC_RESULT_OVERFLOW;
+	else if (irq_result & BIT_INQST_MASK_ERROR_BS)
+		return MTK_JPEG_DEC_RESULT_ERROR_BS;
+
+	return MTK_JPEG_DEC_RESULT_ERROR_UNKNOWN;
+}
+
+void mtk_jpeg_dec_start(void __iomem *base)
+{
+	writel(0, base + JPGDEC_REG_TRIG);
+}
+
+static void mtk_jpeg_dec_soft_reset(void __iomem *base)
+{
+	writel(0x0000FFFF, base + JPGDEC_REG_INTERRUPT_STATUS);
+	writel(0x00, base + JPGDEC_REG_RESET);
+	writel(0x01, base + JPGDEC_REG_RESET);
+}
+
+static void mtk_jpeg_dec_hard_reset(void __iomem *base)
+{
+	writel(0x00, base + JPGDEC_REG_RESET);
+	writel(0x10, base + JPGDEC_REG_RESET);
+}
+
+void mtk_jpeg_dec_reset(void __iomem *base)
+{
+	mtk_jpeg_dec_soft_reset(base);
+	mtk_jpeg_dec_hard_reset(base);
+}
+
+static void mtk_jpeg_dec_set_brz_factor(void __iomem *base, u8 yscale_w,
+					u8 yscale_h, u8 uvscale_w, u8 uvscale_h)
+{
+	u32 val;
+
+	val = (uvscale_h << 12) | (uvscale_w << 8) |
+	      (yscale_h << 4) | yscale_w;
+	writel(val, base + JPGDEC_REG_BRZ_FACTOR);
+}
+
+static void mtk_jpeg_dec_set_dst_bank0(void __iomem *base, u32 addr_y,
+				       u32 addr_u, u32 addr_v)
+{
+	mtk_jpeg_verify_align(addr_y, 16, JPGDEC_REG_DEST_ADDR0_Y);
+	writel(addr_y, base + JPGDEC_REG_DEST_ADDR0_Y);
+	mtk_jpeg_verify_align(addr_u, 16, JPGDEC_REG_DEST_ADDR0_U);
+	writel(addr_u, base + JPGDEC_REG_DEST_ADDR0_U);
+	mtk_jpeg_verify_align(addr_v, 16, JPGDEC_REG_DEST_ADDR0_V);
+	writel(addr_v, base + JPGDEC_REG_DEST_ADDR0_V);
+}
+
+static void mtk_jpeg_dec_set_dst_bank1(void __iomem *base, u32 addr_y,
+				       u32 addr_u, u32 addr_v)
+{
+	writel(addr_y, base + JPGDEC_REG_DEST_ADDR1_Y);
+	writel(addr_u, base + JPGDEC_REG_DEST_ADDR1_U);
+	writel(addr_v, base + JPGDEC_REG_DEST_ADDR1_V);
+}
+
+static void mtk_jpeg_dec_set_mem_stride(void __iomem *base, u32 stride_y,
+					u32 stride_uv)
+{
+	writel((stride_y & 0xFFFF), base + JPGDEC_REG_STRIDE_Y);
+	writel((stride_uv & 0xFFFF), base + JPGDEC_REG_STRIDE_UV);
+}
+
+static void mtk_jpeg_dec_set_img_stride(void __iomem *base, u32 stride_y,
+					u32 stride_uv)
+{
+	writel((stride_y & 0xFFFF), base + JPGDEC_REG_IMG_STRIDE_Y);
+	writel((stride_uv & 0xFFFF), base + JPGDEC_REG_IMG_STRIDE_UV);
+}
+
+static void mtk_jpeg_dec_set_pause_mcu_idx(void __iomem *base, u32 idx)
+{
+	writel(idx & 0x0003FFFFFF, base + JPGDEC_REG_PAUSE_MCU_NUM);
+}
+
+static void mtk_jpeg_dec_set_dec_mode(void __iomem *base, u32 mode)
+{
+	writel(mode & 0x03, base + JPGDEC_REG_OPERATION_MODE);
+}
+
+static void mtk_jpeg_dec_set_bs_write_ptr(void __iomem *base, u32 ptr)
+{
+	mtk_jpeg_verify_align(ptr, 16, JPGDEC_REG_FILE_BRP);
+	writel(ptr, base + JPGDEC_REG_FILE_BRP);
+}
+
+static void mtk_jpeg_dec_set_bs_info(void __iomem *base, u32 addr, u32 size)
+{
+	mtk_jpeg_verify_align(addr, 16, JPGDEC_REG_FILE_ADDR);
+	mtk_jpeg_verify_align(size, 128, JPGDEC_REG_FILE_TOTAL_SIZE);
+	writel(addr, base + JPGDEC_REG_FILE_ADDR);
+	writel(size, base + JPGDEC_REG_FILE_TOTAL_SIZE);
+}
+
+static void mtk_jpeg_dec_set_comp_id(void __iomem *base, u32 id_y, u32 id_u,
+				     u32 id_v)
+{
+	u32 val;
+
+	val = ((id_y & 0x00FF) << 24) | ((id_u & 0x00FF) << 16) |
+	      ((id_v & 0x00FF) << 8);
+	writel(val, base + JPGDEC_REG_COMP_ID);
+}
+
+static void mtk_jpeg_dec_set_total_mcu(void __iomem *base, u32 num)
+{
+	writel(num - 1, base + JPGDEC_REG_TOTAL_MCU_NUM);
+}
+
+static void mtk_jpeg_dec_set_comp0_du(void __iomem *base, u32 num)
+{
+	writel(num - 1, base + JPGDEC_REG_COMP0_DATA_UNIT_NUM);
+}
+
+static void mtk_jpeg_dec_set_du_membership(void __iomem *base, u32 member,
+					   u32 gmc, u32 isgray)
+{
+	if (isgray)
+		member = 0x3FFFFFFC;
+	member |= (isgray << 31) | (gmc << 30);
+	writel(member, base + JPGDEC_REG_DU_CTRL);
+}
+
+static void mtk_jpeg_dec_set_q_table(void __iomem *base, u32 id0, u32 id1,
+				     u32 id2)
+{
+	u32 val;
+
+	val = ((id0 & 0x0f) << 8) | ((id1 & 0x0f) << 4) | ((id2 & 0x0f) << 0);
+	writel(val, base + JPGDEC_REG_QT_ID);
+}
+
+static void mtk_jpeg_dec_set_dma_group(void __iomem *base, u32 mcu_group,
+				       u32 group_num, u32 last_mcu)
+{
+	u32 val;
+
+	val = (((mcu_group - 1) & 0x00FF) << 16) |
+	      (((group_num - 1) & 0x007F) << 8) |
+	      ((last_mcu - 1) & 0x00FF);
+	writel(val, base + JPGDEC_REG_WDMA_CTRL);
+}
+
+static void mtk_jpeg_dec_set_sampling_factor(void __iomem *base, u32 comp_num,
+					     u32 y_w, u32 y_h, u32 u_w,
+					     u32 u_h, u32 v_w, u32 v_h)
+{
+	u32 val;
+	u32 y_wh = (MTK_JPEG_DUNUM_MASK(y_w) << 2) | MTK_JPEG_DUNUM_MASK(y_h);
+	u32 u_wh = (MTK_JPEG_DUNUM_MASK(u_w) << 2) | MTK_JPEG_DUNUM_MASK(u_h);
+	u32 v_wh = (MTK_JPEG_DUNUM_MASK(v_w) << 2) | MTK_JPEG_DUNUM_MASK(v_h);
+
+	if (comp_num == 1)
+		val = 0;
+	else
+		val = (y_wh << 8) | (u_wh << 4) | v_wh;
+	writel(val, base + JPGDEC_REG_DU_NUM);
+}
+
+void mtk_jpeg_dec_set_config(void __iomem *base,
+			     struct mtk_jpeg_dec_param *config,
+			     struct mtk_jpeg_bs *bs,
+			     struct mtk_jpeg_fb *fb)
+{
+	mtk_jpeg_dec_set_brz_factor(base, 0, 0, config->uv_brz_w, 0);
+	mtk_jpeg_dec_set_dec_mode(base, 0);
+	mtk_jpeg_dec_set_comp0_du(base, config->unit_num);
+	mtk_jpeg_dec_set_total_mcu(base, config->total_mcu);
+	mtk_jpeg_dec_set_bs_info(base, bs->str_addr, bs->size);
+	mtk_jpeg_dec_set_bs_write_ptr(base, bs->end_addr);
+	mtk_jpeg_dec_set_du_membership(base, config->membership, 1,
+				       (config->comp_num == 1) ? 1 : 0);
+	mtk_jpeg_dec_set_comp_id(base, config->comp_id[0], config->comp_id[1],
+				 config->comp_id[2]);
+	mtk_jpeg_dec_set_q_table(base, config->qtbl_num[0],
+				 config->qtbl_num[1], config->qtbl_num[2]);
+	mtk_jpeg_dec_set_sampling_factor(base, config->comp_num,
+					 config->sampling_w[0],
+					 config->sampling_h[0],
+					 config->sampling_w[1],
+					 config->sampling_h[1],
+					 config->sampling_w[2],
+					 config->sampling_h[2]);
+	mtk_jpeg_dec_set_mem_stride(base, config->mem_stride[0],
+				    config->mem_stride[1]);
+	mtk_jpeg_dec_set_img_stride(base, config->img_stride[0],
+				    config->img_stride[1]);
+	mtk_jpeg_dec_set_dst_bank0(base, fb->plane_addr[0],
+				   fb->plane_addr[1], fb->plane_addr[2]);
+	mtk_jpeg_dec_set_dst_bank1(base, 0, 0, 0);
+	mtk_jpeg_dec_set_dma_group(base, config->dma_mcu, config->dma_group,
+				   config->dma_last_mcu);
+	mtk_jpeg_dec_set_pause_mcu_idx(base, config->total_mcu);
+}
diff --git a/drivers/media/platform/mtk-jpeg/mtk_jpeg_hw.h b/drivers/media/platform/mtk-jpeg/mtk_jpeg_hw.h
new file mode 100644
index 0000000..37152a6
--- /dev/null
+++ b/drivers/media/platform/mtk-jpeg/mtk_jpeg_hw.h
@@ -0,0 +1,91 @@
+/*
+ * Copyright (c) 2016 MediaTek Inc.
+ * Author: Ming Hsiu Tsai <minghsiu.tsai@mediatek.com>
+ *         Rick Chang <rick.chang@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _MTK_JPEG_HW_H
+#define _MTK_JPEG_HW_H
+
+#include <media/videobuf2-core.h>
+
+#include "mtk_jpeg_core.h"
+#include "mtk_jpeg_reg.h"
+
+enum {
+	MTK_JPEG_DEC_RESULT_EOF_DONE		= 0,
+	MTK_JPEG_DEC_RESULT_PAUSE		= 1,
+	MTK_JPEG_DEC_RESULT_UNDERFLOW		= 2,
+	MTK_JPEG_DEC_RESULT_OVERFLOW		= 3,
+	MTK_JPEG_DEC_RESULT_ERROR_BS		= 4,
+	MTK_JPEG_DEC_RESULT_ERROR_UNKNOWN	= 6
+};
+
+struct mtk_jpeg_dec_param {
+	u32 pic_w;
+	u32 pic_h;
+	u32 dec_w;
+	u32 dec_h;
+	u32 src_color;
+	u32 dst_fourcc;
+	u32 mcu_w;
+	u32 mcu_h;
+	u32 total_mcu;
+	u32 unit_num;
+	u32 comp_num;
+	u32 comp_id[MTK_JPEG_COMP_MAX];
+	u32 sampling_w[MTK_JPEG_COMP_MAX];
+	u32 sampling_h[MTK_JPEG_COMP_MAX];
+	u32 qtbl_num[MTK_JPEG_COMP_MAX];
+	u32 blk_num;
+	u32 blk_comp[MTK_JPEG_COMP_MAX];
+	u32 membership;
+	u32 dma_mcu;
+	u32 dma_group;
+	u32 dma_last_mcu;
+	u32 img_stride[MTK_JPEG_COMP_MAX];
+	u32 mem_stride[MTK_JPEG_COMP_MAX];
+	u32 comp_w[MTK_JPEG_COMP_MAX];
+	u32 comp_size[MTK_JPEG_COMP_MAX];
+	u32 y_size;
+	u32 uv_size;
+	u32 dec_size;
+	u8 uv_brz_w;
+};
+
+static inline u32 mtk_jpeg_align(u32 val, u32 align)
+{
+	return (val + align - 1) & ~(align - 1);
+}
+
+struct mtk_jpeg_bs {
+	dma_addr_t	str_addr;
+	dma_addr_t	end_addr;
+	size_t		size;
+};
+
+struct mtk_jpeg_fb {
+	dma_addr_t	plane_addr[MTK_JPEG_COMP_MAX];
+	size_t		size;
+};
+
+int mtk_jpeg_dec_fill_param(struct mtk_jpeg_dec_param *param);
+u32 mtk_jpeg_dec_get_int_status(void __iomem *dec_reg_base);
+u32 mtk_jpeg_dec_enum_result(u32 irq_result);
+void mtk_jpeg_dec_set_config(void __iomem *base,
+			     struct mtk_jpeg_dec_param *config,
+			     struct mtk_jpeg_bs *bs,
+			     struct mtk_jpeg_fb *fb);
+void mtk_jpeg_dec_reset(void __iomem *dec_reg_base);
+void mtk_jpeg_dec_start(void __iomem *dec_reg_base);
+
+#endif /* _MTK_JPEG_HW_H */
diff --git a/drivers/media/platform/mtk-jpeg/mtk_jpeg_parse.c b/drivers/media/platform/mtk-jpeg/mtk_jpeg_parse.c
new file mode 100644
index 0000000..3886854
--- /dev/null
+++ b/drivers/media/platform/mtk-jpeg/mtk_jpeg_parse.c
@@ -0,0 +1,160 @@
+/*
+ * Copyright (c) 2016 MediaTek Inc.
+ * Author: Ming Hsiu Tsai <minghsiu.tsai@mediatek.com>
+ *         Rick Chang <rick.chang@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/videodev2.h>
+
+#include "mtk_jpeg_parse.h"
+
+#define TEM	0x01
+#define SOF0	0xc0
+#define RST	0xd0
+#define SOI	0xd8
+#define EOI	0xd9
+
+struct mtk_jpeg_stream {
+	u8 *addr;
+	u32 size;
+	u32 curr;
+};
+
+static int read_byte(struct mtk_jpeg_stream *stream)
+{
+	if (stream->curr >= stream->size)
+		return -1;
+	return stream->addr[stream->curr++];
+}
+
+static int read_word_be(struct mtk_jpeg_stream *stream, u32 *word)
+{
+	u32 temp;
+	int byte;
+
+	byte = read_byte(stream);
+	if (byte == -1)
+		return -1;
+	temp = byte << 8;
+	byte = read_byte(stream);
+	if (byte == -1)
+		return -1;
+	*word = (u32)byte | temp;
+
+	return 0;
+}
+
+static void read_skip(struct mtk_jpeg_stream *stream, long len)
+{
+	if (len <= 0)
+		return;
+	while (len--)
+		read_byte(stream);
+}
+
+static bool mtk_jpeg_do_parse(struct mtk_jpeg_dec_param *param, u8 *src_addr_va,
+			      u32 src_size)
+{
+	bool notfound = true;
+	struct mtk_jpeg_stream stream;
+
+	stream.addr = src_addr_va;
+	stream.size = src_size;
+	stream.curr = 0;
+
+	while (notfound) {
+		int i, length, byte;
+		u32 word;
+
+		byte = read_byte(&stream);
+		if (byte == -1)
+			return false;
+		if (byte != 0xff)
+			continue;
+		do
+			byte = read_byte(&stream);
+		while (byte == 0xff);
+		if (byte == -1)
+			return false;
+		if (byte == 0)
+			continue;
+
+		length = 0;
+		switch (byte) {
+		case SOF0:
+			/* length */
+			if (read_word_be(&stream, &word))
+				break;
+
+			/* precision */
+			if (read_byte(&stream) == -1)
+				break;
+
+			if (read_word_be(&stream, &word))
+				break;
+			param->pic_h = word;
+
+			if (read_word_be(&stream, &word))
+				break;
+			param->pic_w = word;
+
+			param->comp_num = read_byte(&stream);
+			if (param->comp_num != 1 && param->comp_num != 3)
+				break;
+
+			for (i = 0; i < param->comp_num; i++) {
+				param->comp_id[i] = read_byte(&stream);
+				if (param->comp_id[i] == -1)
+					break;
+
+				/* sampling */
+				byte = read_byte(&stream);
+				if (byte == -1)
+					break;
+				param->sampling_w[i] = (byte >> 4) & 0x0F;
+				param->sampling_h[i] = byte & 0x0F;
+
+				param->qtbl_num[i] = read_byte(&stream);
+				if (param->qtbl_num[i] == -1)
+					break;
+			}
+
+			notfound = !(i == param->comp_num);
+			break;
+		case RST ... RST + 7:
+		case SOI:
+		case EOI:
+		case TEM:
+			break;
+		default:
+			if (read_word_be(&stream, &word))
+				break;
+			length = (long)word - 2;
+			read_skip(&stream, length);
+			break;
+		}
+	}
+
+	return !notfound;
+}
+
+bool mtk_jpeg_parse(struct mtk_jpeg_dec_param *param, u8 *src_addr_va,
+		    u32 src_size)
+{
+	if (!mtk_jpeg_do_parse(param, src_addr_va, src_size))
+		return false;
+	if (mtk_jpeg_dec_fill_param(param))
+		return false;
+
+	return true;
+}
diff --git a/drivers/media/platform/mtk-jpeg/mtk_jpeg_parse.h b/drivers/media/platform/mtk-jpeg/mtk_jpeg_parse.h
new file mode 100644
index 0000000..5d92340
--- /dev/null
+++ b/drivers/media/platform/mtk-jpeg/mtk_jpeg_parse.h
@@ -0,0 +1,25 @@
+/*
+ * Copyright (c) 2016 MediaTek Inc.
+ * Author: Ming Hsiu Tsai <minghsiu.tsai@mediatek.com>
+ *         Rick Chang <rick.chang@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _MTK_JPEG_PARSE_H
+#define _MTK_JPEG_PARSE_H
+
+#include "mtk_jpeg_hw.h"
+
+bool mtk_jpeg_parse(struct mtk_jpeg_dec_param *param, u8 *src_addr_va,
+		    u32 src_size);
+
+#endif /* _MTK_JPEG_PARSE_H */
+
diff --git a/drivers/media/platform/mtk-jpeg/mtk_jpeg_reg.h b/drivers/media/platform/mtk-jpeg/mtk_jpeg_reg.h
new file mode 100644
index 0000000..fc490d6
--- /dev/null
+++ b/drivers/media/platform/mtk-jpeg/mtk_jpeg_reg.h
@@ -0,0 +1,58 @@
+/*
+ * Copyright (c) 2016 MediaTek Inc.
+ * Author: Ming Hsiu Tsai <minghsiu.tsai@mediatek.com>
+ *         Rick Chang <rick.chang@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _MTK_JPEG_REG_H
+#define _MTK_JPEG_REG_H
+
+#define MTK_JPEG_COMP_MAX		3
+#define MTK_JPEG_BLOCK_MAX		10
+#define MTK_JPEG_DCTSIZE		8
+
+#define BIT_INQST_MASK_ERROR_BS		0x20
+#define BIT_INQST_MASK_PAUSE		0x10
+#define BIT_INQST_MASK_OVERFLOW		0x04
+#define BIT_INQST_MASK_UNDERFLOW	0x02
+#define BIT_INQST_MASK_EOF		0x01
+#define BIT_INQST_MASK_ALLIRQ		0x37
+
+#define JPGDEC_REG_RESET		0x0090
+#define JPGDEC_REG_BRZ_FACTOR		0x00F8
+#define JPGDEC_REG_DU_NUM		0x00FC
+#define JPGDEC_REG_DEST_ADDR0_Y		0x0140
+#define JPGDEC_REG_DEST_ADDR0_U		0x0144
+#define JPGDEC_REG_DEST_ADDR0_V		0x0148
+#define JPGDEC_REG_DEST_ADDR1_Y		0x014C
+#define JPGDEC_REG_DEST_ADDR1_U		0x0150
+#define JPGDEC_REG_DEST_ADDR1_V		0x0154
+#define JPGDEC_REG_STRIDE_Y		0x0158
+#define JPGDEC_REG_STRIDE_UV		0x015C
+#define JPGDEC_REG_IMG_STRIDE_Y		0x0160
+#define JPGDEC_REG_IMG_STRIDE_UV	0x0164
+#define JPGDEC_REG_WDMA_CTRL		0x016C
+#define JPGDEC_REG_PAUSE_MCU_NUM	0x0170
+#define JPGDEC_REG_OPERATION_MODE	0x017C
+#define JPGDEC_REG_FILE_ADDR		0x0200
+#define JPGDEC_REG_COMP_ID		0x020C
+#define JPGDEC_REG_TOTAL_MCU_NUM	0x0210
+#define JPGDEC_REG_COMP0_DATA_UNIT_NUM	0x0224
+#define JPGDEC_REG_DU_CTRL		0x023C
+#define JPGDEC_REG_TRIG			0x0240
+#define JPGDEC_REG_FILE_BRP		0x0248
+#define JPGDEC_REG_FILE_TOTAL_SIZE	0x024C
+#define JPGDEC_REG_QT_ID		0x0270
+#define JPGDEC_REG_INTERRUPT_STATUS	0x0274
+#define JPGDEC_REG_STATUS		0x0278
+
+#endif /* _MTK_JPEG_REG_H */
-- 
1.9.1

