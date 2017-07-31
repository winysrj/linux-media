Return-path: <linux-media-owner@vger.kernel.org>
Received: from vsmx011.vodafonemail.xion.oxcs.net ([153.92.174.89]:25783 "EHLO
        vsmx011.vodafonemail.xion.oxcs.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752295AbdGaONY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 31 Jul 2017 10:13:24 -0400
Subject: Re: [PATCH] dma-buf: fix reservation_object_wait_timeout_rcu to wait
 correctly v2
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <deathsimple@vodafone.de>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org,
        "Zhou, David(ChunMing)" <David1.Zhou@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
References: <1500989710-12982-1-git-send-email-deathsimple@vodafone.de>
Message-ID: <abc22720-7c84-05a7-a71f-f04453bd4df4@vodafone.de>
Date: Mon, 31 Jul 2017 16:13:09 +0200
MIME-Version: 1.0
In-Reply-To: <1500989710-12982-1-git-send-email-deathsimple@vodafone.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ping, what do you guys think of that?

Am 25.07.2017 um 15:35 schrieb Christian König:
> From: Christian König <christian.koenig@amd.com>
>
> With hardware resets in mind it is possible that all shared fences are
> signaled, but the exlusive isn't. Fix waiting for everything in this situation.
>
> v2: make sure we always wait for the exclusive fence
>
> Signed-off-by: Christian König <christian.koenig@amd.com>
> ---
>   drivers/dma-buf/reservation.c | 33 +++++++++++++++------------------
>   1 file changed, 15 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/dma-buf/reservation.c b/drivers/dma-buf/reservation.c
> index 393817e..9d4316d 100644
> --- a/drivers/dma-buf/reservation.c
> +++ b/drivers/dma-buf/reservation.c
> @@ -373,12 +373,25 @@ long reservation_object_wait_timeout_rcu(struct reservation_object *obj,
>   	long ret = timeout ? timeout : 1;
>   
>   retry:
> -	fence = NULL;
>   	shared_count = 0;
>   	seq = read_seqcount_begin(&obj->seq);
>   	rcu_read_lock();
>   
> -	if (wait_all) {
> +	fence = rcu_dereference(obj->fence_excl);
> +	if (fence && !test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags)) {
> +		if (!dma_fence_get_rcu(fence))
> +			goto unlock_retry;
> +
> +		if (dma_fence_is_signaled(fence)) {
> +			dma_fence_put(fence);
> +			fence = NULL;
> +		}
> +
> +	} else {
> +		fence = NULL;
> +	}
> +
> +	if (!fence && wait_all) {
>   		struct reservation_object_list *fobj =
>   						rcu_dereference(obj->fence);
>   
> @@ -405,22 +418,6 @@ long reservation_object_wait_timeout_rcu(struct reservation_object *obj,
>   		}
>   	}
>   
> -	if (!shared_count) {
> -		struct dma_fence *fence_excl = rcu_dereference(obj->fence_excl);
> -
> -		if (fence_excl &&
> -		    !test_bit(DMA_FENCE_FLAG_SIGNALED_BIT,
> -			      &fence_excl->flags)) {
> -			if (!dma_fence_get_rcu(fence_excl))
> -				goto unlock_retry;
> -
> -			if (dma_fence_is_signaled(fence_excl))
> -				dma_fence_put(fence_excl);
> -			else
> -				fence = fence_excl;
> -		}
> -	}
> -
>   	rcu_read_unlock();
>   	if (fence) {
>   		if (read_seqcount_retry(&obj->seq, seq)) {
