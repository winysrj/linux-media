Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:39402 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752825AbeFDLrG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Jun 2018 07:47:06 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv15 25/35] videobuf2-core: add uses_requests flag
Date: Mon,  4 Jun 2018 13:46:38 +0200
Message-Id: <20180604114648.26159-26-hverkuil@xs4all.nl>
In-Reply-To: <20180604114648.26159-1-hverkuil@xs4all.nl>
References: <20180604114648.26159-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Set the first time a buffer from a request is queued to vb2.
Cleared when the queue is canceled.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/common/videobuf2/videobuf2-core.c | 2 ++
 include/media/videobuf2-core.h                  | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index 697765e70fbe..ec76dcb130fe 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -1500,6 +1500,7 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
 		if (ret)
 			return ret;
 
+		q->uses_requests = 1;
 		vb->state = VB2_BUF_STATE_IN_REQUEST;
 		/* Fill buffer information for the userspace */
 		if (pb) {
@@ -1813,6 +1814,7 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 	q->start_streaming_called = 0;
 	q->queued_count = 0;
 	q->error = 0;
+	q->uses_requests = 0;
 
 	/*
 	 * Remove all buffers from videobuf's list...
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index cad712403d14..67553180d98f 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -468,6 +468,8 @@ struct vb2_buf_ops {
  * @quirk_poll_must_check_waiting_for_buffers: Return %EPOLLERR at poll when QBUF
  *              has not been called. This is a vb1 idiom that has been adopted
  *              also by vb2.
+ * @uses_requests: requests are used for this queue. Set to 1 the first time
+ *		a request is queued. Set to 0 when the queue is canceled.
  * @lock:	pointer to a mutex that protects the &struct vb2_queue. The
  *		driver can set this to a mutex to let the v4l2 core serialize
  *		the queuing ioctls. If the driver wants to handle locking
@@ -535,6 +537,7 @@ struct vb2_queue {
 	unsigned			fileio_write_immediately:1;
 	unsigned			allow_zero_bytesused:1;
 	unsigned		   quirk_poll_must_check_waiting_for_buffers:1;
+	unsigned			uses_requests:1;
 
 	struct mutex			*lock;
 	void				*owner;
-- 
2.17.0
