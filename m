Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49194 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756127Ab2ADQBW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jan 2012 11:01:22 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Javier Martin <javier.martin@vista-silicon.com>
Subject: Re: [PATCH 1/2 v3] media: vb2: support userptr for PFN mappings.
Date: Wed, 4 Jan 2012 17:01:36 +0100
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	pawel@osciak.com, kyungmin.park@samsung.com
References: <1325692011-7041-1-git-send-email-javier.martin@vista-silicon.com>
In-Reply-To: <1325692011-7041-1-git-send-email-javier.martin@vista-silicon.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201201041701.37743.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

Thanks for the patch.

On Wednesday 04 January 2012 16:46:51 Javier Martin wrote:
> Some video devices need to use contiguous memory
> which is not backed by pages as it happens with
> vmalloc. This patch provides userptr handling for
> those devices.
> 
> ---
> Changes since v2:
>  - Do not grab mm->mmap_sem.
> 
> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
> ---
>  drivers/media/video/videobuf2-vmalloc.c |   71
> +++++++++++++++++++++---------- 1 files changed, 48 insertions(+), 23
> deletions(-)
> 
> diff --git a/drivers/media/video/videobuf2-vmalloc.c
> b/drivers/media/video/videobuf2-vmalloc.c index 03aa62f..e621db6 100644
> --- a/drivers/media/video/videobuf2-vmalloc.c
> +++ b/drivers/media/video/videobuf2-vmalloc.c
> @@ -10,6 +10,7 @@
>   * the Free Software Foundation.
>   */
> 
> +#include <linux/io.h>
>  #include <linux/module.h>
>  #include <linux/mm.h>
>  #include <linux/sched.h>
> @@ -22,6 +23,7 @@
>  struct vb2_vmalloc_buf {
>  	void				*vaddr;
>  	struct page			**pages;
> +	struct vm_area_struct		*vma;
>  	int				write;
>  	unsigned long			size;
>  	unsigned int			n_pages;
> @@ -71,6 +73,9 @@ static void *vb2_vmalloc_get_userptr(void *alloc_ctx,
> unsigned long vaddr, struct vb2_vmalloc_buf *buf;
>  	unsigned long first, last;
>  	int n_pages, offset;
> +	struct vm_area_struct *vma;
> +	struct vm_area_struct *res_vma;
> +	dma_addr_t physp;
> 
>  	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
>  	if (!buf)
> @@ -80,23 +85,37 @@ static void *vb2_vmalloc_get_userptr(void *alloc_ctx,
> unsigned long vaddr, offset = vaddr & ~PAGE_MASK;
>  	buf->size = size;
> 
> -	first = vaddr >> PAGE_SHIFT;
> -	last  = (vaddr + size - 1) >> PAGE_SHIFT;
> -	buf->n_pages = last - first + 1;
> -	buf->pages = kzalloc(buf->n_pages * sizeof(struct page *), GFP_KERNEL);
> -	if (!buf->pages)
> -		goto fail_pages_array_alloc;
> 
> -	/* current->mm->mmap_sem is taken by videobuf2 core */
> -	n_pages = get_user_pages(current, current->mm, vaddr & PAGE_MASK,
> -					buf->n_pages, write, 1, /* force */
> -					buf->pages, NULL);
> -	if (n_pages != buf->n_pages)
> -		goto fail_get_user_pages;
> -
> -	buf->vaddr = vm_map_ram(buf->pages, buf->n_pages, -1, PAGE_KERNEL);
> -	if (!buf->vaddr)
> -		goto fail_get_user_pages;
> +	vma = find_vma(current->mm, vaddr);
> +	if (vma && (vma->vm_flags & VM_PFNMAP) && (vma->vm_pgoff)) {
> +		if (vb2_get_contig_userptr(vaddr, size, &res_vma, &physp))

One small comment here. You don't use the vma variable from this point on, so 
maybe you could remove res_vma and use vma instead.

> +			goto fail_pages_array_alloc;
> +		buf->vma = res_vma;
> +		buf->vaddr = ioremap_nocache(physp, size);
> +		if (!buf->vaddr)
> +			goto fail_pages_array_alloc;
> +	} else {
> +		first = vaddr >> PAGE_SHIFT;
> +		last  = (vaddr + size - 1) >> PAGE_SHIFT;
> +		buf->n_pages = last - first + 1;
> +		buf->pages = kzalloc(buf->n_pages * sizeof(struct page *),
> +				     GFP_KERNEL);
> +		if (!buf->pages)
> +			goto fail_pages_array_alloc;
> +
> +		/* current->mm->mmap_sem is taken by videobuf2 core */
> +		n_pages = get_user_pages(current, current->mm,
> +					 vaddr & PAGE_MASK, buf->n_pages,
> +					 write, 1, /* force */
> +					 buf->pages, NULL);
> +		if (n_pages != buf->n_pages)
> +			goto fail_get_user_pages;
> +
> +		buf->vaddr = vm_map_ram(buf->pages, buf->n_pages, -1,
> +					PAGE_KERNEL);
> +		if (!buf->vaddr)
> +			goto fail_get_user_pages;
> +	}
> 
>  	buf->vaddr += offset;
>  	return buf;
> @@ -120,14 +139,20 @@ static void vb2_vmalloc_put_userptr(void *buf_priv)
>  	unsigned long vaddr = (unsigned long)buf->vaddr & PAGE_MASK;
>  	unsigned int i;
> 
> -	if (vaddr)
> -		vm_unmap_ram((void *)vaddr, buf->n_pages);
> -	for (i = 0; i < buf->n_pages; ++i) {
> -		if (buf->write)
> -			set_page_dirty_lock(buf->pages[i]);
> -		put_page(buf->pages[i]);
> +	if (buf->pages) {
> +		if (vaddr)
> +			vm_unmap_ram((void *)vaddr, buf->n_pages);
> +		for (i = 0; i < buf->n_pages; ++i) {
> +			if (buf->write)
> +				set_page_dirty_lock(buf->pages[i]);
> +			put_page(buf->pages[i]);
> +		}
> +		kfree(buf->pages);
> +	} else {
> +		if (buf->vma)
> +			vb2_put_vma(buf->vma);
> +		iounmap(buf->vaddr);
>  	}
> -	kfree(buf->pages);
>  	kfree(buf);
>  }

-- 
Regards,

Laurent Pinchart
