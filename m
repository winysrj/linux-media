Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.logicpd.com ([174.46.170.145]:51777 "HELO smtp.logicpd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752660AbbCJThf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2015 15:37:35 -0400
From: Tim Nordell <tim.nordell@logicpd.com>
To: <linux-media@vger.kernel.org>
CC: <laurent.pinchart@ideasonboard.com>, <sakari.ailus@iki.fi>,
	Tim Nordell <tim.nordell@logicpd.com>
Subject: [PATCH 3/3] omap3isp: Add a delayed buffers for frame mode
Date: Tue, 10 Mar 2015 14:24:54 -0500
Message-ID: <1426015494-16799-4-git-send-email-tim.nordell@logicpd.com>
In-Reply-To: <1426015494-16799-1-git-send-email-tim.nordell@logicpd.com>
References: <1426015494-16799-1-git-send-email-tim.nordell@logicpd.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When using an external decoder such as a NTSC decoder chip,
the decoder is sending frame data most of the time making
it very time sensitive to latch onto the CCDC not busy bit
from one frame to the next.  This is different than most
parallel cameras that may be attached to the system as
these send frames in more of a bursty way.

This exhibits itself as a problem in the VD0 interrupt, at
least when attached to a ADV7180 using BT.656.  In this case
the ISR sometimes misses the small amount of time that the
CCDC is not busy.  The ISR attempts to busywait for up to
1ms inside the ISR waiting for the CCDC to stop being busy
and if it misses it it will kill the stream.  In testing,
I set this delay up to 10ms with the ADV7180 and often saw
delays of ~6-7ms with this hardware configuration.

To avoid having to adjust this delay, the CCDC hardware
actually does latch the buffer address at each vertical sync
so the driver could modify the buffer address at any point
during a frame to take effect during the next frame.  In
this patch, the buffering subsystem has been modified for
BT.656 only so that the timing looks more like this near
the end of each frame:

  1. Frame N-2 is released back to userspace
  2. Frame N-1 is being filled by the hardware
  3. Frame N is loaded into buffer address

This introduces additional latency into the video pipeline and
it requires more buffers to be used in the pipeline, but it
removes the busy waiting in the ISR when it's attempting to
find the time the CCDC is not busy.

Rather than moving the buffers out of the dmaqueue, this patch
leaves the buffers in the dmaqueue so that the rest of the
cleanup code for the system isn't affected.  Peeking forward
from the front of the list doesn't take very many cycles to
complete and simplifies this patch's integration with the
rest of the system.  Additionally, this patch is set to only
occur when BT.656 is enabled in the system.

Signed-off-by: Tim Nordell <tim.nordell@logicpd.com>
---
 drivers/media/platform/omap3isp/ispccdc.c  |  22 +++-
 drivers/media/platform/omap3isp/ispvideo.c | 163 ++++++++++++++++++++++++-----
 drivers/media/platform/omap3isp/ispvideo.h |   3 +
 3 files changed, 157 insertions(+), 31 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index d5de843..882ebde 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -1147,6 +1147,8 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 
 		pdata = &((struct isp_v4l2_subdevs_group *)sensor->host_priv)
 			->bus.parallel;
+		if (ccdc->bt656)
+			ccdc->video_out.pipe.do_delayed_frames = true;
 	}
 
 	/* CCDC_PAD_SINK */
@@ -1321,9 +1323,23 @@ static void __ccdc_enable(struct isp_ccdc_device *ccdc, int enable)
 	* interrupts high enough that they won't be generated.
 	*/
 	if (enable) {
-		vd0 = format->height - 2;
-		vd1 = format->height * 2 / 3;
+		if (ccdc->bt656) {
+			/* Generate VD0 around the first line of the image
+			* and VD1 high enough to not be encountered for BT.656.
+			*/
+			vd0 = 1;
+			vd1 = 0xffff;
+		} else {
+			/* Generate VD0 on the last line of the image and VD1
+			* on the 2/3 height line.
+			*/
+			vd0 = format->height - 2;
+			vd1 = format->height * 2 / 3;
+		}
 	} else {
+		/* Set VD0 and VD1 interrupts high enough that they won't
+		* be generated.
+		*/
 		vd0 = 0xffff;
 		vd1 = 0xffff;
 	}
@@ -1617,7 +1633,7 @@ static int ccdc_isr_buffer(struct isp_ccdc_device *ccdc)
 	}
 
 	/* Wait for the CCDC to become idle. */
-	if (ccdc_sbl_wait_idle(ccdc, 1000)) {
+	if (!pipe->do_delayed_frames && ccdc_sbl_wait_idle(ccdc, 1000)) {
 		dev_info(isp->dev, "CCDC won't become idle!\n");
 		isp->crashed |= 1U << ccdc->subdev.entity.id;
 		omap3isp_pipeline_cancel_stream(pipe);
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 3fe9047..2764463 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -370,6 +370,34 @@ static int isp_video_buffer_prepare(struct vb2_buffer *buf)
 }
 
 /*
+ * isp_video_buffer_queue_ready - Returns true if dmaqueue is in a state that
+ * warrants starting the stream.
+ * @video: Video stream
+ *
+ * This function checks to see if isp_video_buffer_queue should start streaming
+ * of the queue or not.  If we're not doing delayed frames, we should kickstart
+ * on the basis of 0 frames currently in the queue.  If we are doing delayed
+ * frames, it should be on the basis of 2 frames currently in the queue.
+ */
+static bool isp_video_buffer_queue_ready(struct isp_video *video)
+{
+	int cnt = 0;
+	struct isp_buffer *pos;
+	struct isp_pipeline *pipe = to_isp_pipeline(&video->video.entity);
+
+	if (!pipe->do_delayed_frames)
+		return list_empty(&video->dmaqueue);
+
+	list_for_each_entry(pos, &video->dmaqueue, irqlist)
+		if (++cnt > 2)
+			return false;
+
+	if (cnt == 2)
+		return true;
+	return false;
+}
+
+/*
  * isp_video_buffer_queue - Add buffer to streaming queue
  * @buf: Video buffer
  *
@@ -389,6 +417,8 @@ static void isp_video_buffer_queue(struct vb2_buffer *buf)
 	unsigned int empty;
 	unsigned int start;
 
+	buffer->delayed_state = 0;
+
 	spin_lock_irqsave(&video->irqlock, flags);
 
 	if (unlikely(video->error)) {
@@ -397,9 +427,17 @@ static void isp_video_buffer_queue(struct vb2_buffer *buf)
 		return;
 	}
 
-	empty = list_empty(&video->dmaqueue);
+	empty = isp_video_buffer_queue_ready(video);
+
 	list_add_tail(&buffer->irqlist, &video->dmaqueue);
 
+	/* If we're doing delayed frames, we always want to load the _first_
+	 * frame in the queue.
+	 */
+	if (pipe->do_delayed_frames)
+		buffer = list_first_entry(&video->dmaqueue, struct isp_buffer,
+					  irqlist);
+
 	spin_unlock_irqrestore(&video->irqlock, flags);
 
 	if (empty) {
@@ -450,10 +488,15 @@ struct isp_buffer *omap3isp_video_buffer_next(struct isp_video *video)
 {
 	struct isp_pipeline *pipe = to_isp_pipeline(&video->video.entity);
 	enum isp_pipeline_state state;
-	struct isp_buffer *buf;
+	struct isp_buffer *buf, *tmp;
+	struct isp_buffer *buf_to_complete = NULL;
+	bool end_video_capture = false;
+
 	unsigned long flags;
 	struct timespec ts;
 
+	ktime_get_ts(&ts);
+
 	spin_lock_irqsave(&video->irqlock, flags);
 	if (WARN_ON(list_empty(&video->dmaqueue))) {
 		spin_unlock_irqrestore(&video->irqlock, flags);
@@ -462,43 +505,104 @@ struct isp_buffer *omap3isp_video_buffer_next(struct isp_video *video)
 
 	buf = list_first_entry(&video->dmaqueue, struct isp_buffer,
 			       irqlist);
-	list_del(&buf->irqlist);
-	spin_unlock_irqrestore(&video->irqlock, flags);
 
-	ktime_get_ts(&ts);
-	buf->vb.v4l2_buf.timestamp.tv_sec = ts.tv_sec;
-	buf->vb.v4l2_buf.timestamp.tv_usec = ts.tv_nsec / NSEC_PER_USEC;
-
-	/* Do frame number propagation only if this is the output video node.
-	 * Frame number either comes from the CSI receivers or it gets
-	 * incremented here if H3A is not active.
-	 * Note: There is no guarantee that the output buffer will finish
-	 * first, so the input number might lag behind by 1 in some cases.
-	 */
-	if (video == pipe->output && !pipe->do_propagation)
-		buf->vb.v4l2_buf.sequence =
-			atomic_inc_return(&pipe->frame_number);
-	else
-		buf->vb.v4l2_buf.sequence = atomic_read(&pipe->frame_number);
+	if (pipe->do_delayed_frames) {
+		/* If the leading buffer is delayed, there could be others */
+		switch (buf->delayed_state) {
+		case 2: /* buf[N-2] - this buffer is ready to be completed */
+			buf_to_complete = buf;
+
+			/* Find the next buffer in the queue */
+			tmp = list_next_entry(buf, irqlist);
+
+			if (tmp == buf) {
+				buf = NULL;
+				break;
+			}
+			buf = tmp;
+
+			/* Fall through */
+		case 1: /* buf[N-1] - this buffer will be ready next time */
+			buf->delayed_state++;
+
+			/* Find the next buffer in the queue */
+			tmp = list_next_entry(buf, irqlist);
+
+			if (tmp == buf) {
+				buf = NULL;
+				break;
+			}
+			buf = tmp;
+
+			/* Fall through */
+		case 0: /* buf[N] - this buffer will be queued this time */
+			buf->delayed_state++;
+			break;
+		}
 
-	if (pipe->field != V4L2_FIELD_NONE)
-		buf->vb.v4l2_buf.sequence /= 2;
+		if (buf_to_complete != NULL)
+			list_del(&buf_to_complete->irqlist);
+	} else {
+		list_del(&buf->irqlist);
+	}
+
+	/* Buf is potentially NULL in the delayed_frames case only */
+	if (buf != NULL) {
+		buf->vb.v4l2_buf.timestamp.tv_sec = ts.tv_sec;
+		buf->vb.v4l2_buf.timestamp.tv_usec = ts.tv_nsec / NSEC_PER_USEC;
+
+		/* Do frame number propagation only if this is the output
+		* video node.  Frame number either comes from the CSI
+		* receivers or it gets incremented here if H3A is not active.
+		*
+		* Note: There is no guarantee that the output buffer will
+		* finish first, so the input number might lag behind by 1 in
+		* some cases.
+		*/
+		if (video == pipe->output && !pipe->do_propagation)
+			buf->vb.v4l2_buf.sequence =
+				atomic_inc_return(&pipe->frame_number);
+		else
+			buf->vb.v4l2_buf.sequence =
+				atomic_read(&pipe->frame_number);
 
-	buf->vb.v4l2_buf.field = pipe->field;
+		if (pipe->field != V4L2_FIELD_NONE)
+			buf->vb.v4l2_buf.sequence /= 2;
+
+		buf->vb.v4l2_buf.field = pipe->field;
+	}
 
 	/* Report pipeline errors to userspace on the capture device side. */
 	if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE && pipe->error) {
-		state = VB2_BUF_STATE_ERROR;
+		buf->state = VB2_BUF_STATE_ERROR;
 		pipe->error = false;
 	} else {
-		state = VB2_BUF_STATE_DONE;
+		buf->state = VB2_BUF_STATE_DONE;
 	}
 
-	vb2_buffer_done(&buf->vb, state);
+	spin_unlock_irqrestore(&video->irqlock, flags);
+
+	if (!pipe->do_delayed_frames)
+		vb2_buffer_done(&buf->vb, buf->state);
+	else if (buf_to_complete != NULL)
+		vb2_buffer_done(&buf_to_complete->vb, buf_to_complete->state);
 
 	spin_lock_irqsave(&video->irqlock, flags);
 
-	if (list_empty(&video->dmaqueue)) {
+	if (pipe->do_delayed_frames) {
+		/* Find the first buffer available that hasn't been started.  If
+		 * there isn't one, we need to end video capture.
+		 */
+		end_video_capture = true;
+		list_for_each_entry(buf, &video->dmaqueue, irqlist)
+			if (buf->delayed_state == 0) {
+				end_video_capture = false;
+				break;
+			}
+	} else if (list_empty(&video->dmaqueue))
+		end_video_capture = true;
+
+	if (end_video_capture) {
 		spin_unlock_irqrestore(&video->irqlock, flags);
 
 		if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
@@ -522,8 +626,11 @@ struct isp_buffer *omap3isp_video_buffer_next(struct isp_video *video)
 		spin_unlock(&pipe->lock);
 	}
 
-	buf = list_first_entry(&video->dmaqueue, struct isp_buffer,
-			       irqlist);
+	/* With delayed frames, we've already found our buffer above. */
+	if (!pipe->do_delayed_frames)
+		buf = list_first_entry(&video->dmaqueue, struct isp_buffer,
+				       irqlist);
+
 	buf->vb.state = VB2_BUF_STATE_ACTIVE;
 
 	spin_unlock_irqrestore(&video->irqlock, flags);
diff --git a/drivers/media/platform/omap3isp/ispvideo.h b/drivers/media/platform/omap3isp/ispvideo.h
index 4071dd7..5857ed9 100644
--- a/drivers/media/platform/omap3isp/ispvideo.h
+++ b/drivers/media/platform/omap3isp/ispvideo.h
@@ -100,6 +100,7 @@ struct isp_pipeline {
 	struct v4l2_subdev *external;
 	unsigned int external_rate;
 	unsigned int external_width;
+	bool do_delayed_frames;
 };
 
 #define to_isp_pipeline(__e) \
@@ -125,6 +126,8 @@ struct isp_buffer {
 	struct vb2_buffer vb;
 	struct list_head irqlist;
 	dma_addr_t dma;
+	int delayed_state;
+	enum isp_pipeline_state state;
 };
 
 #define to_isp_buffer(buf)	container_of(buf, struct isp_buffer, vb)
-- 
2.0.4

