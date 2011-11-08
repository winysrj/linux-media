Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35475 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038Ab1KHMGI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Nov 2011 07:06:08 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Yann Sionneau <yann@minet.net>
Subject: [PATCH 4/4] uvcvideo: Add UVC timestamps support
Date: Tue,  8 Nov 2011 13:06:02 +0100
Message-Id: <1320753962-14079-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1320753962-14079-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1320753962-14079-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

UVC devices transmit a device timestamp along with video frames. Convert
the timestamp to a host timestamp and use it to fill the V4L2 buffer
timestamp field.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/uvc/uvc_queue.c |   12 ++
 drivers/media/video/uvc/uvc_video.c |  327 +++++++++++++++++++++++++++++++++++
 drivers/media/video/uvc/uvcvideo.h  |   25 +++
 3 files changed, 364 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_queue.c b/drivers/media/video/uvc/uvc_queue.c
index 268be57..518f77d 100644
--- a/drivers/media/video/uvc/uvc_queue.c
+++ b/drivers/media/video/uvc/uvc_queue.c
@@ -104,10 +104,22 @@ static void uvc_buffer_queue(struct vb2_buffer *vb)
 	spin_unlock_irqrestore(&queue->irqlock, flags);
 }
 
+static int uvc_buffer_finish(struct vb2_buffer *vb)
+{
+	struct uvc_video_queue *queue = vb2_get_drv_priv(vb->vb2_queue);
+	struct uvc_streaming *stream =
+			container_of(queue, struct uvc_streaming, queue);
+	struct uvc_buffer *buf = container_of(vb, struct uvc_buffer, buf);
+
+	uvc_video_clock_update(stream, &vb->v4l2_buf, buf);
+	return 0;
+}
+
 static struct vb2_ops uvc_queue_qops = {
 	.queue_setup = uvc_queue_setup,
 	.buf_prepare = uvc_buffer_prepare,
 	.buf_queue = uvc_buffer_queue,
+	.buf_finish = uvc_buffer_finish,
 };
 
 void uvc_queue_init(struct uvc_video_queue *queue, enum v4l2_buf_type type,
diff --git a/drivers/media/video/uvc/uvc_video.c b/drivers/media/video/uvc/uvc_video.c
index 513ba30..d0600a5 100644
--- a/drivers/media/video/uvc/uvc_video.c
+++ b/drivers/media/video/uvc/uvc_video.c
@@ -357,6 +357,326 @@ static int uvc_commit_video(struct uvc_streaming *stream,
 	return uvc_set_video_ctrl(stream, probe, 0);
 }
 
+/* -----------------------------------------------------------------------------
+ * Clocks and timestamps
+ */
+
+static void
+uvc_video_clock_decode(struct uvc_streaming *stream, struct uvc_buffer *buf,
+		       const __u8 *data, int len)
+{
+	struct uvc_clock_sample *sample;
+	unsigned int header_size;
+	bool has_pts = false;
+	bool has_scr = false;
+	unsigned long flags;
+	struct timespec ts;
+	u16 host_sof;
+	u16 dev_sof;
+
+	switch (data[1] & (UVC_STREAM_PTS | UVC_STREAM_SCR)) {
+	case UVC_STREAM_PTS | UVC_STREAM_SCR:
+		header_size = 12;
+		has_pts = true;
+		has_scr = true;
+		break;
+	case UVC_STREAM_PTS:
+		header_size = 6;
+		has_pts = true;
+		break;
+	case UVC_STREAM_SCR:
+		header_size = 8;
+		has_scr = true;
+		break;
+	default:
+		header_size = 2;
+		break;
+	}
+
+	/* Check for invalid headers. */
+	if (len < header_size)
+		return;
+
+	/* Extract the timestamps:
+	 *
+	 * - store the frame PTS in the buffer structure
+	 * - if the SCR field is present, retrieve the host SOF counter and
+	 *   kernel timestamps and store them with the SCR STC and SOF fields
+	 *   in the ring buffer
+	 */
+	if (has_pts && buf != NULL)
+		buf->pts = get_unaligned_le32(&data[2]);
+
+	if (!has_scr)
+		return;
+
+	/* To limit the amount of data, drop SCRs with an SOF identical to the
+	 * previous one.
+	 */
+	dev_sof = get_unaligned_le16(&data[header_size - 2]);
+	if (dev_sof == stream->clock.last_sof)
+		return;
+
+	stream->clock.last_sof = dev_sof;
+
+	host_sof = usb_get_current_frame_number(stream->dev->udev);
+	ktime_get_ts(&ts);
+
+	/* The UVC specification allows device implementations that can't obtain
+	 * the USB frame number to keep their own frame counters as long as they
+	 * match the size and frequency of the frame number associated with USB
+	 * SOF tokens. The SOF values sent by such devices differ from the USB
+	 * SOF tokens by a fixed offset that needs to be estimated and accounted
+	 * for to make timestamp recovery as accurate as possible.
+	 *
+	 * The offset is estimated the first time a device SOF value is received
+	 * as the difference between the host and device SOF values. As the two
+	 * SOF values can differ slightly due to transmission delays, consider
+	 * that the offset is null if the difference is not higher than 10 ms
+	 * (negative differences can not happen and are thus considered as an
+	 * offset). The video commit control wDelay field should be used to
+	 * compute a dynamic threshold instead of using a fixed 10 ms value, but
+	 * devices don't report reliable wDelay values.
+	 *
+	 * See uvc_video_clock_host_sof() for an explanation regarding why only
+	 * the 8 LSBs of the delta are kept.
+	 */
+	if (stream->clock.sof_offset == (u16)-1) {
+		u16 delta_sof = (host_sof - dev_sof) & 255;
+		if (delta_sof >= 10)
+			stream->clock.sof_offset = delta_sof;
+		else
+			stream->clock.sof_offset = 0;
+	}
+
+	dev_sof = (dev_sof + stream->clock.sof_offset) & 2047;
+
+	spin_lock_irqsave(&stream->clock.lock, flags);
+
+	sample = &stream->clock.samples[stream->clock.head];
+	sample->dev_stc = get_unaligned_le32(&data[header_size - 6]);
+	sample->dev_sof = dev_sof;
+	sample->host_sof = host_sof;
+	sample->host_ts = ts;
+
+	/* Update the sliding window head and count. */
+	stream->clock.head = (stream->clock.head + 1) % stream->clock.size;
+
+	if (stream->clock.count < stream->clock.size)
+		stream->clock.count++;
+
+	spin_unlock_irqrestore(&stream->clock.lock, flags);
+}
+
+static int uvc_video_clock_init(struct uvc_streaming *stream)
+{
+	struct uvc_clock *clock = &stream->clock;
+
+	spin_lock_init(&clock->lock);
+	clock->head = 0;
+	clock->count = 0;
+	clock->size = 32;
+	clock->last_sof = -1;
+	clock->sof_offset = -1;
+
+	clock->samples = kmalloc(clock->size * sizeof(*clock->samples),
+				 GFP_KERNEL);
+	if (clock->samples == NULL)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void uvc_video_clock_cleanup(struct uvc_streaming *stream)
+{
+	kfree(stream->clock.samples);
+	stream->clock.samples = NULL;
+}
+
+/*
+ * uvc_video_clock_host_sof - Return the host SOF value for a clock sample
+ *
+ * Host SOF counters reported by usb_get_current_frame_number() usually don't
+ * cover the whole 11-bits SOF range (0-2047) but are limited to the HCI frame
+ * schedule window. They can be limited to 8, 9 or 10 bits depending on the host
+ * controller and its configuration.
+ *
+ * We thus need to recover the SOF value corresponding to the host frame number.
+ * As the device and host frame numbers are sampled in a short interval, the
+ * difference between their values should be equal to a small delta plus an
+ * integer multiple of 256 caused by the host frame number limited precision.
+ *
+ * To obtain the recovered host SOF value, compute the small delta by masking
+ * the high bits of the host frame counter and device SOF difference and add it
+ * to the device SOF value.
+ */
+static u16 uvc_video_clock_host_sof(const struct uvc_clock_sample *sample)
+{
+	/* The delta value can be negative. */
+	s8 delta_sof;
+
+	delta_sof = (sample->host_sof - sample->dev_sof) & 255;
+
+	return (sample->dev_sof + delta_sof) & 2047;
+}
+
+/*
+ * uvc_video_clock_update - Update the buffer timestamp
+ *
+ * This function converts the buffer PTS timestamp to the host clock domain by
+ * going through the USB SOF clock domain and stores the result in the V4L2
+ * buffer timestamp field.
+ *
+ * The relationship between the device clock and the host clock isn't known.
+ * However, the device and the host share the common USB SOF clock which can be
+ * used to recover that relationship.
+ *
+ * The relationship between the device clock and the USB SOF clock is considered
+ * to be linear over the clock samples sliding window and is given by
+ *
+ * SOF = m * PTS + p
+ *
+ * Several methods to compute the slope (m) and intercept (p) can be used. As
+ * the clock drift should be small compared to the sliding window size, we
+ * assume that the line that goes through the points at both ends of the window
+ * is a good approximation. Naming those points P1 and P2, we get
+ *
+ * SOF = (SOF2 - SOF1) / (STC2 - STC1) * PTS
+ *     + (SOF1 * STC2 - SOF2 * STC1) / (STC2 - STC1)
+ *
+ * or
+ *
+ * SOF = ((SOF2 - SOF1) * PTS + SOF1 * STC2 - SOF2 * STC1) / (STC2 - STC1)   (1)
+ *
+ * to avoid loosing precision in the division. Similarly, the host timestamp is
+ * computed with
+ *
+ * TS = ((TS2 - TS1) * PTS + TS1 * SOF2 - TS2 * SOF1) / (SOF2 - SOF1)	     (2)
+ *
+ * SOF values are coded on 11 bits by USB. We extend their precision with 16
+ * decimal bits, leading to a 11.16 coding.
+ *
+ * TODO: To avoid surprises with device clock values, PTS/STC timestamps should
+ * be normalized using the nominal device clock frequency reported through the
+ * UVC descriptors.
+ *
+ * Both the PTS/STC and SOF counters roll over, after a fixed but device
+ * specific amount of time for PTS/STC and after 2048ms for SOF. As long as the
+ * sliding window size is smaller than the rollover period, differences computed
+ * on unsigned integers will produce the correct result. However, the p term in
+ * the linear relations will be miscomputed.
+ *
+ * To fix the issue, we subtract a constant from the PTS and STC values to bring
+ * PTS to half the 32 bit STC range. The sliding window STC values then fit into
+ * the 32 bit range without any rollover.
+ *
+ * Similarly, we add 2048 to the device SOF values to make sure that the SOF
+ * computed by (1) will never be smaller than 0. This offset is then compensated
+ * by adding 2048 to the SOF values used in (2). However, this doesn't prevent
+ * rollovers between (1) and (2): the SOF value computed by (1) can be slightly
+ * lower than 4096, and the host SOF counters can have rolled over to 2048. This
+ * case is handled by subtracting 2048 from the SOF value if it exceeds the host
+ * SOF value at the end of the sliding window.
+ *
+ * Finally we subtract a constant from the host timestamps to bring the first
+ * timestamp of the sliding window to 1s.
+ */
+void uvc_video_clock_update(struct uvc_streaming *stream,
+			    struct v4l2_buffer *v4l2_buf,
+			    struct uvc_buffer *buf)
+{
+	struct uvc_clock *clock = &stream->clock;
+	struct uvc_clock_sample *first;
+	struct uvc_clock_sample *last;
+	unsigned long flags;
+	struct timespec ts;
+	u32 delta_stc;
+	u32 y1, y2;
+	u32 x1, x2;
+	u32 mean;
+	u32 sof;
+	u64 y;
+
+	spin_lock_irqsave(&clock->lock, flags);
+
+	if (clock->count < clock->size)
+		goto done;
+
+	first = &clock->samples[clock->head];
+	last = &clock->samples[(clock->head - 1) % clock->size];
+
+	/* First step, PTS to SOF conversion. */
+	delta_stc = buf->pts - (1UL << 31);
+	x1 = first->dev_stc - delta_stc;
+	x2 = last->dev_stc - delta_stc;
+	y1 = (first->dev_sof + 2048) << 16;
+	y2 = (last->dev_sof + 2048) << 16;
+
+	if (y2 < y1)
+		y2 += 2048 << 16;
+
+	y = (u64)(y2 - y1) * (1ULL << 31) + (u64)y1 * (u64)x2
+	  - (u64)y2 * (u64)x1;
+	y = div64_u64(y, x2 - x1);
+
+	sof = y;
+
+	uvc_trace(UVC_TRACE_CLOCK, "%s: PTS %u y %llu.%06llu SOF %u.%06llu "
+		  "(x1 %u x2 %u y1 %u y2 %u SOF offset %u)\n",
+		  stream->dev->name, buf->pts,
+		  y >> 16, div64_u64((y & 0xffff) * 1000000, 65536),
+		  sof >> 16, div64_u64(((u64)sof & 0xffff) * 1000000LLU, 65536),
+		  x1, x2, y1, y2, clock->sof_offset);
+
+	/* Second step, SOF to host clock conversion. */
+	ts = timespec_sub(last->host_ts, first->host_ts);
+	x1 = (uvc_video_clock_host_sof(first) + 2048) << 16;
+	x2 = (uvc_video_clock_host_sof(last) + 2048) << 16;
+	y1 = NSEC_PER_SEC;
+	y2 = (ts.tv_sec + 1) * NSEC_PER_SEC + ts.tv_nsec;
+
+	if (x2 < x1)
+		x2 += 2048 << 16;
+
+	/* Interpolated and host SOF timestamps can wrap around at slightly
+	 * different times. Handle this by adding or removing 2048 to or from
+	 * the computed SOF value to keep it close to the SOF samples mean
+	 * value.
+	 */
+	mean = (x1 + x2) / 2;
+	if (mean - (1024 << 16) > sof)
+		sof += 2048 << 16;
+	else if (sof > mean + (1024 << 16))
+		sof -= 2048 << 16;
+
+	y = (u64)(y2 - y1) * (u64)sof + (u64)y1 * (u64)x2
+	  - (u64)y2 * (u64)x1;
+	y = div64_u64(y, x2 - x1);
+
+	ts.tv_sec = first->host_ts.tv_sec - 1 + y / NSEC_PER_SEC;
+	ts.tv_nsec = first->host_ts.tv_nsec + y % NSEC_PER_SEC;
+	if (ts.tv_nsec >= NSEC_PER_SEC) {
+		ts.tv_sec++;
+		ts.tv_nsec -= NSEC_PER_SEC;
+	}
+
+	uvc_trace(UVC_TRACE_CLOCK, "%s: SOF %u.%06llu y %llu ts %lu.%06lu "
+		  "buf ts %lu.%06lu (x1 %u/%u/%u x2 %u/%u/%u y1 %u y2 %u)\n",
+		  stream->dev->name,
+		  sof >> 16, div64_u64(((u64)sof & 0xffff) * 1000000LLU, 65536),
+		  y, ts.tv_sec, ts.tv_nsec / NSEC_PER_USEC,
+		  v4l2_buf->timestamp.tv_sec, v4l2_buf->timestamp.tv_usec,
+		  x1, first->host_sof, first->dev_sof,
+		  x2, last->host_sof, last->dev_sof, y1, y2);
+
+	/* Update the V4L2 buffer. */
+	v4l2_buf->timestamp.tv_sec = ts.tv_sec;
+	v4l2_buf->timestamp.tv_usec = ts.tv_nsec / NSEC_PER_USEC;
+
+done:
+	spin_unlock_irqrestore(&stream->clock.lock, flags);
+}
+
 /* ------------------------------------------------------------------------
  * Stream statistics
  */
@@ -637,6 +957,7 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
 			uvc_video_stats_update(stream);
 	}
 
+	uvc_video_clock_decode(stream, buf, data, len);
 	uvc_video_stats_decode(stream, data, len);
 
 	/* Store the payload FID bit and return immediately when the buffer is
@@ -1096,6 +1417,8 @@ static void uvc_uninit_video(struct uvc_streaming *stream, int free_buffers)
 
 	if (free_buffers)
 		uvc_free_urb_buffers(stream);
+
+	uvc_video_clock_cleanup(stream);
 }
 
 /*
@@ -1225,6 +1548,10 @@ static int uvc_init_video(struct uvc_streaming *stream, gfp_t gfp_flags)
 
 	uvc_video_stats_start(stream);
 
+	ret = uvc_video_clock_init(stream);
+	if (ret < 0)
+		return ret;
+
 	if (intf->num_altsetting > 1) {
 		struct usb_host_endpoint *best_ep = NULL;
 		unsigned int best_psize = 3 * 1024;
diff --git a/drivers/media/video/uvc/uvcvideo.h b/drivers/media/video/uvc/uvcvideo.h
index e4d4b6d..e9c19f5 100644
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -329,6 +329,8 @@ struct uvc_buffer {
 	void *mem;
 	unsigned int length;
 	unsigned int bytesused;
+
+	u32 pts;
 };
 
 #define UVC_QUEUE_DISCONNECTED		(1 << 0)
@@ -455,6 +457,25 @@ struct uvc_streaming {
 		struct uvc_stats_frame frame;
 		struct uvc_stats_stream stream;
 	} stats;
+
+	/* Timestamps support. */
+	struct uvc_clock {
+		struct uvc_clock_sample {
+			u32 dev_stc;
+			u16 dev_sof;
+			struct timespec host_ts;
+			u16 host_sof;
+		} *samples;
+
+		unsigned int head;
+		unsigned int count;
+		unsigned int size;
+
+		u16 last_sof;
+		u16 sof_offset;
+
+		spinlock_t lock;
+	} clock;
 };
 
 enum uvc_device_state {
@@ -527,6 +548,7 @@ struct uvc_driver {
 #define UVC_TRACE_STATUS	(1 << 9)
 #define UVC_TRACE_VIDEO		(1 << 10)
 #define UVC_TRACE_STATS		(1 << 11)
+#define UVC_TRACE_CLOCK		(1 << 12)
 
 #define UVC_WARN_MINMAX		0
 #define UVC_WARN_PROBE_DEF	1
@@ -607,6 +629,9 @@ extern int uvc_probe_video(struct uvc_streaming *stream,
 		struct uvc_streaming_control *probe);
 extern int uvc_query_ctrl(struct uvc_device *dev, __u8 query, __u8 unit,
 		__u8 intfnum, __u8 cs, void *data, __u16 size);
+void uvc_video_clock_update(struct uvc_streaming *stream,
+			    struct v4l2_buffer *v4l2_buf,
+			    struct uvc_buffer *buf);
 
 /* Status */
 extern int uvc_status_init(struct uvc_device *dev);
-- 
1.7.3.4

