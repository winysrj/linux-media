Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:57799 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab2ACLpq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Jan 2012 06:45:46 -0500
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LX800N2H0O70T@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 03 Jan 2012 11:45:43 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LX8002300O79J@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 03 Jan 2012 11:45:43 +0000 (GMT)
Date: Tue, 03 Jan 2012 12:45:40 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH 1/2 v2] media: vb2: support userptr for PFN mappings.
In-reply-to: <1325589531-23607-1-git-send-email-javier.martin@vista-silicon.com>
To: 'Javier Martin' <javier.martin@vista-silicon.com>,
	linux-media@vger.kernel.org
Cc: mchehab@infradead.org, pawel@osciak.com,
	laurent.pinchart@ideasonboard.com, kyungmin.park@samsung.com
Message-id: <00e501ccca0d$379a5ab0$a6cf1010$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <1325589531-23607-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Tuesday, January 03, 2012 12:19 PM Javier Martin wrote:

> Some video devices need to use contiguous memory
> which is not backed by pages as it happens with
> vmalloc. This patch provides userptr handling for
> those devices.
> 
> ---
> Changes since v1:
>  - Use vb2_get_contig_userptr() which provides page
>  locking and contiguous memory check.
> 
> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
> ---
>  drivers/media/video/videobuf2-vmalloc.c |   74 +++++++++++++++++++++----------
>  1 files changed, 51 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/media/video/videobuf2-vmalloc.c b/drivers/media/video/videobuf2-vmalloc.c
> index 03aa62f..8248e56 100644
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
> @@ -71,6 +73,9 @@ static void *vb2_vmalloc_get_userptr(void *alloc_ctx, unsigned long vaddr,
>  	struct vb2_vmalloc_buf *buf;
>  	unsigned long first, last;
>  	int n_pages, offset;
> +	struct vm_area_struct *vma;
> +	struct vm_area_struct *res_vma;
> +	dma_addr_t physp;
> 
>  	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
>  	if (!buf)
> @@ -80,23 +85,40 @@ static void *vb2_vmalloc_get_userptr(void *alloc_ctx, unsigned long vaddr,
>  	offset = vaddr & ~PAGE_MASK;
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
> +	down_read(&current->mm->mmap_sem);

mm->mmap_sem is already grabbed by the videobuf2-core to avoid deadlocks. You 
must not take it again here.

> +	vma = find_vma(current->mm, vaddr);
> +	if (vma && (vma->vm_flags & VM_PFNMAP) && (vma->vm_pgoff)) {
> +		up_read(&current->mm->mmap_sem);
> +		if (vb2_get_contig_userptr(vaddr, size, &res_vma, &physp))
> +			goto fail_pages_array_alloc;
> +		buf->vma = res_vma;
> +		buf->vaddr = ioremap_nocache(physp, size);
> +		if (!buf->vaddr)
> +			goto fail_pages_array_alloc;
> +	} else {
> +		up_read(&current->mm->mmap_sem);
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
> @@ -120,14 +142,20 @@ static void vb2_vmalloc_put_userptr(void *buf_priv)
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

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



