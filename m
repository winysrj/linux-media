Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:45599 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751524AbdCCMbt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 3 Mar 2017 07:31:49 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 2/4] [media] coda: keep queued buffers on a temporary list during start_streaming
Date: Fri,  3 Mar 2017 13:12:48 +0100
Message-Id: <20170303121250.13693-2-p.zabel@pengutronix.de>
In-Reply-To: <20170303121250.13693-1-p.zabel@pengutronix.de>
References: <20170303121250.13693-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Keeping buffers filled into the bitstream on a temporary list instead of
immediately calling vb2_buffer_done on each of them immediately allows
start_streaming to correctly decide whether they should be marked as
done or requeued if an error occurs after the bitstream has been filled.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c    | 28 ++++++++++++++++++++++------
 drivers/media/platform/coda/coda-common.c | 29 ++++++++++++++++++++++-------
 drivers/media/platform/coda/coda.h        |  2 +-
 3 files changed, 45 insertions(+), 14 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 466a44e4549e5..e3e3225607836 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -224,7 +224,7 @@ static bool coda_bitstream_try_queue(struct coda_ctx *ctx,
 	return true;
 }
 
-void coda_fill_bitstream(struct coda_ctx *ctx, bool streaming)
+void coda_fill_bitstream(struct coda_ctx *ctx, struct list_head *buffer_list)
 {
 	struct vb2_v4l2_buffer *src_buf;
 	struct coda_buffer_meta *meta;
@@ -252,9 +252,16 @@ void coda_fill_bitstream(struct coda_ctx *ctx, bool streaming)
 				 "dropping invalid JPEG frame %d\n",
 				 ctx->qsequence);
 			src_buf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
-			v4l2_m2m_buf_done(src_buf, streaming ?
-					  VB2_BUF_STATE_ERROR :
-					  VB2_BUF_STATE_QUEUED);
+			if (buffer_list) {
+				struct v4l2_m2m_buffer *m2m_buf;
+
+				m2m_buf = container_of(src_buf,
+						       struct v4l2_m2m_buffer,
+						       vb);
+				list_add_tail(&m2m_buf->list, buffer_list);
+			} else {
+				v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_ERROR);
+			}
 			continue;
 		}
 
@@ -295,7 +302,16 @@ void coda_fill_bitstream(struct coda_ctx *ctx, bool streaming)
 				trace_coda_bit_queue(ctx, src_buf, meta);
 			}
 
-			v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_DONE);
+			if (buffer_list) {
+				struct v4l2_m2m_buffer *m2m_buf;
+
+				m2m_buf = container_of(src_buf,
+						       struct v4l2_m2m_buffer,
+						       vb);
+				list_add_tail(&m2m_buf->list, buffer_list);
+			} else {
+				v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_DONE);
+			}
 		} else {
 			break;
 		}
@@ -1747,7 +1763,7 @@ static int coda_prepare_decode(struct coda_ctx *ctx)
 
 	/* Try to copy source buffer contents into the bitstream ringbuffer */
 	mutex_lock(&ctx->bitstream_mutex);
-	coda_fill_bitstream(ctx, true);
+	coda_fill_bitstream(ctx, NULL);
 	mutex_unlock(&ctx->bitstream_mutex);
 
 	if (coda_get_bitstream_payload(ctx) < 512 &&
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index a7318b5a1e6ce..f3d4a595bb13a 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1378,7 +1378,7 @@ static void coda_buf_queue(struct vb2_buffer *vb)
 		v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
 		if (vb2_is_streaming(vb->vb2_queue))
 			/* This set buf->sequence = ctx->qsequence++ */
-			coda_fill_bitstream(ctx, true);
+			coda_fill_bitstream(ctx, NULL);
 		mutex_unlock(&ctx->bitstream_mutex);
 	} else {
 		if (ctx->inst_type == CODA_INST_ENCODER &&
@@ -1433,18 +1433,22 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 	struct coda_ctx *ctx = vb2_get_drv_priv(q);
 	struct v4l2_device *v4l2_dev = &ctx->dev->v4l2_dev;
 	struct coda_q_data *q_data_src, *q_data_dst;
+	struct v4l2_m2m_buffer *m2m_buf, *tmp;
 	struct vb2_v4l2_buffer *buf;
+	struct list_head list;
 	int ret = 0;
 
 	if (count < 1)
 		return -EINVAL;
 
+	INIT_LIST_HEAD(&list);
+
 	q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
 	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
 		if (ctx->inst_type == CODA_INST_DECODER && ctx->use_bit) {
 			/* copy the buffers that were queued before streamon */
 			mutex_lock(&ctx->bitstream_mutex);
-			coda_fill_bitstream(ctx, false);
+			coda_fill_bitstream(ctx, &list);
 			mutex_unlock(&ctx->bitstream_mutex);
 
 			if (coda_get_bitstream_payload(ctx) < 512) {
@@ -1460,7 +1464,7 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 
 	/* Don't start the coda unless both queues are on */
 	if (!(ctx->streamon_out && ctx->streamon_cap))
-		return 0;
+		goto out;
 
 	q_data_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
 	if ((q_data_src->width != q_data_dst->width &&
@@ -1495,15 +1499,26 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 	ret = ctx->ops->start_streaming(ctx);
 	if (ctx->inst_type == CODA_INST_DECODER) {
 		if (ret == -EAGAIN)
-			return 0;
-		else if (ret < 0)
-			goto err;
+			goto out;
 	}
+	if (ret < 0)
+		goto err;
 
-	return ret;
+out:
+	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
+		list_for_each_entry_safe(m2m_buf, tmp, &list, list) {
+			list_del(&m2m_buf->list);
+			v4l2_m2m_buf_done(&m2m_buf->vb, VB2_BUF_STATE_DONE);
+		}
+	}
+	return 0;
 
 err:
 	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
+		list_for_each_entry_safe(m2m_buf, tmp, &list, list) {
+			list_del(&m2m_buf->list);
+			v4l2_m2m_buf_done(&m2m_buf->vb, VB2_BUF_STATE_QUEUED);
+		}
 		while ((buf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx)))
 			v4l2_m2m_buf_done(buf, VB2_BUF_STATE_QUEUED);
 	} else {
diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
index 4b831c91ae4af..6aa9c19c4a896 100644
--- a/drivers/media/platform/coda/coda.h
+++ b/drivers/media/platform/coda/coda.h
@@ -259,7 +259,7 @@ int coda_decoder_queue_init(void *priv, struct vb2_queue *src_vq,
 
 int coda_hw_reset(struct coda_ctx *ctx);
 
-void coda_fill_bitstream(struct coda_ctx *ctx, bool streaming);
+void coda_fill_bitstream(struct coda_ctx *ctx, struct list_head *buffer_list);
 
 void coda_set_gdi_regs(struct coda_ctx *ctx);
 
-- 
2.11.0
