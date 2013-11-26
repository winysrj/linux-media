Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:23745 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206Ab3KZLUo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Nov 2013 06:20:44 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MWV00LJ8BIIJA90@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 26 Nov 2013 11:20:42 +0000 (GMT)
Message-id: <52948409.3070500@samsung.com>
Date: Tue, 26 Nov 2013 12:20:41 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
MIME-version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Pawel Osciak <pawel@osciak.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	"open list:VIDEOBUF2 FRAMEWORK" <linux-media@vger.kernel.org>,
	sylvester.nawrocki@gmail.com
Subject: Re: [PATCH] videobuf2-dma-sg: Support io userptr operations on io
 memory
References: <1383767329-29985-1-git-send-email-ricardo.ribalda@gmail.com>
In-reply-to: <1383767329-29985-1-git-send-email-ricardo.ribalda@gmail.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 2013-11-06 20:48, Ricardo Ribalda Delgado wrote:
> Memory exported via remap_pfn_range cannot be remapped via
> get_user_pages.
>
> Other videobuf2 methods (like the dma-contig) supports io memory.
>
> This patch adds support for this kind of memory.
>
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>   drivers/media/v4l2-core/videobuf2-dma-sg.c | 35 ++++++++++++++++++++++++++----
>   1 file changed, 31 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
> index 2f86054..44ddfe1 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
> @@ -40,6 +40,7 @@ struct vb2_dma_sg_buf {
>   	unsigned int			num_pages;
>   	atomic_t			refcount;
>   	struct vb2_vmarea_handler	handler;
> +	struct vm_area_struct		*vma;
>   };
>   
>   static void vb2_dma_sg_put(void *buf_priv);
> @@ -155,6 +156,11 @@ static void vb2_dma_sg_put(void *buf_priv)
>   	}
>   }
>   
> +static inline int vma_is_io(struct vm_area_struct *vma)
> +{
> +	return !!(vma->vm_flags & (VM_IO | VM_PFNMAP));
> +}
> +
>   static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
>   				    unsigned long size, int write)
>   {
> @@ -180,7 +186,26 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
>   	if (!buf->pages)
>   		return NULL;
>   
> -	num_pages_from_user = get_user_pages(current, current->mm,
> +	buf->vma = find_vma(current->mm, vaddr);
> +	if (!buf->vma) {
> +		dprintk(1, "no vma for address %lu\n", vaddr);
> +		return NULL;
> +	}
> +
> +	if (vma_is_io(buf->vma)) {
> +		for (num_pages_from_user = 0;
> +		     num_pages_from_user < buf->num_pages;
> +		     ++num_pages_from_user, vaddr += PAGE_SIZE) {
> +			unsigned long pfn;
> +
> +			if (follow_pfn(buf->vma, vaddr, &pfn)) {
> +				dprintk(1, "no page for address %lu\n", vaddr);
> +				break;
> +			}

Please add a call to vb2_get_vma(vma) to protect that io memory from 
being freed, see videobuf2-dma-contig.c for the reference. It is not 
100% perfect way, but right now it works for the typical memory regions 
created by other multimedia devices. You will also need to call 
vb2_put_vma() later on release.

> +			buf->pages[num_pages_from_user] = pfn_to_page(pfn);
> +		}
> +	} else
> +		num_pages_from_user = get_user_pages(current, current->mm,
>   					     vaddr & PAGE_MASK,
>   					     buf->num_pages,
>   					     write,
> @@ -201,8 +226,9 @@ userptr_fail_alloc_table_from_pages:
>   userptr_fail_get_user_pages:
>   	dprintk(1, "get_user_pages requested/got: %d/%d]\n",
>   	       num_pages_from_user, buf->num_pages);
> -	while (--num_pages_from_user >= 0)
> -		put_page(buf->pages[num_pages_from_user]);
> +	if (!vma_is_io(buf->vma))
> +		while (--num_pages_from_user >= 0)
> +			put_page(buf->pages[num_pages_from_user]);
>   	kfree(buf->pages);
>   	kfree(buf);
>   	return NULL;
> @@ -225,7 +251,8 @@ static void vb2_dma_sg_put_userptr(void *buf_priv)
>   	while (--i >= 0) {
>   		if (buf->write)
>   			set_page_dirty_lock(buf->pages[i]);
> -		put_page(buf->pages[i]);
> +		if (!vma_is_io(buf->vma))
> +			put_page(buf->pages[i]);
>   	}
>   	kfree(buf->pages);
>   	kfree(buf);

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

