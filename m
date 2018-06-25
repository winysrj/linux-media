Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f66.google.com ([209.85.208.66]:42869 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751469AbeFYIXF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Jun 2018 04:23:05 -0400
Received: by mail-ed1-f66.google.com with SMTP id g12-v6so216648edi.9
        for <linux-media@vger.kernel.org>; Mon, 25 Jun 2018 01:23:05 -0700 (PDT)
Date: Mon, 25 Jun 2018 10:22:31 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Christian =?iso-8859-1?Q?K=F6nig?=
        <ckoenig.leichtzumerken@gmail.com>
Cc: daniel@ffwll.ch, sumit.semwal@linaro.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org, intel-gfx@lists.freedesktop.org
Subject: Re: [PATCH 2/4] dma-buf: lock the reservation object during
 (un)map_dma_buf v2
Message-ID: <20180625082231.GM2958@phenom.ffwll.local>
References: <20180622141103.1787-1-christian.koenig@amd.com>
 <20180622141103.1787-3-christian.koenig@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180622141103.1787-3-christian.koenig@amd.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 22, 2018 at 04:11:01PM +0200, Christian König wrote:
> First step towards unpinned DMA buf operation.
> 
> I've checked the DRM drivers to potential locking of the reservation
> object, but essentially we need to audit all implementations of the
> dma_buf _ops for this to work.
> 
> v2: reordered
> 
> Signed-off-by: Christian König <christian.koenig@amd.com>

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>

> ---
>  drivers/dma-buf/dma-buf.c | 9 ++++++---
>  include/linux/dma-buf.h   | 4 ++++
>  2 files changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index dc94e76e2e2a..49f23b791eb8 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -665,7 +665,9 @@ struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *attach,
>  	if (WARN_ON(!attach || !attach->dmabuf))
>  		return ERR_PTR(-EINVAL);
>  
> -	sg_table = attach->dmabuf->ops->map_dma_buf(attach, direction);
> +	reservation_object_lock(attach->dmabuf->resv, NULL);
> +	sg_table = dma_buf_map_attachment_locked(attach, direction);
> +	reservation_object_unlock(attach->dmabuf->resv);
>  	if (!sg_table)
>  		sg_table = ERR_PTR(-ENOMEM);
>  
> @@ -715,8 +717,9 @@ void dma_buf_unmap_attachment(struct dma_buf_attachment *attach,
>  	if (WARN_ON(!attach || !attach->dmabuf || !sg_table))
>  		return;
>  
> -	attach->dmabuf->ops->unmap_dma_buf(attach, sg_table,
> -						direction);
> +	reservation_object_lock(attach->dmabuf->resv, NULL);
> +	dma_buf_unmap_attachment_locked(attach, sg_table, direction);
> +	reservation_object_unlock(attach->dmabuf->resv);
>  }
>  EXPORT_SYMBOL_GPL(dma_buf_unmap_attachment);
>  
> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> index a25e754ae2f7..024658d1f22e 100644
> --- a/include/linux/dma-buf.h
> +++ b/include/linux/dma-buf.h
> @@ -118,6 +118,8 @@ struct dma_buf_ops {
>  	 * any other kind of sharing that the exporter might wish to make
>  	 * available to buffer-users.
>  	 *
> +	 * This is called with the dmabuf->resv object locked.
> +	 *
>  	 * Returns:
>  	 *
>  	 * A &sg_table scatter list of or the backing storage of the DMA buffer,
> @@ -138,6 +140,8 @@ struct dma_buf_ops {
>  	 * It should also unpin the backing storage if this is the last mapping
>  	 * of the DMA buffer, it the exporter supports backing storage
>  	 * migration.
> +	 *
> +	 * This is called with the dmabuf->resv object locked.
>  	 */
>  	void (*unmap_dma_buf)(struct dma_buf_attachment *,
>  			      struct sg_table *,
> -- 
> 2.14.1
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
