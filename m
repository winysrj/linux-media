Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:15959 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab2AIKOU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Jan 2012 05:14:20 -0500
Received: from euspt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LXJ00MTP0FUYY@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 09 Jan 2012 10:14:18 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LXJ00DUP0FT0U@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 09 Jan 2012 10:14:18 +0000 (GMT)
Date: Mon, 09 Jan 2012 11:14:01 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH 1/2 v4] media: vb2: support userptr for PFN mappings.
In-reply-to: <1325693947-8848-1-git-send-email-javier.martin@vista-silicon.com>
To: 'Javier Martin' <javier.martin@vista-silicon.com>,
	linux-media@vger.kernel.org
Cc: mchehab@infradead.org, pawel@osciak.com,
	laurent.pinchart@ideasonboard.com, kyungmin.park@samsung.com
Message-id: <00ef01ccceb7$68f0cb90$3ad262b0$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <1325693947-8848-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Wednesday, January 04, 2012 5:19 PM Javier Martin wrote:

> Some video devices need to use contiguous memory
> which is not backed by pages as it happens with
> vmalloc. This patch provides userptr handling for
> those devices.
> 
> ---
> Changes since v3:
>  - Remove vma_res variable.
> 
> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

Do you plan to put a git tree with all your patches and send a pull request
to Mauro? If not I will take this patch and put it on my vb2 branch.

> ---
>  drivers/media/video/videobuf2-vmalloc.c |   70 +++++++++++++++++++++----------
>  1 files changed, 47 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/media/video/videobuf2-vmalloc.c b/drivers/media/video/videobuf2-vmalloc.c
> index 03aa62f..f9ff15f 100644
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
> @@ -71,6 +73,8 @@ static void *vb2_vmalloc_get_userptr(void *alloc_ctx, unsigned long vaddr,
>  	struct vb2_vmalloc_buf *buf;
>  	unsigned long first, last;
>  	int n_pages, offset;
> +	struct vm_area_struct *vma;
> +	dma_addr_t physp;
> 
>  	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
>  	if (!buf)
> @@ -80,23 +84,37 @@ static void *vb2_vmalloc_get_userptr(void *alloc_ctx, unsigned long vaddr,
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
> +	vma = find_vma(current->mm, vaddr);
> +	if (vma && (vma->vm_flags & VM_PFNMAP) && (vma->vm_pgoff)) {
> +		if (vb2_get_contig_userptr(vaddr, size, &vma, &physp))
> +			goto fail_pages_array_alloc;
> +		buf->vma = vma;
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
> @@ -120,14 +138,20 @@ static void vb2_vmalloc_put_userptr(void *buf_priv)
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
> 
> --


Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


