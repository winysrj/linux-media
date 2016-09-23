Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:35525 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1034477AbcIWNta (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Sep 2016 09:49:30 -0400
Received: by mail-lf0-f65.google.com with SMTP id s64so5744831lfs.2
        for <linux-media@vger.kernel.org>; Fri, 23 Sep 2016 06:49:30 -0700 (PDT)
Date: Fri, 23 Sep 2016 15:49:26 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        intel-gfx@lists.freedesktop.org, linux-media@vger.kernel.org
Subject: Re: [Linaro-mm-sig] [PATCH 10/11] dma-buf: Use seqlock to close RCU
 race in test_signaled_single
Message-ID: <20160923134926.GL3988@dvetter-linux.ger.corp.intel.com>
References: <20160829070834.22296-1-chris@chris-wilson.co.uk>
 <20160829070834.22296-10-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160829070834.22296-10-chris@chris-wilson.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 29, 2016 at 08:08:33AM +0100, Chris Wilson wrote:
> With the seqlock now extended to cover the lookup of the fence and its
> testing, we can perform that testing solely under the seqlock guard and
> avoid the effective locking and serialisation of acquiring a reference to
> the request.  As the fence is RCU protected we know it cannot disappear
> as we test it, the same guarantee that made it safe to acquire the
> reference previously.  The seqlock tests whether the fence was replaced
> as we are testing it telling us whether or not we can trust the result
> (if not, we just repeat the test until stable).
> 
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Sumit Semwal <sumit.semwal@linaro.org>
> Cc: linux-media@vger.kernel.org
> Cc: dri-devel@lists.freedesktop.org
> Cc: linaro-mm-sig@lists.linaro.org

Not entirely sure this is safe for non-i915 drivers. We might now call
->signalled on a zombie fence (i.e. refcount == 0, but not yet kfreed).
i915 can do that, but other drivers might go boom.

I think in generic code we can't do these kind of tricks unfortunately.
-Daniel

> ---
>  drivers/dma-buf/reservation.c | 32 ++++----------------------------
>  1 file changed, 4 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/dma-buf/reservation.c b/drivers/dma-buf/reservation.c
> index e74493e7332b..1ddffa5adb5a 100644
> --- a/drivers/dma-buf/reservation.c
> +++ b/drivers/dma-buf/reservation.c
> @@ -442,24 +442,6 @@ unlock_retry:
>  }
>  EXPORT_SYMBOL_GPL(reservation_object_wait_timeout_rcu);
>  
> -
> -static inline int
> -reservation_object_test_signaled_single(struct fence *passed_fence)
> -{
> -	struct fence *fence, *lfence = passed_fence;
> -	int ret = 1;
> -
> -	if (!test_bit(FENCE_FLAG_SIGNALED_BIT, &lfence->flags)) {
> -		fence = fence_get_rcu(lfence);
> -		if (!fence)
> -			return -1;
> -
> -		ret = !!fence_is_signaled(fence);
> -		fence_put(fence);
> -	}
> -	return ret;
> -}
> -
>  /**
>   * reservation_object_test_signaled_rcu - Test if a reservation object's
>   * fences have been signaled.
> @@ -474,7 +456,7 @@ bool reservation_object_test_signaled_rcu(struct reservation_object *obj,
>  					  bool test_all)
>  {
>  	unsigned seq, shared_count;
> -	int ret;
> +	bool ret;
>  
>  	rcu_read_lock();
>  retry:
> @@ -494,10 +476,8 @@ retry:
>  		for (i = 0; i < shared_count; ++i) {
>  			struct fence *fence = rcu_dereference(fobj->shared[i]);
>  
> -			ret = reservation_object_test_signaled_single(fence);
> -			if (ret < 0)
> -				goto retry;
> -			else if (!ret)
> +			ret = fence_is_signaled(fence);
> +			if (!ret)
>  				break;
>  		}
>  
> @@ -509,11 +489,7 @@ retry:
>  		struct fence *fence_excl = rcu_dereference(obj->fence_excl);
>  
>  		if (fence_excl) {
> -			ret = reservation_object_test_signaled_single(
> -								fence_excl);
> -			if (ret < 0)
> -				goto retry;
> -
> +			ret = fence_is_signaled(fence_excl);
>  			if (read_seqcount_retry(&obj->seq, seq))
>  				goto retry;
>  		}
> -- 
> 2.9.3
> 
> _______________________________________________
> Linaro-mm-sig mailing list
> Linaro-mm-sig@lists.linaro.org
> https://lists.linaro.org/mailman/listinfo/linaro-mm-sig

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
