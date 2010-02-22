Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:59907 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747Ab0BVQKZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 11:10:25 -0500
Received: from eu_spt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KY900LBF3L80E@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 22 Feb 2010 16:10:20 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0KY900ILU3L7VX@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 22 Feb 2010 16:10:20 +0000 (GMT)
Date: Mon, 22 Feb 2010 17:10:08 +0100
From: Pawel Osciak <p.osciak@samsung.com>
Subject: [PATCH v1 3/4] v4l: videobuf: Add support for multi-plane buffers.
In-reply-to: <1266855010-2198-1-git-send-email-p.osciak@samsung.com>
To: linux-media@vger.kernel.org
Cc: p.osciak@samsung.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl, m-karicheri2@ti.com
Message-id: <1266855010-2198-4-git-send-email-p.osciak@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1266855010-2198-1-git-send-email-p.osciak@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for multiplanar buffers to videobuf core, dma-contig
and vmalloc memory types.

Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/videobuf-core.c       |  363 +++++++++++++++++++++++-----
 drivers/media/video/videobuf-dma-contig.c |  303 ++++++++++++++++++------
 drivers/media/video/videobuf-vmalloc.c    |  195 +++++++++++++---
 include/media/videobuf-core.h             |   59 +++--
 include/media/videobuf-dma-contig.h       |    3 +
 include/media/videobuf-vmalloc.h          |    2 +
 6 files changed, 723 insertions(+), 202 deletions(-)

diff --git a/drivers/media/video/videobuf-core.c b/drivers/media/video/videobuf-core.c
index bb0a1c8..7a5ed69 100644
--- a/drivers/media/video/videobuf-core.c
+++ b/drivers/media/video/videobuf-core.c
@@ -29,6 +29,10 @@
 	printk(KERN_ERR "magic mismatch: %x (expected %x)\n", is, should); \
 	BUG(); } } while (0)
 
+#define is_multiplane(vb)\
+	(vb->memory == V4L2_MEMORY_MULTI_MMAP\
+	 || vb->memory == V4L2_MEMORY_MULTI_USERPTR)
+
 static int debug;
 module_param(debug, int, 0644);
 
@@ -45,22 +49,24 @@ MODULE_LICENSE("GPL");
 #define CALL(q, f, arg...)						\
 	((q->int_ops->f) ? q->int_ops->f(arg) : 0)
 
-void *videobuf_alloc(struct videobuf_queue *q)
+void *videobuf_alloc(struct videobuf_queue *q, unsigned int num_planes)
 {
 	struct videobuf_buffer *vb;
 
 	BUG_ON(q->msize < sizeof(*vb));
+	BUG_ON(0 == num_planes);
 
 	if (!q->int_ops || !q->int_ops->alloc) {
 		printk(KERN_ERR "No specific ops defined!\n");
 		BUG();
 	}
 
-	vb = q->int_ops->alloc(q->msize);
+	vb = q->int_ops->alloc(q->msize, num_planes);
 
 	if (NULL != vb) {
 		init_waitqueue_head(&vb->done);
 		vb->magic     = MAGIC_BUFFER;
+		vb->num_planes = num_planes;
 	}
 
 	return vb;
@@ -106,6 +112,17 @@ void *videobuf_queue_to_vmalloc (struct videobuf_queue *q,
 }
 EXPORT_SYMBOL_GPL(videobuf_queue_to_vmalloc);
 
+void *videobuf_queue_plane_to_vmalloc(struct videobuf_queue *q,
+				      struct videobuf_buffer *buf,
+				      unsigned int plane)
+{
+	if (q->int_ops->plane_vmalloc)
+		return q->int_ops->plane_vmalloc(buf, plane);
+	else
+		return NULL;
+}
+EXPORT_SYMBOL_GPL(videobuf_queue_plane_to_vmalloc);
+
 /* --------------------------------------------------------------------- */
 
 
@@ -131,7 +148,8 @@ void videobuf_queue_core_init(struct videobuf_queue *q,
 	q->int_ops   = int_ops;
 
 	/* All buffer operations are mandatory */
-	BUG_ON(!q->ops->buf_setup);
+	BUG_ON(!q->ops->buf_negotiate);
+	BUG_ON(!q->ops->buf_setup_plane);
 	BUG_ON(!q->ops->buf_prepare);
 	BUG_ON(!q->ops->buf_queue);
 	BUG_ON(!q->ops->buf_release);
@@ -169,7 +187,7 @@ int videobuf_queue_is_busy(struct videobuf_queue *q)
 	for (i = 0; i < VIDEO_MAX_FRAME; i++) {
 		if (NULL == q->bufs[i])
 			continue;
-		if (q->bufs[i]->map) {
+		if (q->bufs[i]->mapped) {
 			dprintk(1, "busy: buffer #%d mapped\n", i);
 			return 1;
 		}
@@ -242,6 +260,8 @@ enum v4l2_field videobuf_next_field(struct videobuf_queue *q)
 static void videobuf_status(struct videobuf_queue *q, struct v4l2_buffer *b,
 			    struct videobuf_buffer *vb, enum v4l2_buf_type type)
 {
+	unsigned int i;
+
 	MAGIC_CHECK(vb->magic, MAGIC_BUFFER);
 	MAGIC_CHECK(q->int_ops->magic, MAGIC_QTYPE_OPS);
 
@@ -251,20 +271,50 @@ static void videobuf_status(struct videobuf_queue *q, struct v4l2_buffer *b,
 	b->memory   = vb->memory;
 	switch (b->memory) {
 	case V4L2_MEMORY_MMAP:
-		b->m.offset  = vb->boff;
-		b->length    = vb->bsize;
+		b->m.offset  = vb->planes[0].boff;
+		b->length    = vb->planes[0].bsize;
 		break;
 	case V4L2_MEMORY_USERPTR:
-		b->m.userptr = vb->baddr;
-		b->length    = vb->bsize;
+		b->m.userptr = vb->planes[0].baddr;
+		b->length    = vb->planes[0].bsize;
 		break;
 	case V4L2_MEMORY_OVERLAY:
-		b->m.offset  = vb->boff;
+		b->m.offset  = vb->planes[0].boff;
+		break;
+	case V4L2_MEMORY_MULTI_MMAP:
+		if (NULL == b->m.planes) {
+			dprintk(1, "Warning: buffer details not copied back "
+				   "as no planes array has been provided\n");
+			break;
+		}
+
+		BUG_ON(b->length < vb->num_planes);
+		b->length    = vb->num_planes;
+		for (i = 0; i < vb->num_planes; ++i) {
+			b->m.planes[i].m.offset  = vb->planes[i].boff;
+			b->m.planes[i].length    = vb->planes[i].bsize;
+			b->m.planes[i].bytesused = vb->planes[i].size;
+		}
+		break;
+	case V4L2_MEMORY_MULTI_USERPTR:
+		if (NULL == b->m.planes) {
+			dprintk(1, "Warning: buffer details not copied back "
+				   "as no planes array has been provided\n");
+			break;
+		}
+
+		BUG_ON(b->length < vb->num_planes);
+		b->length    = vb->num_planes;
+		for (i = 0; i < vb->num_planes; ++i) {
+			b->m.planes[i].m.userptr = vb->planes[i].baddr;
+			b->m.planes[i].length    = vb->planes[i].bsize;
+			b->m.planes[i].bytesused = vb->planes[i].size;
+		}
 		break;
 	}
 
 	b->flags    = 0;
-	if (vb->map)
+	if (vb->mapped)
 		b->flags |= V4L2_BUF_FLAG_MAPPED;
 
 	switch (vb->state) {
@@ -290,7 +340,8 @@ static void videobuf_status(struct videobuf_queue *q, struct v4l2_buffer *b,
 
 	b->field     = vb->field;
 	b->timestamp = vb->ts;
-	b->bytesused = vb->size;
+	/* TODO what to do with bytesused in the main buffer structure? */
+	b->bytesused = vb->planes[0].size;
 	b->sequence  = vb->field_count >> 1;
 }
 
@@ -305,7 +356,6 @@ static int __videobuf_mmap_free(struct videobuf_queue *q)
 
 	MAGIC_CHECK(q->int_ops->magic, MAGIC_QTYPE_OPS);
 
-
 	rc  = CALL(q, mmap_free, q);
 
 	q->is_mmapped = 0;
@@ -333,23 +383,83 @@ int videobuf_mmap_free(struct videobuf_queue *q)
 	return ret;
 }
 
-/* Locking: Caller holds q->vb_lock */
-int __videobuf_mmap_setup(struct videobuf_queue *q,
-			unsigned int bcount, unsigned int bsize,
-			enum v4l2_memory memory)
+static int buf_setup_planes(struct videobuf_queue *q, unsigned int num_planes,
+			    unsigned int *plane_sizes)
 {
 	unsigned int i;
+	int ret;
+
+	BUG_ON(NULL == plane_sizes);
+
+	dprintk(1, "%s num_planes: %u\n", __func__, num_planes);
+
+	for (i = 0; i < num_planes; ++i) {
+		ret = q->ops->buf_setup_plane(q, i, &plane_sizes[i]);
+		if (ret)
+			return ret;
+		plane_sizes[i] = PAGE_ALIGN(plane_sizes[i]);
+		dprintk(1, "%s %dth plane_size: %d\n",
+			__func__, i, plane_sizes[i]);
+	}
+
+	return 0;
+}
+
+static int verify_planes_array(struct videobuf_queue *q, struct v4l2_buffer *b)
+{
+	if (is_multiplane(q->bufs[b->index])) {
+		if (NULL == b->m.planes) {
+			/* Ioctl logic has not copied planes array
+			 * from userspace */
+			dprintk(1, "Multiplane buffer queried but "
+				   "planes array not provided\n");
+			return -EINVAL;
+		}
+
+		if (b->length != q->bufs[b->index]->num_planes) {
+			dprintk(1, "Incorrect planes array length, "
+				   "expected %d, got %d\n",
+				   q->bufs[b->index]->num_planes, b->length);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+/* Locking: Caller holds q->vb_lock */
+int __videobuf_mmap_setup(struct videobuf_queue *q, unsigned int bcount,
+			  unsigned int pcount, enum v4l2_memory memory)
+{
+	unsigned int i = 0;
+	unsigned int j;
 	int err;
+	size_t curr_off = 0;
+	unsigned int *plane_sizes;
 
 	MAGIC_CHECK(q->int_ops->magic, MAGIC_QTYPE_OPS);
+	BUG_ON(pcount < 1);
+
+	dprintk(1, "mmap setup: bcount: %d, pcount: %d, memory: %d\n",
+		bcount, pcount, memory);
 
 	err = __videobuf_mmap_free(q);
 	if (0 != err)
 		return err;
 
+	plane_sizes = kzalloc(pcount * sizeof(*plane_sizes), GFP_KERNEL);
+	if (NULL == plane_sizes)
+		return -ENOMEM;
+
+	err = buf_setup_planes(q, pcount, plane_sizes);
+	if (err) {
+		dprintk(1, "mmap setup: failed setting up planes\n");
+		goto done;
+	}
+
 	/* Allocate and initialize buffers */
 	for (i = 0; i < bcount; i++) {
-		q->bufs[i] = videobuf_alloc(q);
+		q->bufs[i] = videobuf_alloc(q, pcount);
 
 		if (q->bufs[i] == NULL)
 			break;
@@ -357,12 +467,31 @@ int __videobuf_mmap_setup(struct videobuf_queue *q,
 		q->bufs[i]->i      = i;
 		q->bufs[i]->input  = UNSET;
 		q->bufs[i]->memory = memory;
-		q->bufs[i]->bsize  = bsize;
+		q->bufs[i]->num_planes = pcount;
+
 		switch (memory) {
 		case V4L2_MEMORY_MMAP:
-			q->bufs[i]->boff = PAGE_ALIGN(bsize) * i;
+		case V4L2_MEMORY_MULTI_MMAP:
+			for (j = 0; j < pcount; ++j) {
+				q->bufs[i]->planes[j].boff = curr_off;
+				q->bufs[i]->planes[j].bsize = plane_sizes[j];
+				curr_off += plane_sizes[j];
+				dprintk(1, "%s: buf %d plane: %d: "
+					   "bsize: %d boff: %d\n",
+					   __func__, i, j,
+					   q->bufs[i]->planes[j].bsize,
+					   q->bufs[i]->planes[j].boff);
+			}
 			break;
 		case V4L2_MEMORY_USERPTR:
+		case V4L2_MEMORY_MULTI_USERPTR:
+			for (j = 0; j < pcount; ++j) {
+				q->bufs[i]->planes[j].bsize = plane_sizes[j];
+				dprintk(1, "%s: buf: %d plane: %d bsize: %d\n",
+					   __func__, i, j,
+					   q->bufs[i]->planes[j].bsize);
+			}
+			break;
 		case V4L2_MEMORY_OVERLAY:
 			/* nothing */
 			break;
@@ -370,21 +499,21 @@ int __videobuf_mmap_setup(struct videobuf_queue *q,
 	}
 
 	if (!i)
-		return -ENOMEM;
-
-	dprintk(1, "mmap setup: %d buffers, %d bytes each\n",
-		i, bsize);
+		err = -ENOMEM;
+	else
+		err = i;
 
-	return i;
+done:
+	kfree(plane_sizes);
+	return err;
 }
 
-int videobuf_mmap_setup(struct videobuf_queue *q,
-			unsigned int bcount, unsigned int bsize,
-			enum v4l2_memory memory)
+int videobuf_mmap_setup(struct videobuf_queue *q, unsigned int bcount,
+			unsigned int pcount, enum v4l2_memory memory)
 {
 	int ret;
 	mutex_lock(&q->vb_lock);
-	ret = __videobuf_mmap_setup(q, bcount, bsize, memory);
+	ret = __videobuf_mmap_setup(q, bcount, pcount, memory);
 	mutex_unlock(&q->vb_lock);
 	return ret;
 }
@@ -392,7 +521,7 @@ int videobuf_mmap_setup(struct videobuf_queue *q,
 int videobuf_reqbufs(struct videobuf_queue *q,
 		 struct v4l2_requestbuffers *req)
 {
-	unsigned int size, count;
+	unsigned int buf_count, plane_count;
 	int retval;
 
 	if (req->count < 1) {
@@ -402,7 +531,9 @@ int videobuf_reqbufs(struct videobuf_queue *q,
 
 	if (req->memory != V4L2_MEMORY_MMAP     &&
 	    req->memory != V4L2_MEMORY_USERPTR  &&
-	    req->memory != V4L2_MEMORY_OVERLAY) {
+	    req->memory != V4L2_MEMORY_OVERLAY  &&
+	    req->memory != V4L2_MEMORY_MULTI_MMAP &&
+	    req->memory != V4L2_MEMORY_MULTI_USERPTR) {
 		dprintk(1, "reqbufs: memory type invalid\n");
 		return -EINVAL;
 	}
@@ -425,16 +556,13 @@ int videobuf_reqbufs(struct videobuf_queue *q,
 		goto done;
 	}
 
-	count = req->count;
-	if (count > VIDEO_MAX_FRAME)
-		count = VIDEO_MAX_FRAME;
-	size = 0;
-	q->ops->buf_setup(q, &count, &size);
-	dprintk(1, "reqbufs: bufs=%d, size=0x%x [%u pages total]\n",
-		count, size,
-		(unsigned int)((count*PAGE_ALIGN(size))>>PAGE_SHIFT) );
+	buf_count = req->count;
+	if (buf_count > VIDEO_MAX_FRAME)
+		buf_count = VIDEO_MAX_FRAME;
+	q->ops->buf_negotiate(q, &buf_count, &plane_count);
+	dprintk(1, "reqbufs: bufs=%d, planes=%d\n", buf_count, plane_count);
 
-	retval = __videobuf_mmap_setup(q, count, size, req->memory);
+	retval = __videobuf_mmap_setup(q, buf_count, plane_count, req->memory);
 	if (retval < 0) {
 		dprintk(1, "reqbufs: mmap setup returned %d\n", retval);
 		goto done;
@@ -452,6 +580,7 @@ int videobuf_querybuf(struct videobuf_queue *q, struct v4l2_buffer *b)
 {
 	int ret = -EINVAL;
 
+
 	mutex_lock(&q->vb_lock);
 	if (unlikely(b->type != q->type)) {
 		dprintk(1, "querybuf: Wrong type.\n");
@@ -466,6 +595,10 @@ int videobuf_querybuf(struct videobuf_queue *q, struct v4l2_buffer *b)
 		goto done;
 	}
 
+	ret = verify_planes_array(q, b);
+	if (ret < 0)
+		goto done;
+
 	videobuf_status(q, b, q->bufs[b->index], q->type);
 
 	ret = 0;
@@ -474,6 +607,63 @@ done:
 	return ret;
 }
 
+static int multiusrptr_check_buf(struct videobuf_buffer *vb,
+				 struct v4l2_buffer *buf)
+{
+	unsigned int i;
+
+	BUG_ON(NULL == vb->planes);
+
+	if (buf->length != vb->num_planes) {
+		dprintk(1, "%s: wrong number of planes, should be %d\n",
+			__func__, vb->num_planes);
+		return -EINVAL;
+	}
+
+	for (i = 0; i < buf->length; ++i) {
+		dprintk(1, "%s: plane %d: addr %lu, size %u\n", __func__,
+			i, buf->m.planes[i].m.userptr, buf->m.planes[i].length);
+		if (buf->m.planes[i].length < vb->planes[i].bsize) {
+			dprintk(1, "%s: plane %u too small (%u < %u)\n",
+				__func__, i, buf->m.planes[i].length,
+				vb->planes[i].bsize);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+static void multiusrptr_set_addr(struct videobuf_buffer *vb,
+				 struct v4l2_buffer *buf)
+{
+	struct v4l2_plane *planes = buf->m.planes;
+	struct videobuf_plane *vb_planes = vb->planes;
+	unsigned int i;
+
+	BUG_ON(NULL == vb_planes);
+
+	for (i = 0; i < vb->num_planes; ++i)
+		vb_planes[i].baddr = planes[i].m.userptr;
+}
+
+static int multiusrptr_addr_match(struct videobuf_buffer *vb,
+				  struct v4l2_buffer *buf)
+{
+	struct v4l2_plane *planes = buf->m.planes;
+	struct videobuf_plane *vb_planes = vb->planes;
+	unsigned int i;
+
+	BUG_ON(NULL == vb_planes);
+
+	for (i = 0; i < vb->num_planes; ++i) {
+		if (vb_planes[i].baddr != planes[i].m.userptr)
+			return 0;
+	}
+
+	return 1;
+}
+
 int videobuf_qbuf(struct videobuf_queue *q,
 	      struct v4l2_buffer *b)
 {
@@ -484,7 +674,8 @@ int videobuf_qbuf(struct videobuf_queue *q,
 
 	MAGIC_CHECK(q->int_ops->magic, MAGIC_QTYPE_OPS);
 
-	if (b->memory == V4L2_MEMORY_MMAP)
+	if (b->memory == V4L2_MEMORY_MMAP ||
+	    b->memory == V4L2_MEMORY_MULTI_MMAP)
 		down_read(&current->mm->mmap_sem);
 
 	mutex_lock(&q->vb_lock);
@@ -529,24 +720,41 @@ int videobuf_qbuf(struct videobuf_queue *q,
 
 	switch (b->memory) {
 	case V4L2_MEMORY_MMAP:
-		if (0 == buf->baddr) {
-			dprintk(1, "qbuf: mmap requested "
-				   "but buffer addr is zero!\n");
+	case V4L2_MEMORY_MULTI_MMAP:
+		if (!buf->mapped) {
+			dprintk(1, "qbuf: mmap requested, but the buffer "
+				"has not been fully mapped!\n");
 			goto done;
 		}
 		break;
 	case V4L2_MEMORY_USERPTR:
-		if (b->length < buf->bsize) {
+		if (b->length < buf->planes[0].bsize) {
 			dprintk(1, "qbuf: buffer length is not enough\n");
 			goto done;
 		}
 		if (VIDEOBUF_NEEDS_INIT != buf->state &&
-		    buf->baddr != b->m.userptr)
+		    buf->planes[0].baddr != b->m.userptr)
 			q->ops->buf_release(q, buf);
-		buf->baddr = b->m.userptr;
+		buf->planes[0].baddr = b->m.userptr;
+		break;
+	case V4L2_MEMORY_MULTI_USERPTR:
+		/* Verify sizes of each plane */
+		retval = multiusrptr_check_buf(buf, b);
+		if (retval) {
+			dprintk(1, "qbuf: invalid buffer\n");
+			goto done;
+		}
+
+		/* Verify addresses and release if changed */
+		if (VIDEOBUF_NEEDS_INIT != buf->state &&
+		    !multiusrptr_addr_match(buf, b))
+			q->ops->buf_release(q, buf);
+
+		/* Set addresses again */
+		multiusrptr_set_addr(buf, b);
 		break;
 	case V4L2_MEMORY_OVERLAY:
-		buf->boff = b->m.offset;
+		buf->planes[0].boff = b->m.offset;
 		break;
 	default:
 		dprintk(1, "qbuf: wrong memory type\n");
@@ -574,7 +782,8 @@ int videobuf_qbuf(struct videobuf_queue *q,
  done:
 	mutex_unlock(&q->vb_lock);
 
-	if (b->memory == V4L2_MEMORY_MMAP)
+	if (b->memory == V4L2_MEMORY_MMAP ||
+	    b->memory == V4L2_MEMORY_MULTI_MMAP)
 		up_read(&current->mm->mmap_sem);
 
 	return retval;
@@ -651,11 +860,19 @@ int videobuf_dqbuf(struct videobuf_queue *q,
 {
 	struct videobuf_buffer *buf = NULL;
 	int retval;
+	unsigned long len;
+	void __user *usr_addr;
+
 
 	MAGIC_CHECK(q->int_ops->magic, MAGIC_QTYPE_OPS);
 
 	mutex_lock(&q->vb_lock);
 
+	/* There could be a verify_planes_array() call here to verify
+	 * that userspace has passed the array in the buffer, but it might be
+	 * too much to ask userspace to pass the array in each dqbuf call.
+	 */
+
 	retval = stream_next_buffer(q, &buf, nonblocking);
 	if (retval < 0) {
 		dprintk(1, "dqbuf: next_buffer error: %i\n", retval);
@@ -680,7 +897,16 @@ int videobuf_dqbuf(struct videobuf_queue *q,
 		goto done;
 	}
 	list_del(&buf->stream);
-	memset(b, 0, sizeof(*b));
+
+	if (is_multiplane(buf)) {
+		usr_addr = b->m.planes;
+		len = b->length;
+		memset(b, 0, sizeof(*b));
+		b->m.planes = usr_addr;
+		b->length = len;
+	} else {
+		memset(b, 0, sizeof(*b));
+	}
 	videobuf_status(q, b, buf, q->type);
 
  done:
@@ -747,14 +973,15 @@ static ssize_t videobuf_read_zerocopy(struct videobuf_queue *q,
 
 	MAGIC_CHECK(q->int_ops->magic, MAGIC_QTYPE_OPS);
 
+	/* TODO has yet to be adapted to mutliplanes */
 	/* setup stuff */
-	q->read_buf = videobuf_alloc(q);
+	q->read_buf = videobuf_alloc(q, 1);
 	if (NULL == q->read_buf)
 		return -ENOMEM;
 
 	q->read_buf->memory = V4L2_MEMORY_USERPTR;
-	q->read_buf->baddr  = (unsigned long)data;
-	q->read_buf->bsize  = count;
+	q->read_buf->planes[0].baddr  = (unsigned long)data;
+	q->read_buf->planes[0].bsize  = count;
 
 	field = videobuf_next_field(q);
 	retval = q->ops->buf_prepare(q, q->read_buf, field);
@@ -771,7 +998,7 @@ static ssize_t videobuf_read_zerocopy(struct videobuf_queue *q,
 		if (VIDEOBUF_ERROR == q->read_buf->state)
 			retval = -EIO;
 		else
-			retval = q->read_buf->size;
+			retval = q->read_buf->planes[0].size;
 	}
 
  done:
@@ -788,14 +1015,17 @@ ssize_t videobuf_read_one(struct videobuf_queue *q,
 {
 	enum v4l2_field field;
 	unsigned long flags = 0;
-	unsigned size = 0, nbufs = 1;
+	unsigned size = 0, nbufs = 1, nplanes;
 	int retval;
 
 	MAGIC_CHECK(q->int_ops->magic, MAGIC_QTYPE_OPS);
 
 	mutex_lock(&q->vb_lock);
 
-	q->ops->buf_setup(q, &nbufs, &size);
+	/* TODO read has yet to be verified for mutliplanes */
+	/*q->ops->buf_setup(q, &nbufs, &size);*/
+	q->ops->buf_negotiate(q, &nbufs, &nplanes);
+	q->ops->buf_setup_plane(q, 0, &size);
 
 	if (NULL == q->read_buf  &&
 	    count >= size        &&
@@ -810,13 +1040,13 @@ ssize_t videobuf_read_one(struct videobuf_queue *q,
 	if (NULL == q->read_buf) {
 		/* need to capture a new frame */
 		retval = -ENOMEM;
-		q->read_buf = videobuf_alloc(q);
+		q->read_buf = videobuf_alloc(q, 1);
 
 		dprintk(1, "video alloc=0x%p\n", q->read_buf);
 		if (NULL == q->read_buf)
 			goto done;
 		q->read_buf->memory = V4L2_MEMORY_USERPTR;
-		q->read_buf->bsize = count; /* preferred size */
+		q->read_buf->planes[0].bsize = count; /* preferred size */
 		field = videobuf_next_field(q);
 		retval = q->ops->buf_prepare(q, q->read_buf, field);
 
@@ -855,7 +1085,7 @@ ssize_t videobuf_read_one(struct videobuf_queue *q,
 		goto done;
 
 	q->read_off += retval;
-	if (q->read_off == q->read_buf->size) {
+	if (q->read_off == q->read_buf->planes[0].size) {
 		/* all data copied, cleanup */
 		q->ops->buf_release(q, q->read_buf);
 		kfree(q->read_buf);
@@ -872,17 +1102,20 @@ static int __videobuf_read_start(struct videobuf_queue *q)
 {
 	enum v4l2_field field;
 	unsigned long flags = 0;
-	unsigned int count = 0, size = 0;
+	unsigned int count = 0, size = 0, nplanes;
 	int err, i;
 
-	q->ops->buf_setup(q, &count, &size);
+	/*q->ops->buf_setup(q, &count, &size);*/
+	q->ops->buf_negotiate(q, &count, &nplanes);
+	q->ops->buf_setup_plane(q, 0, &size);
 	if (count < 2)
 		count = 2;
 	if (count > VIDEO_MAX_FRAME)
 		count = VIDEO_MAX_FRAME;
 	size = PAGE_ALIGN(size);
 
-	err = __videobuf_mmap_setup(q, count, size, V4L2_MEMORY_USERPTR);
+	/* TODO multiplane support */
+	err = __videobuf_mmap_setup(q, count, nplanes, V4L2_MEMORY_USERPTR);
 	if (err < 0)
 		return err;
 
@@ -1001,13 +1234,13 @@ ssize_t videobuf_read_stream(struct videobuf_queue *q,
 			q->read_off += rc;
 		} else {
 			/* some error */
-			q->read_off = q->read_buf->size;
+			q->read_off = q->read_buf->planes[0].size;
 			if (0 == retval)
 				retval = -EIO;
 		}
 
 		/* requeue buffer when done with copying */
-		if (q->read_off == q->read_buf->size) {
+		if (q->read_off == q->read_buf->planes[0].size) {
 			list_add_tail(&q->read_buf->stream,
 				      &q->stream);
 			spin_lock_irqsave(q->irqlock, flags);
@@ -1098,8 +1331,8 @@ int videobuf_cgmbuf(struct videobuf_queue *q,
 	mbuf->frames = req.count;
 	mbuf->size   = 0;
 	for (i = 0; i < mbuf->frames; i++) {
-		mbuf->offsets[i]  = q->bufs[i]->boff;
-		mbuf->size       += PAGE_ALIGN(q->bufs[i]->bsize);
+		mbuf->offsets[i]  = q->bufs[i]->planes[0].boff;
+		mbuf->size       += q->bufs[i]->planes[0].bsize;
 	}
 
 	return 0;
diff --git a/drivers/media/video/videobuf-dma-contig.c b/drivers/media/video/videobuf-dma-contig.c
index 22c0109..aaaa5de 100644
--- a/drivers/media/video/videobuf-dma-contig.c
+++ b/drivers/media/video/videobuf-dma-contig.c
@@ -9,6 +9,8 @@
  * Based on videobuf-vmalloc.c,
  * (c) 2007 Mauro Carvalho Chehab, <mchehab@infradead.org>
  *
+ * Adapted for multi-plane buffer support by Pawel Osciak <p.osciak@samsung.com>
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2
@@ -19,7 +21,6 @@
 #include <linux/mm.h>
 #include <linux/pagemap.h>
 #include <linux/dma-mapping.h>
-#include <linux/sched.h>
 #include <media/videobuf-dma-contig.h>
 
 struct videobuf_dma_contig_memory {
@@ -37,6 +38,11 @@ struct videobuf_dma_contig_memory {
 		BUG();							    \
 	}
 
+static int debug;
+#define dprintk(level, fmt, arg...) do {			\
+	if (debug >= level)					\
+	printk(KERN_DEBUG "vbuf: " fmt , ## arg); } while (0)
+
 static void
 videobuf_vm_open(struct vm_area_struct *vma)
 {
@@ -53,6 +59,7 @@ static void videobuf_vm_close(struct vm_area_struct *vma)
 	struct videobuf_mapping *map = vma->vm_private_data;
 	struct videobuf_queue *q = map->q;
 	int i;
+	unsigned int j;
 
 	dev_dbg(map->q->dev, "vm_close %p [count=%u,vma=%08lx-%08lx]\n",
 		map, map->count, vma->vm_start, vma->vm_end);
@@ -72,7 +79,12 @@ static void videobuf_vm_close(struct vm_area_struct *vma)
 			if (NULL == q->bufs[i])
 				continue;
 
-			if (q->bufs[i]->map != map)
+			for (j = 0; j < q->bufs[i]->num_planes; ++j)
+				if (q->bufs[i]->planes[j].map == map)
+					break;
+
+			if (q->bufs[i]->num_planes == j)
+				/* Not found yet */
 				continue;
 
 			mem = q->bufs[i]->priv;
@@ -83,6 +95,9 @@ static void videobuf_vm_close(struct vm_area_struct *vma)
 				   in order to do memory unmap.
 				 */
 
+				/* Mem for j-th plane in the array of
+				 * per-plane privs */
+				mem += j;
 				MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
 
 				/* vfree is not atomic - can't be
@@ -96,8 +111,9 @@ static void videobuf_vm_close(struct vm_area_struct *vma)
 				mem->vaddr = NULL;
 			}
 
-			q->bufs[i]->map   = NULL;
-			q->bufs[i]->baddr = 0;
+			q->bufs[i]->planes[j].map   = NULL;
+			q->bufs[i]->planes[j].baddr = 0;
+			q->bufs[i]->mapped = 0;
 		}
 
 		kfree(map);
@@ -119,8 +135,8 @@ static const struct vm_operations_struct videobuf_vm_ops = {
  */
 static void videobuf_dma_contig_user_put(struct videobuf_dma_contig_memory *mem)
 {
-	mem->is_userptr = 0;
 	mem->dma_handle = 0;
+	mem->is_userptr = 0;
 	mem->size = 0;
 }
 
@@ -134,90 +150,147 @@ static void videobuf_dma_contig_user_put(struct videobuf_dma_contig_memory *mem)
  *
  * Returns 0 if successful.
  */
-static int videobuf_dma_contig_user_get(struct videobuf_dma_contig_memory *mem,
-					struct videobuf_buffer *vb)
+static int videobuf_dma_contig_user_get(struct videobuf_buffer *vb)
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
+	struct videobuf_dma_contig_memory *mem;
+	struct videobuf_plane *plane;
 	unsigned long prev_pfn, this_pfn;
 	unsigned long pages_done, user_address;
-	unsigned int offset;
+	/*unsigned long baddr;*/
 	int ret;
+	unsigned int i;
 
-	offset = vb->baddr & ~PAGE_MASK;
-	mem->size = PAGE_ALIGN(vb->size + offset);
-	mem->is_userptr = 0;
 	ret = -EINVAL;
+	plane = vb->planes;
 
 	down_read(&mm->mmap_sem);
 
-	vma = find_vma(mm, vb->baddr);
-	if (!vma)
-		goto out_up;
+	mem = vb->priv;
+	for (i = 0; i < vb->num_planes; ++i) {
 
-	if ((vb->baddr + mem->size) > vma->vm_end)
-		goto out_up;
+		if (!plane->baddr)
+			goto out_up;
 
-	pages_done = 0;
-	prev_pfn = 0; /* kill warning */
-	user_address = vb->baddr;
+		mem->is_userptr = 0;
+		mem->size = PAGE_ALIGN(plane->bsize);
 
-	while (pages_done < (mem->size >> PAGE_SHIFT)) {
-		ret = follow_pfn(vma, user_address, &this_pfn);
-		if (ret)
-			break;
+		vma = find_vma(mm, plane->baddr);
+		if (!vma)
+			goto out_up;
 
-		if (pages_done == 0)
-			mem->dma_handle = (this_pfn << PAGE_SHIFT) + offset;
-		else if (this_pfn != (prev_pfn + 1))
-			ret = -EFAULT;
+		if ((plane->baddr + mem->size) > vma->vm_end) {
+			dprintk(1, "Plane %u won't fit into vma "
+				"baddr: %lu, vm_end: %lu\n",
+				i, plane->baddr, vma->vm_end);
+			goto out_up;
+		}
 
-		if (ret)
-			break;
+		pages_done = 0;
+		prev_pfn = 0; /* kill warning */
+		user_address = plane->baddr;
 
-		prev_pfn = this_pfn;
-		user_address += PAGE_SIZE;
-		pages_done++;
-	}
+		while (pages_done < (mem->size >> PAGE_SHIFT)) {
+			ret = follow_pfn(vma, user_address, &this_pfn);
+			if (ret)
+				/*break;*/
+				goto out_up;
+
+			if (pages_done == 0)
+				mem->dma_handle = this_pfn << PAGE_SHIFT;
+			else if (this_pfn != (prev_pfn + 1))
+				ret = -EFAULT;
 
-	if (!ret)
-		mem->is_userptr = 1;
+			if (ret)
+				/*break;*/
+				goto out_up;
+
+			prev_pfn = this_pfn;
+			user_address += PAGE_SIZE;
+			pages_done++;
+		}
 
- out_up:
+		if (!ret)
+			mem->is_userptr = 1;
+
+		++mem;
+		++plane;
+	}
+
+out_up:
 	up_read(&current->mm->mmap_sem);
 
 	return ret;
 }
 
-static void *__videobuf_alloc(size_t size)
+static void *__videobuf_alloc(size_t size, unsigned int num_planes)
 {
 	struct videobuf_dma_contig_memory *mem;
 	struct videobuf_buffer *vb;
+	unsigned int i;
 
-	vb = kzalloc(size + sizeof(*mem), GFP_KERNEL);
-	if (vb) {
-		mem = vb->priv = ((char *)vb) + size;
+	vb = kzalloc(size, GFP_KERNEL);
+	if (!vb)
+		return vb;
+
+	/* At least one plane of memory is always needed */
+	vb->planes = kzalloc(sizeof(struct videobuf_plane) * num_planes,
+			     GFP_KERNEL);
+	if (!vb->planes)
+		goto free_vb;
+
+	mem = vb->priv = kzalloc(sizeof(*mem) * num_planes, GFP_KERNEL);
+	if (!vb->priv)
+		goto free_planes;
+
+	for (i = 0; i < num_planes; ++i) {
 		mem->magic = MAGIC_DC_MEM;
+		++mem;
 	}
 
 	return vb;
+
+free_planes:
+	kfree(vb->planes);
+free_vb:
+	kfree(vb);
+	return NULL;
 }
 
-static void *__videobuf_to_vmalloc(struct videobuf_buffer *buf)
+/**
+ * __plane_to_vmalloc() - return vmalloc pointer to a plane
+ * @plane:	Plane number (starting at 0).
+ */
+static void *__plane_to_vmalloc(struct videobuf_buffer *buf, unsigned int plane)
 {
 	struct videobuf_dma_contig_memory *mem = buf->priv;
+	BUG_ON(NULL == buf->planes);
 
-	BUG_ON(!mem);
+	if (plane >= buf->num_planes)
+		return NULL;
+	mem += plane;
 	MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
 
 	return mem->vaddr;
 }
 
+/**
+ * __videobuf_to_vmalloc() - return vmalloc pointer to a 1-plane buffer
+ *
+ * Returns vmalloc pointer to the buffer (first plane).
+ */
+static void *__videobuf_to_vmalloc(struct videobuf_buffer *buf)
+{
+	return __plane_to_vmalloc(buf, 0);
+}
+
 static int __videobuf_iolock(struct videobuf_queue *q,
 			     struct videobuf_buffer *vb,
 			     struct v4l2_framebuffer *fbuf)
 {
 	struct videobuf_dma_contig_memory *mem = vb->priv;
+	unsigned int i;
 
 	BUG_ON(!mem);
 	MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
@@ -236,11 +309,13 @@ static int __videobuf_iolock(struct videobuf_queue *q,
 		dev_dbg(q->dev, "%s memory method USERPTR\n", __func__);
 
 		/* handle pointer from user space */
-		if (vb->baddr)
-			return videobuf_dma_contig_user_get(mem, vb);
+		if (vb->planes[0].baddr)
+			/*return videobuf_dma_contig_user_get(mem, vb);*/
+			return videobuf_dma_contig_user_get(vb);
 
+		/* TODO multiplanes */
 		/* allocate memory for the read() method */
-		mem->size = PAGE_ALIGN(vb->size);
+		mem->size = PAGE_ALIGN(vb->planes[0].size);
 		mem->vaddr = dma_alloc_coherent(q->dev, mem->size,
 						&mem->dma_handle, GFP_KERNEL);
 		if (!mem->vaddr) {
@@ -252,6 +327,36 @@ static int __videobuf_iolock(struct videobuf_queue *q,
 		dev_dbg(q->dev, "dma_alloc_coherent data is at %p (%ld)\n",
 			mem->vaddr, mem->size);
 		break;
+	case V4L2_MEMORY_MULTI_MMAP:
+		dev_dbg(q->dev, "%s memory method MULTI_MMAP\n", __func__);
+		BUG_ON(NULL == vb->planes);
+
+		for (i = 0; i < vb->num_planes; ++i) {
+			MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
+			if (!mem->vaddr) {
+				dev_err(q->dev, "plane %d memory is not "
+					"alloced/mmapped\n", i);
+				return -EINVAL;
+			}
+			++mem;
+		}
+		break;
+	case V4L2_MEMORY_MULTI_USERPTR:
+		dev_dbg(q->dev, "%s memory method MULTI_USERPTR\n", __func__);
+		BUG_ON(NULL == vb->planes);
+
+		for (i = 0; i < vb->num_planes; ++i) {
+			MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
+			if (!vb->planes[i].baddr) {
+				dev_err(q->dev, "%s read() not implemented for "
+					"MUTLI_USERPTR\n", __func__);
+				return -EINVAL;
+			}
+			++mem;
+		}
+
+		return videobuf_dma_contig_user_get(vb);
+
 	case V4L2_MEMORY_OVERLAY:
 	default:
 		dev_dbg(q->dev, "%s memory method OVERLAY/unknown\n",
@@ -264,12 +369,16 @@ static int __videobuf_iolock(struct videobuf_queue *q,
 
 static int __videobuf_mmap_free(struct videobuf_queue *q)
 {
-	unsigned int i;
+	unsigned int i, j;
 
-	dev_dbg(q->dev, "%s\n", __func__);
 	for (i = 0; i < VIDEO_MAX_FRAME; i++) {
-		if (q->bufs[i] && q->bufs[i]->map)
-			return -EBUSY;
+		if (NULL == q->bufs[i])
+			continue;
+
+		for (j = 0; j < q->bufs[i]->num_planes; ++j) {
+			if (q->bufs[i]->planes[j].map)
+				return -EBUSY;
+		}
 	}
 
 	return 0;
@@ -280,7 +389,7 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
 {
 	struct videobuf_dma_contig_memory *mem;
 	struct videobuf_mapping *map;
-	unsigned int first;
+	unsigned int first, plane;
 	int retval;
 	unsigned long size, offset = vma->vm_pgoff << PAGE_SHIFT;
 
@@ -293,9 +402,16 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
 		if (!q->bufs[first])
 			continue;
 
-		if (V4L2_MEMORY_MMAP != q->bufs[first]->memory)
+		if (V4L2_MEMORY_MMAP != q->bufs[first]->memory &&
+		    V4L2_MEMORY_MULTI_MMAP != q->bufs[first]->memory)
 			continue;
-		if (q->bufs[first]->boff == offset)
+
+		for (plane = 0; plane < q->bufs[first]->num_planes; ++plane) {
+			if (q->bufs[first]->planes[plane].boff == offset)
+				break;
+		}
+
+		if (q->bufs[first]->num_planes != plane)
 			break;
 	}
 	if (VIDEO_MAX_FRAME == first) {
@@ -309,18 +425,19 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
 	if (!map)
 		return -ENOMEM;
 
-	q->bufs[first]->map = map;
+	q->bufs[first]->planes[plane].map = map;
 	map->start = vma->vm_start;
 	map->end = vma->vm_end;
 	map->q = q;
 
-	q->bufs[first]->baddr = vma->vm_start;
+	q->bufs[first]->planes[plane].baddr = vma->vm_start;
 
 	mem = q->bufs[first]->priv;
 	BUG_ON(!mem);
+	mem += plane;
 	MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
 
-	mem->size = PAGE_ALIGN(q->bufs[first]->bsize);
+	mem->size = PAGE_ALIGN(q->bufs[first]->planes[plane].bsize);
 	mem->vaddr = dma_alloc_coherent(q->dev, mem->size,
 					&mem->dma_handle, GFP_KERNEL);
 	if (!mem->vaddr) {
@@ -351,13 +468,22 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
 	vma->vm_flags       |= VM_DONTEXPAND;
 	vma->vm_private_data = map;
 
-	dev_dbg(q->dev, "mmap %p: q=%p %08lx-%08lx (%lx) pgoff %08lx buf %d\n",
+	dev_dbg(q->dev,
+		"mmap %p: q=%p %08lx-%08lx (%lx) pgoff %08lx buf %d plane %u\n",
 		map, q, vma->vm_start, vma->vm_end,
-		(long int) q->bufs[first]->bsize,
-		vma->vm_pgoff, first);
+		(long int) q->bufs[first]->planes[plane].bsize,
+		vma->vm_pgoff, first, plane);
 
 	videobuf_vm_open(vma);
 
+	/* Mark vb as mapped after all planes are mapped */
+	for (plane = 0; plane < q->bufs[first]->num_planes; ++plane) {
+		if (0 == q->bufs[first]->planes[plane].map)
+			break;
+	}
+	if (q->bufs[first]->num_planes == plane)
+		q->bufs[first]->mapped = 1;
+
 	return 0;
 
 error:
@@ -376,9 +502,10 @@ static int __videobuf_copy_to_user(struct videobuf_queue *q,
 	MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
 	BUG_ON(!mem->vaddr);
 
+	/* TODO multiplanes */
 	/* copy to userspace */
-	if (count > q->read_buf->size - q->read_off)
-		count = q->read_buf->size - q->read_off;
+	if (count > q->read_buf->planes[0].size - q->read_off)
+		count = q->read_buf->planes[0].size - q->read_off;
 
 	vaddr = mem->vaddr;
 
@@ -398,13 +525,14 @@ static int __videobuf_copy_stream(struct videobuf_queue *q,
 	BUG_ON(!mem);
 	MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
 
+	/* TODO multiplanes */
 	if (vbihack) {
 		/* dirty, undocumented hack -- pass the frame counter
 			* within the last four bytes of each vbi data block.
 			* We need that one to maintain backward compatibility
 			* to all vbi decoding software out there ... */
 		fc = (unsigned int *)mem->vaddr;
-		fc += (q->read_buf->size >> 2) - 1;
+		fc += (q->read_buf->planes[0].size >> 2) - 1;
 		*fc = q->read_buf->field_count >> 1;
 		dev_dbg(q->dev, "vbihack: %d\n", *fc);
 	}
@@ -428,6 +556,7 @@ static struct videobuf_qtype_ops qops = {
 	.video_copy_to_user = __videobuf_copy_to_user,
 	.copy_stream  = __videobuf_copy_stream,
 	.vmalloc      = __videobuf_to_vmalloc,
+	.plane_vmalloc = __plane_to_vmalloc,
 };
 
 void videobuf_queue_dma_contig_init(struct videobuf_queue *q,
@@ -455,34 +584,54 @@ dma_addr_t videobuf_to_dma_contig(struct videobuf_buffer *buf)
 }
 EXPORT_SYMBOL_GPL(videobuf_to_dma_contig);
 
-void videobuf_dma_contig_free(struct videobuf_queue *q,
-			      struct videobuf_buffer *buf)
+dma_addr_t videobuf_plane_to_dma_contig(struct videobuf_buffer *buf,
+					unsigned int plane)
 {
 	struct videobuf_dma_contig_memory *mem = buf->priv;
 
+	BUG_ON(!mem);
+
+	if (plane >= buf->num_planes)
+		return 0;
+
+	mem += plane;
+	MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
+
+	return mem->dma_handle;
+}
+EXPORT_SYMBOL_GPL(videobuf_plane_to_dma_contig);
+
+void videobuf_dma_contig_free(struct videobuf_queue *q,
+			      struct videobuf_buffer *vb)
+{
+	struct videobuf_dma_contig_memory *mem = vb->priv;
+	unsigned int i ;
+
 	/* mmapped memory can't be freed here, otherwise mmapped region
 	   would be released, while still needed. In this case, the memory
 	   release should happen inside videobuf_vm_close().
 	   So, it should free memory only if the memory were allocated for
 	   read() operation.
 	 */
-	if (buf->memory != V4L2_MEMORY_USERPTR)
-		return;
-
-	if (!mem)
+	if (vb->memory != V4L2_MEMORY_USERPTR
+	    && vb->memory != V4L2_MEMORY_MULTI_USERPTR)
 		return;
 
-	MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
-
-	/* handle user space pointer case */
-	if (buf->baddr) {
-		videobuf_dma_contig_user_put(mem);
-		return;
+	BUG_ON(!mem);
+	BUG_ON(!vb->planes);
+
+	for (i = 0; i < vb->num_planes; ++i) {
+		MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
+		if (vb->planes[i].baddr) {
+			videobuf_dma_contig_user_put(mem);
+		} else {
+			/* read() method */
+			dma_free_coherent(q->dev, mem->size,
+					  mem->vaddr, mem->dma_handle);
+			mem->vaddr = NULL;
+		}
+		++mem;
 	}
-
-	/* read() method */
-	dma_free_coherent(q->dev, mem->size, mem->vaddr, mem->dma_handle);
-	mem->vaddr = NULL;
 }
 EXPORT_SYMBOL_GPL(videobuf_dma_contig_free);
 
diff --git a/drivers/media/video/videobuf-vmalloc.c b/drivers/media/video/videobuf-vmalloc.c
index 136e093..64ca194 100644
--- a/drivers/media/video/videobuf-vmalloc.c
+++ b/drivers/media/video/videobuf-vmalloc.c
@@ -8,6 +8,8 @@
  *
  * (c) 2007 Mauro Carvalho Chehab, <mchehab@infradead.org>
  *
+ * Adapted for multi-plane buffer support by Pawel Osciak <p.osciak@samsung.com>
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2
@@ -62,6 +64,7 @@ static void videobuf_vm_close(struct vm_area_struct *vma)
 	struct videobuf_mapping *map = vma->vm_private_data;
 	struct videobuf_queue *q = map->q;
 	int i;
+	unsigned int j;
 
 	dprintk(2,"vm_close %p [count=%u,vma=%08lx-%08lx]\n", map,
 		map->count, vma->vm_start, vma->vm_end);
@@ -81,7 +84,12 @@ static void videobuf_vm_close(struct vm_area_struct *vma)
 			if (NULL == q->bufs[i])
 				continue;
 
-			if (q->bufs[i]->map != map)
+			for (j = 0; j < q->bufs[i]->num_planes; ++j)
+				if (q->bufs[i]->planes[j].map == map)
+					break;
+
+			if (q->bufs[i]->num_planes == j)
+				/* Not found yet */
 				continue;
 
 			mem = q->bufs[i]->priv;
@@ -92,6 +100,9 @@ static void videobuf_vm_close(struct vm_area_struct *vma)
 				   in order to do memory unmap.
 				 */
 
+				/* Mem for j-th plane in the array of
+				 * per-plane privs */
+				mem += j;
 				MAGIC_CHECK(mem->magic, MAGIC_VMAL_MEM);
 
 				/* vfree is not atomic - can't be
@@ -104,8 +115,9 @@ static void videobuf_vm_close(struct vm_area_struct *vma)
 				mem->vmalloc = NULL;
 			}
 
-			q->bufs[i]->map   = NULL;
-			q->bufs[i]->baddr = 0;
+			q->bufs[i]->planes[j].map   = NULL;
+			q->bufs[i]->planes[j].baddr = 0;
+			q->bufs[i]->mapped = 0;
 		}
 
 		kfree(map);
@@ -132,23 +144,43 @@ static const struct vm_operations_struct videobuf_vm_ops =
 	struct videobuf_dma_sg_memory
  */
 
-static void *__videobuf_alloc(size_t size)
+static void *__videobuf_alloc(size_t size, unsigned int num_planes)
 {
 	struct videobuf_vmalloc_memory *mem;
 	struct videobuf_buffer *vb;
+	unsigned int i;
 
-	vb = kzalloc(size+sizeof(*mem),GFP_KERNEL);
+	/*vb = kzalloc(size+sizeof(*mem),GFP_KERNEL);*/
+	vb = kzalloc(size, GFP_KERNEL);
 	if (!vb)
 		return vb;
 
-	mem = vb->priv = ((char *)vb)+size;
-	mem->magic=MAGIC_VMAL_MEM;
+	/* At least one plane of memory is always needed */
+	vb->planes = kzalloc(sizeof(struct videobuf_plane) * num_planes,
+			     GFP_KERNEL);
+	if (!vb->planes)
+		goto free_vb;
+
+	mem = vb->priv = kzalloc(sizeof(*mem) * num_planes, GFP_KERNEL);
+	if (!vb->priv)
+		goto free_planes;
+
+	for (i = 0; i < num_planes; ++i) {
+		mem->magic=MAGIC_VMAL_MEM;
+		++mem;
+	}
 
 	dprintk(1,"%s: allocated at %p(%ld+%ld) & %p(%ld)\n",
 		__func__,vb,(long)sizeof(*vb),(long)size-sizeof(*vb),
 		mem,(long)sizeof(*mem));
 
 	return vb;
+
+free_planes:
+	kfree(vb->planes);
+free_vb:
+	kfree(vb);
+	return NULL;
 }
 
 static int __videobuf_iolock (struct videobuf_queue* q,
@@ -157,6 +189,7 @@ static int __videobuf_iolock (struct videobuf_queue* q,
 {
 	struct videobuf_vmalloc_memory *mem = vb->priv;
 	int pages;
+	unsigned int i;
 
 	BUG_ON(!mem);
 
@@ -173,21 +206,17 @@ static int __videobuf_iolock (struct videobuf_queue* q,
 		}
 		break;
 	case V4L2_MEMORY_USERPTR:
-		pages = PAGE_ALIGN(vb->size);
-
 		dprintk(1, "%s memory method USERPTR\n", __func__);
-
 #if 1
-		if (vb->baddr) {
+		if (vb->planes[0].baddr) {
 			printk(KERN_ERR "USERPTR is currently not supported\n");
 			return -EINVAL;
 		}
 #endif
-
 		/* The only USERPTR currently supported is the one needed for
 		   read() method.
 		 */
-
+		pages = PAGE_ALIGN(vb->planes[0].size);
 		mem->vmalloc = vmalloc_user(pages);
 		if (!mem->vmalloc) {
 			printk(KERN_ERR "vmalloc (%d pages) failed\n", pages);
@@ -216,6 +245,59 @@ static int __videobuf_iolock (struct videobuf_queue* q,
 #endif
 
 		break;
+	case V4L2_MEMORY_MULTI_MMAP:
+		dprintk(1, "%s memory method MULTI_MMAP\n", __func__);
+		BUG_ON(NULL == vb->planes);
+
+		for (i = 0; i < vb->num_planes; ++i) {
+			MAGIC_CHECK(mem->magic, MAGIC_VMAL_MEM);
+			if (!mem->vmalloc) {
+				printk(KERN_ERR
+					"memory is not alloced/mmapped.\n");
+				return -EINVAL;
+			}
+			++mem;
+		}
+		break;
+	case V4L2_MEMORY_MULTI_USERPTR:
+		dprintk(1, "%s memory method MULTI_USERPTR\n", __func__);
+		BUG_ON(NULL == vb->planes);
+
+		for (i = 0; i < vb->num_planes; ++i) {
+			MAGIC_CHECK(mem->magic, MAGIC_VMAL_MEM);
+
+			if (vb->planes[i].baddr) {
+				printk(KERN_ERR
+					"USERPTR is currently not supported\n");
+				return -EINVAL;
+			}
+		}
+
+		/* The only USERPTR currently supported is the one needed for
+		   read() method.
+		 */
+		for (i = 0; i < vb->num_planes; ++i) {
+			pages = PAGE_ALIGN(vb->planes[i].size);
+
+			mem->vmalloc = vmalloc_user(pages);
+			if (!mem->vmalloc) {
+				printk(KERN_ERR
+					"vmalloc for plane %d (%d pages) "
+					"failed\n", i, pages);
+				while (i > 0) {
+					--mem;
+					vfree(mem->vmalloc);
+					mem->vmalloc = NULL;
+					--i;
+				}
+				return -ENOMEM;
+			}
+
+			dprintk(1, "vmalloc is at addr %p (%d pages)\n",
+				mem->vmalloc, pages);
+			++mem;
+		}
+		break;
 	case V4L2_MEMORY_OVERLAY:
 	default:
 		dprintk(1, "%s memory method OVERLAY/unknown\n", __func__);
@@ -236,12 +318,15 @@ static int __videobuf_sync(struct videobuf_queue *q,
 
 static int __videobuf_mmap_free(struct videobuf_queue *q)
 {
-	unsigned int i;
+	unsigned int i, j;
 
 	dprintk(1, "%s\n", __func__);
 	for (i = 0; i < VIDEO_MAX_FRAME; i++) {
-		if (q->bufs[i]) {
-			if (q->bufs[i]->map)
+		if (NULL == q->bufs[i])
+			continue;
+
+		for (j = 0; j < q->bufs[i]->num_planes; ++j) {
+			if (q->bufs[i]->planes[j].map)
 				return -EBUSY;
 		}
 	}
@@ -254,7 +339,7 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
 {
 	struct videobuf_vmalloc_memory *mem;
 	struct videobuf_mapping *map;
-	unsigned int first;
+	unsigned int first, plane;
 	int retval, pages;
 	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
 
@@ -267,9 +352,16 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
 		if (NULL == q->bufs[first])
 			continue;
 
-		if (V4L2_MEMORY_MMAP != q->bufs[first]->memory)
+		if (V4L2_MEMORY_MMAP != q->bufs[first]->memory &&
+		    V4L2_MEMORY_MULTI_MMAP != q->bufs[first]->memory)
 			continue;
-		if (q->bufs[first]->boff == offset)
+
+		for (plane = 0; plane < q->bufs[first]->num_planes; ++plane) {
+			if (q->bufs[first]->planes[plane].boff == offset)
+				break;
+		}
+
+		if (q->bufs[first]->num_planes != plane)
 			break;
 	}
 	if (VIDEO_MAX_FRAME == first) {
@@ -283,15 +375,16 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
 	if (NULL == map)
 		return -ENOMEM;
 
-	q->bufs[first]->map = map;
+	q->bufs[first]->planes[plane].map = map;
 	map->start = vma->vm_start;
 	map->end   = vma->vm_end;
 	map->q     = q;
 
-	q->bufs[first]->baddr = vma->vm_start;
+	q->bufs[first]->planes[plane].baddr = vma->vm_start;
 
 	mem = q->bufs[first]->priv;
 	BUG_ON(!mem);
+	mem += plane;
 	MAGIC_CHECK(mem->magic, MAGIC_VMAL_MEM);
 
 	pages = PAGE_ALIGN(vma->vm_end - vma->vm_start);
@@ -315,13 +408,21 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
 	vma->vm_flags       |= VM_DONTEXPAND | VM_RESERVED;
 	vma->vm_private_data = map;
 
-	dprintk(1,"mmap %p: q=%p %08lx-%08lx (%lx) pgoff %08lx buf %d\n",
-		map, q, vma->vm_start, vma->vm_end,
-		(long int) q->bufs[first]->bsize,
-		vma->vm_pgoff, first);
+	dprintk(1,"mmap %p: q=%p %08lx-%08lx (%lx) pgoff %08lx "
+		  "buf %d plane %u\n", map, q, vma->vm_start, vma->vm_end,
+		(long int) q->bufs[first]->planes[plane].bsize,
+		vma->vm_pgoff, first, plane);
 
 	videobuf_vm_open(vma);
 
+	/* Mark vb as mapped after all planes are mapped */
+	for (plane = 0; plane < q->bufs[first]->num_planes; ++plane) {
+		if (0 == q->bufs[first]->planes[plane].map)
+			break;
+	}
+	if (q->bufs[first]->num_planes == plane)
+		q->bufs[first]->mapped = 1;
+
 	return 0;
 
 error:
@@ -340,9 +441,10 @@ static int __videobuf_copy_to_user ( struct videobuf_queue *q,
 
 	BUG_ON (!mem->vmalloc);
 
+	/* TODO multiplanes */
 	/* copy to userspace */
-	if (count > q->read_buf->size - q->read_off)
-		count = q->read_buf->size - q->read_off;
+	if (count > q->read_buf->planes[0].size - q->read_off)
+		count = q->read_buf->planes[0].size - q->read_off;
 
 	if (copy_to_user(data, mem->vmalloc+q->read_off, count))
 		return -EFAULT;
@@ -359,13 +461,14 @@ static int __videobuf_copy_stream ( struct videobuf_queue *q,
 	BUG_ON (!mem);
 	MAGIC_CHECK(mem->magic,MAGIC_VMAL_MEM);
 
+	/* TODO multiplanes */
 	if (vbihack) {
 		/* dirty, undocumented hack -- pass the frame counter
 			* within the last four bytes of each vbi data block.
 			* We need that one to maintain backward compatibility
 			* to all vbi decoding software out there ... */
 		fc  = (unsigned int*)mem->vmalloc;
-		fc += (q->read_buf->size>>2) -1;
+		fc += (q->read_buf->planes[0].size>>2) -1;
 		*fc = q->read_buf->field_count >> 1;
 		dprintk(1,"vbihack: %d\n",*fc);
 	}
@@ -417,9 +520,28 @@ void *videobuf_to_vmalloc (struct videobuf_buffer *buf)
 }
 EXPORT_SYMBOL_GPL(videobuf_to_vmalloc);
 
+void *videobuf_plane_to_vmalloc(struct videobuf_buffer *buf, unsigned int plane)
+{
+	struct videobuf_vmalloc_memory *mem = buf->priv;
+	BUG_ON(!mem);
+
+	if (plane >= buf->num_planes) {
+		dprintk(1, "%s: invalid plane %d\n", __func__, plane);
+		return NULL;
+	}
+
+	mem += plane;
+	MAGIC_CHECK(mem->magic, MAGIC_VMAL_MEM);
+	dprintk(1, "%s: plane %d, vaddr: %p\n", __func__, plane, mem->vmalloc);
+
+	return mem->vmalloc;
+}
+EXPORT_SYMBOL_GPL(videobuf_plane_to_vmalloc);
+
 void videobuf_vmalloc_free (struct videobuf_buffer *buf)
 {
 	struct videobuf_vmalloc_memory *mem = buf->priv;
+	unsigned int i;
 
 	/* mmapped memory can't be freed here, otherwise mmapped region
 	   would be released, while still needed. In this case, the memory
@@ -427,18 +549,21 @@ void videobuf_vmalloc_free (struct videobuf_buffer *buf)
 	   So, it should free memory only if the memory were allocated for
 	   read() operation.
 	 */
-	if ((buf->memory != V4L2_MEMORY_USERPTR) || buf->baddr)
+	if ((buf->memory != V4L2_MEMORY_USERPTR
+	     && buf->memory != V4L2_MEMORY_MULTI_USERPTR)
+	    || buf->planes[0].baddr)
 		return;
 
 	if (!mem)
 		return;
+	BUG_ON(!buf->planes);
 
-	MAGIC_CHECK(mem->magic, MAGIC_VMAL_MEM);
-
-	vfree(mem->vmalloc);
-	mem->vmalloc = NULL;
-
-	return;
+	for (i = 0; i < buf->num_planes; ++i) {
+		MAGIC_CHECK(mem->magic, MAGIC_VMAL_MEM);
+		vfree(mem->vmalloc);
+		mem->vmalloc = NULL;
+		++mem;
+	}
 }
 EXPORT_SYMBOL_GPL(videobuf_vmalloc_free);
 
diff --git a/include/media/videobuf-core.h b/include/media/videobuf-core.h
index 316fdcc..9b617d2 100644
--- a/include/media/videobuf-core.h
+++ b/include/media/videobuf-core.h
@@ -59,6 +59,18 @@ struct videobuf_mapping {
 	struct videobuf_queue *q;
 };
 
+struct videobuf_plane {
+	u32			magic;
+	unsigned long		size;
+	size_t			bsize;
+	size_t			boff;
+	unsigned int		bytesperline;
+	/* For MULTI_USERPTR, userspace address */
+	unsigned long		baddr;
+
+	struct videobuf_mapping	*map;
+};
+
 enum videobuf_state {
 	VIDEOBUF_NEEDS_INIT = 0,
 	VIDEOBUF_PREPARED   = 1,
@@ -76,13 +88,14 @@ struct videobuf_buffer {
 	/* info about the buffer */
 	unsigned int            width;
 	unsigned int            height;
-	unsigned int            bytesperline; /* use only if != 0 */
-	unsigned long           size;
 	unsigned int            input;
 	enum v4l2_field         field;
 	enum videobuf_state     state;
 	struct list_head        stream;  /* QBUF/DQBUF list */
 
+	unsigned int		num_planes;
+	struct videobuf_plane	*planes;
+
 	/* touched by irq handler */
 	struct list_head        queue;
 	wait_queue_head_t       done;
@@ -92,26 +105,19 @@ struct videobuf_buffer {
 	/* Memory type */
 	enum v4l2_memory        memory;
 
-	/* buffer size */
-	size_t                  bsize;
-
-	/* buffer offset (mmap + overlay) */
-	size_t                  boff;
-
-	/* buffer addr (userland ptr!) */
-	unsigned long           baddr;
-
-	/* for mmap'ed buffers */
-	struct videobuf_mapping *map;
+	/* True if all planes are mapped (for MMAP only) */
+	int			mapped;
 
-	/* Private pointer to allow specific methods to store their data */
-	int			privsize;
+	/* Array of per-plane pointers to allow specific methods to store
+	 * their data */
 	void                    *priv;
 };
 
 struct videobuf_queue_ops {
-	int (*buf_setup)(struct videobuf_queue *q,
-			 unsigned int *count, unsigned int *size);
+	int (*buf_negotiate)(struct videobuf_queue *q, unsigned int *buf_count,
+			     unsigned int *plane_count);
+	int (*buf_setup_plane)(struct videobuf_queue *q, unsigned int plane,
+			       unsigned int *plane_size);
 	int (*buf_prepare)(struct videobuf_queue *q,
 			   struct videobuf_buffer *vb,
 			   enum v4l2_field field);
@@ -127,8 +133,10 @@ struct videobuf_queue_ops {
 struct videobuf_qtype_ops {
 	u32                     magic;
 
-	void *(*alloc)		(size_t size);
+	void *(*alloc)		(size_t size, unsigned int num_planes);
 	void *(*vmalloc)	(struct videobuf_buffer *buf);
+	void *(*plane_vmalloc)	(struct videobuf_buffer *buf,
+				 unsigned int plane);
 	int (*iolock)		(struct videobuf_queue* q,
 				 struct videobuf_buffer *vb,
 				 struct v4l2_framebuffer *fbuf);
@@ -188,11 +196,14 @@ int videobuf_waiton(struct videobuf_buffer *vb, int non_blocking, int intr);
 int videobuf_iolock(struct videobuf_queue* q, struct videobuf_buffer *vb,
 		struct v4l2_framebuffer *fbuf);
 
-void *videobuf_alloc(struct videobuf_queue* q);
+void *videobuf_alloc(struct videobuf_queue* q, unsigned int num_planes);
 
 /* Used on videobuf-dvb */
 void *videobuf_queue_to_vmalloc (struct videobuf_queue* q,
 				 struct videobuf_buffer *buf);
+void *videobuf_queue_plane_to_vmalloc(struct videobuf_queue *q,
+				      struct videobuf_buffer *buf,
+				      unsigned int plane);
 
 void videobuf_queue_core_init(struct videobuf_queue *q,
 			 const struct videobuf_queue_ops *ops,
@@ -235,12 +246,10 @@ unsigned int videobuf_poll_stream(struct file *file,
 				  struct videobuf_queue *q,
 				  poll_table *wait);
 
-int videobuf_mmap_setup(struct videobuf_queue *q,
-			unsigned int bcount, unsigned int bsize,
-			enum v4l2_memory memory);
-int __videobuf_mmap_setup(struct videobuf_queue *q,
-			unsigned int bcount, unsigned int bsize,
-			enum v4l2_memory memory);
+int videobuf_mmap_setup(struct videobuf_queue *q, unsigned int bcount,
+			unsigned int pcount, enum v4l2_memory memory);
+int __videobuf_mmap_setup(struct videobuf_queue *q, unsigned int bcount,
+			  unsigned int pcount, enum v4l2_memory memory);
 int videobuf_mmap_free(struct videobuf_queue *q);
 int videobuf_mmap_mapper(struct videobuf_queue *q,
 			 struct vm_area_struct *vma);
diff --git a/include/media/videobuf-dma-contig.h b/include/media/videobuf-dma-contig.h
index ebaa9bc..9dcda78 100644
--- a/include/media/videobuf-dma-contig.h
+++ b/include/media/videobuf-dma-contig.h
@@ -26,6 +26,9 @@ void videobuf_queue_dma_contig_init(struct videobuf_queue *q,
 				    void *priv);
 
 dma_addr_t videobuf_to_dma_contig(struct videobuf_buffer *buf);
+dma_addr_t videobuf_plane_to_dma_contig(struct videobuf_buffer *buf,
+					unsigned int plane);
+
 void videobuf_dma_contig_free(struct videobuf_queue *q,
 			      struct videobuf_buffer *buf);
 
diff --git a/include/media/videobuf-vmalloc.h b/include/media/videobuf-vmalloc.h
index 4b419a2..740aedd 100644
--- a/include/media/videobuf-vmalloc.h
+++ b/include/media/videobuf-vmalloc.h
@@ -39,6 +39,8 @@ void videobuf_queue_vmalloc_init(struct videobuf_queue* q,
 			 void *priv);
 
 void *videobuf_to_vmalloc (struct videobuf_buffer *buf);
+void *videobuf_plane_to_vmalloc(struct videobuf_buffer *buf,
+				unsigned int plane);
 
 void videobuf_vmalloc_free (struct videobuf_buffer *buf);
 
-- 
1.7.0.31.g1df487

