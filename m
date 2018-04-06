Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:36140 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751956AbeDFWzI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 6 Apr 2018 18:55:08 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v7 4/8] media: vsp1: Convert display lists to use new body pool
Date: Sat, 07 Apr 2018 01:55:06 +0300
Message-ID: <5870132.rZqSaTkXFy@avalon>
In-Reply-To: <2ee9fcdd1ca50a51b9d5215f990fd7f1ac831ad3.1520466993.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.636c1ee27fc6973cc312e0f25131a435872a0a35.1520466993.git-series.kieran.bingham+renesas@ideasonboard.com> <2ee9fcdd1ca50a51b9d5215f990fd7f1ac831ad3.1520466993.git-series.kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Thursday, 8 March 2018 02:05:27 EEST Kieran Bingham wrote:
> Adapt the dl->body0 object to use an object from the body pool. This
> greatly reduces the pressure on the TLB for IPMMU use cases, as all of
> the lists use a single allocation for the main body.
> 
> The CLU and LUT objects pre-allocate a pool containing three bodies,
> allowing a userspace update before the hardware has committed a previous
> set of tables.
> 
> Bodies are no longer 'freed' in interrupt context, but instead released
> back to their respective pools. This allows us to remove the garbage
> collector in the DLM.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> ---
> v3:
>  - 's/fragment/body', 's/fragments/bodies/'
>  - CLU/LUT now allocate 3 bodies
>  - vsp1_dl_list_fragments_free -> vsp1_dl_list_bodies_put
> 
> v2:
>  - Use dl->body0->max_entries to determine header offset, instead of the
>    global constant VSP1_DL_NUM_ENTRIES which is incorrect.
>  - squash updates for LUT, CLU, and fragment cleanup into single patch.
>    (Not fully bisectable when separated)
> 
>  drivers/media/platform/vsp1/vsp1_clu.c |  27 ++-
>  drivers/media/platform/vsp1/vsp1_clu.h |   1 +-
>  drivers/media/platform/vsp1/vsp1_dl.c  | 223 ++++++--------------------
>  drivers/media/platform/vsp1/vsp1_dl.h  |   3 +-
>  drivers/media/platform/vsp1/vsp1_lut.c |  27 ++-
>  drivers/media/platform/vsp1/vsp1_lut.h |   1 +-
>  6 files changed, 101 insertions(+), 181 deletions(-)

Still a nice diffstart :-)

[snip]

> diff --git a/drivers/media/platform/vsp1/vsp1_dl.c
> b/drivers/media/platform/vsp1/vsp1_dl.c index 0208e72cb356..74476726451c
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_dl.c
> +++ b/drivers/media/platform/vsp1/vsp1_dl.c

[snip]

> @@ -399,11 +311,10 @@ void vsp1_dl_body_write(struct vsp1_dl_body *dlb, u32
> reg, u32 data) * Display List Transaction Management
>   */
> 
> -static struct vsp1_dl_list *vsp1_dl_list_alloc(struct vsp1_dl_manager *dlm)
> +static struct vsp1_dl_list *vsp1_dl_list_alloc(struct vsp1_dl_manager
> *dlm,
> +					       struct vsp1_dl_body_pool *pool)

Given that the only caller of this function passes dlm->pool as the second 
argument, can't you remove the second argument ?

>  {
>  	struct vsp1_dl_list *dl;
> -	size_t header_size;
> -	int ret;
> 
>  	dl = kzalloc(sizeof(*dl), GFP_KERNEL);
>  	if (!dl)
> @@ -412,41 +323,39 @@ static struct vsp1_dl_list *vsp1_dl_list_alloc(struct
> vsp1_dl_manager *dlm) INIT_LIST_HEAD(&dl->bodies);
>  	dl->dlm = dlm;
> 
> -	/*
> -	 * Initialize the display list body and allocate DMA memory for the body
> -	 * and the optional header. Both are allocated together to avoid memory
> -	 * fragmentation, with the header located right after the body in
> -	 * memory.
> -	 */
> -	header_size = dlm->mode == VSP1_DL_MODE_HEADER
> -		    ? ALIGN(sizeof(struct vsp1_dl_header), 8)
> -		    : 0;
> -
> -	ret = vsp1_dl_body_init(dlm->vsp1, &dl->body0, VSP1_DL_NUM_ENTRIES,
> -				header_size);
> -	if (ret < 0) {
> -		kfree(dl);
> +	/* Retrieve a body from our DLM body pool */

s/body pool/body pool./

(And I would have said "Get a body" but that's up to you)

> +	dl->body0 = vsp1_dl_body_get(pool);
> +	if (!dl->body0)
>  		return NULL;
> -	}
> -
>  	if (dlm->mode == VSP1_DL_MODE_HEADER) {
> -		size_t header_offset = VSP1_DL_NUM_ENTRIES
> -				     * sizeof(*dl->body0.entries);
> +		size_t header_offset = dl->body0->max_entries
> +				     * sizeof(*dl->body0->entries);
> 
> -		dl->header = ((void *)dl->body0.entries) + header_offset;
> -		dl->dma = dl->body0.dma + header_offset;
> +		dl->header = ((void *)dl->body0->entries) + header_offset;
> +		dl->dma = dl->body0->dma + header_offset;
> 
>  		memset(dl->header, 0, sizeof(*dl->header));
> -		dl->header->lists[0].addr = dl->body0.dma;
> +		dl->header->lists[0].addr = dl->body0->dma;
>  	}
> 
>  	return dl;
>  }
> 
> +static void vsp1_dl_list_bodies_put(struct vsp1_dl_list *dl)
> +{
> +	struct vsp1_dl_body *dlb, *tmp;
> +
> +	list_for_each_entry_safe(dlb, tmp, &dl->bodies, list) {
> +		list_del(&dlb->list);
> +		vsp1_dl_body_put(dlb);
> +	}
> +}
> +
>  static void vsp1_dl_list_free(struct vsp1_dl_list *dl)
>  {
> -	vsp1_dl_body_cleanup(&dl->body0);
> -	list_splice_init(&dl->bodies, &dl->dlm->gc_bodies);
> +	vsp1_dl_body_put(dl->body0);
> +	vsp1_dl_list_bodies_put(dl);

Too bad we can't keep the list splice, it's more efficient than iterating over 
the list, but I suppose it's unavoidable if we want to reset the number of 
used entries to 0 for each body. Beside, we should have a small number of 
bodies only, so hopefully it won't be a big deal.

> +
>  	kfree(dl);
>  }
> 
> @@ -500,18 +409,13 @@ static void __vsp1_dl_list_put(struct vsp1_dl_list
> *dl)
> 
>  	dl->has_chain = false;
> 
> +	vsp1_dl_list_bodies_put(dl);
> +
>  	/*
> -	 * We can't free bodies here as DMA memory can only be freed in
> -	 * interruptible context. Move all bodies to the display list manager's
> -	 * list of bodies to be freed, they will be garbage-collected by the
> -	 * work queue.
> +	 * body0 is reused as as an optimisation as presently every display list
> +	 * has at least one body, thus we reinitialise the entries list

s/entries list/entries list./

>  	 */
> -	if (!list_empty(&dl->bodies)) {
> -		list_splice_init(&dl->bodies, &dl->dlm->gc_bodies);
> -		schedule_work(&dl->dlm->gc_work);
> -	}

We can certainly do this synchronously now that we don't need to free memory 
anymore. I wonder however about the potential performance impact, as there's a 
kfree() in vsp1_dl_list_free(). Do you think it could have a noticeable impact 
on the time spent with interrupts disabled ?

> -
> -	dl->body0.num_entries = 0;
> +	dl->body0->num_entries = 0;
> 
>  	list_add_tail(&dl->list, &dl->dlm->free);
>  }
> @@ -548,7 +452,7 @@ void vsp1_dl_list_put(struct vsp1_dl_list *dl)
>   */
>  void vsp1_dl_list_write(struct vsp1_dl_list *dl, u32 reg, u32 data)
>  {
> -	vsp1_dl_body_write(&dl->body0, reg, data);
> +	vsp1_dl_body_write(dl->body0, reg, data);
>  }
> 
>  /**
> @@ -561,8 +465,7 @@ void vsp1_dl_list_write(struct vsp1_dl_list *dl, u32
> reg, u32 data)
>   * in the order in which bodies are added.
>   *
>   * Adding a body to a display list passes ownership of the body to the
> list. The
> - * caller must not touch the body after this call, and must not free it
> - * explicitly with vsp1_dl_body_free().

Shouldn't we keep the last part of the sentence and adapt it ? Maybe something 
like

	and must not release it explicitly with vsp1_dl_body_put().

I know that you introduce a reference count in the next patches that would 
make this comment invalid, up to this patch it should be correct. When 
introducing reference-counting you can update the comment to state that the 
reference must be released.

> + * caller must not touch the body after this call.
>   *
>   * Additional bodies are only usable for display lists in header mode.
>   * Attempting to add a body to a header-less display list will return an
> error. @@ -620,7 +523,7 @@ static void vsp1_dl_list_fill_header(struct
> vsp1_dl_list *dl, bool is_last)
>   * list was allocated.
>  	 */
> 
> -	hdr->num_bytes = dl->body0.num_entries
> +	hdr->num_bytes = dl->body0->num_entries
>  		       * sizeof(*dl->header->lists);
> 
>  	list_for_each_entry(dlb, &dl->bodies, list) {
> @@ -694,9 +597,9 @@ static void vsp1_dl_list_hw_enqueue(struct vsp1_dl_list
> *dl) * bit will be cleared by the hardware when the display list
>  		 * processing starts.
>  		 */
> -		vsp1_write(vsp1, VI6_DL_HDR_ADDR(0), dl->body0.dma);
> +		vsp1_write(vsp1, VI6_DL_HDR_ADDR(0), dl->body0->dma);
>  		vsp1_write(vsp1, VI6_DL_BODY_SIZE, VI6_DL_BODY_SIZE_UPD |
> -			   (dl->body0.num_entries * sizeof(*dl->header->lists)));
> +			(dl->body0->num_entries * sizeof(*dl->header->lists)));
>  	} else {
>  		/*
>  		 * In header mode, program the display list header address. If
> @@ -879,45 +782,12 @@ void vsp1_dlm_reset(struct vsp1_dl_manager *dlm)
>  	dlm->pending = NULL;
>  }
> 
> -/*
> - * Free all bodies awaiting to be garbage-collected.
> - *
> - * This function must be called without the display list manager lock held.
> - */
> -static void vsp1_dlm_bodies_free(struct vsp1_dl_manager *dlm)
> -{
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&dlm->lock, flags);
> -
> -	while (!list_empty(&dlm->gc_bodies)) {
> -		struct vsp1_dl_body *dlb;
> -
> -		dlb = list_first_entry(&dlm->gc_bodies, struct vsp1_dl_body,
> -				       list);
> -		list_del(&dlb->list);
> -
> -		spin_unlock_irqrestore(&dlm->lock, flags);
> -		vsp1_dl_body_free(dlb);
> -		spin_lock_irqsave(&dlm->lock, flags);
> -	}
> -
> -	spin_unlock_irqrestore(&dlm->lock, flags);
> -}
> -
> -static void vsp1_dlm_garbage_collect(struct work_struct *work)
> -{
> -	struct vsp1_dl_manager *dlm =
> -		container_of(work, struct vsp1_dl_manager, gc_work);
> -
> -	vsp1_dlm_bodies_free(dlm);
> -}
> -
>  struct vsp1_dl_manager *vsp1_dlm_create(struct vsp1_device *vsp1,
>  					unsigned int index,
>  					unsigned int prealloc)
>  {
>  	struct vsp1_dl_manager *dlm;
> +	size_t header_size;
>  	unsigned int i;
> 
>  	dlm = devm_kzalloc(vsp1->dev, sizeof(*dlm), GFP_KERNEL);
> @@ -932,13 +802,26 @@ struct vsp1_dl_manager *vsp1_dlm_create(struct
> vsp1_device *vsp1,
> 
>  	spin_lock_init(&dlm->lock);
>  	INIT_LIST_HEAD(&dlm->free);
> -	INIT_LIST_HEAD(&dlm->gc_bodies);
> -	INIT_WORK(&dlm->gc_work, vsp1_dlm_garbage_collect);
> +
> +	/*
> +	 * Initialize the display list body and allocate DMA memory for the body
> +	 * and the optional header. Both are allocated together to avoid memory
> +	 * fragmentation, with the header located right after the body in
> +	 * memory.
> +	 */
> +	header_size = dlm->mode == VSP1_DL_MODE_HEADER
> +		    ? ALIGN(sizeof(struct vsp1_dl_header), 8)
> +		    : 0;
> +
> +	dlm->pool = vsp1_dl_body_pool_create(vsp1, prealloc,
> +					     VSP1_DL_NUM_ENTRIES, header_size);
> +	if (!dlm->pool)
> +		return NULL;
> 
>  	for (i = 0; i < prealloc; ++i) {
>  		struct vsp1_dl_list *dl;
> 
> -		dl = vsp1_dl_list_alloc(dlm);
> +		dl = vsp1_dl_list_alloc(dlm, dlm->pool);
>  		if (!dl)
>  			return NULL;
> 
> @@ -955,12 +838,10 @@ void vsp1_dlm_destroy(struct vsp1_dl_manager *dlm)
>  	if (!dlm)
>  		return;
> 
> -	cancel_work_sync(&dlm->gc_work);
> -
>  	list_for_each_entry_safe(dl, next, &dlm->free, list) {
>  		list_del(&dl->list);
>  		vsp1_dl_list_free(dl);
>  	}
> 
> -	vsp1_dlm_bodies_free(dlm);
> +	vsp1_dl_body_pool_destroy(dlm->pool);
>  }

[snip]

-- 
Regards,

Laurent Pinchart
