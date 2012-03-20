Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:54062 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939Ab2CTUjE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Mar 2012 16:39:04 -0400
Received: by wibhj6 with SMTP id hj6so5672681wib.1
        for <linux-media@vger.kernel.org>; Tue, 20 Mar 2012 13:39:01 -0700 (PDT)
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: linaro-mm-sig@lists.linaro.org,
	LKML <linux-kernel@vger.kernel.org>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	linux-media@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH] [RFC] dma-buf: mmap support
Date: Tue, 20 Mar 2012 21:53:05 +0100
Message-Id: <1332276785-1440-1-git-send-email-daniel.vetter@ffwll.ch>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Let's have some competition here for dma_buf mmap support ;-)

Compared to Rob Clarke's RFC I've ditched the prepare/finish hooks
and corresponding ioctls on the dma_buf file. The major reason for
that is that many people seem to be under the impression that this is
also for synchronization with outstanding asynchronous processsing.
I'm pretty massively opposed to this because:

- It boils down reinventing a new rather general-purpose userspace
  synchronization interface. If we look at things like futexes, this
  is hard to get right.
- Furthermore a lot of kernel code has to interact with this
  synchronization primitive. This smells a look like the dri1 hw_lock,
  a horror show I prefer not to reinvent.
- Even more fun is that multiple different subsystems would interact
  here, so we have plenty of opportunities to create funny deadlock
  scenarios.

I think synchronization is a wholesale different problem from data
sharing and should be tackled as an orthogonal problem.

Now we could demand that prepare/finish may only ensure cache
coherency (as Rob intended), but that runs up into the next problem:
We not only need mmap support to facilitate sw-only processing nodes
in a pipeline (without jumping through hoops by importing the dma_buf
into some sw-access only importer), which allows for a nicer
ION->dma-buf upgrade path for existing Android userspace. We also need
mmap support for existing importing subsystems to support existing
userspace libraries. And a loot of these subsystems are expected to
export coherent userspace mappings.

So prepare/finish can only ever be optional and the exporter /needs/
to support coherent mappings. Given that mmap access is always
somewhat fallback-y in nature I've decided to drop this optimization,
instead of just making it optional. If we demonstrate a clear need for
this, supported by benchmark results, we can always add it in again
later as an optional extension.

Other differences compared to Rob's RFC is the above mentioned support
for mapping a dma-buf through facilities provided by the importer.
Which results in mmap support no longer being optional.

Note taht this dma-buf mmap patch does _not_ support every possible
insanity an existing subsystem could pull of with mmap: Because it
does not allow to intercept pagefaults and shoot down ptes importing
subsystems can't add some magic of their own at these points (e.g. to
automatically synchronize with outstanding rendering or set up some
special resources). I've done a cursory read through a few mmap
implementions of various subsytems and I'm hopeful that we can avoid
this (and the complexity it'd bring with it).

Additonally I've extended the documentation a bit to explain the hows
and whys of this mmap extension.

Comments, reviews and flames highly welcome.

Cheers, Daniel
---
 Documentation/dma-buf-sharing.txt |   84 +++++++++++++++++++++++++++++++++---
 drivers/base/dma-buf.c            |   64 +++++++++++++++++++++++++++-
 include/linux/dma-buf.h           |   16 +++++++
 3 files changed, 156 insertions(+), 8 deletions(-)

diff --git a/Documentation/dma-buf-sharing.txt b/Documentation/dma-buf-sharing.txt
index a6d4c37..c42a4a5 100644
--- a/Documentation/dma-buf-sharing.txt
+++ b/Documentation/dma-buf-sharing.txt
@@ -29,13 +29,6 @@ The buffer-user
    in memory, mapped into its own address space, so it can access the same area
    of memory.
 
-*IMPORTANT*: [see https://lkml.org/lkml/2011/12/20/211 for more details]
-For this first version, A buffer shared using the dma_buf sharing API:
-- *may* be exported to user space using "mmap" *ONLY* by exporter, outside of
-  this framework.
-- with this new iteration of the dma-buf api cpu access from the kernel has been
-  enable, see below for the details.
-
 dma-buf operations for device dma only
 --------------------------------------
 
@@ -313,6 +306,83 @@ Access to a dma_buf from the kernel context involves three steps:
 				  enum dma_data_direction dir);
 
 
+Direct Userspace Access/mmap Support
+------------------------------------
+
+Being able to mmap an export dma-buf buffer object has 2 main use-cases:
+- CPU fallback processing in a pipeline and
+- supporting existing mmap interfaces in importers.
+
+1. CPU fallback processing in a pipeline
+
+   In many processing pipelines it is sometimes required that the cpu can access
+   the data in a dma-buf (e.g. for thumbnail creation, snapshots, ...). To avoid
+   the need to handle this specially in userspace frameworks for buffer sharing
+   it's ideal if the dma_buf fd itself can be used to access the backing storage
+   from userspace using mmap.
+
+   Furthermore Android's ION framework already supports this (and is otherwise
+   rather similar to dma-buf from a userspace consumer side with using fds as
+   handles, too). So it's beneficial to support this in a similar fashion on
+   dma-buf to have a good transition path for existing Android userspace.
+
+   No special interfaces, userspace simply calls mmap on the dma-buf fd.
+
+2. Supporting existing mmap interfaces in exporters
+
+   Similar to the motivation for kernel cpu access it is again important that
+   the userspace code of a given importing subsystem can use the same interfaces
+   with a imported dma-buf buffer object as with a native buffer object. This is
+   especially important for drm where the userspace part of contemporary OpenGL,
+   X, and other drivers is huge, and reworking them to use a different way to
+   mmap a buffer rather invasive.
+
+   The assumption in the current dma-buf interfaces is that redirecting the
+   initial mmap is all that's needed. A survey of some of the existing
+   subsystems shows that no driver seems to do any nefarious thing like syncing
+   up with outstanding asynchronous processing on the device or allocating
+   special resources at fault time. So hopefully this is good enough, since
+   adding interfaces to intercept pagefaults and allow pte shootdowns would
+   increase the complexity quite a bit.
+
+   Interface:
+      int dma_buf_mmap(struct dma_buf *, struct vm_area_struct *,
+		       unsigned long);
+
+   If the importing subsystem simply provides a special-purpose mmap call to set
+   up a mapping in userspace, calling do_mmap with dma_buf->file will equally
+   achieve that for a dma-buf object.
+
+3. Implementation notes for exporters
+
+   Because dma-buf buffers have invariant size over their lifetime, the dma-buf
+   core checks whether a vma is too large and rejects such mappings. The
+   exporter hence does not need to duplicate this check.
+
+   Because existing importing subsystems might presume coherent mappings for
+   userspace, the exporter needs to set up a coherent mapping. If that's not
+   possible, it needs to fake coherency by manually shooting down ptes when
+   leaving the cpu domain and flushing caches at fault time. Note that all the
+   dma_buf files share the same anon inode, hence the exporter needs to replace
+   the dma_buf file stored in vma->vm_file with it's own if pte shootdown is
+   requred. This is because the kernel uses the underlying inode's address_space
+   for vma tracking (and hence pte tracking at shootdown time with
+   unmap_mapping_range).
+
+   If the above shootdown dance turns out to be too expensive in certain
+   scenarios, we can extend dma-buf with a more explicit cache tracking scheme
+   for userspace mappings. But the current assumption is that using mmap is
+   always a slower path, so some inefficiencies should be acceptable.
+
+   Exporters that shoot down mappings (for any reasons) shall not do any
+   synchronization at fault time with outstanding device operations.
+   Synchronization is an orthogonal issue to sharing the backing storage of a
+   buffer and hence should not be handled by dma-buf itself. This is explictly
+   mentioned here because many people seem to want something like this, but if
+   different exporters handle this differently, buffer sharing can fail in
+   interesting ways depending upong the exporter (if userspace starts depending
+   upon this implicit synchronization).
+
 Miscellaneous notes
 -------------------
 
diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
index 07cbbc6..f3b923c 100644
--- a/drivers/base/dma-buf.c
+++ b/drivers/base/dma-buf.c
@@ -44,8 +44,26 @@ static int dma_buf_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static int dma_buf_mmap_internal(struct file *file, struct vm_areat_struct *vma)
+{
+	struct dma_buf *dmabuf;
+
+	if (!is_dma_buf_file(file))
+		return -EINVAL;
+
+	/* check for overflowing the buffer's size */
+	if (vma->vm_pgoff + ((vma->vm_end - vma->vm_start) >> PAGE_SHIFT) >
+	    dmabuf->size >> PAGE_SHIFT)
+		return -EINVAL;
+
+	dmabuf = file->private_data;
+
+	return dmabuf->ops->mmap(dmabuf, vma);
+}
+
 static const struct file_operations dma_buf_fops = {
 	.release	= dma_buf_release,
+	.mmap		= dma_buf_mmap_internal,
 };
 
 /*
@@ -82,7 +100,8 @@ struct dma_buf *dma_buf_export(void *priv, const struct dma_buf_ops *ops,
 			  || !ops->unmap_dma_buf
 			  || !ops->release
 			  || !ops->kmap_atomic
-			  || !ops->kmap)) {
+			  || !ops->kmap
+			  || !ops->mmap)) {
 		return ERR_PTR(-EINVAL);
 	}
 
@@ -406,3 +425,46 @@ void dma_buf_kunmap(struct dma_buf *dmabuf, unsigned long page_num,
 		dmabuf->ops->kunmap(dmabuf, page_num, vaddr);
 }
 EXPORT_SYMBOL_GPL(dma_buf_kunmap);
+
+
+/**
+ * dma_buf_mmap - Setup up a userspace mmap with the given vma
+ * @dma_buf:	[in]	buffer that should back the vma
+ * @vma:	[in]	vma for the mmap
+ * @pgoff:	[in]	offset in pages where this mmap should start within the
+ * 			dma-buf buffer.
+ *
+ * This function adjusts the passed in vma so that it points at the file of the
+ * dma_buf operation. It alsog adjusts the starting pgoff and does bounds
+ * checking on the size of the vma. Then it calls the exporters mmap function to
+ * set up the mapping.
+ *
+ * Can return negative error values, returns 0 on success.
+ */
+int dma_buf_mmap(struct dma_buf *dmabuf, struct vm_area_struct *vma,
+		 unsigned long pgoff)
+{
+	if (WARN_ON(!dmabuf || !vma))
+		return -EINVAL;
+
+	/* check for offset overflow */
+	if (pgoff + ((vma->vm_end - vma->vm_start) >> PAGE_SHIFT) < pgoff)
+		return -EOVERFLOW;
+
+	/* check for overflowing the buffer's size */
+	if (pgoff + ((vma->vm_end - vma->vm_start) >> PAGE_SHIFT) >
+	    dmabuf->size >> PAGE_SHIFT)
+		return -EINVAL;
+
+	/* readjust the vma */
+	if (vma->vm_file)
+		fput(vma->vm_file);
+
+	vma->vm_file = dmabuf->file;
+	get_file(vma->vm_file);
+
+	vma->vm_pgoff = pgoff;
+
+	return dmabuf->ops->mmap(dmabuf, vma);
+}
+EXPORT_SYMBOL_GPL(dma_buf_mmap);
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index ee7ef99..d254630 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -61,6 +61,10 @@ struct dma_buf_attachment;
  * 		   This Callback must not sleep.
  * @kmap: maps a page from the buffer into kernel address space.
  * @kunmap: [optional] unmaps a page from the buffer.
+ * @mmap: used to expose the backing storage to userspace. Note that the
+ * 	  mapping needs to be coherent - if the exporter doesn't directly
+ * 	  support this, it needs to fake coherency by shooting down any ptes
+ * 	  when transitioning away from the cpu domain.
  */
 struct dma_buf_ops {
 	int (*attach)(struct dma_buf *, struct device *,
@@ -92,6 +96,8 @@ struct dma_buf_ops {
 	void (*kunmap_atomic)(struct dma_buf *, unsigned long, void *);
 	void *(*kmap)(struct dma_buf *, unsigned long);
 	void (*kunmap)(struct dma_buf *, unsigned long, void *);
+
+	int (*mmap)(struct dma_buf *, struct vm_area_struct *vma);
 };
 
 /**
@@ -167,6 +173,9 @@ void *dma_buf_kmap_atomic(struct dma_buf *, unsigned long);
 void dma_buf_kunmap_atomic(struct dma_buf *, unsigned long, void *);
 void *dma_buf_kmap(struct dma_buf *, unsigned long);
 void dma_buf_kunmap(struct dma_buf *, unsigned long, void *);
+
+int dma_buf_mmap(struct dma_buf *, struct vm_area_struct *,
+		 unsigned long);
 #else
 
 static inline struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf,
@@ -247,6 +256,13 @@ static inline void dma_buf_kunmap(struct dma_buf *, unsigned long,
 				  void *)
 {
 }
+
+static inline int dma_buf_mmap(struct dma_buf *,
+			       struct vm_area_struct *vma,
+			       unsigned long pgoff)
+{
+	return -ENODEV;
+}
 #endif /* CONFIG_DMA_SHARED_BUFFER */
 
 #endif /* __DMA_BUF_H__ */
-- 
1.7.7.5

