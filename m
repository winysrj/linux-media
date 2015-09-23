Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:8013 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395AbbIWJ0d (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Sep 2015 05:26:33 -0400
From: Mian Yousaf Kaukab <yousaf.kaukab@intel.com>
To: laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, linux-usb@vger.kernel.org,
	hdegoede@redhat.com, stern@rowland.harvard.edu, oneukum@suse.com,
	Mian Yousaf Kaukab <yousaf.kaukab@intel.com>
Subject: [PATCH v2] media: uvcvideo: handle urb completion in a tasklet
Date: Wed, 23 Sep 2015 11:27:23 +0200
Message-Id: <1443000443-3468-1-git-send-email-yousaf.kaukab@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

urb completion callback is executed in either host controllers
interrupt context or a tasklet (if hcd has set HCD_BH flag).

If hcd is calling urb->complete from interrupt context, to keep
preempt disable time short, add urbs to a list on completion and
schedule a tasklet to process the list.

Moreover, save timestamp and sof number in the urb completion callback
to avoid any delays.

Signed-off-by: Mian Yousaf Kaukab <yousaf.kaukab@intel.com>
---
[Rename from media: uvcvideo: handle urb completion in a work queue]

History:
v2:
 - Change to use tasklet instead of workqueue
 - Don't use local tasklet if hcd is aleady using tasklet for
   completion callback
v1:
 - Use global work queue instead of creating ordered queue.
 - Add completed urbs to a list and process all on the list when work
   is scheduled
 - Save timestamp and sof number in urb completion callback and use
   in uvc_video_clock_decode() and uvc_video_decode_start()
 - Fix race between usb_submit_urb() from uvc_video_complete() and
   usb_kill_urb() from uvc_uninit_video()

 drivers/media/usb/uvc/uvc_driver.c |   8 +++
 drivers/media/usb/uvc/uvc_isight.c |   3 +-
 drivers/media/usb/uvc/uvc_video.c  | 144 ++++++++++++++++++++++++++++---------
 drivers/media/usb/uvc/uvcvideo.h   |  18 ++++-
 4 files changed, 134 insertions(+), 39 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 4b5b3e8..218d4f5 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -21,6 +21,7 @@
 #include <linux/vmalloc.h>
 #include <linux/wait.h>
 #include <linux/version.h>
+#include <linux/usb/hcd.h>
 #include <asm/unaligned.h>
 
 #include <media/v4l2-common.h>
@@ -1945,6 +1946,13 @@ static int uvc_probe(struct usb_interface *intf,
 			"supported.\n", ret);
 	}
 
+	/*
+	 * This shouldn't be here. But since not all hcd are using tasklet for
+	 * urb completion callback, Check this from hcd and only use tasklet
+	 * for handling urb completion if hcd is not already using it.
+	 */
+	dev->hcd_uses_bh = hcd_giveback_urb_in_bh(bus_to_hcd(udev->bus));
+
 	uvc_trace(UVC_TRACE_PROBE, "UVC device initialized.\n");
 	usb_enable_autosuspend(udev);
 	return 0;
diff --git a/drivers/media/usb/uvc/uvc_isight.c b/drivers/media/usb/uvc/uvc_isight.c
index 8510e725..7f93d09 100644
--- a/drivers/media/usb/uvc/uvc_isight.c
+++ b/drivers/media/usb/uvc/uvc_isight.c
@@ -99,9 +99,10 @@ static int isight_decode(struct uvc_video_queue *queue, struct uvc_buffer *buf,
 	return 0;
 }
 
-void uvc_video_decode_isight(struct urb *urb, struct uvc_streaming *stream,
+void uvc_video_decode_isight(struct uvc_urb *uu, struct uvc_streaming *stream,
 		struct uvc_buffer *buf)
 {
+	struct urb *urb = uu->urb;
 	int ret, i;
 
 	for (i = 0; i < urb->number_of_packets; ++i) {
diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index f839654..2dfb233 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -379,15 +379,14 @@ static inline void uvc_video_get_ts(struct timespec *ts)
 
 static void
 uvc_video_clock_decode(struct uvc_streaming *stream, struct uvc_buffer *buf,
-		       const __u8 *data, int len)
+		       const __u8 *data, int len, u16 host_sof,
+		       struct timespec *ts)
 {
 	struct uvc_clock_sample *sample;
 	unsigned int header_size;
 	bool has_pts = false;
 	bool has_scr = false;
 	unsigned long flags;
-	struct timespec ts;
-	u16 host_sof;
 	u16 dev_sof;
 
 	switch (data[1] & (UVC_STREAM_PTS | UVC_STREAM_SCR)) {
@@ -435,9 +434,6 @@ uvc_video_clock_decode(struct uvc_streaming *stream, struct uvc_buffer *buf,
 
 	stream->clock.last_sof = dev_sof;
 
-	host_sof = usb_get_current_frame_number(stream->dev->udev);
-	uvc_video_get_ts(&ts);
-
 	/* The UVC specification allows device implementations that can't obtain
 	 * the USB frame number to keep their own frame counters as long as they
 	 * match the size and frequency of the frame number associated with USB
@@ -473,7 +469,7 @@ uvc_video_clock_decode(struct uvc_streaming *stream, struct uvc_buffer *buf,
 	sample->dev_stc = get_unaligned_le32(&data[header_size - 6]);
 	sample->dev_sof = dev_sof;
 	sample->host_sof = host_sof;
-	sample->host_ts = ts;
+	sample->host_ts = *ts;
 
 	/* Update the sliding window head and count. */
 	stream->clock.head = (stream->clock.head + 1) % stream->clock.size;
@@ -964,7 +960,8 @@ static void uvc_video_stats_stop(struct uvc_streaming *stream)
  * uvc_video_decode_end will never be called with a NULL buffer.
  */
 static int uvc_video_decode_start(struct uvc_streaming *stream,
-		struct uvc_buffer *buf, const __u8 *data, int len)
+		struct uvc_buffer *buf, const __u8 *data, int len,
+		u16 host_sof, struct timespec *ts)
 {
 	__u8 fid;
 
@@ -989,7 +986,7 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
 			uvc_video_stats_update(stream);
 	}
 
-	uvc_video_clock_decode(stream, buf, data, len);
+	uvc_video_clock_decode(stream, buf, data, len, host_sof, ts);
 	uvc_video_stats_decode(stream, data, len);
 
 	/* Store the payload FID bit and return immediately when the buffer is
@@ -1016,8 +1013,6 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
 	 * when the EOF bit is set to force synchronisation on the next packet.
 	 */
 	if (buf->state != UVC_BUF_STATE_ACTIVE) {
-		struct timespec ts;
-
 		if (fid == stream->last_fid) {
 			uvc_trace(UVC_TRACE_FRAME, "Dropping payload (out of "
 				"sync).\n");
@@ -1027,13 +1022,11 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
 			return -ENODATA;
 		}
 
-		uvc_video_get_ts(&ts);
-
 		buf->buf.v4l2_buf.field = V4L2_FIELD_NONE;
 		buf->buf.v4l2_buf.sequence = stream->sequence;
-		buf->buf.v4l2_buf.timestamp.tv_sec = ts.tv_sec;
+		buf->buf.v4l2_buf.timestamp.tv_sec = ts->tv_sec;
 		buf->buf.v4l2_buf.timestamp.tv_usec =
-			ts.tv_nsec / NSEC_PER_USEC;
+			ts->tv_nsec / NSEC_PER_USEC;
 
 		/* TODO: Handle PTS and SCR. */
 		buf->state = UVC_BUF_STATE_ACTIVE;
@@ -1160,9 +1153,10 @@ static void uvc_video_validate_buffer(const struct uvc_streaming *stream,
 /*
  * Completion handler for video URBs.
  */
-static void uvc_video_decode_isoc(struct urb *urb, struct uvc_streaming *stream,
-	struct uvc_buffer *buf)
+static void uvc_video_decode_isoc(struct uvc_urb *uu,
+		struct uvc_streaming *stream, struct uvc_buffer *buf)
 {
+	struct urb *urb = uu->urb;
 	u8 *mem;
 	int ret, i;
 
@@ -1180,7 +1174,8 @@ static void uvc_video_decode_isoc(struct urb *urb, struct uvc_streaming *stream,
 		mem = urb->transfer_buffer + urb->iso_frame_desc[i].offset;
 		do {
 			ret = uvc_video_decode_start(stream, buf, mem,
-				urb->iso_frame_desc[i].actual_length);
+				urb->iso_frame_desc[i].actual_length, uu->sof,
+				&uu->ts);
 			if (ret == -EAGAIN) {
 				uvc_video_validate_buffer(stream, buf);
 				buf = uvc_queue_next_buffer(&stream->queue,
@@ -1206,9 +1201,10 @@ static void uvc_video_decode_isoc(struct urb *urb, struct uvc_streaming *stream,
 	}
 }
 
-static void uvc_video_decode_bulk(struct urb *urb, struct uvc_streaming *stream,
-	struct uvc_buffer *buf)
+static void uvc_video_decode_bulk(struct uvc_urb *uu,
+		struct uvc_streaming *stream, struct uvc_buffer *buf)
 {
+	struct urb *urb = uu->urb;
 	u8 *mem;
 	int len, ret;
 
@@ -1228,7 +1224,8 @@ static void uvc_video_decode_bulk(struct urb *urb, struct uvc_streaming *stream,
 	 */
 	if (stream->bulk.header_size == 0 && !stream->bulk.skip_payload) {
 		do {
-			ret = uvc_video_decode_start(stream, buf, mem, len);
+			ret = uvc_video_decode_start(stream, buf, mem, len,
+				uu->sof, &uu->ts);
 			if (ret == -EAGAIN)
 				buf = uvc_queue_next_buffer(&stream->queue,
 							    buf);
@@ -1274,9 +1271,10 @@ static void uvc_video_decode_bulk(struct urb *urb, struct uvc_streaming *stream,
 	}
 }
 
-static void uvc_video_encode_bulk(struct urb *urb, struct uvc_streaming *stream,
-	struct uvc_buffer *buf)
+static void uvc_video_encode_bulk(struct uvc_urb *uu,
+		struct uvc_streaming *stream, struct uvc_buffer *buf)
 {
+	struct urb *urb = uu->urb;
 	u8 *mem = urb->transfer_buffer;
 	int len = stream->urb_size, ret;
 
@@ -1317,9 +1315,10 @@ static void uvc_video_encode_bulk(struct urb *urb, struct uvc_streaming *stream,
 	urb->transfer_buffer_length = stream->urb_size - len;
 }
 
-static void uvc_video_complete(struct urb *urb)
+static void uvc_video_complete(struct uvc_urb *uu)
 {
-	struct uvc_streaming *stream = urb->context;
+	struct urb *urb = uu->urb;
+	struct uvc_streaming *stream = uu->stream;
 	struct uvc_video_queue *queue = &stream->queue;
 	struct uvc_buffer *buf = NULL;
 	unsigned long flags;
@@ -1349,7 +1348,10 @@ static void uvc_video_complete(struct urb *urb)
 				       queue);
 	spin_unlock_irqrestore(&queue->irqlock, flags);
 
-	stream->decode(urb, stream, buf);
+	stream->decode(uu, stream, buf);
+
+	if (stream->stop)
+		return;
 
 	if ((ret = usb_submit_urb(urb, GFP_ATOMIC)) < 0) {
 		uvc_printk(KERN_ERR, "Failed to resubmit video URB (%d).\n",
@@ -1357,6 +1359,55 @@ static void uvc_video_complete(struct urb *urb)
 	}
 }
 
+static void uvc_video_complete_tasklet(unsigned long param)
+{
+	struct uvc_streaming *stream = (struct uvc_streaming *)param;
+	struct urb *urb;
+	unsigned long flags;
+	int i;
+
+	for (i = 0; i < UVC_URBS; i++) {
+		spin_lock_irqsave(&stream->urb_list_lock, flags);
+		if (list_empty(&stream->urb_complete_list)) {
+			spin_unlock_irqrestore(&stream->urb_list_lock, flags);
+			return;
+		}
+		urb = list_first_entry(&stream->urb_complete_list,
+							struct urb, urb_list);
+		list_del(&urb->urb_list);
+		spin_unlock_irqrestore(&stream->urb_list_lock, flags);
+
+		uvc_video_complete(urb->context);
+	}
+}
+
+static void uvc_urb_complete(struct urb *urb)
+{
+	struct uvc_urb *uu = urb->context;
+	struct uvc_streaming *stream = uu->stream;
+	unsigned long flags;
+
+	uu->sof = usb_get_current_frame_number(stream->dev->udev);
+	uvc_video_get_ts(&uu->ts);
+
+	/*
+	 * Don't schedule tasklet If hcd is already using tasklet for
+	 * completion callback.
+	 * Not using !in_interrupt() here as this function can be called
+	 * without interrupt context as a result of usb_kill_urb()
+	 */
+	if (stream->dev->hcd_uses_bh) {
+		uvc_video_complete(uu);
+		return;
+	}
+
+	spin_lock_irqsave(&stream->urb_list_lock, flags);
+	list_add_tail(&urb->urb_list, &stream->urb_complete_list);
+	spin_unlock_irqrestore(&stream->urb_list_lock, flags);
+
+	tasklet_schedule(&stream->urb_tasklet);
+}
+
 /*
  * Free transfer buffers.
  */
@@ -1448,14 +1499,29 @@ static void uvc_uninit_video(struct uvc_streaming *stream, int free_buffers)
 
 	uvc_video_stats_stop(stream);
 
+	/* set stop and make sure no urb is being submitted.*/
+	stream->stop = true;
+	if (!stream->dev->hcd_uses_bh)
+		tasklet_unlock_wait(&stream->urb_tasklet);
+
 	for (i = 0; i < UVC_URBS; ++i) {
-		urb = stream->urb[i];
+		urb = stream->uvc_urb[i].urb;
 		if (urb == NULL)
 			continue;
 
 		usb_kill_urb(urb);
+	}
+
+	if (!stream->dev->hcd_uses_bh)
+		tasklet_kill(&stream->urb_tasklet);
+
+	for (i = 0; i < UVC_URBS; ++i) {
+		urb = stream->uvc_urb[i].urb;
+		if (urb == NULL)
+			continue;
+
 		usb_free_urb(urb);
-		stream->urb[i] = NULL;
+		stream->uvc_urb[i].urb = NULL;
 	}
 
 	if (free_buffers)
@@ -1514,7 +1580,7 @@ static int uvc_init_video_isoc(struct uvc_streaming *stream,
 		}
 
 		urb->dev = stream->dev->udev;
-		urb->context = stream;
+		urb->context = &stream->uvc_urb[i];
 		urb->pipe = usb_rcvisocpipe(stream->dev->udev,
 				ep->desc.bEndpointAddress);
 #ifndef CONFIG_DMA_NONCOHERENT
@@ -1525,7 +1591,7 @@ static int uvc_init_video_isoc(struct uvc_streaming *stream,
 #endif
 		urb->interval = ep->desc.bInterval;
 		urb->transfer_buffer = stream->urb_buffer[i];
-		urb->complete = uvc_video_complete;
+		urb->complete = uvc_urb_complete;
 		urb->number_of_packets = npackets;
 		urb->transfer_buffer_length = size;
 
@@ -1534,7 +1600,8 @@ static int uvc_init_video_isoc(struct uvc_streaming *stream,
 			urb->iso_frame_desc[j].length = psize;
 		}
 
-		stream->urb[i] = urb;
+		stream->uvc_urb[i].urb = urb;
+		stream->uvc_urb[i].stream = stream;
 	}
 
 	return 0;
@@ -1580,14 +1647,15 @@ static int uvc_init_video_bulk(struct uvc_streaming *stream,
 		}
 
 		usb_fill_bulk_urb(urb, stream->dev->udev, pipe,
-			stream->urb_buffer[i], size, uvc_video_complete,
-			stream);
+			stream->urb_buffer[i], size, uvc_urb_complete,
+			&stream->uvc_urb[i]);
 #ifndef CONFIG_DMA_NONCOHERENT
 		urb->transfer_flags = URB_NO_TRANSFER_DMA_MAP;
 		urb->transfer_dma = stream->urb_dma[i];
 #endif
 
-		stream->urb[i] = urb;
+		stream->uvc_urb[i].urb = urb;
+		stream->uvc_urb[i].stream = stream;
 	}
 
 	return 0;
@@ -1611,6 +1679,12 @@ static int uvc_init_video(struct uvc_streaming *stream, gfp_t gfp_flags)
 
 	uvc_video_stats_start(stream);
 
+	tasklet_init(&stream->urb_tasklet, uvc_video_complete_tasklet,
+						(unsigned long)stream);
+	INIT_LIST_HEAD(&stream->urb_complete_list);
+	spin_lock_init(&stream->urb_list_lock);
+	stream->stop = false;
+
 	if (intf->num_altsetting > 1) {
 		struct usb_host_endpoint *best_ep = NULL;
 		unsigned int best_psize = UINT_MAX;
@@ -1678,7 +1752,7 @@ static int uvc_init_video(struct uvc_streaming *stream, gfp_t gfp_flags)
 
 	/* Submit the URBs. */
 	for (i = 0; i < UVC_URBS; ++i) {
-		ret = usb_submit_urb(stream->urb[i], gfp_flags);
+		ret = usb_submit_urb(stream->uvc_urb[i].urb, gfp_flags);
 		if (ret < 0) {
 			uvc_printk(KERN_ERR, "Failed to submit URB %u "
 					"(%d).\n", i, ret);
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 816dd1a..0633d8a 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -440,6 +440,13 @@ struct uvc_stats_stream {
 	unsigned int max_sof;		/* Maximum STC.SOF value */
 };
 
+struct uvc_urb {
+	struct urb *urb;
+	struct uvc_streaming *stream;
+	struct timespec ts;
+	u16 sof;
+};
+
 struct uvc_streaming {
 	struct list_head list;
 	struct uvc_device *dev;
@@ -470,7 +477,7 @@ struct uvc_streaming {
 	/* Buffers queue. */
 	unsigned int frozen : 1;
 	struct uvc_video_queue queue;
-	void (*decode) (struct urb *urb, struct uvc_streaming *video,
+	void (*decode)(struct uvc_urb *uu, struct uvc_streaming *video,
 			struct uvc_buffer *buf);
 
 	/* Context data used by the bulk completion handler. */
@@ -482,7 +489,11 @@ struct uvc_streaming {
 		__u32 max_payload_size;
 	} bulk;
 
-	struct urb *urb[UVC_URBS];
+	bool stop;
+	spinlock_t urb_list_lock;
+	struct list_head urb_complete_list;
+	struct tasklet_struct urb_tasklet;
+	struct uvc_urb uvc_urb[UVC_URBS];
 	char *urb_buffer[UVC_URBS];
 	dma_addr_t urb_dma[UVC_URBS];
 	unsigned int urb_size;
@@ -550,6 +561,7 @@ struct uvc_device {
 	__u8 *status;
 	struct input_dev *input;
 	char input_phys[64];
+	bool hcd_uses_bh;
 };
 
 enum uvc_handle_state {
@@ -728,7 +740,7 @@ extern struct usb_host_endpoint *uvc_find_endpoint(
 		struct usb_host_interface *alts, __u8 epaddr);
 
 /* Quirks support */
-void uvc_video_decode_isight(struct urb *urb, struct uvc_streaming *stream,
+void uvc_video_decode_isight(struct uvc_urb *uu, struct uvc_streaming *stream,
 		struct uvc_buffer *buf);
 
 /* debugfs and statistics */
-- 
2.3.3

