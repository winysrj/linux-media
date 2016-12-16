Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:50169 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757012AbcLPBX5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 20:23:57 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Laura Abbott <labbott@redhat.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [RFC v2 02/11] vb2: Move buffer cache synchronisation to prepare from queue
Date: Fri, 16 Dec 2016 03:24:16 +0200
Message-Id: <20161216012425.11179-3-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20161216012425.11179-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20161216012425.11179-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

The buffer cache should be synchronised in buffer preparation, not when
the buffer is queued to the device. Fix this.

Mmap buffers do not need cache synchronisation since they are always
coherent.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 5379c8718010..8ba48703b189 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1225,23 +1225,19 @@ static int __prepare_dmabuf(struct vb2_buffer *vb, const void *pb)
 static void __enqueue_in_driver(struct vb2_buffer *vb)
 {
 	struct vb2_queue *q = vb->vb2_queue;
-	unsigned int plane;
 
 	vb->state = VB2_BUF_STATE_ACTIVE;
 	atomic_inc(&q->owned_by_drv_count);
 
 	trace_vb2_buf_queue(q, vb);
 
-	/* sync buffers */
-	for (plane = 0; plane < vb->num_planes; ++plane)
-		call_void_memop(vb, prepare, vb->planes[plane].mem_priv);
-
 	call_void_vb_qop(vb, buf_queue, vb);
 }
 
 static int __buf_prepare(struct vb2_buffer *vb, const void *pb)
 {
 	struct vb2_queue *q = vb->vb2_queue;
+	unsigned int plane;
 	int ret;
 
 	if (q->error) {
@@ -1266,11 +1262,19 @@ static int __buf_prepare(struct vb2_buffer *vb, const void *pb)
 		ret = -EINVAL;
 	}
 
-	if (ret)
+	if (ret) {
 		dprintk(1, "buffer preparation failed: %d\n", ret);
-	vb->state = ret ? VB2_BUF_STATE_DEQUEUED : VB2_BUF_STATE_PREPARED;
+		vb->state = VB2_BUF_STATE_DEQUEUED;
+		return ret;
+	}
 
-	return ret;
+	/* sync buffers */
+	for (plane = 0; plane < vb->num_planes; ++plane)
+		call_void_memop(vb, prepare, vb->planes[plane].mem_priv);
+
+	vb->state = VB2_BUF_STATE_PREPARED;
+
+	return 0;
 }
 
 int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb)
-- 
Regards,

Laurent Pinchart

