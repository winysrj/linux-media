Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:51260 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753985AbeFREkp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Jun 2018 00:40:45 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, kernel@collabora.com,
        Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kamil Debski <kamil@wypas.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v2 3/3] mem2mem: Make .job_abort optional
Date: Mon, 18 Jun 2018 01:38:52 -0300
Message-Id: <20180618043852.13293-4-ezequiel@collabora.com>
In-Reply-To: <20180618043852.13293-1-ezequiel@collabora.com>
References: <20180618043852.13293-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implementing job_abort() does not make sense on some drivers.
This is not a problem, as the abort is not required to
wait for the job to finish. Quite the opposite, drivers
are encouraged not to wait.

Demote v4l2_m2m_ops.job_abort from required to optional, and
clean all drivers with dummy implementations.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c | 5 -----
 drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c    | 5 -----
 drivers/media/platform/rcar_jpu.c               | 5 -----
 drivers/media/platform/rockchip/rga/rga.c       | 6 ------
 drivers/media/platform/s5p-g2d/g2d.c            | 5 -----
 drivers/media/platform/s5p-jpeg/jpeg-core.c     | 7 -------
 drivers/media/v4l2-core/v4l2-mem2mem.c          | 6 +++---
 include/media/v4l2-mem2mem.h                    | 2 +-
 8 files changed, 4 insertions(+), 37 deletions(-)

diff --git a/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c b/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
index af17aaa21f58..b0c24e0426db 100644
--- a/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
+++ b/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
@@ -861,14 +861,9 @@ static int mtk_jpeg_job_ready(void *priv)
 	return (ctx->state == MTK_JPEG_RUNNING) ? 1 : 0;
 }
 
-static void mtk_jpeg_job_abort(void *priv)
-{
-}
-
 static const struct v4l2_m2m_ops mtk_jpeg_m2m_ops = {
 	.device_run = mtk_jpeg_device_run,
 	.job_ready  = mtk_jpeg_job_ready,
-	.job_abort  = mtk_jpeg_job_abort,
 };
 
 static int mtk_jpeg_queue_init(void *priv, struct vb2_queue *src_vq,
diff --git a/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c b/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
index 583d47724ee8..1198e19060a2 100644
--- a/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
+++ b/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
@@ -455,10 +455,6 @@ static void mtk_mdp_m2m_stop_streaming(struct vb2_queue *q)
 	pm_runtime_put(&ctx->mdp_dev->pdev->dev);
 }
 
-static void mtk_mdp_m2m_job_abort(void *priv)
-{
-}
-
 /* The color format (num_planes) must be already configured. */
 static void mtk_mdp_prepare_addr(struct mtk_mdp_ctx *ctx,
 				 struct vb2_buffer *vb,
@@ -1227,7 +1223,6 @@ static const struct v4l2_file_operations mtk_mdp_m2m_fops = {
 
 static const struct v4l2_m2m_ops mtk_mdp_m2m_ops = {
 	.device_run	= mtk_mdp_m2m_device_run,
-	.job_abort	= mtk_mdp_m2m_job_abort,
 };
 
 int mtk_mdp_register_m2m_device(struct mtk_mdp_dev *mdp)
diff --git a/drivers/media/platform/rcar_jpu.c b/drivers/media/platform/rcar_jpu.c
index dec696e6b974..c2230d24eb11 100644
--- a/drivers/media/platform/rcar_jpu.c
+++ b/drivers/media/platform/rcar_jpu.c
@@ -1490,13 +1490,8 @@ static void jpu_device_run(void *priv)
 	spin_unlock_irqrestore(&ctx->jpu->lock, flags);
 }
 
-static void jpu_job_abort(void *priv)
-{
-}
-
 static const struct v4l2_m2m_ops jpu_m2m_ops = {
 	.device_run	= jpu_device_run,
-	.job_abort	= jpu_job_abort,
 };
 
 /*
diff --git a/drivers/media/platform/rockchip/rga/rga.c b/drivers/media/platform/rockchip/rga/rga.c
index 5a5a6139e18a..d833bb32a538 100644
--- a/drivers/media/platform/rockchip/rga/rga.c
+++ b/drivers/media/platform/rockchip/rga/rga.c
@@ -39,11 +39,6 @@
 static int debug;
 module_param(debug, int, 0644);
 
-static void job_abort(void *prv)
-{
-	/* Can't do anything rational here */
-}
-
 static void device_run(void *prv)
 {
 	struct rga_ctx *ctx = prv;
@@ -104,7 +99,6 @@ static irqreturn_t rga_isr(int irq, void *prv)
 
 static struct v4l2_m2m_ops rga_m2m_ops = {
 	.device_run = device_run,
-	.job_abort = job_abort,
 };
 
 static int
diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
index e98708883413..680a1b94a19a 100644
--- a/drivers/media/platform/s5p-g2d/g2d.c
+++ b/drivers/media/platform/s5p-g2d/g2d.c
@@ -481,10 +481,6 @@ static int vidioc_s_crop(struct file *file, void *prv, const struct v4l2_crop *c
 	return 0;
 }
 
-static void job_abort(void *prv)
-{
-}
-
 static void device_run(void *prv)
 {
 	struct g2d_ctx *ctx = prv;
@@ -603,7 +599,6 @@ static const struct video_device g2d_videodev = {
 
 static const struct v4l2_m2m_ops g2d_m2m_ops = {
 	.device_run	= device_run,
-	.job_abort	= job_abort,
 };
 
 static const struct of_device_id exynos_g2d_match[];
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 79b63da27f53..04fd2e0493c0 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -2467,26 +2467,19 @@ static int s5p_jpeg_job_ready(void *priv)
 	return 1;
 }
 
-static void s5p_jpeg_job_abort(void *priv)
-{
-}
-
 static struct v4l2_m2m_ops s5p_jpeg_m2m_ops = {
 	.device_run	= s5p_jpeg_device_run,
 	.job_ready	= s5p_jpeg_job_ready,
-	.job_abort	= s5p_jpeg_job_abort,
 };
 
 static struct v4l2_m2m_ops exynos3250_jpeg_m2m_ops = {
 	.device_run	= exynos3250_jpeg_device_run,
 	.job_ready	= s5p_jpeg_job_ready,
-	.job_abort	= s5p_jpeg_job_abort,
 };
 
 static struct v4l2_m2m_ops exynos4_jpeg_m2m_ops = {
 	.device_run	= exynos4_jpeg_device_run,
 	.job_ready	= s5p_jpeg_job_ready,
-	.job_abort	= s5p_jpeg_job_abort,
 };
 
 /*
diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index c4f963d96a79..7bae19ca611e 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -300,7 +300,8 @@ static void v4l2_m2m_cancel_job(struct v4l2_m2m_ctx *m2m_ctx)
 	m2m_ctx->job_flags |= TRANS_ABORT;
 	if (m2m_ctx->job_flags & TRANS_RUNNING) {
 		spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags);
-		m2m_dev->m2m_ops->job_abort(m2m_ctx->priv);
+		if (m2m_dev->m2m_ops->job_abort)
+			m2m_dev->m2m_ops->job_abort(m2m_ctx->priv);
 		dprintk("m2m_ctx %p running, will wait to complete", m2m_ctx);
 		wait_event(m2m_ctx->finished,
 				!(m2m_ctx->job_flags & TRANS_RUNNING));
@@ -599,8 +600,7 @@ struct v4l2_m2m_dev *v4l2_m2m_init(const struct v4l2_m2m_ops *m2m_ops)
 {
 	struct v4l2_m2m_dev *m2m_dev;
 
-	if (!m2m_ops || WARN_ON(!m2m_ops->device_run) ||
-			WARN_ON(!m2m_ops->job_abort))
+	if (!m2m_ops || WARN_ON(!m2m_ops->device_run))
 		return ERR_PTR(-EINVAL);
 
 	m2m_dev = kzalloc(sizeof *m2m_dev, GFP_KERNEL);
diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-mem2mem.h
index 8f4b208cfee7..c2d817d3ff42 100644
--- a/include/media/v4l2-mem2mem.h
+++ b/include/media/v4l2-mem2mem.h
@@ -32,7 +32,7 @@
  *		assumed that one source and one destination buffer are all
  *		that is required for the driver to perform one full transaction.
  *		This method may not sleep.
- * @job_abort:	required. Informs the driver that it has to abort the currently
+ * @job_abort:	optional. Informs the driver that it has to abort the currently
  *		running transaction as soon as possible (i.e. as soon as it can
  *		stop the device safely; e.g. in the next interrupt handler),
  *		even if the transaction would not have been finished by then.
-- 
2.16.3
