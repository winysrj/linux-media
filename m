Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4828 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846AbaIHOPK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Sep 2014 10:15:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, laurent.pinchart@ideasonboard.com,
	m.szyprowski@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 05/12] vb2: call memop prepare before the buf_prepare op is called
Date: Mon,  8 Sep 2014 16:14:34 +0200
Message-Id: <1410185681-20111-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1410185681-20111-1-git-send-email-hverkuil@xs4all.nl>
References: <1410185681-20111-1-git-send-email-hverkuil@xs4all.nl>
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
 drivers/media/v4l2-core/videobuf2-core.c | 46 +++++++++++++++++++++++---------
 1 file changed, 34 insertions(+), 12 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 087cd62..1cb3423 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1346,13 +1346,43 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
 	}
 }
 
+static int __buf_memory_prepare(struct vb2_buffer *vb)
+{
+	int ret = call_vb_qop(vb, buf_prepare_for_cpu, vb);
+	unsigned int plane;
+
+	if (ret)
+		return ret;
+
+	/* sync buffers */
+	for (plane = 0; plane < vb->num_planes; ++plane) {
+		ret = call_memop(vb, prepare, vb->planes[plane].mem_priv);
+		if (ret) {
+			for (; plane; plane--)
+				call_void_memop(vb, finish, vb->planes[plane - 1].mem_priv);
+			call_void_vb_qop(vb, buf_finish_for_cpu, vb);
+			dprintk(1, "buffer memory preparation failed\n");
+			return ret;
+		}
+	}
+
+	ret = call_vb_qop(vb, buf_prepare, vb);
+	if (ret) {
+		dprintk(1, "buffer preparation failed\n");
+		for (plane = 0; plane < vb->num_planes; ++plane)
+			call_void_memop(vb, finish, vb->planes[plane].mem_priv);
+		call_void_vb_qop(vb, buf_finish_for_cpu, vb);
+	}
+	return ret;
+}
+
 /**
  * __qbuf_mmap() - handle qbuf of an MMAP buffer
  */
 static int __qbuf_mmap(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 {
 	__fill_vb2_buffer(vb, b, vb->v4l2_planes);
-	return call_vb_qop(vb, buf_prepare, vb);
+	return __buf_memory_prepare(vb);
 }
 
 /**
@@ -1437,11 +1467,10 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		}
 	}
 
-	ret = call_vb_qop(vb, buf_prepare, vb);
+	ret = __buf_memory_prepare(vb);
 	if (ret) {
-		dprintk(1, "buffer preparation failed\n");
 		call_void_vb_qop(vb, buf_cleanup, vb);
-		goto err;
+		return ret;
 	}
 
 	return 0;
@@ -1561,9 +1590,8 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		}
 	}
 
-	ret = call_vb_qop(vb, buf_prepare, vb);
+	ret = __buf_memory_prepare(vb);
 	if (ret) {
-		dprintk(1, "buffer preparation failed\n");
 		call_void_vb_qop(vb, buf_cleanup, vb);
 		goto err;
 	}
@@ -1628,12 +1656,6 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 	vb->v4l2_buf.timestamp.tv_usec = 0;
 	vb->v4l2_buf.sequence = 0;
 
-	ret = call_vb_qop(vb, buf_prepare_for_cpu, vb);
-	if (ret) {
-		dprintk(1, "buf_prepare_for_cpu failed\n");
-		return ret;
-	}
-
 	switch (q->memory) {
 	case V4L2_MEMORY_MMAP:
 		ret = __qbuf_mmap(vb, b);
-- 
2.1.0

