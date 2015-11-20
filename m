Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:54244 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1163044AbbKTQuJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Nov 2015 11:50:09 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, sakari.ailus@iki.fi, jh1009.sung@samsung.com,
	inki.dae@samsung.com, Geunyoung Kim <nenggun.kim@samsung.com>,
	Hans Verkuil <hansverk@cisco.com>
Subject: [PATCHv10 07/15] media: videobuf2: Refactor vb2_fileio_data and vb2_thread
Date: Fri, 20 Nov 2015 17:34:10 +0100
Message-Id: <1448037258-36305-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1448037258-36305-1-git-send-email-hverkuil@xs4all.nl>
References: <1448037258-36305-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Junghak Sung <jh1009.sung@samsung.com>

Replace v4l2-stuffs with common things in struct vb2_fileio_data and
vb2_thread().

Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Hans Verkuil <hansverk@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-v4l2.c | 104 +++++++++++++++----------------
 1 file changed, 49 insertions(+), 55 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
index 91728c1..9dff50f 100644
--- a/drivers/media/v4l2-core/videobuf2-v4l2.c
+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
@@ -959,9 +959,10 @@ struct vb2_fileio_buf {
  * or write function.
  */
 struct vb2_fileio_data {
-	struct v4l2_requestbuffers req;
-	struct v4l2_plane p;
-	struct v4l2_buffer b;
+	unsigned int count;
+	unsigned int type;
+	unsigned int memory;
+	struct vb2_buffer *b;
 	struct vb2_fileio_buf bufs[VB2_MAX_FRAME];
 	unsigned int cur_index;
 	unsigned int initial_index;
@@ -1014,6 +1015,10 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 	if (fileio == NULL)
 		return -ENOMEM;
 
+	fileio->b = kzalloc(q->buf_struct_size, GFP_KERNEL);
+	if (fileio->b == NULL)
+		return -ENOMEM;
+
 	fileio->read_once = q->fileio_read_once;
 	fileio->write_immediately = q->fileio_write_immediately;
 
@@ -1021,11 +1026,11 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 	 * Request buffers and use MMAP type to force driver
 	 * to allocate buffers by itself.
 	 */
-	fileio->req.count = count;
-	fileio->req.memory = VB2_MEMORY_MMAP;
-	fileio->req.type = q->type;
+	fileio->count = count;
+	fileio->memory = VB2_MEMORY_MMAP;
+	fileio->type = q->type;
 	q->fileio = fileio;
-	ret = vb2_core_reqbufs(q, fileio->req.memory, &fileio->req.count);
+	ret = vb2_core_reqbufs(q, fileio->memory, &fileio->count);
 	if (ret)
 		goto err_kfree;
 
@@ -1054,24 +1059,17 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 	 * Read mode requires pre queuing of all buffers.
 	 */
 	if (read) {
-		bool is_multiplanar = q->is_multiplanar;
-
 		/*
 		 * Queue all buffers.
 		 */
 		for (i = 0; i < q->num_buffers; i++) {
-			struct v4l2_buffer *b = &fileio->b;
+			struct vb2_buffer *b = fileio->b;
 
-			memset(b, 0, sizeof(*b));
+			memset(b, 0, q->buf_struct_size);
 			b->type = q->type;
-			if (is_multiplanar) {
-				memset(&fileio->p, 0, sizeof(fileio->p));
-				b->m.planes = &fileio->p;
-				b->length = 1;
-			}
 			b->memory = q->memory;
 			b->index = i;
-			ret = vb2_internal_qbuf(q, b);
+			ret = vb2_core_qbuf(q, i, b);
 			if (ret)
 				goto err_reqbufs;
 			fileio->bufs[i].queued = 1;
@@ -1094,8 +1092,8 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 	return ret;
 
 err_reqbufs:
-	fileio->req.count = 0;
-	vb2_core_reqbufs(q, fileio->req.memory, &fileio->req.count);
+	fileio->count = 0;
+	vb2_core_reqbufs(q, fileio->memory, &fileio->count);
 
 err_kfree:
 	q->fileio = NULL;
@@ -1114,8 +1112,9 @@ static int __vb2_cleanup_fileio(struct vb2_queue *q)
 	if (fileio) {
 		vb2_core_streamoff(q, q->type);
 		q->fileio = NULL;
-		fileio->req.count = 0;
-		vb2_reqbufs(q, &fileio->req);
+		fileio->count = 0;
+		vb2_core_reqbufs(q, fileio->memory, &fileio->count);
+		kfree(fileio->b);
 		kfree(fileio);
 		dprintk(3, "file io emulator closed\n");
 	}
@@ -1168,24 +1167,21 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 	 */
 	index = fileio->cur_index;
 	if (index >= q->num_buffers) {
+		struct vb2_buffer *b = fileio->b;
+
 		/*
 		 * Call vb2_dqbuf to get buffer back.
 		 */
-		memset(&fileio->b, 0, sizeof(fileio->b));
-		fileio->b.type = q->type;
-		fileio->b.memory = q->memory;
-		if (is_multiplanar) {
-			memset(&fileio->p, 0, sizeof(fileio->p));
-			fileio->b.m.planes = &fileio->p;
-			fileio->b.length = 1;
-		}
-		ret = vb2_internal_dqbuf(q, &fileio->b, nonblock);
+		memset(b, 0, q->buf_struct_size);
+		b->type = q->type;
+		b->memory = q->memory;
+		ret = vb2_core_dqbuf(q, b, nonblock);
 		dprintk(5, "vb2_dqbuf result: %d\n", ret);
 		if (ret)
 			return ret;
 		fileio->dq_count += 1;
 
-		fileio->cur_index = index = fileio->b.index;
+		fileio->cur_index = index = b->index;
 		buf = &fileio->bufs[index];
 
 		/*
@@ -1197,8 +1193,8 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 				 : vb2_plane_size(q->bufs[index], 0);
 		/* Compensate for data_offset on read in the multiplanar case. */
 		if (is_multiplanar && read &&
-		    fileio->b.m.planes[0].data_offset < buf->size) {
-			buf->pos = fileio->b.m.planes[0].data_offset;
+				b->planes[0].data_offset < buf->size) {
+			buf->pos = b->planes[0].data_offset;
 			buf->size -= buf->pos;
 		}
 	} else {
@@ -1237,6 +1233,8 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 	 * Queue next buffer if required.
 	 */
 	if (buf->pos == buf->size || (!read && fileio->write_immediately)) {
+		struct vb2_buffer *b = fileio->b;
+
 		/*
 		 * Check if this is the last buffer to read.
 		 */
@@ -1248,20 +1246,15 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 		/*
 		 * Call vb2_qbuf and give buffer to the driver.
 		 */
-		memset(&fileio->b, 0, sizeof(fileio->b));
-		fileio->b.type = q->type;
-		fileio->b.memory = q->memory;
-		fileio->b.index = index;
-		fileio->b.bytesused = buf->pos;
-		if (is_multiplanar) {
-			memset(&fileio->p, 0, sizeof(fileio->p));
-			fileio->p.bytesused = buf->pos;
-			fileio->b.m.planes = &fileio->p;
-			fileio->b.length = 1;
-		}
+		memset(b, 0, q->buf_struct_size);
+		b->type = q->type;
+		b->memory = q->memory;
+		b->index = index;
+		b->planes[0].bytesused = buf->pos;
+
 		if (copy_timestamp)
-			v4l2_get_timestamp(&fileio->b.timestamp);
-		ret = vb2_internal_qbuf(q, &fileio->b);
+			b->timestamp = ktime_get_ns();
+		ret = vb2_core_qbuf(q, index, b);
 		dprintk(5, "vb2_dbuf result: %d\n", ret);
 		if (ret)
 			return ret;
@@ -1338,20 +1331,21 @@ static int vb2_thread(void *data)
 
 	for (;;) {
 		struct vb2_buffer *vb;
+		struct vb2_buffer *b = fileio->b;
 
 		/*
 		 * Call vb2_dqbuf to get buffer back.
 		 */
-		memset(&fileio->b, 0, sizeof(fileio->b));
-		fileio->b.type = q->type;
-		fileio->b.memory = q->memory;
+		memset(b, 0, q->buf_struct_size);
+		b->type = q->type;
+		b->memory = q->memory;
 		if (prequeue) {
-			fileio->b.index = index++;
+			b->index = index++;
 			prequeue--;
 		} else {
 			call_void_qop(q, wait_finish, q);
 			if (!threadio->stop)
-				ret = vb2_internal_dqbuf(q, &fileio->b, 0);
+				ret = vb2_core_dqbuf(q, b, 0);
 			call_void_qop(q, wait_prepare, q);
 			dprintk(5, "file io: vb2_dqbuf result: %d\n", ret);
 		}
@@ -1359,15 +1353,15 @@ static int vb2_thread(void *data)
 			break;
 		try_to_freeze();
 
-		vb = q->bufs[fileio->b.index];
-		if (!(fileio->b.flags & V4L2_BUF_FLAG_ERROR))
+		vb = q->bufs[b->index];
+		if (b->state == VB2_BUF_STATE_DONE)
 			if (threadio->fnc(vb, threadio->priv))
 				break;
 		call_void_qop(q, wait_finish, q);
 		if (copy_timestamp)
-			v4l2_get_timestamp(&fileio->b.timestamp);
+			b->timestamp = ktime_get_ns();
 		if (!threadio->stop)
-			ret = vb2_internal_qbuf(q, &fileio->b);
+			ret = vb2_core_qbuf(q, b->index, b);
 		call_void_qop(q, wait_prepare, q);
 		if (ret || threadio->stop)
 			break;
-- 
2.6.2

