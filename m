Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3391 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755334AbaDGNLn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Apr 2014 09:11:43 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv2 PATCH 11/13] vb2: allow read/write as long as the format is single planar
Date: Mon,  7 Apr 2014 15:11:10 +0200
Message-Id: <1396876272-18222-12-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1396876272-18222-1-git-send-email-hverkuil@xs4all.nl>
References: <1396876272-18222-1-git-send-email-hverkuil@xs4all.nl>
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
index ef7ef82..d33c69b 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -2610,6 +2610,7 @@ struct vb2_fileio_buf {
  */
 struct vb2_fileio_data {
 	struct v4l2_requestbuffers req;
+	struct v4l2_plane p;
 	struct v4l2_buffer b;
 	struct vb2_fileio_buf bufs[VIDEO_MAX_FRAME];
 	unsigned int cur_index;
@@ -2700,13 +2701,21 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 	 * Read mode requires pre queuing of all buffers.
 	 */
 	if (read) {
+		bool is_multiplanar = V4L2_TYPE_IS_MULTIPLANAR(q->type);
+
 		/*
 		 * Queue all buffers.
 		 */
 		for (i = 0; i < q->num_buffers; i++) {
 			struct v4l2_buffer *b = &fileio->b;
+
 			memset(b, 0, sizeof(*b));
 			b->type = q->type;
+			if (is_multiplanar) {
+				memset(&fileio->p, 0, sizeof(fileio->p));
+				b->m.planes = &fileio->p;
+				b->length = 1;
+			}
 			b->memory = q->memory;
 			b->index = i;
 			ret = vb2_internal_qbuf(q, b);
@@ -2774,6 +2783,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 {
 	struct vb2_fileio_data *fileio;
 	struct vb2_fileio_buf *buf;
+	bool is_multiplanar = V4L2_TYPE_IS_MULTIPLANAR(q->type);
 	bool set_timestamp = !read &&
 		(q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
 		V4L2_BUF_FLAG_TIMESTAMP_COPY;
@@ -2808,6 +2818,11 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 		memset(&fileio->b, 0, sizeof(fileio->b));
 		fileio->b.type = q->type;
 		fileio->b.memory = q->memory;
+		if (is_multiplanar) {
+			memset(&fileio->p, 0, sizeof(fileio->p));
+			fileio->b.m.planes = &fileio->p;
+			fileio->b.length = 1;
+		}
 		ret = vb2_internal_dqbuf(q, &fileio->b, nonblock);
 		dprintk(5, "vb2_dqbuf result: %d\n", ret);
 		if (ret)
@@ -2878,6 +2893,12 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 		fileio->b.memory = q->memory;
 		fileio->b.index = index;
 		fileio->b.bytesused = buf->pos;
+		if (is_multiplanar) {
+			memset(&fileio->p, 0, sizeof(fileio->p));
+			fileio->p.bytesused = buf->pos;
+			fileio->b.m.planes = &fileio->p;
+			fileio->b.length = 1;
+		}
 		if (set_timestamp)
 			v4l2_get_timestamp(&fileio->b.timestamp);
 		ret = vb2_internal_qbuf(q, &fileio->b);
-- 
1.9.1

