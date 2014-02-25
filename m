Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3649 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499AbaBYMx1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 07:53:27 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, s.nawrocki@samsung.com, m.szyprowski@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv2 PATCH 12/15] vb2: properly clean up PREPARED and QUEUED buffers
Date: Tue, 25 Feb 2014 13:52:52 +0100
Message-Id: <1393332775-44067-13-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1393332775-44067-1-git-send-email-hverkuil@xs4all.nl>
References: <1393332775-44067-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

In __vb2_dqbuf we need to call the finish memop for any pending
buffers in the PREPARED or QUEUED state. This can happen if PREPARE_BUF
or QBUF was called without ever calling STREAMON.

In that case, when either REQBUFS(0) is called or the filehandle is
closed __vb2_queue_cancel needs to handle such buffers correctly.

For the same reason a call to __vb2_queue_cancel was added in __reqbufs
so that these buffers are cleaned up there as well.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index f156475..3815f9c 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -96,6 +96,8 @@ module_param(debug, int, 0644);
 				 V4L2_BUF_FLAG_PREPARED | \
 				 V4L2_BUF_FLAG_TIMESTAMP_MASK)
 
+static void __vb2_queue_cancel(struct vb2_queue *q);
+
 /**
  * __vb2_buf_mem_alloc() - allocate video memory for the given buffer
  */
@@ -789,6 +791,12 @@ static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 			return -EBUSY;
 		}
 
+		/*
+		 * Call queue_cancel to clean up any buffers in the PREPARED or
+		 * QUEUED state which is possible if buffers were prepared or
+		 * queued without ever calling STREAMON.
+		 */
+		__vb2_queue_cancel(q);
 		ret = __vb2_queue_free(q, q->num_buffers);
 		if (ret)
 			return ret;
@@ -1839,12 +1847,23 @@ EXPORT_SYMBOL_GPL(vb2_wait_for_all_buffers);
 static void __vb2_dqbuf(struct vb2_buffer *vb)
 {
 	struct vb2_queue *q = vb->vb2_queue;
+	unsigned int plane;
 	unsigned int i;
 
 	/* nothing to do if the buffer is already dequeued */
 	if (vb->state == VB2_BUF_STATE_DEQUEUED)
 		return;
 
+	/*
+	 * If it is prepared or queued the we 'finish' the buffer.
+	 * This can happen if buffers were prepared or queued without STREAMON
+	 * being called, and we are called by __vb2_queue_cancel.
+	 */
+	if (vb->state == VB2_BUF_STATE_PREPARED ||
+	    vb->state == VB2_BUF_STATE_QUEUED)
+		for (plane = 0; plane < vb->num_planes; ++plane)
+			call_memop(vb, finish, vb->planes[plane].mem_priv);
+
 	call_vb_qop(vb, buf_finish, vb);
 
 	vb->state = VB2_BUF_STATE_DEQUEUED;
-- 
1.9.0

