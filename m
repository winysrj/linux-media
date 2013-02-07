Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f74.google.com ([209.85.219.74]:60275 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758536Ab3BGADr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2013 19:03:47 -0500
Received: by mail-oa0-f74.google.com with SMTP id k14so387565oag.5
        for <linux-media@vger.kernel.org>; Wed, 06 Feb 2013 16:03:46 -0800 (PST)
From: John Sheu <sheu@google.com>
To: linux-media@vger.kernel.org
Cc: John Sheu <sheu@chromium.org>, John Sheu <sheu@google.com>
Subject: [PATCH 3/3] dma-buf: restore args on failure of dma_buf_mmap
Date: Wed,  6 Feb 2013 16:03:02 -0800
Message-Id: <1360195382-32317-3-git-send-email-sheu@google.com>
In-Reply-To: <1360195382-32317-1-git-send-email-sheu@google.com>
References: <1360195382-32317-1-git-send-email-sheu@google.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: John Sheu <sheu@chromium.org>

Callers to dma_buf_mmap expect to fput() the vma struct's vm_file
themselves on failure.  Not restoring the struct's data on failure
causes a double-decrement of the vm_file's refcount.

Signed-off-by: John Sheu <sheu@google.com>
---
 drivers/base/dma-buf.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
index a3f79c4..01daf9c 100644
--- a/drivers/base/dma-buf.c
+++ b/drivers/base/dma-buf.c
@@ -446,6 +446,9 @@ EXPORT_SYMBOL_GPL(dma_buf_kunmap);
 int dma_buf_mmap(struct dma_buf *dmabuf, struct vm_area_struct *vma,
 		 unsigned long pgoff)
 {
+	struct file *oldfile;
+	int ret;
+
 	if (WARN_ON(!dmabuf || !vma))
 		return -EINVAL;
 
@@ -459,14 +462,21 @@ int dma_buf_mmap(struct dma_buf *dmabuf, struct vm_area_struct *vma,
 		return -EINVAL;
 
 	/* readjust the vma */
-	if (vma->vm_file)
-		fput(vma->vm_file);
-
+	oldfile = vma->vm_file;
 	vma->vm_file = get_file(dmabuf->file);
 
 	vma->vm_pgoff = pgoff;
 
-	return dmabuf->ops->mmap(dmabuf, vma);
+	ret = dmabuf->ops->mmap(dmabuf, vma);
+	if (ret) {
+		/* restore old parameters on failure */
+		vma->vm_file = oldfile;
+		fput(dmabuf->file);
+	} else {
+		if (oldfile)
+			fput(oldfile);
+	}
+	return ret;
 }
 EXPORT_SYMBOL_GPL(dma_buf_mmap);
 
-- 
1.8.1

