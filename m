Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:51241 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965498AbeFRIW2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Jun 2018 04:22:28 -0400
Received: by mail-wm0-f68.google.com with SMTP id r15-v6so12524241wmc.1
        for <linux-media@vger.kernel.org>; Mon, 18 Jun 2018 01:22:27 -0700 (PDT)
Date: Mon, 18 Jun 2018 10:22:24 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Christian =?iso-8859-1?Q?K=F6nig?=
        <ckoenig.leichtzumerken@gmail.com>
Cc: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org
Subject: Re: [PATCH 3/5] dma-buf: lock the reservation object during
 (un)map_dma_buf
Message-ID: <20180618082224.GW3438@phenom.ffwll.local>
References: <20180601120020.11520-1-christian.koenig@amd.com>
 <20180601120020.11520-3-christian.koenig@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180601120020.11520-3-christian.koenig@amd.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 01, 2018 at 02:00:18PM +0200, Christian König wrote:
> First step towards unpinned DMA buf operation.
> 
> I've checked the DRM drivers to potential locking of the reservation
> object, but essentially we need to audit all implementations of the
> dma_buf _ops for this to work.
> 
> Signed-off-by: Christian König <christian.koenig@amd.com>

Agreed in principle, but I expect a fireworks show with just this patch
applied. It's not just that we need to audit all the implementations of
dma-buf-ops, we also need to audit all the callers.

No idea yet how to go about merging this, but for a start might be good to
throw this at the intel-gfx CI (just Cc: the intel-gfx mailing lists, but
make sure your series applies without amd-staging-next stuff which isn't
in drm.git yet).
-Daniel

> ---
>  drivers/dma-buf/dma-buf.c | 4 ++++
>  include/linux/dma-buf.h   | 4 ++++
>  2 files changed, 8 insertions(+)
> 
> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index e4c657d9fad7..4f0708cb58a7 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -631,7 +631,9 @@ struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *attach,
>  	if (WARN_ON(!attach || !attach->dmabuf))
>  		return ERR_PTR(-EINVAL);
>  
> +	reservation_object_lock(attach->dmabuf->resv, NULL);
>  	sg_table = attach->dmabuf->ops->map_dma_buf(attach, direction);
> +	reservation_object_unlock(attach->dmabuf->resv);
>  	if (!sg_table)
>  		sg_table = ERR_PTR(-ENOMEM);
>  
> @@ -658,8 +660,10 @@ void dma_buf_unmap_attachment(struct dma_buf_attachment *attach,
>  	if (WARN_ON(!attach || !attach->dmabuf || !sg_table))
>  		return;
>  
> +	reservation_object_lock(attach->dmabuf->resv, NULL);
>  	attach->dmabuf->ops->unmap_dma_buf(attach, sg_table,
>  						direction);
> +	reservation_object_unlock(attach->dmabuf->resv);
>  }
>  EXPORT_SYMBOL_GPL(dma_buf_unmap_attachment);
>  
> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> index d17cadd76802..d2ba7a027a78 100644
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
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
