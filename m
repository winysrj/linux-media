Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f182.google.com ([209.85.128.182]:33856 "EHLO
        mail-wr0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751814AbdHULes (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Aug 2017 07:34:48 -0400
Received: by mail-wr0-f182.google.com with SMTP id p14so27761201wrg.1
        for <linux-media@vger.kernel.org>; Mon, 21 Aug 2017 04:34:48 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH 1/7 v3] media: vb2: add bidirectional flag in vb2_queue
Date: Mon, 21 Aug 2017 14:34:10 +0300
Message-Id: <20170821113410.17542-1-stanimir.varbanov@linaro.org>
In-Reply-To: <20170818141606.4835-2-stanimir.varbanov@linaro.org>
References: <20170818141606.4835-2-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This change is intended to give to the v4l2 drivers a choice to
change the default behavior of the v4l2-core DMA mapping direction
from DMA_TO/FROM_DEVICE (depending on the buffer type CAPTURE or
OUTPUT) to DMA_BIDIRECTIONAL during queue_init time.

Initially the issue with DMA mapping direction has been found in
Venus encoder driver where the hardware (firmware side) adds few
lines padding on bottom of the image buffer, and the consequence
is triggering of IOMMU protection faults.

This will help supporting venus encoder (and probably other drivers
in the future) which wants to map output type of buffers as
read/write.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
v3: update V4L2 dma-sg/contig and vmalloc memory type ops with a
    check for DMA_BIDIRECTIONAL.
v2: move dma_dir into private section.

 drivers/media/v4l2-core/videobuf2-core.c       | 17 ++++++++---------
 drivers/media/v4l2-core/videobuf2-dma-contig.c |  3 ++-
 drivers/media/v4l2-core/videobuf2-dma-sg.c     |  6 ++++--
 drivers/media/v4l2-core/videobuf2-vmalloc.c    |  6 ++++--
 include/media/videobuf2-core.h                 | 13 +++++++++++++
 5 files changed, 31 insertions(+), 14 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 0924594989b4..cb115ba6a1d2 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -194,8 +194,6 @@ static void __enqueue_in_driver(struct vb2_buffer *vb);
 static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
 {
 	struct vb2_queue *q = vb->vb2_queue;
-	enum dma_data_direction dma_dir =
-		q->is_output ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
 	void *mem_priv;
 	int plane;
 	int ret = -ENOMEM;
@@ -209,7 +207,7 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
 
 		mem_priv = call_ptr_memop(vb, alloc,
 				q->alloc_devs[plane] ? : q->dev,
-				q->dma_attrs, size, dma_dir, q->gfp_flags);
+				q->dma_attrs, size, q->dma_dir, q->gfp_flags);
 		if (IS_ERR_OR_NULL(mem_priv)) {
 			if (mem_priv)
 				ret = PTR_ERR(mem_priv);
@@ -978,8 +976,6 @@ static int __prepare_userptr(struct vb2_buffer *vb, const void *pb)
 	void *mem_priv;
 	unsigned int plane;
 	int ret = 0;
-	enum dma_data_direction dma_dir =
-		q->is_output ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
 	bool reacquired = vb->planes[0].mem_priv == NULL;
 
 	memset(planes, 0, sizeof(planes[0]) * vb->num_planes);
@@ -1030,7 +1026,7 @@ static int __prepare_userptr(struct vb2_buffer *vb, const void *pb)
 		mem_priv = call_ptr_memop(vb, get_userptr,
 				q->alloc_devs[plane] ? : q->dev,
 				planes[plane].m.userptr,
-				planes[plane].length, dma_dir);
+				planes[plane].length, q->dma_dir);
 		if (IS_ERR(mem_priv)) {
 			dprintk(1, "failed acquiring userspace memory for plane %d\n",
 				plane);
@@ -1096,8 +1092,6 @@ static int __prepare_dmabuf(struct vb2_buffer *vb, const void *pb)
 	void *mem_priv;
 	unsigned int plane;
 	int ret = 0;
-	enum dma_data_direction dma_dir =
-		q->is_output ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
 	bool reacquired = vb->planes[0].mem_priv == NULL;
 
 	memset(planes, 0, sizeof(planes[0]) * vb->num_planes);
@@ -1156,7 +1150,7 @@ static int __prepare_dmabuf(struct vb2_buffer *vb, const void *pb)
 		/* Acquire each plane's memory */
 		mem_priv = call_ptr_memop(vb, attach_dmabuf,
 				q->alloc_devs[plane] ? : q->dev,
-				dbuf, planes[plane].length, dma_dir);
+				dbuf, planes[plane].length, q->dma_dir);
 		if (IS_ERR(mem_priv)) {
 			dprintk(1, "failed to attach dmabuf\n");
 			ret = PTR_ERR(mem_priv);
@@ -2003,6 +1997,11 @@ int vb2_core_queue_init(struct vb2_queue *q)
 	if (q->buf_struct_size == 0)
 		q->buf_struct_size = sizeof(struct vb2_buffer);
 
+	if (q->bidirectional)
+		q->dma_dir = DMA_BIDIRECTIONAL;
+	else
+		q->dma_dir = q->is_output ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(vb2_core_queue_init);
diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index 5b90a66b9e78..9f389f36566d 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -508,7 +508,8 @@ static void *vb2_dc_get_userptr(struct device *dev, unsigned long vaddr,
 	buf->dma_dir = dma_dir;
 
 	offset = vaddr & ~PAGE_MASK;
-	vec = vb2_create_framevec(vaddr, size, dma_dir == DMA_FROM_DEVICE);
+	vec = vb2_create_framevec(vaddr, size, dma_dir == DMA_FROM_DEVICE ||
+					       dma_dir == DMA_BIDIRECTIONAL);
 	if (IS_ERR(vec)) {
 		ret = PTR_ERR(vec);
 		goto fail_buf;
diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
index 54f33938d45b..6808231a6bdc 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
@@ -239,7 +239,8 @@ static void *vb2_dma_sg_get_userptr(struct device *dev, unsigned long vaddr,
 	buf->offset = vaddr & ~PAGE_MASK;
 	buf->size = size;
 	buf->dma_sgt = &buf->sg_table;
-	vec = vb2_create_framevec(vaddr, size, buf->dma_dir == DMA_FROM_DEVICE);
+	vec = vb2_create_framevec(vaddr, size, dma_dir == DMA_FROM_DEVICE ||
+					       dma_dir == DMA_BIDIRECTIONAL);
 	if (IS_ERR(vec))
 		goto userptr_fail_pfnvec;
 	buf->vec = vec;
@@ -292,7 +293,8 @@ static void vb2_dma_sg_put_userptr(void *buf_priv)
 		vm_unmap_ram(buf->vaddr, buf->num_pages);
 	sg_free_table(buf->dma_sgt);
 	while (--i >= 0) {
-		if (buf->dma_dir == DMA_FROM_DEVICE)
+		if (buf->dma_dir == DMA_FROM_DEVICE ||
+		    buf->dma_dir == DMA_BIDIRECTIONAL)
 			set_page_dirty_lock(buf->pages[i]);
 	}
 	vb2_destroy_framevec(buf->vec);
diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c b/drivers/media/v4l2-core/videobuf2-vmalloc.c
index 6bc130fe84f6..3a7c80cd1a17 100644
--- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
+++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
@@ -87,7 +87,8 @@ static void *vb2_vmalloc_get_userptr(struct device *dev, unsigned long vaddr,
 	buf->dma_dir = dma_dir;
 	offset = vaddr & ~PAGE_MASK;
 	buf->size = size;
-	vec = vb2_create_framevec(vaddr, size, dma_dir == DMA_FROM_DEVICE);
+	vec = vb2_create_framevec(vaddr, size, dma_dir == DMA_FROM_DEVICE ||
+					       dma_dir == DMA_BIDIRECTIONAL);
 	if (IS_ERR(vec)) {
 		ret = PTR_ERR(vec);
 		goto fail_pfnvec_create;
@@ -137,7 +138,8 @@ static void vb2_vmalloc_put_userptr(void *buf_priv)
 		pages = frame_vector_pages(buf->vec);
 		if (vaddr)
 			vm_unmap_ram((void *)vaddr, n_pages);
-		if (buf->dma_dir == DMA_FROM_DEVICE)
+		if (buf->dma_dir == DMA_FROM_DEVICE ||
+		    buf->dma_dir == DMA_BIDIRECTIONAL)
 			for (i = 0; i < n_pages; i++)
 				set_page_dirty_lock(pages[i]);
 	} else {
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index cb97c224be73..ef9b64398c8c 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -427,6 +427,16 @@ struct vb2_buf_ops {
  * @dev:	device to use for the default allocation context if the driver
  *		doesn't fill in the @alloc_devs array.
  * @dma_attrs:	DMA attributes to use for the DMA.
+ * @bidirectional: when this flag is set the DMA direction for the buffers of
+ *		this queue will be overridden with DMA_BIDIRECTIONAL direction.
+ *		This is useful in cases where the hardware (firmware) writes to
+ *		a buffer which is mapped as read (DMA_TO_DEVICE), or reads from
+ *		buffer which is mapped for write (DMA_FROM_DEVICE) in order
+ *		to satisfy some internal hardware restrictions or adds a padding
+ *		needed by the processing algorithm. In case the DMA mapping is
+ *		not bidirectional but the hardware (firmware) trying to access
+ *		the buffer (in the opposite direction) this could lead to an
+ *		IOMMU protection faults.
  * @fileio_read_once:		report EOF after reading the first buffer
  * @fileio_write_immediately:	queue buffer after each write() call
  * @allow_zero_bytesused:	allow bytesused == 0 to be passed to the driver
@@ -465,6 +475,7 @@ struct vb2_buf_ops {
  * Private elements (won't appear at the uAPI book):
  * @mmap_lock:	private mutex used when buffers are allocated/freed/mmapped
  * @memory:	current memory type used
+ * @dma_dir:	DMA mapping direction.
  * @bufs:	videobuf buffer structures
  * @num_buffers: number of allocated/used buffers
  * @queued_list: list of buffers currently queued from userspace
@@ -495,6 +506,7 @@ struct vb2_queue {
 	unsigned int			io_modes;
 	struct device			*dev;
 	unsigned long			dma_attrs;
+	unsigned			bidirectional:1;
 	unsigned			fileio_read_once:1;
 	unsigned			fileio_write_immediately:1;
 	unsigned			allow_zero_bytesused:1;
@@ -516,6 +528,7 @@ struct vb2_queue {
 	/* private: internal use only */
 	struct mutex			mmap_lock;
 	unsigned int			memory;
+	enum dma_data_direction		dma_dir;
 	struct vb2_buffer		*bufs[VB2_MAX_FRAME];
 	unsigned int			num_buffers;
 
-- 
2.11.0
