Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:36071 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbbEHNns (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 May 2015 09:43:48 -0400
Received: by pdea3 with SMTP id a3so84425738pde.3
        for <linux-media@vger.kernel.org>; Fri, 08 May 2015 06:43:47 -0700 (PDT)
From: Sumit Semwal <sumit.semwal@linaro.org>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org, rmk+kernel@arm.linux.org.uk,
	airlied@linux.ie, kgene@kernel.org, thierry.reding@gmail.com,
	pawel@osciak.com, m.szyprowski@samsung.com,
	mchehab@osg.samsung.com, gregkh@linuxfoundation.org
Cc: linaro-kernel@lists.linaro.org, robdclark@gmail.com,
	daniel@ffwll.ch, Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH v3] dma-buf: add ref counting for module as exporter
Date: Fri,  8 May 2015 19:12:43 +0530
Message-Id: <1431092563-19799-1-git-send-email-sumit.semwal@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add reference counting on a kernel module that exports dma-buf and
implements its operations. This prevents the module from being unloaded
while DMABUF file is in use.

The original patch [1] was submitted by Tomasz Stanislawski, but this
is a simpler way to do it.

v3: call module_put() as late as possible, per gregkh's comment.
v2: move owner to struct dma_buf, and use DEFINE_DMA_BUF_EXPORT_INFO
    macro to simplify the change.

Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>

[1]: https://lkml.org/lkml/2012/8/8/163
---
 drivers/dma-buf/dma-buf.c | 10 +++++++++-
 include/linux/dma-buf.h   | 10 ++++++++--
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index c5a9138a6a8d..63a9914e42b8 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -29,6 +29,7 @@
 #include <linux/anon_inodes.h>
 #include <linux/export.h>
 #include <linux/debugfs.h>
+#include <linux/module.h>
 #include <linux/seq_file.h>
 #include <linux/poll.h>
 #include <linux/reservation.h>
@@ -72,6 +73,7 @@ static int dma_buf_release(struct inode *inode, struct file *file)
 	if (dmabuf->resv == (struct reservation_object *)&dmabuf[1])
 		reservation_object_fini(dmabuf->resv);
 
+	module_put(dmabuf->owner);
 	kfree(dmabuf);
 	return 0;
 }
@@ -302,14 +304,20 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
 		return ERR_PTR(-EINVAL);
 	}
 
+	if (!try_module_get(exp_info->owner))
+		return ERR_PTR(-ENOENT);
+
 	dmabuf = kzalloc(alloc_size, GFP_KERNEL);
-	if (dmabuf == NULL)
+	if (!dmabuf) {
+		module_put(exp_info->owner);
 		return ERR_PTR(-ENOMEM);
+	}
 
 	dmabuf->priv = exp_info->priv;
 	dmabuf->ops = exp_info->ops;
 	dmabuf->size = exp_info->size;
 	dmabuf->exp_name = exp_info->exp_name;
+	dmabuf->owner = exp_info->owner;
 	init_waitqueue_head(&dmabuf->poll);
 	dmabuf->cb_excl.poll = dmabuf->cb_shared.poll = &dmabuf->poll;
 	dmabuf->cb_excl.active = dmabuf->cb_shared.active = 0;
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index 2f0b431b73e0..f98bd7068d55 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -115,6 +115,8 @@ struct dma_buf_ops {
  * @attachments: list of dma_buf_attachment that denotes all devices attached.
  * @ops: dma_buf_ops associated with this buffer object.
  * @exp_name: name of the exporter; useful for debugging.
+ * @owner: pointer to exporter module; used for refcounting when exporter is a
+ *         kernel module.
  * @list_node: node for dma_buf accounting and debugging.
  * @priv: exporter specific private data for this buffer object.
  * @resv: reservation object linked to this dma-buf
@@ -129,6 +131,7 @@ struct dma_buf {
 	unsigned vmapping_counter;
 	void *vmap_ptr;
 	const char *exp_name;
+	struct module *owner;
 	struct list_head list_node;
 	void *priv;
 	struct reservation_object *resv;
@@ -164,7 +167,8 @@ struct dma_buf_attachment {
 
 /**
  * struct dma_buf_export_info - holds information needed to export a dma_buf
- * @exp_name:	name of the exporting module - useful for debugging.
+ * @exp_name:	name of the exporter - useful for debugging.
+ * @owner:	pointer to exporter module - used for refcounting kernel module
  * @ops:	Attach allocator-defined dma buf ops to the new buffer
  * @size:	Size of the buffer
  * @flags:	mode flags for the file
@@ -176,6 +180,7 @@ struct dma_buf_attachment {
  */
 struct dma_buf_export_info {
 	const char *exp_name;
+	struct module *owner;
 	const struct dma_buf_ops *ops;
 	size_t size;
 	int flags;
@@ -187,7 +192,8 @@ struct dma_buf_export_info {
  * helper macro for exporters; zeros and fills in most common values
  */
 #define DEFINE_DMA_BUF_EXPORT_INFO(a)	\
-	struct dma_buf_export_info a = { .exp_name = KBUILD_MODNAME }
+	struct dma_buf_export_info a = { .exp_name = KBUILD_MODNAME, \
+					 .owner = THIS_MODULE }
 
 /**
  * get_dma_buf - convenience wrapper for get_file.
-- 
1.9.1

