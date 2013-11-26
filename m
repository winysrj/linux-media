Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:9464 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690Ab3KZPDT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Nov 2013 10:03:19 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MWV00GF8LTGRC30@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 26 Nov 2013 15:03:17 +0000 (GMT)
Message-id: <5294B834.60305@samsung.com>
Date: Tue, 26 Nov 2013 16:03:16 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
MIME-version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Pawel Osciak <pawel@osciak.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	"open list:VIDEOBUF2 FRAMEWORK" <linux-media@vger.kernel.org>,
	sylvester.nawrocki@gmail.com,
	=?UTF-8?B?TWF0dGhpYXMgV8OkY2h0ZXI=?= <matthias.waechter@tttech.com>
Subject: Re: [PATCH v2] videobuf2-dma-sg: Support io userptr operations on io
 memory
References: <1385470724-20632-1-git-send-email-ricardo.ribalda@gmail.com>
In-reply-to: <1385470724-20632-1-git-send-email-ricardo.ribalda@gmail.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 2013-11-26 13:58, Ricardo Ribalda Delgado wrote:
> Memory exported via remap_pfn_range cannot be remapped via
> get_user_pages.
>
> Other videobuf2 methods (like the dma-contig) supports io memory.
>
> This patch adds support for this kind of memory.
>
> v2: Comments by Marek Szyprowski
> -Use vb2_get_vma and vb2_put_vma
>
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>   drivers/media/v4l2-core/videobuf2-dma-sg.c | 54 +++++++++++++++++++++++++++---
>   1 file changed, 49 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
> index 2f86054..104e4b9 100644
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
> @@ -155,12 +156,18 @@ static void vb2_dma_sg_put(void *buf_priv)
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
>   	struct vb2_dma_sg_buf *buf;
>   	unsigned long first, last;
>   	int num_pages_from_user;
> +	struct vm_area_struct *vma;
>   
>   	buf = kzalloc(sizeof *buf, GFP_KERNEL);
>   	if (!buf)
> @@ -178,9 +185,40 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
>   	buf->pages = kzalloc(buf->num_pages * sizeof(struct page *),
>   			     GFP_KERNEL);
>   	if (!buf->pages)
> -		return NULL;
> +		goto userptr_fail_alloc_pages;
> +
> +	vma = find_vma(current->mm, vaddr);
> +	if (!vma) {
> +		dprintk(1, "no vma for address %lu\n", vaddr);
> +		goto userptr_fail_find_vma;
> +	}
> +
> +	if (vma->vm_end < vaddr + size) {
> +		dprintk(1, "vma at %lu is too small for %lu bytes\n",
> +			vaddr, size);
> +		goto userptr_fail_find_vma;
> +	}
> +
> +	buf->vma = vb2_get_vma(vma);
> +	if (!buf->vma) {
> +		dprintk(1, "failed to copy vma\n");
> +		goto userptr_fail_find_vma;
> +	}
> +
> +	if (vma_is_io(buf->vma)) {
> +		for (num_pages_from_user = 0;
> +		     num_pages_from_user < buf->num_pages;
> +		     ++num_pages_from_user, vaddr += PAGE_SIZE) {
> +			unsigned long pfn;
>   
> -	num_pages_from_user = get_user_pages(current, current->mm,
> +			if (follow_pfn(buf->vma, vaddr, &pfn)) {
> +				dprintk(1, "no page for address %lu\n", vaddr);
> +				break;
> +			}
> +			buf->pages[num_pages_from_user] = pfn_to_page(pfn);
> +		}
> +	} else
> +		num_pages_from_user = get_user_pages(current, current->mm,
>   					     vaddr & PAGE_MASK,
>   					     buf->num_pages,
>   					     write,
> @@ -201,9 +239,13 @@ userptr_fail_alloc_table_from_pages:
>   userptr_fail_get_user_pages:
>   	dprintk(1, "get_user_pages requested/got: %d/%d]\n",
>   	       num_pages_from_user, buf->num_pages);
> -	while (--num_pages_from_user >= 0)
> -		put_page(buf->pages[num_pages_from_user]);
> +	if (!vma_is_io(buf->vma))
> +		while (--num_pages_from_user >= 0)
> +			put_page(buf->pages[num_pages_from_user]);
> +	vb2_put_vma(buf->vma);
> +userptr_fail_find_vma:
>   	kfree(buf->pages);
> +userptr_fail_alloc_pages:
>   	kfree(buf);
>   	return NULL;
>   }
> @@ -225,9 +267,11 @@ static void vb2_dma_sg_put_userptr(void *buf_priv)
>   	while (--i >= 0) {
>   		if (buf->write)
>   			set_page_dirty_lock(buf->pages[i]);
> -		put_page(buf->pages[i]);
> +		if (!vma_is_io(buf->vma))
> +			put_page(buf->pages[i]);
>   	}
>   	kfree(buf->pages);
> +	vb2_put_vma(buf->vma);
>   	kfree(buf);
>   }
>   

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

