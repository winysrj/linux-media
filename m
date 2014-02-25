Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2417 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151AbaBYKEy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 05:04:54 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, s.nawrocki@samsung.com, m.szyprowski@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 14/20] vb2: allow read/write as long as the format is single planar
Date: Tue, 25 Feb 2014 11:04:19 +0100
Message-Id: <1393322665-29889-15-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1393322665-29889-1-git-send-email-hverkuil@xs4all.nl>
References: <1393322665-29889-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

It was impossible to read() or write() a frame if the queue type was multiplanar.
Even if the current format is single planar. Change this to just check whether
the number of planes is 1 or more.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 1dc1db8..52f38d0 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -576,6 +576,7 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
 		 * for it. The caller has already verified memory and size.
 		 */
 		b->length = vb->num_planes;
+		b->bytesused = 0;
 		memcpy(b->m.planes, vb->v4l2_planes,
 			b->length * sizeof(struct v4l2_plane));
 	} else {
@@ -2589,6 +2590,7 @@ struct vb2_fileio_buf {
  */
 struct vb2_fileio_data {
 	struct v4l2_requestbuffers req;
+	struct v4l2_plane p;
 	struct v4l2_buffer b;
 	struct vb2_fileio_buf bufs[VIDEO_MAX_FRAME];
 	unsigned int cur_index;
@@ -2683,8 +2685,16 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 		 */
 		for (i = 0; i < q->num_buffers; i++) {
 			struct v4l2_buffer *b = &fileio->b;
+
 			memset(b, 0, sizeof(*b));
 			b->type = q->type;
+			if (V4L2_TYPE_IS_MULTIPLANAR(q->type)) {
+				struct v4l2_plane *p = &fileio->p;
+
+				memset(p, 0, sizeof(*p));
+				b->m.planes = p;
+				b->length = 1;
+			}
 			b->memory = q->memory;
 			b->index = i;
 			ret = vb2_qbuf(q, b);
@@ -2784,6 +2794,11 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 		memset(&fileio->b, 0, sizeof(fileio->b));
 		fileio->b.type = q->type;
 		fileio->b.memory = q->memory;
+		if (V4L2_TYPE_IS_MULTIPLANAR(q->type)) {
+			memset(&fileio->p, 0, sizeof(fileio->p));
+			fileio->b.m.planes = &fileio->p;
+			fileio->b.length = 1;
+		}
 		ret = vb2_internal_dqbuf(q, &fileio->b, nonblock);
 		dprintk(5, "file io: vb2_dqbuf result: %d\n", ret);
 		if (ret)
@@ -2854,6 +2869,12 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 		fileio->b.memory = q->memory;
 		fileio->b.index = index;
 		fileio->b.bytesused = buf->pos;
+		if (V4L2_TYPE_IS_MULTIPLANAR(q->type)) {
+			memset(&fileio->p, 0, sizeof(fileio->p));
+			fileio->p.bytesused = buf->pos;
+			fileio->b.m.planes = &fileio->p;
+			fileio->b.length = 1;
+		}
 		ret = vb2_internal_qbuf(q, &fileio->b);
 		dprintk(5, "file io: vb2_dbuf result: %d\n", ret);
 		if (ret)
-- 
1.9.0

