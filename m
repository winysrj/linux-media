Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:43072 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190Ab0EKNfg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 May 2010 09:35:36 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: p.osciak@samsung.com, hverkuil@xs4all.nl
Subject: [PATCH 1/7] v4l: videobuf: rename videobuf_alloc to videobuf_alloc_vb
Date: Tue, 11 May 2010 15:36:28 +0200
Message-Id: <1273584994-14211-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1273584994-14211-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1273584994-14211-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Pawel Osciak <p.osciak@samsung.com>

These functions allocate videobuf_buffer structures only. Renaming in order
to prevent confusion with functions allocating actual video buffer memory.

Signed-off-by: Pawel Osciak <p.osciak@samsung.com>

Rename the functions in videobuf-core.h videobuf-dma-sg.c as well.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/videobuf-core.c       |   14 +++++++-------
 drivers/media/video/videobuf-dma-contig.c |    4 ++--
 drivers/media/video/videobuf-dma-sg.c     |    6 +++---
 drivers/media/video/videobuf-vmalloc.c    |    4 ++--
 include/media/videobuf-core.h             |    4 ++--
 5 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/media/video/videobuf-core.c b/drivers/media/video/videobuf-core.c
index 7d33784..4d56583 100644
--- a/drivers/media/video/videobuf-core.c
+++ b/drivers/media/video/videobuf-core.c
@@ -52,18 +52,18 @@ MODULE_LICENSE("GPL");
 #define CALL(q, f, arg...)						\
 	((q->int_ops->f) ? q->int_ops->f(arg) : 0)
 
-struct videobuf_buffer *videobuf_alloc(struct videobuf_queue *q)
+struct videobuf_buffer *videobuf_alloc_vb(struct videobuf_queue *q)
 {
 	struct videobuf_buffer *vb;
 
 	BUG_ON(q->msize < sizeof(*vb));
 
-	if (!q->int_ops || !q->int_ops->alloc) {
+	if (!q->int_ops || !q->int_ops->alloc_vb) {
 		printk(KERN_ERR "No specific ops defined!\n");
 		BUG();
 	}
 
-	vb = q->int_ops->alloc(q->msize);
+	vb = q->int_ops->alloc_vb(q->msize);
 	if (NULL != vb) {
 		init_waitqueue_head(&vb->done);
 		vb->magic = MAGIC_BUFFER;
@@ -71,7 +71,7 @@ struct videobuf_buffer *videobuf_alloc(struct videobuf_queue *q)
 
 	return vb;
 }
-EXPORT_SYMBOL_GPL(videobuf_alloc);
+EXPORT_SYMBOL_GPL(videobuf_alloc_vb);
 
 #define WAITON_CONDITION (vb->state != VIDEOBUF_ACTIVE &&\
 				vb->state != VIDEOBUF_QUEUED)
@@ -359,7 +359,7 @@ int __videobuf_mmap_setup(struct videobuf_queue *q,
 
 	/* Allocate and initialize buffers */
 	for (i = 0; i < bcount; i++) {
-		q->bufs[i] = videobuf_alloc(q);
+		q->bufs[i] = videobuf_alloc_vb(q);
 
 		if (NULL == q->bufs[i])
 			break;
@@ -766,7 +766,7 @@ static ssize_t videobuf_read_zerocopy(struct videobuf_queue *q,
 	MAGIC_CHECK(q->int_ops->magic, MAGIC_QTYPE_OPS);
 
 	/* setup stuff */
-	q->read_buf = videobuf_alloc(q);
+	q->read_buf = videobuf_alloc_vb(q);
 	if (NULL == q->read_buf)
 		return -ENOMEM;
 
@@ -871,7 +871,7 @@ ssize_t videobuf_read_one(struct videobuf_queue *q,
 	if (NULL == q->read_buf) {
 		/* need to capture a new frame */
 		retval = -ENOMEM;
-		q->read_buf = videobuf_alloc(q);
+		q->read_buf = videobuf_alloc_vb(q);
 
 		dprintk(1, "video alloc=0x%p\n", q->read_buf);
 		if (NULL == q->read_buf)
diff --git a/drivers/media/video/videobuf-dma-contig.c b/drivers/media/video/videobuf-dma-contig.c
index 808d25e..d87ed21 100644
--- a/drivers/media/video/videobuf-dma-contig.c
+++ b/drivers/media/video/videobuf-dma-contig.c
@@ -189,7 +189,7 @@ static int videobuf_dma_contig_user_get(struct videobuf_dma_contig_memory *mem,
 	return ret;
 }
 
-static struct videobuf_buffer *__videobuf_alloc(size_t size)
+static struct videobuf_buffer *__videobuf_alloc_vb(size_t size)
 {
 	struct videobuf_dma_contig_memory *mem;
 	struct videobuf_buffer *vb;
@@ -337,7 +337,7 @@ error:
 static struct videobuf_qtype_ops qops = {
 	.magic        = MAGIC_QTYPE_OPS,
 
-	.alloc        = __videobuf_alloc,
+	.alloc_vb     = __videobuf_alloc_vb,
 	.iolock       = __videobuf_iolock,
 	.mmap_mapper  = __videobuf_mmap_mapper,
 	.vaddr        = __videobuf_to_vaddr,
diff --git a/drivers/media/video/videobuf-dma-sg.c b/drivers/media/video/videobuf-dma-sg.c
index 8359e6b..a9b1091 100644
--- a/drivers/media/video/videobuf-dma-sg.c
+++ b/drivers/media/video/videobuf-dma-sg.c
@@ -428,7 +428,7 @@ static const struct vm_operations_struct videobuf_vm_ops = {
 	struct videobuf_dma_sg_memory
  */
 
-static struct videobuf_buffer *__videobuf_alloc(size_t size)
+static struct videobuf_buffer *__videobuf_alloc_vb(size_t size)
 {
 	struct videobuf_dma_sg_memory *mem;
 	struct videobuf_buffer *vb;
@@ -638,7 +638,7 @@ done:
 static struct videobuf_qtype_ops sg_ops = {
 	.magic        = MAGIC_QTYPE_OPS,
 
-	.alloc        = __videobuf_alloc,
+	.alloc_vb     = __videobuf_alloc_vb,
 	.iolock       = __videobuf_iolock,
 	.sync         = __videobuf_sync,
 	.mmap_mapper  = __videobuf_mmap_mapper,
@@ -654,7 +654,7 @@ void *videobuf_sg_alloc(size_t size)
 
 	q.msize = size;
 
-	return videobuf_alloc(&q);
+	return videobuf_alloc_vb(&q);
 }
 EXPORT_SYMBOL_GPL(videobuf_sg_alloc);
 
diff --git a/drivers/media/video/videobuf-vmalloc.c b/drivers/media/video/videobuf-vmalloc.c
index 583728f..cf5be6b 100644
--- a/drivers/media/video/videobuf-vmalloc.c
+++ b/drivers/media/video/videobuf-vmalloc.c
@@ -135,7 +135,7 @@ static const struct vm_operations_struct videobuf_vm_ops = {
 	struct videobuf_dma_sg_memory
  */
 
-static struct videobuf_buffer *__videobuf_alloc(size_t size)
+static struct videobuf_buffer *__videobuf_alloc_vb(size_t size)
 {
 	struct videobuf_vmalloc_memory *mem;
 	struct videobuf_buffer *vb;
@@ -293,7 +293,7 @@ error:
 static struct videobuf_qtype_ops qops = {
 	.magic        = MAGIC_QTYPE_OPS,
 
-	.alloc        = __videobuf_alloc,
+	.alloc_vb     = __videobuf_alloc_vb,
 	.iolock       = __videobuf_iolock,
 	.mmap_mapper  = __videobuf_mmap_mapper,
 	.vaddr        = videobuf_to_vmalloc,
diff --git a/include/media/videobuf-core.h b/include/media/videobuf-core.h
index f91a736..a157cd1 100644
--- a/include/media/videobuf-core.h
+++ b/include/media/videobuf-core.h
@@ -127,7 +127,7 @@ struct videobuf_queue_ops {
 struct videobuf_qtype_ops {
 	u32                     magic;
 
-	struct videobuf_buffer *(*alloc)(size_t size);
+	struct videobuf_buffer *(*alloc_vb)(size_t size);
 	void *(*vaddr)		(struct videobuf_buffer *buf);
 	int (*iolock)		(struct videobuf_queue *q,
 				 struct videobuf_buffer *vb,
@@ -173,7 +173,7 @@ int videobuf_waiton(struct videobuf_buffer *vb, int non_blocking, int intr);
 int videobuf_iolock(struct videobuf_queue *q, struct videobuf_buffer *vb,
 		struct v4l2_framebuffer *fbuf);
 
-struct videobuf_buffer *videobuf_alloc(struct videobuf_queue *q);
+struct videobuf_buffer *videobuf_alloc_vb(struct videobuf_queue *q);
 
 /* Used on videobuf-dvb */
 void *videobuf_queue_to_vaddr(struct videobuf_queue *q,
-- 
1.6.4.4

