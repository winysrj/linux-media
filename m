Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:12391 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466Ab0CQHBN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Mar 2010 03:01:13 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from eu_spt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0KZE00FSQZHZIW10@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 17 Mar 2010 07:01:11 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0KZE00C6QZHYZB@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 17 Mar 2010 07:01:11 +0000 (GMT)
Date: Wed, 17 Mar 2010 08:01:04 +0100
From: Pawel Osciak <p.osciak@samsung.com>
Subject: [PATCH] v4l: videobuf: code cleanup.
To: linux-media@vger.kernel.org
Cc: p.osciak@samsung.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com
Message-id: <1268809264-11021-1-git-send-email-p.osciak@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make videobuf pass checkpatch; minor code cleanups.

Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/videobuf-core.c    |  116 ++++++-------
 drivers/media/video/videobuf-dma-sg.c  |  276 ++++++++++++++++----------------
 drivers/media/video/videobuf-vmalloc.c |  112 ++++++-------
 3 files changed, 246 insertions(+), 258 deletions(-)

diff --git a/drivers/media/video/videobuf-core.c b/drivers/media/video/videobuf-core.c
index bb0a1c8..37afb4e 100644
--- a/drivers/media/video/videobuf-core.c
+++ b/drivers/media/video/videobuf-core.c
@@ -24,10 +24,15 @@
 #include <media/videobuf-core.h>
 
 #define MAGIC_BUFFER 0x20070728
-#define MAGIC_CHECK(is, should) do {					   \
-	if (unlikely((is) != (should))) {				   \
-	printk(KERN_ERR "magic mismatch: %x (expected %x)\n", is, should); \
-	BUG(); } } while (0)
+#define MAGIC_CHECK(is, should)						\
+	do {								\
+		if (unlikely((is) != (should))) {			\
+			printk(KERN_ERR					\
+				"magic mismatch: %x (expected %x)\n",	\
+					is, should);			\
+			BUG();						\
+		}							\
+	} while (0)
 
 static int debug;
 module_param(debug, int, 0644);
@@ -36,9 +41,11 @@ MODULE_DESCRIPTION("helper module to manage video4linux buffers");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@infradead.org>");
 MODULE_LICENSE("GPL");
 
-#define dprintk(level, fmt, arg...) do {			\
-	if (debug >= level) 					\
-	printk(KERN_DEBUG "vbuf: " fmt , ## arg); } while (0)
+#define dprintk(level, fmt, arg...)					\
+	do {								\
+		if (debug >= level)					\
+			printk(KERN_DEBUG "vbuf: " fmt, ## arg);	\
+	} while (0)
 
 /* --------------------------------------------------------------------- */
 
@@ -57,14 +64,14 @@ void *videobuf_alloc(struct videobuf_queue *q)
 	}
 
 	vb = q->int_ops->alloc(q->msize);
-
 	if (NULL != vb) {
 		init_waitqueue_head(&vb->done);
-		vb->magic     = MAGIC_BUFFER;
+		vb->magic = MAGIC_BUFFER;
 	}
 
 	return vb;
 }
+EXPORT_SYMBOL_GPL(videobuf_alloc);
 
 #define WAITON_CONDITION (vb->state != VIDEOBUF_ACTIVE &&\
 				vb->state != VIDEOBUF_QUEUED)
@@ -86,6 +93,7 @@ int videobuf_waiton(struct videobuf_buffer *vb, int non_blocking, int intr)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(videobuf_waiton);
 
 int videobuf_iolock(struct videobuf_queue *q, struct videobuf_buffer *vb,
 		    struct v4l2_framebuffer *fbuf)
@@ -95,9 +103,10 @@ int videobuf_iolock(struct videobuf_queue *q, struct videobuf_buffer *vb,
 
 	return CALL(q, iolock, q, vb, fbuf);
 }
+EXPORT_SYMBOL_GPL(videobuf_iolock);
 
-void *videobuf_queue_to_vmalloc (struct videobuf_queue *q,
-			   struct videobuf_buffer *buf)
+void *videobuf_queue_to_vmalloc(struct videobuf_queue *q,
+				struct videobuf_buffer *buf)
 {
 	if (q->int_ops->vmalloc)
 		return q->int_ops->vmalloc(buf);
@@ -146,6 +155,7 @@ void videobuf_queue_core_init(struct videobuf_queue *q,
 	init_waitqueue_head(&q->wait);
 	INIT_LIST_HEAD(&q->stream);
 }
+EXPORT_SYMBOL_GPL(videobuf_queue_core_init);
 
 /* Locking: Only usage in bttv unsafe find way to remove */
 int videobuf_queue_is_busy(struct videobuf_queue *q)
@@ -184,6 +194,7 @@ int videobuf_queue_is_busy(struct videobuf_queue *q)
 	}
 	return 0;
 }
+EXPORT_SYMBOL_GPL(videobuf_queue_is_busy);
 
 /* Locking: Caller holds q->vb_lock */
 void videobuf_queue_cancel(struct videobuf_queue *q)
@@ -216,6 +227,7 @@ void videobuf_queue_cancel(struct videobuf_queue *q)
 	}
 	INIT_LIST_HEAD(&q->stream);
 }
+EXPORT_SYMBOL_GPL(videobuf_queue_cancel);
 
 /* --------------------------------------------------------------------- */
 
@@ -237,6 +249,7 @@ enum v4l2_field videobuf_next_field(struct videobuf_queue *q)
 	}
 	return field;
 }
+EXPORT_SYMBOL_GPL(videobuf_next_field);
 
 /* Locking: Caller holds q->vb_lock */
 static void videobuf_status(struct videobuf_queue *q, struct v4l2_buffer *b,
@@ -305,8 +318,7 @@ static int __videobuf_mmap_free(struct videobuf_queue *q)
 
 	MAGIC_CHECK(q->int_ops->magic, MAGIC_QTYPE_OPS);
 
-
-	rc  = CALL(q, mmap_free, q);
+	rc = CALL(q, mmap_free, q);
 
 	q->is_mmapped = 0;
 
@@ -332,6 +344,7 @@ int videobuf_mmap_free(struct videobuf_queue *q)
 	mutex_unlock(&q->vb_lock);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(videobuf_mmap_free);
 
 /* Locking: Caller holds q->vb_lock */
 int __videobuf_mmap_setup(struct videobuf_queue *q,
@@ -351,7 +364,7 @@ int __videobuf_mmap_setup(struct videobuf_queue *q,
 	for (i = 0; i < bcount; i++) {
 		q->bufs[i] = videobuf_alloc(q);
 
-		if (q->bufs[i] == NULL)
+		if (NULL == q->bufs[i])
 			break;
 
 		q->bufs[i]->i      = i;
@@ -372,11 +385,11 @@ int __videobuf_mmap_setup(struct videobuf_queue *q,
 	if (!i)
 		return -ENOMEM;
 
-	dprintk(1, "mmap setup: %d buffers, %d bytes each\n",
-		i, bsize);
+	dprintk(1, "mmap setup: %d buffers, %d bytes each\n", i, bsize);
 
 	return i;
 }
+EXPORT_SYMBOL_GPL(__videobuf_mmap_setup);
 
 int videobuf_mmap_setup(struct videobuf_queue *q,
 			unsigned int bcount, unsigned int bsize,
@@ -388,6 +401,7 @@ int videobuf_mmap_setup(struct videobuf_queue *q,
 	mutex_unlock(&q->vb_lock);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(videobuf_mmap_setup);
 
 int videobuf_reqbufs(struct videobuf_queue *q,
 		 struct v4l2_requestbuffers *req)
@@ -432,7 +446,7 @@ int videobuf_reqbufs(struct videobuf_queue *q,
 	q->ops->buf_setup(q, &count, &size);
 	dprintk(1, "reqbufs: bufs=%d, size=0x%x [%u pages total]\n",
 		count, size,
-		(unsigned int)((count*PAGE_ALIGN(size))>>PAGE_SHIFT) );
+		(unsigned int)((count * PAGE_ALIGN(size)) >> PAGE_SHIFT));
 
 	retval = __videobuf_mmap_setup(q, count, size, req->memory);
 	if (retval < 0) {
@@ -447,6 +461,7 @@ int videobuf_reqbufs(struct videobuf_queue *q,
 	mutex_unlock(&q->vb_lock);
 	return retval;
 }
+EXPORT_SYMBOL_GPL(videobuf_reqbufs);
 
 int videobuf_querybuf(struct videobuf_queue *q, struct v4l2_buffer *b)
 {
@@ -473,9 +488,9 @@ done:
 	mutex_unlock(&q->vb_lock);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(videobuf_querybuf);
 
-int videobuf_qbuf(struct videobuf_queue *q,
-	      struct v4l2_buffer *b)
+int videobuf_qbuf(struct videobuf_queue *q, struct v4l2_buffer *b)
 {
 	struct videobuf_buffer *buf;
 	enum v4l2_field field;
@@ -571,7 +586,7 @@ int videobuf_qbuf(struct videobuf_queue *q,
 	retval = 0;
 	wake_up_interruptible_sync(&q->wait);
 
- done:
+done:
 	mutex_unlock(&q->vb_lock);
 
 	if (b->memory == V4L2_MEMORY_MMAP)
@@ -579,7 +594,7 @@ int videobuf_qbuf(struct videobuf_queue *q,
 
 	return retval;
 }
-
+EXPORT_SYMBOL_GPL(videobuf_qbuf);
 
 /* Locking: Caller holds q->vb_lock */
 static int stream_next_buffer_check_queue(struct videobuf_queue *q, int noblock)
@@ -624,7 +639,6 @@ done:
 	return retval;
 }
 
-
 /* Locking: Caller holds q->vb_lock */
 static int stream_next_buffer(struct videobuf_queue *q,
 			struct videobuf_buffer **vb, int nonblocking)
@@ -647,7 +661,7 @@ done:
 }
 
 int videobuf_dqbuf(struct videobuf_queue *q,
-	       struct v4l2_buffer *b, int nonblocking)
+		   struct v4l2_buffer *b, int nonblocking)
 {
 	struct videobuf_buffer *buf = NULL;
 	int retval;
@@ -682,11 +696,11 @@ int videobuf_dqbuf(struct videobuf_queue *q,
 	list_del(&buf->stream);
 	memset(b, 0, sizeof(*b));
 	videobuf_status(q, b, buf, q->type);
-
- done:
+done:
 	mutex_unlock(&q->vb_lock);
 	return retval;
 }
+EXPORT_SYMBOL_GPL(videobuf_dqbuf);
 
 int videobuf_streamon(struct videobuf_queue *q)
 {
@@ -709,10 +723,11 @@ int videobuf_streamon(struct videobuf_queue *q)
 	spin_unlock_irqrestore(q->irqlock, flags);
 
 	wake_up_interruptible_sync(&q->wait);
- done:
+done:
 	mutex_unlock(&q->vb_lock);
 	return retval;
 }
+EXPORT_SYMBOL_GPL(videobuf_streamon);
 
 /* Locking: Caller holds q->vb_lock */
 static int __videobuf_streamoff(struct videobuf_queue *q)
@@ -735,6 +750,7 @@ int videobuf_streamoff(struct videobuf_queue *q)
 
 	return retval;
 }
+EXPORT_SYMBOL_GPL(videobuf_streamoff);
 
 /* Locking: Caller holds q->vb_lock */
 static ssize_t videobuf_read_zerocopy(struct videobuf_queue *q,
@@ -774,7 +790,7 @@ static ssize_t videobuf_read_zerocopy(struct videobuf_queue *q,
 			retval = q->read_buf->size;
 	}
 
- done:
+done:
 	/* cleanup */
 	q->ops->buf_release(q, q->read_buf);
 	kfree(q->read_buf);
@@ -862,10 +878,11 @@ ssize_t videobuf_read_one(struct videobuf_queue *q,
 		q->read_buf = NULL;
 	}
 
- done:
+done:
 	mutex_unlock(&q->vb_lock);
 	return retval;
 }
+EXPORT_SYMBOL_GPL(videobuf_read_one);
 
 /* Locking: Caller holds q->vb_lock */
 static int __videobuf_read_start(struct videobuf_queue *q)
@@ -917,7 +934,6 @@ static void __videobuf_read_stop(struct videobuf_queue *q)
 		q->bufs[i] = NULL;
 	}
 	q->read_buf = NULL;
-
 }
 
 int videobuf_read_start(struct videobuf_queue *q)
@@ -930,6 +946,7 @@ int videobuf_read_start(struct videobuf_queue *q)
 
 	return rc;
 }
+EXPORT_SYMBOL_GPL(videobuf_read_start);
 
 void videobuf_read_stop(struct videobuf_queue *q)
 {
@@ -937,6 +954,7 @@ void videobuf_read_stop(struct videobuf_queue *q)
 	__videobuf_read_stop(q);
 	mutex_unlock(&q->vb_lock);
 }
+EXPORT_SYMBOL_GPL(videobuf_read_stop);
 
 void videobuf_stop(struct videobuf_queue *q)
 {
@@ -950,7 +968,7 @@ void videobuf_stop(struct videobuf_queue *q)
 
 	mutex_unlock(&q->vb_lock);
 }
-
+EXPORT_SYMBOL_GPL(videobuf_stop);
 
 ssize_t videobuf_read_stream(struct videobuf_queue *q,
 			     char __user *data, size_t count, loff_t *ppos,
@@ -1019,10 +1037,11 @@ ssize_t videobuf_read_stream(struct videobuf_queue *q,
 			break;
 	}
 
- done:
+done:
 	mutex_unlock(&q->vb_lock);
 	return retval;
 }
+EXPORT_SYMBOL_GPL(videobuf_read_stream);
 
 unsigned int videobuf_poll_stream(struct file *file,
 				  struct videobuf_queue *q,
@@ -1062,9 +1081,9 @@ unsigned int videobuf_poll_stream(struct file *file,
 	mutex_unlock(&q->vb_lock);
 	return rc;
 }
+EXPORT_SYMBOL_GPL(videobuf_poll_stream);
 
-int videobuf_mmap_mapper(struct videobuf_queue *q,
-			 struct vm_area_struct *vma)
+int videobuf_mmap_mapper(struct videobuf_queue *q, struct vm_area_struct *vma)
 {
 	int retval;
 
@@ -1077,6 +1096,7 @@ int videobuf_mmap_mapper(struct videobuf_queue *q,
 
 	return retval;
 }
+EXPORT_SYMBOL_GPL(videobuf_mmap_mapper);
 
 #ifdef CONFIG_VIDEO_V4L1_COMPAT
 int videobuf_cgmbuf(struct videobuf_queue *q,
@@ -1107,33 +1127,3 @@ int videobuf_cgmbuf(struct videobuf_queue *q,
 EXPORT_SYMBOL_GPL(videobuf_cgmbuf);
 #endif
 
-/* --------------------------------------------------------------------- */
-
-EXPORT_SYMBOL_GPL(videobuf_waiton);
-EXPORT_SYMBOL_GPL(videobuf_iolock);
-
-EXPORT_SYMBOL_GPL(videobuf_alloc);
-
-EXPORT_SYMBOL_GPL(videobuf_queue_core_init);
-EXPORT_SYMBOL_GPL(videobuf_queue_cancel);
-EXPORT_SYMBOL_GPL(videobuf_queue_is_busy);
-
-EXPORT_SYMBOL_GPL(videobuf_next_field);
-EXPORT_SYMBOL_GPL(videobuf_reqbufs);
-EXPORT_SYMBOL_GPL(videobuf_querybuf);
-EXPORT_SYMBOL_GPL(videobuf_qbuf);
-EXPORT_SYMBOL_GPL(videobuf_dqbuf);
-EXPORT_SYMBOL_GPL(videobuf_streamon);
-EXPORT_SYMBOL_GPL(videobuf_streamoff);
-
-EXPORT_SYMBOL_GPL(videobuf_read_start);
-EXPORT_SYMBOL_GPL(videobuf_read_stop);
-EXPORT_SYMBOL_GPL(videobuf_stop);
-EXPORT_SYMBOL_GPL(videobuf_read_stream);
-EXPORT_SYMBOL_GPL(videobuf_read_one);
-EXPORT_SYMBOL_GPL(videobuf_poll_stream);
-
-EXPORT_SYMBOL_GPL(__videobuf_mmap_setup);
-EXPORT_SYMBOL_GPL(videobuf_mmap_setup);
-EXPORT_SYMBOL_GPL(videobuf_mmap_free);
-EXPORT_SYMBOL_GPL(videobuf_mmap_mapper);
diff --git a/drivers/media/video/videobuf-dma-sg.c b/drivers/media/video/videobuf-dma-sg.c
index fcd045e..c9d946a 100644
--- a/drivers/media/video/videobuf-dma-sg.c
+++ b/drivers/media/video/videobuf-dma-sg.c
@@ -37,8 +37,12 @@
 #define MAGIC_DMABUF 0x19721112
 #define MAGIC_SG_MEM 0x17890714
 
-#define MAGIC_CHECK(is,should)	if (unlikely((is) != (should))) \
-	{ printk(KERN_ERR "magic mismatch: %x (expected %x)\n",is,should); BUG(); }
+#define MAGIC_CHECK(is, should)						\
+	if (unlikely((is) != (should))) {				\
+		printk(KERN_ERR "magic mismatch: %x (expected %x)\n",	\
+				is, should);				\
+		BUG();							\
+	}
 
 static int debug;
 module_param(debug, int, 0644);
@@ -47,13 +51,13 @@ MODULE_DESCRIPTION("helper module to manage video4linux dma sg buffers");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@infradead.org>");
 MODULE_LICENSE("GPL");
 
-#define dprintk(level, fmt, arg...)	if (debug >= level) \
-	printk(KERN_DEBUG "vbuf-sg: " fmt , ## arg)
+#define dprintk(level, fmt, arg...)					\
+	if (debug >= level)						\
+		printk(KERN_DEBUG "vbuf-sg: " fmt , ## arg)
 
 /* --------------------------------------------------------------------- */
 
-struct scatterlist*
-videobuf_vmalloc_to_sg(unsigned char *virt, int nr_pages)
+struct scatterlist *videobuf_vmalloc_to_sg(unsigned char *virt, int nr_pages)
 {
 	struct scatterlist *sglist;
 	struct page *pg;
@@ -73,13 +77,14 @@ videobuf_vmalloc_to_sg(unsigned char *virt, int nr_pages)
 	}
 	return sglist;
 
- err:
+err:
 	vfree(sglist);
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(videobuf_vmalloc_to_sg);
 
-struct scatterlist*
-videobuf_pages_to_sg(struct page **pages, int nr_pages, int offset)
+struct scatterlist *videobuf_pages_to_sg(struct page **pages, int nr_pages,
+					 int offset)
 {
 	struct scatterlist *sglist;
 	int i;
@@ -104,20 +109,20 @@ videobuf_pages_to_sg(struct page **pages, int nr_pages, int offset)
 	}
 	return sglist;
 
- nopage:
-	dprintk(2,"sgl: oops - no page\n");
+nopage:
+	dprintk(2, "sgl: oops - no page\n");
 	vfree(sglist);
 	return NULL;
 
- highmem:
-	dprintk(2,"sgl: oops - highmem page\n");
+highmem:
+	dprintk(2, "sgl: oops - highmem page\n");
 	vfree(sglist);
 	return NULL;
 }
 
 /* --------------------------------------------------------------------- */
 
-struct videobuf_dmabuf *videobuf_to_dma (struct videobuf_buffer *buf)
+struct videobuf_dmabuf *videobuf_to_dma(struct videobuf_buffer *buf)
 {
 	struct videobuf_dma_sg_memory *mem = buf->priv;
 	BUG_ON(!mem);
@@ -126,17 +131,19 @@ struct videobuf_dmabuf *videobuf_to_dma (struct videobuf_buffer *buf)
 
 	return &mem->dma;
 }
+EXPORT_SYMBOL_GPL(videobuf_to_dma);
 
 void videobuf_dma_init(struct videobuf_dmabuf *dma)
 {
-	memset(dma,0,sizeof(*dma));
+	memset(dma, 0, sizeof(*dma));
 	dma->magic = MAGIC_DMABUF;
 }
+EXPORT_SYMBOL_GPL(videobuf_dma_init);
 
 static int videobuf_dma_init_user_locked(struct videobuf_dmabuf *dma,
 			int direction, unsigned long data, unsigned long size)
 {
-	unsigned long first,last;
+	unsigned long first, last;
 	int err, rw = 0;
 
 	dma->direction = direction;
@@ -155,21 +162,21 @@ static int videobuf_dma_init_user_locked(struct videobuf_dmabuf *dma,
 	last  = ((data+size-1) & PAGE_MASK) >> PAGE_SHIFT;
 	dma->offset   = data & ~PAGE_MASK;
 	dma->nr_pages = last-first+1;
-	dma->pages = kmalloc(dma->nr_pages * sizeof(struct page*),
-			     GFP_KERNEL);
+	dma->pages = kmalloc(dma->nr_pages * sizeof(struct page *), GFP_KERNEL);
 	if (NULL == dma->pages)
 		return -ENOMEM;
-	dprintk(1,"init user [0x%lx+0x%lx => %d pages]\n",
-		data,size,dma->nr_pages);
 
-	err = get_user_pages(current,current->mm,
+	dprintk(1, "init user [0x%lx+0x%lx => %d pages]\n",
+		data, size, dma->nr_pages);
+
+	err = get_user_pages(current, current->mm,
 			     data & PAGE_MASK, dma->nr_pages,
 			     rw == READ, 1, /* force */
 			     dma->pages, NULL);
 
 	if (err != dma->nr_pages) {
 		dma->nr_pages = (err >= 0) ? err : 0;
-		dprintk(1,"get_user_pages: err=%d [%d]\n",err,dma->nr_pages);
+		dprintk(1, "get_user_pages: err=%d [%d]\n", err, dma->nr_pages);
 		return err < 0 ? err : -EINVAL;
 	}
 	return 0;
@@ -179,48 +186,58 @@ int videobuf_dma_init_user(struct videobuf_dmabuf *dma, int direction,
 			   unsigned long data, unsigned long size)
 {
 	int ret;
+
 	down_read(&current->mm->mmap_sem);
 	ret = videobuf_dma_init_user_locked(dma, direction, data, size);
 	up_read(&current->mm->mmap_sem);
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(videobuf_dma_init_user);
 
 int videobuf_dma_init_kernel(struct videobuf_dmabuf *dma, int direction,
 			     int nr_pages)
 {
-	dprintk(1,"init kernel [%d pages]\n",nr_pages);
+	dprintk(1, "init kernel [%d pages]\n", nr_pages);
+
 	dma->direction = direction;
 	dma->vmalloc = vmalloc_32(nr_pages << PAGE_SHIFT);
 	if (NULL == dma->vmalloc) {
-		dprintk(1,"vmalloc_32(%d pages) failed\n",nr_pages);
+		dprintk(1, "vmalloc_32(%d pages) failed\n", nr_pages);
 		return -ENOMEM;
 	}
-	dprintk(1,"vmalloc is at addr 0x%08lx, size=%d\n",
+
+	dprintk(1, "vmalloc is at addr 0x%08lx, size=%d\n",
 				(unsigned long)dma->vmalloc,
 				nr_pages << PAGE_SHIFT);
-	memset(dma->vmalloc,0,nr_pages << PAGE_SHIFT);
+
+	memset(dma->vmalloc, 0, nr_pages << PAGE_SHIFT);
 	dma->nr_pages = nr_pages;
+
 	return 0;
 }
+EXPORT_SYMBOL_GPL(videobuf_dma_init_kernel);
 
 int videobuf_dma_init_overlay(struct videobuf_dmabuf *dma, int direction,
 			      dma_addr_t addr, int nr_pages)
 {
-	dprintk(1,"init overlay [%d pages @ bus 0x%lx]\n",
-		nr_pages,(unsigned long)addr);
+	dprintk(1, "init overlay [%d pages @ bus 0x%lx]\n",
+		nr_pages, (unsigned long)addr);
 	dma->direction = direction;
+
 	if (0 == addr)
 		return -EINVAL;
 
 	dma->bus_addr = addr;
 	dma->nr_pages = nr_pages;
+
 	return 0;
 }
+EXPORT_SYMBOL_GPL(videobuf_dma_init_overlay);
 
-int videobuf_dma_map(struct videobuf_queue* q, struct videobuf_dmabuf *dma)
+int videobuf_dma_map(struct videobuf_queue *q, struct videobuf_dmabuf *dma)
 {
-	MAGIC_CHECK(dma->magic,MAGIC_DMABUF);
+	MAGIC_CHECK(dma->magic, MAGIC_DMABUF);
 	BUG_ON(0 == dma->nr_pages);
 
 	if (dma->pages) {
@@ -228,20 +245,21 @@ int videobuf_dma_map(struct videobuf_queue* q, struct videobuf_dmabuf *dma)
 						   dma->offset);
 	}
 	if (dma->vmalloc) {
-		dma->sglist = videobuf_vmalloc_to_sg
-						(dma->vmalloc,dma->nr_pages);
+		dma->sglist = videobuf_vmalloc_to_sg(dma->vmalloc,
+						     dma->nr_pages);
 	}
 	if (dma->bus_addr) {
 		dma->sglist = vmalloc(sizeof(*dma->sglist));
 		if (NULL != dma->sglist) {
-			dma->sglen  = 1;
-			sg_dma_address(&dma->sglist[0]) = dma->bus_addr & PAGE_MASK;
-			dma->sglist[0].offset           = dma->bus_addr & ~PAGE_MASK;
-			sg_dma_len(&dma->sglist[0])     = dma->nr_pages * PAGE_SIZE;
+			dma->sglen = 1;
+			sg_dma_address(&dma->sglist[0])	= dma->bus_addr
+							& PAGE_MASK;
+			dma->sglist[0].offset = dma->bus_addr & ~PAGE_MASK;
+			sg_dma_len(&dma->sglist[0]) = dma->nr_pages * PAGE_SIZE;
 		}
 	}
 	if (NULL == dma->sglist) {
-		dprintk(1,"scatterlist is NULL\n");
+		dprintk(1, "scatterlist is NULL\n");
 		return -ENOMEM;
 	}
 	if (!dma->bus_addr) {
@@ -249,15 +267,17 @@ int videobuf_dma_map(struct videobuf_queue* q, struct videobuf_dmabuf *dma)
 					dma->nr_pages, dma->direction);
 		if (0 == dma->sglen) {
 			printk(KERN_WARNING
-			       "%s: videobuf_map_sg failed\n",__func__);
+			       "%s: videobuf_map_sg failed\n", __func__);
 			vfree(dma->sglist);
 			dma->sglist = NULL;
 			dma->sglen = 0;
 			return -ENOMEM;
 		}
 	}
+
 	return 0;
 }
+EXPORT_SYMBOL_GPL(videobuf_dma_map);
 
 int videobuf_dma_sync(struct videobuf_queue *q, struct videobuf_dmabuf *dma)
 {
@@ -265,12 +285,15 @@ int videobuf_dma_sync(struct videobuf_queue *q, struct videobuf_dmabuf *dma)
 	BUG_ON(!dma->sglen);
 
 	dma_sync_sg_for_cpu(q->dev, dma->sglist, dma->nr_pages, dma->direction);
+
 	return 0;
 }
+EXPORT_SYMBOL_GPL(videobuf_dma_sync);
 
-int videobuf_dma_unmap(struct videobuf_queue* q,struct videobuf_dmabuf *dma)
+int videobuf_dma_unmap(struct videobuf_queue *q, struct videobuf_dmabuf *dma)
 {
 	MAGIC_CHECK(dma->magic, MAGIC_DMABUF);
+
 	if (!dma->sglen)
 		return 0;
 
@@ -279,17 +302,19 @@ int videobuf_dma_unmap(struct videobuf_queue* q,struct videobuf_dmabuf *dma)
 	vfree(dma->sglist);
 	dma->sglist = NULL;
 	dma->sglen = 0;
+
 	return 0;
 }
+EXPORT_SYMBOL_GPL(videobuf_dma_unmap);
 
 int videobuf_dma_free(struct videobuf_dmabuf *dma)
 {
-	MAGIC_CHECK(dma->magic,MAGIC_DMABUF);
+	int i;
+	MAGIC_CHECK(dma->magic, MAGIC_DMABUF);
 	BUG_ON(dma->sglen);
 
 	if (dma->pages) {
-		int i;
-		for (i=0; i < dma->nr_pages; i++)
+		for (i = 0; i < dma->nr_pages; i++)
 			page_cache_release(dma->pages[i]);
 		kfree(dma->pages);
 		dma->pages = NULL;
@@ -298,12 +323,13 @@ int videobuf_dma_free(struct videobuf_dmabuf *dma)
 	vfree(dma->vmalloc);
 	dma->vmalloc = NULL;
 
-	if (dma->bus_addr) {
+	if (dma->bus_addr)
 		dma->bus_addr = 0;
-	}
 	dma->direction = DMA_NONE;
+
 	return 0;
 }
+EXPORT_SYMBOL_GPL(videobuf_dma_free);
 
 /* --------------------------------------------------------------------- */
 
@@ -315,6 +341,7 @@ int videobuf_sg_dma_map(struct device *dev, struct videobuf_dmabuf *dma)
 
 	return videobuf_dma_map(&q, dma);
 }
+EXPORT_SYMBOL_GPL(videobuf_sg_dma_map);
 
 int videobuf_sg_dma_unmap(struct device *dev, struct videobuf_dmabuf *dma)
 {
@@ -324,49 +351,48 @@ int videobuf_sg_dma_unmap(struct device *dev, struct videobuf_dmabuf *dma)
 
 	return videobuf_dma_unmap(&q, dma);
 }
+EXPORT_SYMBOL_GPL(videobuf_sg_dma_unmap);
 
 /* --------------------------------------------------------------------- */
 
-static void
-videobuf_vm_open(struct vm_area_struct *vma)
+static void videobuf_vm_open(struct vm_area_struct *vma)
 {
 	struct videobuf_mapping *map = vma->vm_private_data;
 
-	dprintk(2,"vm_open %p [count=%d,vma=%08lx-%08lx]\n",map,
-		map->count,vma->vm_start,vma->vm_end);
+	dprintk(2, "vm_open %p [count=%d,vma=%08lx-%08lx]\n", map,
+		map->count, vma->vm_start, vma->vm_end);
+
 	map->count++;
 }
 
-static void
-videobuf_vm_close(struct vm_area_struct *vma)
+static void videobuf_vm_close(struct vm_area_struct *vma)
 {
 	struct videobuf_mapping *map = vma->vm_private_data;
 	struct videobuf_queue *q = map->q;
 	struct videobuf_dma_sg_memory *mem;
 	int i;
 
-	dprintk(2,"vm_close %p [count=%d,vma=%08lx-%08lx]\n",map,
-		map->count,vma->vm_start,vma->vm_end);
+	dprintk(2, "vm_close %p [count=%d,vma=%08lx-%08lx]\n", map,
+		map->count, vma->vm_start, vma->vm_end);
 
 	map->count--;
 	if (0 == map->count) {
-		dprintk(1,"munmap %p q=%p\n",map,q);
+		dprintk(1, "munmap %p q=%p\n", map, q);
 		mutex_lock(&q->vb_lock);
 		for (i = 0; i < VIDEO_MAX_FRAME; i++) {
 			if (NULL == q->bufs[i])
 				continue;
-			mem=q->bufs[i]->priv;
-
+			mem = q->bufs[i]->priv;
 			if (!mem)
 				continue;
 
-			MAGIC_CHECK(mem->magic,MAGIC_SG_MEM);
+			MAGIC_CHECK(mem->magic, MAGIC_SG_MEM);
 
 			if (q->bufs[i]->map != map)
 				continue;
 			q->bufs[i]->map   = NULL;
 			q->bufs[i]->baddr = 0;
-			q->ops->buf_release(q,q->bufs[i]);
+			q->ops->buf_release(q, q->bufs[i]);
 		}
 		mutex_unlock(&q->vb_lock);
 		kfree(map);
@@ -380,26 +406,27 @@ videobuf_vm_close(struct vm_area_struct *vma)
  * now ...).  Bounce buffers don't work very well for the data rates
  * video capture has.
  */
-static int
-videobuf_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int videobuf_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct page *page;
 
-	dprintk(3,"fault: fault @ %08lx [vma %08lx-%08lx]\n",
-		(unsigned long)vmf->virtual_address,vma->vm_start,vma->vm_end);
+	dprintk(3, "fault: fault @ %08lx [vma %08lx-%08lx]\n",
+		(unsigned long)vmf->virtual_address,
+		vma->vm_start, vma->vm_end);
+
 	page = alloc_page(GFP_USER | __GFP_DMA32);
 	if (!page)
 		return VM_FAULT_OOM;
 	clear_user_highpage(page, (unsigned long)vmf->virtual_address);
 	vmf->page = page;
+
 	return 0;
 }
 
-static const struct vm_operations_struct videobuf_vm_ops =
-{
-	.open     = videobuf_vm_open,
-	.close    = videobuf_vm_close,
-	.fault    = videobuf_vm_fault,
+static const struct vm_operations_struct videobuf_vm_ops = {
+	.open	= videobuf_vm_open,
+	.close	= videobuf_vm_close,
+	.fault	= videobuf_vm_fault,
 };
 
 /* ---------------------------------------------------------------------
@@ -417,23 +444,23 @@ static void *__videobuf_alloc(size_t size)
 	struct videobuf_dma_sg_memory *mem;
 	struct videobuf_buffer *vb;
 
-	vb = kzalloc(size+sizeof(*mem),GFP_KERNEL);
+	vb = kzalloc(size + sizeof(*mem), GFP_KERNEL);
 	if (!vb)
 		return vb;
 
-	mem = vb->priv = ((char *)vb)+size;
-	mem->magic=MAGIC_SG_MEM;
+	mem = vb->priv = ((char *)vb) + size;
+	mem->magic = MAGIC_SG_MEM;
 
 	videobuf_dma_init(&mem->dma);
 
-	dprintk(1,"%s: allocated at %p(%ld+%ld) & %p(%ld)\n",
-		__func__,vb,(long)sizeof(*vb),(long)size-sizeof(*vb),
-		mem,(long)sizeof(*mem));
+	dprintk(1, "%s: allocated at %p(%ld+%ld) & %p(%ld)\n",
+		__func__, vb, (long)sizeof(*vb), (long)size - sizeof(*vb),
+		mem, (long)sizeof(*mem));
 
 	return vb;
 }
 
-static void *__videobuf_to_vmalloc (struct videobuf_buffer *buf)
+static void *__videobuf_to_vmalloc(struct videobuf_buffer *buf)
 {
 	struct videobuf_dma_sg_memory *mem = buf->priv;
 	BUG_ON(!mem);
@@ -443,11 +470,11 @@ static void *__videobuf_to_vmalloc (struct videobuf_buffer *buf)
 	return mem->dma.vmalloc;
 }
 
-static int __videobuf_iolock (struct videobuf_queue* q,
-			      struct videobuf_buffer *vb,
-			      struct v4l2_framebuffer *fbuf)
+static int __videobuf_iolock(struct videobuf_queue *q,
+			     struct videobuf_buffer *vb,
+			     struct v4l2_framebuffer *fbuf)
 {
-	int err,pages;
+	int err, pages;
 	dma_addr_t bus;
 	struct videobuf_dma_sg_memory *mem = vb->priv;
 	BUG_ON(!mem);
@@ -460,16 +487,16 @@ static int __videobuf_iolock (struct videobuf_queue* q,
 		if (0 == vb->baddr) {
 			/* no userspace addr -- kernel bounce buffer */
 			pages = PAGE_ALIGN(vb->size) >> PAGE_SHIFT;
-			err = videobuf_dma_init_kernel( &mem->dma,
-							DMA_FROM_DEVICE,
-							pages );
+			err = videobuf_dma_init_kernel(&mem->dma,
+						       DMA_FROM_DEVICE,
+						       pages);
 			if (0 != err)
 				return err;
 		} else if (vb->memory == V4L2_MEMORY_USERPTR) {
 			/* dma directly to userspace */
-			err = videobuf_dma_init_user( &mem->dma,
-						      DMA_FROM_DEVICE,
-						      vb->baddr,vb->bsize );
+			err = videobuf_dma_init_user(&mem->dma,
+						     DMA_FROM_DEVICE,
+						     vb->baddr, vb->bsize);
 			if (0 != err)
 				return err;
 		} else {
@@ -516,9 +543,9 @@ static int __videobuf_sync(struct videobuf_queue *q,
 {
 	struct videobuf_dma_sg_memory *mem = buf->priv;
 	BUG_ON(!mem);
-	MAGIC_CHECK(mem->magic,MAGIC_SG_MEM);
+	MAGIC_CHECK(mem->magic, MAGIC_SG_MEM);
 
-	return	videobuf_dma_sync(q,&mem->dma);
+	return videobuf_dma_sync(q, &mem->dma);
 }
 
 static int __videobuf_mmap_free(struct videobuf_queue *q)
@@ -540,16 +567,16 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
 {
 	struct videobuf_dma_sg_memory *mem;
 	struct videobuf_mapping *map;
-	unsigned int first,last,size,i;
+	unsigned int first, last, size, i;
 	int retval;
 
 	retval = -EINVAL;
 	if (!(vma->vm_flags & VM_WRITE)) {
-		dprintk(1,"mmap app bug: PROT_WRITE please\n");
+		dprintk(1, "mmap app bug: PROT_WRITE please\n");
 		goto done;
 	}
 	if (!(vma->vm_flags & VM_SHARED)) {
-		dprintk(1,"mmap app bug: MAP_SHARED please\n");
+		dprintk(1, "mmap app bug: MAP_SHARED please\n");
 		goto done;
 	}
 
@@ -565,9 +592,9 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
 	for (first = 0; first < VIDEO_MAX_FRAME; first++) {
 		if (NULL == q->bufs[first])
 			continue;
-		mem=q->bufs[first]->priv;
+		mem = q->bufs[first]->priv;
 		BUG_ON(!mem);
-		MAGIC_CHECK(mem->magic,MAGIC_SG_MEM);
+		MAGIC_CHECK(mem->magic, MAGIC_SG_MEM);
 
 		if (V4L2_MEMORY_MMAP != q->bufs[first]->memory)
 			continue;
@@ -575,7 +602,7 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
 			break;
 	}
 	if (VIDEO_MAX_FRAME == first) {
-		dprintk(1,"mmap app bug: offset invalid [offset=0x%lx]\n",
+		dprintk(1, "mmap app bug: offset invalid [offset=0x%lx]\n",
 			(vma->vm_pgoff << PAGE_SHIFT));
 		goto done;
 	}
@@ -595,14 +622,14 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
 			break;
 	}
 	if (VIDEO_MAX_FRAME == last) {
-		dprintk(1,"mmap app bug: size invalid [size=0x%lx]\n",
+		dprintk(1, "mmap app bug: size invalid [size=0x%lx]\n",
 			(vma->vm_end - vma->vm_start));
 		goto done;
 	}
 
 	/* create mapping + update buffer list */
 	retval = -ENOMEM;
-	map = kmalloc(sizeof(struct videobuf_mapping),GFP_KERNEL);
+	map = kmalloc(sizeof(struct videobuf_mapping), GFP_KERNEL);
 	if (NULL == map)
 		goto done;
 
@@ -623,21 +650,21 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
 	vma->vm_flags |= VM_DONTEXPAND | VM_RESERVED;
 	vma->vm_flags &= ~VM_IO; /* using shared anonymous pages */
 	vma->vm_private_data = map;
-	dprintk(1,"mmap %p: q=%p %08lx-%08lx pgoff %08lx bufs %d-%d\n",
-		map,q,vma->vm_start,vma->vm_end,vma->vm_pgoff,first,last);
+	dprintk(1, "mmap %p: q=%p %08lx-%08lx pgoff %08lx bufs %d-%d\n",
+		map, q, vma->vm_start, vma->vm_end, vma->vm_pgoff, first, last);
 	retval = 0;
 
- done:
+done:
 	return retval;
 }
 
-static int __videobuf_copy_to_user ( struct videobuf_queue *q,
+static int __videobuf_copy_to_user(struct videobuf_queue *q,
 				char __user *data, size_t count,
-				int nonblocking )
+				int nonblocking)
 {
 	struct videobuf_dma_sg_memory *mem = q->read_buf->priv;
 	BUG_ON(!mem);
-	MAGIC_CHECK(mem->magic,MAGIC_SG_MEM);
+	MAGIC_CHECK(mem->magic, MAGIC_SG_MEM);
 
 	/* copy to userspace */
 	if (count > q->read_buf->size - q->read_off)
@@ -649,30 +676,30 @@ static int __videobuf_copy_to_user ( struct videobuf_queue *q,
 	return count;
 }
 
-static int __videobuf_copy_stream ( struct videobuf_queue *q,
+static int __videobuf_copy_stream(struct videobuf_queue *q,
 				char __user *data, size_t count, size_t pos,
-				int vbihack, int nonblocking )
+				int vbihack, int nonblocking)
 {
-	unsigned int  *fc;
+	unsigned int *fc;
 	struct videobuf_dma_sg_memory *mem = q->read_buf->priv;
 	BUG_ON(!mem);
-	MAGIC_CHECK(mem->magic,MAGIC_SG_MEM);
+	MAGIC_CHECK(mem->magic, MAGIC_SG_MEM);
 
 	if (vbihack) {
 		/* dirty, undocumented hack -- pass the frame counter
-			* within the last four bytes of each vbi data block.
-			* We need that one to maintain backward compatibility
-			* to all vbi decoding software out there ... */
-		fc  = (unsigned int*)mem->dma.vmalloc;
-		fc += (q->read_buf->size>>2) -1;
+		 * within the last four bytes of each vbi data block.
+		 * We need that one to maintain backward compatibility
+		 * to all vbi decoding software out there ... */
+		fc  = (unsigned int *)mem->dma.vmalloc;
+		fc += (q->read_buf->size >> 2) - 1;
 		*fc = q->read_buf->field_count >> 1;
-		dprintk(1,"vbihack: %d\n",*fc);
+		dprintk(1, "vbihack: %d\n", *fc);
 	}
 
 	/* copy stuff using the common method */
-	count = __videobuf_copy_to_user (q,data,count,nonblocking);
+	count = __videobuf_copy_to_user(q, data, count, nonblocking);
 
-	if ( (count==-EFAULT) && (0 == pos) )
+	if ((count == -EFAULT) && (0 == pos))
 		return -EFAULT;
 
 	return count;
@@ -702,8 +729,9 @@ void *videobuf_sg_alloc(size_t size)
 
 	return videobuf_alloc(&q);
 }
+EXPORT_SYMBOL_GPL(videobuf_sg_alloc);
 
-void videobuf_queue_sg_init(struct videobuf_queue* q,
+void videobuf_queue_sg_init(struct videobuf_queue *q,
 			 const struct videobuf_queue_ops *ops,
 			 struct device *dev,
 			 spinlock_t *irqlock,
@@ -715,29 +743,5 @@ void videobuf_queue_sg_init(struct videobuf_queue* q,
 	videobuf_queue_core_init(q, ops, dev, irqlock, type, field, msize,
 				 priv, &sg_ops);
 }
-
-/* --------------------------------------------------------------------- */
-
-EXPORT_SYMBOL_GPL(videobuf_vmalloc_to_sg);
-
-EXPORT_SYMBOL_GPL(videobuf_to_dma);
-EXPORT_SYMBOL_GPL(videobuf_dma_init);
-EXPORT_SYMBOL_GPL(videobuf_dma_init_user);
-EXPORT_SYMBOL_GPL(videobuf_dma_init_kernel);
-EXPORT_SYMBOL_GPL(videobuf_dma_init_overlay);
-EXPORT_SYMBOL_GPL(videobuf_dma_map);
-EXPORT_SYMBOL_GPL(videobuf_dma_sync);
-EXPORT_SYMBOL_GPL(videobuf_dma_unmap);
-EXPORT_SYMBOL_GPL(videobuf_dma_free);
-
-EXPORT_SYMBOL_GPL(videobuf_sg_dma_map);
-EXPORT_SYMBOL_GPL(videobuf_sg_dma_unmap);
-EXPORT_SYMBOL_GPL(videobuf_sg_alloc);
-
 EXPORT_SYMBOL_GPL(videobuf_queue_sg_init);
 
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/video/videobuf-vmalloc.c b/drivers/media/video/videobuf-vmalloc.c
index 136e093..d6a8a38 100644
--- a/drivers/media/video/videobuf-vmalloc.c
+++ b/drivers/media/video/videobuf-vmalloc.c
@@ -30,8 +30,12 @@
 #define MAGIC_DMABUF   0x17760309
 #define MAGIC_VMAL_MEM 0x18221223
 
-#define MAGIC_CHECK(is,should)	if (unlikely((is) != (should))) \
-	{ printk(KERN_ERR "magic mismatch: %x (expected %x)\n",is,should); BUG(); }
+#define MAGIC_CHECK(is, should)						\
+	if (unlikely((is) != (should))) {				\
+		printk(KERN_ERR "magic mismatch: %x (expected %x)\n",	\
+				is, should);				\
+		BUG();							\
+	}
 
 static int debug;
 module_param(debug, int, 0644);
@@ -40,19 +44,19 @@ MODULE_DESCRIPTION("helper module to manage video4linux vmalloc buffers");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@infradead.org>");
 MODULE_LICENSE("GPL");
 
-#define dprintk(level, fmt, arg...)	if (debug >= level) \
-	printk(KERN_DEBUG "vbuf-vmalloc: " fmt , ## arg)
+#define dprintk(level, fmt, arg...)					\
+	if (debug >= level)						\
+		printk(KERN_DEBUG "vbuf-vmalloc: " fmt , ## arg)
 
 
 /***************************************************************************/
 
-static void
-videobuf_vm_open(struct vm_area_struct *vma)
+static void videobuf_vm_open(struct vm_area_struct *vma)
 {
 	struct videobuf_mapping *map = vma->vm_private_data;
 
-	dprintk(2,"vm_open %p [count=%u,vma=%08lx-%08lx]\n",map,
-		map->count,vma->vm_start,vma->vm_end);
+	dprintk(2, "vm_open %p [count=%u,vma=%08lx-%08lx]\n", map,
+		map->count, vma->vm_start, vma->vm_end);
 
 	map->count++;
 }
@@ -63,7 +67,7 @@ static void videobuf_vm_close(struct vm_area_struct *vma)
 	struct videobuf_queue *q = map->q;
 	int i;
 
-	dprintk(2,"vm_close %p [count=%u,vma=%08lx-%08lx]\n", map,
+	dprintk(2, "vm_close %p [count=%u,vma=%08lx-%08lx]\n", map,
 		map->count, vma->vm_start, vma->vm_end);
 
 	map->count--;
@@ -116,8 +120,7 @@ static void videobuf_vm_close(struct vm_area_struct *vma)
 	return;
 }
 
-static const struct vm_operations_struct videobuf_vm_ops =
-{
+static const struct vm_operations_struct videobuf_vm_ops = {
 	.open     = videobuf_vm_open,
 	.close    = videobuf_vm_close,
 };
@@ -137,23 +140,23 @@ static void *__videobuf_alloc(size_t size)
 	struct videobuf_vmalloc_memory *mem;
 	struct videobuf_buffer *vb;
 
-	vb = kzalloc(size+sizeof(*mem),GFP_KERNEL);
+	vb = kzalloc(size + sizeof(*mem), GFP_KERNEL);
 	if (!vb)
 		return vb;
 
-	mem = vb->priv = ((char *)vb)+size;
-	mem->magic=MAGIC_VMAL_MEM;
+	mem = vb->priv = ((char *)vb) + size;
+	mem->magic = MAGIC_VMAL_MEM;
 
-	dprintk(1,"%s: allocated at %p(%ld+%ld) & %p(%ld)\n",
-		__func__,vb,(long)sizeof(*vb),(long)size-sizeof(*vb),
-		mem,(long)sizeof(*mem));
+	dprintk(1, "%s: allocated at %p(%ld+%ld) & %p(%ld)\n",
+		__func__, vb, (long)sizeof(*vb), (long)size - sizeof(*vb),
+		mem, (long)sizeof(*mem));
 
 	return vb;
 }
 
-static int __videobuf_iolock (struct videobuf_queue* q,
-			      struct videobuf_buffer *vb,
-			      struct v4l2_framebuffer *fbuf)
+static int __videobuf_iolock(struct videobuf_queue *q,
+			     struct videobuf_buffer *vb,
+			     struct v4l2_framebuffer *fbuf)
 {
 	struct videobuf_vmalloc_memory *mem = vb->priv;
 	int pages;
@@ -177,15 +180,13 @@ static int __videobuf_iolock (struct videobuf_queue* q,
 
 		dprintk(1, "%s memory method USERPTR\n", __func__);
 
-#if 1
 		if (vb->baddr) {
 			printk(KERN_ERR "USERPTR is currently not supported\n");
 			return -EINVAL;
 		}
-#endif
 
 		/* The only USERPTR currently supported is the one needed for
-		   read() method.
+		 * read() method.
 		 */
 
 		mem->vmalloc = vmalloc_user(pages);
@@ -210,7 +211,7 @@ static int __videobuf_iolock (struct videobuf_queue* q,
 		/* Try to remap memory */
 		rc = remap_vmalloc_range(mem->vma, (void *)vb->baddr, 0);
 		if (rc < 0) {
-			printk(KERN_ERR "mmap: remap failed with error %d. ", rc);
+			printk(KERN_ERR "mmap: remap failed with error %d", rc);
 			return -ENOMEM;
 		}
 #endif
@@ -273,7 +274,7 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
 			break;
 	}
 	if (VIDEO_MAX_FRAME == first) {
-		dprintk(1,"mmap app bug: offset invalid [offset=0x%lx]\n",
+		dprintk(1, "mmap app bug: offset invalid [offset=0x%lx]\n",
 			(vma->vm_pgoff << PAGE_SHIFT));
 		return -EINVAL;
 	}
@@ -300,8 +301,7 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
 		printk(KERN_ERR "vmalloc (%d pages) failed\n", pages);
 		goto error;
 	}
-	dprintk(1, "vmalloc is at addr %p (%d pages)\n",
-		mem->vmalloc, pages);
+	dprintk(1, "vmalloc is at addr %p (%d pages)\n", mem->vmalloc, pages);
 
 	/* Try to remap memory */
 	retval = remap_vmalloc_range(vma, mem->vmalloc, 0);
@@ -315,7 +315,7 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
 	vma->vm_flags       |= VM_DONTEXPAND | VM_RESERVED;
 	vma->vm_private_data = map;
 
-	dprintk(1,"mmap %p: q=%p %08lx-%08lx (%lx) pgoff %08lx buf %d\n",
+	dprintk(1, "mmap %p: q=%p %08lx-%08lx (%lx) pgoff %08lx buf %d\n",
 		map, q, vma->vm_start, vma->vm_end,
 		(long int) q->bufs[first]->bsize,
 		vma->vm_pgoff, first);
@@ -330,15 +330,15 @@ error:
 	return -ENOMEM;
 }
 
-static int __videobuf_copy_to_user ( struct videobuf_queue *q,
-				char __user *data, size_t count,
-				int nonblocking )
+static int __videobuf_copy_to_user(struct videobuf_queue *q,
+				   char __user *data, size_t count,
+				   int nonblocking)
 {
-	struct videobuf_vmalloc_memory *mem=q->read_buf->priv;
-	BUG_ON (!mem);
-	MAGIC_CHECK(mem->magic,MAGIC_VMAL_MEM);
+	struct videobuf_vmalloc_memory *mem = q->read_buf->priv;
+	BUG_ON(!mem);
+	MAGIC_CHECK(mem->magic, MAGIC_VMAL_MEM);
 
-	BUG_ON (!mem->vmalloc);
+	BUG_ON(!mem->vmalloc);
 
 	/* copy to userspace */
 	if (count > q->read_buf->size - q->read_off)
@@ -350,30 +350,30 @@ static int __videobuf_copy_to_user ( struct videobuf_queue *q,
 	return count;
 }
 
-static int __videobuf_copy_stream ( struct videobuf_queue *q,
-				char __user *data, size_t count, size_t pos,
-				int vbihack, int nonblocking )
+static int __videobuf_copy_stream(struct videobuf_queue *q,
+				  char __user *data, size_t count, size_t pos,
+				  int vbihack, int nonblocking)
 {
-	unsigned int  *fc;
-	struct videobuf_vmalloc_memory *mem=q->read_buf->priv;
-	BUG_ON (!mem);
-	MAGIC_CHECK(mem->magic,MAGIC_VMAL_MEM);
+	unsigned int *fc;
+	struct videobuf_vmalloc_memory *mem = q->read_buf->priv;
+	BUG_ON(!mem);
+	MAGIC_CHECK(mem->magic, MAGIC_VMAL_MEM);
 
 	if (vbihack) {
 		/* dirty, undocumented hack -- pass the frame counter
 			* within the last four bytes of each vbi data block.
 			* We need that one to maintain backward compatibility
 			* to all vbi decoding software out there ... */
-		fc  = (unsigned int*)mem->vmalloc;
-		fc += (q->read_buf->size>>2) -1;
+		fc  = (unsigned int *)mem->vmalloc;
+		fc += (q->read_buf->size >> 2) - 1;
 		*fc = q->read_buf->field_count >> 1;
-		dprintk(1,"vbihack: %d\n",*fc);
+		dprintk(1, "vbihack: %d\n", *fc);
 	}
 
 	/* copy stuff using the common method */
-	count = __videobuf_copy_to_user (q,data,count,nonblocking);
+	count = __videobuf_copy_to_user(q, data, count, nonblocking);
 
-	if ( (count==-EFAULT) && (0 == pos) )
+	if ((count == -EFAULT) && (0 == pos))
 		return -EFAULT;
 
 	return count;
@@ -392,7 +392,7 @@ static struct videobuf_qtype_ops qops = {
 	.vmalloc      = videobuf_to_vmalloc,
 };
 
-void videobuf_queue_vmalloc_init(struct videobuf_queue* q,
+void videobuf_queue_vmalloc_init(struct videobuf_queue *q,
 			 const struct videobuf_queue_ops *ops,
 			 struct device *dev,
 			 spinlock_t *irqlock,
@@ -404,20 +404,19 @@ void videobuf_queue_vmalloc_init(struct videobuf_queue* q,
 	videobuf_queue_core_init(q, ops, dev, irqlock, type, field, msize,
 				 priv, &qops);
 }
-
 EXPORT_SYMBOL_GPL(videobuf_queue_vmalloc_init);
 
-void *videobuf_to_vmalloc (struct videobuf_buffer *buf)
+void *videobuf_to_vmalloc(struct videobuf_buffer *buf)
 {
-	struct videobuf_vmalloc_memory *mem=buf->priv;
-	BUG_ON (!mem);
-	MAGIC_CHECK(mem->magic,MAGIC_VMAL_MEM);
+	struct videobuf_vmalloc_memory *mem = buf->priv;
+	BUG_ON(!mem);
+	MAGIC_CHECK(mem->magic, MAGIC_VMAL_MEM);
 
 	return mem->vmalloc;
 }
 EXPORT_SYMBOL_GPL(videobuf_to_vmalloc);
 
-void videobuf_vmalloc_free (struct videobuf_buffer *buf)
+void videobuf_vmalloc_free(struct videobuf_buffer *buf)
 {
 	struct videobuf_vmalloc_memory *mem = buf->priv;
 
@@ -442,8 +441,3 @@ void videobuf_vmalloc_free (struct videobuf_buffer *buf)
 }
 EXPORT_SYMBOL_GPL(videobuf_vmalloc_free);
 
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
-- 
1.7.0.31.g1df487

