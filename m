Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3998 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748Ab0CRVKA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Mar 2010 17:10:00 -0400
Received: from tschai.localnet (cm-84.208.87.21.getinternet.no [84.208.87.21])
	(authenticated bits=0)
	by smtp-vbr12.xs4all.nl (8.13.8/8.13.8) with ESMTP id o2IL9vwZ096399
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 18 Mar 2010 22:09:58 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH/RFC] videobuf refactoring
Date: Thu, 18 Mar 2010 22:10:18 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201003182210.19055.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This patch is for discussion only. It is just to illustrate the possibilities.
Once the cleanup patch Pawel posted is merged, then I can try to make a proper
patch series for this depending on the feedback I get.

The more I look at the videobuf code the more it becomes clear that it is
absolute horrendous code. It's no wonder that it is so hard to use.

This patch is just a first phase at trying to bring some sense to the chaos.
The main changes are:

- All videobuf_qtype_ops now operate on buffers instead of whole queues.
  Sometimes the queue is still passed, but in most cases that can probably
  be avoided in the future. One restriction: the dma_sg needs to support
  some V4L1 functionality where all buffers are mmapped with one mmap call.
  This really requires videobuf_queue for now.
- Removed an unused op (mmap) and added a new one: vaddr. This returns
  the virtual address of the buffer. This used to be vmalloc, but we are
  not allocating anything, so that was a bad name,
- With the new vaddr op we can move the copy_stream and video_copy_to_user
  ops to the videobuf core where they belong.
- I notice that after this patch the mmap_free op does the same thing for
  all qtypes. This op can probably be removed. Frankly, I'm not sure what
  it is supposed to do.
- Now that all qtype ops operate on a buffer the next step would be to move
  the int_ops field from videobuf_queue to videobuf_buffer. Then that can be
  used instead of the 'magic' values.

Is there anything in this patch that I shouldn't have done? I think this
would be a major improvement but perhaps there is something magical somewhere
that I don't know about.

Regards,

	Hans

diff --git a/drivers/media/video/videobuf-core.c b/drivers/media/video/videobuf-core.c
index 471178e..5f6798e 100644
--- a/drivers/media/video/videobuf-core.c
+++ b/drivers/media/video/videobuf-core.c
@@ -99,8 +99,8 @@ int videobuf_iolock(struct videobuf_queue *q, struct videobuf_buffer *vb,
 void *videobuf_queue_to_vmalloc (struct videobuf_queue *q,
 			   struct videobuf_buffer *buf)
 {
-	if (q->int_ops->vmalloc)
-		return q->int_ops->vmalloc(buf);
+	if (q->int_ops->vaddr)
+		return q->int_ops->vaddr(buf);
 	else
 		return NULL;
 }
@@ -298,15 +298,16 @@ static void videobuf_status(struct videobuf_queue *q, struct v4l2_buffer *b,
 static int __videobuf_mmap_free(struct videobuf_queue *q)
 {
 	int i;
-	int rc;
+	int rc = 0;
 
 	if (!q)
 		return 0;
 
 	MAGIC_CHECK(q->int_ops->magic, MAGIC_QTYPE_OPS);
 
-
-	rc  = CALL(q, mmap_free, q);
+	for (i = 0; !rc && i < VIDEO_MAX_FRAME; i++)
+		if (q->bufs[i])
+			rc  = CALL(q, mmap_free, q, q->bufs[i]);
 
 	q->is_mmapped = 0;
 
@@ -782,6 +783,49 @@ static ssize_t videobuf_read_zerocopy(struct videobuf_queue *q,
 	return retval;
 }
 
+static int __videobuf_copy_to_user(struct videobuf_queue *q,
+				   struct videobuf_buffer *buf,
+				   char __user *data, size_t count,
+				   int nonblocking)
+{
+	void *vaddr = CALL(q, vaddr, buf);
+
+	/* copy to userspace */
+	if (count > buf->size - q->read_off)
+		count = buf->size - q->read_off;
+
+	if (copy_to_user(data, vaddr + q->read_off, count))
+		return -EFAULT;
+
+	return count;
+}
+
+static int __videobuf_copy_stream(struct videobuf_queue *q,
+				  struct videobuf_buffer *buf,
+				  char __user *data, size_t count, size_t pos,
+				  int vbihack, int nonblocking)
+{
+	unsigned int *fc = CALL(q, vaddr, buf);
+
+	if (vbihack) {
+		/* dirty, undocumented hack -- pass the frame counter
+			* within the last four bytes of each vbi data block.
+			* We need that one to maintain backward compatibility
+			* to all vbi decoding software out there ... */
+		fc += (buf->size >> 2) - 1;
+		*fc = buf->field_count >> 1;
+		dprintk(1, "vbihack: %d\n", *fc);
+	}
+
+	/* copy stuff using the common method */
+	count = __videobuf_copy_to_user(q, buf, data, count, nonblocking);
+
+	if ((count == -EFAULT) && (pos == 0))
+		return -EFAULT;
+
+	return count;
+}
+
 ssize_t videobuf_read_one(struct videobuf_queue *q,
 			  char __user *data, size_t count, loff_t *ppos,
 			  int nonblocking)
@@ -850,7 +894,7 @@ ssize_t videobuf_read_one(struct videobuf_queue *q,
 	}
 
 	/* Copy to userspace */
-	retval = CALL(q, video_copy_to_user, q, data, count, nonblocking);
+	retval = __videobuf_copy_to_user(q, q->read_buf, data, count, nonblocking);
 	if (retval < 0)
 		goto done;
 
@@ -990,7 +1034,7 @@ ssize_t videobuf_read_stream(struct videobuf_queue *q,
 		}
 
 		if (q->read_buf->state == VIDEOBUF_DONE) {
-			rc = CALL(q, copy_stream, q, data + retval, count,
+			rc = __videobuf_copy_stream(q, q->read_buf, data + retval, count,
 					retval, vbihack, nonblocking);
 			if (rc < 0) {
 				retval = rc;
@@ -1066,16 +1110,29 @@ unsigned int videobuf_poll_stream(struct file *file,
 int videobuf_mmap_mapper(struct videobuf_queue *q,
 			 struct vm_area_struct *vma)
 {
-	int retval;
+	int rc = -EINVAL;
+	int i;
 
 	MAGIC_CHECK(q->int_ops->magic, MAGIC_QTYPE_OPS);
 
+	if (!(vma->vm_flags & VM_WRITE) || !(vma->vm_flags & VM_SHARED))
+		return -EINVAL;
+
 	mutex_lock(&q->vb_lock);
-	retval = CALL(q, mmap_mapper, q, vma);
-	q->is_mmapped = 1;
+	for (i = 0; i < VIDEO_MAX_FRAME; i++) {
+		struct videobuf_buffer *buf = q->bufs[i];
+
+		if (buf && buf->memory == V4L2_MEMORY_MMAP &&
+		    buf->boff == (vma->vm_pgoff << PAGE_SHIFT)) {
+			rc = CALL(q, mmap_mapper, q, buf, vma);
+			if (rc == 0)
+				q->is_mmapped = 1;
+			break;
+		}
+	}
 	mutex_unlock(&q->vb_lock);
 
-	return retval;
+	return rc;
 }
 
 #ifdef CONFIG_VIDEO_V4L1_COMPAT
diff --git a/drivers/media/video/videobuf-dma-contig.c b/drivers/media/video/videobuf-dma-contig.c
index 22c0109..5025c0b 100644
--- a/drivers/media/video/videobuf-dma-contig.c
+++ b/drivers/media/video/videobuf-dma-contig.c
@@ -189,7 +189,7 @@ static int videobuf_dma_contig_user_get(struct videobuf_dma_contig_memory *mem,
 	return ret;
 }
 
-static void *__videobuf_alloc(size_t size)
+static struct videobuf_buffer *__videobuf_alloc(size_t size)
 {
 	struct videobuf_dma_contig_memory *mem;
 	struct videobuf_buffer *vb;
@@ -276,6 +276,7 @@ static int __videobuf_mmap_free(struct videobuf_queue *q)
 }
 
 static int __videobuf_mmap_mapper(struct videobuf_queue *q,
+				  struct videobuf_buffer *buf,
 				  struct vm_area_struct *vma)
 {
 	struct videobuf_dma_contig_memory *mem;
@@ -285,42 +286,24 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
 	unsigned long size, offset = vma->vm_pgoff << PAGE_SHIFT;
 
 	dev_dbg(q->dev, "%s\n", __func__);
-	if (!(vma->vm_flags & VM_WRITE) || !(vma->vm_flags & VM_SHARED))
-		return -EINVAL;
-
-	/* look for first buffer to map */
-	for (first = 0; first < VIDEO_MAX_FRAME; first++) {
-		if (!q->bufs[first])
-			continue;
-
-		if (V4L2_MEMORY_MMAP != q->bufs[first]->memory)
-			continue;
-		if (q->bufs[first]->boff == offset)
-			break;
-	}
-	if (VIDEO_MAX_FRAME == first) {
-		dev_dbg(q->dev, "invalid user space offset [offset=0x%lx]\n",
-			offset);
-		return -EINVAL;
-	}
 
 	/* create mapping + update buffer list */
 	map = kzalloc(sizeof(struct videobuf_mapping), GFP_KERNEL);
 	if (!map)
 		return -ENOMEM;
 
-	q->bufs[first]->map = map;
+	buf->map = map;
 	map->start = vma->vm_start;
 	map->end = vma->vm_end;
 	map->q = q;
 
-	q->bufs[first]->baddr = vma->vm_start;
+	buf->baddr = vma->vm_start;
 
-	mem = q->bufs[first]->priv;
+	mem = buf->priv;
 	BUG_ON(!mem);
 	MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
 
-	mem->size = PAGE_ALIGN(q->bufs[first]->bsize);
+	mem->size = PAGE_ALIGN(buf->bsize);
 	mem->vaddr = dma_alloc_coherent(q->dev, mem->size,
 					&mem->dma_handle, GFP_KERNEL);
 	if (!mem->vaddr) {
@@ -353,7 +336,7 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
 
 	dev_dbg(q->dev, "mmap %p: q=%p %08lx-%08lx (%lx) pgoff %08lx buf %d\n",
 		map, q, vma->vm_start, vma->vm_end,
-		(long int) q->bufs[first]->bsize,
+		(long int)buf->bsize,
 		vma->vm_pgoff, first);
 
 	videobuf_vm_open(vma);
@@ -365,68 +348,14 @@ error:
 	return -ENOMEM;
 }
 
-static int __videobuf_copy_to_user(struct videobuf_queue *q,
-				   char __user *data, size_t count,
-				   int nonblocking)
-{
-	struct videobuf_dma_contig_memory *mem = q->read_buf->priv;
-	void *vaddr;
-
-	BUG_ON(!mem);
-	MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
-	BUG_ON(!mem->vaddr);
-
-	/* copy to userspace */
-	if (count > q->read_buf->size - q->read_off)
-		count = q->read_buf->size - q->read_off;
-
-	vaddr = mem->vaddr;
-
-	if (copy_to_user(data, vaddr + q->read_off, count))
-		return -EFAULT;
-
-	return count;
-}
-
-static int __videobuf_copy_stream(struct videobuf_queue *q,
-				  char __user *data, size_t count, size_t pos,
-				  int vbihack, int nonblocking)
-{
-	unsigned int  *fc;
-	struct videobuf_dma_contig_memory *mem = q->read_buf->priv;
-
-	BUG_ON(!mem);
-	MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
-
-	if (vbihack) {
-		/* dirty, undocumented hack -- pass the frame counter
-			* within the last four bytes of each vbi data block.
-			* We need that one to maintain backward compatibility
-			* to all vbi decoding software out there ... */
-		fc = (unsigned int *)mem->vaddr;
-		fc += (q->read_buf->size >> 2) - 1;
-		*fc = q->read_buf->field_count >> 1;
-		dev_dbg(q->dev, "vbihack: %d\n", *fc);
-	}
-
-	/* copy stuff using the common method */
-	count = __videobuf_copy_to_user(q, data, count, nonblocking);
-
-	if ((count == -EFAULT) && (pos == 0))
-		return -EFAULT;
-
-	return count;
-}
-
 static struct videobuf_qtype_ops qops = {
 	.magic        = MAGIC_QTYPE_OPS,
 
 	.alloc        = __videobuf_alloc,
+	.vaddr        = __videobuf_to_vmalloc,
 	.iolock       = __videobuf_iolock,
 	.mmap_free    = __videobuf_mmap_free,
 	.mmap_mapper  = __videobuf_mmap_mapper,
-	.video_copy_to_user = __videobuf_copy_to_user,
-	.copy_stream  = __videobuf_copy_stream,
 	.vmalloc      = __videobuf_to_vmalloc,
 };
 
diff --git a/drivers/media/video/videobuf-dma-sg.c b/drivers/media/video/videobuf-dma-sg.c
index fcd045e..4994ae9 100644
--- a/drivers/media/video/videobuf-dma-sg.c
+++ b/drivers/media/video/videobuf-dma-sg.c
@@ -412,7 +412,7 @@ static const struct vm_operations_struct videobuf_vm_ops =
 	struct videobuf_dma_sg_memory
  */
 
-static void *__videobuf_alloc(size_t size)
+static struct videobuf_buffer *__videobuf_alloc(size_t size)
 {
 	struct videobuf_dma_sg_memory *mem;
 	struct videobuf_buffer *vb;
@@ -521,37 +521,21 @@ static int __videobuf_sync(struct videobuf_queue *q,
 	return	videobuf_dma_sync(q,&mem->dma);
 }
 
-static int __videobuf_mmap_free(struct videobuf_queue *q)
+static int __videobuf_mmap_free(struct videobuf_queue *q,
+				struct videobuf_buffer *buf)
 {
-	int i;
-
-	for (i = 0; i < VIDEO_MAX_FRAME; i++) {
-		if (q->bufs[i]) {
-			if (q->bufs[i]->map)
-				return -EBUSY;
-		}
-	}
-
-	return 0;
+	return buf->map ? -EBUSY : 0;
 }
 
 static int __videobuf_mmap_mapper(struct videobuf_queue *q,
-			 struct vm_area_struct *vma)
+				  struct videobuf_buffer *buf,
+				  struct vm_area_struct *vma)
 {
-	struct videobuf_dma_sg_memory *mem;
 	struct videobuf_mapping *map;
 	unsigned int first,last,size,i;
 	int retval;
 
 	retval = -EINVAL;
-	if (!(vma->vm_flags & VM_WRITE)) {
-		dprintk(1,"mmap app bug: PROT_WRITE please\n");
-		goto done;
-	}
-	if (!(vma->vm_flags & VM_SHARED)) {
-		dprintk(1,"mmap app bug: MAP_SHARED please\n");
-		goto done;
-	}
 
 	/* This function maintains backwards compatibility with V4L1 and will
 	 * map more than one buffer if the vma length is equal to the combined
@@ -561,44 +545,40 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
 	 * TODO: Allow drivers to specify if they support this mode
 	 */
 
+	BUG_ON(!buf->priv);
+
 	/* look for first buffer to map */
 	for (first = 0; first < VIDEO_MAX_FRAME; first++) {
-		if (NULL == q->bufs[first])
-			continue;
-		mem=q->bufs[first]->priv;
-		BUG_ON(!mem);
-		MAGIC_CHECK(mem->magic,MAGIC_SG_MEM);
-
-		if (V4L2_MEMORY_MMAP != q->bufs[first]->memory)
-			continue;
-		if (q->bufs[first]->boff == (vma->vm_pgoff << PAGE_SHIFT))
+		if (buf == q->bufs[first]) {
+			size = PAGE_ALIGN(q->bufs[last]->bsize);
 			break;
-	}
-	if (VIDEO_MAX_FRAME == first) {
-		dprintk(1,"mmap app bug: offset invalid [offset=0x%lx]\n",
-			(vma->vm_pgoff << PAGE_SHIFT));
-		goto done;
+		}
 	}
 
-	/* look for last buffer to map */
-	for (size = 0, last = first; last < VIDEO_MAX_FRAME; last++) {
-		if (NULL == q->bufs[last])
-			continue;
-		if (V4L2_MEMORY_MMAP != q->bufs[last]->memory)
-			continue;
-		if (q->bufs[last]->map) {
-			retval = -EBUSY;
+	last = first;
+#ifdef CONFIG_VIDEO_V4L1_COMPAT
+	if (size != (vma->vm_end - vma->vm_start)) {
+		/* look for last buffer to map */
+		for (last = first + 1; last < VIDEO_MAX_FRAME; last++) {
+			if (NULL == q->bufs[last])
+				continue;
+			if (V4L2_MEMORY_MMAP != q->bufs[last]->memory)
+				continue;
+			if (q->bufs[last]->map) {
+				retval = -EBUSY;
+				goto done;
+			}
+			size += PAGE_ALIGN(q->bufs[last]->bsize);
+			if (size == (vma->vm_end - vma->vm_start))
+				break;
+		}
+		if (VIDEO_MAX_FRAME == last) {
+			dprintk(1,"mmap app bug: size invalid [size=0x%lx]\n",
+				(vma->vm_end - vma->vm_start));
 			goto done;
 		}
-		size += PAGE_ALIGN(q->bufs[last]->bsize);
-		if (size == (vma->vm_end - vma->vm_start))
-			break;
-	}
-	if (VIDEO_MAX_FRAME == last) {
-		dprintk(1,"mmap app bug: size invalid [size=0x%lx]\n",
-			(vma->vm_end - vma->vm_start));
-		goto done;
 	}
+#endif
 
 	/* create mapping + update buffer list */
 	retval = -ENOMEM;
@@ -631,64 +611,15 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
 	return retval;
 }
 
-static int __videobuf_copy_to_user ( struct videobuf_queue *q,
-				char __user *data, size_t count,
-				int nonblocking )
-{
-	struct videobuf_dma_sg_memory *mem = q->read_buf->priv;
-	BUG_ON(!mem);
-	MAGIC_CHECK(mem->magic,MAGIC_SG_MEM);
-
-	/* copy to userspace */
-	if (count > q->read_buf->size - q->read_off)
-		count = q->read_buf->size - q->read_off;
-
-	if (copy_to_user(data, mem->dma.vmalloc+q->read_off, count))
-		return -EFAULT;
-
-	return count;
-}
-
-static int __videobuf_copy_stream ( struct videobuf_queue *q,
-				char __user *data, size_t count, size_t pos,
-				int vbihack, int nonblocking )
-{
-	unsigned int  *fc;
-	struct videobuf_dma_sg_memory *mem = q->read_buf->priv;
-	BUG_ON(!mem);
-	MAGIC_CHECK(mem->magic,MAGIC_SG_MEM);
-
-	if (vbihack) {
-		/* dirty, undocumented hack -- pass the frame counter
-			* within the last four bytes of each vbi data block.
-			* We need that one to maintain backward compatibility
-			* to all vbi decoding software out there ... */
-		fc  = (unsigned int*)mem->dma.vmalloc;
-		fc += (q->read_buf->size>>2) -1;
-		*fc = q->read_buf->field_count >> 1;
-		dprintk(1,"vbihack: %d\n",*fc);
-	}
-
-	/* copy stuff using the common method */
-	count = __videobuf_copy_to_user (q,data,count,nonblocking);
-
-	if ( (count==-EFAULT) && (0 == pos) )
-		return -EFAULT;
-
-	return count;
-}
-
 static struct videobuf_qtype_ops sg_ops = {
 	.magic        = MAGIC_QTYPE_OPS,
 
 	.alloc        = __videobuf_alloc,
+	.vaddr 	      = __videobuf_to_vmalloc,
 	.iolock       = __videobuf_iolock,
 	.sync         = __videobuf_sync,
 	.mmap_free    = __videobuf_mmap_free,
 	.mmap_mapper  = __videobuf_mmap_mapper,
-	.video_copy_to_user = __videobuf_copy_to_user,
-	.copy_stream  = __videobuf_copy_stream,
-	.vmalloc      = __videobuf_to_vmalloc,
 };
 
 void *videobuf_sg_alloc(size_t size)
diff --git a/drivers/media/video/videobuf-vmalloc.c b/drivers/media/video/videobuf-vmalloc.c
index 136e093..94b3dc2 100644
--- a/drivers/media/video/videobuf-vmalloc.c
+++ b/drivers/media/video/videobuf-vmalloc.c
@@ -132,7 +132,7 @@ static const struct vm_operations_struct videobuf_vm_ops =
 	struct videobuf_dma_sg_memory
  */
 
-static void *__videobuf_alloc(size_t size)
+static struct videobuf_buffer *__videobuf_alloc(size_t size)
 {
 	struct videobuf_vmalloc_memory *mem;
 	struct videobuf_buffer *vb;
@@ -234,63 +234,39 @@ static int __videobuf_sync(struct videobuf_queue *q,
 	return 0;
 }
 
-static int __videobuf_mmap_free(struct videobuf_queue *q)
+static int __videobuf_mmap_free(struct videobuf_queue *q,
+			   struct videobuf_buffer *buf)
 {
-	unsigned int i;
-
 	dprintk(1, "%s\n", __func__);
-	for (i = 0; i < VIDEO_MAX_FRAME; i++) {
-		if (q->bufs[i]) {
-			if (q->bufs[i]->map)
+			if (buf->map)
 				return -EBUSY;
-		}
-	}
 
 	return 0;
 }
 
 static int __videobuf_mmap_mapper(struct videobuf_queue *q,
+				 struct videobuf_buffer *buf,
 			 struct vm_area_struct *vma)
 {
 	struct videobuf_vmalloc_memory *mem;
 	struct videobuf_mapping *map;
-	unsigned int first;
 	int retval, pages;
-	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
 
 	dprintk(1, "%s\n", __func__);
-	if (!(vma->vm_flags & VM_WRITE) || !(vma->vm_flags & VM_SHARED))
-		return -EINVAL;
-
-	/* look for first buffer to map */
-	for (first = 0; first < VIDEO_MAX_FRAME; first++) {
-		if (NULL == q->bufs[first])
-			continue;
-
-		if (V4L2_MEMORY_MMAP != q->bufs[first]->memory)
-			continue;
-		if (q->bufs[first]->boff == offset)
-			break;
-	}
-	if (VIDEO_MAX_FRAME == first) {
-		dprintk(1,"mmap app bug: offset invalid [offset=0x%lx]\n",
-			(vma->vm_pgoff << PAGE_SHIFT));
-		return -EINVAL;
-	}
 
 	/* create mapping + update buffer list */
 	map = kzalloc(sizeof(struct videobuf_mapping), GFP_KERNEL);
 	if (NULL == map)
 		return -ENOMEM;
 
-	q->bufs[first]->map = map;
+	buf->map = map;
 	map->start = vma->vm_start;
 	map->end   = vma->vm_end;
 	map->q     = q;
 
-	q->bufs[first]->baddr = vma->vm_start;
+	buf->baddr = vma->vm_start;
 
-	mem = q->bufs[first]->priv;
+	mem = buf->priv;
 	BUG_ON(!mem);
 	MAGIC_CHECK(mem->magic, MAGIC_VMAL_MEM);
 
@@ -317,8 +293,8 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
 
 	dprintk(1,"mmap %p: q=%p %08lx-%08lx (%lx) pgoff %08lx buf %d\n",
 		map, q, vma->vm_start, vma->vm_end,
-		(long int) q->bufs[first]->bsize,
-		vma->vm_pgoff, first);
+		(long int) buf->bsize,
+		vma->vm_pgoff, buf->i);
 
 	videobuf_vm_open(vma);
 
@@ -330,66 +306,15 @@ error:
 	return -ENOMEM;
 }
 
-static int __videobuf_copy_to_user ( struct videobuf_queue *q,
-				char __user *data, size_t count,
-				int nonblocking )
-{
-	struct videobuf_vmalloc_memory *mem=q->read_buf->priv;
-	BUG_ON (!mem);
-	MAGIC_CHECK(mem->magic,MAGIC_VMAL_MEM);
-
-	BUG_ON (!mem->vmalloc);
-
-	/* copy to userspace */
-	if (count > q->read_buf->size - q->read_off)
-		count = q->read_buf->size - q->read_off;
-
-	if (copy_to_user(data, mem->vmalloc+q->read_off, count))
-		return -EFAULT;
-
-	return count;
-}
-
-static int __videobuf_copy_stream ( struct videobuf_queue *q,
-				char __user *data, size_t count, size_t pos,
-				int vbihack, int nonblocking )
-{
-	unsigned int  *fc;
-	struct videobuf_vmalloc_memory *mem=q->read_buf->priv;
-	BUG_ON (!mem);
-	MAGIC_CHECK(mem->magic,MAGIC_VMAL_MEM);
-
-	if (vbihack) {
-		/* dirty, undocumented hack -- pass the frame counter
-			* within the last four bytes of each vbi data block.
-			* We need that one to maintain backward compatibility
-			* to all vbi decoding software out there ... */
-		fc  = (unsigned int*)mem->vmalloc;
-		fc += (q->read_buf->size>>2) -1;
-		*fc = q->read_buf->field_count >> 1;
-		dprintk(1,"vbihack: %d\n",*fc);
-	}
-
-	/* copy stuff using the common method */
-	count = __videobuf_copy_to_user (q,data,count,nonblocking);
-
-	if ( (count==-EFAULT) && (0 == pos) )
-		return -EFAULT;
-
-	return count;
-}
-
 static struct videobuf_qtype_ops qops = {
 	.magic        = MAGIC_QTYPE_OPS,
 
 	.alloc        = __videobuf_alloc,
+	.vaddr        = videobuf_to_vmalloc,
 	.iolock       = __videobuf_iolock,
 	.sync         = __videobuf_sync,
 	.mmap_free    = __videobuf_mmap_free,
 	.mmap_mapper  = __videobuf_mmap_mapper,
-	.video_copy_to_user = __videobuf_copy_to_user,
-	.copy_stream  = __videobuf_copy_stream,
-	.vmalloc      = videobuf_to_vmalloc,
 };
 
 void videobuf_queue_vmalloc_init(struct videobuf_queue* q,
diff --git a/include/media/videobuf-core.h b/include/media/videobuf-core.h
index 316fdcc..aefcf7f 100644
--- a/include/media/videobuf-core.h
+++ b/include/media/videobuf-core.h
@@ -127,30 +127,18 @@ struct videobuf_queue_ops {
 struct videobuf_qtype_ops {
 	u32                     magic;
 
-	void *(*alloc)		(size_t size);
-	void *(*vmalloc)	(struct videobuf_buffer *buf);
+	struct videobuf_buffer *(*alloc)(size_t size);
+	void *(*vaddr)		(struct videobuf_buffer *buf);
 	int (*iolock)		(struct videobuf_queue* q,
 				 struct videobuf_buffer *vb,
 				 struct v4l2_framebuffer *fbuf);
-	int (*mmap)		(struct videobuf_queue *q,
-				 unsigned int *count,
-				 unsigned int *size,
-				 enum v4l2_memory memory);
 	int (*sync)		(struct videobuf_queue* q,
 				 struct videobuf_buffer *buf);
-	int (*video_copy_to_user)(struct videobuf_queue *q,
-				 char __user *data,
-				 size_t count,
-				 int nonblocking);
-	int (*copy_stream)	(struct videobuf_queue *q,
-				 char __user *data,
-				 size_t count,
-				 size_t pos,
-				 int vbihack,
-				 int nonblocking);
-	int (*mmap_free)	(struct videobuf_queue *q);
+	int (*mmap_free)	(struct videobuf_queue *q,
+				 struct videobuf_buffer *buf);
 	int (*mmap_mapper)	(struct videobuf_queue *q,
-				struct vm_area_struct *vma);
+				 struct videobuf_buffer *buf,
+				 struct vm_area_struct *vma);
 };
 
 struct videobuf_queue {

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
