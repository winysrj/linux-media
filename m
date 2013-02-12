Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:62294 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932873Ab3BLB4l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Feb 2013 20:56:41 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so670404vea.0
        for <linux-media@vger.kernel.org>; Mon, 11 Feb 2013 17:56:39 -0800 (PST)
From: sheu@google.com
To: sumit.semwal@linaro.org
Cc: linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	John Sheu <sheu@google.com>
Subject: [PATCH] CHROMIUM: dma-buf: restore args on failure of dma_buf_mmap
Date: Mon, 11 Feb 2013 17:50:24 -0800
Message-Id: <1360633824-2563-1-git-send-email-sheu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: John Sheu <sheu@google.com>

Callers to dma_buf_mmap expect to fput() the vma struct's vm_file
themselves on failure.  Not restoring the struct's data on failure
causes a double-decrement of the vm_file's refcount.

Signed-off-by: John Sheu <sheu@google.com>

---
 drivers/base/dma-buf.c |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
index 09e6878..06c6225 100644
--- a/drivers/base/dma-buf.c
+++ b/drivers/base/dma-buf.c
@@ -536,6 +536,9 @@ EXPORT_SYMBOL_GPL(dma_buf_kunmap);
 int dma_buf_mmap(struct dma_buf *dmabuf, struct vm_area_struct *vma,
 		 unsigned long pgoff)
 {
+	struct file *oldfile;
+	int ret;
+
 	if (WARN_ON(!dmabuf || !vma))
 		return -EINVAL;
 
@@ -549,15 +552,21 @@ int dma_buf_mmap(struct dma_buf *dmabuf, struct vm_area_struct *vma,
 		return -EINVAL;
 
 	/* readjust the vma */
-	if (vma->vm_file)
-		fput(vma->vm_file);
-
+	get_file(dmabuf->file);
+	oldfile = vma->vm_file;
 	vma->vm_file = dmabuf->file;
-	get_file(vma->vm_file);
-
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
1.7.8.6

