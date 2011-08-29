Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:64154 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460Ab1H2L6I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Aug 2011 07:58:08 -0400
Received: from euspt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LQO00EB5UKUUS@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 29 Aug 2011 12:58:06 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LQO005Z6UKTTA@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 29 Aug 2011 12:58:05 +0100 (BST)
Date: Mon, 29 Aug 2011 13:58:02 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH v3 RESEND] media: vb2: change queue initialization order
In-reply-to: <1314618332-13262-1-git-send-email-m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Jonathan Corbet <corbet@lwn.net>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?=
	<u.kleine-koenig@pengutronix.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Marin Mitov <mitov@issp.bas.bg>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Josh Wu <josh.wu@atmel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Paul Mundt <lethal@linux-sh.org>
Message-id: <1314619082-17911-1-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1314618332-13262-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch changes the order of operations during stream on call. Now the
buffers are first queued to the driver and then the start_streaming method
is called.

This resolves the most common case when the driver needs to know buffer
addresses to enable dma engine and start streaming. Additional parameter
to start_streaming method have been added to simplify drivers code. The
driver are now obliged to check if the number of queued buffers is high
enough to enable hardware streaming. If not - it can return an error. In
such case all the buffers that have been pre-queued are invalidated.

This patch also updates all videobuf2 clients to work properly with the
changed order of operations.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
CC: Pawel Osciak <pawel@osciak.com>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Hans Verkuil <hverkuil@xs4all.nl>
CC: Tomasz Stanislawski <t.stanislaws@samsung.com>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: Kamil Debski <k.debski@samsung.com>
CC: Jonathan Corbet <corbet@lwn.net>
CC: Josh Wu <josh.wu@atmel.com>
CC: Hans de Goede <hdegoede@redhat.com>
CC: Paul Mundt <lethal@linux-sh.org>
---

Hello,

This is yet another version of the patch that introduces significant
changes in the vb2 streamon operation. I've decided to remove the
additional parameter to buf_queue callback and added a few cleanups here
and there. This patch also includes an update for all vb2 clients.
Please check if my change didn't break anything.

(I'm sorry for spamming, but previous version had wrong code for
atmel-isi driver).

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center



 drivers/media/video/atmel-isi.c              |   20 ++++--
 drivers/media/video/marvell-ccic/mcam-core.c |    6 +-
 drivers/media/video/pwc/pwc-if.c             |    2 +-
 drivers/media/video/s5p-fimc/fimc-capture.c  |   65 +++++++++++-------
 drivers/media/video/s5p-mfc/s5p_mfc_dec.c    |    2 +-
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    |    2 +-
 drivers/media/video/s5p-tv/mixer.h           |    2 -
 drivers/media/video/s5p-tv/mixer_video.c     |   22 +++---
 drivers/media/video/videobuf2-core.c         |   97 ++++++++++++--------------
 drivers/media/video/vivi.c                   |    2 +-
 include/media/videobuf2-core.h               |   17 ++++-
 11 files changed, 131 insertions(+), 106 deletions(-)

diff --git a/drivers/media/video/atmel-isi.c b/drivers/media/video/atmel-isi.c
index 7e1d789..774715d 100644
--- a/drivers/media/video/atmel-isi.c
+++ b/drivers/media/video/atmel-isi.c
@@ -404,12 +404,13 @@ static void buffer_queue(struct vb2_buffer *vb)
 
 	if (isi->active == NULL) {
 		isi->active = buf;
-		start_dma(isi, buf);
+		if (vb2_is_streaming(vb->vb2_queue))
+			start_dma(isi, buf);
 	}
 	spin_unlock_irqrestore(&isi->lock, flags);
 }
 
-static int start_streaming(struct vb2_queue *vq)
+static int start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
@@ -431,17 +432,26 @@ static int start_streaming(struct vb2_queue *vq)
 	ret = wait_event_interruptible(isi->vsync_wq,
 				       isi->state != ISI_STATE_IDLE);
 	if (ret)
-		return ret;
+		goto err;
 
-	if (isi->state != ISI_STATE_READY)
-		return -EIO;
+	if (isi->state != ISI_STATE_READY) {
+		ret = -EIO;
+		goto err;
+	}
 
 	spin_lock_irq(&isi->lock);
 	isi->state = ISI_STATE_WAIT_SOF;
 	isi_writel(isi, ISI_INTDIS, ISI_SR_VSYNC);
+	if (count)
+		start_dma(isi, isi->active);
 	spin_unlock_irq(&isi->lock);
 
 	return 0;
+err:
+	isi->active = NULL;
+	isi->sequence = 0;
+	INIT_LIST_HEAD(&isi->video_buffer_list);
+	return ret;
 }
 
 /* abort streaming and wait for last buffer */
diff --git a/drivers/media/video/marvell-ccic/mcam-core.c b/drivers/media/video/marvell-ccic/mcam-core.c
index 7abe503..1141b97 100644
--- a/drivers/media/video/marvell-ccic/mcam-core.c
+++ b/drivers/media/video/marvell-ccic/mcam-core.c
@@ -940,12 +940,14 @@ static void mcam_vb_wait_finish(struct vb2_queue *vq)
 /*
  * These need to be called with the mutex held from vb2
  */
-static int mcam_vb_start_streaming(struct vb2_queue *vq)
+static int mcam_vb_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct mcam_camera *cam = vb2_get_drv_priv(vq);
 
-	if (cam->state != S_IDLE)
+	if (cam->state != S_IDLE) {
+		INIT_LIST_HEAD(&cam->buffers);
 		return -EINVAL;
+	}
 	cam->sequence = 0;
 	/*
 	 * Videobuf2 sneakily hoards all the buffers and won't
diff --git a/drivers/media/video/pwc/pwc-if.c b/drivers/media/video/pwc/pwc-if.c
index a7e4f56..360be22 100644
--- a/drivers/media/video/pwc/pwc-if.c
+++ b/drivers/media/video/pwc/pwc-if.c
@@ -816,7 +816,7 @@ static void buffer_queue(struct vb2_buffer *vb)
 	spin_unlock_irqrestore(&pdev->queued_bufs_lock, flags);
 }
 
-static int start_streaming(struct vb2_queue *vq)
+static int start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct pwc_device *pdev = vb2_get_drv_priv(vq);
 
diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index e6afe5f..287d099 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -151,27 +151,11 @@ static int fimc_isp_subdev_init(struct fimc_dev *fimc, unsigned int index)
 	return ret;
 }
 
-static int fimc_stop_capture(struct fimc_dev *fimc)
+static void fimc_capture_state_cleanup(struct fimc_dev *fimc)
 {
-	unsigned long flags;
-	struct fimc_vid_cap *cap;
+	struct fimc_vid_cap *cap = &fimc->vid_cap;
 	struct fimc_vid_buffer *buf;
-
-	cap = &fimc->vid_cap;
-
-	if (!fimc_capture_active(fimc))
-		return 0;
-
-	spin_lock_irqsave(&fimc->slock, flags);
-	set_bit(ST_CAPT_SHUT, &fimc->state);
-	fimc_deactivate_capture(fimc);
-	spin_unlock_irqrestore(&fimc->slock, flags);
-
-	wait_event_timeout(fimc->irq_queue,
-			   !test_bit(ST_CAPT_SHUT, &fimc->state),
-			   FIMC_SHUTDOWN_TIMEOUT);
-
-	v4l2_subdev_call(cap->sd, video, s_stream, 0);
+	unsigned long flags;
 
 	spin_lock_irqsave(&fimc->slock, flags);
 	fimc->state &= ~(1 << ST_CAPT_RUN | 1 << ST_CAPT_PEND |
@@ -191,27 +175,50 @@ static int fimc_stop_capture(struct fimc_dev *fimc)
 	}
 
 	spin_unlock_irqrestore(&fimc->slock, flags);
+}
+
+static int fimc_stop_capture(struct fimc_dev *fimc)
+{
+	struct fimc_vid_cap *cap = &fimc->vid_cap;
+	unsigned long flags;
+
+	if (!fimc_capture_active(fimc))
+		return 0;
+
+	spin_lock_irqsave(&fimc->slock, flags);
+	set_bit(ST_CAPT_SHUT, &fimc->state);
+	fimc_deactivate_capture(fimc);
+	spin_unlock_irqrestore(&fimc->slock, flags);
+
+	wait_event_timeout(fimc->irq_queue,
+			   !test_bit(ST_CAPT_SHUT, &fimc->state),
+			   FIMC_SHUTDOWN_TIMEOUT);
 
+	v4l2_subdev_call(cap->sd, video, s_stream, 0);
+
+	fimc_capture_state_cleanup(fimc);
 	dbg("state: 0x%lx", fimc->state);
 	return 0;
 }
 
-static int start_streaming(struct vb2_queue *q)
+
+static int start_streaming(struct vb2_queue *q, unsigned int count)
 {
 	struct fimc_ctx *ctx = q->drv_priv;
 	struct fimc_dev *fimc = ctx->fimc_dev;
 	struct s5p_fimc_isp_info *isp_info;
+	int min_bufs;
 	int ret;
 
 	fimc_hw_reset(fimc);
 
 	ret = v4l2_subdev_call(fimc->vid_cap.sd, video, s_stream, 1);
 	if (ret && ret != -ENOIOCTLCMD)
-		return ret;
+		goto error;
 
 	ret = fimc_prepare_config(ctx, ctx->state);
 	if (ret)
-		return ret;
+		goto error;
 
 	isp_info = &fimc->pdata->isp_info[fimc->vid_cap.input_index];
 	fimc_hw_set_camera_type(fimc, isp_info);
@@ -222,7 +229,7 @@ static int start_streaming(struct vb2_queue *q)
 		ret = fimc_set_scaler_info(ctx);
 		if (ret) {
 			err("Scaler setup error");
-			return ret;
+			goto error;
 		}
 		fimc_hw_set_input_path(ctx);
 		fimc_hw_set_prescaler(ctx);
@@ -237,13 +244,20 @@ static int start_streaming(struct vb2_queue *q)
 
 	INIT_LIST_HEAD(&fimc->vid_cap.pending_buf_q);
 	INIT_LIST_HEAD(&fimc->vid_cap.active_buf_q);
-	fimc->vid_cap.active_buf_cnt = 0;
 	fimc->vid_cap.frame_count = 0;
 	fimc->vid_cap.buf_index = 0;
 
 	set_bit(ST_CAPT_PEND, &fimc->state);
 
+	min_bufs = fimc->vid_cap.reqbufs_count > 1 ? 2 : 1;
+
+	if (fimc->vid_cap.active_buf_cnt >= min_bufs)
+		fimc_activate_capture(ctx);
+
 	return 0;
+error:
+	fimc_capture_state_cleanup(fimc);
+	return ret;
 }
 
 static int stop_streaming(struct vb2_queue *q)
@@ -341,7 +355,8 @@ static void buffer_queue(struct vb2_buffer *vb)
 
 	min_bufs = vid_cap->reqbufs_count > 1 ? 2 : 1;
 
-	if (vid_cap->active_buf_cnt >= min_bufs &&
+	if (vb2_is_streaming(&vid_cap->vbq) &&
+	    vid_cap->active_buf_cnt >= min_bufs &&
 	    !test_and_set_bit(ST_CAPT_STREAM, &fimc->state))
 		fimc_activate_capture(ctx);
 
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
index 4540dc2..32f8989 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
@@ -864,7 +864,7 @@ static int s5p_mfc_buf_init(struct vb2_buffer *vb)
 	return 0;
 }
 
-static int s5p_mfc_start_streaming(struct vb2_queue *q)
+static int s5p_mfc_start_streaming(struct vb2_queue *q, unsigned int count)
 {
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(q->drv_priv);
 	struct s5p_mfc_dev *dev = ctx->dev;
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
index e11b19a..14ddbd2 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
@@ -1640,7 +1640,7 @@ static int s5p_mfc_buf_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static int s5p_mfc_start_streaming(struct vb2_queue *q)
+static int s5p_mfc_start_streaming(struct vb2_queue *q, unsigned int count)
 {
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(q->drv_priv);
 	struct s5p_mfc_dev *dev = ctx->dev;
diff --git a/drivers/media/video/s5p-tv/mixer.h b/drivers/media/video/s5p-tv/mixer.h
index e224224..51ad59b 100644
--- a/drivers/media/video/s5p-tv/mixer.h
+++ b/drivers/media/video/s5p-tv/mixer.h
@@ -111,8 +111,6 @@ struct mxr_buffer {
 enum mxr_layer_state {
 	/** layers is not shown */
 	MXR_LAYER_IDLE = 0,
-	/** state between STREAMON and hardware start */
-	MXR_LAYER_STREAMING_START,
 	/** layer is shown */
 	MXR_LAYER_STREAMING,
 	/** state before STREAMOFF is finished */
diff --git a/drivers/media/video/s5p-tv/mixer_video.c b/drivers/media/video/s5p-tv/mixer_video.c
index 8bea0f3..4917e2c 100644
--- a/drivers/media/video/s5p-tv/mixer_video.c
+++ b/drivers/media/video/s5p-tv/mixer_video.c
@@ -764,19 +764,10 @@ static void buf_queue(struct vb2_buffer *vb)
 	struct mxr_layer *layer = vb2_get_drv_priv(vb->vb2_queue);
 	struct mxr_device *mdev = layer->mdev;
 	unsigned long flags;
-	int must_start = 0;
 
 	spin_lock_irqsave(&layer->enq_slock, flags);
-	if (layer->state == MXR_LAYER_STREAMING_START) {
-		layer->state = MXR_LAYER_STREAMING;
-		must_start = 1;
-	}
 	list_add_tail(&buffer->list, &layer->enq_list);
 	spin_unlock_irqrestore(&layer->enq_slock, flags);
-	if (must_start) {
-		layer->ops.stream_set(layer, MXR_ENABLE);
-		mxr_streamer_get(mdev);
-	}
 
 	mxr_dbg(mdev, "queuing buffer\n");
 }
@@ -797,13 +788,19 @@ static void wait_unlock(struct vb2_queue *vq)
 	mutex_unlock(&layer->mutex);
 }
 
-static int start_streaming(struct vb2_queue *vq)
+static int start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct mxr_layer *layer = vb2_get_drv_priv(vq);
 	struct mxr_device *mdev = layer->mdev;
 	unsigned long flags;
 
 	mxr_dbg(mdev, "%s\n", __func__);
+
+	if (count == 0) {
+		mxr_dbg(mdev, "no output buffers queued\n");
+		return -EINVAL;
+	}
+
 	/* block any changes in output configuration */
 	mxr_output_get(mdev);
 
@@ -814,9 +811,12 @@ static int start_streaming(struct vb2_queue *vq)
 	layer->ops.format_set(layer);
 	/* enabling layer in hardware */
 	spin_lock_irqsave(&layer->enq_slock, flags);
-	layer->state = MXR_LAYER_STREAMING_START;
+	layer->state = MXR_LAYER_STREAMING;
 	spin_unlock_irqrestore(&layer->enq_slock, flags);
 
+	layer->ops.stream_set(layer, MXR_ENABLE);
+	mxr_streamer_get(mdev);
+
 	return 0;
 }
 
diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index e89fd53..6687ac3 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -1111,6 +1111,43 @@ int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
 EXPORT_SYMBOL_GPL(vb2_dqbuf);
 
 /**
+ * __vb2_queue_cancel() - cancel and stop (pause) streaming
+ *
+ * Removes all queued buffers from driver's queue and all buffers queued by
+ * userspace from videobuf's queue. Returns to state after reqbufs.
+ */
+static void __vb2_queue_cancel(struct vb2_queue *q)
+{
+	unsigned int i;
+
+	/*
+	 * Tell driver to stop all transactions and release all queued
+	 * buffers.
+	 */
+	if (q->streaming)
+		call_qop(q, stop_streaming, q);
+	q->streaming = 0;
+
+	/*
+	 * Remove all buffers from videobuf's list...
+	 */
+	INIT_LIST_HEAD(&q->queued_list);
+	/*
+	 * ...and done list; userspace will not receive any buffers it
+	 * has not already dequeued before initiating cancel.
+	 */
+	INIT_LIST_HEAD(&q->done_list);
+	atomic_set(&q->queued_count, 0);
+	wake_up_all(&q->done_wq);
+
+	/*
+	 * Reinitialize all buffers for next use.
+	 */
+	for (i = 0; i < q->num_buffers; ++i)
+		q->bufs[i]->state = VB2_BUF_STATE_DEQUEUED;
+}
+
+/**
  * vb2_streamon - start streaming
  * @q:		videobuf2 queue
  * @type:	type argument passed from userspace to vidioc_streamon handler
@@ -1118,7 +1155,7 @@ EXPORT_SYMBOL_GPL(vb2_dqbuf);
  * Should be called from vidioc_streamon handler of a driver.
  * This function:
  * 1) verifies current state
- * 2) starts streaming and passes any previously queued buffers to the driver
+ * 2) passes any previously queued buffers to the driver and starts streaming
  *
  * The return values from this function are intended to be directly returned
  * from vidioc_streamon handler in the driver.
@@ -1144,75 +1181,29 @@ int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
 	}
 
 	/*
-	 * Cannot start streaming on an OUTPUT device if no buffers have
-	 * been queued yet.
+	 * If any buffers were queued before streamon,
+	 * we can now pass them to driver for processing.
 	 */
-	if (V4L2_TYPE_IS_OUTPUT(q->type)) {
-		if (list_empty(&q->queued_list)) {
-			dprintk(1, "streamon: no output buffers queued\n");
-			return -EINVAL;
-		}
-	}
+	list_for_each_entry(vb, &q->queued_list, queued_entry)
+		__enqueue_in_driver(vb);
 
 	/*
 	 * Let driver notice that streaming state has been enabled.
 	 */
-	ret = call_qop(q, start_streaming, q);
+	ret = call_qop(q, start_streaming, q, atomic_read(&q->queued_count));
 	if (ret) {
 		dprintk(1, "streamon: driver refused to start streaming\n");
+		__vb2_queue_cancel(q);
 		return ret;
 	}
 
 	q->streaming = 1;
 
-	/*
-	 * If any buffers were queued before streamon,
-	 * we can now pass them to driver for processing.
-	 */
-	list_for_each_entry(vb, &q->queued_list, queued_entry)
-		__enqueue_in_driver(vb);
-
 	dprintk(3, "Streamon successful\n");
 	return 0;
 }
 EXPORT_SYMBOL_GPL(vb2_streamon);
 
-/**
- * __vb2_queue_cancel() - cancel and stop (pause) streaming
- *
- * Removes all queued buffers from driver's queue and all buffers queued by
- * userspace from videobuf's queue. Returns to state after reqbufs.
- */
-static void __vb2_queue_cancel(struct vb2_queue *q)
-{
-	unsigned int i;
-
-	/*
-	 * Tell driver to stop all transactions and release all queued
-	 * buffers.
-	 */
-	if (q->streaming)
-		call_qop(q, stop_streaming, q);
-	q->streaming = 0;
-
-	/*
-	 * Remove all buffers from videobuf's list...
-	 */
-	INIT_LIST_HEAD(&q->queued_list);
-	/*
-	 * ...and done list; userspace will not receive any buffers it
-	 * has not already dequeued before initiating cancel.
-	 */
-	INIT_LIST_HEAD(&q->done_list);
-	atomic_set(&q->queued_count, 0);
-	wake_up_all(&q->done_wq);
-
-	/*
-	 * Reinitialize all buffers for next use.
-	 */
-	for (i = 0; i < q->num_buffers; ++i)
-		q->bufs[i]->state = VB2_BUF_STATE_DEQUEUED;
-}
 
 /**
  * vb2_streamoff - stop streaming
diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index 26eda47..88459a9 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -766,7 +766,7 @@ static void buffer_queue(struct vb2_buffer *vb)
 	spin_unlock_irqrestore(&dev->slock, flags);
 }
 
-static int start_streaming(struct vb2_queue *vq)
+static int start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct vivi_dev *dev = vb2_get_drv_priv(vq);
 	dprintk(dev, 1, "%s\n", __func__);
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 5287e90..f987b40 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -196,15 +196,24 @@ struct vb2_buffer {
  *			before userspace accesses the buffer; optional
  * @buf_cleanup:	called once before the buffer is freed; drivers may
  *			perform any additional cleanup; optional
- * @start_streaming:	called once before entering 'streaming' state; enables
- *			driver to receive buffers over buf_queue() callback
+ * @start_streaming:	called once to enter 'streaming' state; the driver may
+ *			receive buffers with @buf_queue callback before
+ *			@start_streaming is called; the driver gets the number
+ *			of already queued buffers in count parameter; driver
+ *			can return an error if hardware fails or not enough
+ *			buffers has been queued, in such case all buffers that
+ *			have been already given by the @buf_queue callback are
+ *			invalidated.
  * @stop_streaming:	called when 'streaming' state must be disabled; driver
  *			should stop any DMA transactions or wait until they
  *			finish and give back all buffers it got from buf_queue()
  *			callback; may use vb2_wait_for_all_buffers() function
  * @buf_queue:		passes buffer vb to the driver; driver may start
  *			hardware operation on this buffer; driver should give
- *			the buffer back by calling vb2_buffer_done() function
+ *			the buffer back by calling vb2_buffer_done() function;
+ *			it is allways called after calling STREAMON ioctl;
+ *			might be called before start_streaming callback if user
+ *			pre-queued buffers before calling STREAMON
  */
 struct vb2_ops {
 	int (*queue_setup)(struct vb2_queue *q, unsigned int *num_buffers,
@@ -219,7 +228,7 @@ struct vb2_ops {
 	int (*buf_finish)(struct vb2_buffer *vb);
 	void (*buf_cleanup)(struct vb2_buffer *vb);
 
-	int (*start_streaming)(struct vb2_queue *q);
+	int (*start_streaming)(struct vb2_queue *q, unsigned int count);
 	int (*stop_streaming)(struct vb2_queue *q);
 
 	void (*buf_queue)(struct vb2_buffer *vb);
-- 
1.7.1.569.g6f426

