Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:44144 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbaKZWnQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Nov 2014 17:43:16 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH v2 03/11] media: exynos-gsc: use vb2_ops_wait_prepare/finish helper
Date: Wed, 26 Nov 2014 22:42:26 +0000
Message-Id: <1417041754-8714-4-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1417041754-8714-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1417041754-8714-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch drops driver specific wait_prepare() and
wait_finish() callbacks from vb2_ops and instead uses
the the helpers vb2_ops_wait_prepare/finish() provided
by the vb2 core, the lock member of the queue needs
to be initalized to a mutex so that vb2 helpers
vb2_ops_wait_prepare/finish() can make use of it.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>
---
 drivers/media/platform/exynos-gsc/gsc-core.h | 12 ------------
 drivers/media/platform/exynos-gsc/gsc-m2m.c  |  6 ++++--
 2 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.h b/drivers/media/platform/exynos-gsc/gsc-core.h
index 0abdb17..fa572aa 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.h
+++ b/drivers/media/platform/exynos-gsc/gsc-core.h
@@ -466,18 +466,6 @@ static inline void gsc_hw_clear_irq(struct gsc_dev *dev, int irq)
 	writel(cfg, dev->regs + GSC_IRQ);
 }
 
-static inline void gsc_lock(struct vb2_queue *vq)
-{
-	struct gsc_ctx *ctx = vb2_get_drv_priv(vq);
-	mutex_lock(&ctx->gsc_dev->lock);
-}
-
-static inline void gsc_unlock(struct vb2_queue *vq)
-{
-	struct gsc_ctx *ctx = vb2_get_drv_priv(vq);
-	mutex_unlock(&ctx->gsc_dev->lock);
-}
-
 static inline bool gsc_ctx_state_is_set(u32 mask, struct gsc_ctx *ctx)
 {
 	unsigned long flags;
diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
index 74e1de6..d5cffef 100644
--- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
+++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
@@ -267,8 +267,8 @@ static struct vb2_ops gsc_m2m_qops = {
 	.queue_setup	 = gsc_m2m_queue_setup,
 	.buf_prepare	 = gsc_m2m_buf_prepare,
 	.buf_queue	 = gsc_m2m_buf_queue,
-	.wait_prepare	 = gsc_unlock,
-	.wait_finish	 = gsc_lock,
+	.wait_prepare	 = vb2_ops_wait_prepare,
+	.wait_finish	 = vb2_ops_wait_finish,
 	.stop_streaming	 = gsc_m2m_stop_streaming,
 	.start_streaming = gsc_m2m_start_streaming,
 };
@@ -590,6 +590,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->mem_ops = &vb2_dma_contig_memops;
 	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	src_vq->lock = &ctx->gsc_dev->lock;
 
 	ret = vb2_queue_init(src_vq);
 	if (ret)
@@ -603,6 +604,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	dst_vq->mem_ops = &vb2_dma_contig_memops;
 	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	dst_vq->lock = &ctx->gsc_dev->lock;
 
 	return vb2_queue_init(dst_vq);
 }
-- 
1.9.1

