Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m68EZJud003726
	for <video4linux-list@redhat.com>; Tue, 8 Jul 2008 10:35:20 -0400
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m68EZ7bf000577
	for <video4linux-list@redhat.com>; Tue, 8 Jul 2008 10:35:08 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1KGEHW-0002NM-VW
	for video4linux-list@redhat.com; Tue, 08 Jul 2008 14:35:02 +0000
Received: from 82-135-208-232.static.zebra.lt ([82.135.208.232])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Tue, 08 Jul 2008 14:35:02 +0000
Received: from paulius.zaleckas by 82-135-208-232.static.zebra.lt with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Tue, 08 Jul 2008 14:35:02 +0000
To: video4linux-list@redhat.com
From: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Date: Tue, 08 Jul 2008 17:33:07 +0300
Message-ID: <48737AA3.3080902@teltonika.lt>
References: <20080705025335.27137.98068.sendpatchset@rx1.opensource.se>
	<20080705025405.27137.16206.sendpatchset@rx1.opensource.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <20080705025405.27137.16206.sendpatchset@rx1.opensource.se>
Cc: video4linux-list@redhat.com, linux-sh@vger.kernel.org
Subject: Re: [PATCH 03/04] videobuf: Add physically contiguous queue code V2
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

Magnus Damm wrote:
> This is V2 of the physically contiguous videobuf queues patch.
> Useful for hardware such as the SuperH Mobile CEU which doesn't
> support scatter gatter bus mastering.

spelling gatther :)

> +static int __videobuf_mmap_mapper(struct videobuf_queue *q,
> +				  struct vm_area_struct *vma)
> +{
> +	struct videobuf_dma_contig_memory *mem;
> +	struct videobuf_mapping *map;
> +	unsigned int first;
> +	int retval;
> +	unsigned long size, offset = vma->vm_pgoff << PAGE_SHIFT;
> +
> +	dev_dbg(q->dev, "%s\n", __func__);
> +	if (!(vma->vm_flags & VM_WRITE) || !(vma->vm_flags & VM_SHARED))
> +		return -EINVAL;
> +
> +	/* look for first buffer to map */
> +	for (first = 0; first < VIDEO_MAX_FRAME; first++) {
> +		if (!q->bufs[first])
> +			continue;
> +
> +		if (V4L2_MEMORY_MMAP != q->bufs[first]->memory)
> +			continue;
> +		if (q->bufs[first]->boff == offset)
> +			break;
> +	}
> +	if (VIDEO_MAX_FRAME == first) {
> +		dev_dbg(q->dev, "invalid user space offset [offset=0x%lx]\n",
> +			offset);
> +		return -EINVAL;
> +	}
> +
> +	/* create mapping + update buffer list */
> +	map = kzalloc(sizeof(struct videobuf_mapping), GFP_KERNEL);
> +	if (!map)
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
> +	mem->size = PAGE_ALIGN(q->bufs[first]->bsize);
> +	mem->vaddr = dma_alloc_coherent(q->dev, mem->size,
> +					&mem->dma_handle, GFP_KERNEL);
> +	if (!mem->vaddr) {
> +		dev_err(q->dev, "dma_alloc_coherent size %ld failed\n",
> +			mem->size);
> +		goto error;
> +	}
> +	dev_dbg(q->dev, "dma_alloc_coherent data is at addr %p (size %ld)\n",
> +		mem->vaddr, mem->size);
> +
> +	/* Try to remap memory */
> +
> +	size = vma->vm_end - vma->vm_start;
> +	size = (size < mem->size) ? size : mem->size;
> +
> +	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> +	retval = remap_pfn_range(vma, vma->vm_start,
> +				 __pa(mem->vaddr) >> PAGE_SHIFT,

__pa(mem->vaddr) doesn't work on ARM architecture... It is a long story
about handling memory allocations and mapping for ARM (there is
dma_mmap_coherent to deal with this), but there is a workaround:

mem->dma_handle >> PAGE_SHIFT,

It is safe to do it this way and also saves some CPU instructions :)

> +				 size, vma->vm_page_prot);
> +	if (retval) {
> +		dev_err(q->dev, "mmap: remap failed with error %d. ", retval);
> +		dma_free_coherent(q->dev, mem->size,
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

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
