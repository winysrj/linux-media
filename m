Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:37965 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932500Ab1IAPan (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2011 11:30:43 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Thu, 01 Sep 2011 17:30:21 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 17/19 v4] s5p-fimc: Add runtime PM support in the camera
 capture driver
In-reply-to: <1314891023-14227-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: mchehab@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	sw0312.kim@samsung.com, riverful.kim@samsung.com
Message-id: <1314891023-14227-18-git-send-email-s.nawrocki@samsung.com>
References: <1314891023-14227-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for whole pipeline suspend/resume. Sensors must support
suspend/resume through s_power subdev operation.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |   83 +++++++++++++++++++-------
 drivers/media/video/s5p-fimc/fimc-core.c    |   10 ++--
 drivers/media/video/s5p-fimc/fimc-core.h    |    1 +
 3 files changed, 66 insertions(+), 28 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 4693846..9ca9462 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -69,30 +69,32 @@ static int fimc_init_capture(struct fimc_dev *fimc)
 	return ret;
 }
 
-static int fimc_capture_state_cleanup(struct fimc_dev *fimc)
+static int fimc_capture_state_cleanup(struct fimc_dev *fimc, bool suspend)
 {
 	struct fimc_vid_cap *cap = &fimc->vid_cap;
 	struct fimc_vid_buffer *buf;
 	unsigned long flags;
 
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
 
 	if (test_bit(ST_CAPT_ISP_STREAM, &fimc->state))
@@ -101,9 +103,8 @@ static int fimc_capture_state_cleanup(struct fimc_dev *fimc)
 		return 0;
 }
 
-static int fimc_stop_capture(struct fimc_dev *fimc)
+static int fimc_stop_capture(struct fimc_dev *fimc, bool suspend)
 {
-	struct fimc_vid_cap *cap = &fimc->vid_cap;
 	unsigned long flags;
 
 	if (!fimc_capture_active(fimc))
@@ -116,9 +117,9 @@ static int fimc_stop_capture(struct fimc_dev *fimc)
 
 	wait_event_timeout(fimc->irq_queue,
 			   !test_bit(ST_CAPT_SHUT, &fimc->state),
-			   FIMC_SHUTDOWN_TIMEOUT);
+			   (2*HZ/10)); /* 200 ms */
 
-	return fimc_capture_state_cleanup(fimc);
+	return fimc_capture_state_cleanup(fimc, suspend);
 }
 
 /**
@@ -181,7 +182,7 @@ static int start_streaming(struct vb2_queue *q, unsigned int count)
 
 	return 0;
 error:
-	fimc_capture_state_cleanup(fimc);
+	fimc_capture_state_cleanup(fimc, false);
 	return ret;
 }
 
@@ -193,17 +194,46 @@ static int stop_streaming(struct vb2_queue *q)
 	if (!fimc_capture_active(fimc))
 		return -EINVAL;
 
-	return fimc_stop_capture(fimc);
+	return fimc_stop_capture(fimc, false);
 }
 
 int fimc_capture_suspend(struct fimc_dev *fimc)
 {
-	return -EBUSY;
+	bool suspend = fimc_capture_busy(fimc);
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
+	fimc_init_capture(fimc);
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
+
 }
 
 static unsigned int get_plane_size(struct fimc_frame *fr, unsigned int plane)
@@ -271,8 +301,9 @@ static void buffer_queue(struct vb2_buffer *vb)
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
@@ -366,6 +397,7 @@ static int fimc_capture_open(struct file *file)
 	if (fimc_m2m_active(fimc))
 		return -EBUSY;
 
+	set_bit(ST_CAPT_BUSY, &fimc->state);
 	pm_runtime_get_sync(&fimc->pdev->dev);
 
 	if (++fimc->vid_cap.refcnt == 1) {
@@ -377,6 +409,7 @@ static int fimc_capture_open(struct file *file)
 			pm_runtime_put_sync(&fimc->pdev->dev);
 			fimc->vid_cap.refcnt--;
 			v4l2_fh_release(file);
+			clear_bit(ST_CAPT_BUSY, &fimc->state);
 			return ret;
 		}
 		ret = fimc_capture_ctrls_create(fimc);
@@ -394,14 +427,18 @@ static int fimc_capture_close(struct file *file)
 	dbg("pid: %d, state: 0x%lx", task_pid_nr(current), fimc->state);
 
 	if (--fimc->vid_cap.refcnt == 0) {
-		fimc_stop_capture(fimc);
+		clear_bit(ST_CAPT_BUSY, &fimc->state);
+		fimc_stop_capture(fimc, false);
 		fimc_pipeline_shutdown(fimc);
-		fimc_ctrls_delete(fimc->vid_cap.ctx);
-		vb2_queue_release(&fimc->vid_cap.vbq);
+		clear_bit(ST_CAPT_SUSPENDED, &fimc->state);
 	}
 
 	pm_runtime_put(&fimc->pdev->dev);
 
+	if (fimc->vid_cap.refcnt == 0) {
+		vb2_queue_release(&fimc->vid_cap.vbq);
+		fimc_ctrls_delete(fimc->vid_cap.ctx);
+	}
 	return v4l2_fh_release(file);
 }
 
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 4369c4f..a528a76 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -334,6 +334,11 @@ void fimc_capture_irq_handler(struct fimc_dev *fimc, bool final)
 	struct timeval *tv;
 	struct timespec ts;
 
+	if (test_and_clear_bit(ST_CAPT_SHUT, &fimc->state)) {
+		wake_up(&fimc->irq_queue);
+		return;
+	}
+
 	if (!list_empty(&cap->active_buf_q) &&
 	    test_bit(ST_CAPT_RUN, &fimc->state) && final) {
 		ktime_get_real_ts(&ts);
@@ -348,11 +353,6 @@ void fimc_capture_irq_handler(struct fimc_dev *fimc, bool final)
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
index 82ac597..a6936da 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -63,6 +63,7 @@ enum fimc_dev_flags {
 	ST_CAPT_RUN,
 	ST_CAPT_STREAM,
 	ST_CAPT_ISP_STREAM,
+	ST_CAPT_SUSPENDED,
 	ST_CAPT_SHUT,
 	ST_CAPT_BUSY,
 	ST_CAPT_APPLY_CFG,
-- 
1.7.6

