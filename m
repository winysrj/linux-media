Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:43159 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751550AbdIUH2o (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Sep 2017 03:28:44 -0400
Subject: Re: [PATCH] dma-fence: fix dma_fence_get_rcu_safe v2
To: =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>,
        chris@chris-wilson.co.uk, daniel.vetter@ffwll.ch,
        sumit.semwal@linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org
References: <1505469187-3565-1-git-send-email-deathsimple@vodafone.de>
From: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Message-ID: <0297e4f4-e3fa-8a50-09c2-acfeedc7d834@linux.intel.com>
Date: Thu, 21 Sep 2017 09:28:41 +0200
MIME-Version: 1.0
In-Reply-To: <1505469187-3565-1-git-send-email-deathsimple@vodafone.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Op 15-09-17 om 11:53 schreef Christian König:
> From: Christian König <christian.koenig@amd.com>
>
> When dma_fence_get_rcu() fails to acquire a reference it doesn't necessary
> mean that there is no fence at all.
>
> It usually mean that the fence was replaced by a new one and in this situation
> we certainly want to have the new one as result and *NOT* NULL.
>
> v2: Keep extra check after dma_fence_get_rcu().
>
> Signed-off-by: Christian König <christian.koenig@amd.com>
> Cc: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Sumit Semwal <sumit.semwal@linaro.org>
> Cc: linux-media@vger.kernel.org
> Cc: dri-devel@lists.freedesktop.org
> Cc: linaro-mm-sig@lists.linaro.org
> ---
>  include/linux/dma-fence.h | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/dma-fence.h b/include/linux/dma-fence.h
> index 0a186c4..f4f23cb 100644
> --- a/include/linux/dma-fence.h
> +++ b/include/linux/dma-fence.h
> @@ -248,9 +248,12 @@ dma_fence_get_rcu_safe(struct dma_fence * __rcu *fencep)
>  		struct dma_fence *fence;
>  
>  		fence = rcu_dereference(*fencep);
> -		if (!fence || !dma_fence_get_rcu(fence))
> +		if (!fence)
>  			return NULL;
>  
> +		if (!dma_fence_get_rcu(fence))
> +			continue;
> +
>  		/* The atomic_inc_not_zero() inside dma_fence_get_rcu()
>  		 * provides a full memory barrier upon success (such as now).
>  		 * This is paired with the write barrier from assigning

Should be safe from an infinite loop since the old fence is only unreffed after the new pointer is written, so we'll always make progress. :)

Reviewed-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
