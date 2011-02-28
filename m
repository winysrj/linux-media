Return-path: <mchehab@pedra>
Received: from rcsinet10.oracle.com ([148.87.113.121]:27892 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421Ab1B1PYM (ORCPT
	<rfc822;<linux-media@vger.kernel.org>>);
	Mon, 28 Feb 2011 10:24:12 -0500
Date: Mon, 28 Feb 2011 09:53:01 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: mchehab@infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: [PATCH v2 -resend#1 1/1] V4L: videobuf, don't use dma addr as
 physical
Message-ID: <20110228145301.GC10846@dumpdata.com>
References: <1298885822-10083-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298885822-10083-1-git-send-email-jslaby@suse.cz>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Feb 28, 2011 at 10:37:02AM +0100, Jiri Slaby wrote:
> mem->dma_handle is a dma address obtained by dma_alloc_coherent which
> needn't be a physical address in presence of IOMMU. So ensure we are

Can you add a comment why you are fixing it? Is there a bug report for this?
Under what conditions did you expose this fault?

You also might want to mention that "needn't be a physical address as
a hardware IOMMU can (and most likely) will return a bus address where
physical != bus address."

Otherwise you can stick 'Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>'
on it.

> remapping (remap_pfn_range) the right page in __videobuf_mmap_mapper
> by using virt_to_phys(mem->vaddr) and not mem->dma_handle.
> 
> While at it, use PFN_DOWN instead of explicit shift.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/media/video/videobuf-dma-contig.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/videobuf-dma-contig.c b/drivers/media/video/videobuf-dma-contig.c
> index c969111..19d3e4a 100644
> --- a/drivers/media/video/videobuf-dma-contig.c
> +++ b/drivers/media/video/videobuf-dma-contig.c
> @@ -300,7 +300,7 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
>  
>  	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
>  	retval = remap_pfn_range(vma, vma->vm_start,
> -				 mem->dma_handle >> PAGE_SHIFT,
> +				 PFN_DOWN(virt_to_phys(mem->vaddr))
>  				 size, vma->vm_page_prot);
>  	if (retval) {
>  		dev_err(q->dev, "mmap: remap failed with error %d. ", retval);
> -- 
> 1.7.4.1
> 
