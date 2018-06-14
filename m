Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:55320 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755269AbeFNPfr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Jun 2018 11:35:47 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, kernel@collabora.com,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 1/3] mem2mem: Remove unused v4l2_m2m_ops .lock/.unlock
Date: Thu, 14 Jun 2018 12:34:03 -0300
Message-Id: <20180614153405.5697-2-ezequiel@collabora.com>
In-Reply-To: <20180614153405.5697-1-ezequiel@collabora.com>
References: <20180614153405.5697-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit f1a81afc98e3 ("[media] m2m: fix bad unlock balance")
removed the last use of v4l2_m2m_ops.lock and
v4l2_m2m_ops.unlock hooks. They are not actually
used anymore. Remove them.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/media/platform/coda/coda-common.c          | 26 ++++------------------
 drivers/media/platform/m2m-deinterlace.c           | 20 ++---------------
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c | 18 ---------------
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c | 16 -------------
 drivers/media/platform/mx2_emmaprp.c               | 16 -------------
 drivers/media/platform/sti/delta/delta-v4l2.c      | 18 ---------------
 drivers/media/platform/ti-vpe/vpe.c                | 19 ----------------
 include/media/v4l2-mem2mem.h                       |  6 -----
 8 files changed, 6 insertions(+), 133 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index c7631e117dd3..b86d704ae10c 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1297,28 +1297,10 @@ static void coda_job_abort(void *priv)
 		 "Aborting task\n");
 }
 
-static void coda_lock(void *m2m_priv)
-{
-	struct coda_ctx *ctx = m2m_priv;
-	struct coda_dev *pcdev = ctx->dev;
-
-	mutex_lock(&pcdev->dev_mutex);
-}
-
-static void coda_unlock(void *m2m_priv)
-{
-	struct coda_ctx *ctx = m2m_priv;
-	struct coda_dev *pcdev = ctx->dev;
-
-	mutex_unlock(&pcdev->dev_mutex);
-}
-
 static const struct v4l2_m2m_ops coda_m2m_ops = {
 	.device_run	= coda_device_run,
 	.job_ready	= coda_job_ready,
 	.job_abort	= coda_job_abort,
-	.lock		= coda_lock,
-	.unlock		= coda_unlock,
 };
 
 static void set_default_params(struct coda_ctx *ctx)
@@ -2092,9 +2074,9 @@ static int coda_open(struct file *file)
 	INIT_LIST_HEAD(&ctx->buffer_meta_list);
 	spin_lock_init(&ctx->buffer_meta_lock);
 
-	coda_lock(ctx);
+	mutex_lock(&dev->dev_mutex);
 	list_add(&ctx->list, &dev->instances);
-	coda_unlock(ctx);
+	mutex_unlock(&dev->dev_mutex);
 
 	v4l2_dbg(1, coda_debug, &dev->v4l2_dev, "Created instance %d (%p)\n",
 		 ctx->idx, ctx);
@@ -2142,9 +2124,9 @@ static int coda_release(struct file *file)
 		flush_work(&ctx->seq_end_work);
 	}
 
-	coda_lock(ctx);
+	mutex_lock(&dev->dev_mutex);
 	list_del(&ctx->list);
-	coda_unlock(ctx);
+	mutex_unlock(&dev->dev_mutex);
 
 	if (ctx->dev->devtype->product == CODA_DX6)
 		coda_free_aux_buf(dev, &ctx->workbuf);
diff --git a/drivers/media/platform/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
index 1e4195144f39..734619d5954d 100644
--- a/drivers/media/platform/m2m-deinterlace.c
+++ b/drivers/media/platform/m2m-deinterlace.c
@@ -181,20 +181,6 @@ static void deinterlace_job_abort(void *priv)
 	v4l2_m2m_job_finish(pcdev->m2m_dev, ctx->m2m_ctx);
 }
 
-static void deinterlace_lock(void *priv)
-{
-	struct deinterlace_ctx *ctx = priv;
-	struct deinterlace_dev *pcdev = ctx->dev;
-	mutex_lock(&pcdev->dev_mutex);
-}
-
-static void deinterlace_unlock(void *priv)
-{
-	struct deinterlace_ctx *ctx = priv;
-	struct deinterlace_dev *pcdev = ctx->dev;
-	mutex_unlock(&pcdev->dev_mutex);
-}
-
 static void dma_callback(void *data)
 {
 	struct deinterlace_ctx *curr_ctx = data;
@@ -956,9 +942,9 @@ static __poll_t deinterlace_poll(struct file *file,
 	struct deinterlace_ctx *ctx = file->private_data;
 	__poll_t ret;
 
-	deinterlace_lock(ctx);
+	mutex_lock(&ctx->dev->dev_mutex);
 	ret = v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
-	deinterlace_unlock(ctx);
+	mutex_unlock(&ctx->dev->dev_mutex);
 
 	return ret;
 }
@@ -992,8 +978,6 @@ static const struct v4l2_m2m_ops m2m_ops = {
 	.device_run	= deinterlace_device_run,
 	.job_ready	= deinterlace_job_ready,
 	.job_abort	= deinterlace_job_abort,
-	.lock		= deinterlace_lock,
-	.unlock		= deinterlace_unlock,
 };
 
 static int deinterlace_probe(struct platform_device *pdev)
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
index 86f0a7134365..5523edadb86c 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
@@ -1411,28 +1411,10 @@ int mtk_vcodec_dec_ctrls_setup(struct mtk_vcodec_ctx *ctx)
 	return 0;
 }
 
-static void m2mops_vdec_lock(void *m2m_priv)
-{
-	struct mtk_vcodec_ctx *ctx = m2m_priv;
-
-	mtk_v4l2_debug(3, "[%d]", ctx->id);
-	mutex_lock(&ctx->dev->dev_mutex);
-}
-
-static void m2mops_vdec_unlock(void *m2m_priv)
-{
-	struct mtk_vcodec_ctx *ctx = m2m_priv;
-
-	mtk_v4l2_debug(3, "[%d]", ctx->id);
-	mutex_unlock(&ctx->dev->dev_mutex);
-}
-
 const struct v4l2_m2m_ops mtk_vdec_m2m_ops = {
 	.device_run	= m2mops_vdec_device_run,
 	.job_ready	= m2mops_vdec_job_ready,
 	.job_abort	= m2mops_vdec_job_abort,
-	.lock		= m2mops_vdec_lock,
-	.unlock		= m2mops_vdec_unlock,
 };
 
 static const struct vb2_ops mtk_vdec_vb2_ops = {
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
index 1b1a28abbf1f..6ad408514a99 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
@@ -1181,26 +1181,10 @@ static void m2mops_venc_job_abort(void *priv)
 	ctx->state = MTK_STATE_ABORT;
 }
 
-static void m2mops_venc_lock(void *m2m_priv)
-{
-	struct mtk_vcodec_ctx *ctx = m2m_priv;
-
-	mutex_lock(&ctx->dev->dev_mutex);
-}
-
-static void m2mops_venc_unlock(void *m2m_priv)
-{
-	struct mtk_vcodec_ctx *ctx = m2m_priv;
-
-	mutex_unlock(&ctx->dev->dev_mutex);
-}
-
 const struct v4l2_m2m_ops mtk_venc_m2m_ops = {
 	.device_run	= m2mops_venc_device_run,
 	.job_ready	= m2mops_venc_job_ready,
 	.job_abort	= m2mops_venc_job_abort,
-	.lock		= m2mops_venc_lock,
-	.unlock		= m2mops_venc_unlock,
 };
 
 void mtk_vcodec_enc_set_default_params(struct mtk_vcodec_ctx *ctx)
diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
index 5a8eff60e95f..6dddb76c0b41 100644
--- a/drivers/media/platform/mx2_emmaprp.c
+++ b/drivers/media/platform/mx2_emmaprp.c
@@ -250,20 +250,6 @@ static void emmaprp_job_abort(void *priv)
 	v4l2_m2m_job_finish(pcdev->m2m_dev, ctx->m2m_ctx);
 }
 
-static void emmaprp_lock(void *priv)
-{
-	struct emmaprp_ctx *ctx = priv;
-	struct emmaprp_dev *pcdev = ctx->dev;
-	mutex_lock(&pcdev->dev_mutex);
-}
-
-static void emmaprp_unlock(void *priv)
-{
-	struct emmaprp_ctx *ctx = priv;
-	struct emmaprp_dev *pcdev = ctx->dev;
-	mutex_unlock(&pcdev->dev_mutex);
-}
-
 static inline void emmaprp_dump_regs(struct emmaprp_dev *pcdev)
 {
 	dprintk(pcdev,
@@ -885,8 +871,6 @@ static const struct video_device emmaprp_videodev = {
 static const struct v4l2_m2m_ops m2m_ops = {
 	.device_run	= emmaprp_device_run,
 	.job_abort	= emmaprp_job_abort,
-	.lock		= emmaprp_lock,
-	.unlock		= emmaprp_unlock,
 };
 
 static int emmaprp_probe(struct platform_device *pdev)
diff --git a/drivers/media/platform/sti/delta/delta-v4l2.c b/drivers/media/platform/sti/delta/delta-v4l2.c
index 232d508c5b66..0b42acd4e3a6 100644
--- a/drivers/media/platform/sti/delta/delta-v4l2.c
+++ b/drivers/media/platform/sti/delta/delta-v4l2.c
@@ -339,22 +339,6 @@ static void register_decoders(struct delta_dev *delta)
 	}
 }
 
-static void delta_lock(void *priv)
-{
-	struct delta_ctx *ctx = priv;
-	struct delta_dev *delta = ctx->dev;
-
-	mutex_lock(&delta->lock);
-}
-
-static void delta_unlock(void *priv)
-{
-	struct delta_ctx *ctx = priv;
-	struct delta_dev *delta = ctx->dev;
-
-	mutex_unlock(&delta->lock);
-}
-
 static int delta_open_decoder(struct delta_ctx *ctx, u32 streamformat,
 			      u32 pixelformat, const struct delta_dec **pdec)
 {
@@ -1099,8 +1083,6 @@ static const struct v4l2_m2m_ops delta_m2m_ops = {
 	.device_run     = delta_device_run,
 	.job_ready	= delta_job_ready,
 	.job_abort      = delta_job_abort,
-	.lock		= delta_lock,
-	.unlock		= delta_unlock,
 };
 
 /*
diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index e395aa85c8ad..32f33c968cf1 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -953,23 +953,6 @@ static void job_abort(void *priv)
 	ctx->aborting = 1;
 }
 
-/*
- * Lock access to the device
- */
-static void vpe_lock(void *priv)
-{
-	struct vpe_ctx *ctx = priv;
-	struct vpe_dev *dev = ctx->dev;
-	mutex_lock(&dev->dev_mutex);
-}
-
-static void vpe_unlock(void *priv)
-{
-	struct vpe_ctx *ctx = priv;
-	struct vpe_dev *dev = ctx->dev;
-	mutex_unlock(&dev->dev_mutex);
-}
-
 static void vpe_dump_regs(struct vpe_dev *dev)
 {
 #define DUMPREG(r) vpe_dbg(dev, "%-35s %08x\n", #r, read_reg(dev, VPE_##r))
@@ -2434,8 +2417,6 @@ static const struct v4l2_m2m_ops m2m_ops = {
 	.device_run	= device_run,
 	.job_ready	= job_ready,
 	.job_abort	= job_abort,
-	.lock		= vpe_lock,
-	.unlock		= vpe_unlock,
 };
 
 static int vpe_runtime_get(struct platform_device *pdev)
diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-mem2mem.h
index 3d07ba3a8262..8f4b208cfee7 100644
--- a/include/media/v4l2-mem2mem.h
+++ b/include/media/v4l2-mem2mem.h
@@ -40,17 +40,11 @@
  *		v4l2_m2m_job_finish() (as if the transaction ended normally).
  *		This function does not have to (and will usually not) wait
  *		until the device enters a state when it can be stopped.
- * @lock:	optional. Define a driver's own lock callback, instead of using
- *		&v4l2_m2m_ctx->q_lock.
- * @unlock:	optional. Define a driver's own unlock callback, instead of
- *		using &v4l2_m2m_ctx->q_lock.
  */
 struct v4l2_m2m_ops {
 	void (*device_run)(void *priv);
 	int (*job_ready)(void *priv);
 	void (*job_abort)(void *priv);
-	void (*lock)(void *priv);
-	void (*unlock)(void *priv);
 };
 
 struct v4l2_m2m_dev;
-- 
2.16.3
