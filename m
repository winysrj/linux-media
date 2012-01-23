Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:63229 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669Ab2AWNvj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jan 2012 08:51:39 -0500
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LY900ALN7U0WI@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 23 Jan 2012 13:51:36 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LY900H9S7TZ7F@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 23 Jan 2012 13:51:36 +0000 (GMT)
Date: Mon, 23 Jan 2012 14:51:12 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 07/10] v4l: vb2: remove dma-contig allocator
In-reply-to: <1327326675-8431-1-git-send-email-t.stanislaws@samsung.com>
To: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org
Cc: sumit.semwal@ti.com, jesse.barker@linaro.org, rob@ti.com,
	daniel@ffwll.ch, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	pawel@osciak.com
Message-id: <1327326675-8431-8-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1327326675-8431-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is temporary patch. The dma-contig changes were significant
and the difference patch would be very difficult to read.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/videobuf2-dma-contig.c |  308 ----------------------------
 1 files changed, 0 insertions(+), 308 deletions(-)
 delete mode 100644 drivers/media/video/videobuf2-dma-contig.c

diff --git a/drivers/media/video/videobuf2-dma-contig.c b/drivers/media/video/videobuf2-dma-contig.c
deleted file mode 100644
index ea2699f..0000000
--- a/drivers/media/video/videobuf2-dma-contig.c
+++ /dev/null
@@ -1,308 +0,0 @@
-/*
- * videobuf2-dma-contig.c - DMA contig memory allocator for videobuf2
- *
- * Copyright (C) 2010 Samsung Electronics
- *
- * Author: Pawel Osciak <pawel@osciak.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation.
- */
-
-#include <linux/module.h>
-#include <linux/slab.h>
-#include <linux/dma-mapping.h>
-#include <linux/scatterlist.h>
-#include <linux/dma-buf.h>
-
-#include <media/videobuf2-core.h>
-#include <media/videobuf2-memops.h>
-
-struct vb2_dc_conf {
-	struct device		*dev;
-};
-
-struct vb2_dc_buf {
-	struct vb2_dc_conf		*conf;
-	void				*vaddr;
-	dma_addr_t			dma_addr;
-	unsigned long			size;
-	struct vm_area_struct		*vma;
-	struct dma_buf_attachment	*db_attach;
-	atomic_t			refcount;
-	struct vb2_vmarea_handler	handler;
-};
-
-static void vb2_dma_contig_put(void *buf_priv);
-
-static void *vb2_dma_contig_alloc(void *alloc_ctx, unsigned long size)
-{
-	struct vb2_dc_conf *conf = alloc_ctx;
-	struct vb2_dc_buf *buf;
-	/* TODO: add db_attach processing while adding DMABUF as exporter */
-
-	buf = kzalloc(sizeof *buf, GFP_KERNEL);
-	if (!buf)
-		return ERR_PTR(-ENOMEM);
-
-	buf->vaddr = dma_alloc_coherent(conf->dev, size, &buf->dma_addr,
-					GFP_KERNEL);
-	if (!buf->vaddr) {
-		dev_err(conf->dev, "dma_alloc_coherent of size %ld failed\n",
-			size);
-		kfree(buf);
-		return ERR_PTR(-ENOMEM);
-	}
-
-	buf->conf = conf;
-	buf->size = size;
-
-	buf->handler.refcount = &buf->refcount;
-	buf->handler.put = vb2_dma_contig_put;
-	buf->handler.arg = buf;
-
-	atomic_inc(&buf->refcount);
-
-	return buf;
-}
-
-static void vb2_dma_contig_put(void *buf_priv)
-{
-	struct vb2_dc_buf *buf = buf_priv;
-
-	if (atomic_dec_and_test(&buf->refcount)) {
-		dma_free_coherent(buf->conf->dev, buf->size, buf->vaddr,
-				  buf->dma_addr);
-		kfree(buf);
-	}
-}
-
-static void *vb2_dma_contig_cookie(void *buf_priv)
-{
-	struct vb2_dc_buf *buf = buf_priv;
-
-	return &buf->dma_addr;
-}
-
-static void *vb2_dma_contig_vaddr(void *buf_priv)
-{
-	struct vb2_dc_buf *buf = buf_priv;
-	if (!buf)
-		return 0;
-
-	return buf->vaddr;
-}
-
-static unsigned int vb2_dma_contig_num_users(void *buf_priv)
-{
-	struct vb2_dc_buf *buf = buf_priv;
-
-	return atomic_read(&buf->refcount);
-}
-
-static int vb2_dma_contig_mmap(void *buf_priv, struct vm_area_struct *vma)
-{
-	struct vb2_dc_buf *buf = buf_priv;
-
-	if (!buf) {
-		printk(KERN_ERR "No buffer to map\n");
-		return -EINVAL;
-	}
-
-	return vb2_mmap_pfn_range(vma, buf->dma_addr, buf->size,
-				  &vb2_common_vm_ops, &buf->handler);
-}
-
-static void *vb2_dma_contig_get_userptr(void *alloc_ctx, unsigned long vaddr,
-					unsigned long size, int write)
-{
-	struct vb2_dc_buf *buf;
-	struct vm_area_struct *vma;
-	dma_addr_t dma_addr = 0;
-	int ret;
-
-	buf = kzalloc(sizeof *buf, GFP_KERNEL);
-	if (!buf)
-		return ERR_PTR(-ENOMEM);
-
-	ret = vb2_get_contig_userptr(vaddr, size, &vma, &dma_addr);
-	if (ret) {
-		printk(KERN_ERR "Failed acquiring VMA for vaddr 0x%08lx\n",
-				vaddr);
-		kfree(buf);
-		return ERR_PTR(ret);
-	}
-
-	buf->size = size;
-	buf->dma_addr = dma_addr;
-	buf->vma = vma;
-
-	return buf;
-}
-
-static void vb2_dma_contig_put_userptr(void *mem_priv)
-{
-	struct vb2_dc_buf *buf = mem_priv;
-
-	if (!buf)
-		return;
-
-	vb2_put_vma(buf->vma);
-	kfree(buf);
-}
-
-static int vb2_dma_contig_map_dmabuf(void *mem_priv,
-					enum dma_data_direction direction)
-{
-	struct vb2_dc_buf *buf = mem_priv;
-	struct dma_buf *dmabuf;
-	struct sg_table *sg;
-
-	if (!buf || !buf->db_attach) {
-		printk(KERN_ERR "No dma buffer to pin\n");
-		return -EINVAL;
-	}
-
-	WARN_ON(buf->dma_addr);
-
-	if (direction == DMA_NONE) {
-		printk(KERN_ERR "Incorrect DMA direction\n");
-		return -EINVAL;
-	}
-
-	dmabuf = buf->db_attach->dmabuf;
-
-	/* get the associated scatterlist for this buffer */
-	sg = dma_buf_map_attachment(buf->db_attach, direction);
-
-	if (!sg) {
-		printk(KERN_ERR "Error getting dmabuf scatterlist\n");
-		return -EINVAL;
-	}
-
-	/*
-	 *  convert sglist to paddr:
-	 *  Assumption: for dma-contig, dmabuf would map to single entry
-	 *  Will return an error if it has more than one.
-	 */
-	if (sg->nents > 1) {
-		printk(KERN_ERR
-			"dmabuf scatterlist has more than 1 entry\n");
-		return -EINVAL;
-	}
-
-	buf->dma_addr = sg_dma_address(sg->sgl);
-	/* TODO: check the buffer size as per S_FMT */
-	buf->size = sg_dma_len(sg->sgl);
-
-	/* save this scatterlist in dmabuf for put_scatterlist */
-	dmabuf->priv = sg;
-
-	return 0;
-}
-
-static void vb2_dma_contig_unmap_dmabuf(void *mem_priv)
-{
-	struct vb2_dc_buf *buf = mem_priv;
-	struct dma_buf *dmabuf;
-	struct sg_table *sg;
-
-	if (!buf || !buf->db_attach)
-		return;
-
-	WARN_ON(!buf->dma_addr);
-
-	dmabuf = buf->db_attach->dmabuf;
-	sg = dmabuf->priv;
-
-	/* Put the sg for this buffer */
-	dma_buf_unmap_attachment(buf->db_attach, sg);
-
-	buf->dma_addr = 0;
-	buf->size = 0;
-}
-
-static void *vb2_dma_contig_attach_dmabuf(void *alloc_ctx, struct dma_buf *dbuf)
-{
-	struct vb2_dc_conf *conf = alloc_ctx;
-	struct vb2_dc_buf *buf;
-	struct dma_buf_attachment *dba;
-
-	buf = kzalloc(sizeof *buf, GFP_KERNEL);
-	if (!buf)
-		return ERR_PTR(-ENOMEM);
-
-	/* create attachment for the dmabuf with the user device */
-	dba = dma_buf_attach(dbuf, conf->dev);
-	if (IS_ERR(dba)) {
-		printk(KERN_ERR "failed to attach dmabuf\n");
-		kfree(buf);
-		return dba;
-	}
-
-	buf->conf = conf;
-	buf->size = dba->dmabuf->size;
-	buf->db_attach = dba;
-	buf->dma_addr = 0; /* dma_addr is available only after map */
-
-	return buf;
-}
-
-static void vb2_dma_contig_detach_dmabuf(void *mem_priv)
-{
-	struct vb2_dc_buf *buf = mem_priv;
-
-	if (!buf)
-		return;
-
-	if (buf->dma_addr) {
-		vb2_dma_contig_unmap_dmabuf(buf);
-	}
-
-	/* detach this attachment */
-	dma_buf_detach(buf->db_attach->dmabuf, buf->db_attach);
-	buf->db_attach = NULL;
-
-	kfree(buf);
-}
-
-const struct vb2_mem_ops vb2_dma_contig_memops = {
-	.alloc		= vb2_dma_contig_alloc,
-	.put		= vb2_dma_contig_put,
-	.cookie		= vb2_dma_contig_cookie,
-	.vaddr		= vb2_dma_contig_vaddr,
-	.mmap		= vb2_dma_contig_mmap,
-	.get_userptr	= vb2_dma_contig_get_userptr,
-	.put_userptr	= vb2_dma_contig_put_userptr,
-	.map_dmabuf	= vb2_dma_contig_map_dmabuf,
-	.unmap_dmabuf	= vb2_dma_contig_unmap_dmabuf,
-	.attach_dmabuf	= vb2_dma_contig_attach_dmabuf,
-	.detach_dmabuf	= vb2_dma_contig_detach_dmabuf,
-	.num_users	= vb2_dma_contig_num_users,
-};
-EXPORT_SYMBOL_GPL(vb2_dma_contig_memops);
-
-void *vb2_dma_contig_init_ctx(struct device *dev)
-{
-	struct vb2_dc_conf *conf;
-
-	conf = kzalloc(sizeof *conf, GFP_KERNEL);
-	if (!conf)
-		return ERR_PTR(-ENOMEM);
-
-	conf->dev = dev;
-
-	return conf;
-}
-EXPORT_SYMBOL_GPL(vb2_dma_contig_init_ctx);
-
-void vb2_dma_contig_cleanup_ctx(void *alloc_ctx)
-{
-	kfree(alloc_ctx);
-}
-EXPORT_SYMBOL_GPL(vb2_dma_contig_cleanup_ctx);
-
-MODULE_DESCRIPTION("DMA-contig memory handling routines for videobuf2");
-MODULE_AUTHOR("Pawel Osciak <pawel@osciak.com>");
-MODULE_LICENSE("GPL");
-- 
1.7.5.4

