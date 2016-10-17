Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38294 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S934820AbcJQOdn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Oct 2016 10:33:43 -0400
Date: Mon, 17 Oct 2016 17:32:58 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Thierry Escande <thierry.escande@collabora.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] [media] videobuf2-dma-contig: Support cacheable MMAP
Message-ID: <20161017143258.GN9460@valkosipuli.retiisi.org.uk>
References: <1476451309-10645-1-git-send-email-thierry.escande@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476451309-10645-1-git-send-email-thierry.escande@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thierry,

On Fri, Oct 14, 2016 at 03:21:49PM +0200, Thierry Escande wrote:
> From: Heng-Ruey Hsu <henryhsu@chromium.org>
> 
> DMA allocations for MMAP type are uncached by default. But for
> some cases, CPU has to access the buffers. ie: memcpy for format
> converter. Supporting cacheable MMAP improves huge performance.

Does this patch basically make videobuf2-dma-contig work if you use the
DMA_ATTR_NO_KERNEL_MAPPING and DMA_ATTR_NON_CONSISTENT attributes? If so, it
should be mentioned in the commit message. No driver appears to be using
either of the two flags right now.

> 
> Signed-off-by: Heng-Ruey Hsu <henryhsu@chromium.org>
> Tested-by: Heng-ruey Hsu <henryhsu@chromium.org>
> Reviewed-by: Tomasz Figa <tfiga@chromium.org>
> Signed-off-by: Thierry Escande <thierry.escande@collabora.com>
> ---
>  drivers/media/v4l2-core/videobuf2-dma-contig.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> index fb6a177..c953c24 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> @@ -42,6 +42,12 @@ struct vb2_dc_buf {
>  };
>  
>  /*********************************************/
> +/*           Forward declarations            */
> +/*********************************************/
> +
> +static struct sg_table *vb2_dc_get_base_sgt(struct vb2_dc_buf *buf);

If you need this above from where the function is right now, could you move
it up instead in a separate patch?

> +
> +/*********************************************/
>  /*        scatterlist table functions        */
>  /*********************************************/
>  
> @@ -129,6 +135,10 @@ static void vb2_dc_put(void *buf_priv)
>  		sg_free_table(buf->sgt_base);
>  		kfree(buf->sgt_base);
>  	}
> +	if (buf->dma_sgt) {
> +		sg_free_table(buf->dma_sgt);
> +		kfree(buf->dma_sgt);
> +	}
>  	dma_free_attrs(buf->dev, buf->size, buf->cookie, buf->dma_addr,
>  		       buf->attrs);
>  	put_device(buf->dev);
> @@ -170,6 +180,10 @@ static void *vb2_dc_alloc(struct device *dev, unsigned long attrs,
>  	buf->handler.put = vb2_dc_put;
>  	buf->handler.arg = buf;
>  

It'd be nice to add a comment why this is being done. I don't think it's
entirely trivial.

> +	if (!(buf->attrs & DMA_ATTR_NO_KERNEL_MAPPING) &&
> +	     (buf->attrs & DMA_ATTR_NON_CONSISTENT))
> +		buf->dma_sgt = vb2_dc_get_base_sgt(buf);
> +
>  	atomic_inc(&buf->refcount);
>  
>  	return buf;
> @@ -205,6 +219,11 @@ static int vb2_dc_mmap(void *buf_priv, struct vm_area_struct *vma)
>  
>  	vma->vm_ops->open(vma);
>  
> +	if ((buf->attrs & DMA_ATTR_NO_KERNEL_MAPPING) &&

Is the DMA_ATTR_NO_KERNEL_MAPPING flag relevant here? I understand the
mapping is used to flush the cache, but you do need it independently of
whether or not the DMA_ATTR_NO_KERNEL_MAPPING flag is present, don't you?

> +	    (buf->attrs & DMA_ATTR_NON_CONSISTENT) &&
> +	    !buf->dma_sgt)

I think it'd be nicer to check for buf->dma_sgt first; up to you. You don't
need the extra parentheses either (some extra in the above chunk as well).

> +		buf->dma_sgt = vb2_dc_get_base_sgt(buf);

What if vb2_dc_get_base_sgt() returns NULL here or in the chunk above?

> +
>  	pr_debug("%s: mapped dma addr 0x%08lx at 0x%08lx, size %ld\n",
>  		__func__, (unsigned long)buf->dma_addr, vma->vm_start,
>  		buf->size);

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
