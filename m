Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:50175 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757012AbcLPBYA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 20:24:00 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Laura Abbott <labbott@redhat.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Samu Onkalo <samu.onkalo@intel.com>
Subject: [RFC v2 05/11] v4l2-core: Don't sync cache for a buffer if so requested
Date: Fri, 16 Dec 2016 03:24:19 +0200
Message-Id: <20161216012425.11179-6-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20161216012425.11179-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20161216012425.11179-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Samu Onkalo <samu.onkalo@intel.com>

The user may request to the driver (vb2) to skip the cache maintenance
operations in case the buffer does not need cache synchronisation, e.g. in
cases where the buffer is passed between hardware blocks without it being
touched by the CPU.

Also document that the prepare and finish vb2_mem_ops might not get called
every time the buffer ownership changes between the kernel and the user
space.

Signed-off-by: Samu Onkalo <samu.onkalo@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
Changes since v1:

- Add a no_cache_sync argument to vb2 core prepare/qbuf/dqbuf functions
  to get round the inability to access v4l2_buffer flags from vb2 core.
---
 drivers/media/v4l2-core/videobuf2-core.c | 101 +++++++++++++++++++++----------
 drivers/media/v4l2-core/videobuf2-v4l2.c |  14 ++++-
 include/media/videobuf2-core.h           |  23 ++++---
 3 files changed, 97 insertions(+), 41 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 15a83f338072..e5371ef213b0 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -189,6 +189,28 @@ static void __vb2_queue_cancel(struct vb2_queue *q);
 static void __enqueue_in_driver(struct vb2_buffer *vb);
 
 /**
+ * __mem_prepare_planes() - call finish mem op for all planes of the buffer
+ */
+static void __mem_prepare_planes(struct vb2_buffer *vb)
+{
+	unsigned int plane;
+
+	for (plane = 0; plane < vb->num_planes; ++plane)
+		call_void_memop(vb, prepare, vb->planes[plane].mem_priv);
+}
+
+/**
+ * __mem_finish_planes() - call finish mem op for all planes of the buffer
+ */
+static void __mem_finish_planes(struct vb2_buffer *vb)
+{
+	unsigned int plane;
+
+	for (plane = 0; plane < vb->num_planes; ++plane)
+		call_void_memop(vb, finish, vb->planes[plane].mem_priv);
+}
+
+/**
  * __vb2_buf_mem_alloc() - allocate video memory for the given buffer
  */
 static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
@@ -953,20 +975,29 @@ EXPORT_SYMBOL_GPL(vb2_discard_done);
 /**
  * __prepare_mmap() - prepare an MMAP buffer
  */
-static int __prepare_mmap(struct vb2_buffer *vb, const void *pb)
+static int __prepare_mmap(struct vb2_buffer *vb, const void *pb,
+			  bool no_cache_sync)
 {
-	int ret = 0;
+	int ret;
 
-	if (pb)
+	if (pb) {
 		ret = call_bufop(vb->vb2_queue, fill_vb2_buffer,
 				 vb, pb, vb->planes);
-	return ret ? ret : call_vb_qop(vb, buf_prepare, vb);
+		if (ret)
+			return ret;
+	}
+
+	if (!no_cache_sync)
+		__mem_prepare_planes(vb);
+
+	return call_vb_qop(vb, buf_prepare, vb);
 }
 
 /**
  * __prepare_userptr() - prepare a USERPTR buffer
  */
-static int __prepare_userptr(struct vb2_buffer *vb, const void *pb)
+static int __prepare_userptr(struct vb2_buffer *vb, const void *pb,
+			     bool no_cache_sync)
 {
 	struct vb2_plane planes[VB2_MAX_PLANES];
 	struct vb2_queue *q = vb->vb2_queue;
@@ -1056,6 +1087,11 @@ static int __prepare_userptr(struct vb2_buffer *vb, const void *pb)
 			dprintk(1, "buffer initialization failed\n");
 			goto err;
 		}
+
+		/* This is new buffer memory --- always synchronise cache. */
+		__mem_prepare_planes(vb);
+	} else if (!no_cache_sync) {
+		__mem_prepare_planes(vb);
 	}
 
 	ret = call_vb_qop(vb, buf_prepare, vb);
@@ -1083,7 +1119,8 @@ static int __prepare_userptr(struct vb2_buffer *vb, const void *pb)
 /**
  * __prepare_dmabuf() - prepare a DMABUF buffer
  */
-static int __prepare_dmabuf(struct vb2_buffer *vb, const void *pb)
+static int __prepare_dmabuf(struct vb2_buffer *vb, const void *pb,
+			    bool no_cache_sync)
 {
 	struct vb2_plane planes[VB2_MAX_PLANES];
 	struct vb2_queue *q = vb->vb2_queue;
@@ -1197,6 +1234,11 @@ static int __prepare_dmabuf(struct vb2_buffer *vb, const void *pb)
 			dprintk(1, "buffer initialization failed\n");
 			goto err;
 		}
+
+		/* This is new buffer memory --- always synchronise cache. */
+		__mem_prepare_planes(vb);
+	} else if (!no_cache_sync) {
+		__mem_prepare_planes(vb);
 	}
 
 	ret = call_vb_qop(vb, buf_prepare, vb);
@@ -1229,10 +1271,10 @@ static void __enqueue_in_driver(struct vb2_buffer *vb)
 	call_void_vb_qop(vb, buf_queue, vb);
 }
 
-static int __buf_prepare(struct vb2_buffer *vb, const void *pb)
+static int __buf_prepare(struct vb2_buffer *vb, const void *pb,
+			 bool no_cache_sync)
 {
 	struct vb2_queue *q = vb->vb2_queue;
-	unsigned int plane;
 	int ret;
 
 	if (q->error) {
@@ -1244,13 +1286,13 @@ static int __buf_prepare(struct vb2_buffer *vb, const void *pb)
 
 	switch (q->memory) {
 	case VB2_MEMORY_MMAP:
-		ret = __prepare_mmap(vb, pb);
+		ret = __prepare_mmap(vb, pb, no_cache_sync);
 		break;
 	case VB2_MEMORY_USERPTR:
-		ret = __prepare_userptr(vb, pb);
+		ret = __prepare_userptr(vb, pb, no_cache_sync);
 		break;
 	case VB2_MEMORY_DMABUF:
-		ret = __prepare_dmabuf(vb, pb);
+		ret = __prepare_dmabuf(vb, pb, no_cache_sync);
 		break;
 	default:
 		WARN(1, "Invalid queue type\n");
@@ -1263,16 +1305,13 @@ static int __buf_prepare(struct vb2_buffer *vb, const void *pb)
 		return ret;
 	}
 
-	/* sync buffers */
-	for (plane = 0; plane < vb->num_planes; ++plane)
-		call_void_memop(vb, prepare, vb->planes[plane].mem_priv);
-
 	vb->state = VB2_BUF_STATE_PREPARED;
 
 	return 0;
 }
 
-int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb)
+int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb,
+			 bool no_cache_sync)
 {
 	struct vb2_buffer *vb;
 	int ret;
@@ -1284,7 +1323,7 @@ int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb)
 		return -EINVAL;
 	}
 
-	ret = __buf_prepare(vb, pb);
+	ret = __buf_prepare(vb, pb, no_cache_sync);
 	if (ret)
 		return ret;
 
@@ -1360,7 +1399,8 @@ static int vb2_start_streaming(struct vb2_queue *q)
 	return ret;
 }
 
-int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
+int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
+		  bool no_cache_sync)
 {
 	struct vb2_buffer *vb;
 	int ret;
@@ -1369,7 +1409,7 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
 
 	switch (vb->state) {
 	case VB2_BUF_STATE_DEQUEUED:
-		ret = __buf_prepare(vb, pb);
+		ret = __buf_prepare(vb, pb, no_cache_sync);
 		if (ret)
 			return ret;
 		break;
@@ -1555,7 +1595,7 @@ EXPORT_SYMBOL_GPL(vb2_wait_for_all_buffers);
 /**
  * __vb2_dqbuf() - bring back the buffer to the DEQUEUED state
  */
-static void __vb2_dqbuf(struct vb2_buffer *vb)
+static void __vb2_dqbuf(struct vb2_buffer *vb, bool no_cache_sync)
 {
 	struct vb2_queue *q = vb->vb2_queue;
 	unsigned int i;
@@ -1566,9 +1606,8 @@ static void __vb2_dqbuf(struct vb2_buffer *vb)
 
 	vb->state = VB2_BUF_STATE_DEQUEUED;
 
-	/* sync buffers */
-	for (i = 0; i < vb->num_planes; ++i)
-		call_void_memop(vb, finish, vb->planes[i].mem_priv);
+	if (!no_cache_sync)
+		__mem_finish_planes(vb);
 
 	/* unmap DMABUF buffer */
 	if (q->memory == VB2_MEMORY_DMABUF)
@@ -1581,7 +1620,7 @@ static void __vb2_dqbuf(struct vb2_buffer *vb)
 }
 
 int vb2_core_dqbuf(struct vb2_queue *q, unsigned int *pindex, void *pb,
-		   bool nonblocking)
+		   bool nonblocking, bool no_cache_sync)
 {
 	struct vb2_buffer *vb = NULL;
 	int ret;
@@ -1618,7 +1657,7 @@ int vb2_core_dqbuf(struct vb2_queue *q, unsigned int *pindex, void *pb,
 	trace_vb2_dqbuf(q, vb);
 
 	/* go back to dequeued state */
-	__vb2_dqbuf(vb);
+	__vb2_dqbuf(vb, no_cache_sync);
 
 	dprintk(1, "dqbuf of buffer %d, with state %d\n",
 			vb->index, vb->state);
@@ -1692,7 +1731,7 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 			vb->state = VB2_BUF_STATE_PREPARED;
 			call_void_vb_qop(vb, buf_finish, vb);
 		}
-		__vb2_dqbuf(vb);
+		__vb2_dqbuf(vb, false);
 	}
 }
 
@@ -2240,7 +2279,7 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 		 * Queue all buffers.
 		 */
 		for (i = 0; i < q->num_buffers; i++) {
-			ret = vb2_core_qbuf(q, i, NULL);
+			ret = vb2_core_qbuf(q, i, NULL, false);
 			if (ret)
 				goto err_reqbufs;
 			fileio->bufs[i].queued = 1;
@@ -2343,7 +2382,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 		/*
 		 * Call vb2_dqbuf to get buffer back.
 		 */
-		ret = vb2_core_dqbuf(q, &index, NULL, nonblock);
+		ret = vb2_core_dqbuf(q, &index, NULL, nonblock, false);
 		dprintk(5, "vb2_dqbuf result: %d\n", ret);
 		if (ret)
 			return ret;
@@ -2419,7 +2458,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 
 		if (copy_timestamp)
 			b->timestamp = ktime_get_ns();
-		ret = vb2_core_qbuf(q, index, NULL);
+		ret = vb2_core_qbuf(q, index, NULL, false);
 		dprintk(5, "vb2_dbuf result: %d\n", ret);
 		if (ret)
 			return ret;
@@ -2505,7 +2544,7 @@ static int vb2_thread(void *data)
 		} else {
 			call_void_qop(q, wait_finish, q);
 			if (!threadio->stop)
-				ret = vb2_core_dqbuf(q, &index, NULL, 0);
+				ret = vb2_core_dqbuf(q, &index, NULL, 0, false);
 			call_void_qop(q, wait_prepare, q);
 			dprintk(5, "file io: vb2_dqbuf result: %d\n", ret);
 			if (!ret)
@@ -2522,7 +2561,7 @@ static int vb2_thread(void *data)
 		if (copy_timestamp)
 			vb->timestamp = ktime_get_ns();;
 		if (!threadio->stop)
-			ret = vb2_core_qbuf(q, vb->index, NULL);
+			ret = vb2_core_qbuf(q, vb->index, NULL, false);
 		call_void_qop(q, wait_prepare, q);
 		if (ret || threadio->stop)
 			break;
diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
index 3529849d2218..7e327ad6ef30 100644
--- a/drivers/media/v4l2-core/videobuf2-v4l2.c
+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
@@ -499,8 +499,11 @@ int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b)
 	}
 
 	ret = vb2_queue_or_prepare_buf(q, b, "prepare_buf");
+	if (ret)
+		return ret;
 
-	return ret ? ret : vb2_core_prepare_buf(q, b->index, b);
+	return vb2_core_prepare_buf(q, b->index, b,
+				    b->flags & V4L2_BUF_FLAG_NO_CACHE_SYNC);
 }
 EXPORT_SYMBOL_GPL(vb2_prepare_buf);
 
@@ -565,7 +568,11 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 	}
 
 	ret = vb2_queue_or_prepare_buf(q, b, "qbuf");
-	return ret ? ret : vb2_core_qbuf(q, b->index, b);
+	if (ret)
+		return ret;
+
+	return vb2_core_qbuf(q, b->index, b,
+			     b->flags & V4L2_BUF_FLAG_NO_CACHE_SYNC);
 }
 EXPORT_SYMBOL_GPL(vb2_qbuf);
 
@@ -583,7 +590,8 @@ int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
 		return -EINVAL;
 	}
 
-	ret = vb2_core_dqbuf(q, NULL, b, nonblocking);
+	ret = vb2_core_dqbuf(q, NULL, b, nonblocking,
+			     b->flags & V4L2_BUF_FLAG_NO_CACHE_SYNC);
 
 	/*
 	 *  After calling the VIDIOC_DQBUF V4L2_BUF_FLAG_DONE must be
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index ac5898a55fd9..bfad0588bb2b 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -83,10 +83,14 @@ struct vb2_threadio_data;
  *		dmabuf.
  * @unmap_dmabuf: releases access control to the dmabuf - allocator is notified
  *		  that this driver is done using the dmabuf for now.
- * @prepare:	called every time the buffer is passed from userspace to the
- *		driver, useful for cache synchronisation, optional.
- * @finish:	called every time the buffer is passed back from the driver
- *		to the userspace, also optional.
+ * @prepare:	Called on the plane when the buffer ownership is passed from
+ *		the user space to the kernel and the plane must be cache
+ *		syncronised. The V4L2_BUF_FLAG_NO_CACHE_SYNC buffer flag may
+ *		be used to skip this call. Optional.
+ * @finish:	Called on the plane when the buffer ownership is passed from
+ *		the kernel to the user space and the plane must be cache
+ *		syncronised. The V4L2_BUF_FLAG_NO_CACHE_SYNC buffer flag may
+ *		be used to skip this call. Optional.
  * @vaddr:	return a kernel virtual address to a given memory buffer
  *		associated with the passed private structure or NULL if no
  *		such mapping exists.
@@ -695,6 +699,7 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
  * @index:	id number of the buffer
  * @pb:		buffer structure passed from userspace to vidioc_prepare_buf
  *		handler in driver
+ * @no_cache_sync if true, skip cache synchronization
  *
  * Should be called from vidioc_prepare_buf ioctl handler of a driver.
  * The passed buffer should have been verified.
@@ -704,7 +709,8 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
  * The return values from this function are intended to be directly returned
  * from vidioc_prepare_buf handler in driver.
  */
-int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb);
+int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb,
+			 bool no_cache_sync);
 
 /**
  * vb2_core_qbuf() - Queue a buffer from userspace
@@ -713,6 +719,7 @@ int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb);
  * @index:	id number of the buffer
  * @pb:		buffer structure passed from userspace to vidioc_qbuf handler
  *		in driver
+ * @no_cache_sync if true, skip cache synchronization
  *
  * Should be called from vidioc_qbuf ioctl handler of a driver.
  * The passed buffer should have been verified.
@@ -727,7 +734,8 @@ int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb);
  * The return values from this function are intended to be directly returned
  * from vidioc_qbuf handler in driver.
  */
-int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb);
+int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
+		  bool no_cache_sync);
 
 /**
  * vb2_core_dqbuf() - Dequeue a buffer to the userspace
@@ -738,6 +746,7 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb);
  * @nonblocking: if true, this call will not sleep waiting for a buffer if no
  *		 buffers ready for dequeuing are present. Normally the driver
  *		 would be passing (file->f_flags & O_NONBLOCK) here
+ * @no_cache_sync if true, skip cache synchronization
  *
  * Should be called from vidioc_dqbuf ioctl handler of a driver.
  * The passed buffer should have been verified.
@@ -754,7 +763,7 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb);
  * from vidioc_dqbuf handler in driver.
  */
 int vb2_core_dqbuf(struct vb2_queue *q, unsigned int *pindex, void *pb,
-		   bool nonblocking);
+		   bool nonblocking, bool no_cache_sync);
 
 int vb2_core_streamon(struct vb2_queue *q, unsigned int type);
 int vb2_core_streamoff(struct vb2_queue *q, unsigned int type);
-- 
Regards,

Laurent Pinchart

