Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:45468 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726459AbeK3TZv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Nov 2018 14:25:51 -0500
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH v3] media: cedrus: Remove global IRQ spin lock from the driver
Date: Fri, 30 Nov 2018 09:16:17 +0100
Message-Id: <20181130081617.28710-1-paul.kocialkowski@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We initially introduced a spin lock to ensure that the VPU registers
are not accessed concurrently between our setup function and IRQ
handler. The V4L2 M2M API ensures that only one decoding job runs at a
time, so the interrupt signaling the end of decoding will not occur
while the next picture is being configured.

Spurious interrupts are taken care of in the handler, by checking that
we have a valid M2M context and a decoding status available before
marking the buffers as done.

In addition, holding a spin lock could be problematic if non-atomic
operations are required in the setup process for future codec support.

As a result, remove the global IRQ spin lock.

Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
Changes since v2:
* Rebased on top of the next media tree.

Changes since v1:
* Reworked commit message as suggested by Maxime.

 drivers/staging/media/sunxi/cedrus/cedrus.c       |  1 -
 drivers/staging/media/sunxi/cedrus/cedrus.h       |  2 --
 drivers/staging/media/sunxi/cedrus/cedrus_dec.c   |  9 ---------
 drivers/staging/media/sunxi/cedrus/cedrus_hw.c    | 13 +------------
 drivers/staging/media/sunxi/cedrus/cedrus_video.c |  5 -----
 5 files changed, 1 insertion(+), 29 deletions(-)

diff --git a/drivers/staging/media/sunxi/cedrus/cedrus.c b/drivers/staging/media/sunxi/cedrus/cedrus.c
index da790db450d2..edb04a696d70 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus.c
@@ -279,7 +279,6 @@ static int cedrus_probe(struct platform_device *pdev)
 	dev->dec_ops[CEDRUS_CODEC_MPEG2] = &cedrus_dec_ops_mpeg2;
 
 	mutex_init(&dev->dev_mutex);
-	spin_lock_init(&dev->irq_lock);
 
 	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
 	if (ret) {
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus.h b/drivers/staging/media/sunxi/cedrus/cedrus.h
index 3f61248c57ac..3acfdcf83691 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus.h
+++ b/drivers/staging/media/sunxi/cedrus/cedrus.h
@@ -105,8 +105,6 @@ struct cedrus_dev {
 
 	/* Device file mutex */
 	struct mutex		dev_mutex;
-	/* Interrupt spinlock */
-	spinlock_t		irq_lock;
 
 	void __iomem		*base;
 
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
index e40180a33951..6c5e310a7cf7 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
@@ -28,7 +28,6 @@ void cedrus_device_run(void *priv)
 	struct cedrus_dev *dev = ctx->dev;
 	struct cedrus_run run = { 0 };
 	struct media_request *src_req;
-	unsigned long flags;
 
 	run.src = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
 	run.dst = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
@@ -39,8 +38,6 @@ void cedrus_device_run(void *priv)
 	if (src_req)
 		v4l2_ctrl_request_setup(src_req, &ctx->hdl);
 
-	spin_lock_irqsave(&ctx->dev->irq_lock, flags);
-
 	switch (ctx->src_fmt.pixelformat) {
 	case V4L2_PIX_FMT_MPEG2_SLICE:
 		run.mpeg2.slice_params = cedrus_find_control_data(ctx,
@@ -55,16 +52,10 @@ void cedrus_device_run(void *priv)
 
 	dev->dec_ops[ctx->current_codec]->setup(ctx, &run);
 
-	spin_unlock_irqrestore(&ctx->dev->irq_lock, flags);
-
 	/* Complete request(s) controls if needed. */
 
 	if (src_req)
 		v4l2_ctrl_request_complete(src_req, &ctx->hdl);
 
-	spin_lock_irqsave(&ctx->dev->irq_lock, flags);
-
 	dev->dec_ops[ctx->current_codec]->trigger(ctx);
-
-	spin_unlock_irqrestore(&ctx->dev->irq_lock, flags);
 }
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_hw.c b/drivers/staging/media/sunxi/cedrus/cedrus_hw.c
index 493e65b17b30..243592a5425e 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_hw.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_hw.c
@@ -105,24 +105,17 @@ static irqreturn_t cedrus_irq(int irq, void *data)
 	struct vb2_v4l2_buffer *src_buf, *dst_buf;
 	enum vb2_buffer_state state;
 	enum cedrus_irq_status status;
-	unsigned long flags;
-
-	spin_lock_irqsave(&dev->irq_lock, flags);
 
 	ctx = v4l2_m2m_get_curr_priv(dev->m2m_dev);
 	if (!ctx) {
 		v4l2_err(&dev->v4l2_dev,
 			 "Instance released before the end of transaction\n");
-		spin_unlock_irqrestore(&dev->irq_lock, flags);
-
 		return IRQ_NONE;
 	}
 
 	status = dev->dec_ops[ctx->current_codec]->irq_status(ctx);
-	if (status == CEDRUS_IRQ_NONE) {
-		spin_unlock_irqrestore(&dev->irq_lock, flags);
+	if (status == CEDRUS_IRQ_NONE)
 		return IRQ_NONE;
-	}
 
 	dev->dec_ops[ctx->current_codec]->irq_disable(ctx);
 	dev->dec_ops[ctx->current_codec]->irq_clear(ctx);
@@ -133,8 +126,6 @@ static irqreturn_t cedrus_irq(int irq, void *data)
 	if (!src_buf || !dst_buf) {
 		v4l2_err(&dev->v4l2_dev,
 			 "Missing source and/or destination buffers\n");
-		spin_unlock_irqrestore(&dev->irq_lock, flags);
-
 		return IRQ_HANDLED;
 	}
 
@@ -146,8 +137,6 @@ static irqreturn_t cedrus_irq(int irq, void *data)
 	v4l2_m2m_buf_done(src_buf, state);
 	v4l2_m2m_buf_done(dst_buf, state);
 
-	spin_unlock_irqrestore(&dev->irq_lock, flags);
-
 	v4l2_m2m_job_finish(ctx->dev->m2m_dev, ctx->fh.m2m_ctx);
 
 	return IRQ_HANDLED;
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_video.c b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
index 5c5fce678b93..8721b4a7d496 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_video.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
@@ -380,18 +380,13 @@ static void cedrus_queue_cleanup(struct vb2_queue *vq, u32 state)
 {
 	struct cedrus_ctx *ctx = vb2_get_drv_priv(vq);
 	struct vb2_v4l2_buffer *vbuf;
-	unsigned long flags;
 
 	for (;;) {
-		spin_lock_irqsave(&ctx->dev->irq_lock, flags);
-
 		if (V4L2_TYPE_IS_OUTPUT(vq->type))
 			vbuf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
 		else
 			vbuf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
 
-		spin_unlock_irqrestore(&ctx->dev->irq_lock, flags);
-
 		if (!vbuf)
 			return;
 
-- 
2.19.1
