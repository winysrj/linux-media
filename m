Return-Path: <SRS0=UobA=R6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AB81C43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 18:50:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 504482075C
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 18:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553712638;
	bh=CeQ62Pbfbh6tZwFK4ti5CCpPzHMeTwY0GTEr+LaJKJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Fil5HoZjsnnBwmsdmymZdh+NLXeGW85zBoDUyzB4lVT3+ByrEahi+TwlU1R+e2CC3
	 cAw01OFibmlpvlxuTbAl6zSAEyMYVhdw9WReEbWmFKjkLq0S/UNektgsB3b/iOKbFh
	 jkCHyQpTGF6oo7XmVPKzXpsECi6bfuX+xReHRH9c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390708AbfC0Suc (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Mar 2019 14:50:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:35130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390475AbfC0SSS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Mar 2019 14:18:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 982812087C;
        Wed, 27 Mar 2019 18:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553710697;
        bh=CeQ62Pbfbh6tZwFK4ti5CCpPzHMeTwY0GTEr+LaJKJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pSr14/okJOS9ZDBqydy4hQDEvVxV1F8WGnkIy7w55YFn+flDYpDcwpML4b9Jh40WI
         jdbpqOfjXr+8tF0yLDp7+cMhL6IgZRWJ+oTV3khX8qWXgZe2OcbC0xRG/AcBmVQQqg
         BZwLHkFtNEOaAGpc3YlUyHkiS/ymGiVti7pqE7hA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ezequiel Garcia <ezequiel@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 060/123] media: mtk-jpeg: Correct return type for mem2mem buffer helpers
Date:   Wed, 27 Mar 2019 14:15:24 -0400
Message-Id: <20190327181628.15899-60-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190327181628.15899-1-sashal@kernel.org>
References: <20190327181628.15899-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Ezequiel Garcia <ezequiel@collabora.com>

[ Upstream commit 1b275e4e8b70dbff9850874b30831c1bd8d3c504 ]

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
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/platform/mtk-jpeg/mtk_jpeg_core.c   | 40 +++++++++----------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c b/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
index 226f90886484..46c996936798 100644
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
 
@@ -926,7 +926,7 @@ static irqreturn_t mtk_jpeg_dec_irq(int irq, void *priv)
 {
 	struct mtk_jpeg_dev *jpeg = priv;
 	struct mtk_jpeg_ctx *ctx;
-	struct vb2_buffer *src_buf, *dst_buf;
+	struct vb2_v4l2_buffer *src_buf, *dst_buf;
 	struct mtk_jpeg_src_buf *jpeg_src_buf;
 	enum vb2_buffer_state buf_state = VB2_BUF_STATE_ERROR;
 	u32	dec_irq_ret;
@@ -943,7 +943,7 @@ static irqreturn_t mtk_jpeg_dec_irq(int irq, void *priv)
 
 	src_buf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
 	dst_buf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
-	jpeg_src_buf = mtk_jpeg_vb2_to_srcbuf(src_buf);
+	jpeg_src_buf = mtk_jpeg_vb2_to_srcbuf(&src_buf->vb2_buf);
 
 	if (dec_irq_ret >= MTK_JPEG_DEC_RESULT_UNDERFLOW)
 		mtk_jpeg_dec_reset(jpeg->dec_reg_base);
@@ -953,15 +953,15 @@ static irqreturn_t mtk_jpeg_dec_irq(int irq, void *priv)
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
2.19.1

