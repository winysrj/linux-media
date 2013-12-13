Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3955 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab3LMQOE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Dec 2013 11:14:04 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 3/9] vb2: fix race condition between REQBUFS and QBUF/PREPARE_BUF.
Date: Fri, 13 Dec 2013 17:13:40 +0100
Message-Id: <1386951226-27655-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1386951226-27655-1-git-send-email-hverkuil@xs4all.nl>
References: <1386951226-27655-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

When preparing a buffer the queue lock is released for a short while
if the memory mode is USERPTR (see __buf_prepare for the details), which
would allow a race with a REQBUFS which can free the buffers. Removing the
buffers from underneath __buf_prepare is obviously a bad idea, so we
check if any of the buffers is in the state PREPARING, and if so we
just return -EAGAIN.

If this happens, then the application does something really strange. The
REQBUFS call can be retried safely, since this situation is transient.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 08ad883..a537094 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -298,10 +298,28 @@ static void __vb2_free_mem(struct vb2_queue *q, unsigned int buffers)
  * related information, if no buffers are left return the queue to an
  * uninitialized state. Might be called even if the queue has already been freed.
  */
-static void __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
+static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
 {
 	unsigned int buffer;
 
+	/*
+	 * Sanity check: when preparing a buffer the queue lock is released for
+	 * a short while (see __buf_prepare for the details), which would allow
+	 * a race with a reqbufs which can call this function. Removing the
+	 * buffers from underneath __buf_prepare is obviously a bad idea, so we
+	 * check if any of the buffers is in the state PREPARING, and if so we
+	 * just return -EAGAIN.
+	 */
+	for (buffer = q->num_buffers - buffers; buffer < q->num_buffers;
+	     ++buffer) {
+		if (q->bufs[buffer] == NULL)
+			continue;
+		if (q->bufs[buffer]->state == VB2_BUF_STATE_PREPARING) {
+			dprintk(1, "reqbufs: preparing buffers, cannot free\n");
+			return -EAGAIN;
+		}
+	}
+
 	/* Call driver-provided cleanup function for each buffer, if provided */
 	if (q->ops->buf_cleanup) {
 		for (buffer = q->num_buffers - buffers; buffer < q->num_buffers;
@@ -326,6 +344,7 @@ static void __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
 	if (!q->num_buffers)
 		q->memory = 0;
 	INIT_LIST_HEAD(&q->queued_list);
+	return 0;
 }
 
 /**
@@ -658,7 +677,9 @@ static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 			return -EBUSY;
 		}
 
-		__vb2_queue_free(q, q->num_buffers);
+		ret = __vb2_queue_free(q, q->num_buffers);
+		if (ret)
+			return ret;
 
 		/*
 		 * In case of REQBUFS(0) return immediately without calling
-- 
1.8.4.3

