Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:36168 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727821AbeHDOqN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 4 Aug 2018 10:46:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv17 27/34] videobuf2-core: add uses_requests/qbuf flags
Date: Sat,  4 Aug 2018 14:45:19 +0200
Message-Id: <20180804124526.46206-28-hverkuil@xs4all.nl>
In-Reply-To: <20180804124526.46206-1-hverkuil@xs4all.nl>
References: <20180804124526.46206-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Set the first time a buffer from a request is queued to vb2
(uses_requests) or directly queued (uses_qbuf).
Cleared when the queue is canceled.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/common/videobuf2/videobuf2-core.c | 13 +++++++++++++
 include/media/videobuf2-core.h                  |  8 ++++++++
 2 files changed, 21 insertions(+)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index f8af7add35ab..5d7946ec80d8 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -1491,9 +1491,17 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
 
 	vb = q->bufs[index];
 
+	if ((req && q->uses_qbuf) ||
+	    (!req && vb->state != VB2_BUF_STATE_IN_REQUEST &&
+	     q->uses_requests)) {
+		dprintk(1, "queue in wrong mode (qbuf vs requests)\n");
+		return -EPERM;
+	}
+
 	if (req) {
 		int ret;
 
+		q->uses_requests = 1;
 		if (vb->state != VB2_BUF_STATE_DEQUEUED) {
 			dprintk(1, "buffer %d not in dequeued state\n",
 				vb->index);
@@ -1523,6 +1531,9 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
 		return 0;
 	}
 
+	if (vb->state != VB2_BUF_STATE_IN_REQUEST)
+		q->uses_qbuf = 1;
+
 	switch (vb->state) {
 	case VB2_BUF_STATE_DEQUEUED:
 	case VB2_BUF_STATE_IN_REQUEST:
@@ -1825,6 +1836,8 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 	q->start_streaming_called = 0;
 	q->queued_count = 0;
 	q->error = 0;
+	q->uses_requests = 0;
+	q->uses_qbuf = 0;
 
 	/*
 	 * Remove all buffers from videobuf's list...
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index cad712403d14..daffdf259fce 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -468,6 +468,12 @@ struct vb2_buf_ops {
  * @quirk_poll_must_check_waiting_for_buffers: Return %EPOLLERR at poll when QBUF
  *              has not been called. This is a vb1 idiom that has been adopted
  *              also by vb2.
+ * @uses_qbuf:	qbuf was used directly for this queue. Set to 1 the first
+ *		time this is called. Set to 0 when the queue is canceled.
+ *		If this is 1, then you cannot queue buffers from a request.
+ * @uses_requests: requests are used for this queue. Set to 1 the first time
+ *		a request is queued. Set to 0 when the queue is canceled.
+ *		If this is 1, then you cannot queue buffers directly.
  * @lock:	pointer to a mutex that protects the &struct vb2_queue. The
  *		driver can set this to a mutex to let the v4l2 core serialize
  *		the queuing ioctls. If the driver wants to handle locking
@@ -535,6 +541,8 @@ struct vb2_queue {
 	unsigned			fileio_write_immediately:1;
 	unsigned			allow_zero_bytesused:1;
 	unsigned		   quirk_poll_must_check_waiting_for_buffers:1;
+	unsigned			uses_qbuf:1;
+	unsigned			uses_requests:1;
 
 	struct mutex			*lock;
 	void				*owner;
-- 
2.18.0
