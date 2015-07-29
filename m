Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40528 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892AbbG2P31 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jul 2015 11:29:27 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] vb2: revert: vb2: allow requeuing buffers while streaming
Date: Wed, 29 Jul 2015 18:29:05 +0300
Message-Id: <1438183745-2652-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

commit ce0eff016f7272faa6dc6eec722b1ca1970ff9aa
[media] vb2: allow requeuing buffers while streaming

That commit causes buf_queue() called on infinity loop when
start_streaming() returns error. On that case resources are eaten
quickly and machine crashes.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/v4l2-core/videobuf2-core.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 93b3154..e7b4f6a 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -182,7 +182,6 @@ module_param(debug, int, 0644);
 				 V4L2_BUF_FLAG_KEYFRAME | V4L2_BUF_FLAG_TIMECODE)
 
 static void __vb2_queue_cancel(struct vb2_queue *q);
-static void __enqueue_in_driver(struct vb2_buffer *vb);
 
 /**
  * __vb2_buf_mem_alloc() - allocate video memory for the given buffer
@@ -1154,9 +1153,8 @@ EXPORT_SYMBOL_GPL(vb2_plane_cookie);
 /**
  * vb2_buffer_done() - inform videobuf that an operation on a buffer is finished
  * @vb:		vb2_buffer returned from the driver
- * @state:	either VB2_BUF_STATE_DONE if the operation finished successfully,
- *		VB2_BUF_STATE_ERROR if the operation finished with an error or
- *		VB2_BUF_STATE_QUEUED if the driver wants to requeue buffers.
+ * @state:	either VB2_BUF_STATE_DONE if the operation finished successfully
+ *		or VB2_BUF_STATE_ERROR if the operation finished with an error.
  *		If start_streaming fails then it should return buffers with state
  *		VB2_BUF_STATE_QUEUED to put them back into the queue.
  *
@@ -1207,11 +1205,8 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 	atomic_dec(&q->owned_by_drv_count);
 	spin_unlock_irqrestore(&q->done_lock, flags);
 
-	if (state == VB2_BUF_STATE_QUEUED) {
-		if (q->start_streaming_called)
-			__enqueue_in_driver(vb);
+	if (state == VB2_BUF_STATE_QUEUED)
 		return;
-	}
 
 	/* Inform any processes that may be waiting for buffers */
 	wake_up(&q->done_wq);
-- 
http://palosaari.fi/

