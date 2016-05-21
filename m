Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:34304 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbcEUNXi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 May 2016 09:23:38 -0400
From: Muhammad Falak R Wani <falakreyaz@gmail.com>
To: Sumit Semwal <sumit.semwal@linaro.org>
Cc: linux-media@vger.kernel.org (open list:DMA BUFFER SHARING FRAMEWORK),
	dri-devel@lists.freedesktop.org (open list:DMA BUFFER SHARING FRAMEWORK),
	linaro-mm-sig@lists.linaro.org (moderated list:DMA BUFFER SHARING
	FRAMEWORK), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] dma-buf: use vma_pages().
Date: Sat, 21 May 2016 18:53:32 +0530
Message-Id: <1463837013-17074-1-git-send-email-falakreyaz@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace explicit computation of vma page count by a call to
vma_pages()

Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>
---
 drivers/dma-buf/dma-buf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 4a2c07e..b0317ec 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -90,7 +90,7 @@ static int dma_buf_mmap_internal(struct file *file, struct vm_area_struct *vma)
 	dmabuf = file->private_data;
 
 	/* check for overflowing the buffer's size */
-	if (vma->vm_pgoff + ((vma->vm_end - vma->vm_start) >> PAGE_SHIFT) >
+	if (vma->vm_pgoff + vma_pages(vma) >
 	    dmabuf->size >> PAGE_SHIFT)
 		return -EINVAL;
 
@@ -723,11 +723,11 @@ int dma_buf_mmap(struct dma_buf *dmabuf, struct vm_area_struct *vma,
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

