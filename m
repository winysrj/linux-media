Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f74.google.com ([209.85.160.74]:40432 "EHLO
	mail-pb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384Ab3JIXuh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Oct 2013 19:50:37 -0400
Received: by mail-pb0-f74.google.com with SMTP id rq2so131287pbb.3
        for <linux-media@vger.kernel.org>; Wed, 09 Oct 2013 16:50:36 -0700 (PDT)
From: John Sheu <sheu@google.com>
To: linux-media@vger.kernel.org
Cc: John Sheu <sheu@google.com>, m.chehab@samsung.com,
	k.debski@samsung.com, pawel@osciak.com
Subject: [PATCH 6/6] [media] v4l2-mem2mem: allow reqbufs(0) with "in use" MMAP buffers
Date: Wed,  9 Oct 2013 16:49:49 -0700
Message-Id: <1381362589-32237-7-git-send-email-sheu@google.com>
In-Reply-To: <1381362589-32237-1-git-send-email-sheu@google.com>
References: <1381362589-32237-1-git-send-email-sheu@google.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2-mem2mem presently does not allow VIDIOC_REQBUFS to destroy
outstanding buffers if the queue is of type V4L2_MEMORY_MMAP, and if the
buffers are considered "in use".  This is different behavior than for
other memory types, and prevents us for deallocating buffers in a few
cases:

* In the case that there are outstanding mmap()ed views on the buffer,
  refcounting on the videobuf2 buffer backing the vm_area will track
  lifetime appropriately,
* In the case that the buffer has been exported as a DMABUF, refcounting
  on the videobuf2 bufer backing the DMABUF will track lifetime
  appropriately.

Remove the specific check for type V4L2_MEMOMRY_MMAP when freeing all
buffers through VIDIOC_REQBUFS.

Signed-off-by: John Sheu <sheu@google.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 26 +-------------------------
 1 file changed, 1 insertion(+), 25 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index fc8af50..3c31efb 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -369,8 +369,7 @@ static int __verify_length(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 }
 
 /**
- * __buffer_in_use() - return true if the buffer is in use and
- * the queue cannot be freed (by the means of REQBUFS(0)) call
+ * __buffer_in_use() - return true if the buffer is in use.
  */
 static bool __buffer_in_use(struct vb2_queue *q, struct vb2_buffer *vb)
 {
@@ -390,20 +389,6 @@ static bool __buffer_in_use(struct vb2_queue *q, struct vb2_buffer *vb)
 }
 
 /**
- * __buffers_in_use() - return true if any buffers on the queue are in use and
- * the queue cannot be freed (by the means of REQBUFS(0)) call
- */
-static bool __buffers_in_use(struct vb2_queue *q)
-{
-	unsigned int buffer;
-	for (buffer = 0; buffer < q->num_buffers; ++buffer) {
-		if (__buffer_in_use(q, q->bufs[buffer]))
-			return true;
-	}
-	return false;
-}
-
-/**
  * __fill_v4l2_buffer() - fill in a struct v4l2_buffer with information to be
  * returned to userspace
  */
@@ -626,15 +611,6 @@ static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 	}
 
 	if (req->count == 0 || q->num_buffers != 0 || q->memory != req->memory) {
-		/*
-		 * We already have buffers allocated, so first check if they
-		 * are not in use and can be freed.
-		 */
-		if (q->memory == V4L2_MEMORY_MMAP && __buffers_in_use(q)) {
-			dprintk(1, "reqbufs: memory in use, cannot free\n");
-			return -EBUSY;
-		}
-
 		__vb2_queue_free(q, q->num_buffers);
 
 		/*
-- 
1.8.4

