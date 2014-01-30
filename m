Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2971 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087AbaA3OwH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jan 2014 09:52:07 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, s.nawrocki@samsung.com, m.szyprowski@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 7/9] vb2: add reinit_streaming op.
Date: Thu, 30 Jan 2014 15:51:29 +0100
Message-Id: <1391093491-23077-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1391093491-23077-1-git-send-email-hverkuil@xs4all.nl>
References: <1391093491-23077-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This new op is called after stop_streaming() or after a failed call to
start_streaming(). The driver needs to dequeue any pending active buffers
it got from the buf_queue() callback.

The reason this op was added is that stop_streaming() traditionally dequeued
any pending active buffers after stopping the DMA engine. However,
stop_streaming() is never called if start_streaming() fails, even though any
prequeued buffers have been passed on to the driver. In that case those
pending active buffers may still be in the driver's active buffer list,
which can cause all sorts of problems if they are not removed.

By splitting stop_streaming into stop_streaming (i.e. stop the DMA engine)
and reinit_streaming (i.e. reinitialize the buffer lists) this problem is
solved. After calling reinit_streaming() the vb2 core will also call
vb2_buffer_done() for any remaining active buffers.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 13 +++++++++++--
 include/media/videobuf2-core.h           |  9 +++++++--
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index a3b4b4c..3030ef6 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -395,9 +395,9 @@ static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
 		if (unbalanced || debug) {
 			pr_info("vb2: counters for queue %p:%s\n", q,
 				unbalanced ? " UNBALANCED!" : "");
-			pr_info("vb2:     setup: %u start_streaming: %u stop_streaming: %u\n",
+			pr_info("vb2:     setup: %u start_streaming: %u stop_streaming: %u reinit_streaming: %u\n",
 				q->cnt_queue_setup, q->cnt_start_streaming,
-				q->cnt_stop_streaming);
+				q->cnt_stop_streaming, q->cnt_reinit_streaming);
 			pr_info("vb2:     wait_prepare: %u wait_finish: %u\n",
 				q->cnt_wait_prepare, q->cnt_wait_finish);
 		}
@@ -406,6 +406,7 @@ static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
 		q->cnt_wait_finish = 0;
 		q->cnt_start_streaming = 0;
 		q->cnt_stop_streaming = 0;
+		q->cnt_reinit_streaming = 0;
 	}
 	for (buffer = 0; buffer < q->num_buffers; ++buffer) {
 		struct vb2_buffer *vb = q->bufs[buffer];
@@ -1900,7 +1901,15 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 	 */
 	if (q->streaming)
 		call_qop(q, stop_streaming, q);
+
 	q->streaming = 0;
+	if (atomic_read(&q->queued_count)) {
+		call_qop(q, reinit_streaming, q);
+
+		for (i = 0; i < q->num_buffers; ++i)
+			if (q->bufs[i]->state == VB2_BUF_STATE_ACTIVE)
+				vb2_buffer_done(q->bufs[i], VB2_BUF_STATE_ERROR);
+	}
 
 	/*
 	 * Remove all buffers from videobuf's list...
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 82b7f0f..b40dfbc 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -294,8 +294,11 @@ struct vb2_buffer {
  *			buffer is queued.
  * @stop_streaming:	called when 'streaming' state must be disabled; driver
  *			should stop any DMA transactions or wait until they
- *			finish and give back all buffers it got from buf_queue()
- *			callback; may use vb2_wait_for_all_buffers() function
+ *			finish; may use vb2_wait_for_all_buffers() function.
+ * @reinit_streaming:	called after stop_streaming() or after a failed call to
+ *			start_streaming(). The driver needs to dequeue any
+ *			pending active buffers it got from the buf_queue()
+ *			callback.
  * @buf_queue:		passes buffer vb to the driver; driver may start
  *			hardware operation on this buffer; driver should give
  *			the buffer back by calling vb2_buffer_done() function;
@@ -318,6 +321,7 @@ struct vb2_ops {
 
 	int (*start_streaming)(struct vb2_queue *q, unsigned int count);
 	int (*stop_streaming)(struct vb2_queue *q);
+	void (*reinit_streaming)(struct vb2_queue *q);
 
 	void (*buf_queue)(struct vb2_buffer *vb);
 };
@@ -408,6 +412,7 @@ struct vb2_queue {
 	u32				cnt_wait_finish;
 	u32				cnt_start_streaming;
 	u32				cnt_stop_streaming;
+	u32				cnt_reinit_streaming;
 #endif
 };
 
-- 
1.8.5.2

