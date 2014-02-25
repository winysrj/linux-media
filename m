Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2042 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbaBYKEp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 05:04:45 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, s.nawrocki@samsung.com, m.szyprowski@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 02/20] vb2: fix handling of data_offset and v4l2_plane.reserved[]
Date: Tue, 25 Feb 2014 11:04:07 +0100
Message-Id: <1393322665-29889-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1393322665-29889-1-git-send-email-hverkuil@xs4all.nl>
References: <1393322665-29889-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The videobuf2-core did not zero the reserved array of v4l2_plane as it
should.

More serious is the fact that data_offset was not handled correctly:

- for capture devices it was never zeroed, which meant that it was
  uninitialized. Unless the driver sets it it was a completely random
  number.

- __qbuf_dmabuf had a completely incorrect length check that included
  data_offset.

- in the single-planar case data_offset was never correctly set to 0.
  The single-planar API doesn't support data_offset, so setting it
  to 0 is the right thing to do.

All these issues were found with v4l2-compliance.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 2c3a7f2..f9ced55 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1120,6 +1120,12 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
 	unsigned int plane;
 
 	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
+		for (plane = 0; plane < vb->num_planes; ++plane) {
+			memset(v4l2_planes[plane].reserved, 0,
+			       sizeof(v4l2_planes[plane].reserved));
+			v4l2_planes[plane].data_offset = 0;
+		}
+
 		/* Fill in driver-provided information for OUTPUT types */
 		if (V4L2_TYPE_IS_OUTPUT(b->type)) {
 			/*
@@ -1148,8 +1154,6 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
 					b->m.planes[plane].m.fd;
 				v4l2_planes[plane].length =
 					b->m.planes[plane].length;
-				v4l2_planes[plane].data_offset =
-					b->m.planes[plane].data_offset;
 			}
 		}
 	} else {
@@ -1159,10 +1163,10 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
 		 * In videobuf we use our internal V4l2_planes struct for
 		 * single-planar buffers as well, for simplicity.
 		 */
-		if (V4L2_TYPE_IS_OUTPUT(b->type)) {
+		if (V4L2_TYPE_IS_OUTPUT(b->type))
 			v4l2_planes[0].bytesused = b->bytesused;
-			v4l2_planes[0].data_offset = 0;
-		}
+		/* Single-planar buffers never use data_offset */
+		v4l2_planes[0].data_offset = 0;
 
 		if (b->memory == V4L2_MEMORY_USERPTR) {
 			v4l2_planes[0].m.userptr = b->m.userptr;
@@ -1172,9 +1176,7 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
 		if (b->memory == V4L2_MEMORY_DMABUF) {
 			v4l2_planes[0].m.fd = b->m.fd;
 			v4l2_planes[0].length = b->length;
-			v4l2_planes[0].data_offset = 0;
 		}
-
 	}
 
 	vb->v4l2_buf.field = b->field;
@@ -1331,8 +1333,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		if (planes[plane].length == 0)
 			planes[plane].length = dbuf->size;
 
-		if (planes[plane].length < planes[plane].data_offset +
-		    q->plane_sizes[plane]) {
+		if (planes[plane].length < q->plane_sizes[plane]) {
 			dprintk(1, "qbuf: invalid dmabuf length for plane %d\n",
 				plane);
 			ret = -EINVAL;
-- 
1.9.0

