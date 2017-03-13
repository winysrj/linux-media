Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:34887 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753643AbdCMTVL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Mar 2017 15:21:11 -0400
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [RFC 10/10] [media] vb2: add out-fence support to QBUF
Date: Mon, 13 Mar 2017 16:20:35 -0300
Message-Id: <20170313192035.29859-11-gustavo@padovan.org>
In-Reply-To: <20170313192035.29859-1-gustavo@padovan.org>
References: <20170313192035.29859-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

If V4L2_BUF_FLAG_OUT_FENCE flag is present on the QBUF call we create
an out_fence for the buffer and return it to userspace on the fence_fd
field.

The fence is signaled on buffer_done(), when the job on the buffer is
finished.

TODO: clean up on __vb2_queue_cancel()

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 drivers/media/v4l2-core/videobuf2-core.c |  6 ++++++
 drivers/media/v4l2-core/videobuf2-v4l2.c | 15 ++++++++++++++-
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 54b1404..ca8abcc 100644
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
index c164aa0..1b43d9f 100644
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
@@ -577,6 +582,14 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 			return -EINVAL;
 	}
 
+	if (b->flags & V4L2_BUF_FLAG_OUT_FENCE) {
+		ret = vb2_setup_out_fence(q, b->index);
+		if (ret) {
+			dma_fence_put(fence);
+			return ret;
+		}
+	}
+
 	return ret ? ret : vb2_core_qbuf(q, b->index, b, fence);
 }
 EXPORT_SYMBOL_GPL(vb2_qbuf);
-- 
2.9.3
