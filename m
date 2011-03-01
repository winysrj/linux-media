Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60059 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755671Ab1CAIWb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Mar 2011 03:22:31 -0500
Message-ID: <4D6CACC2.7010307@gmail.com>
Date: Tue, 01 Mar 2011 09:22:26 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: mchehab@infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH v2 1/1] V4L: videobuf, don't use dma addr as physical
References: <1298967701-11889-1-git-send-email-jslaby@suse.cz>
In-Reply-To: <1298967701-11889-1-git-send-email-jslaby@suse.cz>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 03/01/2011 09:21 AM, Jiri Slaby wrote:
> mem->dma_handle is a dma address obtained by dma_alloc_coherent which
> needn't be a physical address as a hardware IOMMU can (and most
> likely will) return a bus address where physical != bus address. So
> ensure we are remapping (remap_pfn_range) the right page in
> __videobuf_mmap_mapper by using virt_to_phys(mem->vaddr) and not
> mem->dma_handle.
> 
> While at it, use PFN_DOWN instead of explicit shift to obtain a frame
> number.
> 
> This was discovered by a random review of the code when looking for
> something completely different. I'm not aware of any bug reports for
> this.
> 
> However it is a bug because many v4l drivers use this layer and have
> no idea whether IOMMU is in the system and running or not.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Ah, this is rather:
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

> ---
> 
> This is a version with updated changelog.
> 
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


-- 
js
