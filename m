Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:35326 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbcEIPIL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 May 2016 11:08:11 -0400
Received: by mail-wm0-f47.google.com with SMTP id e201so141550616wme.0
        for <linux-media@vger.kernel.org>; Mon, 09 May 2016 08:08:11 -0700 (PDT)
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org, zoltan.kuscsik@linaro.org,
	sumit.semwal@linaro.org, cc.ma@mediatek.com,
	pascal.brand@linaro.org, joakim.bech@linaro.org,
	dan.caprita@windriver.com
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v7 1/3] create SMAF module
Date: Mon,  9 May 2016 17:07:37 +0200
Message-Id: <1462806459-8124-2-git-send-email-benjamin.gaignard@linaro.org>
In-Reply-To: <1462806459-8124-1-git-send-email-benjamin.gaignard@linaro.org>
References: <1462806459-8124-1-git-send-email-benjamin.gaignard@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Secure Memory Allocation Framework goal is to be able
to allocate memory that can be securing.
There is so much ways to allocate and securing memory that SMAF
doesn't do it by itself but need help of additional modules.
To be sure to use the correct allocation method SMAF implement
deferred allocation (i.e. allocate memory when only really needed)

Allocation modules (smaf-alloctor.h):
SMAF could manage with multiple allocation modules at same time.
To select the good one SMAF call match() to be sure that a module
can allocate memory for a given list of devices. It is to the module
to check if the devices are compatible or not with it allocation
method.

Securing module (smaf-secure.h):
The way of how securing memory it is done is platform specific.
Secure module is responsible of grant/revoke memory access.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
---
 drivers/Kconfig                |   2 +
 drivers/Makefile               |   1 +
 drivers/smaf/Kconfig           |   5 +
 drivers/smaf/Makefile          |   1 +
 drivers/smaf/smaf-core.c       | 794 +++++++++++++++++++++++++++++++++++++++++
 include/linux/smaf-allocator.h |  54 +++
 include/linux/smaf-secure.h    |  73 ++++
 include/uapi/linux/smaf.h      |  66 ++++
 8 files changed, 996 insertions(+)
 create mode 100644 drivers/smaf/Kconfig
 create mode 100644 drivers/smaf/Makefile
 create mode 100644 drivers/smaf/smaf-core.c
 create mode 100644 include/linux/smaf-allocator.h
 create mode 100644 include/linux/smaf-secure.h
 create mode 100644 include/uapi/linux/smaf.h

diff --git a/drivers/Kconfig b/drivers/Kconfig
index d2ac339..f5262fd 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -198,4 +198,6 @@ source "drivers/hwtracing/intel_th/Kconfig"
 
 source "drivers/fpga/Kconfig"
 
+source "drivers/smaf/Kconfig"
+
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index 8f5d076..b2fb04a 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -172,3 +172,4 @@ obj-$(CONFIG_STM)		+= hwtracing/stm/
 obj-$(CONFIG_ANDROID)		+= android/
 obj-$(CONFIG_NVMEM)		+= nvmem/
 obj-$(CONFIG_FPGA)		+= fpga/
+obj-$(CONFIG_SMAF) 		+= smaf/
diff --git a/drivers/smaf/Kconfig b/drivers/smaf/Kconfig
new file mode 100644
index 0000000..d36651a
--- /dev/null
+++ b/drivers/smaf/Kconfig
@@ -0,0 +1,5 @@
+config SMAF
+	tristate "Secure Memory Allocation Framework"
+	depends on DMA_SHARED_BUFFER
+	help
+	  Choose this option to enable Secure Memory Allocation Framework
diff --git a/drivers/smaf/Makefile b/drivers/smaf/Makefile
new file mode 100644
index 0000000..40cd882
--- /dev/null
+++ b/drivers/smaf/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_SMAF) += smaf-core.o
diff --git a/drivers/smaf/smaf-core.c b/drivers/smaf/smaf-core.c
new file mode 100644
index 0000000..3bf619c
--- /dev/null
+++ b/drivers/smaf/smaf-core.c
@@ -0,0 +1,794 @@
+/*
+ * smaf.c
+ *
+ * Copyright (C) Linaro SA 2015
+ * Author: Benjamin Gaignard <benjamin.gaignard@linaro.org> for Linaro.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#include <linux/cpu.h>
+#include <linux/device.h>
+#include <linux/fs.h>
+#include <linux/ioctl.h>
+#include <linux/list_sort.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/smaf.h>
+#include <linux/smaf-allocator.h>
+#include <linux/smaf-secure.h>
+#include <linux/uaccess.h>
+
+struct smaf_handle {
+	struct dma_buf *dmabuf;
+	struct smaf_allocator *allocator;
+	struct dma_buf *db_alloc;
+	size_t length;
+	unsigned int flags;
+	int fd;
+	atomic_t is_secure;
+	void *secure_ctx;
+};
+
+/**
+ * struct smaf_device - smaf device node private data
+ * @misc_dev:	the misc device
+ * @head:	list of allocator
+ * @lock:	list and secure pointer mutex
+ * @secure:	pointer to secure functions helpers
+ */
+struct smaf_device {
+	struct miscdevice misc_dev;
+	struct list_head head;
+	/* list and secure pointer lock*/
+	struct mutex lock;
+	struct smaf_secure *secure;
+};
+
+static struct smaf_device smaf_dev;
+
+static bool have_secure_module(void)
+{
+	return !!smaf_dev.secure;
+}
+
+/**
+ * smaf_grant_access - return true if the specified device can get access
+ * to the memory area
+ *
+ * This function must be called with smaf_dev.lock set
+ */
+static bool smaf_grant_access(struct smaf_handle *handle, struct device *dev,
+			      dma_addr_t addr, size_t size,
+			      enum dma_data_direction dir)
+{
+	if (!atomic_read(&handle->is_secure))
+		return true;
+
+	if (!have_secure_module())
+		return false;
+
+	return smaf_dev.secure->grant_access(handle->secure_ctx,
+					     dev, addr, size, dir);
+}
+
+/**
+ * smaf_revoke_access
+ * This function must be called with smaf_dev.lock set
+ */
+static void smaf_revoke_access(struct smaf_handle *handle, struct device *dev,
+			       dma_addr_t addr, size_t size,
+			       enum dma_data_direction dir)
+{
+	if (!atomic_read(&handle->is_secure))
+		return;
+
+	if (!have_secure_module())
+		return;
+
+	smaf_dev.secure->revoke_access(handle->secure_ctx,
+				       dev, addr, size, dir);
+}
+
+static int smaf_secure_handle(struct smaf_handle *handle)
+{
+	if (atomic_read(&handle->is_secure))
+		return 0;
+
+	if (!have_secure_module())
+		return -EINVAL;
+
+	handle->secure_ctx = smaf_dev.secure->create_ctx();
+
+	if (!handle->secure_ctx)
+		return -EINVAL;
+
+	atomic_set(&handle->is_secure, 1);
+	return 0;
+}
+
+static int smaf_unsecure_handle(struct smaf_handle *handle)
+{
+	if (!atomic_read(&handle->is_secure))
+		return 0;
+
+	if (!have_secure_module())
+		return -EINVAL;
+
+	if (smaf_dev.secure->destroy_ctx(handle->secure_ctx))
+		return -EINVAL;
+
+	handle->secure_ctx = NULL;
+	atomic_set(&handle->is_secure, 0);
+	return 0;
+}
+
+int smaf_register_secure(struct smaf_secure *s)
+{
+	/* make sure that secure module have all required functions
+	 * to avoid test them each time later
+	 */
+	WARN_ON(!s || !s->create_ctx || !s->destroy_ctx ||
+		!s->grant_access || !s->revoke_access);
+
+	mutex_lock(&smaf_dev.lock);
+	smaf_dev.secure = s;
+	mutex_unlock(&smaf_dev.lock);
+
+	return 0;
+}
+EXPORT_SYMBOL(smaf_register_secure);
+
+void smaf_unregister_secure(struct smaf_secure *s)
+{
+	mutex_lock(&smaf_dev.lock);
+	if (smaf_dev.secure == s)
+		smaf_dev.secure = NULL;
+	mutex_unlock(&smaf_dev.lock);
+}
+EXPORT_SYMBOL(smaf_unregister_secure);
+
+static struct smaf_allocator *smaf_find_allocator(struct dma_buf *dmabuf)
+{
+	struct smaf_allocator *alloc;
+
+	list_for_each_entry(alloc, &smaf_dev.head, list_node) {
+		if (alloc->match(dmabuf))
+			return alloc;
+	}
+
+	return NULL;
+}
+
+static struct smaf_allocator *smaf_get_first_allocator(struct dma_buf *dmabuf)
+{
+	/* the first allocator of the list is the preferred allocator */
+	return list_first_entry(&smaf_dev.head, struct smaf_allocator,
+			list_node);
+}
+
+static int smaf_allocator_compare(void *priv,
+				  struct list_head *lh_a,
+				  struct list_head *lh_b)
+{
+	struct smaf_allocator *a = list_entry(lh_a,
+					      struct smaf_allocator, list_node);
+	struct smaf_allocator *b = list_entry(lh_b,
+					      struct smaf_allocator, list_node);
+	int diff;
+
+	diff = b->ranking - a->ranking;
+	if (diff)
+		return diff;
+
+	return strcmp(a->name, b->name);
+}
+
+int smaf_register_allocator(struct smaf_allocator *alloc)
+{
+	WARN_ON(!alloc || !alloc->match || !alloc->allocate || !alloc->name);
+
+	mutex_lock(&smaf_dev.lock);
+	list_add(&alloc->list_node, &smaf_dev.head);
+	list_sort(NULL, &smaf_dev.head, smaf_allocator_compare);
+	mutex_unlock(&smaf_dev.lock);
+
+	return 0;
+}
+EXPORT_SYMBOL(smaf_register_allocator);
+
+void smaf_unregister_allocator(struct smaf_allocator *alloc)
+{
+	mutex_lock(&smaf_dev.lock);
+	list_del(&alloc->list_node);
+	mutex_unlock(&smaf_dev.lock);
+}
+EXPORT_SYMBOL(smaf_unregister_allocator);
+
+static struct dma_buf_attachment *smaf_find_attachment(struct dma_buf *db_alloc,
+						       struct device *dev)
+{
+	struct dma_buf_attachment *attach_obj;
+
+	list_for_each_entry(attach_obj, &db_alloc->attachments, node) {
+		if (attach_obj->dev == dev)
+			return attach_obj;
+	}
+
+	return NULL;
+}
+
+static struct sg_table *smaf_map_dma_buf(struct dma_buf_attachment *attachment,
+					 enum dma_data_direction direction)
+{
+	struct dma_buf_attachment *db_attachment;
+	struct dma_buf *dmabuf = attachment->dmabuf;
+	struct smaf_handle *handle = dmabuf->priv;
+	struct sg_table *sgt;
+	unsigned int count_done, count;
+	struct scatterlist *sg;
+
+	/* try to find an allocator */
+	if (!handle->allocator) {
+		struct smaf_allocator *alloc;
+
+		mutex_lock(&smaf_dev.lock);
+		alloc = smaf_find_allocator(dmabuf);
+		mutex_unlock(&smaf_dev.lock);
+
+		/* still no allocator ? */
+		if (!alloc)
+			return NULL;
+
+		handle->allocator = alloc;
+	}
+
+	if (!handle->db_alloc) {
+		struct dma_buf *db_alloc;
+
+		db_alloc = handle->allocator->allocate(dmabuf,
+						       handle->length,
+						       handle->flags);
+		if (!db_alloc)
+			return NULL;
+
+		handle->db_alloc = db_alloc;
+	}
+
+	db_attachment = smaf_find_attachment(handle->db_alloc, attachment->dev);
+	sgt = dma_buf_map_attachment(db_attachment, direction);
+
+	if (!sgt)
+		return NULL;
+
+	if (!atomic_read(&handle->is_secure))
+		return sgt;
+
+	mutex_lock(&smaf_dev.lock);
+
+	/* now secure the data */
+	for_each_sg(sgt->sgl, sg, sgt->nents, count_done) {
+		if (!smaf_grant_access(handle, db_attachment->dev,
+				       sg_phys(sg), sg->length, direction))
+			goto failed;
+	}
+
+	mutex_unlock(&smaf_dev.lock);
+	return sgt;
+
+failed:
+	for_each_sg(sgt->sgl, sg, count_done, count) {
+		smaf_revoke_access(handle, db_attachment->dev,
+				   sg_phys(sg), sg->length, direction);
+	}
+
+	mutex_unlock(&smaf_dev.lock);
+
+	sg_free_table(sgt);
+	kfree(sgt);
+	return NULL;
+}
+
+static void smaf_unmap_dma_buf(struct dma_buf_attachment *attachment,
+			       struct sg_table *sgt,
+			       enum dma_data_direction direction)
+{
+	struct dma_buf_attachment *db_attachment;
+	struct dma_buf *dmabuf = attachment->dmabuf;
+	struct smaf_handle *handle = dmabuf->priv;
+	struct scatterlist *sg;
+	unsigned int count;
+
+	if (!handle->db_alloc)
+		return;
+
+	db_attachment = smaf_find_attachment(handle->db_alloc, attachment->dev);
+	if (!db_attachment)
+		return;
+
+	if (atomic_read(&handle->is_secure)) {
+		mutex_lock(&smaf_dev.lock);
+		for_each_sg(sgt->sgl, sg, sgt->nents, count) {
+			smaf_revoke_access(handle, db_attachment->dev,
+					   sg_phys(sg), sg->length, direction);
+		}
+		mutex_unlock(&smaf_dev.lock);
+	}
+
+	dma_buf_unmap_attachment(db_attachment, sgt, direction);
+}
+
+static void smaf_vm_close(struct vm_area_struct *vma)
+{
+	struct smaf_handle *handle = vma->vm_private_data;
+	enum dma_data_direction dir;
+
+	if (vma->vm_flags == VM_READ)
+		dir = DMA_TO_DEVICE;
+
+	if (vma->vm_flags == VM_WRITE)
+		dir = DMA_FROM_DEVICE;
+
+	if (vma->vm_flags == (VM_READ | VM_WRITE))
+		dir = DMA_BIDIRECTIONAL;
+
+	mutex_lock(&smaf_dev.lock);
+	smaf_revoke_access(handle, get_cpu_device(0), 0, handle->length, dir);
+	mutex_unlock(&smaf_dev.lock);
+}
+
+static struct vm_operations_struct smaf_vma_ops = {
+	.close = smaf_vm_close,
+};
+
+static int smaf_mmap(struct dma_buf *dmabuf, struct vm_area_struct *vma)
+{
+	struct smaf_handle *handle = dmabuf->priv;
+	bool ret;
+	enum dma_data_direction dir;
+
+	/* if no allocator attached, get the first allocator */
+	if (!handle->allocator) {
+		struct smaf_allocator *alloc;
+
+		mutex_lock(&smaf_dev.lock);
+		alloc = smaf_get_first_allocator(dmabuf);
+		mutex_unlock(&smaf_dev.lock);
+
+		/* still no allocator ? */
+		if (!alloc)
+			return -EINVAL;
+
+		handle->allocator = alloc;
+	}
+
+	if (!handle->db_alloc) {
+		struct dma_buf *db_alloc;
+
+		db_alloc = handle->allocator->allocate(dmabuf,
+						       handle->length,
+						       handle->flags);
+		if (!db_alloc)
+			return -EINVAL;
+
+		handle->db_alloc = db_alloc;
+	}
+
+	vma->vm_private_data = handle;
+	vma->vm_ops = &smaf_vma_ops;
+
+	if (vma->vm_flags == VM_READ)
+		dir = DMA_TO_DEVICE;
+
+	if (vma->vm_flags == VM_WRITE)
+		dir = DMA_FROM_DEVICE;
+
+	if (vma->vm_flags == (VM_READ | VM_WRITE))
+		dir = DMA_BIDIRECTIONAL;
+
+	mutex_lock(&smaf_dev.lock);
+	ret = smaf_grant_access(handle,
+				get_cpu_device(0), 0, handle->length, dir);
+	mutex_unlock(&smaf_dev.lock);
+
+	if (!ret)
+		return -EINVAL;
+
+	return dma_buf_mmap(handle->db_alloc, vma, 0);
+}
+
+static void smaf_dma_buf_release(struct dma_buf *dmabuf)
+{
+	struct smaf_handle *handle = dmabuf->priv;
+
+	if (handle->db_alloc)
+		dma_buf_put(handle->db_alloc);
+
+	mutex_lock(&smaf_dev.lock);
+	smaf_unsecure_handle(handle);
+	mutex_unlock(&smaf_dev.lock);
+
+	kfree(handle);
+}
+
+static int smaf_dma_buf_begin_cpu_access(struct dma_buf *dmabuf,
+					 enum dma_data_direction dir)
+{
+	struct smaf_handle *handle = dmabuf->priv;
+	bool ret;
+
+	if (!handle->db_alloc)
+		return -EINVAL;
+
+	mutex_lock(&smaf_dev.lock);
+	ret = smaf_grant_access(handle,
+				get_cpu_device(0), 0, handle->length, dir);
+	mutex_unlock(&smaf_dev.lock);
+
+	if (!ret)
+		return -EINVAL;
+
+	return dma_buf_begin_cpu_access(handle->db_alloc, dir);
+}
+
+static int smaf_dma_buf_end_cpu_access(struct dma_buf *dmabuf,
+				       enum dma_data_direction dir)
+{
+	struct smaf_handle *handle = dmabuf->priv;
+	int ret;
+
+	if (!handle->db_alloc)
+		return -EINVAL;
+
+	ret = dma_buf_end_cpu_access(handle->db_alloc, dir);
+
+	mutex_lock(&smaf_dev.lock);
+	smaf_revoke_access(handle, get_cpu_device(0), 0, handle->length, dir);
+	mutex_unlock(&smaf_dev.lock);
+
+	return ret;
+}
+
+static void *smaf_dma_buf_kmap_atomic(struct dma_buf *dmabuf,
+				      unsigned long offset)
+{
+	struct smaf_handle *handle = dmabuf->priv;
+
+	if (!handle->db_alloc)
+		return NULL;
+
+	return dma_buf_kmap_atomic(handle->db_alloc, offset);
+}
+
+static void smaf_dma_buf_kunmap_atomic(struct dma_buf *dmabuf,
+				       unsigned long offset, void *ptr)
+{
+	struct smaf_handle *handle = dmabuf->priv;
+
+	if (!handle->db_alloc)
+		return;
+
+	dma_buf_kunmap_atomic(handle->db_alloc, offset, ptr);
+}
+
+static void *smaf_dma_buf_kmap(struct dma_buf *dmabuf, unsigned long offset)
+{
+	struct smaf_handle *handle = dmabuf->priv;
+
+	if (!handle->db_alloc)
+		return NULL;
+
+	return dma_buf_kmap(handle->db_alloc, offset);
+}
+
+static void smaf_dma_buf_kunmap(struct dma_buf *dmabuf, unsigned long offset,
+				void *ptr)
+{
+	struct smaf_handle *handle = dmabuf->priv;
+
+	if (!handle->db_alloc)
+		return;
+
+	dma_buf_kunmap(handle->db_alloc, offset, ptr);
+}
+
+static void *smaf_dma_buf_vmap(struct dma_buf *dmabuf)
+{
+	struct smaf_handle *handle = dmabuf->priv;
+
+	if (!handle->db_alloc)
+		return NULL;
+
+	return dma_buf_vmap(handle->db_alloc);
+}
+
+static void smaf_dma_buf_vunmap(struct dma_buf *dmabuf, void *vaddr)
+{
+	struct smaf_handle *handle = dmabuf->priv;
+
+	if (!handle->db_alloc)
+		return;
+
+	dma_buf_vunmap(handle->db_alloc, vaddr);
+}
+
+static int smaf_attach(struct dma_buf *dmabuf, struct device *dev,
+		       struct dma_buf_attachment *attach)
+{
+	struct smaf_handle *handle = dmabuf->priv;
+	struct dma_buf_attachment *db_attach;
+
+	if (!handle->db_alloc)
+		return 0;
+
+	db_attach = dma_buf_attach(handle->db_alloc, dev);
+
+	return IS_ERR(db_attach);
+}
+
+static void smaf_detach(struct dma_buf *dmabuf,
+			struct dma_buf_attachment *attach)
+{
+	struct smaf_handle *handle = dmabuf->priv;
+	struct dma_buf_attachment *db_attachment;
+
+	if (!handle->db_alloc)
+		return;
+
+	db_attachment = smaf_find_attachment(handle->db_alloc, attach->dev);
+	dma_buf_detach(handle->db_alloc, db_attachment);
+}
+
+static struct dma_buf_ops smaf_dma_buf_ops = {
+	.attach = smaf_attach,
+	.detach = smaf_detach,
+	.map_dma_buf = smaf_map_dma_buf,
+	.unmap_dma_buf = smaf_unmap_dma_buf,
+	.mmap = smaf_mmap,
+	.release = smaf_dma_buf_release,
+	.begin_cpu_access = smaf_dma_buf_begin_cpu_access,
+	.end_cpu_access = smaf_dma_buf_end_cpu_access,
+	.kmap_atomic = smaf_dma_buf_kmap_atomic,
+	.kunmap_atomic = smaf_dma_buf_kunmap_atomic,
+	.kmap = smaf_dma_buf_kmap,
+	.kunmap = smaf_dma_buf_kunmap,
+	.vmap = smaf_dma_buf_vmap,
+	.vunmap = smaf_dma_buf_vunmap,
+};
+
+static bool is_smaf_dmabuf(struct dma_buf *dmabuf)
+{
+	return dmabuf->ops == &smaf_dma_buf_ops;
+}
+
+bool smaf_is_secure(struct dma_buf *dmabuf)
+{
+	struct smaf_handle *handle = dmabuf->priv;
+
+	if (!is_smaf_dmabuf(dmabuf))
+		return false;
+
+	return atomic_read(&handle->is_secure);
+}
+EXPORT_SYMBOL(smaf_is_secure);
+
+int smaf_set_secure(struct dma_buf *dmabuf, bool secure)
+{
+	struct smaf_handle *handle = dmabuf->priv;
+	int ret;
+
+	if (!is_smaf_dmabuf(dmabuf))
+		return -EINVAL;
+
+	mutex_lock(&smaf_dev.lock);
+	if (secure)
+		ret = smaf_secure_handle(handle);
+	else
+		ret = smaf_unsecure_handle(handle);
+	mutex_unlock(&smaf_dev.lock);
+
+	return ret;
+}
+EXPORT_SYMBOL(smaf_set_secure);
+
+int smaf_select_allocator_by_name(struct dma_buf *dmabuf, char *name)
+{
+	struct smaf_handle *handle = dmabuf->priv;
+	struct smaf_allocator *alloc;
+
+	if (!is_smaf_dmabuf(dmabuf))
+		return -EINVAL;
+
+	if (handle->allocator)
+		return -EINVAL;
+
+	mutex_lock(&smaf_dev.lock);
+
+	list_for_each_entry(alloc, &smaf_dev.head, list_node) {
+		if (!strncmp(alloc->name, name, ALLOCATOR_NAME_LENGTH)) {
+			handle->allocator = alloc;
+			handle->db_alloc = NULL;
+		}
+	}
+
+	mutex_unlock(&smaf_dev.lock);
+
+	if (!handle->allocator)
+		return -EINVAL;
+
+	return 0;
+}
+EXPORT_SYMBOL(smaf_select_allocator_by_name);
+
+struct smaf_handle *smaf_create_handle(size_t length, unsigned int flags)
+{
+	struct smaf_handle *handle;
+
+	DEFINE_DMA_BUF_EXPORT_INFO(info);
+
+	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
+	if (!handle)
+		return ERR_PTR(-ENOMEM);
+
+	info.ops = &smaf_dma_buf_ops;
+	info.size = round_up(length, PAGE_SIZE);
+	info.flags = flags;
+	info.priv = handle;
+
+	handle->dmabuf = dma_buf_export(&info);
+	if (IS_ERR(handle->dmabuf)) {
+		kfree(handle);
+		return NULL;
+	}
+
+	handle->length = info.size;
+	handle->flags = flags;
+
+	return handle;
+}
+EXPORT_SYMBOL(smaf_create_handle);
+
+static long smaf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	switch (cmd) {
+	case SMAF_IOC_CREATE:
+	{
+		struct smaf_create_data data;
+		struct smaf_handle *handle;
+
+		if (copy_from_user(&data, (void __user *)arg, _IOC_SIZE(cmd)))
+			return -EFAULT;
+
+		handle = smaf_create_handle(data.length, data.flags);
+		if (!handle)
+			return -EINVAL;
+
+		if (data.name[0]) {
+			/* user force allocator selection */
+			if (smaf_select_allocator_by_name(handle->dmabuf,
+							  data.name)) {
+				dma_buf_put(handle->dmabuf);
+				return -EINVAL;
+			}
+		}
+
+		handle->fd = dma_buf_fd(handle->dmabuf, data.flags);
+		if (handle->fd < 0) {
+			dma_buf_put(handle->dmabuf);
+			return -EINVAL;
+		}
+
+		data.fd = handle->fd;
+		if (copy_to_user((void __user *)arg, &data, _IOC_SIZE(cmd))) {
+			dma_buf_put(handle->dmabuf);
+			return -EFAULT;
+		}
+		break;
+	}
+	case SMAF_IOC_GET_SECURE_FLAG:
+	{
+		struct smaf_secure_flag data;
+		struct dma_buf *dmabuf;
+
+		if (copy_from_user(&data, (void __user *)arg, _IOC_SIZE(cmd)))
+			return -EFAULT;
+
+		dmabuf = dma_buf_get(data.fd);
+		if (!dmabuf)
+			return -EINVAL;
+
+		data.secure = smaf_is_secure(dmabuf);
+		dma_buf_put(dmabuf);
+
+		if (copy_to_user((void __user *)arg, &data, _IOC_SIZE(cmd)))
+			return -EFAULT;
+		break;
+	}
+	case SMAF_IOC_SET_SECURE_FLAG:
+	{
+		struct smaf_secure_flag data;
+		struct dma_buf *dmabuf;
+		int ret;
+
+		if (!smaf_dev.secure)
+			return -EINVAL;
+
+		if (copy_from_user(&data, (void __user *)arg, _IOC_SIZE(cmd)))
+			return -EFAULT;
+
+		dmabuf = dma_buf_get(data.fd);
+		if (!dmabuf)
+			return -EINVAL;
+
+		ret = smaf_set_secure(dmabuf, data.secure);
+
+		dma_buf_put(dmabuf);
+
+		if (ret)
+			return -EINVAL;
+
+		break;
+	}
+	case SMAF_IOC_GET_INFO:
+	{
+		struct smaf_info info;
+		struct smaf_allocator *alloc;
+
+		if (copy_from_user(&info, (void __user *)arg, _IOC_SIZE(cmd)))
+			return -EFAULT;
+
+		info.count = 0;
+		list_for_each_entry(alloc,  &smaf_dev.head, list_node) {
+			if (info.count++ == info.index)
+				strncpy(info.name, alloc->name,
+					ALLOCATOR_NAME_LENGTH);
+		}
+
+		if (info.index >= info.count)
+			return -EINVAL;
+
+		if (copy_to_user((void __user *)arg, &info, _IOC_SIZE(cmd)))
+			return -EFAULT;
+		break;
+	}
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static const struct file_operations smaf_fops = {
+	.owner = THIS_MODULE,
+	.unlocked_ioctl = smaf_ioctl,
+};
+
+static int __init smaf_init(void)
+{
+	int ret = 0;
+
+	smaf_dev.misc_dev.minor = MISC_DYNAMIC_MINOR;
+	smaf_dev.misc_dev.name  = "smaf";
+	smaf_dev.misc_dev.fops  = &smaf_fops;
+
+	/* register misc device */
+	ret = misc_register(&smaf_dev.misc_dev);
+	if (ret < 0)
+		return ret;
+
+	mutex_init(&smaf_dev.lock);
+	INIT_LIST_HEAD(&smaf_dev.head);
+
+	return ret;
+}
+module_init(smaf_init);
+
+static void __exit smaf_deinit(void)
+{
+	misc_deregister(&smaf_dev.misc_dev);
+}
+module_exit(smaf_deinit);
+
+MODULE_DESCRIPTION("Secure Memory Allocation Framework");
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Benjamin Gaignard <benjamin.gaignard@linaro.org>");
diff --git a/include/linux/smaf-allocator.h b/include/linux/smaf-allocator.h
new file mode 100644
index 0000000..f764ef4
--- /dev/null
+++ b/include/linux/smaf-allocator.h
@@ -0,0 +1,54 @@
+/*
+ * smaf-allocator.h
+ *
+ * Copyright (C) Linaro SA 2015
+ * Author: Benjamin Gaignard <benjamin.gaignard@linaro.org> for Linaro.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#ifndef _SMAF_ALLOCATOR_H_
+#define _SMAF_ALLOCATOR_H_
+
+#include <linux/dma-buf.h>
+#include <linux/list.h>
+
+/**
+ * struct smaf_allocator - implement dma_buf_ops like functions
+ *
+ * @match: match function to check if allocator can accept the devices
+ *	   attached to dmabuf
+ * @allocate: allocate memory with the given length and flags
+ *	      return a dma_buf handle
+ * @name: allocator name
+ * @ranking: allocator ranking (bigger is better)
+ */
+struct smaf_allocator {
+	struct list_head list_node;
+	bool (*match)(struct dma_buf *dmabuf);
+	struct dma_buf *(*allocate)(struct dma_buf *dmabuf,
+				    size_t length, unsigned int flags);
+	const char *name;
+	int ranking;
+};
+
+/**
+ * smaf_register_allocator - register an allocator to be used by SMAF
+ * @alloc: smaf_allocator structure
+ */
+int smaf_register_allocator(struct smaf_allocator *alloc);
+
+/**
+ * smaf_unregister_allocator - unregister alloctor
+ * @alloc: smaf_allocator structure
+ */
+void smaf_unregister_allocator(struct smaf_allocator *alloc);
+
+/**
+ * smaf_select_allocator_by_name - select an allocator by it name
+ * return 0 if the allocator has been found and selected.
+ * @dmabuf: dma_buf buffer handler
+ * @name: name of the allocator to be selected
+ */
+int smaf_select_allocator_by_name(struct dma_buf *dmabuf, char *name);
+
+#endif
diff --git a/include/linux/smaf-secure.h b/include/linux/smaf-secure.h
new file mode 100644
index 0000000..fffcde8
--- /dev/null
+++ b/include/linux/smaf-secure.h
@@ -0,0 +1,73 @@
+/*
+ * smaf-secure.h
+ *
+ * Copyright (C) Linaro SA 2015
+ * Author: Benjamin Gaignard <benjamin.gaignard@linaro.org> for Linaro.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#ifndef _SMAF_SECURE_H_
+#define _SMAF_SECURE_H_
+
+#include <linux/dma-buf.h>
+#include <linux/dma-mapping.h>
+
+/**
+ * struct smaf_secure
+ * @create_ctx:		create a context for one dmabuf.
+ * @destroy_ctx:	destroy context.
+ * @grant_access:	check and provide access to memory area for a specific
+ *			device. Return true if the request is valid.
+ * @revoke_access:	remove device access rights.
+ */
+struct smaf_secure {
+	void *(*create_ctx)(void);
+	int (*destroy_ctx)(void *ctx);
+	bool (*grant_access)(void *ctx,
+			     struct device *dev,
+			     size_t addr, size_t size,
+			     enum dma_data_direction direction);
+	void (*revoke_access)(void *ctx,
+			      struct device *dev,
+			      size_t addr, size_t size,
+			      enum dma_data_direction direction);
+};
+
+/**
+ * smaf_register_secure - register secure module helper
+ * Secure module helper should be platform specific so only one can be
+ * registered.
+ *
+ * @sec: secure module to be registered
+ */
+int smaf_register_secure(struct smaf_secure *sec);
+
+/**
+ * smaf_unregister_secure - unregister secure module helper
+ */
+void smaf_unregister_secure(struct smaf_secure *sec);
+
+/**
+ * smaf_is_secure - test is a dma_buf handle has been secured by SMAF
+ * @dmabuf: dma_buf handle to be tested
+ */
+bool smaf_is_secure(struct dma_buf *dmabuf);
+
+/**
+ * smaf_set_secure - change dma_buf handle secure status
+ * @dmabuf: dma_buf handle to be change
+ * @secure: if true secure dma_buf handle
+ */
+int smaf_set_secure(struct dma_buf *dmabuf, bool secure);
+
+/**
+ * smaf_create_handle - create a smaf_handle with the give length and flags
+ * do not allocate memory but provide smaf_handle->dmabuf that can be
+ * shared between devices.
+ *
+ * @length: buffer size
+ * @flags: handle flags
+ */
+struct smaf_handle *smaf_create_handle(size_t length, unsigned int flags);
+
+#endif
diff --git a/include/uapi/linux/smaf.h b/include/uapi/linux/smaf.h
new file mode 100644
index 0000000..5a9201b
--- /dev/null
+++ b/include/uapi/linux/smaf.h
@@ -0,0 +1,66 @@
+/*
+ * smaf.h
+ *
+ * Copyright (C) Linaro SA 2015
+ * Author: Benjamin Gaignard <benjamin.gaignard@linaro.org> for Linaro.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#ifndef _UAPI_SMAF_H_
+#define _UAPI_SMAF_H_
+
+#include <linux/ioctl.h>
+#include <linux/types.h>
+
+#define ALLOCATOR_NAME_LENGTH 64
+
+/**
+ * struct smaf_create_data - allocation parameters
+ * @length:	size of the allocation
+ * @flags:	flags passed to allocator
+ * @name:	name of the allocator to be selected, could be NULL
+ * @fd:		returned file descriptor
+ */
+struct smaf_create_data {
+	size_t length;
+	unsigned int flags;
+	char name[ALLOCATOR_NAME_LENGTH];
+	int fd;
+};
+
+/**
+ * struct smaf_secure_flag - set/get secure flag
+ * @fd:		file descriptor
+ * @secure:	secure flag value (set or get)
+ */
+struct smaf_secure_flag {
+	int fd;
+	int secure;
+};
+
+/**
+ * struct smaf_info - get registered allocator name per index
+ * @index:	allocator's index
+ * @count:	return number of registered allocators
+ * @name:	return allocator name
+ */
+struct smaf_info {
+	int index;
+	int count;
+	char name[ALLOCATOR_NAME_LENGTH];
+};
+
+#define SMAF_IOC_MAGIC	'S'
+
+#define SMAF_IOC_CREATE		 _IOWR(SMAF_IOC_MAGIC, 0, \
+				       struct smaf_create_data)
+
+#define SMAF_IOC_GET_SECURE_FLAG _IOWR(SMAF_IOC_MAGIC, 1, \
+				       struct smaf_secure_flag)
+
+#define SMAF_IOC_SET_SECURE_FLAG _IOWR(SMAF_IOC_MAGIC, 2, \
+				       struct smaf_secure_flag)
+
+#define SMAF_IOC_GET_INFO	 _IOWR(SMAF_IOC_MAGIC, 3, struct smaf_info)
+
+#endif
-- 
1.9.1

