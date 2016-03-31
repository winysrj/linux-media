Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35911 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071AbcCaIf5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Mar 2016 04:35:57 -0400
Received: by mail-wm0-f68.google.com with SMTP id 20so21521880wmh.3
        for <linux-media@vger.kernel.org>; Thu, 31 Mar 2016 01:35:57 -0700 (PDT)
From: Chris Wilson <chris@chris-wilson.co.uk>
To: intel-gfx@lists.freedesktop.org
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org
Subject: [PATCH] dma-buf: Release module reference on creation failure
Date: Thu, 31 Mar 2016 09:35:50 +0100
Message-Id: <1459413350-31082-1-git-send-email-chris@chris-wilson.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If we fail to create the anon file, we need to remember to release the
module reference on the owner.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: linaro-mm-sig@lists.linaro.org
---
 drivers/dma-buf/dma-buf.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 4a2c07ee6677..6f0f0b10a241 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -333,6 +333,7 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
 	struct reservation_object *resv = exp_info->resv;
 	struct file *file;
 	size_t alloc_size = sizeof(struct dma_buf);
+	int ret;
 
 	if (!exp_info->resv)
 		alloc_size += sizeof(struct reservation_object);
@@ -356,8 +357,8 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
 
 	dmabuf = kzalloc(alloc_size, GFP_KERNEL);
 	if (!dmabuf) {
-		module_put(exp_info->owner);
-		return ERR_PTR(-ENOMEM);
+		ret = -ENOMEM;
+		goto free_module;
 	}
 
 	dmabuf->priv = exp_info->priv;
@@ -378,8 +379,8 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
 	file = anon_inode_getfile("dmabuf", &dma_buf_fops, dmabuf,
 					exp_info->flags);
 	if (IS_ERR(file)) {
-		kfree(dmabuf);
-		return ERR_CAST(file);
+		ret = PTR_ERR(file);
+		goto free_dmabuf;
 	}
 
 	file->f_mode |= FMODE_LSEEK;
@@ -393,6 +394,12 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
 	mutex_unlock(&db_list.lock);
 
 	return dmabuf;
+
+free_dmabuf:
+	kfree(dmabuf);
+free_module:
+	module_put(exp_info->owner);
+	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL_GPL(dma_buf_export);
 
-- 
2.8.0.rc3

