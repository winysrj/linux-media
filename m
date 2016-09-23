Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:35466 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755454AbcIWNDj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Sep 2016 09:03:39 -0400
Received: by mail-lf0-f66.google.com with SMTP id s64so5672704lfs.2
        for <linux-media@vger.kernel.org>; Fri, 23 Sep 2016 06:03:38 -0700 (PDT)
Date: Fri, 23 Sep 2016 15:03:35 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org
Subject: Re: [PATCH 07/11] dma-buf: Restart
 reservation_object_get_fences_rcu() after writes
Message-ID: <20160923130335.GH3988@dvetter-linux.ger.corp.intel.com>
References: <20160829070834.22296-1-chris@chris-wilson.co.uk>
 <20160829070834.22296-7-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20160829070834.22296-7-chris@chris-wilson.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 29, 2016 at 08:08:30AM +0100, Chris Wilson wrote:
> In order to be completely generic, we have to double check the read
> seqlock after acquiring a reference to the fence. If the driver is
> allocating fences from a SLAB_DESTROY_BY_RCU, or similar freelist, then
> within an RCU grace period a fence may be freed and reallocated. The RCU
> read side critical section does not prevent this reallocation, instead
> we have to inspect the reservation's seqlock to double check if the
> fences have been reassigned as we were acquiring our reference.
> 
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Cc: Christian König <christian.koenig@amd.com>
> Cc: Alex Deucher <alexander.deucher@amd.com>
> Cc: Sumit Semwal <sumit.semwal@linaro.org>
> Cc: linux-media@vger.kernel.org
> Cc: dri-devel@lists.freedesktop.org
> Cc: linaro-mm-sig@lists.linaro.org
> ---
>  drivers/dma-buf/reservation.c | 71 +++++++++++++++++++------------------------
>  1 file changed, 31 insertions(+), 40 deletions(-)
> 
> diff --git a/drivers/dma-buf/reservation.c b/drivers/dma-buf/reservation.c
> index 723d8af988e5..10fd441dd4ed 100644
> --- a/drivers/dma-buf/reservation.c
> +++ b/drivers/dma-buf/reservation.c
> @@ -280,18 +280,24 @@ int reservation_object_get_fences_rcu(struct reservation_object *obj,
>  				      unsigned *pshared_count,
>  				      struct fence ***pshared)
>  {
> -	unsigned shared_count = 0;
> -	unsigned retry = 1;
> -	struct fence **shared = NULL, *fence_excl = NULL;
> -	int ret = 0;
> +	struct fence **shared = NULL;
> +	struct fence *fence_excl;
> +	unsigned shared_count;
> +	int ret = 1;

Personally I'd go with ret = -EBUSY here, but that's a bikeshed.

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>  
> -	while (retry) {
> +	do {
>  		struct reservation_object_list *fobj;
>  		unsigned seq;
> +		unsigned i;
>  
> -		seq = read_seqcount_begin(&obj->seq);
> +		shared_count = i = 0;
>  
>  		rcu_read_lock();
> +		seq = read_seqcount_begin(&obj->seq);
> +
> +		fence_excl = rcu_dereference(obj->fence_excl);
> +		if (fence_excl && !fence_get_rcu(fence_excl))
> +			goto unlock;
>  
>  		fobj = rcu_dereference(obj->fence);
>  		if (fobj) {
> @@ -309,52 +315,37 @@ int reservation_object_get_fences_rcu(struct reservation_object *obj,
>  				}
>  
>  				ret = -ENOMEM;
> -				shared_count = 0;
>  				break;
>  			}
>  			shared = nshared;
> -			memcpy(shared, fobj->shared, sz);
>  			shared_count = fobj->shared_count;
> -		} else
> -			shared_count = 0;
> -		fence_excl = rcu_dereference(obj->fence_excl);
> -
> -		retry = read_seqcount_retry(&obj->seq, seq);
> -		if (retry)
> -			goto unlock;
> -
> -		if (!fence_excl || fence_get_rcu(fence_excl)) {
> -			unsigned i;
>  
>  			for (i = 0; i < shared_count; ++i) {
> -				if (fence_get_rcu(shared[i]))
> -					continue;
> -
> -				/* uh oh, refcount failed, abort and retry */
> -				while (i--)
> -					fence_put(shared[i]);
> -
> -				if (fence_excl) {
> -					fence_put(fence_excl);
> -					fence_excl = NULL;
> -				}
> -
> -				retry = 1;
> -				break;
> +				shared[i] = rcu_dereference(fobj->shared[i]);
> +				if (!fence_get_rcu(shared[i]))
> +					break;
>  			}
> -		} else
> -			retry = 1;
> +		}
> +
> +		if (i != shared_count || read_seqcount_retry(&obj->seq, seq)) {
> +			while (i--)
> +				fence_put(shared[i]);
> +			fence_put(fence_excl);
> +			goto unlock;
> +		}
>  
> +		ret = 0;
>  unlock:
>  		rcu_read_unlock();
> -	}
> -	*pshared_count = shared_count;
> -	if (shared_count)
> -		*pshared = shared;
> -	else {
> -		*pshared = NULL;
> +	} while (ret);
> +
> +	if (!shared_count) {
>  		kfree(shared);
> +		shared = NULL;
>  	}
> +
> +	*pshared_count = shared_count;
> +	*pshared = shared;
>  	*pfence_excl = fence_excl;
>  
>  	return ret;
> -- 
> 2.9.3
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
