Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m649AZhA018609
	for <video4linux-list@redhat.com>; Fri, 4 Jul 2008 05:10:36 -0400
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m649A3hI018381
	for <video4linux-list@redhat.com>; Fri, 4 Jul 2008 05:10:03 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1KEhIp-0004j9-7C
	for video4linux-list@redhat.com; Fri, 04 Jul 2008 09:10:03 +0000
Received: from 82-135-208-232.static.zebra.lt ([82.135.208.232])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Fri, 04 Jul 2008 09:10:03 +0000
Received: from paulius.zaleckas by 82-135-208-232.static.zebra.lt with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Fri, 04 Jul 2008 09:10:03 +0000
To: video4linux-list@redhat.com
From: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Date: Fri, 04 Jul 2008 12:08:27 +0300
Message-ID: <486DE88B.2030709@teltonika.lt>
References: <20080701124638.30446.81449.sendpatchset@rx1.opensource.se>
	<20080701124735.30446.89320.sendpatchset@rx1.opensource.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <20080701124735.30446.89320.sendpatchset@rx1.opensource.se>
Cc: video4linux-list@redhat.com, linux-sh@vger.kernel.org
Subject: Re: [PATCH 06/07] videobuf: Add physically contiguous queue code
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Here goes my full review:

Magnus Damm wrote:
> This patch adds support for videobuf queues made from physically
> contiguous memory. Useful for hardware such as the SuperH Mobile CEU
> which doesn't support scatter gatter bus mastering.
> 
> Since it may be difficult to allocate large chunks of physically
> contiguous memory after some uptime due to fragmentation, this code
> allocates memory using dma_alloc_coherent(). Architectures supporting
> dma_declare_coherent_memory() can easily avoid fragmentation issues
> by using dma_declare_coherent_memory() to force dma_alloc_coherent()
> to allocate from a certain pre-allocated memory area.
> 
> Signed-off-by: Magnus Damm <damm@igel.co.jp>
> ---
> 
>  drivers/media/video/Kconfig               |    4 
>  drivers/media/video/Makefile              |    1 
>  drivers/media/video/videobuf-dma-contig.c |  413 +++++++++++++++++++++++++++++
>  include/media/videobuf-dma-contig.h       |   39 ++
>  4 files changed, 457 insertions(+)
> 
> --- 0006/drivers/media/video/Kconfig
> +++ work/drivers/media/video/Kconfig	2008-06-30 15:30:35.000000000 +0900
> @@ -24,6 +24,10 @@ config VIDEOBUF_VMALLOC
>  	select VIDEOBUF_GEN
>  	tristate
>  
> +config VIDEOBUF_DMA_CONTIG
> +	select VIDEOBUF_GEN
> +	tristate
> +

Maybe "depends on HAS_DMA" is needed here?

>  config VIDEOBUF_DVB
>  	tristate
>  	select VIDEOBUF_GEN
> --- 0001/drivers/media/video/Makefile
> +++ work/drivers/media/video/Makefile	2008-06-30 15:30:35.000000000 +0900
> @@ -88,6 +88,7 @@ obj-$(CONFIG_VIDEO_TUNER) += tuner.o
>  
>  obj-$(CONFIG_VIDEOBUF_GEN) += videobuf-core.o
>  obj-$(CONFIG_VIDEOBUF_DMA_SG) += videobuf-dma-sg.o
> +obj-$(CONFIG_VIDEOBUF_DMA_CONTIG) += videobuf-dma-contig.o
>  obj-$(CONFIG_VIDEOBUF_VMALLOC) += videobuf-vmalloc.o
>  obj-$(CONFIG_VIDEOBUF_DVB) += videobuf-dvb.o
>  obj-$(CONFIG_VIDEO_BTCX)  += btcx-risc.o
> --- /dev/null
> +++ work/drivers/media/video/videobuf-dma-contig.c	2008-06-30 15:36:13.000000000 +0900
> @@ -0,0 +1,413 @@
> +/*
> + * helper functions for physically contiguous capture buffers
> + *
> + * The functions support hardware lacking scatter gatter support
> + * (i.e. the buffers must be linear in physical memory)
> + *
> + * Copyright (c) 2008 Magnus Damm
> + *
> + * Based on videobuf-vmalloc.c,
> + * (c) 2007 Mauro Carvalho Chehab, <mchehab@infradead.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2
> + */
> +
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/dma-mapping.h>
> +#include <media/videobuf-dma-contig.h>
> +
> +#define MAGIC_DC_MEM 0x0733ac61
> +#define MAGIC_CHECK(is, should)						\
> +	if (unlikely((is) != (should)))	{				\
> +		pr_err("magic mismatch: %x expected %x\n", is, should); \
> +		BUG();							\
> +	}
> +
> +static void
> +videobuf_vm_open(struct vm_area_struct *vma)
> +{
> +	struct videobuf_mapping *map = vma->vm_private_data;
> +
> +	dev_dbg(map->q->dev, "vm_open %p [count=%u,vma=%08lx-%08lx]\n",
> +		map, map->count, vma->vm_start, vma->vm_end);
> +
> +	map->count++;
> +}
> +
> +static void videobuf_vm_close(struct vm_area_struct *vma)
> +{
> +	struct videobuf_mapping *map = vma->vm_private_data;
> +	struct videobuf_queue *q = map->q;
> +	int i, datasize;
> +
> +	dev_dbg(map->q->dev, "vm_close %p [count=%u,vma=%08lx-%08lx]\n",
> +		map, map->count, vma->vm_start, vma->vm_end);
> +
> +	map->count--;
> +	if (0 == map->count) {
> +		struct videobuf_dma_contig_memory *mem;
> +
> +		dev_dbg(map->q->dev, "munmap %p q=%p\n", map, q);
> +		mutex_lock(&q->vb_lock);
> +
> +		/* We need first to cancel streams, before unmapping */
> +		if (q->streaming)
> +			videobuf_queue_cancel(q);
> +
> +		for (i = 0; i < VIDEO_MAX_FRAME; i++) {
> +			if (NULL == q->bufs[i])

			if (!q->bufs[i])

> +				continue;
> +
> +			if (q->bufs[i]->map != map)
> +				continue;
> +
> +			mem = q->bufs[i]->priv;
> +			if (mem) {
> +				/* This callback is called only if kernel has
> +				   allocated memory and this memory is mmapped.
> +				   In this case, memory should be freed,
> +				   in order to do memory unmap.
> +				 */
> +
> +				MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
> +
> +				/* vfree is not atomic - can't be
> +				   called with IRQ's disabled
> +				 */
> +				dev_dbg(map->q->dev, "buf[%d] freeing %p\n",
> +					i, mem->vaddr);
> +
> +				datasize = PAGE_ALIGN(q->bufs[i]->size);
> +				dma_free_coherent(q->dev, datasize,
> +						  mem->vaddr, mem->dma_handle);
> +				mem->vaddr = NULL;
> +			}
> +
> +			q->bufs[i]->map   = NULL;
> +			q->bufs[i]->baddr = 0;
> +		}
> +
> +		kfree(map);
> +
> +		mutex_unlock(&q->vb_lock);
> +	}
> +
> +	return;

return not needed here.

> +}
> +
> +static struct vm_operations_struct videobuf_vm_ops = {
> +	.open     = videobuf_vm_open,
> +	.close    = videobuf_vm_close,
> +};
> +
> +static void *__videobuf_alloc(size_t size)
> +{
> +	struct videobuf_dma_contig_memory *mem;
> +	struct videobuf_buffer *vb;
> +
> +	vb = kzalloc(size + sizeof(*mem), GFP_KERNEL);
> +	if (vb) {
> +		mem = vb->priv = ((char *)vb)+size;

		mem = vb->priv = ((char *)vb) + size;

> +		mem->magic = MAGIC_DC_MEM;
> +	}
> +
> +	return vb;
> +}
> +
> +static void *__videobuf_to_vmalloc(struct videobuf_buffer *buf)
> +{
> +	struct videobuf_dma_contig_memory *mem = buf->priv;
> +
> +	BUG_ON(!mem);
> +	MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
> +
> +	return mem->vaddr;
> +}
> +
> +static int __videobuf_iolock(struct videobuf_queue *q,
> +			     struct videobuf_buffer *vb,
> +			     struct v4l2_framebuffer *fbuf)
> +{
> +	struct videobuf_dma_contig_memory *mem = vb->priv;
> +	int datasize;
> +
> +	BUG_ON(!mem);
> +	MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
> +
> +	switch (vb->memory) {
> +	case V4L2_MEMORY_MMAP:
> +		dev_dbg(q->dev, "%s memory method MMAP\n", __func__);
> +
> +		/* All handling should be done by __videobuf_mmap_mapper() */
> +		if (!mem->vaddr) {
> +			pr_err("memory is not alloced/mmapped.\n");

			why not dev_err?

> +			return -EINVAL;
> +		}
> +		break;
> +	case V4L2_MEMORY_USERPTR:
> +		dev_dbg(q->dev, "%s memory method USERPTR\n", __func__);
> +
> +		/* The only USERPTR currently supported is the one needed for
> +		   read() method.
> +		 */
> +		if (vb->baddr)
> +			return -EINVAL;
> +
> +		datasize = PAGE_ALIGN(vb->size);
> +		mem->vaddr = dma_alloc_coherent(q->dev, datasize,
> +						&mem->dma_handle, GFP_KERNEL);
> +		if (!mem->vaddr) {
> +			pr_err("dma_alloc_coherent %d failed\n", datasize);

			dev_err

> +			return -ENOMEM;
> +		}
> +
> +		dev_dbg(q->dev, "dma_alloc_coherent data is at %p (%d)\n",
> +			mem->vaddr, datasize);
> +		break;
> +	case V4L2_MEMORY_OVERLAY:
> +	default:
> +		dev_dbg(q->dev, "%s memory method OVERLAY/unknown\n",
> +			__func__);
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int __videobuf_sync(struct videobuf_queue *q,
> +			   struct videobuf_buffer *buf)
> +{

Maybe dma_sync_single_for_cpu should be called here?

> +	return 0;
> +}
> +
> +static int __videobuf_mmap_free(struct videobuf_queue *q)
> +{
> +	unsigned int i;
> +
> +	dev_dbg(q->dev, "%s\n", __func__);
> +	for (i = 0; i < VIDEO_MAX_FRAME; i++) {
> +		if (q->bufs[i]) {
> +			if (q->bufs[i]->map)

		if (q->bufs[i] && q->bufs[i]->map)

> +				return -EBUSY;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int __videobuf_mmap_mapper(struct videobuf_queue *q,
> +				  struct vm_area_struct *vma)
> +{
> +	struct videobuf_dma_contig_memory *mem;
> +	struct videobuf_mapping *map;
> +	unsigned int first;
> +	int retval, datasize;
> +	unsigned long size, offset = vma->vm_pgoff << PAGE_SHIFT;
> +
> +	dev_dbg(q->dev, "%s\n", __func__);
> +	if (!(vma->vm_flags & VM_WRITE) || !(vma->vm_flags & VM_SHARED))
> +		return -EINVAL;
> +
> +	/* look for first buffer to map */
> +	for (first = 0; first < VIDEO_MAX_FRAME; first++) {
> +		if (NULL == q->bufs[first])

		if (!q->bufs[first])

> +			continue;
> +
> +		if (V4L2_MEMORY_MMAP != q->bufs[first]->memory)
> +			continue;
> +		if (q->bufs[first]->boff == offset)
> +			break;
> +	}
> +	if (VIDEO_MAX_FRAME == first) {
> +		dev_dbg(q->dev, "invalid user space offset [offset=0x%lx]\n",
> +			(vma->vm_pgoff << PAGE_SHIFT));

			offset = vma->vm_pgoff << PAGE_SHIFT;
			Use offset, don't recalculate this value again.

> +		return -EINVAL;
> +	}
> +
> +	/* create mapping + update buffer list */
> +	map = kzalloc(sizeof(struct videobuf_mapping), GFP_KERNEL);
> +	if (NULL == map)

	if (!map)

> +		return -ENOMEM;
> +
> +	q->bufs[first]->map = map;
> +	map->start = vma->vm_start;
> +	map->end = vma->vm_end;
> +	map->q = q;
> +
> +	q->bufs[first]->baddr = vma->vm_start;
> +
> +	mem = q->bufs[first]->priv;
> +	BUG_ON(!mem);
> +	MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
> +
> +	datasize = PAGE_ALIGN(q->bufs[first]->bsize);
> +	mem->vaddr = dma_alloc_coherent(q->dev, datasize,
> +					&mem->dma_handle, GFP_KERNEL);
> +	if (!mem->vaddr) {
> +		pr_err("dma_alloc_coherent size %d failed\n", datasize);

		dev_err?

> +		goto error;
> +	}
> +	dev_dbg(q->dev, "dma_alloc_coherent data is at addr %p (size %d)\n",
> +		mem->vaddr, datasize);
> +
> +	/* Try to remap memory */
> +
> +	size = vma->vm_end - vma->vm_start;
> +	size = (size < datasize) ? size : datasize;
> +
> +	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> +	retval = remap_pfn_range(vma, vma->vm_start,
> +				 __pa(mem->vaddr) >> PAGE_SHIFT,
> +				 size, vma->vm_page_prot);
> +	if (retval < 0) {

	if (retval)
	because remap_pfn_range returns 0 on success else it is error.

> +		pr_err("mmap: remap failed with error %d. ", retval);

		dev_err ?

> +		dma_free_coherent(q->dev, datasize,
> +				  mem->vaddr, mem->dma_handle);
> +		goto error;
> +	}
> +
> +	vma->vm_ops          = &videobuf_vm_ops;
> +	vma->vm_flags       |= VM_DONTEXPAND;
> +	vma->vm_private_data = map;
> +
> +	dev_dbg(q->dev, "mmap %p: q=%p %08lx-%08lx (%lx) pgoff %08lx buf %d\n",
> +		map, q, vma->vm_start, vma->vm_end,
> +		(long int) q->bufs[first]->bsize,
> +		vma->vm_pgoff, first);
> +
> +	videobuf_vm_open(vma);
> +
> +	return 0;
> +
> +error:
> +	kfree(map);
> +	return -ENOMEM;
> +}
> +
> +static int __videobuf_copy_to_user(struct videobuf_queue *q,
> +				   char __user *data, size_t count,
> +				   int nonblocking)
> +{
> +	struct videobuf_dma_contig_memory *mem = q->read_buf->priv;
> +	void *vaddr;
> +
> +	BUG_ON(!mem);
> +	MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
> +	BUG_ON(!mem->vaddr);
> +
> +	/* copy to userspace */
> +	if (count > q->read_buf->size - q->read_off)
> +		count = q->read_buf->size - q->read_off;
> +
> +	vaddr = mem->vaddr;
> +
> +	if (copy_to_user(data, vaddr + q->read_off, count))
> +		return -EFAULT;
> +
> +	return count;
> +}
> +
> +static int __videobuf_copy_stream(struct videobuf_queue *q,
> +				  char __user *data, size_t count, size_t pos,
> +				  int vbihack, int nonblocking)
> +{
> +	unsigned int  *fc;
> +	struct videobuf_dma_contig_memory *mem = q->read_buf->priv;
> +
> +	BUG_ON(!mem);
> +	MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
> +
> +	if (vbihack) {
> +		/* dirty, undocumented hack -- pass the frame counter
> +			* within the last four bytes of each vbi data block.
> +			* We need that one to maintain backward compatibility
> +			* to all vbi decoding software out there ... */
> +		fc = (unsigned int *)mem->vaddr;
> +		fc += (q->read_buf->size >> 2) - 1;
> +		*fc = q->read_buf->field_count >> 1;
> +		dev_dbg(q->dev, "vbihack: %d\n", *fc);
> +	}
> +
> +	/* copy stuff using the common method */
> +	count = __videobuf_copy_to_user(q, data, count, nonblocking);
> +
> +	if ((count == -EFAULT) && (pos == 0))

	if ((count == -EFAULT) && (!pos))

> +		return -EFAULT;
> +
> +	return count;
> +}
> +
> +static struct videobuf_qtype_ops qops = {
> +	.magic        = MAGIC_QTYPE_OPS,
> +
> +	.alloc        = __videobuf_alloc,
> +	.iolock       = __videobuf_iolock,
> +	.sync         = __videobuf_sync,
> +	.mmap_free    = __videobuf_mmap_free,
> +	.mmap_mapper  = __videobuf_mmap_mapper,
> +	.video_copy_to_user = __videobuf_copy_to_user,
> +	.copy_stream  = __videobuf_copy_stream,
> +	.vmalloc      = __videobuf_to_vmalloc,
> +};
> +
> +void videobuf_queue_dma_contig_init(struct videobuf_queue *q,
> +				    struct videobuf_queue_ops *ops,
> +				    struct device *dev,
> +				    spinlock_t *irqlock,
> +				    enum v4l2_buf_type type,
> +				    enum v4l2_field field,
> +				    unsigned int msize,
> +				    void *priv)
> +{
> +	videobuf_queue_core_init(q, ops, dev, irqlock, type, field, msize,
> +				 priv, &qops);
> +}
> +EXPORT_SYMBOL_GPL(videobuf_queue_dma_contig_init);
> +
> +struct videobuf_dma_contig_memory *
> +videobuf_to_dma_contig(struct videobuf_buffer *buf)
> +{
> +	struct videobuf_dma_contig_memory *mem = buf->priv;
> +
> +	BUG_ON(!mem);
> +	MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
> +
> +	return mem;

I think it is enough to return mem->dma_handle
You will have to change function type also...

> +}
> +EXPORT_SYMBOL_GPL(videobuf_to_dma_contig);
> +
> +void videobuf_dma_contig_free(struct videobuf_queue *q,
> +			      struct videobuf_buffer *buf)
> +{
> +	struct videobuf_dma_contig_memory *mem = buf->priv;
> +	int datasize;
> +
> +	/* mmapped memory can't be freed here, otherwise mmapped region
> +	   would be released, while still needed. In this case, the memory
> +	   release should happen inside videobuf_vm_close().
> +	   So, it should free memory only if the memory were allocated for
> +	   read() operation.
> +	 */
> +	if ((buf->memory != V4L2_MEMORY_USERPTR) || (buf->baddr == 0))

	if ((buf->memory != V4L2_MEMORY_USERPTR) || (!buf->baddr))

> +		return;
> +
> +	if (!mem)
> +		return;
> +
> +	MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
> +
> +	datasize = PAGE_ALIGN(buf->size);
> +	dma_free_coherent(q->dev, datasize, mem->vaddr, mem->dma_handle);
> +	mem->vaddr = NULL;

Maybe you should mem->dma_handle = NULL also?
I don't have strong opinion about this...

> +
> +	return;

return not needed here.

> +}
> +EXPORT_SYMBOL_GPL(videobuf_dma_contig_free);
> +
> +MODULE_DESCRIPTION("helper module to manage video4linux dma contig buffers");
> +MODULE_AUTHOR("Magnus Damm");
> +MODULE_LICENSE("GPL");
> +

blank line not needed here

> --- /dev/null
> +++ work/include/media/videobuf-dma-contig.h	2008-06-30 15:30:35.000000000 +0900
> @@ -0,0 +1,39 @@
> +/*
> + * helper functions for physically contiguous capture buffers
> + *
> + * The functions support hardware lacking scatter gatter support
> + * (i.e. the buffers must be linear in physical memory)
> + *
> + * Copyright (c) 2008 Magnus Damm
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2
> + */
> +#ifndef _VIDEOBUF_DMA_CONTIG_H
> +#define _VIDEOBUF_DMA_CONTIG_H
> +
> +#include <linux/dma-mapping.h>

I think this include is not needed here...

> +#include <media/videobuf-core.h>
> +
> +struct videobuf_dma_contig_memory {
> +	u32 magic;
> +	void *vaddr;
> +	dma_addr_t dma_handle;
> +};
> +
> +void videobuf_queue_dma_contig_init(struct videobuf_queue *q,
> +				    struct videobuf_queue_ops *ops,
> +				    struct device *dev,
> +				    spinlock_t *irqlock,
> +				    enum v4l2_buf_type type,
> +				    enum v4l2_field field,
> +				    unsigned int msize,
> +				    void *priv);
> +
> +struct videobuf_dma_contig_memory *
> +videobuf_to_dma_contig(struct videobuf_buffer *buf);
> +void videobuf_dma_contig_free(struct videobuf_queue *q,
> +			      struct videobuf_buffer *buf);
> +
> +#endif /* _VIDEOBUF_DMA_CONTIG_H */

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
