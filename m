Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:43518 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758510Ab1GDRzr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2011 13:55:47 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Mon, 04 Jul 2011 19:55:10 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v3 19/19] s5p-fimc: Add runtime PM support in the camera
 capture driver
In-reply-to: <1309802110-16682-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, sw0312.kim@samsung.com,
	riverful.kim@samsung.com
Message-id: <1309802110-16682-20-git-send-email-s.nawrocki@samsung.com>
References: <1309802110-16682-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add support for whole pipeline suspend/resume. Sensors must support
suspend/resume through s_power subdev operation.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |   77 ++++++++++++++++++++-------
 drivers/media/video/s5p-fimc/fimc-core.c    |   10 ++--
 drivers/media/video/s5p-fimc/fimc-core.h    |    1 +
 3 files changed, 64 insertions(+), 24 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 3b64788..33776ff 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -73,7 +73,7 @@ static int fimc_start_capture(struct fimc_dev *fimc)
 	return ret;
 }
 
-static int fimc_stop_capture(struct fimc_dev *fimc)
+static int fimc_stop_capture(struct fimc_dev *fimc, bool suspend)
 {
 	struct fimc_vid_cap *cap = &fimc->vid_cap;
 	struct fimc_vid_buffer *buf;
@@ -89,26 +89,28 @@ static int fimc_stop_capture(struct fimc_dev *fimc)
 
 	wait_event_timeout(fimc->irq_queue,
 			   !test_bit(ST_CAPT_SHUT, &fimc->state),
-			   FIMC_SHUTDOWN_TIMEOUT);
+			   (2*HZ/10)); /* 200 ms */
 
 	spin_lock_irqsave(&fimc->slock, flags);
-	fimc->state &= ~(1 << ST_CAPT_RUN | 1 << ST_CAPT_PEND |
-			 1 << ST_CAPT_SHUT | 1 << ST_CAPT_STREAM |
-			 1 << ST_CAPT_ISP_STREAM);
+	fimc->state &= ~(1 << ST_CAPT_RUN | 1 << ST_CAPT_SHUT |
+			 1 << ST_CAPT_STREAM | 1 << ST_CAPT_ISP_STREAM);
+	if (!suspend)
+		fimc->state &= ~(1 << ST_CAPT_PEND | 1 << ST_CAPT_SUSPENDED);
 
-	fimc->vid_cap.active_buf_cnt = 0;
-
-	/* Release buffers that were enqueued in the driver by videobuf2. */
-	while (!list_empty(&cap->pending_buf_q)) {
+	/* Release unused buffers */
+	while (!suspend && !list_empty(&cap->pending_buf_q)) {
 		buf = fimc_pending_queue_pop(cap);
 		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
 	}
-
+	/* If suspending put unused buffers onto pending queue */
 	while (!list_empty(&cap->active_buf_q)) {
 		buf = fimc_active_queue_pop(cap);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		if (suspend)
+			fimc_pending_queue_add(cap, buf);
+		else
+			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
 	}
-
+	set_bit(ST_CAPT_SUSPENDED, &fimc->state);
 	spin_unlock_irqrestore(&fimc->slock, flags);
 	dbg("state: 0x%lx", fimc->state);
 
@@ -117,11 +119,39 @@ static int fimc_stop_capture(struct fimc_dev *fimc)
 
 int fimc_capture_suspend(struct fimc_dev *fimc)
 {
-	return -EBUSY;
+	bool suspend = fimc_capture_in_use(fimc);
+
+	int ret = fimc_stop_capture(fimc, suspend);
+	if (ret)
+		return ret;
+	return fimc_pipeline_shutdown(fimc);
 }
 
+static void buffer_queue(struct vb2_buffer *vb);
+
 int fimc_capture_resume(struct fimc_dev *fimc)
 {
+	struct fimc_vid_cap *vid_cap = &fimc->vid_cap;
+	struct fimc_vid_buffer *buf;
+	int i;
+
+	if (!test_and_clear_bit(ST_CAPT_SUSPENDED, &fimc->state))
+		return 0;
+
+	INIT_LIST_HEAD(&fimc->vid_cap.active_buf_q);
+	vid_cap->buf_index = 0;
+	fimc_pipeline_initialize(fimc, &fimc->vid_cap.vfd->entity,
+				 false);
+	fimc_start_capture(fimc);
+
+	clear_bit(ST_CAPT_SUSPENDED, &fimc->state);
+
+	for (i = 0; i < vid_cap->reqbufs_count; i++) {
+		if (list_empty(&vid_cap->pending_buf_q))
+			break;
+		buf = fimc_pending_queue_pop(vid_cap);
+		buffer_queue(&buf->vb);
+	}
 	return 0;
 }
 
@@ -181,7 +211,7 @@ static int stop_streaming(struct vb2_queue *q)
 	if (!fimc_capture_active(fimc))
 		return -EINVAL;
 
-	return fimc_stop_capture(fimc);
+	return fimc_stop_capture(fimc, false);
 }
 
 static unsigned int get_plane_size(struct fimc_frame *fr, unsigned int plane)
@@ -248,8 +278,9 @@ static void buffer_queue(struct vb2_buffer *vb)
 	spin_lock_irqsave(&fimc->slock, flags);
 	fimc_prepare_addr(ctx, &buf->vb, &ctx->d_frame, &buf->paddr);
 
-	if (!test_bit(ST_CAPT_STREAM, &fimc->state)
-	     && vid_cap->active_buf_cnt < FIMC_MAX_OUT_BUFS) {
+	if (!test_bit(ST_CAPT_SUSPENDED, &fimc->state) &&
+	    !test_bit(ST_CAPT_STREAM, &fimc->state) &&
+	    vid_cap->active_buf_cnt < FIMC_MAX_OUT_BUFS) {
 		/* Setup the buffer directly for processing. */
 		int buf_id = (vid_cap->reqbufs_count == 1) ? -1 :
 				vid_cap->buf_index;
@@ -337,6 +368,7 @@ static int fimc_capture_open(struct file *file)
 	if (fimc_m2m_active(fimc))
 		return -EBUSY;
 
+	set_bit(ST_CAPT_INUSE, &fimc->state);
 	pm_runtime_get_sync(&fimc->pdev->dev);
 
 	if (++fimc->vid_cap.refcnt == 1) {
@@ -348,6 +380,7 @@ static int fimc_capture_open(struct file *file)
 			pm_runtime_put_sync(&fimc->pdev->dev);
 			fimc->vid_cap.refcnt--;
 			v4l2_fh_release(file);
+			clear_bit(ST_CAPT_INUSE, &fimc->state);
 			return ret;
 		}
 		ret = fimc_capture_ctrls_create(fimc);
@@ -362,12 +395,18 @@ static int fimc_capture_close(struct file *file)
 	dbg("pid: %d, state: 0x%lx", task_pid_nr(current), fimc->state);
 
 	if (--fimc->vid_cap.refcnt == 0) {
-		fimc_stop_capture(fimc);
+		clear_bit(ST_CAPT_INUSE, &fimc->state);
+		fimc_stop_capture(fimc, false);
 		fimc_pipeline_shutdown(fimc);
-		fimc_ctrls_delete(fimc->vid_cap.ctx);
-		vb2_queue_release(&fimc->vid_cap.vbq);
+		clear_bit(ST_CAPT_SUSPENDED, &fimc->state);
 	}
+
 	pm_runtime_put_sync(&fimc->pdev->dev);
+
+	if (fimc->vid_cap.refcnt == 0) {
+		vb2_queue_release(&fimc->vid_cap.vbq);
+		fimc_ctrls_delete(fimc->vid_cap.ctx);
+	}
 	return v4l2_fh_release(file);
 }
 
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 66d1af5..6044459 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -334,6 +334,11 @@ void fimc_capture_irq_handler(struct fimc_dev *fimc, bool rel_buf)
 	struct timeval *tv;
 	struct timespec ts;
 
+	if (test_and_clear_bit(ST_CAPT_SHUT, &fimc->state)) {
+		wake_up(&fimc->irq_queue);
+		return;
+	}
+
 	if (!list_empty(&cap->active_buf_q) &&
 	    test_bit(ST_CAPT_RUN, &fimc->state) && rel_buf) {
 		ktime_get_real_ts(&ts);
@@ -348,11 +353,6 @@ void fimc_capture_irq_handler(struct fimc_dev *fimc, bool rel_buf)
 		vb2_buffer_done(&v_buf->vb, VB2_BUF_STATE_DONE);
 	}
 
-	if (test_and_clear_bit(ST_CAPT_SHUT, &fimc->state)) {
-		wake_up(&fimc->irq_queue);
-		return;
-	}
-
 	if (!list_empty(&cap->pending_buf_q)) {
 
 		v_buf = fimc_pending_queue_pop(cap);
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index 879d5dd..72c6799 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -63,6 +63,7 @@ enum fimc_dev_flags {
 	ST_CAPT_RUN,
 	ST_CAPT_STREAM,
 	ST_CAPT_ISP_STREAM,
+	ST_CAPT_SUSPENDED,
 	ST_CAPT_SHUT,
 	ST_CAPT_INUSE,
 	ST_CAPT_APPLY_CFG,
-- 
1.7.5.4

