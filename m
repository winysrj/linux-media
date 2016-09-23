Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:35283 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030211AbcIWNnj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Sep 2016 09:43:39 -0400
Received: by mail-lf0-f66.google.com with SMTP id s64so5736534lfs.2
        for <linux-media@vger.kernel.org>; Fri, 23 Sep 2016 06:43:38 -0700 (PDT)
Date: Fri, 23 Sep 2016 15:43:34 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org
Subject: Re: [PATCH 09/11] dma-buf: Restart
 reservation_object_test_signaled_rcu() after writes
Message-ID: <20160923134334.GK3988@dvetter-linux.ger.corp.intel.com>
References: <20160829070834.22296-1-chris@chris-wilson.co.uk>
 <20160829070834.22296-9-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20160829070834.22296-9-chris@chris-wilson.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 29, 2016 at 08:08:32AM +0100, Chris Wilson wrote:
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

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>

> ---
>  drivers/dma-buf/reservation.c | 30 ++++++++++--------------------
>  1 file changed, 10 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/dma-buf/reservation.c b/drivers/dma-buf/reservation.c
> index 3369e4668e96..e74493e7332b 100644
> --- a/drivers/dma-buf/reservation.c
> +++ b/drivers/dma-buf/reservation.c
> @@ -474,12 +474,13 @@ bool reservation_object_test_signaled_rcu(struct reservation_object *obj,
>  					  bool test_all)
>  {
>  	unsigned seq, shared_count;
> -	int ret = true;
> +	int ret;
>  
> +	rcu_read_lock();
>  retry:
> +	ret = true;
>  	shared_count = 0;
>  	seq = read_seqcount_begin(&obj->seq);
> -	rcu_read_lock();
>  
>  	if (test_all) {
>  		unsigned i;
> @@ -490,46 +491,35 @@ retry:
>  		if (fobj)
>  			shared_count = fobj->shared_count;
>  
> -		if (read_seqcount_retry(&obj->seq, seq))
> -			goto unlock_retry;
> -
>  		for (i = 0; i < shared_count; ++i) {
>  			struct fence *fence = rcu_dereference(fobj->shared[i]);
>  
>  			ret = reservation_object_test_signaled_single(fence);
>  			if (ret < 0)
> -				goto unlock_retry;
> +				goto retry;
>  			else if (!ret)
>  				break;
>  		}
>  
> -		/*
> -		 * There could be a read_seqcount_retry here, but nothing cares
> -		 * about whether it's the old or newer fence pointers that are
> -		 * signaled. That race could still have happened after checking
> -		 * read_seqcount_retry. If you care, use ww_mutex_lock.
> -		 */
> +		if (read_seqcount_retry(&obj->seq, seq))
> +			goto retry;
>  	}
>  
>  	if (!shared_count) {
>  		struct fence *fence_excl = rcu_dereference(obj->fence_excl);
>  
> -		if (read_seqcount_retry(&obj->seq, seq))
> -			goto unlock_retry;
> -
>  		if (fence_excl) {
>  			ret = reservation_object_test_signaled_single(
>  								fence_excl);
>  			if (ret < 0)
> -				goto unlock_retry;
> +				goto retry;
> +
> +			if (read_seqcount_retry(&obj->seq, seq))
> +				goto retry;
>  		}
>  	}
>  
>  	rcu_read_unlock();
>  	return ret;
> -
> -unlock_retry:
> -	rcu_read_unlock();
> -	goto retry;
>  }
>  EXPORT_SYMBOL_GPL(reservation_object_test_signaled_rcu);
> -- 
> 2.9.3
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
