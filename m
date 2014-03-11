Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f73.google.com ([209.85.219.73]:48280 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755364AbaCKWwf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 18:52:35 -0400
Received: by mail-oa0-f73.google.com with SMTP id n16so1963236oag.2
        for <linux-media@vger.kernel.org>; Tue, 11 Mar 2014 15:52:35 -0700 (PDT)
From: John Sheu <sheu@google.com>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, k.debski@samsung.com, posciak@google.com,
	arun.m@samsung.com, kgene.kim@samsung.com,
	John Sheu <sheu@google.com>
Subject: [PATCH 4/4] v4l2-mem2mem: allow reqbufs(0) with "in use" MMAP buffers
Date: Tue, 11 Mar 2014 15:52:05 -0700
Message-Id: <1394578325-11298-5-git-send-email-sheu@google.com>
In-Reply-To: <1394578325-11298-1-git-send-email-sheu@google.com>
References: <1394578325-11298-1-git-send-email-sheu@google.com>
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
index 8e6695c9..5b6f9da6 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -414,8 +414,7 @@ static int __verify_length(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 }
 
 /**
- * __buffer_in_use() - return true if the buffer is in use and
- * the queue cannot be freed (by the means of REQBUFS(0)) call
+ * __buffer_in_use() - return true if the buffer is in use.
  */
 static bool __buffer_in_use(struct vb2_queue *q, struct vb2_buffer *vb)
 {
@@ -435,20 +434,6 @@ static bool __buffer_in_use(struct vb2_queue *q, struct vb2_buffer *vb)
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
@@ -681,15 +666,6 @@ static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
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
 		ret = __vb2_queue_free(q, q->num_buffers);
 		if (ret)
 			return ret;
-- 
1.9.0.279.gdc9e3eb

