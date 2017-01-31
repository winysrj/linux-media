Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:41258 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751268AbdAaQcY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jan 2017 11:32:24 -0500
From: Hugues Fruchet <hugues.fruchet@st.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <kernel@stlinux.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Subject: [PATCH v5 05/10] [media] st-delta: STiH4xx multi-format video decoder v4l2 driver
Date: Tue, 31 Jan 2017 17:30:28 +0100
Message-ID: <1485880233-666-6-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1485880233-666-1-git-send-email-hugues.fruchet@st.com>
References: <1485880233-666-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This V4L2 driver enables DELTA multi-format video decoder
of STMicroelectronics STiH4xx SoC series.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/platform/Kconfig                |   20 +
 drivers/media/platform/Makefile               |    2 +
 drivers/media/platform/sti/delta/Makefile     |    2 +
 drivers/media/platform/sti/delta/delta-cfg.h  |   61 +
 drivers/media/platform/sti/delta/delta-v4l2.c | 1816 +++++++++++++++++++++++++
 drivers/media/platform/sti/delta/delta.h      |  514 +++++++
 6 files changed, 2415 insertions(+)
 create mode 100644 drivers/media/platform/sti/delta/Makefile
 create mode 100644 drivers/media/platform/sti/delta/delta-cfg.h
 create mode 100644 drivers/media/platform/sti/delta/delta-v4l2.c
 create mode 100644 drivers/media/platform/sti/delta/delta.h

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index d944421..451a33b 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -298,6 +298,26 @@ config VIDEO_STI_HVA
 	  To compile this driver as a module, choose M here:
 	  the module will be called st-hva.
 
+config VIDEO_STI_DELTA
+	tristate "STMicroelectronics STiH4xx DELTA multi-format video decoder V4L2 driver"
+	depends on VIDEO_DEV && VIDEO_V4L2
+	depends on ARCH_STI || COMPILE_TEST
+	depends on HAS_DMA
+	select VIDEOBUF2_DMA_CONTIG
+	select V4L2_MEM2MEM_DEV
+	help
+		This V4L2 driver enables DELTA multi-format video decoder
+		of STMicroelectronics STiH4xx SoC series allowing hardware
+		decoding of various compressed video bitstream format in
+		raw uncompressed format.
+
+		To compile this driver as a module, choose M here:
+		the module will be called st-delta.
+
+if VIDEO_STI_DELTA
+
+endif # VIDEO_STI_DELTA
+
 config VIDEO_SH_VEU
 	tristate "SuperH VEU mem2mem video processing driver"
 	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 5b3cb27..349ddf6 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -39,6 +39,8 @@ obj-$(CONFIG_VIDEO_STI_BDISP)		+= sti/bdisp/
 obj-$(CONFIG_VIDEO_STI_HVA)		+= sti/hva/
 obj-$(CONFIG_DVB_C8SECTPFE)		+= sti/c8sectpfe/
 
+obj-$(CONFIG_VIDEO_STI_DELTA)		+= sti/delta/
+
 obj-$(CONFIG_BLACKFIN)                  += blackfin/
 
 obj-$(CONFIG_ARCH_DAVINCI)		+= davinci/
diff --git a/drivers/media/platform/sti/delta/Makefile b/drivers/media/platform/sti/delta/Makefile
new file mode 100644
index 0000000..07ba7ad
--- /dev/null
+++ b/drivers/media/platform/sti/delta/Makefile
@@ -0,0 +1,2 @@
+obj-$(CONFIG_VIDEO_STI_DELTA) := st-delta.o
+st-delta-y := delta-v4l2.o
diff --git a/drivers/media/platform/sti/delta/delta-cfg.h b/drivers/media/platform/sti/delta/delta-cfg.h
new file mode 100644
index 0000000..f6674f6
--- /dev/null
+++ b/drivers/media/platform/sti/delta/delta-cfg.h
@@ -0,0 +1,61 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2015
+ * Author: Hugues Fruchet <hugues.fruchet@st.com> for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#ifndef DELTA_CFG_H
+#define DELTA_CFG_H
+
+#define DELTA_FW_VERSION "21.1-3"
+
+#define DELTA_MIN_WIDTH  32
+#define DELTA_MAX_WIDTH  4096
+#define DELTA_MIN_HEIGHT 32
+#define DELTA_MAX_HEIGHT 2400
+
+/* DELTA requires a 32x32 pixels alignment for frames */
+#define DELTA_WIDTH_ALIGNMENT    32
+#define DELTA_HEIGHT_ALIGNMENT   32
+
+#define DELTA_DEFAULT_WIDTH  DELTA_MIN_WIDTH
+#define DELTA_DEFAULT_HEIGHT DELTA_MIN_HEIGHT
+#define DELTA_DEFAULT_FRAMEFORMAT  V4L2_PIX_FMT_NV12
+#define DELTA_DEFAULT_STREAMFORMAT V4L2_PIX_FMT_MJPEG
+
+#define DELTA_MAX_RESO (DELTA_MAX_WIDTH * DELTA_MAX_HEIGHT)
+
+/* guard value for number of access units */
+#define DELTA_MAX_AUS 10
+
+/* IP perf dependent, can be tuned */
+#define DELTA_PEAK_FRAME_SMOOTHING 2
+
+/*
+ * guard output frame count:
+ * - at least 1 frame needed for display
+ * - at worst 21
+ *   ( max h264 dpb (16) +
+ *     decoding peak smoothing (2) +
+ *     user display pipeline (3) )
+ */
+#define DELTA_MIN_FRAME_USER    1
+#define DELTA_MAX_DPB           16
+#define DELTA_MAX_FRAME_USER    3 /* platform/use-case dependent */
+#define DELTA_MAX_FRAMES (DELTA_MAX_DPB + DELTA_PEAK_FRAME_SMOOTHING +\
+			  DELTA_MAX_FRAME_USER)
+
+#if DELTA_MAX_FRAMES > VIDEO_MAX_FRAME
+#undef DELTA_MAX_FRAMES
+#define DELTA_MAX_FRAMES (VIDEO_MAX_FRAME)
+#endif
+
+/* extra space to be allocated to store codec specific data per frame */
+#define DELTA_MAX_FRAME_PRIV_SIZE 100
+
+/* PM runtime auto power-off after 5ms of inactivity */
+#define DELTA_HW_AUTOSUSPEND_DELAY_MS 5
+
+#define DELTA_MAX_DECODERS 10
+
+#endif /* DELTA_CFG_H */
diff --git a/drivers/media/platform/sti/delta/delta-v4l2.c b/drivers/media/platform/sti/delta/delta-v4l2.c
new file mode 100644
index 0000000..4c98767
--- /dev/null
+++ b/drivers/media/platform/sti/delta/delta-v4l2.c
@@ -0,0 +1,1816 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2015
+ * Authors: Hugues Fruchet <hugues.fruchet@st.com>
+ *          Jean-Christophe Trotin <jean-christophe.trotin@st.com>
+ *          for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#include <linux/clk.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+#include <linux/slab.h>
+
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-event.h>
+#include <media/videobuf2-dma-contig.h>
+
+#include "delta.h"
+
+#define DELTA_NAME	"st-delta"
+
+#define DELTA_PREFIX "[---:----]"
+
+#define to_ctx(__fh) container_of(__fh, struct delta_ctx, fh)
+#define to_au(__vbuf) container_of(__vbuf, struct delta_au, vbuf)
+#define to_frame(__vbuf) container_of(__vbuf, struct delta_frame, vbuf)
+
+#define call_dec_op(dec, op, args...)\
+		((dec && (dec)->op) ? (dec)->op(args) : 0)
+
+/* registry of available decoders */
+static const struct delta_dec *delta_decoders[] = {
+	NULL
+};
+
+static inline int frame_size(u32 w, u32 h, u32 fmt)
+{
+	switch (fmt) {
+	case V4L2_PIX_FMT_NV12:
+		return (w * h * 3) / 2;
+	default:
+		return 0;
+	}
+}
+
+static inline int frame_stride(u32 w, u32 fmt)
+{
+	switch (fmt) {
+	case V4L2_PIX_FMT_NV12:
+		return w;
+	default:
+		return 0;
+	}
+}
+
+static void dump_au(struct delta_ctx *ctx, struct delta_au *au)
+{
+	struct delta_dev *delta = ctx->dev;
+	u32 size = 10;	/* dump first & last 10 bytes */
+	u8 *data = (u8 *)(au->vaddr);
+
+	if (au->size <= (size * 2))
+		dev_dbg(delta->dev, "%s dump au[%d] dts=%lld size=%d data=%*ph\n",
+			ctx->name, au->vbuf.vb2_buf.index, au->dts, au->size,
+			au->size, data);
+	else
+		dev_dbg(delta->dev, "%s dump au[%d] dts=%lld size=%d data=%*ph..%*ph\n",
+			ctx->name, au->vbuf.vb2_buf.index, au->dts, au->size,
+			size, data, size, data + au->size - size);
+}
+
+static void dump_frame(struct delta_ctx *ctx, struct delta_frame *frame)
+{
+	struct delta_dev *delta = ctx->dev;
+	u32 size = 10;	/* dump first 10 bytes */
+	u8 *data = (u8 *)(frame->vaddr);
+
+	dev_dbg(delta->dev, "%s dump frame[%d] dts=%lld type=%s field=%s data=%*ph\n",
+		ctx->name, frame->index, frame->dts,
+		frame_type_str(frame->flags),
+		frame_field_str(frame->field),
+		size, data);
+}
+
+static void delta_au_done(struct delta_ctx *ctx, struct delta_au *au, int err)
+{
+	struct vb2_v4l2_buffer *vbuf;
+
+	vbuf = &au->vbuf;
+	vbuf->sequence = ctx->au_num++;
+	v4l2_m2m_buf_done(vbuf, err ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
+}
+
+static void delta_frame_done(struct delta_ctx *ctx, struct delta_frame *frame,
+			     int err)
+{
+	struct vb2_v4l2_buffer *vbuf;
+
+	dump_frame(ctx, frame);
+
+	/* decoded frame is now output to user */
+	frame->state |= DELTA_FRAME_OUT;
+
+	vbuf = &frame->vbuf;
+	vbuf->sequence = ctx->frame_num++;
+	v4l2_m2m_buf_done(vbuf, err ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
+
+	ctx->output_frames++;
+}
+
+static void requeue_free_frames(struct delta_ctx *ctx)
+{
+	struct vb2_v4l2_buffer *vbuf;
+	struct delta_frame *frame;
+	unsigned int i;
+
+	/* requeue all free frames */
+	for (i = 0; i < ctx->nb_of_frames; i++) {
+		frame = ctx->frames[i];
+		if (frame->state == DELTA_FRAME_FREE) {
+			vbuf = &frame->vbuf;
+			v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
+			frame->state = DELTA_FRAME_M2M;
+		}
+	}
+}
+
+static int delta_recycle(struct delta_ctx *ctx, struct delta_frame *frame)
+{
+	const struct delta_dec *dec = ctx->dec;
+
+	/* recycle frame on decoder side */
+	call_dec_op(dec, recycle, ctx, frame);
+
+	/* this frame is no more output */
+	frame->state &= ~DELTA_FRAME_OUT;
+
+	/* requeue free frame */
+	if (frame->state == DELTA_FRAME_FREE) {
+		struct vb2_v4l2_buffer *vbuf = &frame->vbuf;
+
+		v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
+		frame->state = DELTA_FRAME_M2M;
+	}
+
+	/* reset other frame fields */
+	frame->flags = 0;
+	frame->dts = 0;
+
+	return 0;
+}
+
+static void delta_push_dts(struct delta_ctx *ctx, u64 val)
+{
+	struct delta_dts *dts;
+
+	dts = kzalloc(sizeof(*dts), GFP_KERNEL);
+	if (!dts)
+		return;
+
+	INIT_LIST_HEAD(&dts->list);
+
+	/*
+	 * protected by global lock acquired
+	 * by V4L2 when calling delta_vb2_au_queue
+	 */
+	dts->val = val;
+	list_add_tail(&dts->list, &ctx->dts);
+}
+
+static void delta_pop_dts(struct delta_ctx *ctx, u64 *val)
+{
+	struct delta_dev *delta = ctx->dev;
+	struct delta_dts *dts;
+
+	/*
+	 * protected by global lock acquired
+	 * by V4L2 when calling delta_vb2_au_queue
+	 */
+	if (list_empty(&ctx->dts)) {
+		dev_warn(delta->dev, "%s no dts to pop ... output dts = 0\n",
+			 ctx->name);
+		*val = 0;
+		return;
+	}
+
+	dts = list_first_entry(&ctx->dts, struct delta_dts, list);
+	list_del(&dts->list);
+
+	*val = dts->val;
+
+	kfree(dts);
+}
+
+static void delta_flush_dts(struct delta_ctx *ctx)
+{
+	struct delta_dts *dts;
+	struct delta_dts *next;
+
+	/*
+	 * protected by global lock acquired
+	 * by V4L2 when calling delta_vb2_au_queue
+	 */
+
+	/* free all pending dts */
+	list_for_each_entry_safe(dts, next, &ctx->dts, list)
+		kfree(dts);
+
+	/* reset list */
+	INIT_LIST_HEAD(&ctx->dts);
+}
+
+static inline int frame_alignment(u32 fmt)
+{
+	switch (fmt) {
+	case V4L2_PIX_FMT_NV12:
+	case V4L2_PIX_FMT_NV21:
+		/* multiple of 2 */
+		return 2;
+	default:
+		return 1;
+	}
+}
+
+static inline int estimated_au_size(u32 w, u32 h)
+{
+	/*
+	 * for a MJPEG stream encoded from YUV422 pixel format,
+	 * assuming a compression ratio of 2, the maximum size
+	 * of an access unit is (width x height x 2) / 2,
+	 * so (width x height)
+	 */
+	return (w * h);
+}
+
+static void set_default_params(struct delta_ctx *ctx)
+{
+	struct delta_frameinfo *frameinfo = &ctx->frameinfo;
+	struct delta_streaminfo *streaminfo = &ctx->streaminfo;
+
+	memset(frameinfo, 0, sizeof(*frameinfo));
+	frameinfo->pixelformat = V4L2_PIX_FMT_NV12;
+	frameinfo->width = DELTA_DEFAULT_WIDTH;
+	frameinfo->height = DELTA_DEFAULT_HEIGHT;
+	frameinfo->aligned_width = ALIGN(frameinfo->width,
+					 DELTA_WIDTH_ALIGNMENT);
+	frameinfo->aligned_height = ALIGN(frameinfo->height,
+					  DELTA_HEIGHT_ALIGNMENT);
+	frameinfo->size = frame_size(frameinfo->aligned_width,
+				     frameinfo->aligned_height,
+				     frameinfo->pixelformat);
+	frameinfo->field = V4L2_FIELD_NONE;
+	frameinfo->colorspace = V4L2_COLORSPACE_REC709;
+	frameinfo->xfer_func = V4L2_XFER_FUNC_DEFAULT;
+	frameinfo->ycbcr_enc = V4L2_YCBCR_ENC_DEFAULT;
+	frameinfo->quantization = V4L2_QUANTIZATION_DEFAULT;
+
+	memset(streaminfo, 0, sizeof(*streaminfo));
+	streaminfo->streamformat = DELTA_DEFAULT_STREAMFORMAT;
+	streaminfo->width = DELTA_DEFAULT_WIDTH;
+	streaminfo->height = DELTA_DEFAULT_HEIGHT;
+	streaminfo->field = V4L2_FIELD_NONE;
+	streaminfo->colorspace = V4L2_COLORSPACE_REC709;
+	streaminfo->xfer_func = V4L2_XFER_FUNC_DEFAULT;
+	streaminfo->ycbcr_enc = V4L2_YCBCR_ENC_DEFAULT;
+	streaminfo->quantization = V4L2_QUANTIZATION_DEFAULT;
+
+	ctx->max_au_size = estimated_au_size(streaminfo->width,
+					     streaminfo->height);
+}
+
+static const struct delta_dec *delta_find_decoder(struct delta_ctx *ctx,
+						  u32 streamformat,
+						  u32 pixelformat)
+{
+	struct delta_dev *delta = ctx->dev;
+	const struct delta_dec *dec;
+	unsigned int i;
+
+	for (i = 0; i < delta->nb_of_decoders; i++) {
+		dec = delta->decoders[i];
+		if ((dec->pixelformat == pixelformat) &&
+		    (dec->streamformat == streamformat))
+			return dec;
+	}
+
+	return NULL;
+}
+
+static void register_format(u32 format, u32 formats[], u32 *nb_of_formats)
+{
+	u32 i;
+
+	for (i = 0; i < *nb_of_formats; i++) {
+		if (format == formats[i])
+			return;
+	}
+
+	formats[(*nb_of_formats)++] = format;
+}
+
+static void register_formats(struct delta_dev *delta)
+{
+	unsigned int i;
+
+	for (i = 0; i < delta->nb_of_decoders; i++) {
+		register_format(delta->decoders[i]->pixelformat,
+				delta->pixelformats,
+				&delta->nb_of_pixelformats);
+
+		register_format(delta->decoders[i]->streamformat,
+				delta->streamformats,
+				&delta->nb_of_streamformats);
+	}
+}
+
+static void register_decoders(struct delta_dev *delta)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(delta_decoders); i++) {
+		if (!delta_decoders[i])
+			return;
+		if (delta->nb_of_decoders >= DELTA_MAX_DECODERS) {
+			dev_dbg(delta->dev,
+				"%s failed to register %s decoder (%d maximum reached)\n",
+				DELTA_PREFIX, delta_decoders[i]->name,
+				DELTA_MAX_DECODERS);
+			return;
+		}
+
+		delta->decoders[delta->nb_of_decoders++] = delta_decoders[i];
+		dev_info(delta->dev, "%s %s decoder registered\n",
+			 DELTA_PREFIX, delta_decoders[i]->name);
+	}
+}
+
+static void delta_lock(void *priv)
+{
+	struct delta_ctx *ctx = priv;
+	struct delta_dev *delta = ctx->dev;
+
+	mutex_lock(&delta->lock);
+}
+
+static void delta_unlock(void *priv)
+{
+	struct delta_ctx *ctx = priv;
+	struct delta_dev *delta = ctx->dev;
+
+	mutex_unlock(&delta->lock);
+}
+
+static int delta_open_decoder(struct delta_ctx *ctx, u32 streamformat,
+			      u32 pixelformat, const struct delta_dec **pdec)
+{
+	struct delta_dev *delta = ctx->dev;
+	const struct delta_dec *dec;
+	int ret;
+
+	dec = delta_find_decoder(ctx, streamformat, ctx->frameinfo.pixelformat);
+	if (!dec) {
+		dev_err(delta->dev, "%s no decoder found matching %4.4s => %4.4s\n",
+			ctx->name, (char *)&streamformat, (char *)&pixelformat);
+		return -EINVAL;
+	}
+
+	dev_dbg(delta->dev, "%s one decoder matching %4.4s => %4.4s\n",
+		ctx->name, (char *)&streamformat, (char *)&pixelformat);
+
+	/* update instance name */
+	snprintf(ctx->name, sizeof(ctx->name), "[%3d:%4.4s]",
+		 delta->instance_id, (char *)&streamformat);
+
+	/* open decoder instance */
+	ret = call_dec_op(dec, open, ctx);
+	if (ret) {
+		dev_err(delta->dev, "%s failed to open decoder instance (%d)\n",
+			ctx->name, ret);
+		return ret;
+	}
+
+	dev_dbg(delta->dev, "%s %s decoder opened\n", ctx->name, dec->name);
+
+	*pdec = dec;
+
+	return ret;
+}
+
+/*
+ * V4L2 ioctl operations
+ */
+
+static int delta_querycap(struct file *file, void *priv,
+			  struct v4l2_capability *cap)
+{
+	struct delta_ctx *ctx = to_ctx(file->private_data);
+	struct delta_dev *delta = ctx->dev;
+
+	strlcpy(cap->driver, DELTA_NAME, sizeof(cap->driver));
+	strlcpy(cap->card, delta->vdev->name, sizeof(cap->card));
+	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
+		 delta->pdev->name);
+
+	return 0;
+}
+
+static int delta_enum_fmt_stream(struct file *file, void *priv,
+				 struct v4l2_fmtdesc *f)
+{
+	struct delta_ctx *ctx = to_ctx(file->private_data);
+	struct delta_dev *delta = ctx->dev;
+
+	if (unlikely(f->index >= delta->nb_of_streamformats))
+		return -EINVAL;
+
+	f->pixelformat = delta->streamformats[f->index];
+
+	return 0;
+}
+
+static int delta_enum_fmt_frame(struct file *file, void *priv,
+				struct v4l2_fmtdesc *f)
+{
+	struct delta_ctx *ctx = to_ctx(file->private_data);
+	struct delta_dev *delta = ctx->dev;
+
+	if (unlikely(f->index >= delta->nb_of_pixelformats))
+		return -EINVAL;
+
+	f->pixelformat = delta->pixelformats[f->index];
+
+	return 0;
+}
+
+static int delta_g_fmt_stream(struct file *file, void *fh,
+			      struct v4l2_format *f)
+{
+	struct delta_ctx *ctx = to_ctx(file->private_data);
+	struct delta_dev *delta = ctx->dev;
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	struct delta_streaminfo *streaminfo = &ctx->streaminfo;
+
+	if (!(ctx->flags & DELTA_FLAG_STREAMINFO))
+		dev_dbg(delta->dev,
+			"%s V4L2 GET_FMT (OUTPUT): no stream information available, using default\n",
+			ctx->name);
+
+	pix->pixelformat = streaminfo->streamformat;
+	pix->width = streaminfo->width;
+	pix->height = streaminfo->height;
+	pix->field = streaminfo->field;
+	pix->bytesperline = 0;
+	pix->sizeimage = ctx->max_au_size;
+	pix->colorspace = streaminfo->colorspace;
+	pix->xfer_func = streaminfo->xfer_func;
+	pix->ycbcr_enc = streaminfo->ycbcr_enc;
+	pix->quantization = streaminfo->quantization;
+
+	return 0;
+}
+
+static int delta_g_fmt_frame(struct file *file, void *fh, struct v4l2_format *f)
+{
+	struct delta_ctx *ctx = to_ctx(file->private_data);
+	struct delta_dev *delta = ctx->dev;
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	struct delta_frameinfo *frameinfo = &ctx->frameinfo;
+	struct delta_streaminfo *streaminfo = &ctx->streaminfo;
+
+	if (!(ctx->flags & DELTA_FLAG_FRAMEINFO))
+		dev_dbg(delta->dev,
+			"%s V4L2 GET_FMT (CAPTURE): no frame information available, using default\n",
+			ctx->name);
+
+	pix->pixelformat = frameinfo->pixelformat;
+	pix->width = frameinfo->aligned_width;
+	pix->height = frameinfo->aligned_height;
+	pix->field = frameinfo->field;
+	pix->bytesperline = frame_stride(frameinfo->aligned_width,
+					       frameinfo->pixelformat);
+	pix->sizeimage = frameinfo->size;
+
+	if (ctx->flags & DELTA_FLAG_STREAMINFO) {
+		/* align colorspace & friends on stream ones if any set */
+		frameinfo->colorspace = streaminfo->colorspace;
+		frameinfo->xfer_func = streaminfo->xfer_func;
+		frameinfo->ycbcr_enc = streaminfo->ycbcr_enc;
+		frameinfo->quantization = streaminfo->quantization;
+	}
+	pix->colorspace = frameinfo->colorspace;
+	pix->xfer_func = frameinfo->xfer_func;
+	pix->ycbcr_enc = frameinfo->ycbcr_enc;
+	pix->quantization = frameinfo->quantization;
+
+	return 0;
+}
+
+static int delta_try_fmt_stream(struct file *file, void *priv,
+				struct v4l2_format *f)
+{
+	struct delta_ctx *ctx = to_ctx(file->private_data);
+	struct delta_dev *delta = ctx->dev;
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	u32 streamformat = pix->pixelformat;
+	const struct delta_dec *dec;
+	u32 width, height;
+	u32 au_size;
+
+	dec = delta_find_decoder(ctx, streamformat, ctx->frameinfo.pixelformat);
+	if (!dec) {
+		dev_dbg(delta->dev,
+			"%s V4L2 TRY_FMT (OUTPUT): unsupported format %4.4s\n",
+			ctx->name, (char *)&pix->pixelformat);
+		return -EINVAL;
+	}
+
+	/* adjust width & height */
+	width = pix->width;
+	height = pix->height;
+	v4l_bound_align_image
+		(&pix->width,
+		 DELTA_MIN_WIDTH,
+		 dec->max_width ? dec->max_width : DELTA_MAX_WIDTH,
+		 0,
+		 &pix->height,
+		 DELTA_MIN_HEIGHT,
+		 dec->max_height ? dec->max_height : DELTA_MAX_HEIGHT,
+		 0, 0);
+
+	if ((pix->width != width) || (pix->height != height))
+		dev_dbg(delta->dev,
+			"%s V4L2 TRY_FMT (OUTPUT): resolution updated %dx%d -> %dx%d to fit min/max/alignment\n",
+			ctx->name, width, height,
+			pix->width, pix->height);
+
+	au_size = estimated_au_size(pix->width, pix->height);
+	if (pix->sizeimage < au_size) {
+		dev_dbg(delta->dev,
+			"%s V4L2 TRY_FMT (OUTPUT): size updated %d -> %d to fit estimated size\n",
+			ctx->name, pix->sizeimage, au_size);
+		pix->sizeimage = au_size;
+	}
+
+	pix->bytesperline = 0;
+
+	if (pix->field == V4L2_FIELD_ANY)
+		pix->field = V4L2_FIELD_NONE;
+
+	return 0;
+}
+
+static int delta_try_fmt_frame(struct file *file, void *priv,
+			       struct v4l2_format *f)
+{
+	struct delta_ctx *ctx = to_ctx(file->private_data);
+	struct delta_dev *delta = ctx->dev;
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	u32 pixelformat = pix->pixelformat;
+	const struct delta_dec *dec;
+	u32 width, height;
+
+	dec = delta_find_decoder(ctx, ctx->streaminfo.streamformat,
+				 pixelformat);
+	if (!dec) {
+		dev_dbg(delta->dev,
+			"%s V4L2 TRY_FMT (CAPTURE): unsupported format %4.4s\n",
+			ctx->name, (char *)&pixelformat);
+		return -EINVAL;
+	}
+
+	/* adjust width & height */
+	width = pix->width;
+	height = pix->height;
+	v4l_bound_align_image(&pix->width,
+			      DELTA_MIN_WIDTH, DELTA_MAX_WIDTH,
+			      frame_alignment(pixelformat) - 1,
+			      &pix->height,
+			      DELTA_MIN_HEIGHT, DELTA_MAX_HEIGHT,
+			      frame_alignment(pixelformat) - 1, 0);
+
+	if ((pix->width != width) || (pix->height != height))
+		dev_dbg(delta->dev,
+			"%s V4L2 TRY_FMT (CAPTURE): resolution updated %dx%d -> %dx%d to fit min/max/alignment\n",
+			ctx->name, width, height, pix->width, pix->height);
+
+	/* default decoder alignment constraint */
+	width = ALIGN(pix->width, DELTA_WIDTH_ALIGNMENT);
+	height = ALIGN(pix->height, DELTA_HEIGHT_ALIGNMENT);
+	if ((pix->width != width) || (pix->height != height))
+		dev_dbg(delta->dev,
+			"%s V4L2 TRY_FMT (CAPTURE): resolution updated %dx%d -> %dx%d to fit decoder alignment\n",
+			ctx->name, width, height, pix->width, pix->height);
+
+	if (!pix->colorspace) {
+		pix->colorspace = V4L2_COLORSPACE_REC709;
+		pix->xfer_func = V4L2_XFER_FUNC_DEFAULT;
+		pix->ycbcr_enc = V4L2_YCBCR_ENC_DEFAULT;
+		pix->quantization = V4L2_QUANTIZATION_DEFAULT;
+	}
+
+	pix->width = width;
+	pix->height = height;
+	pix->bytesperline = frame_stride(pix->width, pixelformat);
+	pix->sizeimage = frame_size(pix->width, pix->height, pixelformat);
+
+	if (pix->field == V4L2_FIELD_ANY)
+		pix->field = V4L2_FIELD_NONE;
+
+	return 0;
+}
+
+static int delta_s_fmt_stream(struct file *file, void *fh,
+			      struct v4l2_format *f)
+{
+	struct delta_ctx *ctx = to_ctx(file->private_data);
+	struct delta_dev *delta = ctx->dev;
+	struct vb2_queue *vq;
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	int ret;
+
+	ret = delta_try_fmt_stream(file, fh, f);
+	if (ret) {
+		dev_dbg(delta->dev,
+			"%s V4L2 S_FMT (OUTPUT): unsupported format %4.4s\n",
+			ctx->name, (char *)&pix->pixelformat);
+		return ret;
+	}
+
+	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
+	if (vb2_is_streaming(vq)) {
+		dev_dbg(delta->dev, "%s V4L2 S_FMT (OUTPUT): queue busy\n",
+			ctx->name);
+		return -EBUSY;
+	}
+
+	ctx->max_au_size = pix->sizeimage;
+	ctx->streaminfo.width = pix->width;
+	ctx->streaminfo.height = pix->height;
+	ctx->streaminfo.streamformat = pix->pixelformat;
+	ctx->streaminfo.colorspace = pix->colorspace;
+	ctx->streaminfo.xfer_func = pix->xfer_func;
+	ctx->streaminfo.ycbcr_enc = pix->ycbcr_enc;
+	ctx->streaminfo.quantization = pix->quantization;
+	ctx->flags |= DELTA_FLAG_STREAMINFO;
+
+	return 0;
+}
+
+static int delta_s_fmt_frame(struct file *file, void *fh, struct v4l2_format *f)
+{
+	struct delta_ctx *ctx = to_ctx(file->private_data);
+	struct delta_dev *delta = ctx->dev;
+	const struct delta_dec *dec = ctx->dec;
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	struct delta_frameinfo frameinfo;
+	struct vb2_queue *vq;
+	int ret;
+
+	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
+	if (vb2_is_streaming(vq)) {
+		dev_dbg(delta->dev, "%s V4L2 S_FMT (CAPTURE): queue busy\n",
+			ctx->name);
+		return -EBUSY;
+	}
+
+	if (ctx->state < DELTA_STATE_READY) {
+		/*
+		 * decoder not yet opened and valid stream header not found,
+		 * could not negotiate format with decoder, check at least
+		 * pixel format & negotiate resolution boundaries
+		 * and alignment...
+		 */
+		ret = delta_try_fmt_frame(file, fh, f);
+		if (ret) {
+			dev_dbg(delta->dev,
+				"%s V4L2 S_FMT (CAPTURE): unsupported format %4.4s\n",
+				ctx->name, (char *)&pix->pixelformat);
+			return ret;
+		}
+
+		return 0;
+	}
+
+	/* set frame information to decoder */
+	memset(&frameinfo, 0, sizeof(frameinfo));
+	frameinfo.pixelformat = pix->pixelformat;
+	frameinfo.width = pix->width;
+	frameinfo.height = pix->height;
+	frameinfo.aligned_width = pix->width;
+	frameinfo.aligned_height = pix->height;
+	frameinfo.size = pix->sizeimage;
+	frameinfo.field = pix->field;
+	frameinfo.colorspace = pix->colorspace;
+	frameinfo.xfer_func = pix->xfer_func;
+	frameinfo.ycbcr_enc = pix->ycbcr_enc;
+	frameinfo.quantization = pix->quantization;
+	ret = call_dec_op(dec, set_frameinfo, ctx, &frameinfo);
+	if (ret)
+		return ret;
+
+	/* then get what decoder can really do */
+	ret = call_dec_op(dec, get_frameinfo, ctx, &frameinfo);
+	if (ret)
+		return ret;
+
+	ctx->flags |= DELTA_FLAG_FRAMEINFO;
+	ctx->frameinfo = frameinfo;
+
+	pix->pixelformat = frameinfo.pixelformat;
+	pix->width = frameinfo.aligned_width;
+	pix->height = frameinfo.aligned_height;
+	pix->bytesperline = frame_stride(pix->width, pix->pixelformat);
+	pix->sizeimage = frameinfo.size;
+	pix->field = frameinfo.field;
+	pix->colorspace = frameinfo.colorspace;
+	pix->xfer_func = frameinfo.xfer_func;
+	pix->ycbcr_enc = frameinfo.ycbcr_enc;
+	pix->quantization = frameinfo.quantization;
+
+	return 0;
+}
+
+static int delta_g_selection(struct file *file, void *fh,
+			     struct v4l2_selection *s)
+{
+	struct delta_ctx *ctx = to_ctx(fh);
+	struct delta_frameinfo *frameinfo = &ctx->frameinfo;
+	struct v4l2_rect crop;
+
+	if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	if ((ctx->flags & DELTA_FLAG_FRAMEINFO) &&
+	    (frameinfo->flags & DELTA_FRAMEINFO_FLAG_CROP)) {
+		crop = frameinfo->crop;
+	} else {
+		/* default to video dimensions */
+		crop.left = 0;
+		crop.top = 0;
+		crop.width = frameinfo->width;
+		crop.height = frameinfo->height;
+	}
+
+	switch (s->target) {
+	case V4L2_SEL_TGT_COMPOSE:
+	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
+		/* visible area inside video */
+		s->r = crop;
+		break;
+	case V4L2_SEL_TGT_COMPOSE_PADDED:
+	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
+		/* up to aligned dimensions */
+		s->r.left = 0;
+		s->r.top = 0;
+		s->r.width = frameinfo->aligned_width;
+		s->r.height = frameinfo->aligned_height;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/* v4l2 ioctl ops */
+static const struct v4l2_ioctl_ops delta_ioctl_ops = {
+	.vidioc_querycap = delta_querycap,
+	.vidioc_enum_fmt_vid_cap = delta_enum_fmt_frame,
+	.vidioc_g_fmt_vid_cap = delta_g_fmt_frame,
+	.vidioc_try_fmt_vid_cap = delta_try_fmt_frame,
+	.vidioc_s_fmt_vid_cap = delta_s_fmt_frame,
+	.vidioc_enum_fmt_vid_out = delta_enum_fmt_stream,
+	.vidioc_g_fmt_vid_out = delta_g_fmt_stream,
+	.vidioc_try_fmt_vid_out = delta_try_fmt_stream,
+	.vidioc_s_fmt_vid_out = delta_s_fmt_stream,
+	.vidioc_reqbufs = v4l2_m2m_ioctl_reqbufs,
+	.vidioc_create_bufs = v4l2_m2m_ioctl_create_bufs,
+	.vidioc_querybuf = v4l2_m2m_ioctl_querybuf,
+	.vidioc_expbuf = v4l2_m2m_ioctl_expbuf,
+	.vidioc_qbuf = v4l2_m2m_ioctl_qbuf,
+	.vidioc_dqbuf = v4l2_m2m_ioctl_dqbuf,
+	.vidioc_streamon = v4l2_m2m_ioctl_streamon,
+	.vidioc_streamoff = v4l2_m2m_ioctl_streamoff,
+	.vidioc_g_selection = delta_g_selection,
+};
+
+/*
+ * mem-to-mem operations
+ */
+
+static void delta_run_work(struct work_struct *work)
+{
+	struct delta_ctx *ctx = container_of(work, struct delta_ctx, run_work);
+	struct delta_dev *delta = ctx->dev;
+	const struct delta_dec *dec = ctx->dec;
+	struct delta_au *au;
+	struct delta_frame *frame = NULL;
+	int ret = 0;
+	bool discard = false;
+	struct vb2_v4l2_buffer *vbuf;
+
+	if (!dec) {
+		dev_err(delta->dev, "%s no decoder opened yet\n", ctx->name);
+		return;
+	}
+
+	/* protect instance against reentrancy */
+	mutex_lock(&ctx->lock);
+
+	vbuf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
+	if (!vbuf) {
+		dev_err(delta->dev, "%s no buffer to decode\n", ctx->name);
+		mutex_unlock(&ctx->lock);
+		return;
+	}
+	au = to_au(vbuf);
+	au->size = vb2_get_plane_payload(&vbuf->vb2_buf, 0);
+	au->dts = vbuf->vb2_buf.timestamp;
+
+	/* dump access unit */
+	dump_au(ctx, au);
+
+	/* enable the hardware */
+	if (!dec->pm) {
+		ret = delta_get_sync(ctx);
+		if (ret)
+			goto err;
+	}
+
+	/* decode this access unit */
+	ret = call_dec_op(dec, decode, ctx, au);
+
+	/*
+	 * if the (-ENODATA) value is returned, it refers to the interlaced
+	 * stream case for which 2 access units are needed to get 1 frame.
+	 * So, this returned value doesn't mean that the decoding fails, but
+	 * indicates that the timestamp information of the access unit shall
+	 * not be taken into account, and that the V4L2 buffer associated with
+	 * the access unit shall be flagged with V4L2_BUF_FLAG_ERROR to inform
+	 * the user of this situation
+	 */
+	if (ret == -ENODATA) {
+		discard = true;
+	} else if (ret) {
+		dev_err(delta->dev, "%s decoding failed (%d)\n",
+			ctx->name, ret);
+
+		/* disable the hardware */
+		if (!dec->pm)
+			delta_put_autosuspend(ctx);
+
+		goto err;
+	}
+
+	/* disable the hardware */
+	if (!dec->pm)
+		delta_put_autosuspend(ctx);
+
+	/* push au timestamp in FIFO */
+	if (!discard)
+		delta_push_dts(ctx, au->dts);
+
+	/* get available decoded frames */
+	while (1) {
+		ret = call_dec_op(dec, get_frame, ctx, &frame);
+		if (ret == -ENODATA) {
+			/* no more decoded frames */
+			goto out;
+		}
+		if (ret) {
+			dev_err(delta->dev, "%s  cannot get decoded frame (%d)\n",
+				ctx->name, ret);
+			goto out;
+		}
+		if (!frame) {
+			dev_err(delta->dev,
+				"%s  NULL decoded frame\n",
+				ctx->name);
+			ret = -EIO;
+			goto out;
+		}
+
+		/* pop timestamp and mark frame with it */
+		delta_pop_dts(ctx, &frame->dts);
+
+		/* release decoded frame to user */
+		delta_frame_done(ctx, frame, 0);
+	}
+
+out:
+	requeue_free_frames(ctx);
+	delta_au_done(ctx, au, (discard ? -ENODATA : 0));
+	mutex_unlock(&ctx->lock);
+	v4l2_m2m_job_finish(delta->m2m_dev, ctx->fh.m2m_ctx);
+	return;
+
+err:
+	requeue_free_frames(ctx);
+	delta_au_done(ctx, au, ret);
+	mutex_unlock(&ctx->lock);
+	v4l2_m2m_job_finish(delta->m2m_dev, ctx->fh.m2m_ctx);
+}
+
+static void delta_device_run(void *priv)
+{
+	struct delta_ctx *ctx = priv;
+	struct delta_dev *delta = ctx->dev;
+
+	queue_work(delta->work_queue, &ctx->run_work);
+}
+
+static void delta_job_abort(void *priv)
+{
+	struct delta_ctx *ctx = priv;
+	struct delta_dev *delta = ctx->dev;
+
+	dev_dbg(delta->dev, "%s aborting job\n", ctx->name);
+
+	ctx->aborting = true;
+}
+
+static int delta_job_ready(void *priv)
+{
+	struct delta_ctx *ctx = priv;
+	struct delta_dev *delta = ctx->dev;
+	int src_bufs = v4l2_m2m_num_src_bufs_ready(ctx->fh.m2m_ctx);
+
+	if (!src_bufs) {
+		dev_dbg(delta->dev, "%s not ready: not enough video buffers.\n",
+			ctx->name);
+		return 0;
+	}
+
+	if (!v4l2_m2m_num_dst_bufs_ready(ctx->fh.m2m_ctx)) {
+		dev_dbg(delta->dev, "%s not ready: not enough video capture buffers.\n",
+			ctx->name);
+		return 0;
+	}
+
+	if (ctx->aborting) {
+		dev_dbg(delta->dev, "%s job not ready: aborting\n", ctx->name);
+		return 0;
+	}
+
+	dev_dbg(delta->dev, "%s job ready\n", ctx->name);
+
+	return 1;
+}
+
+/* mem-to-mem ops */
+static struct v4l2_m2m_ops delta_m2m_ops = {
+	.device_run     = delta_device_run,
+	.job_ready	= delta_job_ready,
+	.job_abort      = delta_job_abort,
+	.lock		= delta_lock,
+	.unlock		= delta_unlock,
+};
+
+/*
+ * VB2 queue operations
+ */
+
+static int delta_vb2_au_queue_setup(struct vb2_queue *vq,
+				    unsigned int *num_buffers,
+				    unsigned int *num_planes,
+				    unsigned int sizes[],
+				    struct device *alloc_devs[])
+{
+	struct delta_ctx *ctx = vb2_get_drv_priv(vq);
+	unsigned int size = ctx->max_au_size;
+
+	if (*num_planes)
+		return sizes[0] < size ? -EINVAL : 0;
+
+	*num_planes = 1;
+	if (*num_buffers < 1)
+		*num_buffers = 1;
+	if (*num_buffers > DELTA_MAX_AUS)
+		*num_buffers = DELTA_MAX_AUS;
+
+	sizes[0] = size;
+
+	return 0;
+}
+
+static int delta_vb2_au_prepare(struct vb2_buffer *vb)
+{
+	struct vb2_queue *q = vb->vb2_queue;
+	struct delta_ctx *ctx = vb2_get_drv_priv(q);
+	struct delta_dev *delta = ctx->dev;
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct delta_au *au = to_au(vbuf);
+
+	if (!au->prepared) {
+		/* get memory addresses */
+		au->vaddr = vb2_plane_vaddr(&au->vbuf.vb2_buf, 0);
+		au->paddr = vb2_dma_contig_plane_dma_addr
+				(&au->vbuf.vb2_buf, 0);
+		au->prepared = true;
+		dev_dbg(delta->dev, "%s au[%d] prepared; virt=0x%p, phy=0x%pad\n",
+			ctx->name, vb->index, au->vaddr, &au->paddr);
+	}
+
+	if (vbuf->field == V4L2_FIELD_ANY)
+		vbuf->field = V4L2_FIELD_NONE;
+
+	return 0;
+}
+
+static int delta_setup_frame(struct delta_ctx *ctx,
+			     struct delta_frame *frame)
+{
+	struct delta_dev *delta = ctx->dev;
+	const struct delta_dec *dec = ctx->dec;
+
+	if (frame->index >= DELTA_MAX_FRAMES) {
+		dev_err(delta->dev,
+			"%s frame index=%d exceeds output frame count (%d)\n",
+			ctx->name, frame->index, DELTA_MAX_FRAMES);
+		return -EINVAL;
+	}
+
+	if (ctx->nb_of_frames >= DELTA_MAX_FRAMES) {
+		dev_err(delta->dev,
+			"%s number of frames exceeds output frame count (%d > %d)\n",
+			ctx->name, ctx->nb_of_frames, DELTA_MAX_FRAMES);
+		return -EINVAL;
+	}
+
+	if (frame->index != ctx->nb_of_frames) {
+		dev_warn(delta->dev,
+			 "%s frame index discontinuity detected, expected %d, got %d\n",
+			 ctx->name, ctx->nb_of_frames, frame->index);
+	}
+
+	frame->state = DELTA_FRAME_FREE;
+	ctx->frames[ctx->nb_of_frames] = frame;
+	ctx->nb_of_frames++;
+
+	/* setup frame on decoder side */
+	return call_dec_op(dec, setup_frame, ctx, frame);
+}
+
+/*
+ * default implementation of get_frameinfo decoder ops
+ * matching frame information from stream information
+ * & with default pixel format & default alignment.
+ */
+int delta_get_frameinfo_default(struct delta_ctx *ctx,
+				struct delta_frameinfo *frameinfo)
+{
+	struct delta_streaminfo *streaminfo = &ctx->streaminfo;
+
+	memset(frameinfo, 0, sizeof(*frameinfo));
+	frameinfo->pixelformat = V4L2_PIX_FMT_NV12;
+	frameinfo->width = streaminfo->width;
+	frameinfo->height = streaminfo->height;
+	frameinfo->aligned_width = ALIGN(streaminfo->width,
+					 DELTA_WIDTH_ALIGNMENT);
+	frameinfo->aligned_height = ALIGN(streaminfo->height,
+					  DELTA_HEIGHT_ALIGNMENT);
+	frameinfo->size = frame_size(frameinfo->aligned_width,
+				     frameinfo->aligned_height,
+				     frameinfo->pixelformat);
+	if (streaminfo->flags & DELTA_STREAMINFO_FLAG_CROP) {
+		frameinfo->flags |= DELTA_FRAMEINFO_FLAG_CROP;
+		frameinfo->crop = streaminfo->crop;
+	}
+	if (streaminfo->flags & DELTA_STREAMINFO_FLAG_PIXELASPECT) {
+		frameinfo->flags |= DELTA_FRAMEINFO_FLAG_PIXELASPECT;
+		frameinfo->pixelaspect = streaminfo->pixelaspect;
+	}
+	frameinfo->field = streaminfo->field;
+
+	return 0;
+}
+
+/*
+ * default implementation of recycle decoder ops
+ * consisting to relax the "decoded" frame state
+ */
+int delta_recycle_default(struct delta_ctx *pctx,
+			  struct delta_frame *frame)
+{
+	frame->state &= ~DELTA_FRAME_DEC;
+
+	return 0;
+}
+
+static void dump_frames_status(struct delta_ctx *ctx)
+{
+	struct delta_dev *delta = ctx->dev;
+	unsigned int i;
+	struct delta_frame *frame;
+	unsigned char str[100] = "";
+
+	dev_info(delta->dev,
+		 "%s dumping frames status...\n", ctx->name);
+
+	for (i = 0; i < ctx->nb_of_frames; i++) {
+		frame = ctx->frames[i];
+		dev_info(delta->dev,
+			 "%s frame[%d] %s\n",
+			 ctx->name, frame->index,
+			 frame_state_str(frame->state,
+					 str, sizeof(str)));
+	}
+}
+
+int delta_get_free_frame(struct delta_ctx *ctx,
+			 struct delta_frame **pframe)
+{
+	struct delta_dev *delta = ctx->dev;
+	struct vb2_v4l2_buffer *vbuf;
+	struct delta_frame *frame;
+
+	*pframe = NULL;
+
+	vbuf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
+	if (!vbuf) {
+		dev_err(delta->dev, "%s no frame available",
+			ctx->name);
+		return -EIO;
+	}
+
+	frame = to_frame(vbuf);
+	frame->state &= ~DELTA_FRAME_M2M;
+	if (frame->state != DELTA_FRAME_FREE) {
+		dev_err(delta->dev,
+			"%s frame[%d] is not free\n",
+			ctx->name, frame->index);
+		dump_frames_status(ctx);
+		return -ENODATA;
+	}
+
+	dev_dbg(delta->dev,
+		"%s get free frame[%d]\n", ctx->name, frame->index);
+
+	*pframe = frame;
+	return 0;
+}
+
+int delta_get_sync(struct delta_ctx *ctx)
+{
+	struct delta_dev *delta = ctx->dev;
+	int ret = 0;
+
+	/* enable the hardware */
+	ret = pm_runtime_get_sync(delta->dev);
+	if (ret < 0) {
+		dev_err(delta->dev, "%s pm_runtime_get_sync failed (%d)\n",
+			__func__, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+void delta_put_autosuspend(struct delta_ctx *ctx)
+{
+	struct delta_dev *delta = ctx->dev;
+
+	pm_runtime_put_autosuspend(delta->dev);
+}
+
+static void delta_vb2_au_queue(struct vb2_buffer *vb)
+{
+	struct vb2_queue *q = vb->vb2_queue;
+	struct delta_ctx *ctx = vb2_get_drv_priv(q);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+
+	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
+}
+
+static int delta_vb2_au_start_streaming(struct vb2_queue *q,
+					unsigned int count)
+{
+	struct delta_ctx *ctx = vb2_get_drv_priv(q);
+	struct delta_dev *delta = ctx->dev;
+	const struct delta_dec *dec = ctx->dec;
+	struct delta_au *au;
+	int ret = 0;
+	struct vb2_v4l2_buffer *vbuf = NULL;
+	struct delta_streaminfo *streaminfo = &ctx->streaminfo;
+	struct delta_frameinfo *frameinfo = &ctx->frameinfo;
+
+	if ((ctx->state != DELTA_STATE_WF_FORMAT) &&
+	    (ctx->state != DELTA_STATE_WF_STREAMINFO))
+		return 0;
+
+	if (ctx->state == DELTA_STATE_WF_FORMAT) {
+		/* open decoder if not yet done */
+		ret = delta_open_decoder(ctx,
+					 ctx->streaminfo.streamformat,
+					 ctx->frameinfo.pixelformat, &dec);
+		if (ret)
+			goto err;
+		ctx->dec = dec;
+		ctx->state = DELTA_STATE_WF_STREAMINFO;
+	}
+
+	/*
+	 * first buffer should contain stream header,
+	 * decode it to get the infos related to stream
+	 * such as width, height, dpb, ...
+	 */
+	vbuf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
+	if (!vbuf) {
+		dev_err(delta->dev, "%s failed to start streaming, no stream header buffer enqueued\n",
+			ctx->name);
+		ret = -EINVAL;
+		goto err;
+	}
+	au = to_au(vbuf);
+	au->size = vb2_get_plane_payload(&vbuf->vb2_buf, 0);
+	au->dts = vbuf->vb2_buf.timestamp;
+
+	delta_push_dts(ctx, au->dts);
+
+	/* dump access unit */
+	dump_au(ctx, au);
+
+	/* decode this access unit */
+	ret = call_dec_op(dec, decode, ctx, au);
+	if (ret) {
+		dev_err(delta->dev, "%s failed to start streaming, header decoding failed (%d)\n",
+			ctx->name, ret);
+		goto err;
+	}
+
+	ret = call_dec_op(dec, get_streaminfo, ctx, streaminfo);
+	if (ret) {
+		dev_dbg_ratelimited(delta->dev,
+				    "%s failed to start streaming, valid stream header not yet decoded\n",
+				    ctx->name);
+		goto err;
+	}
+	ctx->flags |= DELTA_FLAG_STREAMINFO;
+
+	ret = call_dec_op(dec, get_frameinfo, ctx, frameinfo);
+	if (ret)
+		goto err;
+	ctx->flags |= DELTA_FLAG_FRAMEINFO;
+
+	ctx->state = DELTA_STATE_READY;
+
+	delta_au_done(ctx, au, ret);
+	return 0;
+
+err:
+	/*
+	 * return all buffers to vb2 in QUEUED state.
+	 * This will give ownership back to userspace
+	 */
+	if (vbuf)
+		v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_QUEUED);
+
+	while ((vbuf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx)))
+		v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_QUEUED);
+	return ret;
+}
+
+static void delta_vb2_au_stop_streaming(struct vb2_queue *q)
+{
+	struct delta_ctx *ctx = vb2_get_drv_priv(q);
+	struct vb2_v4l2_buffer *vbuf;
+
+	delta_flush_dts(ctx);
+
+	/* return all buffers to vb2 in ERROR state */
+	while ((vbuf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx)))
+		v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_ERROR);
+
+	ctx->au_num = 0;
+
+	ctx->aborting = false;
+}
+
+static int delta_vb2_frame_queue_setup(struct vb2_queue *vq,
+				       unsigned int *num_buffers,
+				       unsigned int *num_planes,
+				       unsigned int sizes[],
+				       struct device *alloc_devs[])
+{
+	struct delta_ctx *ctx = vb2_get_drv_priv(vq);
+	struct delta_dev *delta = ctx->dev;
+	struct delta_streaminfo *streaminfo = &ctx->streaminfo;
+	struct delta_frameinfo *frameinfo = &ctx->frameinfo;
+	unsigned int size = frameinfo->size;
+
+	/*
+	 * the number of output buffers needed for decoding =
+	 * user need (*num_buffers given, usually for display pipeline) +
+	 * stream need (streaminfo->dpb) +
+	 * decoding peak smoothing (depends on DELTA IP perf)
+	 */
+	if (*num_buffers < DELTA_MIN_FRAME_USER) {
+		dev_dbg(delta->dev,
+			"%s num_buffers too low (%d), increasing to %d\n",
+			ctx->name, *num_buffers, DELTA_MIN_FRAME_USER);
+		*num_buffers = DELTA_MIN_FRAME_USER;
+	}
+
+	*num_buffers += streaminfo->dpb + DELTA_PEAK_FRAME_SMOOTHING;
+
+	if (*num_buffers > DELTA_MAX_FRAMES) {
+		dev_dbg(delta->dev,
+			"%s output frame count too high (%d), cut to %d\n",
+			ctx->name, *num_buffers, DELTA_MAX_FRAMES);
+		*num_buffers = DELTA_MAX_FRAMES;
+	}
+
+	if (*num_planes)
+		return sizes[0] < size ? -EINVAL : 0;
+
+	/* single plane for Y and CbCr */
+	*num_planes = 1;
+
+	sizes[0] = size;
+
+	ctx->nb_of_frames = 0;
+
+	return 0;
+}
+
+static int delta_vb2_frame_prepare(struct vb2_buffer *vb)
+{
+	struct vb2_queue *q = vb->vb2_queue;
+	struct delta_ctx *ctx = vb2_get_drv_priv(q);
+	struct delta_dev *delta = ctx->dev;
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct delta_frame *frame = to_frame(vbuf);
+	int ret = 0;
+
+	if (!frame->prepared) {
+		frame->index = vbuf->vb2_buf.index;
+		frame->vaddr = vb2_plane_vaddr(&vbuf->vb2_buf, 0);
+		frame->paddr = vb2_dma_contig_plane_dma_addr(&vbuf->vb2_buf, 0);
+		frame->info = ctx->frameinfo;
+
+		ret = delta_setup_frame(ctx, frame);
+		if (ret) {
+			dev_err(delta->dev,
+				"%s setup_frame() failed (%d)\n",
+				ctx->name, ret);
+			return ret;
+		}
+		frame->prepared = true;
+		dev_dbg(delta->dev,
+			"%s frame[%d] prepared; virt=0x%p, phy=0x%pad\n",
+			ctx->name, vb->index, frame->vaddr,
+			&frame->paddr);
+	}
+
+	frame->flags = vbuf->flags;
+
+	return 0;
+}
+
+static void delta_vb2_frame_finish(struct vb2_buffer *vb)
+{
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct delta_frame *frame = to_frame(vbuf);
+
+	/* update V4L2 fields for user */
+	vb2_set_plane_payload(&vbuf->vb2_buf, 0, frame->info.size);
+	vb->timestamp = frame->dts;
+	vbuf->field = frame->field;
+	vbuf->flags = frame->flags;
+}
+
+static void delta_vb2_frame_queue(struct vb2_buffer *vb)
+{
+	struct vb2_queue *q = vb->vb2_queue;
+	struct delta_ctx *ctx = vb2_get_drv_priv(q);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct delta_frame *frame = to_frame(vbuf);
+
+	/* recycle this frame */
+	delta_recycle(ctx, frame);
+}
+
+static void delta_vb2_frame_stop_streaming(struct vb2_queue *q)
+{
+	struct delta_ctx *ctx = vb2_get_drv_priv(q);
+	struct vb2_v4l2_buffer *vbuf;
+	struct delta_frame *frame;
+	const struct delta_dec *dec = ctx->dec;
+	unsigned int i;
+
+	delta_flush_dts(ctx);
+
+	call_dec_op(dec, flush, ctx);
+
+	/*
+	 * return all buffers to vb2 in ERROR state
+	 * & reset each frame state to OUT
+	 */
+	for (i = 0; i < ctx->nb_of_frames; i++) {
+		frame = ctx->frames[i];
+		if (!(frame->state & DELTA_FRAME_OUT)) {
+			vbuf = &frame->vbuf;
+			v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_ERROR);
+		}
+		frame->state = DELTA_FRAME_OUT;
+	}
+
+	ctx->frame_num = 0;
+
+	ctx->aborting = false;
+}
+
+/* VB2 queue ops */
+static struct vb2_ops delta_vb2_au_ops = {
+	.queue_setup = delta_vb2_au_queue_setup,
+	.buf_prepare = delta_vb2_au_prepare,
+	.buf_queue = delta_vb2_au_queue,
+	.wait_prepare = vb2_ops_wait_prepare,
+	.wait_finish = vb2_ops_wait_finish,
+	.start_streaming = delta_vb2_au_start_streaming,
+	.stop_streaming = delta_vb2_au_stop_streaming,
+};
+
+static struct vb2_ops delta_vb2_frame_ops = {
+	.queue_setup = delta_vb2_frame_queue_setup,
+	.buf_prepare = delta_vb2_frame_prepare,
+	.buf_finish = delta_vb2_frame_finish,
+	.buf_queue = delta_vb2_frame_queue,
+	.wait_prepare = vb2_ops_wait_prepare,
+	.wait_finish = vb2_ops_wait_finish,
+	.stop_streaming = delta_vb2_frame_stop_streaming,
+};
+
+/*
+ * V4L2 file operations
+ */
+
+static int queue_init(void *priv,
+		      struct vb2_queue *src_vq, struct vb2_queue *dst_vq)
+{
+	struct vb2_queue *q;
+	struct delta_ctx *ctx = priv;
+	struct delta_dev *delta = ctx->dev;
+	int ret;
+
+	/* setup vb2 queue for stream input */
+	q = src_vq;
+	q->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
+	q->io_modes = VB2_MMAP | VB2_DMABUF;
+	q->drv_priv = ctx;
+	/* overload vb2 buf with private au struct */
+	q->buf_struct_size = sizeof(struct delta_au);
+	q->ops = &delta_vb2_au_ops;
+	q->mem_ops = &vb2_dma_contig_memops;
+	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	q->lock = &delta->lock;
+	q->dev = delta->dev;
+
+	ret = vb2_queue_init(q);
+	if (ret)
+		return ret;
+
+	/* setup vb2 queue for frame output */
+	q = dst_vq;
+	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	q->io_modes = VB2_MMAP | VB2_DMABUF;
+	q->drv_priv = ctx;
+	/* overload vb2 buf with private frame struct */
+	q->buf_struct_size = sizeof(struct delta_frame)
+			     + DELTA_MAX_FRAME_PRIV_SIZE;
+	q->ops = &delta_vb2_frame_ops;
+	q->mem_ops = &vb2_dma_contig_memops;
+	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	q->lock = &delta->lock;
+	q->dev = delta->dev;
+
+	return vb2_queue_init(q);
+}
+
+static int delta_open(struct file *file)
+{
+	struct delta_dev *delta = video_drvdata(file);
+	struct delta_ctx *ctx = NULL;
+	int ret = 0;
+
+	mutex_lock(&delta->lock);
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx) {
+		ret = -ENOMEM;
+		goto err;
+	}
+	ctx->dev = delta;
+
+	v4l2_fh_init(&ctx->fh, video_devdata(file));
+	file->private_data = &ctx->fh;
+	v4l2_fh_add(&ctx->fh);
+
+	INIT_WORK(&ctx->run_work, delta_run_work);
+	mutex_init(&ctx->lock);
+
+	ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(delta->m2m_dev, ctx,
+					    queue_init);
+	if (IS_ERR(ctx->fh.m2m_ctx)) {
+		ret = PTR_ERR(ctx->fh.m2m_ctx);
+		dev_err(delta->dev, "%s failed to initialize m2m context (%d)\n",
+			DELTA_PREFIX, ret);
+		goto err_fh_del;
+	}
+
+	/*
+	 * wait stream format to determine which
+	 * decoder to open
+	 */
+	ctx->state = DELTA_STATE_WF_FORMAT;
+
+	INIT_LIST_HEAD(&ctx->dts);
+
+	/* set the instance name */
+	delta->instance_id++;
+	snprintf(ctx->name, sizeof(ctx->name), "[%3d:----]",
+		 delta->instance_id);
+
+	/* default parameters for frame and stream */
+	set_default_params(ctx);
+
+	/* enable ST231 clocks */
+	if (delta->clk_st231)
+		if (clk_prepare_enable(delta->clk_st231))
+			dev_warn(delta->dev, "failed to enable st231 clk\n");
+
+	/* enable FLASH_PROMIP clock */
+	if (delta->clk_flash_promip)
+		if (clk_prepare_enable(delta->clk_flash_promip))
+			dev_warn(delta->dev, "failed to enable delta promip clk\n");
+
+	mutex_unlock(&delta->lock);
+
+	dev_dbg(delta->dev, "%s decoder instance created\n", ctx->name);
+
+	return 0;
+
+err_fh_del:
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
+	kfree(ctx);
+err:
+	mutex_unlock(&delta->lock);
+
+	return ret;
+}
+
+static int delta_release(struct file *file)
+{
+	struct delta_ctx *ctx = to_ctx(file->private_data);
+	struct delta_dev *delta = ctx->dev;
+	const struct delta_dec *dec = ctx->dec;
+
+	mutex_lock(&delta->lock);
+
+	/* close decoder */
+	call_dec_op(dec, close, ctx);
+
+	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
+
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
+
+	/* disable ST231 clocks */
+	if (delta->clk_st231)
+		clk_disable_unprepare(delta->clk_st231);
+
+	/* disable FLASH_PROMIP clock */
+	if (delta->clk_flash_promip)
+		clk_disable_unprepare(delta->clk_flash_promip);
+
+	dev_dbg(delta->dev, "%s decoder instance released\n", ctx->name);
+
+	kfree(ctx);
+
+	mutex_unlock(&delta->lock);
+	return 0;
+}
+
+/* V4L2 file ops */
+static const struct v4l2_file_operations delta_fops = {
+	.owner = THIS_MODULE,
+	.open = delta_open,
+	.release = delta_release,
+	.unlocked_ioctl = video_ioctl2,
+	.mmap = v4l2_m2m_fop_mmap,
+	.poll = v4l2_m2m_fop_poll,
+};
+
+/*
+ * Platform device operations
+ */
+
+static int delta_register_device(struct delta_dev *delta)
+{
+	int ret;
+	struct video_device *vdev;
+
+	if (!delta)
+		return -ENODEV;
+
+	delta->m2m_dev = v4l2_m2m_init(&delta_m2m_ops);
+	if (IS_ERR(delta->m2m_dev)) {
+		dev_err(delta->dev, "%s failed to initialize v4l2-m2m device\n",
+			DELTA_PREFIX);
+		ret = PTR_ERR(delta->m2m_dev);
+		goto err;
+	}
+
+	vdev = video_device_alloc();
+	if (!vdev) {
+		dev_err(delta->dev, "%s failed to allocate video device\n",
+			DELTA_PREFIX);
+		ret = -ENOMEM;
+		goto err_m2m_release;
+	}
+
+	vdev->fops = &delta_fops;
+	vdev->ioctl_ops = &delta_ioctl_ops;
+	vdev->release = video_device_release;
+	vdev->lock = &delta->lock;
+	vdev->vfl_dir = VFL_DIR_M2M;
+	vdev->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_M2M;
+	vdev->v4l2_dev = &delta->v4l2_dev;
+	snprintf(vdev->name, sizeof(vdev->name), "%s-%s",
+		 DELTA_NAME, DELTA_FW_VERSION);
+
+	ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
+	if (ret) {
+		dev_err(delta->dev, "%s failed to register video device\n",
+			DELTA_PREFIX);
+		goto err_vdev_release;
+	}
+
+	delta->vdev = vdev;
+	video_set_drvdata(vdev, delta);
+	return 0;
+
+err_vdev_release:
+	video_device_release(vdev);
+err_m2m_release:
+	v4l2_m2m_release(delta->m2m_dev);
+err:
+	return ret;
+}
+
+static void delta_unregister_device(struct delta_dev *delta)
+{
+	if (!delta)
+		return;
+
+	if (delta->m2m_dev)
+		v4l2_m2m_release(delta->m2m_dev);
+
+	video_unregister_device(delta->vdev);
+}
+
+static int delta_probe(struct platform_device *pdev)
+{
+	struct delta_dev *delta;
+	struct device *dev = &pdev->dev;
+	int ret;
+
+	delta = devm_kzalloc(dev, sizeof(*delta), GFP_KERNEL);
+	if (!delta) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	delta->dev = dev;
+	delta->pdev = pdev;
+	platform_set_drvdata(pdev, delta);
+
+	mutex_init(&delta->lock);
+
+	/* get clock resources */
+	delta->clk_delta = devm_clk_get(dev, "delta");
+	if (IS_ERR(delta->clk_delta)) {
+		dev_dbg(dev, "%s can't get delta clock\n", DELTA_PREFIX);
+		delta->clk_delta = NULL;
+	}
+
+	delta->clk_st231 = devm_clk_get(dev, "delta-st231");
+	if (IS_ERR(delta->clk_st231)) {
+		dev_dbg(dev, "%s can't get delta-st231 clock\n", DELTA_PREFIX);
+		delta->clk_st231 = NULL;
+	}
+
+	delta->clk_flash_promip = devm_clk_get(dev, "delta-flash-promip");
+	if (IS_ERR(delta->clk_flash_promip)) {
+		dev_dbg(dev, "%s can't get delta-flash-promip clock\n",
+			DELTA_PREFIX);
+		delta->clk_flash_promip = NULL;
+	}
+
+	/* init pm_runtime used for power management */
+	pm_runtime_set_autosuspend_delay(dev, DELTA_HW_AUTOSUSPEND_DELAY_MS);
+	pm_runtime_use_autosuspend(dev);
+	pm_runtime_set_suspended(dev);
+	pm_runtime_enable(dev);
+
+	/* register all available decoders */
+	register_decoders(delta);
+
+	/* register all supported formats */
+	register_formats(delta);
+
+	/* register on V4L2 */
+	ret = v4l2_device_register(dev, &delta->v4l2_dev);
+	if (ret) {
+		dev_err(delta->dev, "%s failed to register V4L2 device\n",
+			DELTA_PREFIX);
+		goto err;
+	}
+
+	delta->work_queue = create_workqueue(DELTA_NAME);
+	if (!delta->work_queue) {
+		dev_err(delta->dev, "%s failed to allocate work queue\n",
+			DELTA_PREFIX);
+		ret = -ENOMEM;
+		goto err_v4l2;
+	}
+
+	/* register device */
+	ret = delta_register_device(delta);
+	if (ret)
+		goto err_work_queue;
+
+	dev_info(dev, "%s %s registered as /dev/video%d\n",
+		 DELTA_PREFIX, delta->vdev->name, delta->vdev->num);
+
+	return 0;
+
+err_work_queue:
+	destroy_workqueue(delta->work_queue);
+err_v4l2:
+	v4l2_device_unregister(&delta->v4l2_dev);
+err:
+	return ret;
+}
+
+static int delta_remove(struct platform_device *pdev)
+{
+	struct delta_dev *delta = platform_get_drvdata(pdev);
+
+	delta_unregister_device(delta);
+
+	destroy_workqueue(delta->work_queue);
+
+	pm_runtime_put_autosuspend(delta->dev);
+	pm_runtime_disable(delta->dev);
+
+	v4l2_device_unregister(&delta->v4l2_dev);
+
+	return 0;
+}
+
+static int delta_runtime_suspend(struct device *dev)
+{
+	struct delta_dev *delta = dev_get_drvdata(dev);
+
+	if (delta->clk_delta)
+		clk_disable_unprepare(delta->clk_delta);
+
+	return 0;
+}
+
+static int delta_runtime_resume(struct device *dev)
+{
+	struct delta_dev *delta = dev_get_drvdata(dev);
+
+	if (delta->clk_delta)
+		if (clk_prepare_enable(delta->clk_delta))
+			dev_warn(dev, "failed to prepare/enable delta clk\n");
+
+	return 0;
+}
+
+/* PM ops */
+static const struct dev_pm_ops delta_pm_ops = {
+	.runtime_suspend = delta_runtime_suspend,
+	.runtime_resume = delta_runtime_resume,
+};
+
+static const struct of_device_id delta_match_types[] = {
+	{
+	 .compatible = "st,st-delta",
+	},
+	{
+	 /* end node */
+	}
+};
+
+MODULE_DEVICE_TABLE(of, delta_match_types);
+
+static struct platform_driver delta_driver = {
+	.probe = delta_probe,
+	.remove = delta_remove,
+	.driver = {
+		   .name = DELTA_NAME,
+		   .of_match_table = delta_match_types,
+		   .pm = &delta_pm_ops},
+};
+
+module_platform_driver(delta_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Hugues Fruchet <hugues.fruchet@st.com>");
+MODULE_DESCRIPTION("STMicroelectronics DELTA video decoder V4L2 driver");
diff --git a/drivers/media/platform/sti/delta/delta.h b/drivers/media/platform/sti/delta/delta.h
new file mode 100644
index 0000000..74a4240
--- /dev/null
+++ b/drivers/media/platform/sti/delta/delta.h
@@ -0,0 +1,514 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2015
+ * Author: Hugues Fruchet <hugues.fruchet@st.com> for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#ifndef DELTA_H
+#define DELTA_H
+
+#include <media/v4l2-device.h>
+#include <media/v4l2-mem2mem.h>
+
+#include "delta-cfg.h"
+
+/*
+ * enum delta_state - state of decoding instance
+ *
+ *@DELTA_STATE_WF_FORMAT:
+ *	Wait for compressed format to be set by V4L2 client in order
+ *	to know what is the relevant decoder to open.
+ *
+ *@DELTA_STATE_WF_STREAMINFO:
+ *	Wait for stream information to be available (bitstream
+ *	header parsing is done).
+ *
+ *@DELTA_STATE_READY:
+ *	Decoding instance is ready to decode compressed access unit.
+ *
+ */
+enum delta_state {
+	DELTA_STATE_WF_FORMAT,
+	DELTA_STATE_WF_STREAMINFO,
+	DELTA_STATE_READY,
+};
+
+/*
+ * struct delta_streaminfo - information about stream to decode
+ *
+ * @flags:		validity of fields (crop, pixelaspect, other)
+ * @width:		width of video stream
+ * @height:		height ""
+ * @streamformat:	fourcc compressed format of video (MJPEG, MPEG2, ...)
+ * @dpb:		number of frames needed to decode a single frame
+ *			(h264 dpb, up to 16)
+ * @crop:		cropping window inside decoded frame (1920x1080@0,0
+ *			inside 1920x1088 frame for ex.)
+ * @pixelaspect:	pixel aspect ratio of video (4/3, 5/4)
+ * @field:		interlaced or not
+ * @profile:		profile string
+ * @level:		level string
+ * @other:		other string information from codec
+ * @colorspace:		colorspace identifier
+ * @xfer_func:		transfer function identifier
+ * @ycbcr_enc:		Y'CbCr encoding identifier
+ * @quantization:	quantization identifier
+ */
+struct delta_streaminfo {
+	u32 flags;
+	u32 streamformat;
+	u32 width;
+	u32 height;
+	u32 dpb;
+	struct v4l2_rect crop;
+	struct v4l2_fract pixelaspect;
+	enum v4l2_field field;
+	u8 profile[32];
+	u8 level[32];
+	u8 other[32];
+	enum v4l2_colorspace colorspace;
+	enum v4l2_xfer_func xfer_func;
+	enum v4l2_ycbcr_encoding ycbcr_enc;
+	enum v4l2_quantization quantization;
+};
+
+#define DELTA_STREAMINFO_FLAG_CROP		0x0001
+#define DELTA_STREAMINFO_FLAG_PIXELASPECT	0x0002
+#define DELTA_STREAMINFO_FLAG_OTHER		0x0004
+
+/*
+ * struct delta_au - access unit structure.
+ *
+ * @vbuf:	video buffer information for V4L2
+ * @list:	V4L2 m2m list that the frame belongs to
+ * @prepared:	if set vaddr/paddr are resolved
+ * @vaddr:	virtual address (kernel can read/write)
+ * @paddr:	physical address (for hardware)
+ * @flags:	access unit type (V4L2_BUF_FLAG_KEYFRAME/PFRAME/BFRAME)
+ * @dts:	decoding timestamp of this access unit
+ */
+struct delta_au {
+	struct vb2_v4l2_buffer vbuf;	/* keep first */
+	struct list_head list;	/* keep second */
+
+	bool prepared;
+	u32 size;
+	void *vaddr;
+	dma_addr_t paddr;
+	u32 flags;
+	u64 dts;
+};
+
+/*
+ * struct delta_frameinfo - information about decoded frame
+ *
+ * @flags:		validity of fields (crop, pixelaspect)
+ * @pixelformat:	fourcc code for uncompressed video format
+ * @width:		width of frame
+ * @height:		height of frame
+ * @aligned_width:	width of frame (with encoder or decoder alignment
+ *			constraint)
+ * @aligned_height:	height of frame (with encoder or decoder alignment
+ *			constraint)
+ * @size:		maximum size in bytes required for data
+ * @crop:		cropping window inside frame (1920x1080@0,0
+ *			inside 1920x1088 frame for ex.)
+ * @pixelaspect:	pixel aspect ratio of video (4/3, 5/4)
+ * @field:		interlaced mode
+ * @colorspace:		colorspace identifier
+ * @xfer_func:		transfer function identifier
+ * @ycbcr_enc:		Y'CbCr encoding identifier
+ * @quantization:	quantization identifier
+ */
+struct delta_frameinfo {
+	u32 flags;
+	u32 pixelformat;
+	u32 width;
+	u32 height;
+	u32 aligned_width;
+	u32 aligned_height;
+	u32 size;
+	struct v4l2_rect crop;
+	struct v4l2_fract pixelaspect;
+	enum v4l2_field field;
+	enum v4l2_colorspace colorspace;
+	enum v4l2_xfer_func xfer_func;
+	enum v4l2_ycbcr_encoding ycbcr_enc;
+	enum v4l2_quantization quantization;
+};
+
+#define DELTA_FRAMEINFO_FLAG_CROP		0x0001
+#define DELTA_FRAMEINFO_FLAG_PIXELASPECT	0x0002
+
+/*
+ * struct delta_frame - frame structure.
+ *
+ * @vbuf:	video buffer information for V4L2
+ * @list:	V4L2 m2m list that the frame belongs to
+ * @info:	frame information (width, height, format, alignment...)
+ * @prepared:	if set pix/vaddr/paddr are resolved
+ * @index:	frame index, aligned on V4L2 wow
+ * @vaddr:	virtual address (kernel can read/write)
+ * @paddr:	physical address (for hardware)
+ * @state:	frame state for frame lifecycle tracking
+ *		(DELTA_FRAME_FREE/DEC/OUT/REC/...)
+ * @flags:	frame type (V4L2_BUF_FLAG_KEYFRAME/PFRAME/BFRAME)
+ * @dts:	decoding timestamp of this frame
+ * @field:	field order for interlaced frame
+ */
+struct delta_frame {
+	struct vb2_v4l2_buffer vbuf;	/* keep first */
+	struct list_head list;	/* keep second */
+
+	struct delta_frameinfo info;
+	bool prepared;
+	u32 index;
+	void *vaddr;
+	dma_addr_t paddr;
+	u32 state;
+	u32 flags;
+	u64 dts;
+	enum v4l2_field field;
+};
+
+/* frame state for frame lifecycle tracking */
+#define DELTA_FRAME_FREE	0x00 /* is free and can be used for decoding */
+#define DELTA_FRAME_REF		0x01 /* is a reference frame */
+#define DELTA_FRAME_BSY		0x02 /* is owned by decoder and busy */
+#define DELTA_FRAME_DEC		0x04 /* contains decoded content */
+#define DELTA_FRAME_OUT		0x08 /* has been given to user */
+#define DELTA_FRAME_RDY		0x10 /* is ready but still held by decoder */
+#define DELTA_FRAME_M2M		0x20 /* is owned by mem2mem framework */
+
+/*
+ * struct delta_dts - decoding timestamp.
+ *
+ * @list:	list to chain timestamps
+ * @val:	timestamp in microseconds
+ */
+struct delta_dts {
+	struct list_head list;
+	u64 val;
+};
+
+struct delta_ctx;
+
+/*
+ * struct delta_dec - decoder structure.
+ *
+ * @name:		name of this decoder
+ * @streamformat:	input stream format that this decoder support
+ * @pixelformat:	pixel format of decoded frame that this decoder support
+ * @max_width:		(optional) maximum width that can decode this decoder
+ *			if not set, maximum width is DELTA_MAX_WIDTH
+ * @max_height:		(optional) maximum height that can decode this decoder
+ *			if not set, maximum height is DELTA_MAX_HEIGHT
+ * @pm:			(optional) if set, decoder will manage power on its own
+ * @open:		open this decoder
+ * @close:		close this decoder
+ * @setup_frame:	setup frame to be used by decoder, see below
+ * @get_streaminfo:	get stream related infos, see below
+ * @get_frameinfo:	get decoded frame related infos, see below
+ * @set_frameinfo:	(optional) set decoded frame related infos, see below
+ * @setup_frame:	setup frame to be used by decoder, see below
+ * @decode:		decode a single access unit, see below
+ * @get_frame:		get the next decoded frame available, see below
+ * @recycle:		recycle the given frame, see below
+ * @flush:		(optional) flush decoder, see below
+ */
+struct delta_dec {
+	const char *name;
+	u32 streamformat;
+	u32 pixelformat;
+	u32 max_width;
+	u32 max_height;
+	bool pm;
+
+	/*
+	 * decoder ops
+	 */
+	int (*open)(struct delta_ctx *ctx);
+	int (*close)(struct delta_ctx *ctx);
+
+	/*
+	 * setup_frame() - setup frame to be used by decoder
+	 * @ctx:	(in) instance
+	 * @frame:	(in) frame to use
+	 *  @frame.index	(in) identifier of frame
+	 *  @frame.vaddr	(in) virtual address (kernel can read/write)
+	 *  @frame.paddr	(in) physical address (for hardware)
+	 *
+	 * Frame is to be allocated by caller, then given
+	 * to decoder through this call.
+	 * Several frames must be given to decoder (dpb),
+	 * each frame is identified using its index.
+	 */
+	int (*setup_frame)(struct delta_ctx *ctx, struct delta_frame *frame);
+
+	/*
+	 * get_streaminfo() - get stream related infos
+	 * @ctx:	(in) instance
+	 * @streaminfo:	(out) width, height, dpb,...
+	 *
+	 * Precondition: stream header must have been successfully
+	 * parsed to have this call successful & @streaminfo valid.
+	 * Header parsing must be done using decode(), giving
+	 * explicitly header access unit or first access unit of bitstream.
+	 * If no valid header is found, get_streaminfo will return -ENODATA,
+	 * in this case the next bistream access unit must be decoded till
+	 * get_streaminfo becomes successful.
+	 */
+	int (*get_streaminfo)(struct delta_ctx *ctx,
+			      struct delta_streaminfo *streaminfo);
+
+	/*
+	 * get_frameinfo() - get decoded frame related infos
+	 * @ctx:	(in) instance
+	 * @frameinfo:	(out) width, height, alignment, crop, ...
+	 *
+	 * Precondition: get_streaminfo() must be successful
+	 */
+	int (*get_frameinfo)(struct delta_ctx *ctx,
+			     struct delta_frameinfo *frameinfo);
+
+	/*
+	 * set_frameinfo() - set decoded frame related infos
+	 * @ctx:	(in) instance
+	 * @frameinfo:	(out) width, height, alignment, crop, ...
+	 *
+	 * Optional.
+	 * Typically used to negotiate with decoder the output
+	 * frame if decoder can do post-processing.
+	 */
+	int (*set_frameinfo)(struct delta_ctx *ctx,
+			     struct delta_frameinfo *frameinfo);
+
+	/*
+	 * decode() - decode a single access unit
+	 * @ctx:	(in) instance
+	 * @au:		(in/out) access unit
+	 *  @au.size	(in) size of au to decode
+	 *  @au.vaddr	(in) virtual address (kernel can read/write)
+	 *  @au.paddr	(in) physical address (for hardware)
+	 *  @au.flags	(out) au type (V4L2_BUF_FLAG_KEYFRAME/
+	 *			PFRAME/BFRAME)
+	 *
+	 * Decode the access unit given. Decode is synchronous;
+	 * access unit memory is no more needed after this call.
+	 * After this call, none, one or several frames could
+	 * have been decoded, which can be retrieved using
+	 * get_frame().
+	 */
+	int (*decode)(struct delta_ctx *ctx, struct delta_au *au);
+
+	/*
+	 * get_frame() - get the next decoded frame available
+	 * @ctx:	(in) instance
+	 * @frame:	(out) frame with decoded data:
+	 *  @frame.index	(out) identifier of frame
+	 *  @frame.field	(out) field order for interlaced frame
+	 *  @frame.state	(out) frame state for frame lifecycle tracking
+	 *  @frame.flags	(out) frame type (V4L2_BUF_FLAG_KEYFRAME/
+	 *			PFRAME/BFRAME)
+	 *
+	 * Get the next available decoded frame.
+	 * If no frame is available, -ENODATA is returned.
+	 * If a frame is available, frame structure is filled with
+	 * relevant data, frame.index identifying this exact frame.
+	 * When this frame is no more needed by upper layers,
+	 * recycle() must be called giving this frame identifier.
+	 */
+	int (*get_frame)(struct delta_ctx *ctx, struct delta_frame **frame);
+
+	/*
+	 * recycle() - recycle the given frame
+	 * @ctx:	(in) instance
+	 * @frame:	(in) frame to recycle:
+	 *  @frame.index	(in) identifier of frame
+	 *
+	 * recycle() is to be called by user when the decoded frame
+	 * is no more needed (composition/display done).
+	 * This frame will then be reused by decoder to proceed
+	 * with next frame decoding.
+	 * If not enough frames have been provided through setup_frame(),
+	 * or recycle() is not called fast enough, the decoder can run out
+	 * of available frames to proceed with decoding (starvation).
+	 * This case is guarded by wq_recycle wait queue which ensures that
+	 * decoder is called only if at least one frame is available.
+	 */
+	int (*recycle)(struct delta_ctx *ctx, struct delta_frame *frame);
+
+	/*
+	 * flush() - flush decoder
+	 * @ctx:	(in) instance
+	 *
+	 * Optional.
+	 * Reset decoder context and discard all internal buffers.
+	 * This allows implementation of seek, which leads to discontinuity
+	 * of input bitstream that decoder must know to restart its internal
+	 * decoding logic.
+	 */
+	int (*flush)(struct delta_ctx *ctx);
+};
+
+struct delta_dev;
+
+/*
+ * struct delta_ctx - instance structure.
+ *
+ * @flags:		validity of fields (streaminfo)
+ * @fh:			V4L2 file handle
+ * @dev:		device context
+ * @dec:		selected decoder context for this instance
+ * @state:		instance state
+ * @frame_num:		frame number
+ * @au_num:		access unit number
+ * @max_au_size:	max size of an access unit
+ * @streaminfo:		stream information (width, height, dpb, interlacing...)
+ * @frameinfo:		frame information (width, height, format, alignment...)
+ * @nb_of_frames:	number of frames available for decoding
+ * @frames:		array of decoding frames to keep track of frame
+ *			state and manage frame recycling
+ * @decoded_frames:	nb of decoded frames from opening
+ * @output_frames:	nb of output frames from opening
+ * @dropped_frames:	nb of frames dropped (ie access unit not parsed
+ *			or frame decoded but not output)
+ * @stream_errors:	nb of stream errors (corrupted, not supported, ...)
+ * @decode_errors:	nb of decode errors (firmware error)
+ * @sys_errors:		nb of system errors (memory, ipc, ...)
+ * @dts:		FIFO of decoding timestamp.
+ *			output frames are timestamped with incoming access
+ *			unit timestamps using this fifo.
+ * @name:		string naming this instance (debug purpose)
+ * @run_work:		decoding work
+ * @lock:		lock for decoding work serialization
+ * @aborting:		true if current job aborted
+ * @priv:		private decoder context for this instance, allocated
+ *			by decoder @open time.
+ */
+struct delta_ctx {
+	u32 flags;
+	struct v4l2_fh fh;
+	struct delta_dev *dev;
+	const struct delta_dec *dec;
+	enum delta_state state;
+	u32 frame_num;
+	u32 au_num;
+	size_t max_au_size;
+	struct delta_streaminfo streaminfo;
+	struct delta_frameinfo frameinfo;
+	u32 nb_of_frames;
+	struct delta_frame *frames[DELTA_MAX_FRAMES];
+	u32 decoded_frames;
+	u32 output_frames;
+	u32 dropped_frames;
+	u32 stream_errors;
+	u32 decode_errors;
+	u32 sys_errors;
+	struct list_head dts;
+	char name[100];
+	struct work_struct run_work;
+	struct mutex lock;
+	bool aborting;
+	void *priv;
+};
+
+#define DELTA_FLAG_STREAMINFO 0x0001
+#define DELTA_FLAG_FRAMEINFO 0x0002
+
+#define DELTA_MAX_FORMATS  DELTA_MAX_DECODERS
+
+/*
+ * struct delta_dev - device struct, 1 per probe (so single one for
+ * all platform life)
+ *
+ * @v4l2_dev:		v4l2 device
+ * @vdev:		v4l2 video device
+ * @pdev:		platform device
+ * @dev:		device
+ * @m2m_dev:		memory-to-memory V4L2 device
+ * @lock:		device lock, for crit section & V4L2 ops serialization.
+ * @clk_delta:		delta main clock
+ * @clk_st231:		st231 coprocessor main clock
+ * @clk_flash_promip:	flash promip clock
+ * @decoders:		list of registered decoders
+ * @nb_of_decoders:	nb of registered decoders
+ * @pixelformats:	supported uncompressed video formats
+ * @nb_of_pixelformats:	number of supported umcompressed video formats
+ * @streamformats:	supported compressed video formats
+ * @nb_of_streamformats:number of supported compressed video formats
+ * @instance_id:	rolling counter identifying an instance (debug purpose)
+ * @work_queue:		decoding job work queue
+ */
+struct delta_dev {
+	struct v4l2_device v4l2_dev;
+	struct video_device *vdev;
+	struct platform_device *pdev;
+	struct device *dev;
+	struct v4l2_m2m_dev *m2m_dev;
+	struct mutex lock;
+	struct clk *clk_delta;
+	struct clk *clk_st231;
+	struct clk *clk_flash_promip;
+	const struct delta_dec *decoders[DELTA_MAX_DECODERS];
+	u32 nb_of_decoders;
+	u32 pixelformats[DELTA_MAX_FORMATS];
+	u32 nb_of_pixelformats;
+	u32 streamformats[DELTA_MAX_FORMATS];
+	u32 nb_of_streamformats;
+	u8 instance_id;
+	struct workqueue_struct *work_queue;
+};
+
+static inline char *frame_type_str(u32 flags)
+{
+	if (flags & V4L2_BUF_FLAG_KEYFRAME)
+		return "I";
+	if (flags & V4L2_BUF_FLAG_PFRAME)
+		return "P";
+	if (flags & V4L2_BUF_FLAG_BFRAME)
+		return "B";
+	return "?";
+}
+
+static inline char *frame_field_str(enum v4l2_field field)
+{
+	if (field == V4L2_FIELD_NONE)
+		return "-";
+	if (field == V4L2_FIELD_TOP)
+		return "T";
+	if (field == V4L2_FIELD_BOTTOM)
+		return "B";
+	if (field == V4L2_FIELD_INTERLACED)
+		return "I";
+	if (field == V4L2_FIELD_INTERLACED_TB)
+		return "TB";
+	if (field == V4L2_FIELD_INTERLACED_BT)
+		return "BT";
+	return "?";
+}
+
+static inline char *frame_state_str(u32 state, char *str, unsigned int len)
+{
+	snprintf(str, len, "%s %s %s %s %s %s",
+		 (state & DELTA_FRAME_REF)  ? "ref" : "   ",
+		 (state & DELTA_FRAME_BSY)  ? "bsy" : "   ",
+		 (state & DELTA_FRAME_DEC)  ? "dec" : "   ",
+		 (state & DELTA_FRAME_OUT)  ? "out" : "   ",
+		 (state & DELTA_FRAME_M2M)  ? "m2m" : "   ",
+		 (state & DELTA_FRAME_RDY)  ? "rdy" : "   ");
+	return str;
+}
+
+int delta_get_frameinfo_default(struct delta_ctx *ctx,
+				struct delta_frameinfo *frameinfo);
+int delta_recycle_default(struct delta_ctx *pctx,
+			  struct delta_frame *frame);
+
+int delta_get_free_frame(struct delta_ctx *ctx,
+			 struct delta_frame **pframe);
+
+int delta_get_sync(struct delta_ctx *ctx);
+void delta_put_autosuspend(struct delta_ctx *ctx);
+
+#endif /* DELTA_H */
-- 
1.9.1

