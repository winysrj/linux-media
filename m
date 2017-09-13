Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:54519 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751078AbdIMCP2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Sep 2017 22:15:28 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: kieran.bingham@ideasonboard.com
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 2/8] v4l: vsp1: Provide a fragment pool
Date: Wed, 13 Sep 2017 05:15:29 +0300
Message-ID: <1597664.yeZO11HtTZ@avalon>
In-Reply-To: <ce5f2a44-6d66-2822-450f-ece7f8d819f0@ideasonboard.com>
References: <cover.4457988ad8b64b5c7636e35039ef61d507af3648.1502723341.git-series.kieran.bingham+renesas@ideasonboard.com> <3241934.7ubTCsH5T0@avalon> <ce5f2a44-6d66-2822-450f-ece7f8d819f0@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Monday, 11 September 2017 23:30:25 EEST Kieran Bingham wrote:
> On 17/08/17 13:13, Laurent Pinchart wrote:
> > On Monday 14 Aug 2017 16:13:25 Kieran Bingham wrote:
> >> Each display list allocates a body to store register values in a dma
> >> accessible buffer from a dma_alloc_wc() allocation. Each of these
> >> results in an entry in the TLB, and a large number of display list
> >> allocations adds pressure to this resource.
> >> 
> >> Reduce TLB pressure on the IPMMUs by allocating multiple display list
> >> bodies in a single allocation, and providing these to the display list
> >> through a 'fragment pool'. A pool can be allocated by the display list
> >> manager or entities which require their own body allocations.
> >> 
> >> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> >> 
> >> ---
> >> 
> >> v2:
> >>  - assign dlb->dma correctly
> >> 
> >> ---
> >> 
> >>  drivers/media/platform/vsp1/vsp1_dl.c | 129 +++++++++++++++++++++++++++-
> >>  drivers/media/platform/vsp1/vsp1_dl.h |   8 ++-
> >>  2 files changed, 137 insertions(+)
> >> 
> >> diff --git a/drivers/media/platform/vsp1/vsp1_dl.c
> >> b/drivers/media/platform/vsp1/vsp1_dl.c index cb4625ae13c2..aab9dd6ec0eb
> >> 100644
> >> --- a/drivers/media/platform/vsp1/vsp1_dl.c
> >> +++ b/drivers/media/platform/vsp1/vsp1_dl.c

[snip]

> >>  /*
> >> + * Fragment pool's reduce the pressure on the iommu TLB by allocating a
> >> single
> >> + * large area of DMA memory and allocating it as a pool of fragment
> >> bodies
> >> + */
> > 
> > Could you document non-static function using kerneldoc ? Parameters to
> > this function would benefit from some documentation. I'd also like to see
> > the fragment get/put functions documented, as you remove existing
> > kerneldoc for the alloc/free existing functions in patch 3/8.
> 
> Ah yes of course.
> 
> >> +struct vsp1_dl_fragment_pool *
> >> +vsp1_dl_fragment_pool_alloc(struct vsp1_device *vsp1, unsigned int qty,
> > 
> > I think I would name this function vsp1_dl_fragment_pool_create(), as it
> > does more than just allocating memory. Similarly I'd call the free
> > function vsp1_dl_fragment_pool_destroy().
> 
> That sounds reasonable. Done.
> 
> > qty is a bit vague, I'd rename it to num_fragments.
> 
> Ok with me.
> 
> >> +			    unsigned int num_entries, size_t extra_size)
> >> +{
> >> +	struct vsp1_dl_fragment_pool *pool;
> >> +	size_t dlb_size;
> >> +	unsigned int i;
> >> +
> >> +	pool = kzalloc(sizeof(*pool), GFP_KERNEL);
> >> +	if (!pool)
> >> +		return NULL;
> >> +
> >> +	pool->vsp1 = vsp1;
> >> +
> >> +	dlb_size = num_entries * sizeof(struct vsp1_dl_entry) + extra_size;
> > 
> > extra_size is only used by vsp1_dlm_create(), to allocate extra memory for
> > the display list header. We need one header per display list, not per
> > display list body.
> 
> Good catch, that will take a little bit of reworking.

I didn't propose a fix for this as I wasn't sure how to fix it properly. I 
thus won't complain too loudly if you can't fix it either and waste a bit of 
memory :-) But in that case please add a comment to explain what's going on.

> >> +	pool->size = dlb_size * qty;
> >> +
> >> +	pool->bodies = kcalloc(qty, sizeof(*pool->bodies), GFP_KERNEL);
> >> +	if (!pool->bodies) {
> >> +		kfree(pool);
> >> +		return NULL;
> >> +	}
> >> +
> >> +	pool->mem = dma_alloc_wc(vsp1->bus_master, pool->size, &pool->dma,
> >> +					    GFP_KERNEL);
> > 
> > This is a weird indentation.
> 
> I know! - Not sure how that slipped by :)
> 
> >> +	if (!pool->mem) {
> >> +		kfree(pool->bodies);
> >> +		kfree(pool);
> >> +		return NULL;
> >> +	}
> >> +
> >> +	spin_lock_init(&pool->lock);
> >> +	INIT_LIST_HEAD(&pool->free);
> >> +
> >> +	for (i = 0; i < qty; ++i) {
> >> +		struct vsp1_dl_body *dlb = &pool->bodies[i];
> >> +
> >> +		dlb->pool = pool;
> >> +		dlb->max_entries = num_entries;
> >> +
> >> +		dlb->dma = pool->dma + i * dlb_size;
> >> +		dlb->entries = pool->mem + i * dlb_size;
> >> +
> >> +		list_add_tail(&dlb->free, &pool->free);
> >> +	}
> >> +
> >> +	return pool;
> >> +}
> >> +
> >> +void vsp1_dl_fragment_pool_free(struct vsp1_dl_fragment_pool *pool)
> >> +{
> >> +	if (!pool)
> >> +		return;
> > 
> > Can this happen ?
> 
> I was mirroring 'kfree()' support here ... such that error paths can be
> simple.
> 
> Would you prefer that it's required to be valid (non-null) pointer?
> 
> Actually - I think it is better to leave this for now - as we now call this
> function from the .destroy() entity functions ...

It was a genuine question :-) We have more control over the 
vsp1_dl_fragment_pool_free() callers as the function is internal to the 
driver. If we have real use cases for pool being NULL then let's keep the 
check.

> >> +
> >> +	if (pool->mem)
> >> +		dma_free_wc(pool->vsp1->bus_master, pool->size, pool->mem,
> >> +			    pool->dma);
> >> +
> >> +	kfree(pool->bodies);
> >> +	kfree(pool);
> >> +}

[snip]

-- 
Regards,

Laurent Pinchart
