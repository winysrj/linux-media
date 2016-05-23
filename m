Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:35387 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbcEWLix (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2016 07:38:53 -0400
From: Muhammad Falak R Wani <falakreyaz@gmail.com>
To: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Eric Engestrom <eric.engestrom@imgtec.com>,
	linux-media@vger.kernel.org (open list:DMA BUFFER SHARING FRAMEWORK),
	dri-devel@lists.freedesktop.org (open list:DMA BUFFER SHARING FRAMEWORK),
	linaro-mm-sig@lists.linaro.org (moderated list:DMA BUFFER SHARING
	FRAMEWORK), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2] dma-buf: use vma_pages().
Date: Mon, 23 May 2016 17:08:42 +0530
Message-Id: <1464003522-27682-1-git-send-email-falakreyaz@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace explicit computation of vma page count by a call to
vma_pages().
Also, include <linux/mm.h>

Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>
---
 drivers/dma-buf/dma-buf.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 4a2c07e..6355ab3 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -33,6 +33,7 @@
 #include <linux/seq_file.h>
 #include <linux/poll.h>
 #include <linux/reservation.h>
+#include <linux/mm.h>
 
 #include <uapi/linux/dma-buf.h>
 
@@ -90,7 +91,7 @@ static int dma_buf_mmap_internal(struct file *file, struct vm_area_struct *vma)
 	dmabuf = file->private_data;
 
 	/* check for overflowing the buffer's size */
-	if (vma->vm_pgoff + ((vma->vm_end - vma->vm_start) >> PAGE_SHIFT) >
+	if (vma->vm_pgoff + vma_pages(vma) >
 	    dmabuf->size >> PAGE_SHIFT)
 		return -EINVAL;
 
@@ -723,11 +724,11 @@ int dma_buf_mmap(struct dma_buf *dmabuf, struct vm_area_struct *vma,
 		return -EINVAL;
 
 	/* check for offset overflow */
-	if (pgoff + ((vma->vm_end - vma->vm_start) >> PAGE_SHIFT) < pgoff)
+	if (pgoff + vma_pages(vma) < pgoff)
 		return -EOVERFLOW;
 
 	/* check for overflowing the buffer's size */
-	if (pgoff + ((vma->vm_end - vma->vm_start) >> PAGE_SHIFT) >
+	if (pgoff + vma_pages(vma) >
 	    dmabuf->size >> PAGE_SHIFT)
 		return -EINVAL;
 
-- 
1.9.1

