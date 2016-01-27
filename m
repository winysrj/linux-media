Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:38835 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752884AbcA0ME4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2016 07:04:56 -0500
To: linux-media <linux-media@vger.kernel.org>
Cc: Junghak Sung <jh1009.sung@samsung.com>,
	Matthias Schwarzott <zzam@gentoo.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH for v4.5] vb2: fix nasty vb2_thread regression
Message-ID: <56A8B34A.7010606@xs4all.nl>
Date: Wed, 27 Jan 2016 13:08:42 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The vb2_thread implementation was made generic and was moved from
videobuf2-v4l2.c to videobuf2-core.c in commit af3bac1a. Unfortunately
that clearly was never tested since it broke read() causing NULL address
references.

The root cause was confused handling of vb2_buffer vs v4l2_buffer (the pb
pointer in various core functions).

The v4l2_buffer no longer exists after moving the code into the core and
it is no longer needed. However, the vb2_thread code passed a pointer to
a vb2_buffer to the core functions were a v4l2_buffer pointer was expected
and vb2_thread expected that the vb2_buffer fields would be filled in
correctly.

This is obviously wrong since v4l2_buffer != vb2_buffer. Note that the
pb pointer is a void pointer, so no type-checking took place.

This patch fixes this problem:

1) allow pb to be NULL for vb2_core_(d)qbuf. The vb2_thread code will use
   a NULL pointer here since they don't care about v4l2_buffer anyway.
2) let vb2_core_dqbuf pass back the index of the received buffer. This is
   all vb2_thread needs: this index is the index into the q->bufs array
   and vb2_thread just gets the vb2_buffer from there.
3) the fileio->b pointer (that originally contained a v4l2_buffer) is
   removed altogether since it is no longer needed.

Tested with vivid and the cobalt driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/v4l2-core/videobuf2-core.c | 95 +++++++++++++++-----------------
 drivers/media/v4l2-core/videobuf2-v4l2.c |  2 +-
 include/media/videobuf2-core.h           |  3 +-
 3 files changed, 46 insertions(+), 54 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index c5d49d7..b53e42c 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1063,8 +1063,11 @@ EXPORT_SYMBOL_GPL(vb2_discard_done);
  */
 static int __qbuf_mmap(struct vb2_buffer *vb, const void *pb)
 {
-	int ret = call_bufop(vb->vb2_queue, fill_vb2_buffer,
-			vb, pb, vb->planes);
+	int ret = 0;
+
+	if (pb)
+		ret = call_bufop(vb->vb2_queue, fill_vb2_buffer,
+				 vb, pb, vb->planes);
 	return ret ? ret : call_vb_qop(vb, buf_prepare, vb);
 }

@@ -1077,14 +1080,16 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const void *pb)
 	struct vb2_queue *q = vb->vb2_queue;
 	void *mem_priv;
 	unsigned int plane;
-	int ret;
+	int ret = 0;
 	enum dma_data_direction dma_dir =
 		q->is_output ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
 	bool reacquired = vb->planes[0].mem_priv == NULL;

 	memset(planes, 0, sizeof(planes[0]) * vb->num_planes);
 	/* Copy relevant information provided by the userspace */
-	ret = call_bufop(vb->vb2_queue, fill_vb2_buffer, vb, pb, planes);
+	if (pb)
+		ret = call_bufop(vb->vb2_queue, fill_vb2_buffer,
+				 vb, pb, planes);
 	if (ret)
 		return ret;

@@ -1192,14 +1197,16 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const void *pb)
 	struct vb2_queue *q = vb->vb2_queue;
 	void *mem_priv;
 	unsigned int plane;
-	int ret;
+	int ret = 0;
 	enum dma_data_direction dma_dir =
 		q->is_output ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
 	bool reacquired = vb->planes[0].mem_priv == NULL;

 	memset(planes, 0, sizeof(planes[0]) * vb->num_planes);
 	/* Copy relevant information provided by the userspace */
-	ret = call_bufop(vb->vb2_queue, fill_vb2_buffer, vb, pb, planes);
+	if (pb)
+		ret = call_bufop(vb->vb2_queue, fill_vb2_buffer,
+				 vb, pb, planes);
 	if (ret)
 		return ret;

@@ -1520,7 +1527,8 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
 	q->waiting_for_buffers = false;
 	vb->state = VB2_BUF_STATE_QUEUED;

-	call_void_bufop(q, copy_timestamp, vb, pb);
+	if (pb)
+		call_void_bufop(q, copy_timestamp, vb, pb);

 	trace_vb2_qbuf(q, vb);

@@ -1532,7 +1540,8 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
 		__enqueue_in_driver(vb);

 	/* Fill buffer information for the userspace */
-	call_void_bufop(q, fill_user_buffer, vb, pb);
+	if (pb)
+		call_void_bufop(q, fill_user_buffer, vb, pb);

 	/*
 	 * If streamon has been called, and we haven't yet called
@@ -1731,7 +1740,8 @@ static void __vb2_dqbuf(struct vb2_buffer *vb)
  * The return values from this function are intended to be directly returned
  * from vidioc_dqbuf handler in driver.
  */
-int vb2_core_dqbuf(struct vb2_queue *q, void *pb, bool nonblocking)
+int vb2_core_dqbuf(struct vb2_queue *q, unsigned int *pindex, void *pb,
+		   bool nonblocking)
 {
 	struct vb2_buffer *vb = NULL;
 	int ret;
@@ -1754,8 +1764,12 @@ int vb2_core_dqbuf(struct vb2_queue *q, void *pb, bool nonblocking)

 	call_void_vb_qop(vb, buf_finish, vb);

+	if (pindex)
+		*pindex = vb->index;
+
 	/* Fill buffer information for the userspace */
-	call_void_bufop(q, fill_user_buffer, vb, pb);
+	if (pb)
+		call_void_bufop(q, fill_user_buffer, vb, pb);

 	/* Remove from videobuf queue */
 	list_del(&vb->queued_entry);
@@ -1828,7 +1842,7 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 	 * that's done in dqbuf, but that's not going to happen when we
 	 * cancel the whole queue. Note: this code belongs here, not in
 	 * __vb2_dqbuf() since in vb2_internal_dqbuf() there is a critical
-	 * call to __fill_v4l2_buffer() after buf_finish(). That order can't
+	 * call to __fill_user_buffer() after buf_finish(). That order can't
 	 * be changed, so we can't move the buf_finish() to __vb2_dqbuf().
 	 */
 	for (i = 0; i < q->num_buffers; ++i) {
@@ -2357,7 +2371,6 @@ struct vb2_fileio_data {
 	unsigned int count;
 	unsigned int type;
 	unsigned int memory;
-	struct vb2_buffer *b;
 	struct vb2_fileio_buf bufs[VB2_MAX_FRAME];
 	unsigned int cur_index;
 	unsigned int initial_index;
@@ -2410,12 +2423,6 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 	if (fileio == NULL)
 		return -ENOMEM;

-	fileio->b = kzalloc(q->buf_struct_size, GFP_KERNEL);
-	if (fileio->b == NULL) {
-		kfree(fileio);
-		return -ENOMEM;
-	}
-
 	fileio->read_once = q->fileio_read_once;
 	fileio->write_immediately = q->fileio_write_immediately;

@@ -2460,13 +2467,7 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 		 * Queue all buffers.
 		 */
 		for (i = 0; i < q->num_buffers; i++) {
-			struct vb2_buffer *b = fileio->b;
-
-			memset(b, 0, q->buf_struct_size);
-			b->type = q->type;
-			b->memory = q->memory;
-			b->index = i;
-			ret = vb2_core_qbuf(q, i, b);
+			ret = vb2_core_qbuf(q, i, NULL);
 			if (ret)
 				goto err_reqbufs;
 			fileio->bufs[i].queued = 1;
@@ -2511,7 +2512,6 @@ static int __vb2_cleanup_fileio(struct vb2_queue *q)
 		q->fileio = NULL;
 		fileio->count = 0;
 		vb2_core_reqbufs(q, fileio->memory, &fileio->count);
-		kfree(fileio->b);
 		kfree(fileio);
 		dprintk(3, "file io emulator closed\n");
 	}
@@ -2539,7 +2539,8 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 	 * else is able to provide this information with the write() operation.
 	 */
 	bool copy_timestamp = !read && q->copy_timestamp;
-	int ret, index;
+	unsigned index;
+	int ret;

 	dprintk(3, "mode %s, offset %ld, count %zd, %sblocking\n",
 		read ? "read" : "write", (long)*ppos, count,
@@ -2564,22 +2565,20 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 	 */
 	index = fileio->cur_index;
 	if (index >= q->num_buffers) {
-		struct vb2_buffer *b = fileio->b;
+		struct vb2_buffer *b;

 		/*
 		 * Call vb2_dqbuf to get buffer back.
 		 */
-		memset(b, 0, q->buf_struct_size);
-		b->type = q->type;
-		b->memory = q->memory;
-		ret = vb2_core_dqbuf(q, b, nonblock);
+		ret = vb2_core_dqbuf(q, &index, NULL, nonblock);
 		dprintk(5, "vb2_dqbuf result: %d\n", ret);
 		if (ret)
 			return ret;
 		fileio->dq_count += 1;

-		fileio->cur_index = index = b->index;
+		fileio->cur_index = index;
 		buf = &fileio->bufs[index];
+		b = q->bufs[index];

 		/*
 		 * Get number of bytes filled by the driver
@@ -2630,7 +2629,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 	 * Queue next buffer if required.
 	 */
 	if (buf->pos == buf->size || (!read && fileio->write_immediately)) {
-		struct vb2_buffer *b = fileio->b;
+		struct vb2_buffer *b = q->bufs[index];

 		/*
 		 * Check if this is the last buffer to read.
@@ -2643,15 +2642,11 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 		/*
 		 * Call vb2_qbuf and give buffer to the driver.
 		 */
-		memset(b, 0, q->buf_struct_size);
-		b->type = q->type;
-		b->memory = q->memory;
-		b->index = index;
 		b->planes[0].bytesused = buf->pos;

 		if (copy_timestamp)
 			b->timestamp = ktime_get_ns();
-		ret = vb2_core_qbuf(q, index, b);
+		ret = vb2_core_qbuf(q, index, NULL);
 		dprintk(5, "vb2_dbuf result: %d\n", ret);
 		if (ret)
 			return ret;
@@ -2713,10 +2708,9 @@ static int vb2_thread(void *data)
 {
 	struct vb2_queue *q = data;
 	struct vb2_threadio_data *threadio = q->threadio;
-	struct vb2_fileio_data *fileio = q->fileio;
 	bool copy_timestamp = false;
-	int prequeue = 0;
-	int index = 0;
+	unsigned prequeue = 0;
+	unsigned index = 0;
 	int ret = 0;

 	if (q->is_output) {
@@ -2728,37 +2722,34 @@ static int vb2_thread(void *data)

 	for (;;) {
 		struct vb2_buffer *vb;
-		struct vb2_buffer *b = fileio->b;

 		/*
 		 * Call vb2_dqbuf to get buffer back.
 		 */
-		memset(b, 0, q->buf_struct_size);
-		b->type = q->type;
-		b->memory = q->memory;
 		if (prequeue) {
-			b->index = index++;
+			vb = q->bufs[index++];
 			prequeue--;
 		} else {
 			call_void_qop(q, wait_finish, q);
 			if (!threadio->stop)
-				ret = vb2_core_dqbuf(q, b, 0);
+				ret = vb2_core_dqbuf(q, &index, NULL, 0);
 			call_void_qop(q, wait_prepare, q);
 			dprintk(5, "file io: vb2_dqbuf result: %d\n", ret);
+			if (!ret)
+				vb = q->bufs[index];
 		}
 		if (ret || threadio->stop)
 			break;
 		try_to_freeze();

-		vb = q->bufs[b->index];
-		if (b->state == VB2_BUF_STATE_DONE)
+		if (vb->state == VB2_BUF_STATE_DONE)
 			if (threadio->fnc(vb, threadio->priv))
 				break;
 		call_void_qop(q, wait_finish, q);
 		if (copy_timestamp)
-			b->timestamp = ktime_get_ns();;
+			vb->timestamp = ktime_get_ns();;
 		if (!threadio->stop)
-			ret = vb2_core_qbuf(q, b->index, b);
+			ret = vb2_core_qbuf(q, vb->index, NULL);
 		call_void_qop(q, wait_prepare, q);
 		if (ret || threadio->stop)
 			break;
diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
index c9a2860..91f5521 100644
--- a/drivers/media/v4l2-core/videobuf2-v4l2.c
+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
@@ -625,7 +625,7 @@ static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b,
 		return -EINVAL;
 	}

-	ret = vb2_core_dqbuf(q, b, nonblocking);
+	ret = vb2_core_dqbuf(q, NULL, b, nonblocking);

 	return ret;
 }
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index ef03ae5..8a0f55b 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -533,7 +533,8 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
 		const unsigned int requested_sizes[]);
 int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb);
 int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb);
-int vb2_core_dqbuf(struct vb2_queue *q, void *pb, bool nonblocking);
+int vb2_core_dqbuf(struct vb2_queue *q, unsigned int *pindex, void *pb,
+		   bool nonblocking);

 int vb2_core_streamon(struct vb2_queue *q, unsigned int type);
 int vb2_core_streamoff(struct vb2_queue *q, unsigned int type);
-- 
2.6.1

