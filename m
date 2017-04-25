Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:33752 "EHLO
        mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S980587AbdDYGUE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Apr 2017 02:20:04 -0400
Received: by mail-pf0-f179.google.com with SMTP id a188so22244847pfa.0
        for <linux-media@vger.kernel.org>; Mon, 24 Apr 2017 23:20:04 -0700 (PDT)
From: Alexandre Courbot <acourbot@chromium.org>
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>
Subject: [PATCH] [media] s5p-jpeg: fix recursive spinlock acquisition
Date: Tue, 25 Apr 2017 15:19:43 +0900
Message-Id: <20170425061943.717-1-acourbot@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2_m2m_job_finish(), which is called from the interrupt handler with
slock acquired, can call the device_run() hook immediately if another
context was in the queue. This hook also acquires slock, resulting in
a deadlock for this scenario.

Fix this by releasing slock right before calling v4l2_m2m_job_finish().
This is safe to do as the state of the hardware cannot change before
v4l2_m2m_job_finish() is called anyway.

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 52dc7941db65..223b4379929e 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -2642,13 +2642,13 @@ static irqreturn_t s5p_jpeg_irq(int irq, void *dev_id)
 	if (curr_ctx->mode == S5P_JPEG_ENCODE)
 		vb2_set_plane_payload(&dst_buf->vb2_buf, 0, payload_size);
 	v4l2_m2m_buf_done(dst_buf, state);
-	v4l2_m2m_job_finish(jpeg->m2m_dev, curr_ctx->fh.m2m_ctx);
 
 	curr_ctx->subsampling = s5p_jpeg_get_subsampling_mode(jpeg->regs);
 	spin_unlock(&jpeg->slock);
 
 	s5p_jpeg_clear_int(jpeg->regs);
 
+	v4l2_m2m_job_finish(jpeg->m2m_dev, curr_ctx->fh.m2m_ctx);
 	return IRQ_HANDLED;
 }
 
@@ -2707,11 +2707,12 @@ static irqreturn_t exynos4_jpeg_irq(int irq, void *priv)
 		v4l2_m2m_buf_done(dst_vb, VB2_BUF_STATE_ERROR);
 	}
 
-	v4l2_m2m_job_finish(jpeg->m2m_dev, curr_ctx->fh.m2m_ctx);
 	if (jpeg->variant->version == SJPEG_EXYNOS4)
 		curr_ctx->subsampling = exynos4_jpeg_get_frame_fmt(jpeg->regs);
 
 	spin_unlock(&jpeg->slock);
+
+	v4l2_m2m_job_finish(jpeg->m2m_dev, curr_ctx->fh.m2m_ctx);
 	return IRQ_HANDLED;
 }
 
@@ -2770,10 +2771,15 @@ static irqreturn_t exynos3250_jpeg_irq(int irq, void *dev_id)
 	if (curr_ctx->mode == S5P_JPEG_ENCODE)
 		vb2_set_plane_payload(&dst_buf->vb2_buf, 0, payload_size);
 	v4l2_m2m_buf_done(dst_buf, state);
-	v4l2_m2m_job_finish(jpeg->m2m_dev, curr_ctx->fh.m2m_ctx);
 
 	curr_ctx->subsampling =
 			exynos3250_jpeg_get_subsampling_mode(jpeg->regs);
+
+	spin_unlock(&jpeg->slock);
+
+	v4l2_m2m_job_finish(jpeg->m2m_dev, curr_ctx->fh.m2m_ctx);
+	return IRQ_HANDLED;
+
 exit_unlock:
 	spin_unlock(&jpeg->slock);
 	return IRQ_HANDLED;
-- 
2.13.0.rc0.306.g87b477812d-goog
