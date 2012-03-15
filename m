Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43352 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031446Ab2COBcl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Mar 2012 21:32:41 -0400
Received: by gghe5 with SMTP id e5so2531877ggh.19
        for <linux-media@vger.kernel.org>; Wed, 14 Mar 2012 18:32:40 -0700 (PDT)
From: Rob Clark <rob.clark@linaro.org>
To: linaro-mm-sig@lists.linaro.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org
Cc: patches@linaro.org, sumit.semwal@linaro.org, daniel@ffwll.ch,
	rschultz@google.com, Rob Clark <rob@ti.com>
Subject: [PATCH] RFC: dma-buf: userspace mmap support
Date: Wed, 14 Mar 2012 20:32:28 -0500
Message-Id: <1331775148-5001-1-git-send-email-rob.clark@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Rob Clark <rob@ti.com>

Enable optional userspace access to dma-buf buffers via mmap() on the
dma-buf file descriptor.  Userspace access to the buffer should be
bracketed with DMA_BUF_IOCTL_{PREPARE,FINISH}_ACCESS ioctl calls to
give the exporting driver a chance to deal with cache synchronization
and such for cached userspace mappings without resorting to page
faulting tricks.  The reasoning behind this is that, while drm
drivers tend to have all the mechanisms in place for dealing with
page faulting tricks, other driver subsystems may not.  And in
addition, while page faulting tricks make userspace simpler, there
are some associated overheads.

In all cases, the mmap() call is allowed to fail, and the associated
dma_buf_ops are optional (mmap() will fail if at least the mmap()
op is not implemented by the exporter, but in either case the
{prepare,finish}_access() ops are optional).

For now the prepare/finish access ioctls are kept simple with no
argument, although there is possibility to add additional ioctls
(or simply change the existing ioctls from _IO() to _IOW()) later
to provide optimization to allow userspace to specify a region of
interest.

For a final patch, dma-buf.h would need to be split into what is
exported to userspace, and what is kernel private, but I wanted to
get feedback on the idea of requiring userspace to bracket access
first (vs. limiting this to coherent mappings or exporters who play
page faltings plus PTE shoot-down games) before I split the header
which would cause conflicts with other pending dma-buf patches.  So
flame-on!
---
 drivers/base/dma-buf.c  |   42 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/dma-buf.h |   22 ++++++++++++++++++++++
 2 files changed, 64 insertions(+), 0 deletions(-)

diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
index c9a945f..382b78a 100644
--- a/drivers/base/dma-buf.c
+++ b/drivers/base/dma-buf.c
@@ -30,6 +30,46 @@
 
 static inline int is_dma_buf_file(struct file *);
 
+static int dma_buf_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct dma_buf *dmabuf;
+
+	if (!is_dma_buf_file(file))
+		return -EINVAL;
+
+	dmabuf = file->private_data;
+
+	if (dmabuf->ops->mmap)
+		return dmabuf->ops->mmap(dmabuf, file, vma);
+
+	return -ENODEV;
+}
+
+static long dma_buf_ioctl(struct file *file, unsigned int cmd,
+		unsigned long arg)
+{
+	struct dma_buf *dmabuf;
+
+	if (!is_dma_buf_file(file))
+		return -EINVAL;
+
+	dmabuf = file->private_data;
+
+	switch (_IOC_NR(cmd)) {
+	case _IOC_NR(DMA_BUF_IOCTL_PREPARE_ACCESS):
+		if (dmabuf->ops->prepare_access)
+			return dmabuf->ops->prepare_access(dmabuf);
+		return 0;
+	case _IOC_NR(DMA_BUF_IOCTL_FINISH_ACCESS):
+		if (dmabuf->ops->finish_access)
+			return dmabuf->ops->finish_access(dmabuf);
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
+
 static int dma_buf_release(struct inode *inode, struct file *file)
 {
 	struct dma_buf *dmabuf;
@@ -45,6 +85,8 @@ static int dma_buf_release(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations dma_buf_fops = {
+	.mmap 		= dma_buf_mmap,
+	.unlocked_ioctl = dma_buf_ioctl,
 	.release	= dma_buf_release,
 };
 
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index a885b26..cbdff81 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -34,6 +34,17 @@
 struct dma_buf;
 struct dma_buf_attachment;
 
+/* TODO: dma-buf.h should be the userspace visible header, and dma-buf-priv.h (?)
+ * the kernel internal header.. for now just stuff these here to avoid conflicting
+ * with other patches..
+ *
+ * For now, no arg to keep things simple, but we could consider adding an
+ * optional region of interest later.
+ */
+#define DMA_BUF_IOCTL_PREPARE_ACCESS   _IO('Z', 0)
+#define DMA_BUF_IOCTL_FINISH_ACCESS    _IO('Z', 1)
+
+
 /**
  * struct dma_buf_ops - operations possible on struct dma_buf
  * @attach: [optional] allows different devices to 'attach' themselves to the
@@ -49,6 +60,13 @@ struct dma_buf_attachment;
  * @unmap_dma_buf: decreases usecount of buffer, might deallocate scatter
  *		   pages.
  * @release: release this buffer; to be called after the last dma_buf_put.
+ * @mmap: [optional, allowed to fail] operation called if userspace calls
+ *		 mmap() on the dmabuf fd.  Note that userspace should use the
+ *		 DMA_BUF_PREPARE_ACCESS / DMA_BUF_FINISH_ACCESS ioctls before/after
+ *		 sw access to the buffer, to give the exporter an opportunity to
+ *		 deal with cache maintenance.
+ * @prepare_access: [optional] handler for PREPARE_ACCESS ioctl.
+ * @finish_access: [optional] handler for FINISH_ACCESS ioctl.
  */
 struct dma_buf_ops {
 	int (*attach)(struct dma_buf *, struct device *,
@@ -72,6 +90,10 @@ struct dma_buf_ops {
 	/* after final dma_buf_put() */
 	void (*release)(struct dma_buf *);
 
+	int (*mmap)(struct dma_buf *, struct file *, struct vm_area_struct *);
+	int (*prepare_access)(struct dma_buf *);
+	int (*finish_access)(struct dma_buf *);
+
 };
 
 /**
-- 
1.7.5.4

