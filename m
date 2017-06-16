Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35606 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752779AbdFPHj5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Jun 2017 03:39:57 -0400
Received: by mail-pf0-f193.google.com with SMTP id s66so4710631pfs.2
        for <linux-media@vger.kernel.org>; Fri, 16 Jun 2017 00:39:57 -0700 (PDT)
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [PATCH 12/12] [media] vb2: add out-fence support to QBUF
Date: Fri, 16 Jun 2017 16:39:15 +0900
Message-Id: <20170616073915.5027-13-gustavo@padovan.org>
In-Reply-To: <20170616073915.5027-1-gustavo@padovan.org>
References: <20170616073915.5027-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

If V4L2_BUF_FLAG_OUT_FENCE flag is present on the QBUF call we create
an out_fence for the buffer and return it to userspace on the fence_fd
field. It only works with ordered queues.

The fence is signaled on buffer_done(), when the job on the buffer is
finished.

v2: check if the queue is ordered.

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 drivers/media/v4l2-core/videobuf2-core.c |  6 ++++++
 drivers/media/v4l2-core/videobuf2-v4l2.c | 22 +++++++++++++++++++++-
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 21cc4ed..a57902ee 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -356,6 +356,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum vb2_memory memory,
 			vb->planes[plane].length = plane_sizes[plane];
 			vb->planes[plane].min_length = plane_sizes[plane];
 		}
+		vb->out_fence_fd = -1;
 		q->bufs[vb->index] = vb;
 
 		/* Allocate video buffer memory for the MMAP type */
@@ -940,6 +941,11 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 			__enqueue_in_driver(vb);
 		return;
 	default:
+		dma_fence_signal(vb->out_fence);
+		dma_fence_put(vb->out_fence);
+		vb->out_fence = NULL;
+		vb->out_fence_fd = -1;
+
 		/* Inform any processes that may be waiting for buffers */
 		wake_up(&q->done_wq);
 		break;
diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
index e6ad77f..e2733dd 100644
--- a/drivers/media/v4l2-core/videobuf2-v4l2.c
+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
@@ -204,9 +204,14 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
 	b->timestamp = ns_to_timeval(vb->timestamp);
 	b->timecode = vbuf->timecode;
 	b->sequence = vbuf->sequence;
-	b->fence_fd = -1;
+	b->fence_fd = vb->out_fence_fd;
 	b->reserved = 0;
 
+	if (vb->sync_file) {
+		fd_install(vb->out_fence_fd, vb->sync_file->file);
+		vb->sync_file = NULL;
+	}
+
 	if (q->is_multiplanar) {
 		/*
 		 * Fill in plane-related data if userspace provided an array
@@ -581,6 +586,21 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 		}
 	}
 
+	if (b->flags & V4L2_BUF_FLAG_OUT_FENCE) {
+		if (!q->ordered) {
+			dprintk(1, "can't use out-fences with unordered queues\n");
+			dma_fence_put(fence);
+			return -EINVAL;
+		}
+
+		ret = vb2_setup_out_fence(q, b->index);
+		if (ret) {
+			dprintk(1, "failed to set up out-fence\n");
+			dma_fence_put(fence);
+			return ret;
+		}
+	}
+
 	return ret ? ret : vb2_core_qbuf(q, b->index, b, fence);
 }
 EXPORT_SYMBOL_GPL(vb2_qbuf);
-- 
2.9.4
