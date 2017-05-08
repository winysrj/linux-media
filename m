Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:30997 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754771AbdEHPEa (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 May 2017 11:04:30 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, posciak@chromium.org,
        m.szyprowski@samsung.com, kyungmin.park@samsung.com,
        hverkuil@xs4all.nl, sumit.semwal@linaro.org, robdclark@gmail.com,
        daniel.vetter@ffwll.ch, labbott@redhat.com,
        laurent.pinchart@ideasonboard.com
Subject: [RFC v4 02/18] vb2: Move buffer cache synchronisation to prepare from queue
Date: Mon,  8 May 2017 18:03:14 +0300
Message-Id: <1494255810-12672-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1494255810-12672-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1494255810-12672-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The buffer cache should be synchronised in buffer preparation, not when
the buffer is queued to the device. Fix this.

Mmap buffers do not need cache synchronisation since they are always
coherent.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 8df680d..8bf3369 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1227,23 +1227,19 @@ static int __prepare_dmabuf(struct vb2_buffer *vb, const void *pb)
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
@@ -1268,11 +1264,19 @@ static int __buf_prepare(struct vb2_buffer *vb, const void *pb)
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
2.7.4
