Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:47160 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751100AbdEaOUB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 May 2017 10:20:01 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
        by paasikivi.fi.intel.com (Postfix) with ESMTP id C1A2320A70
        for <linux-media@vger.kernel.org>; Wed, 31 May 2017 17:18:43 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/3] vb2: Move buffer cache synchronisation to prepare from queue
Date: Wed, 31 May 2017 17:17:26 +0300
Message-Id: <1496240247-25936-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1496240247-25936-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1496240247-25936-1-git-send-email-sakari.ailus@linux.intel.com>
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
index 9f3ce3b..3107e21 100644
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
