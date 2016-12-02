Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f47.google.com ([74.125.83.47]:36279 "EHLO
        mail-pg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756914AbcLBCiu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Dec 2016 21:38:50 -0500
Received: by mail-pg0-f47.google.com with SMTP id f188so101410413pgc.3
        for <linux-media@vger.kernel.org>; Thu, 01 Dec 2016 18:38:50 -0800 (PST)
From: Wu-Cheng Li <wuchengli@chromium.org>
To: tiffany.lin@mediatek.com, andrew-ct.chen@mediatek.com,
        mchehab@kernel.org, matthias.bgg@gmail.com
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        djkurtz@chromium.org, pawel@osciak.com,
        Wu-Cheng Li <wuchengli@chromium.org>
Subject: [PATCH v1] mtk-vcodec: use V4L2_DEC_CMD_STOP to implement flush
Date: Fri,  2 Dec 2016 10:38:34 +0800
Message-Id: <1480646314-75478-2-git-send-email-wuchengli@chromium.org>
In-Reply-To: <1480646314-75478-1-git-send-email-wuchengli@chromium.org>
References: <1480646314-75478-1-git-send-email-wuchengli@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Tiffany Lin <tiffany.lin@mediatek.com>

Also remove the code using size-0 OUTPUT buffer to flush.

Singed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
Signed-off-by: Wu-Cheng Li <wuchengli@chromium.org>
Reviewed-by: Kuang-che Wu <kcwu@chromium.org>
---
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c | 151 ++++++++++++++-------
 .../media/platform/mtk-vcodec/mtk_vcodec_dec_drv.c |  14 ++
 drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h |   2 +
 3 files changed, 117 insertions(+), 50 deletions(-)

diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
index 0746592..407c8ba 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
@@ -351,16 +351,6 @@ static void mtk_vdec_worker(struct work_struct *work)
 	dst_vb2_v4l2 = container_of(dst_buf, struct vb2_v4l2_buffer, vb2_buf);
 	dst_buf_info = container_of(dst_vb2_v4l2, struct mtk_video_dec_buf, vb);
 
-	buf.va = vb2_plane_vaddr(src_buf, 0);
-	buf.dma_addr = vb2_dma_contig_plane_dma_addr(src_buf, 0);
-	buf.size = (size_t)src_buf->planes[0].bytesused;
-	if (!buf.va) {
-		v4l2_m2m_job_finish(dev->m2m_dev_dec, ctx->m2m_ctx);
-		mtk_v4l2_err("[%d] id=%d src_addr is NULL!!",
-				ctx->id, src_buf->index);
-		return;
-	}
-
 	pfb = &dst_buf_info->frame_buffer;
 	pfb->base_y.va = vb2_plane_vaddr(dst_buf, 0);
 	pfb->base_y.dma_addr = vb2_dma_contig_plane_dma_addr(dst_buf, 0);
@@ -371,8 +361,6 @@ static void mtk_vdec_worker(struct work_struct *work)
 	pfb->base_c.size = ctx->picinfo.c_bs_sz + ctx->picinfo.c_len_sz;
 	pfb->status = 0;
 	mtk_v4l2_debug(3, "===>[%d] vdec_if_decode() ===>", ctx->id);
-	mtk_v4l2_debug(3, "[%d] Bitstream VA=%p DMA=%pad Size=%zx vb=%p",
-			ctx->id, buf.va, &buf.dma_addr, buf.size, src_buf);
 
 	mtk_v4l2_debug(3,
 			"id=%d Framebuf  pfb=%p VA=%p Y_DMA=%pad C_DMA=%pad Size=%zx",
@@ -381,24 +369,36 @@ static void mtk_vdec_worker(struct work_struct *work)
 			&pfb->base_c.dma_addr, pfb->base_y.size);
 
 	if (src_buf_info->lastframe) {
-		/* update src buf status */
+		mtk_v4l2_debug(1, "Got empty flush input buffer.");
 		src_buf = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
-		src_buf_info->lastframe = false;
-		v4l2_m2m_buf_done(&src_buf_info->vb, VB2_BUF_STATE_DONE);
 
 		/* update dst buf status */
 		dst_buf = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
+		mutex_lock(&ctx->lock);
 		dst_buf_info->used = false;
+		mutex_unlock(&ctx->lock);
 
 		vdec_if_decode(ctx, NULL, NULL, &res_chg);
 		clean_display_buffer(ctx);
 		vb2_set_plane_payload(&dst_buf_info->vb.vb2_buf, 0, 0);
 		vb2_set_plane_payload(&dst_buf_info->vb.vb2_buf, 1, 0);
+		dst_vb2_v4l2->flags |= V4L2_BUF_FLAG_LAST;
 		v4l2_m2m_buf_done(&dst_buf_info->vb, VB2_BUF_STATE_DONE);
 		clean_free_buffer(ctx);
 		v4l2_m2m_job_finish(dev->m2m_dev_dec, ctx->m2m_ctx);
 		return;
 	}
+	buf.va = vb2_plane_vaddr(src_buf, 0);
+	buf.dma_addr = vb2_dma_contig_plane_dma_addr(src_buf, 0);
+	buf.size = (size_t)src_buf->planes[0].bytesused;
+	if (!buf.va) {
+		v4l2_m2m_job_finish(dev->m2m_dev_dec, ctx->m2m_ctx);
+		mtk_v4l2_err("[%d] id=%d src_addr is NULL!!",
+				ctx->id, src_buf->index);
+		return;
+	}
+	mtk_v4l2_debug(3, "[%d] Bitstream VA=%p DMA=%pad Size=%zx vb=%p",
+			ctx->id, buf.va, &buf.dma_addr, buf.size, src_buf);
 	dst_buf_info->vb.vb2_buf.timestamp
 			= src_buf_info->vb.vb2_buf.timestamp;
 	dst_buf_info->vb.timecode
@@ -412,10 +412,9 @@ static void mtk_vdec_worker(struct work_struct *work)
 
 	if (ret) {
 		mtk_v4l2_err(
-			" <===[%d], src_buf[%d]%d sz=0x%zx pts=%llu dst_buf[%d] vdec_if_decode() ret=%d res_chg=%d===>",
+			" <===[%d], src_buf[%d] sz=0x%zx pts=%llu dst_buf[%d] vdec_if_decode() ret=%d res_chg=%d===>",
 			ctx->id,
 			src_buf->index,
-			src_buf_info->lastframe,
 			buf.size,
 			src_buf_info->vb.vb2_buf.timestamp,
 			dst_buf->index,
@@ -456,6 +455,65 @@ static void mtk_vdec_worker(struct work_struct *work)
 	v4l2_m2m_job_finish(dev->m2m_dev_dec, ctx->m2m_ctx);
 }
 
+static int vidioc_try_decoder_cmd(struct file *file, void *priv,
+				struct v4l2_decoder_cmd *cmd)
+{
+	switch (cmd->cmd) {
+	case V4L2_DEC_CMD_STOP:
+	case V4L2_DEC_CMD_START:
+		if (cmd->flags != 0) {
+			mtk_v4l2_err("cmd->flags=%u", cmd->flags);
+			return -EINVAL;
+		}
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+
+static int vidioc_decoder_cmd(struct file *file, void *priv,
+				struct v4l2_decoder_cmd *cmd)
+{
+	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
+	struct vb2_queue *src_vq, *dst_vq;
+	int ret;
+
+	ret = vidioc_try_decoder_cmd(file, priv, cmd);
+	if (ret)
+		return ret;
+
+	mtk_v4l2_debug(1, "decoder cmd=%u", cmd->cmd);
+	dst_vq = v4l2_m2m_get_vq(ctx->m2m_ctx,
+				V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE);
+	switch (cmd->cmd) {
+	case V4L2_DEC_CMD_STOP:
+		src_vq = v4l2_m2m_get_vq(ctx->m2m_ctx,
+				V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE);
+		if (!vb2_is_streaming(src_vq)) {
+			mtk_v4l2_debug(1, "Output stream is off. No need to flush.");
+			return 0;
+		}
+		if (!vb2_is_streaming(dst_vq)) {
+			mtk_v4l2_debug(1, "Capture stream is off. No need to flush.");
+			return 0;
+		}
+		v4l2_m2m_buf_queue(ctx->m2m_ctx, &ctx->empty_flush_buf->vb);
+		v4l2_m2m_try_schedule(ctx->m2m_ctx);
+		break;
+
+	case V4L2_DEC_CMD_START:
+		vb2_clear_last_buffer_dequeued(dst_vq);
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 void mtk_vdec_unlock(struct mtk_vcodec_ctx *ctx)
 {
 	mutex_unlock(&ctx->dev->dec_mutex);
@@ -521,10 +579,6 @@ static int vidioc_vdec_qbuf(struct file *file, void *priv,
 			    struct v4l2_buffer *buf)
 {
 	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
-	struct vb2_queue *vq;
-	struct vb2_buffer *vb;
-	struct mtk_video_dec_buf *mtkbuf;
-	struct vb2_v4l2_buffer	*vb2_v4l2;
 
 	if (ctx->state == MTK_STATE_ABORT) {
 		mtk_v4l2_err("[%d] Call on QBUF after unrecoverable error",
@@ -532,25 +586,6 @@ static int vidioc_vdec_qbuf(struct file *file, void *priv,
 		return -EIO;
 	}
 
-	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, buf->type);
-	if (buf->index >= vq->num_buffers) {
-		mtk_v4l2_debug(1, "buffer index %d out of range", buf->index);
-		return -EINVAL;
-	}
-	vb = vq->bufs[buf->index];
-	vb2_v4l2 = container_of(vb, struct vb2_v4l2_buffer, vb2_buf);
-	mtkbuf = container_of(vb2_v4l2, struct mtk_video_dec_buf, vb);
-
-	if ((buf->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) &&
-	    (buf->m.planes[0].bytesused == 0)) {
-		mtkbuf->lastframe = true;
-		mtk_v4l2_debug(1, "[%d] (%d) id=%d lastframe=%d (%d,%d, %d) vb=%p",
-			 ctx->id, buf->type, buf->index,
-			 mtkbuf->lastframe, buf->bytesused,
-			 buf->m.planes[0].bytesused, buf->length,
-			 vb);
-	}
-
 	return v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
 }
 
@@ -1067,10 +1102,8 @@ static void vb2ops_vdec_buf_queue(struct vb2_buffer *vb)
 	int ret = 0;
 	unsigned int dpbsize = 1;
 	struct mtk_vcodec_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
-	struct vb2_v4l2_buffer *vb2_v4l2 = container_of(vb,
-				struct vb2_v4l2_buffer, vb2_buf);
-	struct mtk_video_dec_buf *buf = container_of(vb2_v4l2,
-				struct mtk_video_dec_buf, vb);
+	struct vb2_v4l2_buffer *vb2_v4l2 = NULL;
+	struct mtk_video_dec_buf *buf = NULL;
 
 	mtk_v4l2_debug(3, "[%d] (%d) id=%d, vb=%p",
 			ctx->id, vb->vb2_queue->type,
@@ -1079,10 +1112,11 @@ static void vb2ops_vdec_buf_queue(struct vb2_buffer *vb)
 	 * check if this buffer is ready to be used after decode
 	 */
 	if (vb->vb2_queue->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		vb2_v4l2 = to_vb2_v4l2_buffer(vb);
+		buf = container_of(vb2_v4l2, struct mtk_video_dec_buf, vb);
 		mutex_lock(&ctx->lock);
 		if (buf->used == false) {
-			v4l2_m2m_buf_queue(ctx->m2m_ctx,
-					to_vb2_v4l2_buffer(vb));
+			v4l2_m2m_buf_queue(ctx->m2m_ctx, vb2_v4l2);
 			buf->queued_in_vb2 = true;
 			buf->queued_in_v4l2 = true;
 			buf->ready_to_display = false;
@@ -1095,7 +1129,7 @@ static void vb2ops_vdec_buf_queue(struct vb2_buffer *vb)
 		return;
 	}
 
-	v4l2_m2m_buf_queue(ctx->m2m_ctx, vb2_v4l2);
+	v4l2_m2m_buf_queue(ctx->m2m_ctx, to_vb2_v4l2_buffer(vb));
 
 	if (ctx->state != MTK_STATE_INIT) {
 		mtk_v4l2_debug(3, "[%d] already init driver %d",
@@ -1108,6 +1142,14 @@ static void vb2ops_vdec_buf_queue(struct vb2_buffer *vb)
 		mtk_v4l2_err("No src buffer");
 		return;
 	}
+	vb2_v4l2 = to_vb2_v4l2_buffer(src_buf);
+	buf = container_of(vb2_v4l2, struct mtk_video_dec_buf, vb);
+	if (buf->lastframe) {
+		/* This shouldn't happen. Just in case. */
+		mtk_v4l2_err("Invalid flush buffer.");
+		v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
+		return;
+	}
 
 	src_mem.va = vb2_plane_vaddr(src_buf, 0);
 	src_mem.dma_addr = vb2_dma_contig_plane_dma_addr(src_buf, 0);
@@ -1224,9 +1266,15 @@ static void vb2ops_vdec_stop_streaming(struct vb2_queue *q)
 			ctx->id, q->type, ctx->state, ctx->decoded_frame_cnt);
 
 	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
-		while ((src_buf = v4l2_m2m_src_buf_remove(ctx->m2m_ctx)))
-			v4l2_m2m_buf_done(to_vb2_v4l2_buffer(src_buf),
-					VB2_BUF_STATE_ERROR);
+		while ((src_buf = v4l2_m2m_src_buf_remove(ctx->m2m_ctx))) {
+			struct vb2_v4l2_buffer *vb2_v4l2 =
+					to_vb2_v4l2_buffer(src_buf);
+			struct mtk_video_dec_buf *buf_info = container_of(
+					vb2_v4l2, struct mtk_video_dec_buf, vb);
+			if (!buf_info->lastframe)
+				v4l2_m2m_buf_done(vb2_v4l2,
+						VB2_BUF_STATE_ERROR);
+		}
 		return;
 	}
 
@@ -1406,6 +1454,9 @@ const struct v4l2_ioctl_ops mtk_vdec_ioctl_ops = {
 	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
 	.vidioc_g_selection             = vidioc_vdec_g_selection,
 	.vidioc_s_selection             = vidioc_vdec_s_selection,
+
+	.vidioc_decoder_cmd = vidioc_decoder_cmd,
+	.vidioc_try_decoder_cmd = vidioc_try_decoder_cmd,
 };
 
 int mtk_vcodec_dec_queue_init(void *priv, struct vb2_queue *src_vq,
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_drv.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_drv.c
index d48287c..4334b73 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_drv.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_drv.c
@@ -105,13 +105,21 @@ static int fops_vcodec_open(struct file *file)
 {
 	struct mtk_vcodec_dev *dev = video_drvdata(file);
 	struct mtk_vcodec_ctx *ctx = NULL;
+	struct mtk_video_dec_buf *mtk_buf = NULL;
 	int ret = 0;
+	struct vb2_queue *src_vq;
 
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;
+	mtk_buf = kzalloc(sizeof(*mtk_buf), GFP_KERNEL);
+	if (!mtk_buf) {
+		kfree(ctx);
+		return -ENOMEM;
+	}
 
 	mutex_lock(&dev->dev_mutex);
+	ctx->empty_flush_buf = mtk_buf;
 	ctx->id = dev->id_counter++;
 	v4l2_fh_init(&ctx->fh, video_devdata(file));
 	file->private_data = &ctx->fh;
@@ -135,6 +143,10 @@ static int fops_vcodec_open(struct file *file)
 			ret);
 		goto err_m2m_ctx_init;
 	}
+	src_vq = v4l2_m2m_get_vq(ctx->m2m_ctx,
+				V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE);
+	ctx->empty_flush_buf->vb.vb2_buf.vb2_queue = src_vq;
+	ctx->empty_flush_buf->lastframe = true;
 	mtk_vcodec_dec_set_default_params(ctx);
 
 	if (v4l2_fh_is_singular(&ctx->fh)) {
@@ -173,6 +185,7 @@ static int fops_vcodec_open(struct file *file)
 err_ctrls_setup:
 	v4l2_fh_del(&ctx->fh);
 	v4l2_fh_exit(&ctx->fh);
+	kfree(ctx->empty_flush_buf);
 	kfree(ctx);
 	mutex_unlock(&dev->dev_mutex);
 
@@ -203,6 +216,7 @@ static int fops_vcodec_release(struct file *file)
 	v4l2_ctrl_handler_free(&ctx->ctrl_hdl);
 
 	list_del_init(&ctx->list);
+	kfree(ctx->empty_flush_buf);
 	kfree(ctx);
 	mutex_unlock(&dev->dev_mutex);
 	return 0;
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h b/drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h
index d7eb8ef..3cffb38 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h
@@ -254,6 +254,7 @@ struct vdec_pic_info {
  * @decode_work: worker for the decoding
  * @encode_work: worker for the encoding
  * @last_decoded_picinfo: pic information get from latest decode
+ * @empty_flush_buf: a fake size-0 capture buffer that indicates flush
  *
  * @colorspace: enum v4l2_colorspace; supplemental to pixelformat
  * @ycbcr_enc: enum v4l2_ycbcr_encoding, Y'CbCr encoding
@@ -291,6 +292,7 @@ struct mtk_vcodec_ctx {
 	struct work_struct decode_work;
 	struct work_struct encode_work;
 	struct vdec_pic_info last_decoded_picinfo;
+	struct mtk_video_dec_buf *empty_flush_buf;
 
 	enum v4l2_colorspace colorspace;
 	enum v4l2_ycbcr_encoding ycbcr_enc;
-- 
2.8.0.rc3.226.g39d4020

