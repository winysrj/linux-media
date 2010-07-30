Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:59605 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775Ab0G3Jab (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jul 2010 05:30:31 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Figo.zhang" <figo1802@gmail.com>
Subject: Re: [PATCH v2]Resend:videobuf_dma_sg: a new implementation for mmap
Date: Fri, 30 Jul 2010 11:31:16 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	"max.song" <max.song@kolorific.com>,
	"linux-media" <linux-media@vger.kernel.org>
References: <1280448482.2648.2.camel@localhost.localdomain>
In-Reply-To: <1280448482.2648.2.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201007301131.17638.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Friday 30 July 2010 02:08:02 Figo.zhang wrote:
> a mmap issue for videobuf-dma-sg: it will alloc a new page for mmaping when
> it encounter page fault at video_vm_ops->fault(). pls see
> http://www.spinics.net/lists/linux-media/msg21243.html
> 
> a new implementation for mmap, it translate to vmalloc to page at
> video_vm_ops->fault().
> 
> in v2, if mem->dma.vmalloc is NULL at video_vm_ops->fault(), it will alloc
> memory by vmlloc_32().

You're replacing allocation in videobuf_vm_fault by allocationg in 
videobuf_vm_fault. I don't see the point. videobuf_vm_fault needs to go away 
completely.

This has been discussed previously: fixing videobuf is not really possible. A 
videobuf2 implementation is needed and is (slowly) being worked on. I wouldn't 
bother with this patch, just drop it.

> Signed-off-by: Figo.zhang <figo1802@gmail.com>
> ---
> drivers/media/video/videobuf-dma-sg.c |   50
> +++++++++++++++++++++++++++------ 1 files changed, 41 insertions(+), 9
> deletions(-)
> 
> diff --git a/drivers/media/video/videobuf-dma-sg.c
> b/drivers/media/video/videobuf-dma-sg.c index 8359e6b..f7295da 100644
> --- a/drivers/media/video/videobuf-dma-sg.c
> +++ b/drivers/media/video/videobuf-dma-sg.c
> @@ -201,10 +201,11 @@ int videobuf_dma_init_kernel(struct videobuf_dmabuf
> *dma, int direction, dprintk(1, "init kernel [%d pages]\n", nr_pages);
> 
>  	dma->direction = direction;
> -	dma->vmalloc = vmalloc_32(nr_pages << PAGE_SHIFT);
> -	if (NULL == dma->vmalloc) {
> -		dprintk(1, "vmalloc_32(%d pages) failed\n", nr_pages);
> -		return -ENOMEM;
> +	if (!dma->vmalloc)
> +		dma->vmalloc = vmalloc_32(nr_pages << PAGE_SHIFT);
> +		if (NULL == dma->vmalloc) {
> +			dprintk(1, "vmalloc_32(%d pages) failed\n", nr_pages);
> +			return -ENOMEM;
>  	}
> 
>  	dprintk(1, "vmalloc is at addr 0x%08lx, size=%d\n",
> @@ -397,16 +398,47 @@ static void videobuf_vm_close(struct vm_area_struct
> *vma) */
>  static int videobuf_vm_fault(struct vm_area_struct *vma, struct vm_fault
> *vmf) {
> -	struct page *page;
> +	struct page *page = NULL;
> +	struct videobuf_mapping *map = vma->vm_private_data;
> +	struct videobuf_queue *q = map->q;
> +	struct videobuf_dma_sg_memory *mem = NULL;
> +
> +	unsigned long offset;
> +	unsigned long page_nr;
> +	int first;
> 
>  	dprintk(3, "fault: fault @ %08lx [vma %08lx-%08lx]\n",
>  		(unsigned long)vmf->virtual_address,
>  		vma->vm_start, vma->vm_end);
> 
> -	page = alloc_page(GFP_USER | __GFP_DMA32);
> -	if (!page)
> -		return VM_FAULT_OOM;
> -	clear_user_highpage(page, (unsigned long)vmf->virtual_address);
> +	mutex_lock(&q->vb_lock);
> +	offset = (unsigned long)vmf->virtual_address - vma->vm_start;
> +	page_nr = offset >> PAGE_SHIFT;
> +
> +	for (first = 0; first < VIDEO_MAX_FRAME; first++) {
> +			if (NULL == q->bufs[first])
> +				continue;
> +
> +			MAGIC_CHECK(mem->magic, MAGIC_SG_MEM);
> +
> +			if (q->bufs[first]->map == map)
> +				break;
> +	}
> +
> +	mem = q->bufs[first]->priv;
> +	if (!mem)
> +		return VM_FAULT_SIGBUS;
> +	if (!mem->dma.vmalloc) {
> +		mem->dma.vmalloc = vmalloc_32(PAGE_ALIGN(q->bufs[first]->size));
> +		if (NULL == mem->dma.vmalloc) {
> +			dprintk(1, "%s: vmalloc_32() failed\n", __func__);
> +			return VM_FAULT_OOM;
> +		}
> +	} else
> +		page = vmalloc_to_page(mem->dma.vmalloc+
> +				(offset & (~PAGE_MASK)));
> +	mutex_unlock(&q->vb_lock);
> +
>  	vmf->page = page;
> 
>  	return 0;

-- 
Regards,

Laurent Pinchart
