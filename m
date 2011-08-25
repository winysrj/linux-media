Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:47770 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab1HYKwv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Aug 2011 06:52:51 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from spt2.w1.samsung.com ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LQH00DJTCW1JJ50@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 25 Aug 2011 11:52:49 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LQH005KKCVZQM@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 25 Aug 2011 11:52:48 +0100 (BST)
Date: Thu, 25 Aug 2011 12:52:11 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH v2/RFC] media: vb2: change queue initialization order
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
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Message-id: <1314269531-30080-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch changes the order of operations during stream on call. Now the
buffers are first queued to the driver and then the start_streaming method
is called.

This resolves the most common case when the driver needs to know buffer
addresses to enable dma engine and start streaming. Additional parameters
to start_streaming and buffer_queue methods have been added to simplify
drivers code. The driver are now obliged to check if the number of queued
buffers is enough to enable hardware streaming. If not - it should return
an error. In such case all the buffers that have been pre-queued are
invalidated.

Drivers that are able to start/stop streaming on-fly, can control dma
engine directly in buf_queue callback. In this case start_streaming
callback can be considered as optional. The driver can also assume that
after a few first buf_queue calls with zero 'streaming' parameter, the core
will finally call start_streaming callback.

This patch also updates some videobuf2 clients (s5p-fimc, s5p-mfc, s5p-tv,
mem2mem_testdev and vivi) to work properly with the changed order of
operations.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
CC: Pawel Osciak <pawel@osciak.com>
---
 drivers/media/video/mem2mem_testdev.c       |    2 +-
 drivers/media/video/s5p-fimc/fimc-capture.c |   66 ++++++++++++++++-----------
 drivers/media/video/s5p-fimc/fimc-core.c    |    2 +-
 drivers/media/video/s5p-mfc/s5p_mfc_dec.c   |    4 +-
 drivers/media/video/s5p-tv/mixer.h          |    2 -
 drivers/media/video/s5p-tv/mixer_video.c    |   24 +++++-----
 drivers/media/video/videobuf2-core.c        |   30 +++++--------
 drivers/media/video/vivi.c                  |    4 +-
 include/media/videobuf2-core.h              |   18 +++++--
 9 files changed, 82 insertions(+), 70 deletions(-)
---

Hello,

This patch introduces significant changes in the vb2 streamon operation,
so all vb2 clients need to be checked and updated. Right now I only
updated virtual and Samsung drivers. Once we agree that this patch can
be merged, I will update it to include all the required changes for all
videobuf2 clients as well.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center

diff --git a/drivers/media/video/mem2mem_testdev.c b/drivers/media/video/mem2mem_testdev.c
index 0d0c0d5..0a79c86 100644
--- a/drivers/media/video/mem2mem_testdev.c
+++ b/drivers/media/video/mem2mem_testdev.c
@@ -787,7 +787,7 @@ static int m2mtest_buf_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static void m2mtest_buf_queue(struct vb2_buffer *vb)
+static void m2mtest_buf_queue(struct vb2_buffer *vb, bool streaming)
 {
 	struct m2mtest_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
 	v4l2_m2m_buf_queue(ctx->m2m_ctx, vb);
diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index e6afe5f..5f80fb4 100644
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
+static int start_streaming(struct vb2_queue *q, int count)
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
@@ -310,7 +324,7 @@ static int buffer_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static void buffer_queue(struct vb2_buffer *vb)
+static void buffer_queue(struct vb2_buffer *vb, bool streaming)
 {
 	struct fimc_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
 	struct fimc_dev *fimc = ctx->fimc_dev;
@@ -341,7 +355,7 @@ static void buffer_queue(struct vb2_buffer *vb)
 
 	min_bufs = vid_cap->reqbufs_count > 1 ? 2 : 1;
 
-	if (vid_cap->active_buf_cnt >= min_bufs &&
+	if (streaming && vid_cap->active_buf_cnt >= min_bufs &&
 	    !test_and_set_bit(ST_CAPT_STREAM, &fimc->state))
 		fimc_activate_capture(ctx);
 
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 36d127f..8152756 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -733,7 +733,7 @@ static int fimc_buf_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static void fimc_buf_queue(struct vb2_buffer *vb)
+static void fimc_buf_queue(struct vb2_buffer *vb, bool streaming)
 {
 	struct fimc_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
 
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
index dbc94b8..13099b8 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
@@ -864,7 +864,7 @@ static int s5p_mfc_buf_init(struct vb2_buffer *vb)
 	return 0;
 }
 
-static int s5p_mfc_start_streaming(struct vb2_queue *q)
+static int s5p_mfc_start_streaming(struct vb2_queue *q, int count)
 {
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(q->drv_priv);
 	struct s5p_mfc_dev *dev = ctx->dev;
@@ -919,7 +919,7 @@ static int s5p_mfc_stop_streaming(struct vb2_queue *q)
 }
 
 
-static void s5p_mfc_buf_queue(struct vb2_buffer *vb)
+static void s5p_mfc_buf_queue(struct vb2_buffer *vb, bool streaming)
 {
 	struct vb2_queue *vq = vb->vb2_queue;
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(vq->drv_priv);
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
index 8bea0f3..ba84d35 100644
--- a/drivers/media/video/s5p-tv/mixer_video.c
+++ b/drivers/media/video/s5p-tv/mixer_video.c
@@ -758,25 +758,16 @@ static int queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
 	return 0;
 }
 
-static void buf_queue(struct vb2_buffer *vb)
+static void buf_queue(struct vb2_buffer *vb, bool streaming)
 {
 	struct mxr_buffer *buffer = container_of(vb, struct mxr_buffer, vb);
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
+static int start_streaming(struct vb2_queue *vq, int count)
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
index e89fd53..283c6ce 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -823,13 +823,13 @@ static int __qbuf_mmap(struct vb2_buffer *vb, struct v4l2_buffer *b)
 /**
  * __enqueue_in_driver() - enqueue a vb2_buffer in driver for processing
  */
-static void __enqueue_in_driver(struct vb2_buffer *vb)
+static void __enqueue_in_driver(struct vb2_buffer *vb, bool streaming)
 {
 	struct vb2_queue *q = vb->vb2_queue;
 
 	vb->state = VB2_BUF_STATE_ACTIVE;
 	atomic_inc(&q->queued_count);
-	q->ops->buf_queue(vb);
+	q->ops->buf_queue(vb, streaming);
 }
 
 /**
@@ -916,7 +916,7 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 	 * If not, the buffer will be given to driver on next streamon.
 	 */
 	if (q->streaming)
-		__enqueue_in_driver(vb);
+		__enqueue_in_driver(vb, 1);
 
 	dprintk(1, "qbuf of buffer %d succeeded\n", vb->v4l2_buf.index);
 	return 0;
@@ -1110,6 +1110,8 @@ int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
 }
 EXPORT_SYMBOL_GPL(vb2_dqbuf);
 
+static void __vb2_queue_cancel(struct vb2_queue *q);
+
 /**
  * vb2_streamon - start streaming
  * @q:		videobuf2 queue
@@ -1144,34 +1146,24 @@ int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
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
+		__enqueue_in_driver(vb, 0);
 
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
diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index 26eda47..17e7e1d 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -752,7 +752,7 @@ static void buffer_cleanup(struct vb2_buffer *vb)
 
 }
 
-static void buffer_queue(struct vb2_buffer *vb)
+static void buffer_queue(struct vb2_buffer *vb, bool streaming)
 {
 	struct vivi_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
 	struct vivi_buffer *buf = container_of(vb, struct vivi_buffer, vb);
@@ -766,7 +766,7 @@ static void buffer_queue(struct vb2_buffer *vb)
 	spin_unlock_irqrestore(&dev->slock, flags);
 }
 
-static int start_streaming(struct vb2_queue *vq)
+static int start_streaming(struct vb2_queue *vq, int count)
 {
 	struct vivi_dev *dev = vb2_get_drv_priv(vq);
 	dprintk(dev, 1, "%s\n", __func__);
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 5287e90..412daf0 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -196,15 +196,23 @@ struct vb2_buffer {
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
+ *			'streaming' parameter tells driver wheather streaming
+ *			state has been enabled not.
  */
 struct vb2_ops {
 	int (*queue_setup)(struct vb2_queue *q, unsigned int *num_buffers,
@@ -219,10 +227,10 @@ struct vb2_ops {
 	int (*buf_finish)(struct vb2_buffer *vb);
 	void (*buf_cleanup)(struct vb2_buffer *vb);
 
-	int (*start_streaming)(struct vb2_queue *q);
+	int (*start_streaming)(struct vb2_queue *q, int count);
 	int (*stop_streaming)(struct vb2_queue *q);
 
-	void (*buf_queue)(struct vb2_buffer *vb);
+	void (*buf_queue)(struct vb2_buffer *vb, bool streaming);
 };
 
 /**
-- 
1.7.1.569.g6f426

