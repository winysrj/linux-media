Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:55374 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbbJPG1w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Oct 2015 02:27:52 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NWA0204NVAALWD0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Fri, 16 Oct 2015 15:27:46 +0900 (KST)
From: Junghak Sung <jh1009.sung@samsung.com>
To: linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, pawel@osciak.com
Cc: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com, Junghak Sung <jh1009.sung@samsung.com>
Subject: [RFC PATCH v7 6/7] media: videobuf2: Refactor vb2_fileio_data and
 vb2_thread
Date: Fri, 16 Oct 2015 15:27:42 +0900
Message-id: <1444976863-3657-7-git-send-email-jh1009.sung@samsung.com>
In-reply-to: <1444976863-3657-1-git-send-email-jh1009.sung@samsung.com>
References: <1444976863-3657-1-git-send-email-jh1009.sung@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace v4l2-stuffs with common things in struct vb2_fileio_data and
vb2_thread().

Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
---
 drivers/media/v4l2-core/videobuf2-v4l2.c |  113 +++++++++++++++---------------
 1 file changed, 58 insertions(+), 55 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
index dabcb6d..ea5ab37 100644
--- a/drivers/media/v4l2-core/videobuf2-v4l2.c
+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
@@ -882,6 +882,15 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 }
 EXPORT_SYMBOL_GPL(vb2_poll);
 
+static void vb2_get_timestamp(struct timeval *tv)
+{
+	struct timespec ts;
+
+	ktime_get_ts(&ts);
+	tv->tv_sec = ts.tv_sec;
+	tv->tv_usec = ts.tv_nsec / NSEC_PER_USEC;
+}
+
 /**
  * struct vb2_fileio_buf - buffer context used by file io emulator
  *
@@ -921,9 +930,10 @@ struct vb2_fileio_buf {
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
@@ -976,6 +986,10 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 	if (fileio == NULL)
 		return -ENOMEM;
 
+	fileio->b = kzalloc(q->buf_struct_size, GFP_KERNEL);
+	if (fileio->b == NULL)
+		return -ENOMEM;
+
 	fileio->read_once = q->fileio_read_once;
 	fileio->write_immediately = q->fileio_write_immediately;
 
@@ -983,11 +997,11 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
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
 
@@ -1016,24 +1030,17 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
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
@@ -1056,8 +1063,8 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 	return ret;
 
 err_reqbufs:
-	fileio->req.count = 0;
-	vb2_core_reqbufs(q, fileio->req.memory, &fileio->req.count);
+	fileio->count = 0;
+	vb2_core_reqbufs(q, fileio->memory, &fileio->count);
 
 err_kfree:
 	q->fileio = NULL;
@@ -1076,8 +1083,9 @@ static int __vb2_cleanup_fileio(struct vb2_queue *q)
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
@@ -1130,24 +1138,21 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
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
@@ -1159,8 +1164,8 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
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
@@ -1199,6 +1204,8 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 	 * Queue next buffer if required.
 	 */
 	if (buf->pos == buf->size || (!read && fileio->write_immediately)) {
+		struct vb2_buffer *b = fileio->b;
+
 		/*
 		 * Check if this is the last buffer to read.
 		 */
@@ -1210,20 +1217,15 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
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
 		if (set_timestamp)
-			v4l2_get_timestamp(&fileio->b.timestamp);
-		ret = vb2_internal_qbuf(q, &fileio->b);
+			vb2_get_timestamp(&b->timestamp);
+		ret = vb2_core_qbuf(q, index, b);
 		dprintk(5, "vb2_dbuf result: %d\n", ret);
 		if (ret)
 			return ret;
@@ -1300,20 +1302,21 @@ static int vb2_thread(void *data)
 
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
@@ -1321,15 +1324,15 @@ static int vb2_thread(void *data)
 			break;
 		try_to_freeze();
 
-		vb = q->bufs[fileio->b.index];
-		if (!(fileio->b.flags & V4L2_BUF_FLAG_ERROR))
+		vb = q->bufs[b->index];
+		if (b->state == VB2_BUF_STATE_DONE)
 			if (threadio->fnc(vb, threadio->priv))
 				break;
 		call_void_qop(q, wait_finish, q);
 		if (set_timestamp)
-			v4l2_get_timestamp(&fileio->b.timestamp);
+			vb2_get_timestamp(&b->timestamp);
 		if (!threadio->stop)
-			ret = vb2_internal_qbuf(q, &fileio->b);
+			ret = vb2_core_qbuf(q, b->index, b);
 		call_void_qop(q, wait_prepare, q);
 		if (ret || threadio->stop)
 			break;
-- 
1.7.9.5

