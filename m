Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx009.vodafonemail.xion.oxcs.net ([153.92.174.39]:11628 "EHLO
        mx009.vodafonemail.xion.oxcs.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753780AbdIDPud (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Sep 2017 11:50:33 -0400
Subject: Re: [PATCH] dma-fence: fix dma_fence_get_rcu_safe
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <deathsimple@vodafone.de>
To: amd-gfx@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>
References: <1504530994-2464-1-git-send-email-deathsimple@vodafone.de>
Message-ID: <1e4e8c81-5ad3-4042-0a77-4f8ee1b8f403@vodafone.de>
Date: Mon, 4 Sep 2017 17:50:08 +0200
MIME-Version: 1.0
In-Reply-To: <1504530994-2464-1-git-send-email-deathsimple@vodafone.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I really wonder what's wrong with my mail client, but it looks like this 
patch never made it at least to dri-devel.

Forwarding manually now,
Christian.

Am 04.09.2017 um 15:16 schrieb Christian König:
> From: Christian König <christian.koenig@amd.com>
>
> The logic is buggy and unnecessary complex. When dma_fence_get_rcu() fails to
> acquire a reference it doesn't necessary mean that there is no fence at all.
>
> It usually mean that the fence was replaced by a new one and in this situation
> we certainly want to have the new one as result and *NOT* NULL.
>
> Signed-off-by: Christian König <christian.koenig@amd.com>
> Cc: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Sumit Semwal <sumit.semwal@linaro.org>
> Cc: linux-media@vger.kernel.org
> Cc: dri-devel@lists.freedesktop.org
> Cc: linaro-mm-sig@lists.linaro.org
> ---
>   include/linux/dma-fence.h | 23 ++---------------------
>   1 file changed, 2 insertions(+), 21 deletions(-)
>
> diff --git a/include/linux/dma-fence.h b/include/linux/dma-fence.h
> index a5195a7..37f3d67 100644
> --- a/include/linux/dma-fence.h
> +++ b/include/linux/dma-fence.h
> @@ -246,27 +246,8 @@ dma_fence_get_rcu_safe(struct dma_fence * __rcu *fencep)
>   		struct dma_fence *fence;
>   
>   		fence = rcu_dereference(*fencep);
> -		if (!fence || !dma_fence_get_rcu(fence))
> -			return NULL;
> -
> -		/* The atomic_inc_not_zero() inside dma_fence_get_rcu()
> -		 * provides a full memory barrier upon success (such as now).
> -		 * This is paired with the write barrier from assigning
> -		 * to the __rcu protected fence pointer so that if that
> -		 * pointer still matches the current fence, we know we
> -		 * have successfully acquire a reference to it. If it no
> -		 * longer matches, we are holding a reference to some other
> -		 * reallocated pointer. This is possible if the allocator
> -		 * is using a freelist like SLAB_TYPESAFE_BY_RCU where the
> -		 * fence remains valid for the RCU grace period, but it
> -		 * may be reallocated. When using such allocators, we are
> -		 * responsible for ensuring the reference we get is to
> -		 * the right fence, as below.
> -		 */
> -		if (fence == rcu_access_pointer(*fencep))
> -			return rcu_pointer_handoff(fence);
> -
> -		dma_fence_put(fence);
> +		if (!fence || dma_fence_get_rcu(fence))
> +			return fence;
>   	} while (1);
>   }
>   
