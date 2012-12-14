Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:65375 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226Ab2LNK3H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Dec 2012 05:29:07 -0500
Received: by mail-bk0-f46.google.com with SMTP id q16so1602307bkw.19
        for <linux-media@vger.kernel.org>; Fri, 14 Dec 2012 02:29:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1355477817-5750-1-git-send-email-sumit.semwal@ti.com>
References: <1355477817-5750-1-git-send-email-sumit.semwal@ti.com>
Date: Fri, 14 Dec 2012 11:29:04 +0100
Message-ID: <CAKMK7uFqAhwNBwMHSiudy9u88dHkoqtP7q9cPecUR-xF-6mm9g@mail.gmail.com>
Subject: Re: [PATCH] dma-buf: Add debugfs support
From: Daniel Vetter <daniel@ffwll.ch>
To: sumit.semwal@ti.com
Cc: sumit.semwal@linaro.org, linaro-mm-sig@lists.linaro.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Dec 14, 2012 at 10:36 AM,  <sumit.semwal@ti.com> wrote:
> From: Sumit Semwal <sumit.semwal@linaro.org>
>
> Add debugfs support to make it easier to print debug information
> about the dma-buf buffers.
>
> Signed-off-by: Sumit Semwal <sumit.semwal@ti.com>

Looks line, only nitpick is that we have no idea who exported a given
buffer. So what about adding a new dma_buf_export_named which takes a
char * to identify the exporter, and then add a bit of cpp magic like
this:

#define dma_buf_export(args) dma_buf_export_named(args, stringify(__FILE))

At least for drm drivers using the prime helpers this should add the
file of the exporting driver, so would be good enough to identify the
exporter. Or we could add a dma_buf_export_dev which has a struct
device * as additional argument ... Otoh that wouldn't really work for
exporting dma_bufs from ION, so maybe a const char * is better.
-Daniel

> ---
>  drivers/base/dma-buf.c  |  149 +++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/dma-buf.h |    6 +-
>  2 files changed, 154 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
> index a3f79c4..49fcf0f 100644
> --- a/drivers/base/dma-buf.c
> +++ b/drivers/base/dma-buf.c
> @@ -27,9 +27,18 @@
>  #include <linux/dma-buf.h>
>  #include <linux/anon_inodes.h>
>  #include <linux/export.h>
> +#include <linux/debugfs.h>
> +#include <linux/seq_file.h>
>
>  static inline int is_dma_buf_file(struct file *);
>
> +struct dma_buf_list {
> +       struct list_head head;
> +       struct mutex lock;
> +};
> +
> +static struct dma_buf_list db_list;
> +
>  static int dma_buf_release(struct inode *inode, struct file *file)
>  {
>         struct dma_buf *dmabuf;
> @@ -40,6 +49,11 @@ static int dma_buf_release(struct inode *inode, struct file *file)
>         dmabuf = file->private_data;
>
>         dmabuf->ops->release(dmabuf);
> +
> +       mutex_lock(&db_list.lock);
> +       list_del(&dmabuf->list_node);
> +       mutex_unlock(&db_list.lock);
> +
>         kfree(dmabuf);
>         return 0;
>  }
> @@ -120,6 +134,10 @@ struct dma_buf *dma_buf_export(void *priv, const struct dma_buf_ops *ops,
>         mutex_init(&dmabuf->lock);
>         INIT_LIST_HEAD(&dmabuf->attachments);
>
> +       mutex_lock(&db_list.lock);
> +       list_add(&dmabuf->list_node, &db_list.head);
> +       mutex_unlock(&db_list.lock);
> +
>         return dmabuf;
>  }
>  EXPORT_SYMBOL_GPL(dma_buf_export);
> @@ -505,3 +523,134 @@ void dma_buf_vunmap(struct dma_buf *dmabuf, void *vaddr)
>                 dmabuf->ops->vunmap(dmabuf, vaddr);
>  }
>  EXPORT_SYMBOL_GPL(dma_buf_vunmap);
> +
> +static int dma_buf_init_debugfs(void);
> +static void dma_buf_uninit_debugfs(void);
> +
> +static void __init dma_buf_init(void)
> +{
> +       mutex_init(&db_list.lock);
> +       INIT_LIST_HEAD(&db_list.head);
> +       dma_buf_init_debugfs();
> +}
> +
> +static void __exit dma_buf_deinit(void)
> +{
> +       dma_buf_uninit_debugfs();
> +}
> +
> +#ifdef CONFIG_DEBUG_FS
> +static int dma_buf_describe(struct seq_file *s)
> +{
> +       int ret;
> +       struct dma_buf *buf_obj;
> +       struct dma_buf_attachment *attach_obj;
> +       int count = 0, attach_count;
> +       size_t size = 0;
> +
> +       ret = mutex_lock_interruptible(&db_list.lock);
> +
> +       if (ret)
> +               return ret;
> +
> +       seq_printf(s, "\nDma-buf Objects:\n");
> +       seq_printf(s, "\tsize\tflags\tmode\tcount\n");
> +
> +       list_for_each_entry(buf_obj, &db_list.head, list_node) {
> +               seq_printf(s, "\t");
> +
> +               seq_printf(s, "%08zu\t%08x\t%08x\t%08d\n",
> +                               buf_obj->size, buf_obj->file->f_flags,
> +                               buf_obj->file->f_mode,
> +                               buf_obj->file->f_count.counter);
> +
> +               seq_printf(s, "\t\tAttached Devices:\n");
> +               attach_count = 0;
> +
> +               list_for_each_entry(attach_obj, &buf_obj->attachments, node) {
> +                       seq_printf(s, "\t\t");
> +
> +                       seq_printf(s, "%s\n", attach_obj->dev->init_name);
> +                       attach_count++;
> +               }
> +
> +               seq_printf(s, "\n\t\tTotal %d devices attached\n",
> +                               attach_count);
> +
> +               count++;
> +               size += buf_obj->size;
> +       }
> +
> +       seq_printf(s, "\nTotal %d objects, %zu bytes\n", count, size);
> +
> +       mutex_unlock(&db_list.lock);
> +       return 0;
> +}
> +
> +static int dma_buf_show(struct seq_file *s, void *unused)
> +{
> +       void (*func)(struct seq_file *) = s->private;
> +       func(s);
> +       return 0;
> +}
> +
> +static int dma_buf_debug_open(struct inode *inode, struct file *file)
> +{
> +       return single_open(file, dma_buf_show, inode->i_private);
> +}
> +
> +static const struct file_operations dma_buf_debug_fops = {
> +       .open           = dma_buf_debug_open,
> +       .read           = seq_read,
> +       .llseek         = seq_lseek,
> +       .release        = single_release,
> +};
> +
> +static struct dentry *dma_buf_debugfs_dir;
> +
> +static int dma_buf_init_debugfs(void)
> +{
> +       int err = 0;
> +       dma_buf_debugfs_dir = debugfs_create_dir("dma_buf", NULL);
> +       if (IS_ERR(dma_buf_debugfs_dir)) {
> +               err = PTR_ERR(dma_buf_debugfs_dir);
> +               dma_buf_debugfs_dir = NULL;
> +               return err;
> +       }
> +
> +       err = dma_buf_debugfs_create_file("bufinfo", dma_buf_describe);
> +
> +       if (err)
> +               pr_debug("dma_buf: debugfs: failed to create node bufinfo\n");
> +
> +       return err;
> +}
> +
> +static void dma_buf_uninit_debugfs(void)
> +{
> +       if (dma_buf_debugfs_dir)
> +               debugfs_remove_recursive(dma_buf_debugfs_dir);
> +}
> +
> +int dma_buf_debugfs_create_file(const char *name,
> +                               int (*write)(struct seq_file *))
> +{
> +       struct dentry *d;
> +
> +       d = debugfs_create_file(name, S_IRUGO, dma_buf_debugfs_dir,
> +                       write, &dma_buf_debug_fops);
> +
> +       if (IS_ERR(d))
> +               return PTR_ERR(d);
> +
> +       return 0;
> +}
> +#else
> +static inline int dma_buf_init_debugfs(void)
> +{
> +       return 0;
> +}
> +static inline void dma_buf_uninit_debugfs(void)
> +{
> +}
> +#endif
> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> index bd2e52c..160453f 100644
> --- a/include/linux/dma-buf.h
> +++ b/include/linux/dma-buf.h
> @@ -112,6 +112,7 @@ struct dma_buf_ops {
>   * @file: file pointer used for sharing buffers across, and for refcounting.
>   * @attachments: list of dma_buf_attachment that denotes all devices attached.
>   * @ops: dma_buf_ops associated with this buffer object.
> + * @list_node: node for dma_buf accounting and debugging.
>   * @priv: exporter specific private data for this buffer object.
>   */
>  struct dma_buf {
> @@ -121,6 +122,8 @@ struct dma_buf {
>         const struct dma_buf_ops *ops;
>         /* mutex to serialize list manipulation and attach/detach */
>         struct mutex lock;
> +
> +       struct list_head list_node;
>         void *priv;
>  };
>
> @@ -183,5 +186,6 @@ int dma_buf_mmap(struct dma_buf *, struct vm_area_struct *,
>                  unsigned long);
>  void *dma_buf_vmap(struct dma_buf *);
>  void dma_buf_vunmap(struct dma_buf *, void *vaddr);
> -
> +int dma_buf_debugfs_create_file(const char *name,
> +                               int (*write)(struct seq_file *));
>  #endif /* __DMA_BUF_H__ */
> --
> 1.7.10.4
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel



-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
