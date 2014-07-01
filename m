Return-path: <linux-media-owner@vger.kernel.org>
Received: from adelie.canonical.com ([91.189.90.139]:60182 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757573AbaGAK5p (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Jul 2014 06:57:45 -0400
Subject: [PATCH v2 1/9] dma-buf: move to drivers/dma-buf
To: gregkh@linuxfoundation.org
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linux-arch@vger.kernel.org, thellstrom@vmware.com,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, robdclark@gmail.com,
	thierry.reding@gmail.com, ccross@google.com, daniel@ffwll.ch,
	sumit.semwal@linaro.org, linux-media@vger.kernel.org
Date: Tue, 01 Jul 2014 12:57:08 +0200
Message-ID: <20140701105708.12718.50675.stgit@patser>
In-Reply-To: <20140701103432.12718.82795.stgit@patser>
References: <20140701103432.12718.82795.stgit@patser>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
---
 Documentation/DocBook/device-drivers.tmpl |    3 
 MAINTAINERS                               |    4 
 drivers/Makefile                          |    1 
 drivers/base/Makefile                     |    1 
 drivers/base/dma-buf.c                    |  743 -----------------------------
 drivers/base/reservation.c                |   39 --
 drivers/dma-buf/Makefile                  |    1 
 drivers/dma-buf/dma-buf.c                 |  743 +++++++++++++++++++++++++++++
 drivers/dma-buf/reservation.c             |   39 ++
 9 files changed, 787 insertions(+), 787 deletions(-)
 delete mode 100644 drivers/base/dma-buf.c
 delete mode 100644 drivers/base/reservation.c
 create mode 100644 drivers/dma-buf/Makefile
 create mode 100644 drivers/dma-buf/dma-buf.c
 create mode 100644 drivers/dma-buf/reservation.c

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index cc63f30de166..ac61ebd92875 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -128,8 +128,7 @@ X!Edrivers/base/interface.c
 !Edrivers/base/bus.c
      </sect1>
      <sect1><title>Device Drivers DMA Management</title>
-!Edrivers/base/dma-buf.c
-!Edrivers/base/reservation.c
+!Edrivers/dma-buf/dma-buf.c
 !Iinclude/linux/reservation.h
 !Edrivers/base/dma-coherent.c
 !Edrivers/base/dma-mapping.c
diff --git a/MAINTAINERS b/MAINTAINERS
index 134483f206e4..c948e53a4ee6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2882,8 +2882,8 @@ S:	Maintained
 L:	linux-media@vger.kernel.org
 L:	dri-devel@lists.freedesktop.org
 L:	linaro-mm-sig@lists.linaro.org
-F:	drivers/base/dma-buf*
-F:	include/linux/dma-buf*
+F:	drivers/dma-buf/
+F:	include/linux/dma-buf* include/linux/reservation.h
 F:	Documentation/dma-buf-sharing.txt
 T:	git git://git.linaro.org/people/sumitsemwal/linux-dma-buf.git
 
diff --git a/drivers/Makefile b/drivers/Makefile
index f98b50d8251d..c00337be5351 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -61,6 +61,7 @@ obj-$(CONFIG_FB_INTEL)          += video/fbdev/intelfb/
 
 obj-$(CONFIG_PARPORT)		+= parport/
 obj-y				+= base/ block/ misc/ mfd/ nfc/
+obj-$(CONFIG_DMA_SHARED_BUFFER) += dma-buf/
 obj-$(CONFIG_NUBUS)		+= nubus/
 obj-y				+= macintosh/
 obj-$(CONFIG_IDE)		+= ide/
diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index 04b314e0fa51..4aab26ec0292 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -10,7 +10,6 @@ obj-$(CONFIG_DMA_CMA) += dma-contiguous.o
 obj-y			+= power/
 obj-$(CONFIG_HAS_DMA)	+= dma-mapping.o
 obj-$(CONFIG_HAVE_GENERIC_DMA_COHERENT) += dma-coherent.o
-obj-$(CONFIG_DMA_SHARED_BUFFER) += dma-buf.o reservation.o
 obj-$(CONFIG_ISA)	+= isa.o
 obj-$(CONFIG_FW_LOADER)	+= firmware_class.o
 obj-$(CONFIG_NUMA)	+= node.o
diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
deleted file mode 100644
index 840c7fa80983..000000000000
--- a/drivers/base/dma-buf.c
+++ /dev/null
@@ -1,743 +0,0 @@
-/*
- * Framework for buffer objects that can be shared across devices/subsystems.
- *
- * Copyright(C) 2011 Linaro Limited. All rights reserved.
- * Author: Sumit Semwal <sumit.semwal@ti.com>
- *
- * Many thanks to linaro-mm-sig list, and specially
- * Arnd Bergmann <arnd@arndb.de>, Rob Clark <rob@ti.com> and
- * Daniel Vetter <daniel@ffwll.ch> for their support in creation and
- * refining of this idea.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License version 2 as published by
- * the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program.  If not, see <http://www.gnu.org/licenses/>.
- */
-
-#include <linux/fs.h>
-#include <linux/slab.h>
-#include <linux/dma-buf.h>
-#include <linux/anon_inodes.h>
-#include <linux/export.h>
-#include <linux/debugfs.h>
-#include <linux/seq_file.h>
-
-static inline int is_dma_buf_file(struct file *);
-
-struct dma_buf_list {
-	struct list_head head;
-	struct mutex lock;
-};
-
-static struct dma_buf_list db_list;
-
-static int dma_buf_release(struct inode *inode, struct file *file)
-{
-	struct dma_buf *dmabuf;
-
-	if (!is_dma_buf_file(file))
-		return -EINVAL;
-
-	dmabuf = file->private_data;
-
-	BUG_ON(dmabuf->vmapping_counter);
-
-	dmabuf->ops->release(dmabuf);
-
-	mutex_lock(&db_list.lock);
-	list_del(&dmabuf->list_node);
-	mutex_unlock(&db_list.lock);
-
-	kfree(dmabuf);
-	return 0;
-}
-
-static int dma_buf_mmap_internal(struct file *file, struct vm_area_struct *vma)
-{
-	struct dma_buf *dmabuf;
-
-	if (!is_dma_buf_file(file))
-		return -EINVAL;
-
-	dmabuf = file->private_data;
-
-	/* check for overflowing the buffer's size */
-	if (vma->vm_pgoff + ((vma->vm_end - vma->vm_start) >> PAGE_SHIFT) >
-	    dmabuf->size >> PAGE_SHIFT)
-		return -EINVAL;
-
-	return dmabuf->ops->mmap(dmabuf, vma);
-}
-
-static loff_t dma_buf_llseek(struct file *file, loff_t offset, int whence)
-{
-	struct dma_buf *dmabuf;
-	loff_t base;
-
-	if (!is_dma_buf_file(file))
-		return -EBADF;
-
-	dmabuf = file->private_data;
-
-	/* only support discovering the end of the buffer,
-	   but also allow SEEK_SET to maintain the idiomatic
-	   SEEK_END(0), SEEK_CUR(0) pattern */
-	if (whence == SEEK_END)
-		base = dmabuf->size;
-	else if (whence == SEEK_SET)
-		base = 0;
-	else
-		return -EINVAL;
-
-	if (offset != 0)
-		return -EINVAL;
-
-	return base + offset;
-}
-
-static const struct file_operations dma_buf_fops = {
-	.release	= dma_buf_release,
-	.mmap		= dma_buf_mmap_internal,
-	.llseek		= dma_buf_llseek,
-};
-
-/*
- * is_dma_buf_file - Check if struct file* is associated with dma_buf
- */
-static inline int is_dma_buf_file(struct file *file)
-{
-	return file->f_op == &dma_buf_fops;
-}
-
-/**
- * dma_buf_export_named - Creates a new dma_buf, and associates an anon file
- * with this buffer, so it can be exported.
- * Also connect the allocator specific data and ops to the buffer.
- * Additionally, provide a name string for exporter; useful in debugging.
- *
- * @priv:	[in]	Attach private data of allocator to this buffer
- * @ops:	[in]	Attach allocator-defined dma buf ops to the new buffer.
- * @size:	[in]	Size of the buffer
- * @flags:	[in]	mode flags for the file.
- * @exp_name:	[in]	name of the exporting module - useful for debugging.
- *
- * Returns, on success, a newly created dma_buf object, which wraps the
- * supplied private data and operations for dma_buf_ops. On either missing
- * ops, or error in allocating struct dma_buf, will return negative error.
- *
- */
-struct dma_buf *dma_buf_export_named(void *priv, const struct dma_buf_ops *ops,
-				size_t size, int flags, const char *exp_name)
-{
-	struct dma_buf *dmabuf;
-	struct file *file;
-
-	if (WARN_ON(!priv || !ops
-			  || !ops->map_dma_buf
-			  || !ops->unmap_dma_buf
-			  || !ops->release
-			  || !ops->kmap_atomic
-			  || !ops->kmap
-			  || !ops->mmap)) {
-		return ERR_PTR(-EINVAL);
-	}
-
-	dmabuf = kzalloc(sizeof(struct dma_buf), GFP_KERNEL);
-	if (dmabuf == NULL)
-		return ERR_PTR(-ENOMEM);
-
-	dmabuf->priv = priv;
-	dmabuf->ops = ops;
-	dmabuf->size = size;
-	dmabuf->exp_name = exp_name;
-
-	file = anon_inode_getfile("dmabuf", &dma_buf_fops, dmabuf, flags);
-	if (IS_ERR(file)) {
-		kfree(dmabuf);
-		return ERR_CAST(file);
-	}
-
-	file->f_mode |= FMODE_LSEEK;
-	dmabuf->file = file;
-
-	mutex_init(&dmabuf->lock);
-	INIT_LIST_HEAD(&dmabuf->attachments);
-
-	mutex_lock(&db_list.lock);
-	list_add(&dmabuf->list_node, &db_list.head);
-	mutex_unlock(&db_list.lock);
-
-	return dmabuf;
-}
-EXPORT_SYMBOL_GPL(dma_buf_export_named);
-
-
-/**
- * dma_buf_fd - returns a file descriptor for the given dma_buf
- * @dmabuf:	[in]	pointer to dma_buf for which fd is required.
- * @flags:      [in]    flags to give to fd
- *
- * On success, returns an associated 'fd'. Else, returns error.
- */
-int dma_buf_fd(struct dma_buf *dmabuf, int flags)
-{
-	int fd;
-
-	if (!dmabuf || !dmabuf->file)
-		return -EINVAL;
-
-	fd = get_unused_fd_flags(flags);
-	if (fd < 0)
-		return fd;
-
-	fd_install(fd, dmabuf->file);
-
-	return fd;
-}
-EXPORT_SYMBOL_GPL(dma_buf_fd);
-
-/**
- * dma_buf_get - returns the dma_buf structure related to an fd
- * @fd:	[in]	fd associated with the dma_buf to be returned
- *
- * On success, returns the dma_buf structure associated with an fd; uses
- * file's refcounting done by fget to increase refcount. returns ERR_PTR
- * otherwise.
- */
-struct dma_buf *dma_buf_get(int fd)
-{
-	struct file *file;
-
-	file = fget(fd);
-
-	if (!file)
-		return ERR_PTR(-EBADF);
-
-	if (!is_dma_buf_file(file)) {
-		fput(file);
-		return ERR_PTR(-EINVAL);
-	}
-
-	return file->private_data;
-}
-EXPORT_SYMBOL_GPL(dma_buf_get);
-
-/**
- * dma_buf_put - decreases refcount of the buffer
- * @dmabuf:	[in]	buffer to reduce refcount of
- *
- * Uses file's refcounting done implicitly by fput()
- */
-void dma_buf_put(struct dma_buf *dmabuf)
-{
-	if (WARN_ON(!dmabuf || !dmabuf->file))
-		return;
-
-	fput(dmabuf->file);
-}
-EXPORT_SYMBOL_GPL(dma_buf_put);
-
-/**
- * dma_buf_attach - Add the device to dma_buf's attachments list; optionally,
- * calls attach() of dma_buf_ops to allow device-specific attach functionality
- * @dmabuf:	[in]	buffer to attach device to.
- * @dev:	[in]	device to be attached.
- *
- * Returns struct dma_buf_attachment * for this attachment; returns ERR_PTR on
- * error.
- */
-struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf,
-					  struct device *dev)
-{
-	struct dma_buf_attachment *attach;
-	int ret;
-
-	if (WARN_ON(!dmabuf || !dev))
-		return ERR_PTR(-EINVAL);
-
-	attach = kzalloc(sizeof(struct dma_buf_attachment), GFP_KERNEL);
-	if (attach == NULL)
-		return ERR_PTR(-ENOMEM);
-
-	attach->dev = dev;
-	attach->dmabuf = dmabuf;
-
-	mutex_lock(&dmabuf->lock);
-
-	if (dmabuf->ops->attach) {
-		ret = dmabuf->ops->attach(dmabuf, dev, attach);
-		if (ret)
-			goto err_attach;
-	}
-	list_add(&attach->node, &dmabuf->attachments);
-
-	mutex_unlock(&dmabuf->lock);
-	return attach;
-
-err_attach:
-	kfree(attach);
-	mutex_unlock(&dmabuf->lock);
-	return ERR_PTR(ret);
-}
-EXPORT_SYMBOL_GPL(dma_buf_attach);
-
-/**
- * dma_buf_detach - Remove the given attachment from dmabuf's attachments list;
- * optionally calls detach() of dma_buf_ops for device-specific detach
- * @dmabuf:	[in]	buffer to detach from.
- * @attach:	[in]	attachment to be detached; is free'd after this call.
- *
- */
-void dma_buf_detach(struct dma_buf *dmabuf, struct dma_buf_attachment *attach)
-{
-	if (WARN_ON(!dmabuf || !attach))
-		return;
-
-	mutex_lock(&dmabuf->lock);
-	list_del(&attach->node);
-	if (dmabuf->ops->detach)
-		dmabuf->ops->detach(dmabuf, attach);
-
-	mutex_unlock(&dmabuf->lock);
-	kfree(attach);
-}
-EXPORT_SYMBOL_GPL(dma_buf_detach);
-
-/**
- * dma_buf_map_attachment - Returns the scatterlist table of the attachment;
- * mapped into _device_ address space. Is a wrapper for map_dma_buf() of the
- * dma_buf_ops.
- * @attach:	[in]	attachment whose scatterlist is to be returned
- * @direction:	[in]	direction of DMA transfer
- *
- * Returns sg_table containing the scatterlist to be returned; returns ERR_PTR
- * on error.
- */
-struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *attach,
-					enum dma_data_direction direction)
-{
-	struct sg_table *sg_table = ERR_PTR(-EINVAL);
-
-	might_sleep();
-
-	if (WARN_ON(!attach || !attach->dmabuf))
-		return ERR_PTR(-EINVAL);
-
-	sg_table = attach->dmabuf->ops->map_dma_buf(attach, direction);
-	if (!sg_table)
-		sg_table = ERR_PTR(-ENOMEM);
-
-	return sg_table;
-}
-EXPORT_SYMBOL_GPL(dma_buf_map_attachment);
-
-/**
- * dma_buf_unmap_attachment - unmaps and decreases usecount of the buffer;might
- * deallocate the scatterlist associated. Is a wrapper for unmap_dma_buf() of
- * dma_buf_ops.
- * @attach:	[in]	attachment to unmap buffer from
- * @sg_table:	[in]	scatterlist info of the buffer to unmap
- * @direction:  [in]    direction of DMA transfer
- *
- */
-void dma_buf_unmap_attachment(struct dma_buf_attachment *attach,
-				struct sg_table *sg_table,
-				enum dma_data_direction direction)
-{
-	might_sleep();
-
-	if (WARN_ON(!attach || !attach->dmabuf || !sg_table))
-		return;
-
-	attach->dmabuf->ops->unmap_dma_buf(attach, sg_table,
-						direction);
-}
-EXPORT_SYMBOL_GPL(dma_buf_unmap_attachment);
-
-
-/**
- * dma_buf_begin_cpu_access - Must be called before accessing a dma_buf from the
- * cpu in the kernel context. Calls begin_cpu_access to allow exporter-specific
- * preparations. Coherency is only guaranteed in the specified range for the
- * specified access direction.
- * @dmabuf:	[in]	buffer to prepare cpu access for.
- * @start:	[in]	start of range for cpu access.
- * @len:	[in]	length of range for cpu access.
- * @direction:	[in]	length of range for cpu access.
- *
- * Can return negative error values, returns 0 on success.
- */
-int dma_buf_begin_cpu_access(struct dma_buf *dmabuf, size_t start, size_t len,
-			     enum dma_data_direction direction)
-{
-	int ret = 0;
-
-	if (WARN_ON(!dmabuf))
-		return -EINVAL;
-
-	if (dmabuf->ops->begin_cpu_access)
-		ret = dmabuf->ops->begin_cpu_access(dmabuf, start, len, direction);
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(dma_buf_begin_cpu_access);
-
-/**
- * dma_buf_end_cpu_access - Must be called after accessing a dma_buf from the
- * cpu in the kernel context. Calls end_cpu_access to allow exporter-specific
- * actions. Coherency is only guaranteed in the specified range for the
- * specified access direction.
- * @dmabuf:	[in]	buffer to complete cpu access for.
- * @start:	[in]	start of range for cpu access.
- * @len:	[in]	length of range for cpu access.
- * @direction:	[in]	length of range for cpu access.
- *
- * This call must always succeed.
- */
-void dma_buf_end_cpu_access(struct dma_buf *dmabuf, size_t start, size_t len,
-			    enum dma_data_direction direction)
-{
-	WARN_ON(!dmabuf);
-
-	if (dmabuf->ops->end_cpu_access)
-		dmabuf->ops->end_cpu_access(dmabuf, start, len, direction);
-}
-EXPORT_SYMBOL_GPL(dma_buf_end_cpu_access);
-
-/**
- * dma_buf_kmap_atomic - Map a page of the buffer object into kernel address
- * space. The same restrictions as for kmap_atomic and friends apply.
- * @dmabuf:	[in]	buffer to map page from.
- * @page_num:	[in]	page in PAGE_SIZE units to map.
- *
- * This call must always succeed, any necessary preparations that might fail
- * need to be done in begin_cpu_access.
- */
-void *dma_buf_kmap_atomic(struct dma_buf *dmabuf, unsigned long page_num)
-{
-	WARN_ON(!dmabuf);
-
-	return dmabuf->ops->kmap_atomic(dmabuf, page_num);
-}
-EXPORT_SYMBOL_GPL(dma_buf_kmap_atomic);
-
-/**
- * dma_buf_kunmap_atomic - Unmap a page obtained by dma_buf_kmap_atomic.
- * @dmabuf:	[in]	buffer to unmap page from.
- * @page_num:	[in]	page in PAGE_SIZE units to unmap.
- * @vaddr:	[in]	kernel space pointer obtained from dma_buf_kmap_atomic.
- *
- * This call must always succeed.
- */
-void dma_buf_kunmap_atomic(struct dma_buf *dmabuf, unsigned long page_num,
-			   void *vaddr)
-{
-	WARN_ON(!dmabuf);
-
-	if (dmabuf->ops->kunmap_atomic)
-		dmabuf->ops->kunmap_atomic(dmabuf, page_num, vaddr);
-}
-EXPORT_SYMBOL_GPL(dma_buf_kunmap_atomic);
-
-/**
- * dma_buf_kmap - Map a page of the buffer object into kernel address space. The
- * same restrictions as for kmap and friends apply.
- * @dmabuf:	[in]	buffer to map page from.
- * @page_num:	[in]	page in PAGE_SIZE units to map.
- *
- * This call must always succeed, any necessary preparations that might fail
- * need to be done in begin_cpu_access.
- */
-void *dma_buf_kmap(struct dma_buf *dmabuf, unsigned long page_num)
-{
-	WARN_ON(!dmabuf);
-
-	return dmabuf->ops->kmap(dmabuf, page_num);
-}
-EXPORT_SYMBOL_GPL(dma_buf_kmap);
-
-/**
- * dma_buf_kunmap - Unmap a page obtained by dma_buf_kmap.
- * @dmabuf:	[in]	buffer to unmap page from.
- * @page_num:	[in]	page in PAGE_SIZE units to unmap.
- * @vaddr:	[in]	kernel space pointer obtained from dma_buf_kmap.
- *
- * This call must always succeed.
- */
-void dma_buf_kunmap(struct dma_buf *dmabuf, unsigned long page_num,
-		    void *vaddr)
-{
-	WARN_ON(!dmabuf);
-
-	if (dmabuf->ops->kunmap)
-		dmabuf->ops->kunmap(dmabuf, page_num, vaddr);
-}
-EXPORT_SYMBOL_GPL(dma_buf_kunmap);
-
-
-/**
- * dma_buf_mmap - Setup up a userspace mmap with the given vma
- * @dmabuf:	[in]	buffer that should back the vma
- * @vma:	[in]	vma for the mmap
- * @pgoff:	[in]	offset in pages where this mmap should start within the
- * 			dma-buf buffer.
- *
- * This function adjusts the passed in vma so that it points at the file of the
- * dma_buf operation. It also adjusts the starting pgoff and does bounds
- * checking on the size of the vma. Then it calls the exporters mmap function to
- * set up the mapping.
- *
- * Can return negative error values, returns 0 on success.
- */
-int dma_buf_mmap(struct dma_buf *dmabuf, struct vm_area_struct *vma,
-		 unsigned long pgoff)
-{
-	struct file *oldfile;
-	int ret;
-
-	if (WARN_ON(!dmabuf || !vma))
-		return -EINVAL;
-
-	/* check for offset overflow */
-	if (pgoff + ((vma->vm_end - vma->vm_start) >> PAGE_SHIFT) < pgoff)
-		return -EOVERFLOW;
-
-	/* check for overflowing the buffer's size */
-	if (pgoff + ((vma->vm_end - vma->vm_start) >> PAGE_SHIFT) >
-	    dmabuf->size >> PAGE_SHIFT)
-		return -EINVAL;
-
-	/* readjust the vma */
-	get_file(dmabuf->file);
-	oldfile = vma->vm_file;
-	vma->vm_file = dmabuf->file;
-	vma->vm_pgoff = pgoff;
-
-	ret = dmabuf->ops->mmap(dmabuf, vma);
-	if (ret) {
-		/* restore old parameters on failure */
-		vma->vm_file = oldfile;
-		fput(dmabuf->file);
-	} else {
-		if (oldfile)
-			fput(oldfile);
-	}
-	return ret;
-
-}
-EXPORT_SYMBOL_GPL(dma_buf_mmap);
-
-/**
- * dma_buf_vmap - Create virtual mapping for the buffer object into kernel
- * address space. Same restrictions as for vmap and friends apply.
- * @dmabuf:	[in]	buffer to vmap
- *
- * This call may fail due to lack of virtual mapping address space.
- * These calls are optional in drivers. The intended use for them
- * is for mapping objects linear in kernel space for high use objects.
- * Please attempt to use kmap/kunmap before thinking about these interfaces.
- *
- * Returns NULL on error.
- */
-void *dma_buf_vmap(struct dma_buf *dmabuf)
-{
-	void *ptr;
-
-	if (WARN_ON(!dmabuf))
-		return NULL;
-
-	if (!dmabuf->ops->vmap)
-		return NULL;
-
-	mutex_lock(&dmabuf->lock);
-	if (dmabuf->vmapping_counter) {
-		dmabuf->vmapping_counter++;
-		BUG_ON(!dmabuf->vmap_ptr);
-		ptr = dmabuf->vmap_ptr;
-		goto out_unlock;
-	}
-
-	BUG_ON(dmabuf->vmap_ptr);
-
-	ptr = dmabuf->ops->vmap(dmabuf);
-	if (WARN_ON_ONCE(IS_ERR(ptr)))
-		ptr = NULL;
-	if (!ptr)
-		goto out_unlock;
-
-	dmabuf->vmap_ptr = ptr;
-	dmabuf->vmapping_counter = 1;
-
-out_unlock:
-	mutex_unlock(&dmabuf->lock);
-	return ptr;
-}
-EXPORT_SYMBOL_GPL(dma_buf_vmap);
-
-/**
- * dma_buf_vunmap - Unmap a vmap obtained by dma_buf_vmap.
- * @dmabuf:	[in]	buffer to vunmap
- * @vaddr:	[in]	vmap to vunmap
- */
-void dma_buf_vunmap(struct dma_buf *dmabuf, void *vaddr)
-{
-	if (WARN_ON(!dmabuf))
-		return;
-
-	BUG_ON(!dmabuf->vmap_ptr);
-	BUG_ON(dmabuf->vmapping_counter == 0);
-	BUG_ON(dmabuf->vmap_ptr != vaddr);
-
-	mutex_lock(&dmabuf->lock);
-	if (--dmabuf->vmapping_counter == 0) {
-		if (dmabuf->ops->vunmap)
-			dmabuf->ops->vunmap(dmabuf, vaddr);
-		dmabuf->vmap_ptr = NULL;
-	}
-	mutex_unlock(&dmabuf->lock);
-}
-EXPORT_SYMBOL_GPL(dma_buf_vunmap);
-
-#ifdef CONFIG_DEBUG_FS
-static int dma_buf_describe(struct seq_file *s)
-{
-	int ret;
-	struct dma_buf *buf_obj;
-	struct dma_buf_attachment *attach_obj;
-	int count = 0, attach_count;
-	size_t size = 0;
-
-	ret = mutex_lock_interruptible(&db_list.lock);
-
-	if (ret)
-		return ret;
-
-	seq_puts(s, "\nDma-buf Objects:\n");
-	seq_puts(s, "size\tflags\tmode\tcount\texp_name\n");
-
-	list_for_each_entry(buf_obj, &db_list.head, list_node) {
-		ret = mutex_lock_interruptible(&buf_obj->lock);
-
-		if (ret) {
-			seq_puts(s,
-				 "\tERROR locking buffer object: skipping\n");
-			continue;
-		}
-
-		seq_printf(s, "%08zu\t%08x\t%08x\t%08ld\t%s\n",
-				buf_obj->size,
-				buf_obj->file->f_flags, buf_obj->file->f_mode,
-				(long)(buf_obj->file->f_count.counter),
-				buf_obj->exp_name);
-
-		seq_puts(s, "\tAttached Devices:\n");
-		attach_count = 0;
-
-		list_for_each_entry(attach_obj, &buf_obj->attachments, node) {
-			seq_puts(s, "\t");
-
-			seq_printf(s, "%s\n", dev_name(attach_obj->dev));
-			attach_count++;
-		}
-
-		seq_printf(s, "Total %d devices attached\n\n",
-				attach_count);
-
-		count++;
-		size += buf_obj->size;
-		mutex_unlock(&buf_obj->lock);
-	}
-
-	seq_printf(s, "\nTotal %d objects, %zu bytes\n", count, size);
-
-	mutex_unlock(&db_list.lock);
-	return 0;
-}
-
-static int dma_buf_show(struct seq_file *s, void *unused)
-{
-	void (*func)(struct seq_file *) = s->private;
-	func(s);
-	return 0;
-}
-
-static int dma_buf_debug_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, dma_buf_show, inode->i_private);
-}
-
-static const struct file_operations dma_buf_debug_fops = {
-	.open           = dma_buf_debug_open,
-	.read           = seq_read,
-	.llseek         = seq_lseek,
-	.release        = single_release,
-};
-
-static struct dentry *dma_buf_debugfs_dir;
-
-static int dma_buf_init_debugfs(void)
-{
-	int err = 0;
-	dma_buf_debugfs_dir = debugfs_create_dir("dma_buf", NULL);
-	if (IS_ERR(dma_buf_debugfs_dir)) {
-		err = PTR_ERR(dma_buf_debugfs_dir);
-		dma_buf_debugfs_dir = NULL;
-		return err;
-	}
-
-	err = dma_buf_debugfs_create_file("bufinfo", dma_buf_describe);
-
-	if (err)
-		pr_debug("dma_buf: debugfs: failed to create node bufinfo\n");
-
-	return err;
-}
-
-static void dma_buf_uninit_debugfs(void)
-{
-	if (dma_buf_debugfs_dir)
-		debugfs_remove_recursive(dma_buf_debugfs_dir);
-}
-
-int dma_buf_debugfs_create_file(const char *name,
-				int (*write)(struct seq_file *))
-{
-	struct dentry *d;
-
-	d = debugfs_create_file(name, S_IRUGO, dma_buf_debugfs_dir,
-			write, &dma_buf_debug_fops);
-
-	return PTR_ERR_OR_ZERO(d);
-}
-#else
-static inline int dma_buf_init_debugfs(void)
-{
-	return 0;
-}
-static inline void dma_buf_uninit_debugfs(void)
-{
-}
-#endif
-
-static int __init dma_buf_init(void)
-{
-	mutex_init(&db_list.lock);
-	INIT_LIST_HEAD(&db_list.head);
-	dma_buf_init_debugfs();
-	return 0;
-}
-subsys_initcall(dma_buf_init);
-
-static void __exit dma_buf_deinit(void)
-{
-	dma_buf_uninit_debugfs();
-}
-__exitcall(dma_buf_deinit);
diff --git a/drivers/base/reservation.c b/drivers/base/reservation.c
deleted file mode 100644
index a73fbf3b8e56..000000000000
--- a/drivers/base/reservation.c
+++ /dev/null
@@ -1,39 +0,0 @@
-/*
- * Copyright (C) 2012-2013 Canonical Ltd
- *
- * Based on bo.c which bears the following copyright notice,
- * but is dual licensed:
- *
- * Copyright (c) 2006-2009 VMware, Inc., Palo Alto, CA., USA
- * All Rights Reserved.
- *
- * Permission is hereby granted, free of charge, to any person obtaining a
- * copy of this software and associated documentation files (the
- * "Software"), to deal in the Software without restriction, including
- * without limitation the rights to use, copy, modify, merge, publish,
- * distribute, sub license, and/or sell copies of the Software, and to
- * permit persons to whom the Software is furnished to do so, subject to
- * the following conditions:
- *
- * The above copyright notice and this permission notice (including the
- * next paragraph) shall be included in all copies or substantial portions
- * of the Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL
- * THE COPYRIGHT HOLDERS, AUTHORS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM,
- * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
- * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
- * USE OR OTHER DEALINGS IN THE SOFTWARE.
- *
- **************************************************************************/
-/*
- * Authors: Thomas Hellstrom <thellstrom-at-vmware-dot-com>
- */
-
-#include <linux/reservation.h>
-#include <linux/export.h>
-
-DEFINE_WW_CLASS(reservation_ww_class);
-EXPORT_SYMBOL(reservation_ww_class);
diff --git a/drivers/dma-buf/Makefile b/drivers/dma-buf/Makefile
new file mode 100644
index 000000000000..4a4f4c9bacd0
--- /dev/null
+++ b/drivers/dma-buf/Makefile
@@ -0,0 +1 @@
+obj-y := dma-buf.o reservation.o
diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
new file mode 100644
index 000000000000..840c7fa80983
--- /dev/null
+++ b/drivers/dma-buf/dma-buf.c
@@ -0,0 +1,743 @@
+/*
+ * Framework for buffer objects that can be shared across devices/subsystems.
+ *
+ * Copyright(C) 2011 Linaro Limited. All rights reserved.
+ * Author: Sumit Semwal <sumit.semwal@ti.com>
+ *
+ * Many thanks to linaro-mm-sig list, and specially
+ * Arnd Bergmann <arnd@arndb.de>, Rob Clark <rob@ti.com> and
+ * Daniel Vetter <daniel@ffwll.ch> for their support in creation and
+ * refining of this idea.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/fs.h>
+#include <linux/slab.h>
+#include <linux/dma-buf.h>
+#include <linux/anon_inodes.h>
+#include <linux/export.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+
+static inline int is_dma_buf_file(struct file *);
+
+struct dma_buf_list {
+	struct list_head head;
+	struct mutex lock;
+};
+
+static struct dma_buf_list db_list;
+
+static int dma_buf_release(struct inode *inode, struct file *file)
+{
+	struct dma_buf *dmabuf;
+
+	if (!is_dma_buf_file(file))
+		return -EINVAL;
+
+	dmabuf = file->private_data;
+
+	BUG_ON(dmabuf->vmapping_counter);
+
+	dmabuf->ops->release(dmabuf);
+
+	mutex_lock(&db_list.lock);
+	list_del(&dmabuf->list_node);
+	mutex_unlock(&db_list.lock);
+
+	kfree(dmabuf);
+	return 0;
+}
+
+static int dma_buf_mmap_internal(struct file *file, struct vm_area_struct *vma)
+{
+	struct dma_buf *dmabuf;
+
+	if (!is_dma_buf_file(file))
+		return -EINVAL;
+
+	dmabuf = file->private_data;
+
+	/* check for overflowing the buffer's size */
+	if (vma->vm_pgoff + ((vma->vm_end - vma->vm_start) >> PAGE_SHIFT) >
+	    dmabuf->size >> PAGE_SHIFT)
+		return -EINVAL;
+
+	return dmabuf->ops->mmap(dmabuf, vma);
+}
+
+static loff_t dma_buf_llseek(struct file *file, loff_t offset, int whence)
+{
+	struct dma_buf *dmabuf;
+	loff_t base;
+
+	if (!is_dma_buf_file(file))
+		return -EBADF;
+
+	dmabuf = file->private_data;
+
+	/* only support discovering the end of the buffer,
+	   but also allow SEEK_SET to maintain the idiomatic
+	   SEEK_END(0), SEEK_CUR(0) pattern */
+	if (whence == SEEK_END)
+		base = dmabuf->size;
+	else if (whence == SEEK_SET)
+		base = 0;
+	else
+		return -EINVAL;
+
+	if (offset != 0)
+		return -EINVAL;
+
+	return base + offset;
+}
+
+static const struct file_operations dma_buf_fops = {
+	.release	= dma_buf_release,
+	.mmap		= dma_buf_mmap_internal,
+	.llseek		= dma_buf_llseek,
+};
+
+/*
+ * is_dma_buf_file - Check if struct file* is associated with dma_buf
+ */
+static inline int is_dma_buf_file(struct file *file)
+{
+	return file->f_op == &dma_buf_fops;
+}
+
+/**
+ * dma_buf_export_named - Creates a new dma_buf, and associates an anon file
+ * with this buffer, so it can be exported.
+ * Also connect the allocator specific data and ops to the buffer.
+ * Additionally, provide a name string for exporter; useful in debugging.
+ *
+ * @priv:	[in]	Attach private data of allocator to this buffer
+ * @ops:	[in]	Attach allocator-defined dma buf ops to the new buffer.
+ * @size:	[in]	Size of the buffer
+ * @flags:	[in]	mode flags for the file.
+ * @exp_name:	[in]	name of the exporting module - useful for debugging.
+ *
+ * Returns, on success, a newly created dma_buf object, which wraps the
+ * supplied private data and operations for dma_buf_ops. On either missing
+ * ops, or error in allocating struct dma_buf, will return negative error.
+ *
+ */
+struct dma_buf *dma_buf_export_named(void *priv, const struct dma_buf_ops *ops,
+				size_t size, int flags, const char *exp_name)
+{
+	struct dma_buf *dmabuf;
+	struct file *file;
+
+	if (WARN_ON(!priv || !ops
+			  || !ops->map_dma_buf
+			  || !ops->unmap_dma_buf
+			  || !ops->release
+			  || !ops->kmap_atomic
+			  || !ops->kmap
+			  || !ops->mmap)) {
+		return ERR_PTR(-EINVAL);
+	}
+
+	dmabuf = kzalloc(sizeof(struct dma_buf), GFP_KERNEL);
+	if (dmabuf == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	dmabuf->priv = priv;
+	dmabuf->ops = ops;
+	dmabuf->size = size;
+	dmabuf->exp_name = exp_name;
+
+	file = anon_inode_getfile("dmabuf", &dma_buf_fops, dmabuf, flags);
+	if (IS_ERR(file)) {
+		kfree(dmabuf);
+		return ERR_CAST(file);
+	}
+
+	file->f_mode |= FMODE_LSEEK;
+	dmabuf->file = file;
+
+	mutex_init(&dmabuf->lock);
+	INIT_LIST_HEAD(&dmabuf->attachments);
+
+	mutex_lock(&db_list.lock);
+	list_add(&dmabuf->list_node, &db_list.head);
+	mutex_unlock(&db_list.lock);
+
+	return dmabuf;
+}
+EXPORT_SYMBOL_GPL(dma_buf_export_named);
+
+
+/**
+ * dma_buf_fd - returns a file descriptor for the given dma_buf
+ * @dmabuf:	[in]	pointer to dma_buf for which fd is required.
+ * @flags:      [in]    flags to give to fd
+ *
+ * On success, returns an associated 'fd'. Else, returns error.
+ */
+int dma_buf_fd(struct dma_buf *dmabuf, int flags)
+{
+	int fd;
+
+	if (!dmabuf || !dmabuf->file)
+		return -EINVAL;
+
+	fd = get_unused_fd_flags(flags);
+	if (fd < 0)
+		return fd;
+
+	fd_install(fd, dmabuf->file);
+
+	return fd;
+}
+EXPORT_SYMBOL_GPL(dma_buf_fd);
+
+/**
+ * dma_buf_get - returns the dma_buf structure related to an fd
+ * @fd:	[in]	fd associated with the dma_buf to be returned
+ *
+ * On success, returns the dma_buf structure associated with an fd; uses
+ * file's refcounting done by fget to increase refcount. returns ERR_PTR
+ * otherwise.
+ */
+struct dma_buf *dma_buf_get(int fd)
+{
+	struct file *file;
+
+	file = fget(fd);
+
+	if (!file)
+		return ERR_PTR(-EBADF);
+
+	if (!is_dma_buf_file(file)) {
+		fput(file);
+		return ERR_PTR(-EINVAL);
+	}
+
+	return file->private_data;
+}
+EXPORT_SYMBOL_GPL(dma_buf_get);
+
+/**
+ * dma_buf_put - decreases refcount of the buffer
+ * @dmabuf:	[in]	buffer to reduce refcount of
+ *
+ * Uses file's refcounting done implicitly by fput()
+ */
+void dma_buf_put(struct dma_buf *dmabuf)
+{
+	if (WARN_ON(!dmabuf || !dmabuf->file))
+		return;
+
+	fput(dmabuf->file);
+}
+EXPORT_SYMBOL_GPL(dma_buf_put);
+
+/**
+ * dma_buf_attach - Add the device to dma_buf's attachments list; optionally,
+ * calls attach() of dma_buf_ops to allow device-specific attach functionality
+ * @dmabuf:	[in]	buffer to attach device to.
+ * @dev:	[in]	device to be attached.
+ *
+ * Returns struct dma_buf_attachment * for this attachment; returns ERR_PTR on
+ * error.
+ */
+struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf,
+					  struct device *dev)
+{
+	struct dma_buf_attachment *attach;
+	int ret;
+
+	if (WARN_ON(!dmabuf || !dev))
+		return ERR_PTR(-EINVAL);
+
+	attach = kzalloc(sizeof(struct dma_buf_attachment), GFP_KERNEL);
+	if (attach == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	attach->dev = dev;
+	attach->dmabuf = dmabuf;
+
+	mutex_lock(&dmabuf->lock);
+
+	if (dmabuf->ops->attach) {
+		ret = dmabuf->ops->attach(dmabuf, dev, attach);
+		if (ret)
+			goto err_attach;
+	}
+	list_add(&attach->node, &dmabuf->attachments);
+
+	mutex_unlock(&dmabuf->lock);
+	return attach;
+
+err_attach:
+	kfree(attach);
+	mutex_unlock(&dmabuf->lock);
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL_GPL(dma_buf_attach);
+
+/**
+ * dma_buf_detach - Remove the given attachment from dmabuf's attachments list;
+ * optionally calls detach() of dma_buf_ops for device-specific detach
+ * @dmabuf:	[in]	buffer to detach from.
+ * @attach:	[in]	attachment to be detached; is free'd after this call.
+ *
+ */
+void dma_buf_detach(struct dma_buf *dmabuf, struct dma_buf_attachment *attach)
+{
+	if (WARN_ON(!dmabuf || !attach))
+		return;
+
+	mutex_lock(&dmabuf->lock);
+	list_del(&attach->node);
+	if (dmabuf->ops->detach)
+		dmabuf->ops->detach(dmabuf, attach);
+
+	mutex_unlock(&dmabuf->lock);
+	kfree(attach);
+}
+EXPORT_SYMBOL_GPL(dma_buf_detach);
+
+/**
+ * dma_buf_map_attachment - Returns the scatterlist table of the attachment;
+ * mapped into _device_ address space. Is a wrapper for map_dma_buf() of the
+ * dma_buf_ops.
+ * @attach:	[in]	attachment whose scatterlist is to be returned
+ * @direction:	[in]	direction of DMA transfer
+ *
+ * Returns sg_table containing the scatterlist to be returned; returns ERR_PTR
+ * on error.
+ */
+struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *attach,
+					enum dma_data_direction direction)
+{
+	struct sg_table *sg_table = ERR_PTR(-EINVAL);
+
+	might_sleep();
+
+	if (WARN_ON(!attach || !attach->dmabuf))
+		return ERR_PTR(-EINVAL);
+
+	sg_table = attach->dmabuf->ops->map_dma_buf(attach, direction);
+	if (!sg_table)
+		sg_table = ERR_PTR(-ENOMEM);
+
+	return sg_table;
+}
+EXPORT_SYMBOL_GPL(dma_buf_map_attachment);
+
+/**
+ * dma_buf_unmap_attachment - unmaps and decreases usecount of the buffer;might
+ * deallocate the scatterlist associated. Is a wrapper for unmap_dma_buf() of
+ * dma_buf_ops.
+ * @attach:	[in]	attachment to unmap buffer from
+ * @sg_table:	[in]	scatterlist info of the buffer to unmap
+ * @direction:  [in]    direction of DMA transfer
+ *
+ */
+void dma_buf_unmap_attachment(struct dma_buf_attachment *attach,
+				struct sg_table *sg_table,
+				enum dma_data_direction direction)
+{
+	might_sleep();
+
+	if (WARN_ON(!attach || !attach->dmabuf || !sg_table))
+		return;
+
+	attach->dmabuf->ops->unmap_dma_buf(attach, sg_table,
+						direction);
+}
+EXPORT_SYMBOL_GPL(dma_buf_unmap_attachment);
+
+
+/**
+ * dma_buf_begin_cpu_access - Must be called before accessing a dma_buf from the
+ * cpu in the kernel context. Calls begin_cpu_access to allow exporter-specific
+ * preparations. Coherency is only guaranteed in the specified range for the
+ * specified access direction.
+ * @dmabuf:	[in]	buffer to prepare cpu access for.
+ * @start:	[in]	start of range for cpu access.
+ * @len:	[in]	length of range for cpu access.
+ * @direction:	[in]	length of range for cpu access.
+ *
+ * Can return negative error values, returns 0 on success.
+ */
+int dma_buf_begin_cpu_access(struct dma_buf *dmabuf, size_t start, size_t len,
+			     enum dma_data_direction direction)
+{
+	int ret = 0;
+
+	if (WARN_ON(!dmabuf))
+		return -EINVAL;
+
+	if (dmabuf->ops->begin_cpu_access)
+		ret = dmabuf->ops->begin_cpu_access(dmabuf, start, len, direction);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(dma_buf_begin_cpu_access);
+
+/**
+ * dma_buf_end_cpu_access - Must be called after accessing a dma_buf from the
+ * cpu in the kernel context. Calls end_cpu_access to allow exporter-specific
+ * actions. Coherency is only guaranteed in the specified range for the
+ * specified access direction.
+ * @dmabuf:	[in]	buffer to complete cpu access for.
+ * @start:	[in]	start of range for cpu access.
+ * @len:	[in]	length of range for cpu access.
+ * @direction:	[in]	length of range for cpu access.
+ *
+ * This call must always succeed.
+ */
+void dma_buf_end_cpu_access(struct dma_buf *dmabuf, size_t start, size_t len,
+			    enum dma_data_direction direction)
+{
+	WARN_ON(!dmabuf);
+
+	if (dmabuf->ops->end_cpu_access)
+		dmabuf->ops->end_cpu_access(dmabuf, start, len, direction);
+}
+EXPORT_SYMBOL_GPL(dma_buf_end_cpu_access);
+
+/**
+ * dma_buf_kmap_atomic - Map a page of the buffer object into kernel address
+ * space. The same restrictions as for kmap_atomic and friends apply.
+ * @dmabuf:	[in]	buffer to map page from.
+ * @page_num:	[in]	page in PAGE_SIZE units to map.
+ *
+ * This call must always succeed, any necessary preparations that might fail
+ * need to be done in begin_cpu_access.
+ */
+void *dma_buf_kmap_atomic(struct dma_buf *dmabuf, unsigned long page_num)
+{
+	WARN_ON(!dmabuf);
+
+	return dmabuf->ops->kmap_atomic(dmabuf, page_num);
+}
+EXPORT_SYMBOL_GPL(dma_buf_kmap_atomic);
+
+/**
+ * dma_buf_kunmap_atomic - Unmap a page obtained by dma_buf_kmap_atomic.
+ * @dmabuf:	[in]	buffer to unmap page from.
+ * @page_num:	[in]	page in PAGE_SIZE units to unmap.
+ * @vaddr:	[in]	kernel space pointer obtained from dma_buf_kmap_atomic.
+ *
+ * This call must always succeed.
+ */
+void dma_buf_kunmap_atomic(struct dma_buf *dmabuf, unsigned long page_num,
+			   void *vaddr)
+{
+	WARN_ON(!dmabuf);
+
+	if (dmabuf->ops->kunmap_atomic)
+		dmabuf->ops->kunmap_atomic(dmabuf, page_num, vaddr);
+}
+EXPORT_SYMBOL_GPL(dma_buf_kunmap_atomic);
+
+/**
+ * dma_buf_kmap - Map a page of the buffer object into kernel address space. The
+ * same restrictions as for kmap and friends apply.
+ * @dmabuf:	[in]	buffer to map page from.
+ * @page_num:	[in]	page in PAGE_SIZE units to map.
+ *
+ * This call must always succeed, any necessary preparations that might fail
+ * need to be done in begin_cpu_access.
+ */
+void *dma_buf_kmap(struct dma_buf *dmabuf, unsigned long page_num)
+{
+	WARN_ON(!dmabuf);
+
+	return dmabuf->ops->kmap(dmabuf, page_num);
+}
+EXPORT_SYMBOL_GPL(dma_buf_kmap);
+
+/**
+ * dma_buf_kunmap - Unmap a page obtained by dma_buf_kmap.
+ * @dmabuf:	[in]	buffer to unmap page from.
+ * @page_num:	[in]	page in PAGE_SIZE units to unmap.
+ * @vaddr:	[in]	kernel space pointer obtained from dma_buf_kmap.
+ *
+ * This call must always succeed.
+ */
+void dma_buf_kunmap(struct dma_buf *dmabuf, unsigned long page_num,
+		    void *vaddr)
+{
+	WARN_ON(!dmabuf);
+
+	if (dmabuf->ops->kunmap)
+		dmabuf->ops->kunmap(dmabuf, page_num, vaddr);
+}
+EXPORT_SYMBOL_GPL(dma_buf_kunmap);
+
+
+/**
+ * dma_buf_mmap - Setup up a userspace mmap with the given vma
+ * @dmabuf:	[in]	buffer that should back the vma
+ * @vma:	[in]	vma for the mmap
+ * @pgoff:	[in]	offset in pages where this mmap should start within the
+ * 			dma-buf buffer.
+ *
+ * This function adjusts the passed in vma so that it points at the file of the
+ * dma_buf operation. It also adjusts the starting pgoff and does bounds
+ * checking on the size of the vma. Then it calls the exporters mmap function to
+ * set up the mapping.
+ *
+ * Can return negative error values, returns 0 on success.
+ */
+int dma_buf_mmap(struct dma_buf *dmabuf, struct vm_area_struct *vma,
+		 unsigned long pgoff)
+{
+	struct file *oldfile;
+	int ret;
+
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
+	get_file(dmabuf->file);
+	oldfile = vma->vm_file;
+	vma->vm_file = dmabuf->file;
+	vma->vm_pgoff = pgoff;
+
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
+
+}
+EXPORT_SYMBOL_GPL(dma_buf_mmap);
+
+/**
+ * dma_buf_vmap - Create virtual mapping for the buffer object into kernel
+ * address space. Same restrictions as for vmap and friends apply.
+ * @dmabuf:	[in]	buffer to vmap
+ *
+ * This call may fail due to lack of virtual mapping address space.
+ * These calls are optional in drivers. The intended use for them
+ * is for mapping objects linear in kernel space for high use objects.
+ * Please attempt to use kmap/kunmap before thinking about these interfaces.
+ *
+ * Returns NULL on error.
+ */
+void *dma_buf_vmap(struct dma_buf *dmabuf)
+{
+	void *ptr;
+
+	if (WARN_ON(!dmabuf))
+		return NULL;
+
+	if (!dmabuf->ops->vmap)
+		return NULL;
+
+	mutex_lock(&dmabuf->lock);
+	if (dmabuf->vmapping_counter) {
+		dmabuf->vmapping_counter++;
+		BUG_ON(!dmabuf->vmap_ptr);
+		ptr = dmabuf->vmap_ptr;
+		goto out_unlock;
+	}
+
+	BUG_ON(dmabuf->vmap_ptr);
+
+	ptr = dmabuf->ops->vmap(dmabuf);
+	if (WARN_ON_ONCE(IS_ERR(ptr)))
+		ptr = NULL;
+	if (!ptr)
+		goto out_unlock;
+
+	dmabuf->vmap_ptr = ptr;
+	dmabuf->vmapping_counter = 1;
+
+out_unlock:
+	mutex_unlock(&dmabuf->lock);
+	return ptr;
+}
+EXPORT_SYMBOL_GPL(dma_buf_vmap);
+
+/**
+ * dma_buf_vunmap - Unmap a vmap obtained by dma_buf_vmap.
+ * @dmabuf:	[in]	buffer to vunmap
+ * @vaddr:	[in]	vmap to vunmap
+ */
+void dma_buf_vunmap(struct dma_buf *dmabuf, void *vaddr)
+{
+	if (WARN_ON(!dmabuf))
+		return;
+
+	BUG_ON(!dmabuf->vmap_ptr);
+	BUG_ON(dmabuf->vmapping_counter == 0);
+	BUG_ON(dmabuf->vmap_ptr != vaddr);
+
+	mutex_lock(&dmabuf->lock);
+	if (--dmabuf->vmapping_counter == 0) {
+		if (dmabuf->ops->vunmap)
+			dmabuf->ops->vunmap(dmabuf, vaddr);
+		dmabuf->vmap_ptr = NULL;
+	}
+	mutex_unlock(&dmabuf->lock);
+}
+EXPORT_SYMBOL_GPL(dma_buf_vunmap);
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
+	seq_puts(s, "\nDma-buf Objects:\n");
+	seq_puts(s, "size\tflags\tmode\tcount\texp_name\n");
+
+	list_for_each_entry(buf_obj, &db_list.head, list_node) {
+		ret = mutex_lock_interruptible(&buf_obj->lock);
+
+		if (ret) {
+			seq_puts(s,
+				 "\tERROR locking buffer object: skipping\n");
+			continue;
+		}
+
+		seq_printf(s, "%08zu\t%08x\t%08x\t%08ld\t%s\n",
+				buf_obj->size,
+				buf_obj->file->f_flags, buf_obj->file->f_mode,
+				(long)(buf_obj->file->f_count.counter),
+				buf_obj->exp_name);
+
+		seq_puts(s, "\tAttached Devices:\n");
+		attach_count = 0;
+
+		list_for_each_entry(attach_obj, &buf_obj->attachments, node) {
+			seq_puts(s, "\t");
+
+			seq_printf(s, "%s\n", dev_name(attach_obj->dev));
+			attach_count++;
+		}
+
+		seq_printf(s, "Total %d devices attached\n\n",
+				attach_count);
+
+		count++;
+		size += buf_obj->size;
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
+	return PTR_ERR_OR_ZERO(d);
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
+
+static int __init dma_buf_init(void)
+{
+	mutex_init(&db_list.lock);
+	INIT_LIST_HEAD(&db_list.head);
+	dma_buf_init_debugfs();
+	return 0;
+}
+subsys_initcall(dma_buf_init);
+
+static void __exit dma_buf_deinit(void)
+{
+	dma_buf_uninit_debugfs();
+}
+__exitcall(dma_buf_deinit);
diff --git a/drivers/dma-buf/reservation.c b/drivers/dma-buf/reservation.c
new file mode 100644
index 000000000000..a73fbf3b8e56
--- /dev/null
+++ b/drivers/dma-buf/reservation.c
@@ -0,0 +1,39 @@
+/*
+ * Copyright (C) 2012-2013 Canonical Ltd
+ *
+ * Based on bo.c which bears the following copyright notice,
+ * but is dual licensed:
+ *
+ * Copyright (c) 2006-2009 VMware, Inc., Palo Alto, CA., USA
+ * All Rights Reserved.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the
+ * "Software"), to deal in the Software without restriction, including
+ * without limitation the rights to use, copy, modify, merge, publish,
+ * distribute, sub license, and/or sell copies of the Software, and to
+ * permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the
+ * next paragraph) shall be included in all copies or substantial portions
+ * of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDERS, AUTHORS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM,
+ * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
+ * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
+ * USE OR OTHER DEALINGS IN THE SOFTWARE.
+ *
+ **************************************************************************/
+/*
+ * Authors: Thomas Hellstrom <thellstrom-at-vmware-dot-com>
+ */
+
+#include <linux/reservation.h>
+#include <linux/export.h>
+
+DEFINE_WW_CLASS(reservation_ww_class);
+EXPORT_SYMBOL(reservation_ww_class);

