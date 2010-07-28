Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:46305 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460Ab0G1JM3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jul 2010 05:12:29 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Figo.zhang" <figo1802@gmail.com>
Subject: Re: [PATCH]videobuf_dma_sg: a new implementation for mmap
Date: Wed, 28 Jul 2010 11:13:07 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	"linux-media" <linux-media@vger.kernel.org>
References: <1280233300.2628.8.camel@localhost.localdomain>
In-Reply-To: <1280233300.2628.8.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201007281113.08378.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Tuesday 27 July 2010 14:21:40 Figo.zhang wrote:
> a mmap issue for videobuf-dma-sg: it will alloc a new page for mmaping
> when it encounter page fault at video_vm_ops->fault().
> 
> a new implementation for mmap, it translate the vmalloc to page at
> video_vm_ops->fault().

How is that supposed to work ? mem->dma.vmalloc is NULL in the vm_fault 
handler for V4L2_MEMORY_MMAP buffers. Have you tested the code at all ?

> Signed-off-by: Figo.zhang <figo1802@gmail.com>
> ---
> drivers/media/video/videobuf-dma-sg.c |   38
> ++++++++++++++++++++++++++++----
>  1 files changed, 33 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/video/videobuf-dma-sg.c
> b/drivers/media/video/videobuf-dma-sg.c
> index 8359e6b..c9a8817 100644
> --- a/drivers/media/video/videobuf-dma-sg.c
> +++ b/drivers/media/video/videobuf-dma-sg.c
> @@ -397,16 +397,44 @@ static void videobuf_vm_close(struct
> vm_area_struct *vma)
>   */
>  static int videobuf_vm_fault(struct vm_area_struct *vma, struct
> vm_fault *vmf)
>  {
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
> +
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
> +	if (mem->dma.vmalloc)
> +		page = vmalloc_to_page(mem->dma.vmalloc+
> +				(offset & (~PAGE_MASK)));
> +	if (mem->dma.pages)
> +		page = mem->dma.pages[page_nr];
> +	mutex_unlock(&q->vb_lock);
> +
>  	vmf->page = page;
> 
>  	return 0;

-- 
Regards,

Laurent Pinchart
