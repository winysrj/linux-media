Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:40850 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754395AbbIHKfz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Sep 2015 06:35:55 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl
Subject: [RFC 02/11] vb2: Move buffer cache synchronisation to prepare from queue
Date: Tue,  8 Sep 2015 13:33:46 +0300
Message-Id: <1441708435-12736-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1441708435-12736-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1441708435-12736-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The buffer cache should be synchronised in buffer preparation, not when
the buffer is queued to the device. Fix this.

Mmap buffers do not need cache synchronisation since they are always
coherent.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index af6a23a..64fce4d 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1636,10 +1636,6 @@ static void __enqueue_in_driver(struct vb2_buffer *vb)
 
 	trace_vb2_buf_queue(q, vb);
 
-	/* sync buffers */
-	for (plane = 0; plane < vb->num_planes; ++plane)
-		call_void_memop(vb, prepare, vb->planes[plane].mem_priv);
-
 	call_void_vb_qop(vb, buf_queue, vb);
 }
 
@@ -1694,11 +1690,19 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
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
 
 static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
-- 
2.1.0.231.g7484e3b

