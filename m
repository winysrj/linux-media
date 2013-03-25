Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:48707 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755644Ab3CYLVd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Mar 2013 07:21:33 -0400
Received: by mail-pb0-f51.google.com with SMTP id rr4so1436836pbb.10
        for <linux-media@vger.kernel.org>; Mon, 25 Mar 2013 04:21:33 -0700 (PDT)
From: Sumit Semwal <sumit.semwal@linaro.org>
To: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org
Cc: patches@linaro.org, linaro-kernel@lists.linaro.org,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Dave Airlie <airlied@redhat.com>
Subject: [PATCH 2/2] dma-buf: Add debugfs support
Date: Mon, 25 Mar 2013 16:50:46 +0530
Message-Id: <1364210447-8125-3-git-send-email-sumit.semwal@linaro.org>
In-Reply-To: <1364210447-8125-1-git-send-email-sumit.semwal@linaro.org>
References: <1364210447-8125-1-git-send-email-sumit.semwal@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add debugfs support to make it easier to print debug information
about the dma-buf buffers.

Cc: Dave Airlie <airlied@redhat.com>
 [minor fixes on init and warning fix]
Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
---
changes since v1:
 - fixes on init and warnings as reported and corrected by Dave Airlie.
 - add locking while walking attachment list - reported by Daniel Vetter.

 drivers/base/dma-buf.c  |  162 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/dma-buf.h |    5 +-
 2 files changed, 166 insertions(+), 1 deletion(-)

diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
index d89102a..7d867ed 100644
--- a/drivers/base/dma-buf.c
+++ b/drivers/base/dma-buf.c
@@ -27,9 +27,18 @@
 #include <linux/dma-buf.h>
 #include <linux/anon_inodes.h>
 #include <linux/export.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
 
 static inline int is_dma_buf_file(struct file *);
 
+struct dma_buf_list {
+	struct list_head head;
+	struct mutex lock;
+};
+
+static struct dma_buf_list db_list;
+
 static int dma_buf_release(struct inode *inode, struct file *file)
 {
 	struct dma_buf *dmabuf;
@@ -42,6 +51,11 @@ static int dma_buf_release(struct inode *inode, struct file *file)
 	BUG_ON(dmabuf->vmapping_counter);
 
 	dmabuf->ops->release(dmabuf);
+
+	mutex_lock(&db_list.lock);
+	list_del(&dmabuf->list_node);
+	mutex_unlock(&db_list.lock);
+
 	kfree(dmabuf);
 	return 0;
 }
@@ -125,6 +139,10 @@ struct dma_buf *dma_buf_export_named(void *priv, const struct dma_buf_ops *ops,
 	mutex_init(&dmabuf->lock);
 	INIT_LIST_HEAD(&dmabuf->attachments);
 
+	mutex_lock(&db_list.lock);
+	list_add(&dmabuf->list_node, &db_list.head);
+	mutex_unlock(&db_list.lock);
+
 	return dmabuf;
 }
 EXPORT_SYMBOL_GPL(dma_buf_export_named);
@@ -551,3 +569,147 @@ void dma_buf_vunmap(struct dma_buf *dmabuf, void *vaddr)
 	mutex_unlock(&dmabuf->lock);
 }
 EXPORT_SYMBOL_GPL(dma_buf_vunmap);
+
+static int dma_buf_init_debugfs(void);
+static void dma_buf_uninit_debugfs(void);
+
+static int __init dma_buf_init(void)
+{
+	mutex_init(&db_list.lock);
+	INIT_LIST_HEAD(&db_list.head);
+	dma_buf_init_debugfs();
+	return 0;
+}
+
+subsys_initcall(dma_buf_init);
+
+static void __exit dma_buf_deinit(void)
+{
+	dma_buf_uninit_debugfs();
+}
+
+#ifdef CONFIG_DEBUG_FS
+static int dma_buf_describe(struct seq_file *s)
+{
+	int ret;
+	struct dma_buf *buf_obj;
+	struct dma_buf_attachment *attach_obj;
+	int count = 0, attach_count;
+	size_t size = 0;
+
+	ret = mutex_lock_interruptible(&db_list.lock);
+
+	if (ret)
+		return ret;
+
+	seq_printf(s, "\nDma-buf Objects:\n");
+	seq_printf(s, "\texp_name\tsize\tflags\tmode\tcount\n");
+
+	list_for_each_entry(buf_obj, &db_list.head, list_node) {
+		ret = mutex_lock_interruptible(&buf_obj->lock);
+
+		if (ret) {
+			seq_printf(s,
+				  "\tERROR locking buffer object: skipping\n");
+			goto skip_buffer;
+		}
+
+		seq_printf(s, "\t");
+
+		seq_printf(s, "\t%s\t%08zu\t%08x\t%08x\t%08d\n",
+				buf_obj->exp_name, buf_obj->size,
+				buf_obj->file->f_flags, buf_obj->file->f_mode,
+				buf_obj->file->f_count.counter);
+
+		seq_printf(s, "\t\tAttached Devices:\n");
+		attach_count = 0;
+
+		list_for_each_entry(attach_obj, &buf_obj->attachments, node) {
+			seq_printf(s, "\t\t");
+
+			seq_printf(s, "%s\n", attach_obj->dev->init_name);
+			attach_count++;
+		}
+
+		seq_printf(s, "\n\t\tTotal %d devices attached\n",
+				attach_count);
+
+		count++;
+		size += buf_obj->size;
+skip_buffer:
+		mutex_unlock(&buf_obj->lock);
+	}
+
+	seq_printf(s, "\nTotal %d objects, %zu bytes\n", count, size);
+
+	mutex_unlock(&db_list.lock);
+	return 0;
+}
+
+static int dma_buf_show(struct seq_file *s, void *unused)
+{
+	void (*func)(struct seq_file *) = s->private;
+	func(s);
+	return 0;
+}
+
+static int dma_buf_debug_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, dma_buf_show, inode->i_private);
+}
+
+static const struct file_operations dma_buf_debug_fops = {
+	.open           = dma_buf_debug_open,
+	.read           = seq_read,
+	.llseek         = seq_lseek,
+	.release        = single_release,
+};
+
+static struct dentry *dma_buf_debugfs_dir;
+
+static int dma_buf_init_debugfs(void)
+{
+	int err = 0;
+	dma_buf_debugfs_dir = debugfs_create_dir("dma_buf", NULL);
+	if (IS_ERR(dma_buf_debugfs_dir)) {
+		err = PTR_ERR(dma_buf_debugfs_dir);
+		dma_buf_debugfs_dir = NULL;
+		return err;
+	}
+
+	err = dma_buf_debugfs_create_file("bufinfo", dma_buf_describe);
+
+	if (err)
+		pr_debug("dma_buf: debugfs: failed to create node bufinfo\n");
+
+	return err;
+}
+
+static void dma_buf_uninit_debugfs(void)
+{
+	if (dma_buf_debugfs_dir)
+		debugfs_remove_recursive(dma_buf_debugfs_dir);
+}
+
+int dma_buf_debugfs_create_file(const char *name,
+				int (*write)(struct seq_file *))
+{
+	struct dentry *d;
+
+	d = debugfs_create_file(name, S_IRUGO, dma_buf_debugfs_dir,
+			write, &dma_buf_debug_fops);
+
+	if (IS_ERR(d))
+		return PTR_ERR(d);
+
+	return 0;
+}
+#else
+static inline int dma_buf_init_debugfs(void)
+{
+	return 0;
+}
+static inline void dma_buf_uninit_debugfs(void)
+{
+}
+#endif
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index 6f55c04..dfac5ed 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -113,6 +113,7 @@ struct dma_buf_ops {
  * @attachments: list of dma_buf_attachment that denotes all devices attached.
  * @ops: dma_buf_ops associated with this buffer object.
  * @exp_name: name of the exporter; useful for debugging.
+ * @list_node: node for dma_buf accounting and debugging.
  * @priv: exporter specific private data for this buffer object.
  */
 struct dma_buf {
@@ -125,6 +126,7 @@ struct dma_buf {
 	unsigned vmapping_counter;
 	void *vmap_ptr;
 	const char *exp_name;
+	struct list_head list_node;
 	void *priv;
 };
 
@@ -192,5 +194,6 @@ int dma_buf_mmap(struct dma_buf *, struct vm_area_struct *,
 		 unsigned long);
 void *dma_buf_vmap(struct dma_buf *);
 void dma_buf_vunmap(struct dma_buf *, void *vaddr);
-
+int dma_buf_debugfs_create_file(const char *name,
+				int (*write)(struct seq_file *));
 #endif /* __DMA_BUF_H__ */
-- 
1.7.10.4

