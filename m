Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:58045 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934974AbdGTOCP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 10:02:15 -0400
Message-ID: <1500559330.26680.10.camel@pengutronix.de>
Subject: Re: [Linaro-mm-sig] [PATCH] dma-fence: Don't BUG_ON when not
 absolutely needed
From: Lucas Stach <l.stach@pengutronix.de>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: DRI Development <dri-devel@lists.freedesktop.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        linaro-mm-sig@lists.linaro.org,
        Daniel Vetter <daniel.vetter@intel.com>,
        linux-media@vger.kernel.org
Date: Thu, 20 Jul 2017 16:02:10 +0200
In-Reply-To: <20170720125107.26693-1-daniel.vetter@ffwll.ch>
References: <20170720125107.26693-1-daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Donnerstag, den 20.07.2017, 14:51 +0200 schrieb Daniel Vetter:
> It makes debugging a massive pain.

It is also considered very bad style to BUG the kernel on anything other
than filesystem eating catastrophic failures.

Reviewed-by: Lucas Stach <l.stach@pengutronix.de>

> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> Cc: Sumit Semwal <sumit.semwal@linaro.org>
> Cc: Gustavo Padovan <gustavo@padovan.org>
> Cc: linux-media@vger.kernel.org
> Cc: linaro-mm-sig@lists.linaro.org
> ---
>  drivers/dma-buf/dma-fence.c | 4 ++--
>  include/linux/dma-fence.h   | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/dma-buf/dma-fence.c b/drivers/dma-buf/dma-fence.c
> index 56e0a0e1b600..9a302799040e 100644
> --- a/drivers/dma-buf/dma-fence.c
> +++ b/drivers/dma-buf/dma-fence.c
> @@ -48,7 +48,7 @@ static atomic64_t dma_fence_context_counter = ATOMIC64_INIT(0);
>   */
>  u64 dma_fence_context_alloc(unsigned num)
>  {
> -	BUG_ON(!num);
> +	WARN_ON(!num);
>  	return atomic64_add_return(num, &dma_fence_context_counter) - num;
>  }
>  EXPORT_SYMBOL(dma_fence_context_alloc);
> @@ -172,7 +172,7 @@ void dma_fence_release(struct kref *kref)
>  
>  	trace_dma_fence_destroy(fence);
>  
> -	BUG_ON(!list_empty(&fence->cb_list));
> +	WARN_ON(!list_empty(&fence->cb_list));
>  
>  	if (fence->ops->release)
>  		fence->ops->release(fence);
> diff --git a/include/linux/dma-fence.h b/include/linux/dma-fence.h
> index 9342cf0dada4..171895072435 100644
> --- a/include/linux/dma-fence.h
> +++ b/include/linux/dma-fence.h
> @@ -431,8 +431,8 @@ int dma_fence_get_status(struct dma_fence *fence);
>  static inline void dma_fence_set_error(struct dma_fence *fence,
>  				       int error)
>  {
> -	BUG_ON(test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags));
> -	BUG_ON(error >= 0 || error < -MAX_ERRNO);
> +	WARN_ON(test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags));
> +	WARN_ON(error >= 0 || error < -MAX_ERRNO);
>  
>  	fence->error = error;
>  }
