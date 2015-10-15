Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:35647 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbbJOJFn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Oct 2015 05:05:43 -0400
Received: by pacao1 with SMTP id ao1so17372745pac.2
        for <linux-media@vger.kernel.org>; Thu, 15 Oct 2015 02:05:43 -0700 (PDT)
From: Tomasz Figa <tfiga@chromium.org>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Pawel Osciak <posciak@chromium.org>,
	Daniel Kurtz <djkurtz@chromium.org>,
	John Sheu <sheu@chromium.org>, Tomasz Figa <tfiga@chromium.org>
Subject: [PATCH] media: vb2: Allow reqbufs(0) with "in use" MMAP buffers
Date: Thu, 15 Oct 2015 18:05:25 +0900
Message-Id: <1444899925-22608-1-git-send-email-tfiga@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: John Sheu <sheu@chromium.org>

Videobuf2 presently does not allow VIDIOC_REQBUFS to destroy outstanding
buffers if the queue is of type V4L2_MEMORY_MMAP, and if the buffers are
considered "in use".  This is different behavior than for other memory
types and prevents us from deallocating buffers in following two cases:

1) There are outstanding mmap()ed views on the buffer. However even if
   we put the buffer in reqbufs(0), there will be remaining references,
   due to vma .open/close() adjusting vb2 buffer refcount appropriately.
   This means that the buffer will be in fact freed only when the last
   mmap()ed view is unmapped.

2) Buffer has been exported as a DMABUF. Refcount of the vb2 buffer
   is managed properly by VB2 DMABUF ops, i.e. incremented on DMABUF
   get and decremented on DMABUF release. This means that the buffer
   will be alive until all importers release it.

Considering both cases above, there does not seem to be any need to
prevent reqbufs(0) operation, because buffer lifetime is already
properly managed by both mmap() and DMABUF code paths. Let's remove it
and allow userspace freeing the queue (and potentially allocating a new
one) even though old buffers might be still in processing.

Signed-off-by: John Sheu <sheu@chromium.org>
Reviewed-by: Pawel Osciak <posciak@chromium.org>
Reviewed-by: Tomasz Figa <tfiga@chromium.org>
Signed-off-by: Tomasz Figa <tfiga@chromium.org>
---
 drivers/media/v4l2-core/videobuf2-core.c | 22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 4f59b7e..931c5de 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -636,19 +636,6 @@ static bool __buffer_in_use(struct vb2_queue *q, struct vb2_buffer *vb)
 	return false;
 }
 
-/**
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
 
 /**
  * __fill_v4l2_buffer() - fill in a struct v4l2_buffer with information to be
@@ -884,16 +871,7 @@ static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 	}
 
 	if (req->count == 0 || q->num_buffers != 0 || q->memory != req->memory) {
-		/*
-		 * We already have buffers allocated, so first check if they
-		 * are not in use and can be freed.
-		 */
 		mutex_lock(&q->mmap_lock);
-		if (q->memory == V4L2_MEMORY_MMAP && __buffers_in_use(q)) {
-			mutex_unlock(&q->mmap_lock);
-			dprintk(1, "memory in use, cannot free\n");
-			return -EBUSY;
-		}
 
 		/*
 		 * Call queue_cancel to clean up any buffers in the PREPARED or
-- 
2.6.0.rc2.230.g3dd15c0

