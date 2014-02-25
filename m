Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4722 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbaBYJsz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 04:48:55 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, s.nawrocki@samsung.com, m.szyprowski@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv1 PATCH 08/14] vb2: fix buf_init/buf_cleanup call sequences
Date: Tue, 25 Feb 2014 10:48:21 +0100
Message-Id: <1393321707-9749-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1393321707-9749-1-git-send-email-hverkuil@xs4all.nl>
References: <1393321707-9749-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Ensure that these ops are properly balanced.

There are two scenarios:

1) for MMAP buf_init is called when the buffers are created and buf_cleanup
   must be called when the queue is finally freed. This scenario was always
   working.

2) for USERPTR and DMABUF it is more complicated. When a buffer is queued
   the code checks if all planes of this buffer have been acquired before.
   If that's the case, then only buf_prepare has to be called. Otherwise
   buf_cleanup needs to be called if the buffer was acquired before, then,
   once all changed planes have been (re)acquired, buf_init has to be
   called followed by buf_prepare. Should buf_prepare fail, then buf_cleanup
   must be called on the newly acquired planes to release them in.

Finally, in __vb2_queue_free we have to check if the buffer was actually
acquired before calling buf_cleanup. While that it always true for MMAP
mode, it is not necessarily true for the other modes. E.g. if you just
call REQBUFS and close the file handle, then buffers were never queued and
so no buf_init was ever called.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 100 +++++++++++++++++++++----------
 1 file changed, 67 insertions(+), 33 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index b5142e5..eefcff7 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -373,8 +373,10 @@ static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
 	/* Call driver-provided cleanup function for each buffer, if provided */
 	for (buffer = q->num_buffers - buffers; buffer < q->num_buffers;
 	     ++buffer) {
-		if (q->bufs[buffer])
-			call_vb_qop(q->bufs[buffer], buf_cleanup, q->bufs[buffer]);
+		struct vb2_buffer *vb = q->bufs[buffer];
+
+		if (vb && vb->planes[0].mem_priv)
+			call_vb_qop(vb, buf_cleanup, vb);
 	}
 
 	/* Release video buffer memory */
@@ -1161,6 +1163,7 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 	unsigned int plane;
 	int ret;
 	int write = !V4L2_TYPE_IS_OUTPUT(q->type);
+	bool reacquired = vb->planes[0].mem_priv == NULL;
 
 	/* Copy relevant information provided by the userspace */
 	__fill_vb2_buffer(vb, b, planes);
@@ -1186,12 +1189,16 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		}
 
 		/* Release previously acquired memory if present */
-		if (vb->planes[plane].mem_priv)
+		if (vb->planes[plane].mem_priv) {
+			if (!reacquired) {
+				reacquired = true;
+				call_vb_qop(vb, buf_cleanup, vb);
+			}
 			call_memop(vb, put_userptr, vb->planes[plane].mem_priv);
+		}
 
 		vb->planes[plane].mem_priv = NULL;
-		vb->v4l2_planes[plane].m.userptr = 0;
-		vb->v4l2_planes[plane].length = 0;
+		memset(&vb->v4l2_planes[plane], 0, sizeof(struct v4l2_plane));
 
 		/* Acquire each plane's memory */
 		mem_priv = call_memop(vb, get_userptr, q->alloc_ctx[plane],
@@ -1208,23 +1215,34 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 	}
 
 	/*
-	 * Call driver-specific initialization on the newly acquired buffer,
-	 * if provided.
-	 */
-	ret = call_vb_qop(vb, buf_init, vb);
-	if (ret) {
-		dprintk(1, "qbuf: buffer initialization failed\n");
-		fail_vb_qop(vb, buf_init);
-		goto err;
-	}
-
-	/*
 	 * Now that everything is in order, copy relevant information
 	 * provided by userspace.
 	 */
 	for (plane = 0; plane < vb->num_planes; ++plane)
 		vb->v4l2_planes[plane] = planes[plane];
 
+	if (reacquired) {
+		/*
+		 * One or more planes changed, so we must call buf_init to do
+		 * the driver-specific initialization on the newly acquired
+		 * buffer, if provided.
+		 */
+		ret = call_vb_qop(vb, buf_init, vb);
+		if (ret) {
+			dprintk(1, "qbuf: buffer initialization failed\n");
+			fail_vb_qop(vb, buf_init);
+			goto err;
+		}
+	}
+
+	ret = call_vb_qop(vb, buf_prepare, vb);
+	if (ret) {
+		dprintk(1, "qbuf: buffer preparation failed\n");
+		fail_vb_qop(vb, buf_prepare);
+		call_vb_qop(vb, buf_cleanup, vb);
+		goto err;
+	}
+
 	return 0;
 err:
 	/* In case of errors, release planes that were already acquired */
@@ -1244,8 +1262,13 @@ err:
  */
 static int __qbuf_mmap(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 {
+	int ret;
+
 	__fill_vb2_buffer(vb, b, vb->v4l2_planes);
-	return 0;
+	ret = call_vb_qop(vb, buf_prepare, vb);
+	if (ret)
+		fail_vb_qop(vb, buf_prepare);
+	return ret;
 }
 
 /**
@@ -1259,6 +1282,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 	unsigned int plane;
 	int ret;
 	int write = !V4L2_TYPE_IS_OUTPUT(q->type);
+	bool reacquired = vb->planes[0].mem_priv == NULL;
 
 	/* Copy relevant information provided by the userspace */
 	__fill_vb2_buffer(vb, b, planes);
@@ -1294,6 +1318,11 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 
 		dprintk(1, "qbuf: buffer for plane %d changed\n", plane);
 
+		if (!reacquired) {
+			reacquired = true;
+			call_vb_qop(vb, buf_cleanup, vb);
+		}
+
 		/* Release previously acquired memory if present */
 		__vb2_plane_dmabuf_put(vb, &vb->planes[plane]);
 		memset(&vb->v4l2_planes[plane], 0, sizeof(struct v4l2_plane));
@@ -1329,23 +1358,33 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 	}
 
 	/*
-	 * Call driver-specific initialization on the newly acquired buffer,
-	 * if provided.
-	 */
-	ret = call_vb_qop(vb, buf_init, vb);
-	if (ret) {
-		dprintk(1, "qbuf: buffer initialization failed\n");
-		fail_vb_qop(vb, buf_init);
-		goto err;
-	}
-
-	/*
 	 * Now that everything is in order, copy relevant information
 	 * provided by userspace.
 	 */
 	for (plane = 0; plane < vb->num_planes; ++plane)
 		vb->v4l2_planes[plane] = planes[plane];
 
+	if (reacquired) {
+		/*
+		 * Call driver-specific initialization on the newly acquired buffer,
+		 * if provided.
+		 */
+		ret = call_vb_qop(vb, buf_init, vb);
+		if (ret) {
+			dprintk(1, "qbuf: buffer initialization failed\n");
+			fail_vb_qop(vb, buf_init);
+			goto err;
+		}
+	}
+
+	ret = call_vb_qop(vb, buf_prepare, vb);
+	if (ret) {
+		dprintk(1, "qbuf: buffer preparation failed\n");
+		fail_vb_qop(vb, buf_prepare);
+		call_vb_qop(vb, buf_cleanup, vb);
+		goto err;
+	}
+
 	return 0;
 err:
 	/* In case of errors, release planes that were already acquired */
@@ -1420,11 +1459,6 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		ret = -EINVAL;
 	}
 
-	if (!ret) {
-		ret = call_vb_qop(vb, buf_prepare, vb);
-		if (ret)
-			fail_vb_qop(vb, buf_prepare);
-	}
 	if (ret)
 		dprintk(1, "qbuf: buffer preparation failed: %d\n", ret);
 	vb->state = ret ? VB2_BUF_STATE_DEQUEUED : VB2_BUF_STATE_PREPARED;
-- 
1.9.0

