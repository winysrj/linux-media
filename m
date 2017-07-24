Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34531 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750864AbdGXIeD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Jul 2017 04:34:03 -0400
Received: by mail-wm0-f66.google.com with SMTP id 79so4193451wmg.1
        for <linux-media@vger.kernel.org>; Mon, 24 Jul 2017 01:34:03 -0700 (PDT)
Date: Mon, 24 Jul 2017 10:33:59 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Christian =?iso-8859-1?Q?K=F6nig?= <deathsimple@vodafone.de>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org
Subject: Re: [PATCH] dma-buf: fix reservation_object_wait_timeout_rcu to wait
 correctly
Message-ID: <20170724083359.j6wo5icln3faajn6@phenom.ffwll.local>
References: <1500654001-20899-1-git-send-email-deathsimple@vodafone.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1500654001-20899-1-git-send-email-deathsimple@vodafone.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 21, 2017 at 06:20:01PM +0200, Christian König wrote:
> From: Christian König <christian.koenig@amd.com>
> 
> With hardware resets in mind it is possible that all shared fences are
> signaled, but the exlusive isn't. Fix waiting for everything in this situation.

How did you end up with both shared and exclusive fences on the same
reservation object? At least I thought the point of exclusive was that
it's exclusive (and has an implicit barrier on all previous shared
fences). Same for shared fences, they need to wait for the exclusive one
(and replace it).

Is this fallout from the amdgpu trickery where by default you do all
shared fences? I thought we've aligned semantics a while back ...
-Daniel

> 
> Signed-off-by: Christian König <christian.koenig@amd.com>
> ---
>  drivers/dma-buf/reservation.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/dma-buf/reservation.c b/drivers/dma-buf/reservation.c
> index e2eff86..ce3f9c1 100644
> --- a/drivers/dma-buf/reservation.c
> +++ b/drivers/dma-buf/reservation.c
> @@ -461,7 +461,7 @@ long reservation_object_wait_timeout_rcu(struct reservation_object *obj,
>  		}
>  	}
>  
> -	if (!shared_count) {
> +	if (!fence) {
>  		struct dma_fence *fence_excl = rcu_dereference(obj->fence_excl);
>  
>  		if (fence_excl &&
> -- 
> 2.7.4
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
