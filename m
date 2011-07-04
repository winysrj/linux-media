Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:17598 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758518Ab1GDRzs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2011 13:55:48 -0400
Date: Mon, 04 Jul 2011 19:55:09 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v3 18/19] s5p-fimc: Use consistent names for the buffer list
 functions
In-reply-to: <1309802110-16682-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, sw0312.kim@samsung.com,
	riverful.kim@samsung.com
Message-id: <1309802110-16682-19-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1309802110-16682-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Also correct and improve *_queue_add/pop functions description.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |    6 ++--
 drivers/media/video/s5p-fimc/fimc-core.c    |    6 ++--
 drivers/media/video/s5p-fimc/fimc-core.h    |   38 +++++++++++++++++---------
 3 files changed, 31 insertions(+), 19 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index c9420db..3b64788 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -100,12 +100,12 @@ static int fimc_stop_capture(struct fimc_dev *fimc)
 
 	/* Release buffers that were enqueued in the driver by videobuf2. */
 	while (!list_empty(&cap->pending_buf_q)) {
-		buf = pending_queue_pop(cap);
+		buf = fimc_pending_queue_pop(cap);
 		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
 	}
 
 	while (!list_empty(&cap->active_buf_q)) {
-		buf = active_queue_pop(cap);
+		buf = fimc_active_queue_pop(cap);
 		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
 	}
 
@@ -256,7 +256,7 @@ static void buffer_queue(struct vb2_buffer *vb)
 
 		fimc_hw_set_output_addr(fimc, &buf->paddr, buf_id);
 		buf->index = vid_cap->buf_index;
-		active_queue_add(vid_cap, buf);
+		fimc_active_queue_add(vid_cap, buf);
 
 		if (++vid_cap->buf_index >= FIMC_MAX_OUT_BUFS)
 			vid_cap->buf_index = 0;
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 9538ab7..66d1af5 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -338,7 +338,7 @@ void fimc_capture_irq_handler(struct fimc_dev *fimc, bool rel_buf)
 	    test_bit(ST_CAPT_RUN, &fimc->state) && rel_buf) {
 		ktime_get_real_ts(&ts);
 
-		v_buf = active_queue_pop(cap);
+		v_buf = fimc_active_queue_pop(cap);
 
 		tv = &v_buf->vb.v4l2_buf.timestamp;
 		tv->tv_sec = ts.tv_sec;
@@ -355,12 +355,12 @@ void fimc_capture_irq_handler(struct fimc_dev *fimc, bool rel_buf)
 
 	if (!list_empty(&cap->pending_buf_q)) {
 
-		v_buf = pending_queue_pop(cap);
+		v_buf = fimc_pending_queue_pop(cap);
 		fimc_hw_set_output_addr(fimc, &v_buf->paddr, cap->buf_index);
 		v_buf->index = cap->buf_index;
 
 		/* Move the buffer to the capture active queue */
-		active_queue_add(cap, v_buf);
+		fimc_active_queue_add(cap, v_buf);
 
 		dbg("next frame: %d, done frame: %d",
 		    fimc_hw_get_frame_index(fimc), v_buf->index);
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index 3759250..879d5dd 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -746,22 +746,27 @@ static inline void fimc_deactivate_capture(struct fimc_dev *fimc)
 }
 
 /*
- * Add buf to the capture active buffers queue.
- * Locking: Need to be called with fimc_dev::slock held.
+ * Buffer list manipulation functions. Must be called with fimc.slock held.
  */
-static inline void active_queue_add(struct fimc_vid_cap *vid_cap,
-				    struct fimc_vid_buffer *buf)
+
+/**
+ * fimc_active_queue_add - add buffer to the capture active buffers queue
+ * @buf: buffer to add to the active buffers list
+ */
+static inline void fimc_active_queue_add(struct fimc_vid_cap *vid_cap,
+					 struct fimc_vid_buffer *buf)
 {
 	list_add_tail(&buf->list, &vid_cap->active_buf_q);
 	vid_cap->active_buf_cnt++;
 }
 
-/*
- * Pop a video buffer from the capture active buffers queue
- * Locking: Need to be called with fimc_dev::slock held.
+/**
+ * fimc_active_queue_pop - pop buffer from the capture active buffers queue
+ *
+ * The caller must assure the active_buf_q list is not empty.
  */
-static inline struct fimc_vid_buffer *
-active_queue_pop(struct fimc_vid_cap *vid_cap)
+static inline struct fimc_vid_buffer *fimc_active_queue_pop(
+				    struct fimc_vid_cap *vid_cap)
 {
 	struct fimc_vid_buffer *buf;
 	buf = list_entry(vid_cap->active_buf_q.next,
@@ -771,16 +776,23 @@ active_queue_pop(struct fimc_vid_cap *vid_cap)
 	return buf;
 }
 
-/* Add video buffer to the capture pending buffers queue */
+/**
+ * fimc_pending_queue_add - add buffer to the capture pending buffers queue
+ * @buf: buffer to add to the pending buffers list
+ */
 static inline void fimc_pending_queue_add(struct fimc_vid_cap *vid_cap,
 					  struct fimc_vid_buffer *buf)
 {
 	list_add_tail(&buf->list, &vid_cap->pending_buf_q);
 }
 
-/* Add video buffer to the capture pending buffers queue */
-static inline struct fimc_vid_buffer *
-pending_queue_pop(struct fimc_vid_cap *vid_cap)
+/**
+ * fimc_pending_queue_pop - pop buffer from the capture pending buffers queue
+ *
+ * The caller must assure the pending_buf_q list is not empty.
+ */
+static inline struct fimc_vid_buffer *fimc_pending_queue_pop(
+				     struct fimc_vid_cap *vid_cap)
 {
 	struct fimc_vid_buffer *buf;
 	buf = list_entry(vid_cap->pending_buf_q.next,
-- 
1.7.5.4

