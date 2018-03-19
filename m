Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:38717 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933458AbeCSOE2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Mar 2018 10:04:28 -0400
Received: by mail-wm0-f67.google.com with SMTP id l16so6581975wmh.3
        for <linux-media@vger.kernel.org>; Mon, 19 Mar 2018 07:04:27 -0700 (PDT)
Date: Mon, 19 Mar 2018 15:04:23 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Christian =?iso-8859-1?Q?K=F6nig?=
        <ckoenig.leichtzumerken@gmail.com>
Cc: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org
Subject: Re: [PATCH 1/5] dma-buf: add optional invalidate_mappings callback v2
Message-ID: <20180319140423.GN14155@phenom.ffwll.local>
References: <20180316132049.1748-1-christian.koenig@amd.com>
 <20180316132049.1748-2-christian.koenig@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180316132049.1748-2-christian.koenig@amd.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 16, 2018 at 02:20:45PM +0100, Christian König wrote:
> Each importer can now provide an invalidate_mappings callback.
> 
> This allows the exporter to provide the mappings without the need to pin
> the backing store.
> 
> v2: don't try to invalidate mappings when the callback is NULL,
>     lock the reservation obj while using the attachments,
>     add helper to set the callback
> 
> Signed-off-by: Christian König <christian.koenig@amd.com>

Replying here to avoid thread split, but not entirely related.

I thought some more about the lockdep splat discussion, and specifically
that amdgpu needs the reservations for the vm objects when doing a gpu
reset.

Since they're in the same ww_class as all other dma-buf reservations I'm
pretty sure lockdep will complain, at least when cross-release lockdep and
cross-release annotations for dma_fence are merged.

And as long as there's some case where amdgpu needs both the vm object
reservation and other reservations (CS?) then we must have them in the
same class, and in that case the deadlock is real. It'll require an
impressive set of circumstances most likely (the minimal number of threads
we generally needed to actually hit the cross-release stuff was 4+ or
something nuts like that, all doing something else), but it'll be real.

Otoh I think the invalidate stuff here doesn't actually make this worse,
so we can bang our heads against the gpu reset problem at leisure :-)

This stuff here has much more potential to interact badly with core mm
paths, and anything related to that (which ime also means all the cpu
hotplug machinery, which includes suspend/resume, and anything related to
the vfs because someone always manages to drag sysfs into the picture).

It's going to be fun times.

Cheers, Daniel
> ---
>  drivers/dma-buf/dma-buf.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/dma-buf.h   | 38 ++++++++++++++++++++++++++++++
>  2 files changed, 98 insertions(+)
> 
> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index d78d5fc173dc..ed2b3559ba25 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -572,7 +572,9 @@ struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf,
>  		if (ret)
>  			goto err_attach;
>  	}
> +	reservation_object_lock(dmabuf->resv, NULL);
>  	list_add(&attach->node, &dmabuf->attachments);
> +	reservation_object_unlock(dmabuf->resv);
>  
>  	mutex_unlock(&dmabuf->lock);
>  	return attach;
> @@ -598,7 +600,9 @@ void dma_buf_detach(struct dma_buf *dmabuf, struct dma_buf_attachment *attach)
>  		return;
>  
>  	mutex_lock(&dmabuf->lock);
> +	reservation_object_lock(dmabuf->resv, NULL);
>  	list_del(&attach->node);
> +	reservation_object_unlock(dmabuf->resv);
>  	if (dmabuf->ops->detach)
>  		dmabuf->ops->detach(dmabuf, attach);
>  
> @@ -632,10 +636,23 @@ struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *attach,
>  	if (WARN_ON(!attach || !attach->dmabuf))
>  		return ERR_PTR(-EINVAL);
>  
> +	/*
> +	 * Mapping a DMA-buf can trigger its invalidation, prevent sending this
> +	 * event to the caller by temporary removing this attachment from the
> +	 * list.
> +	 */
> +	if (attach->invalidate_mappings) {
> +		reservation_object_assert_held(attach->dmabuf->resv);
> +		list_del(&attach->node);
> +	}
> +
>  	sg_table = attach->dmabuf->ops->map_dma_buf(attach, direction);
>  	if (!sg_table)
>  		sg_table = ERR_PTR(-ENOMEM);
>  
> +	if (attach->invalidate_mappings)
> +		list_add(&attach->node, &attach->dmabuf->attachments);
> +
>  	return sg_table;
>  }
>  EXPORT_SYMBOL_GPL(dma_buf_map_attachment);
> @@ -656,6 +673,9 @@ void dma_buf_unmap_attachment(struct dma_buf_attachment *attach,
>  {
>  	might_sleep();
>  
> +	if (attach->invalidate_mappings)
> +		reservation_object_assert_held(attach->dmabuf->resv);
> +
>  	if (WARN_ON(!attach || !attach->dmabuf || !sg_table))
>  		return;
>  
> @@ -664,6 +684,44 @@ void dma_buf_unmap_attachment(struct dma_buf_attachment *attach,
>  }
>  EXPORT_SYMBOL_GPL(dma_buf_unmap_attachment);
>  
> +/**
> + * dma_buf_set_invalidate_callback - set the invalidate_mappings callback
> + *
> + * @attach:	[in]	attachment where to set the callback
> + * @cb:		[in]	the callback to set
> + *
> + * Makes sure to take the appropriate locks when updating the invalidate
> + * mappings callback.
> + */
> +void dma_buf_set_invalidate_callback(struct dma_buf_attachment *attach,
> +				     void (*cb)(struct dma_buf_attachment *))
> +{
> +	reservation_object_lock(attach->dmabuf->resv, NULL);
> +	attach->invalidate_mappings = cb;
> +	reservation_object_unlock(attach->dmabuf->resv);
> +}
> +EXPORT_SYMBOL_GPL(dma_buf_set_invalidate_callback);
> +
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
> +		if (attach->invalidate_mappings)
> +			attach->invalidate_mappings(attach);
> +}
> +EXPORT_SYMBOL_GPL(dma_buf_invalidate_mappings);
> +
>  /**
>   * DOC: cpu access
>   *
> @@ -1121,10 +1179,12 @@ static int dma_buf_debug_show(struct seq_file *s, void *unused)
>  		seq_puts(s, "\tAttached Devices:\n");
>  		attach_count = 0;
>  
> +		reservation_object_lock(buf_obj->resv, NULL);
>  		list_for_each_entry(attach_obj, &buf_obj->attachments, node) {
>  			seq_printf(s, "\t%s\n", dev_name(attach_obj->dev));
>  			attach_count++;
>  		}
> +		reservation_object_unlock(buf_obj->resv);
>  
>  		seq_printf(s, "Total %d devices attached\n\n",
>  				attach_count);
> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> index 085db2fee2d7..70c65fcfe1e3 100644
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
> +	 *
> +	 * New mappings can be created immediately, but can't be used before the
> +	 * exclusive fence in the dma_bufs reservation object is signaled.
> +	 */
> +	void (*invalidate_mappings)(struct dma_buf_attachment *attach);
>  };
>  
>  /**
> @@ -391,6 +426,9 @@ struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *,
>  					enum dma_data_direction);
>  void dma_buf_unmap_attachment(struct dma_buf_attachment *, struct sg_table *,
>  				enum dma_data_direction);
> +void dma_buf_set_invalidate_callback(struct dma_buf_attachment *attach,
> +				     void (*cb)(struct dma_buf_attachment *));
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
