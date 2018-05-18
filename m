Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:33398 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751920AbeERSxx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 14:53:53 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, kernel@collabora.com,
        Abylay Ospan <aospan@netup.ru>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 08/20] mtk-mdp: Add locks for capture and output vb2_queues
Date: Fri, 18 May 2018 15:51:56 -0300
Message-Id: <20180518185208.17722-9-ezequiel@collabora.com>
In-Reply-To: <20180518185208.17722-1-ezequiel@collabora.com>
References: <20180518185208.17722-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the mutex in struct mtk_mdp_ctx to protect the
capture and output  vb2_queues. This allows to replace
the ad-hoc wait_{prepare, finish} with
vb2_ops_wait_{prepare, finish}.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c b/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
index 583d47724ee8..c2e2f5f1ebf1 100644
--- a/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
+++ b/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
@@ -394,20 +394,6 @@ static bool mtk_mdp_ctx_state_is_set(struct mtk_mdp_ctx *ctx, u32 mask)
 	return ret;
 }
 
-static void mtk_mdp_ctx_lock(struct vb2_queue *vq)
-{
-	struct mtk_mdp_ctx *ctx = vb2_get_drv_priv(vq);
-
-	mutex_lock(&ctx->mdp_dev->lock);
-}
-
-static void mtk_mdp_ctx_unlock(struct vb2_queue *vq)
-{
-	struct mtk_mdp_ctx *ctx = vb2_get_drv_priv(vq);
-
-	mutex_unlock(&ctx->mdp_dev->lock);
-}
-
 static void mtk_mdp_set_frame_size(struct mtk_mdp_frame *frame, int width,
 				   int height)
 {
@@ -625,10 +611,10 @@ static const struct vb2_ops mtk_mdp_m2m_qops = {
 	.queue_setup	 = mtk_mdp_m2m_queue_setup,
 	.buf_prepare	 = mtk_mdp_m2m_buf_prepare,
 	.buf_queue	 = mtk_mdp_m2m_buf_queue,
-	.wait_prepare	 = mtk_mdp_ctx_unlock,
-	.wait_finish	 = mtk_mdp_ctx_lock,
 	.stop_streaming	 = mtk_mdp_m2m_stop_streaming,
 	.start_streaming = mtk_mdp_m2m_start_streaming,
+	.wait_prepare	 = vb2_ops_wait_prepare,
+	.wait_finish	 = vb2_ops_wait_finish,
 };
 
 static int mtk_mdp_m2m_querycap(struct file *file, void *fh,
@@ -996,6 +982,7 @@ static int mtk_mdp_m2m_queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	src_vq->dev = &ctx->mdp_dev->pdev->dev;
+	src_vq->lock = &ctx->mdp_dev->lock;
 
 	ret = vb2_queue_init(src_vq);
 	if (ret)
@@ -1010,6 +997,7 @@ static int mtk_mdp_m2m_queue_init(void *priv, struct vb2_queue *src_vq,
 	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	dst_vq->dev = &ctx->mdp_dev->pdev->dev;
+	dst_vq->lock = &ctx->mdp_dev->lock;
 
 	return vb2_queue_init(dst_vq);
 }
-- 
2.16.3
