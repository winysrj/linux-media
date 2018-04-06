Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:36107 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751711AbeDFWdl (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 6 Apr 2018 18:33:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v7 3/8] media: vsp1: Provide a body pool
Date: Sat, 07 Apr 2018 01:33:40 +0300
Message-ID: <1646405.Bdlv5Bo0GY@avalon>
In-Reply-To: <9f8fb55c1811825884ab620d2956e0036147bc26.1520466993.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.636c1ee27fc6973cc312e0f25131a435872a0a35.1520466993.git-series.kieran.bingham+renesas@ideasonboard.com> <9f8fb55c1811825884ab620d2956e0036147bc26.1520466993.git-series.kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Thursday, 8 March 2018 02:05:26 EEST Kieran Bingham wrote:
> Each display list allocates a body to store register values in a dma
> accessible buffer from a dma_alloc_wc() allocation. Each of these
> results in an entry in the TLB, and a large number of display list

I'd write it as "IOMMU TLB" to make it clear we're not concerned about CPU MMU 
TLB pressure.

> allocations adds pressure to this resource.
> 
> Reduce TLB pressure on the IPMMUs by allocating multiple display list
> bodies in a single allocation, and providing these to the display list
> through a 'body pool'. A pool can be allocated by the display list
> manager or entities which require their own body allocations.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> ---
> v4:
>  - Provide comment explaining extra allocation on body pool
>    highlighting area for optimisation later.
> 
> v3:
>  - s/fragment/body/, s/fragments/bodies/
>  - qty -> num_bodies
>  - indentation fix
>  - s/vsp1_dl_body_pool_{alloc,free}/vsp1_dl_body_pool_{create,destroy}/'
>  - Add kerneldoc to non-static functions
> 
> v2:
>  - assign dlb->dma correctly
> 
>  drivers/media/platform/vsp1/vsp1_dl.c | 163 +++++++++++++++++++++++++++-
>  drivers/media/platform/vsp1/vsp1_dl.h |   8 +-
>  2 files changed, 171 insertions(+)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_dl.c
> b/drivers/media/platform/vsp1/vsp1_dl.c index 67cc16c1b8e3..0208e72cb356
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_dl.c
> +++ b/drivers/media/platform/vsp1/vsp1_dl.c
> @@ -45,6 +45,8 @@ struct vsp1_dl_entry {
>  /**
>   * struct vsp1_dl_body - Display list body
>   * @list: entry in the display list list of bodies
> + * @free: entry in the pool free body list

Could we reuse @list for this purpose ? Unless I'm mistaken, when a body is in 
a pool it doesn't belong to any particular display list, and when it is in a 
display list it isn't in the pool anymore.

> + * @pool: pool to which this body belongs
>   * @vsp1: the VSP1 device
>   * @entries: array of entries
>   * @dma: DMA address of the entries
> @@ -54,6 +56,9 @@ struct vsp1_dl_entry {
>   */
>  struct vsp1_dl_body {
>  	struct list_head list;
> +	struct list_head free;
> +
> +	struct vsp1_dl_body_pool *pool;
>  	struct vsp1_device *vsp1;
> 
>  	struct vsp1_dl_entry *entries;
> @@ -65,6 +70,30 @@ struct vsp1_dl_body {
>  };
> 
>  /**
> + * struct vsp1_dl_body_pool - display list body pool
> + * @dma: DMA address of the entries
> + * @size: size of the full DMA memory pool in bytes
> + * @mem: CPU memory pointer for the pool
> + * @bodies: Array of DLB structures for the pool
> + * @free: List of free DLB entries
> + * @lock: Protects the pool and free list

The pool and free list ? As far as I can tell the lock only protects the free 
list.

> + * @vsp1: the VSP1 device
> + */
> +struct vsp1_dl_body_pool {
> +	/* DMA allocation */
> +	dma_addr_t dma;
> +	size_t size;
> +	void *mem;
> +
> +	/* Body management */
> +	struct vsp1_dl_body *bodies;
> +	struct list_head free;
> +	spinlock_t lock;
> +
> +	struct vsp1_device *vsp1;
> +};
> +
> +/**
>   * struct vsp1_dl_list - Display list
>   * @list: entry in the display list manager lists
>   * @dlm: the display list manager
> @@ -105,6 +134,7 @@ enum vsp1_dl_mode {
>   * @active: list currently being processed (loaded) by hardware
>   * @queued: list queued to the hardware (written to the DL registers)
>   * @pending: list waiting to be queued to the hardware
> + * @pool: body pool for the display list bodies
>   * @gc_work: bodies garbage collector work struct
>   * @gc_bodies: array of display list bodies waiting to be freed
>   */
> @@ -120,6 +150,8 @@ struct vsp1_dl_manager {
>  	struct vsp1_dl_list *queued;
>  	struct vsp1_dl_list *pending;
> 
> +	struct vsp1_dl_body_pool *pool;
> +
>  	struct work_struct gc_work;
>  	struct list_head gc_bodies;
>  };
> @@ -128,6 +160,137 @@ struct vsp1_dl_manager {
>   * Display List Body Management
>   */
> 
> +/**
> + * vsp1_dl_body_pool_create - Create a pool of bodies from a single
> allocation
> + * @vsp1: The VSP1 device
> + * @num_bodies: The quantity of bodies to allocate

For consistency, s/quantity/number/

> + * @num_entries: The maximum number of entries that the body can contain

Maybe s/the body/a body/ ?

> + * @extra_size: Extra allocation provided for the bodies
> + *
> + * Allocate a pool of display list bodies each with enough memory to
> contain the
> + * requested number of entries.

How about

the requested number of entries plus the @extra_size.

> + *
> + * Return a pointer to a pool on success or NULL if memory can't be
> allocated.
> + */
> +struct vsp1_dl_body_pool *
> +vsp1_dl_body_pool_create(struct vsp1_device *vsp1, unsigned int num_bodies,
> +			 unsigned int num_entries, size_t extra_size)
> +{
> +	struct vsp1_dl_body_pool *pool;
> +	size_t dlb_size;
> +	unsigned int i;
> +
> +	pool = kzalloc(sizeof(*pool), GFP_KERNEL);
> +	if (!pool)
> +		return NULL;
> +
> +	pool->vsp1 = vsp1;
> +
> +	/*
> +	 * Todo: 'extra_size' is only used by vsp1_dlm_create(), to allocate

s/Todo/TODO/

> +	 * extra memory for the display list header. We need only one header per
> +	 * display list, not per display list body, thus this allocation is
> +	 * extraneous and should be reworked in the future.
> +	 */

Any plan to fix this ? :-)

> +	dlb_size = num_entries * sizeof(struct vsp1_dl_entry) + extra_size;
> +	pool->size = dlb_size * num_bodies;
> +
> +	pool->bodies = kcalloc(num_bodies, sizeof(*pool->bodies), GFP_KERNEL);
> +	if (!pool->bodies) {
> +		kfree(pool);
> +		return NULL;
> +	}
> +
> +	pool->mem = dma_alloc_wc(vsp1->bus_master, pool->size, &pool->dma,
> +				 GFP_KERNEL);
> +	if (!pool->mem) {
> +		kfree(pool->bodies);
> +		kfree(pool);
> +		return NULL;
> +	}
> +
> +	spin_lock_init(&pool->lock);
> +	INIT_LIST_HEAD(&pool->free);
> +
> +	for (i = 0; i < num_bodies; ++i) {
> +		struct vsp1_dl_body *dlb = &pool->bodies[i];
> +
> +		dlb->pool = pool;
> +		dlb->max_entries = num_entries;
> +
> +		dlb->dma = pool->dma + i * dlb_size;
> +		dlb->entries = pool->mem + i * dlb_size;
> +
> +		list_add_tail(&dlb->free, &pool->free);
> +	}
> +
> +	return pool;
> +}
> +
> +/**
> + * vsp1_dl_body_pool_destroy - Release a body pool
> + * @pool: The body pool
> + *
> + * Release all components of a pool allocation.
> + */
> +void vsp1_dl_body_pool_destroy(struct vsp1_dl_body_pool *pool)
> +{
> +	if (!pool)
> +		return;
> +
> +	if (pool->mem)
> +		dma_free_wc(pool->vsp1->bus_master, pool->size, pool->mem,
> +			    pool->dma);
> +
> +	kfree(pool->bodies);
> +	kfree(pool);
> +}
> +
> +/**
> + * vsp1_dl_body_get - Obtain a body from a pool
> + * @pool: The body pool
> + *
> + * Obtain a body from the pool allocation without blocking.

"the pool allocation" ? Did you mean just "the pool" ?

> + *
> + * Returns a display list body or NULL if there are none available.
> + */
> +struct vsp1_dl_body *vsp1_dl_body_get(struct vsp1_dl_body_pool *pool)
> +{
> +	struct vsp1_dl_body *dlb = NULL;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&pool->lock, flags);
> +
> +	if (!list_empty(&pool->free)) {
> +		dlb = list_first_entry(&pool->free, struct vsp1_dl_body, free);
> +		list_del(&dlb->free);
> +	}
> +
> +	spin_unlock_irqrestore(&pool->lock, flags);
> +
> +	return dlb;
> +}
> +
> +/**
> + * vsp1_dl_body_put - Return a body back to its pool
> + * @dlb: The display list body
> + *
> + * Return a body back to the pool, and reset the num_entries to clear the
> list.
> + */
> +void vsp1_dl_body_put(struct vsp1_dl_body *dlb)
> +{
> +	unsigned long flags;
> +
> +	if (!dlb)
> +		return;
> +
> +	dlb->num_entries = 0;
> +
> +	spin_lock_irqsave(&dlb->pool->lock, flags);
> +	list_add_tail(&dlb->free, &dlb->pool->free);
> +	spin_unlock_irqrestore(&dlb->pool->lock, flags);
> +}
> +
>  /*
>   * Initialize a display list body object and allocate DMA memory for the
> body * data. The display list body object is expected to have been
> initialized to diff --git a/drivers/media/platform/vsp1/vsp1_dl.h
> b/drivers/media/platform/vsp1/vsp1_dl.h index cf57f986b69a..031032e304d2
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_dl.h
> +++ b/drivers/media/platform/vsp1/vsp1_dl.h
> @@ -17,6 +17,7 @@
> 
>  struct vsp1_device;
>  struct vsp1_dl_body;
> +struct vsp1_dl_body_pool;
>  struct vsp1_dl_list;
>  struct vsp1_dl_manager;
> 
> @@ -34,6 +35,13 @@ void vsp1_dl_list_put(struct vsp1_dl_list *dl);
>  void vsp1_dl_list_write(struct vsp1_dl_list *dl, u32 reg, u32 data);
>  void vsp1_dl_list_commit(struct vsp1_dl_list *dl);
> 
> +struct vsp1_dl_body_pool *
> +vsp1_dl_body_pool_create(struct vsp1_device *vsp1, unsigned int num_bodies,
> +			 unsigned int num_entries, size_t extra_size);
> +void vsp1_dl_body_pool_destroy(struct vsp1_dl_body_pool *pool);
> +struct vsp1_dl_body *vsp1_dl_body_get(struct vsp1_dl_body_pool *pool);
> +void vsp1_dl_body_put(struct vsp1_dl_body *dlb);
> +
>  struct vsp1_dl_body *vsp1_dl_body_alloc(struct vsp1_device *vsp1,
>  					unsigned int num_entries);
>  void vsp1_dl_body_free(struct vsp1_dl_body *dlb);


-- 
Regards,

Laurent Pinchart
