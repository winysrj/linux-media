Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:57946 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbbIQVUX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Sep 2015 17:20:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, y2038@lists.linaro.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-api@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 6/9] [media] use v4l2_get_timestamp where possible
Date: Thu, 17 Sep 2015 23:19:37 +0200
Message-Id: <1442524780-781677-7-git-send-email-arnd@arndb.de>
In-Reply-To: <1442524780-781677-1-git-send-email-arnd@arndb.de>
References: <1442524780-781677-1-git-send-email-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a preparation for a change to the type of v4l2 timestamps.
v4l2_get_timestamp() is a helper function that reads the monotonic
time and stores it into a 'struct timeval'. Multiple drivers implement
the same thing themselves for historic reasons.

Changing them all to use v4l2_get_timestamp() is more consistent
and reduces the amount of code duplication, and most importantly
simplifies the following changes.

If desired, this patch can easily be split up into one patch per
driver.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/pci/bt8xx/bttv-driver.c            | 5 +----
 drivers/media/pci/cx18/cx18-mailbox.c            | 2 +-
 drivers/media/platform/exynos4-is/fimc-lite.c    | 7 +------
 drivers/media/platform/omap3isp/ispstat.c        | 5 ++---
 drivers/media/platform/omap3isp/ispstat.h        | 2 +-
 drivers/media/platform/s3c-camif/camif-capture.c | 8 +-------
 drivers/media/usb/gspca/gspca.c                  | 4 ++--
 drivers/media/v4l2-core/v4l2-dev.c               | 1 +
 drivers/staging/media/omap4iss/iss_video.c       | 5 +----
 9 files changed, 11 insertions(+), 28 deletions(-)

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 3632958f2158..15a4ebc2844d 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -3625,13 +3625,10 @@ static void
 bttv_irq_wakeup_vbi(struct bttv *btv, struct bttv_buffer *wakeup,
 		    unsigned int state)
 {
-	struct timeval ts;
-
 	if (NULL == wakeup)
 		return;
 
-	v4l2_get_timestamp(&ts);
-	wakeup->vb.ts = ts;
+	v4l2_get_timestamp(&wakeup->vb.ts);
 	wakeup->vb.field_count = btv->field_count;
 	wakeup->vb.state = state;
 	wake_up(&wakeup->vb.done);
diff --git a/drivers/media/pci/cx18/cx18-mailbox.c b/drivers/media/pci/cx18/cx18-mailbox.c
index eabf00c6351b..1f8aa9a749a1 100644
--- a/drivers/media/pci/cx18/cx18-mailbox.c
+++ b/drivers/media/pci/cx18/cx18-mailbox.c
@@ -202,7 +202,7 @@ static void cx18_mdl_send_to_videobuf(struct cx18_stream *s,
 	}
 
 	if (dispatch) {
-		vb_buf->vb.ts = ktime_to_timeval(ktime_get());
+		v4l2_get_timestamp(&vb_buf->vb.ts);
 		list_del(&vb_buf->vb.queue);
 		vb_buf->vb.state = VIDEOBUF_DONE;
 		wake_up(&vb_buf->vb.done);
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index ca6261a86a5f..459bc65b545d 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -254,8 +254,6 @@ static irqreturn_t flite_irq_handler(int irq, void *priv)
 	struct fimc_lite *fimc = priv;
 	struct flite_buffer *vbuf;
 	unsigned long flags;
-	struct timeval *tv;
-	struct timespec ts;
 	u32 intsrc;
 
 	spin_lock_irqsave(&fimc->slock, flags);
@@ -294,10 +292,7 @@ static irqreturn_t flite_irq_handler(int irq, void *priv)
 	    test_bit(ST_FLITE_RUN, &fimc->state) &&
 	    !list_empty(&fimc->active_buf_q)) {
 		vbuf = fimc_lite_active_queue_pop(fimc);
-		ktime_get_ts(&ts);
-		tv = &vbuf->vb.v4l2_buf.timestamp;
-		tv->tv_sec = ts.tv_sec;
-		tv->tv_usec = ts.tv_nsec / NSEC_PER_USEC;
+		v4l2_get_timestamp(&vbuf->vb.v4l2_buf.timestamp);
 		vbuf->vb.v4l2_buf.sequence = fimc->frame_count++;
 		flite_hw_mask_dma_buffer(fimc, vbuf->index);
 		vb2_buffer_done(&vbuf->vb, VB2_BUF_STATE_DONE);
diff --git a/drivers/media/platform/omap3isp/ispstat.c b/drivers/media/platform/omap3isp/ispstat.c
index 20434e83e801..94d4c295d3d0 100644
--- a/drivers/media/platform/omap3isp/ispstat.c
+++ b/drivers/media/platform/omap3isp/ispstat.c
@@ -235,7 +235,7 @@ static int isp_stat_buf_queue(struct ispstat *stat)
 	if (!stat->active_buf)
 		return STAT_NO_BUF;
 
-	ktime_get_ts(&stat->active_buf->ts);
+	v4l2_get_timestamp(&stat->active_buf->ts);
 
 	stat->active_buf->buf_size = stat->buf_size;
 	if (isp_stat_buf_check_magic(stat, stat->active_buf)) {
@@ -496,8 +496,7 @@ int omap3isp_stat_request_statistics(struct ispstat *stat,
 		return PTR_ERR(buf);
 	}
 
-	data->ts.tv_sec = buf->ts.tv_sec;
-	data->ts.tv_usec = buf->ts.tv_nsec / NSEC_PER_USEC;
+	data->ts = buf->ts;
 	data->config_counter = buf->config_counter;
 	data->frame_number = buf->frame_number;
 	data->buf_size = buf->buf_size;
diff --git a/drivers/media/platform/omap3isp/ispstat.h b/drivers/media/platform/omap3isp/ispstat.h
index b79380d83fcf..6d9b0244f320 100644
--- a/drivers/media/platform/omap3isp/ispstat.h
+++ b/drivers/media/platform/omap3isp/ispstat.h
@@ -39,7 +39,7 @@ struct ispstat_buffer {
 	struct sg_table sgt;
 	void *virt_addr;
 	dma_addr_t dma_addr;
-	struct timespec ts;
+	struct timeval ts;
 	u32 buf_size;
 	u32 frame_number;
 	u16 config_counter;
diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
index 76e6289a5612..edf70725ecf3 100644
--- a/drivers/media/platform/s3c-camif/camif-capture.c
+++ b/drivers/media/platform/s3c-camif/camif-capture.c
@@ -328,23 +328,17 @@ irqreturn_t s3c_camif_irq_handler(int irq, void *priv)
 	    !list_empty(&vp->active_buf_q)) {
 		unsigned int index;
 		struct camif_buffer *vbuf;
-		struct timeval *tv;
-		struct timespec ts;
 		/*
 		 * Get previous DMA write buffer index:
 		 * 0 => DMA buffer 0, 2;
 		 * 1 => DMA buffer 1, 3.
 		 */
 		index = (CISTATUS_FRAMECNT(status) + 2) & 1;
-
-		ktime_get_ts(&ts);
 		vbuf = camif_active_queue_peek(vp, index);
 
 		if (!WARN_ON(vbuf == NULL)) {
 			/* Dequeue a filled buffer */
-			tv = &vbuf->vb.v4l2_buf.timestamp;
-			tv->tv_sec = ts.tv_sec;
-			tv->tv_usec = ts.tv_nsec / NSEC_PER_USEC;
+			v4l2_get_timestamp(&vbuf->vb.v4l2_buf.timestamp);
 			vbuf->vb.v4l2_buf.sequence = vp->frame_sequence++;
 			vb2_buffer_done(&vbuf->vb, VB2_BUF_STATE_DONE);
 
diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
index e54cee856a80..af5cd8213e8b 100644
--- a/drivers/media/usb/gspca/gspca.c
+++ b/drivers/media/usb/gspca/gspca.c
@@ -436,7 +436,7 @@ void gspca_frame_add(struct gspca_dev *gspca_dev,
 		}
 		j = gspca_dev->fr_queue[i];
 		frame = &gspca_dev->frame[j];
-		frame->v4l2_buf.timestamp = ktime_to_timeval(ktime_get());
+		v4l2_get_timestamp(&frame->v4l2_buf.timestamp);
 		frame->v4l2_buf.sequence = gspca_dev->sequence++;
 		gspca_dev->image = frame->data;
 		gspca_dev->image_len = 0;
@@ -1909,7 +1909,7 @@ static ssize_t dev_read(struct file *file, char __user *data,
 	}
 
 	/* get a frame */
-	timestamp = ktime_to_timeval(ktime_get());
+	v4l2_get_timestamp(&timestamp);
 	timestamp.tv_sec--;
 	n = 2;
 	for (;;) {
diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 71a1b93b0790..8faa50dc5b19 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -565,6 +565,7 @@ static void determine_valid_ioctls(struct video_device *vdev)
 #endif
 	/* yes, really vidioc_subscribe_event */
 	SET_VALID_IOCTL(ops, VIDIOC_DQEVENT, vidioc_subscribe_event);
+	SET_VALID_IOCTL(ops, VIDIOC_DQEVENT32, vidioc_subscribe_event);
 	SET_VALID_IOCTL(ops, VIDIOC_SUBSCRIBE_EVENT, vidioc_subscribe_event);
 	SET_VALID_IOCTL(ops, VIDIOC_UNSUBSCRIBE_EVENT, vidioc_unsubscribe_event);
 	if (ops->vidioc_enum_freq_bands || ops->vidioc_g_tuner || ops->vidioc_g_modulator)
diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index 40405d8710a6..485a90ce12df 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -420,7 +420,6 @@ struct iss_buffer *omap4iss_video_buffer_next(struct iss_video *video)
 	enum iss_pipeline_state state;
 	struct iss_buffer *buf;
 	unsigned long flags;
-	struct timespec ts;
 
 	spin_lock_irqsave(&video->qlock, flags);
 	if (WARN_ON(list_empty(&video->dmaqueue))) {
@@ -433,9 +432,7 @@ struct iss_buffer *omap4iss_video_buffer_next(struct iss_video *video)
 	list_del(&buf->list);
 	spin_unlock_irqrestore(&video->qlock, flags);
 
-	ktime_get_ts(&ts);
-	buf->vb.v4l2_buf.timestamp.tv_sec = ts.tv_sec;
-	buf->vb.v4l2_buf.timestamp.tv_usec = ts.tv_nsec / NSEC_PER_USEC;
+	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
 
 	/* Do frame number propagation only if this is the output video node.
 	 * Frame number either comes from the CSI receivers or it gets
-- 
2.1.0.rc2

