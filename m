Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.fireflyinternet.com ([109.228.58.192]:62634 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752057AbeF0Luz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Jun 2018 07:50:55 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: =?utf-8?q?Michel_D=C3=A4nzer?= <michel@daenzer.net>,
        "Sumit Semwal" <sumit.semwal@linaro.org>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <20180626143147.14296-1-michel@daenzer.net>
Cc: linaro-mm-sig@lists.linaro.org, amd-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org,
        =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
References: <20180626143147.14296-1-michel@daenzer.net>
Message-ID: <153010024207.8693.14587899562244751472@mail.alporthouse.com>
Subject: Re: [PATCH] dma-buf: Move BUG_ON from _add_shared_fence to
 _add_shared_inplace
Date: Wed, 27 Jun 2018 12:50:42 +0100
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Quoting Michel Dänzer (2018-06-26 15:31:47)
> From: Michel Dänzer <michel.daenzer@amd.com>
> 
> Fixes the BUG_ON spuriously triggering under the following
> circumstances:
> 
> * ttm_eu_reserve_buffers processes a list containing multiple BOs using
>   the same reservation object, so it calls
>   reservation_object_reserve_shared with that reservation object once
>   for each such BO.
> * In reservation_object_reserve_shared, old->shared_count ==
>   old->shared_max - 1, so obj->staged is freed in preparation of an
>   in-place update.
> * ttm_eu_fence_buffer_objects calls reservation_object_add_shared_fence
>   once for each of the BOs above, always with the same fence.
> * The first call adds the fence in the remaining free slot, after which
>   old->shared_count == old->shared_max.
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

I've convinced myself (or rather have not found a valid argument
against) that being able to call reserve_shared + add_shared multiple
times for the same fence is an intended part of reservation_object API 

I'd double check with Christian though.

Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>

>  drivers/dma-buf/reservation.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/dma-buf/reservation.c b/drivers/dma-buf/reservation.c
> index 314eb1071cce..532545b9488e 100644
> --- a/drivers/dma-buf/reservation.c
> +++ b/drivers/dma-buf/reservation.c
> @@ -141,6 +141,7 @@ reservation_object_add_shared_inplace(struct reservation_object *obj,
>         if (signaled) {
>                 RCU_INIT_POINTER(fobj->shared[signaled_idx], fence);
>         } else {
> +               BUG_ON(fobj->shared_count >= fobj->shared_max);

Personally I would just let kasan detect this and throw away the BUG_ON
or at least move it behind some DMABUF_BUG_ON().
-Chris
