Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:14572 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab1KQJIZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Nov 2011 04:08:25 -0500
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LUS0022YS1Z7W@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 17 Nov 2011 09:08:23 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LUS005YPS1YDS@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 17 Nov 2011 09:08:22 +0000 (GMT)
Date: Thu, 17 Nov 2011 10:08:11 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH] media: vb2: fix potential deadlock in mmap vs. get_userptr
 handling
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Message-id: <1321520891-30769-1-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To get direct access to userspace memory pages vb2 allocator needs to
gather read access on mmap semaphore in the current process.
The same semaphore is taken before calling mmap operation, while
both mmap and qbuf are called by the driver or v4l2 core with
driver's lock held. To avoid a AB-BA deadlock (mmap_sem then
driver's lock in mmap and driver's lock then mmap_sem in qbuf)
the videobuf2 core release driver's lock, takes mmap_sem and then
takes again driver's lock. get_userptr methods are now called with
all needed locks already taken to avoid further lock magic inside
memory allocator's code.

Reported-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/videobuf2-core.c   |   51 ++++++++++++++++++++++++++-----
 drivers/media/video/videobuf2-dma-sg.c |    3 +-
 drivers/media/video/videobuf2-memops.c |   28 ++++++-----------
 3 files changed, 53 insertions(+), 29 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index 4d22b82..a3a9bf9 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -1082,46 +1082,76 @@ EXPORT_SYMBOL_GPL(vb2_prepare_buf);
  */
 int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 {
+	struct rw_semaphore *mmap_sem = NULL;
 	struct vb2_buffer *vb;
-	int ret;
+	int ret = 0;
+
+	/*
+	 * In case of user pointer buffers vb2 allocator needs to get direct
+	 * access to userspace pages. This requires getting read access on
+	 * mmap semaphore in the current process structure. The same
+	 * semaphore is taken before calling mmap operation, while both mmap
+	 * and qbuf are called by the driver or v4l2 core with driver's lock
+	 * held. To avoid a AB-BA deadlock (mmap_sem then driver's lock in
+	 * mmap and driver's lock then mmap_sem in qbuf) the videobuf2 core
+	 * release driver's lock, takes mmap_sem and then takes again driver's
+	 * lock.
+	 *
+	 * To avoid race with other vb2 calls, which might be called after
+	 * releasing driver's lock, this operation is performed at the
+	 * beggining of qbuf processing. This way the queue status is
+	 * consistent after getting driver's lock back.
+	 */
+	if (b->type == V4L2_MEMORY_USERPTR) {
+		mmap_sem = &current->mm->mmap_sem;
+		call_qop(q, wait_prepare, q);
+		down_read(mmap_sem);
+		call_qop(q, wait_finish, q);
+	}
 
 	if (q->fileio) {
 		dprintk(1, "qbuf: file io in progress\n");
-		return -EBUSY;
+		ret = -EBUSY;
+		goto unlock;
 	}
 
 	if (b->type != q->type) {
 		dprintk(1, "qbuf: invalid buffer type\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto unlock;
 	}
 
 	if (b->index >= q->num_buffers) {
 		dprintk(1, "qbuf: buffer index out of range\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto unlock;
 	}
 
 	vb = q->bufs[b->index];
 	if (NULL == vb) {
 		/* Should never happen */
 		dprintk(1, "qbuf: buffer is NULL\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto unlock;
 	}
 
 	if (b->memory != q->memory) {
 		dprintk(1, "qbuf: invalid memory type\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto unlock;
 	}
 
 	switch (vb->state) {
 	case VB2_BUF_STATE_DEQUEUED:
 		ret = __buf_prepare(vb, b);
 		if (ret)
-			return ret;
+			goto unlock;
 	case VB2_BUF_STATE_PREPARED:
 		break;
 	default:
 		dprintk(1, "qbuf: buffer already in use\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto unlock;
 	}
 
 	/*
@@ -1142,7 +1172,10 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 	__fill_v4l2_buffer(vb, b);
 
 	dprintk(1, "qbuf of buffer %d succeeded\n", vb->v4l2_buf.index);
-	return 0;
+unlock:
+	if (mmap_sem)
+		up_read(mmap_sem);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(vb2_qbuf);
 
diff --git a/drivers/media/video/videobuf2-dma-sg.c b/drivers/media/video/videobuf2-dma-sg.c
index 3bad8b1..25c3b36 100644
--- a/drivers/media/video/videobuf2-dma-sg.c
+++ b/drivers/media/video/videobuf2-dma-sg.c
@@ -140,7 +140,6 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
 	if (!buf->pages)
 		goto userptr_fail_pages_array_alloc;
 
-	down_read(&current->mm->mmap_sem);
 	num_pages_from_user = get_user_pages(current, current->mm,
 					     vaddr & PAGE_MASK,
 					     buf->sg_desc.num_pages,
@@ -148,7 +147,7 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
 					     1, /* force */
 					     buf->pages,
 					     NULL);
-	up_read(&current->mm->mmap_sem);
+
 	if (num_pages_from_user != buf->sg_desc.num_pages)
 		goto userptr_fail_get_user_pages;
 
diff --git a/drivers/media/video/videobuf2-memops.c b/drivers/media/video/videobuf2-memops.c
index 71a7a78..c41cb60 100644
--- a/drivers/media/video/videobuf2-memops.c
+++ b/drivers/media/video/videobuf2-memops.c
@@ -100,29 +100,26 @@ int vb2_get_contig_userptr(unsigned long vaddr, unsigned long size,
 	unsigned long offset, start, end;
 	unsigned long this_pfn, prev_pfn;
 	dma_addr_t pa = 0;
-	int ret = -EFAULT;
 
 	start = vaddr;
 	offset = start & ~PAGE_MASK;
 	end = start + size;
 
-	down_read(&mm->mmap_sem);
 	vma = find_vma(mm, start);
 
 	if (vma == NULL || vma->vm_end < end)
-		goto done;
+		return -EFAULT;
 
 	for (prev_pfn = 0; start < end; start += PAGE_SIZE) {
-		ret = follow_pfn(vma, start, &this_pfn);
+		int ret = follow_pfn(vma, start, &this_pfn);
 		if (ret)
-			goto done;
+			return ret;
 
 		if (prev_pfn == 0)
 			pa = this_pfn << PAGE_SHIFT;
-		else if (this_pfn != prev_pfn + 1) {
-			ret = -EFAULT;
-			goto done;
-		}
+		else if (this_pfn != prev_pfn + 1)
+			return -EFAULT;
+
 		prev_pfn = this_pfn;
 	}
 
@@ -130,16 +127,11 @@ int vb2_get_contig_userptr(unsigned long vaddr, unsigned long size,
 	 * Memory is contigous, lock vma and return to the caller
 	 */
 	*res_vma = vb2_get_vma(vma);
-	if (*res_vma == NULL) {
-		ret = -ENOMEM;
-		goto done;
-	}
-	*res_pa = pa + offset;
-	ret = 0;
+	if (*res_vma == NULL)
+		return -ENOMEM;
 
-done:
-	up_read(&mm->mmap_sem);
-	return ret;
+	*res_pa = pa + offset;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(vb2_get_contig_userptr);
 
-- 
1.7.1.569.g6f426

