Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1573 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367Ab2ISOi1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Sep 2012 10:38:27 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 3/6] videobuf2-core: move plane verification out of __fill_v4l2_buffer.
Date: Wed, 19 Sep 2012 16:37:37 +0200
Message-Id: <bf34157b75c930ab456dc977ebafbe895c7a3e8a.1348064901.git.hans.verkuil@cisco.com>
In-Reply-To: <1348065460-1624-1-git-send-email-hverkuil@xs4all.nl>
References: <1348065460-1624-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <9e4acd70e02bb67e6e7af0c236c69af27108e4fa.1348064901.git.hans.verkuil@cisco.com>
References: <9e4acd70e02bb67e6e7af0c236c69af27108e4fa.1348064901.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The plane verification should be done before actually queuing or
dequeuing buffers, so move it out of __fill_v4l2_buffer and call it
as a separate step.

The also makes it possible to change the return type of __fill_v4l2_buffer
to void.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c |   29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 2e26e58..929cc99 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -276,6 +276,9 @@ static void __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
  */
 static int __verify_planes_array(struct vb2_queue *q, const struct v4l2_buffer *b)
 {
+	if (!V4L2_TYPE_IS_MULTIPLANAR(b->type))
+		return 0;
+
 	/* Is memory for copying plane information present? */
 	if (NULL == b->m.planes) {
 		dprintk(1, "Multi-planar buffer passed but "
@@ -331,10 +334,9 @@ static bool __buffers_in_use(struct vb2_queue *q)
  * __fill_v4l2_buffer() - fill in a struct v4l2_buffer with information to be
  * returned to userspace
  */
-static int __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
+static void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
 {
 	struct vb2_queue *q = vb->vb2_queue;
-	int ret;
 
 	/* Copy back data such as timestamp, flags, etc. */
 	memcpy(b, &vb->v4l2_buf, offsetof(struct v4l2_buffer, m));
@@ -342,10 +344,6 @@ static int __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
 	b->reserved = vb->v4l2_buf.reserved;
 
 	if (V4L2_TYPE_IS_MULTIPLANAR(q->type)) {
-		ret = __verify_planes_array(q, b);
-		if (ret)
-			return ret;
-
 		/*
 		 * Fill in plane-related data if userspace provided an array
 		 * for it. The memory and size is verified above.
@@ -391,8 +389,6 @@ static int __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
 
 	if (__buffer_in_use(q, vb))
 		b->flags |= V4L2_BUF_FLAG_MAPPED;
-
-	return 0;
 }
 
 /**
@@ -411,6 +407,7 @@ static int __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
 int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b)
 {
 	struct vb2_buffer *vb;
+	int ret;
 
 	if (b->type != q->type) {
 		dprintk(1, "querybuf: wrong buffer type\n");
@@ -422,8 +419,10 @@ int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b)
 		return -EINVAL;
 	}
 	vb = q->bufs[b->index];
-
-	return __fill_v4l2_buffer(vb, b);
+	ret = __verify_planes_array(q, b);
+	if (!ret)
+		__fill_v4l2_buffer(vb, b);
+	return ret;
 }
 EXPORT_SYMBOL(vb2_querybuf);
 
@@ -1061,8 +1060,8 @@ int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b)
 		dprintk(1, "%s(): invalid buffer state %d\n", __func__, vb->state);
 		return -EINVAL;
 	}
-
-	ret = __buf_prepare(vb, b);
+	ret = __verify_planes_array(q, b);
+	ret = ret ? ret : __buf_prepare(vb, b);
 	if (ret < 0)
 		return ret;
 
@@ -1149,6 +1148,9 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 		ret = -EINVAL;
 		goto unlock;
 	}
+	ret = __verify_planes_array(q, b);
+	if (ret)
+		return ret;
 
 	switch (vb->state) {
 	case VB2_BUF_STATE_DEQUEUED:
@@ -1337,6 +1339,9 @@ int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
 		dprintk(1, "dqbuf: invalid buffer type\n");
 		return -EINVAL;
 	}
+	ret = __verify_planes_array(q, b);
+	if (ret)
+		return ret;
 
 	ret = __vb2_get_done_vb(q, &vb, nonblocking);
 	if (ret < 0) {
-- 
1.7.10.4

