Return-path: <mchehab@pedra>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:22005 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755417Ab1BXOjd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Feb 2011 09:39:33 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Thu, 24 Feb 2011 15:33:48 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 1/7] s5p-fimc: fix ISR and buffer handling for fimc-capture
In-reply-to: <1298558034-10768-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	kgene.kim@samsung.com, s.nawrocki@samsung.com,
	Sungchun Kang <sungchun.kang@samsung.com>
Message-id: <1298558034-10768-2-git-send-email-s.nawrocki@samsung.com>
References: <1298558034-10768-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

In some cases fimc H/W did not stop although there were no output
buffers available. So the capture deactivation interrupt routine
is modified and the state of ST_CAPT_RUN is cleared only
in the LAST-IRQ call.

After LAST-IRQ is generated, H/W pointer will be skipped by 1 frame.
(reference by user manual) So, S/W pointer should be increased too.

Reviewed-by Jonghun Han <jonghun.han@samsung.com>
Signed-off-by: Sungchun Kang <sungchun.kang@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |   65 +++++++++------------------
 drivers/media/video/s5p-fimc/fimc-core.c    |   22 ++++++---
 2 files changed, 36 insertions(+), 51 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 5159cc8..10d6426 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -153,40 +153,6 @@ static int fimc_isp_subdev_init(struct fimc_dev *fimc, unsigned int index)
 	return ret;
 }
 
-/*
- * At least one buffer on the pending_buf_q queue is required.
- * Locking: The caller holds fimc->slock spinlock.
- */
-int fimc_vid_cap_buf_queue(struct fimc_dev *fimc,
-			   struct fimc_vid_buffer *fimc_vb)
-{
-	struct fimc_vid_cap *cap = &fimc->vid_cap;
-	struct fimc_ctx *ctx = cap->ctx;
-	int ret = 0;
-
-	BUG_ON(!fimc || !fimc_vb);
-
-	ret = fimc_prepare_addr(ctx, &fimc_vb->vb, &ctx->d_frame,
-				&fimc_vb->paddr);
-	if (ret)
-		return ret;
-
-	if (test_bit(ST_CAPT_STREAM, &fimc->state)) {
-		fimc_pending_queue_add(cap, fimc_vb);
-	} else {
-		/* Setup the buffer directly for processing. */
-		int buf_id = (cap->reqbufs_count == 1) ? -1 : cap->buf_index;
-		fimc_hw_set_output_addr(fimc, &fimc_vb->paddr, buf_id);
-
-		fimc_vb->index = cap->buf_index;
-		active_queue_add(cap, fimc_vb);
-
-		if (++cap->buf_index >= FIMC_MAX_OUT_BUFS)
-			cap->buf_index = 0;
-	}
-	return ret;
-}
-
 static int fimc_stop_capture(struct fimc_dev *fimc)
 {
 	unsigned long flags;
@@ -239,6 +205,8 @@ static int start_streaming(struct vb2_queue *q)
 	struct s5p_fimc_isp_info *isp_info;
 	int ret;
 
+	fimc_hw_reset(fimc);
+
 	ret = v4l2_subdev_call(fimc->vid_cap.sd, video, s_stream, 1);
 	if (ret && ret != -ENOIOCTLCMD)
 		return ret;
@@ -273,7 +241,7 @@ static int start_streaming(struct vb2_queue *q)
 	INIT_LIST_HEAD(&fimc->vid_cap.active_buf_q);
 	fimc->vid_cap.active_buf_cnt = 0;
 	fimc->vid_cap.frame_count = 0;
-	fimc->vid_cap.buf_index = fimc_hw_get_frame_index(fimc);
+	fimc->vid_cap.buf_index = 0;
 
 	set_bit(ST_CAPT_PEND, &fimc->state);
 
@@ -374,17 +342,28 @@ static void buffer_queue(struct vb2_buffer *vb)
 	unsigned long flags;
 
 	spin_lock_irqsave(&fimc->slock, flags);
-	fimc_vid_cap_buf_queue(fimc, buf);
+	fimc_prepare_addr(ctx, &buf->vb, &ctx->d_frame, &buf->paddr);
 
-	dbg("active_buf_cnt: %d", fimc->vid_cap.active_buf_cnt);
 
-	if (vid_cap->active_buf_cnt >= vid_cap->reqbufs_count ||
-	   vid_cap->active_buf_cnt >= FIMC_MAX_OUT_BUFS) {
-		if (!test_and_set_bit(ST_CAPT_STREAM, &fimc->state)) {
-			fimc_activate_capture(ctx);
-			dbg("");
-		}
+	if (!test_bit(ST_CAPT_STREAM, &fimc->state)
+	     && vid_cap->active_buf_cnt < FIMC_MAX_OUT_BUFS) {
+		/* Setup the buffer directly for processing. */
+		int buf_id = (vid_cap->reqbufs_count == 1) ? -1 :
+				vid_cap->buf_index;
+
+		fimc_hw_set_output_addr(fimc, &buf->paddr, buf_id);
+		buf->index = vid_cap->buf_index;
+		active_queue_add(vid_cap, buf);
+
+		if (++vid_cap->buf_index >= FIMC_MAX_OUT_BUFS)
+			vid_cap->buf_index = 0;
+	} else {
+		fimc_pending_queue_add(vid_cap, buf);
 	}
+
+	if (!test_and_set_bit(ST_CAPT_STREAM, &fimc->state))
+		fimc_activate_capture(ctx);
+
 	spin_unlock_irqrestore(&fimc->slock, flags);
 }
 
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index cd8a300..461f1f2 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -327,7 +327,7 @@ static int stop_streaming(struct vb2_queue *q)
 static void fimc_capture_handler(struct fimc_dev *fimc)
 {
 	struct fimc_vid_cap *cap = &fimc->vid_cap;
-	struct fimc_vid_buffer *v_buf = NULL;
+	struct fimc_vid_buffer *v_buf;
 
 	if (!list_empty(&cap->active_buf_q)) {
 		v_buf = active_queue_pop(cap);
@@ -356,19 +356,23 @@ static void fimc_capture_handler(struct fimc_dev *fimc)
 
 		if (++cap->buf_index >= FIMC_MAX_OUT_BUFS)
 			cap->buf_index = 0;
+	}
 
-	} else if (test_and_clear_bit(ST_CAPT_STREAM, &fimc->state) &&
-		   cap->active_buf_cnt <= 1) {
-		fimc_deactivate_capture(fimc);
+	if (cap->active_buf_cnt == 0) {
+		clear_bit(ST_CAPT_RUN, &fimc->state);
+
+		if (++cap->buf_index >= FIMC_MAX_OUT_BUFS)
+			cap->buf_index = 0;
 	}
 
-	dbg("frame: %d, active_buf_cnt= %d",
+	dbg("frame: %d, active_buf_cnt: %d",
 	    fimc_hw_get_frame_index(fimc), cap->active_buf_cnt);
 }
 
 static irqreturn_t fimc_isr(int irq, void *priv)
 {
 	struct fimc_dev *fimc = priv;
+	struct fimc_vid_cap *cap = &fimc->vid_cap;
 
 	BUG_ON(!fimc);
 	fimc_hw_clear_irq(fimc);
@@ -398,10 +402,12 @@ static irqreturn_t fimc_isr(int irq, void *priv)
 
 	if (test_bit(ST_CAPT_RUN, &fimc->state))
 		fimc_capture_handler(fimc);
-
-	if (test_and_clear_bit(ST_CAPT_PEND, &fimc->state)) {
+	else if (test_bit(ST_CAPT_PEND, &fimc->state))
 		set_bit(ST_CAPT_RUN, &fimc->state);
-		wake_up(&fimc->irq_queue);
+
+	if (cap->active_buf_cnt == 1) {
+		fimc_deactivate_capture(fimc);
+		clear_bit(ST_CAPT_STREAM, &fimc->state);
 	}
 
 isr_unlock:
-- 
1.7.4.1
