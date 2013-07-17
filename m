Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:55484 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201Ab3GQI1m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jul 2013 04:27:42 -0400
Message-id: <51E65577.7010403@samsung.com>
Date: Wed, 17 Jul 2013 10:27:35 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
MIME-version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Pawel Osciak <pawel@osciak.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] videobuf2-dma-sg: Minimize the number of dma segments
References: <1373880874-9270-1-git-send-email-ricardo.ribalda@gmail.com>
In-reply-to: <1373880874-9270-1-git-send-email-ricardo.ribalda@gmail.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 7/15/2013 11:34 AM, Ricardo Ribalda Delgado wrote:
> Most DMA engines have limitations regarding the number of DMA segments
> (sg-buffers) that they can handle. Videobuffers can easily spread through
> houndreds of pages.
>
> In the previous aproach, the pages were allocated individually, this
> could led to the creation houndreds of dma segments (sg-buffers) that
> could not be handled by some DMA engines.
>
> This patch tries to minimize the number of DMA segments by using
> alloc_pages_exact. In the worst case it will behave as before, but most
> of the times it will reduce the number fo dma segments
>
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

I like the idea, but the code doesn't seem to be correct. buf->pages 
array is
needed for vb2_dma_sg_mmap() function to map pages to userspace. However 
in your
code I don't see any place where you fill it with the pages of order higher
than 0. AFAIR vm_insert_page() can handle compound pages, but 
alloc_pages_exact()
splits such pages into a set of pages of order 0, so you need to change 
your code
to correctly fill buf->pages array.

> ---
>   drivers/media/v4l2-core/videobuf2-dma-sg.c |   49 +++++++++++++++++++++-------
>   1 file changed, 38 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
> index 16ae3dc..67a94ab 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
> @@ -42,10 +42,44 @@ struct vb2_dma_sg_buf {
>   
>   static void vb2_dma_sg_put(void *buf_priv);
>   
> +static int vb2_dma_sg_alloc_compacted(struct vb2_dma_sg_buf *buf,
> +		gfp_t gfp_flags)
> +{
> +	unsigned int last_page = 0;
> +	void *vaddr = NULL;
> +	unsigned int req_pages;
> +
> +	while (last_page < buf->sg_desc.num_pages) {
> +		req_pages = buf->sg_desc.num_pages-last_page;
> +		while (req_pages >= 1) {
> +			vaddr = alloc_pages_exact(req_pages*PAGE_SIZE,
> +				GFP_KERNEL | __GFP_ZERO | __GFP_NOWARN);
> +			if (vaddr)
> +				break;
> +			req_pages >>= 1;
> +		}
> +		if (!vaddr) {
> +			while (--last_page >= 0)
> +				__free_page(buf->pages[last_page]);
> +			return -ENOMEM;
> +		}
> +		while (req_pages) {
> +			buf->pages[last_page] = virt_to_page(vaddr);
> +			sg_set_page(&buf->sg_desc.sglist[last_page],
> +					buf->pages[last_page], PAGE_SIZE, 0);
> +			vaddr += PAGE_SIZE;
> +			last_page++;
> +			req_pages--;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>   static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size, gfp_t gfp_flags)
>   {
>   	struct vb2_dma_sg_buf *buf;
> -	int i;
> +	int ret;
>   
>   	buf = kzalloc(sizeof *buf, GFP_KERNEL);
>   	if (!buf)
> @@ -69,14 +103,9 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size, gfp_t gfp_fla
>   	if (!buf->pages)
>   		goto fail_pages_array_alloc;
>   
> -	for (i = 0; i < buf->sg_desc.num_pages; ++i) {
> -		buf->pages[i] = alloc_page(GFP_KERNEL | __GFP_ZERO |
> -					   __GFP_NOWARN | gfp_flags);
> -		if (NULL == buf->pages[i])
> -			goto fail_pages_alloc;
> -		sg_set_page(&buf->sg_desc.sglist[i],
> -			    buf->pages[i], PAGE_SIZE, 0);
> -	}
> +	ret = vb2_dma_sg_alloc_compacted(buf, gfp_flags);
> +	if (ret)
> +		goto fail_pages_alloc;
>   
>   	buf->handler.refcount = &buf->refcount;
>   	buf->handler.put = vb2_dma_sg_put;
> @@ -89,8 +118,6 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size, gfp_t gfp_fla
>   	return buf;
>   
>   fail_pages_alloc:
> -	while (--i >= 0)
> -		__free_page(buf->pages[i]);
>   	kfree(buf->pages);
>   
>   fail_pages_array_alloc:

Best regards
-- 
Marek Szyprowski
Samsung R&D Institute Poland


