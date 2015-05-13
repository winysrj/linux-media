Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:45821 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753348AbbEMHXD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 May 2015 03:23:03 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: ovebryne@cisco.com, marbugge@cisco.com, matrandg@cisco.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 2/5] vb2: allow requeuing buffers while streaming
Date: Wed, 13 May 2015 09:22:41 +0200
Message-Id: <1431501764-44250-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1431501764-44250-1-git-send-email-hverkuil@xs4all.nl>
References: <1431501764-44250-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

vb2_buffer_done() already allows STATE_QUEUED, but currently only when not
streaming. It is useful to allow it while streaming as well, as this makes
it possible for drivers to requeue buffers while waiting for a stable
video signal.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 552d7e1..1a096a6 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -182,6 +182,7 @@ module_param(debug, int, 0644);
 				 V4L2_BUF_FLAG_KEYFRAME | V4L2_BUF_FLAG_TIMECODE)
 
 static void __vb2_queue_cancel(struct vb2_queue *q);
+static void __enqueue_in_driver(struct vb2_buffer *vb);
 
 /**
  * __vb2_buf_mem_alloc() - allocate video memory for the given buffer
@@ -1153,8 +1154,9 @@ EXPORT_SYMBOL_GPL(vb2_plane_cookie);
 /**
  * vb2_buffer_done() - inform videobuf that an operation on a buffer is finished
  * @vb:		vb2_buffer returned from the driver
- * @state:	either VB2_BUF_STATE_DONE if the operation finished successfully
- *		or VB2_BUF_STATE_ERROR if the operation finished with an error.
+ * @state:	either VB2_BUF_STATE_DONE if the operation finished successfully,
+ *		VB2_BUF_STATE_ERROR if the operation finished with an error or
+ *		VB2_BUF_STATE_QUEUED if the driver wants to requeue buffers.
  *		If start_streaming fails then it should return buffers with state
  *		VB2_BUF_STATE_QUEUED to put them back into the queue.
  *
@@ -1205,8 +1207,11 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 	atomic_dec(&q->owned_by_drv_count);
 	spin_unlock_irqrestore(&q->done_lock, flags);
 
-	if (state == VB2_BUF_STATE_QUEUED)
+	if (state == VB2_BUF_STATE_QUEUED) {
+		if (q->start_streaming_called)
+			__enqueue_in_driver(vb);
 		return;
+	}
 
 	/* Inform any processes that may be waiting for buffers */
 	wake_up(&q->done_wq);
-- 
2.1.4

