Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:49565 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757248Ab1CIQXm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Mar 2011 11:23:42 -0500
Date: Wed, 09 Mar 2011 17:23:24 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 1/7] s5p-fimc: fix ISR and buffer handling for fimc-capture
In-reply-to: <1298558034-10768-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, Sungchun Kang <sungchun.kang@samsung.com>
Message-id: <1299687805-23525-2-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1298558034-10768-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Sungchun Kang <sungchun.kang@samsung.com>

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
 drivers/media/video/s5p-fimc/fimc-capture.c |   70 ++++++++++-----------------
 drivers/media/video/s5p-fimc/fimc-core.c    |   33 +++++++-----
 2 files changed, 45 insertions(+), 58 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 5159cc8..6b6f72e 100644
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
@@ -211,7 +177,7 @@ static int fimc_stop_capture(struct fimc_dev *fimc)
 
 	spin_lock_irqsave(&fimc->slock, flags);
 	fimc->state &= ~(1 << ST_CAPT_RUN | 1 << ST_CAPT_PEND |
-			1 << ST_CAPT_STREAM);
+			 1 << ST_CAPT_SHUT | 1 << ST_CAPT_STREAM);
 
 	fimc->vid_cap.active_buf_cnt = 0;
 
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
 
@@ -372,19 +340,33 @@ static void buffer_queue(struct vb2_buffer *vb)
 		= container_of(vb, struct fimc_vid_buffer, vb);
 	struct fimc_vid_cap *vid_cap = &fimc->vid_cap;
 	unsigned long flags;
+	int min_bufs;
 
 	spin_lock_irqsave(&fimc->slock, flags);
-	fimc_vid_cap_buf_queue(fimc, buf);
+	fimc_prepare_addr(ctx, &buf->vb, &ctx->d_frame, &buf->paddr);
+
+	if (!test_bit(ST_CAPT_STREAM, &fimc->state)
+	     && vid_cap->active_buf_cnt < FIMC_MAX_OUT_BUFS) {
+		/* Setup the buffer directly for processing. */
+		int buf_id = (vid_cap->reqbufs_count == 1) ? -1 :
+				vid_cap->buf_index;
 
-	dbg("active_buf_cnt: %d", fimc->vid_cap.active_buf_cnt);
+		fimc_hw_set_output_addr(fimc, &buf->paddr, buf_id);
+		buf->index = vid_cap->buf_index;
+		active_queue_add(vid_cap, buf);
 
-	if (vid_cap->active_buf_cnt >= vid_cap->reqbufs_count ||
-	   vid_cap->active_buf_cnt >= FIMC_MAX_OUT_BUFS) {
-		if (!test_and_set_bit(ST_CAPT_STREAM, &fimc->state)) {
-			fimc_activate_capture(ctx);
-			dbg("");
-		}
+		if (++vid_cap->buf_index >= FIMC_MAX_OUT_BUFS)
+			vid_cap->buf_index = 0;
+	} else {
+		fimc_pending_queue_add(vid_cap, buf);
 	}
+
+	min_bufs = vid_cap->reqbufs_count > 1 ? 2 : 1;
+
+	if (vid_cap->active_buf_cnt >= min_bufs &&
+	    !test_and_set_bit(ST_CAPT_STREAM, &fimc->state))
+		fimc_activate_capture(ctx);
+
 	spin_unlock_irqrestore(&fimc->slock, flags);
 }
 
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index cd8a300..fdf4270 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -327,9 +327,10 @@ static int stop_streaming(struct vb2_queue *q)
 static void fimc_capture_handler(struct fimc_dev *fimc)
 {
 	struct fimc_vid_cap *cap = &fimc->vid_cap;
-	struct fimc_vid_buffer *v_buf = NULL;
+	struct fimc_vid_buffer *v_buf;
 
-	if (!list_empty(&cap->active_buf_q)) {
+	if (!list_empty(&cap->active_buf_q) &&
+	    test_bit(ST_CAPT_RUN, &fimc->state)) {
 		v_buf = active_queue_pop(cap);
 		vb2_buffer_done(&v_buf->vb, VB2_BUF_STATE_DONE);
 	}
@@ -345,9 +346,6 @@ static void fimc_capture_handler(struct fimc_dev *fimc)
 		fimc_hw_set_output_addr(fimc, &v_buf->paddr, cap->buf_index);
 		v_buf->index = cap->buf_index;
 
-		dbg("hw ptr: %d, sw ptr: %d",
-		    fimc_hw_get_frame_index(fimc), cap->buf_index);
-
 		/* Move the buffer to the capture active queue */
 		active_queue_add(cap, v_buf);
 
@@ -356,19 +354,25 @@ static void fimc_capture_handler(struct fimc_dev *fimc)
 
 		if (++cap->buf_index >= FIMC_MAX_OUT_BUFS)
 			cap->buf_index = 0;
+	}
+
+	if (cap->active_buf_cnt == 0) {
+		clear_bit(ST_CAPT_RUN, &fimc->state);
 
-	} else if (test_and_clear_bit(ST_CAPT_STREAM, &fimc->state) &&
-		   cap->active_buf_cnt <= 1) {
-		fimc_deactivate_capture(fimc);
+		if (++cap->buf_index >= FIMC_MAX_OUT_BUFS)
+			cap->buf_index = 0;
+	} else {
+		set_bit(ST_CAPT_RUN, &fimc->state);
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
@@ -396,12 +400,13 @@ static irqreturn_t fimc_isr(int irq, void *priv)
 
 	}
 
-	if (test_bit(ST_CAPT_RUN, &fimc->state))
-		fimc_capture_handler(fimc);
+	if (test_bit(ST_CAPT_PEND, &fimc->state)) {
+		fimc_capture_irq_handler(fimc);
 
-	if (test_and_clear_bit(ST_CAPT_PEND, &fimc->state)) {
-		set_bit(ST_CAPT_RUN, &fimc->state);
-		wake_up(&fimc->irq_queue);
+		if (cap->active_buf_cnt == 1) {
+			fimc_deactivate_capture(fimc);
+			clear_bit(ST_CAPT_STREAM, &fimc->state);
+		}
 	}
 
 isr_unlock:
-- 
1.7.4.1
