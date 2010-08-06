Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:16561 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756861Ab0HFNuy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Aug 2010 09:50:54 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from eu_spt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0L6Q009T7H4SY180@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 06 Aug 2010 14:50:52 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L6Q00FHCH4SCP@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 06 Aug 2010 14:50:52 +0100 (BST)
Date: Fri, 06 Aug 2010 15:50:46 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: [PATCH] v4l: s5p-fimc: Fix coding style issues
To: linux-media@vger.kernel.org
Cc: p.osciak@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com
Message-id: <1281102646-2250-1-git-send-email-p.osciak@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-core.c |   36 +++++++++++++++++++++--------
 drivers/media/video/s5p-fimc/fimc-core.h |   30 +++++++++++++++----------
 2 files changed, 44 insertions(+), 22 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 6558a2e..b151c7b 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -303,7 +303,9 @@ static int fimc_prepare_addr(struct fimc_ctx *ctx,
 	u32 pix_size;
 	int ret = 0;
 
-	ctx_m2m_get_frame(frame, ctx, type);
+	frame = ctx_m2m_get_frame(ctx, type);
+	if (IS_ERR(frame))
+		return PTR_ERR(frame);
 	paddr = &frame->paddr;
 
 	if (!buf)
@@ -555,8 +557,10 @@ dma_unlock:
 	spin_unlock_irqrestore(&ctx->slock, flags);
 }
 
-/* Nothing done in job_abort. */
-static void fimc_job_abort(void *priv) {}
+static void fimc_job_abort(void *priv)
+{
+	/* Nothing done in job_abort. */
+}
 
 static void fimc_buf_release(struct videobuf_queue *vq,
 				    struct videobuf_buffer *vb)
@@ -571,7 +575,9 @@ static int fimc_buf_setup(struct videobuf_queue *vq, unsigned int *count,
 	struct fimc_ctx *ctx = vq->priv_data;
 	struct fimc_frame *frame;
 
-	ctx_m2m_get_frame(frame, ctx, vq->type);
+	frame = ctx_m2m_get_frame(ctx, vq->type);
+	if (IS_ERR(frame))
+		return PTR_ERR(frame);
 
 	*size = (frame->width * frame->height * frame->fmt->depth) >> 3;
 	if (0 == *count)
@@ -587,7 +593,9 @@ static int fimc_buf_prepare(struct videobuf_queue *vq,
 	struct fimc_frame *frame;
 	int ret;
 
-	ctx_m2m_get_frame(frame, ctx, vq->type);
+	frame = ctx_m2m_get_frame(ctx, vq->type);
+	if (IS_ERR(frame))
+		return PTR_ERR(frame);
 
 	if (vb->baddr) {
 		if (vb->bsize < frame->size) {
@@ -628,7 +636,7 @@ static void fimc_buf_queue(struct videobuf_queue *vq,
 	v4l2_m2m_buf_queue(ctx->m2m_ctx, vq, vb);
 }
 
-struct videobuf_queue_ops fimc_qops = {
+static struct videobuf_queue_ops fimc_qops = {
 	.buf_setup	= fimc_buf_setup,
 	.buf_prepare	= fimc_buf_prepare,
 	.buf_queue	= fimc_buf_queue,
@@ -670,7 +678,9 @@ static int fimc_m2m_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
 	struct fimc_ctx *ctx = priv;
 	struct fimc_frame *frame;
 
-	ctx_m2m_get_frame(frame, ctx, f->type);
+	frame = ctx_m2m_get_frame(ctx, f->type);
+	if (IS_ERR(frame))
+		return PTR_ERR(frame);
 
 	f->fmt.pix.width	= frame->width;
 	f->fmt.pix.height	= frame->height;
@@ -1003,7 +1013,9 @@ static int fimc_m2m_cropcap(struct file *file, void *fh,
 	struct fimc_frame *frame;
 	struct fimc_ctx *ctx = fh;
 
-	ctx_m2m_get_frame(frame, ctx, cr->type);
+	frame = ctx_m2m_get_frame(ctx, cr->type);
+	if (IS_ERR(frame))
+		return PTR_ERR(frame);
 
 	cr->bounds.left = 0;
 	cr->bounds.top = 0;
@@ -1021,7 +1033,9 @@ static int fimc_m2m_g_crop(struct file *file, void *fh, struct v4l2_crop *cr)
 	struct fimc_frame *frame;
 	struct fimc_ctx *ctx = file->private_data;
 
-	ctx_m2m_get_frame(frame, ctx, cr->type);
+	frame = ctx_m2m_get_frame(ctx, cr->type);
+	if (IS_ERR(frame))
+		return PTR_ERR(frame);
 
 	cr->c.left = frame->offs_h;
 	cr->c.top = frame->offs_v;
@@ -1052,7 +1066,9 @@ static int fimc_m2m_s_crop(struct file *file, void *fh, struct v4l2_crop *cr)
 		return -EINVAL;
 	}
 
-	ctx_m2m_get_frame(f, ctx, cr->type);
+	f = ctx_m2m_get_frame(ctx, cr->type);
+	if (IS_ERR(f))
+		return PTR_ERR(f);
 
 	/* Adjust to required pixel boundary. */
 	min_size = (cr->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) ?
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index f121b93..6b3e0cd 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -28,18 +28,6 @@
 #define dbg(fmt, args...)
 #endif
 
-#define ctx_m2m_get_frame(frame, ctx, type) do { \
-	if (V4L2_BUF_TYPE_VIDEO_OUTPUT == (type)) { \
-		frame = &(ctx)->s_frame; \
-	} else if (V4L2_BUF_TYPE_VIDEO_CAPTURE == (type)) { \
-		frame = &(ctx)->d_frame; \
-	} else { \
-		v4l2_err(&(ctx)->fimc_dev->m2m.v4l2_dev,\
-			"Wrong buffer/video queue type (%d)\n", type); \
-		return -EINVAL; \
-	} \
-} while (0)
-
 #define NUM_FIMC_CLOCKS		2
 #define MODULE_NAME		"s5p-fimc"
 #define FIMC_MAX_DEVS		3
@@ -444,6 +432,24 @@ static inline void fimc_hw_stop_in_dma(struct fimc_dev *dev)
 	writel(cfg, dev->regs + S5P_MSCTRL);
 }
 
+static inline struct fimc_frame *ctx_m2m_get_frame(struct fimc_ctx *ctx,
+						   enum v4l2_buf_type type)
+{
+	struct fimc_frame *frame;
+
+	if (V4L2_BUF_TYPE_VIDEO_OUTPUT == type) {
+		frame = &ctx->s_frame;
+	} else if (V4L2_BUF_TYPE_VIDEO_CAPTURE == type) {
+		frame = &ctx->d_frame;
+	} else {
+		v4l2_err(&ctx->fimc_dev->m2m.v4l2_dev,
+			"Wrong buffer/video queue type (%d)\n", type);
+		return ERR_PTR(-EINVAL);
+	}
+
+	return frame;
+}
+
 /* -----------------------------------------------------*/
 /* fimc-reg.c						*/
 void fimc_hw_reset(struct fimc_dev *dev);
-- 
1.7.1.569.g6f426

