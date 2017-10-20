Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:48677 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752603AbdJTKO7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Oct 2017 06:14:59 -0400
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Marian Mihailescu <mihailescu2m@gmail.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        JaeChul Lee <jcsing.lee@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: [PATCH] media: s5p-mfc: Add support for V4L2_MEMORY_DMABUF type
Date: Fri, 20 Oct 2017 12:14:33 +0200
Message-id: <20171020101433.30119-1-m.szyprowski@samsung.com>
References: <CGME20171020101455eucas1p1ad826b685fab9d93bb5f12b2b27096c6@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Seung-Woo Kim <sw0312.kim@samsung.com>

There is memory constraint for the buffers in V5 of the MFC hardware, but
when IOMMU is used, then this constraint is meaningless. Other version of
the MFC hardware don't have such limitations. So in such cases the driver
is able to use buffers placed anywhere in the system memory, thus USERPTR
and DMABUF operation modes can be also enabled.

This patch also removes USERPTR operation mode from encoder node, as it
doesn't work with v5 MFC hardware without IOMMU being enabled.

Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
[mszyprow: adapted to v4.14 code base and updated commit message]
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c     | 14 ++++--
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c | 73 ++++++++++++++++++++++++----
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c | 24 ++++++---
 3 files changed, 89 insertions(+), 22 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index cf68aed59e0d..f975523dc040 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -754,6 +754,7 @@ static int s5p_mfc_open(struct file *file)
 	struct s5p_mfc_dev *dev = video_drvdata(file);
 	struct s5p_mfc_ctx *ctx = NULL;
 	struct vb2_queue *q;
+	unsigned int io_modes;
 	int ret = 0;
 
 	mfc_debug_enter();
@@ -839,16 +840,21 @@ static int s5p_mfc_open(struct file *file)
 		if (ret)
 			goto err_init_hw;
 	}
+
+	io_modes = VB2_MMAP;
+	if (exynos_is_iommu_available(&dev->plat_dev->dev) || !IS_TWOPORT(dev))
+		io_modes |= VB2_USERPTR | VB2_DMABUF;
+
 	/* Init videobuf2 queue for CAPTURE */
 	q = &ctx->vq_dst;
 	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
 	q->drv_priv = &ctx->fh;
 	q->lock = &dev->mfc_mutex;
 	if (vdev == dev->vfd_dec) {
-		q->io_modes = VB2_MMAP;
+		q->io_modes = io_modes;
 		q->ops = get_dec_queue_ops();
 	} else if (vdev == dev->vfd_enc) {
-		q->io_modes = VB2_MMAP | VB2_USERPTR;
+		q->io_modes = io_modes;
 		q->ops = get_enc_queue_ops();
 	} else {
 		ret = -ENOENT;
@@ -872,10 +878,10 @@ static int s5p_mfc_open(struct file *file)
 	q->drv_priv = &ctx->fh;
 	q->lock = &dev->mfc_mutex;
 	if (vdev == dev->vfd_dec) {
-		q->io_modes = VB2_MMAP;
+		q->io_modes = io_modes;
 		q->ops = get_dec_queue_ops();
 	} else if (vdev == dev->vfd_enc) {
-		q->io_modes = VB2_MMAP | VB2_USERPTR;
+		q->io_modes = io_modes;
 		q->ops = get_enc_queue_ops();
 	} else {
 		ret = -ENOENT;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 8937b0af7cb3..efe65fce4880 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -546,14 +546,27 @@ static int reqbufs_capture(struct s5p_mfc_dev *dev, struct s5p_mfc_ctx *ctx,
 			goto out;
 		}
 
-		WARN_ON(ctx->dst_bufs_cnt != ctx->total_dpb_count);
-		ctx->capture_state = QUEUE_BUFS_MMAPED;
+		if (reqbufs->memory == V4L2_MEMORY_MMAP) {
+			if (ctx->dst_bufs_cnt == ctx->total_dpb_count) {
+				ctx->capture_state = QUEUE_BUFS_MMAPED;
+			} else {
+				mfc_err("Not all buffers passed to buf_init\n");
+				reqbufs->count = 0;
+				ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
+				s5p_mfc_hw_call(dev->mfc_ops,
+						release_codec_buffers, ctx);
+				ret = -ENOMEM;
+				goto out;
+			}
+		}
 
 		if (s5p_mfc_ctx_ready(ctx))
 			set_work_bit_irqsave(ctx);
 		s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
-		s5p_mfc_wait_for_done_ctx(ctx, S5P_MFC_R2H_CMD_INIT_BUFFERS_RET,
-					  0);
+		if (reqbufs->memory == V4L2_MEMORY_MMAP) {
+			s5p_mfc_wait_for_done_ctx(ctx,
+					 S5P_MFC_R2H_CMD_INIT_BUFFERS_RET, 0);
+		}
 	} else {
 		mfc_err("Buffers have already been requested\n");
 		ret = -EINVAL;
@@ -571,15 +584,19 @@ static int vidioc_reqbufs(struct file *file, void *priv,
 {
 	struct s5p_mfc_dev *dev = video_drvdata(file);
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
-
-	if (reqbufs->memory != V4L2_MEMORY_MMAP) {
-		mfc_debug(2, "Only V4L2_MEMORY_MMAP is supported\n");
-		return -EINVAL;
-	}
+	int ret;
 
 	if (reqbufs->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		ret = vb2_verify_memory_type(&ctx->vq_src, reqbufs->memory,
+					     reqbufs->type);
+		if (ret)
+			return ret;
 		return reqbufs_output(dev, ctx, reqbufs);
 	} else if (reqbufs->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		ret = vb2_verify_memory_type(&ctx->vq_dst, reqbufs->memory,
+					     reqbufs->type);
+		if (ret)
+			return ret;
 		return reqbufs_capture(dev, ctx, reqbufs);
 	} else {
 		mfc_err("Invalid type requested\n");
@@ -998,6 +1015,27 @@ static int s5p_mfc_buf_init(struct vb2_buffer *vb)
 	return 0;
 }
 
+static int s5p_mfc_buf_prepare(struct vb2_buffer *vb)
+{
+	struct vb2_queue *vq = vb->vb2_queue;
+	struct s5p_mfc_ctx *ctx = fh_to_ctx(vq->drv_priv);
+
+	if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		if (vb2_plane_size(vb, 0) < ctx->luma_size ||
+			vb2_plane_size(vb, 1) < ctx->chroma_size) {
+			mfc_err("Plane buffer (CAPTURE) is too small.\n");
+			return -EINVAL;
+		}
+	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		if (vb2_plane_size(vb, 0) < ctx->dec_src_buf_size) {
+			mfc_err("Plane buffer (OUTPUT) is too small.\n");
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
 static int s5p_mfc_start_streaming(struct vb2_queue *q, unsigned int count)
 {
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(q->drv_priv);
@@ -1066,6 +1104,7 @@ static void s5p_mfc_buf_queue(struct vb2_buffer *vb)
 	struct s5p_mfc_dev *dev = ctx->dev;
 	unsigned long flags;
 	struct s5p_mfc_buf *mfc_buf;
+	int wait_flag = 0;
 
 	if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
 		mfc_buf = &ctx->src_bufs[vb->index];
@@ -1083,12 +1122,25 @@ static void s5p_mfc_buf_queue(struct vb2_buffer *vb)
 		list_add_tail(&mfc_buf->list, &ctx->dst_queue);
 		ctx->dst_queue_cnt++;
 		spin_unlock_irqrestore(&dev->irqlock, flags);
+		if ((vq->memory == V4L2_MEMORY_USERPTR ||
+			vq->memory == V4L2_MEMORY_DMABUF) &&
+			ctx->dst_queue_cnt == ctx->total_dpb_count)
+			ctx->capture_state = QUEUE_BUFS_MMAPED;
 	} else {
 		mfc_err("Unsupported buffer type (%d)\n", vq->type);
 	}
-	if (s5p_mfc_ctx_ready(ctx))
+	if (s5p_mfc_ctx_ready(ctx)) {
 		set_work_bit_irqsave(ctx);
+		if ((vq->memory == V4L2_MEMORY_USERPTR ||
+			vq->memory == V4L2_MEMORY_DMABUF) &&
+			ctx->state == MFCINST_HEAD_PARSED &&
+			ctx->capture_state == QUEUE_BUFS_MMAPED)
+			wait_flag = 1;
+	}
 	s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
+	if (wait_flag)
+		s5p_mfc_wait_for_done_ctx(ctx,
+				S5P_MFC_R2H_CMD_INIT_BUFFERS_RET, 0);
 }
 
 static struct vb2_ops s5p_mfc_dec_qops = {
@@ -1096,6 +1148,7 @@ static struct vb2_ops s5p_mfc_dec_qops = {
 	.wait_prepare		= vb2_ops_wait_prepare,
 	.wait_finish		= vb2_ops_wait_finish,
 	.buf_init		= s5p_mfc_buf_init,
+	.buf_prepare		= s5p_mfc_buf_prepare,
 	.start_streaming	= s5p_mfc_start_streaming,
 	.stop_streaming		= s5p_mfc_stop_streaming,
 	.buf_queue		= s5p_mfc_buf_queue,
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 2a5fd7c42cd5..63a2cb3c7555 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -1130,11 +1130,11 @@ static int vidioc_reqbufs(struct file *file, void *priv,
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
 	int ret = 0;
 
-	/* if memory is not mmp or userptr return error */
-	if ((reqbufs->memory != V4L2_MEMORY_MMAP) &&
-		(reqbufs->memory != V4L2_MEMORY_USERPTR))
-		return -EINVAL;
 	if (reqbufs->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		ret = vb2_verify_memory_type(&ctx->vq_dst, reqbufs->memory,
+					     reqbufs->type);
+		if (ret)
+			return ret;
 		if (reqbufs->count == 0) {
 			mfc_debug(2, "Freeing buffers\n");
 			ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
@@ -1164,6 +1164,10 @@ static int vidioc_reqbufs(struct file *file, void *priv,
 			return -ENOMEM;
 		}
 	} else if (reqbufs->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		ret = vb2_verify_memory_type(&ctx->vq_dst, reqbufs->memory,
+					     reqbufs->type);
+		if (ret)
+			return ret;
 		if (reqbufs->count == 0) {
 			mfc_debug(2, "Freeing buffers\n");
 			ret = vb2_reqbufs(&ctx->vq_src, reqbufs);
@@ -1209,11 +1213,11 @@ static int vidioc_querybuf(struct file *file, void *priv,
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
 	int ret = 0;
 
-	/* if memory is not mmp or userptr return error */
-	if ((buf->memory != V4L2_MEMORY_MMAP) &&
-		(buf->memory != V4L2_MEMORY_USERPTR))
-		return -EINVAL;
 	if (buf->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		ret = vb2_verify_memory_type(&ctx->vq_dst, buf->memory,
+					     buf->type);
+		if (ret)
+			return ret;
 		if (ctx->state != MFCINST_GOT_INST) {
 			mfc_err("invalid context state: %d\n", ctx->state);
 			return -EINVAL;
@@ -1225,6 +1229,10 @@ static int vidioc_querybuf(struct file *file, void *priv,
 		}
 		buf->m.planes[0].m.mem_offset += DST_QUEUE_OFF_BASE;
 	} else if (buf->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		ret = vb2_verify_memory_type(&ctx->vq_src, buf->memory,
+					     buf->type);
+		if (ret)
+			return ret;
 		ret = vb2_querybuf(&ctx->vq_src, buf);
 		if (ret != 0) {
 			mfc_err("error in vb2_querybuf() for E(S)\n");
-- 
2.14.2
