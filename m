Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:50616 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932971AbeGDIbu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Jul 2018 04:31:50 -0400
Reply-To: christian.koenig@amd.com
Subject: Re: [PATCH] dma-buf: Move BUG_ON from _add_shared_fence to
 _add_shared_inplace
To: =?UTF-8?Q?Michel_D=c3=a4nzer?= <michel@daenzer.net>,
        Sumit Semwal <sumit.semwal@linaro.org>
Cc: linaro-mm-sig@lists.linaro.org, amd-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org
References: <20180626143147.14296-1-michel@daenzer.net>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>
Message-ID: <249b84ea-affe-2e27-abdd-81d61da9cce6@gmail.com>
Date: Wed, 4 Jul 2018 10:31:47 +0200
MIME-Version: 1.0
In-Reply-To: <20180626143147.14296-1-michel@daenzer.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 26.06.2018 um 16:31 schrieb Michel Dänzer:
> From: Michel Dänzer <michel.daenzer@amd.com>
>
> Fixes the BUG_ON spuriously triggering under the following
> circumstances:
>
> * ttm_eu_reserve_buffers processes a list containing multiple BOs using
>    the same reservation object, so it calls
>    reservation_object_reserve_shared with that reservation object once
>    for each such BO.
> * In reservation_object_reserve_shared, old->shared_count ==
>    old->shared_max - 1, so obj->staged is freed in preparation of an
>    in-place update.
> * ttm_eu_fence_buffer_objects calls reservation_object_add_shared_fence
>    once for each of the BOs above, always with the same fence.
> * The first call adds the fence in the remaining free slot, after which
>    old->shared_count == old->shared_max.

Well, the explanation here is not correct. For multiple BOs using the 
same reservation object we won't call 
reservation_object_add_shared_fence() multiple times because we move 
those to the duplicates list in ttm_eu_reserve_buffers().

But this bug can still happen because we call 
reservation_object_add_shared_fence() manually with fences for the same 
context in a couple of places.

One prominent case which comes to my mind are for the VM BOs during 
updates. Another possibility are VRAM BOs which need to be cleared.

>
> In the next call to reservation_object_add_shared_fence, the BUG_ON
> triggers. However, nothing bad would happen in
> reservation_object_add_shared_inplace, since the fence is already in the
> reservation object.
>
> Prevent this by moving the BUG_ON to where an overflow would actually
> happen (e.g. if a buggy caller didn't call
> reservation_object_reserve_shared before).
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Michel Dänzer <michel.daenzer@amd.com>

Reviewed-by: Christian König <christian.koenig@amd.com>.

Regards,
Christian.

> ---
>   drivers/dma-buf/reservation.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/dma-buf/reservation.c b/drivers/dma-buf/reservation.c
> index 314eb1071cce..532545b9488e 100644
> --- a/drivers/dma-buf/reservation.c
> +++ b/drivers/dma-buf/reservation.c
> @@ -141,6 +141,7 @@ reservation_object_add_shared_inplace(struct reservation_object *obj,
>   	if (signaled) {
>   		RCU_INIT_POINTER(fobj->shared[signaled_idx], fence);
>   	} else {
> +		BUG_ON(fobj->shared_count >= fobj->shared_max);
>   		RCU_INIT_POINTER(fobj->shared[fobj->shared_count], fence);
>   		fobj->shared_count++;
>   	}
> @@ -230,10 +231,9 @@ void reservation_object_add_shared_fence(struct reservation_object *obj,
>   	old = reservation_object_get_list(obj);
>   	obj->staged = NULL;
>   
> -	if (!fobj) {
> -		BUG_ON(old->shared_count >= old->shared_max);
> +	if (!fobj)
>   		reservation_object_add_shared_inplace(obj, old, fence);
> -	} else
> +	else
>   		reservation_object_add_shared_replace(obj, old, fobj, fence);
>   }
>   EXPORT_SYMBOL(reservation_object_add_shared_fence);
