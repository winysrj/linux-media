Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4429 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbaBYKEx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 05:04:53 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, s.nawrocki@samsung.com, m.szyprowski@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 12/20] vb2: use correct prefix
Date: Tue, 25 Feb 2014 11:04:17 +0100
Message-Id: <1393322665-29889-13-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1393322665-29889-1-git-send-email-hverkuil@xs4all.nl>
References: <1393322665-29889-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The __qbuf_mmap/userptr/dmabuf all uses similar dprintk's, all using the same
'qbuf' prefix. Replace this by the actual function name so I can see which
dprintk is actually executed.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 48 +++++++++++++++++---------------
 1 file changed, 25 insertions(+), 23 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 0e0d2a8..1f8ab7b 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1263,15 +1263,14 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		    && vb->v4l2_planes[plane].length == planes[plane].length)
 			continue;
 
-		dprintk(3, "qbuf: userspace address for plane %d changed, "
-				"reacquiring memory\n", plane);
+		dprintk(3, "%s: userspace address for plane %d changed, reacquiring memory\n",
+			__func__, plane);
 
 		/* Check if the provided plane buffer is large enough */
 		if (planes[plane].length < q->plane_sizes[plane]) {
-			dprintk(1, "qbuf: provided buffer size %u is less than "
-						"setup size %u for plane %d\n",
-						planes[plane].length,
-						q->plane_sizes[plane], plane);
+			dprintk(1, "%s: provided buffer size %u is less than setup size %u for plane %d\n",
+				__func__, planes[plane].length,
+				q->plane_sizes[plane], plane);
 			ret = -EINVAL;
 			goto err;
 		}
@@ -1293,8 +1292,8 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 				      planes[plane].m.userptr,
 				      planes[plane].length, write);
 		if (IS_ERR_OR_NULL(mem_priv)) {
-			dprintk(1, "qbuf: failed acquiring userspace "
-						"memory for plane %d\n", plane);
+			dprintk(1, "%s: failed acquiring userspace memory for plane %d\n",
+				__func__, plane);
 			fail_memop(vb, get_userptr);
 			ret = mem_priv ? PTR_ERR(mem_priv) : -EINVAL;
 			goto err;
@@ -1317,7 +1316,8 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		 */
 		ret = call_vb_qop(vb, buf_init, vb);
 		if (ret) {
-			dprintk(1, "qbuf: buffer initialization failed\n");
+			dprintk(1, "%s: buffer initialization failed\n",
+				__func__);
 			fail_vb_qop(vb, buf_init);
 			goto err;
 		}
@@ -1326,13 +1326,13 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 	ret = __buf_prepare_memory(vb);
 	if (ret) {
 		call_vb_qop(vb, buf_cleanup, vb);
-		dprintk(1, "qbuf: buffer memory preparation failed\n");
+		dprintk(1, "%s: buffer memory preparation failed\n", __func__);
 		goto err;
 	}
 
 	ret = call_vb_qop(vb, buf_prepare, vb);
 	if (ret) {
-		dprintk(1, "qbuf: buffer preparation failed\n");
+		dprintk(1, "%s: buffer preparation failed\n", __func__);
 		fail_vb_qop(vb, buf_prepare);
 		__buf_finish_memory(vb);
 		call_vb_qop(vb, buf_cleanup, vb);
@@ -1365,7 +1365,7 @@ static int __qbuf_mmap(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 	ret = __buf_prepare_memory(vb);
 	if (ret) {
 		call_vb_qop(vb, buf_cleanup, vb);
-		dprintk(1, "qbuf: buffer memory preparation failed\n");
+		dprintk(1, "%s: buffer memory preparation failed\n", __func__);
 		return ret;
 	}
 
@@ -1398,8 +1398,8 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		struct dma_buf *dbuf = dma_buf_get(planes[plane].m.fd);
 
 		if (IS_ERR_OR_NULL(dbuf)) {
-			dprintk(1, "qbuf: invalid dmabuf fd for plane %d\n",
-				plane);
+			dprintk(1, "%s: invalid dmabuf fd for plane %d\n",
+				__func__, plane);
 			ret = -EINVAL;
 			goto err;
 		}
@@ -1409,8 +1409,8 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 			planes[plane].length = dbuf->size;
 
 		if (planes[plane].length < q->plane_sizes[plane]) {
-			dprintk(1, "qbuf: invalid dmabuf length for plane %d\n",
-				plane);
+			dprintk(1, "%s: invalid dmabuf length for plane %d\n",
+				__func__, plane);
 			ret = -EINVAL;
 			goto err;
 		}
@@ -1422,7 +1422,8 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 			continue;
 		}
 
-		dprintk(1, "qbuf: buffer for plane %d changed\n", plane);
+		dprintk(1, "%s: buffer for plane %d changed\n",
+			__func__, plane);
 
 		if (!reacquired) {
 			reacquired = true;
@@ -1437,7 +1438,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		mem_priv = call_memop(vb, attach_dmabuf, q->alloc_ctx[plane],
 			dbuf, planes[plane].length, write);
 		if (IS_ERR(mem_priv)) {
-			dprintk(1, "qbuf: failed to attach dmabuf\n");
+			dprintk(1, "%s: failed to attach dmabuf\n", __func__);
 			fail_memop(vb, attach_dmabuf);
 			ret = PTR_ERR(mem_priv);
 			dma_buf_put(dbuf);
@@ -1455,8 +1456,8 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 	for (plane = 0; plane < vb->num_planes; ++plane) {
 		ret = call_memop(vb, map_dmabuf, vb->planes[plane].mem_priv);
 		if (ret) {
-			dprintk(1, "qbuf: failed to map dmabuf for plane %d\n",
-				plane);
+			dprintk(1, "%s: failed to map dmabuf for plane %d\n",
+				__func__, plane);
 			fail_memop(vb, map_dmabuf);
 			goto err;
 		}
@@ -1477,7 +1478,8 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		 */
 		ret = call_vb_qop(vb, buf_init, vb);
 		if (ret) {
-			dprintk(1, "qbuf: buffer initialization failed\n");
+			dprintk(1, "%s: buffer initialization failed\n",
+				__func__);
 			fail_vb_qop(vb, buf_init);
 			goto err;
 		}
@@ -1486,13 +1488,13 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 	ret = __buf_prepare_memory(vb);
 	if (ret) {
 		call_vb_qop(vb, buf_cleanup, vb);
-		dprintk(1, "qbuf: buffer memory preparation failed\n");
+		dprintk(1, "%s: buffer memory preparation failed\n", __func__);
 		goto err;
 	}
 
 	ret = call_vb_qop(vb, buf_prepare, vb);
 	if (ret) {
-		dprintk(1, "qbuf: buffer preparation failed\n");
+		dprintk(1, "%s: buffer preparation failed\n", __func__);
 		fail_vb_qop(vb, buf_prepare);
 		__buf_finish_memory(vb);
 		call_vb_qop(vb, buf_cleanup, vb);
-- 
1.9.0

