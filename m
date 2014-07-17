Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3676 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044AbaGQJx5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 05:53:57 -0400
Message-ID: <53C79D04.6040205@xs4all.nl>
Date: Thu, 17 Jul 2014 11:53:08 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Nikhil Devshatwar <nikhil.nd@ti.com>
Subject: [PATCH] vb2: fix bytesused == 0 handling
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The original report from Nikhil was that if data_offset > 0 and bytesused == 0,
then the check in __verify_length() would fail, even though the spec says that
if bytes_used == 0, then it will be replaced by the actual length of the
buffer.

After digging into it a bit more I realized that there were several other
things wrong:

- in __verify_length() it would use the application-provided length value
  for USERPTR and the vb2 core length for other memory models, but it
  should have used the application-provided length as well for DMABUF.

- in __fill_vb2_buffer() on the other hand it would replace bytesused == 0
  by the application-provided length, even for MMAP buffers where the
  length is determined by the vb2 core.

- in __fill_vb2_buffer() it tries to figure out if all the planes have
  bytesused == 0 before it will decide to replace bytesused by length.
  However, the spec makes no such provision, and it makes for convoluted
  code. So just replace any bytesused == 0 by the proper length.
  The idea behind this was that you could use bytesused to signal empty
  planes, something that is currently not supported. But that is better
  done in the future by using one of the reserved fields in strucy v4l2_plane.

This patch fixes all these issues.

Regards,

	Hans

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Nikhil Devshatwar <nikhil.nd@ti.com>
Cc: Nikhil Devshatwar <nikhil.nd@ti.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 78 ++++++++++++++++----------------
 1 file changed, 38 insertions(+), 40 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 7c4489c..f255c14 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -576,6 +576,7 @@ static int __verify_planes_array(struct vb2_buffer *vb, const struct v4l2_buffer
 static int __verify_length(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 {
 	unsigned int length;
+	unsigned int bytesused;
 	unsigned int plane;
 
 	if (!V4L2_TYPE_IS_OUTPUT(b->type))
@@ -583,21 +584,24 @@ static int __verify_length(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 
 	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
 		for (plane = 0; plane < vb->num_planes; ++plane) {
-			length = (b->memory == V4L2_MEMORY_USERPTR)
+			length = (b->memory == V4L2_MEMORY_USERPTR ||
+				  b->memory == V4L2_MEMORY_DMABUF)
 			       ? b->m.planes[plane].length
 			       : vb->v4l2_planes[plane].length;
+			bytesused = b->m.planes[plane].bytesused
+				  ? b->m.planes[plane].bytesused : length;
 
 			if (b->m.planes[plane].bytesused > length)
 				return -EINVAL;
 
 			if (b->m.planes[plane].data_offset > 0 &&
-			    b->m.planes[plane].data_offset >=
-			    b->m.planes[plane].bytesused)
+			    b->m.planes[plane].data_offset >= bytesused)
 				return -EINVAL;
 		}
 	} else {
 		length = (b->memory == V4L2_MEMORY_USERPTR)
 		       ? b->length : vb->v4l2_planes[0].length;
+		bytesused = b->bytesused ? b->bytesused : length;
 
 		if (b->bytesused > length)
 			return -EINVAL;
@@ -1234,35 +1238,6 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
 	unsigned int plane;
 
 	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
-		/* Fill in driver-provided information for OUTPUT types */
-		if (V4L2_TYPE_IS_OUTPUT(b->type)) {
-			bool bytesused_is_used;
-
-			/* Check if bytesused == 0 for all planes */
-			for (plane = 0; plane < vb->num_planes; ++plane)
-				if (b->m.planes[plane].bytesused)
-					break;
-			bytesused_is_used = plane < vb->num_planes;
-
-			/*
-			 * Will have to go up to b->length when API starts
-			 * accepting variable number of planes.
-			 *
-			 * If bytesused_is_used is false, then fall back to the
-			 * full buffer size. In that case userspace clearly
-			 * never bothered to set it and it's a safe assumption
-			 * that they really meant to use the full plane sizes.
-			 */
-			for (plane = 0; plane < vb->num_planes; ++plane) {
-				struct v4l2_plane *pdst = &v4l2_planes[plane];
-				struct v4l2_plane *psrc = &b->m.planes[plane];
-
-				pdst->bytesused = bytesused_is_used ?
-					psrc->bytesused : psrc->length;
-				pdst->data_offset = psrc->data_offset;
-			}
-		}
-
 		if (b->memory == V4L2_MEMORY_USERPTR) {
 			for (plane = 0; plane < vb->num_planes; ++plane) {
 				v4l2_planes[plane].m.userptr =
@@ -1279,6 +1254,28 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
 					b->m.planes[plane].length;
 			}
 		}
+
+		/* Fill in driver-provided information for OUTPUT types */
+		if (V4L2_TYPE_IS_OUTPUT(b->type)) {
+			/*
+			 * Will have to go up to b->length when API starts
+			 * accepting variable number of planes.
+			 *
+			 * If bytesused == 0 for the output buffer, then fall
+			 * back to the full buffer size. In that case
+			 * userspace clearly never bothered to set it and
+			 * it's a safe assumption that they really meant to
+			 * use the full plane sizes.
+			 */
+			for (plane = 0; plane < vb->num_planes; ++plane) {
+				struct v4l2_plane *pdst = &v4l2_planes[plane];
+				struct v4l2_plane *psrc = &b->m.planes[plane];
+
+				pdst->bytesused = psrc->bytesused ?
+					psrc->bytesused : pdst->length;
+				pdst->data_offset = psrc->data_offset;
+			}
+		}
 	} else {
 		/*
 		 * Single-planar buffers do not use planes array,
@@ -1286,15 +1283,9 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
 		 * In videobuf we use our internal V4l2_planes struct for
 		 * single-planar buffers as well, for simplicity.
 		 *
-		 * If bytesused == 0, then fall back to the full buffer size
-		 * as that's a sensible default.
+		 * If bytesused == 0 for the output buffer, then fall back
+		 * to the full buffer size as that's a sensible default.
 		 */
-		if (V4L2_TYPE_IS_OUTPUT(b->type))
-			v4l2_planes[0].bytesused =
-				b->bytesused ? b->bytesused : b->length;
-		else
-			v4l2_planes[0].bytesused = 0;
-
 		if (b->memory == V4L2_MEMORY_USERPTR) {
 			v4l2_planes[0].m.userptr = b->m.userptr;
 			v4l2_planes[0].length = b->length;
@@ -1304,6 +1295,13 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
 			v4l2_planes[0].m.fd = b->m.fd;
 			v4l2_planes[0].length = b->length;
 		}
+
+		if (V4L2_TYPE_IS_OUTPUT(b->type))
+			v4l2_planes[0].bytesused = b->bytesused ?
+				b->bytesused : v4l2_planes[0].length;
+		else
+			v4l2_planes[0].bytesused = 0;
+
 	}
 
 	/* Zero flags that the vb2 core handles */
-- 
2.0.0

