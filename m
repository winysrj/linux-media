Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2479 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132AbaBYKEw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 05:04:52 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, s.nawrocki@samsung.com, m.szyprowski@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 07/20] vb2: call memop prepare before the buf_prepare op is called
Date: Tue, 25 Feb 2014 11:04:12 +0100
Message-Id: <1393322665-29889-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1393322665-29889-1-git-send-email-hverkuil@xs4all.nl>
References: <1393322665-29889-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The prepare memop now returns an error, so we need to be able to handle that.
In addition, prepare has to be called before buf_prepare since in the dma-sg
case buf_prepare expects that the dma memory is mapped and it can use the
sg_table.

So call the prepare memop before calling buf_prepare and clean up the memory
in case of an error.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 67 +++++++++++++++++++++++++++++---
 1 file changed, 61 insertions(+), 6 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index bb36fe5..0e0d2a8 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1207,6 +1207,39 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
 	vb->v4l2_buf.flags = b->flags & ~V4L2_BUFFER_MASK_FLAGS;
 }
 
+/*
+ * __buf_prepare_memory() - prepare (sync) a vb2_buffer so it can be enqueued
+ */
+static int __buf_prepare_memory(struct vb2_buffer *vb)
+{
+	unsigned int plane;
+	int err;
+
+	/* sync buffers */
+	for (plane = 0; plane < vb->num_planes; ++plane) {
+		err = call_memop(vb, prepare, vb->planes[plane].mem_priv);
+		if (err) {
+			fail_memop(vb, prepare);
+			for (; plane; plane--)
+				call_memop(vb, finish, vb->planes[plane - 1].mem_priv);
+			return err;
+		}
+	}
+	return 0;
+}
+
+/*
+ * __buf_finish_memory() - finish (unsync) a vb2_buffer
+ */
+static void __buf_finish_memory(struct vb2_buffer *vb)
+{
+	unsigned int plane;
+
+	/* unsync buffers */
+	for (plane = 0; plane < vb->num_planes; ++plane)
+		call_memop(vb, finish, vb->planes[plane].mem_priv);
+}
+
 /**
  * __qbuf_userptr() - handle qbuf of a USERPTR buffer
  */
@@ -1290,10 +1323,18 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		}
 	}
 
+	ret = __buf_prepare_memory(vb);
+	if (ret) {
+		call_vb_qop(vb, buf_cleanup, vb);
+		dprintk(1, "qbuf: buffer memory preparation failed\n");
+		goto err;
+	}
+
 	ret = call_vb_qop(vb, buf_prepare, vb);
 	if (ret) {
 		dprintk(1, "qbuf: buffer preparation failed\n");
 		fail_vb_qop(vb, buf_prepare);
+		__buf_finish_memory(vb);
 		call_vb_qop(vb, buf_cleanup, vb);
 		goto err;
 	}
@@ -1320,9 +1361,20 @@ static int __qbuf_mmap(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 	int ret;
 
 	__fill_vb2_buffer(vb, b, vb->v4l2_planes);
+
+	ret = __buf_prepare_memory(vb);
+	if (ret) {
+		call_vb_qop(vb, buf_cleanup, vb);
+		dprintk(1, "qbuf: buffer memory preparation failed\n");
+		return ret;
+	}
+
 	ret = call_vb_qop(vb, buf_prepare, vb);
-	if (ret)
+	if (ret) {
+		dprintk(1, "%s: buffer preparation failed\n", __func__);
 		fail_vb_qop(vb, buf_prepare);
+		__buf_finish_memory(vb);
+	}
 	return ret;
 }
 
@@ -1431,10 +1483,18 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		}
 	}
 
+	ret = __buf_prepare_memory(vb);
+	if (ret) {
+		call_vb_qop(vb, buf_cleanup, vb);
+		dprintk(1, "qbuf: buffer memory preparation failed\n");
+		goto err;
+	}
+
 	ret = call_vb_qop(vb, buf_prepare, vb);
 	if (ret) {
 		dprintk(1, "qbuf: buffer preparation failed\n");
 		fail_vb_qop(vb, buf_prepare);
+		__buf_finish_memory(vb);
 		call_vb_qop(vb, buf_cleanup, vb);
 		goto err;
 	}
@@ -1453,15 +1513,10 @@ err:
 static void __enqueue_in_driver(struct vb2_buffer *vb)
 {
 	struct vb2_queue *q = vb->vb2_queue;
-	unsigned int plane;
 
 	vb->state = VB2_BUF_STATE_ACTIVE;
 	atomic_inc(&q->owned_by_drv_count);
 
-	/* sync buffers */
-	for (plane = 0; plane < vb->num_planes; ++plane)
-		call_memop(vb, prepare, vb->planes[plane].mem_priv);
-
 	call_vb_qop(vb, buf_queue, vb);
 }
 
-- 
1.9.0

