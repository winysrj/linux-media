Return-path: <mchehab@gaivota>
Received: from ganesha.gnumonks.org ([213.95.27.120]:51226 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab0L2IJI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Dec 2010 03:09:08 -0500
From: Hyunwoong Kim <khw0178.kim@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: s.nawrocki@samsung.com, Hyunwoong Kim <khw0178.kim@samsung.com>
Subject: [PATCH v2] [media] s5p-fimc: Support stop_streaming and job_abort
Date: Wed, 29 Dec 2010 16:47:49 +0900
Message-Id: <1293608869-31794-1-git-send-email-khw0178.kim@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

This patch adds callback functions, stop_streaming and job_abort,
to abort or finish any DMA in progress. stop_streaming is called
by videobuf2 framework and job_abort is called by m2m framework.
ST_M2M_PEND state is added to discard the next job.

Reviewed-by: Jonghun Han <jonghun.han@samsung.com>
Signed-off-by: Hyunwoong Kim <khw0178.kim@samsung.com>
---
Changes since V1:
- remove the spinlock protections and unnecessay variables

This patch is depended on Hyunwoong Kim's last patch.
- [PATCH v2] [media] s5p-fimc: update checking scaling ratio range

 drivers/media/video/s5p-fimc/fimc-core.c |   35 ++++++++++++++++++++++++++++-
 drivers/media/video/s5p-fimc/fimc-core.h |    1 +
 2 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index e608fb8..953a8c1 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -305,6 +305,23 @@ int fimc_set_scaler_info(struct fimc_ctx *ctx)
 	return 0;
 }
 
+static int stop_streaming(struct vb2_queue *q)
+{
+	struct fimc_ctx *ctx = q->drv_priv;
+	struct fimc_dev *fimc = ctx->fimc_dev;
+
+	if (!fimc_m2m_pending(fimc))
+		return 0;
+
+	set_bit(ST_M2M_SHUT, &fimc->state);
+
+	wait_event_timeout(fimc->irq_queue,
+			   !test_bit(ST_M2M_SHUT, &fimc->state),
+			   FIMC_SHUTDOWN_TIMEOUT);
+
+	return 0;
+}
+
 static void fimc_capture_handler(struct fimc_dev *fimc)
 {
 	struct fimc_vid_cap *cap = &fimc->vid_cap;
@@ -356,7 +373,10 @@ static irqreturn_t fimc_isr(int irq, void *priv)
 
 	spin_lock(&fimc->slock);
 
-	if (test_and_clear_bit(ST_M2M_PEND, &fimc->state)) {
+	if (test_and_clear_bit(ST_M2M_SHUT, &fimc->state)) {
+		wake_up(&fimc->irq_queue);
+		goto isr_unlock;
+	} else if (test_and_clear_bit(ST_M2M_PEND, &fimc->state)) {
 		struct vb2_buffer *src_vb, *dst_vb;
 		struct fimc_ctx *ctx = v4l2_m2m_get_curr_priv(fimc->m2m.m2m_dev);
 
@@ -636,7 +656,17 @@ dma_unlock:
 
 static void fimc_job_abort(void *priv)
 {
-	/* Nothing done in job_abort. */
+	struct fimc_ctx *ctx = priv;
+	struct fimc_dev *fimc = ctx->fimc_dev;
+
+	if (!fimc_m2m_pending(fimc))
+		return;
+
+	set_bit(ST_M2M_SHUT, &fimc->state);
+
+	wait_event_timeout(fimc->irq_queue,
+			   !test_bit(ST_M2M_SHUT, &fimc->state),
+			   FIMC_SHUTDOWN_TIMEOUT);
 }
 
 static int fimc_queue_setup(struct vb2_queue *vq, unsigned int *num_buffers,
@@ -713,6 +743,7 @@ struct vb2_ops fimc_qops = {
 	.buf_queue	 = fimc_buf_queue,
 	.wait_prepare	 = fimc_unlock,
 	.wait_finish	 = fimc_lock,
+	.stop_streaming	 = stop_streaming,
 };
 
 static int fimc_m2m_querycap(struct file *file, void *priv,
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index b442fed..b938b41 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -51,6 +51,7 @@ enum fimc_dev_flags {
 	ST_IDLE,
 	ST_OUTDMA_RUN,
 	ST_M2M_PEND,
+	ST_M2M_SHUT,
 	/* for capture node */
 	ST_CAPT_PEND,
 	ST_CAPT_RUN,
-- 
1.6.2.5

