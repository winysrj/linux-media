Return-path: <mchehab@pedra>
Received: from ganesha.gnumonks.org ([213.95.27.120]:54820 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab1CHHJY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Mar 2011 02:09:24 -0500
From: Jonghun Han <jonghun.han@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, Jonghun Han <jonghun.han@samsung.com>
Subject: [RFC 1/1] v4l: videobuf2: Add Exynos devices based allocator, named SDVMM
Date: Tue,  8 Mar 2011 15:47:45 +0900
Message-Id: <1299566865-5499-2-git-send-email-jonghun.han@samsung.com>
In-Reply-To: <1299566865-5499-1-git-send-email-jonghun.han@samsung.com>
References: <1299566865-5499-1-git-send-email-jonghun.han@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

SDVMM: Shared Device Virtual Memory Management

This patch adds new videobuf2 memory allocator dedicated to Exynos.
This allocator gets memory using VCM which can get memory its own allocator
and also get memory via CMA optionally.

It requires the following 4 modules.
UMP (Unified Memory Provider), suggested by ARM.
VCM (Virtual Contiguous Memory framework), submitted by Samsung
CMA (Contiguous Memory Allocator), submitted by Samsung
SYS.MMU (System MMU), submitted by Samsung.

Signed-off-by: Jonghun Han <jonghun.han@samsung.com>
---
 drivers/media/video/videobuf2-sdvmm.c |  659 +++++++++++++++++++++++++++++++++
 include/media/videobuf2-sdvmm.h       |   58 +++
 2 files changed, 717 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/videobuf2-sdvmm.c
 create mode 100644 include/media/videobuf2-sdvmm.h

diff --git a/drivers/media/video/videobuf2-sdvmm.c b/drivers/media/video/videobuf2-sdvmm.c
new file mode 100644
index 0000000..06e12aa
--- /dev/null
+++ b/drivers/media/video/videobuf2-sdvmm.c
@@ -0,0 +1,659 @@
+/* linux/drivers/media/video/videobuf2-sdvmm.c
+ *
+ * Copyright (c) 2010 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * Implementation of SDVMM memory allocator for videobuf2
+ * SDVMM : Shared Device Virtual Memory Management
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#include <linux/err.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mm.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <linux/cma.h>
+#include <linux/vcm-drv.h>
+
+#include <plat/s5p-vcm.h>
+#include <media/videobuf2-sdvmm.h>
+
+#include "ump_kernel_interface.h"
+#include "ump_kernel_interface_ref_drv.h"
+#include "ump_kernel_interface_vcm.h"
+
+static int sdvmm_debug;
+module_param(sdvmm_debug, int, 0644);
+#define dbg(level, fmt, arg...)						\
+	do {								\
+		if (sdvmm_debug >= level)				\
+			printk(KERN_DEBUG "vb2_sdvmm: " fmt, ## arg);	\
+	} while (0)
+
+struct vb2_sdvmm_conf {
+	spinlock_t              slock;
+
+	/* For CMA */
+	struct device		*dev;
+	const char		*type;
+	unsigned long		alignment;
+	bool			use_cma;
+
+	/* For VCMM */
+	struct vcm		*vcm_ctx;
+	enum vcm_dev_id		vcm_id;
+
+	/* SYS.MMU */
+	bool			mmu_clk;
+	bool			(*get_power)(void *);
+
+	void 			*priv;
+};
+
+struct vb2_sdvmm_buf {
+	struct vm_area_struct		*vma;
+	struct vb2_sdvmm_conf		*conf;
+	struct vb2_vmarea_handler	handler;
+
+	atomic_t			ref;
+	unsigned long			size;
+
+	struct vcm_res			*vcm_res;
+	struct vcm_res			*vcm_res_kern;
+	ump_dd_handle			ump_dd_handle;
+	unsigned long			dva_offset;
+};
+
+static void vb2_sdvmm_put(void *buf_priv);
+static int _vb2_sdvmm_mmap_pfn_range(struct vm_area_struct *vma,
+				     struct vcm_phys *vcm_phys,
+				     unsigned long size,
+				     const struct vm_operations_struct *vm_ops,
+				     void *priv);
+
+static void *_vb2_sdvmm_ump_register(struct vb2_sdvmm_buf *buf)
+{
+	struct vcm_phys_part	*part = buf->vcm_res->phys->parts;
+	ump_dd_physical_block	*blocks;
+	ump_dd_handle		*handle;
+	struct ump_vcm		ump_vcm;
+	int num_blocks = buf->vcm_res->phys->count;
+	int block_size, i;
+
+	block_size = sizeof(ump_dd_physical_block) * num_blocks;
+	blocks = (ump_dd_physical_block *)vmalloc(block_size);
+	for (i = 0; i < num_blocks; i++) {
+		blocks[i].addr = part->start;
+		blocks[i].size = part->size;
+		++part;
+
+		dbg(6, "block addr(0x%08x), size(0x%08x)\n",
+			(u32)blocks[i].addr, (u32)blocks[i].size);
+	}
+
+	handle = ump_dd_handle_create_from_phys_blocks(blocks, num_blocks);
+	vfree(blocks);
+	if (handle == UMP_DD_HANDLE_INVALID) {
+		pr_err("ump_dd_handle_create_from_phys_blocks failed\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	ump_vcm.vcm = buf->conf->vcm_ctx;
+	ump_vcm.vcm_res = buf->vcm_res;
+	ump_vcm.dev_id = buf->conf->vcm_id;
+
+	if (ump_dd_meminfo_set(handle, (void *)&ump_vcm)) {
+		ump_dd_reference_release(handle);
+		return ERR_PTR(-EINVAL);
+	}
+
+	return (void *)handle;
+}
+
+static void _vb2_sdvmm_cma_free(struct vcm_phys *vcm_phys)
+{
+	cma_free(vcm_phys->parts[0].start);
+	kfree(vcm_phys);
+}
+
+static void *vb2_sdvmm_alloc(void *alloc_ctx, unsigned long size)
+{
+	struct vb2_sdvmm_conf	*conf = alloc_ctx;
+	struct vb2_sdvmm_buf	*buf;
+	struct vcm_phys		*vcm_phys = NULL;
+	dma_addr_t		paddr;
+	unsigned long		aligned_size = ALIGN(size, SZ_4K);
+	int ret;
+
+	buf = kzalloc(sizeof *buf, GFP_KERNEL);
+	if (!buf) {
+		pr_err("no memory for vb2_sdvmm_conf\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	/* Set vb2_sdvmm_buf.conf and size */
+	buf->conf = conf;
+	buf->size = size;
+
+	/* Allocate: physical memory */
+	if (conf->use_cma) {	/* physically contiguous memory allocation */
+		paddr = cma_alloc(conf->dev, conf->type, size, conf->alignment);
+		if (IS_ERR((void *)paddr)) {
+			pr_err("cma_alloc of size %ld failed\n", size);
+			ret = -ENOMEM;
+			goto err_alloc;
+		}
+
+		vcm_phys = kzalloc(sizeof(*vcm_phys) + sizeof(*vcm_phys->parts),
+				   GFP_KERNEL);
+		vcm_phys->count = 1;
+		vcm_phys->size = aligned_size;
+		vcm_phys->free = _vb2_sdvmm_cma_free;
+		vcm_phys->parts[0].start = paddr;
+		vcm_phys->parts[0].size = aligned_size;
+	} else {
+		vcm_phys = vcm_alloc(conf->vcm_ctx, aligned_size, 0);
+		if (IS_ERR((struct vcm_phys *)vcm_phys)) {
+			pr_err("vcm_alloc of size %ld failed\n", size);
+			ret = -ENOMEM;
+			goto err_alloc;
+		}
+	}
+	dbg(6, "PA(0x%x)\n", vcm_phys->parts[0].start);
+
+	/* Reserve & Bind: device virtual address */
+	buf->vcm_res = vcm_map(conf->vcm_ctx, vcm_phys, 0);
+	if (IS_ERR((struct vcm_res *)buf->vcm_res)) {
+		pr_err("vcm_map of size %ld failed\n", size);
+		ret = -ENOMEM;
+		goto err_map;
+	}
+	dbg(6, "DVA(0x%x)\n", buf->vcm_res->start);
+
+	/* Register: UMP */
+	buf->ump_dd_handle = _vb2_sdvmm_ump_register(buf);
+	if (IS_ERR(buf->ump_dd_handle)) {
+		pr_err("ump_register failed\n");
+		ret = -ENOMEM;
+		goto err_ump;
+	}
+
+	/* Set struct vb2_vmarea_handler */
+	buf->handler.refcount = &buf->ref;
+	buf->handler.put = vb2_sdvmm_put;
+	buf->handler.arg = buf;
+
+	atomic_inc(&buf->ref);
+
+	return buf;
+
+err_ump:
+	vcm_unmap(buf->vcm_res);
+
+err_map:
+	vcm_free(vcm_phys);
+
+err_alloc:
+	kfree(buf);
+
+	return ERR_PTR(ret);
+}
+
+static void vb2_sdvmm_put(void *buf_priv)
+{
+	struct vb2_sdvmm_buf *buf = buf_priv;
+	struct vb2_sdvmm_conf *conf = buf->conf;
+	struct vcm_phys *vcm_phys = NULL;
+	bool need_clk_ctrl = false;
+
+	if (atomic_dec_and_test(&buf->ref)) {
+		ump_dd_reference_release(buf->ump_dd_handle);
+
+		if (conf->get_power(conf->priv) && !conf->mmu_clk) {
+			need_clk_ctrl = true;
+			vb2_sdvmm_resume((void *)conf);
+		}
+
+		vcm_phys = vcm_unbind(buf->vcm_res);
+		if (IS_ERR((struct vcm_phys *)vcm_phys)) {
+			if (need_clk_ctrl)
+				vb2_sdvmm_suspend((void *)conf);
+			pr_err("vcm_unbind failed\n");
+			return;
+		}
+
+		if (need_clk_ctrl)
+			vb2_sdvmm_suspend((void *)conf);
+
+		vcm_unreserve(buf->vcm_res);
+
+		if (buf->vcm_res_kern)
+			vcm_unmap(buf->vcm_res_kern);
+
+		vcm_free(vcm_phys);
+
+		kfree(buf);
+	}
+
+	dbg(6, "released: buf_refcnt(%d)\n", atomic_read(&buf->ref));
+}
+
+/**
+ * _vb2_get_sdvmm_userptr() - lock userspace mapped memory
+ * @vaddr:	starting virtual address of the area to be verified
+ * @size:	size of the area
+ * @res_vma:	will return locked copy of struct vm_area for the given area
+ *
+ * This function will go through memory area of size @size mapped at @vaddr
+ * If they are contiguous the virtual memory area is locked and a @res_vma is
+ * filled with the copy and @res_pa set to the physical address of the buffer.
+ *
+ * Returns 0 on success.
+ */
+static int _vb2_get_sdvmm_userptr(unsigned long vaddr, unsigned long size,
+				  struct vm_area_struct **res_vma)
+{
+	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *vma;
+	unsigned long offset, start, end;
+	int ret = -EFAULT;
+
+	start = vaddr;
+	offset = start & ~PAGE_MASK;
+	end = start + size;
+
+	down_read(&mm->mmap_sem);
+	vma = find_vma(mm, start);
+
+	if (vma == NULL || vma->vm_end < end)
+		goto done;
+
+	/* Lock vma and return to the caller */
+	*res_vma = vb2_get_vma(vma);
+	if (*res_vma == NULL) {
+		ret = -ENOMEM;
+		goto done;
+	}
+	ret = 0;
+
+done:
+	up_read(&mm->mmap_sem);
+	return ret;
+}
+
+static void *vb2_sdvmm_get_userptr(void *alloc_ctx, unsigned long vaddr,
+				   unsigned long size, int write)
+{
+	struct vb2_sdvmm_conf *conf = alloc_ctx;
+	struct vb2_sdvmm_buf *buf = NULL;
+	struct vm_area_struct *vma = NULL;
+	ump_dd_handle ump_dd_handle = NULL;
+	ump_secure_id secure_id = 0;
+	unsigned long offset = 0;
+	int ret;
+
+	/* buffer should be registered in UMP before QBUF */
+	ret = ump_dd_secure_id_get_from_vaddr(vaddr, &secure_id, &offset);
+	if (ret) {
+		pr_err("fail: get SecureID from vaddr(0x%08x)\n", (u32)vaddr);
+		return ERR_PTR(-EINVAL);
+	}
+
+	ump_dd_handle = ump_dd_handle_create_from_secure_id(secure_id);
+	if (ump_dd_handle == NULL) {
+		pr_err("ump_dd_handle_get_from_vaddr failed\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	buf = kzalloc(sizeof *buf, GFP_KERNEL);
+	if (!buf)
+		return ERR_PTR(-ENOMEM);
+
+	buf->vcm_res = (struct vcm_res *)ump_dd_meminfo_get(secure_id,
+							(void *)conf->vcm_id);
+	if (buf->vcm_res == NULL) {
+		pr_err("ump_dd_meminfo_get failed\n");
+		kfree(buf);
+		return ERR_PTR(-EINVAL);
+	}
+	buf->dva_offset = offset;
+
+	dbg(6, "dva(0x%x), size(0x%x), offset(0x%x)\n",
+			(u32)buf->vcm_res->start, (u32)size, (u32)offset);
+
+	ret = _vb2_get_sdvmm_userptr(vaddr, size, &vma);
+	if (ret) {
+		pr_err("Failed acquiring VMA 0x%08lx\n", vaddr);
+		ump_dd_reference_release(buf->ump_dd_handle);
+		kfree(buf);
+		return ERR_PTR(ret);
+	}
+
+	buf->conf = conf;
+	buf->size = size;
+	buf->vma = vma;
+	buf->ump_dd_handle = ump_dd_handle;
+
+	return buf;
+}
+
+static void vb2_sdvmm_put_userptr(void *mem_priv)
+{
+	struct vb2_sdvmm_buf *buf = mem_priv;
+
+	if (!buf) {
+		pr_err("No buffer to put\n");
+		return;
+	}
+
+	ump_dd_reference_release(buf->ump_dd_handle);
+
+	vb2_put_vma(buf->vma);
+
+	kfree(buf);
+}
+
+static void *vb2_sdvmm_cookie(void *buf_priv)
+{
+	struct vb2_sdvmm_buf *buf = buf_priv;
+
+	return (void *)(buf->vcm_res->start + buf->dva_offset);
+}
+
+static void *vb2_sdvmm_vaddr(void *buf_priv)
+{
+	struct vb2_sdvmm_buf *buf = buf_priv;
+
+	if (!buf) {
+		pr_err("failed to get buffer\n");
+		return NULL;
+	}
+
+	if (!buf->vcm_res_kern) {
+		buf->vcm_res_kern = vcm_map(vcm_vmm, buf->vcm_res->phys, 0);
+		if (IS_ERR(buf->vcm_res_kern)) {
+			pr_err("failed to get kernel virtual\n");
+			return NULL;
+		}
+	}
+
+	return (void *)buf->vcm_res_kern->start;
+}
+
+static unsigned int vb2_sdvmm_num_users(void *buf_priv)
+{
+	struct vb2_sdvmm_buf *buf = buf_priv;
+
+	return atomic_read(&buf->ref);
+}
+
+static int vb2_sdvmm_mmap(void *buf_priv, struct vm_area_struct *vma)
+{
+	struct vb2_sdvmm_buf *buf = buf_priv;
+
+	if (!buf) {
+		pr_err("No buffer to map\n");
+		return -EINVAL;
+	}
+
+	return _vb2_sdvmm_mmap_pfn_range(vma, buf->vcm_res->phys, buf->size,
+				&vb2_common_vm_ops, &buf->handler);
+}
+
+const struct vb2_mem_ops vb2_sdvmm_memops = {
+	.alloc		= vb2_sdvmm_alloc,
+	.put		= vb2_sdvmm_put,
+	.cookie		= vb2_sdvmm_cookie,
+	.vaddr		= vb2_sdvmm_vaddr,
+	.mmap		= vb2_sdvmm_mmap,
+	.get_userptr	= vb2_sdvmm_get_userptr,
+	.put_userptr	= vb2_sdvmm_put_userptr,
+	.num_users	= vb2_sdvmm_num_users,
+};
+EXPORT_SYMBOL_GPL(vb2_sdvmm_memops);
+
+void vb2_sdvmm_suspend(void *alloc_ctx)
+{
+	struct vb2_sdvmm_conf *conf = alloc_ctx;
+	unsigned long flags;
+
+	spin_lock_irqsave(&conf->slock, flags);
+	if (!conf->mmu_clk) {
+		pr_warning("Already suspend: vcm_id(%d)\n", conf->vcm_id);
+		spin_unlock_irqrestore(&conf->slock, flags);
+		return;
+	}
+
+	conf->mmu_clk = false;
+	s5p_vcm_turn_off(conf->vcm_ctx);
+
+	spin_unlock_irqrestore(&conf->slock, flags);
+}
+
+void vb2_sdvmm_resume(void *alloc_ctx)
+{
+	struct vb2_sdvmm_conf *conf = alloc_ctx;
+	unsigned long flags;
+
+	spin_lock_irqsave(&conf->slock, flags);
+
+	if (conf->mmu_clk) {
+		pr_warning("Already resume: vcm_id(%d)\n", conf->vcm_id);
+		spin_unlock_irqrestore(&conf->slock, flags);
+		return;
+	}
+
+	conf->mmu_clk = true;
+	s5p_vcm_turn_on(conf->vcm_ctx);
+
+	spin_unlock_irqrestore(&conf->slock, flags);
+}
+
+void *vb2_sdvmm_init(struct vb2_vcm *vcm,
+		     struct vb2_cma *cma,
+		     struct vb2_drv *drv)
+{
+	struct vb2_sdvmm_conf *conf;
+	int ret;
+
+	conf = kzalloc(sizeof *conf, GFP_KERNEL);
+	if (!conf)
+		return ERR_PTR(-ENOMEM);
+
+	if (cma != NULL) {
+		conf->dev	= cma->dev;
+		conf->type	= cma->type;
+		conf->alignment = cma->alignment;
+		conf->use_cma	= true;
+	}
+
+	conf->vcm_id = vcm->vcm_id;
+
+	conf->vcm_ctx = vcm_create_unified(vcm->size, vcm->vcm_id, NULL);
+	if (IS_ERR(conf->vcm_ctx)) {
+		pr_err("vcm_create failed: vcm_id(%d), size(%ld)\n",
+				conf->vcm_id, (long int)vcm->size);
+		goto err_vcm_create;
+	}
+
+	s5p_vcm_turn_off(conf->vcm_ctx);
+	ret = vcm_activate(conf->vcm_ctx);
+	if (ret < 0) {
+		pr_err("vcm_activate failed\n");
+		goto err_vcm_activate;
+	}
+
+	conf->mmu_clk	= false;
+	conf->get_power = drv->get_power;
+	conf->priv	= drv->priv;
+
+	spin_lock_init(&conf->slock);
+
+	return conf;
+
+err_vcm_activate:
+	s5p_vcm_turn_off(conf->vcm_ctx);
+	vcm_destroy(conf->vcm_ctx);
+
+err_vcm_create:
+	kfree(conf);
+
+	return ERR_PTR(-EINVAL);
+}
+EXPORT_SYMBOL_GPL(vb2_sdvmm_init);
+
+void vb2_sdvmm_cleanup(void *alloc_ctx)
+{
+	struct vb2_sdvmm_conf *local_conf = alloc_ctx;
+
+	vcm_deactivate(local_conf->vcm_ctx);
+	vcm_destroy(local_conf->vcm_ctx);
+	kfree(alloc_ctx);
+}
+EXPORT_SYMBOL_GPL(vb2_sdvmm_cleanup);
+
+void **vb2_sdvmm_init_multi(unsigned int num_planes,
+			    struct vb2_vcm *vcm,
+			    struct vb2_cma *cma[],
+			    struct vb2_drv *drv)
+{
+	struct vb2_sdvmm_conf *conf;
+	struct vcm *vcm_ctx;
+	void **alloc_ctxes;
+	u32 i, ret;
+
+	/* allocate structure of alloc_ctxes */
+	alloc_ctxes = kzalloc((sizeof *alloc_ctxes + sizeof *conf) * num_planes,
+			      GFP_KERNEL);
+
+	if (!alloc_ctxes)
+		return ERR_PTR(-ENOMEM);
+
+	vcm_ctx = vcm_create_unified(vcm->size, vcm->vcm_id, NULL);
+	if (IS_ERR(vcm_ctx)) {
+		pr_err("vcm_create of size %ld failed\n", (long int)vcm->size);
+		goto err_vcm_create;
+	}
+
+	s5p_vcm_turn_off(vcm_ctx);
+	ret = vcm_activate(vcm_ctx);
+	if (ret < 0) {
+		pr_err("vcm_activate failed\n");
+		goto err_vcm_activate;
+	}
+
+	conf = (void *)(alloc_ctxes + num_planes);
+
+	for (i = 0; i < num_planes; ++i, ++conf) {
+		alloc_ctxes[i] = conf;
+		if ((cma != NULL) && (cma[i] != NULL)) {
+			conf->dev	= cma[i]->dev;
+			conf->type	= cma[i]->type;
+			conf->alignment = cma[i]->alignment;
+			conf->use_cma	= true;
+		}
+		conf->vcm_ctx	= vcm_ctx;
+		conf->vcm_id	= vcm->vcm_id;
+		conf->mmu_clk	= false;
+		conf->get_power = drv->get_power;
+		conf->priv	= drv->priv;
+	}
+
+	return alloc_ctxes;
+
+err_vcm_activate:
+	s5p_vcm_turn_off(vcm_ctx);
+	vcm_destroy(vcm_ctx);
+
+err_vcm_create:
+	kfree(alloc_ctxes);
+
+	return ERR_PTR(-EINVAL);
+}
+EXPORT_SYMBOL_GPL(vb2_sdvmm_init_multi);
+
+void vb2_sdvmm_cleanup_multi(void **alloc_ctxes)
+{
+	struct vb2_sdvmm_conf *local_conf = alloc_ctxes[0];
+
+	vcm_deactivate(local_conf->vcm_ctx);
+	vcm_destroy(local_conf->vcm_ctx);
+
+	kfree(alloc_ctxes);
+}
+EXPORT_SYMBOL_GPL(vb2_sdvmm_cleanup_multi);
+
+/**
+ * _vb2_sdvmm_mmap_pfn_range() - map physical pages(vcm) to userspace
+ * @vma:	virtual memory region for the mapping
+ * @vcm_phys:	vcm physical group information to be mapped
+ * @size:	size of the memory to be mapped
+ * @vm_ops:	vm operations to be assigned to the created area
+ * @priv:	private data to be associated with the area
+ *
+ * Returns 0 on success.
+ */
+static int _vb2_sdvmm_mmap_pfn_range(struct vm_area_struct *vma,
+				      struct vcm_phys *vcm_phys,
+				      unsigned long size,
+				      const struct vm_operations_struct *vm_ops,
+				      void *priv)
+{
+	unsigned long org_vm_start = vma->vm_start;
+	int ret, i;
+	int count = vcm_phys->count;
+	int mapped_size = 0;
+	int vma_size = vma->vm_end - vma->vm_start;
+	int remap_break = 0;
+	resource_size_t remap_size;
+
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+
+	/* sequentially physical-virtual mapping */
+	for (i = 0; (i < count && !remap_break); i++) {
+		if ((mapped_size + vcm_phys->parts[i].size) > vma_size) {
+			remap_size = vma_size - mapped_size;
+			remap_break = 1;
+		} else {
+			remap_size = vcm_phys->parts[i].size;
+		}
+
+		ret = remap_pfn_range(vma, vma->vm_start,
+				vcm_phys->parts[i].start >> PAGE_SHIFT,
+				remap_size, vma->vm_page_prot);
+		if (ret) {
+			pr_err("Remapping failed, error: %d\n", ret);
+			return ret;
+		}
+
+		dbg(6, "%dth page vaddr(0x%08x), paddr(0x%08x),	size(0x%08x)\n",
+			i, (u32)vma->vm_start, vcm_phys->parts[i].start,
+			vcm_phys->parts[i].size);
+
+		mapped_size += remap_size;
+		vma->vm_start += vcm_phys->parts[i].size;
+	}
+
+	WARN_ON(size > mapped_size);
+
+	/* re-assign initial start address */
+	vma->vm_start		= org_vm_start;
+	vma->vm_flags		|= VM_DONTEXPAND | VM_RESERVED;
+	vma->vm_private_data	= priv;
+	vma->vm_ops		= vm_ops;
+
+	vma->vm_ops->open(vma);
+
+	return 0;
+}
+
+MODULE_AUTHOR("Sewoon Park <senui.park@samsung.com>");
+MODULE_AUTHOR("Jonghun,	Han <jonghun.han@samsung.com>");
+MODULE_DESCRIPTION("SDVMM allocator handling routines for videobuf2");
+MODULE_LICENSE("GPL");
diff --git a/include/media/videobuf2-sdvmm.h b/include/media/videobuf2-sdvmm.h
new file mode 100644
index 0000000..c31b666
--- /dev/null
+++ b/include/media/videobuf2-sdvmm.h
@@ -0,0 +1,58 @@
+/* include/media/videobuf2-sdvmm.h
+ *
+ * Copyright 2010 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * Definition of SDVMM memory allocator for videobuf2
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _MEDIA_VIDEOBUF2_SDVMM_H
+#define _MEDIA_VIDEOBUF2_SDVMM_H
+
+#include <linux/vcm.h>
+#include <media/videobuf2-core.h>
+#include <media/videobuf2-memops.h>
+#include <plat/s5p-vcm.h>
+
+struct vb2_vcm {
+	enum vcm_dev_id			vcm_id;
+	resource_size_t			size;
+};
+
+struct vb2_cma {
+	struct device	*dev;
+	const char	*type;
+	unsigned long	alignment;
+};
+
+struct vb2_drv {
+	bool (*get_power)(void *);
+	void *priv;
+};
+
+static inline unsigned long vb2_sdvmm_plane_dvaddr(struct vb2_buffer *vb, unsigned int plane_no)
+{
+	return (unsigned long)vb2_plane_cookie(vb, plane_no);
+}
+
+static inline unsigned long vb2_sdvmm_plane_kvaddr(struct vb2_buffer *vb, unsigned int plane_no)
+{
+	return (unsigned long)vb2_plane_vaddr(vb, plane_no);
+}
+
+void *vb2_sdvmm_init(struct vb2_vcm *vcm, struct vb2_cma *cma, struct vb2_drv *drv);
+void vb2_sdvmm_cleanup(void *alloc_ctx);
+
+void **vb2_sdvmm_init_multi(unsigned int num_planes, struct vb2_vcm *vcm, struct vb2_cma *cma[], struct vb2_drv *drv);
+void vb2_sdvmm_cleanup_multi(void **alloc_ctxes);
+
+void vb2_sdvmm_suspend(void *alloc_ctx);
+void vb2_sdvmm_resume(void *alloc_ctx);
+
+extern const struct vb2_mem_ops vb2_sdvmm_memops;
+
+#endif
-- 
1.7.1

