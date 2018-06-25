Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f66.google.com ([209.85.208.66]:40266 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754079AbeFYIQP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Jun 2018 04:16:15 -0400
Received: by mail-ed1-f66.google.com with SMTP id m15-v6so2598056edr.7
        for <linux-media@vger.kernel.org>; Mon, 25 Jun 2018 01:16:14 -0700 (PDT)
Date: Mon, 25 Jun 2018 10:15:41 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Christian =?iso-8859-1?Q?K=F6nig?=
        <ckoenig.leichtzumerken@gmail.com>
Cc: daniel@ffwll.ch, sumit.semwal@linaro.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org, intel-gfx@lists.freedesktop.org
Subject: Re: [PATCH 1/4] dma-buf: add dma_buf_(un)map_attachment_locked
 variants v2
Message-ID: <20180625081541.GL2958@phenom.ffwll.local>
References: <20180622141103.1787-1-christian.koenig@amd.com>
 <20180622141103.1787-2-christian.koenig@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180622141103.1787-2-christian.koenig@amd.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 22, 2018 at 04:11:00PM +0200, Christian König wrote:
> Add function variants which can be called with the reservation lock
> already held.
> 
> v2: reordered, add lockdep asserts, fix kerneldoc
> 
> Signed-off-by: Christian König <christian.koenig@amd.com>
> ---
>  drivers/dma-buf/dma-buf.c | 57 +++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/dma-buf.h   |  5 +++++
>  2 files changed, 62 insertions(+)
> 
> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index 852a3928ee71..dc94e76e2e2a 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -606,6 +606,40 @@ void dma_buf_detach(struct dma_buf *dmabuf, struct dma_buf_attachment *attach)
>  }
>  EXPORT_SYMBOL_GPL(dma_buf_detach);
>  
> +/**
> + * dma_buf_map_attachment_locked - Maps the buffer into _device_ address space
> + * with the reservation lock held. Is a wrapper for map_dma_buf() of the
> + *

This here looks mangled (and the blank line wreaks the resulting html).
With that fixed.

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>


> + * Returns the scatterlist table of the attachment;
> + * dma_buf_ops.
> + * @attach:	[in]	attachment whose scatterlist is to be returned
> + * @direction:	[in]	direction of DMA transfer
> + *
> + * Returns sg_table containing the scatterlist to be returned; returns ERR_PTR
> + * on error. May return -EINTR if it is interrupted by a signal.
> + *
> + * A mapping must be unmapped by using dma_buf_unmap_attachment_locked(). Note
> + * that the underlying backing storage is pinned for as long as a mapping
> + * exists, therefore users/importers should not hold onto a mapping for undue
> + * amounts of time.
> + */
> +struct sg_table *
> +dma_buf_map_attachment_locked(struct dma_buf_attachment *attach,
> +			      enum dma_data_direction direction)
> +{
> +	struct sg_table *sg_table;
> +
> +	might_sleep();
> +	reservation_object_assert_held(attach->dmabuf->resv);
> +
> +	sg_table = attach->dmabuf->ops->map_dma_buf(attach, direction);
> +	if (!sg_table)
> +		sg_table = ERR_PTR(-ENOMEM);
> +
> +	return sg_table;
> +}
> +EXPORT_SYMBOL_GPL(dma_buf_map_attachment_locked);
> +
>  /**
>   * dma_buf_map_attachment - Returns the scatterlist table of the attachment;
>   * mapped into _device_ address space. Is a wrapper for map_dma_buf() of the
> @@ -639,6 +673,29 @@ struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *attach,
>  }
>  EXPORT_SYMBOL_GPL(dma_buf_map_attachment);
>  
> +/**
> + * dma_buf_unmap_attachment_locked - unmaps the buffer with reservation lock
> + * held, should deallocate the associated scatterlist. Is a wrapper for
> + * unmap_dma_buf() of dma_buf_ops.
> + * @attach:	[in]	attachment to unmap buffer from
> + * @sg_table:	[in]	scatterlist info of the buffer to unmap
> + * @direction:  [in]    direction of DMA transfer
> + *
> + * This unmaps a DMA mapping for @attached obtained by
> + * dma_buf_map_attachment_locked().
> + */
> +void dma_buf_unmap_attachment_locked(struct dma_buf_attachment *attach,
> +				     struct sg_table *sg_table,
> +				     enum dma_data_direction direction)
> +{
> +	might_sleep();
> +	reservation_object_assert_held(attach->dmabuf->resv);
> +
> +	attach->dmabuf->ops->unmap_dma_buf(attach, sg_table,
> +						direction);
> +}
> +EXPORT_SYMBOL_GPL(dma_buf_unmap_attachment_locked);
> +
>  /**
>   * dma_buf_unmap_attachment - unmaps and decreases usecount of the buffer;might
>   * deallocate the scatterlist associated. Is a wrapper for unmap_dma_buf() of
> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> index 991787a03199..a25e754ae2f7 100644
> --- a/include/linux/dma-buf.h
> +++ b/include/linux/dma-buf.h
> @@ -384,8 +384,13 @@ int dma_buf_fd(struct dma_buf *dmabuf, int flags);
>  struct dma_buf *dma_buf_get(int fd);
>  void dma_buf_put(struct dma_buf *dmabuf);
>  
> +struct sg_table *dma_buf_map_attachment_locked(struct dma_buf_attachment *,
> +					       enum dma_data_direction);
>  struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *,
>  					enum dma_data_direction);
> +void dma_buf_unmap_attachment_locked(struct dma_buf_attachment *,
> +				     struct sg_table *,
> +				     enum dma_data_direction);
>  void dma_buf_unmap_attachment(struct dma_buf_attachment *, struct sg_table *,
>  				enum dma_data_direction);
>  int dma_buf_begin_cpu_access(struct dma_buf *dma_buf,
> -- 
> 2.14.1
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
