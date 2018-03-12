Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:52961 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932629AbeCLRHP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Mar 2018 13:07:15 -0400
Received: by mail-wm0-f67.google.com with SMTP id t3so18046686wmc.2
        for <linux-media@vger.kernel.org>; Mon, 12 Mar 2018 10:07:14 -0700 (PDT)
Date: Mon, 12 Mar 2018 18:07:10 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Christian K??nig <ckoenig.leichtzumerken@gmail.com>
Cc: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org
Subject: Re: [PATCH 1/4] dma-buf: add optional invalidate_mappings callback
Message-ID: <20180312170710.GL8589@phenom.ffwll.local>
References: <20180309191144.1817-1-christian.koenig@amd.com>
 <20180309191144.1817-2-christian.koenig@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180309191144.1817-2-christian.koenig@amd.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 09, 2018 at 08:11:41PM +0100, Christian K??nig wrote:
> Each importer can now provide an invalidate_mappings callback.
> 
> This allows the exporter to provide the mappings without the need to pin
> the backing store.
> 
> Signed-off-by: Christian K??nig <christian.koenig@amd.com>
> ---
>  drivers/dma-buf/dma-buf.c | 25 +++++++++++++++++++++++++
>  include/linux/dma-buf.h   | 36 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 61 insertions(+)
> 
> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index d78d5fc173dc..ed8d5844ae74 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -629,6 +629,9 @@ struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *attach,
>  
>  	might_sleep();
>  
> +	if (attach->invalidate_mappings)
> +		reservation_object_assert_held(attach->dmabuf->resv);
> +
>  	if (WARN_ON(!attach || !attach->dmabuf))
>  		return ERR_PTR(-EINVAL);
>  
> @@ -656,6 +659,9 @@ void dma_buf_unmap_attachment(struct dma_buf_attachment *attach,
>  {
>  	might_sleep();
>  
> +	if (attach->invalidate_mappings)
> +		reservation_object_assert_held(attach->dmabuf->resv);
> +
>  	if (WARN_ON(!attach || !attach->dmabuf || !sg_table))
>  		return;
>  
> @@ -664,6 +670,25 @@ void dma_buf_unmap_attachment(struct dma_buf_attachment *attach,
>  }
>  EXPORT_SYMBOL_GPL(dma_buf_unmap_attachment);
>  
> +/**
> + * dma_buf_invalidate_mappings - invalidate all mappings of this dma_buf
> + *
> + * @dmabuf:	[in]	buffer which mappings should be invalidated
> + *
> + * Informs all attachmenst that they need to destroy and recreated all their
> + * mappings.
> + */
> +void dma_buf_invalidate_mappings(struct dma_buf *dmabuf)
> +{
> +	struct dma_buf_attachment *attach;
> +
> +	reservation_object_assert_held(dmabuf->resv);
> +
> +	list_for_each_entry(attach, &dmabuf->attachments, node)
> +		attach->invalidate_mappings(attach);

To make the locking work I think we also need to require importers to hold
the reservation object while attaching/detaching. Otherwise the list walk
above could go boom.

We could use the existing dma-buf lock, but I think that'll just result in
deadlocks.

> +}
> +EXPORT_SYMBOL_GPL(dma_buf_invalidate_mappings);
> +
>  /**
>   * DOC: cpu access
>   *
> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> index 085db2fee2d7..c1e2f7d93509 100644
> --- a/include/linux/dma-buf.h
> +++ b/include/linux/dma-buf.h
> @@ -91,6 +91,18 @@ struct dma_buf_ops {
>  	 */
>  	void (*detach)(struct dma_buf *, struct dma_buf_attachment *);
>  
> +	/**
> +	 * @supports_mapping_invalidation:
> +	 *
> +	 * True for exporters which supports unpinned DMA-buf operation using
> +	 * the reservation lock.
> +	 *
> +	 * When attachment->invalidate_mappings is set the @map_dma_buf and
> +	 * @unmap_dma_buf callbacks can be called with the reservation lock
> +	 * held.
> +	 */
> +	bool supports_mapping_invalidation;

Why do we need this? Importer could simply always register with the
invalidate_mapping hook registered, and exporters could use it when they
see fit. That gives us more lockdep coverage to make sure importers use
their attachment callbacks correctly (aka they hold the reservation
object).

> +
>  	/**
>  	 * @map_dma_buf:
>  	 *
> @@ -326,6 +338,29 @@ struct dma_buf_attachment {
>  	struct device *dev;
>  	struct list_head node;
>  	void *priv;
> +
> +	/**
> +	 * @invalidate_mappings:
> +	 *
> +	 * Optional callback provided by the importer of the attachment which
> +	 * must be set before mappings are created.

This doesn't work, it must be set before the attachment is created,
otherwise you race with your invalidate callback.

I think the simplest option would be to add a new dma_buf_attach_dynamic
(well except a less crappy name).

> +	 *
> +	 * If provided the exporter can avoid pinning the backing store while
> +	 * mappings exists.
> +	 *
> +	 * The function is called with the lock of the reservation object
> +	 * associated with the dma_buf held and the mapping function must be
> +	 * called with this lock held as well. This makes sure that no mapping
> +	 * is created concurrently with an ongoing invalidation.
> +	 *
> +	 * After the callback all existing mappings are still valid until all
> +	 * fences in the dma_bufs reservation object are signaled, but should be
> +	 * destroyed by the importer as soon as possible.

Do we guarantee that the importer will attach a fence, after which the
mapping will be gone? What about re-trying? Or just best effort (i.e. only
useful for evicting to try to make room).

I think a helper which both unmaps _and_ waits for all the fences to clear
would be best, with some guarantees that it'll either fail or all the
mappings _will_ be gone. The locking for that one will be hilarious, since
we need to figure out dmabuf->lock vs. the reservation. I kinda prefer we
throw away the dmabuf->lock and superseed it entirely by the reservation
lock.


> +	 *
> +	 * New mappings can be created immediately, but can't be used before the
> +	 * exclusive fence in the dma_bufs reservation object is signaled.
> +	 */
> +	void (*invalidate_mappings)(struct dma_buf_attachment *attach);

Bunch of questions about exact semantics, but I very much like this. And I
think besides those technical details, the overall approach seems sound.
-Daniel

>  };
>  
>  /**
> @@ -391,6 +426,7 @@ struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *,
>  					enum dma_data_direction);
>  void dma_buf_unmap_attachment(struct dma_buf_attachment *, struct sg_table *,
>  				enum dma_data_direction);
> +void dma_buf_invalidate_mappings(struct dma_buf *dma_buf);
>  int dma_buf_begin_cpu_access(struct dma_buf *dma_buf,
>  			     enum dma_data_direction dir);
>  int dma_buf_end_cpu_access(struct dma_buf *dma_buf,
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
