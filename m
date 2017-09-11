Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39364 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751047AbdIKU1o (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Sep 2017 16:27:44 -0400
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH v2 3/8] v4l: vsp1: Convert display lists to use new
 fragment pool
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
References: <cover.4457988ad8b64b5c7636e35039ef61d507af3648.1502723341.git-series.kieran.bingham+renesas@ideasonboard.com>
 <b15a5776bf062f26bdc6ae580414cd9252d900e3.1502723341.git-series.kieran.bingham+renesas@ideasonboard.com>
 <1922275.UObh22kbi7@avalon>
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <1bc44302-c8e0-973c-b7b8-312e24fe27a6@ideasonboard.com>
Date: Mon, 11 Sep 2017 21:27:39 +0100
MIME-Version: 1.0
In-Reply-To: <1922275.UObh22kbi7@avalon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the review

On 17/08/17 13:13, Laurent Pinchart wrote:
> Hi Kieran,
> 
> Thank you for the patch.
> 
> On Monday 14 Aug 2017 16:13:26 Kieran Bingham wrote:
>> Adapt the dl->body0 object to use an object from the fragment pool.
>> This greatly reduces the pressure on the TLB for IPMMU use cases, as
>> all of the lists use a single allocation for the main body.
>>
>> The CLU and LUT objects pre-allocate a pool containing two bodies,
>> allowing a userspace update before the hardware has committed a previous
>> set of tables.
> 
> I think you'll need three bodies, one for the DL queued to the hardware, one 
> for the pending DL and one for the new DL needed when you update the LUT/CLU. 
> Given that the VSP test suite hasn't caught this problem, we also need a new 
> test :-)
> 
>> Fragments are no longer 'freed' in interrupt context, but instead
>> released back to their respective pools.  This allows us to remove the
>> garbage collector in the DLM.
>>
>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>>
>> ---
>> v2:
>>  - Use dl->body0->max_entries to determine header offset, instead of the
>>    global constant VSP1_DL_NUM_ENTRIES which is incorrect.
>>  - squash updates for LUT, CLU, and fragment cleanup into single patch.
>>    (Not fully bisectable when separated)
>> ---
>>  drivers/media/platform/vsp1/vsp1_clu.c |  22 ++-
>>  drivers/media/platform/vsp1/vsp1_clu.h |   1 +-
>>  drivers/media/platform/vsp1/vsp1_dl.c  | 223 +++++---------------------
>>  drivers/media/platform/vsp1/vsp1_dl.h  |   3 +-
>>  drivers/media/platform/vsp1/vsp1_lut.c |  23 ++-
>>  drivers/media/platform/vsp1/vsp1_lut.h |   1 +-
>>  6 files changed, 90 insertions(+), 183 deletions(-)
> 
> This is a nice diffstat, but only if you add kerneldoc for the new functions 
> introduced in patch 2/8, otherwise the overall documentation diffstat looks 
> bad :-)
> 
>> diff --git a/drivers/media/platform/vsp1/vsp1_clu.c
>> b/drivers/media/platform/vsp1/vsp1_clu.c index f2fb26e5ab4e..52c523625e2f
>> 100644
>> --- a/drivers/media/platform/vsp1/vsp1_clu.c
>> +++ b/drivers/media/platform/vsp1/vsp1_clu.c
> 
> [snip]
> 
>> @@ -288,6 +298,12 @@ struct vsp1_clu *vsp1_clu_create(struct vsp1_device
>> *vsp1) if (ret < 0)
>>  		return ERR_PTR(ret);
>>
>> +	/* Allocate a fragment pool */
> 
> The comment would be more useful if you explained why you need to allocate a 
> pool here. Same comment for the LUT.

Done

> 
>> +	clu->pool = vsp1_dl_fragment_pool_alloc(clu->entity.vsp1, 2,
>> +						CLU_SIZE + 1, 0);
>> +	if (!clu->pool)
>> +		return ERR_PTR(-ENOMEM);
>> +
>>  	/* Initialize the control handler. */
>>  	v4l2_ctrl_handler_init(&clu->ctrls, 2);
>>  	v4l2_ctrl_new_custom(&clu->ctrls, &clu_table_control, NULL);
> 
> [snip]
> 
>> diff --git a/drivers/media/platform/vsp1/vsp1_dl.c
>> b/drivers/media/platform/vsp1/vsp1_dl.c index aab9dd6ec0eb..6ffdc3549283
>> 100644
>> --- a/drivers/media/platform/vsp1/vsp1_dl.c
>> +++ b/drivers/media/platform/vsp1/vsp1_dl.c
> 
> [snip]
> 
> 
>> @@ -379,41 +289,39 @@ static struct vsp1_dl_list *vsp1_dl_list_alloc(struct
>> vsp1_dl_manager *dlm) INIT_LIST_HEAD(&dl->fragments);
>>  	dl->dlm = dlm;
>>
>> -	/*
>> -	 * Initialize the display list body and allocate DMA memory for the 
> body
>> -	 * and the optional header. Both are allocated together to avoid 
> memory
>> -	 * fragmentation, with the header located right after the body in
>> -	 * memory.
>> -	 */
>> -	header_size = dlm->mode == VSP1_DL_MODE_HEADER
>> -		    ? ALIGN(sizeof(struct vsp1_dl_header), 8)
>> -		    : 0;
>> -
>> -	ret = vsp1_dl_body_init(dlm->vsp1, &dl->body0, VSP1_DL_NUM_ENTRIES,
>> -				header_size);
>> -	if (ret < 0) {
>> -		kfree(dl);
>> +	/* Retrieve a body from our DLM body pool */
>> +	dl->body0 = vsp1_dl_fragment_get(pool);
>> +	if (!dl->body0)
>>  		return NULL;
>> -	}
>> -
>>  	if (dlm->mode == VSP1_DL_MODE_HEADER) {
>> -		size_t header_offset = VSP1_DL_NUM_ENTRIES
>> -				     * sizeof(*dl->body0.entries);
>> +		size_t header_offset = dl->body0->max_entries
>> +				     * sizeof(*dl->body0->entries);
>>
>> -		dl->header = ((void *)dl->body0.entries) + header_offset;
>> -		dl->dma = dl->body0.dma + header_offset;
>> +		dl->header = ((void *)dl->body0->entries) + header_offset;
>> +		dl->dma = dl->body0->dma + header_offset;
>>
>>  		memset(dl->header, 0, sizeof(*dl->header));
>> -		dl->header->lists[0].addr = dl->body0.dma;
>> +		dl->header->lists[0].addr = dl->body0->dma;
>>  	}
>>
>>  	return dl;
>>  }
>>
>> +static void vsp1_dl_list_fragments_free(struct vsp1_dl_list *dl)
> 
> This function doesn't free fragments put puts them back to the free list. I'd 
> call it vsp1_dl_list_fragments_put().
> 

Done

>> +{
>> +	struct vsp1_dl_body *dlb, *tmp;
>> +
>> +	list_for_each_entry_safe(dlb, tmp, &dl->fragments, list) {
>> +		list_del(&dlb->list);
>> +		vsp1_dl_fragment_put(dlb);
>> +	}
>> +}
>> +
>>  static void vsp1_dl_list_free(struct vsp1_dl_list *dl)
>>  {
>> -	vsp1_dl_body_cleanup(&dl->body0);
>> -	list_splice_init(&dl->fragments, &dl->dlm->gc_fragments);
>> +	vsp1_dl_fragment_put(dl->body0);
>> +	vsp1_dl_list_fragments_free(dl);
> 
> I wonder whether the second line is actually needed. vsp1_dl_list_free() is 
> called from vsp1_dlm_destroy() for every entry in the dlm->free list. A DL can 
> only be put in that list by vsp1_dlm_create() or __vsp1_dl_list_put(). The 
> former creates lists with no fragment, while the latter calls 
> vsp1_dl_list_fragments_free() already.
> 
> If you're not entirely sure you could add a WARN_ON(!list_empty(&dl-
>> fragments)) and run the test suite. A comment explaining why the fragments 
> list should already be empty here would be useful too.
> 

You may be right here, but would you object to leaving it in ?

Isn't it correct to ensure that the list is completely cleaned up on release?

Furthermore - I would anticipate that in the future - 'body0' could be removed,
(becoming a fragment) and thus this line would then be required.

## /where 's/fragments/bodies/g' applies to the above text. ##

>> +
>>  	kfree(dl);
>>  }
>>
>> @@ -467,18 +375,10 @@ static void __vsp1_dl_list_put(struct vsp1_dl_list
>> *dl)
>>
>>  	dl->has_chain = false;
>>
>> -	/*
>> -	 * We can't free fragments here as DMA memory can only be freed in
>> -	 * interruptible context. Move all fragments to the display list
>> -	 * manager's list of fragments to be freed, they will be
>> -	 * garbage-collected by the work queue.
>> -	 */
>> -	if (!list_empty(&dl->fragments)) {
>> -		list_splice_init(&dl->fragments, &dl->dlm->gc_fragments);
>> -		schedule_work(&dl->dlm->gc_work);
>> -	}
>> +	vsp1_dl_list_fragments_free(dl);
>>
>> -	dl->body0.num_entries = 0;
>> +	/* body0 is reused */
> 
> It would be useful to explain why. Maybe something like "body0 is reused as an 
> optimization as every display list needs at least one body." ? And now I'm 
> wondering it it's really a useful optimization :-)

Yes, currently each list has at least one body, == body0 - but I can foresee
that being 'optimised' out soon.


>> +	dl->body0->num_entries = 0;
>>
>>  	list_add_tail(&dl->list, &dl->dlm->free);
>>  }
> 
> [snip]
> 
>> @@ -898,13 +764,26 @@ struct vsp1_dl_manager *vsp1_dlm_create(struct
>> vsp1_device *vsp1,
>>
>>  	spin_lock_init(&dlm->lock);
>>  	INIT_LIST_HEAD(&dlm->free);
>> -	INIT_LIST_HEAD(&dlm->gc_fragments);
>> -	INIT_WORK(&dlm->gc_work, vsp1_dlm_garbage_collect);
>> +
>> +	/*
>> +	 * Initialize the display list body and allocate DMA memory for the 
> body
>> +	 * and the optional header. Both are allocated together to avoid 
> memory
>> +	 * fragmentation, with the header located right after the body in
>> +	 * memory.
>> +	 */
> 
> Nice to see you're keeping this comment, but maybe you want to update it 
> according to the code changes ;-)

Ahh yes, - of course this needs adjusting so that we only allocate a single
header per display list as well - I'll catch that in the next version.

I'm using this current rebase to clean up comments and rebase to mainline.


> 
>> +	header_size = dlm->mode == VSP1_DL_MODE_HEADER
>> +		    ? ALIGN(sizeof(struct vsp1_dl_header), 8)
>> +		    : 0;
>> +
>> +	dlm->pool = vsp1_dl_fragment_pool_alloc(vsp1, prealloc,
>> +					VSP1_DL_NUM_ENTRIES, header_size);
>> +	if (!dlm->pool)
>> +		return NULL;
>>
>>  	for (i = 0; i < prealloc; ++i) {
>>  		struct vsp1_dl_list *dl;
>>
>> -		dl = vsp1_dl_list_alloc(dlm);
>> +		dl = vsp1_dl_list_alloc(dlm, dlm->pool);
>>  		if (!dl)
>>  			return NULL;
>>
> 
> [snip]
> 
