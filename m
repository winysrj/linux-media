Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECEB1C169C4
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 16:21:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2CF12086C
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 16:21:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfBHQV2 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 11:21:28 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:55420 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726847AbfBHQV2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Feb 2019 11:21:28 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id 14960260F54
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 01/10] mtk-jpeg: Correct return type for mem2mem buffer helpers
Date:   Fri,  8 Feb 2019 13:17:39 -0300
Message-Id: <20190208161748.5862-2-ezequiel@collabora.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190208161748.5862-1-ezequiel@collabora.com>
References: <20190208161748.5862-1-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Fix the assigned type of mem2mem buffer handling API.
Namely, these functions:

 v4l2_m2m_next_buf
 v4l2_m2m_last_buf
 v4l2_m2m_buf_remove
 v4l2_m2m_next_src_buf
 v4l2_m2m_next_dst_buf
 v4l2_m2m_last_src_buf
 v4l2_m2m_last_dst_buf
 v4l2_m2m_src_buf_remove
 v4l2_m2m_dst_buf_remove

return a struct vb2_v4l2_buffer, and not a struct vb2_buffer.

Fixing this is necessary to fix the mem2mem buffer handling API,
changing the return to the correct struct vb2_v4l2_buffer instead
of a void pointer.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 .../media/platform/mtk-jpeg/mtk_jpeg_core.c   | 40 +++++++++----------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c b/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
index 2a5d5002c27e..f761e4d8bf2a 100644
--- a/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
+++ b/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
@@ -702,7 +702,7 @@ static void mtk_jpeg_buf_queue(struct vb2_buffer *vb)
 	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, to_vb2_v4l2_buffer(vb));
 }
 
-static void *mtk_jpeg_buf_remove(struct mtk_jpeg_ctx *ctx,
+static struct vb2_v4l2_buffer *mtk_jpeg_buf_remove(struct mtk_jpeg_ctx *ctx,
 				 enum v4l2_buf_type type)
 {
 	if (V4L2_TYPE_IS_OUTPUT(type))
@@ -714,7 +714,7 @@ static void *mtk_jpeg_buf_remove(struct mtk_jpeg_ctx *ctx,
 static int mtk_jpeg_start_streaming(struct vb2_queue *q, unsigned int count)
 {
 	struct mtk_jpeg_ctx *ctx = vb2_get_drv_priv(q);
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 	int ret = 0;
 
 	ret = pm_runtime_get_sync(ctx->jpeg->dev);
@@ -724,14 +724,14 @@ static int mtk_jpeg_start_streaming(struct vb2_queue *q, unsigned int count)
 	return 0;
 err:
 	while ((vb = mtk_jpeg_buf_remove(ctx, q->type)))
-		v4l2_m2m_buf_done(to_vb2_v4l2_buffer(vb), VB2_BUF_STATE_QUEUED);
+		v4l2_m2m_buf_done(vb, VB2_BUF_STATE_QUEUED);
 	return ret;
 }
 
 static void mtk_jpeg_stop_streaming(struct vb2_queue *q)
 {
 	struct mtk_jpeg_ctx *ctx = vb2_get_drv_priv(q);
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 
 	/*
 	 * STREAMOFF is an acknowledgment for source change event.
@@ -743,7 +743,7 @@ static void mtk_jpeg_stop_streaming(struct vb2_queue *q)
 		struct mtk_jpeg_src_buf *src_buf;
 
 		vb = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
-		src_buf = mtk_jpeg_vb2_to_srcbuf(vb);
+		src_buf = mtk_jpeg_vb2_to_srcbuf(&vb->vb2_buf);
 		mtk_jpeg_set_queue_data(ctx, &src_buf->dec_param);
 		ctx->state = MTK_JPEG_RUNNING;
 	} else if (V4L2_TYPE_IS_OUTPUT(q->type)) {
@@ -751,7 +751,7 @@ static void mtk_jpeg_stop_streaming(struct vb2_queue *q)
 	}
 
 	while ((vb = mtk_jpeg_buf_remove(ctx, q->type)))
-		v4l2_m2m_buf_done(to_vb2_v4l2_buffer(vb), VB2_BUF_STATE_ERROR);
+		v4l2_m2m_buf_done(vb, VB2_BUF_STATE_ERROR);
 
 	pm_runtime_put_sync(ctx->jpeg->dev);
 }
@@ -807,7 +807,7 @@ static void mtk_jpeg_device_run(void *priv)
 {
 	struct mtk_jpeg_ctx *ctx = priv;
 	struct mtk_jpeg_dev *jpeg = ctx->jpeg;
-	struct vb2_buffer *src_buf, *dst_buf;
+	struct vb2_v4l2_buffer *src_buf, *dst_buf;
 	enum vb2_buffer_state buf_state = VB2_BUF_STATE_ERROR;
 	unsigned long flags;
 	struct mtk_jpeg_src_buf *jpeg_src_buf;
@@ -817,11 +817,11 @@ static void mtk_jpeg_device_run(void *priv)
 
 	src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
 	dst_buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
-	jpeg_src_buf = mtk_jpeg_vb2_to_srcbuf(src_buf);
+	jpeg_src_buf = mtk_jpeg_vb2_to_srcbuf(&src_buf->vb2_buf);
 
 	if (jpeg_src_buf->flags & MTK_JPEG_BUF_FLAGS_LAST_FRAME) {
-		for (i = 0; i < dst_buf->num_planes; i++)
-			vb2_set_plane_payload(dst_buf, i, 0);
+		for (i = 0; i < dst_buf->vb2_buf.num_planes; i++)
+			vb2_set_plane_payload(&dst_buf->vb2_buf, i, 0);
 		buf_state = VB2_BUF_STATE_DONE;
 		goto dec_end;
 	}
@@ -833,8 +833,8 @@ static void mtk_jpeg_device_run(void *priv)
 		return;
 	}
 
-	mtk_jpeg_set_dec_src(ctx, src_buf, &bs);
-	if (mtk_jpeg_set_dec_dst(ctx, &jpeg_src_buf->dec_param, dst_buf, &fb))
+	mtk_jpeg_set_dec_src(ctx, &src_buf->vb2_buf, &bs);
+	if (mtk_jpeg_set_dec_dst(ctx, &jpeg_src_buf->dec_param, &dst_buf->vb2_buf, &fb))
 		goto dec_end;
 
 	spin_lock_irqsave(&jpeg->hw_lock, flags);
@@ -849,8 +849,8 @@ static void mtk_jpeg_device_run(void *priv)
 dec_end:
 	v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
 	v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
-	v4l2_m2m_buf_done(to_vb2_v4l2_buffer(src_buf), buf_state);
-	v4l2_m2m_buf_done(to_vb2_v4l2_buffer(dst_buf), buf_state);
+	v4l2_m2m_buf_done(src_buf, buf_state);
+	v4l2_m2m_buf_done(dst_buf, buf_state);
 	v4l2_m2m_job_finish(jpeg->m2m_dev, ctx->fh.m2m_ctx);
 }
 
@@ -921,7 +921,7 @@ static irqreturn_t mtk_jpeg_dec_irq(int irq, void *priv)
 {
 	struct mtk_jpeg_dev *jpeg = priv;
 	struct mtk_jpeg_ctx *ctx;
-	struct vb2_buffer *src_buf, *dst_buf;
+	struct vb2_v4l2_buffer *src_buf, *dst_buf;
 	struct mtk_jpeg_src_buf *jpeg_src_buf;
 	enum vb2_buffer_state buf_state = VB2_BUF_STATE_ERROR;
 	u32	dec_irq_ret;
@@ -938,7 +938,7 @@ static irqreturn_t mtk_jpeg_dec_irq(int irq, void *priv)
 
 	src_buf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
 	dst_buf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
-	jpeg_src_buf = mtk_jpeg_vb2_to_srcbuf(src_buf);
+	jpeg_src_buf = mtk_jpeg_vb2_to_srcbuf(&src_buf->vb2_buf);
 
 	if (dec_irq_ret >= MTK_JPEG_DEC_RESULT_UNDERFLOW)
 		mtk_jpeg_dec_reset(jpeg->dec_reg_base);
@@ -948,15 +948,15 @@ static irqreturn_t mtk_jpeg_dec_irq(int irq, void *priv)
 		goto dec_end;
 	}
 
-	for (i = 0; i < dst_buf->num_planes; i++)
-		vb2_set_plane_payload(dst_buf, i,
+	for (i = 0; i < dst_buf->vb2_buf.num_planes; i++)
+		vb2_set_plane_payload(&dst_buf->vb2_buf, i,
 				      jpeg_src_buf->dec_param.comp_size[i]);
 
 	buf_state = VB2_BUF_STATE_DONE;
 
 dec_end:
-	v4l2_m2m_buf_done(to_vb2_v4l2_buffer(src_buf), buf_state);
-	v4l2_m2m_buf_done(to_vb2_v4l2_buffer(dst_buf), buf_state);
+	v4l2_m2m_buf_done(src_buf, buf_state);
+	v4l2_m2m_buf_done(dst_buf, buf_state);
 	v4l2_m2m_job_finish(jpeg->m2m_dev, ctx->fh.m2m_ctx);
 	return IRQ_HANDLED;
 }
-- 
2.20.1

