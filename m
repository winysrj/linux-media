Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59335 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080Ab2DQM4m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Apr 2012 08:56:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, subashrp@gmail.com,
	mchehab@redhat.com
Subject: Re: [RFC 03/13] v4l: vb2-dma-contig: let mmap method to use dma_mmap_coherent call
Date: Tue, 17 Apr 2012 14:56:54 +0200
Message-ID: <1620523.5SfIscjHXv@avalon>
In-Reply-To: <1334063447-16824-4-git-send-email-t.stanislaws@samsung.com>
References: <1334063447-16824-1-git-send-email-t.stanislaws@samsung.com> <1334063447-16824-4-git-send-email-t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

Thanks for the patch.

On Tuesday 10 April 2012 15:10:37 Tomasz Stanislawski wrote:
> From: Marek Szyprowski <m.szyprowski@samsung.com>
> 
> Let mmap method to use dma_mmap_coherent call.  This patch depends on DMA
> mapping redesign patches because the usage of dma_mmap_coherent breaks
> dma-contig allocator for architectures other than ARM and AVR.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/media/video/videobuf2-dma-contig.c |   28 +++++++++++++++++++++++--
>  1 files changed, 26 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/videobuf2-dma-contig.c
> b/drivers/media/video/videobuf2-dma-contig.c index 6329483..f4df9e2 100644
> --- a/drivers/media/video/videobuf2-dma-contig.c
> +++ b/drivers/media/video/videobuf2-dma-contig.c
> @@ -224,14 +224,38 @@ static void *vb2_dc_alloc(void *alloc_ctx, unsigned
> long size) static int vb2_dc_mmap(void *buf_priv, struct vm_area_struct
> *vma) {
>  	struct vb2_dc_buf *buf = buf_priv;
> +	int ret;
> 
>  	if (!buf) {
>  		printk(KERN_ERR "No buffer to map\n");
>  		return -EINVAL;
>  	}
> 
> -	return vb2_mmap_pfn_range(vma, buf->dma_addr, buf->size,
> -				  &vb2_common_vm_ops, &buf->handler);

This was the only vb2_mmap_pfn_range() if I'm not mistaken. Should the 
function be removed ?

> +	/*
> +	 * dma_mmap_* uses vm_pgoff as in-buffer offset, but we want to
> +	 * map whole buffer
> +	 */
> +	vma->vm_pgoff = 0;

Is it safe to set vma->vm_pgoff to 0 here behind memory core's back ?

> +	ret = dma_mmap_coherent(buf->dev, vma, buf->vaddr,
> +		buf->dma_addr, buf->size);
> +
> +	if (ret) {
> +		printk(KERN_ERR "Remapping memory failed, error: %d\n", ret);
> +		return ret;
> +	}
> +
> +	vma->vm_flags		|= VM_DONTEXPAND | VM_RESERVED;
> +	vma->vm_private_data	= &buf->handler;
> +	vma->vm_ops		= &vb2_common_vm_ops;
> +
> +	vma->vm_ops->open(vma);
> +
> +	printk(KERN_DEBUG "%s: mapped dma addr 0x%08lx at 0x%08lx, size %ld\n",
> +		__func__, (unsigned long)buf->dma_addr, vma->vm_start,
> +		buf->size);
> +
> +	return 0;
>  }
> 
>  /*********************************************/
-- 
Regards,

Laurent Pinchart

